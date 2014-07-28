From: Phil Sutter <phil@nwl.cc>
Subject: Re: DMA support for mv_cesa
Date: Mon, 28 Jul 2014 23:05:56 +0200
Message-ID: <20140728210556.GB28452@orbit.nwl.cc>
References: <20140728163849.44ac7ec5@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Muran Hrun <muuhuu@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([176.31.251.142]:34242 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaG1VGA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 17:06:00 -0400
Content-Disposition: inline
In-Reply-To: <20140728163849.44ac7ec5@free-electrons.com>
 <20140728141757.GR23220@titan.lakedaemon.net>
 <CADP6xpuU1V0byRQDp7+=VB6Ao3uL-YxjwYd6YK+KWc51fJVDsg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 28, 2014 at 03:24:43PM +0200, Muran Hrun wrote:
> Hi,
> 
> What is the status of DMA support for mv_cesa? I tried applying the patches at
> git://nwl.cc/~n0-1/linux.git (cesa-dma branch)
> on kernel 3.15.6 but the kernel just crashed on my DNS-320, when
> accessing an encrypted volume. (Kernel 3.5rc2 in the respository did
> not boot at all)

Yes, this is pretty old, work in progress and almost certainly broken.

> Is DMA support for mv_cesa still developed?

I still have that in mind, but am buried in work.

On the technical side, the interesting thing is providing for the
various DMA engines Marvell has and probably will continue to bestow
upon us.

Cheers, Phil
