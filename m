Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAFADDB3;
	Tue,  4 Jun 2024 09:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493866; cv=none; b=uejRoDzbmblkHhWLyEE3GozKqxCXdmu/W+Pb08ekgjCmjhyL0g5wKZrOu3656c6ZrG9gMUdZN77Z4pmhKcM7xW/x4AeMY8yzjc9Ix6mO4/Fr+KqezHVOjXArubFF7kTpV/qKALVvQ2BXrbNr1jlKMWkLoPtPxmz+eV9FkvauUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493866; c=relaxed/simple;
	bh=sb6H4cRJveYvYDAoRRNVgc3VL7ZzIFu0qHA0fsru1pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XK1OekWn/vlr7GYkwKH2lR4isNi/H7tLv9+BOaM5mTi2jNfmB485OptJDxusz8EUqRzHpYgPLSKfqnLnOWDC9vqrkjcvSiHU49d37BNt5kPU4Eq0cmSlVv+XEfSvVQrxYACZpbPLGsCWrw7mTw5fd2Ne1Vo9SvZwAlOcdx7lwis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sEQbm-005SlT-0I;
	Tue, 04 Jun 2024 17:37:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Jun 2024 17:37:36 +0800
Date: Tue, 4 Jun 2024 17:37:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603183731.108986-7-ebiggers@kernel.org>

On Mon, Jun 03, 2024 at 11:37:29AM -0700, Eric Biggers wrote:
>
> +	for (i = 0; i < ctx->num_pending; i++) {
> +		data[i] = ctx->pending_blocks[i].data;
> +		outs[i] = ctx->pending_blocks[i].hash;
> +	}
> +
> +	desc->tfm = params->hash_alg->tfm;
> +	if (params->hashstate)
> +		err = crypto_shash_import(desc, params->hashstate);
> +	else
> +		err = crypto_shash_init(desc);
> +	if (err) {
> +		fsverity_err(inode, "Error %d importing hash state", err);
> +		return false;
> +	}
> +	err = crypto_shash_finup_mb(desc, data, params->block_size, outs,
> +				    ctx->num_pending);
> +	if (err) {
> +		fsverity_err(inode, "Error %d computing block hashes", err);
> +		return false;
> +	}

So with ahash operating in synchronous mode (callback == NULL), this
would look like:

	struct ahash_request *reqs[FS_VERITY_MAX_PENDING_DATA_BLOCKS];

	for (i = 0; i < ctx->num_pending; i++) {
		reqs[i] = fsverity_alloc_hash_request();
		if (!req) {
			free all reqs;
			return false;
		}

		if (params->hashstate)
			err = crypto_ahash_import(&reqs[i], params->hashstate);
		else
			err = crypto_ahash_init(&reqs[i]);

		if (err) {
			fsverity_err(inode, "Error %d importing hash state", err);
			free all reqs;
			return false;
		}
	}

	for (i = 0; i < ctx->num_pending; i++) {
		unsigned more;

		if (params->hashstate)
			err = crypto_ahash_import(req, params->hashstate);
		else
			err = crypto_ahash_init(req);

		if (err) {
			fsverity_err(inode, "Error %d importing hash state", err);
			free all requests;
			return false;
		}

		more = 0;
		if (i + 1 < ctx->num_pending)
			more = CRYPTO_TFM_REQ_MORE;
		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP | more,
					   NULL, NULL);
		ahash_request_set_crypt(req, ctx->pending_blocks[i].sg,
					ctx->pending_blocks[i].hash,
					params->block_size);

		err = crypto_ahash_finup(req);
		if (err) {
			fsverity_err(inode, "Error %d computing block hashes", err);
			free all requests;
			return false;
		}
	}

You're hiding some of the complexity by not allocating memory
explicitly for each hash state.  This might fit on the stack
for two requests, but eventually you will have to allocate memory.

With the ahash API, the allocation is explicit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
