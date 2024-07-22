// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RetailerContract {
    enum OrderStatus { PENDING, RECEIVED, IN_TRANSIT, DELIVERED, CANCELED }

    struct Order {
        address sender;
        address supplier;
        address buyer;
        uint256 Createdtime;
        uint256 Amount;
        uint256 Quantity;
        uint256 TotalAmount;
        OrderStatus status;
        bool isPaid;
    }

    mapping(address => Order[]) public Orders;
    uint256 public OrderCount;

    struct TypeOrder {
        address sender;
        address supplier;
        address buyer;
        uint256 Createdtime;
        uint256 Amount;
        uint256 Quantity;
        uint256 TotalAmount;
        OrderStatus status;
        bool isPaid;
    }

    TypeOrder[] typeOrders;

    event OrderCreated(address indexed sender, address indexed supplier, address indexed buyer, uint256 Createdtime, uint256 Quantity, uint256 TotalAmount);
    event OrderInReceived(address indexed sender, address indexed buyer, uint256 Createdtime);
    event OrderInTransit(address indexed sender, address indexed buyer, uint256 Createdtime);
    event OrderDelivered(address indexed sender, address indexed buyer, uint256 Createdtime);
    event OrderPaid(address indexed sender, address indexed buyer, uint256 TotalAmount);

    constructor(){
        OrderCount = 0;
        ProductCount = 0;
    }

    function createOrder(address _supplier, address _buyer, uint256 _Createdtime, uint256 _Quantity, uint256 _TotalAmount) public payable {
        require(msg.value == _TotalAmount, "Payment amount must match the TotalAmount");

        Order memory order = Order(msg.sender, _supplier, _buyer, _Createdtime, 0, _Quantity, _TotalAmount, OrderStatus.PENDING, false);

        Orders[msg.sender].push(order);
        OrderCount++;

        typeOrders.push(
            TypeOrder(
                msg.sender,
                _supplier,
                _buyer,
                _Createdtime,
                0,
                _Quantity,
                _TotalAmount,
                OrderStatus.PENDING,
                false
            )
        );

        emit OrderCreated(msg.sender,_supplier, _buyer, _Createdtime, _Quantity, _TotalAmount);
    }

    function receiveOrder(address _sender, address _buyer, uint256 _index) public {
        Order storage order = Orders[_sender][_index];
        TypeOrder storage typeOrder = typeOrders[_index];

        require(order.buyer == _buyer, "Invalid buyer");
        require(order.status == OrderStatus.PENDING, "The Order ready Received");

        order.status = OrderStatus.RECEIVED;
        typeOrder.status = OrderStatus.RECEIVED;

        emit OrderInTransit(_sender, _buyer, order.Createdtime);
    }

    function startOrder(address _sender, address _buyer, uint256 _index) public {
        Order storage order = Orders[_sender][_index];
        TypeOrder storage typeOrder = typeOrders[_index];

        require(order.buyer == _buyer, "Invalid buyer");
        require(order.status == OrderStatus.RECEIVED, "The Order ready in Transit");

        order.status = OrderStatus.IN_TRANSIT;
        typeOrder.status = OrderStatus.IN_TRANSIT;

        emit OrderInTransit(_sender, _buyer, order.Createdtime);
    }

    function completeOrder(address _sender, address _buyer, uint256 _index) public {
        Order storage order = Orders[_sender][_index];
        TypeOrder storage typeOrder = typeOrders[_index];

        require(order.buyer == _buyer, "Invalid buyer");
        require(order.status == OrderStatus.IN_TRANSIT, "The Order not in Transit");
        require(!order.isPaid, "Order already paid");

        order.status = OrderStatus.DELIVERED;
        typeOrder.status = OrderStatus.DELIVERED;
        order.Amount = block.timestamp;

        uint256 amount = order.TotalAmount;
        payable(order.sender).transfer(amount);

        order.isPaid = true;
        typeOrder.isPaid = true;

        emit OrderDelivered(_sender, _buyer, order.Createdtime);
        emit OrderPaid(_sender, _buyer, amount);
    }


    function getOrder(address _sender, uint256 _index) public view returns (address, address, address, uint256, uint256, uint256, uint256, OrderStatus, bool) {
        Order memory order = Orders[_sender][_index];
        return (order.sender, order.supplier, order.buyer, order.Createdtime, order.Amount, order.Quantity, order.TotalAmount,
        order.status, order.isPaid);
    }

    function getOrderCount(address _sender) public view returns (uint256){
        return Orders[_sender].length;
    }

    function getAllTransactions() public view returns (TypeOrder[] memory){
        return typeOrders;
    }

   

  enum ProductStatus { PENDING, RECEIVED, IN_TRANSIT, DELIVERED, CANCELED }

    struct Product {
        address sender;
        address buyer;
        uint256 productId;
        string productName;
        string location;
        uint256 mnfdDate;
        uint256 Quantity;
        uint256 TotalAmount;
        ProductStatus status;
        bool isPaid;
    }

    mapping(address => Product[]) public Products;
    uint256 public ProductCount;

    struct TypeProduct {
        address sender;
        address buyer;
        uint256 productId;
        string productName;
        string location;
        uint256 mnfdDate;
        uint256 Quantity;
        uint256 TotalAmount;
        ProductStatus status;
        bool isPaid;
    }

    TypeProduct[] typeProducts;

    event ProductCreated(address indexed sender, address indexed buyer, uint256 productId, string productName, uint256 mnfdDate, uint256 Quantity, uint256 TotalAmount);
    event ProductInReceived(address indexed sender, address indexed buyer, uint256 productId);
    event ProductInTransit(address indexed sender, address indexed buyer, uint256 productId);
    event ProductDelivered(address indexed sender, address indexed buyer, uint256 productId);
    event ProductPaid(address indexed sender, address indexed buyer, uint256 TotalAmount);

    // constructor(){
    //     ProductCount = 0;
    // }

    function createProduct(
        address _buyer, 
        uint256 _productId, 
        string memory _productName, 
        string memory _location, 
        uint256 _mnfdDate, 
        uint256 _Quantity, 
        uint256 _TotalAmount
    ) public payable {
        require(msg.value == _TotalAmount, "Payment amount must match the TotalAmount");

        Product memory product = Product(
            msg.sender, 
            _buyer, 
            _productId, 
            _productName, 
            _location, 
            _mnfdDate, 
            _Quantity, 
            _TotalAmount, 
            ProductStatus.PENDING, 
            false
        );

        Products[msg.sender].push(product);
        ProductCount++;

        typeProducts.push(
            TypeProduct(
                msg.sender,
                _buyer,
                _productId,
                _productName,
                _location,
                _mnfdDate,
                _Quantity,
                _TotalAmount,
                ProductStatus.PENDING,
                false
            )
        );

        emit ProductCreated(msg.sender, _buyer, _productId, _productName, _mnfdDate, _Quantity, _TotalAmount);
    }

    function receiveProduct(address _sender, address _buyer, uint256 _productId) public {
        // Implementation for receiving product
        emit ProductInReceived(_sender, _buyer, _productId);
    }

    function startProduct(address _sender, address _buyer, uint256 _productId) public {
        // Implementation for starting product transit
        emit ProductInTransit(_sender, _buyer, _productId);
    }

    function completeProduct(address _sender, address _buyer, uint256 _productId) public {
        // Implementation for completing product delivery
        emit ProductDelivered(_sender, _buyer, _productId);
    }

    function getProduct(address _sender, uint256 _index) public view returns (address, address, uint256, string memory, string memory, uint256, uint256, uint256, ProductStatus, bool) {
        Product memory product = Products[_sender][_index];
        return (
            product.sender,
            product.buyer,
            product.productId,
            product.productName,
            product.location,
            product.mnfdDate,
            product.Quantity,
            product.TotalAmount,
            product.status,
            product.isPaid
        );
    }

    function getProductCount(address _sender) public view returns (uint256){
        return Products[_sender].length;
    }

    function getAllPTransactions() public view returns (TypeProduct[] memory){
        return typeProducts;
    }
   
}