From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH v2] crypto: hash - Fix page length clamping in hash walk
Date: Wed, 4 May 2016 07:39:13 -0400
Message-ID: <20160504113913.GD29618@oracle.com>
References: <20160421071451.GE3347@gauss.secunet.com>
 <20160425100527.GA9521@gondor.apana.org.au>
 <20160428082743.GO3347@gauss.secunet.com>
 <20160503095531.GA18007@gondor.apana.org.au>
 <20160504093420.GB3347@gauss.secunet.com>
 <20160504095256.GA27632@gondor.apana.org.au>
 <20160504100854.GD3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42219 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbcEDLjZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 07:39:25 -0400
Content-Disposition: inline
In-Reply-To: <20160504100854.GD3347@gauss.secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (05/04/16 12:08), Steffen Klassert wrote:
> > > Sowmini, could you please doublecheck with your test setup?
> > 
> > Don't bother, my patch was crap.  Here's one that's more likely
> > to work:
> 
> This one is much better, works here :)

The patch seems to work, but the caveat is that the original
bug (iperf segv) was not always reproducible on demand - it depended
on memory and other config. 

But looks like Steffen has a reliable way to reproduce the original
problem, so lets go with this patch for now.

--Sowmini
