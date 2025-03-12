Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C561ADC6C
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 20:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810150; cv=none; b=YiTVLNN3IGn1O45gk+CmVmQ+8BnZFOoc6Rvm/iEVtlXpUUx8DWeoOiJDbbYMnP9D2Dl/ipZa59SGbtU0PfOY5BZXTqEAtTeVLJ0hShv0PRIHhYqKBRgX+6NKwolTOtoy5PQYuaiXMptU+FPegkFHuw+vlM2xQk5Rt/0O2dOg+xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810150; c=relaxed/simple;
	bh=hg1jilIwZcyhjqoXvOvM6bO6EsFdwpe6T+/rZdxv0a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqpLbQFSdLKbtCOpZEEVTJkbVUYeMrkkH0qJOz8Ozw41PxvYXN/Z0/Q0+VlqzmnKTYvVnP3zUG9yljjeNgry2d3CwionsatpTv2X7/Ty0yHwYEPjSpYtbiP6bb5fwcMSoQaHLJmAO6pJVL5YdXROkOje9crmi8tovQdJ23RqtFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3zMiOZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3zMiOZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E3AC4CEDD;
	Wed, 12 Mar 2025 20:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810149;
	bh=hg1jilIwZcyhjqoXvOvM6bO6EsFdwpe6T+/rZdxv0a0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B3zMiOZEgE2tjlMeYzIdXbV5G0QaC5ZJhzCiLxzPytg8spBPQPWeOFWB1vsWpeolD
	 mtEkU5vWU+dM18MD7n4a0f+zznV7XQt+36+1574fYIdvZuV8ngE2wXElqCLQVvg8sg
	 q5sSzH7kiGUJ0gyJa96JqZ9kvDSmuGYrA4hSi3ii/J6iVdQJ2djuul58crd8IutaAL
	 Q4WXUr4p41sWMl8R3YoQCs6JgjaA0F/y5wMUz63Pbm30iwTOpFXBvIyVRBBbLBU+E2
	 CWMXLSAJDFL5jvFR0RLktMl+5DnWGngLEeBAFOo2w12+eG+ZlUMtceSKTYDBQiKDn3
	 j/BIfSGWN1Ang==
Date: Wed, 12 Mar 2025 13:09:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/2] crypto: hash - Use nth_page instead of doing it
 by hand
Message-ID: <20250312200908.GB1621@sol.localdomain>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <a68366725ab6130fea3a5e3257e92c8109b7f86a.1741753576.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a68366725ab6130fea3a5e3257e92c8109b7f86a.1741753576.git.herbert@gondor.apana.org.au>

On Wed, Mar 12, 2025 at 12:30:00PM +0800, Herbert Xu wrote:
> Use nth_page instead of adding n to the page pointer.
> 
> This also fixes a real bug in shash_ahash_digest where the the
> check for continguous hash data may be incorrect in the presence
> of highmem.  This could result in an incorrect hash or worse.

Again, you need to explain this properly.

It seems that the "real bug" mentioned above is the case of
scatterlist::offset > PAGE_SIZE.  That's unrelated to the nth_page() fix, which
seems to be for scatterlist elements that span physical memory sections.  Also,
unlike the case of scatterlist elements that span physical memory sections,
scatterlist::offset > PAGE_SIZE can be easily tested.  The self-tests need to be
updated to test that case, if it's indeed now established that it's allowed.

Note that there is also page arithmetic being done in scatterwalk_done_dst() and
scomp_acomp_comp_decomp().  Those presumably need the nth_page() fix too.

scomp_acomp_comp_decomp() also assumes that if the first page in a given
scatterlist element is lowmem, then any additional pages are lowmem too.  That
sounds like another potentially wrong assumption.  Can scatterlist elements span
memory zones?  Or just physical memory sections?

Is there actually going to be a clear specification of the scatterlist based
crypto APIs, or just random broken and incomplete fixes?

> @@ -201,25 +202,36 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
>  	unsigned int nbytes = req->nbytes;
>  	struct scatterlist *sg;
>  	unsigned int offset;
> +	struct page *page;
> +	const u8 *data;
>  	int err;
>  
> -	if (ahash_request_isvirt(req))
> -		return crypto_shash_digest(desc, req->svirt, nbytes,
> -					   req->result);
> +	data = req->svirt;
> +	if (!nbytes || ahash_request_isvirt(req))
> +		return crypto_shash_digest(desc, data, nbytes, req->result);
>  
> -	if (nbytes &&
> -	    (sg = req->src, offset = sg->offset,
> -	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
> -		void *data;
> +	sg = req->src;
> +	if (nbytes > sg->length)
> +		return crypto_shash_init(desc) ?:
> +		       shash_ahash_finup(req, desc);
>  
> -		data = kmap_local_page(sg_page(sg));
> -		err = crypto_shash_digest(desc, data + offset, nbytes,
> -					  req->result);
> -		kunmap_local(data);
> -	} else
> -		err = crypto_shash_init(desc) ?:
> -		      shash_ahash_finup(req, desc);
> +	page = sg_page(sg);
> +	data = lowmem_page_address(page) + offset;
> +	if (!IS_ENABLED(CONFIG_HIGHMEM))
> +		return crypto_shash_digest(desc, data, nbytes, req->result);
>  
> +	offset = sg->offset;
> +	page = nth_page(page, offset >> PAGE_SHIFT);
> +	offset = offset_in_page(offset);
> +
> +	if (nbytes > (unsigned int)PAGE_SIZE - offset)
> +		return crypto_shash_init(desc) ?:
> +		       shash_ahash_finup(req, desc);
> +
> +	data = kmap_local_page(page);
> +	err = crypto_shash_digest(desc, data + offset, nbytes,
> +				  req->result);
> +	kunmap_local(data);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(shash_ahash_digest);

This is clearly untested, so not much point in reviewing it.

- Eric
