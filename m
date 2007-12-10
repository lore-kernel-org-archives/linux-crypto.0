From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] Geode: use correct encrypt/decrypt function in fallback
Date: Mon, 10 Dec 2007 15:48:40 +0800
Message-ID: <20071210074840.GA754@gondor.apana.org.au>
References: <20071208124122.GB1911@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3223 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbXLJHsm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 02:48:42 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1dNZ-0007cF-04
	for <linux-crypto@vger.kernel.org>; Mon, 10 Dec 2007 18:48:41 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J1dNY-0000DH-00
	for <linux-crypto@vger.kernel.org>; Mon, 10 Dec 2007 15:48:40 +0800
Content-Disposition: inline
In-Reply-To: <20071208124122.GB1911@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 08, 2007 at 01:41:22PM +0100, Sebastian Siewior wrote:
> crypto_blkcipher_decrypt is wrong because it does not care about
> the IV.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks Sebastian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
