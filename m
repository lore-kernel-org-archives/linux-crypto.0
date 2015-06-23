From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] crypto: jitterentropy - avoid compiler warnings
Date: Tue, 23 Jun 2015 20:15:05 +0200
Message-ID: <CAMuHMdUVKRKZvZGcEfNkStdvYC+pGkiHyuGGzhdvcfT2GGucEw@mail.gmail.com>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com>
	<33380936.3jDOACMRCz@tachyon.chronox.de>
	<CAMuHMdUw9FJE3kWEQf+TNTaLB9gMjdHEGt27bnD--qoGX22H7Q@mail.gmail.com>
	<1446731.BXdYRBoPhr@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Guenter Roeck <linux@roeck-us.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1446731.BXdYRBoPhr@tachyon.chronox.de>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

On Tue, Jun 23, 2015 at 4:18 PM, Stephan Mueller <smueller@chronox.de> wrote:
> may I ask that you check that the following patch compiles without errors or warnings on your systems?
>
> Though, when I test that patch with the AVR32 cross compiler, I get a warning about the code being not relaxable.
>
> Thank you very much.
>
> ---8<---
> The core of the Jitter RNG is intended to be compiled with -O0. To
> ensure that the Jitter RNG can be compiled on all architectures,
> separate out the RNG core into a stand-alone C file that can be compiled
> with -O0 which does not depend on any kernel include file.
>
> As no kernel includes can be used in the C file implementing the core
> RNG, any dependencies on kernel code must be extracted.
>
> A second file provides the link to the kernel and the kernel crypto API
> that can be compiled with the regular compile options of the kernel.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Thanks, the warnings I saw before with m68k-linux-gnu-gcc-4.1.2
are gone.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
