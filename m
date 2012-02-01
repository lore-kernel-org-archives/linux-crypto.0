From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question on __crypto_alg_lookup
Date: Thu, 2 Feb 2012 08:16:43 +1100
Message-ID: <20120201211643.GA16557@gondor.apana.org.au>
References: <alpine.LRH.2.02.1201271415230.23638@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43168 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab2BAVQq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Feb 2012 16:16:46 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1201271415230.23638@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark Allyn <allyn@well.com> wrote:
>
> Is dm-crypt supposed to work with ahash?

Since it uses the shash interface, no.

Someone will need to convert it over to ahash first, like what
we have done for IPsec.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
