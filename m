From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: eseqiv - fix IV generation for sync algorithms
Date: Tue, 14 Apr 2009 15:23:51 +0200
Message-ID: <20090414132351.GN6791@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:44067 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZDNNVw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Apr 2009 09:21:52 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If crypto_ablkcipher_encrypt() returns synchronous,
eseqiv_complete2() is called even if req->giv is already the
pointer to the generated IV. The generated IV is overwritten
with some random data in this case. This patch fixes this by
calling eseqiv_complete2() just in the case where an asynchronous
algorithm would call eseqiv_complete() as the complete function.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/eseqiv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 2a342c8..2fa53b0 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -153,7 +153,8 @@ static int eseqiv_givencrypt(struct skcipher_givcrypt_request *req)
 	if (err)
 		goto out;
 
-	eseqiv_complete2(req);
+	if (complete == eseqiv_complete)
+		eseqiv_complete2(req);
 
 out:
 	return err;
-- 
1.5.4.2

