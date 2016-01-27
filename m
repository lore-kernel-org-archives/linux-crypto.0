From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/3] crypto: skcipher - return the correct request to the
 user
Date: Wed, 27 Jan 2016 09:13:56 -0800
Message-ID: <20160127171355.32579.12218.stgit@tstruk-mobl1>
References: <20160127171350.32579.49931.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbcA0RRt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 12:17:49 -0500
In-Reply-To: <20160127171350.32579.49931.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A user of the skcipher api may have some private context associated with
a request, like for instance the algif_skcipher does, so the api needs to
return the original skcipher_request in the callback instead of the
ablkcipher_request subtype.

Cc: <stable@vger.kernel.org> # 4.4.x-
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/skcipher.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 69230e9..a9d54c0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -142,6 +142,15 @@ static int skcipher_setkey_ablkcipher(struct crypto_skcipher *tfm,
 	return err;
 }
 
+static void skcipher_complete(struct crypto_async_request *req_base, int err)
+{
+	void *subreq = ablkcipher_request_cast(req_base);
+	struct skcipher_request *req =
+			container_of(subreq, struct skcipher_request, __ctx);
+
+	req->base.complete(&req->base, err);
+}
+
 static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
 				     int (*crypt)(struct ablkcipher_request *))
 {
@@ -151,7 +160,7 @@ static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
 
 	ablkcipher_request_set_tfm(subreq, *ctx);
 	ablkcipher_request_set_callback(subreq, skcipher_request_flags(req),
-					req->base.complete, req->base.data);
+					skcipher_complete, req->base.data);
 	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				     req->iv);
 
