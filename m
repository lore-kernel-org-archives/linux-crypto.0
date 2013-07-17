From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 10/20] ima: pass the file descriptor to ima_add_violation()
Date: Wed, 17 Jul 2013 19:51:30 -0400
Message-ID: <1374105100-25880-11-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37606 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab3GQXwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 19:52:03 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 18 Jul 2013 00:52:01 +0100
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Roberto Sassu <roberto.sassu@polito.it>

Pass the file descriptor instead of the inode to ima_add_violation(),
to make the latter consistent with ima_store_measurement() in
preparation for the new template architecture.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h      | 2 +-
 security/integrity/ima/ima_api.c  | 3 ++-
 security/integrity/ima/ima_main.c | 5 ++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e0e1cde..d7bec6f 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -74,7 +74,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
 int ima_calc_buffer_hash(const void *data, int len,
 			 struct ima_digest_data *hash);
 int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
-void ima_add_violation(struct inode *inode, const unsigned char *filename,
+void ima_add_violation(struct file *file, const unsigned char *filename,
 		       const char *op, const char *cause);
 int ima_init_crypto(void);
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index bc1d128..98160a3 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -78,10 +78,11 @@ int ima_store_template(struct ima_template_entry *entry,
  * By extending the PCR with 0xFF's instead of with zeroes, the PCR
  * value is invalidated.
  */
-void ima_add_violation(struct inode *inode, const unsigned char *filename,
+void ima_add_violation(struct file *file, const unsigned char *filename,
 		       const char *op, const char *cause)
 {
 	struct ima_template_entry *entry;
+	struct inode *inode = file->f_dentry->d_inode;
 	int violation = 1;
 	int result;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c22027e..d9965bf 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -94,10 +94,9 @@ out:
 		pathname = dentry->d_name.name;
 
 	if (send_tomtou)
-		ima_add_violation(inode, pathname,
-				  "invalid_pcr", "ToMToU");
+		ima_add_violation(file, pathname, "invalid_pcr", "ToMToU");
 	if (send_writers)
-		ima_add_violation(inode, pathname,
+		ima_add_violation(file, pathname,
 				  "invalid_pcr", "open_writers");
 	kfree(pathbuf);
 }
-- 
1.8.1.4
