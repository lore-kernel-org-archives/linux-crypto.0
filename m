Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C938C2D0C8
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB1E32053B
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577762982;
	bh=1m/VmD0dwb7blDFzT9vtbGUbKWVTgQ3klF0dcASIqlo=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oZoJdnvMiWyA900NohhwDtWs3LJVT1DxD/Pu6GmSe+1nNXWjM0ALqDB3qSqrRnLmc
	 LaL+MPkh9BNLzwdWWsSmvt5YvltXv0ULd+w3BPfp0tebrWOhsGymLewHp/5IxrujqU
	 GVb8eWtRxNpWI/b1U+dG97ZORyvb3nczTY/fbeB8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfLaD3l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:29:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaD3l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 22:29:41 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC0E20730
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 03:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577762458;
        bh=1m/VmD0dwb7blDFzT9vtbGUbKWVTgQ3klF0dcASIqlo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NJp8WirmJuGOesXbvjI+mvuQh3iHsey8elfgwD3sPh2n0MVuLdf+EYRNLYPjzqM0X
         qu8rOiW3LustWOo5RbwDvA1Hv9LaFawGZJgjteJqkAVx9TjUZVzZie8oWGXWOkGS7V
         r0jCK7wgOo6uWAh1xdtmYk+nHuIuxOctEV2yJXlo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 6/8] crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
Date:   Mon, 30 Dec 2019 21:19:36 -0600
Message-Id: <20191231031938.241705-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
References: <20191231031938.241705-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The CRYPTO_TFM_RES_BAD_KEY_LEN flag was apparently meant as a way to
make the ->setkey() functions provide more information about errors.

However, no one actually checks for this flag, which makes it pointless.

Also, many algorithms fail to set this flag when given a bad length key.
Reviewing just the generic implementations, this is the case for
aes-fixed-time, cbcmac, echainiv, nhpoly1305, pcrypt, rfc3686, rfc4309,
rfc7539, rfc7539esp, salsa20, seqiv, and xcbc.  But there are probably
many more in arch/*/crypto/ and drivers/crypto/.

Some algorithms can even set this flag when the key is the correct
length.  For example, authenc and authencesn set it when the key payload
is malformed in any way (not just a bad length), the atmel-sha and ccree
drivers can set it if a memory allocation fails, and the chelsio driver
sets it for bad auth tag lengths, not just bad key lengths.

So even if someone actually wanted to start checking this flag (which
seems unlikely, since it's been unused for a long time), there would be
a lot of work needed to get it working correctly.  But it would probably
be much better to go back to the drawing board and just define different
return values, like -EINVAL if the key is invalid for the algorithm vs.
-EKEYREJECTED if the key was rejected by a policy like "no weak keys".
That would be much simpler, less error-prone, and easier to test.

So just remove this flag.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/aes-ce-glue.c                 | 14 +-----
 arch/arm/crypto/crc32-ce-glue.c               |  4 +-
 arch/arm/crypto/ghash-ce-glue.c               |  4 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c           |  8 +---
 arch/arm64/crypto/aes-ce-glue.c               |  8 +---
 arch/arm64/crypto/aes-glue.c                  | 31 ++----------
 arch/arm64/crypto/ghash-ce-glue.c             |  8 +---
 arch/mips/crypto/crc32-mips.c                 |  4 +-
 arch/powerpc/crypto/aes-spe-glue.c            | 18 ++-----
 arch/powerpc/crypto/crc32c-vpmsum_glue.c      |  4 +-
 arch/s390/crypto/aes_s390.c                   |  4 +-
 arch/s390/crypto/crc32-vx.c                   |  8 +---
 arch/s390/crypto/ghash_s390.c                 |  4 +-
 arch/s390/crypto/paes_s390.c                  | 25 +++-------
 arch/sparc/crypto/aes_glue.c                  |  2 -
 arch/sparc/crypto/camellia_glue.c             |  5 +-
 arch/sparc/crypto/crc32c_glue.c               |  4 +-
 arch/x86/crypto/aegis128-aesni-glue.c         |  4 +-
 arch/x86/crypto/aesni-intel_glue.c            | 10 ++--
 arch/x86/crypto/blake2s-glue.c                |  4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c    |  3 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c     |  9 ++--
 arch/x86/crypto/camellia_glue.c               |  9 ++--
 arch/x86/crypto/cast6_avx_glue.c              |  6 +--
 arch/x86/crypto/crc32-pclmul_glue.c           |  4 +-
 arch/x86/crypto/crc32c-intel_glue.c           |  4 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c    |  4 +-
 arch/x86/crypto/twofish_avx_glue.c            |  6 +--
 arch/x86/include/asm/crypto/camellia.h        |  2 +-
 crypto/aegis128-core.c                        |  4 +-
 crypto/aes_generic.c                          | 18 +++----
 crypto/anubis.c                               |  2 -
 crypto/authenc.c                              |  6 +--
 crypto/authencesn.c                           |  6 +--
 crypto/blake2b_generic.c                      |  4 +-
 crypto/blake2s_generic.c                      |  4 +-
 crypto/camellia_generic.c                     |  5 +-
 crypto/cast6_generic.c                        | 10 ++--
 crypto/cipher.c                               |  4 +-
 crypto/crc32_generic.c                        |  4 +-
 crypto/crc32c_generic.c                       |  4 +-
 crypto/essiv.c                                |  4 +-
 crypto/ghash-generic.c                        |  4 +-
 crypto/michael_mic.c                          |  4 +-
 crypto/skcipher.c                             |  4 +-
 crypto/sm4_generic.c                          | 16 ++-----
 crypto/twofish_common.c                       |  8 +---
 crypto/vmac.c                                 |  4 +-
 crypto/xxhash_generic.c                       |  4 +-
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      |  1 -
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  1 -
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |  2 -
 drivers/crypto/amcc/crypto4xx_alg.c           | 11 ++---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   |  1 -
 drivers/crypto/atmel-aes.c                    |  9 +---
 drivers/crypto/axis/artpec6_crypto.c          |  8 +---
 drivers/crypto/bcm/cipher.c                   |  3 --
 drivers/crypto/caam/caamalg.c                 | 33 +++----------
 drivers/crypto/caam/caamalg_qi.c              | 44 +++++------------
 drivers/crypto/caam/caamalg_qi2.c             | 47 ++++---------------
 drivers/crypto/caam/caamhash.c                |  9 +---
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  2 -
 drivers/crypto/cavium/nitrox/nitrox_aead.c    |  4 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    | 12 ++---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |  1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c    |  1 -
 drivers/crypto/ccp/ccp-crypto-aes.c           |  1 -
 drivers/crypto/ccp/ccp-crypto-sha.c           |  4 +-
 drivers/crypto/ccree/cc_aead.c                | 20 +++-----
 drivers/crypto/ccree/cc_cipher.c              |  3 --
 drivers/crypto/ccree/cc_hash.c                |  6 ---
 drivers/crypto/chelsio/chcr_algo.c            | 16 ++-----
 drivers/crypto/geode-aes.c                    |  8 +---
 .../crypto/inside-secure/safexcel_cipher.c    | 38 +++++----------
 drivers/crypto/inside-secure/safexcel_hash.c  | 16 ++-----
 drivers/crypto/ixp4xx_crypto.c                |  3 --
 drivers/crypto/marvell/cipher.c               |  4 +-
 drivers/crypto/mediatek/mtk-aes.c             |  2 -
 drivers/crypto/n2_core.c                      |  1 -
 drivers/crypto/padlock-aes.c                  |  9 +---
 drivers/crypto/picoxcell_crypto.c             |  6 +--
 drivers/crypto/qat/qat_common/qat_algs.c      |  6 +--
 drivers/crypto/qce/sha.c                      |  2 -
 .../crypto/rockchip/rk3288_crypto_skcipher.c  |  4 +-
 drivers/crypto/stm32/stm32-crc32.c            |  4 +-
 drivers/crypto/talitos.c                      | 15 ++----
 drivers/crypto/ux500/cryp/cryp_core.c         |  2 -
 drivers/crypto/virtio/virtio_crypto_algs.c    |  8 +---
 include/crypto/cast6.h                        |  3 +-
 include/crypto/internal/des.h                 |  8 +---
 include/crypto/twofish.h                      |  2 +-
 include/crypto/xts.h                          |  8 +---
 include/linux/crypto.h                        |  1 -
 93 files changed, 167 insertions(+), 561 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index cdb1a07e7ad0..b668c97663ec 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -138,14 +138,8 @@ static int ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			 unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret;
-
-	ret = ce_aes_expandkey(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
 
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
+	return ce_aes_expandkey(ctx, in_key, key_len);
 }
 
 struct crypto_aes_xts_ctx {
@@ -167,11 +161,7 @@ static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (!ret)
 		ret = ce_aes_expandkey(&ctx->key2, &in_key[key_len / 2],
 				       key_len / 2);
-	if (!ret)
-		return 0;
-
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
+	return ret;
 }
 
 static int ecb_encrypt(struct skcipher_request *req)
diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
index 95592499b9bd..2208445808d7 100644
--- a/arch/arm/crypto/crc32-ce-glue.c
+++ b/arch/arm/crypto/crc32-ce-glue.c
@@ -54,10 +54,8 @@ static int crc32_setkey(struct crypto_shash *hash, const u8 *key,
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 	*mctx = le32_to_cpup((__le32 *)key);
 	return 0;
 }
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index c691077679a6..7e8b2f55685c 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -163,10 +163,8 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	struct ghash_key *key = crypto_shash_ctx(tfm);
 	be128 h;
 
-	if (keylen != GHASH_BLOCK_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
-	}
 
 	/* needed for the fallback */
 	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 541cf9165748..f6d19b0dc893 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -47,14 +47,8 @@ static int ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
 		      unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_aead_ctx(tfm);
