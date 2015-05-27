From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 PATCH 0/8] crypto: Convert all AEAD users to new interface
Date: Wed, 27 May 2015 17:07:37 +0800
Message-ID: <20150527090737.GA27692@gondor.apana.org.au>
References: <20150521103938.GA23035@gondor.apana.org.au>
 <20150522082708.GA3507@gondor.apana.org.au>
 <20150527080105.GA26751@gondor.apana.org.au>
 <1432714550.2159.4.camel@sipsolutions.net>
 <20150527083911.GA27432@gondor.apana.org.au>
 <1432717240.2159.5.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Stephan Mueller <smueller@chronox.de>
To: Johannes Berg <johannes@sipsolutions.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40420 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbE0JHo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:07:44 -0400
Content-Disposition: inline
In-Reply-To: <1432717240.2159.5.camel@sipsolutions.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 27, 2015 at 11:00:40AM +0200, Johannes Berg wrote:
>
> Right. Unfortunately, I can't typically rely on being able to make
> changes to the kernel our driver is built against, and I don't think we
> could do these changes otherwise.

You could provide your own version of crypto_aead_encrypt and
crypto_aead_decrypt that did the same thing as old_crypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
