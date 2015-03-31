From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH] crypto: omap-aes: Fix support for unequal lengths
Date: Tue, 31 Mar 2015 09:52:25 +0530
Message-ID: <1427775745-4674-3-git-send-email-lokeshvutla@ti.com>
References: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nsekhar@ti.com>, <t-kristo@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

For cases where total length of an input SGs is not same as
length of the input data for encryption, omap-aes driver
crashes. This happens in the case when IPsec is trying to use
omap-aes driver.

To avoid this, we copy all the pages from the input SG list
into a contiguous buffer and prepare a single element SG list
for this buffer with length as the total bytes to crypt, which is
similar thing that is done in case of unaligned lengths.

Fixes: 6242332ff2f3 ("crypto: omap-aes - Add support for cases of unaligned lengths")
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 42f95a4..9a28b7e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -554,15 +554,23 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 	return err;
 }
 
-static int omap_aes_check_aligned(struct scatterlist *sg)
+static int omap_aes_check_aligned(struct scatterlist *sg, int total)
 {
+	int len = 0;
+
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, 4))
 			return -1;
 		if (!IS_ALIGNED(sg->length, AES_BLOCK_SIZE))
 			return -1;
+
+		len += sg->length;
 		sg = sg_next(sg);
 	}
+
+	if (len != total)
+		return -1;
+
 	return 0;
 }
 
@@ -633,8 +641,8 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	dd->in_sg = req->src;
 	dd->out_sg = req->dst;
 
-	if (omap_aes_check_aligned(dd->in_sg) ||
-	    omap_aes_check_aligned(dd->out_sg)) {
+	if (omap_aes_check_aligned(dd->in_sg, dd->total) ||
+	    omap_aes_check_aligned(dd->out_sg, dd->total)) {
 		if (omap_aes_copy_sgs(dd))
 			pr_err("Failed to copy SGs for unaligned cases\n");
 		dd->sgs_copied = 1;
-- 
1.9.1
