From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2 v2] crypto: img-hash - shift wrapping bug in
 img_hash_hw_init()
Date: Mon, 23 Mar 2015 14:03:55 +0300
Message-ID: <20150323110355.GB10964@mwanda>
References: <72BC0C8BD7BB6F45988A99382E5FBAE54446CD50@hhmail02.hh.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbCWLEN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2015 07:04:13 -0400
Content-Disposition: inline
In-Reply-To: <72BC0C8BD7BB6F45988A99382E5FBAE54446CD50@hhmail02.hh.imgtec.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"hdev->req->nbytes" is an unsigned int so we so we lose the upper 3 bits
to the shift wrap bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: typo in changelog

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 601ab35..ad47d0d 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -464,7 +464,7 @@ static int img_hash_hw_init(struct img_hash_dev *hdev)
 	img_hash_write(hdev, CR_RESET, CR_RESET_UNSET);
 	img_hash_write(hdev, CR_INTENAB, CR_INT_NEW_RESULTS_SET);
 
-	nbits = (hdev->req->nbytes << 3);
+	nbits = (u64)hdev->req->nbytes << 3;
 	u = nbits >> 32;
 	l = nbits;
 	img_hash_write(hdev, CR_MESSAGE_LENGTH_H, u);
