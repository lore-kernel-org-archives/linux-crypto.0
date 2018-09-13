From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 16:34:44 +0200
Message-ID: <CAHmME9oXXHZQXuvum1x69tojsRwXtBM32VXsL2SXbBuq2JCVeg@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com> <c5855aa4-1561-8387-aebb-0a7587ac6d4f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: gmazyland@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c5855aa4-1561-8387-aebb-0a7587ac6d4f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Milan,

On Thu, Sep 13, 2018 at 8:40 AM Milan Broz <gmazyland@gmail.com> wrote:
> Please note, that dm-crypt now uses not only block ciphers and modes,
> but also authenticated encryption and hashes (for ESSIV and HMAC
> in authenticated composed modes) and RNG (for random IV).
> We use crypto API, including async variants (I hope correctly :)
>
> There is a long time battle to move initialization vectors generators
> from dm-crypt to crypto API. If there are any plans to use a new library,
> this issue should be discussed as well.
> (Some dm-crypt IV generators are disk encryption specific, some do more
> that just IV so porting is not straightforward etc).
>
> Related problem here is an optimization of chain of sectors encryption -
> if we have new crypto API, it would be nice if can take chain of sectors
> so possible implementation can process this chain in one batch
> (every sector need to be tweaked by differently generated IV - and we
> are back in problem above).
> I think filesystem encryption uses the same pattern.
>
> And btw, we use the same algorithms through AF_ALG in userspace (cryptsetup).
>
> So please, if you mention dm-crypt, note that it is very complex
> crypto API consumer :) And everything is dynamic, configurable through
> dm-crypt options.
>
> That said, I would be more than happy to help in experiments to porting dm-crypt
> to any other crypto library, but if it doesn't not help with problems
> mentioned above, I do not see any compelling reason for the new library for dm-crypt...

dm-crypt is probably a good consumer of the existing crypto API and
won't be impacted by the introduction of Zinc, which is really just
the exposure of a couple low level simple crypto functions, and not a
fancy API like the crypto API which dm-crypt happily uses.

Jason
