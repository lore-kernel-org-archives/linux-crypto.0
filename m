From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: dcp: Check the return value from
 devm_ioremap_resource()
Date: Mon, 7 Oct 2013 18:10:01 +1100
Message-ID: <20131007071001.GA7522@gondor.apana.org.au>
References: <1379970724-11983-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39564 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3JGHKF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Oct 2013 03:10:05 -0400
Content-Disposition: inline
In-Reply-To: <1379970724-11983-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 23, 2013 at 06:12:04PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> devm_ioremap_resource() may fail, so better check its return value and propagate
> it in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
