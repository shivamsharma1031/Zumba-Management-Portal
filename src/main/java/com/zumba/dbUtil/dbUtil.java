package com.zumba.dbUtil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class dbUtil {

    // Method to establish and return a connection
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load the JDBC driver
        Class.forName(DbUtilHelperConstant.DRIVER_CLASS);
        
        // Create and return the connection
        return DriverManager.getConnection(
            DbUtilHelperConstant.DB_URL,
            DbUtilHelperConstant.USERNAME,
            DbUtilHelperConstant.PASSWORD
        );
    }

    // Method to close the connection
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace(); 
            }
        }
    }
}
