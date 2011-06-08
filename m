From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: UML build fixes
Date: Wed, 8 Jun 2011 20:57:11 +0800
Message-ID: <20110608125711.GA4582@gondor.apana.org.au>
References: <1306937591-21815-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39832 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1FHM5Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2011 08:57:16 -0400
Content-Disposition: inline
In-Reply-To: <1306937591-21815-1-git-send-email-richard@nod.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 01, 2011 at 04:13:11PM +0200, Richard Weinberger wrote:
> CRYPTO_GHASH_CLMUL_NI_INTEL and CRYPTO_AES_NI_INTEL cannot be used
> on UML.
> Commit 3e02e5cb and 54b6a1b enabled them by accident.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
