//
//  AddStaff.swift
//  HMS_Main
//
//  Created by Rupaj Sen on 24/04/24.
//
//
//import SwiftUI
//
//struct StaffList: View {
//    @State private var selectedTab = 1
//    @State private var isAddStaffSheetPresented = false
//
//    var body: some View {
//            VStack {
//                Picker(selection: $selectedTab, label: Text("What is your favorite color?")) {
//                    Text("Overview").tag(0)
//                    Text("Staff List").tag(1)
//                    Text("Patient List").tag(2)
//                    Text("Patient Appointments").tag(3)
//                }.pickerStyle(SegmentedPickerStyle())
//
//                SearchBar(text: .constant(""))
//
//                if selectedTab == 1 {
//                    ScrollView {
//                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
//                            ForEach(0..<10) { _ in
//                                StaffCard()
//                            }
//                        }
//                    }
//                } else {
//                    // Display other content for the Overview, Patient List, and Patient Appointments tabs
//                }
//
//
//                if selectedTab == 2 {
//                    ScrollView {
//                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
//                            ForEach(0..<10) { _ in
//                                PatientCard()
//                            }
//                        }
//                    }
//                } else {
//                    // Display other content for the Overview, Patient List, and Patient Appointments tabs
//                }
//
//
//
//                Spacer()
//
//                Button(action: {
//                               // Show the AddStaff sheet when the button is tapped
//                               isAddStaffSheetPresented.toggle()
//                           }) {
//                               Text("Add New Staff")
//                                   .foregroundColor(.white)
//                                   .padding()
//                                   .background(Color.blue)
//                                   .cornerRadius(10)
//                           }
//            }
//            .padding()
//            .navigationTitle("Staff Management")
//            .navigationBarItems(trailing: Image(systemName: "person.crop.circle"))
//            .sheet(isPresented: $isAddStaffSheetPresented) {
//                        // Present the AddStaff sheet when isAddStaffSheetPresented is true
//                        AddStaff()
//                    }
//    }
//}
//
//struct StaffCard: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Circle()
//                    .fill(Color.gray)
//                    .frame(width: 50, height: 50)
//
//                VStack(alignment: .leading) {
//                    Text("Kristan Watson")
//                        .font(.headline)
//                    Text("Employee ID: 27140440")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//            }
//
//            Divider()
//
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Designation: Cardiologists, Head")
//                Text("Department: Cardiology")
//                Text("Contact no.: 9893823937")
//            }
//
//            Spacer()
//
//            Button(action: {}) {
//                Text("View Doctor Details")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.purple)
//                    .cornerRadius(10)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 10)
//    }
//}
//
//
//
//#Preview {
//    StaffList()
//}

import SwiftUI
import Firebase

struct StaffList: View {
    @State private var selectedTab = 0
    @State private var isAddStaffSheetPresented = false
    @State private var doctors: [Doctor1] = []
    @State private var patients: [Patient1] = []
    @State private var appointments: [Appointment1] = []
    @State private var searchText: String = ""
    @State private var searchTextDoctor = ""
    @State private var searchTextPatient = ""
    
    @State private var totalAppointmentsCount = 0

    
    let totalPatientsVisited = 100
        let activeAppointmentsCount = 20
        let closedAppointmentsCount = 30
        let scheduledAppointmentsCount = 50
        
        let doctorsAppointments = [("Dr. John Doe", 5), ("Dr. Jane Smith", 8),("Dr. Varad Kadtan", 14)] // Sample data
        
    var filteredDoctors: [Doctor1] {
           if searchTextDoctor.isEmpty {
               return doctors
           } else {
               return doctors.filter { $0.name.localizedCaseInsensitiveContains(searchTextDoctor) }
           }
       }

       var filteredPatients: [Patient1] {
           if searchTextPatient.isEmpty {
               return patients
           } else {
               return patients.filter { $0.name.localizedCaseInsensitiveContains(searchTextPatient) }
           }
       }


