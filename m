Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAFCC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25EC520652
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045256;
	bh=9vI72+Nt5VNbY58nueUpnPxJukR9bFw2TuItPZRzzd8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hgIeZEIIupgKrrmOQeEvP+kdZvBi/B2gPFLa1Isg65WtwRd/8ZaAs51Gm19OhKGKT
	 vStWxTF6gMDzASrrGF5Ft7wjNliUddHHjcp8LjttfUhA03SZ2D71ew4hoWN9fNglns
	 FrVRUTcmq0bPMSoqKa2BJBZQ1c3DyFY1omhXaPuY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfDLFAy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbfDLFAx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:53 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27768218C3;
        Fri, 12 Apr 2019 05:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045251;
        bh=9vI72+Nt5VNbY58nueUpnPxJukR9bFw2TuItPZRzzd8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=J8J5H2H+TDAncL/H5wBXD8wdLS0bl4dTgrHfxJSKCXc8bGizEmBrpk9tNsjXDqAo2
         FweFFZjQIlMThOCTZF0UJeuS5trzM8L53Sj/WaUNB38HYJbsfRpa51ejyil4tiyl/U
         IOg8AaRWOU09K564+mFqxTH7rxTGbLN97U5Wbnyo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 7/7] crypto: run initcalls for generic implementations earlier
Date:   Thu, 11 Apr 2019 21:57:42 -0700
Message-Id: <20190412045742.1725-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
References: <20190412045742.1725-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use subsys_initcall for registration of all templates and generic
algorithm implementations, rather than module_init.  Then change
cryptomgr to use arch_initcall, to place it before the subsys_initcalls.

This is needed so that when both a generic and optimized implementation
of an algorithm are built into the kernel (not loadable modules), the
generic implementation is registered before the optimized one.
Otherwise, the self-tests for the optimized implementation are unable to
allocate the generic implementation for the new comparison fuzz tests.

Note that on arm, a side effect of this change is that self-tests for
generic implementations may run before the unaligned access handler has
been installed.  So, unaligned accesses will crash the kernel.  This is
arguably a good thing as it makes it easier to detect that type of bug.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/842.c                 | 2 +-
 crypto/adiantum.c            | 2 +-
 crypto/aegis128.c            | 2 +-
 crypto/aegis128l.c           | 2 +-
 crypto/aegis256.c            | 2 +-
 crypto/aes_generic.c         | 2 +-
 crypto/algboss.c             | 8 +++++++-
 crypto/ansi_cprng.c          | 2 +-
 crypto/anubis.c              | 2 +-
 crypto/arc4.c                | 2 +-
 crypto/authenc.c             | 2 +-
 crypto/authencesn.c          | 2 +-
 crypto/blowfish_generic.c    | 2 +-
 crypto/camellia_generic.c    | 2 +-
 crypto/cast5_generic.c       | 2 +-
 crypto/cast6_generic.c       | 2 +-
 crypto/cbc.c                 | 2 +-
 crypto/ccm.c                 | 2 +-
 crypto/cfb.c                 | 2 +-
 crypto/chacha20poly1305.c    | 2 +-
 crypto/chacha_generic.c      | 2 +-
 crypto/cmac.c                | 2 +-
 crypto/crc32_generic.c       | 2 +-
 crypto/crc32c_generic.c      | 2 +-
 crypto/crct10dif_generic.c   | 2 +-
 crypto/crypto_null.c         | 2 +-
 crypto/ctr.c                 | 2 +-
 crypto/cts.c                 | 2 +-
 crypto/deflate.c             | 2 +-
 crypto/des_generic.c         | 2 +-
 crypto/dh.c                  | 2 +-
 crypto/drbg.c                | 2 +-
 crypto/ecb.c                 | 2 +-
 crypto/ecdh.c                | 2 +-
 crypto/echainiv.c            | 2 +-
 crypto/fcrypt.c              | 2 +-
 crypto/fips.c                | 2 +-
 crypto/gcm.c                 | 2 +-
 crypto/ghash-generic.c       | 2 +-
 crypto/hmac.c                | 2 +-
 crypto/jitterentropy-kcapi.c | 2 +-
 crypto/keywrap.c             | 2 +-
 crypto/khazad.c              | 2 +-
 crypto/lrw.c                 | 2 +-
 crypto/lz4.c                 | 2 +-
 crypto/lz4hc.c               | 2 +-
 crypto/lzo-rle.c             | 2 +-
 crypto/lzo.c                 | 2 +-
 crypto/md4.c                 | 2 +-
 crypto/md5.c                 | 2 +-
 crypto/michael_mic.c         | 2 +-
 crypto/morus1280.c           | 2 +-
 crypto/morus640.c            | 2 +-
 crypto/nhpoly1305.c          | 2 +-
 crypto/ofb.c                 | 2 +-
 crypto/pcbc.c                | 2 +-
 crypto/pcrypt.c              | 2 +-
 crypto/poly1305_generic.c    | 2 +-
 crypto/rmd128.c              | 2 +-
 crypto/rmd160.c              | 2 +-
 crypto/rmd256.c              | 2 +-
 crypto/rmd320.c              | 2 +-
 crypto/rsa.c                 | 2 +-
 crypto/salsa20_generic.c     | 2 +-
 crypto/seed.c                | 2 +-
 crypto/seqiv.c               | 2 +-
 crypto/serpent_generic.c     | 2 +-
 crypto/sha1_generic.c        | 2 +-
 crypto/sha256_generic.c      | 2 +-
 crypto/sha3_generic.c        | 2 +-
 crypto/sha512_generic.c      | 2 +-
 crypto/sm3_generic.c         | 2 +-
 crypto/sm4_generic.c         | 2 +-
 crypto/streebog_generic.c    | 2 +-
 crypto/tcrypt.c              | 2 +-
 crypto/tea.c                 | 2 +-
 crypto/tgr192.c              | 2 +-
 crypto/twofish_generic.c     | 2 +-
 crypto/vmac.c                | 2 +-
 crypto/wp512.c               | 2 +-
 crypto/xcbc.c                | 2 +-
 crypto/xts.c                 | 2 +-
 crypto/zstd.c                | 2 +-
 83 files changed, 89 insertions(+), 83 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index bc26dc942821c..5f98393b65d1e 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -144,7 +144,7 @@ static int __init crypto842_mod_init(void)
 
 	return ret;
 }
