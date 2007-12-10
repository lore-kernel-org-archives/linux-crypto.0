From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] s390-aes: use correct encrypt/decrypt function in fallback
Date: Mon, 10 Dec 2007 15:49:56 +0800
Message-ID: <20071210074956.GB754@gondor.apana.org.au>
References: <20071208124230.GC1911@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3230 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbXLJHuD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 02:50:03 -0500
Content-Disposition: inline
In-Reply-To: <20071208124230.GC1911@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 08, 2007 at 01:42:30PM +0100, Sebastian Siewior wrote:
> crypto_blkcipher_decrypt is wrong because it does not care about
> the IV.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Also applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
