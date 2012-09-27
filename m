From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - increase TRNG clocks per sample
Date: Wed, 26 Sep 2012 22:44:39 -0700
Message-ID: <20120927054438.GD22311@gondor.apana.org.au>
References: <20120917182155.ef1d5aab06d07e5db9dcd6cc@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59087 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755000Ab2I0Fok (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:44:40 -0400
Content-Disposition: inline
In-Reply-To: <20120917182155.ef1d5aab06d07e5db9dcd6cc@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 17, 2012 at 06:21:55PM -0500, Kim Phillips wrote:
> we need to configure the TRNG to use more clocks per sample
> to handle the two back-to-back 64KiB random descriptor requests
> on higher frequency P5040s.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
