From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/11] [CRYPTO] ablkcipher: Added ablkcipher_request_complete
Date: Thu, 22 Nov 2007 16:48:44 +0800
Message-ID: <E1Iv7jo-00020h-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1104 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751702AbXKVJCe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 04:02:34 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7js-0008Cr-2f
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:49 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] ablkcipher: Added ablkcipher_request_complete

This patch adds the helper ablkcipher_request_complete which should be
called when an ablkcipher algorithm has completed a request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/algapi.h |    6 ++++++
 1 files changed, 6 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index bb8a2e8..e4a4092 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -297,6 +297,12 @@ static inline void *ablkcipher_request_ctx(struct ablkcipher_request *req)
 	return req->__ctx;
 }
 
+static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
+					       int err)
+{
+	req->base.complete(&req->base, err);
+}
+
 static inline int ablkcipher_tfm_in_queue(struct crypto_queue *queue,
 					  struct crypto_ablkcipher *tfm)
 {
