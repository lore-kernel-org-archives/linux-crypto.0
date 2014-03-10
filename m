From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: sahara: Use return value of
 devm_request_irq() on error
Date: Mon, 10 Mar 2014 20:20:29 +0800
Message-ID: <20140310122029.GA10556@gondor.apana.org.au>
References: <1393073735-16092-1-git-send-email-shc_work@mail.ru>
 <1393073735-16092-2-git-send-email-shc_work@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:54893 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaCJMUh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:20:37 -0400
Content-Disposition: inline
In-Reply-To: <1393073735-16092-2-git-send-email-shc_work@mail.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 22, 2014 at 12:55:35PM +0000, Alexander Shiyan wrote:
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Patch 1/2 dropped since it's already in the tree.  Patch 2/2
applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