    var body: some View {
        VStack {
            Picker(selection: $selectedTab, label: Text("Select Tab")) {
                Text("Overview").tag(0)
                Text("Staff List").tag(1)
                Text("Patient List").tag(2)
                Text("Patient Appointments").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedTab == 1 {
                VStack {
                    SearchBar(text: $searchTextDoctor, placeholder: "Search Doctors")
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                            ForEach(filteredDoctors.indices, id: \.self) { index in
                                DoctorCard1(doctor: filteredDoctors[index])
                            }
                        }
                    }
                }
            } else if selectedTab == 2 {
                VStack {
                    SearchBar(text: $searchTextPatient, placeholder: "Search Patients")
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                            ForEach(filteredPatients.indices, id: \.self) { index in
                                PatientCard1(patient: filteredPatients[index])
                            }
                        }
                    }
                }
            } else if selectedTab == 3 {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                        ForEach(appointments.indices, id: \.self) { index in
                            AppointmentCard1(appointment: appointments[index])
                        }
                    }
                }
            }
            else {
                ScrollView {
                    VStack(spacing: 20) {
                        OverviewTabView()
                    }
                    .padding()
                }
            }

            
            Spacer()
            
            Button(action: {
                isAddStaffSheetPresented.toggle()
            }) {
                Text("Add New Staff")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Staff Management")
        .navigationBarItems(trailing: Image(systemName: "person.crop.circle"))
        .sheet(isPresented: $isAddStaffSheetPresented) {
            AddStaff()
        }
        .onAppear {
            fetchDoctorsFromFirestore()
            fetchPatientsFromFirestore()
            fetchAppointmentsFromFirestore()
        }
    }
    
    func fetchDoctorsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("doctors").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching doctors: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.doctors = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                return Doctor1(data: data)
            }
        }
    }
    
    func fetchPatientsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("users").whereField("userType", isEqualTo: "Patient").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching patients: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.patients = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                return Patient1(data: data)
            }
        }
    }

//    func fetchAppointmentsFromFirestore() {
//        let db = Firestore.firestore()
//        db.collection("appointments").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error fetching appointments: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//
//            self.appointments = documents.compactMap { queryDocumentSnapshot in
//                let data = queryDocumentSnapshot.data()
//                return Appointment1(data: data)
//            }
//
//        }
//    }
    
    func fetchAppointmentsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("appointments").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching appointments: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            
            
            self.appointments = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                return Appointment1(data: data)
            }
            
            // Print the total appointments count for debugging
            let totalAppointmentsCount = documents.count
            print("Total Appointments Count: \(totalAppointmentsCount)")
            
            // Update the total appointments count using a separate state variable
            DispatchQueue.main.async {
                self.totalAppointmentsCount = totalAppointmentsCount
            }
        }
    }

    struct SearchBar: View {
        @Binding var text: String
        var placeholder: String
        
        var body: some View {
            HStack {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                        .onTapGesture {
                            self.text = "" // Clear the search text
                        }
                }
            }
        }
    }
}

import SwiftUI
import Firebase

struct OverviewTabView: View {
    @State private var totalAppointmentsCount = 0 // Define totalAppointmentsCount as a state variable
    @State private var totalPatientsCount = 0 // Define totalPatientsCount as a state variable
    @State private var totalDoctorsCount = 0 // Define totalDoctorsCount as a state variable

    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    GreetingCard(title: "Hello, Admin", subtitle: "Welcome to your dashboard")
                        .frame(width: 755, height: 150)
                        .padding()

                    HStack {
                        // Total Bookings Card
                        TotalBookingsCard(title: "Total Bookings", value: "\(totalAppointmentsCount)", buttonAction: {}, totalCount: $totalAppointmentsCount)

                        // Total patients Card
                        TotalBookingsCard(title: "Total patients", value: "\(totalPatientsCount)", buttonAction: {}, totalCount: $totalPatientsCount)

                        // Doctors Available Card
                        TotalBookingsCard(title: "Doctors Available", value: "\(totalDoctorsCount)", buttonAction: {}, totalCount: $totalDoctorsCount)
                    }

                    // Summary Statistics

                    HStack {
                        // Patient List
                        PatientListView()

                        // Doctors List
                    }
                }

                VStack {
                    SummaryStatisticsView()
                        .offset(y: -60)

                    DoctorListView()
                        .offset(y: -70)
                }
                .offset(y: 60)
            }
        }
        .onAppear {
            // Fetch appointments, patient, and doctor counts from Firestore
            fetchAppointmentsCountFromFirestore()
            fetchPatientsCountFromFirestore()
            fetchDoctorsCountFromFirestore()
        }
    }

    // Function to fetch appointments count from Firestore
    func fetchAppointmentsCountFromFirestore() {
        let db = Firestore.firestore()
        db.collection("appointments").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching appointments count: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No appointment documents")
                return
            }
            
            // Update totalAppointmentsCount with the count of documents
            self.totalAppointmentsCount = documents.count
        }
    }
    
    // Function to fetch patients count from Firestore
    func fetchPatientsCountFromFirestore() {
        let db = Firestore.firestore()
        db.collection("users").whereField("userType", isEqualTo: "Patient").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching patients count: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No patient documents")
                return
            }
            
            // Update totalPatientsCount with the count of documents
            self.totalPatientsCount = documents.count
        }
    }
    
    // Function to fetch doctors count from Firestore
    func fetchDoctorsCountFromFirestore() {
        let db = Firestore.firestore()
        db.collection("users").whereField("userType", isEqualTo: "Doctor").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching doctors count: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No doctor documents")
                return
            }
            
            // Update totalDoctorsCount with the count of documents
            self.totalDoctorsCount = documents.count
        }
    }
}

