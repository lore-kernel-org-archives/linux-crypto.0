From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 18/20] ima: add Kconfig default measurement list template
Date: Wed, 17 Jul 2013 19:51:38 -0400
Message-ID: <1374105100-25880-19-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@us.ibm.com>,
	Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46546 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab3GQXwM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 19:52:12 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 17 Jul 2013 17:52:12 -0600
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a Kconfig option to select the default IMA
measurement list template.  The 'ima' template limited the
filedata hash to 20 bytes and the pathname to 255 charaters.
The 'ima-ng' measurement list template permits larger hash
digests and longer pathnames.

Changelog:
- keep 'select CRYPTO_HASH_INFO' in 'config IMA' section (Kconfig)
  (Roberto Sassu);
- removed trailing whitespaces (Roberto Sassu).
- Lindent fixes

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/Kconfig        | 25 +++++++++++++++++++++++++
 security/integrity/ima/ima_template.c |  4 ++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index e6628e7..de26cc8 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -46,6 +46,31 @@ config IMA_LSM_RULES
 	help
 	  Disabling this option will disregard LSM based policy rules.
 
+choice
+	prompt "Default template"
+	default IMA_NG_TEMPLATE
+	depends on IMA
+	help
+	  Select the default IMA measurement template.
+
+	  The original 'ima' measurement list template contains a
+	  hash, defined as 20 bytes, and a null terminated pathname,
+	  limited to 255 characters.  The 'ima-ng' measurement list
+	  template permits both larger hash digests and longer
+	  pathnames.
+
+	config IMA_TEMPLATE
+		bool "ima"
+	config IMA_NG_TEMPLATE
+		bool "ima-ng (default)"
+endchoice
+
+config IMA_DEFAULT_TEMPLATE
+	string
+	depends on IMA
+	default "ima" if IMA_TEMPLATE
+	default "ima-ng" if IMA_NG_TEMPLATE
+
 config IMA_APPRAISE
 	bool "Appraise integrity measurements"
 	depends on IMA
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 1c4cf19..c28ff9b 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -127,8 +127,8 @@ static int init_defined_templates(void)
 struct ima_template_desc *ima_template_desc_current(void)
 {
 	if (!ima_template)
-		ima_template = lookup_template_desc(IMA_TEMPLATE_IMA_NAME);
-
+		ima_template =
+		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
 	return ima_template;
 }
 
-- 
1.8.1.4
