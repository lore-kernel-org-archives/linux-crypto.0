From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: picoxcell - Use devm_ioremap_resource()
Date: Tue, 25 Feb 2014 20:17:22 +0800
Message-ID: <20140225121721.GC12216@gondor.apana.org.au>
References: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Mathias Krause' <mathias.krause@secunet.com>,
	'Jamie Iles' <jamie@jamieiles.com>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:45338 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaBYMRc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 07:17:32 -0500
Content-Disposition: inline
In-Reply-To: <000301cf27a9$fd5c61c0$f8152540$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 12, 2014 at 01:22:06PM +0900, Jingoo Han wrote:
> >From c0c9c31eba90635cac93f3d5e5311beb10afafb7 Mon Sep 17 00:00:00 2001
> From: Jingoo Han <jg1.han@samsung.com>
> Date: Wed, 12 Feb 2014 13:08:54 +0900
> Subject: [PATCH 1/4] crypto: picoxcell - Use devm_ioremap_resource()
> 
> Use devm_ioremap_resource() in order to make the code simpler,
> and remove redundant return value check of platform_get_resource()
> because the value is checked by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

All applied except for 4/4 since we're removing tegra.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
