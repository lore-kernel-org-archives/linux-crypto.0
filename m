From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Async Crypto API
Date: Tue, 9 Feb 2010 18:31:55 +1100
Message-ID: <20100209073155.GA17506@gondor.apana.org.au>
References: <20100123032039.GA5551@gondor.apana.org.au> <4B6817EF.7060307@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60974 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075Ab0BIHb7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 02:31:59 -0500
Content-Disposition: inline
In-Reply-To: <4B6817EF.7060307@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 02, 2010 at 02:17:51PM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> In the case when finup() is not used, just update/update/../final
> driver finalize calculation from the final function.
> 
> It takes a time and if it may not sleep, can final() also return
> EINPROGRESS?

Sure, final can certainly return EINPROGRESS.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
