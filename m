From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: marvell/cesa - remove unneeded condition
Date: Mon, 21 Mar 2016 12:03:43 +0300
Message-ID: <20160321090342.GB31670@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26251 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbcCUJE0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 05:04:26 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

creq->cache[] is an array inside the struct, it's not a pointer and it
can't be NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 7ca2e0f..7a5058d 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -768,8 +768,7 @@ static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
 	*len = creq->len;
 	memcpy(hash, creq->state, digsize);
 	memset(cache, 0, blocksize);
-	if (creq->cache)
-		memcpy(cache, creq->cache, creq->cache_ptr);
+	memcpy(cache, creq->cache, creq->cache_ptr);
 
 	return 0;
 }
