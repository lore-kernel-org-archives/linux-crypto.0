From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] [PATCH v2 10/11] crypto: ahash: Remove VLA usage for
 AHASH_REQUEST_ON_STACK
Date: Wed, 27 Jun 2018 22:34:53 +0800
Message-ID: <20180627143453.gu44ghqh6jnaf4tz@gondor.apana.org.au>
References: <20180625211026.15819-1-keescook@chromium.org>
 <20180625211026.15819-11-keescook@chromium.org>
 <20180625225609.GA181665@gmail.com>
 <20180626091958.zy3m24sjukfbn7av@gondor.apana.org.au>
 <CAGXu5j+2UEUMJ0RL_XDm+Z2jBaPgshbiKaKmrYTQiP7yB2eKng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+2UEUMJ0RL_XDm+Z2jBaPgshbiKaKmrYTQiP7yB2eKng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 26, 2018 at 10:02:31AM -0700, Kees Cook wrote:
>
> There is no SHASH_MAX_REQSIZE?
> 
> As for users of AHASH_REQUEST_ON_STACK, I see:

These users are only using the top-level ahash interface.  The
underlying algorithms must all be shas.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
