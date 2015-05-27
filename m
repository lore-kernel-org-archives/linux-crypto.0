From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 0/5] Seeding DRBG with more entropy
Date: Wed, 27 May 2015 17:55:23 +0800
Message-ID: <20150527095523.GB28255@gondor.apana.org.au>
References: <1818200.UPNYCFQzYg@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37023 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbE0Jzj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 05:55:39 -0400
Content-Disposition: inline
In-Reply-To: <1818200.UPNYCFQzYg@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 25, 2015 at 03:08:08PM +0200, Stephan Mueller wrote:
> Hi,
> 
> as of now, the DRBG is only seeded from get_random_bytes. In various
> circumstances, the nonblocking_pool behind get_random_bytes may not be fully
> seeded from hardware events at the time the DRBG requires to be seeded.
> Based on the discussion in [1], the DRBG seeding is updated such that it
> does not completely rely on get_random_bytes any more.

All applied to cryptodev.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
