From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/omap aes: select BLKCIPHER2
Date: Fri, 9 Nov 2012 17:35:02 +0800
Message-ID: <20121109093502.GC25720@gondor.apana.org.au>
References: <1351710517-9516-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:52174 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976Ab2KIJfG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2012 04:35:06 -0500
Content-Disposition: inline
In-Reply-To: <1351710517-9516-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 31, 2012 at 08:08:37PM +0100, Sebastian Andrzej Siewior wrote:
> without it:
> |drivers/built-in.o:(.data+0x14588): undefined reference to `crypto_ablkcipher_type'
> |drivers/built-in.o:(.data+0x14668): undefined reference to `crypto_ablkcipher_type'
> 
> Not sure when this broke.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
