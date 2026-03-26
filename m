Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8163A3826;
	Thu, 26 Mar 2026 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774555973; cv=none; b=WtvTi80lNifmjFG+a/v80azUVdZwvREPCZPIoYCr9+DRbHDRSp/ljQaahbGwpqgIfCIJiOT9kDO34j+meAIdkmWxQQYs09ON6Rx0vU3t0BrbhvNYBaepvrDDkNc64Tadtvb+KXNzQjGyUzl5k3beh2hKdErqC6fbTihLSZPyNjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774555973; c=relaxed/simple;
	bh=VBVbTnQFXp4h+uFwG4gUTfOTUBJpwgXxdOn1hji6UY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPqfFDAl+WfI/Qom+Q5HOjN4BCcf3mURBdYVf8bGTnjWycVOO6TN1HsxScqofhzfJNq0bNRDiG7BtGOPSJOl0m356xUIwnm+chxbzasjmhF1eNwZDtijiUXulkJ/ONdwPZciTvTiESHYV/g2SfHhBXmWQF3HNZ7UYDeSLU/Gxzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thnbTqB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thnbTqB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFA9C2BCB1;
	Thu, 26 Mar 2026 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774555973;
	bh=VBVbTnQFXp4h+uFwG4gUTfOTUBJpwgXxdOn1hji6UY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thnbTqB0IwEiYEgAHBFF/XuTaulWZ9X97gpbRDxSi8doWNitFUb6AwRH8vET7hjw8
	 uzTMNLS2AgNVD5g/KcRmg9740TlNrRsGeqbak+fDr8p++Ah8jL9eYCgcDj1cUqB5Tb
	 ZTRCMOmyJQFXjCPWHJMmoYNEPHaDFbqak8xU9qxA6lNkE5xMBO18bJmH+owXMbNpjX
	 l/1Rp8OKfvwYAXmrpjUkXt2jkVeb5a8/3LjzM2QRLhg0wES52qF6mt47gXKFUlGXL4
	 nZrmmq9at0hl+4C9szCaI5zcYJWLCo6vvcQsP/d9I0CDv6RqAKTtgYvwreqkfUZ+6Y
	 okChQq1lYxXRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
Date: Thu, 26 Mar 2026 13:12:43 -0700
Message-ID: <20260326201246.57544-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326201246.57544-1-ebiggers@kernel.org>
References: <20260326201246.57544-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since DES and Triple DES are obsolete, there is very little point in
maintining architecture-optimized code for them.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/s390/configs/debug_defconfig |   1 -
 arch/s390/configs/defconfig       |   1 -
 arch/s390/crypto/Kconfig          |  16 -
 arch/s390/crypto/Makefile         |   1 -
 arch/s390/crypto/des_s390.c       | 502 ------------------------------
 5 files changed, 521 deletions(-)
 delete mode 100644 arch/s390/crypto/des_s390.c

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 98fd0a2f51c6..74e4bb236623 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -809,11 +809,10 @@ CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_GHASH_S390=m
 CONFIG_CRYPTO_AES_S390=m
-CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_HMAC_S390=m
 CONFIG_ZCRYPT=m
 CONFIG_PKEY=m
 CONFIG_PKEY_CCA=m
 CONFIG_PKEY_EP11=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 0f4cedcab3ce..5cb7b715ba6b 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -794,11 +794,10 @@ CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_GHASH_S390=m
 CONFIG_CRYPTO_AES_S390=m
-CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_HMAC_S390=m
 CONFIG_ZCRYPT=m
 CONFIG_PKEY=m
 CONFIG_PKEY_CCA=m
 CONFIG_PKEY_EP11=m
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 79a2d0034258..4218d21f1f00 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -29,26 +29,10 @@ config CRYPTO_AES_S390
 
 	  As of z196 the CTR mode is hardware accelerated for all AES
 	  key sizes and XTS mode is hardware accelerated for 256 and
 	  512 bit keys.
 
