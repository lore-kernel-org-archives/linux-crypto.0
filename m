From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Updated Openssl Patch to support Linux CryptoAPI v3
Date: Tue, 2 Dec 2008 14:04:40 +0300
Message-ID: <20081202110440.GA5496@ioremap.net>
References: <DB599F406D04E34389140B7D99C71B1B068407A2@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cet.com.ru ([195.178.208.66]:56696 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYLBLEo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 06:04:44 -0500
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B068407A2@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 01, 2008 at 04:28:49PM -0800, Shasi Pulijala (spulijala@amcc.com) wrote:
> This Openssl patch is the version 3 which incorporates some changes suggested by the Linux Crypto Maintainer. Openssl still needs to be patched with OCF first to use the linux cryptodev interface. The major changes in this patch include:
> 
> 1) Addition of a header file that defines the crypto and hash algorithm/modes as a bitmap.
> 2) The structures session_op and crypt_op need to be included from the linux kernel headers.

There are other problems mentioned prviously which were not included
here: http://marc.info/?l=linux-crypto-vger&m=122727693310351&w=2

>  /* NB: deprecated */
> +#ifndef CRYPTODEV_LINUX
>  struct session_op {
>  	u_int32_t	cipher;		/* ie. CRYPTO_DES_CBC */
>  	u_int32_t	mac;		/* ie. CRYPTO_MD5_HMAC */
> @@ -187,8 +189,9 @@
>  	int		mackeylen;	/* mac key */
>  	caddr_t		mackey;

If this strcuture is shared between kernelspace and userspace things are
very broken: pointer types may have different sizes in kernel and
userspace.

> -  	u_int32_t	ses;		/* returns: session # */ 
> +	u_int32_t	ses;		/* returns: session # */
> };
> +#endif
>  
>  struct session2_op {
>  	u_int32_t	cipher;		/* ie. CRYPTO_DES_CBC */
> @@ -199,11 +202,12 @@
>  	int		mackeylen;	/* mac key */
>  	caddr_t		mackey;

The same.

> -  	u_int32_t	ses;		/* returns: session # */
> +	u_int32_t	ses;		/* returns: session # */
>  	int		crid;		/* driver id + flags (rw) */
>  	int		pad[4];		/* for future expansion */
> };
>  
> +#ifndef CRYPTODEV_LINUX
>  struct crypt_op {
>  	u_int32_t	ses;
>  	u_int16_t	op;		/* i.e. COP_ENCRYPT */
> @@ -217,7 +221,7 @@
>  	caddr_t		mac;		/* must be big enough for chosen MAC */
>  	caddr_t		iv;

The same.

Please provide full patch next time, it is hard to tell if there are
other problem places without looking at the code.

-- 
	Evgeniy Polyakov
