From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 3/4] crypto: talitos - avoid out of bound scatterlist iterator
Date: Tue, 12 May 2015 11:28:05 +0300
Message-ID: <1431419285-9014-1-git-send-email-horia.geanta@freescale.com>
References: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:53174
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752810AbbELI2P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 04:28:15 -0400
In-Reply-To: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Check return value of scatterlist_sg_next(), i.e. don't rely solely
on number of bytes to be processed or number of scatterlist entries.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6b19b3dca616..7367f6cba2ed 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1065,7 +1065,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 {
 	int n_sg = sg_count;
 
-	while (n_sg--) {
+	while (sg && n_sg--) {
 		to_talitos_ptr(link_tbl_ptr, sg_dma_address(sg), 0);
 		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
 		link_tbl_ptr->j_extent = 0;
@@ -1254,7 +1254,7 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
 	int sg_nents = 0;
 
 	*chained = false;
-	while (nbytes > 0) {
+	while (nbytes > 0 && sg) {
 		sg_nents++;
 		nbytes -= sg->length;
 		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-- 
1.8.3.1
