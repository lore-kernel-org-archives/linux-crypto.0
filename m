From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix gcc 4.6 warning
Date: Fri, 13 Jan 2012 16:39:18 +1100
Message-ID: <20120113053918.GG13918@gondor.apana.org.au>
References: <20120109102740.82e4ac0f8425930b6a34ac1c@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60757 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2AMFjV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jan 2012 00:39:21 -0500
Content-Disposition: inline
In-Reply-To: <20120109102740.82e4ac0f8425930b6a34ac1c@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 09, 2012 at 10:27:40AM -0600, Kim Phillips wrote:
> drivers/crypto/caam/ctrl.c: In function 'caam_probe':
> drivers/crypto/caam/ctrl.c:49:6: warning: unused variable 'd' [-Wunused-variable]
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Both patches applied.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
