From: Megha Dey <megha.dey@intel.com>
Subject: Re: [RFC] crypto: Remove mcryptd
Date: Thu, 09 Aug 2018 19:40:33 -0700
Message-ID: <1533868833.19050.19.camel@megha-Z97X-UD7-TH>
References: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
         <20180720035325.m5tzeuqsfej3y6wd@gondor.apana.org.au>
         <1532651107.19157.24.camel@megha-Z97X-UD7-TH>
         <20180808095621.h7ecacftx5ofe5ki@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180808095621.h7ecacftx5ofe5ki@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2018-08-08 at 17:56 +0800, Herbert Xu wrote:
> On Thu, Jul 26, 2018 at 05:25:07PM -0700, Megha Dey wrote:
> > 
> > 1. On the existing algorithms covered in aesni_intel-glue.c (eg:
> > __cbc-aes-aesni), 3 algorithms are registered in /proc/crypto:
> > 
> >      __cbc(aes)
> >      cryptd(__cbc-aes-aesni)--> registered via cryptd_create_skcipher
> > 
> >      cbc(aes)
> >      cbc-aes-aesni	--> registered via simd_skcipher_create_compat
> > 
> >      __cbc(aes)
> >      __cbc-aes-aesni    --> registered as the internal algorithm
> > 
> > I would want to know why do we need the cryptd(__cbc-aes-aesni)
> > algorithm at all. I do not see any of the associated setkey, encrypt or
> > decrypt functions getting called during the selftest or while running
> > tcrypt. I just see the simd_(setkey, encrypt, decrypt) functions
> > directly called the inner algorithms. However, if I remove the cryptd
> > algorithm, none of the algorithms are registered.
> 
> The simd functions are the fast path where you are running in a
> context where SIMD can be used directly.  cryptd is the slow path
> where we defer the work to a work queue.

Hi Herbert,

Thank you for the clarification.

I seem to have gotten things to work (i.e remove mcryptd layer). I have
tried this with the skcipher on top of my previously posted patches for
the aes-cbc-mb multibuffer algorithm since the simd wrappers already
exist for it. I am working on extending to hashes, sorry for the
confusion.

I would like to get your approval first on the changes I have made in
the cryptd layer:

1. 
@@ -495,7 +534,10 @@ static void cryptd_skcipher_encrypt(struct
crypto_async_request *base,
        skcipher_request_set_crypt(subreq, req->src, req->dst,
req->cryptlen, req->iv);
 
-       err = crypto_skcipher_encrypt(subreq);
+       subreq->base.data = req->base.data;
+       subreq->base.complete = rctx->complete;
+       rctx->desc = *subreq;
+       err = crypto_skcipher_encrypt(&rctx->desc);
        skcipher_request_zero(subreq);

This change is necessary because for the multibuffer algorithms, the
inner algorithm needs a pointer to the original request. In the slow
path, since we allocate a skcipher_request on the stack, there is no
easy way to retrieve the request. In the mcryptd_layer, we had extra
logic to store this pointer. 

2. Currently, 
-struct cryptd_skcipher_request_ctx {
-       crypto_completion_t complete;
-};
-

For multibuffer algorithms, we need more structure members:
+struct cryptd_skcipher_request_ctx {
+        struct list_head waiter;
+        crypto_completion_t complete;
+        struct cryptd_tag tag;
+        struct skcipher_walk walk;
+        u8 flag;
+        int nbytes;
+        int error;
+        struct skcipher_request desc;
+        void *job;
+        u128 seq_iv;

I am not sure if adding the member to the original structure definition
is acceptable or I should introduce a new structure.

Lastly, for hashes, we have
struct cryptd_hash_request_ctx {
        crypto_completion_t complete;
        struct shash_desc desc;
};

If we were to use this(with the added fields for multibuffer), we should
update the shash_desc to ahash_request since we are an async algorithm
right?


> 
> > > What you need to do is create an actual simd wrapper with cryptd
> >  
> > This simd wrapper is already present for skcipher right(in simd.c)?
> > Assuming we only have ciphers and no hash algorithms, are any changes
> > required in these wrappers?
> 
> For skcipher yes they already exist.  But this thread was about
> hashes.
> 
> Cheers,
