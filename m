From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] crypto: talitos - fix size calculation in
 talitos_edesc_alloc()
Date: Mon, 11 May 2015 13:10:09 +0300
Message-ID: <20150511101009.GA12395@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	LEROY Christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27020 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbEKKKm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 06:10:42 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The + operation has higher precedence than ?: so we need parentheses
here.  Otherwise we may end up allocating a max of only one "cryptlen"
instead of two.

Fixes: 6f65f6ac5fb3 ('crypto: talitos - implement scatter/gather copy for SEC1')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c04074d..273942c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1335,8 +1335,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	alloc_len = sizeof(struct talitos_edesc);
 	if (assoc_nents || src_nents || dst_nents) {
 		if (is_sec1)
-			dma_len = src_nents ? cryptlen : 0 +
-				  dst_nents ? cryptlen : 0;
+			dma_len = (src_nents ? cryptlen : 0) +
+				  (dst_nents ? cryptlen : 0);
 		else
 			dma_len = (src_nents + dst_nents + 2 + assoc_nents) *
 				  sizeof(struct talitos_ptr) + authsize;
