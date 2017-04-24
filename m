From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to
 ASM_EXPORT
Date: Mon, 24 Apr 2017 16:00:56 +0800
Message-ID: <20170424080056.GA20285@gondor.apana.org.au>
References: <20170405183458.193068-1-mka@chromium.org>
 <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
 <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
 <20170418173401.GA128305@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Hackmann <ghackmann@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Matthias Kaehlcke <mka@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:43776 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1166163AbdDXIC2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 04:02:28 -0400
Content-Disposition: inline
In-Reply-To: <20170418173401.GA128305@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 18, 2017 at 10:34:01AM -0700, Matthias Kaehlcke wrote:
> El Tue, Apr 18, 2017 at 04:35:02PM +0100 Ard Biesheuvel ha dit:
> 
> > On 18 April 2017 at 15:47, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > > On Wed, Apr 5, 2017 at 2:34 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
> > >> The operand is an integer constant, make the constness explicit by
> > >> adding the modifier. This is needed for clang to generate valid code
> > >> and also works with gcc.
> > >
> > > Actually it doesn't work with all gcc.  I've got an older arm64 toolchain that I
> > > only use for syntax checking (and hence I don't care if it is the latest and
> > > greatest) and this commit breaks it:
> > >
> > > arch/arm64/crypto/sha1-ce-glue.c:21:2: error: invalid 'asm': invalid
> > > operand prefix '%c'
> > >   asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
> 
> Sorry about that :(

So what's the consensus? Should I revert this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
