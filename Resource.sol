// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract ResourseContract {

    address Admin;
    uint ID;

    // constructor(){
    //     Admin = msg.sender;
    // }

    modifier onlyOwner(){
        require(msg.sender == Admin, "Not Admin");
        _;

    }

    struct UserData{
        uint Id;
        string username;
        string firstname;
        string surname;
        string email;
        address useraddr;
        uint role; //1-admin : 2 - emp : 3 - student - 4 : teacher
        uint state; // 1-active : 2-deactive : 3-suspended
        bool status;
    }
    mapping (address => UserData) public userdata;
    UserData[] public Ulist;
    address[] _userState;


    function RegisterUser(string calldata _username, address student, string calldata _surname, string calldata _firstname, string calldata _email, uint _role) public {
        ID++;
        UserData storage _userdata = userdata[student];
        require(_userdata.status == false, "User already exist");
        _userdata.username = _username;
        _userdata.useraddr = student;
        _userdata.surname = _surname;
        _userdata.firstname = _firstname;
        _userdata.email = _email;
        _userdata.Id = ID;
        _userdata.role = _role;
        _userdata.state = 1;
        _userdata.status = true;
        _userState.push(student);

    }

    function login(address student) public view returns(UserData memory _data){
        _data = userdata[student];
    }

    function usersList() external view returns(UserData[] memory list){
        uint size = _userState.length;
        address[] memory  userMemory = new address[](size);
        list = new UserData[](size);
        userMemory = _userState;
        for(uint i =0; i < size; i++){
            UserData storage _data = userdata[userMemory[i]];
            list[i] = _data;
            list[i] =  userdata[userMemory[i]]; 
        }
    }

    struct SelectData{
        uint Id;
        string firstname;
        string middname;
        string surname;
        string collage;
        string course;
        bool status;
    }

    mapping (address => SelectData) public selectdata;
    SelectData[] public Stlists;
    address[] _selectState;

    function RAdmitted(string calldata _firstname, string calldata _surname, string calldata _collage, string calldata _course, address student, uint _id) external onlyOwner{
        ID++;
        SelectData storage _selectdata = selectdata[student];
        require(_selectdata.status == false, "User already exist");
        _selectdata.firstname = _firstname;
        _selectdata.surname = _surname;
        _selectdata.collage = _collage;
        _selectdata.course = _course;
        _selectdata.Id = _id;
        _selectdata.status = true;
         _selectState.push(student);

    }


    function admittedStudent() external view returns(SelectData[] memory list){
        uint size = _selectState.length;
        address[] memory  selectMemory = new address[](size);
        list = new SelectData[](size);
        selectMemory = _selectState;
        for(uint i =0; i < size; i++){
            SelectData storage _data = selectdata[selectMemory[i]];
            list[i] = _data;
            list[i] =  selectdata[selectMemory[i]]; 
        }
    }

    struct ApplicationStatus{
        uint Id;
        uint OpenWin;
        uint closwWin;
        bool winstatus;
        uint resultReleaseDate;
        bool resultstatus;
    }

    mapping (address => ApplicationStatus) public applistatus;
    ApplicationStatus[] public Applists;
    address[] _applicationState;


    function WindowOpen(address student) external onlyOwner {
        ID++;
        ApplicationStatus storage _applistatus = applistatus[student];
        require(_applistatus.winstatus == false, "Window is Open");
        _applistatus.winstatus = true;
        _applistatus.Id = ID;
        _applicationState.push(student);
    }

    function WindowClose(address student) external onlyOwner {
        ID++;
        ApplicationStatus storage _applistatus = applistatus[student];
        require(_applistatus.winstatus == true, "Window is Close");
        _applistatus.winstatus = false;
        _applistatus.Id = ID;
        _applicationState.push(student);
    }

    function ResultWindowOpen(address student) external onlyOwner {
        ID++;
        ApplicationStatus storage _applistatus = applistatus[student];
        require(_applistatus.resultstatus == false, "Window is Open");
        _applistatus.resultstatus = true;
        _applistatus.Id = ID;
        _applicationState.push(student);
    }

    function ResultWindowClose(address student) external onlyOwner {
        ID++;
        ApplicationStatus storage _applistatus = applistatus[student];
        require(_applistatus.resultstatus == true, "Window is Close");
        _applistatus.resultstatus = false;
        _applistatus.Id = ID;
        _applicationState.push(student);
    }


    function getApplicationStatus() external view returns(ApplicationStatus[] memory list){
       uint size = _applicationState.length;

        if (size == 0) {
            // Return an empty array if there are no elements
            return new ApplicationStatus[](0);
        }

        // Ensure that the index is within bounds
        require(size > 0, "Array index out of range");

        address lastInserted = _applicationState[size - 1];

        // Ensure that the lastInserted address is valid
        require(lastInserted != address(0), "Invalid address");

        ApplicationStatus storage lastInsertedData = applistatus[lastInserted];

        // Create a new array with a single element containing the last inserted data
        ApplicationStatus[] memory result = new ApplicationStatus[](1);
        result[0] = lastInsertedData;

        return result;
    }
}