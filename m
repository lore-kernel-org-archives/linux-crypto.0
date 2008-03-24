From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 2/2] [crypto] make the crypto subsystem fully modular
Date: Mon, 24 Mar 2008 20:35:59 +0800
Message-ID: <20080324123559.GA7097@gondor.apana.org.au>
References: <20080105123637.GA12561@Chamillionaire.breakpoint.cc> <E1JB8IB-0003Pt-Kk@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58453 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757056AbYCXMgD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2008 08:36:03 -0400
Content-Disposition: inline
In-Reply-To: <E1JB8IB-0003Pt-Kk@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 05, 2008 at 01:36:37PM +0100, Sebastian Siewior wrote:
>
> diff --git a/crypto/api.c b/crypto/api.c
> index a2496d1..0a0f41e 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -445,3 +445,6 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(crypto_has_alg);
> +
> +MODULE_DESCRIPTION("Cryptographic core API");
> +MODULE_LICENSE("GPL");

Could you please add an exit handler? That way we can unload the
module which is probably the most important application of this.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
