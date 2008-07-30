From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: add fips_enable flag
Date: Wed, 30 Jul 2008 16:34:07 -0400
Message-ID: <20080730203407.GA14674@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.linux.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58037 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410AbYHEGQY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 02:16:24 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KQFqI-0003Am-Jn
	for <linux-crypto@vger.kernel.org>; Tue, 05 Aug 2008 16:16:22 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KQFqI-0005Bb-00
	for <linux-crypto@vger.kernel.org>; Tue, 05 Aug 2008 14:16:22 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the ability to turn FIPS-compliant mode on or off at boot

In order to be FIPS compliant, several check may need to be preformed that may
be construed as unusefull in a non-compliant mode.  This patch allows us to set
a kernel flag incating that we are running in a fips-compliant mode from boot
up.  It also exports that mode information to user space via a sysctl
(/proc/sys/crypto/fips_enabled).

Tested successfully by me.

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 api.c      |   14 ++++++++++++++
 internal.h |    2 ++
 proc.c     |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)


diff --git a/crypto/api.c b/crypto/api.c
index d06e332..897070c 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -450,5 +450,19 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
+
+int fips_enabled;
+
+/* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
+static int fips_enable(char *str)
+{
+	fips_enabled = !!simple_strtol(str, NULL, 0);
+	printk(KERN_INFO "fips mode: %s\n",
+		fips_enabled ? "enabled" : "disabled");
+	return 1;
+}
+
+__setup("fips=", fips_enable);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/internal.h b/crypto/internal.h
index 683fcb2..ec44f47 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -26,6 +26,8 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 
+extern int fips_enabled;
+
 /* Crypto notification events. */
 enum {
 	CRYPTO_MSG_ALG_REQUEST,
diff --git a/crypto/proc.c b/crypto/proc.c
index 02ff567..07864ec 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -19,8 +19,37 @@
 #include <linux/rwsem.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 
+static struct ctl_table crypto_sysctl_table[] = {
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "fips_enabled",
+		.data           = &fips_enabled,
+		.maxlen         = sizeof(int),
+		.mode           = 0444,
+		.proc_handler   = &proc_dointvec
+	},
+	{
+		.ctl_name = 0,
+	},
+};
+
+static struct ctl_table crypto_dir_table[] = {
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "crypto",
+		.mode           = 0555,
+		.child          = crypto_sysctl_table
+	},
+	{
+		.ctl_name = 0,
+	},
+};
+
+static struct ctl_table_header *crypto_sysctls;
+
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	down_read(&crypto_alg_sem);
@@ -100,9 +129,12 @@ static const struct file_operations proc_crypto_ops = {
 void __init crypto_init_proc(void)
 {
 	proc_create("crypto", 0, NULL, &proc_crypto_ops);
+	crypto_sysctls = register_sysctl_table(crypto_dir_table);
 }
 
 void __exit crypto_exit_proc(void)
 {
 	remove_proc_entry("crypto", NULL);
+	if (crypto_sysctls)
+		unregister_sysctl_table(crypto_sysctls);
 }
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
