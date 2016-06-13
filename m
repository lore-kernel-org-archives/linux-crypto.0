From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ux500: memmove the right size
Date: Mon, 13 Jun 2016 20:29:55 +0800
Message-ID: <20160613122955.GB8583@gondor.apana.org.au>
References: <1465390599-20605-1-git-send-email-linus.walleij@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	David Binderman <linuxdev.baldrick@gmail.com>,
	Joakim Bech <joakim.bech@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48237 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965373AbcFMMaC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 08:30:02 -0400
Content-Disposition: inline
In-Reply-To: <1465390599-20605-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 02:56:39PM +0200, Linus Walleij wrote:
> The hash buffer is really HASH_BLOCK_SIZE bytes, someone
> must have thought that memmove takes n*u32 words by mistake.
> Tests work as good/bad as before after this patch.
> 
> Cc: Joakim Bech <joakim.bech@linaro.org>
> Reported-by: David Binderman <linuxdev.baldrick@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
