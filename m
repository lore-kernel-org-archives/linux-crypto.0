From: Simon Baatz <gmbnomis@gmail.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 18 Jun 2012 22:12:36 +0200
Message-ID: <20120618201235.GA20755@schnuecks.de>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Simon Baatz <gmbnomis@gmail.com>, linux-crypto@vger.kernel.org,
	cloudy.linux@gmail.com, andrew@lunn.ch
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61148 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2FRUMj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 16:12:39 -0400
Received: by eeit10 with SMTP id t10so1749992eei.19
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jun 2012 13:12:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120618134718.GL9122@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Phil,

On Mon, Jun 18, 2012 at 03:47:18PM +0200, Phil Sutter wrote:
> On Sat, Jun 16, 2012 at 02:20:19AM +0200, Simon Baatz wrote:
> > thanks for providing these patches; it's great to finally see DMA
> > support for CESA in the kernel. Additionally, the implementation seems
> > to be fine regarding cache incoherencies (at least my test in [*]
> > works).
> 
> Thanks for testing and the fixes. Could you also specify the platform
> you are testing on?

This is a Marvell Kirkwood MV88F6281-A1. 

I see one effect that I don't fully understand. 
Similar to the previous implementation, the system is mostly in
kernel space when accessing an encrypted dm-crypt device:

# cryptsetup --cipher=aes-cbc-plain --key-size=128 create c_sda2 /dev/sda2 
Enter passphrase: 
# dd if=/dev/mapper/c_sda2 of=/dev/null bs=64k count=2048
2048+0 records in
2048+0 records out
134217728 bytes (134 MB) copied, 10.7324 s, 12.5 MB/s

Doing an "mpstat 1" at the same time gives:

21:21:42     CPU    %usr   %nice    %sys %iowait    %irq   %soft ...
21:21:45     all    0.00    0.00    0.00    0.00    0.00    0.00
21:21:46     all    0.00    0.00   79.00    0.00    0.00    2.00
21:21:47     all    0.00    0.00   95.00    0.00    0.00    5.00
21:21:48     all    0.00    0.00   94.00    0.00    0.00    6.00
21:21:49     all    0.00    0.00   96.00    0.00    0.00    4.00
...

The underlying device is a SATA drive and should not be the limit:

# dd if=/dev/sda2 of=/dev/null bs=64k count=2048
2048+0 records in
2048+0 records out
134217728 bytes (134 MB) copied, 1.79804 s, 74.6 MB/s

I did not dare hope the DMA implementation to be much faster than the
old one, but I would have expected a rather low CPU usage using DMA. 
Do you have an idea where the kernel spends its time?  (Am I hitting
a non/only partially accelerated path here?)

> > - My system locked up hard when mv_dma and mv_cesa were built as
> >   modules. mv_cesa has code to enable the crypto clock in 3.5, but
> >   mv_dma already accesses the CESA engine before. Thus, we need to
> >   enable this clock here, too.
> 
> I have folded them into my patch series, thanks again. I somewhat miss
> the orion_clkdev_add() part for orion5x platforms, but also fail to find
> any equivalent place in the correspondent subdirectory. So I hope it is
> OK like this.

The change follows the original clk changes by Andrew. I don't know
orion5x, but apparently, only kirkwood has such fine grained clock
gates:

/* Create clkdev entries for all orion platforms except kirkwood.
   Kirkwood has gated clocks for some of its peripherals, so creates
   its own clkdev entries. For all the other orion devices, create
   clkdev entries to the tclk. */

(from plat-orion/common.c)

This is why the clock enabling code in the modules ignores the case
that the clock can't be found.  I think the clocks defined by
plat-orion are for those drivers that need the actual TCLK rate (but
there is no clock gate functionality here).

- Simon
