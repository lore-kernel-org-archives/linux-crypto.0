Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134821A83F1;
	Wed, 11 Dec 2024 09:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733909984; cv=none; b=qolSn0qTkA5XsEY6Gkj2aoNoXGmiklnv6oIpE5wmiBjeBiES9OTwkv+7sEqsuXUfuzcrNjnNk6bPvJS1k4ofwEDm57AxvgDrDm9iJ49vHzNfbvT+mErUWuM/8Chm9fquk0gxW4X1g3dXkkebSweIqigPBKiZiozkN3zRqhj3ayw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733909984; c=relaxed/simple;
	bh=uNyEf575JGyMABK2IicpmY65Fjj1XGV+8co33oXnZm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJLMx2tbo4TbL2/5r1zW26ZVec8pZq3QqLEVac+OeLpJ0K+BeRUIAGGlh61XzWDL0Jy3Hd3H6UyYOttCWHndPgUeL5QfsHhEHAkzMiM79G1hXh6tWqMiqgSv+aNlWxleyy6fCyj/z2qo81AfjvHaVTq/3JE+96ZxnpK+ElnLybA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VOTY1GM3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VOTY1GM3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Qqv1Ckd+GSAVyFgCgoZ2cbk9PY96hUlWhS6ami2Y8/E=; b=VOTY1GM38aeo33J4odoZJApRSZ
	fKl3wu4tZ0GC7SNOVn8yvwgmNzeaT/EZDMSPJZf6kwpIsnN+oS9wsYaWrB0OzGaDEbidp3GkCQct8
	dM14yTNPMWyjmzHjT4EPmfx+DQL2sWLptP1PNgg8pkexEXuob5tmwQWNJu5Dkj/lMnvfarMqywn+S
	hW5IuagzihfU1WvVZG+23jZM9VnpqEcHukwN9PfcoVBXcVzX3/Li/oqBYezzUb2szi1N0GVouNxJi
	ePY9wdvdKJDnhVbueoXzRR+rFPD2J5xhvODQlmhgK15TdLTqdN0GaeklQRnRn2l8hPpV5K+8+W5p3
	uOhBb0tA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tLIys-000iOY-2J;
	Wed, 11 Dec 2024 17:39:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Dec 2024 17:39:27 +0800
Date: Wed, 11 Dec 2024 17:39:27 +0800
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
Subject: Re: [PATCH v8 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z1ldzyPKgoD8GZfx@gondor.apana.org.au>
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
 <20241210204853.18765-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210204853.18765-4-ansuelsmth@gmail.com>

On Tue, Dec 10, 2024 at 09:48:33PM +0100, Christian Marangi wrote:
>
> +static int eip93_hash_export(struct ahash_request *req, void *out)
> +{
> +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> +	struct eip93_hash_export_state *state = out;
> +
> +	/* Save the first block in state data */
> +	if (rctx->len) {
> +		struct mkt_hash_block *block;
> +
> +		block = list_first_entry(&rctx->blocks,
> +					 struct mkt_hash_block,
> +					 list);
> +
> +		memcpy(state->data, block->data,
> +		       SHA256_BLOCK_SIZE - rctx->left_last);
> +	}
> +
> +	eip93_hash_export_sa_state(req, state);
> +
> +	eip93_hash_free_data_blocks(req);
> +	eip93_hash_free_sa_state(req);
> +	eip93_hash_free_sa_record(req);

The export function should be idempotent so it shouldn't be freeing
anything.

In fact this indicates a bigger problem with how DMA is being used
in the driver.  You shouldn't be leaving DMA memory mapped after
the init (or update) function completes.  It is perfectly legal
for a user to call init and then abandon the request by freeing it
directly without ever calling final.  In that case you will be
leaking the DMA mappings.

So make sure that DMA is mapped only when needed, and freed before
you call the user callback.

The import/export functions should only be touching kernel memory,
not DMA.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