-	int ret;
 
-	ret = ce_aes_expandkey(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
-
-	tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
+	return ce_aes_expandkey(ctx, in_key, key_len);
 }
 
 static int ccm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
diff --git a/arch/arm64/crypto/aes-ce-glue.c b/arch/arm64/crypto/aes-ce-glue.c
index 6d085dc56c51..56a5f6f0b0c1 100644
--- a/arch/arm64/crypto/aes-ce-glue.c
+++ b/arch/arm64/crypto/aes-ce-glue.c
@@ -143,14 +143,8 @@ int ce_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		  unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	int ret;
 
-	ret = ce_aes_expandkey(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
-
-	tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
+	return ce_aes_expandkey(ctx, in_key, key_len);
 }
 EXPORT_SYMBOL(ce_aes_setkey);
 
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index aa57dc639f77..ed5409c6abf4 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -132,13 +132,8 @@ static int skcipher_aes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			       unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret;
-
-	ret = aes_expandkey(ctx, in_key, key_len);
-	if (ret)
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
-	return ret;
+	return aes_expandkey(ctx, in_key, key_len);
 }
 
 static int __maybe_unused xts_set_key(struct crypto_skcipher *tfm,
@@ -155,11 +150,7 @@ static int __maybe_unused xts_set_key(struct crypto_skcipher *tfm,
 	if (!ret)
 		ret = aes_expandkey(&ctx->key2, &in_key[key_len / 2],
 				    key_len / 2);
-	if (!ret)
-		return 0;
-
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
+	return ret;
 }
 
 static int __maybe_unused essiv_cbc_set_key(struct crypto_skcipher *tfm,
@@ -173,19 +164,12 @@ static int __maybe_unused essiv_cbc_set_key(struct crypto_skcipher *tfm,
 
 	ret = aes_expandkey(&ctx->key1, in_key, key_len);
 	if (ret)
-		goto out;
+		return ret;
 
 	desc->tfm = ctx->hash;
 	crypto_shash_digest(desc, in_key, key_len, digest);
 
-	ret = aes_expandkey(&ctx->key2, digest, sizeof(digest));
-	if (ret)
-		goto out;
-
-	return 0;
-out:
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
+	return aes_expandkey(&ctx->key2, digest, sizeof(digest));
 }
 
 static int __maybe_unused ecb_encrypt(struct skcipher_request *req)
@@ -791,13 +775,8 @@ static int cbcmac_setkey(struct crypto_shash *tfm, const u8 *in_key,
 			 unsigned int key_len)
 {
 	struct mac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
-	int err;
 
-	err = aes_expandkey(&ctx->key, in_key, key_len);
-	if (err)
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
-	return err;
+	return aes_expandkey(&ctx->key, in_key, key_len);
 }
 
 static void cmac_gf128_mul_by_x(be128 *y, const be128 *x)
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 196aedd0c20c..22831d3b7f62 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -248,10 +248,8 @@ static int ghash_setkey(struct crypto_shash *tfm,
 {
 	struct ghash_key *key = crypto_shash_ctx(tfm);
 
-	if (keylen != GHASH_BLOCK_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
-	}
 
 	return __ghash_setkey(key, inkey, keylen);
 }
@@ -306,10 +304,8 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	int ret;
 
 	ret = aes_expandkey(&ctx->aes_key, inkey, keylen);
-	if (ret) {
-		tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (ret)
 		return -EINVAL;
-	}
 
 	aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
 
diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
index 7d1d2425746f..faa88a6a74c0 100644
--- a/arch/mips/crypto/crc32-mips.c
+++ b/arch/mips/crypto/crc32-mips.c
@@ -177,10 +177,8 @@ static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct chksum_ctx *mctx = crypto_shash_ctx(tfm);
 
-	if (keylen != sizeof(mctx->key)) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(mctx->key))
 		return -EINVAL;
-	}
 	mctx->key = get_unaligned_le32(key);
 	return 0;
 }
diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index 1fad5d4c658d..c2b23b69d7b1 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -94,13 +94,6 @@ static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (key_len != AES_KEYSIZE_128 &&
-	    key_len != AES_KEYSIZE_192 &&
-	    key_len != AES_KEYSIZE_256) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-
 	switch (key_len) {
 	case AES_KEYSIZE_128:
 		ctx->rounds = 4;
@@ -114,6 +107,8 @@ static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		ctx->rounds = 6;
 		ppc_expand_key_256(ctx->key_enc, in_key);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
@@ -139,13 +134,6 @@ static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 
 	key_len >>= 1;
 
-	if (key_len != AES_KEYSIZE_128 &&
-	    key_len != AES_KEYSIZE_192 &&
-	    key_len != AES_KEYSIZE_256) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
 	switch (key_len) {
 	case AES_KEYSIZE_128:
 		ctx->rounds = 4;
@@ -162,6 +150,8 @@ static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		ppc_expand_key_256(ctx->key_enc, in_key);
 		ppc_expand_key_256(ctx->key_twk, in_key + AES_KEYSIZE_256);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
diff --git a/arch/powerpc/crypto/crc32c-vpmsum_glue.c b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
index 2c232898b933..63760b7dbb76 100644
--- a/arch/powerpc/crypto/crc32c-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
@@ -73,10 +73,8 @@ static int crc32c_vpmsum_setkey(struct crypto_shash *hash, const u8 *key,
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 	*mctx = le32_to_cpup((__le32 *)key);
 	return 0;
 }
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index ead0b2c9881d..2db167e5871c 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -414,10 +414,8 @@ static int xts_aes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 		return err;
 
 	/* In fips mode only 128 bit or 256 bit keys are valid */
-	if (fips_enabled && key_len != 32 && key_len != 64) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (fips_enabled && key_len != 32 && key_len != 64)
 		return -EINVAL;
-	}
 
 	/* Pick the correct function code based on the key length */
 	fc = (key_len == 32) ? CPACF_KM_XTS_128 :
diff --git a/arch/s390/crypto/crc32-vx.c b/arch/s390/crypto/crc32-vx.c
index 423ee05887e6..fafecad20752 100644
--- a/arch/s390/crypto/crc32-vx.c
+++ b/arch/s390/crypto/crc32-vx.c
@@ -111,10 +111,8 @@ static int crc32_vx_setkey(struct crypto_shash *tfm, const u8 *newkey,
 {
 	struct crc_ctx *mctx = crypto_shash_ctx(tfm);
 
-	if (newkeylen != sizeof(mctx->key)) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (newkeylen != sizeof(mctx->key))
 		return -EINVAL;
-	}
 	mctx->key = le32_to_cpu(*(__le32 *)newkey);
 	return 0;
 }
@@ -124,10 +122,8 @@ static int crc32be_vx_setkey(struct crypto_shash *tfm, const u8 *newkey,
 {
 	struct crc_ctx *mctx = crypto_shash_ctx(tfm);
 
-	if (newkeylen != sizeof(mctx->key)) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (newkeylen != sizeof(mctx->key))
 		return -EINVAL;
-	}
 	mctx->key = be32_to_cpu(*(__be32 *)newkey);
 	return 0;
 }
diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index a3e7400e031c..6b07a2f1ce8a 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -43,10 +43,8 @@ static int ghash_setkey(struct crypto_shash *tfm,
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
 
-	if (keylen != GHASH_BLOCK_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->key, key, GHASH_BLOCK_SIZE);
 
diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index c7119c617b6e..e2a85783f804 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -151,11 +151,7 @@ static int ecb_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (rc)
 		return rc;
 
-	if (__paes_set_key(ctx)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	return 0;
+	return __paes_set_key(ctx);
 }
 
 static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
@@ -254,11 +250,7 @@ static int cbc_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (rc)
 		return rc;
 
-	if (__cbc_paes_set_key(ctx)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	return 0;
+	return __cbc_paes_set_key(ctx);
 }
 
 static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
@@ -386,10 +378,9 @@ static int xts_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (rc)
 		return rc;
 
-	if (__xts_paes_set_key(ctx)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	rc = __xts_paes_set_key(ctx);
+	if (rc)
+		return rc;
 
 	/*
 	 * xts_check_key verifies the key length is not odd and makes
@@ -526,11 +517,7 @@ static int ctr_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (rc)
 		return rc;
 
-	if (__ctr_paes_set_key(ctx)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-	return 0;
+	return __ctr_paes_set_key(ctx);
 }
 
 static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 0f5a501c95a9..e3d2138ff9e2 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -169,7 +169,6 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
 	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 
 	switch (key_len) {
 	case AES_KEYSIZE_128:
@@ -188,7 +187,6 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		break;
 
 	default:
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
 
diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
index 1700f863748c..aaa9714378e6 100644
--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -39,12 +39,9 @@ static int camellia_set_key(struct crypto_tfm *tfm, const u8 *_in_key,
 {
 	struct camellia_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u32 *in_key = (const u32 *) _in_key;
-	u32 *flags = &tfm->crt_flags;
 
-	if (key_len != 16 && key_len != 24 && key_len != 32) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (key_len != 16 && key_len != 24 && key_len != 32)
 		return -EINVAL;
-	}
 
 	ctx->key_len = key_len;
 
diff --git a/arch/sparc/crypto/crc32c_glue.c b/arch/sparc/crypto/crc32c_glue.c
index 1299073285a3..4e9323229e71 100644
--- a/arch/sparc/crypto/crc32c_glue.c
+++ b/arch/sparc/crypto/crc32c_glue.c
@@ -33,10 +33,8 @@ static int crc32c_sparc64_setkey(struct crypto_shash *hash, const u8 *key,
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 	*(__le32 *)mctx = le32_to_cpup((__le32 *)key);
 	return 0;
 }
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 46d227122643..4623189000d8 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -144,10 +144,8 @@ static int crypto_aegis128_aesni_setkey(struct crypto_aead *aead, const u8 *key,
 {
 	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(aead);
 
-	if (keylen != AEGIS128_KEY_SIZE) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != AEGIS128_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->key.bytes, key, AEGIS128_KEY_SIZE);
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 670f8fcf2544..bbbebbd35b5d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -316,14 +316,11 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 			      const u8 *in_key, unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
-	u32 *flags = &tfm->crt_flags;
 	int err;
 
 	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
-	    key_len != AES_KEYSIZE_256) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	    key_len != AES_KEYSIZE_256)
 		return -EINVAL;
-	}
 
 	if (!crypto_simd_usable())
 		err = aes_expandkey(ctx, in_key, key_len);
@@ -641,10 +638,9 @@ static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
 {
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(aead);
 
-	if (key_len < 4) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (key_len < 4)
 		return -EINVAL;
-	}
+
 	/*Account for 4 byte nonce at the end.*/
 	key_len -= 4;
 
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 1d9ff8a45e1f..06ef2d4a4701 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -64,10 +64,8 @@ static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
-	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	memcpy(tctx->key, key, keylen);
 	tctx->keylen = keylen;
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index a8cc2c83fe1b..ccda647422d6 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -142,8 +142,7 @@ static const struct common_glue_ctx camellia_dec_xts = {
 static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	return __camellia_setkey(crypto_skcipher_ctx(tfm), key, keylen,
-				 &tfm->base.crt_flags);
+	return __camellia_setkey(crypto_skcipher_ctx(tfm), key, keylen);
 }
 
 static int ecb_encrypt(struct skcipher_request *req)
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 31a82a79f4ac..4e5de6ef206e 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -144,8 +144,7 @@ static const struct common_glue_ctx camellia_dec_xts = {
 static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	return __camellia_setkey(crypto_skcipher_ctx(tfm), key, keylen,
-				 &tfm->base.crt_flags);
+	return __camellia_setkey(crypto_skcipher_ctx(tfm), key, keylen);
 }
 
 static int ecb_encrypt(struct skcipher_request *req)
@@ -177,7 +176,6 @@ int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
 	err = xts_verify_key(tfm, key, keylen);
@@ -185,13 +183,12 @@ int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return err;
 
 	/* first half of xts-key is for crypt */
-	err = __camellia_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
+	err = __camellia_setkey(&ctx->crypt_ctx, key, keylen / 2);
 	if (err)
 		return err;
 
 	/* second half of xts-key is for tweak */
-	return __camellia_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
-				flags);
+	return __camellia_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
 }
 EXPORT_SYMBOL_GPL(xts_camellia_setkey);
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 5f3ed5af68d7..242c056e5fa8 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1227,12 +1227,10 @@ static void camellia_setup192(const unsigned char *key, u64 *subkey)
 }
 
 int __camellia_setkey(struct camellia_ctx *cctx, const unsigned char *key,
-		      unsigned int key_len, u32 *flags)
+		      unsigned int key_len)
 {
-	if (key_len != 16 && key_len != 24 && key_len != 32) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (key_len != 16 && key_len != 24 && key_len != 32)
 		return -EINVAL;
-	}
 
 	cctx->key_length = key_len;
 
@@ -1255,8 +1253,7 @@ EXPORT_SYMBOL_GPL(__camellia_setkey);
 static int camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int key_len)
 {
-	return __camellia_setkey(crypto_tfm_ctx(tfm), key, key_len,
-				 &tfm->crt_flags);
+	return __camellia_setkey(crypto_tfm_ctx(tfm), key, key_len);
 }
 
 static int camellia_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index da5297475f9e..48e0f37796fa 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -173,7 +173,6 @@ static int xts_cast6_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
 	err = xts_verify_key(tfm, key, keylen);
@@ -181,13 +180,12 @@ static int xts_cast6_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return err;
 
 	/* first half of xts-key is for crypt */
-	err = __cast6_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
+	err = __cast6_setkey(&ctx->crypt_ctx, key, keylen / 2);
 	if (err)
 		return err;
 
 	/* second half of xts-key is for tweak */
-	return __cast6_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
-			      flags);
+	return __cast6_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
 }
 
 static int xts_encrypt(struct skcipher_request *req)
diff --git a/arch/x86/crypto/crc32-pclmul_glue.c b/arch/x86/crypto/crc32-pclmul_glue.c
index cb4ab6645106..418bd88acac8 100644
--- a/arch/x86/crypto/crc32-pclmul_glue.c
+++ b/arch/x86/crypto/crc32-pclmul_glue.c
@@ -94,10 +94,8 @@ static int crc32_pclmul_setkey(struct crypto_shash *hash, const u8 *key,
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 	*mctx = le32_to_cpup((__le32 *)key);
 	return 0;
 }
diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index eefa0862f309..c20d1b8a82c3 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -91,10 +91,8 @@ static int crc32c_intel_setkey(struct crypto_shash *hash, const u8 *key,
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 	*mctx = le32_to_cpup((__le32 *)key);
 	return 0;
 }
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 04d72a5a8ce9..4a9c9833a7d6 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -57,10 +57,8 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	be128 *x = (be128 *)key;
 	u64 a, b;
 
