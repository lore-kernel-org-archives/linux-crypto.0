From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] [PATCH v2 10/11] crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Tue, 26 Jun 2018 10:02:31 -0700
Message-ID: <CAGXu5j+2UEUMJ0RL_XDm+Z2jBaPgshbiKaKmrYTQiP7yB2eKng@mail.gmail.com>
References: <20180625211026.15819-1-keescook@chromium.org> <20180625211026.15819-11-keescook@chromium.org>
 <20180625225609.GA181665@gmail.com> <20180626091958.zy3m24sjukfbn7av@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers3@gmail.com>,
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180626091958.zy3m24sjukfbn7av@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 26, 2018 at 2:19 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Jun 25, 2018 at 03:56:09PM -0700, Eric Biggers wrote:
>>
>> > diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
>> > index a0b0ad9d585e..d96ae5f52125 100644
>> > --- a/include/crypto/internal/hash.h
>> > +++ b/include/crypto/internal/hash.h
>> > @@ -142,6 +142,7 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
>> >  static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
>> >                                         unsigned int reqsize)
>> >  {
>> > +   BUG_ON(reqsize > AHASH_MAX_REQSIZE);
>> >     tfm->reqsize = reqsize;
>> >  }
>>
>> This isn't accounting for the cases where a hash algorithm is "wrapped" with
>> another one, which increases the request size.  For example, "sha512_mb" ends up
>> with a request size of
>
> I think this patch is on the wrong track.  The stack requests are
> only ever meant to be used for synchronous algorithms (IOW shash
> algorithms) and were a quick-and-dirty fix for legacy users.
>
> So either check SHASH_MAX_REQSIZE or just convert the users to
> kmalloc or even better make them real async users.

There is no SHASH_MAX_REQSIZE?

As for users of AHASH_REQUEST_ON_STACK, I see:

$ git grep AHASH_REQUEST_ON_STACK
arch/x86/power/hibernate_64.c:          AHASH_REQUEST_ON_STACK(req, tfm);
crypto/ccm.c:   AHASH_REQUEST_ON_STACK(ahreq, ctx->mac);
drivers/block/drbd/drbd_worker.c:       AHASH_REQUEST_ON_STACK(req, tfm);
drivers/block/drbd/drbd_worker.c:       AHASH_REQUEST_ON_STACK(req, tfm);
drivers/md/dm-crypt.c:  AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
drivers/net/ppp/ppp_mppe.c:     AHASH_REQUEST_ON_STACK(req, state->sha1);
drivers/staging/rtl8192e/rtllib_crypt_tkip.c:
AHASH_REQUEST_ON_STACK(req, tfm_michael);
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:
AHASH_REQUEST_ON_STACK(req, tfm_michael);
net/wireless/lib80211_crypt_tkip.c:     AHASH_REQUEST_ON_STACK(req,
tfm_michael);

Regardless, I'll take a closer look at these.

The other patches leading up to the REQSIZE ones, though, I think are
ready to go? They're distinct from the last two, so the first 9
patches could be applied and I'll continue to improve the two REQSIZE
ones? If that sounds okay, do you want me to resend just first 9, or
do you want to take them from this series?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
