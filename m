From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: picoxcell: set [src|dst]_nents and nents as signed int
Date: Thu, 19 Nov 2015 13:38:18 +0100
Message-ID: <1447936699-26854-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1447936699-26854-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au,
	jamie@jamieiles.com, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36161 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbbKSMjb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 07:39:31 -0500
In-Reply-To: <1447936699-26854-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The unsigned int variables [src|dst]_nents and nents can be assigned
signed value (-EINVAL) from sg_nents_for_len().
Furthermore they are used only by dma_map_sg and dma_unmap_sg which wait
for an signed int, so they must be set as int.

Fixes: f051f95eb47b ("crypto: picoxcell - check return value of sg_nents_for_len")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/picoxcell_crypto.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a9c6367..15b5e39 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -289,10 +289,11 @@ static struct spacc_ddt *spacc_sg_to_ddt(struct spacc_engine *engine,
 					 enum dma_data_direction dir,
 					 dma_addr_t *ddt_phys)
 {
-	unsigned nents, mapped_ents;
+	unsigned mapped_ents;
 	struct scatterlist *cur;
 	struct spacc_ddt *ddt;
 	int i;
+	int nents;
 
 	nents = sg_nents_for_len(payload, nbytes);
 	if (nents < 0) {
@@ -326,7 +327,7 @@ static int spacc_aead_make_ddts(struct aead_request *areq)
 	struct spacc_engine *engine = req->engine;
 	struct spacc_ddt *src_ddt, *dst_ddt;
 	unsigned total;
-	unsigned int src_nents, dst_nents;
+	int src_nents, dst_nents;
 	struct scatterlist *cur;
 	int i, dst_ents, src_ents;
 
-- 
2.4.10
