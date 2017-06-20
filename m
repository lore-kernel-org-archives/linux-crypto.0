From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 04/11] Fix ERROR: that open brace { should be on the previous
 line
Date: Tue, 20 Jun 2017 13:21:35 +0800
Message-ID: <1497936095-4623-1-git-send-email-fbihjmeric@gmail.com>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
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

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Fixed 'ERROR: that open brace { should be on the previous line'.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ca3f11f..6bcab5a 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1340,8 +1340,7 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
 			goto data_size_err;
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
 			break;
-		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
-		{
+		if (ctx->cipher_mode == DRV_CIPHER_GCTR) {
 			if (areq_ctx->plaintext_authenticate_only == true)
 				areq_ctx->is_single_pass = false;
 			break;
@@ -1912,8 +1911,7 @@ static int config_gcm_context(struct aead_request *req) {
 	memcpy(req_ctx->gcm_iv_inc1, req->iv, 16);
 
 
-	if (req_ctx->plaintext_authenticate_only == false)
-	{
+	if (req_ctx->plaintext_authenticate_only == false) {
 		__be64 temp64;
 		temp64 = cpu_to_be64(req->assoclen * 8);
 		memcpy ( &req_ctx->gcm_len_block.lenA , &temp64, sizeof(temp64) );
-- 
2.7.4
