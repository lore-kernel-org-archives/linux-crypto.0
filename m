From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] crypto: talitos - add new crypto modes
Date: Tue,  1 Dec 2015 12:44:15 +0100 (CET)
Message-ID: <20151201114415.97E331A2438@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the following algorithms to the talitos driver:
* ecb(aes)
* ctr(aes)
* ecb(des)
* cbc(des)
* ecb(des3_ede)

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos.h |  1 +
 2 files changed, 84 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ab33898..a0d4a08 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2324,6 +2324,22 @@ static struct talitos_alg_template driver_algs[] = {
 	/* ABLKCIPHER algorithms. */
 	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.alg.crypto = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_ASYNC,
+			.cra_ablkcipher = {
+				.min_keysize = AES_MIN_KEY_SIZE,
+				.max_keysize = AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU,
+	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -2341,6 +2357,73 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.alg.crypto = {
+			.cra_name = "ctr(aes)",
+			.cra_driver_name = "ctr-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_ASYNC,
+			.cra_ablkcipher = {
+				.min_keysize = AES_MIN_KEY_SIZE,
+				.max_keysize = AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CTR,
+	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "ecb(des)",
+			.cra_driver_name = "ecb-des-talitos",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_ASYNC,
+			.cra_ablkcipher = {
+				.min_keysize = DES_KEY_SIZE,
+				.max_keysize = DES_KEY_SIZE,
+				.ivsize = DES_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU,
+	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "cbc(des)",
+			.cra_driver_name = "cbc-des-talitos",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_ASYNC,
+			.cra_ablkcipher = {
+				.min_keysize = DES_KEY_SIZE,
+				.max_keysize = DES_KEY_SIZE,
+				.ivsize = DES_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "ecb-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+				     CRYPTO_ALG_ASYNC,
+			.cra_ablkcipher = {
+				.min_keysize = DES3_EDE_KEY_SIZE,
+				.max_keysize = DES3_EDE_KEY_SIZE,
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_3DES,
+	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 0090f32..8dd8f40 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -345,6 +345,7 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 /* primary execution unit mode (MODE0) and derivatives */
 #define	DESC_HDR_MODE0_ENCRYPT		cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
+#define	DESC_HDR_MODE0_AESU_CTR		cpu_to_be32(0x00600000)
 #define	DESC_HDR_MODE0_DEU_CBC		cpu_to_be32(0x00400000)
 #define	DESC_HDR_MODE0_DEU_3DES		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_MDEU_CONT	cpu_to_be32(0x08000000)
-- 
2.1.0
