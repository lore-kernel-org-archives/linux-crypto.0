Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:26286 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeKETtR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 14:49:17 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: mark cts(cbc(aes)) as FIPS allowed
Date: Mon, 05 Nov 2018 11:30:12 +0100
Message-ID: <8348637.N0ntbUeCvJ@tauon.chronox.de>
In-Reply-To: <CAKv+Gu8x1LRKq4xJTrWfu7vQDPSzxYwEYGXG_o3Xv+Zsch9S-g@mail.gmail.com>
References: <1541325924-14777-1-git-send-email-gilad@benyossef.com> <CAOtvUMeRth4zrTZbEy6Co=+CR4==5oSDbaf760Yh4fj8UAf8bQ@mail.gmail.com> <CAKv+Gu8x1LRKq4xJTrWfu7vQDPSzxYwEYGXG_o3Xv+Zsch9S-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 5. November 2018, 11:20:28 CET schrieb Ard Biesheuvel:

Hi Ard, Gilad,

> On 5 November 2018 at 10:18, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > Hi Stephan,
> > 
> > On Mon, Nov 5, 2018 at 10:50 AM Stephan Mueller <smueller@chronox.de> 
wrote:
> >> Am Sonntag, 4. November 2018, 11:05:24 CET schrieb Gilad Ben-Yossef:
> >> 
> >> Hi Gilad,
> >> 
> >> > As per Sp800-38A addendum from Oct 2010[1], cts(cbc(aes)) is
> >> > allowed as a FIPS mode algorithm. Mark it as such.
> >> > 
> >> > [1] https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
> >> 
> >> There are several types of CTS approaches. Only three of those are listed
> >> in the SP800-38A addendum. The source code only refers to some RFCs.
> >> 
> >> Did you check whether the CTS implementation matches one or more of the
> >> types listed in the addendum? If yes, may I suggest to add a small
> >> statement in the code noting this fact?
> > 
> > Yes, AFAIK the software implements CBC-CS3 as described in the document.
> > You have a very good point about this not document anywhere. I will
> > send a patch.
> 
> I agree that it makes sense to document this.

Thanks for adding this. With this statement, the initial patch of adding the 
fips_allowed flag is:

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
