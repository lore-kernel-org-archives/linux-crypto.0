From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 1/2] crypto: skcipher - return the correct request to the
 user
Date: Thu, 28 Jan 2016 07:24:00 -0800
Message-ID: <20160128152359.5394.37085.stgit@tstruk-mobl1>
References: <20160128152354.5394.90834.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160128152354.5394.90834.stgit@tstruk-mobl1>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

A user of the skcipher api may have some private context associated with
a request, like for instance the algif_skcipher does, so the api needs to
return the original skcipher_request in the callback instead of the
ablkcipher_request subtype.

Cc: <stable@vger.kernel.org> # 4.4.x-
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/skcipher.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 69230e9..22a9c2a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -142,6 +142,13 @@ static int skcipher_setkey_ablkcipher(struct crypto_skcipher *tfm,
 	return err;
 }
 
+static void skcipher_complete(struct crypto_async_request *req_base, int err)
+{
+	struct skcipher_request *req = req_base->data;
+
+	req->base.complete(&req->base, err);
+}
+
 static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
 				     int (*crypt)(struct ablkcipher_request *))
 {
@@ -151,7 +158,7 @@ static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
 
 	ablkcipher_request_set_tfm(subreq, *ctx);
 	ablkcipher_request_set_callback(subreq, skcipher_request_flags(req),
-					req->base.complete, req->base.data);
+					skcipher_complete, req);
 	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				     req->iv);
 