struct TotalBookingsCard: View {
    var title: String
    var value: String
    var buttonAction: () -> Void
    
    // Capture totalAppointmentsCount, totalPatientsCount, or totalDoctorsCount as a binding
    @Binding var totalCount: Int
    
    init(title: String, value: String, buttonAction: @escaping () -> Void, totalCount: Binding<Int>) {
        self.title = title
        self.value = value
        self.buttonAction = buttonAction
        _totalCount = totalCount
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(.black)
            
            Button(action: buttonAction) {
                Text("View Details")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding()
        .frame(width:230 ,height: 180)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

struct SummaryStatisticsView: View {
    var body: some View {
        VStack {
            // Summary Card
            VStack(alignment: .leading) {
                Text("Summary")
                    .font(.headline)
                Divider()
                SummaryRow(status: "Pending", count: "35", color: .yellow)
                SummaryRow(status: "Confirmed", count: "70", color: .green)
                SummaryRow(status: "Canceled", count: "10", color: .red)
                SummaryRow(status: "Rescheduled", count: "5", color: .orange)
            }
            .frame(width: 260)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
        }
        .offset(y:-60)
        .padding()
    }
}

struct SummaryRow: View {
    var status: String
    var count: String
    var color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text("\(status): \(count)")
        }
    }
}
import SwiftUI
import SwiftUICharts // Import the SwiftUICharts library

struct PatientListView: View {
    @State private var appointmentsData: [Date: Double] = [:]
    @State private var selectedGraphOption = 0
    let graphOptions = ["Day", "Week", "Year"]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Dropdown menu for selecting the graph option
            Menu {
                ForEach(0..<graphOptions.count) { index in
                    Button(action: {
                        selectedGraphOption = index
                        fetchAppointmentsDataFromFirestore() // Update data when option changes
                    }) {
                        Text(graphOptions[index])
                    }
                }
            } label: {
                Text("Graph Option: \(graphOptions[selectedGraphOption])")
                    .padding()
            }
            
            Text("Appointments")
                .font(.headline)
                .padding(.top)
            
            Divider()
            
            // Display the graph based on selectedGraphOption
            switch selectedGraphOption {
            case 0: // Day
                if !appointmentsData.isEmpty {
                    let data = appointmentsData.sorted { $0.key < $1.key }.map { $0.value }
                    LineChartView(data: data, title: "Appointments", legend: "Appointments")
                        .padding()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity) // Take up full width
                } else {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .padding()
                }
            case 1: // Week
                if !appointmentsData.isEmpty {
                    let data = appointmentsData.sorted { $0.key < $1.key }.map { $0.value }
                    // Create a line chart for week view
                    LineChartView(data: data, title: "Appointments - Weekly", legend: "Appointments")
                        .padding()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity) // Take up full width
                } else {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .padding()
                }

            case 2: // Year
                if !appointmentsData.isEmpty {
                    let data = appointmentsData.sorted { $0.key < $1.key }.map { $0.value }
                    // Create a line chart for year view
                    LineChartView(data: data, title: "Appointments - Yearly", legend: "Appointments")
                        .padding()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity) // Take up full width
                } else {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .padding()
                }

            default:
                EmptyView()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding()
        .onAppear {
            fetchAppointmentsDataFromFirestore()
        }
    }
    
    // Function to fetch appointments data from Firestore
    func fetchAppointmentsDataFromFirestore() {
        let db = Firestore.firestore()
        db.collection("appointments").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching appointments data: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No appointment documents")
                return
            }
            
            // Parse the appointment data and count appointments for each date
            var appointmentsData: [Date: Double] = [:]
            for document in documents {
                if let timestamp = document["date"] as? Timestamp {
                    // Convert Timestamp to Date
                    let date = timestamp.dateValue()
                    // Get the date component without time
                    let calendar = Calendar.current
                    let components: Set<Calendar.Component> = [.year, .month, .day]
                    let normalizedDate = calendar.date(from: calendar.dateComponents(components, from: date))
                    
                    switch selectedGraphOption {
                    case 0: // Day
                        // For day option, count appointments for each date
                        appointmentsData[normalizedDate!, default: 0] += 1
                    case 1: // Week
                        // For week option, group appointments by week
                        let weekOfYear = calendar.component(.weekOfYear, from: normalizedDate!)
                        let year = calendar.component(.year, from: normalizedDate!)
                        let weekDate = calendar.date(from: DateComponents(year: year, weekOfYear: weekOfYear))
                        appointmentsData[weekDate!, default: 0] += 1
                    case 2: // Year
                        // For year option, group appointments by year
                        let year = calendar.component(.year, from: normalizedDate!)
                        let yearDate = calendar.date(from: DateComponents(year: year))
                        appointmentsData[yearDate!, default: 0] += 1
                    default:
                        break
                    }
                }
            }
            
            // Update the appointmentsData state variable
            self.appointmentsData = appointmentsData
        }
    }
}





