From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] RSA: Don't select non-existent symbol
Date: Sat, 24 May 2014 14:01:46 +0200
Message-ID: <201405241401.46654.marex@denx.de>
References: <20140522182515.626f0728@endymion.delvare>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:58691 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXRvj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 May 2014 13:51:39 -0400
In-Reply-To: <20140522182515.626f0728@endymion.delvare>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, May 22, 2014 at 06:25:15 PM, Jean Delvare wrote:
> You can select MPILIB_EXTRA all you want, it doesn't exist ;-)
> 
> Surprised kconfig doesn't complain about that...
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  crypto/asymmetric_keys/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- linux-3.15-rc6.orig/crypto/asymmetric_keys/Kconfig	2014-03-31
> 05:40:15.000000000 +0200 +++
> linux-3.15-rc6/crypto/asymmetric_keys/Kconfig	2014-05-22
> 18:17:27.988688934 +0200 @@ -22,7 +22,6 @@ config
> ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> 
>  config PUBLIC_KEY_ALGO_RSA
>  	tristate "RSA public-key algorithm"
> -	select MPILIB_EXTRA
>  	select MPILIB
>  	help
>  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).

Nice find.

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
