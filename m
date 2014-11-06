From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - add support for rfc4543(gcm(aes))
Date: Thu, 6 Nov 2014 23:17:14 +0800
Message-ID: <20141106151714.GE4544@gondor.apana.org.au>
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
 <1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36135 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaKFPRR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 10:17:17 -0500
Content-Disposition: inline
In-Reply-To: <1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 30, 2014 at 06:55:07PM +0200, Tudor Ambarus wrote:
> Add AES-GMAC as an IPSec ESP mechanism to provide
> data origin authentication, but not confidentiality.
> This method is referred as ENCR_NULL_AUTH_AES_GMAC.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
