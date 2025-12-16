/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

// Documentation page names
export const DOC_PAGES = {
  OVERVIEW: 'overview',
  CONFIGURATION: 'configuration',
  EXAMPLES: 'examples',
  FAQ: 'faq',
} as const;

export const DOC_PAGE_LABELS = {
  [DOC_PAGES.OVERVIEW]: 'Overview',
  [DOC_PAGES.CONFIGURATION]: 'Configuration',
  [DOC_PAGES.EXAMPLES]: 'Examples',
  [DOC_PAGES.FAQ]: 'FAQ',
} as const;
