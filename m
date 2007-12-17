From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] tcrypt depends on AEAD
Date: Tue, 18 Dec 2007 00:08:45 +0800
Message-ID: <20071217160845.GC14440@gondor.apana.org.au>
References: <20071216202925.GC29507@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2428 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934453AbXLQQIr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 11:08:47 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4IWL-0005Go-SO
	for <linux-crypto@vger.kernel.org>; Tue, 18 Dec 2007 03:08:46 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J4IWL-0003nN-00
	for <linux-crypto@vger.kernel.org>; Tue, 18 Dec 2007 00:08:45 +0800
Content-Disposition: inline
In-Reply-To: <20071216202925.GC29507@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 16, 2007 at 09:29:25PM +0100, Sebastian Siewior wrote:
>  ERROR: "crypto_aead_setauthsize" [crypto/tcrypt.ko] undefined!
>  ERROR: "crypto_alloc_aead" [crypto/tcrypt.ko] undefined!
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks Sebastian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
