From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: DMA support for mv_cesa
Date: Mon, 28 Jul 2014 16:38:49 +0200
Message-ID: <20140728163849.44ac7ec5@free-electrons.com>
References: <CADP6xpuU1V0byRQDp7+=VB6Ao3uL-YxjwYd6YK+KWc51fJVDsg@mail.gmail.com>
	<20140728141757.GR23220@titan.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Muran Hrun <muuhuu@gmail.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-crypto@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:39921 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbaG1Oiw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 10:38:52 -0400
In-Reply-To: <20140728141757.GR23220@titan.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jason, Muran,

+Cc Tawfik and Lior from Marvell.

On Mon, 28 Jul 2014 10:17:57 -0400, Jason Cooper wrote:
> Muran,
> 
> + free-electron's, mvebu maintainers
> 
> On Mon, Jul 28, 2014 at 03:24:43PM +0200, Muran Hrun wrote:
> > What is the status of DMA support for mv_cesa? I tried applying the patches at
> > git://nwl.cc/~n0-1/linux.git (cesa-dma branch)
> > on kernel 3.15.6 but the kernel just crashed on my DNS-320, when
> > accessing an encrypted volume. (Kernel 3.5rc2 in the respository did
> > not boot at all)
> > 
> > Is DMA support for mv_cesa still developed?

On our (Free Electrons) side, we haven't started working on the crypto
unit for Armada 370/XP/375/38x, so it's not a driver for which we have
followed the recent developments. However, it might appear on our
TODO-list at some point in the future.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
