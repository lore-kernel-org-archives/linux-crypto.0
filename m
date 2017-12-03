From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 10/10] staging: ccree: amend aead func def for readability
Date: Sun,  3 Dec 2017 13:58:21 +0000
Message-ID: <1512309503-29766-11-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Func definitions in the aead implementation were did not adhere to
coding style. Fix them for better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 141 ++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 54edd99..5548c7b 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -678,9 +678,8 @@ static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 }
 #endif /*SSI_CC_HAS_AES_CCM*/
 
-static int cc_aead_setauthsize(
-	struct crypto_aead *authenc,
-	unsigned int authsize)
+static int cc_aead_setauthsize(struct crypto_aead *authenc,
+			       unsigned int authsize)
 {
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
@@ -733,12 +732,8 @@ static int cc_ccm_setauthsize(struct crypto_aead *authenc,
 }
 #endif /*SSI_CC_HAS_AES_CCM*/
 
-static void
-cc_set_assoc_desc(
-	struct aead_request *areq,
-	unsigned int flow_mode,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
+			      struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -776,13 +771,10 @@ cc_set_assoc_desc(
 	*seq_size = (++idx);
 }
 
-static void
-cc_proc_authen_desc(
-	struct aead_request *areq,
-	unsigned int flow_mode,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size,
-	int direct)
+static void cc_proc_authen_desc(struct aead_request *areq,
+				unsigned int flow_mode,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size, int direct)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
 	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
@@ -843,12 +835,10 @@ cc_proc_authen_desc(
 	*seq_size = (++idx);
 }
 
-static void
-cc_proc_cipher_desc(
-	struct aead_request *areq,
-	unsigned int flow_mode,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_proc_cipher_desc(struct aead_request *areq,
+				unsigned int flow_mode,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
@@ -891,10 +881,9 @@ cc_proc_cipher_desc(
 	*seq_size = (++idx);
 }
 
-static void cc_proc_digest_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_proc_digest_desc(struct aead_request *req,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -942,10 +931,9 @@ static void cc_proc_digest_desc(
 	*seq_size = (++idx);
 }
 
-static void cc_set_cipher_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_set_cipher_desc(struct aead_request *req,
+			       struct cc_hw_desc desc[],
+			       unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -988,11 +976,8 @@ static void cc_set_cipher_desc(
 	*seq_size = idx;
 }
 
-static void cc_proc_cipher(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size,
-	unsigned int data_flow_mode)
+static void cc_proc_cipher(struct aead_request *req, struct cc_hw_desc desc[],
+			   unsigned int *seq_size, unsigned int data_flow_mode)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
@@ -1014,10 +999,8 @@ static void cc_proc_cipher(
 	*seq_size = idx;
 }
 
-static void cc_set_hmac_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_set_hmac_desc(struct aead_request *req, struct cc_hw_desc desc[],
+			     unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1051,10 +1034,8 @@ static void cc_set_hmac_desc(
 	*seq_size = idx;
 }
 
-static void cc_set_xcbc_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_set_xcbc_desc(struct aead_request *req, struct cc_hw_desc desc[],
+			     unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1113,10 +1094,9 @@ static void cc_set_xcbc_desc(
 	*seq_size = idx;
 }
 
-static void cc_proc_header_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_proc_header_desc(struct aead_request *req,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
 {
 	unsigned int idx = *seq_size;
 	/* Hash associated data */
@@ -1127,10 +1107,9 @@ static void cc_proc_header_desc(
 	*seq_size = idx;
 }
 
-static void cc_proc_scheme_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_proc_scheme_desc(struct aead_request *req,
+				struct cc_hw_desc desc[],
+				unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1192,10 +1171,8 @@ static void cc_proc_scheme_desc(
 	*seq_size = idx;
 }
 
-static void cc_mlli_to_sram(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_mlli_to_sram(struct aead_request *req,
+			    struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -1221,10 +1198,9 @@ static void cc_mlli_to_sram(
 	}
 }
 
-static enum cc_flow_mode cc_get_data_flow(
-	enum drv_crypto_direction direct,
-	enum cc_flow_mode setup_flow_mode,
-	bool is_single_pass)
+static enum cc_flow_mode cc_get_data_flow(enum drv_crypto_direction direct,
+					  enum cc_flow_mode setup_flow_mode,
+					  bool is_single_pass)
 {
 	enum cc_flow_mode data_flow_mode;
 
@@ -1247,10 +1223,8 @@ static enum cc_flow_mode cc_get_data_flow(
 	return data_flow_mode;
 }
 
-static void cc_hmac_authenc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_hmac_authenc(struct aead_request *req, struct cc_hw_desc desc[],
+			    unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1301,10 +1275,8 @@ static void cc_hmac_authenc(
 }
 
 static void
-cc_xcbc_authenc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+cc_xcbc_authenc(struct aead_request *req, struct cc_hw_desc desc[],
+		unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1449,10 +1421,8 @@ static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
 	return 0;
 }
 
-static int cc_ccm(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static int cc_ccm(struct aead_request *req, struct cc_hw_desc desc[],
+		  unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1659,10 +1629,8 @@ static void cc_proc_rfc4309_ccm(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static void cc_set_ghash_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_set_ghash_desc(struct aead_request *req,
+			      struct cc_hw_desc desc[], unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1739,10 +1707,8 @@ static void cc_set_ghash_desc(
 	*seq_size = idx;
 }
 
-static void cc_set_gctr_desc(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_set_gctr_desc(struct aead_request *req, struct cc_hw_desc desc[],
+			     unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1777,10 +1743,9 @@ static void cc_set_gctr_desc(
 	*seq_size = idx;
 }
 
-static void cc_proc_gcm_result(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_proc_gcm_result(struct aead_request *req,
+			       struct cc_hw_desc desc[],
+			       unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1843,10 +1808,8 @@ static void cc_proc_gcm_result(
 	*seq_size = idx;
 }
 
-static int cc_gcm(
-	struct aead_request *req,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static int cc_gcm(struct aead_request *req, struct cc_hw_desc desc[],
+		  unsigned int *seq_size)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int cipher_flow_mode;
@@ -1883,9 +1846,7 @@ static int cc_gcm(
 }
 
 #ifdef CC_DEBUG
-static void cc_dump_gcm(
-	const char *title,
-	struct aead_request *req)
+static void cc_dump_gcm(const char *title, struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
-- 
2.7.4
