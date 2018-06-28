From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 11/11] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Wed, 27 Jun 2018 17:10:05 -0700
Message-ID: <CAGXu5jKas=OyJPsrMthxjEykG=FkHDW84dO4bKGpj-50JjUYwQ@mail.gmail.com>
References: <20180625211026.15819-1-keescook@chromium.org> <20180625211026.15819-12-keescook@chromium.org>
 <20180626092041.mxfg4lxcvxfivzc2@gondor.apana.org.au> <CAGXu5jKYb-0NNvOcN79hzqU7O6vCFhMTBDGBL8Knuoc-YHamPg@mail.gmail.com>
 <20180627143622.ntksjxsymo4yw6dz@gondor.apana.org.au> <CAGXu5jJ2Z=YP+fNsvy+6a_BpC1ibZf6tOzZuPHk=Qx1qNVvOZw@mail.gmail.com>
 <20180627222749.xa5333caq5vaa7st@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627222749.xa5333caq5vaa7st@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 27, 2018 at 3:27 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jun 27, 2018 at 11:31:09AM -0700, Kees Cook wrote:
>> crypto/lrw.c:   crypto_skcipher_set_reqsize(tfm,
>> crypto_skcipher_reqsize(cipher) +
>> crypto/lrw.c-                                    sizeof(struct rctx));
>> ...
>> crypto/cts.c-   align = crypto_skcipher_alignmask(tfm);
>> crypto/cts.c-   bsize = crypto_skcipher_blocksize(cipher);
>> crypto/cts.c-   reqsize = ALIGN(sizeof(struct crypto_cts_reqctx) +
>> crypto/cts.c-                   crypto_skcipher_reqsize(cipher),
>> crypto/cts.c-                   crypto_tfm_ctx_alignment()) +
>> crypto/cts.c-             (align & ~(crypto_tfm_ctx_alignment() - 1)) + bsize;
>> crypto/cts.c-
>> crypto/cts.c:   crypto_skcipher_set_reqsize(tfm, reqsize);
>>
>> What values might be expected here? It seems the entire blocksize
>> needs to be included as well...
>
> But otherwise yes these are the ones that count.

In both cases here, what is "cipher"? i.e. what ciphers could lrw be
wrapping, and what ciphers could cts be wrapping, so that I can
examine the blocksizes, etc?

FWIW, looking at the non-ASYNC wrappers, I see only:

crypto/ctr.c
crypto/cts.c
crypto/lrw.c
crypto/xts.c
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c

Building in all crypto things and running tcrypt with an instrumented
crypto_skcipher_set_reqsize, I see:

# dmesg | grep skcipher_set_req | cut -c16- | sort -u | sort +1 -n
crypto_skcipher_set_reqsize: 8
crypto_skcipher_set_reqsize: 88
crypto_skcipher_set_reqsize: 184
crypto_skcipher_set_reqsize: 256
crypto_skcipher_set_reqsize: 472

The 472 maps to lrw with its 384 struct rctx:

[  553.843884] tcrypt: testing lrw(twofish)
[  553.844479] crypto_skcipher_set_reqsize: 8
[  553.845076] crypto_skcipher_set_reqsize: 88
[  553.845658] crypto_skcipher_set_reqsize: 472

[  553.860578] tcrypt: testing lrw(serpent)
[  553.861349] crypto_skcipher_set_reqsize: 8
[  553.861960] crypto_skcipher_set_reqsize: 88
[  553.862534] crypto_skcipher_set_reqsize: 472

[  553.871676] tcrypt: testing lrw(aes)
[  553.872398] crypto_skcipher_set_reqsize: 8
[  553.873002] crypto_skcipher_set_reqsize: 88
[  553.873574] crypto_skcipher_set_reqsize: 472

[  553.957282] tcrypt: testing lrw(cast6)
[  553.958098] crypto_skcipher_set_reqsize: 8
[  553.958691] crypto_skcipher_set_reqsize: 88
[  553.959311] crypto_skcipher_set_reqsize: 472

[  553.982514] tcrypt: testing lrw(camellia)
[  553.983308] crypto_skcipher_set_reqsize: 8
[  553.983907] crypto_skcipher_set_reqsize: 88
[  553.984470] crypto_skcipher_set_reqsize: 472

And while I'm using tcrypt, ahash shows:

44
124
336
368
528
536
568
616
648
728
808

The largest seems to be sha512:

[  553.883440] tcrypt: testing sha512
[  553.884179] sha512_mb: crypto_ahash_set_reqsize: 528
[  553.884904] crypto_ahash_set_reqsize: 728
[  553.885449] sha512_mb: crypto_ahash_set_reqsize: 808

So ... should I use 472 for skcipher and 808 for ahash?

-Kees

-- 
Kees Cook
Pixel Security
