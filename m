From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 6 Sep 2018 13:22:32 -0700
Message-ID: <CAGXu5jJHnUF_C7ChNdxkYMPW59-jTMSJpiTB7XyAYhe6=00zbg@mail.gmail.com>
References: <20180904181629.20712-1-keescook@chromium.org> <20180904181629.20712-3-keescook@chromium.org>
 <CAKv+Gu9uJ+ZjBSCM=aU0GDvYR72cy2k8reXdLV5on3dOVw8KdQ@mail.gmail.com>
 <CAGXu5jKmcuhULMR=O9B_hJAxEK8uV36uoMxm4F3F8yYSuMzYNA@mail.gmail.com>
 <CAKv+Gu_0vWUqkUex45iW=pAfUbKVsqzP9MDf6OOwTg-nUVPZNg@mail.gmail.com> <CAGXu5j+z8eQKu_3sm93pdo+bBZDFqkHNM3Y0tKTDbnHfUNzywg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+z8eQKu_3sm93pdo+bBZDFqkHNM3Y0tKTDbnHfUNzywg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 5, 2018 at 5:43 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Sep 5, 2018 at 3:49 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 5 September 2018 at 23:05, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Sep 5, 2018 at 2:18 AM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> On 4 September 2018 at 20:16, Kees Cook <keescook@chromium.org> wrote:
>>>>> In the quest to remove all stack VLA usage from the kernel[1], this
>>>>> caps the skcipher request size similar to other limits and adds a sanity
>>>>> check at registration. Looking at instrumented tcrypt output, the largest
>>>>> is for lrw:
>>>>>
>>>>>         crypt: testing lrw(aes)
>>>>>         crypto_skcipher_set_reqsize: 8
>>>>>         crypto_skcipher_set_reqsize: 88
>>>>>         crypto_skcipher_set_reqsize: 472
>>>>>
>>>>
>>>> Are you sure this is a representative sampling? I haven't double
>>>> checked myself, but we have plenty of drivers for peripherals in
>>>> drivers/crypto that implement block ciphers, and they would not turn
>>>> up in tcrypt unless you are running on a platform that provides the
>>>> hardware in question.
>>>
>>> Hrm, excellent point. Looking at this again:
>>> [...]
>>> And of the crt_ablkcipher.reqsize assignments/initializers, I found:
>>>
>>> ablkcipher reqsize:
>>> 1       struct dcp_aes_req_ctx
>>> 8       struct atmel_tdes_reqctx
>>> 8       struct cryptd_blkcipher_request_ctx
>>> 8       struct mtk_aes_reqctx
>>> 8       struct omap_des_reqctx
>>> 8       struct s5p_aes_reqctx
>>> 8       struct sahara_aes_reqctx
>>> 8       struct stm32_cryp_reqctx
>>> 8       struct stm32_cryp_reqctx
>>> 16      struct ablk_ctx
>>> 24      struct atmel_aes_reqctx
>>> 48      struct omap_aes_reqctx
>>> 48      struct omap_aes_reqctx
>>> 48      struct qat_crypto_request
>>> 56      struct artpec6_crypto_request_context
>>> 64      struct chcr_blkcipher_req_ctx
>>> 80      struct spacc_req
>>> 80      struct virtio_crypto_sym_request
>>> 136     struct qce_cipher_reqctx
>>> 168     struct n2_request_context
>>> 328     struct ccp_des3_req_ctx
>>> 400     struct ccp_aes_req_ctx
>>> 536     struct hifn_request_context
>>> 992     struct cvm_req_ctx
>>> 2456    struct iproc_reqctx_s

