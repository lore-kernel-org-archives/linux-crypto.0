From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: dcp - Use devm_ioremap_resource()
Date: Tue, 24 Sep 2013 06:09:57 +1000
Message-ID: <20130923200957.GG21243@gondor.apana.org.au>
References: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tobias.rauter@gmail.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34665 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753584Ab3IWUJ7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 16:09:59 -0400
Content-Disposition: inline
In-Reply-To: <1379871747-17570-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 22, 2013 at 02:42:25PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Using devm_ioremap_resource() can make the code simpler and smaller.
> 
> When devm_ioremap_resource() is used there is no need to explicitely check the 
> error returned by platform_get_resource().
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
