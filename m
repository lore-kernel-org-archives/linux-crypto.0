From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 3/4] crypto: akcipher: add akcipher declarations
 needed by templates.
Date: Fri, 4 Dec 2015 22:28:21 +0800
Message-ID: <20151204142821.GA17533@gondor.apana.org.au>
References: <1448798541-17580-1-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43518 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbLDO2Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:28:24 -0500
Content-Disposition: inline
In-Reply-To: <1448798541-17580-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>
> +static inline struct crypto_akcipher *crypto_spawn_akcipher(
> +               struct crypto_akcipher_spawn *spawn)
> +{
> +       return crypto_spawn_tfm2(&spawn->base);
> +}
> +
> +static inline void crypto_drop_akcipher(struct crypto_akcipher_spawn *spawn)
> +{
> +       crypto_drop_spawn(&spawn->base);
> +}
> +
> +static inline struct akcipher_alg *crypto_spawn_akcipher_alg(
> +               struct crypto_akcipher_spawn *spawn)
> +{
> +       return container_of(spawn->base.alg, struct akcipher_alg, base);
> +}
> +
> +static inline struct crypto_akcipher *crypto_spawn_akcipher(
> +       struct crypto_akcipher_spawn *spawn)
> +{
> +       return crypto_spawn_tfm2(&spawn->base);
> +}

You're defining crypto_spawn_akcipher twice.  This also means that
you didn't even bother compiling it.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
