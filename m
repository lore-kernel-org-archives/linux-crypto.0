From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 4/5] authenc: Check if the IV is already added to the
	scatterlist
Date: Mon, 8 Jun 2009 09:11:43 +0200
Message-ID: <20090608071143.GV20366@secunet.com>
References: <20090608070749.GR20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58247 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZFHHJQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2009 03:09:16 -0400
Content-Disposition: inline
In-Reply-To: <20090608070749.GR20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

aead eseqiv needs to add the IV to the scatterlist itself.
So check if the IV is already contained in the scatterlist
and add it just if it is not already there.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/authenc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5793b64..e11029a 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -157,15 +157,16 @@ static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
 
 	dstp = sg_page(dst);
 	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
+	cryptlen = req->cryptlen;
 
-	if (ivsize) {
+	if (ivsize && !(aead_request_flags(req) & CRYPTO_TFM_REQ_SG_HAS_IV)) {
 		sg_init_table(cipher, 2);
 		sg_set_buf(cipher, iv, ivsize);
 		authenc_chain(cipher, dst, vdst == iv + ivsize);
 		dst = cipher;
+		cryptlen += ivsize;
 	}
 
-	cryptlen = req->cryptlen + ivsize;
 	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
-- 
1.5.4.2

