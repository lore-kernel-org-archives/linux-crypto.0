From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Staticize caam_jr_shutdown()
Date: Tue, 16 Feb 2016 20:20:02 +0000
Message-ID: <20160216202002.GC11908@gondor.apana.org.au>
References: <1455462501-18464-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@freescale.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59072 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbcBPUUH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:20:07 -0500
Content-Disposition: inline
In-Reply-To: <1455462501-18464-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 14, 2016 at 01:08:21PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> caam_jr_shutdown() is only used in this file, so it can be
> made static.
> 
> This avoids the following sparse warning:
> 
> drivers/crypto/caam/jr.c:68:5: warning: symbol 'caam_jr_shutdown' was not declared. Should it be static?
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
