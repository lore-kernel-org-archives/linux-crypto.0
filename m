From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 3/3] arm64: enable 128-bit memory read/write support
Date: Wed, 24 Jan 2018 21:19:54 +0300
Message-ID: <20180124181954.o6e6wfekbdnjn7rc@yury-thinkpad>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
 <20180124090519.6680-4-ynorov@caviumnetworks.com>
 <CAMuHMdU5AHC4ZYkvC=X4UUAnGyysHqayv4m+T5=1Grpo5Qez4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>,
        Will Deacon <will.deacon@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0086.outbound.protection.outlook.com ([104.47.34.86]:57760
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964930AbeAXSUK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 13:20:10 -0500
Content-Disposition: inline
In-Reply-To: <CAMuHMdU5AHC4ZYkvC=X4UUAnGyysHqayv4m+T5=1Grpo5Qez4g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 24, 2018 at 02:00:42PM +0100, Geert Uytterhoeven wrote:
> Hi Yury,
> 
> On Wed, Jan 24, 2018 at 10:05 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:
> > Introduce __raw_writeo(), __raw_reado() and other arch-specific
> > RW functions for 128-bit memory access, and enable it for arm64.
> >
> > 128-bit I/O is required for example by Octeon TX2 device to access
> > some registers. According to Hardware Reference Manual:
> >
> > A 128-bit write to the OP_FREE0/1 registers frees a pointer into a
> > given [...] pool. All other accesses to these registers (e.g. reads
> > and 64-bit writes) are RAZ/WI.
> >
> > Starting from ARMv8.4, stp and ldp instructions become atomic, and
> > API for 128-bit access would be helpful for core code.
> >
> > Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
> 
> Thanks for your patch!
> 
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -116,6 +116,13 @@ config UPROBES
> >             managed by the kernel and kept transparent to the probed
> >             application. )
> >
> > +config HAVE_128BIT_ACCESS
> > +       def_bool ARM64
> 
> I think it's better to select this symbol from arch/arm64/Kconfig instead.
> Else this file has to be modified each and every time an architecture
> adds support for 128-bit, causing conflicts.

Shure, thanks.

Yury
 
> > +       help
> > +         Architectures having 128-bit access require corresponding APIs,
> > +         like reado() and writeo(), which stands for reading and writing
> > +         the octet of bytes at once.
> > +
> >  config HAVE_64BIT_ALIGNED_ACCESS
> >         def_bool 64BIT && !HAVE_EFFICIENT_UNALIGNED_ACCESS
> >         help
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
