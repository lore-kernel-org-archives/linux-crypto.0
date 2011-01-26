From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Wed, 26 Jan 2011 17:09:39 +1000
Message-ID: <20110126070939.GA18150@gondor.apana.org.au>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com> <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com> <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35277 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1AZHJl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 02:09:41 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 26, 2011 at 10:26:33AM +0330, Hamid Nassiby wrote:
>
> As you know, I posted my problem again to crypto list and no one answered.
> Now I
> emphasize one aspect of the problem as a concept related to IPSec protocol,
> free
> of my problem's nature, and I hope to get some guidelines at this time. The
> question is as following:
> If IPSec delivers IP packets to hardware crypto accelerator in sequential
> manner
> (e.g, packets in order: 1, 2, 3, ..., 36, 37, 38,...) and crypto accelerator
> possibly returns back packets out of entering order to IPSec (e.g, packet
> 37 is returned back before the packet 36 to IPSec, so the order of packets
> is
> not the same before entering crypto accelerator and after exiting it); Is it
> possible to rise any problem here?

We do not allow such reordering.  All crypto drivers must ensure
ordering within a single tfm.  Between different tfms there is no
ordering requirement.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
