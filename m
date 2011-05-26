From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix operator precedence in shared
	descriptor allocation
Date: Thu, 26 May 2011 13:30:44 +1000
Message-ID: <20110526033044.GB14500@gondor.apana.org.au>
References: <20110523184523.62654cb1.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38819 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1EZDaq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2011 23:30:46 -0400
Content-Disposition: inline
In-Reply-To: <20110523184523.62654cb1.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 23, 2011 at 06:45:23PM -0500, Kim Phillips wrote:
> setkey allocates 16 bytes (CAAM_CMD_SZ *
> DESC_AEAD_SHARED_TEXT_LEN) shy of what is needed to
> store the shared descriptor, resulting in memory
> corruption.  Fix this.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Applied to cryptodev.  Thanks Kim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
