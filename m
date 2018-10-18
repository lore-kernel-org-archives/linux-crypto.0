Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37528 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbeJRVBc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 17:01:32 -0400
From: Yael Chemla <yael.chemla@foss.arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org
Cc: Yael Chemla <yael.chemla@foss.arm.com>
Subject: [PATCH 3/3] crypto: ccree: add SM3 support
Date: Thu, 18 Oct 2018 13:59:59 +0100
Message-Id: <1539867599-20504-4-git-send-email-yael.chemla@foss.arm.com>
In-Reply-To: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
References: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for SM3 cipher in CryptoCell 713.

Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
---
 drivers/crypto/Kconfig                  |   1 +
 drivers/crypto/ccree/cc_crypto_ctx.h    |   4 +-
 drivers/crypto/ccree/cc_hash.c          | 119 ++++++++++++++++++++++++++------
 drivers/crypto/ccree/cc_hw_queue_defs.h |  13 ++++
 4 files changed, 113 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index a8c4ce0..1588cd4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -751,6 +751,7 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_ECB
 	select CRYPTO_CTR
 	select CRYPTO_XTS
+	select CRYPTO_SM3
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
diff --git a/drivers/crypto/ccree/cc_crypto_ctx.h b/drivers/crypto/ccree/cc_crypto_ctx.h
index e032544..c8dac27 100644
--- a/drivers/crypto/ccree/cc_crypto_ctx.h
+++ b/drivers/crypto/ccree/cc_crypto_ctx.h
@@ -115,7 +115,8 @@ enum drv_hash_mode {
 	DRV_HASH_CBC_MAC = 6,
 	DRV_HASH_XCBC_MAC = 7,
 	DRV_HASH_CMAC = 8,
-	DRV_HASH_MODE_NUM = 9,
+	DRV_HASH_SM3 = 9,
+	DRV_HASH_MODE_NUM = 10,
 	DRV_HASH_RESERVE32B = S32_MAX
 };
 
@@ -127,6 +128,7 @@ enum drv_hash_hw_mode {
 	DRV_HASH_HW_SHA512 = 4,
 	DRV_HASH_HW_SHA384 = 12,
 	DRV_HASH_HW_GHASH = 6,
+	DRV_HASH_HW_SM3 = 14,
 	DRV_HASH_HW_RESERVE32B = S32_MAX
 };
 
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index adcd9df..c80c9ae 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -6,6 +6,7 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <crypto/md5.h>
+#include <crypto/sm3.h>
 #include <crypto/internal/hash.h>
 
 #include "cc_driver.h"
@@ -16,6 +17,7 @@
 
 #define CC_MAX_HASH_SEQ_LEN 12
 #define CC_MAX_OPAD_KEYS_SIZE CC_MAX_HASH_BLCK_SIZE