-module_init(crypto842_mod_init);
+subsys_initcall(crypto842_mod_init);
 
 static void __exit crypto842_mod_exit(void)
 {
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 5564e73266a6a..e6de50f669aa7 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -659,7 +659,7 @@ static void __exit adiantum_module_exit(void)
 	crypto_unregister_template(&adiantum_tmpl);
 }
 
-module_init(adiantum_module_init);
+subsys_initcall(adiantum_module_init);
 module_exit(adiantum_module_exit);
 
 MODULE_DESCRIPTION("Adiantum length-preserving encryption mode");
diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index 3718a83413032..d78f77fc5dd18 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -448,7 +448,7 @@ static void __exit crypto_aegis128_module_exit(void)
 	crypto_unregister_aead(&crypto_aegis128_alg);
 }
 
-module_init(crypto_aegis128_module_init);
+subsys_initcall(crypto_aegis128_module_init);
 module_exit(crypto_aegis128_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
index 275a8616d71bd..9bca3d619a22b 100644
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -512,7 +512,7 @@ static void __exit crypto_aegis128l_module_exit(void)
 	crypto_unregister_aead(&crypto_aegis128l_alg);
 }
 
-module_init(crypto_aegis128l_module_init);
+subsys_initcall(crypto_aegis128l_module_init);
 module_exit(crypto_aegis128l_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/aegis256.c b/crypto/aegis256.c
index ecd6b7f34a2d2..b47fd39595ad7 100644
--- a/crypto/aegis256.c
+++ b/crypto/aegis256.c
@@ -463,7 +463,7 @@ static void __exit crypto_aegis256_module_exit(void)
 	crypto_unregister_aead(&crypto_aegis256_alg);
 }
 
-module_init(crypto_aegis256_module_init);
+subsys_initcall(crypto_aegis256_module_init);
 module_exit(crypto_aegis256_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index fddcbe3edb0a6..f217568917e42 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1470,7 +1470,7 @@ static void __exit aes_fini(void)
 	crypto_unregister_alg(&aes_alg);
 }
 
-module_init(aes_init);
+subsys_initcall(aes_init);
 module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 527b44d0af21b..bb97cfb388367 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -296,7 +296,13 @@ static void __exit cryptomgr_exit(void)
 	BUG_ON(err);
 }
 
