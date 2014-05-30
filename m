From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Date: Fri, 30 May 2014 17:05:48 +0800
Message-ID: <20140530090548.GA12603@gondor.apana.org.au>
References: <20140523211459.GA21019@gondor.apana.org.au>
 <1449817.RiX7azh5Ri@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37376 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaE3JF7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 05:05:59 -0400
Content-Disposition: inline
In-Reply-To: <1449817.RiX7azh5Ri@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 26, 2014 at 07:42:57AM +0200, Stephan Mueller wrote:
>
> A second aspect is the implementation of the stdrng. Currently, the offered 
> patch does not include the stdrng selection. I am currently working on the 
> completion of the addition of the stdrng selection to the offered patch. My 
> idea is the following: currently, all DRBG types are registered with their own 
> cra_name. However, there shall be one particular DRBG registered twice. When 
> registering the instance again, the cra_name shall be "stdrng". In addition, 
> if the kernel command line contains fips=1, the cra_priority of that stdrng 
> should be set to 300. That implies that when the kernel resolves the stdrng, 
> it resolves to get_random_bytes in normal mode, but to the stdrng DRBG in FIPS 
> mode.

Just have all of them register as stdrng with differing priorities.
We already have a user-space interface to change priorities.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
