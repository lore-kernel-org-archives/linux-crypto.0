From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - standardize device tree naming
	convention to utilize '-vX.Y'
Date: Wed, 23 Mar 2011 21:18:42 +0800
Message-ID: <20110323131842.GA4374@gondor.apana.org.au>
References: <20110314174247.e5515448.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devicetree-discuss@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Kumar Gala <kumar.gala@freescale.com>,
	Steve Cornelius <sec@pobox.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44859 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CWNSt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2011 09:18:49 -0400
Content-Disposition: inline
In-Reply-To: <20110314174247.e5515448.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 14, 2011 at 05:42:47PM -0500, Kim Phillips wrote:
> Help clarify that the number trailing in compatible nomenclature
> is the version number of the device, i.e., change:
> 
> "fsl,p4080-sec4.0", "fsl,sec4.0";
> 
> to:
> 
> "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Cc: Kumar Gala <kumar.gala@freescale.com>
> Cc: Steve Cornelius <sec@pobox.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
