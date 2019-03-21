package spring.generated.userrole.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import spring.generated.forms.UserRoleMenuForm;
import spring.mine.common.controller.BaseController;
import spring.mine.common.validator.BaseErrors;

//seemingly unused controller
@Controller
public class DeleteUserRoleController extends BaseController {
	@RequestMapping(value = "/DeleteUserRole", method = RequestMethod.GET)
	public ModelAndView showDeleteUserRole(HttpServletRequest request, @ModelAttribute("form") UserRoleMenuForm form) {
		String forward = FWD_SUCCESS;
		if (form == null) {
			form = new UserRoleMenuForm();
		}
		form.setFormAction("");
		Errors errors = new BaseErrors();

		return findForward(forward, form);
	}

	@Override
	protected String findLocalForward(String forward) {
		if (FWD_SUCCESS.equals(forward)) {
			return "/UserRoleMenu.do";
		} else if (FWD_FAIL.equals(forward)) {
			return "/UserRoleMenu.do";
		} else {
			return "PageNotFound";
		}
	}

	@Override
	protected String getPageTitleKey() {
		return null;
	}

	@Override
	protected String getPageSubtitleKey() {
		return null;
	}
}
