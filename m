From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 4.13
Date: Wed, 5 Jul 2017 13:02:59 -0700
Message-ID: <CA+55aFybPA7zJYfT=Dd38tVW8mFE4hv0=hBkdGrXNtdO9zMWiw@mail.gmail.com>
References: <20161119102748.GA4277@gondor.apana.org.au> <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au> <20170705130124.GA3755@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170705130124.GA3755@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 5, 2017 at 6:01 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Drivers:
>
> - Add support for CNN55XX adapters in cavium.

Grr. I noticed this too late to fix it in the merge.

That stupid CNN55XX driver was added with a default of "m"?

WTF? Hell no. We don't add random new drivers and default them on -
and we do so even less when they are for very unusual hardware.

                  Linus
