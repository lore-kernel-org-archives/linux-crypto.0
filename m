Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0812147FB;
	Thu, 17 Apr 2025 07:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744874518; cv=none; b=hTIVuWu9S5QApr4nb9IyuBzWPX/6rlD+1OGDkU2gxBP3JHG/2QrtmGETJ6ob9E+0UfYchmxXEZHsSsVi/3tvV1ceWawAAT062c/uYTuzBB3e10fsC0tkE8lfCZW11ACP5WuAfKFMxZc88gxge2xsU3dk8AKLRqMFa/CbMSOVTm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744874518; c=relaxed/simple;
	bh=D6FUsCg0Gpw8z0w/zqu3Oewsd1avSCrPubcu3vTtGiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6r+aNPvQdfg0b1G1OPka9ZdDmHgXZJOCFAhFOuHbNuorvZZxSbC155ooV8SOtntcIclspNRsFzAkqaADgsHesZQP3dH7Enq9q3fFESH8c8PuA1em4AKwBKHGf/QTvUx/yF3i03P30fkh5/SDwRMhPUPyCf6hS96qJY5uiyTPxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=m2xZjzmn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="m2xZjzmn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9kw9FMXD/wPGWa+Txh7gPuISKMppmLAsTHqS5svg0z0=; b=m2xZjzmnbaV1GAQlzHYGXRlrUL
	fdZofOEhaKFYsBYK18yKTMJ7q+s63Jm2OLSXzwAFwFxMuHCkBBa5GlFl7OI3Ru2Ybj9o19CxLrS2B
	7m5EQ2MbXd1ZtKBI6l7w1VdX6MY/RKnZxu/CgnA0/XkP9xO5ov8kTIZEdIHJKhYVECy+bPd0UmE7h
	/fSgTR/5nJdbdiWzrn48HfJ+1nqj9YyUOq1PAWQsC+mmRzZicngojjAaIu24RtFza+IZ73cNQyVcQ
	elbTrGBfe2aY0GdLyTHSrVBiniwvb4U/axuz/sEKkAREUY4ffQ3BRIGbhwwUu2/xbNPdkS47Jd7pH
	t5TeE0DA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5JZ3-00GPE6-0G;
	Thu, 17 Apr 2025 15:21:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 17 Apr 2025 15:21:37 +0800
Date: Thu, 17 Apr 2025 15:21:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Qingfang Deng <dqfext@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko.stuebner@vrull.eu>,
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
Message-ID: <aACsAT0sOzkqFblQ@gondor.apana.org.au>
References: <20250417064940.68469-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417064940.68469-1-dqfext@gmail.com>

On Thu, Apr 17, 2025 at 02:49:38PM +0800, Qingfang Deng wrote:
>
> +static int riscv64_clmul_ghash_update(struct shash_desc *desc, const u8 *src, unsigned int srclen)
> +{
> +	struct riscv64_clmul_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	struct riscv64_clmul_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
> +	unsigned int len;
> +
> +	if (dctx->bytes) {
> +		if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
> +			memcpy(dctx->buffer + dctx->bytes, src, srclen);
> +			dctx->bytes += srclen;
> +			return 0;
> +		}
> +		memcpy(dctx->buffer + dctx->bytes, src, GHASH_DIGEST_SIZE - dctx->bytes);
> +
> +		gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, dctx->buffer, GHASH_DIGEST_SIZE);
> +
> +		src += GHASH_DIGEST_SIZE - dctx->bytes;
> +		srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
> +		dctx->bytes = 0;
> +	}

If this progresses beyond an RFC, you will need to do convert this
into a block-only algorithm on top of:

https://patchwork.kernel.org/project/linux-crypto/patch/b2eb753b083c029785c5e18238ca6cf06f48c86a.1744784515.git.herbert@gondor.apana.org.au/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
