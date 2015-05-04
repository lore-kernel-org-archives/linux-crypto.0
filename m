From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/6] Seeding DRBG with more entropy
Date: Mon, 4 May 2015 14:13:51 +0800
Message-ID: <20150504061350.GA25540@gondor.apana.org.au>
References: <1626703.0h1HzJAx4d@tachyon.chronox.de>
 <20150503205834.GJ10014@thunk.org>
 <9802019.GiEn27gNxE@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Paul Bolle <pebolle@tiscali.it>,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39860 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbEDGOL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 02:14:11 -0400
Content-Disposition: inline
In-Reply-To: <9802019.GiEn27gNxE@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2015 at 07:40:12AM +0200, Stephan Mueller wrote:
> 
> I am not sure that this approach is helpful, because the suggested approach 
> implies using a seeded DRNG and the used get_random_bytes already operates as 
> a (not always seeded) DRNG. If we have a blocking interface in the kernel, I 
> would recommend to make it identical to /dev/random. With the suggested 
> seeding approach for DRBG, we definitely have seed data available to start 
> with. Therefore, re-seeding it from another seeded DRNG (i.e. the nonblocking 
> pool after it is initialized) may not give us too much extra.

My main concern with your original approach was precisely the
fact that get_random_bytes may be called before the before the
kernel pool is ready.  So Ted's solution solves that perfectly.

Please do what Ted says and we can all move forward.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
