From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Thu, 13 Sep 2018 08:39:54 +0200
Message-ID: <c5855aa4-1561-8387-aebb-0a7587ac6d4f@gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com>
 <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13/09/18 01:45, Andy Lutomirski wrote:
> On Wed, Sep 12, 2018 at 3:56 PM, Ard Biesheuvel
... 
> b) Crypto that is used dynamically.  This includes dm-crypt
> (aes-xts-plain64, aes-cbc-essiv, etc), all the ALG_IF interfaces, a
> lot of IPSEC stuff, possibly KCM, and probably many more.  These will
> get comparatively little benefit from being converted to a zinc-like
> interface.  For some of these cases, it wouldn't make any sense at all
> to convert them.  Certainly the ones that do async hardware crypto
> using DMA engines will never look at all like zinc, even under the
> hood.

Please note, that dm-crypt now uses not only block ciphers and modes,
but also authenticated encryption and hashes (for ESSIV and HMAC
in authenticated composed modes) and RNG (for random IV).
We use crypto API, including async variants (I hope correctly :)

There is a long time battle to move initialization vectors generators
from dm-crypt to crypto API. If there are any plans to use a new library,
this issue should be discussed as well.
(Some dm-crypt IV generators are disk encryption specific, some do more
that just IV so porting is not straightforward etc).

Related problem here is an optimization of chain of sectors encryption -
if we have new crypto API, it would be nice if can take chain of sectors
so possible implementation can process this chain in one batch
(every sector need to be tweaked by differently generated IV - and we
are back in problem above).
I think filesystem encryption uses the same pattern.

And btw, we use the same algorithms through AF_ALG in userspace (cryptsetup).

So please, if you mention dm-crypt, note that it is very complex
crypto API consumer :) And everything is dynamic, configurable through
dm-crypt options.

That said, I would be more than happy to help in experiments to porting dm-crypt
to any other crypto library, but if it doesn't not help with problems
mentioned above, I do not see any compelling reason for the new library for dm-crypt...

Milan
