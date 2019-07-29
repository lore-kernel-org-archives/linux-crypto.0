Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAB0C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 10:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53259206BA
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 10:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbfG2Kki (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 06:40:38 -0400
Received: from foss.arm.com ([217.140.110.172]:41748 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387428AbfG2Kki (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 06:40:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 829F815A2;
        Mon, 29 Jul 2019 03:40:37 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5108C3F694;
        Mon, 29 Jul 2019 03:40:36 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: ccree: use std api sg_zero_buffer
Date:   Mon, 29 Jul 2019 13:40:19 +0300
Message-Id: <20190729104020.3681-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729104020.3681-1-gilad@benyossef.com>
References: <20190729104020.3681-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace internal cc_zero_sgl() with kernel API of the same function
sg_zero_buffer().

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c       |  3 ++-
 drivers/crypto/ccree/cc_buffer_mgr.c | 21 ---------------------
 drivers/crypto/ccree/cc_buffer_mgr.h |  2 --
 3 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 8a6c825d40e8..f807875b541f 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -268,7 +268,8 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
-			cc_zero_sgl(areq->dst, areq->cryptlen);
+			sg_zero_buffer(areq->dst, sg_nents(areq->dst),
+				       areq->cryptlen, 0);
 			err = -EBADMSG;
 		}
 	/*ENCRYPT*/
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index c81ad33f9115..a72586eccd81 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -99,27 +99,6 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
 	return nents;
 }
 
-/**
- * cc_zero_sgl() - Zero scatter scatter list data.
- *
- * @sgl:
- */
-void cc_zero_sgl(struct scatterlist *sgl, u32 data_len)
-{
-	struct scatterlist *current_sg = sgl;
-	int sg_index = 0;
-
-	while (sg_index <= data_len) {
-		if (!current_sg) {
-			/* reached the end of the sgl --> just return back */
-			return;
-		}
-		memset(sg_virt(current_sg), 0, current_sg->length);
-		sg_index += current_sg->length;
-		current_sg = sg_next(current_sg);
-	}
-}
-
 /**
  * cc_copy_sg_portion() - Copy scatter list data,
  * from to_skip to end, to dest and vice versa
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.h b/drivers/crypto/ccree/cc_buffer_mgr.h
index a726016bdbc1..af434872c6ff 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.h
+++ b/drivers/crypto/ccree/cc_buffer_mgr.h
@@ -66,6 +66,4 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 void cc_copy_sg_portion(struct device *dev, u8 *dest, struct scatterlist *sg,
 			u32 to_skip, u32 end, enum cc_sg_cpy_direct direct);
 
-void cc_zero_sgl(struct scatterlist *sgl, u32 data_len);
-
 #endif /*__BUFFER_MGR_H__*/
-- 
2.21.0

