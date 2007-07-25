From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 12/12] drivers: PMC MSP71xx security engine driver
Date: Wed, 25 Jul 2007 15:45:18 +0800
Message-ID: <20070725074518.GA21278@gondor.apana.org.au>
References: <200706281949.l5SJnDdH029612@pasqua.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, brian_oostenbrink@pmc-sierra.com,
	linux-crypto@vger.kernel.org, rod_sillett@pmc-sierra.com
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4464 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbXGYHp0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jul 2007 03:45:26 -0400
Content-Disposition: inline
In-Reply-To: <200706281949.l5SJnDdH029612@pasqua.pmc-sierra.bc.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 28, 2007 at 01:49:13PM -0600, Marc St-Jean wrote:
> [PATCH 12/12] drivers: PMC MSP71xx security engine driver
> 
> Patch to add an security engien driver for the PMC-Sierra MSP71xx devices.

Sorry for the late response.  Your email hit me while I was
travelling so it got stuck in the backlog.

> +config CRYPTO_MD5_HW
> +	tristate
> +	default n
> +
> +config CRYPTO_MD5_SW
> +	tristate
> +	default y if (CRYPTO_MD5_HW = n && CRYPTO_MD5 = y)
> +	default m if ((CRYPTO_MD5_HW = m || CRYPTO_MD5_HW = n) && \
> +			CRYPTO_MD5 = m)
> +

We shouldn't need this.  Please follow the scheme that other
hardware-based sync crypto algorithms use.  You can look at
padlock or s390 as good examples.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
