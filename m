From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix build warning when DEBUG_FS not
	configured
Date: Wed, 8 Jun 2011 21:27:56 +0800
Message-ID: <20110608132756.GA9044@gondor.apana.org.au>
References: <20110605164254.b9ede635.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36200 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab1FHN17 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2011 09:27:59 -0400
Content-Disposition: inline
In-Reply-To: <20110605164254.b9ede635.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 05, 2011 at 04:42:54PM -0500, Kim Phillips wrote:
> drivers/crypto/caam/ctrl.c: In function 'caam_probe':
> drivers/crypto/caam/ctrl.c:55:23: warning: unused variable 'perfmon'
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks Kim.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
