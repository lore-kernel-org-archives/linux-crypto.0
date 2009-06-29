From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 2/2] crypto/ansi prng: alloc cipher just in in init()
Date: Mon, 29 Jun 2009 17:54:28 -0400
Message-ID: <20090629215428.GA10465@hmsreliant.think-freely.org>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org> <20090629214508.GB29616@Chamillionaire.breakpoint.cc> <20090629214821.GC29616@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47902 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZF2Vya (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 17:54:30 -0400
Content-Disposition: inline
In-Reply-To: <20090629214821.GC29616@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 29, 2009 at 11:48:21PM +0200, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2009-06-29 23:45:08 [+0200]:
> 
> >From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> >
> >As reported by Eric Sesterhenn the re-allocation of the cipher in reset leads
> 
> Neil, the patches are untested. Could you please verify them?
> 
> Sebastian
> 

Yeah, you'll have to give me a day or two to get to it, but I'll test them

Neil

