From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: drbg - reseed often if seedsource is degraded
Date: Wed, 10 Jun 2015 19:20:16 +0800
Message-ID: <20150610112016.GA6937@gondor.apana.org.au>
References: <1734010.LdNLRSju42@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andreas.steffen@strongswan.org, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41692 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbbFJLUg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 07:20:36 -0400
Content-Disposition: inline
In-Reply-To: <1734010.LdNLRSju42@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 10, 2015 at 03:33:37AM +0200, Stephan Mueller wrote:
> Changes v2: 
> * port the patch to current cryptodev tree plus the async seeding DRBG patches

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
