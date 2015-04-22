From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/6] crypto: fips - Move fips_enabled sysctl into fips.c
Date: Wed, 22 Apr 2015 13:25:56 +0800
Message-ID: <E1YknAa-0001zQ-1V@gondolin.me.apana.org.au>
References: <20150422052452.GA7553@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36137 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbbDVFZ6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:25:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YknAa-0005SE-6l
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2015 15:25:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is currently a large ifdef FIPS code section in proc.c.
Ostensibly it's there because the fips_enabled sysctl sits under
/proc/sys/crypto.  However, no other crypto sysctls exist.

In fact, the whole ethos of the crypto API is against such user
interfaces so this patch moves all the FIPS sysctl code over to
fips.c.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/fips.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/proc.c |   41 -----------------------------------------
 2 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index 0f65df9..9d627c1 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -13,7 +13,9 @@
 #include <linux/export.h>
 #include <linux/fips.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sysctl.h>
 
 int fips_enabled;
 EXPORT_SYMBOL_GPL(fips_enabled);
@@ -28,3 +30,49 @@ static int fips_enable(char *str)
 }
 
 __setup("fips=", fips_enable);
+
+static struct ctl_table crypto_sysctl_table[] = {
+	{
+		.procname       = "fips_enabled",
+		.data           = &fips_enabled,
+		.maxlen         = sizeof(int),
+		.mode           = 0444,
+		.proc_handler   = proc_dointvec
+	},
+	{}
+};
+
+static struct ctl_table crypto_dir_table[] = {
+	{
+		.procname       = "crypto",
+		.mode           = 0555,
+		.child          = crypto_sysctl_table
+	},
+	{}
+};
+
+static struct ctl_table_header *crypto_sysctls;
+
+static void crypto_proc_fips_init(void)
+{
+	crypto_sysctls = register_sysctl_table(crypto_dir_table);
+}
+
+static void crypto_proc_fips_exit(void)
+{
+	unregister_sysctl_table(crypto_sysctls);
+}
+
+static int __init fips_init(void)
+{
+	crypto_proc_fips_init();
+	return 0;
+}
+
+static void __exit fips_exit(void)
+{
+	crypto_proc_fips_exit();
+}
+
+module_init(fips_init);
+module_exit(fips_exit);
diff --git a/crypto/proc.c b/crypto/proc.c
index 4ffe73b..2cc10c9 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -20,47 +20,8 @@
 #include <linux/rwsem.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/sysctl.h>
 #include "internal.h"
 
-#ifdef CONFIG_CRYPTO_FIPS
-static struct ctl_table crypto_sysctl_table[] = {
-	{
-		.procname       = "fips_enabled",
-		.data           = &fips_enabled,
-		.maxlen         = sizeof(int),
-		.mode           = 0444,
-		.proc_handler   = proc_dointvec
-	},
-	{}
-};
-
-static struct ctl_table crypto_dir_table[] = {
-	{
-		.procname       = "crypto",
-		.mode           = 0555,
-		.child          = crypto_sysctl_table
-	},
-	{}
-};
-
-static struct ctl_table_header *crypto_sysctls;
-
-static void crypto_proc_fips_init(void)
-{
-	crypto_sysctls = register_sysctl_table(crypto_dir_table);
-}
-
-static void crypto_proc_fips_exit(void)
-{
-	if (crypto_sysctls)
-		unregister_sysctl_table(crypto_sysctls);
-}
-#else
-#define crypto_proc_fips_init()
-#define crypto_proc_fips_exit()
-#endif
-
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	down_read(&crypto_alg_sem);
@@ -148,11 +109,9 @@ static const struct file_operations proc_crypto_ops = {
 void __init crypto_init_proc(void)
 {
 	proc_create("crypto", 0, NULL, &proc_crypto_ops);
-	crypto_proc_fips_init();
 }
 
 void __exit crypto_exit_proc(void)
 {
-	crypto_proc_fips_exit();
 	remove_proc_entry("crypto", NULL);
 }