+#define CC_SM3_HASH_LEN_SIZE 8
 
 struct cc_hash_handle {
 	cc_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
@@ -43,6 +45,9 @@ static u64 sha384_init[] = {
 static u64 sha512_init[] = {
 	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
+static const u32 sm3_init[] = {
+	SM3_IVH, SM3_IVG, SM3_IVF, SM3_IVE,
+	SM3_IVD, SM3_IVC, SM3_IVB, SM3_IVA };
 
 static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
 			  unsigned int *seq_size);
@@ -1074,7 +1079,10 @@ static int cc_get_hash_len(struct crypto_tfm *tfm)
 {
 	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	return cc_get_default_hash_len(ctx->drvdata);
+	if (ctx->hash_mode == DRV_HASH_SM3)
+		return CC_SM3_HASH_LEN_SIZE;
+	else
+		return cc_get_default_hash_len(ctx->drvdata);
 }
 
 static int cc_cra_init(struct crypto_tfm *tfm)
@@ -1523,6 +1531,7 @@ struct cc_hash_template {
 	char mac_name[CRYPTO_MAX_ALG_NAME];
 	char mac_driver_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int blocksize;
+	bool is_mac;
 	bool synchronize;
 	struct ahash_alg template_ahash;
 	int hash_mode;
@@ -1544,6 +1553,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "hmac(sha1)",
 		.mac_driver_name = "hmac-sha1-ccree",
 		.blocksize = SHA1_BLOCK_SIZE,
+		.is_mac = true,
 		.synchronize = false,
 		.template_ahash = {
 			.init = cc_hash_init,
@@ -1570,6 +1580,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "hmac(sha256)",
 		.mac_driver_name = "hmac-sha256-ccree",
 		.blocksize = SHA256_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_hash_update,
@@ -1595,6 +1606,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "hmac(sha224)",
 		.mac_driver_name = "hmac-sha224-ccree",
 		.blocksize = SHA224_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_hash_update,
@@ -1620,6 +1632,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "hmac(sha384)",
 		.mac_driver_name = "hmac-sha384-ccree",
 		.blocksize = SHA384_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_hash_update,
@@ -1645,6 +1658,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "hmac(sha512)",
 		.mac_driver_name = "hmac-sha512-ccree",
 		.blocksize = SHA512_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_hash_update,
@@ -1670,6 +1684,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "hmac(md5)",
 		.mac_driver_name = "hmac-md5-ccree",
 		.blocksize = MD5_HMAC_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_hash_update,
@@ -1690,9 +1705,34 @@ static struct cc_hash_template driver_hash[] = {
 		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
+		.name = "sm3",
+		.driver_name = "sm3-ccree",
+		.blocksize = SM3_BLOCK_SIZE,
+		.is_mac = false,
+		.template_ahash = {
+			.init = cc_hash_init,
+			.update = cc_hash_update,
+			.final = cc_hash_final,
+			.finup = cc_hash_finup,
+			.digest = cc_hash_digest,
+			.export = cc_hash_export,
+			.import = cc_hash_import,
+			.setkey = cc_hash_setkey,
+			.halg = {
+				.digestsize = SM3_DIGEST_SIZE,
+				.statesize = CC_STATE_SIZE(SM3_DIGEST_SIZE),
+			},
+		},
+		.hash_mode = DRV_HASH_SM3,
+		.hw_mode = DRV_HASH_HW_SM3,
+		.inter_digestsize = SM3_DIGEST_SIZE,
+		.min_hw_rev = CC_HW_REV_713,
+	},
+	{
 		.mac_name = "xcbc(aes)",
 		.mac_driver_name = "xcbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_mac_update,
@@ -1716,6 +1756,7 @@ static struct cc_hash_template driver_hash[] = {
 		.mac_name = "cmac(aes)",
 		.mac_driver_name = "cmac-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
+		.is_mac = true,
 		.template_ahash = {
 			.init = cc_hash_init,
 			.update = cc_mac_update,
@@ -1788,6 +1829,7 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	unsigned int larval_seq_len = 0;
 	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
 	bool large_sha_supported = (drvdata->hw_rev >= CC_HW_REV_712);
+	bool sm3_supported = (drvdata->hw_rev >= CC_HW_REV_713);
 	int rc = 0;
 
 	/* Copy-to-sram digest-len */
@@ -1853,6 +1895,17 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	sram_buff_ofs += sizeof(sha256_init);
 	larval_seq_len = 0;
 
+	if (sm3_supported) {
+		cc_set_sram_desc(sm3_init, sram_buff_ofs,
+				 ARRAY_SIZE(sm3_init), larval_seq,
+				 &larval_seq_len);
+		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
+		if (rc)
+			goto init_digest_const_err;
+		sram_buff_ofs += sizeof(sm3_init);
+		larval_seq_len = 0;
+	}
+
 	if (large_sha_supported) {
 		cc_set_sram_desc((u32 *)sha384_init, sram_buff_ofs,
 				 (ARRAY_SIZE(sha384_init) * 2), larval_seq,
@@ -1919,6 +1972,9 @@ int cc_hash_alloc(struct cc_drvdata *drvdata)
 			sizeof(sha224_init) +
 			sizeof(sha256_init);
 
+	if (drvdata->hw_rev >= CC_HW_REV_713)
+		sram_size_to_alloc += sizeof(sm3_init);
+
 	if (drvdata->hw_rev >= CC_HW_REV_712)
 		sram_size_to_alloc += sizeof(digest_len_sha512_init) +
 			sizeof(sha384_init) + sizeof(sha512_init);
@@ -1948,27 +2004,28 @@ int cc_hash_alloc(struct cc_drvdata *drvdata)
 		/* We either support both HASH and MAC or none */
 		if (driver_hash[alg].min_hw_rev > drvdata->hw_rev)
 			continue;
-
-		/* register hmac version */
-		t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
-		if (IS_ERR(t_alg)) {
-			rc = PTR_ERR(t_alg);
-			dev_err(dev, "%s alg allocation failed\n",
-				driver_hash[alg].driver_name);
-			goto fail;
-		}
-		t_alg->drvdata = drvdata;
-
-		rc = crypto_register_ahash(&t_alg->ahash_alg);
-		if (rc) {
-			dev_err(dev, "%s alg registration failed\n",
-				driver_hash[alg].driver_name);
-			kfree(t_alg);
-			goto fail;
-		} else {
-			list_add_tail(&t_alg->entry, &hash_handle->hash_list);
+		if (driver_hash[alg].is_mac) {
+			/* register hmac version */
+			t_alg = cc_alloc_hash_alg(&driver_hash[alg], dev, true);
+			if (IS_ERR(t_alg)) {
+				rc = PTR_ERR(t_alg);
+				dev_err(dev, "%s alg allocation failed\n",
+					driver_hash[alg].driver_name);
+				goto fail;
+			}
+			t_alg->drvdata = drvdata;
+
+			rc = crypto_register_ahash(&t_alg->ahash_alg);
+			if (rc) {
+				dev_err(dev, "%s alg registration failed\n",
+					driver_hash[alg].driver_name);
+				kfree(t_alg);
+				goto fail;
+			} else {
+				list_add_tail(&t_alg->entry,
+					      &hash_handle->hash_list);
+			}
 		}
-
 		if (hw_mode == DRV_CIPHER_XCBC_MAC ||
 		    hw_mode == DRV_CIPHER_CMAC)
 			continue;
@@ -2170,6 +2227,8 @@ static const void *cc_larval_digest(struct device *dev, u32 mode)
 		return sha384_init;
 	case DRV_HASH_SHA512:
 		return sha512_init;
+	case DRV_HASH_SM3:
+		return sm3_init;
 	default:
 		dev_err(dev, "Invalid hash mode (%d)\n", mode);
 		return md5_init;
@@ -2190,6 +2249,8 @@ cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 	struct cc_drvdata *_drvdata = (struct cc_drvdata *)drvdata;
 	struct cc_hash_handle *hash_handle = _drvdata->hash_handle;
 	struct device *dev = drvdata_to_dev(_drvdata);
+	bool sm3_supported = (_drvdata->hw_rev >= CC_HW_REV_713);
+	cc_sram_addr_t addr;
 
 	switch (mode) {
 	case DRV_HASH_NULL:
@@ -2208,19 +2269,31 @@ cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
 			sizeof(sha224_init));
-	case DRV_HASH_SHA384:
+	case DRV_HASH_SM3:
 		return (hash_handle->larval_digest_sram_addr +
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
 			sizeof(sha224_init) +
 			sizeof(sha256_init));
+	case DRV_HASH_SHA384:
+		addr = (hash_handle->larval_digest_sram_addr +
+			sizeof(md5_init) +
+			sizeof(sha1_init) +
+			sizeof(sha224_init) +
+			sizeof(sha256_init));
+		if (sm3_supported)
+			addr += sizeof(sm3_init);
+		return addr;
 	case DRV_HASH_SHA512:
-		return (hash_handle->larval_digest_sram_addr +
+		addr = (hash_handle->larval_digest_sram_addr +
 			sizeof(md5_init) +
 			sizeof(sha1_init) +
 			sizeof(sha224_init) +
 			sizeof(sha256_init) +
 			sizeof(sha384_init));
+		if (sm3_supported)
+			addr += sizeof(sm3_init);
+		return addr;
 	default:
 		dev_err(dev, "Invalid hash mode (%d)\n", mode);
 	}
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index b367b67..e1783ea 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -42,6 +42,7 @@
 #define WORD3_QUEUE_LAST_IND	CC_GENMASK(3, QUEUE_LAST_IND)
 #define WORD4_ACK_NEEDED	CC_GENMASK(4, ACK_NEEDED)
 #define WORD4_AES_SEL_N_HASH	CC_GENMASK(4, AES_SEL_N_HASH)
+#define WORD4_AES_XOR_CRYPTO_KEY CC_GENMASK(4, AES_XOR_CRYPTO_KEY)
 #define WORD4_BYTES_SWAP	CC_GENMASK(4, BYTES_SWAP)
 #define WORD4_CIPHER_CONF0	CC_GENMASK(4, CIPHER_CONF0)
 #define WORD4_CIPHER_CONF1	CC_GENMASK(4, CIPHER_CONF1)
@@ -394,6 +395,16 @@ static inline void set_aes_not_hash_mode(struct cc_hw_desc *pdesc)
 }
 
 /*
+ * Set aes xor crypto key, this in some secenrios select SM3 engine
+ *
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_aes_xor_crypto_key(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_AES_XOR_CRYPTO_KEY, 1);
+}
+
+/*
  * Set the DOUT field of a HW descriptors to SRAM mode
  * Note: No need to check SRAM alignment since host requests do not use SRAM and
  * adaptor will enforce alignment check.
@@ -466,6 +477,8 @@ static inline void set_hash_cipher_mode(struct cc_hw_desc *pdesc,
 					enum drv_hash_mode hash_mode)
 {
 	set_cipher_mode(pdesc, cipher_mode);
+	if (hash_mode == DRV_HASH_SM3)
+		set_aes_xor_crypto_key(pdesc);
 }
 
 /*
-- 
2.7.4
