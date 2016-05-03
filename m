From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-des: Integrate with the crypto engine
 framework
Date: Tue, 3 May 2016 16:16:02 +0800
Message-ID: <20160503081602.GA17166@gondor.apana.org.au>
References: <a4d000f46bd5fa99b0ab832d85430e37a1c2d1bd.1461823641.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, broonie@kernel.org, linus.walleij@linaro.org,
	arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Baolin <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50528 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbcECIQR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 04:16:17 -0400
Content-Disposition: inline
In-Reply-To: <a4d000f46bd5fa99b0ab832d85430e37a1c2d1bd.1461823641.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 28, 2016 at 02:11:51PM +0800, Baolin wrote:
> Since the crypto engine framework had been merged, thus this patch integrates
> with the newly added crypto engine framework to make the crypto hardware
> engine under utilized as each block needs to be processed before the crypto
> hardware can start working on the next block.
> 
> The crypto engine framework can manage and process the requests automatically,
> so remove the 'queue' and 'queue_task' things in omap des driver.
> 
> Signed-off-by: Baolin <baolin.wang@linaro.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
