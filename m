From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/3] crypto: drbg - revamp locking
Date: Mon, 20 Apr 2015 08:23:41 +0800
Message-ID: <20150420002341.GA16750@gondor.apana.org.au>
References: <1702481.h2hMdNkdaF@myon.chronox.de>
 <20150419054931.GC11255@gondor.apana.org.au>
 <2916811.EN7EiDNNhd@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42686 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbDTAXs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 20:23:48 -0400
Content-Disposition: inline
In-Reply-To: <2916811.EN7EiDNNhd@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 19, 2015 at 05:35:23PM +0200, Stephan Mueller wrote:
>
> Thanks -- can you please push your tree? There is one more mutex_init missing: 
> in drbg_healthcheck.

I've got that fixed in my tree already but yes I will push it soon
once my test is complete.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
