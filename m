From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: DMA support for mv_cesa
Date: Mon, 28 Jul 2014 10:17:57 -0400
Message-ID: <20140728141757.GR23220@titan.lakedaemon.net>
References: <CADP6xpuU1V0byRQDp7+=VB6Ao3uL-YxjwYd6YK+KWc51fJVDsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
To: Muran Hrun <muuhuu@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24391 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1OSH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 10:18:07 -0400
Content-Disposition: inline
In-Reply-To: <CADP6xpuU1V0byRQDp7+=VB6Ao3uL-YxjwYd6YK+KWc51fJVDsg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Muran,

+ free-electron's, mvebu maintainers

On Mon, Jul 28, 2014 at 03:24:43PM +0200, Muran Hrun wrote:
> What is the status of DMA support for mv_cesa? I tried applying the patches at
> git://nwl.cc/~n0-1/linux.git (cesa-dma branch)
> on kernel 3.15.6 but the kernel just crashed on my DNS-320, when
> accessing an encrypted volume. (Kernel 3.5rc2 in the respository did
> not boot at all)
> 
> Is DMA support for mv_cesa still developed?

thx,

Jason.
