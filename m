From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] geode: do not copy the IV too often
Date: Sun, 18 Nov 2007 21:41:13 +0800
Message-ID: <20071118134113.GA28869@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115212335.GB21159@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4699 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752435AbXKRNlP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 08:41:15 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1ItkOg-0007Bc-03
	for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2007 00:41:14 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1ItkOf-0007W0-00
	for <linux-crypto@vger.kernel.org>; Sun, 18 Nov 2007 21:41:13 +0800
Content-Disposition: inline
In-Reply-To: <20071115212335.GB21159@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 15, 2007 at 10:23:35PM +0100, Sebastian Siewior wrote:
> There is no reason to keep the IV in the private structre.
> This also remove a few memcpy()s
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Thanks Sebastian.

How about just change op->iv to a pointer and assigning walk->iv
to it? That should make a smaller patch.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
