Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097F3CE0A1;
	Fri,  5 Jun 2026 10:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780654272; cv=none; b=tS4U994OJHlpT1rW6foE3UdO56pSG5ruqsVJNzYtU/S+BeMjoaBoShX9AFKZ8p/bSKmwh6cwvvbhDJdEs67PKBJfLwzITzRvOcnPyie5ScUKZYYMmspUsVq1/9eOOZDQyHf4xuWKnBN5Xd+QvcVIl2a6W+I9GfdHuvKIHu18EE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780654272; c=relaxed/simple;
	bh=b6zNUWze2By8Ji6SI23f3Jg+AWrwk+3SXDdAeCjJbqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqeSyNmQIN3qAgiJ1lVDIcxAfo2YlFR4r9DrHPq8IoyR5kT1juEziIllR1EeN5e5IEawMy9Ip5c3mu5EQVBHy/JxFewBL6ogCv/yCKjbuIG4dh45DOt/TwCfudBLxGDUPxUFSsU/YQHOPwm/Vn/HiJkSO+DTyF27D2MhqCfOlNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EwkH0tLt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EwkH0tLt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ho6/VpHLZPrv7UM1Q3Sy6kSj15lzuvXL4menozc6Ty4=; 
	b=EwkH0tLtPs1ym9jwuitw0wO6YEp49kRwaHczVa+iD62HQa/7WLop3SdKFSLiZKHmFi9FLMsMJNx
	kBKXYgjjbsK2izz11XwdbMehswVGCeYHonEmMdwGvoxyGOVTF7GtGq3+Yt7ZLqy/9S9LjYvYBaJ06
	M39ayI3/nNuF80iQni3WUolTZMqFkfnoJQC4Zo27aracheagdnG0KbNEEDub6f4Dr2mQnKGtx0PXK
	pVKqgvE1+mmwrHZ5E7AhQ6f90BmtxOipmxSGpHJaNfPUh0WxXzcdePhf9MmpnMgK9MNw2gdhVpOel
	uehtX6JJrH9hKXvPWeuVl7fztSryXr8uFiLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVRVz-002nFj-2T;
	Fri, 05 Jun 2026 18:11:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 18:10:59 +0800
Date: Fri, 5 Jun 2026 18:10:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/3] crypto: ti - Add support for SHA224/256/384/512
 in DTHEv2 driver
Message-ID: <aiKgs8ipDLPlz6c4@gondor.apana.org.au>
References: <20260526094355.555712-1-t-pratham@ti.com>
 <20260526094355.555712-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526094355.555712-2-t-pratham@ti.com>

On Tue, May 26, 2026 at 03:13:51PM +0530, T Pratham wrote:
>
> +static int dthe_hash_final(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
> +	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
> +	struct crypto_engine *engine = dev_data->hash_engine;
> +
> +	/**
> +	 * We are always buffering data in update, except when nbytes = 0.
> +	 * So, either we get the buffered data here (nbytes > 0) or
> +	 * it is the case that we got zero message to begin with
> +	 */
> +	if (req->nbytes > 0) {
> +		rctx->flags = DTHE_HASH_OP_FINUP;
> +
> +		return crypto_transfer_hash_request_to_engine(engine, req);
> +	}
> +
> +	dthe_hash_write_zero_message(ctx->hash_mode, req->result);

This doesn't look right.  If I do an update of 64 bytes, and then
call final with req->nbytes == 0, this will give me a zero-length
hash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
