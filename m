From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] crypto/arm64: aes-ce-cipher - move assembler code to .S
 file
Date: Wed, 22 Nov 2017 12:04:58 +0000
Message-ID: <20171122120457.cf47mwmg4pudzoy4@lakrids.cambridge.arm.com>
References: <20171121134017.21247-1-ard.biesheuvel@linaro.org>
 <20171122100558.717b7973@delmar.localdomain>
 <CAKv+Gu8Tde_yu-3MWFEgdaWDWtf1SssUAMc1s396zL=J-j+buA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Matveev <alxmtvv@gmail.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Greg Hackmann <ghackmann@google.com>,
        Kees Cook <keescook@chromium.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Yury Norov <ynorov@caviumnetworks.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Will Deacon <will.deacon@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51236 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752322AbdKVMFD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 07:05:03 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8Tde_yu-3MWFEgdaWDWtf1SssUAMc1s396zL=J-j+buA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 10:12:17AM +0000, Ard Biesheuvel wrote:
> On 22 November 2017 at 10:05, Alex Matveev <alxmtvv@gmail.com> wrote:
> > This is better than my simple fix, thank you.
> >
> > Out of curiosity, why doesn't NEON code use barrier() to prevent
> > reordering?
> 
> Because barrier() affects ordering of memory accesses, not register accesses.

My understanding was that barrier() also hazards with any volatile asm
(and that in general, volatile asm block couldn't be re-ordered w.r.t.
one another). I'm sure we rely on this, even if it's not true. :/

So making the asm statements volatile might work too.

Thanks,
Mark.
