From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for the Marvell Crypto
 driver
Date: Fri, 9 Oct 2015 17:56:29 +0200
Message-ID: <20151009175629.545e124a@bbrezillon>
References: <1444405142-4469-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <linux@arm.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34179 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565AbbJIP4d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 11:56:33 -0400
In-Reply-To: <1444405142-4469-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri,  9 Oct 2015 17:39:02 +0200
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> A new crypto driver for Marvell ARM platforms was added in
> drivers/crypto/marvell/ as part of commit f63601fd616ab ("crypto:
> marvell/cesa - add a new driver for Marvell's CESA"). This commit adds
> the relevant developers to the list of maintainers.
> 
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Thanks,

Boris

> Cc: Arnaud Ebalard <arno@natisbad.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7ba7ab7..d3f47f5c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6555,6 +6555,13 @@ M:	Guenter Roeck <linux@roeck-us.net>
>  S:	Maintained
>  F:	drivers/net/dsa/mv88e6352.c
>  
> +MARVELL CRYPTO DRIVER
> +M:	Boris Brezillon <boris.brezillon@free-electrons.com>
> +M:	Arnaud Ebalard <arno@natisbad.org>
> +F:	drivers/crypto/marvell/
> +S:	Maintained
> +L:	linux-crypto@vger.kernel.org
> +
>  MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
>  M:	Mirko Lindner <mlindner@marvell.com>
>  M:	Stephen Hemminger <stephen@networkplumber.org>



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
