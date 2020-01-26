Return-Path: <SRS0=c791=3P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B30EC2D0DB
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Jan 2020 13:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7896420708
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Jan 2020 13:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgAZNiY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Jan 2020 08:38:24 -0500
Received: from foss.arm.com ([217.140.110.172]:36116 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgAZNiY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Jan 2020 08:38:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFE5431B;
        Sun, 26 Jan 2020 05:38:23 -0800 (PST)
Received: from e110176-lin.benyossef.com (unknown [10.50.4.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 548F73F68E;
        Sun, 26 Jan 2020 05:38:22 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] crypto: ccree - protect against short scatterlists
Date:   Sun, 26 Jan 2020 15:38:05 +0200
Message-Id: <20200126133805.20294-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Deal gracefully with the event of being handed a scatterlist
which is shorter than expected.

This mitigates a crash in some cases of crashes due to
attempt to map empty (but not NULL) scatterlists with none
zero lengths.

This is an interim patch, to help diagnoze the issue, not
intended for mainline in its current form as of yet.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 30 +++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index a72586eccd81..9667a2630c66 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -286,10 +286,32 @@ static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
 	sgl_data->num_of_buffers++;
 }
 
+static unsigned int cc_sg_trunc_len(struct scatterlist *sg, unsigned int len)
+{
+	unsigned int total;
+
+	if (!len)
+		return 0;
+
+	for (total = 0; sg; sg = sg_next(sg)) {
+		total += sg->length;
+		if (total >= len) {
+			total = len;
+			break;
+		}
+	}
+
+	return total;
+}
+
 static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 		     unsigned int nbytes, int direction, u32 *nents,
 		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
 {
+	int ret;
+
+	nbytes = cc_sg_trunc_len(sg, nbytes);
+
 	if (sg_is_last(sg)) {
 		/* One entry only case -set to DLLI */
 		if (dma_map_sg(dev, sg, 1, direction) != 1) {
@@ -313,12 +335,14 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 		/* In case of mmu the number of mapped nents might
 		 * be changed from the original sgl nents
 		 */
-		*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-		if (*mapped_nents == 0) {
+		ret = dma_map_sg(dev, sg, *nents, direction);
+		if (dma_mapping_error(dev, ret)) {
 			*nents = 0;
-			dev_err(dev, "dma_map_sg() sg buffer failed\n");
+			dev_err(dev, "dma_map_sg() sg buffer failed %d\n", ret);
 			return -ENOMEM;
 		}
+
+		*mapped_nents = ret;
 	}
 
 	return 0;
-- 
2.23.0

