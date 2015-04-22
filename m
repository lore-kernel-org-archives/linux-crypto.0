From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: api - Move module sig ifdef into accessor function
Date: Wed, 22 Apr 2015 11:28:46 +0800
Message-ID: <20150422032846.GA6798@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34210 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbbDVD2v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 23:28:51 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently we're hiding mod->sig_ok under an ifdef in open code.
This patch adds a module_sig_ok accessor function and removes that
ifdef.
    
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8057c9f..c63836f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -44,12 +44,9 @@ static inline int crypto_set_driver_name(struct crypto_alg *alg)
 
 static inline void crypto_check_module_sig(struct module *mod)
 {
-#ifdef CONFIG_CRYPTO_FIPS
-	if (fips_enabled && mod && !mod->sig_ok)
+	if (fips_enabled && mod && !module_sig_ok(mod))
 		panic("Module %s signature verification failed in FIPS mode\n",
 		      mod->name);
-#endif
-	return;
 }
 
 static int crypto_check_alg(struct crypto_alg *alg)
diff --git a/include/linux/module.h b/include/linux/module.h
index c883b86..1e54360 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -655,4 +655,16 @@ static inline void module_bug_finalize(const Elf_Ehdr *hdr,
 static inline void module_bug_cleanup(struct module *mod) {}
 #endif	/* CONFIG_GENERIC_BUG */
 
+#ifdef CONFIG_MODULE_SIG
+static inline bool module_sig_ok(struct module *module)
+{
+	return module->sig_ok;
+}
+#else	/* !CONFIG_MODULE_SIG */
+static inline bool module_sig_ok(struct module *module)
+{
+	return true;
+}
+#endif	/* CONFIG_MODULE_SIG */
+
 #endif /* _LINUX_MODULE_H */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
