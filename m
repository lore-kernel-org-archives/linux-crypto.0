From: Vakul Garg <vakul@freescale.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Thu, 25 Apr 2013 03:45:55 +0000 (UTC)
Message-ID: <loom.20130425T054131-302@post.gmane.org>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com> <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com> <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com> <20110126070939.GA18150@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35673 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758485Ab3DYDuE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Apr 2013 23:50:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1UVDC7-0006nQ-1z
	for linux-crypto@vger.kernel.org; Thu, 25 Apr 2013 05:50:03 +0200
Received: from gate-zin2.freescale.com ([192.88.169.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2013 05:50:03 +0200
Received: from vakul by gate-zin2.freescale.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2013 05:50:03 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert <at> gondor.apana.org.au> writes:

> 
> On Wed, Jan 26, 2011 at 10:26:33AM +0330, Hamid Nassiby wrote:
> >
> > As you know, I posted my problem again to crypto list and no one 
answered.
> > Now I
> > emphasize one aspect of the problem as a concept related to IPSec 
protocol,
> > free
> > of my problem's nature, and I hope to get some guidelines at this time. 
The
> > question is as following:
> > If IPSec delivers IP packets to hardware crypto accelerator in 
sequential
> > manner
> > (e.g, packets in order: 1, 2, 3, ..., 36, 37, 38,...) and crypto 
accelerator
> > possibly returns back packets out of entering order to IPSec (e.g, 
packet
> > 37 is returned back before the packet 36 to IPSec, so the order of 
packets
> > is
> > not the same before entering crypto accelerator and after exiting it); 
Is it
> > possible to rise any problem here?
> 
> We do not allow such reordering.  All crypto drivers must ensure
> ordering within a single tfm.  Between different tfms there is no
> ordering requirement.
> 
> Cheers,


Hello Herbert,

Does this mean that processing of all the crypto requests from a single tfm 
must be serialized even if they execute on multiple different cores?

Regards
