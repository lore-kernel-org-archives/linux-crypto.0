From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 12/35] crypto: padlock - Switch sha to shash
Date: Wed, 15 Jul 2009 18:30:25 +0800
Message-ID: <20090715103025.GA21263@gondor.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au> <E1MQyij-0004zN-Ec@gondolin.me.apana.org.au> <20090715102818.GM20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41967 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752973AbZGOKa1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 06:30:27 -0400
Content-Disposition: inline
In-Reply-To: <20090715102818.GM20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 12:28:18PM +0200, Steffen Klassert wrote:
>
> Just FYI, I'm getting the following compiler error:

Is this 32-bit or 64-bit?

Cheers,
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
