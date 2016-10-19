From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/8] crypto: ARM/arm64 - big endian fixes
Date: Wed, 19 Oct 2016 11:03:33 +0800
Message-ID: <20161019030333.GA1269@gondor.apana.org.au>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161018114932.GG10115@e104818-lin.cambridge.arm.com>
 <CAKv+Gu9wuXnrq77a3Zk0GnHgnkpURh=EegwgP+vAwMC=rdm3qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34911 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932580AbcJSDDm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 23:03:42 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9wuXnrq77a3Zk0GnHgnkpURh=EegwgP+vAwMC=rdm3qA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 18, 2016 at 01:14:38PM +0100, Ard Biesheuvel wrote:
> On 18 October 2016 at 12:49, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Oct 11, 2016 at 07:15:12PM +0100, Ard Biesheuvel wrote:
> >> As it turns out, none of the accelerated crypto routines under arch/arm64/crypto
> >> currently work, or have ever worked correctly when built for big endian. So this
> >> series fixes all of them. This v2 now includes a similar fix for 32-bit ARM as
> >> well, and an additional fix for XTS which escaped my attention before.
> >>
> >> Each of these patches carries a fixes tag, and could be backported to stable.
> >> However, for patches #1 and #5, the fixes tag denotes the oldest commit that the
> >> fix is compatible with, not the patch that introduced the algorithm.
> >
> > I think for future reference, the Fixes tag should denote the commit
> > that introduced the issue. An explicit Cc: stable tag would state how
> > far back it should be applied.
> >
> 
> OK, that sounds reasonable.
> 
> >> Ard Biesheuvel (8):
> >>   crypto: arm64/aes-ce - fix for big endian
> >>   crypto: arm64/ghash-ce - fix for big endian
> >>   crypto: arm64/sha1-ce - fix for big endian
> >>   crypto: arm64/sha2-ce - fix for big endian
> >>   crypto: arm64/aes-ccm-ce: fix for big endian
> >>   crypto: arm64/aes-neon - fix for big endian
> >>   crypto: arm64/aes-xts-ce: fix for big endian
> >>   crypto: arm/aes-ce - fix for big endian
> >
> > The changes look fine to me but I can't claim I fully understand these
> > algorithms. FWIW:
> >
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> >
> > (Will may pick them up for 4.9-rcX)
> 
> Thanks, although I was kind of expecting Herbert to pick these up,
> given that #8 affects ARM not arm64.
> 
> But if you (or Will) can pick up #1 to #7, that is also fine, then I
> can drop #8 into rmk's patch database.

I was planning merging these for 4.10.  But I'm fine with them
going through the arm tree.  Let me know what you guys want to
do.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
