From: David Miller <davem@davemloft.net>
Subject: Re: [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
Date: Mon, 07 Jan 2008 22:14:25 -0800 (PST)
Message-ID: <20080107.221425.140140329.davem@davemloft.net>
References: <20080108060911.GA4305@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54375
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbYAHGOZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:14:25 -0500
In-Reply-To: <20080108060911.GA4305@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 8 Jan 2008 17:09:11 +1100

> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 0aba104..6a20fc9 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -90,6 +90,8 @@
>  #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
>  #elif defined(ARCH_SLAB_MINALIGN)
>  #define CRYPTO_MINALIGN ARCH_SLAB_MINALIGN
> +#else
> +#define CRYPTO_MINALIGN __alignof__(unsigned long long)
>  #endif
>  
>  #ifdef CRYPTO_MINALIGN

Not to nit-pick but the CRYPTO_MINALIGN ifdef there at the
end is superfluous.  It will always be defined.
