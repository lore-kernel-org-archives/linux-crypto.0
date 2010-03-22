From: Dan Carpenter <error27@gmail.com>
Subject: [patch v2] pcrypt: handle crypto_get_attr_type() errors
Date: Mon, 22 Mar 2010 16:53:19 +0300
Message-ID: <20100322135319.GQ21571@bicker>
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100322132342.GJ20508@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I was concerned about the error handling for crypto_get_attr_type() in
pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply 
avoid calling crypto_get_attr_type() if we passed the type and mask as a 
parameter.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8020124..e049388 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -315,13 +315,11 @@ out_free_inst:
 	goto out;
 }
 
-static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
+static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
+						 struct crypto_attr_type *algt)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
 
 	alg = crypto_get_attr_alg(tb, algt->type,
 				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
@@ -365,7 +363,7 @@ static struct crypto_instance *pcrypt_alloc(struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AEAD:
-		return pcrypt_alloc_aead(tb);
+		return pcrypt_alloc_aead(tb, algt);
 	}
 
 	return ERR_PTR(-EINVAL);
