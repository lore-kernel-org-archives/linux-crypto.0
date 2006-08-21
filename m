From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Warning: cryptodev-2.6 to be rebased
Date: Mon, 21 Aug 2006 21:49:26 +1000
Message-ID: <20060821114925.GA22544@gondor.apana.org.au>
References: <20060806104937.GA30095@gondor.apana.org.au> <20060815070938.GA30796@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:16402 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S965066AbWHULta
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Aug 2006 07:49:30 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1GF8HY-0002lT-8H
	for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2006 21:49:28 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1GF8HW-00060P-00
	for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2006 21:49:26 +1000
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060815070938.GA30796@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 15, 2006 at 05:09:38PM +1000, herbert wrote:
> 
> Sorry, I've had to rebase it again due to conflicts in the mm tree.

There you go, I'm rebasing it again because the compatibility stuff for
cipher turned out to be broken.  I've also taken the opportunity to
coalesce some bug fix changesets.

Cheers.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
