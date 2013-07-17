From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 19/20] ima: define kernel parameter 'ima_template=' to change configured default
Date: Wed, 17 Jul 2013 19:51:39 -0400
Message-ID: <1374105100-25880-20-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Roberto Sassu <roberto.sassu@polito.it>

This patch allows users to specify from the kernel command line the
template descriptor, among those defined, that will be used to generate
and display measurement entries. If an user specifies a wrong template,
IMA reverts to the template descriptor set in the kernel configuration.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt   |  5 +++++
 security/integrity/ima/ima_template.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cb5daa1..7c60db3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1139,6 +1139,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			programs exec'd, files mmap'd for exec, and all files
 			opened for read by uid=0.
 
+	ima_template=   [IMA]
+			Select one of defined IMA measurements template formats.
+			Formats: { "ima" | "ima-ng" }
+			Default: "ima-ng"
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index c28ff9b..0002214 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -12,6 +12,8 @@
  * File: ima_template.c
  *      Helpers to manage template descriptors.
  */
+#include <crypto/hash_info.h>
+
 #include "ima.h"
 #include "ima_template_lib.h"
 
@@ -32,6 +34,35 @@ static struct ima_template_field supported_fields[] = {
 };
 
 static struct ima_template_desc *ima_template;
+static struct ima_template_desc *lookup_template_desc(const char *name);
+
+static int __init ima_template_setup(char *str)
+{
+	struct ima_template_desc *template_desc;
+	int template_len = strlen(str);
+
+	/*
+	 * Verify that a template with the supplied name exists.
+	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
+	 */
+	template_desc = lookup_template_desc(str);
+	if (!template_desc)
+		return 1;
+
+	/*
+	 * Verify whether the current hash algorithm is supported
+	 * by the 'ima' template.
+	 */
+	if (template_len == 3 && strcmp(str, IMA_TEMPLATE_IMA_NAME) == 0 &&
+	    ima_hash_algo != HASH_ALGO_SHA1 && ima_hash_algo != HASH_ALGO_MD5) {
+		pr_err("IMA: template does not support hash alg\n");
+		return 1;
+	}
+
+	ima_template = template_desc;
+	return 1;
+}
+__setup("ima_template=", ima_template_setup);
 
 static struct ima_template_desc *lookup_template_desc(const char *name)
 {
-- 
1.8.1.4

