From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 04/17] crypto: Add userspace configuration API
Date: Mon, 26 Sep 2011 21:21:37 +1000
Message-ID: <20110926112137.GA18070@gondor.apana.org.au>
References: <20110921085855.GE1808@secunet.com> <20110921090238.GI1808@secunet.com> <20110926105646.GZ1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39925 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1IZLVk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 07:21:40 -0400
Content-Disposition: inline
In-Reply-To: <20110926105646.GZ1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 26, 2011 at 12:56:46PM +0200, Steffen Klassert wrote:
>
> I'm just wondering whether CAP_NET_ADMIN is the right capability to
> use here? Do you think we can keep it like that, or would it be better
> to define a new CAP_CRYPTO_ADMIN capability?

I think CAP_NET_ADMIN is fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
