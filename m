From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 15/24] staging: ccree: fix ivgen func def coding style
Date: Tue, 12 Dec 2017 14:53:01 +0000
Message-ID: <1513090395-7938-16-git-send-email-gilad@benyossef.com>
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

Fix ivgen functions definition indentation according to coding
style guide lines for better code readability

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_ivgen.c | 16 +++++-----------
 drivers/staging/ccree/ssi_ivgen.h | 10 +++-------
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index ad6cd97..c499361 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -57,10 +57,8 @@ struct cc_ivgen_ctx {
  * \param iv_seq IN/OUT array to the descriptors sequence
  * \param iv_seq_len IN/OUT pointer to the sequence length
  */
-static int cc_gen_iv_pool(
-	struct cc_ivgen_ctx *ivgen_ctx,
-	struct cc_hw_desc iv_seq[],
-	unsigned int *iv_seq_len)
+static int cc_gen_iv_pool(struct cc_ivgen_ctx *ivgen_ctx,
+			  struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
 {
 	unsigned int idx = *iv_seq_len;
 
@@ -236,13 +234,9 @@ int cc_ivgen_init(struct ssi_drvdata *drvdata)
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_get_iv(
-	struct ssi_drvdata *drvdata,
-	dma_addr_t iv_out_dma[],
-	unsigned int iv_out_dma_len,
-	unsigned int iv_out_size,
-	struct cc_hw_desc iv_seq[],
-	unsigned int *iv_seq_len)
+int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
+	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
+	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len)
 {
 	struct cc_ivgen_ctx *ivgen_ctx = drvdata->ivgen_handle;
 	unsigned int idx = *iv_seq_len;
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/ssi_ivgen.h
index fe3d919..bbd0245 100644
--- a/drivers/staging/ccree/ssi_ivgen.h
+++ b/drivers/staging/ccree/ssi_ivgen.h
@@ -61,12 +61,8 @@ int cc_init_iv_sram(struct ssi_drvdata *drvdata);
  *
  * \return int Zero for success, negative value otherwise.
  */
-int cc_get_iv(
-	struct ssi_drvdata *drvdata,
-	dma_addr_t iv_out_dma[],
-	unsigned int iv_out_dma_len,
-	unsigned int iv_out_size,
-	struct cc_hw_desc iv_seq[],
-	unsigned int *iv_seq_len);
+int cc_get_iv(struct ssi_drvdata *drvdata, dma_addr_t iv_out_dma[],
+	      unsigned int iv_out_dma_len, unsigned int iv_out_size,
+	      struct cc_hw_desc iv_seq[], unsigned int *iv_seq_len);
 
 #endif /*__SSI_IVGEN_H__*/
-- 
2.7.4
