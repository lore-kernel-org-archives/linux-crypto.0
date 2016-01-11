From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: skcipher - Add crypto_skcipher_has_setkey
Date: Mon, 11 Jan 2016 21:26:50 +0800
Message-ID: <20160111132650.GA25134@gondor.apana.org.au>
References: <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
 <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au>
 <568A66B2.4090307@gmail.com>
 <20160108124851.GA5425@gondor.apana.org.au>
 <568FFE18.6090900@gmail.com>
 <20160109054103.GA11188@gondor.apana.org.au>
 <5690DD9C.4010408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5690DD9C.4010408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds a way for skcipher users to determine whether a key
is required by a transform.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7591928..d199c0b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -118,6 +118,7 @@ static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 	skcipher->decrypt = skcipher_decrypt_blkcipher;
 
 	skcipher->ivsize = crypto_blkcipher_ivsize(blkcipher);
+	skcipher->has_setkey = calg->cra_blkcipher.max_keysize;
 
 	return 0;
 }
@@ -210,6 +211,7 @@ static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 	skcipher->ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	skcipher->reqsize = crypto_ablkcipher_reqsize(ablkcipher) +
 			    sizeof(struct ablkcipher_request);
+	skcipher->has_setkey = calg->cra_ablkcipher.max_keysize;
 
 	return 0;
 }
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index d8dd41f..fd8742a 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -61,6 +61,8 @@ struct crypto_skcipher {
 	unsigned int ivsize;
 	unsigned int reqsize;
 
+	bool has_setkey;
+
 	struct crypto_tfm base;
 };
 
@@ -305,6 +307,11 @@ static inline int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 	return tfm->setkey(tfm, key, keylen);
 }
 
+static inline bool crypto_skcipher_has_setkey(struct crypto_skcipher *tfm)
+{
+	return tfm->has_setkey;
+}
+
 /**
  * crypto_skcipher_reqtfm() - obtain cipher handle from request
  * @req: skcipher_request out of which the cipher handle is to be obtained
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
