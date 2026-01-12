Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD163D6F;
	Mon, 12 Jan 2026 04:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192090; cv=none; b=XPFr9KA3Ipany+M9RK13SEdib89PHs74QSkNAah7YynrNyvqgXmccIL/sUcNrXFqpFXWgvsj4KQTvrIxfUBJl3+tLGVNRGJY80by4Zna75LGKKkWTZ3N2Y5F8tVRz5JL0xNiFjQLRf9usWHUop6TIj6522ag2/WL8eXqvPSymJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192090; c=relaxed/simple;
	bh=NCHtEVA7PylBPydKawoYIqhcpI/yZviRDtr4ifekw5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4f7TWjhO1MhBN1rw0Yl4QDSiqO3H7JCzcxM0Ol5hv2/xfZznVIYKuDVRA48splquuVTqDk0f8yWZWzsbq08ghcbSjDJA07uwrZjrnSzWdLwdKZ7fBAeLrZcW6XGI8u5hziboc5+pcl4cFtvQVBEq5SQ/l/He6bryNgGZtOXNLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SQTQ/Lg8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SQTQ/Lg8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4wekVBs552Ul+A82d1gcgJFDKSPLzWzQWAFP+ZsWD8A=; 
	b=SQTQ/Lg8o+Osh3A08Qi3OxF4FK3KUoi+xDBOoWNUjRRfc/A7AKu2Wbq3Tv1sKLDK2D2cI3Acna3
	Jor6n6PeVcfZK9vakXoMgfJ2LHoVyJKOBqr9e3RSWutkpu0AOIwgufiPPpewqBx1cj7xhioq8McvO
	HQ9xWPjdG19F04sPZtn7YM0SLbbgVnzen+oxE0hSfTkZZQ72+5GPz/Oxfcrf+qij6W9MmWHAs9Pxf
	cIfINzSmpLOjsTuu2eCA3y0lgW7z8K0AqC9hGkkm73rb9BNQKx9FLpwCTnvFiNvPMjfp5aDT6qdZu
	xaGeJpqgsHXfhNZwHAVuQ18N8rR7bflmPPjg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vf9Wx-00FxMN-15;
	Mon, 12 Jan 2026 12:27:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Jan 2026 12:27:51 +0800
Date: Mon, 12 Jan 2026 12:27:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aWR4R8easn23zuHO@gondor.apana.org.au>
References: <20251126112207.4033971-1-t-pratham@ti.com>
 <20251126112207.4033971-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126112207.4033971-2-t-pratham@ti.com>

On Wed, Nov 26, 2025 at 04:46:15PM +0530, T Pratham wrote:
>
> @@ -295,6 +356,32 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
>  	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
>  	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
>  
> +	if (ctx->aes_mode == DTHE_AES_CTR) {
> +		/*
> +		 * CTR mode can operate on any input length, but the hardware
> +		 * requires input length to be a multiple of the block size.
> +		 * We need to handle the padding in the driver.
> +		 */
> +		if (req->cryptlen % AES_BLOCK_SIZE) {
> +			/* Need to create a new SG list with padding */
> +			pad_len = ALIGN(req->cryptlen, AES_BLOCK_SIZE) - req->cryptlen;
> +			memset(pad_buf, 0, pad_len);
> +
> +			src = dthe_chain_pad_sg(req->src, src_nents, src_pad, pad_buf, pad_len);
> +			src_nents++;

This is too complicated and may break if the user supplies an SG list
that's much longer than what is being encrypted.  For example, the
user could have an SG list spanning many pages, and only the first
of half of which are to be encrypted.  If you break it up here you
will risk corrupting the bigger SG list.

I think it's much simpler to just stop at the last block boundary,
and then do the last partial block manually with lib/crypto aes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
