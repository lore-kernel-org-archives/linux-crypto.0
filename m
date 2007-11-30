From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] geode: do not copy the IV too often
Date: Fri, 30 Nov 2007 16:37:12 +1100
Message-ID: <20071130053712.GA30917@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115212335.GB21159@Chamillionaire.breakpoint.cc> <20071126092521.GC18309@Chamillionaire.breakpoint.cc> <20071126092832.GA25693@gondor.apana.org.au> <20071126094226.GA18532@Chamillionaire.breakpoint.cc> <20071127193358.GB3506@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4483 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbXK3FhR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Nov 2007 00:37:17 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IxyYr-000768-A1
	for <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2007 16:37:13 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IxyYq-0008Di-00
	for <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2007 16:37:12 +1100
Content-Disposition: inline
In-Reply-To: <20071127193358.GB3506@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 27, 2007 at 08:33:58PM +0100, Sebastian Siewior wrote:
> There is no reason to keep the IV in the private structre. Instead keep
> just a pointer to make the patch smaller :)
> This also remove a few memcpy()s
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks a lot Sebastian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
