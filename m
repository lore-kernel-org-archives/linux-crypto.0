From: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Subject: RE: [PATCH v2] crypto/caam: add backlogging support
Date: Wed, 23 Sep 2015 14:40:32 +0000
Message-ID: <BY1PR03MB1404567DB10A5990A864FD8580440@BY1PR03MB1404.namprd03.prod.outlook.com>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918135017.GA9152@gondor.apana.org.au>
 <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918141040.GL9249@gondor.apana.org.au>
 <BY1PR03MB1404D7BD44164F6E91FFBAD680590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150923120200.GA21368@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Geanta Neag Horia" <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0115.outbound.protection.outlook.com ([207.46.100.115]:40042
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754733AbbIWOkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 10:40:36 -0400
In-Reply-To: <20150923120200.GA21368@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Wednesday, September 23, 2015 3:02 PM
> To: Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
> Cc: linux-crypto@vger.kernel.org; Geanta Neag Horia Ioan-B05471
> <Horia.Geanta@freescale.com>; Pop Mircea-R19439
> <mircea.pop@freescale.com>
> Subject: Re: [PATCH v2] crypto/caam: add backlogging support
> 
> On Fri, Sep 18, 2015 at 02:27:12PM +0000, Porosanu Alexandru wrote:
> >
> > Well, the HW has less than the whole RAM for backlogging requests, it has
> the # of available backlogging requests slots.
> > Then it will start dropping, just like in the out-of-mem case.
> 
> OK I think that's where our misunderstanding is.  For a backlogged request
> you do not give it to the hardware immediately.  In fact a request should only
> be backlogged when the hardware queue is completely full.  It should stay in
> a software queue until the hardware has space for it.  When that happens
> you move it onto the hardware queue and invoke the completion function
> with err set to -EINPROGRESS.  This tells the caller to enqueue that it may
> enqueue more requests.

Yes, you are absolutely right. In this case, I have some reasons why I wouldn't like to use a crypto_queue based approach:

1) we've prototyped a crypto_queue implementation which did not reach the performance expectations due to CPU overhead;

2) the modifications implied by adding support for the crypto_queue in the driver add complexity, as well as increasing the code size;

3) as opposed to f.i. Talitos, there's already a queue that is long enough to be split in half for reserving slots for any backlogging tfm; that's what I've proposed in v4 of this patch;

To elaborate a bit on  in the v4 of this patch, I've introduce a limitation of the # of tfms that can be affined on a JR, equal to half the JR size minus 1. This means that in the worst case scenario where all the 255 (for a JR length of 512) tfms are backlog-enabled, there are at least 2 slots available for each tfm.

An observation about the queue length: having a deep queue (be it HW or SW) doesn't help; the length of the queue should be there to dampen  the spikes. The longer the queue, the worse the latency becomes.  TBH, our current setting of 512 entries in the JR is way too big. Somewhere around 16-64 should be enough. Let's take the following example: 9600B (jumbo) TCP packets on a 10Gbps line; the time interval between the last enqueue in our 512 entries JR and the time it goes out of the JR and back to the net subsystem is equal to ~39 ms.


> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

BR,

Alex P.
