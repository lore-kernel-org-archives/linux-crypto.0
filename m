From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] crypto: img-hash - shift wrapping bug in
 img_hash_hw_init()
Date: Fri, 20 Mar 2015 17:21:44 +0300
Message-ID: <20150320142144.GB5108@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbCTOWB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Mar 2015 10:22:01 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"hdev->req->nbytes" is an unsigned int so we so we lose the upper 3
bytes to the shift wrap bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

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
