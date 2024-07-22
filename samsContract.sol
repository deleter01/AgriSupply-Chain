// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract samsContract {

    address Admin;
    uint ID;

    constructor(){
        Admin = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == Admin, "Not Admin");
        _;

    }

    struct StudentData{
        string name; // fname, mname, sname
        string email;
        uint phone;
        string laddress; // address ,city ,Nationality
        uint Id;
        uint dbirth;        
        string gender;
        bool status;
    }
    mapping (address => StudentData) public studentdata;
    StudentData[] public Slists;
    address[] _studentState;

    struct AdmissionData{
        uint Id;
        string olevelReg;
        string alevelReg;
        string dipReg;
        bool estatus;
        string collage;
        string course; //course1,course2,course3,course4
        bool adstatus;
        bool status;
        
    }

    mapping (address => AdmissionData) public admissiondata;
    mapping (uint => AdmissionData) public admissionid;
    AdmissionData[] public Alists;
    address[] _admissionState;
    

    function PersonInfo(string calldata _name, uint _phone,string calldata _laddress, string calldata _email,string calldata _gender, address student ) external onlyOwner{
        ID++; 
        StudentData storage _studentdata = studentdata[student];
        require(_studentdata.status == false, "Student exist");
            _studentdata.name = _name;
            _studentdata.phone = _phone;
            _studentdata.laddress = _laddress;
            _studentdata.email = _email;
            _studentdata.gender = _gender;
            _studentdata.Id = ID;
            _studentdata.status = true;
            _studentState.push(student);
    }

    function OEducationInfo(address student, string calldata _olevelreg, uint _id) external onlyOwner{
        AdmissionData storage _admissiondata = admissiondata[student];
        require(_admissiondata.estatus == false, "Olevel Data has been saved");
        _admissiondata.olevelReg = _olevelreg;
        _admissiondata.Id = _id;
        _admissiondata.estatus = true;
        _admissionState.push(student);

    }

    function AEducationInfo(address student, string calldata _alevelreg) external onlyOwner{
        AdmissionData storage _admissiondata = admissiondata[student];
        require(_admissiondata.estatus == true, "Fill Olevel Detail First");
        _admissiondata.alevelReg = _alevelreg;

    }

    function SetAdmStatus(uint id) external onlyOwner{
     
        uint size = _admissionState.length;

        for (uint i = 0; i < size; i++) {
            AdmissionData storage _data = admissiondata[_admissionState[i]];

            if (_data.Id == id) {
                _data.adstatus = true;
                break;
            }
        }

    }

    function getEducationData(address student) public view returns(AdmissionData memory _adata){
        _adata = admissiondata[student];
    }

    function getStudent(address student) public view returns(StudentData memory _data){
        _data = studentdata[student];
    }

    function CourseSelection(address student, string calldata _collage, string calldata _course) external onlyOwner{
        AdmissionData storage _admissiondata = admissiondata[student];
        require(_admissiondata.status == false, "Course Selection Exist");
        _admissiondata.collage = _collage;
        _admissiondata.course = _course;
        _admissiondata.status = true;

    }

    function admissionList() external view returns(AdmissionData[] memory list){
        uint size = _admissionState.length;
        address[] memory  admissionMemory = new address[](size);
        list = new AdmissionData[](size);
        admissionMemory = _admissionState;
        for(uint i =0; i < size; i++){
            AdmissionData storage _data = admissiondata[admissionMemory[i]];
            list[i] = _data;
            list[i] =  admissiondata[admissionMemory[i]]; 
        }
    }

    function admissionStatus() external view returns(AdmissionData[] memory list){
        uint size = _admissionState.length;
        address[] memory  admissionMemory = new address[](size);
        list = new AdmissionData[](size);
        admissionMemory = _admissionState;
        for(uint i =0; i < size; i++){
            AdmissionData storage _data = admissiondata[admissionMemory[i]];
            if(_data.adstatus == false){
                list[i] = _data;
                list[i] =  admissiondata[admissionMemory[i]]; 
            }
            
        }
    }

    function studentsList() external view returns(StudentData[] memory list){
        uint size = _studentState.length;
        address[] memory  studentMemory = new address[](size);
        list = new StudentData[](size);
        studentMemory = _studentState;
        for(uint i =0; i < size; i++){
            StudentData storage _data = studentdata[studentMemory[i]];
            list[i] = _data;
            list[i] =  studentdata[studentMemory[i]]; 
        }
    }


     function studentsDetails() external view returns(StudentData[] memory list){
        uint size = _studentState.length;
        address[] memory  studentMemory = new address[](size);
        list = new StudentData[](size);
        studentMemory = _studentState;
        for(uint i =0; i < size; i++){
            StudentData storage _data = studentdata[studentMemory[i]];
            list[i] = _data;
            list[i] =  studentdata[studentMemory[i]]; 
        }

    }

    // function stdStatus(address student) public view returns(bool){
    //     bool results;
    //     StudentData storage _studentdata = studentdata[student];
    //     if(_studentdata.status == true){
    //         results = true;
    //     }else{
    //         results = false;
    //     }
    //     return results;
    // }

    // function registerStudent(string calldata _name, address student, uint _age, string calldata _gender) external onlyOwner{
    //     ID++;
    //     Data storage _data = data[student];
    //     require(_data.status == false, "Student already exist");
    //     _data.name = _name;
    //     _data.age = _age;
    //     _data.gender = _gender;
    //     _data.Id = ID;
    //     _data.status = true;
    //     _studentState.push(student);

    // }

    // function login(address student) public view returns(bool){
    //     bool results;
    //     Data storage _data = data[student];
    //     if(_data.status == true){
    //         results = true;
    //     }else{
    //         results = false;
    //     }
    //     return results;
    // }


    // function getStudent(address student) public view returns(Data memory _data){
    //     _data = data[student];
    // }


    // function studentsDetails() external view returns(Data[] memory list){
    //     uint size = _studentState.length;
    //     address[] memory  studentMemory = new address[](size);
    //     list = new Data[](size);
    //     studentMemory = _studentState;
    //     for(uint i =0; i < size; i++){
    //         Data storage _data = data[studentMemory[i]];
    //         list[i] = _data;
    //         list[i] =  data[studentMemory[i]]; 
    //     }

    // }


    // function DeleteStudent(address student) external onlyOwner{
    //     Data storage _data = data[student];
    //     require(_data.status == true, "Not student");
    //     _data.name = "";
    //     _data.age = 0;
    //     _data.Id =  0;
    //     _data.gender = "";
    //     _data.status = false;
    //     uint size = _studentState.length;
    //     address[] memory  studentMemory = new address[](size);
    //     studentMemory = _studentState;

    //     for (uint i = 0; i < size; i++){
    //         if(student == studentMemory[i]){
    //             studentMemory[i] = studentMemory[size - 1];
    //             _studentState = studentMemory;
    //             break;

    //         }
    //     }
    //     _studentState.pop();

    // }


    // function changeAdmin(address _newAdmin) external onlyOwner{
    //     Admin = _newAdmin;
    // }

    //  struct Data{
    //     string name;
    //     uint Id;
    //     uint age;        
    //     string gender;
    //     bool status;
    // }

    // mapping (address => Data) public data;
    // Data[] public lists;
    // address[] _studentState;

}