From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] crypto/arm64: aes-ce-cipher - move assembler code to .S
 file
Date: Wed, 22 Nov 2017 12:17:08 +0000
Message-ID: <20171122121708.rw7zxmomhao3jnzc@lakrids.cambridge.arm.com>
References: <20171121134017.21247-1-ard.biesheuvel@linaro.org>
 <20171122100558.717b7973@delmar.localdomain>
 <CAKv+Gu8Tde_yu-3MWFEgdaWDWtf1SssUAMc1s396zL=J-j+buA@mail.gmail.com>
 <20171122120457.cf47mwmg4pudzoy4@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>,
        Will Deacon <will.deacon@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Greg Hackmann <ghackmann@google.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Yury Norov <ynorov@caviumnetworks.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alex Matveev <alxmtvv@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51328 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752358AbdKVMRO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 07:17:14 -0500
Content-Disposition: inline
In-Reply-To: <20171122120457.cf47mwmg4pudzoy4@lakrids.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 12:04:58PM +0000, Mark Rutland wrote:
> On Wed, Nov 22, 2017 at 10:12:17AM +0000, Ard Biesheuvel wrote:
> > On 22 November 2017 at 10:05, Alex Matveev <alxmtvv@gmail.com> wrote:
> > > This is better than my simple fix, thank you.
> > >
> > > Out of curiosity, why doesn't NEON code use barrier() to prevent
> > > reordering?
> > 
> > Because barrier() affects ordering of memory accesses, not register accesses.
> 
> My understanding was that barrier() also hazards with any volatile asm
> (and that in general, volatile asm block couldn't be re-ordered w.r.t.
> one another). I'm sure we rely on this, even if it's not true. :/

>From a quick scan, certainly in tls_thread_flush(),
compat_arm_syscall(), elsewhere where we have isb() and other helpers
like {read,write}_sysreg().

Mark.