All of these are ASYNC (they're all crt_ablkcipher), so IIUC, I can ignore them.

>>> The base ablkcipher wrapper is:
>>> 80      struct ablkcipher_request
>>>
>>> And in my earlier skcipher wrapper analysis, lrw was the largest
>>> skcipher wrapper:
>>> 384     struct rctx
>>>
>>> iproc_reqctx_s is an extreme outlier, with cvm_req_ctx at a bit less than half.
>>>
>>> Making this a 2920 byte fixed array doesn't seem sensible at all
>>> (though that's what's already possible to use with existing
>>> SKCIPHER_REQUEST_ON_STACK users).
>>>
>>> What's the right path forward here?
>>>
>>
>> The skcipher implementations based on crypto IP blocks are typically
>> asynchronous, and I wouldn't be surprised if a fair number of
>> SKCIPHER_REQUEST_ON_STACK() users are limited to synchronous
>> skciphers.
>
> Looks similar to ahash vs shash. :) Yes, so nearly all
> crypto_alloc_skcipher() users explicitly mask away ASYNC. What's left
> appears to be:
>
> crypto/drbg.c:  sk_tfm = crypto_alloc_skcipher(ctr_name, 0, 0);
> crypto/tcrypt.c:        tfm = crypto_alloc_skcipher(algo, 0, async ? 0
> : CRYPTO_ALG_ASYNC);
> drivers/crypto/omap-aes.c:      ctx->ctr =
> crypto_alloc_skcipher("ecb(aes)", 0, 0);
> drivers/md/dm-crypt.c:          cc->cipher_tfm.tfms[i] =
> crypto_alloc_skcipher(ciphermode, 0, 0);
> drivers/md/dm-integrity.c:              ic->journal_crypt =
> crypto_alloc_skcipher(ic->journal_crypt_alg.alg_string, 0, 0);
> fs/crypto/keyinfo.c:    struct crypto_skcipher *tfm =
> crypto_alloc_skcipher("ecb(aes)", 0, 0);
> fs/crypto/keyinfo.c:    ctfm = crypto_alloc_skcipher(mode->cipher_str, 0, 0);
> fs/ecryptfs/crypto.c:   crypt_stat->tfm =
> crypto_alloc_skcipher(full_alg_name, 0, 0);
>
> I'll cross-reference this with SKCIPHER_REQUEST_ON_STACK...

None of these use SKCIPHER_REQUEST_ON_STACK that I can find.

>> So we could formalize this and limit SKCIPHER_REQUEST_ON_STACK() to
>> synchronous skciphers, which implies that the reqsize limit only has
>> to apply synchronous skciphers as well. But before we can do this, we
>> have to identify the remaining occurrences that allow asynchronous
>> skciphers to be used, and replace them with heap allocations.
>
> Sounds good; thanks!

crypto_init_skcipher_ops_blkcipher() doesn't touch reqsize at all, so
the only places I can find it gets changed are with direct callers of
crypto_skcipher_set_reqsize(), which, when wrapping a sync blkcipher
start with a reqsize == 0. So, the remaining non-ASYNC callers ask
for:

4       struct sun4i_cipher_req_ctx
96      struct crypto_rfc3686_req_ctx
375     sum:
                160     crypto_skcipher_blocksize(cipher) (max)
                152     struct crypto_cts_reqctx
                63      align_mask (max)
384     struct rctx

So, following your patch to encrypt/decrypt, I can add reqsize check
there. How does this look, on top of your patch?

--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -144,9 +144,10 @@ struct skcipher_alg {
 /*
  * This must only ever be used with synchronous algorithms.
  */
+#define MAX_SYNC_SKCIPHER_REQSIZE      384
 #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
        char __##name##_desc[sizeof(struct skcipher_request) + \
-               crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR = { 1 } \
+               MAX_SYNC_SKCIPHER_REQSIZE] CRYPTO_MINALIGN_ATTR = { 1 } \
        struct skcipher_request *name = (void *)__##name##_desc

 /**
@@ -442,10 +443,14 @@ static inline int crypto_skcipher_encrypt(struct
skcipher_request *req)
 {
        struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);

-       if (req->__onstack &&
-           WARN_ON(crypto_skcipher_alg(tfm)->base.cra_flags &
-                       CRYPTO_ALG_ASYNC))
-               return -EINVAL;
+       if (req->__onstack) {
+               if (WARN_ON(crypto_skcipher_alg(tfm)->base.cra_flags &
+                               CRYPTO_ALG_ASYNC))
+                       return -EINVAL;
+               if (WARN_ON(crypto_skcipher_reqsize(tfm) >
+                               MAX_SYNC_SKCIPHER_REQSIZE))
+                       return -ENOSPC;
+       }
...etc

-- 
Kees Cook
Pixel Security
