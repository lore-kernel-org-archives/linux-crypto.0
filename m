From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] crypto/ansi prng: alloc cipher just in in init()
Date: Wed, 1 Jul 2009 06:36:16 -0400
Message-ID: <20090701103616.GB29601@hmsreliant.think-freely.org>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org> <20090629214508.GB29616@Chamillionaire.breakpoint.cc> <20090630145150.GB13116@hmsreliant.think-freely.org> <20090630195517.GA4659@Chamillionaire.breakpoint.cc> <20090701000648.GA12326@localhost.localdomain> <20090701072517.GA9583@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33456 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZGAKgY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jul 2009 06:36:24 -0400
Content-Disposition: inline
In-Reply-To: <20090701072517.GA9583@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 01, 2009 at 09:25:17AM +0200, Sebastian Andrzej Siewior wrote:
> * Neil Horman | 2009-06-30 20:06:48 [-0400]:
> 
> >I think this looks better, yeah, have you tested this?  If not, give it a quick
> >run please, and I'll ack it.
> I've built it and started
> | modprobe tcrypt mode=150
> and I ended up with:
> | alg: No test for stdrng (ansi_cprng)
> 
> So this should be fine I guess.
> 
> >Neil
> 
> Sebastian
> 

Yeah, ok, that should be good, although I'll make a note and fix the aliasing
issue in the testmgr code

Acked-by: Neil Horman <nhorman@tuxdriver.com>

Herbert, can you pull this into cryptodev please?

