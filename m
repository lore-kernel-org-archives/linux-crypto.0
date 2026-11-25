Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592801;
	b=PyDmKSJLSCaC8EhE3kJnUp1LaTzklKBYR0/y4xGgaX1yCs+5Ojz3MWU5y4Y6u12375Mb
	 94pw0iPcNhb9YdTUQqhAHOdby4+WXH5Hyw/7DKJz/1ewNGRE9SgvcomDNXuHJ24oaUlyb
	 TAa5oM2g1rT0X6jb+GWElVyYZ4etI5SHy7ClfyRxxr03LkoQVIwW3bwPNniF3rfEGA4N2
	 mms6o+mDiHR8AvE+8bZEnsG1b80n/v6fLwJYD3Jr1lB5ts1l6dJsChhM3udhmyhZoVaTE
	 gPV8XDeqsttwJDKwRJwCoj+KoyxPH4zL2yTfGTm41Iwv3xtHb/n269cAu4oTBiVDNMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592801;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=Y3z4KSMFxg1GWLPfae2IVVy9PJMDAe5vcdEdU+Ed6KQ=;
	b=FZITY0y/15qs76hWfJhTc/j/5hUPZjfQNuKRdHm1bUtYS6yRdH+knBnKP+iNQH/avltq
	 SlNJDeAeIcs2T9aQY5rCXkA/nQKmFYma3CzFotNWfCcNjEFmCT+nHdMAtAQx5XK1xGNYD
	 6hXDINqIp9YZwsxzvA5f96k0LRLg+TOMwYj5bjiDdBUz29jz77VMUITJrwwe6Mv1dH4ZL
	 uJWn3N6+3OCOdCQdjCPDl+7TpM/+ifVRbcwhjs07F3LEQ3OHx0AgE0x/nPpI6wuEmbJVC
	 bSZqYKTQJ2Qnn6Ri9yFDAThZD9+tn4/d/eUDe8v9b/QiBRvQwzaAg2Wbo4sAcN511hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F43E60A2616;
	Wed, 25 Nov 2026 07:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F43E60A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZk6F5qzVcB6;
	Wed, 25 Nov 2026 15:46:38 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZj0C1YzVcB6;
	Wed, 25 Nov 2026 15:46:37 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 70CA5300B6F1;
	Wed, 25 Nov 2026 15:45:24 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:36 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 06/11] crypto: ccp - add SM3/SM4 command definitions
Date: Wed, 25 Nov 2026 15:46:04 +0800
Message-ID: <2e188d10d18439ada04a62c001683f34de85e416.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

Add the public SM3/SM4 command structures, the engine identifiers and
the v5 descriptor fields.  No engine or algorithm is wired up yet; this
only describes the interface the SM engine patches will use.

The new engine identifiers come with the matching CCP_CAPS_* bits.  The
SM2 engine number (8) is left reserved.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-crypto.h |  67 +++++++++++++
 drivers/crypto/ccp/ccp-dev-v5.c |  26 +++++
 drivers/crypto/ccp/ccp-dev.h    |  22 +++++
 include/linux/ccp.h             | 165 ++++++++++++++++++++++++++++++++
 4 files changed, 280 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index e42450d07168..dfd16df920a3 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -21,6 +21,8 @@
 #include <crypto/hash.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <crypto/sm3.h>
+#include <crypto/sm4.h>
 #include <crypto/akcipher.h>
 #include <crypto/skcipher.h>
 #include <crypto/internal/rsa.h>
