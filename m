From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Is the asynchronous hash crypto API asynchronous?
Date: Sun, 8 Jan 2017 15:45:37 +0200
Message-ID: <CAOtvUMd=EHaFq=AtMePzN9fsoMLszZ0ruAu8KaaP=W=8J7nGUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37513 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932078AbdAHNpj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Jan 2017 08:45:39 -0500
Received: by mail-it0-f51.google.com with SMTP id r185so7077936ita.0
        for <linux-crypto@vger.kernel.org>; Sun, 08 Jan 2017 05:45:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

My apologies in advance for the length of this email on what sounds
like a trivial $SUBJECT. I'm really at my wits end.

I'm working on giving dm-verity a make over and ran into something I'm
not clear about with regard to asynchronous Hash API.

Documentation/crypto/architecture.rst says:

"Asynchronous operation is provided by the kernel crypto API which
implies that the invocation of a cipher operation will complete almost
instantly. That invocation triggers the cipher operation but it does not
signal its completion. Before invoking a cipher operation, the caller
must provide a callback function the kernel crypto API can invoke to
signal the completion of the cipher operation. Furthermore, the caller
must ensure it can handle such asynchronous events by applying
appropriate locking around its data. The kernel crypto API does not
perform any special serialization operation to protect the caller's data
integrity."

Well, that sounds sane and what I would expect from an asynchronous  API.

api-intro.rst in same directory though includes this example however:

        #include <crypto/hash.h>
        #include <linux/err.h>
        #include <linux/scatterlist.h>

        struct scatterlist sg[2];
        char result[128];
        struct crypto_ahash *tfm;
        struct ahash_request *req;

        tfm = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
        if (IS_ERR(tfm))
                fail();

        /* ... set up the scatterlists ... */

        req = ahash_request_alloc(tfm, GFP_ATOMIC);
        if (!req)
                fail();

        ahash_request_set_callback(req, 0, NULL, NULL);
        ahash_request_set_crypt(req, sg, result, 2);

        if (crypto_ahash_digest(req))
                fail();

        ahash_request_free(req);
        crypto_free_ahash(tfm);

Note the NULL call back function parameter and distinct lack of any
synchronization operations on completion after crypto_ahash_digest()
is done.
Also, the code checks the return value of crypto_ahash_digest() in a
way that seems to imply the return value is the one of performing the
digest, NOT queuing an asynchronous request which later figure out if
it is indeed successful.
Well, that does not look like an invocation of an asynchronous API at all.

hmm.... documentation have been known to go out of sync (pun not
intended) with code in past. What does the API doc for
crypto_ahash_digest() say?


/**
 * crypto_ahash_digest() - calculate message digest for a buffer
 * @req: reference to the ahash_request handle that holds all information
 *       needed to perform the cipher operation
 *
 * This function is a "short-hand" for the function calls of crypto_ahash_init,
 * crypto_ahash_update and crypto_ahash_final. The parameters have the same
 * meaning as discussed for those separate three functions.
 *
 * Return: 0 if the message digest creation was successful; < 0 if an error
 *         occurred
 */
int crypto_ahash_digest(struct ahash_request *req);

Note remark says the return value indicates the *digest creation* was
successful, not submitting an asynchronous request!
This is indeed in-line in with the code example above but isn't really
asynchronous.

OK, I'm officially confused. What does the code do?

ahash_request_set_callback() doesn't seem to do anything special with
a NULL call back function:

 static inline void ahash_request_set_callback(struct ahash_request *req,
                                              u32 flags,
                                              crypto_completion_t compl,
                                              void *data)
{
        req->base.complete = compl;
        req->base.data = data;
        req->base.flags = flags;
}

Neither does the completion call site treats it in a special way
(ignoring for now the mad house which is the handling of the unaligned
requests case):

static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
{
        struct ahash_request *areq = req->data;

        ahash_def_finup_finish2(areq, err);

        areq->base.complete(&areq->base, err);
}

hmmm... perhaps the specific algorithm module handle this?


rockchip/rk3288_crypto_ahash.c indeed seems to handle a NULL call back
in a sense:

static void rk_ahash_crypto_complete(struct rk_crypto_info *dev, int err)
{
        if (dev->ahash_req->base.complete)
                dev->ahash_req->base.complete(&dev->ahash_req->base, err);
}

And since it's busy waiting for completion, the example code might even work:

static int rk_ahash_digest(struct ahash_request *req)
{
        struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
        struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
        struct rk_crypto_info *dev = NULL;
        unsigned long flags;
        int ret;
...
        tasklet_schedule(&dev->crypto_tasklet);

        /*
         * it will take some time to process date after last dma transmission.
         *
         * waiting time is relative with the last date len,
         * so cannot set a fixed time here.
         * 10-50 makes system not call here frequently wasting
         * efficiency, and make it response quickly when dma
         * complete.
         */
        while (!CRYPTO_READ(dev, RK_CRYPTO_HASH_STS))
                usleep_range(10, 50);

        memcpy_fromio(req->result, dev->reg + RK_CRYPTO_HASH_DOUT_0,
                      crypto_ahash_digestsize(tfm));

        return 0;
}

Not exactly my cup of tea and I wouldn't call this asynchronous but I
guess you can say it gets the job done.

caam/caamhash.c however tells a completely different story:

static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
                       void *context)
{
        struct ahash_request *req = context;
        struct ahash_edesc *edesc;
...
        req->base.complete(&req->base, err);
}

Note distinct lack of checking for the possibility the registered
callback is NULL, which in my eyes is perfectly sane choice for an
implementation of an asynchronous callback invocation assuming the
wrapping layer would have caught that, which in this case it doesn't.

Also:

static int ahash_digest(struct ahash_request *req)
{
        struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
        struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
        struct device *jrdev = ctx->jrdev;
        gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
                       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
...
        ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
        if (!ret) {
                ret = -EINPROGRESS;
        } else {
                ahash_unmap(jrdev, edesc, req, digestsize);
                kfree(edesc);
        }

        return ret;
}

Which means the normal return value for ahash_digest would be
-EINPROGRESS, which is actually as expected for an asynchronous except
that will not work with the code example in api-intro.rst.

So... I am totally confused. The documentation claims this is an
asynchronous interface, but then its own code examples beg to differ
and actual implementations varies.

Would anyone be kind enough to enlighten me?

Many thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
