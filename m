From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for the Marvell Crypto
 driver
Date: Fri, 9 Oct 2015 16:40:36 +0100
Message-ID: <20151009154036.GY32532@n2100.arm.linux.org.uk>
References: <1444405142-4469-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:50823 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbbJIPkm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 11:40:42 -0400
Content-Disposition: inline
In-Reply-To: <1444405142-4469-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 05:39:02PM +0200, Thomas Petazzoni wrote:
> A new crypto driver for Marvell ARM platforms was added in
> drivers/crypto/marvell/ as part of commit f63601fd616ab ("crypto:
> marvell/cesa - add a new driver for Marvell's CESA"). This commit adds
> the relevant developers to the list of maintainers.
> 
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Cc: Arnaud Ebalard <arno@natisbad.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Russell King <linux@arm.linux.org.uk>

Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>

;)

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
> -- 
> 2.6.1
> 

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
