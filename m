From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara: fix building as module
Date: Wed, 5 Jun 2013 16:42:11 +0800
Message-ID: <20130605084211.GB12202@gondor.apana.org.au>
References: <3573891.yE7nyLPekp@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:56274 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753455Ab3FEImV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jun 2013 04:42:21 -0400
Content-Disposition: inline
In-Reply-To: <3573891.yE7nyLPekp@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 03, 2013 at 11:57:37PM +0200, Arnd Bergmann wrote:
> The sahara crypto driver has an incorrect MODULE_DEVICE_TABLE, which
> prevents us from actually building this driver as a loadable module.
> 
> sahara_dt_ids is a of_device_id array, so we have to use
> MODULE_DEVICE_TABLE(of, ...).
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
