From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 03/11] crypto: omap-sham: implement context export/import
 APIs
Date: Thu, 4 Aug 2016 13:28:38 +0300
Message-ID: <1470306526-27219-4-git-send-email-t-kristo@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>, <davem@davemloft.net>,
 <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
 <linux-omap@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Context export/import are now required for ahash algorithms due to
required support in algif_hash. Implement these for OMAP SHA driver,
saving and restoring the internal state of the driver.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6e53944..aa71e61 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1379,6 +1379,27 @@ exit_unlock:
 	return ret;
 }
 
+static int omap_sham_export(struct ahash_request *req, void *out)
+{
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+
+	while (omap_sham_flush(req) == -EINPROGRESS)
+		msleep(10);
+
+	memcpy(out, rctx, sizeof(*rctx) + SHA512_BLOCK_SIZE);
+
+	return 0;
+}
+
+static int omap_sham_import(struct ahash_request *req, const void *in)
+{
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+
+	memcpy(rctx, in, sizeof(*rctx) + SHA512_BLOCK_SIZE);
+
+	return 0;
+}
+
 static struct ahash_alg algs_sha1_md5[] = {
 {
 	.init		= omap_sham_init,
@@ -2037,8 +2058,14 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	for (i = 0; i < dd->pdata->algs_info_size; i++) {
 		for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
-			err = crypto_register_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
+			struct ahash_alg *alg;
+
+			alg = &dd->pdata->algs_info[i].algs_list[j];
+			alg->export = omap_sham_export;
+			alg->import = omap_sham_import;
+			alg->halg.statesize = sizeof(struct omap_sham_reqctx) +
+				SHA512_BLOCK_SIZE;
+			err = crypto_register_ahash(alg);
 			if (err)
 				goto err_algs;
 
-- 
1.9.1
