Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55951 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbeKHFGT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Nov 2018 00:06:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id s10-v6so15267517wmc.5
        for <linux-crypto@vger.kernel.org>; Wed, 07 Nov 2018 11:34:32 -0800 (PST)
Date: Wed, 7 Nov 2018 20:34:28 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] crypto: crypto_user_stat: fix use_after_free of
 struct xxx_request
Message-ID: <20181107193428.GE5133@Red>
References: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
 <1541422274-40060-6-git-send-email-clabbe@baylibre.com>
 <20181106014905.GF28490@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106014905.GF28490@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 05, 2018 at 05:49:06PM -0800, Eric Biggers wrote:
> Hi Corentin,
> 
> On Mon, Nov 05, 2018 at 12:51:14PM +0000, Corentin Labbe wrote:
> > All crypto_stats functions use the struct xxx_request for feeding stats,
> > but in some case this structure could already be freed.
> > 
> > For fixing this, the needed parameters (len and alg) will be stored
> > before the request being executed.
> > Fixes: cac5818c25d0 ("crypto: user - Implement a generic crypto statistics")
> > Reported-by: syzbot <syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com>
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  crypto/ahash.c             | 14 ++++++++--
> >  include/crypto/acompress.h | 30 ++++++++++----------
> >  include/crypto/aead.h      | 30 ++++++++++----------
> >  include/crypto/akcipher.h  | 56 ++++++++++++++++++--------------------
> >  include/crypto/hash.h      | 25 +++++++++--------
> >  include/crypto/kpp.h       | 22 +++++++--------
> >  include/crypto/skcipher.h  | 16 +++++++----
> >  include/linux/crypto.h     | 34 +++++++++++------------
> >  8 files changed, 118 insertions(+), 109 deletions(-)
> > 
> > diff --git a/crypto/ahash.c b/crypto/ahash.c
> > index 3a348fbcf8f9..3f4c44c1e80f 100644
> > --- a/crypto/ahash.c
> > +++ b/crypto/ahash.c
> > @@ -364,20 +364,26 @@ static int crypto_ahash_op(struct ahash_request *req,
> >  
> >  int crypto_ahash_final(struct ahash_request *req)
> >  {
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > +	struct crypto_alg *alg = tfm->base.__crt_alg;
> > +	unsigned int nbytes = req->nbytes;
> >  	int ret;
> >  
> >  	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
> > -	crypto_stat_ahash_final(req, ret);
> > +	crypto_stat_ahash_final(nbytes, ret, alg);
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_ahash_final);
> 
> I'm not confident this is enough.  If the request is being processed
> asynchronously, the completion callback could be used to signal another thread
> to go ahead and free the resources, including not only the request but also the
> 'tfm', which could even result in the last reference to the 'alg' being dropped
> and therefore the 'alg' being freed.  If I'm wrong, then please explain why :-)
> 
> Note: I'd also prefer a solution that is more obviously zero-overhead in the
> !CONFIG_CRYPTO_STATS case.
> 
> - Eric
> 

I think the best solution is to grab a crypto_alg refcnt before the operation and release it after.
So for example this will lead to:
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -486,7 +486,7 @@ static inline struct crypto_sync_skcipher *crypto_sync_skcipher_reqtfm(
 	return container_of(tfm, struct crypto_sync_skcipher, base);
 }
 
-static inline void crypto_stat_skcipher_encrypt(struct skcipher_request *req,
+static inline void crypto_stat_skcipher_encrypt(unsigned int cryptlen,
 						int ret, struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
@@ -494,12 +494,13 @@ static inline void crypto_stat_skcipher_encrypt(struct skcipher_request *req,
 		atomic64_inc(&alg->cipher_err_cnt);
 	} else {
 		atomic64_inc(&alg->encrypt_cnt);
-		atomic64_add(req->cryptlen, &alg->encrypt_tlen);
+		atomic64_add(cryptlen, &alg->encrypt_tlen);
 	}
+	crypto_alg_put(alg);
 #endif
 }
 
-static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
+static inline void crypto_stat_skcipher_decrypt(unsigned int cryptlen,
 						int ret, struct crypto_alg *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
@@ -507,8 +508,9 @@ static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
 		atomic64_inc(&alg->cipher_err_cnt);
 	} else {
 		atomic64_inc(&alg->decrypt_cnt);
-		atomic64_add(req->cryptlen, &alg->decrypt_tlen);
+		atomic64_add(cryptlen, &alg->decrypt_tlen);
 	}
+	crypto_alg_put(alg);
 #endif
 }
 
@@ -526,13 +528,18 @@ static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
 static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
+#ifdef CONFIG_CRYPTO_STATS
+	crypto_alg_get(alg);
+#endif
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = tfm->encrypt(req);
-	crypto_stat_skcipher_encrypt(req, ret, tfm->base.__crt_alg);
+	crypto_stat_skcipher_encrypt(cryptlen, ret, alg);
 	return ret;
 }
 
@@ -550,13 +557,18 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
+#ifdef CONFIG_CRYPTO_STATS
+	crypto_alg_get(alg);
+#endif
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = tfm->decrypt(req);
-	crypto_stat_skcipher_decrypt(req, ret, tfm->base.__crt_alg);
+	crypto_stat_skcipher_decrypt(cryptlen, ret, alg);
 	return ret;
 }

This should not have any overhead with !CONFIG_CRYPTO_STATS
The only drawback is that crypto_alg_get/crypto_alg_put need to be moved out of crypto/internal.h to include/linux/crypto.h

Herbert what do you think about that ?

Regards