@@ -258,6 +260,67 @@ struct ccp_rsa_req_ctx {
 #define	CCP_RSA_MAXMOD	(4 * 1024 / 8)
 #define	CCP5_RSA_MAXMOD	(16 * 1024 / 8)
 
+/***** SM3 related defines *****/
+struct ccp_sm3_ctx {
+	u32 key_len;
+	u8 key[SM3_BLOCK_SIZE];
+
+	u8 ipad[SM3_BLOCK_SIZE];
+
+	u8 opad[SM3_BLOCK_SIZE];
+	struct scatterlist opad_sg;
+
+	struct crypto_shash *hmac_tfm;
+};
+
+struct ccp_sm3_req_ctx {
+	u64 msg_bits;
+
+	unsigned int first;
+	unsigned int final;
+
+	struct scatterlist *src;
+	u32 nbytes;
+
+	u64 hash_cnt;
+	u32 hash_rem;
+
+	struct sg_table data_sg;
+
+	struct scatterlist ctx_sg;
+	u8 ctx[SM3_DIGEST_SIZE];
+
+	struct scatterlist buf_sg;
+	u32 buf_count;
+	u8 buf[SM3_BLOCK_SIZE];
+
+	struct ccp_cmd cmd;
+};
+
+struct ccp_sm3_exp_ctx {
+	u64 msg_bits;
+
+	u8 ctx[SM3_DIGEST_SIZE];
+
+	u32 buf_count;
+	u8 buf[SM3_BLOCK_SIZE];
+};
+
+/***** SM4 related defines *****/
+struct ccp_sm4_ctx {
+	struct scatterlist key_sg;
+	u8 key[SM4_KEY_SIZE];
+	u32 key_len;
+	u32 mode;
+};
+
+struct ccp_sm4_req_ctx {
+	struct scatterlist iv_sg;
+	u8 iv[SM4_BLOCK_SIZE];
+
+	struct ccp_cmd cmd;
+};
+
 /***** Common Context Structure *****/
 struct ccp_ctx {
 	int (*complete)(struct crypto_async_request *req, int ret);
@@ -267,6 +330,8 @@ struct ccp_ctx {
 		struct ccp_rsa_ctx rsa;
 		struct ccp_sha_ctx sha;
 		struct ccp_des3_ctx des3;
+		struct ccp_sm3_ctx sm3;
+		struct ccp_sm4_ctx sm4;
 	} u;
 };
 
@@ -282,5 +347,7 @@ int ccp_register_aes_aeads(struct list_head *head);
 int ccp_register_sha_algs(struct list_head *head);
 int ccp_register_des3_algs(struct list_head *head);
 int ccp_register_rsa_algs(struct list_head *head);
+int ccp_register_sm3_algs(struct list_head *head);
+int ccp_register_sm4_algs(struct list_head *head);
 
 #endif
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index f7c107b93ccc..9b1593703ec5 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -131,6 +131,23 @@ union ccp_function {
 		u16 type:2;
 		u16 mode:3;
 	} ecc;
+	struct {
+		u16 rsvd:10;
+		u16 type:4;
+		u16 rsvd2:1;
+	} sm3;
+	struct {
+		u16 rsvd:7;
+		u16 encrypt:1;
+		u16 mode:4;
+		u16 select:1;
+		u16 rsvd2:2;
+	} sm4;
+	struct {
+		u16 size:7;
+		u16 encrypt:1;
+		u16 step:7;
+	} sm4_ctr;
 	u16 raw;
 };
 
