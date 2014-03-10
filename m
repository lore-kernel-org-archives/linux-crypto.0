From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: omap-aes - Use SIMPLE_DEV_PM_OPS macro
Date: Mon, 10 Mar 2014 20:21:30 +0800
Message-ID: <20140310122129.GD10556@gondor.apana.org.au>
References: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Nishanth Menon' <nm@ti.com>, 'Joel Fernandes' <joelf@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50347 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaCJMVe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:21:34 -0400
Content-Disposition: inline
In-Reply-To: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 27, 2014 at 08:31:38PM +0900, Jingoo Han wrote:
> Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

All three patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
