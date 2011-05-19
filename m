From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: caam - platform_bus_type migration
Date: Thu, 19 May 2011 14:39:03 +1000
Message-ID: <20110519043903.GA23507@gondor.apana.org.au>
References: <20110514220755.a5dad77f.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47792 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1ESEjH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2011 00:39:07 -0400
Content-Disposition: inline
In-Reply-To: <20110514220755.a5dad77f.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 14, 2011 at 10:07:55PM -0500, Kim Phillips wrote:
> this fixes a build error since cryptodev-2.6 got rebased
> to include commit d714d1979d7b4df7e2c127407f4014ce71f73cd0
> "dt: eliminate of_platform_driver shim code".
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

All four patches applied.  Thanks Kim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
