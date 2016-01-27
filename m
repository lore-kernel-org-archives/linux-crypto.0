From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/3] crypto: algif_skcipher - increase private contex space
 for async request
Date: Wed, 27 Jan 2016 09:14:06 -0800
Message-ID: <20160127171406.32579.69197.stgit@tstruk-mobl1>
References: <20160127171350.32579.49931.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160127171350.32579.49931.stgit@tstruk-mobl1>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The private context space that was allocated for the async request was too
small. It accidentally worked fine (at least with the qat driver) because
the qat driveri, by mistake, allocated too much.
The problem started to show up since the qat driver issue has been fixed in
commit: 7768fb2ee.

We also need another version of this patch applicable to the code before
skcipher conversion that adds sizeof(struct ablkcipher_request)

Cc: <stable@vger.kernel.org> # 4.4.x-
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_skcipher.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 78529ce..298605d 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -69,10 +69,12 @@ struct skcipher_async_req {
 };
 
 #define GET_SREQ(areq, ctx) (struct skcipher_async_req *)((char *)areq + \
-	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req)))
+	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req)) + \
+	sizeof(struct skcipher_request))
 
 #define GET_REQ_SIZE(ctx) \
-	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req))
+	crypto_skcipher_reqsize(crypto_skcipher_reqtfm(&ctx->req)) + \
+	sizeof(struct skcipher_request)
 
 #define GET_IV_SIZE(ctx) \
 	crypto_skcipher_ivsize(crypto_skcipher_reqtfm(&ctx->req))