-subsys_initcall(cryptomgr_init);
+/*
+ * This is arch_initcall() so that the crypto self-tests are run on algorithms
+ * registered early by subsys_initcall().  subsys_initcall() is needed for
+ * generic implementations so that they're available for comparison tests when
+ * other implementations are registered later by module_init().
+ */
+arch_initcall(cryptomgr_init);
 module_exit(cryptomgr_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index eff337ce90037..e7c43ea4ce9d1 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -472,7 +472,7 @@ MODULE_DESCRIPTION("Software Pseudo Random Number Generator");
 MODULE_AUTHOR("Neil Horman <nhorman@tuxdriver.com>");
 module_param(dbg, int, 0);
 MODULE_PARM_DESC(dbg, "Boolean to enable debugging (0/1 == off/on)");
-module_init(prng_mod_init);
+subsys_initcall(prng_mod_init);
 module_exit(prng_mod_fini);
 MODULE_ALIAS_CRYPTO("stdrng");
 MODULE_ALIAS_CRYPTO("ansi_cprng");
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 4bb187c2a9027..673927de0eb92 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -699,7 +699,7 @@ static void __exit anubis_mod_fini(void)
 	crypto_unregister_alg(&anubis_alg);
 }
 
-module_init(anubis_mod_init);
+subsys_initcall(anubis_mod_init);
 module_exit(anubis_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/arc4.c b/crypto/arc4.c
index 6c93342e3405b..2233d36456e27 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -163,7 +163,7 @@ static void __exit arc4_exit(void)
 	crypto_unregister_skcipher(&arc4_skcipher);
 }
 
-module_init(arc4_init);
+subsys_initcall(arc4_init);
 module_exit(arc4_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 4be293a4b5f0f..b3eddac7fa3a4 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -508,7 +508,7 @@ static void __exit crypto_authenc_module_exit(void)
 	crypto_unregister_template(&crypto_authenc_tmpl);
 }
 
-module_init(crypto_authenc_module_init);
+subsys_initcall(crypto_authenc_module_init);
 module_exit(crypto_authenc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 4741fe89ba2cd..58074308e5350 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -523,7 +523,7 @@ static void __exit crypto_authenc_esn_module_exit(void)
 	crypto_unregister_template(&crypto_authenc_esn_tmpl);
 }
 
-module_init(crypto_authenc_esn_module_init);
+subsys_initcall(crypto_authenc_esn_module_init);
 module_exit(crypto_authenc_esn_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/blowfish_generic.c b/crypto/blowfish_generic.c
index 87b392a77a939..8548ced8b0741 100644
--- a/crypto/blowfish_generic.c
+++ b/crypto/blowfish_generic.c
@@ -133,7 +133,7 @@ static void __exit blowfish_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-module_init(blowfish_mod_init);
+subsys_initcall(blowfish_mod_init);
 module_exit(blowfish_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 32ddd4836ff55..15ce1281f5d9c 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -1092,7 +1092,7 @@ static void __exit camellia_fini(void)
 	crypto_unregister_alg(&camellia_alg);
 }
 
-module_init(camellia_init);
+subsys_initcall(camellia_init);
 module_exit(camellia_fini);
 
 MODULE_DESCRIPTION("Camellia Cipher Algorithm");
diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
index 66169c1783148..24bc7d4e33be0 100644
--- a/crypto/cast5_generic.c
+++ b/crypto/cast5_generic.c
@@ -543,7 +543,7 @@ static void __exit cast5_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-module_init(cast5_mod_init);
+subsys_initcall(cast5_mod_init);
 module_exit(cast5_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index c8e5ec69790e2..edd59cc349919 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -285,7 +285,7 @@ static void __exit cast6_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-module_init(cast6_mod_init);
+subsys_initcall(cast6_mod_init);
 module_exit(cast6_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cbc.c b/crypto/cbc.c
index d12efaac9230b..129f79d033658 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -98,7 +98,7 @@ static void __exit crypto_cbc_module_exit(void)
 	crypto_unregister_template(&crypto_cbc_tmpl);
 }
 
-module_init(crypto_cbc_module_init);
+subsys_initcall(crypto_cbc_module_init);
 module_exit(crypto_cbc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ccm.c b/crypto/ccm.c
index dbb3b6d8e6136..1d6c58287de1e 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -1005,7 +1005,7 @@ static void __exit crypto_ccm_module_exit(void)
 				    ARRAY_SIZE(crypto_ccm_tmpls));
 }
 
-module_init(crypto_ccm_module_init);
+subsys_initcall(crypto_ccm_module_init);
 module_exit(crypto_ccm_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cfb.c b/crypto/cfb.c
index 03ac847f6d6ab..7b68fbb617324 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -243,7 +243,7 @@ static void __exit crypto_cfb_module_exit(void)
 	crypto_unregister_template(&crypto_cfb_tmpl);
 }
 
-module_init(crypto_cfb_module_init);
+subsys_initcall(crypto_cfb_module_init);
 module_exit(crypto_cfb_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 279d816ab51dd..e38a2d61819a7 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -725,7 +725,7 @@ static void __exit chacha20poly1305_module_exit(void)
 				    ARRAY_SIZE(rfc7539_tmpls));
 }
 
