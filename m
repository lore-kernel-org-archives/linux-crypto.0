From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 16 Feb 2010 08:44:30 +0800
Message-ID: <20100216004430.GA26021@gondor.apana.org.au>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B72A3A4.4050700@nokia.com> <4B799E83.5000700@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38091 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932411Ab0BPAod (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 19:44:33 -0500
Content-Disposition: inline
In-Reply-To: <4B799E83.5000700@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 15, 2010 at 09:20:35PM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> Alg code and drivers uses req/desc->flags to use GFP_KERNEL or GFP_ATOMIC.
> 
> crypto_kmap() -> Does not it make a sense to also use kmap/kmap_atomic
> instead of just kmap_atomic()?

crypto_kmap is not meant for async drivers.  Why do you need it?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
