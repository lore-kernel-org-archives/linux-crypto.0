From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto:nx - fix nx-aes-gcm verification
Date: Wed, 21 Aug 2013 21:50:35 +1000
Message-ID: <20130821115035.GD23287@gondor.apana.org.au>
References: <520c0215.kHFgBNcJQfAPXpv3%jmlatten@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: jmlatten@linux.vnet.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34069 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486Ab3HULup (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 07:50:45 -0400
Content-Disposition: inline
In-Reply-To: <520c0215.kHFgBNcJQfAPXpv3%jmlatten@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 14, 2013 at 05:17:57PM -0500, jmlatten@linux.vnet.ibm.com wrote:
> This patch fixes a bug in the nx-aes-gcm implementation.
> Corrected the code so that the authtag is always verified after
> decrypting and not just when there is associated data included.
> Also, corrected the code to retrieve the input authtag from src
> instead of dst. 
> 
> Reviewed-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> Signed-off-by: Joy Latten <jmlatten@linux.vnet.ibm.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
