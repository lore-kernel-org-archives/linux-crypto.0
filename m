From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add support for the Freescale SEC4/CAAM
Date: Sun, 13 Mar 2011 16:55:04 +0800
Message-ID: <20110313085504.GA12392@gondor.apana.org.au>
References: <20110308193421.67e2aea6.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	devicetree-discuss@lists.ozlabs.org,
	Steve Cornelius <sec@pobox.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47786 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1CMIzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Mar 2011 04:55:12 -0400
Content-Disposition: inline
In-Reply-To: <20110308193421.67e2aea6.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 08, 2011 at 07:34:21PM -0600, Kim Phillips wrote:
> The SEC4 supercedes the SEC2.x/3.x as Freescale's
> Integrated Security Engine.  Its programming model is
> incompatible with all prior versions of the SEC (talitos).
> 
> The SEC4 is also known as the Cryptographic Accelerator
> and Assurance Module (CAAM); this driver is named caam.
> 
> This initial submission does not include support for Data Path
> mode operation - AEAD descriptors are submitted via the job
> ring interface, while the Queue Interface (QI) is enabled
> for use by others.  Only AEAD algorithms are implemented
> at this time, for use with IPsec.
> 
> Many thanks to the Freescale STC team for their contributions
> to this driver.
> 
> Signed-off-by: Steve Cornelius <sec@pobox.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
