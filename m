From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix IV loading for authenc (giv)decryption
Date: Fri, 26 Aug 2016 17:13:42 +0300
Message-ID: <1472220822-18888-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0080.outbound.protection.outlook.com ([104.47.33.80]:19872
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751884AbcHZOOM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2016 10:14:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For algorithms that implement IV generators before the crypto ops,
the IV needed for decryption is initially located in req->src
scatterlist, not in req->iv.
aead_givdecrypt() is updated to put the IV in place.

Cc: <stable@vger.kernel.org> # 4.3+
Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---

Herbert, as you suggested, aead_givdecrypt() is now setting the IV.

In terms of optimizations, would it be safe to assume all "geniv" authenc
algorithms - {echainiv, seqiv}(authenc) - get assoc,iv,ciphertext in
req->src for decryption?
The idea would be to avoid copying IV into req->iv and instruct
the crypto engine to access it directly from req->src scatterlist.

 drivers/crypto/caam/caamalg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 6dc597126b79..78be2bea1273 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2545,6 +2545,7 @@ static int aead_givdecrypt(struct aead_request *req)
 	if (req->cryptlen < ivsize)
 		return -EINVAL;
 
+	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
 	req->cryptlen -= ivsize;
 	req->assoclen += ivsize;
 
-- 
2.4.4
