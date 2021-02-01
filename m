Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B7DC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD94564EA0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBASDm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhBASDk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:03:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCD8564E9C;
        Mon,  1 Feb 2021 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202578;
        bh=Cblu8CfYjFM2YPqZbDa2JAyKI5piJKhKuLA3RKBQTZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dg97IkBOCwBPLpHrBQt4KG5TJihWT/ZQJ+SzgeeqftVu99Su8RI4CZQ3HPGlfaiB+
         U4J/J+0dMi1hpyrGZmjBFSc6IW1SFHJInHW0LPyTD1aI2B830m1RVBg+4Iiip0LrTy
         vKh07Engaay+2MtbmilsNWLXaS2JiZc1gPPxE6vlOiHhGB4uw7rCusCtrqEMDaz/gi
         8svyn204PFvum9YwcAE96V1pkFnqT6RaavmHdxDqSrwGd3kNyRgDwb80RScevQSSA+
         BTCvmKIAHvKmNmrIbc5xLMIrZ7NItgallC+GP5g1jxYuqea6dv1F9cx3HqilnWYdh9
         2dSfxVkPs4JXw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/9] crypto: serpent - get rid of obsolete tnepres variant
Date:   Mon,  1 Feb 2021 19:02:30 +0100
Message-Id: <20210201180237.3171-3-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It is not trivial to trace back why exactly the tnepres variant of
serpent was added ~17 years ago - Google searches come up mostly empty,
but it seems to be related with the 'kerneli' version, which was based
on an incorrect interpretation of the serpent spec.

In other words, nobody is likely to care anymore today, so let's get rid
of it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig           |  3 +-
 crypto/serpent_generic.c | 82 ++------------------
 crypto/tcrypt.c          |  6 +-
 crypto/testmgr.c         |  6 --
 crypto/testmgr.h         | 79 -------------------
 5 files changed, 7 insertions(+), 169 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9779c7f7531f..15c9c28d9f53 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1460,8 +1460,7 @@ config CRYPTO_SERPENT
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
 
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
-	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
-	  variant of Serpent for compatibility with old kerneli.org code.
+	  of 8 bits.
 
 	  See also:
 	  <https://www.cl.cam.ac.uk/~rja14/serpent.html>
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 492c1d0bfe06..a932e0b2964f 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -5,11 +5,6 @@
  * Serpent Cipher Algorithm.
  *
  * Copyright (C) 2002 Dag Arne Osvik <osvik@ii.uib.no>
- *               2003 Herbert Valerio Riedel <hvr@gnu.org>
- *
- * Added tnepres support:
- *		Ruben Jesus Garcia Hernandez <ruben@ugr.es>, 18.10.2004
- *              Based on code by hvr
  */
 
 #include <linux/init.h>
@@ -576,59 +571,7 @@ static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	__serpent_decrypt(ctx, dst, src);
 }
 
-static int tnepres_setkey(struct crypto_tfm *tfm, const u8 *key,
-			  unsigned int keylen)
-{
-	u8 rev_key[SERPENT_MAX_KEY_SIZE];
-	int i;
-
-	for (i = 0; i < keylen; ++i)
-		rev_key[keylen - i - 1] = key[i];
-
-	return serpent_setkey(tfm, rev_key, keylen);
-}
-
-static void tnepres_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	const u32 * const s = (const u32 * const)src;
-	u32 * const d = (u32 * const)dst;
-
-	u32 rs[4], rd[4];
-
-	rs[0] = swab32(s[3]);
-	rs[1] = swab32(s[2]);
-	rs[2] = swab32(s[1]);
-	rs[3] = swab32(s[0]);
-
-	serpent_encrypt(tfm, (u8 *)rd, (u8 *)rs);
-
-	d[0] = swab32(rd[3]);
-	d[1] = swab32(rd[2]);
-	d[2] = swab32(rd[1]);
-	d[3] = swab32(rd[0]);
-}
-
-static void tnepres_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	const u32 * const s = (const u32 * const)src;
-	u32 * const d = (u32 * const)dst;
-
-	u32 rs[4], rd[4];
-
-	rs[0] = swab32(s[3]);
-	rs[1] = swab32(s[2]);
-	rs[2] = swab32(s[1]);
-	rs[3] = swab32(s[0]);
-
-	serpent_decrypt(tfm, (u8 *)rd, (u8 *)rs);
-
-	d[0] = swab32(rd[3]);
-	d[1] = swab32(rd[2]);
-	d[2] = swab32(rd[1]);
-	d[3] = swab32(rd[0]);
-}
-
-static struct crypto_alg srp_algs[2] = { {
+static struct crypto_alg srp_alg = {
 	.cra_name		=	"serpent",
 	.cra_driver_name	=	"serpent-generic",
 	.cra_priority		=	100,
@@ -643,38 +586,23 @@ static struct crypto_alg srp_algs[2] = { {
 	.cia_setkey		=	serpent_setkey,
 	.cia_encrypt		=	serpent_encrypt,
 	.cia_decrypt		=	serpent_decrypt } }
-}, {
-	.cra_name		=	"tnepres",
-	.cra_driver_name	=	"tnepres-generic",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	SERPENT_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct serpent_ctx),
-	.cra_alignmask		=	3,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	SERPENT_MIN_KEY_SIZE,
-	.cia_max_keysize	=	SERPENT_MAX_KEY_SIZE,
-	.cia_setkey		=	tnepres_setkey,
-	.cia_encrypt		=	tnepres_encrypt,
-	.cia_decrypt		=	tnepres_decrypt } }
-} };
+};
 
 static int __init serpent_mod_init(void)
 {
-	return crypto_register_algs(srp_algs, ARRAY_SIZE(srp_algs));
+	return crypto_register_alg(&srp_alg);
 }
 
 static void __exit serpent_mod_fini(void)
 {
-	crypto_unregister_algs(srp_algs, ARRAY_SIZE(srp_algs));
+	crypto_unregister_alg(&srp_alg);
 }
 
 subsys_initcall(serpent_mod_init);
 module_exit(serpent_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Serpent and tnepres (kerneli compatible serpent reversed) Cipher Algorithm");
+MODULE_DESCRIPTION("Serpent Cipher Algorithm");
 MODULE_AUTHOR("Dag Arne Osvik <osvik@ii.uib.no>");
-MODULE_ALIAS_CRYPTO("tnepres");
 MODULE_ALIAS_CRYPTO("serpent");
 MODULE_ALIAS_CRYPTO("serpent-generic");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2877b88cfa45..6b7c158dc508 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -70,7 +70,7 @@ static const char *check[] = {
 	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256", "sm3",
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
-	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
+	"khazad", "wp512", "wp384", "wp256", "xeta",  "fcrypt",
 	"camellia", "seed", "rmd160",
 	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
 	"sha3-512", "streebog256", "streebog512",
@@ -1806,10 +1806,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("wp256");
 		break;
 
-	case 25:
-		ret += tcrypt_test("ecb(tnepres)");
-		break;
-
 	case 26:
 		ret += tcrypt_test("ecb(anubis)");
 		ret += tcrypt_test("cbc(anubis)");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1a4103b1b202..93359999c94b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4876,12 +4876,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.cipher = __VECS(tea_tv_template)
 		}
-	}, {
-		.alg = "ecb(tnepres)",
-		.test = alg_test_skcipher,
-		.suite = {
-			.cipher = __VECS(tnepres_tv_template)
-		}
 	}, {
 		.alg = "ecb(twofish)",
 		.test = alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 99aca08263d2..ced56ea0c9b4 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -11415,85 +11415,6 @@ static const struct cipher_testvec serpent_tv_template[] = {
 	},
 };
 
