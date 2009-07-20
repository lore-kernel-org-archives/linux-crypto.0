From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: authenc - convert to ahash
Date: Mon, 20 Jul 2009 10:39:53 +0200
Message-ID: <20090720083953.GE20288@secunet.com>
References: <20090717074709.GZ20288@secunet.com> <20090720065244.GA4026@gondor.apana.org.au> <20090720074956.GB20288@secunet.com> <20090720082224.GB4797@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:50173 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZGTIhL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2009 04:37:11 -0400
Content-Disposition: inline
In-Reply-To: <20090720082224.GB4797@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2009 at 04:22:24PM +0800, Herbert Xu wrote:
> 
> Actually, you can assume that init is always sync since I'll
> ensure that everything supports export/import before hmac is
> converted to ahash (from shash).
> 

Ok, I'll update and resend the patch.

Thanks.
