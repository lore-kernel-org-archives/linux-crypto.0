From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Question about Talitos Linux driver for MPC885
Date: Tue, 25 Sep 2012 19:47:30 -0500
Message-ID: <20120925194730.85456a91d813a7fa35b637f4@freescale.com>
References: <50616F1D.108@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.32.180.185] ([216.32.180.185]:4014 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752430Ab2IZAvS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Sep 2012 20:51:18 -0400
In-Reply-To: <50616F1D.108@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 25 Sep 2012 10:45:17 +0200
leroy christophe <christophe.leroy@c-s.fr> wrote:

> I'm trying to use the Talitos crypto driver with the MPC885 
> microcontroller. For the time being, it doesn't work.

yes, they're not exactly compatible...

> The kernel startup blocks at the test of the DES function.
> 
> I have added the following definition in the DTS file:
> 
>          crypto@20000 {
>              compatible = "fsl,sec2.0";

interesting, its called "SEC Lite" and its version register does
indeed say 2.  I see it has a single channel FIFO instead of a ring,
that the SEC v1.x (MPC185) used, so you probably don't have to
rewrite talitos_submit.

>              reg = <0x20000 0x8000>;
>              interrupts = <1 1>;

I couldn't find the IRQ line in the MPC855RM - if there's no IRQ
line, then that's a problem.

>              interrupt-parent = <&PIC>;
>              fsl,num-channels = <1>;
>              fsl,channel-fifo-len = <24>;
>              fsl,exec-units-mask = <0x4c>;
>              fsl,descriptor-types-mask = <0x301f>;

the descriptor type enumeration isn't uniform across into the mpc8xx
SEC version, e.g., the SEC Lite doesn't support the ipsec_esp
descriptor type, represented in mpc8xxx SEC versions as the second
bit, so this descriptor-types-mask setting should be fixed to at
least omit that since the driver checks for, and uses it if
available.

> Is there anything wrong in what I did ? Or is there something else I 
> should do ?

might want to go through the defines in talitos.h, e.g,
TALITOS_MCR_SWR is 0x1 on mpc8xxx vs. 0x10000000 on
mpc8xx (I suppose CONFIG_PPC_8xx can be used as the ifdef, btw).

Descriptor header and pointer formats, along with field locations,
sizes, and enumerations may also be different.

It also appears the SEC Lite doesn't support scatter-gather tables,
which will make performance hurt for fragmented (large) packet sizes.

Kim
