From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6.25 patch] crypto/ section fixes
Date: Sat, 8 Mar 2008 23:51:40 +0200
Message-ID: <20080308215140.GC12621@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60559 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYCHVvz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Mar 2008 16:51:55 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the following issues introduced by
commit 76fc60a2e3c6aa6e98cd3a5cb81a1855c637b274:
- the exports of {chainiv,eseqiv}_module_{init,exit} are unneeded
- calling {chainiv,eseqiv}_module_init from a module would anyway have 
  resulted in an Oops
- chainiv_module_exit() mustn't be exit since it's now called from 
  the __init blkcipher_module_init()

On architectures that discard __exit code at build time these issues led 
to build errors.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 crypto/chainiv.c                   |    4 +---
 crypto/eseqiv.c                    |    2 --
 include/crypto/internal/skcipher.h |    2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

320c91127c5a53a109feda13c9e29c72df0edac0 foobar
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 0a7cac6..6da3f57 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -318,10 +318,8 @@ int __init chainiv_module_init(void)
 {
 	return crypto_register_template(&chainiv_tmpl);
 }
-EXPORT_SYMBOL_GPL(chainiv_module_init);
 
-void __exit chainiv_module_exit(void)
+void chainiv_module_exit(void)
 {
 	crypto_unregister_template(&chainiv_tmpl);
 }
-EXPORT_SYMBOL_GPL(chainiv_module_exit);
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 6f2cd06..b14f14e 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -251,10 +251,8 @@ int __init eseqiv_module_init(void)
 {
 	return crypto_register_template(&eseqiv_tmpl);
 }
-EXPORT_SYMBOL_GPL(eseqiv_module_init);
 
 void __exit eseqiv_module_exit(void)
 {
 	crypto_unregister_template(&eseqiv_tmpl);
 }
-EXPORT_SYMBOL_GPL(eseqiv_module_exit);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a8f1264..ccc32ba 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -68,7 +68,7 @@ void skcipher_geniv_exit(struct crypto_tfm *tfm);
 int __init eseqiv_module_init(void);
 void __exit eseqiv_module_exit(void);
 int __init chainiv_module_init(void);
-void __exit chainiv_module_exit(void);
+void chainiv_module_exit(void);
 
 static inline struct crypto_ablkcipher *skcipher_geniv_cipher(
 	struct crypto_ablkcipher *geniv)

