From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC] crypto: drbg - lower reseed threshold if seed source
 is degraded
Date: Tue, 9 Jun 2015 23:26:05 +0800
Message-ID: <20150609152605.GA15444@gondor.apana.org.au>
References: <1546948.ChzZZVGUza@tachyon.chronox.de>
 <20150609142524.GA14316@gondor.apana.org.au>
 <3482320.MoAVfHitsv@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andreas.steffen@strongswan.org, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48511 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbbFIP0O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 11:26:14 -0400
Content-Disposition: inline
In-Reply-To: <3482320.MoAVfHitsv@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2015 at 05:22:32PM +0200, Stephan Mueller wrote:
> Am Dienstag, 9. Juni 2015, 22:25:25 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > 
> > Anyway, I'm happy to apply this.  However, the patch is corrupted
> > so please resend it without the white-space damage/line wrapping.
> 
> As this patch would clash with the async seeding patch, shall I develop this 
> patch on top of your async patch set?

Either way is fine.  I can fix it up when applying as they don't
conceptually conflict.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
