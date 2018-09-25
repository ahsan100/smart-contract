contract SimpleStorage {
    string storedData;

    function set(string x){
        storedData = x;
    }

    function get() returns (string) {
        return storedData;
    }
}
