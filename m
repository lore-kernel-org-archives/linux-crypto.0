From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] [PATCH v5 10/11] crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Tue, 17 Jul 2018 13:11:52 -0700
Message-ID: <CAGXu5j+uUUKjDb3_W=PvLG+mG+_ozTRuK5PMAewKEVnomnc2yA@mail.gmail.com>
References: <20180717042150.37761-1-keescook@chromium.org> <20180717042150.37761-11-keescook@chromium.org>
 <20180717164358.GC75957@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
        LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717164358.GC75957@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 17, 2018 at 9:43 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Mon, Jul 16, 2018 at 09:21:49PM -0700, Kees Cook wrote:
>> +     reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
>> +     if (WARN_ON(reqsize > AHASH_MAX_REQSIZE)) {
>> +             crypto_mod_put(calg);
>> +             return -EINVAL;
>> +     }
>
> 'crypto_free_shash(shash);' instead of 'crypto_mod_put(calg);'

Oops! Yes, thanks; I have fixed it now in the next version.

-Kees

-- 
Kees Cook
Pixel Security
