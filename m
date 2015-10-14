From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxs-dcp is an stmp device
Date: Wed, 14 Oct 2015 22:28:42 +0800
Message-ID: <20151014142842.GG17455@gondor.apana.org.au>
References: <6543300.PJNp8A08gY@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Marek Vasut <marex@denx.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55679 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbbJNO2x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:28:53 -0400
Content-Disposition: inline
In-Reply-To: <6543300.PJNp8A08gY@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2015 at 03:52:34PM +0200, Arnd Bergmann wrote:
> The mxs-dcp driver relies on the stmp_reset_block() helper function, which
> is provided by CONFIG_STMP_DEVICE. This symbol is always set on MXS,
> but the driver can now also be built for MXC (i.MX6), which results
> in a built error if no other driver selects STMP_DEVICE:
> 
> drivers/built-in.o: In function `mxs_dcp_probe':
> vf610-ocotp.c:(.text+0x3df302): undefined reference to `stmp_reset_block'
> 
> This adds the 'select', like all other stmp drivers have it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: a2712e6c75f ("crypto: mxs-dcp - Allow MXS_DCP to be used on MX6SL")

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