-module_init(chacha20poly1305_module_init);
+subsys_initcall(chacha20poly1305_module_init);
 module_exit(chacha20poly1305_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index a7fae9b73ec4e..d2ec04997832e 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -201,7 +201,7 @@ static void __exit chacha_generic_mod_fini(void)
 	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-module_init(chacha_generic_mod_init);
+subsys_initcall(chacha_generic_mod_init);
 module_exit(chacha_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 16301f52858ca..c60b6c011ec60 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -313,7 +313,7 @@ static void __exit crypto_cmac_module_exit(void)
 	crypto_unregister_template(&crypto_cmac_tmpl);
 }
 
-module_init(crypto_cmac_module_init);
+subsys_initcall(crypto_cmac_module_init);
 module_exit(crypto_cmac_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/crc32_generic.c b/crypto/crc32_generic.c
index 00facd27bcc29..9e97912280bdf 100644
--- a/crypto/crc32_generic.c
+++ b/crypto/crc32_generic.c
@@ -146,7 +146,7 @@ static void __exit crc32_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(crc32_mod_init);
+subsys_initcall(crc32_mod_init);
 module_exit(crc32_mod_fini);
 
 MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index 7283066ecc982..ad26f15d4c7b3 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -165,7 +165,7 @@ static void __exit crc32c_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(crc32c_mod_init);
+subsys_initcall(crc32c_mod_init);
 module_exit(crc32c_mod_fini);
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index d08048ae55527..d90c0070710e8 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -112,7 +112,7 @@ static void __exit crct10dif_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(crct10dif_mod_init);
+subsys_initcall(crct10dif_mod_init);
 module_exit(crct10dif_mod_fini);
 
 MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 01630a9c7e011..9320d4eaa4a8a 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -220,7 +220,7 @@ static void __exit crypto_null_mod_fini(void)
 	crypto_unregister_skcipher(&skcipher_null);
 }
 
-module_init(crypto_null_mod_init);
+subsys_initcall(crypto_null_mod_init);
 module_exit(crypto_null_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ctr.c b/crypto/ctr.c
index ec8f8b67473a0..52cdf2c5605fb 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -384,7 +384,7 @@ static void __exit crypto_ctr_module_exit(void)
 				    ARRAY_SIZE(crypto_ctr_tmpls));
 }
 
-module_init(crypto_ctr_module_init);
+subsys_initcall(crypto_ctr_module_init);
 module_exit(crypto_ctr_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/cts.c b/crypto/cts.c
index 9441da797bb90..6b6087dbb62a2 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -423,7 +423,7 @@ static void __exit crypto_cts_module_exit(void)
 	crypto_unregister_template(&crypto_cts_tmpl);
 }
 
-module_init(crypto_cts_module_init);
+subsys_initcall(crypto_cts_module_init);
 module_exit(crypto_cts_module_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 94ec3b36a8e83..aab089cde1bf8 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -334,7 +334,7 @@ static void __exit deflate_mod_fini(void)
 	crypto_unregister_scomps(scomp, ARRAY_SIZE(scomp));
 }
 
-module_init(deflate_mod_init);
+subsys_initcall(deflate_mod_init);
 module_exit(deflate_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 1e6621665dd92..9efebe47f8f0a 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -993,7 +993,7 @@ static void __exit des_generic_mod_fini(void)
 	crypto_unregister_algs(des_algs, ARRAY_SIZE(des_algs));
 }
 
-module_init(des_generic_mod_init);
+subsys_initcall(des_generic_mod_init);
 module_exit(des_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/dh.c b/crypto/dh.c
index 09a44de4209d1..ce77fb4ee8b32 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -236,7 +236,7 @@ static void dh_exit(void)
 	crypto_unregister_kpp(&dh);
 }
 
-module_init(dh_init);
+subsys_initcall(dh_init);
 module_exit(dh_exit);
 MODULE_ALIAS_CRYPTO("dh");
 MODULE_LICENSE("GPL");