struct DoctorListView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Doctors")
                    .font(.title2)
                    .foregroundColor(.primary)
                Spacer()
                // Add any action buttons here if needed
            }
            
            Divider()
            
            // Circular Pie Chart Placeholder
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 12)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                Text("80%") // Placeholder text for percentage
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(75)
            
            // Doctor list
            VStack(alignment: .leading, spacing: 8) {
                DoctorListItemm()
                Divider()
                DoctorListItemm()
                Divider()
                DoctorListItemm()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding()
        .frame(width: 320, height: 320)
    }
}


struct DoctorListItemm: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Dr. Smith")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Specialty: Cardiology")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}



// Preview



struct OverviewCard: View {
    var title: String
    var count: Int
    var icon: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(Color.blue)
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
            }
            
            Text("\(count)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            LineGraphView(count: count) // Line graph visualization
            
        }
        .padding(20)
        .frame(width: 500, height:300) // Fixed size for consistency
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct LineGraphView: View {
    var count: Int
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let stepWidth = geometry.size.width / CGFloat(count)
                
                // Move to the starting point
                path.move(to: CGPoint(x: 0, y: geometry.size.height))
                
                // Iterate through each step and add points to the path
                for i in 0..<count {
                    let x = CGFloat(i) * stepWidth
                    let y = CGFloat.random(in: geometry.size.height * 0.2...geometry.size.height * 0.8) // Randomize the y-coordinate
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                // Add a final line to the end of the view
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .padding(20)
    }
}

struct GreetingCard: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .padding(.leading) // Add padding to align with the left edge
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.system(size: 20))
                .padding(.leading) // Add padding to align with the left edge
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 760,height: 150)// Align VStack contents to the left
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}


struct AppointmentCard1: View {
    let appointment: Appointment1
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text("Doctor: \(appointment.doctorId)")
                        .font(.headline)
                    Text("Patient: \(appointment.userId)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Date: \(formattedDate)")
                Text("Time: \(appointment.time)")
                Text("Additional Info: \(appointment.additionalInfo)")
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("View Details")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }

    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy "
        return dateFormatter.string(from: appointment.date)
    }
}

struct Appointment1 {
    let additionalInfo: String
    let date: Date
    let doctorId: String
    let time: String
    let userId: String
    var doctorName: String = ""
    var patientName: String = ""

    init(data: [String: Any]) {
        self.additionalInfo = data["additionalInfo"] as? String ?? ""
        if let timestamp = data["date"] as? Timestamp {
            self.date = timestamp.dateValue()
        } else {
            self.date = Date()
        }
        self.doctorId = data["doctorId"] as? String ?? ""
        self.time = data["time"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
    }
}

struct DoctorCard1: View {
    let doctor: Doctor1
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(doctor.name)
                        .font(.headline)
                    Text("Employee ID: \(doctor.position)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Designation: \(doctor.designation)")
                Text("Department: \(doctor.department)")
                Text("Contact no.: \(doctor.contactNo)")
                Text("Educational Details: \(doctor.educationalDetails)")
                Text("Email: \(doctor.email)")
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("View Details")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct PatientCard1: View {
    let patient: Patient1
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(patient.name)
                        .font(.headline)
                    Text("Patient ID: \(patient.patientID)")
                        .font(.subheadline)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Weight: \(patient.weight)")
                Text("Blood Pressure: \(patient.bloodPressure)")
                Text("Blood Glucose: \(patient.bloodGlucose)")
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("View Details")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}




struct Doctor1 {
    let name: String
    let designation: String
    let department: String
    let contactNo: String
    let educationalDetails: String
    let email: String
    let position: String
    
    init(data: [String: Any]) {
        self.name = data["fullName"] as? String ?? ""
        self.designation = data["designation"] as? String ?? ""
        self.department = data["specialization"] as? String ?? ""
        self.contactNo = data["contactNo"] as? String ?? ""
        self.educationalDetails = data["educationalDetails"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.position = data["position"] as? String ?? ""
    }
}


struct Patient1 {
    let name: String
    let patientID: String
    let weight: String
    let bloodPressure: String
    let bloodGlucose: String
    
    init(data: [String: Any]) {
        self.name = data["fullname"] as? String ?? ""
        self.patientID = data["id"] as? String ?? ""
        self.weight = data["weight"] as? String ?? ""
        self.bloodPressure = data["bloodPressure"] as? String ?? ""
        self.bloodGlucose = data["bloodGlucose"] as? String ?? ""
    }
}


#Preview {
    StaffList()
}
