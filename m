From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active
 hwrng devices
Date: Tue, 9 Aug 2016 17:50:58 +0800
Message-ID: <20160809095058.GA6618@gondor.apana.org.au>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Keith Packard <keithp@keithp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55549 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcHIJvI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:51:08 -0400
Content-Disposition: inline
In-Reply-To: <1469477255-26824-1-git-send-email-keithp@keithp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 25, 2016 at 01:07:35PM -0700, Keith Packard wrote:
> Instead of having only one hwrng feeding /dev/random at a time, maintain
> a list of devices and cycle between them when filling the entropy pool.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

So you're cycling RNGs even for user-space reads? That could be
problematic because not all hardware RNGs carry the maximum amount
of entropy.  It would be rather annoying to be cycling between
RNGs of different qualities.

Perhaps only cycle for the kernel hwrngd?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
