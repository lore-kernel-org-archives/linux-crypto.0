From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv1] crypto: caam - set RDB bit in security configuration
 register
Date: Thu, 21 Mar 2013 17:54:47 +0800
Message-ID: <20130321095447.GD26931@gondor.apana.org.au>
References: <1363076721-21315-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60826 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757939Ab3CUJyt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Mar 2013 05:54:49 -0400
Content-Disposition: inline
In-Reply-To: <1363076721-21315-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 12, 2013 at 01:55:21PM +0530, Vakul Garg wrote:
> This change is required for post SEC-5.0 devices which have RNG4.
> Setting RDB in security configuration register allows CAAM to use the
> "Random Data Buffer" to be filled by a single request. The Random Data
> Buffer is large enough for ten packets to get their IVs from a single
> request. If the Random Data Buffer is not enabled, then each IV causes a
> separate request, and RNG4 hardware cannot keep up resulting in lower
> IPSEC throughput if random IVs are used.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
