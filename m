From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH 1/2] crypto: add new driver for Marvell CESA
Date: Fri, 10 Apr 2015 12:38:59 +0200
Message-ID: <1428662339.17822.18.camel@x220>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
	 <1428591523-1780-2-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <info-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428591523-1780-2-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

(This patch needed a trivial context change in drivers/crypto/Makefile
to get it applied on top of next-20150409.)

On Thu, 2015-04-09 at 16:58 +0200, Boris Brezillon wrote:
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -164,8 +164,10 @@ config CRYPTO_DEV_MV_CESA
>  	depends on PLAT_ORION
>  	select CRYPTO_ALGAPI
>  	select CRYPTO_AES
> +	select CRYPTO_DES
>  	select CRYPTO_BLKCIPHER2
>  	select CRYPTO_HASH
> +	select SRAM
>  	help
>  	  This driver allows you to utilize the Cryptographic Engines and
>  	  Security Accelerator (CESA) which can be found on the Marvell Orion

> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile

> -obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
> +obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += marvell/

> --- /dev/null
> +++ b/drivers/crypto/marvell/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += cesa.o cipher.o hash.o tdma.o

For a modular build (which is all I tried) this doesn't do what you
probably want, as this will generate four modules. Assuming you want to
keep the mv_cesa name for the module, you could try something like:
    obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
    mv_cesa-objs := cesa.o cipher.o hash.o tdma.o

Does that do what you want?

> --- /dev/null
> +++ b/drivers/crypto/marvell/cesa.c

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.

This states the license is GPL v2.

> +static struct platform_driver marvell_cesa = {
> +	.probe		= mv_cesa_probe,
> +	.remove		= mv_cesa_remove,
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "mv_crypto",
> +		.of_match_table = mv_cesa_of_match_table,
> +	},
> +};
> +MODULE_ALIAS("platform:mv_crypto");

(It's nicer to make that macro be a part of the block of the other
MODULE_ macros.)

> +module_platform_driver(marvell_cesa);

(And it's nicer to have this directly follow the definition of
marvell_cesa.)

> +MODULE_AUTHOR("Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>");
> +MODULE_AUTHOR("Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>");
> +MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
> +MODULE_LICENSE("GPL");

And this states the license is GPL v2 or later. So either the comment at
the top of this file or this macro need to be changed.


Paul Bolle

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
