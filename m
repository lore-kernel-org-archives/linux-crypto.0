From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] crypto: sahara: set nb_[in|out]_sg as signed int
Date: Thu, 19 Nov 2015 13:38:17 +0100
Message-ID: <1447936699-26854-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37730 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbbKSMj2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 07:39:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The two unsigned int variables nb_in_sg and nb_out_sg can be assigned
signed value (-EINVAL) from sg_nents_for_len().
Furthermore they are used only by dma_map_sg and dma_unmap_sg which wait
for an signed int, so they must be set as int.

Fixes: 6c2b74d4774f ("crypto: sahara - check return value of sg_nents_for_len")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sahara.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index ea9f56a..cc738f3 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -228,9 +228,9 @@ struct sahara_dev {
 
 	size_t			total;
 	struct scatterlist	*in_sg;
-	unsigned int		nb_in_sg;
+	int		nb_in_sg;
 	struct scatterlist	*out_sg;
-	unsigned int		nb_out_sg;
+	int		nb_out_sg;
 
 	u32			error;
 };
-- 
2.4.10
