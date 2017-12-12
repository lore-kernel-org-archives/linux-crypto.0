From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/24] staging: ccree: func params should follow func name
Date: Tue, 12 Dec 2017 14:52:50 +0000
Message-ID: <1513090395-7938-5-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

Fix some call sites with func params not following func name in AEAD
code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 408ea24..75a578e 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1226,8 +1226,9 @@ static void cc_hmac_authenc(struct aead_request *req, struct cc_hw_desc desc[],
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode = cc_get_data_flow(
-		direct, ctx->flow_mode, req_ctx->is_single_pass);
+	unsigned int data_flow_mode =
+		cc_get_data_flow(direct, ctx->flow_mode,
+				 req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
 		/**
@@ -1278,8 +1279,9 @@ cc_xcbc_authenc(struct aead_request *req, struct cc_hw_desc desc[],
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode = cc_get_data_flow(
-		direct, ctx->flow_mode, req_ctx->is_single_pass);
+	unsigned int data_flow_mode =
+		cc_get_data_flow(direct, ctx->flow_mode,
+				 req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
 		/**
-- 
2.7.4
