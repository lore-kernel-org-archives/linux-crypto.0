From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] geode: do not copy the IV too often
Date: Mon, 26 Nov 2007 17:28:32 +0800
Message-ID: <20071126092832.GA25693@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115212335.GB21159@Chamillionaire.breakpoint.cc> <20071126092521.GC18309@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1953 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161AbXKZJ2e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 04:28:34 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IwaGW-0003ji-QH
	for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 20:28:33 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IwaGW-0006gt-00
	for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 17:28:32 +0800
Content-Disposition: inline
In-Reply-To: <20071126092521.GC18309@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 26, 2007 at 10:25:21AM +0100, Sebastian Siewior wrote:
>
> I saw that you rebased your cryptodev tree but you did not include
> this patch. Should I resend it?

I had to check my archives to refresh my memory :)

OK I dropped it because:

: How about just change op->iv to a pointer and assigning walk->iv
: to it? That should make a smaller patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
