From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 5/5] crypto: talitos - add IPsec ESN support
Date: Tue, 7 Aug 2012 21:27:48 -0500
Message-ID: <20120807212748.d805c751b83e14e20b397cc1@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
	<1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
	<20120806204751.1f6277ba8f7b1de92fd128ac@freescale.com>
	<FD18E5D573A8AB48A365D4D78185DE9929291E@039-SN1MPN1-001.039d.mgd.msft.net>
	<FD18E5D573A8AB48A365D4D78185DE99293799@039-SN1MPN1-001.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:35707
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab2HHC34 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Aug 2012 22:29:56 -0400
In-Reply-To: <FD18E5D573A8AB48A365D4D78185DE99293799@039-SN1MPN1-001.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 7 Aug 2012 08:34:07 -0500
Geanta Neag Horia Ioan-B05471 <B05471@freescale.com> wrote:

> On Tue, 7 Aug 2012 09:54:14 +0300, Geanta Neag Horia Ioan-B05471 <B05471@freescale.com> wrote:
> > On Tue, 7 Aug 2012 04:47:51 +0300, Phillips Kim-R1AAHA <R1AAHA@freescale.com> wrote:
> 
> >> Also: if the algorithm name is really all that changes, can it be
> >> done more space-efficiently with some string manipulation in the
> >> algorithm registration loop?:  If registering an "authenc"
> >> algorithm, also register an "authencesn" version.
> > 
> > Agree. Will come up with smth more elegant in v2.
> > 
> 
> Looking closer at algorithm registration, talitos_alg_alloc uses shallow copies
> of the templates in driver_algs[], so maybe sticking with the initial approach
> is safer ?

not sure what you mean by 'shallow copies', but the t_alg->algt =
*template assignment should be copying the entire struct crypto_alg.

There are lots more redundancies in driver_algs, e.g., all
.type == ALG_TYPE_AEADs have the same .cra_type and entry points.
So, ideally, as support for more algorithms are added, factoring out
the the common assignments into talitos_alg_alloc should keep the
size of driver_algs from exploding and becoming even more
unmanageable.

Kim
