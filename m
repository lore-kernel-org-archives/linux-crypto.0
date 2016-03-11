From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ux500: fix checks of error code returned by
 devm_ioremap_resource()
Date: Fri, 11 Mar 2016 21:32:05 +0800
Message-ID: <20160311133205.GE24332@gondor.apana.org.au>
References: <1457227324-3243-1-git-send-email-vz@mleia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org
To: Vladimir Zapolskiy <vz@mleia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51392 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbcCKNcL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 08:32:11 -0500
Content-Disposition: inline
In-Reply-To: <1457227324-3243-1-git-send-email-vz@mleia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 06, 2016 at 03:22:04AM +0200, Vladimir Zapolskiy wrote:
> The change fixes potential oops while accessing iomem on invalid
> address, if devm_ioremap_resource() fails due to some reason.
> 
> The devm_ioremap_resource() function returns ERR_PTR() and never
> returns NULL, which makes useless a following check for NULL.
> 
> Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
> Fixes: 5a4eea2658c93 ("crypto: ux500 - Use devm_xxx() managed function")

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
