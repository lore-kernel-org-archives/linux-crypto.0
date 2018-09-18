From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 18 Sep 2018 06:26:11 +0200
Message-ID: <CAHmME9rthEDfL7=xNsafZfcL_N0SrB-VKrBWiZMWTQ2bd=gUvw@mail.gmail.com>
References: <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
 <20180918042133.4ybztgdooxkoyiru@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918042133.4ybztgdooxkoyiru@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Tue, Sep 18, 2018 at 6:21 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> That may be your view but from what I've read Ard has been very
> constructive in pointing out issues in your submission.
> Please keep in mind that this is a large project that has to support
> multiple users on one hand (not just WireGuard) and complex hardware
> acceleration drivers on the other.  Ard has been one of the most
> prolific contributors to the crypto code and his review should be
> taken seriously.

I'm well aware, which is why I also wrote:

"I do sincerely hope these are only fears and not what actually is
going on. I'll do my best to take into serious consideration what you
say -- many are indeed extremely helpful"

Worry not, I've been working around the clock to implement suggestions
from Ard and from others.

I'll be submitting v5 fairly soon, which will probably be a good spot
for you to review as well, if you're interested. I'm just going to
give kbuild testbot a few more hours on it first.

Regards,
Jason
