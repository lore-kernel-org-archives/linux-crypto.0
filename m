From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] cryptd: Fix uninitialized return value
Date: Wed, 15 Jul 2009 16:54:02 +0800
Message-ID: <20090715085402.GC20126@gondor.apana.org.au>
References: <20090715085009.GL20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38883 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbZGOIyE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 04:54:04 -0400
Content-Disposition: inline
In-Reply-To: <20090715085009.GL20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 10:50:09AM +0200, Steffen Klassert wrote:
> If cryptd_alloc_instance() fails, the return value is uninitialized.
> This patch fixes this by setting the return value.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Just found two similar bugs in xcbc and hmac.  I'll fix them up.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
