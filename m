From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 1/4] crypto: caam - constify key data
Date: Tue, 19 Dec 2017 12:16:04 +0200
Message-ID: <20171219101607.15323-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0049.outbound.protection.outlook.com ([104.47.42.49]:24020
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1760384AbdLSKQ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 05:16:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Key data is not modified, it is copied in the shared descriptor.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c |  6 +++---
 drivers/crypto/caam/desc_constr.h  | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 530c14ee32de..2db9e85bf81c 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1075,7 +1075,7 @@ void cnstr_shdsc_ablkcipher_encap(u32 * const desc, struct alginfo *cdata,
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		u8 *nonce = cdata->key_virt + cdata->keylen;
+		const u8 *nonce = cdata->key_virt + cdata->keylen;
 
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
 				   LDST_CLASS_IND_CCB |
@@ -1140,7 +1140,7 @@ void cnstr_shdsc_ablkcipher_decap(u32 * const desc, struct alginfo *cdata,
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		u8 *nonce = cdata->key_virt + cdata->keylen;
+		const u8 *nonce = cdata->key_virt + cdata->keylen;
 
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
 				   LDST_CLASS_IND_CCB |
@@ -1209,7 +1209,7 @@ void cnstr_shdsc_ablkcipher_givencap(u32 * const desc, struct alginfo *cdata,
 
 	/* Load Nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
-		u8 *nonce = cdata->key_virt + cdata->keylen;
+		const u8 *nonce = cdata->key_virt + cdata->keylen;
 
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
 				   LDST_CLASS_IND_CCB |
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index ba1ca0806f0a..5b39b7d7a47a 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -109,7 +109,7 @@ static inline void init_job_desc_shared(u32 * const desc, dma_addr_t ptr,
 	append_ptr(desc, ptr);
 }
 
-static inline void append_data(u32 * const desc, void *data, int len)
+static inline void append_data(u32 * const desc, const void *data, int len)
 {
 	u32 *offset = desc_end(desc);
 
@@ -172,7 +172,7 @@ static inline void append_cmd_ptr_extlen(u32 * const desc, dma_addr_t ptr,
 	append_cmd(desc, len);
 }
 
-static inline void append_cmd_data(u32 * const desc, void *data, int len,
+static inline void append_cmd_data(u32 * const desc, const void *data, int len,
 				   u32 command)
 {
 	append_cmd(desc, command | IMMEDIATE | len);
@@ -271,7 +271,7 @@ APPEND_SEQ_PTR_INTLEN(in, IN)
 APPEND_SEQ_PTR_INTLEN(out, OUT)
 
 #define APPEND_CMD_PTR_TO_IMM(cmd, op) \
-static inline void append_##cmd##_as_imm(u32 * const desc, void *data, \
+static inline void append_##cmd##_as_imm(u32 * const desc, const void *data, \
 					 unsigned int len, u32 options) \
 { \
 	PRINT_POS; \
@@ -312,7 +312,7 @@ APPEND_CMD_PTR_LEN(seq_out_ptr, SEQ_OUT_PTR, u32)
  * from length of immediate data provided, e.g., split keys
  */
 #define APPEND_CMD_PTR_TO_IMM2(cmd, op) \
-static inline void append_##cmd##_as_imm(u32 * const desc, void *data, \
+static inline void append_##cmd##_as_imm(u32 * const desc, const void *data, \
 					 unsigned int data_len, \
 					 unsigned int len, u32 options) \
 { \
@@ -452,7 +452,7 @@ struct alginfo {
 	unsigned int keylen_pad;
 	union {
 		dma_addr_t key_dma;
-		void *key_virt;
+		const void *key_virt;
 	};
 	bool key_inline;
 };
-- 
2.12.0.264.gd6db3f216544
