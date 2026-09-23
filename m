Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F0A432BD9;
	Wed, 23 Sep 2026 05:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790141422; cv=none; b=k1ZJ9ve26XPZRwnDs9uLvxzT4u7C11KQak3WWPNe8Uyaxuk0i2i8TOAq7X1O3mRkhw1DZKipAU5T0tcxQqxAqQ+Zrs6MIJ2I3ayZpniUD8iJaPoD5F7J2lXxfws1C3NlRCRSlcE8w3cdMtoomWAxFd2Omv17ppiliBapaP/7rnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790141422; c=relaxed/simple;
	bh=Q0O6cyxN8rACgRvQPLvaD8kCnL2Sg/2v9l08oITD918=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pa/oUjFzje3/SkpYZzvGkS+IU4zYMB4Mb/p62Oq6lX+dh2MzfKjLaPDmSF1lUxaOCbG7KVDTerlyQ0YsLvn5nEzXOr1zFtQ5PQyC+cUtTVTlYyyHxVcbvJbY3SQ7bq/8oKWzloRY6IU2U3OfzUJ+ZwjPhYw7TwAiMmdww3m86R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jq+l0GKq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jq+l0GKq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KmvtLIDg6ogO9T0A/2CErZXJwnUpNYMwty3VhwjMj50=; 
	b=jq+l0GKqj1KobyT9Ejke37hl4OwoFbhSySidgCNs5TUCWISbB9vvCnE9j0TQfX3DeSQCi8vx12P
	ct8Hz3YDwBJiBSoqx9K4BgFkQXfNqNaqwRwWKbqiFcHENNXEgL8Zd/sDNoef1RBI+NdR+vjSQGFuE
	ml95uqgr4aeHwoleiVHtqgahv3llDmap+KC9cANHYfLk1ytVQr+1oMk9yRS1vchGra2xvnWORo2Wy
	0nUL12ijI5ZycM9Zzf8E4zhlatEEiWCUFwu10NJZ1VWGTywUT2D/umDibsXOhbSwQ3PjtCOnbjHLn
	b8q2vkqM+nCILOx9tvDTG79Pk/JGe4u1T1Ww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FYb-0000000GuYl-3zSk;
	Wed, 23 Sep 2026 13:30:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:30:13 +1000
Date: Wed, 23 Sep 2026 15:30:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ralf Lici <ralf@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with
 accurate DMA directions
Message-ID: <arNj5SOwXf_TV6eK@gondor.apana.org.au>
References: <cover.1789469436.git.ralf@mandelbit.com>
 <7bd0c89dd32e9712d7d08393842498698148064b.1789469436.git.ralf@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd0c89dd32e9712d7d08393842498698148064b.1789469436.git.ralf@mandelbit.com>

On Tue, Sep 15, 2026 at 01:32:12PM +0200, Ralf Lici wrote:
>
> +static int safexcel_map_aead(struct device *dev, struct scatterlist *sgl,
> +			     int nents, unsigned int output_offset,
> +			     unsigned int output_len, bool inplace)
> +{
> +	struct scatterlist *sg;
> +	unsigned int offset = 0;
> +	int i;
> +
> +	for_each_sg(sgl, sg, nents, i) {
> +		enum dma_data_direction dir;
> +
> +		dir = safexcel_aead_dma_dir(offset, sg->length, output_offset,
> +					    output_len, inplace);
> +		sg_dma_address(sg) = dma_map_page(dev, sg_page(sg), sg->offset,
> +						  sg->length, dir);
> +		if (dma_mapping_error(dev, sg_dma_address(sg)))
> +			goto err_unmap;
> +		sg_dma_len(sg) = sg->length;
> +		offset += sg->length;
> +	}
> +
> +	return nents;
> +
> +err_unmap:
> +	safexcel_unmap_aead(dev, sgl, i, output_offset, output_len, inplace);
> +	return 0;
> +}

Is this assuming that the SG list actually contains one entry for
each type of data? What if the input is completely linear, i.e.,
the AD, cipher and tag are all described by a single SG entry?

In IPsec this is often the case.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
