From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] crypto: talitos - ensure request ordering within a
	single tfm
Date: Fri, 15 Jul 2011 11:23:40 +0800
Message-ID: <20110715032339.GA27854@gondor.apana.org.au>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38015 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1GODXn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2011 23:23:43 -0400
Content-Disposition: inline
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 08, 2011 at 10:57:22PM +0000, Kim Phillips wrote:
> Assign single target channel per tfm in talitos_cra_init instead of
> performing channel scheduling dynamically during the encryption request.
> This changes the talitos_submit interface to accept a new channel
> number argument.  Without this, rapid bursts of misc. sized requests
> could make it possible for IPsec packets to be encrypted out-of-order,
> which would result in packet drops due to sequence numbers falling
> outside the anti-reply window on a peer gateway.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

All patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