-	if (keylen != GHASH_BLOCK_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
-	}
 
 	/* perform multiplication by 'x' in GF(2^128) */
 	a = be64_to_cpu(x->a);
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 3b36e97ec7ab..2dbc8ce3730e 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -64,7 +64,6 @@ static int xts_twofish_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			      unsigned int keylen)
 {
 	struct twofish_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
 	err = xts_verify_key(tfm, key, keylen);
@@ -72,13 +71,12 @@ static int xts_twofish_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return err;
 
 	/* first half of xts-key is for crypt */
-	err = __twofish_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
+	err = __twofish_setkey(&ctx->crypt_ctx, key, keylen / 2);
 	if (err)
 		return err;
 
 	/* second half of xts-key is for tweak */
-	return __twofish_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
-				flags);
+	return __twofish_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
 }
 
 static const struct common_glue_ctx twofish_enc = {
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index f1592619dd65..f6d91861cb14 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -26,7 +26,7 @@ struct camellia_xts_ctx {
 
 extern int __camellia_setkey(struct camellia_ctx *cctx,
 			     const unsigned char *key,
-			     unsigned int key_len, u32 *flags);
+			     unsigned int key_len);
 
 extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int keylen);
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 71c11cb5bad1..44fb4956f0dd 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -372,10 +372,8 @@ static int crypto_aegis128_setkey(struct crypto_aead *aead, const u8 *key,
 {
 	struct aegis_ctx *ctx = crypto_aead_ctx(aead);
 
-	if (keylen != AEGIS128_KEY_SIZE) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != AEGIS128_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->key.bytes, key, AEGIS128_KEY_SIZE);
 	return 0;
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 22e5867177f1..27ab27931813 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1127,24 +1127,18 @@ EXPORT_SYMBOL_GPL(crypto_it_tab);
  * @in_key:	The input key.
  * @key_len:	The size of the key.
  *
- * Returns 0 on success, on failure the %CRYPTO_TFM_RES_BAD_KEY_LEN flag in tfm
- * is set. The function uses aes_expand_key() to expand the key.
- * &crypto_aes_ctx _must_ be the private data embedded in @tfm which is
- * retrieved with crypto_tfm_ctx().
+ * This function uses aes_expand_key() to expand the key.  &crypto_aes_ctx
+ * _must_ be the private data embedded in @tfm which is retrieved with
+ * crypto_tfm_ctx().
+ *
+ * Return: 0 on success; -EINVAL on failure (only happens for bad key lengths)
  */
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	int ret;
-
-	ret = aes_expandkey(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
 
-	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
+	return aes_expandkey(ctx, in_key, key_len);
 }
 EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 
diff --git a/crypto/anubis.c b/crypto/anubis.c
index f9ce78fde6ee..5da0241ef453 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -464,7 +464,6 @@ static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct anubis_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __be32 *key = (const __be32 *)in_key;
-	u32 *flags = &tfm->crt_flags;
 	int N, R, i, r;
 	u32 kappa[ANUBIS_MAX_N];
 	u32 inter[ANUBIS_MAX_N];
@@ -474,7 +473,6 @@ static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		case 32: case 36: case 40:
 			break;
 		default:
-			*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 			return -EINVAL;
 	}
 
diff --git a/crypto/authenc.c b/crypto/authenc.c
index f3f49fc022f2..4b0b2dc99676 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -91,7 +91,7 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	int err = -EINVAL;
 
 	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
-		goto badkey;
+		goto out;
 
 	crypto_ahash_clear_flags(auth, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(auth, crypto_aead_get_flags(authenc) &
@@ -113,10 +113,6 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static void authenc_geniv_ahash_done(struct crypto_async_request *areq, int err)
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 8510373affe2..d43326d6bf5d 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -65,7 +65,7 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 	int err = -EINVAL;
 
 	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
-		goto badkey;
+		goto out;
 
 	crypto_ahash_clear_flags(auth, CRYPTO_TFM_REQ_MASK);
 	crypto_ahash_set_flags(auth, crypto_aead_get_flags(authenc_esn) &
@@ -87,10 +87,6 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(authenc_esn, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static int crypto_authenc_esn_genicv_tail(struct aead_request *req,
diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index d04b1788dc42..1d262374fa4e 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -147,10 +147,8 @@ static int blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
-	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES)
 		return -EINVAL;
-	}
 
 	memcpy(tctx->key, key, keylen);
 	tctx->keylen = keylen;
diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
index ed0c74640470..005783ff45ad 100644
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -17,10 +17,8 @@ static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
-	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	memcpy(tctx->key, key, keylen);
 	tctx->keylen = keylen;
diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index b6a1121e2478..9a5783e5196a 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -970,12 +970,9 @@ camellia_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
 	const unsigned char *key = (const unsigned char *)in_key;
-	u32 *flags = &tfm->crt_flags;
 
-	if (key_len != 16 && key_len != 24 && key_len != 32) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (key_len != 16 && key_len != 24 && key_len != 32)
 		return -EINVAL;
-	}
 
 	cctx->key_length = key_len;
 
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index 85328522c5ca..c77ff6c8a2b2 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -103,17 +103,14 @@ static inline void W(u32 *key, unsigned int i)
 	key[7] ^= F2(key[0], Tr[i % 4][7], Tm[i][7]);
 }
 
-int __cast6_setkey(struct cast6_ctx *c, const u8 *in_key,
-		   unsigned key_len, u32 *flags)
+int __cast6_setkey(struct cast6_ctx *c, const u8 *in_key, unsigned int key_len)
 {
 	int i;
 	u32 key[8];
 	__be32 p_key[8]; /* padded key */
 
-	if (key_len % 4 != 0) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (key_len % 4 != 0)
 		return -EINVAL;
-	}
 
 	memset(p_key, 0, 32);
 	memcpy(p_key, in_key, key_len);
@@ -148,8 +145,7 @@ EXPORT_SYMBOL_GPL(__cast6_setkey);
 
 int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 {
-	return __cast6_setkey(crypto_tfm_ctx(tfm), key, keylen,
-			      &tfm->crt_flags);
+	return __cast6_setkey(crypto_tfm_ctx(tfm), key, keylen);
 }
 EXPORT_SYMBOL_GPL(cast6_setkey);
 
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 924d9f6575f9..2dc47e4efec7 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -46,10 +46,8 @@ int crypto_cipher_setkey(struct crypto_cipher *tfm,
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 
 	crypto_cipher_clear_flags(tfm, CRYPTO_TFM_RES_MASK);
-	if (keylen < cia->cia_min_keysize || keylen > cia->cia_max_keysize) {
-		crypto_cipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen < cia->cia_min_keysize || keylen > cia->cia_max_keysize)
 		return -EINVAL;
-	}
 
 	if ((unsigned long)key & alignmask)
 		return setkey_unaligned(tfm, key, keylen);
diff --git a/crypto/crc32_generic.c b/crypto/crc32_generic.c
index 9e97912280bd..0e103fb5dd77 100644
--- a/crypto/crc32_generic.c
+++ b/crypto/crc32_generic.c
@@ -60,10 +60,8 @@ static int crc32_setkey(struct crypto_shash *hash, const u8 *key,
 {
 	u32 *mctx = crypto_shash_ctx(hash);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 	*mctx = get_unaligned_le32(key);
 	return 0;
 }
diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index 7b25fe82072c..7fa9b0788685 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -74,10 +74,8 @@ static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct chksum_ctx *mctx = crypto_shash_ctx(tfm);
 
-	if (keylen != sizeof(mctx->key)) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(mctx->key))
 		return -EINVAL;
-	}
 	mctx->key = get_unaligned_le32(key);
 	return 0;
 }
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 388cceb8c1a0..0bc73abb948f 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -117,10 +117,8 @@ static int essiv_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (err)
 		return err;
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0) {
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		return -EINVAL;
-	}
 
 	desc->tfm = tctx->hash;
 	err = crypto_shash_init(desc) ?:
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index 5027b3461c92..c70d163c1ac9 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -58,10 +58,8 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
 	be128 k;
 
-	if (keylen != GHASH_BLOCK_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
-	}
 
 	if (ctx->gf128)
 		gf128mul_free_4k(ctx->gf128);
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 20e6220f46f6..63350c4ad461 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -137,10 +137,8 @@ static int michael_setkey(struct crypto_shash *tfm, const u8 *key,
 
 	const __le32 *data = (const __le32 *)key;
 
-	if (keylen != 8) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != 8)
 		return -EINVAL;
-	}
 
 	mctx->l = le32_to_cpu(data[0]);
 	mctx->r = le32_to_cpu(data[1]);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 21f1421980e6..c50a25f6bef2 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -603,10 +603,8 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	unsigned long alignmask = crypto_skcipher_alignmask(tfm);
 	int err;
 
-	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize)
 		return -EINVAL;
-	}
 
 	if ((unsigned long)key & alignmask)
 		err = skcipher_setkey_unaligned(tfm, key, keylen);
diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
index 71ffb343709a..016dbc595705 100644
--- a/crypto/sm4_generic.c
+++ b/crypto/sm4_generic.c
@@ -143,29 +143,23 @@ int crypto_sm4_expand_key(struct crypto_sm4_ctx *ctx, const u8 *in_key,
 EXPORT_SYMBOL_GPL(crypto_sm4_expand_key);
 
 /**
- * crypto_sm4_set_key - Set the AES key.
+ * crypto_sm4_set_key - Set the SM4 key.
  * @tfm:	The %crypto_tfm that is used in the context.
  * @in_key:	The input key.
  * @key_len:	The size of the key.
  *
- * Returns 0 on success, on failure the %CRYPTO_TFM_RES_BAD_KEY_LEN flag in tfm
- * is set. The function uses crypto_sm4_expand_key() to expand the key.
+ * This function uses crypto_sm4_expand_key() to expand the key.
  * &crypto_sm4_ctx _must_ be the private data embedded in @tfm which is
  * retrieved with crypto_tfm_ctx().
+ *
+ * Return: 0 on success; -EINVAL on failure (only happens for bad key lengths)
  */
 int crypto_sm4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
 	struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	int ret;
-
-	ret = crypto_sm4_expand_key(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
 
-	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
+	return crypto_sm4_expand_key(ctx, in_key, key_len);
 }
 EXPORT_SYMBOL_GPL(crypto_sm4_set_key);
 
diff --git a/crypto/twofish_common.c b/crypto/twofish_common.c
index 222fc765c57a..d23fa531b91f 100644
--- a/crypto/twofish_common.c
+++ b/crypto/twofish_common.c
@@ -567,7 +567,7 @@ static const u8 calc_sb_tbl[512] = {
 
 /* Perform the key setup. */
 int __twofish_setkey(struct twofish_ctx *ctx, const u8 *key,
-		     unsigned int key_len, u32 *flags)
+		     unsigned int key_len)
 {
 	int i, j, k;
 
@@ -584,10 +584,7 @@ int __twofish_setkey(struct twofish_ctx *ctx, const u8 *key,
 
 	/* Check key length. */
 	if (key_len % 8)
-	{
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL; /* unsupported key length */
-	}
 
 	/* Compute the first two words of the S vector.  The magic numbers are
 	 * the entries of the RS matrix, preprocessed through poly_to_exp. The
@@ -688,8 +685,7 @@ EXPORT_SYMBOL_GPL(__twofish_setkey);
 
 int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len)
 {
-	return __twofish_setkey(crypto_tfm_ctx(tfm), key, key_len,
-				&tfm->crt_flags);
+	return __twofish_setkey(crypto_tfm_ctx(tfm), key, key_len);
 }
 EXPORT_SYMBOL_GPL(twofish_setkey);
 
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 1554455359d5..f20c206578a2 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -435,10 +435,8 @@ static int vmac_setkey(struct crypto_shash *tfm,
 	unsigned int i;
 	int err;
 
-	if (keylen != VMAC_KEY_LEN) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != VMAC_KEY_LEN)
 		return -EINVAL;
-	}
 
 	err = crypto_cipher_setkey(tctx->cipher, key, keylen);
 	if (err)
diff --git a/crypto/xxhash_generic.c b/crypto/xxhash_generic.c
index 4aad2c0f40a9..55d1c8a76127 100644
--- a/crypto/xxhash_generic.c
+++ b/crypto/xxhash_generic.c
@@ -22,10 +22,8 @@ static int xxhash64_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
-	if (keylen != sizeof(tctx->seed)) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(tctx->seed))
 		return -EINVAL;
-	}
 	tctx->seed = get_unaligned_le64(key);
 	return 0;
 }
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index cb2b0874f68f..7f22d305178e 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -541,7 +541,6 @@ int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		break;
 	default:
 		dev_dbg(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	op->keylen = keylen;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 37d0b6c386a0..b102da74b731 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -394,7 +394,6 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		break;
 	default:
 		dev_dbg(ce->dev, "ERROR: Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	if (op->key) {
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index f222979a5623..84d52fc3a2da 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -390,7 +390,6 @@ int sun8i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		break;
 	default:
 		dev_dbg(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	if (op->key) {
@@ -416,7 +415,6 @@ int sun8i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	if (unlikely(keylen != 3 * DES_KEY_SIZE)) {
 		dev_dbg(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index a42f8619589d..121eb81df64f 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -128,12 +128,9 @@ static int crypto4xx_setkey_aes(struct crypto_skcipher *cipher,
 	struct dynamic_sa_ctl *sa;
 	int    rc;
 
-	if (keylen != AES_KEYSIZE_256 &&
-		keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_128) {
-		crypto_skcipher_set_flags(cipher,
-				CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != AES_KEYSIZE_256 && keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_128)
 		return -EINVAL;
-	}
 
 	/* Create SA */
 	if (ctx->sa_in || ctx->sa_out)
@@ -551,10 +548,8 @@ int crypto4xx_setkey_aes_gcm(struct crypto_aead *cipher,
 	struct dynamic_sa_ctl *sa;
 	int    rc = 0;
 
-	if (crypto4xx_aes_gcm_validate_keylen(keylen) != 0) {
-		crypto_aead_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (crypto4xx_aes_gcm_validate_keylen(keylen) != 0)
 		return -EINVAL;
-	}
 
 	rc = crypto4xx_aead_setup_fallback(ctx, cipher, key, keylen);
 	if (rc)
diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index e589015aac1c..9819dd50fbad 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -366,7 +366,6 @@ int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		break;
 	default:
 		dev_dbg(mc->dev, "ERROR: Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	if (op->key) {
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index b001fdcd9d95..898f66cb2eb2 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1140,10 +1140,8 @@ static int atmel_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	if (keylen != AES_KEYSIZE_128 &&
 	    keylen != AES_KEYSIZE_192 &&
-	    keylen != AES_KEYSIZE_256) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	    keylen != AES_KEYSIZE_256)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -1716,10 +1714,8 @@ static int atmel_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	if (keylen != AES_KEYSIZE_256 &&
 	    keylen != AES_KEYSIZE_192 &&
-	    keylen != AES_KEYSIZE_128) {
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	    keylen != AES_KEYSIZE_128)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -2073,7 +2069,6 @@ static int atmel_aes_authenc_setkey(struct crypto_aead *tfm, const u8 *key,
 	return 0;
 
 badkey:
-	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 22ebe40f09f5..fcf1effc7661 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1249,10 +1249,8 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
 {
 	struct artpec6_cryptotfm_context *ctx = crypto_tfm_ctx(&tfm->base);
 
-	if (len != 16 && len != 24 && len != 32) {
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (len != 16 && len != 24 && len != 32)
 		return -EINVAL;
-	}
 
 	ctx->key_length = len;
 
@@ -1606,8 +1604,6 @@ artpec6_crypto_cipher_set_key(struct crypto_skcipher *cipher, const u8 *key,
 	case 32:
 		break;
 	default:
-		crypto_skcipher_set_flags(cipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -1634,8 +1630,6 @@ artpec6_crypto_xts_set_key(struct crypto_skcipher *cipher, const u8 *key,
 	case 64:
 		break;
 	default:
-		crypto_skcipher_set_flags(cipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 1564a6f8c9cb..184a3e1245cf 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -1846,7 +1846,6 @@ static int aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 		ctx->cipher_type = CIPHER_TYPE_AES256;
 		break;
 	default:
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	WARN_ON((ctx->max_payload != SPU_MAX_PAYLOAD_INF) &&
@@ -2916,7 +2915,6 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 	ctx->authkeylen = 0;
 	ctx->digestsize = 0;
 
-	crypto_aead_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
 }
 
@@ -2992,7 +2990,6 @@ static int aead_gcm_ccm_setkey(struct crypto_aead *cipher,
 	ctx->authkeylen = 0;
 	ctx->digestsize = 0;
 
-	crypto_aead_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
 }
 
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2912006b946b..ef1a65f4fc92 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -548,10 +548,8 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	unsigned int saltlen = CHACHAPOLY_IV_SIZE - ivsize;
 
-	if (keylen != CHACHA_KEY_SIZE + saltlen) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != CHACHA_KEY_SIZE + saltlen)
 		return -EINVAL;
-	}
 
 	ctx->cdata.key_virt = key;
 	ctx->cdata.keylen = keylen - saltlen;
@@ -619,7 +617,6 @@ static int aead_setkey(struct crypto_aead *aead,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_set_sh_desc(aead);
 badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
@@ -649,10 +646,8 @@ static int gcm_setkey(struct crypto_aead *aead,
 	int err;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -672,10 +667,8 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 	int err;
 
 	err = aes_check_keylen(keylen - 4);
-	if (err) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -700,10 +693,8 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	int err;
 
 	err = aes_check_keylen(keylen - 4);
-	if (err) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -762,11 +753,8 @@ static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	int err;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
@@ -786,11 +774,8 @@ static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
 	keylen -= CTR_RFC3686_NONCE_SIZE;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
@@ -809,11 +794,8 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 	ctx1_iv_off = 16;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
@@ -846,7 +828,6 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		dev_err(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 8e3449670d2f..4a29e0ef9d63 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -268,7 +268,6 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return ret;
 badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
@@ -356,10 +355,8 @@ static int gcm_setkey(struct crypto_aead *aead,
 	int ret;
 
 	ret = aes_check_keylen(keylen);
-	if (ret) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -462,10 +459,8 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 	int ret;
 
 	ret = aes_check_keylen(keylen - 4);
-	if (ret) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -570,10 +565,8 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	int ret;
 
 	ret = aes_check_keylen(keylen - 4);
-	if (ret) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -644,7 +637,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 					  ctx->sh_desc_enc);
 		if (ret) {
 			dev_err(jrdev, "driver enc context update failed\n");
-			goto badkey;
+			return -EINVAL;
 		}
 	}
 
@@ -653,14 +646,11 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 					  ctx->sh_desc_dec);
 		if (ret) {
 			dev_err(jrdev, "driver dec context update failed\n");
-			goto badkey;
+			return -EINVAL;
 		}
 	}
 
 	return ret;
-badkey:
-	crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
 }
 
 static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
@@ -669,11 +659,8 @@ static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	int err;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
@@ -693,11 +680,8 @@ static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
 	keylen -= CTR_RFC3686_NONCE_SIZE;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
@@ -716,11 +700,8 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 	ctx1_iv_off = 16;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
@@ -748,7 +729,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_err(jrdev, "key size mismatch\n");
-		goto badkey;
+		return -EINVAL;
 	}
 
 	ctx->cdata.keylen = keylen;
@@ -765,7 +746,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 					  ctx->sh_desc_enc);
 		if (ret) {
 			dev_err(jrdev, "driver enc context update failed\n");
-			goto badkey;
+			return -EINVAL;
 		}
 	}
 
@@ -774,14 +755,11 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 					  ctx->sh_desc_dec);
 		if (ret) {
 			dev_err(jrdev, "driver dec context update failed\n");
-			goto badkey;
+			return -EINVAL;
 		}
 	}
 
 	return ret;
-badkey:
-	crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
 }
 
 /*
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 3aeacc36ce23..fe2a628e8905 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -313,7 +313,6 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_set_sh_desc(aead);
 badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
@@ -326,11 +325,11 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
-		goto badkey;
+		goto out;
 
 	err = -EINVAL;
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
+		goto out;
 
 	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
 	      aead_setkey(aead, key, keylen);
@@ -338,10 +337,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
@@ -634,10 +629,8 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	unsigned int saltlen = CHACHAPOLY_IV_SIZE - ivsize;
 
-	if (keylen != CHACHA_KEY_SIZE + saltlen) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != CHACHA_KEY_SIZE + saltlen)
 		return -EINVAL;
-	}
 
 	ctx->cdata.key_virt = key;
 	ctx->cdata.keylen = keylen - saltlen;
@@ -725,10 +718,8 @@ static int gcm_setkey(struct crypto_aead *aead,
 	int ret;
 
 	ret = aes_check_keylen(keylen);
-	if (ret) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -822,10 +813,8 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 	int ret;
 
 	ret = aes_check_keylen(keylen - 4);
-	if (ret) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -923,10 +912,8 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	int ret;
 
 	ret = aes_check_keylen(keylen - 4);
-	if (ret) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -992,11 +979,8 @@ static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	int err;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
@@ -1016,11 +1000,8 @@ static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
 	keylen -= CTR_RFC3686_NONCE_SIZE;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
@@ -1039,11 +1020,8 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 	ctx1_iv_off = 16;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
@@ -1051,11 +1029,8 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 static int chacha20_skcipher_setkey(struct crypto_skcipher *skcipher,
 				    const u8 *key, unsigned int keylen)
 {
-	if (keylen != CHACHA_KEY_SIZE) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != CHACHA_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
@@ -1084,7 +1059,6 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
 		dev_err(dev, "key size mismatch\n");
-		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -3277,7 +3251,6 @@ static int ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	return ret;
 bad_free_key:
 	kfree(hashed_key);
-	crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
 }
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 50a8852ad276..8d9143407fc5 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -473,7 +473,6 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 	return ahash_set_sh_desc(ahash);
  bad_free_key:
 	kfree(hashed_key);
-	crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	return -EINVAL;
 }
 
@@ -483,10 +482,8 @@ static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *jrdev = ctx->jrdev;
 
-	if (keylen != AES_KEYSIZE_128) {
-		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != AES_KEYSIZE_128)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	dma_sync_single_for_device(jrdev, ctx->adata.key_dma, keylen,
@@ -506,10 +503,8 @@ static int acmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 	int err;
 
 	err = aes_check_keylen(keylen);
-	if (err) {
-		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (err)
 		return err;
-	}
 
 	/* key is immediate data for all cmac shared descriptors */
 	ctx->adata.key_virt = key;
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 1ad66677d88e..1be1adffff1d 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -295,8 +295,6 @@ static int cvm_setkey(struct crypto_skcipher *cipher, const u8 *key,
 		memcpy(ctx->enc_key, key, keylen);
 		return 0;
 	} else {
-		crypto_skcipher_set_flags(cipher,
-					    CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/cavium/nitrox/nitrox_aead.c
index 6f80cc3b5c84..dce5423a5883 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -40,10 +40,8 @@ static int nitrox_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	union fc_ctx_flags flags;
 
 	aes_keylen = flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (aes_keylen < 0)
 		return -EINVAL;
-	}
 
 	/* fill crypto context */
 	fctx = nctx->u.fctx;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 97af4d50d003..18088b0a2257 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -200,10 +200,8 @@ static int nitrox_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	int aes_keylen;
 
 	aes_keylen = flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (aes_keylen < 0)
 		return -EINVAL;
-	}
 	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
 }
 
