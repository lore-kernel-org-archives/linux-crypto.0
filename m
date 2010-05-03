From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: cleanup: remove unneeded null check
Date: Mon, 3 May 2010 11:08:44 +0800
Message-ID: <20100503030844.GA31335@gondor.apana.org.au>
References: <20100428085515.GE29093@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Brad Bosch <bradbosch@comcast.net>,
	Richard Hartmann <richih.mailinglist@gmail.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:47025 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754521Ab0ECDIz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 May 2010 23:08:55 -0400
Content-Disposition: inline
In-Reply-To: <20100428085515.GE29093@bicker>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 28, 2010 at 10:55:15AM +0200, Dan Carpenter wrote:
> We don't check "frontend" consistently in crypto_init_spawn2().  We
> check it at the start of the function but then we dereference it 
> unconditionally in the parameter list when we call crypto_init_spawn().
> 
> I looked at the places that call crypto_init_spawn2() and "frontend" is
> always a valid pointer so I removed the check for null.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
