From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 6 Sep 2018 16:49:25 +0200
Message-ID: <CAKv+Gu9tSFg9ekEagfn4sPbK-NLYHmmEtij=iMm7szGGQD9B1A@mail.gmail.com>
References: <20180904181629.20712-1-keescook@chromium.org> <20180904181629.20712-3-keescook@chromium.org>
 <CAKv+Gu9uJ+ZjBSCM=aU0GDvYR72cy2k8reXdLV5on3dOVw8KdQ@mail.gmail.com>
 <CAGXu5jKmcuhULMR=O9B_hJAxEK8uV36uoMxm4F3F8yYSuMzYNA@mail.gmail.com>
 <CAKv+Gu_0vWUqkUex45iW=pAfUbKVsqzP9MDf6OOwTg-nUVPZNg@mail.gmail.com>
 <CAOtvUMfu4-DWD4n4c5itjArAYWhGaBnPBEnkh6cbCubG-k9cCA@mail.gmail.com>
 <CAKv+Gu8bKcPksgoryaVjoD9G5KeCYrqWOCgVhqrBqGw5dCzXag@mail.gmail.com>
 <CAKv+Gu-QkCE0pY4+5anEZ0eWv-FTH1QJtOQfPcTVLcvNf7XNiA@mail.gmail.com>
 <20180906085100.xcqqftgqg4sizkec@gondor.apana.org.au> <CAKv+Gu_0ehX9sLCtUYR00D4iQw+ytwmsLKmG6dgq9EnLjidKFw@mail.gmail.com>
 <20180906131149.ge2db74nxffs2tbz@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906131149.ge2db74nxffs2tbz@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6 September 2018 at 15:11, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Sep 06, 2018 at 11:29:41AM +0200, Ard Biesheuvel wrote:
>>
>> Perhaps not, but it is not enforced atm.
>>
>> In any case, limiting the reqsize is going to break things, so that
>> needs to occur based on the sync/async nature of the algo. That also
>> means we'll corrupt the stack if we ever end up using
>> SKCIPHER_REQUEST_ON_STACK() with an async algo whose reqsize is
>> greater than the sync reqsize limit, so I do think some additional
>> sanity check is appropriate.
>
> I'd prefer compile-time based checks.  Perhaps we can introduce
> a wrapper around crypto_skcipher, say crypto_skcipher_sync which
> could then be used by SKCIPHER_REQUEST_ON_STACK to ensure that
> only sync algorithms can use this construct.
>

That would require lots of changes in the callers, including ones that
already take care to use sync algos only.

How about we do something like the below instead?

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f327f090c3e..ace707d59cd9 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -19,6 +19,7 @@

 /**
  *     struct skcipher_request - Symmetric key cipher request
+ *     @__onstack: 1 if the request was allocated by SKCIPHER_REQUEST_ON_STACK
  *     @cryptlen: Number of bytes to encrypt or decrypt
  *     @iv: Initialisation Vector
  *     @src: Source SG list
@@ -27,6 +28,7 @@
  *     @__ctx: Start of private context data
  */
 struct skcipher_request {
+       unsigned char __onstack;
        unsigned int cryptlen;

        u8 *iv;
@@ -141,7 +143,7 @@ struct skcipher_alg {

 #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
        char __##name##_desc[sizeof(struct skcipher_request) + \
-               crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+               crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR = { 1 }; \
        struct skcipher_request *name = (void *)__##name##_desc

 /**
@@ -437,6 +439,10 @@ static inline int crypto_skcipher_encrypt(struct
skcipher_request *req)
 {
        struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);

+       if (req->__onstack &&
+           (crypto_skcipher_alg(tfm)->base.cra_flags & CRYPTO_ALG_ASYNC))
+               return -EINVAL;
+
        if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
                return -ENOKEY;

@@ -458,6 +464,10 @@ static inline int crypto_skcipher_decrypt(struct
skcipher_request *req)
 {
        struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);

+       if (req->__onstack &&
+           (crypto_skcipher_alg(tfm)->base.cra_flags & CRYPTO_ALG_ASYNC))
+               return -EINVAL;
+
        if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
                return -ENOKEY;