diff --git a/crypto/drbg.c b/crypto/drbg.c
index bc52d95626110..710b3046a4df2 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2039,7 +2039,7 @@ static void __exit drbg_exit(void)
 	crypto_unregister_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
-module_init(drbg_init);
+subsys_initcall(drbg_init);
 module_exit(drbg_exit);
 #ifndef CRYPTO_DRBG_HASH_STRING
 #define CRYPTO_DRBG_HASH_STRING ""
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 0732715c8d915..de839129d151c 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -101,7 +101,7 @@ static void __exit crypto_ecb_module_exit(void)
 	crypto_unregister_template(&crypto_ecb_tmpl);
 }
 
-module_init(crypto_ecb_module_init);
+subsys_initcall(crypto_ecb_module_init);
 module_exit(crypto_ecb_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index bf6300175b9cd..890092bd89899 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -166,7 +166,7 @@ static void ecdh_exit(void)
 	crypto_unregister_kpp(&ecdh);
 }
 
-module_init(ecdh_init);
+subsys_initcall(ecdh_init);
 module_exit(ecdh_exit);
 MODULE_ALIAS_CRYPTO("ecdh");
 MODULE_LICENSE("GPL");
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 77e607fdbfb73..e71d1bc8d850d 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -174,7 +174,7 @@ static void __exit echainiv_module_exit(void)
 	crypto_unregister_template(&echainiv_tmpl);
 }
 
-module_init(echainiv_module_init);
+subsys_initcall(echainiv_module_init);
 module_exit(echainiv_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 77286ea28865b..4e8704405a3b9 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -414,7 +414,7 @@ static void __exit fcrypt_mod_fini(void)
 	crypto_unregister_alg(&fcrypt_alg);
 }
 
-module_init(fcrypt_mod_init);
+subsys_initcall(fcrypt_mod_init);
 module_exit(fcrypt_mod_fini);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/fips.c b/crypto/fips.c
index 9d627c1cf8bc7..9dfed122d6da9 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -74,5 +74,5 @@ static void __exit fips_exit(void)
 	crypto_proc_fips_exit();
 }
 
-module_init(fips_init);
+subsys_initcall(fips_init);
 module_exit(fips_exit);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index c7354ed1fa4d4..6fd98a4d186dd 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1244,7 +1244,7 @@ static void __exit crypto_gcm_module_exit(void)
 				    ARRAY_SIZE(crypto_gcm_tmpls));
 }
 
-module_init(crypto_gcm_module_init);
+subsys_initcall(crypto_gcm_module_init);
 module_exit(crypto_gcm_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index d9f192b953b22..e6307935413c1 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -149,7 +149,7 @@ static void __exit ghash_mod_exit(void)
 	crypto_unregister_shash(&ghash_alg);
 }
 
-module_init(ghash_mod_init);
+subsys_initcall(ghash_mod_init);
 module_exit(ghash_mod_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/hmac.c b/crypto/hmac.c
index e74730224f0a5..4ceb3f1f0eb84 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -268,7 +268,7 @@ static void __exit hmac_module_exit(void)
 	crypto_unregister_template(&hmac_tmpl);
 }
 
-module_init(hmac_module_init);
+subsys_initcall(hmac_module_init);
 module_exit(hmac_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 787dccca37159..6ea1a270b8dc2 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -198,7 +198,7 @@ static void __exit jent_mod_exit(void)
 	crypto_unregister_rng(&jent_alg);
 }
 
-module_init(jent_mod_init);
+subsys_initcall(jent_mod_init);
 module_exit(jent_mod_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index a5cfe610d8f40..a155c88105ea1 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -310,7 +310,7 @@ static void __exit crypto_kw_exit(void)
 	crypto_unregister_template(&crypto_kw_tmpl);
 }
 
-module_init(crypto_kw_init);
+subsys_initcall(crypto_kw_init);
 module_exit(crypto_kw_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 873eb5ded6d7a..b50aa8a3ab4cf 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -875,7 +875,7 @@ static void __exit khazad_mod_fini(void)
 }
 
 
-module_init(khazad_mod_init);
+subsys_initcall(khazad_mod_init);
 module_exit(khazad_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lrw.c b/crypto/lrw.c
index b6666c595a686..0cc689ab69596 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -433,7 +433,7 @@ static void __exit crypto_module_exit(void)
 	crypto_unregister_template(&crypto_tmpl);
 }
 
