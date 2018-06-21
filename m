From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH 05/11] crypto alg: Introduce max blocksize and
 alignmask
Date: Wed, 20 Jun 2018 17:32:31 -0700
Message-ID: <20180621003231.GH111712@gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-6-keescook@chromium.org>
 <20180620234031.GC111712@gmail.com>
 <CAGXu5j++uGCnAOiQd=JM139B6g7oUGTquhgniX-Fwsj8qofU9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        qat-linux@intel.com, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j++uGCnAOiQd=JM139B6g7oUGTquhgniX-Fwsj8qofU9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 05:04:08PM -0700, Kees Cook wrote:
> On Wed, Jun 20, 2018 at 4:40 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > On Wed, Jun 20, 2018 at 12:04:02PM -0700, Kees Cook wrote:
> >> In the quest to remove all stack VLA usage from the kernel[1], this
> >> exposes the existing upper bound on crypto block sizes for VLA removal,
> >> and introduces a new check for alignmask (current maximum in the kernel
> >> is 63 from manual inspection of all cra_alignmask settings).
> >>
> >> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  crypto/algapi.c        | 5 ++++-
> >>  include/linux/crypto.h | 4 ++++
> >>  2 files changed, 8 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/crypto/algapi.c b/crypto/algapi.c
> >> index c0755cf4f53f..760a412b059c 100644
> >> --- a/crypto/algapi.c
> >> +++ b/crypto/algapi.c
> >> @@ -57,7 +57,10 @@ static int crypto_check_alg(struct crypto_alg *alg)
> >>       if (alg->cra_alignmask & (alg->cra_alignmask + 1))
> >>               return -EINVAL;
> >>
> >> -     if (alg->cra_blocksize > PAGE_SIZE / 8)
> >> +     if (alg->cra_blocksize > CRYPTO_ALG_MAX_BLOCKSIZE)
> >> +             return -EINVAL;
> >> +
> >> +     if (alg->cra_alignmask > CRYPTO_ALG_MAX_ALIGNMASK)
> >>               return -EINVAL;
> >>
> >>       if (!alg->cra_type && (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> >> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> >> index 6eb06101089f..e76ffcbd5aa6 100644
> >> --- a/include/linux/crypto.h
> >> +++ b/include/linux/crypto.h
> >> @@ -134,6 +134,10 @@
> >>   */
> >>  #define CRYPTO_MAX_ALG_NAME          128
> >>
> >> +/* Maximum values for registered algorithms. */
> >> +#define CRYPTO_ALG_MAX_BLOCKSIZE    (PAGE_SIZE / 8)
> >> +#define CRYPTO_ALG_MAX_ALIGNMASK    63
> >> +
> >
> > How do these differ from MAX_CIPHER_BLOCKSIZE and MAX_CIPHER_ALIGNMASK, and why
> > are they declared in different places?
> 
> This is what I get for staring at crypto code for so long. I entirely
> missed these checks... even though they're 8 line away:
> 
>         if (!alg->cra_type && (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
>                                CRYPTO_ALG_TYPE_CIPHER) {
>                 if (alg->cra_alignmask > MAX_CIPHER_ALIGNMASK)
>                         return -EINVAL;
> 
>                 if (alg->cra_blocksize > MAX_CIPHER_BLOCKSIZE)
>                         return -EINVAL;
>         }
> 
> However, this is only checking CRYPTO_ALG_TYPE_CIPHER, and
> cra_blocksize can be used for all kinds of things.
> 

It's overloaded for different purposes, depending on the type of algorithm.
It's poorly documented, but the uses I see are:

(1) Block size for "ciphers", i.e. what the rest of the world calls "block ciphers".
(2) Minimum input size for "skciphers" -- usually either 1 or the block size of
    the underlying block cipher, in the case that the skcipher is something like
    "cbc(aes)", where a block cipher is wrapped in a mode of operation.
(3) Block size for hash functions that use an internal compression function,
    e.g. SHA-1 has a block size of 64 bytes.

I'm not sure it makes sense to have a single limit for all these uses.  All the
block ciphers supported by Linux have a block size of 16 bytes or less, while
hash functions usually have larger "block sizes".

> include/crypto/algapi.h:#define MAX_CIPHER_ALIGNMASK            15
> ...
> drivers/crypto/mxs-dcp.c:                       .cra_flags
>  = CRYPTO_ALG_ASYNC,
> drivers/crypto/mxs-dcp.c:                       .cra_alignmask          = 63,
> 
> Is this one broken? It has no CRYPTO_ALG_TYPE_... ?
> 
> For my CRYPTO_ALG_MAX_BLOCKSIZE, there is:
> 
> crypto/xcbc.c:  u8 key1[CRYPTO_ALG_MAX_BLOCKSIZE];
> drivers/crypto/qat/qat_common/qat_algs.c:       char
> ipad[CRYPTO_ALG_MAX_BLOCKSIZE];
> drivers/crypto/qat/qat_common/qat_algs.c:       char
> opad[CRYPTO_ALG_MAX_BLOCKSIZE];
> 
> It looks like both xcbc and qat are used with shash, so that needs a
> separate max blocksize.

Actually, xcbc is a 'shash' template (CRYPTO_ALG_TYPE_SHASH) that wraps a block
cipher (CRYPTO_ALG_TYPE_CIPHER) and sets its own cra_blocksize to the block
cipher's block size.  So the same block size can be gotten from either
'crypto_shash_blocksize(parent)' or 'crypto_cipher_blocksize(ctx->child)'.
It can only be 16 bytes, currently, since xcbc_create() only allows
instantiating the template if that's the block size.

But in the case of qat_alg_do_precomputes(), yes it appears to need the hash
block size.

> 
> For my CRYPTO_ALG_MAX_ALIGNMASK, there is:
> 
> crypto/shash.c: u8 ubuf[CRYPTO_ALG_MAX_ALIGNMASK]
> crypto/shash.c:         __aligned(CRYPTO_ALG_MAX_ALIGNMASK + 1);
> crypto/shash.c:         __aligned(CRYPTO_ALG_MAX_ALIGNMASK + 1);
> 
> which is also shash.
> 
> How should I rename these and best apply the registration-time sanity checks?

I'm not sure, but it may make sense to enforce a smaller limit for algorithm
types like CRYPTO_ALG_TYPE_CIPHER and maybe even CRYPTO_ALG_TYPE_SHASH that
can't be implemented in a hardware driver, as their APIs are not asynchronous
and don't operate on scatterlists.  Only hardware drivers can need very large
alignmasks like 64 bytes, I believe.

Eric
