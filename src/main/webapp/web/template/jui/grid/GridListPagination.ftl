<#--定义dataBinding-->
<#assign dataBind = "com.exedosoft.plat.template.BindData2FormModel"?new()/> 
<#assign i18n = "com.exedosoft.plat.template.TPLI18n"?new()>  
<div class="pageContent">
		
<#if (model.topOutGridFormLinks?size > 0) > 
	<div class="panelBar">
		<ul class="toolBar">
		<#list model.topOutGridFormLinks as item>
			<li>
				<#if '${dataBind(null,item)}' ==''>${item.htmlValue} </#if>
			</li>
			<#if ((item_index+1)!=(model.topOutGridFormLinks?size))>
					<li class="line">line</li>
			</#if>
		</#list>
		</ul>
	</div>
</#if>
	<table id='g${model.objUid}' class='table' width="100%" layoutH="150" >
		<thead>
		  <tr>
			<#--隐藏列，数据部分输出记录的主键-->
	<!--		<th  style='display:none' class="{sorter: false}" ></th>-->
			<#if model.NO><#--是否有数字序列-->
				<th  align='center' width='5%' class="{sorter: 'digit'}" nowrap='nowrap'>${i18n('序号')}</th>
			</#if>
		<#if model.checkBox><#--定义CheckBox-->
			<th style="align: center"  width='5%' nowrap='nowrap' class="{sorter: false}">
				${i18n('全选')}<input type ='checkbox'   name='checkinstanceheader' 
				id="check_${model.objUid}"/>
			</th>
		<#elseif model.radio>	
			<th style="text-align: center"  width='5%' nowrap='nowrap' class="{sorter: false}">&nbsp;</th>
		</#if>		<#--定义宏 判断输出什么类型的align-->
		<#macro JudgeAlign item>
		    <#if item.align?exists>
		    	align='${item.align}'
		    <#else>
		        align='center' 
		    </#if>
		</#macro>
		<#--输出其它的头标题-->
		<#list model.normalGridFormLinks as item>
            <th id='${item.colName}'  <#if item.width?exists> width='${item.width}'</#if>  <#if item.noWrapLabel>nowrap='nowrap'</#if> <#compress><@JudgeAlign item/> </#compress>>${item.l10n} </th> 
		</#list>
		</tr>
		</thead>
		<#--Table Header部分输出完毕-->
		<tbody>
	   <#list data as ins>
			<tr target='sid_user' rel='${ins.uid?if_exists}'  value='${ins.uid?if_exists}'  title='${ins.name?if_exists}'  >
			<#if model.NO><#--是否有数字序列-->
				<td align='center'>#{ins_index+1}</td>
			</#if>
			<#if model.checkBox><#--定义CheckBox-->
				<td style="text-align: center"  >&nbsp;&nbsp;<input type ='checkbox' title='${ins.name?if_exists}' value='${ins.uid}' class='list_check'  name='checkinstance'/> <input type ='hidden' value='${ins.uid}' name='checkinstance_hidden'/> </td>
			<#elseif model.radio>
				<td style="text-align: center" ><input type ='radio' title='${ins.name?if_exists}' value='${ins.uid}'  name='checkinstance'/>   <input type ='hidden' value='${ins.uid}' name='checkinstance_hidden'/>  </td>
			</#if>
			<#list model.normalGridFormLinks as item> 
		            <td  	<#if item.pageStatistics > class="${item.objUid}"</#if>  <#if item.noWrapValue>nowrap='nowrap'</#if> <#compress>  <@JudgeAlign item/></#compress>  style="${item.style?if_exists}" > <#if '${dataBind(ins,item)}' ==''> ${item.htmlValue} </#if> </td> 
			</#list>
			</tr>
	     </#list>
		</tbody>
	</table>

	<#if (model.rowSize?exists && model.rowSize > 0 && resultSize > model.rowSize)>
	<div class="panelBar">
		<div class="pages">
			<span>显示</span>
			<select id='selectsize${model.objUid}' class="combox" name="numPerPage" onchange="navTabPageBreak({numPerPage:this.value})">
				<option value="10">10</option>
				<option value="20">20</option>
				<option value="50">50</option>
				<option value="100">100</option>
				<option value="200">200</option>
				
			</select>
			<span>条，共${resultSize}条</span>
		</div>
		<div id="aabbcc" class="pagination"  targetType="navTab" totalCount="${resultSize}" numPerPage="${rowSize}" pageNumShown="${pageSize}" currentPage="${pageNo}"></div>
		<form id="pagerForm" method="post">
		<input type="hidden" name="pageNum" value="1" />
		<input type="hidden" name="numPerPage" value="${rowSize}" />
	</form>	
	</div>
	</#if>


	
	
	
	<#if (model.bottomOutGridFormLinks?size > 0) > 
	    <table class="list" width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="text-align:center" >
				<tr><td align="center" style="text-align:center">
				<#list model.bottomOutGridFormLinks as item> 
				   <#if item.newLine><br/></#if> <#if '${dataBind(null,item)}' ==''>  ${item.htmlValue} </#if> &nbsp; 
				</#list>
				</td></tr>
		</table>
	
	</#if>
	
	<#if (model.hiddenGridFormLinks?size > 0) > 
				<#list model.hiddenGridFormLinks as item> 
				    ${item.htmlValue}  &nbsp; 
				</#list>
	</#if>


</div>

<script language="javascript">


		

		$('#check_${model.objUid}').bind('click',function(){
			var check = $('#check_${model.objUid}').attr("checked");
			if(typeof check == "undefined") {
				check = false;
			}
			$('#g${model.objUid} .list_check').attr('checked',check);
			///同时把第一条记录selected
			if($('#check_${model.objUid}').attr("checked")){
				$('#g${model.objUid} tbody  tr').eq(0).addClass("selected");
			}else{
				$('#g${model.objUid} tbody  tr').eq(0).removeClass("selected");
			}
		});
		
		$('#g${model.objUid} .list_check').bind('click',function(e){
			if(!$(this).attr('checked')){
				$(this).parent().parent().removeClass("selected");
				if($('#g${model.objUid} .selected').size()==0){
					$('#g${model.objUid} .list_check:checked:first').parent().parent().addClass("selected");				
				}
				e.stopPropagation();
			}
		});

		$('#g${model.objUid} tbody  tr').bind('click',function(){
			$('#g${model.objUid} tbody  tr.selected').removeClass("selected");//去掉原来的选中selected
			$(this).addClass("selected");
//			$(this).find(".list_check").attr("checked",true);//点击就选中，容易出现问题
		});
		<#if model.subscribeAll> 
		$('#g${model.objUid} tbody  tr').bind('dblclick',function(){
			var selectedValue = $(this).attr('value');
			var dealBus = "&dataBus=setContext&contextKey=${model.service.bo.name}" + "&contextValue=" + selectedValue;
			$(".toolbar .selected").removeClass("selected");
			$(this).addClass("selected");
		    <#if ((model.service.bo.mainPaneModel.fullCorrHref)?exists) >
				popupDialog('${model.service.bo.mainPaneModel.name}','${model.service.bo.mainPaneModel.title}','${model.service.bo.mainPaneModel.fullCorrHref}' + dealBus,'${model.service.bo.mainPaneModel.paneWidth?if_exists}','${model.service.bo.mainPaneModel.paneHeight?if_exists}')
			</#if> 

		});
		</#if>
		$('#g${model.objUid} tbody  tr').bind('mouseover',function(){
			$(this).addClass("mover");
		}).bind('mouseout',function(){
			$('#g${model.objUid} tbody  tr').removeClass("mover");
		});
		

</script>
