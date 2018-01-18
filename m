From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] arm64: move literal data into .rodata section
Date: Thu, 18 Jan 2018 23:02:42 +1100
Message-ID: <20180118120242.GE20717@gondor.apana.org.au>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
 <20180118114112.GA20091@gondor.apana.org.au>
 <CAKv+Gu_oh7q81mr=XPW+HM9zewETtbL=mnN0mkr83f5=n4zr6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Steve Capper <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55346 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755137AbeARMDO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 07:03:14 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_oh7q81mr=XPW+HM9zewETtbL=mnN0mkr83f5=n4zr6Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 18, 2018 at 11:46:07AM +0000, Ard Biesheuvel wrote:
> On 18 January 2018 at 11:41, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Wed, Jan 10, 2018 at 12:11:35PM +0000, Ard Biesheuvel wrote:
> >> Prevent inadvertently creating speculative gadgets by moving literal data
> >> into the .rodata section.
> >>
> >> Patch #1 enables this for C code, by reverting a change that disables the
> >> GCC feature implementing this. Note that this conflicts with the mitigation
> >> of erratum #843419 for Cortex-A53.
> >
> > Ard, which tree is this supposed to go through?
> >
> 
> Hi Herbert,
> 
> I am going to drop that first patch, the remaining 6 patches can go
> through the crypto tree as they are independent.

Patches 2-7 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