-config CRYPTO_DES_S390
-	tristate "Ciphers: DES and Triple DES EDE, modes: ECB, CBC, CTR"
-	select CRYPTO_ALGAPI
-	select CRYPTO_SKCIPHER
-	select CRYPTO_LIB_DES
-	help
-	  Block ciphers: DES (FIPS 46-2) cipher algorithm
-	  Block ciphers: Triple DES EDE (FIPS 46-3) cipher algorithm
-	  Length-preserving ciphers: DES with ECB, CBC, and CTR modes
-	  Length-preserving ciphers: Triple DES EDED with ECB, CBC, and CTR modes
-
-	  Architecture: s390
-
-	  As of z990 the ECB and CBC mode are hardware accelerated.
-	  As of z196 the CTR mode is hardware accelerated.
-
 config CRYPTO_HMAC_S390
 	tristate "Keyed-hash message authentication code: HMAC"
 	select CRYPTO_HASH
 	help
 	  s390 specific HMAC hardware support for SHA224, SHA256, SHA384 and
diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
index 387a229e1038..bf5e061ebf13 100644
--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -1,11 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_CRYPTO_PAES_S390) += paes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
 obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
 obj-$(CONFIG_CRYPTO_HMAC_S390) += hmac_s390.o
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
deleted file mode 100644
index 8e75b83a5ddc..000000000000
--- a/arch/s390/crypto/des_s390.c
+++ /dev/null
@@ -1,502 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Cryptographic API.
- *
- * s390 implementation of the DES Cipher Algorithm.
- *
- * Copyright IBM Corp. 2003, 2011
- * Author(s): Thomas Spatzier
- *	      Jan Glauber (jan.glauber@de.ibm.com)
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/cpufeature.h>
-#include <linux/crypto.h>
-#include <linux/fips.h>
-#include <linux/mutex.h>
-#include <crypto/algapi.h>
-#include <crypto/internal/des.h>
-#include <crypto/internal/skcipher.h>
-#include <asm/cpacf.h>
-
-#define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
-
-static u8 *ctrblk;
-static DEFINE_MUTEX(ctrblk_lock);
-
-static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
-
-struct s390_des_ctx {
-	u8 iv[DES_BLOCK_SIZE];
-	u8 key[DES3_KEY_SIZE];
-};
-
-static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
-		      unsigned int key_len)
-{
-	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	int err;
-
-	err = crypto_des_verify_key(tfm, key);
-	if (err)
-		return err;
-
-	memcpy(ctx->key, key, key_len);
-	return 0;
-}
-
-static int des_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
-			       unsigned int key_len)
-{
-	return des_setkey(crypto_skcipher_tfm(tfm), key, key_len);
-}
-
-static void s390_des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cpacf_km(CPACF_KM_DEA, ctx->key, out, in, DES_BLOCK_SIZE);
-}
-
-static void s390_des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cpacf_km(CPACF_KM_DEA | CPACF_DECRYPT,
-		 ctx->key, out, in, DES_BLOCK_SIZE);
-}
-
-static struct crypto_alg des_alg = {
-	.cra_name		=	"des",
-	.cra_driver_name	=	"des-s390",
-	.cra_priority		=	300,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	DES_KEY_SIZE,
-			.cia_max_keysize	=	DES_KEY_SIZE,
-			.cia_setkey		=	des_setkey,
-			.cia_encrypt		=	s390_des_encrypt,
-			.cia_decrypt		=	s390_des_decrypt,
-		}
-	}
-};
-
-static int ecb_desall_crypt(struct skcipher_request *req, unsigned long fc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_des_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes, n;
-	int ret;
-
-	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
-		/* only use complete blocks */
-		n = nbytes & ~(DES_BLOCK_SIZE - 1);
-		cpacf_km(fc, ctx->key, walk.dst.virt.addr,
-			 walk.src.virt.addr, n);
-		ret = skcipher_walk_done(&walk, nbytes - n);
-	}
-	return ret;
-}
-
-static int cbc_desall_crypt(struct skcipher_request *req, unsigned long fc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_des_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes, n;
-	int ret;
-	struct {
-		u8 iv[DES_BLOCK_SIZE];
-		u8 key[DES3_KEY_SIZE];
-	} param;
-
-	ret = skcipher_walk_virt(&walk, req, false);
-	if (ret)
-		return ret;
-	memcpy(param.iv, walk.iv, DES_BLOCK_SIZE);
-	memcpy(param.key, ctx->key, DES3_KEY_SIZE);
-	while ((nbytes = walk.nbytes) != 0) {
-		/* only use complete blocks */
-		n = nbytes & ~(DES_BLOCK_SIZE - 1);
-		cpacf_kmc(fc, &param, walk.dst.virt.addr,
-			  walk.src.virt.addr, n);
-		memcpy(walk.iv, param.iv, DES_BLOCK_SIZE);
-		ret = skcipher_walk_done(&walk, nbytes - n);
-	}
-	return ret;
-}
-
-static int ecb_des_encrypt(struct skcipher_request *req)
-{
-	return ecb_desall_crypt(req, CPACF_KM_DEA);
-}
-
-static int ecb_des_decrypt(struct skcipher_request *req)
-{
-	return ecb_desall_crypt(req, CPACF_KM_DEA | CPACF_DECRYPT);
-}
-
-static struct skcipher_alg ecb_des_alg = {
-	.base.cra_name		=	"ecb(des)",
-	.base.cra_driver_name	=	"ecb-des-s390",
-	.base.cra_priority	=	400,	/* combo: des + ecb */
-	.base.cra_blocksize	=	DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	DES_KEY_SIZE,
-	.max_keysize		=	DES_KEY_SIZE,
-	.setkey			=	des_setkey_skcipher,
-	.encrypt		=	ecb_des_encrypt,
-	.decrypt		=	ecb_des_decrypt,
-};
-
-static int cbc_des_encrypt(struct skcipher_request *req)
-{
-	return cbc_desall_crypt(req, CPACF_KMC_DEA);
-}
-
-static int cbc_des_decrypt(struct skcipher_request *req)
-{
-	return cbc_desall_crypt(req, CPACF_KMC_DEA | CPACF_DECRYPT);
-}
-
-static struct skcipher_alg cbc_des_alg = {
-	.base.cra_name		=	"cbc(des)",
-	.base.cra_driver_name	=	"cbc-des-s390",
-	.base.cra_priority	=	400,	/* combo: des + cbc */
-	.base.cra_blocksize	=	DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	DES_KEY_SIZE,
-	.max_keysize		=	DES_KEY_SIZE,
-	.ivsize			=	DES_BLOCK_SIZE,
-	.setkey			=	des_setkey_skcipher,
-	.encrypt		=	cbc_des_encrypt,
-	.decrypt		=	cbc_des_decrypt,
-};
-
-/*
- * RFC2451:
- *
- *   For DES-EDE3, there is no known need to reject weak or
- *   complementation keys.  Any weakness is obviated by the use of
- *   multiple keys.
- *
- *   However, if the first two or last two independent 64-bit keys are
- *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
- *   same as DES.  Implementers MUST reject keys that exhibit this
- *   property.
- *
- *   In fips mode additionally check for all 3 keys are unique.
- *
- */
-static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
-		       unsigned int key_len)
-{
-	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	int err;
-
-	err = crypto_des3_ede_verify_key(tfm, key);
-	if (err)
-		return err;
-
-	memcpy(ctx->key, key, key_len);
-	return 0;
-}
-
-static int des3_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
-				unsigned int key_len)
-{
-	return des3_setkey(crypto_skcipher_tfm(tfm), key, key_len);
-}
-
-static void des3_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cpacf_km(CPACF_KM_TDEA_192, ctx->key, dst, src, DES_BLOCK_SIZE);
-}
-
-static void des3_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cpacf_km(CPACF_KM_TDEA_192 | CPACF_DECRYPT,
-		 ctx->key, dst, src, DES_BLOCK_SIZE);
-}
-
-static struct crypto_alg des3_alg = {
-	.cra_name		=	"des3_ede",
-	.cra_driver_name	=	"des3_ede-s390",
-	.cra_priority		=	300,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	DES3_KEY_SIZE,
-			.cia_max_keysize	=	DES3_KEY_SIZE,
-			.cia_setkey		=	des3_setkey,
-			.cia_encrypt		=	des3_encrypt,
-			.cia_decrypt		=	des3_decrypt,
-		}
-	}
-};
-
-static int ecb_des3_encrypt(struct skcipher_request *req)
-{
-	return ecb_desall_crypt(req, CPACF_KM_TDEA_192);
-}
-
-static int ecb_des3_decrypt(struct skcipher_request *req)
-{
-	return ecb_desall_crypt(req, CPACF_KM_TDEA_192 | CPACF_DECRYPT);
-}
-
-static struct skcipher_alg ecb_des3_alg = {
-	.base.cra_name		=	"ecb(des3_ede)",
-	.base.cra_driver_name	=	"ecb-des3_ede-s390",
-	.base.cra_priority	=	400,	/* combo: des3 + ecb */
-	.base.cra_blocksize	=	DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	DES3_KEY_SIZE,
-	.max_keysize		=	DES3_KEY_SIZE,
-	.setkey			=	des3_setkey_skcipher,
-	.encrypt		=	ecb_des3_encrypt,
-	.decrypt		=	ecb_des3_decrypt,
-};
-
-static int cbc_des3_encrypt(struct skcipher_request *req)
-{
-	return cbc_desall_crypt(req, CPACF_KMC_TDEA_192);
-}
-
-static int cbc_des3_decrypt(struct skcipher_request *req)
-{
-	return cbc_desall_crypt(req, CPACF_KMC_TDEA_192 | CPACF_DECRYPT);
-}
-
-static struct skcipher_alg cbc_des3_alg = {
-	.base.cra_name		=	"cbc(des3_ede)",
-	.base.cra_driver_name	=	"cbc-des3_ede-s390",
-	.base.cra_priority	=	400,	/* combo: des3 + cbc */
-	.base.cra_blocksize	=	DES_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	DES3_KEY_SIZE,
-	.max_keysize		=	DES3_KEY_SIZE,
-	.ivsize			=	DES_BLOCK_SIZE,
-	.setkey			=	des3_setkey_skcipher,
-	.encrypt		=	cbc_des3_encrypt,
-	.decrypt		=	cbc_des3_decrypt,
-};
-
-static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
-{
-	unsigned int i, n;
-
-	/* align to block size, max. PAGE_SIZE */
-	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(DES_BLOCK_SIZE - 1);
-	memcpy(ctrptr, iv, DES_BLOCK_SIZE);
-	for (i = (n / DES_BLOCK_SIZE) - 1; i > 0; i--) {
-		memcpy(ctrptr + DES_BLOCK_SIZE, ctrptr, DES_BLOCK_SIZE);
-		crypto_inc(ctrptr + DES_BLOCK_SIZE, DES_BLOCK_SIZE);
-		ctrptr += DES_BLOCK_SIZE;
-	}
-	return n;
-}
-
-static int ctr_desall_crypt(struct skcipher_request *req, unsigned long fc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_des_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u8 buf[DES_BLOCK_SIZE], *ctrptr;
-	struct skcipher_walk walk;
-	unsigned int n, nbytes;
-	int ret, locked;
-
-	locked = mutex_trylock(&ctrblk_lock);
-
-	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) >= DES_BLOCK_SIZE) {
-		n = DES_BLOCK_SIZE;
-		if (nbytes >= 2*DES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
-		ctrptr = (n > DES_BLOCK_SIZE) ? ctrblk : walk.iv;
-		cpacf_kmctr(fc, ctx->key, walk.dst.virt.addr,
-			    walk.src.virt.addr, n, ctrptr);
-		if (ctrptr == ctrblk)
-			memcpy(walk.iv, ctrptr + n - DES_BLOCK_SIZE,
-				DES_BLOCK_SIZE);
-		crypto_inc(walk.iv, DES_BLOCK_SIZE);
-		ret = skcipher_walk_done(&walk, nbytes - n);
-	}
-	if (locked)
-		mutex_unlock(&ctrblk_lock);
-	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
-	if (nbytes) {
-		cpacf_kmctr(fc, ctx->key, buf, walk.src.virt.addr,
-			    DES_BLOCK_SIZE, walk.iv);
-		memcpy(walk.dst.virt.addr, buf, nbytes);
-		crypto_inc(walk.iv, DES_BLOCK_SIZE);
-		ret = skcipher_walk_done(&walk, 0);
-	}
-	return ret;
-}
-
-static int ctr_des_crypt(struct skcipher_request *req)
-{
-	return ctr_desall_crypt(req, CPACF_KMCTR_DEA);
-}
-
-static struct skcipher_alg ctr_des_alg = {
-	.base.cra_name		=	"ctr(des)",
-	.base.cra_driver_name	=	"ctr-des-s390",
-	.base.cra_priority	=	400,	/* combo: des + ctr */
-	.base.cra_blocksize	=	1,
-	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	DES_KEY_SIZE,
-	.max_keysize		=	DES_KEY_SIZE,
-	.ivsize			=	DES_BLOCK_SIZE,
-	.setkey			=	des_setkey_skcipher,
-	.encrypt		=	ctr_des_crypt,
-	.decrypt		=	ctr_des_crypt,
-	.chunksize		=	DES_BLOCK_SIZE,
-};
-
-static int ctr_des3_crypt(struct skcipher_request *req)
-{
-	return ctr_desall_crypt(req, CPACF_KMCTR_TDEA_192);
-}
-
-static struct skcipher_alg ctr_des3_alg = {
-	.base.cra_name		=	"ctr(des3_ede)",
-	.base.cra_driver_name	=	"ctr-des3_ede-s390",
-	.base.cra_priority	=	400,	/* combo: des3 + ede */
-	.base.cra_blocksize	=	1,
-	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	DES3_KEY_SIZE,
-	.max_keysize		=	DES3_KEY_SIZE,
-	.ivsize			=	DES_BLOCK_SIZE,
-	.setkey			=	des3_setkey_skcipher,
-	.encrypt		=	ctr_des3_crypt,
-	.decrypt		=	ctr_des3_crypt,
-	.chunksize		=	DES_BLOCK_SIZE,
-};
-
-static struct crypto_alg *des_s390_algs_ptr[2];
-static int des_s390_algs_num;
-static struct skcipher_alg *des_s390_skciphers_ptr[6];
-static int des_s390_skciphers_num;
-
-static int des_s390_register_alg(struct crypto_alg *alg)
-{
-	int ret;
-
-	ret = crypto_register_alg(alg);
-	if (!ret)
-		des_s390_algs_ptr[des_s390_algs_num++] = alg;
-	return ret;
-}
-
-static int des_s390_register_skcipher(struct skcipher_alg *alg)
-{
-	int ret;
-
-	ret = crypto_register_skcipher(alg);
-	if (!ret)
-		des_s390_skciphers_ptr[des_s390_skciphers_num++] = alg;
-	return ret;
-}
-
-static void des_s390_exit(void)
-{
-	while (des_s390_algs_num--)
-		crypto_unregister_alg(des_s390_algs_ptr[des_s390_algs_num]);
-	while (des_s390_skciphers_num--)
-		crypto_unregister_skcipher(des_s390_skciphers_ptr[des_s390_skciphers_num]);
-	if (ctrblk)
-		free_page((unsigned long) ctrblk);
-}
-
-static int __init des_s390_init(void)
-{
-	int ret;
-
-	/* Query available functions for KM, KMC and KMCTR */
-	cpacf_query(CPACF_KM, &km_functions);
-	cpacf_query(CPACF_KMC, &kmc_functions);
-	cpacf_query(CPACF_KMCTR, &kmctr_functions);
-
-	if (cpacf_test_func(&km_functions, CPACF_KM_DEA)) {
-		ret = des_s390_register_alg(&des_alg);
-		if (ret)
-			goto out_err;
-		ret = des_s390_register_skcipher(&ecb_des_alg);
-		if (ret)
-			goto out_err;
-	}
-	if (cpacf_test_func(&kmc_functions, CPACF_KMC_DEA)) {
-		ret = des_s390_register_skcipher(&cbc_des_alg);
-		if (ret)
-			goto out_err;
-	}
-	if (cpacf_test_func(&km_functions, CPACF_KM_TDEA_192)) {
-		ret = des_s390_register_alg(&des3_alg);
-		if (ret)
-			goto out_err;
-		ret = des_s390_register_skcipher(&ecb_des3_alg);
-		if (ret)
-			goto out_err;
-	}
-	if (cpacf_test_func(&kmc_functions, CPACF_KMC_TDEA_192)) {
-		ret = des_s390_register_skcipher(&cbc_des3_alg);
-		if (ret)
-			goto out_err;
-	}
-
-	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_DEA) ||
-	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_TDEA_192)) {
-		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
-		if (!ctrblk) {
-			ret = -ENOMEM;
-			goto out_err;
-		}
-	}
-
-	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_DEA)) {
-		ret = des_s390_register_skcipher(&ctr_des_alg);
-		if (ret)
-			goto out_err;
-	}
-	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_TDEA_192)) {
-		ret = des_s390_register_skcipher(&ctr_des3_alg);
-		if (ret)
-			goto out_err;
-	}
-
-	return 0;
-out_err:
-	des_s390_exit();
-	return ret;
-}
-
-module_cpu_feature_match(S390_CPU_FEATURE_MSA, des_s390_init);
-module_exit(des_s390_exit);
-
-MODULE_ALIAS_CRYPTO("des");
-MODULE_ALIAS_CRYPTO("des3_ede");
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms");
-- 
2.53.0