-static const struct cipher_testvec tnepres_tv_template[] = {
-	{ /* KeySize=0 */
-		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ctext	= "\x41\xcc\x6b\x31\x59\x31\x45\x97"
-			  "\x6d\x6f\xbb\x38\x4b\x37\x21\x28",
-		.len	= 16,
-	},
-	{ /* KeySize=128, PT=0, I=1 */
-		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.key    = "\x80\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.klen   = 16,
-		.ctext	= "\x49\xaf\xbf\xad\x9d\x5a\x34\x05"
-			  "\x2c\xd8\xff\xa5\x98\x6b\xd2\xdd",
-		.len	= 16,
-	}, { /* KeySize=128 */
-		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.klen	= 16,
-		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ctext	= "\xea\xf4\xd7\xfc\xd8\x01\x34\x47"
-			  "\x81\x45\x0b\xfa\x0c\xd6\xad\x6e",
-		.len	= 16,
-	}, { /* KeySize=128, I=121 */
-		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80",
-		.klen	= 16,
-		.ptext	= zeroed_string,
-		.ctext	= "\x3d\xda\xbf\xc0\x06\xda\xab\x06"
-			  "\x46\x2a\xf4\xef\x81\x54\x4e\x26",
-		.len	= 16,
-	}, { /* KeySize=192, PT=0, I=1 */
-		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.klen	= 24,
-		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ctext	= "\xe7\x8e\x54\x02\xc7\x19\x55\x68"
-			  "\xac\x36\x78\xf7\xa3\xf6\x0c\x66",
-		.len	= 16,
-	}, { /* KeySize=256, PT=0, I=1 */
-		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.klen	= 32,
-		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ctext	= "\xab\xed\x96\xe7\x66\xbf\x28\xcb"
-			  "\xc0\xeb\xd2\x1a\x82\xef\x08\x19",
-		.len	= 16,
-	}, { /* KeySize=256, I=257 */
-		.key	= "\x1f\x1e\x1d\x1c\x1b\x1a\x19\x18"
-			  "\x17\x16\x15\x14\x13\x12\x11\x10"
-			  "\x0f\x0e\x0d\x0c\x0b\x0a\x09\x08"
-			  "\x07\x06\x05\x04\x03\x02\x01\x00",
-		.klen	= 32,
-		.ptext	= "\x0f\x0e\x0d\x0c\x0b\x0a\x09\x08"
-			  "\x07\x06\x05\x04\x03\x02\x01\x00",
-		.ctext	= "\x5c\xe7\x1c\x70\xd2\x88\x2e\x5b"
-			  "\xb8\x32\xe4\x33\xf8\x9f\x26\xde",
-		.len	= 16,
-	}, { /* KeySize=256 */
-		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
-			  "\x10\x11\x12\x13\x14\x15\x16\x17"
-			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
-		.klen	= 32,
-		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ctext	= "\x64\xa9\x1a\x37\xed\x9f\xe7\x49"
-			  "\xa8\x4e\x76\xd6\xf5\x0d\x78\xee",
-		.len	= 16,
-	}
-};
-
 static const struct cipher_testvec serpent_cbc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
-- 
2.20.1

