From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC] crypto: drbg - lower reseed threshold if seed source
 is degraded
Date: Tue, 9 Jun 2015 23:33:28 +0800
Message-ID: <20150609153328.GA16954@gondor.apana.org.au>
References: <1546948.ChzZZVGUza@tachyon.chronox.de>
 <3482320.MoAVfHitsv@tachyon.chronox.de>
 <20150609152605.GA15444@gondor.apana.org.au>
 <1454819.tTuWU5o0ua@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andreas.steffen@strongswan.org, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43770 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbFIPdg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 11:33:36 -0400
Content-Disposition: inline
In-Reply-To: <1454819.tTuWU5o0ua@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2015 at 05:27:46PM +0200, Stephan Mueller wrote:
>
> I see one: the reset of the threshold to the "normal" value must happen at two 
> places: the one place is in the async handler. The 2nd place is when the 
> request to random.c returns 0 (i.e. fully initialized). The 2nd location is 
> different between both code bases.

Right but after the callback patch there should be only one location
where you reset it to normal, namely in the async handler.  The
other place would only set it to the lower value if the pool is
not ready yet.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
