From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: CTR mode: Kconfig cyclic dependency
Date: Sun, 12 Jun 2016 18:58:28 +0800
Message-ID: <20160612105828.GB807@gondor.apana.org.au>
References: <1465466750.NsZ2X8r4WP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44764 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbcFLK6e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Jun 2016 06:58:34 -0400
Content-Disposition: inline
In-Reply-To: <1465466750.NsZ2X8r4WP@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 09, 2016 at 11:07:06AM +0200, Stephan Mueller wrote:
> 
> during the finalization of my patch set for converting the CTR DRBG over to 
> CTR AES, I ran into a Kconfig problem. Maybe you have an idea how to resolve 
> it.

Once I finish the skcipher conversion CTR will no longer need SEQIV.
If it's stopping your work right now I think you can just kill the
SEQIV selection by CTR right now since the only user IPsec doesn't
select CTR anyway.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
