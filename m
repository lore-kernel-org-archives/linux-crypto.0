From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 17:51:08 +0000
Message-ID: <20160809175108.GE2013@io.lakedaemon.net>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <12791731.pG3fmEhvyp@tauon.atsec.com>
 <20160809095657.GB6618@gondor.apana.org.au>
 <11316081.S4pPZmZMrt@tauon.atsec.com>
 <20160809102458.GA20214@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1.eu.mailhop.org ([52.28.251.132]:60352 "EHLO
	outbound1.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbcHIRxT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 13:53:19 -0400
Content-Disposition: inline
In-Reply-To: <20160809102458.GA20214@khazad-dum.debian.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Henrique,

On Tue, Aug 09, 2016 at 07:24:58AM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 09 Aug 2016, Stephan Mueller wrote:
> > RHEL 7 and Fedora do not adjust it. So, shall we consider those rng-tools then 
> > broken (at least in those large distros)?
> 
> Might I humbly suggest that the kernel start providing some metatada
> about the quality of the random source that userspace can consume?
> Preferably by a new ioctl, so that it will fit naturally if we ever
> extend /dev/hwrng to support more than one source?
> 
> That would allow for auto tunning to be implemented in userspace...

See my reply to Keith Packard's proposed multi-device hw_random patch:

  https://lkml.kernel.org/r/20160809165710.GC2013@io.lakedaemon.net

and top of thread:

  https://lkml.kernel.org/r/1469477255-26824-1-git-send-email-keithp@keithp.com

thx,

Jason.
