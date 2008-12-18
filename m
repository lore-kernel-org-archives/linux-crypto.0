From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC 2/8] crypto: compress - Add pcomp interface
Date: Thu, 18 Dec 2008 17:19:08 +1100
Message-ID: <20081218061908.GB27951@gondor.apana.org.au>
References: <20081217163634.998961917@vixen.sonytel.be> <20081217164036.539681327@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46805 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbYLRGTK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Dec 2008 01:19:10 -0500
Content-Disposition: inline
In-Reply-To: <20081217164036.539681327@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 17, 2008 at 05:36:37PM +0100, Geert Uytterhoeven wrote:
>
> @@ -3,7 +3,7 @@
>  #
>  
>  obj-$(CONFIG_CRYPTO) += crypto.o
> -crypto-objs := api.o cipher.o digest.o compress.o
> +crypto-objs := api.o cipher.o digest.o compress.o pcompress.o

Sorry, you modelled it on the wrong type.  These are the original
and obsolete types.  You should model it on one of the others.  I
recommend the crypto_shash type which is most recent.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
