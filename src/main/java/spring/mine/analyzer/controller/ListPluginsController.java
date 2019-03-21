package spring.mine.analyzer.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import spring.mine.analyzer.form.ListPluginForm;
import spring.mine.common.controller.BaseController;
import spring.mine.common.validator.BaseErrors;
import spring.mine.internationalization.MessageUtil;
import us.mn.state.health.lims.plugin.PluginLoader;

@Controller
public class ListPluginsController extends BaseController {
	@RequestMapping(value = "/ListPlugins", method = RequestMethod.GET)
	public ModelAndView showListPlugins(HttpServletRequest request) {
		String forward = FWD_SUCCESS;
		ListPluginForm form = new ListPluginForm();
		form.setFormAction("");
		Errors errors = new BaseErrors();
		

		List<String> pluginNames = PluginLoader.getCurrentPlugins();

		if (pluginNames.size() == 0) {
			pluginNames.add(MessageUtil.getContextualMessage("plugin.no.plugins"));
		}
		form.setPluginList(pluginNames);

		return findForward(forward, form);
	}

	protected String findLocalForward(String forward) {
		if (FWD_SUCCESS.equals(forward)) {
			return "ListPluginsPageDefinition";
		} else {
			return "PageNotFound";
		}
	}

	@Override
	protected String getPageTitleKey() {
		return "plugin.installed.plugins";
	}

	@Override
	protected String getPageSubtitleKey() {
		return "plugin.installed.plugins";
	}
}
