From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 01/18] crypto: marvell: easier way to get the transform
Date: Sun, 18 Oct 2015 17:23:30 +0100
Message-ID: <E1Znqk6-0005W5-Kk@rmk-PC.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45184 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbJRQXi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:23:38 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There's an easier way to get at the hash transform - rather than
using crypto_ahash_tfm(ahash), we can get it directly from
req->base.tfm.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index a24ceda7acfe..d9cc49e9c43b 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -803,7 +803,7 @@ static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
 	unsigned int digsize = crypto_ahash_digestsize(ahash);
 	unsigned int blocksize;
 
-	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	blocksize = crypto_tfm_alg_blocksize(req->base.tfm);
 
 	*len = creq->len;
 	memcpy(hash, creq->state, digsize);
@@ -828,7 +828,7 @@ static int mv_cesa_ahash_import(struct ahash_request *req, const void *hash,
 	if (ret)
 		return ret;
 
-	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	blocksize = crypto_tfm_alg_blocksize(req->base.tfm);
 	if (len >= blocksize)
 		mv_cesa_update_op_cfg(&creq->op_tmpl,
 				      CESA_SA_DESC_CFG_MID_FRAG,
-- 
2.1.0
