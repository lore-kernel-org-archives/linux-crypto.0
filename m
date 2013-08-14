From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: sahara - Staticize local symbol
Date: Wed, 14 Aug 2013 20:49:12 +1000
Message-ID: <20130814104912.GA13403@gondor.apana.org.au>
References: <000801ce94d6$24377710$6ca66530$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	'Javier Martin' <javier.martin@vista-silicon.com>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39450 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932467Ab3HNKtW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 06:49:22 -0400
Content-Disposition: inline
In-Reply-To: <000801ce94d6$24377710$6ca66530$@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:57:48PM +0900, Jingoo Han wrote:
> This local symbol is used only in this file.
> Fix the following sparse warnings:
> 
> drivers/crypto/sahara.c:420:6: warning: symbol 'sahara_watchdog' was not declared. Should it be static?
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
