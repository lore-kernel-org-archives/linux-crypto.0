From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 17/20] ima: defer determining the appraisal hash algorithm for 'ima' template
Date: Wed, 17 Jul 2013 19:51:37 -0400
Message-ID: <1374105100-25880-18-git-send-email-zohar@linux.vnet.ibm.com>
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

The same hash algorithm should be used for calculating the file
data hash for the IMA measurement list, as for appraising the file
data integrity.  (The appraise hash algorithm is stored in the
'security.ima' extended attribute.)  The exception is when the
reference file data hash digest, stored in the extended attribute,
is larger than the one supported by the template.  In this case,
the file data hash needs to be calculated twice, once for the
measurement list and, again, for appraisal.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index d9965bf..c2f6d96 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -145,6 +145,7 @@ static int process_measurement(struct file *file, const char *filename,
 {
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
+	struct ima_template_desc *template_desc = ima_template_desc_current();
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
 	int rc = -ENOMEM, action, must_appraise, _func;
@@ -188,7 +189,10 @@ static int process_measurement(struct file *file, const char *filename,
 		goto out_digsig;
 	}
 
-	if (action & IMA_APPRAISE_SUBMASK)
+	if (strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) == 0) {
+		if (action & IMA_APPRAISE_SUBMASK)
+			xattr_ptr = &xattr_value;
+	} else
 		xattr_ptr = &xattr_value;
 
 	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
-- 
1.8.1.4

