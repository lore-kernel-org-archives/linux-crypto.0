From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] [PATCH v2 10/11] crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Wed, 27 Jun 2018 11:12:12 -0700
Message-ID: <CAGXu5jL=p28A=NtVpjjPVLeq4VvBweNjP-K_MWqde-kwDEn2TA@mail.gmail.com>
References: <20180625211026.15819-1-keescook@chromium.org> <20180625211026.15819-11-keescook@chromium.org>
 <20180625225609.GA181665@gmail.com> <20180626091958.zy3m24sjukfbn7av@gondor.apana.org.au>
 <CAGXu5j+2UEUMJ0RL_XDm+Z2jBaPgshbiKaKmrYTQiP7yB2eKng@mail.gmail.com> <20180627143453.gu44ghqh6jnaf4tz@gondor.apana.org.au>
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
In-Reply-To: <20180627143453.gu44ghqh6jnaf4tz@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 27, 2018 at 7:34 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jun 26, 2018 at 10:02:31AM -0700, Kees Cook wrote:
>>
>> There is no SHASH_MAX_REQSIZE?
>>
>> As for users of AHASH_REQUEST_ON_STACK, I see:
>
> These users are only using the top-level ahash interface.  The
> underlying algorithms must all be shas.

typo? "shash" you mean?

I don't really understand the crypto APIs -- are you or Eric able to
help me a bit more here? I don't understand that things can wrap other
things, so I'm not sure the best way to reason about the maximum size
to choose here. (And the same for skcipher.)

-Kees

-- 
Kees Cook
Pixel Security