@@ -151,6 +168,13 @@ union ccp_function {
 #define	CCP_PT_BITWISE(p)	((p)->pt.bitwise)
 #define	CCP_ECC_MODE(p)		((p)->ecc.mode)
 #define	CCP_ECC_AFFINE(p)	((p)->ecc.one)
+#define	CCP_SM3_TYPE(p)		((p)->sm3.type)
+#define	CCP_SM4_ENCRYPT(p)	((p)->sm4.encrypt)
+#define	CCP_SM4_MODE(p)		((p)->sm4.mode)
+#define	CCP_SM4_SELECT(p)	((p)->sm4.select)
+#define	CCP_SM4_CTR_ENCRYPT(p)	((p)->sm4_ctr.encrypt)
+#define	CCP_SM4_CTR_STEP(p)	((p)->sm4_ctr.step)
+#define	CCP_SM4_CTR_SIZE(p)	((p)->sm4_ctr.size)
 
 /* Word 0 */
 #define CCP5_CMD_DW0(p)		((p)->dw0)
@@ -186,6 +210,8 @@ union ccp_function {
 #define CCP5_CMD_FIX_DST(p)	((p)->dw5.fields.fixed)
 #define CCP5_CMD_SHA_LO(p)	((p)->dw4.sha_len_lo)
 #define CCP5_CMD_SHA_HI(p)	((p)->dw5.sha_len_hi)
+#define CCP5_CMD_SM3_LO(p)	((p)->dw4.sm3_len_lo)
+#define CCP5_CMD_SM3_HI(p)	((p)->dw5.sm3_len_hi)
 
 /* Word 6/7 */
 #define CCP5_CMD_DW6(p)		((p)->key_lo)
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 16d5ea7773e2..813a1b20c3c2 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -530,6 +530,23 @@ struct ccp_ecc_op {
 	enum ccp_ecc_function function;
 };
 
+struct ccp_sm3_op {
+	enum ccp_sm3_type type;
+	u64 msg_bits;
+};
+
+struct ccp_sm4_op {
+	enum ccp_sm4_action action;
+	enum ccp_sm4_mode mode;
+	u32 select;
+};
+
+struct ccp_sm4_ctr_op {
+	u32 size;
+	enum ccp_sm4_action action;
+	u32 step;
+};
+
 struct ccp_op {
 	struct ccp_cmd_queue *cmd_q;
 
@@ -553,6 +570,9 @@ struct ccp_op {
 		struct ccp_rsa_op rsa;
 		struct ccp_passthru_op passthru;
 		struct ccp_ecc_op ecc;
+		struct ccp_sm3_op sm3;
+		struct ccp_sm4_op sm4;
+		struct ccp_sm4_ctr_op sm4_ctr;
 	} u;
 };
 
@@ -601,6 +621,7 @@ struct dword3 {
 union dword4 {
 	u32 dst_lo;		/* NON-SHA	*/
 	u32 sha_len_lo;		/* SHA		*/
+	u32 sm3_len_lo;		/* SM3		*/
 };
 
 union dword5 {
@@ -611,6 +632,7 @@ union dword5 {
 		unsigned int  fixed:1;
 	} fields;
 	u32 sha_len_hi;
+	u32 sm3_len_hi;
 };
 
 struct dword7 {
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 06c3b14a1eb6..43020be71bc4 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -617,6 +617,158 @@ struct ccp_ecc_engine {
 	u16 ecc_result;
 };
 
+/***** SM3 engine *****/
+/**
+ * enum ccp_sm3_type - type of SM3 operation
+ *
+ * @CCP_SM3_TYPE_256: SM3-256 operation
+ */
+enum ccp_sm3_type {
+	CCP_SM3_TYPE_256 = 2,
+};
+
+/**
+ * struct ccp_sm3_engine - CCP SM3 operation
+ * @type: Type of SM3 operation
+ * @ctx: current hash value
+ * @ctx_len: length in bytes of hash value
+ * @src: data to be used for this operation
+ * @src_len: length in bytes of data used for this operation
+ * @opad: data to be used for final HMAC operation
+ * @opad_len: length in bytes of data used for final HMAC operation
+ * @first: indicates first SM3 operation
+ * @final: indicates final SM3 operation
+ * @msg_bits: total length of the message in bits used in the final
+ *	      SM3 operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - type, ctx, ctx_len, src, src_len, first, final
+ *   - opad, opad_len for the final HMAC operation
+ *   - msg_bits when final is set
+ */
+struct ccp_sm3_engine {
+	enum ccp_sm3_type type;
+
+	struct scatterlist *ctx;
+	u32 ctx_len;
+
+	struct scatterlist *src;
+	u64 src_len;
+
+	struct scatterlist *opad;
+	u32 opad_len;
+
+	u32 first;
+	u32 final;
+	u64 msg_bits;
+};
+
+/***** SM4 engine *****/
+/**
+ * enum ccp_sm4_mode - SM4 operation mode
+ *
+ * These values are hardware encodings and must not be changed.
+ *
+ * @CCP_SM4_MODE_ECB: ECB mode
+ * @CCP_SM4_MODE_CBC: CBC mode
+ * @CCP_SM4_MODE_OFB: OFB mode
+ * @CCP_SM4_MODE_CFB: CFB mode
+ * @CCP_SM4_MODE_XTS: XTS mode
+ * @CCP_SM4_MODE_CTR: CTR mode
+ */
+enum ccp_sm4_mode {
+	CCP_SM4_MODE_ECB = 0,
+	CCP_SM4_MODE_CBC,
+	CCP_SM4_MODE_OFB,
+	CCP_SM4_MODE_CFB,
+	CCP_SM4_MODE_XTS,
+	CCP_SM4_MODE_CTR,
+};
+
+/**
+ * enum ccp_sm4_action - SM4 operation
+ *
+ * @CCP_SM4_ACTION_DECRYPT: SM4 decrypt operation
+ * @CCP_SM4_ACTION_ENCRYPT: SM4 encrypt operation
+ */
+enum ccp_sm4_action {
+	CCP_SM4_ACTION_DECRYPT = 0,
+	CCP_SM4_ACTION_ENCRYPT,
+};
+
+/**
+ * struct ccp_sm4_engine - CCP SM4 operation
+ * @mode: SM4 operation mode
+ * @action: SM4 operation (decrypt/encrypt)
+ * @select: indicating that the high-security engine is selected
+ * @key: key to be used for this SM4 operation
+ * @key_len: length in bytes of key
+ * @iv: IV to be used for this SM4 operation
+ * @iv_len: length in bytes of iv
+ * @src: data to be used for this operation
+ * @dst: data produced by this operation
+ * @src_len: length in bytes of data used for this operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - mode, action, key, key_len, src, dst, src_len
+ *   - iv, iv_len for any mode other than ECB
+ *   - key_len and iv_len must be 16B
+ *   - src_len must be a multiple of 16B
+ *
+ * The iv variable is used as both input and output. On completion of the
+ * SM4 operation the new IV overwrites the old IV.
+ */
+struct ccp_sm4_engine {
+	enum ccp_sm4_mode mode;
+	enum ccp_sm4_action action;
+	u32 select;
+
+	struct scatterlist *key;
+	u32 key_len;		/* In bytes */
+
+	struct scatterlist *iv;
+	u32 iv_len;		/* In bytes */
+
+	struct scatterlist *src, *dst;
+	u64 src_len;		/* In bytes */
+};
+
+/***** SM4_CTR engine *****/
+/**
+ * struct ccp_sm4_ctr_engine - CCP SM4_CTR operation
+ * @action: SM4_CTR operation (decrypt/encrypt)
+ * @size: counter bit size
+ * @step: counter increase step
+ * @key: key to be used for this SM4 operation
+ * @key_len: length in bytes of key
+ * @iv: IV to be used for this SM4 operation
+ * @iv_len: length in bytes of iv
+ * @src: data to be used for this operation
+ * @dst: data produced by this operation
+ * @src_len: length in bytes of data used for this operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - action, size, step, key, key_len, iv, iv_len, src, dst, src_len
+ *   - key_len and iv_len must be 16B
+ *
+ * The iv variable is used as both input and output. On completion of the
+ * SM4_CTR operation the new IV overwrites the old IV.
+ */
+struct ccp_sm4_ctr_engine {
+	enum ccp_sm4_action action;
+	u32 size;
+	u32 step;
+
+	struct scatterlist *key;
+	u32 key_len;		/* In bytes */
+
+	struct scatterlist *iv;
+	u32 iv_len;		/* In bytes */
+
+	struct scatterlist *src, *dst;
+	u64 src_len;		/* In bytes */
+};
+
 
 /**
  * enum ccp_engine - CCP operation identifiers
@@ -629,6 +781,9 @@ struct ccp_ecc_engine {
  * @CCP_ENGINE_PASSTHRU: pass-through operation
  * @CCP_ENGINE_ZLIB_DECOMPRESS: unused
  * @CCP_ENGINE_ECC: ECC operation
+ * @CCP_ENGINE_SM3: SM3 operation
+ * @CCP_ENGINE_SM4: SM4 operation
+ * @CCP_ENGINE_SM4_CTR: SM4 CTR operation
  */
 enum ccp_engine {
 	CCP_ENGINE_AES = 0,
@@ -639,6 +794,10 @@ enum ccp_engine {
 	CCP_ENGINE_PASSTHRU,
 	CCP_ENGINE_ZLIB_DECOMPRESS,
 	CCP_ENGINE_ECC,
+	/* 8 is reserved for SM2 */
+	CCP_ENGINE_SM3 = 9,
+	CCP_ENGINE_SM4,
+	CCP_ENGINE_SM4_CTR,
 	/* private: */
 	CCP_ENGINE__LAST,
 };
@@ -651,6 +810,9 @@ enum ccp_engine {
 #define CCP_CAPS_RSA		BIT(CCP_ENGINE_RSA)
 #define CCP_CAPS_PASSTHRU	BIT(CCP_ENGINE_PASSTHRU)
 #define CCP_CAPS_ECC		BIT(CCP_ENGINE_ECC)
+#define CCP_CAPS_SM3		BIT(CCP_ENGINE_SM3)
+#define CCP_CAPS_SM4		BIT(CCP_ENGINE_SM4)
+#define CCP_CAPS_SM4_CTR	BIT(CCP_ENGINE_SM4_CTR)
 
 /* Flag values for flags member of ccp_cmd */
 #define CCP_CMD_MAY_BACKLOG		0x00000001
@@ -697,6 +859,9 @@ struct ccp_cmd {
 		struct ccp_passthru_engine passthru;
 		struct ccp_passthru_nomap_engine passthru_nomap;
 		struct ccp_ecc_engine ecc;
+		struct ccp_sm3_engine sm3;
+		struct ccp_sm4_engine sm4;
+		struct ccp_sm4_ctr_engine sm4_ctr;
 	} u;
 
 	/* Completion callback support */
-- 
2.34.1


