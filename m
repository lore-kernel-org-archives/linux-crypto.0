From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Fix key inlining in AEAD shared
 descriptors
Date: Thu, 8 May 2014 21:52:55 +0800
Message-ID: <20140508135255.GA13355@gondor.apana.org.au>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
 <20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
 <72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
 <20140505133725.33abd0d08a1662a147c498f5@freescale.com>
 <70e10fa687e249f08a102f148edd3231@BL2PR03MB162.namprd03.prod.outlook.com>
 <20140506151114.e44a1af14c9d5b63ecbac603@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Garg Vakul-B16394 <vakul@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia Ioan-B05471 <Horia.Geanta@freescale.com>,
	Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>,
	Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47539 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaEHNw7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2014 09:52:59 -0400
Content-Disposition: inline
In-Reply-To: <20140506151114.e44a1af14c9d5b63ecbac603@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 06, 2014 at 03:11:14PM -0500, Kim Phillips wrote:
>
> > > > I think that the form I submitted is equally easy to read.
> > > 
> > > adding one line instead of two -> less lines overall -> more code on one
> > > screen -> easier to read.
> > 
> > I think that this is a matter of personal coding choice.
> > Both the approaches are fine and compliant to kernel coding guidelines.
> 
> I disagree, for the reasons already mentioned above.

I like Kim's version better.  Kim, could you respin a patch in
the way you described?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
