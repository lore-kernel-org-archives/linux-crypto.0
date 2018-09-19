From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH crypto-next 03/23] lib80211: Remove VLA usage of skcipher
Date: Wed, 19 Sep 2018 22:37:59 +0200
Message-ID: <1537389479.10305.94.camel@sipsolutions.net>
References: <20180919021100.3380-1-keescook@chromium.org>
         <20180919021100.3380-4-keescook@chromium.org>
         (sfid-20180919_041111_811472_0A3A2E21)
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-4-keescook@chromium.org> (sfid-20180919_041111_811472_0A3A2E21)
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-09-18 at 19:10 -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
> with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
> which uses a fixed stack size.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 

I know this lib80211 stuff landed on my plate as the maintainer (and the
others are probably more or less copies thereof), but honestly I don't
even have a device I could test this on, and quite possibly never had
(after the old non-mac80211 b43 driver was killed.)

So basically I'll just trust you to be doing the right thing, since you
probably did the same transformation on other code that is better
tested...

johannes
