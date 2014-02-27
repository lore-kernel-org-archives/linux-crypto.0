From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] crypto: omap-des - make local functions static
Date: Thu, 27 Feb 2014 20:34:36 +0900
Message-ID: <000701cf33af$e46a9f80$ad3fde80$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Joel Fernandes' <joelf@ti.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46141 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0Leh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 06:34:37 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N1N00669K5OQNA0@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 27 Feb 2014 20:34:36 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make omap_des_copy_needed(), omap_des_copy_sgs(), because these
functions are used only in this file.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/omap-des.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 758919e..ec5f131 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -535,7 +535,7 @@ static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
 	return err;
 }
 
-int omap_des_copy_needed(struct scatterlist *sg)
+static int omap_des_copy_needed(struct scatterlist *sg)
 {
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, 4))
@@ -547,7 +547,7 @@ int omap_des_copy_needed(struct scatterlist *sg)
 	return 0;
 }
 
-int omap_des_copy_sgs(struct omap_des_dev *dd)
+static int omap_des_copy_sgs(struct omap_des_dev *dd)
 {
 	void *buf_in, *buf_out;
 	int pages;
-- 
1.7.10.4
