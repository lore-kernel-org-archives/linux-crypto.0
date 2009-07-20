From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: authenc - convert to ahash
Date: Mon, 20 Jul 2009 16:22:24 +0800
Message-ID: <20090720082224.GB4797@gondor.apana.org.au>
References: <20090717074709.GZ20288@secunet.com> <20090720065244.GA4026@gondor.apana.org.au> <20090720074956.GB20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34898 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbZGTIWZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2009 04:22:25 -0400
Content-Disposition: inline
In-Reply-To: <20090720074956.GB20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2009 at 09:49:56AM +0200, Steffen Klassert wrote:
>
> Aside the optimization, another reason to use the digest interface was to
> avoid callback functions for init, update and finup. I guess we can not
> avoid this if assoc can be a sg list with more than one entry, so I'll
> update the patch in this manner.

Actually, you can assume that init is always sync since I'll
ensure that everything supports export/import before hmac is
converted to ahash (from shash).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
