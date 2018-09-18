From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Tue, 18 Sep 2018 12:21:34 +0800
Message-ID: <20180918042133.4ybztgdooxkoyiru@gondor.apana.org.au>
References: <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ard.biesheuvel@linaro.org, luto@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, ebiggers@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sneves@dei.uc.pt, jeanphilippe.aumasson@gmail.com,
        linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason:

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> On Mon, Sep 17, 2018 at 7:26 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> OK, so let me summarize my remaining concerns as well. I may be a bit
>> more finicky than Andy, though.
> 
> Yes, and generally hostile to this whole initiative since the
> beginning. But I am very grateful for your reviews nonetheless, and
> I'll do my best to incorporate as much as is reasonable.
 
>> I would like to urge Jason to
>> bear with us and bring this discussion to a close before resubmitting.
> 
> What I fear is that either:
> - You don't like the Zinc initiative in one way or another, and the
> desire to "keep discussing" and adding more things is less out of
> their necessity and more out of a desire to stall it indefinitely.
> - You're going to bikeshed and bikeshed and waste tons of time until
> Zinc copies lots of the same design decisions from the present crypto
> API.

That may be your view but from what I've read Ard has been very
constructive in pointing out issues in your submission.  If your
response to criticism is to dismiss them as hostile then I'm afraid
that we will not be able to progress on this patch series.

Please keep in mind that this is a large project that has to support
multiple users on one hand (not just WireGuard) and complex hardware
acceleration drivers on the other.  Ard has been one of the most
prolific contributors to the crypto code and his review should be
taken seriously.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
