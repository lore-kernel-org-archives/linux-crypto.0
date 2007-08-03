From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Fri, 3 Aug 2007 21:43:02 +0800
Message-ID: <20070803134302.GA26727@gondor.apana.org.au>
References: <20070802125743.GC24639@Chamillionaire.breakpoint.cc> <20070803123425.GA25948@gondor.apana.org.au> <20070803132628.GC17687@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1311 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758068AbXHCNnF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Aug 2007 09:43:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGxQl-000850-JB
	for <linux-crypto@vger.kernel.org>; Fri, 03 Aug 2007 23:43:03 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGxQl-0006xL-00
	for <linux-crypto@vger.kernel.org>; Fri, 03 Aug 2007 21:43:03 +0800
Content-Disposition: inline
In-Reply-To: <20070803132628.GC17687@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 03, 2007 at 03:26:28PM +0200, Sebastian Siewior wrote:
> 
> Why not? This is used by _any_ cipher/hash/... user in tree. Most of
> algos specify an alignment of 3 what is very likely to become. I
> checked IPsec and they allocated keys with an alignment of 7.
> padlock-aes specifies an alignment of 15 so there is a 50-50 chance that
> it will go well :)
> I don't know if you count this as user, but tcrypt.c has an alignment of
> 3 and the tgr hash needs 7.

Thanks for checking.

I'll get this pushed into stable too.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
