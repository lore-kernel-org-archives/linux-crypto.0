From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: authenc - convert to ahash
Date: Mon, 20 Jul 2009 09:49:56 +0200
Message-ID: <20090720074956.GB20288@secunet.com>
References: <20090717074709.GZ20288@secunet.com> <20090720065244.GA4026@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:49674 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZGTHrO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2009 03:47:14 -0400
Content-Disposition: inline
In-Reply-To: <20090720065244.GA4026@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2009 at 02:52:44PM +0800, Herbert Xu wrote:
> 
> This is not quite right.  What I had in mind was to use the digest
> interface if the assoc SG list has a single entry in it.  Otherwise
> it should just fall back to doing update followed by finup.
> 

Ok. I was not even aware that the assoc sg list can have more than one
entry, because esp sets up assoc as a single entry list and this is
actually the only user of authenc as far as I know.

Aside the optimization, another reason to use the digest interface was to
avoid callback functions for init, update and finup. I guess we can not
avoid this if assoc can be a sg list with more than one entry, so I'll
update the patch in this manner.
