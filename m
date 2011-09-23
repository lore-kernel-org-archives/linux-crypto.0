From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 04/17] crypto: Add userspace configuration API
Date: Fri, 23 Sep 2011 15:55:54 +1000
Message-ID: <20110923055554.GA15901@gondor.apana.org.au>
References: <20110921085855.GE1808@secunet.com> <20110921090238.GI1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51257 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1IWFz5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Sep 2011 01:55:57 -0400
Content-Disposition: inline
In-Reply-To: <20110921090238.GI1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 21, 2011 at 11:02:38AM +0200, Steffen Klassert wrote:
>
> +/* Netlink message attributes.  */
> +enum crypto_attr_type_t {
> +	CRYPTOCFGA_UNSPEC,
> +	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
> +	__CRYPTOCFGA_MAX
> +
> +#define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
> +};
> +
> +struct crypto_user_alg {
> +	char cru_name[CRYPTO_MAX_ALG_NAME];
> +	char cru_driver_name[CRYPTO_MAX_ALG_NAME];
> +	char cru_module_name[CRYPTO_MAX_ALG_NAME];
> +	__u32 cru_type;
> +	__u32 cru_mask;
> +	__u32 cru_priority;

Do we still need this since you already have the priority as
an attribute?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
