From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/4] crypto: add CONFIG_ symbol for rsa helper
Date: Tue, 5 Apr 2016 20:32:53 +0800
Message-ID: <20160405123253.GA12846@gondor.apana.org.au>
References: <1458745459-1096-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745459-1096-4-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	smueller@chronox.de, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35129 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbcDEMdC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:33:02 -0400
Content-Disposition: inline
In-Reply-To: <1458745459-1096-4-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 23, 2016 at 05:04:18PM +0200, Tudor Ambarus wrote:
> All RSA implementations can now use the key extract symbols
> by selecting CRYPTO_RSA_HELPER.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Please don't.  Just keep it in the generic rsa module and have
the drivers depend on that instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
