From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add fips_enable flag
Date: Tue, 19 Aug 2008 17:55:35 +1000
Message-ID: <20080819075535.GA5411@gondor.apana.org.au>
References: <20080730203407.GA14674@hmsreliant.think-freely.org> <20080805061422.GA19801@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46483 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752591AbYHSH5z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Aug 2008 03:57:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KVM6D-0004QW-OB
	for <linux-crypto@vger.kernel.org>; Tue, 19 Aug 2008 17:57:54 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KVM6D-0002hZ-00
	for <linux-crypto@vger.kernel.org>; Tue, 19 Aug 2008 17:57:53 +1000
Content-Disposition: inline
In-Reply-To: <20080805061422.GA19801@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 05, 2008 at 02:14:22PM +0800, Herbert Xu wrote:
> 
> So I've added an EXPORT_SYMBOL_GPL on it and applied to cryptodev-2.6.

I've moved fips_enabled into its own file because the crypto API
can be built as a module.  I've also added a Kconfig option so
this has no impact on non-FIPS users.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a985065..e26512e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -21,6 +21,14 @@ if CRYPTO
 
 comment "Crypto core or helper"
 
+config CRYPTO_FIPS
+	bool
+	help
+	  This options enables the fips boot option which is
+	  required if you want to system to operate in a FIPS 200
+	  certification.  You should say no unless you know what
+	  this is.
+
 config CRYPTO_ALGAPI
 	tristate
 	help
diff --git a/crypto/Makefile b/crypto/Makefile
index ed2be05..e3ce913 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -5,6 +5,8 @@
 obj-$(CONFIG_CRYPTO) += crypto.o
 crypto-objs := api.o cipher.o digest.o compress.o
 
+obj-$(CONFIG_FIPS) += fips.o
+
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
diff --git a/crypto/api.c b/crypto/api.c
index cd232d4..0444d24 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -493,19 +493,5 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
-int fips_enabled;
-EXPORT_SYMBOL_GPL(fips_enabled);
-
-/* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
-static int fips_enable(char *str)
-{
-	fips_enabled = !!simple_strtol(str, NULL, 0);
-	printk(KERN_INFO "fips mode: %s\n",
-		fips_enabled ? "enabled" : "disabled");
-	return 1;
-}
-
-__setup("fips=", fips_enable);
-
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/fips.c b/crypto/fips.c
new file mode 100644
index 0000000..070a18e
--- /dev/null
+++ b/crypto/fips.c
@@ -0,0 +1,27 @@
+/*
+ * FIPS 200 support.
+ *
+ * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#include "internal.h"
+
+int fips_enabled;
+EXPORT_SYMBOL_GPL(fips_enabled);
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
diff --git a/crypto/internal.h b/crypto/internal.h
index b7fcd30..8ef72d7 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -26,7 +26,11 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 
+#ifdef CONFIG_CRYPTO_FIPS
 extern int fips_enabled;
+#else
+#define fips_enabled 0
+#endif
 
 /* Crypto notification events. */
 enum {
diff --git a/crypto/proc.c b/crypto/proc.c
index 29601dc..37a13d0 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -22,6 +22,7 @@
 #include <linux/sysctl.h>
 #include "internal.h"
 
+#ifdef CONFIG_CRYPTO_FIPS
 static struct ctl_table crypto_sysctl_table[] = {
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -50,6 +51,21 @@ static struct ctl_table crypto_dir_table[] = {
 
 static struct ctl_table_header *crypto_sysctls;
 
+static void crypto_proc_fips_init(void)
+{
+	crypto_sysctls = register_sysctl_table(crypto_dir_table);
+}
+
+static void crypto_proc_fips_exit(void)
+{
+	if (crypto_sysctls)
+		unregister_sysctl_table(crypto_sysctls);
+}
+#else
+#define crypto_proc_fips_init()
+#define crypto_proc_fips_exit()
+#endif
+
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	down_read(&crypto_alg_sem);
@@ -135,12 +151,11 @@ static const struct file_operations proc_crypto_ops = {
 void __init crypto_init_proc(void)
 {
 	proc_create("crypto", 0, NULL, &proc_crypto_ops);
-	crypto_sysctls = register_sysctl_table(crypto_dir_table);
+	crypto_proc_fips_init();
 }
 
 void __exit crypto_exit_proc(void)
 {
+	crypto_proc_fips_exit();
 	remove_proc_entry("crypto", NULL);
-	if (crypto_sysctls)
-		unregister_sysctl_table(crypto_sysctls);
 }
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 56f23a0..e0744c1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -699,6 +699,7 @@ config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
 	select CRYPTO_AES
 	select CRYPTO_RNG
+	select CRYPTO_FIPS
 	help
 	  This option enables the generic pseudo random number generator
 	  for cryptographic modules.  Uses the Algorithm specified in
