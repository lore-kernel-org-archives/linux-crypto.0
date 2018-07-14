From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Fri, 13 Jul 2018 20:07:10 -0700
Message-ID: <CAGXu5jJp3Y4RZD+ZUYsWqf+sTbGJwdN3M=KOiPBn9VecYE4OgQ@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-12-keescook@chromium.org>
 <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
 <20180713004038.lwibdesz7ohhoind@gondor.apana.org.au> <CAGXu5jJOZ3u1BTf8U20wErphfjKzaGK+m1sdhA89LqVP3MDYZA@mail.gmail.com>
 <20180713062204.2o7gz5xri374nii6@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180713062204.2o7gz5xri374nii6@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2018 at 11:22 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 12, 2018 at 11:16:28PM -0700, Kees Cook wrote:
>>
>> Is this correct? It seems like you did the bulk of
>> AHASH_REQUEST_ON_STACK conversions in 2016. Can shash grow an sg
>> interface?
>
> shash does not need to grow an sg interface.  All users of
> AHASH_REQUEST_ON_STACK set the CRYPTO_ALG_ASYNC flag to zero
> when allocating the tfm.

On a plane today I started converting all these to shash. IIUC, it
just looks like this (apologies for whitespace damage):


 static int crypt_iv_essiv_init(struct crypt_config *cc)
 {
        struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-       AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
-       struct scatterlist sg;
+       SHASH_DESC_ON_STACK(desc, essiv->hash_tfm);
        struct crypto_cipher *essiv_tfm;
        int err;

-       sg_init_one(&sg, cc->key, cc->key_size);
-       ahash_request_set_tfm(req, essiv->hash_tfm);
-       ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-       ahash_request_set_crypt(req, &sg, essiv->salt, cc->key_size);
+       desc->tfm = essiv->hash_tfm;
+       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;

-       err = crypto_ahash_digest(req);
-       ahash_request_zero(req);
+       err = crypto_shash_digest(desc, key, cc->key_size, essiv->salt);
+       shash_desc_zero(desc);
        if (err)
                return err;


(I left out all the s/ahash/shash/ in types and function declarations.)

Does this look like what you were thinking of for converting these
away from ahash? The only one I couldn't make sense of was in
drivers/crypto/inside-secure/safexcel_hash.c. I have no idea what's
happening there.

-Kees

-- 
Kees Cook
Pixel Security
