<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         import="java.util.List,
         		org.openelisglobal.common.action.IActionConstants,
         		org.openelisglobal.common.util.IdValuePair,
         		org.openelisglobal.internationalization.MessageUtil,
         		org.openelisglobal.common.util.Versioning" %>

<%@ page isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="ajax" uri="/tags/ajaxtags" %>
<%--
  ~ The contents of this file are subject to the Mozilla Public License
  ~ Version 1.1 (the "License"); you may not use this file except in
  ~ compliance with the License. You may obtain a copy of the License at
  ~ http://www.mozilla.org/MPL/
  ~
  ~ Software distributed under the License is distributed on an "AS IS"
  ~ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  ~ License for the specific language governing rights and limitations under
  ~ the License.
  ~
  ~ The Original Code is OpenELIS code.
  ~
  ~ Copyright (C) ITECH, University of Washington, Seattle WA.  All Rights Reserved.
  --%>

  <script type="text/javascript" src="scripts/ajaxCalls.js?"></script>

 <%--
<bean:define id="methodList" name='${form.formName}' property="existingMethodList" type="java.util.List"/>
<bean:define id="inactiveMethodList" name='${form.formName}' property="inactiveMethodList" type="java.util.List"/>
<bean:define id="englishSectionNames" name='${form.formName}' property="existingEnglishNames" type="String"/>
<bean:define id="frenchSectionNames" name='${form.formName}' property="existingFrenchNames" type="String"/>
 --%>

 <c:set var="methodList" value="${form.existingMethodList}" />
<c:set var="inactiveMethodList" value="${form.inactiveMethodList}" />
<c:set var="existingEnglishNames" value="${form.existingEnglishNames}" />
<c:set var="existingFrenchNames" value="${form.existingFrenchNames}" />

<%!
	final String NAME_SEPARATOR = "$";
%>

<%
	int methodCount = 0;
	int columnCount = 0;
	int columns = 4;
%>

<script type="text/javascript">
    if (!jQuery) {
        var jQuery = jQuery.noConflict();
    }

    function makeDirty(){
        function formWarning(){
            return "<spring:message code="banner.menu.dataLossWarning"/>";
        }
        window.onbeforeunload = formWarning;
    }

    function submitAction(target) {
        var form = document.getElementById("mainForm");
        form.action = target;
        form.submit();
    }

    function confirmValues() {
        var hasError = false;
        jQuery(".required").each(function () {
            var input = jQuery(this);
            if (!input.val() || input.val().strip().length == 0) {
                input.addClass("error");
                hasError = true;
            }
        });

        if (hasError) {
            alert("<%=MessageUtil.getContextualMessage("error.all.required")%>");
        } else {
            jQuery(".required").each(function () {
                var element = jQuery(this);
                element.prop("readonly", true);
                element.addClass("confirmation");
            });
            jQuery(".requiredlabel").each(function () {
                jQuery(this).hide();
            });
            jQuery("#editButtons").hide();
            jQuery("#confirmationButtons").show();
            jQuery("#confirmationMessage").show();
            jQuery("#action").text("<%=MessageUtil.getContextualMessage("label.confirmation")%>");
        }
    }

    function rejectConfirmation() {
        jQuery(".required").each(function () {
            var element = jQuery(this);
            element.removeProp("readonly");
            element.removeClass("confirmation");
        });
        jQuery(".requiredlabel").each(function () {
            jQuery(this).show();
        });

        jQuery("#editButtons").show();
        jQuery("#confirmationButtons").hide();
        jQuery("#confirmationMessage").hide();
        jQuery("#action").text("<%=MessageUtil.getContextualMessage("label.button.edit")%>");
    }

    function handleInput(element, locale) {
        var englishNames = "${form.existingEnglishNames}".toLowerCase();
        var frenchNames = "${form.existingFrenchNames}".toLowerCase();
        var duplicate = false;
        if( locale == 'english'){
            duplicate = englishNames.indexOf( '<%=NAME_SEPARATOR%>' + element.value.toLowerCase() + '<%=NAME_SEPARATOR%>') != -1;
        }else{
            duplicate = frenchNames.indexOf( '<%=NAME_SEPARATOR%>' + element.value.toLowerCase() + '<%=NAME_SEPARATOR%>') != -1;
        }

        if(duplicate){
            jQuery(element).addClass("error");
            alert("<spring:message code="configuration.method.create.duplicate" />" );
        }else{
            jQuery(element).removeClass("error");
        }

        makeDirty();
    }

    function savePage() {
        window.onbeforeunload = null; // Added to flag that formWarning alert isn't needed.
        var form = document.getElementById("mainForm");
        form.action = "MethodCreate";
        form.submit();
    }
