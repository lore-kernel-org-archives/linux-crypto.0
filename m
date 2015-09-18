From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] hwrng: mxc-rnga - Remove unneeded goto label
Date: Fri, 18 Sep 2015 22:04:46 +0800
Message-ID: <20150918140446.GF9249@gondor.apana.org.au>
References: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60274 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbbIROEt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:04:49 -0400
Content-Disposition: inline
In-Reply-To: <1442099993-29449-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 12, 2015 at 08:19:50PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> We can simplify the code by returning the error code immediately
> instead of jumping to a goto label.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
