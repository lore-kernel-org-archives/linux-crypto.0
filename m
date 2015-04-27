From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/6] random: Addition of kernel_pool
Date: Mon, 27 Apr 2015 14:56:09 +0800
Message-ID: <20150427065609.GA21100@gondor.apana.org.au>
References: <1631051.qmxH657I75@myon.chronox.de>
 <3407082.JU6Cks92ze@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paul Bolle <pebolle@tiscali.nl>, andreas.steffen@strongswan.org,
	tytso@mit.edu, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53569 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbD0G42 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 02:56:28 -0400
Content-Disposition: inline
In-Reply-To: <3407082.JU6Cks92ze@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 25, 2015 at 05:40:41PM +0200, Stephan Mueller wrote:
>
> +				if (p->entropy_count <=
> +					p->poolinfo->poolfracbits / 4) {

There appears to be a "3 *" missing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
