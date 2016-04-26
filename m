From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] crypto: s5p-sss: fix incorrect usage of scatterlists api
Date: Tue, 26 Apr 2016 09:29:26 +0200
Message-ID: <1461655766-27346-1-git-send-email-m.szyprowski@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	stable@vger.kernel.org
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35451 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbcDZH3t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 03:29:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sg_dma_len() macro can be used only on scattelists which are mapped, so
all calls to it before dma_map_sg() are invalid. Replace them by proper
check for direct sg segment length read.

Fixes: a49e490c7a8a ("crypto: s5p-sss - add S5PV210 advanced crypto engine support")
Fixes: 9e4a1100a445 ("crypto: s5p-sss - Handle unaligned buffers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/crypto/s5p-sss.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index ac6d62b..2b3a0cf 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -327,7 +327,7 @@ static int s5p_set_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	int err;
 
-	if (!sg_dma_len(sg)) {
+	if (!sg->length) {
 		err = -EINVAL;
 		goto exit;
 	}
@@ -349,7 +349,7 @@ static int s5p_set_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	int err;
 
-	if (!sg_dma_len(sg)) {
+	if (!sg->length) {
 		err = -EINVAL;
 		goto exit;
 	}
@@ -474,7 +474,7 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 static bool s5p_is_sg_aligned(struct scatterlist *sg)
 {
 	while (sg) {
-		if (!IS_ALIGNED(sg_dma_len(sg), AES_BLOCK_SIZE))
+		if (!IS_ALIGNED(sg->length, AES_BLOCK_SIZE))
 			return false;
 		sg = sg_next(sg);
 	}
-- 
1.9.2
