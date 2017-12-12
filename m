From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 13/24] staging: ccree: fix cipher func def coding style
Date: Tue, 12 Dec 2017 14:52:59 +0000
Message-ID: <1513090395-7938-14-git-send-email-gilad@benyossef.com>
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

Fix cipher functions definition indentation according to coding
style guide lines for better code readability

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index d7687a4..0b464d8 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -435,14 +435,11 @@ static int cc_cipher_setkey(struct crypto_ablkcipher *atfm, const u8 *key,
 	return 0;
 }
 
-static void
-cc_setup_cipher_desc(
-	struct crypto_tfm *tfm,
-	struct blkcipher_req_ctx *req_ctx,
-	unsigned int ivsize,
-	unsigned int nbytes,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
+				 struct blkcipher_req_ctx *req_ctx,
+				 unsigned int ivsize, unsigned int nbytes,
+				 struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
@@ -565,12 +562,10 @@ cc_setup_cipher_desc(
 }
 
 #if SSI_CC_HAS_MULTI2
-static void cc_setup_multi2_desc(
-	struct crypto_tfm *tfm,
-	struct blkcipher_req_ctx *req_ctx,
-	unsigned int ivsize,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_setup_multi2_desc(struct crypto_tfm *tfm,
+				 struct blkcipher_req_ctx *req_ctx,
+				 unsigned int ivsize, struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 
@@ -609,15 +604,12 @@ static void cc_setup_multi2_desc(
 }
 #endif /*SSI_CC_HAS_MULTI2*/
 
-static void
-cc_setup_cipher_data(
-	struct crypto_tfm *tfm,
-	struct blkcipher_req_ctx *req_ctx,
-	struct scatterlist *dst, struct scatterlist *src,
-	unsigned int nbytes,
-	void *areq,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size)
+static void cc_setup_cipher_data(struct crypto_tfm *tfm,
+				 struct blkcipher_req_ctx *req_ctx,
+				 struct scatterlist *dst,
+				 struct scatterlist *src, unsigned int nbytes,
+				 void *areq, struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
 {
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-- 
2.7.4
