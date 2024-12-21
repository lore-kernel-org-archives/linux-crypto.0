Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B541F37BA;
	Sat, 21 Dec 2024 11:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734781489; cv=none; b=VFnOlvWJ3sfmPE95yxMX9tZi4VNXY+mKWPyB/fWoHRiKw02opG3ota3l387LNf5pNLj2Yx2j3yzdW1bUVnpXq082UoKIulauXTTQhDoCUaJRVcF+x3mVFpjz30W7kOQL43cgek2zUMaNnYojmXH6dgfFXirUJjdk5JKxSGcHluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734781489; c=relaxed/simple;
	bh=R7FCkY8zEpmlZAj2CWJmeEAToi5k5RHpTuix11/39P0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HG5kuCLFgSCSwHqTExPSgMj/+dwgoalKafYFM/OjwNl+2vyf3wdkPqzI0BKVqrOVg8wg8H84LiCS+7KwoGa4O708h66qE+gnAjJbIMPIjDwWvG1En0czWFvrGqOzNAQdF272tppUk2tsnXhSWQ9NwtiIgdO41d/FJ9H7DeqUsas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VnF7EWmP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VnF7EWmP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fN6Rx54yRPxE2G3ZsB46AH54lVE8HoSDT2so6fXpjXU=; b=VnF7EWmPljHM2HV4Y88liP28v7
	ny6VH++PizzB1H2eiFSneQeyzBPsAGUhqmyfU+hYenzGLwzneb2Zz/UM/lFtFVsGlVsIT311CnO3e
	SEwYmXUoznFDU93xAaHbkRCCtvdFhti9UEK5kJi5pLlat3H6Qm3mT7gfp9QcySynDM3pE+jIuU10e
	Qs+BkE/MFhLT6Pea106YHpTDVqwEdn2r28PZwSGCqe8TR4mbSvmGwGLhCN7B+KFi7jcsRuHmmEPhu
	Y+URbgMKpO/SXOqIIj+3s+VCk0zOY+q6gt5SEVI7DYnGXSlnnrfirPnW5f7vwC59rfdJhI7dr/AjR
	CruSTuNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tOxhN-002Qdw-10;
	Sat, 21 Dec 2024 19:44:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Dec 2024 19:44:30 +0800
Date: Sat, 21 Dec 2024 19:44:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v9 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z2aqHmrVAm3adVG6@gondor.apana.org.au>
References: <20241214132808.19449-1-ansuelsmth@gmail.com>
 <20241214132808.19449-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214132808.19449-4-ansuelsmth@gmail.com>

On Sat, Dec 14, 2024 at 02:27:54PM +0100, Christian Marangi wrote:
>
> +	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
> +	if (IS_ERR(ahash_tfm))
> +		return PTR_ERR(ahash_tfm);
> +
> +	req = ahash_request_alloc(ahash_tfm, GFP_ATOMIC);
> +	if (!req) {
> +		ret = -ENOMEM;
> +		goto err_ahash;
> +	}
> +
> +	rctx = ahash_request_ctx_dma(req);
> +	crypto_init_wait(&wait);
> +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				   crypto_req_done, &wait);
> +
> +	/* Hash the key if > SHA256_BLOCK_SIZE */
> +	if (keylen > SHA256_BLOCK_SIZE) {
> +		sg_init_one(&sg[0], key, keylen);
> +
> +		ahash_request_set_crypt(req, sg, ipad, keylen);
> +		ret = crypto_wait_req(crypto_ahash_digest(req), &wait);

Sleeping in setkey is no longer allowed.  I don't think it's
fatal yet because the main user driving this currently uses
sync ahashes only.  But we should avoid this in all new driver
code.

Easiest fix would be to allocate a sync ahash:

	ahash_tfm = crypto_alloc_ahash(alg_name, 0, CRYPTO_ALG_SYNC);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