-module_init(crypto_module_init);
+subsys_initcall(crypto_module_init);
 module_exit(crypto_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lz4.c b/crypto/lz4.c
index c160dfdbf2e07..1e35134d0a98d 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -164,7 +164,7 @@ static void __exit lz4_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(lz4_mod_init);
+subsys_initcall(lz4_mod_init);
 module_exit(lz4_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 583b5e013d7a5..4a220b628fe7e 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -165,7 +165,7 @@ static void __exit lz4hc_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(lz4hc_mod_init);
+subsys_initcall(lz4hc_mod_init);
 module_exit(lz4hc_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index ea9c75b1db49b..4c82bf18440f0 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -167,7 +167,7 @@ static void __exit lzorle_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(lzorle_mod_init);
+subsys_initcall(lzorle_mod_init);
 module_exit(lzorle_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 218567d717d68..4a6ac8f247d0a 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -167,7 +167,7 @@ static void __exit lzo_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(lzo_mod_init);
+subsys_initcall(lzo_mod_init);
 module_exit(lzo_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/md4.c b/crypto/md4.c
index 9965ec40d9f97..9a1a228a0c695 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -232,7 +232,7 @@ static void __exit md4_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(md4_mod_init);
+subsys_initcall(md4_mod_init);
 module_exit(md4_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/md5.c b/crypto/md5.c
index 94dd78144ba3e..221c2c0932f83 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -244,7 +244,7 @@ static void __exit md5_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(md5_mod_init);
+subsys_initcall(md5_mod_init);
 module_exit(md5_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 46195e0d0f4d1..538ae79337957 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -178,7 +178,7 @@ static void __exit michael_mic_exit(void)
 }
 
 
-module_init(michael_mic_init);
+subsys_initcall(michael_mic_init);
 module_exit(michael_mic_exit);
 
 MODULE_LICENSE("GPL v2");
diff --git a/crypto/morus1280.c b/crypto/morus1280.c
index 0747732d5b78a..f8734c6576af6 100644
--- a/crypto/morus1280.c
+++ b/crypto/morus1280.c
@@ -532,7 +532,7 @@ static void __exit crypto_morus1280_module_exit(void)
 	crypto_unregister_aead(&crypto_morus1280_alg);
 }
 
-module_init(crypto_morus1280_module_init);
+subsys_initcall(crypto_morus1280_module_init);
 module_exit(crypto_morus1280_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/morus640.c b/crypto/morus640.c
index 1617a1eb8be13..ae5aa9482cb45 100644
--- a/crypto/morus640.c
+++ b/crypto/morus640.c
@@ -523,7 +523,7 @@ static void __exit crypto_morus640_module_exit(void)
 	crypto_unregister_aead(&crypto_morus640_alg);
 }
 
-module_init(crypto_morus640_module_init);
+subsys_initcall(crypto_morus640_module_init);
 module_exit(crypto_morus640_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/nhpoly1305.c b/crypto/nhpoly1305.c
index ec831a5594d8f..9ab4e07cde4dc 100644
--- a/crypto/nhpoly1305.c
+++ b/crypto/nhpoly1305.c
@@ -244,7 +244,7 @@ static void __exit nhpoly1305_mod_exit(void)
 	crypto_unregister_shash(&nhpoly1305_alg);
 }
 
-module_init(nhpoly1305_mod_init);
+subsys_initcall(nhpoly1305_mod_init);
 module_exit(nhpoly1305_mod_exit);
 
 MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function");
diff --git a/crypto/ofb.c b/crypto/ofb.c
index 34b6e1f426f7a..133ff4c7f2c67 100644
--- a/crypto/ofb.c
+++ b/crypto/ofb.c
@@ -95,7 +95,7 @@ static void __exit crypto_ofb_module_exit(void)
 	crypto_unregister_template(&crypto_ofb_tmpl);
 }
 
-module_init(crypto_ofb_module_init);
+subsys_initcall(crypto_ofb_module_init);
 module_exit(crypto_ofb_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 2fa03fc576fe4..31b3ce948474e 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -191,7 +191,7 @@ static void __exit crypto_pcbc_module_exit(void)
 	crypto_unregister_template(&crypto_pcbc_tmpl);
 }
 
-module_init(crypto_pcbc_module_init);
+subsys_initcall(crypto_pcbc_module_init);
 module_exit(crypto_pcbc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index d47cfc47b1b1b..0e9ce329fd477 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -512,7 +512,7 @@ static void __exit pcrypt_exit(void)
 	crypto_unregister_template(&pcrypt_tmpl);
 }
 
-module_init(pcrypt_init);
+subsys_initcall(pcrypt_init);
 module_exit(pcrypt_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 2a06874204e87..adc40298c7492 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -318,7 +318,7 @@ static void __exit poly1305_mod_exit(void)
 	crypto_unregister_shash(&poly1305_alg);
 }
 
-module_init(poly1305_mod_init);
+subsys_initcall(poly1305_mod_init);
 module_exit(poly1305_mod_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 5f4472256e272..faf4252c4b856 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -318,7 +318,7 @@ static void __exit rmd128_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(rmd128_mod_init);
+subsys_initcall(rmd128_mod_init);
 module_exit(rmd128_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 737645344d1cb..b33309916d4fe 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -362,7 +362,7 @@ static void __exit rmd160_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(rmd160_mod_init);
+subsys_initcall(rmd160_mod_init);
 module_exit(rmd160_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 0e9d30676a013..2a643250c9a5c 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -337,7 +337,7 @@ static void __exit rmd256_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(rmd256_mod_init);
+subsys_initcall(rmd256_mod_init);
 module_exit(rmd256_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 3ae1df5bb48c8..2f062574fc8c8 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -386,7 +386,7 @@ static void __exit rmd320_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(rmd320_mod_init);
+subsys_initcall(rmd320_mod_init);
 module_exit(rmd320_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4167980c243d4..4019e9af34c34 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -391,7 +391,7 @@ static void rsa_exit(void)
 	crypto_unregister_akcipher(&rsa);
 }
 
-module_init(rsa_init);
+subsys_initcall(rsa_init);
 module_exit(rsa_exit);
 MODULE_ALIAS_CRYPTO("rsa");
 MODULE_LICENSE("GPL");
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index faed244be316f..c81a44404086a 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -203,7 +203,7 @@ static void __exit salsa20_generic_mod_fini(void)
 	crypto_unregister_skcipher(&alg);
 }
 
-module_init(salsa20_generic_mod_init);
+subsys_initcall(salsa20_generic_mod_init);
 module_exit(salsa20_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/seed.c b/crypto/seed.c
index c6ba8438be430..a75ac50fa4fd4 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -470,7 +470,7 @@ static void __exit seed_fini(void)
 	crypto_unregister_alg(&seed_alg);
 }
 
-module_init(seed_init);
+subsys_initcall(seed_init);
 module_exit(seed_fini);
 
 MODULE_DESCRIPTION("SEED Cipher Algorithm");
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index ed1b0e9f24367..3f2fad615d265 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -211,7 +211,7 @@ static void __exit seqiv_module_exit(void)
 	crypto_unregister_template(&seqiv_tmpl);
 }
 
-module_init(seqiv_module_init);
+subsys_initcall(seqiv_module_init);
 module_exit(seqiv_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 7c3382facc82e..ec4ec89ad1085 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -664,7 +664,7 @@ static void __exit serpent_mod_fini(void)
 	crypto_unregister_algs(srp_algs, ARRAY_SIZE(srp_algs));
 }
 
-module_init(serpent_mod_init);
+subsys_initcall(serpent_mod_init);
 module_exit(serpent_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 2af64ef81f402..1b806d4584b2f 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -92,7 +92,7 @@ static void __exit sha1_generic_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(sha1_generic_mod_init);
+subsys_initcall(sha1_generic_mod_init);
 module_exit(sha1_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 1e5ba6649e8db..5844e9a469e8a 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -301,7 +301,7 @@ static void __exit sha256_generic_mod_fini(void)
 	crypto_unregister_shashes(sha256_algs, ARRAY_SIZE(sha256_algs));
 }
 
-module_init(sha256_generic_mod_init);
+subsys_initcall(sha256_generic_mod_init);
 module_exit(sha256_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 7ed98367d4fbb..60fd2be609d8d 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -294,7 +294,7 @@ static void __exit sha3_generic_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-module_init(sha3_generic_mod_init);
+subsys_initcall(sha3_generic_mod_init);
 module_exit(sha3_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 4097cd555eb6b..0193ecb8ae102 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -223,7 +223,7 @@ static void __exit sha512_generic_mod_fini(void)
 	crypto_unregister_shashes(sha512_algs, ARRAY_SIZE(sha512_algs));
 }
 
-module_init(sha512_generic_mod_init);
+subsys_initcall(sha512_generic_mod_init);
 module_exit(sha512_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index c0cf87ae7ef6d..e227bcada2a20 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -199,7 +199,7 @@ static void __exit sm3_generic_mod_fini(void)
 	crypto_unregister_shash(&sm3_alg);
 }
 
-module_init(sm3_generic_mod_init);
+subsys_initcall(sm3_generic_mod_init);
 module_exit(sm3_generic_mod_fini);
 
 MODULE_LICENSE("GPL v2");
diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
index c18eebfd5edda..71ffb343709a5 100644
--- a/crypto/sm4_generic.c
+++ b/crypto/sm4_generic.c
@@ -237,7 +237,7 @@ static void __exit sm4_fini(void)
 	crypto_unregister_alg(&sm4_alg);
 }
 
-module_init(sm4_init);
+subsys_initcall(sm4_init);
 module_exit(sm4_fini);
 
 MODULE_DESCRIPTION("SM4 Cipher Algorithm");
diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index b82fc3d79aa15..63663c3bab7e9 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -1128,7 +1128,7 @@ static void __exit streebog_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-module_init(streebog_mod_init);
+subsys_initcall(streebog_mod_init);
 module_exit(streebog_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ea2d5007ff56..798253f05203e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -3053,7 +3053,7 @@ static int __init tcrypt_mod_init(void)
  */
 static void __exit tcrypt_mod_fini(void) { }
 
-module_init(tcrypt_mod_init);
+subsys_initcall(tcrypt_mod_init);
 module_exit(tcrypt_mod_fini);
 
 module_param(alg, charp, 0);
diff --git a/crypto/tea.c b/crypto/tea.c
index b70b441c7d1e7..786b589e13995 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -274,7 +274,7 @@ MODULE_ALIAS_CRYPTO("tea");
 MODULE_ALIAS_CRYPTO("xtea");
 MODULE_ALIAS_CRYPTO("xeta");
 
-module_init(tea_mod_init);
+subsys_initcall(tea_mod_init);
 module_exit(tea_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index f8e1d9f9938f5..40020f8adc46a 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -677,7 +677,7 @@ MODULE_ALIAS_CRYPTO("tgr192");
 MODULE_ALIAS_CRYPTO("tgr160");
 MODULE_ALIAS_CRYPTO("tgr128");
 
-module_init(tgr192_mod_init);
+subsys_initcall(tgr192_mod_init);
 module_exit(tgr192_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/twofish_generic.c b/crypto/twofish_generic.c
index 07e62433fbfb9..dbac6e2332858 100644
--- a/crypto/twofish_generic.c
+++ b/crypto/twofish_generic.c
@@ -205,7 +205,7 @@ static void __exit twofish_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-module_init(twofish_mod_init);
+subsys_initcall(twofish_mod_init);
 module_exit(twofish_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 5f436dfdfc61e..f50a85060b39f 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -690,7 +690,7 @@ static void __exit vmac_module_exit(void)
 	crypto_unregister_template(&vmac64_tmpl);
 }
 
-module_init(vmac_module_init);
+subsys_initcall(vmac_module_init);
 module_exit(vmac_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 149e577fb7726..1b8e502d999ff 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1168,7 +1168,7 @@ MODULE_ALIAS_CRYPTO("wp512");
 MODULE_ALIAS_CRYPTO("wp384");
 MODULE_ALIAS_CRYPTO("wp256");
 
-module_init(wp512_mod_init);
+subsys_initcall(wp512_mod_init);
 module_exit(wp512_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index c055f57fab11a..94ca694ef091a 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -282,7 +282,7 @@ static void __exit crypto_xcbc_module_exit(void)
 	crypto_unregister_template(&crypto_xcbc_tmpl);
 }
 
-module_init(crypto_xcbc_module_init);
+subsys_initcall(crypto_xcbc_module_init);
 module_exit(crypto_xcbc_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/xts.c b/crypto/xts.c
index 847f54f767897..aed11e63ca315 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -359,7 +359,7 @@ static void __exit crypto_module_exit(void)
 	crypto_unregister_template(&crypto_tmpl);
 }
 
-module_init(crypto_module_init);
+subsys_initcall(crypto_module_init);
 module_exit(crypto_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 9a76b3ed8b8bc..2c04055e407f0 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -257,7 +257,7 @@ static void __exit zstd_mod_fini(void)
 	crypto_unregister_scomp(&scomp);
 }
 
-module_init(zstd_mod_init);
+subsys_initcall(zstd_mod_init);
 module_exit(zstd_mod_fini);
 
 MODULE_LICENSE("GPL");
-- 
2.21.0

