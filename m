From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 05/19] crypto: proc - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:03 +0100
Message-ID: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44202 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0BSAWX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/proc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 58fef67..56a3c64 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -8,7 +8,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -79,15 +79,15 @@ static void c_stop(struct seq_file *m, void *p)
 static int c_show(struct seq_file *m, void *p)
 {
 	struct crypto_alg *alg = list_entry(p, struct crypto_alg, cra_list);
-	
+
 	seq_printf(m, "name         : %s\n", alg->cra_name);
 	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
 	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
 	seq_printf(m, "priority     : %d\n", alg->cra_priority);
 	seq_printf(m, "refcnt       : %d\n", atomic_read(&alg->cra_refcnt));
 	seq_printf(m, "selftest     : %s\n",
-		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
-		   "passed" : "unknown");
+	           (alg->cra_flags & CRYPTO_ALG_TESTED) ?
+	           "passed" : "unknown");
 
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
 		seq_printf(m, "type         : larval\n");
@@ -99,7 +99,7 @@ static int c_show(struct seq_file *m, void *p)
 		alg->cra_type->show(m, alg);
 		goto out;
 	}
-	
+
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
 		seq_printf(m, "type         : cipher\n");
@@ -133,7 +133,7 @@ static int crypto_info_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &crypto_seq_ops);
 }
-        
+
 static const struct file_operations proc_crypto_ops = {
 	.open		= crypto_info_open,
 	.read		= seq_read,
-- 
1.6.6.1

