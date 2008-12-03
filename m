From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - Fix modpost warning
Date: Wed, 3 Dec 2008 20:06:40 +0800
Message-ID: <20081203120640.GB9818@gondor.apana.org.au>
References: <1228278556-1056-1-git-send-email-galak@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	kim.phillips@freescale.com
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35652 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753441AbYLCMGs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 07:06:48 -0500
Content-Disposition: inline
In-Reply-To: <1228278556-1056-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2008 at 10:29:16PM -0600, Kumar Gala wrote:
> Removed __devexit from talitos_remove() since its also called from
> talitos_probe().
> 
> WARNING: vmlinux.o(.text+0x28a008): Section mismatch in reference from the function talitos_probe() to the function .devexit.text:talitos_remove()
> The function talitos_probe() references a function in an exit section.
> Often the function talitos_remove() has valid usage outside the exit section
> and the fix is to remove the __devexit annotation of talitos_remove.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

OK, but what about the __devexit_p reference on talitos_remove?
We should remove that too.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
