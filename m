From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 27/35] crypto: cryptd - Switch to template create API
Date: Wed, 15 Jul 2009 16:48:19 +0800
Message-ID: <20090715084819.GA20126@gondor.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au> <E1MQyiz-00051d-KJ@gondolin.me.apana.org.au> <20090715084723.GK20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46901 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753184AbZGOIsV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 04:48:21 -0400
Content-Disposition: inline
In-Reply-To: <20090715084723.GK20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 10:47:23AM +0200, Steffen Klassert wrote:
>
> This introduces an uninitialized return value warning. err is not initialized
> if cryptd_alloc_instance() fails.

Good catch!

> Same here.
> I'll send a patch to fix it.

Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
