From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/6] crypto: sun4i-ss: fix a few signed warning
Date: Wed, 10 Aug 2016 11:45:29 +0200
Message-ID: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33990 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062AbcHJS1L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 14:27:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The variable i is always checked against unsigned value and cannot be
negative.
This patch set it as unsigned.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 3830d7c..90efd10 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -29,7 +29,8 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	u32 tx_cnt = 0;
 	u32 spaces;
 	u32 v;
-	int i, err = 0;
+	int err = 0;
+	unsigned int i;
 	unsigned int ileft = areq->nbytes;
 	unsigned int oleft = areq->nbytes;
 	unsigned int todo;
@@ -139,7 +140,8 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	u32 tx_cnt = 0;
 	u32 v;
 	u32 spaces;
-	int i, err = 0;
+	int err = 0;
+	unsigned int i;
 	unsigned int ileft = areq->nbytes;
 	unsigned int oleft = areq->nbytes;
 	unsigned int todo;
-- 
2.7.3