@@ -351,10 +349,8 @@ static int nitrox_aes_xts_setkey(struct crypto_skcipher *cipher,
 	keylen /= 2;
 
 	aes_keylen = flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (aes_keylen < 0)
 		return -EINVAL;
-	}
 
 	fctx = nctx->u.fctx;
 	/* copy KEY2 */
@@ -382,10 +378,8 @@ static int nitrox_aes_ctr_rfc3686_setkey(struct crypto_skcipher *cipher,
 	keylen -= CTR_RFC3686_NONCE_SIZE;
 
 	aes_keylen = flexi_aes_keylen(keylen);
-	if (aes_keylen < 0) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (aes_keylen < 0)
 		return -EINVAL;
-	}
 	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
 }
 
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 32f19f402073..5eba7ee49e81 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -276,7 +276,6 @@ static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 		ctx->u.aes.type = CCP_AES_TYPE_256;
 		break;
 	default:
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	ctx->u.aes.mode = alg->mode;
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index ff50ee80d223..9e8f07c1afac 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -42,7 +42,6 @@ static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 		ctx->u.aes.type = CCP_AES_TYPE_256;
 		break;
 	default:
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 33328a153225..51e12fbd1159 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -51,7 +51,6 @@ static int ccp_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		ctx->u.aes.type = CCP_AES_TYPE_256;
 		break;
 	default:
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	ctx->u.aes.mode = alg->mode;
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 453b9797f93f..474e6f1a6a84 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -293,10 +293,8 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 		ret = crypto_shash_digest(sdesc, key, key_len,
 					  ctx->u.sha.key);
-		if (ret) {
-			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		if (ret)
 			return -EINVAL;
-		}
 
 		key_len = digest_size;
 	} else {
diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index b0085db7e211..d014c8e063a7 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -562,7 +562,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 		rc = crypto_authenc_extractkeys(&keys, key, keylen);
 		if (rc)
-			goto badkey;
+			return rc;
 		enckey = keys.enckey;
 		authkey = keys.authkey;
 		ctx->enc_keylen = keys.enckeylen;
@@ -570,10 +570,9 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 		if (ctx->cipher_mode == DRV_CIPHER_CTR) {
 			/* the nonce is stored in bytes at end of key */
-			rc = -EINVAL;
 			if (ctx->enc_keylen <
 			    (AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE))
-				goto badkey;
+				return -EINVAL;
 			/* Copy nonce from last 4 bytes in CTR key to
 			 *  first 4 bytes in CTR IV
 			 */
@@ -591,7 +590,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	rc = validate_keys_sizes(ctx);
 	if (rc)
-		goto badkey;
+		return rc;
 
 	/* STAT_PHASE_1: Copy key to ctx */
 
@@ -605,7 +604,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC */
 		rc = cc_get_plain_hmac_key(tfm, authkey, ctx->auth_keylen);
 		if (rc)
-			goto badkey;
+			return rc;
 	}
 
 	/* STAT_PHASE_2: Create sequence */
@@ -622,8 +621,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		break; /* No auth. key setup */
 	default:
 		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
-		rc = -ENOTSUPP;
-		goto badkey;
+		return -ENOTSUPP;
 	}
 
 	/* STAT_PHASE_3: Submit sequence to HW */
@@ -632,18 +630,12 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, seq_len);
 		if (rc) {
 			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			goto setkey_error;
+			return rc;
 		}
 	}
 
 	/* Update STAT_PHASE_3 */
 	return rc;
