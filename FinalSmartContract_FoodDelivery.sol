pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

contract FoodDelivery {
    
    struct Order{
        uint id;
        address ethAddressCustomer;
        address ethAddressRestaurant;
        address ethAddressRider;
        Customer customer;
        Restaurant restaurant;
        Rider rider;
    }

    struct Customer{
        string customer; // ชื่อลูกค้า
        string menu; // ชื่อเมนู
        uint qty; // จำนวน
        uint price; // ราคา
        string location; // ที่อยู่
        string telephone; // เบอร์โทร
        uint orderDatetime; // วันเวลาสั่งออเดอร์
        uint acceptState;//สถานะรับอาาร
    }

    struct Restaurant {
        string restaurant; // ชื่อร้านอาหาร
        string restaurantTelephone; // เบอร์โทรร้าน
        uint restaurantAcceptDate; // วันเวลายืนยันรับออเดอร์ร้านอาหาร
        uint restaurantState; //สถานะการรับงาน (1=รับงาน, 2=ไม่รับงาน)
        uint restaurantSubmitDate; // วันเวลายืนยันทำออเดอร์เสร็จร้านอาหาร
    }

    struct Rider {
        string rider; // ชื่อพนังงานส่งอาหาร
        string riderTelephone; // เบอร์
        uint riderAcceptState; //สถานะการรับงาน (1=รับงาน, 2=ไม่รับงาน)
        uint riderAcceptDate; // วันเวลายืนรับออเดอร์พนักงานส่งอาหาร
        string riderTakePic; //URL image to take order
        uint riderSetMenu; // วันเวลาพนักงานส่งอาหารออกส่งอาหาร
        uint riderDelivery; // วันเวลาพนักงานส่งอาหารถึงที่หมาย
        uint deliveryDate; // วันเวลปิดงาน
        uint deliveryState; // สถานะงาน (1=ส่งงานสำเร็จ, 2=ส่งงานไม่สำเร็จ)
    }

    Order[] public orders;
    uint public nextId;
    
    // สั่งออเดอร์
    function insertOrder (address _ethAddressRestaurant,string memory _customer, string memory _menu, uint _qty, uint _price, string memory _location, string memory _telephone, string memory _restaurant, string memory _restaurantTelephone, uint _acceptState) public {
        
        
        Customer memory customer = Customer(_customer, _menu, _qty, _price, _location, _telephone, block.timestamp, _acceptState);
        Restaurant memory restaurant = Restaurant(_restaurant, _restaurantTelephone, 0, 0, 0);
        Rider memory rider = Rider("", "", 0, 0, "", 0, 0, 0, 0);
        orders.push(Order(nextId, msg.sender, _ethAddressRestaurant, 0x0000000000000000000000000000000000000000, customer, restaurant, rider));
        nextId++;
       
    }
    function customerAccept (uint _id, uint _acceptState) public {
        uint id;
        address ethAddressCustomer;
        (id, ,ethAddressCustomer,) = findOrder(_id);
       // require(ethAddressCustomer == msg.sender, "ลูกค้าไม่ตรงกับระบบ");
         require(_acceptState == 1 || _acceptState == 2, "สถานะต้องเป็น (1, 2)");
        orders[id].customer.acceptState = _acceptState;

    }

    // พนักงานรับออเดอร์
    function riderAccept (uint _id, string memory _rider, string memory _riderTelephone, uint _riderAcceptState) public {
        uint id;
        address ethAddressRider;
        (id, , , ethAddressRider) = findOrder(_id);
        require(ethAddressRider == 0x0000000000000000000000000000000000000000, "มีพนักงานอื่นรับไปแล้ว");
        require(orders[id].restaurant.restaurantState == 1, "ร้านปฏิเสธคำสั่งซื้อ");
        require(_riderAcceptState == 1 || _riderAcceptState == 2, "สถานะต้องเป็น (1, 2)");
        if(_riderAcceptState == 1){
            orders[id].ethAddressRider = msg.sender;
        }
        // orders[id].ethAddressRider = msg.sender;
        orders[id].rider.rider = _rider;
        orders[id].rider.riderTelephone = _riderTelephone;
        orders[id].rider.riderAcceptDate = block.timestamp;
        orders[id].rider.riderAcceptState = _riderAcceptState;
    }

    // ร้านอาหารรับออเดอร์
    function restaurantAccept (uint _id, uint _restaurantState ) public {
        uint id;
        address ethAddressRestaurant;
        (id, ,ethAddressRestaurant,) = findOrder(_id);
        require(ethAddressRestaurant == msg.sender, "ร้านอาหารไม่ตรงกับระบบ");
        require(orders[id].restaurant.restaurantAcceptDate == 0, "รับออเดอร์ไปแล้ว");
        require(_restaurantState == 1 || _restaurantState == 2, "สถานะต้องเป็น (1, 2)");
        orders[id].restaurant.restaurantAcceptDate = block.timestamp;
        orders[id].restaurant.restaurantState = _restaurantState;
    }

    // ร้านอาหารยืนยันทำออเดอร์เสร็จ
    function restaurantSubmit (uint _id) public {
        uint id;
        address ethAddressRestaurant;
        (id, ,ethAddressRestaurant,) = findOrder(_id);
        require(ethAddressRestaurant == msg.sender, "ร้านอาหารไม่ตรงกับระบบ");
        require(orders[id].restaurant.restaurantSubmitDate == 0, "ยืนยันทำออเดอร์เสร็จไปแล้ว");
        orders[id].restaurant.restaurantSubmitDate = block.timestamp;
    }

    // พนักงานส่งอาหาร ออกส่งอาหาร (รับอาหารไปส่ง)
    function riderSetMenu (uint _id, string memory _linkApi) public {
        uint id;
        address ethAddressRider;
        (id, , , ethAddressRider) = findOrder(_id);
        require(ethAddressRider == msg.sender, "พนักงานไม่ตรงกับระบบ");
        require(orders[id].rider.riderSetMenu == 0, "ยืนยันส่งอาหารออกส่งอาหารไปแล้ว");
      //  require(orders[id].rider.riderDelivery == 1, "ไม่ได้รับคำสั่งซื้อนี้");
        orders[id].rider.riderTakePic = _linkApi;
        orders[id].rider.riderSetMenu = block.timestamp;
    }

    // พนักงานส่งอาหารถึงที่หมาย
    function riderDelivery (uint _id) public {
        uint id;
        address ethAddressRider;
        (id, , , ethAddressRider) = findOrder(_id);
        require(ethAddressRider == msg.sender, "พนักงานไม่ตรงกับระบบ");
        require(orders[id].rider.riderDelivery == 0, "ยืนยันส่งอาหารถึงที่หมายไปแล้ว");
        orders[id].rider.riderDelivery = block.timestamp;
    }


    // พนักงานส่งอาหารถึงที่หมาย
    function deliveryDate (uint _id, uint _deliveryState) public {
        uint id;
        address ethAddressRider;
        (id, , , ethAddressRider) = findOrder(_id);
        require(ethAddressRider == msg.sender, "พนักงานไม่ตรงกับระบบ");
        require(orders[id].rider.deliveryDate == 0, "ยืนยันปิดงานไปแล้ว");
        require(_deliveryState == 1 || _deliveryState == 2, "สถานะต้องเป็น (1, 2)");
        orders[id].rider.deliveryDate = block.timestamp;
        orders[id].rider.deliveryState = _deliveryState;
    }

    // ดึงข้อมูล
    function readOrder(uint _id) public view returns (uint, address, address, address) {
        uint i;
        (i, , ,) = findOrder(_id);
        return (orders[i].id, orders[i].ethAddressCustomer, orders[i].ethAddressRestaurant, orders[i].ethAddressRider);
    }

    function readOrderCustomer(uint _id) public view returns (uint, string memory, string memory, uint, uint, string memory, string memory,string memory, uint, uint) {
        uint i;
        (i, , ,) = findOrder(_id);
        return (orders[i].id, orders[i].customer.customer, orders[i].customer.menu, orders[i].customer.qty, orders[i].customer.price, orders[i].customer.location, orders[i].customer.telephone,orders[i].restaurant.restaurant ,orders[i].customer.orderDatetime, orders[i].customer.acceptState);
    }

    function readOrderRestaurant(uint _id) public view returns (uint, string memory, string memory, uint, uint, uint) {
        uint i;
        (i, , ,) = findOrder(_id);
        return (orders[i].id, orders[i].restaurant.restaurant, orders[i].restaurant.restaurantTelephone, orders[i].restaurant.restaurantAcceptDate, orders[i].restaurant.restaurantState, orders[i].restaurant.restaurantSubmitDate);
    }

    function readOrderRider(uint _id) public view returns (uint, string memory, string memory, uint, string memory, uint, uint, uint, uint) {
        uint i;
        (i, , ,) = findOrder(_id);
        return (orders[i].id, orders[i].rider.rider, orders[i].rider.riderTelephone, orders[i].rider.riderAcceptDate, orders[i].rider.riderTakePic, orders[i].rider.riderSetMenu, orders[i].rider.riderDelivery, orders[i].rider.deliveryDate, orders[i].rider.deliveryState);
    }

    // ดึงข้อมูลทั้งหมด
    function getAll() public view returns (Order[] memory){
        Order[] memory data = orders;
        return data;
    }

    // หาออเดอร์
    function findOrder(uint _id) internal view returns (uint, address, address, address) {
        for(uint i = 0; i < orders.length; i++) {
            if(orders[i].id == _id) {
                return (orders[i].id, orders[i].ethAddressCustomer, orders[i].ethAddressRestaurant, orders[i].ethAddressRider);
            }
        }
    }
    
}