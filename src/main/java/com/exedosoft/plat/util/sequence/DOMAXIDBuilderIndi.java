package com.exedosoft.plat.util.sequence;

import com.exedosoft.plat.bo.DODataSource;

import java.util.Hashtable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.exedosoft.plat.bo.DOBO;
import com.exedosoft.plat.util.id.UUIDHex;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2003</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

/**
 * <p>Title: </p> <p>Description: </p> <p>Copyright: Copyright (c) 2003</p> <p>Company: </p>
 * @author  not attributable
 * @version  1.0
 */
public class DOMAXIDBuilderIndi implements SequenceBuilder {

	private static DOMAXIDBuilderIndi builder;

	private static Object lockObj = new Object();// lock object

	private static Hashtable casheKey = new Hashtable();// cashe

	private static Hashtable casheOverFlowId = new Hashtable();

	private int overFlowId = 0; // when cashe's id more than this id ,have to

	// retrieve from db

	private int poolSize = 10;// getId numbers without accessing datebase

	private int maxSequence = 1;

	private DOMAXIDBuilderIndi() {
	}

	/**
	 * Gets only one TableIdBuidler object
	 * 
	 * @return
	 */
	public static DOMAXIDBuilderIndi getInstance() {

		if (builder == null) {
			synchronized (lockObj) {
				if (builder == null) {
					builder = new DOMAXIDBuilderIndi();
				}
			}
		}
		return builder;
	}

	/**
	 * 
	 * Gets the number value of max of objid +1
	 */
	private int getIDFromDb(String codeItemID, String aIndiID) {

		// int aTrash = DOMAXIDTrash.getInstance().getTrashID(codeItemID,
		// aDeptCode);
		// if(aTrash!=-1){
		// return aTrash;
		// }

		// propertyValue:::::::::::deptCode

		String selectSql = "SELECT max_sequence FROM do_code_maxsequence WHERE code_ItemUid=? and propertyValue=?  for update ";

		StringBuffer insertSql = new StringBuffer(
				"insert into DO_Code_MaxSequence(OBJUID,SEQUENCE_NAME,CODE_ITEMUID,PROPERTYUID,PROPERTYVALUE,YEARSEQ,MAX_SEQUENCE) values(")
				.append("?,?,?,null,?,?,?)");

		StringBuffer updateSql = new StringBuffer(
				"update DO_Code_MaxSequence	 SET max_sequence=max_sequence+1")
				.append(" WHERE code_ItemUid=? and propertyValue=? ");

		Connection con = null;
		PreparedStatement stmt = null;
		int retId = 1;// //////////返回的值

		DOBO bo = DOBO.getDOBOByName("do_authorization");
		DODataSource dss =  bo.getDataBase();

		try {
			// query
			con = dss.getConnection();
			con.setAutoCommit(false);

			// query
			stmt = con.prepareStatement(selectSql);
			stmt.setString(1, codeItemID);
			stmt.setString(2, aIndiID);
			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				retId = rs.getInt("max_sequence") + 1;
				// update
				stmt = con.prepareStatement(updateSql.toString());
				stmt.setString(1, codeItemID);
				stmt.setString(2, aIndiID);
				stmt.execute();
			} else {
				// //////////////insert
				stmt = con.prepareStatement(insertSql.toString());
				stmt.setString(1, UUIDHex.getInstance().generate());
				stmt.setString(2, aIndiID);
				stmt.setString(3, codeItemID);
				stmt.setString(4, aIndiID);
				stmt.setInt(5, 0);
				stmt.setLong(6, retId);
				stmt.execute();
			}

			con.commit();
			return retId;

		} catch (SQLException ex) {
			try {
				con.rollback();
			} catch (SQLException e) {

			}
			ex.printStackTrace();
			return 0;
		} finally {// Close Connection
			try {
				if (stmt != null) {
					stmt.close();
				}
				con.close();
			} catch (Exception ex1) {
				ex1.printStackTrace();
			}
		}
	}

	/**
	 * Put tableName and maxId to hashtble
	 */
	private void putCashe(String codeItemId, int aMaxId) {
		casheKey.put(codeItemId, new Integer(aMaxId));
	}

	/**
	 * Gets table key by a table name
	 * 
	 * @return key in cashe
	 */
	public synchronized int getID(String codeItemID, String aIndiID) {

		// if (casheKey.containsKey(codeItemID)) {
		// maxSequence = ((Integer) casheKey.get(codeItemID)).intValue() + 1;
		// } // if cash contains table's key
		// else {
		maxSequence = this.getIDFromDb(codeItemID, aIndiID);
		// }
		// // ////////////////if overflow
		// if (casheOverFlowId.get(codeItemID) != null) {
		// overFlowId = ((Integer) casheOverFlowId.get(codeItemID)).intValue();
		// }
		// if (maxSequence >= overFlowId) {
		// maxSequence = this.getIDFromDb(codeItemID, aDeptCode);
		// }
		// // ///////////refesh cashe data
		// putCashe(codeItemID, maxSequence);
		return maxSequence;
	}

	public synchronized Long getLong(String codeItemID, String aIndiID) {
		return new Long(getID(codeItemID, aIndiID));
	}

	public synchronized Integer getInteger(String codeItemID, String aIndiID) {
		return new Integer(getID(codeItemID, aIndiID));
	}

	public synchronized String getString(String codeItemID, String aIndiID) {
		return String.valueOf(getID(codeItemID, aIndiID));
	}

	public static void main(String[] args) {

		int i = 1;
		for (int j = 0; j < 2; j++) {
			i++;
		}
		System.out.println(++i);

	}

}
