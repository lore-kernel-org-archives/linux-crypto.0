Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718322D0C63;
	Fri,  6 Feb 2026 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770370753; cv=none; b=WljW9yjtECX5QuS99FI67AY1aSXLcg6yUFqGnU7OWqNZuI9dr8ZeC4S1TQmVaM0tZzyBuJQ5aD4ESacBTUHza804WKQRCIYzVsbDBR0L62ywIz3C9NU4JiQ3w5ojoHk8B3z6b6S74e6gckX95u0CAYq118y6JgfiwmIUA/V1YJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770370753; c=relaxed/simple;
	bh=0KZ6Rc67mshf/8RIcAojjUEyfHIp6PTSvrY4xifGwKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLTGBu9Q8d9X/PB3WiSTfSJlKeVegRs58k33kx0JxIuFCNw7c3ENhgHhjXODV8yUyZ6B3tUDUX+pOC/1MSs7TDZ6QVjG01hA8wge3UtZBmcB4sVIwFb/mJVz3qacpZMF/BukNSgAQWLOz/i1FEEbKpP79t1Zt2q25kWCjRTMGjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nog5pwgg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nog5pwgg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gs9mZiOaseQgaZ/0S1QUwDW3mhpZfUYWbeh60dWS5ww=; 
	b=nog5pwggdvKS52Em/got38xwqoN/m9dtAkynypMb+xS66Qv/mWxYy12kxCyczwuSHtX8aySsAk6
	+n1we1MTO8ubClfUXpwgs8N9bMHXCAxP62sGBx9E/C+JodpCChk9zCTxjI0tpF49DA1u49HQJZmdx
	yFxXS9o4Kt7+42z/8Cl81zH0V029BCcSsgDhpqEtM+U6x2Gns1fwzWxXPtFSpQof/oyHZPaF9kcn/
	oacH6+CBO22u5IBchY7XYW7/xcRiYbZXKcEXr3DoJI99wXhRK6W0lFBypyQH2oDEVcxMKE2vS8Pdp
	YJ8da5xBckwCdCnMKMgF5o6JL6ykMR/Ax5yQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voHbA-004xZ0-2V;
	Fri, 06 Feb 2026 16:53:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 16:53:56 +0800
Date: Fri, 6 Feb 2026 16:53:56 +0800
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
Subject: Re: [PATCH v8 1/3] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aYWsJAmf05EdotTX@gondor.apana.org.au>
References: <20260120144408.606911-1-t-pratham@ti.com>
 <20260120144408.606911-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120144408.606911-2-t-pratham@ti.com>

On Tue, Jan 20, 2026 at 08:14:06PM +0530, T Pratham wrote:
>
> +	/*
> +	 * CTR mode can operate on any input length, but the hardware
> +	 * requires input length to be a multiple of the block size.
> +	 * We need to handle the padding in the driver.
> +	 */
> +	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
> +		struct scatterlist *sg;
> +		int i = 0;
> +		unsigned int curr_len = 0;
> +
> +		len -= req->cryptlen % AES_BLOCK_SIZE;
> +		src_nents = sg_nents_for_len(req->src, len);
> +		dst_nents = sg_nents_for_len(req->dst, len);
> +
> +		/*
> +		 * Need to truncate the src and dst to len, else DMA complains.
> +		 * Lengths restored at end
> +		 */
> +		for_each_sg(req->src, sg, src_nents - 1, i) {
> +			curr_len += sg->length;
> +		}
> +		curr_len += sg->length;
> +		src_bkup_len = sg->length;
> +		sg->length -= curr_len % AES_BLOCK_SIZE;

Please don't modify the SG lists since they may be used elsewhere.
There is no harm in mapping a bit more data than what you will
end up using.

Just truncate the length written to the hardware instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