</script>

<style>
    table{
      width: 80%;
    }
    td {
      width: 25%;
    }
</style>

<form:form name="${form.formName}" 
				   action="${form.formAction}" 
				   modelAttribute="form" 
				   onSubmit="return submitForm(this);" 
				   method="${form.formMethod}"
				   id="mainForm">


    <input type="button" value="<%= MessageUtil.getContextualMessage("banner.menu.administration") %>"
           onclick="submitAction('MasterListsPage');"
           class="textButton"/>&rarr;
    <input type="button" value="<%= MessageUtil.getContextualMessage("configuration.test.management") %>"
           onclick="submitAction('TestManagementConfigMenu');"
           class="textButton"/>&rarr;
    <input type="button" value="<%= MessageUtil.getContextualMessage("configuration.method.manage") %>"
           onclick="submitAction('MethodManagement');"
           class="textButton"/>&rarr;

<%=MessageUtil.getContextualMessage( "configuration.method.create" )%>
<br><br>

<div id="editDiv" >
    <h1 id="action"><spring:message code="label.button.edit"/></h1>
    <h2><spring:message code="configuration.method.create"/> </h2>

    <table>
        <tr>
            <th colspan="2" style="text-align: center"><spring:message code="method.new"/></th>
        </tr>
        <tr>
            <td style="text-align: center"><spring:message code="label.english"/></td>
            <td style="text-align: center"><spring:message code="label.french"/></td>
        </tr>
        <tr>
            <td><span class="requiredlabel">*</span><form:input path="methodEnglishName" cssClass="required" size="40"
                                                               onchange="handleInput(this, 'english');checkForDuplicates('english');"/>
            </td>
            <td><span class="requiredlabel">*</span><form:input path="methodFrenchName" cssClass="required" size="40"
                                                               onchange="handleInput(this, 'french');"/>
            </td>
        </tr>
    </table>
    <div id="confirmationMessage" style="display:none">
        <h4><spring:message code="configuration.method.confirmation.explain" /></h4>
    </div>
    <div style="text-align: center" id="editButtons">
        <input type="button" value="<%=MessageUtil.getContextualMessage("label.button.save")%>"
               onclick="confirmValues();"/>
        <input type="button" value="<%=MessageUtil.getContextualMessage("label.button.cancel")%>"
               onclick="window.onbeforeunload = null; submitAction('TestSectionManagement');"/>
    </div>
    <div style="text-align: center; display: none;" id="confirmationButtons">
        <input type="button" value="<%=MessageUtil.getContextualMessage("label.button.accept")%>"
               onclick="savePage();"/>
        <input type="button" value="<%=MessageUtil.getContextualMessage("label.button.reject")%>"
               onclick='rejectConfirmation();'/>
    </div>
</div>

<h3><spring:message code="method.existing" /></h3>

<table>
    <%  
        List methodList = (List) pageContext.getAttribute("methodList");
        List inactiveMethodList = (List) pageContext.getAttribute("inactiveMethodList");
    %>
      
    
        <% while(methodCount < methodList.size()){%>
        <tr>
            <td><%= ((IdValuePair)methodList.get(methodCount)).getValue()%>
                <%
                    methodCount++;
                    columnCount = 1;
                %></td>
            <% while(methodCount < methodList.size() && ( columnCount < columns )){%>
            <td><%= ((IdValuePair)methodList.get(methodCount)).getValue()%>
                <%
                    methodCount++;
                    columnCount++;
                %>
            </td>
            <% } %>
    
        </tr>
        <% } %>
    </table>


    <% if( !inactiveMethodList.isEmpty()){ %>
        <h3><spring:message code="method.existing.inactive" /></h3>
        <table>
            <%  methodCount = 0;
                columnCount = 0;
                while(methodCount < inactiveMethodList.size()){%>
            <tr>
                <td><%= ((IdValuePair)inactiveMethodList.get(methodCount)).getValue()%>
                    <%
                        methodCount++;
                        columnCount = 1;
                    %></td>
                <% while(methodCount < inactiveMethodList.size() && ( columnCount < columns )){%>
                <td><%= ((IdValuePair)inactiveMethodList.get(methodCount)).getValue()%>
                    <%
                        methodCount++;
                        columnCount++;
                    %></td>
                <% } %>
    
            </tr>
            <% } %>
        </table>
        <% } %>
    </form:form>
            


