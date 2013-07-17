From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 20/20] ima: enable support for larger default filedata hash algorithms
Date: Wed, 17 Jul 2013 19:51:40 -0400
Message-ID: <1374105100-25880-21-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@us.ibm.com>,
	Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The IMA measurement list contains two hashes - a template data hash
and a filedata hash.  The template data hash is committed to the TPM,
which is limited, by the TPM v1.2 specification, to 20 bytes.  The
filedata hash is defined as 20 bytes as well.

Now that support for variable length measurement list templates was
added, the filedata hash is not limited to 20 bytes.  This patch adds
Kconfig support for defining larger default filedata hash algorithms
and replacing the builtin default with one specified on the kernel
command line.

<uapi/linux/hash_info.h> contains a list of hash algorithms.  The
Kconfig default hash algorithm is a subset of this list, but any hash
algorithm included in the list can be specified at boot, using the
'ima_hash=' kernel command line option.

Changelog:
- support hashes that are configured
- use generic HASH_ALGO_ definitions
- add Kconfig support
- hash_setup must be called only once (Dmitry)
- removed trailing whitespaces (Roberto Sassu)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/kernel-parameters.txt |  6 +++++-
 security/integrity/ima/Kconfig      | 35 +++++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_main.c   | 26 ++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7c60db3..f328a60 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1130,9 +1130,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			owned by uid=0.
 
 	ima_hash=	[IMA]
-			Format: { "sha1" | "md5" }
+			Format: { md5 | sha1 | rmd160 | sha256 | sha384
+				   | sha512 | ... }
 			default: "sha1"
 
+			The list of supported hash algorithms is defined
+			in crypto/hash_info.h.
+
 	ima_tcb		[IMA]
 			Load a policy which meets the needs of the Trusted
 			Computing Base.  This means IMA will measure all
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index de26cc8..dab1898 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -71,6 +71,41 @@ config IMA_DEFAULT_TEMPLATE
 	default "ima" if IMA_TEMPLATE
 	default "ima-ng" if IMA_NG_TEMPLATE
 
+choice
+	prompt "Default integrity hash algorithm"
+	default IMA_DEFAULT_HASH_SHA1
+	depends on IMA
+	help
+	   Select the default hash algorithm used for the measurement
+	   list, integrity appraisal and audit log.  The compiled default
+	   hash algorithm can be overwritten using the kernel command
+	   line 'ima_hash=' option.
+
+	config IMA_DEFAULT_HASH_SHA1
+		bool "SHA1 (default)"
+		depends on CRYPTO_SHA1
+
+	config IMA_DEFAULT_HASH_SHA256
+		bool "SHA256"
+		depends on CRYPTO_SHA256 && IMA_NG_TEMPLATE
+
+	config IMA_DEFAULT_HASH_SHA512
+		bool "SHA512"
+		depends on CRYPTO_SHA512 && IMA_NG_TEMPLATE
+
+	config IMA_DEFAULT_HASH_WP512
+		bool "WP512"
+		depends on CRYPTO_WP512 && IMA_NG_TEMPLATE
+endchoice
+
+config IMA_DEFAULT_HASH
+	string
+	depends on IMA
+	default "sha1" if IMA_DEFAULT_HASH_SHA1
+	default "sha256" if IMA_DEFAULT_HASH_SHA256
+	default "sha512" if IMA_DEFAULT_HASH_SHA512
+	default "wp512" if IMA_DEFAULT_HASH_WP512
+
 config IMA_APPRAISE
 	bool "Appraise integrity measurements"
 	depends on IMA
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c2f6d96..fc1ff82 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -37,11 +37,32 @@ int ima_appraise;
 #endif
 
 int ima_hash_algo = HASH_ALGO_SHA1;
+static int hash_setup_done;
 
 static int __init hash_setup(char *str)
 {
-	if (strncmp(str, "md5", 3) == 0)
-		ima_hash_algo = HASH_ALGO_MD5;
+	struct ima_template_desc *template_desc = ima_template_desc_current();
+	int i;
+
+	if (hash_setup_done)
+		return 1;
+
+	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
+		if (strncmp(str, "sha1", 4) == 0)
+			ima_hash_algo = HASH_ALGO_SHA1;
+		else if (strncmp(str, "md5", 3) == 0)
+			ima_hash_algo = HASH_ALGO_MD5;
+		goto out;
+	}
+
+	for (i = 0; i < HASH_ALGO__LAST; i++) {
+		if (strcmp(str, hash_algo_name[i]) == 0) {
+			ima_hash_algo = i;
+			break;
+		}
+	}
+out:
+	hash_setup_done = 1;
 	return 1;
 }
 __setup("ima_hash=", hash_setup);
@@ -306,6 +327,7 @@ static int __init init_ima(void)
 {
 	int error;
 
+	hash_setup(CONFIG_IMA_DEFAULT_HASH);
 	error = ima_init();
 	if (!error)
 		ima_initialized = 1;
-- 
1.8.1.4

