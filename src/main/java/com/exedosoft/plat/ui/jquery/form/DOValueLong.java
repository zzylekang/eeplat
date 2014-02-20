package com.exedosoft.plat.ui.jquery.form;

import com.exedosoft.plat.ui.DOFormModel;
import com.exedosoft.plat.ui.DOIModel;
import com.exedosoft.plat.ui.DOIView;

public class DOValueLong extends DOBaseForm  implements DOIView {
	
	public DOValueLong(){
		super();
	}


	public String getHtmlCode(DOIModel aModel) {
		
		if(isUsingTemplate){
			return super.getHtmlCode(aModel);
		}
		
		DOFormModel fm = (DOFormModel) aModel;
		if (fm.getValue() != null) {
			String longValue = fm.getValue();
			if(longValue.indexOf(".")>-1){
				longValue = longValue.substring(0,longValue.indexOf("."));
			}
			return longValue;
		} else {
			return "&nbsp;";
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
