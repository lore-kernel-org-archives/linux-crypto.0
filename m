From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Build regressions/improvements in v3.10-rc1 (crypto/parisc)
Date: Sun, 12 May 2013 22:49:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305122248030.5463@ayla.of.borg>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg> <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, linux-parisc@vger.kernel.org
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Sender: linux-parisc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 12 May 2013, Geert Uytterhoeven wrote:
> However, the full list of errors isn't that unmanageable, so I'm following
> up with a digested list...

lib/mpi/generic_mpih-mul1.c:50:3: error: inconsistent operand constraints in an 'asm': 1 errors in 1 logs
lib/mpi/generic_mpih-mul2.c:49:3: error: inconsistent operand constraints in an 'asm': 1 errors in 1 logs
lib/mpi/generic_mpih-mul3.c:49:3: error: inconsistent operand constraints in an 'asm': 1 errors in 1 logs
lib/mpi/mpih-div.c:142:6: error: inconsistent operand constraints in an 'asm': 1 errors in 1 logs
lib/mpi/mpih-div.c:205:6: error: inconsistent operand constraints in an 'asm': 1 errors in 1 logs
	v3.10-rc1/parisc/parisc-allmodconfig


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
