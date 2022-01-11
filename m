Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA05C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 06:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiAKG0P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 01:26:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59322 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234767AbiAKG0O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 01:26:14 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n7Abj-0007jC-CO; Tue, 11 Jan 2022 17:26:12 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jan 2022 17:26:11 +1100
Date:   Tue, 11 Jan 2022 17:26:11 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: testmgr - Move crypto_simd_disabled_for_test out
Message-ID: <Yd0jA4VOjysrdOu7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As testmgr is part of cryptomgr which was designed to be unloadable
as a module, it shouldn't export any symbols for other crypto
modules to use as that would prevent it from being unloaded.  All
its functionality is meant to be accessed through notifiers.

The symbol crypto_simd_disabled_for_test was added to testmgr
which caused it to be pinned as a module if its users were also
loaded.  This patch moves it out of testmgr and into crypto/simd.c
so cryptomgr can again be unloaded and replaced on demand.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/simd.c b/crypto/simd.c
index edaa479a1ec5..2027d747b746 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -47,6 +47,11 @@ struct simd_skcipher_ctx {
 	struct cryptd_skcipher *cryptd_tfm;
 };
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
+EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
+#endif
+
 static int simd_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				unsigned int key_len)
 {
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5831d4bbc64f..3a5a3e5cb77b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -55,9 +55,6 @@ MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
-
-DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
-EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
 #endif
 
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