-
-badkey:
-	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
-setkey_error:
-	return rc;
 }
 
 static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 61b9dcaa0c05..7493a32f12b9 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -291,7 +291,6 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 	/* This check the size of the protected key token */
 	if (keylen != sizeof(hki)) {
 		dev_err(dev, "Unsupported protected key size %d.\n", keylen);
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -304,7 +303,6 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 
 	if (validate_keys_sizes(ctx_p, keylen)) {
 		dev_err(dev, "Unsupported key size %d.\n", keylen);
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -395,7 +393,6 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 
 	if (validate_keys_sizes(ctx_p, keylen)) {
 		dev_err(dev, "Unsupported key size %d.\n", keylen);
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index aee5db5f8538..912e5ce5079d 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -899,9 +899,6 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
 
 out:
-	if (rc)
-		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(dev, ctx->key_params.key_dma_addr,
 				 ctx->key_params.keylen, DMA_TO_DEVICE);
@@ -990,9 +987,6 @@ static int cc_xcbc_setkey(struct crypto_ahash *ahash,
 
 	rc = cc_send_sync_request(ctx->drvdata, &cc_req, desc, idx);
 
-	if (rc)
-		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
 	dma_unmap_single(dev, ctx->key_params.key_dma_addr,
 			 ctx->key_params.keylen, DMA_TO_DEVICE);
 	dev_dbg(dev, "Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5b7dbe7cdb17..720b2ff55464 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -912,7 +912,6 @@ static int chcr_aes_cbc_setkey(struct crypto_skcipher *cipher,
 	ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_CBC;
 	return 0;
 badkey_err:
-	crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	ablkctx->enckey_len = 0;
 
 	return err;
@@ -943,7 +942,6 @@ static int chcr_aes_ctr_setkey(struct crypto_skcipher *cipher,
 
 	return 0;
 badkey_err:
-	crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	ablkctx->enckey_len = 0;
 
 	return err;
@@ -981,7 +979,6 @@ static int chcr_aes_rfc3686_setkey(struct crypto_skcipher *cipher,
 
 	return 0;
 badkey_err:
-	crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	ablkctx->enckey_len = 0;
 
 	return err;
@@ -2174,7 +2171,6 @@ static int chcr_aes_xts_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_XTS;
 	return 0;
 badkey_err:
-	crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	ablkctx->enckey_len = 0;
 
 	return err;
@@ -3284,7 +3280,6 @@ static int chcr_ccm_common_setkey(struct crypto_aead *aead,
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 		mk_size = CHCR_KEYCTX_MAC_KEY_SIZE_256;
 	} else {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		aeadctx->enckey_len = 0;
 		return	-EINVAL;
 	}
@@ -3322,7 +3317,6 @@ static int chcr_aead_rfc4309_setkey(struct crypto_aead *aead, const u8 *key,
 	int error;
 
 	if (keylen < 3) {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		aeadctx->enckey_len = 0;
 		return	-EINVAL;
 	}
@@ -3372,7 +3366,6 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	} else if (keylen == AES_KEYSIZE_256) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 	} else {
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		pr_err("GCM: Invalid key length %d\n", keylen);
 		ret = -EINVAL;
 		goto out;
@@ -3429,10 +3422,8 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	if (err)
 		goto out;
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0) {
-		crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto out;
-	}
 
 	if (get_alg_config(&param, max_authsize)) {
 		pr_err("chcr : Unsupported digest size\n");
@@ -3559,10 +3550,9 @@ static int chcr_aead_digest_null_setkey(struct crypto_aead *authenc,
 	if (err)
 		goto out;
 
-	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0) {
-		crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
 		goto out;
-	}
+
 	subtype = get_aead_subtype(authenc);
 	if (subtype == CRYPTO_ALG_SUB_TYPE_CTR_SHA ||
 	    subtype == CRYPTO_ALG_SUB_TYPE_CTR_NULL) {
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 73a899e6f837..eb6e6b618361 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -119,11 +119,9 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 		return 0;
 	}
 
-	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
+	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256)
 		/* not supported at all */
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
-	}
 
 	/*
 	 * The requested key size is not supported by HW, do a fallback
@@ -154,11 +152,9 @@ static int geode_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 		return 0;
 	}
 
-	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
+	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256)
 		/* not supported at all */
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
-	}
 
 	/*
 	 * The requested key size is not supported by HW, do a fallback
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index f4ece0d8bd6c..5ee66532f336 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -380,10 +380,8 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
-	if (ret) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < len / sizeof(u32); i++) {
@@ -433,12 +431,12 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	case SAFEXCEL_DES:
 		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
-			goto badkey_expflags;
+			goto badkey;
 		break;
 	case SAFEXCEL_3DES:
 		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
-			goto badkey_expflags;
+			goto badkey;
 		break;
 	case SAFEXCEL_AES:
 		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
@@ -521,8 +519,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	return 0;
 
 badkey:
-	crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-badkey_expflags:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
@@ -1444,10 +1440,8 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 	/* exclude the nonce here */
 	keylen = len - CTR_RFC3686_NONCE_SIZE;
 	ret = aes_expandkey(&aes, key, keylen);
-	if (ret) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keylen / sizeof(u32); i++) {
@@ -2459,10 +2453,8 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 	/* Only half of the key data is cipher key */
 	keylen = (len >> 1);
 	ret = aes_expandkey(&aes, key, keylen);
-	if (ret) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keylen / sizeof(u32); i++) {
@@ -2478,10 +2470,8 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 
 	/* The other half is the tweak key */
 	ret = aes_expandkey(&aes, (u8 *)(key + keylen), keylen);
-	if (ret) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keylen / sizeof(u32); i++) {
@@ -2570,7 +2560,6 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
-		crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		memzero_explicit(&aes, sizeof(aes));
 		return ret;
 	}
@@ -2684,7 +2673,6 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
-		crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		memzero_explicit(&aes, sizeof(aes));
 		return ret;
 	}
@@ -2815,10 +2803,9 @@ static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
 {
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 
-	if (len != CHACHA_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (len != CHACHA_KEY_SIZE)
 		return -EINVAL;
-	}
+
 	safexcel_chacha20_setkey(ctx, key);
 
 	return 0;
@@ -2872,10 +2859,9 @@ static int safexcel_aead_chachapoly_setkey(struct crypto_aead *ctfm,
 		len -= EIP197_AEAD_IPSEC_NONCE_SIZE;
 		ctx->nonce = *(u32 *)(key + len);
 	}
-	if (len != CHACHA_KEY_SIZE) {
-		crypto_aead_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (len != CHACHA_KEY_SIZE)
 		return -EINVAL;
-	}
+
 	safexcel_chacha20_setkey(ctx, key);
 
 	return 0;
@@ -3070,10 +3056,8 @@ static int safexcel_skcipher_sm4_setkey(struct crypto_skcipher *ctfm,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 
-	if (len != SM4_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (len != SM4_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma)
 		if (memcmp(ctx->key, key, SM4_KEY_SIZE))
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 25e49d1c96e8..088d7f8aab5e 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1919,10 +1919,8 @@ static int safexcel_crc32_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 
-	if (keylen != sizeof(u32)) {
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 
 	memcpy(ctx->ipad, key, sizeof(u32));
 	return 0;
@@ -1995,10 +1993,8 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
-	if (ret) {
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	memset(ctx->ipad, 0, 2 * AES_BLOCK_SIZE);
 	for (i = 0; i < len / sizeof(u32); i++)
@@ -2065,10 +2061,8 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
-	if (ret) {
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	/* precompute the XCBC key material */
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
@@ -2168,10 +2162,8 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	int ret, i;
 
 	ret = aes_expandkey(&aes, key, len);
-	if (ret) {
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	for (i = 0; i < len / sizeof(u32); i++)
 		ctx->ipad[i + 8] =
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 391e3b4df364..f64bde506ae8 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -740,7 +740,6 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 	u32 keylen_cfg = 0;
 	struct ix_sa_dir *dir;
 	struct ixp_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 
 	dir = encrypt ? &ctx->encrypt : &ctx->decrypt;
 	cinfo = dir->npe_ctx;
@@ -757,7 +756,6 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 		case 24: keylen_cfg = MOD_AES192; break;
 		case 32: keylen_cfg = MOD_AES256; break;
 		default:
-			*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 			return -EINVAL;
 		}
 		cipher_cfg |= keylen_cfg;
@@ -1169,7 +1167,6 @@ static int aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index d8e8c857770c..c24f34a48cef 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -255,10 +255,8 @@ static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	int i;
 
 	ret = aes_expandkey(&ctx->aes, key, len);
-	if (ret) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (ret)
 		return ret;
-	}
 
 	remaining = (ctx->aes.key_length - 16) / 4;
 	offset = ctx->aes.key_length + 24 - remaining;
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 90880a81c534..00e580bf8536 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -652,7 +652,6 @@ static int mtk_aes_setkey(struct crypto_skcipher *tfm,
 		break;
 
 	default:
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -1022,7 +1021,6 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 		break;
 
 	default:
-		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 63bd565048f4..f5c468f2cc82 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -746,7 +746,6 @@ static int n2_aes_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 		ctx->enc_type |= ENC_TYPE_ALG_AES256;
 		break;
 	default:
-		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index c5b60f50e1b5..594d6b1695d5 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -108,14 +108,11 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 	const __le32 *key = (const __le32 *)in_key;
-	u32 *flags = &tfm->crt_flags;
 	struct crypto_aes_ctx gen_aes;
 	int cpu;
 
-	if (key_len % 8) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (key_len % 8)
 		return -EINVAL;
-	}
 
 	/*
 	 * If the hardware is capable of generating the extended key
@@ -146,10 +143,8 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->cword.encrypt.keygen = 1;
 	ctx->cword.decrypt.keygen = 1;
 
-	if (aes_expandkey(&gen_aes, in_key, key_len)) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (aes_expandkey(&gen_aes, in_key, key_len))
 		return -EINVAL;
-	}
 
 	memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
 	memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index d187312b9864..ced4cbed9ea0 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -490,7 +490,6 @@ static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	return 0;
 
 badkey:
-	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
@@ -780,10 +779,8 @@ static int spacc_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err = 0;
 
-	if (len > AES_MAX_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (len > AES_MAX_KEY_SIZE)
 		return -EINVAL;
-	}
 
 	/*
 	 * IPSec engine only supports 128 and 256 bit AES keys. If we get a
@@ -830,7 +827,6 @@ static int spacc_kasumi_f8_setkey(struct crypto_skcipher *cipher,
 	int err = 0;
 
 	if (len > AES_MAX_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 35bca76b640f..833bb1d3a11b 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -570,7 +570,6 @@ static int qat_alg_aead_init_sessions(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return 0;
 bad_key:
-	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 error:
@@ -586,14 +585,11 @@ static int qat_alg_skcipher_init_sessions(struct qat_alg_skcipher_ctx *ctx,
 	int alg;
 
 	if (qat_alg_validate_key(keylen, &alg, mode))
-		goto bad_key;
+		return -EINVAL;
 
 	qat_alg_skcipher_init_enc(ctx, alg, key, keylen, mode);
 	qat_alg_skcipher_init_dec(ctx, alg, key, keylen, mode);
 	return 0;
-bad_key:
-	crypto_skcipher_set_flags(ctx->tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
 }
 
 static int qat_alg_aead_rekey(struct crypto_aead *tfm, const uint8_t *key,
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 95ab16fc8fd6..1ab62e7d5f3c 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -396,8 +396,6 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ahash_request_set_crypt(req, &sg, ctx->authkey, keylen);
 
 	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
-	if (ret)
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	kfree(buf);
 err_free_req:
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index ca4de4ddfe1f..4a75c8e1fa6c 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -34,10 +34,8 @@ static int rk_aes_setkey(struct crypto_skcipher *cipher,
 	struct rk_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
-	    keylen != AES_KEYSIZE_256) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	    keylen != AES_KEYSIZE_256)
 		return -EINVAL;
-	}
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_AES_KEY_0, key, keylen);
 	return 0;
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 9e11c3480353..8e92e4ac79f1 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -85,10 +85,8 @@ static int stm32_crc_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct stm32_crc_ctx *mctx = crypto_shash_ctx(tfm);
 
-	if (keylen != sizeof(u32)) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != sizeof(u32))
 		return -EINVAL;
-	}
 
 	mctx->key = get_unaligned_le32(key);
 	return 0;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d71d65846e47..9c6db7f698c4 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -914,7 +914,6 @@ static int aead_setkey(struct crypto_aead *authenc,
 	return 0;
 
 badkey:
-	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
 	memzero_explicit(&keys, sizeof(keys));
 	return -EINVAL;
 }
@@ -929,11 +928,11 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
-		goto badkey;
+		goto out;
 
 	err = -EINVAL;
 	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
-		goto badkey;
+		goto out;
 
 	err = verify_aead_des3_key(authenc, keys.enckey, keys.enckeylen);
 	if (err)
@@ -954,10 +953,6 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static void talitos_sg_unmap(struct device *dev,
@@ -1528,8 +1523,6 @@ static int skcipher_aes_setkey(struct crypto_skcipher *cipher,
 	    keylen == AES_KEYSIZE_256)
 		return skcipher_setkey(cipher, key, keylen);
 
-	crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-
 	return -EINVAL;
 }
 
@@ -2234,10 +2227,8 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 		/* Must get the hash of the long key */
 		ret = keyhash(tfm, key, keylen, hash);
 
-		if (ret) {
-			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		if (ret)
 			return -EINVAL;
-		}
 
 		keysize = digestsize;
 		memcpy(ctx->key, hash, digestsize);
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 95fb694a2667..800dfc4d16c4 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -951,7 +951,6 @@ static int aes_skcipher_setkey(struct crypto_skcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_skcipher_ctx(cipher);
-	u32 *flags = &cipher->base.crt_flags;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
@@ -970,7 +969,6 @@ static int aes_skcipher_setkey(struct crypto_skcipher *cipher,
 
 	default:
 		pr_err(DEV_DBG_NAME "[%s]: Unknown keylen!", __func__);
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 4b71e80951b7..fd045e64972a 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -272,11 +272,11 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 
 	if (keylen > vcrypto->max_cipher_key_len) {
 		pr_err("virtio_crypto: the key is too long\n");
-		goto bad_key;
+		return -EINVAL;
 	}
 
 	if (virtio_crypto_alg_validate_key(keylen, &alg))
-		goto bad_key;
+		return -EINVAL;
 
 	/* Create encryption session */
 	ret = virtio_crypto_alg_skcipher_init_session(ctx,
@@ -291,10 +291,6 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 		return ret;
 	}
 	return 0;
-
-bad_key:
-	crypto_skcipher_set_flags(ctx->tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
 }
 
 /* Note: kernel crypto API realization */
diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index 4c8d0c72f78d..38f490cd50a8 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -15,8 +15,7 @@ struct cast6_ctx {
 	u8 Kr[12][4];
 };
 
-int __cast6_setkey(struct cast6_ctx *ctx, const u8 *key,
-		   unsigned int keylen, u32 *flags);
+int __cast6_setkey(struct cast6_ctx *ctx, const u8 *key, unsigned int keylen);
 int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
 void __cast6_encrypt(const void *ctx, u8 *dst, const u8 *src);
diff --git a/include/crypto/internal/des.h b/include/crypto/internal/des.h
index f62a2bb1866b..355ddaae3806 100644
--- a/include/crypto/internal/des.h
+++ b/include/crypto/internal/des.h
@@ -120,20 +120,16 @@ static inline int verify_skcipher_des3_key(struct crypto_skcipher *tfm,
 static inline int verify_aead_des_key(struct crypto_aead *tfm, const u8 *key,
 				      int keylen)
 {
-	if (keylen != DES_KEY_SIZE) {
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != DES_KEY_SIZE)
 		return -EINVAL;
-	}
 	return crypto_des_verify_key(crypto_aead_tfm(tfm), key);
 }
 
 static inline int verify_aead_des3_key(struct crypto_aead *tfm, const u8 *key,
 				       int keylen)
 {
-	if (keylen != DES3_EDE_KEY_SIZE) {
-		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen != DES3_EDE_KEY_SIZE)
 		return -EINVAL;
-	}
 	return crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), key);
 }
 
diff --git a/include/crypto/twofish.h b/include/crypto/twofish.h
index 2e2c09673d88..f6b307a58554 100644
--- a/include/crypto/twofish.h
+++ b/include/crypto/twofish.h
@@ -19,7 +19,7 @@ struct twofish_ctx {
 };
 
 int __twofish_setkey(struct twofish_ctx *ctx, const u8 *key,
-		     unsigned int key_len, u32 *flags);
+		     unsigned int key_len);
 int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len);
 
 #endif
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 15ae7fdc0478..57b2c52928db 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -17,10 +17,8 @@ static inline int xts_check_key(struct crypto_tfm *tfm,
 	 * key consists of keys of equal size concatenated, therefore
 	 * the length must be even.
 	 */
-	if (keylen % 2) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	if (keylen % 2)
 		return -EINVAL;
-	}
 
 	/* ensure that the AES and tweak key are not identical */
 	if (fips_enabled &&
@@ -39,10 +37,8 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 	 * key consists of keys of equal size concatenated, therefore
 	 * the length must be even.
 	 */
-	if (keylen % 2) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	if (keylen % 2)
 		return -EINVAL;
-	}
 
 	/* ensure that the AES and tweak key are not identical */
 	if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 719a301af3f2..61fccc7d0efb 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -113,7 +113,6 @@
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
-#define CRYPTO_TFM_RES_BAD_KEY_LEN   	0x00200000
 
 /*
  * Miscellaneous stuff.
-- 
2.24.1

