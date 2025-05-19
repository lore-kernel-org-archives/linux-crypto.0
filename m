Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB8C1E9B29;
	Mon, 19 May 2025 04:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747628827; cv=none; b=FAYuB2uuHkL9zjd9IxYvYXM//sYfDTYzTy+CrSH8arf4o16iV9uPlWVEfwi80uQ2l/JfwqXt7HBVbLwiYgPZFhRSY4B2BJLS6+AGohrT6C9AgjzcfE79LKT+405RTo7ImoCYQI5fQkqM7pHIlVb+/yTRmROFMm+XmwrmFw8OZ8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747628827; c=relaxed/simple;
	bh=D+BxbR1R/7GuzjXXZsA9L4v+Ig3eZDfJMkxSGuO5IxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbBD8+XXOoY/5VVrm1SFHBfh/b1lnwMuptOuwDgVIUQ9kEKiNuaLoc+kcb82EYt975v5bj/D35iTgU4Th31RhEXxI4xOcov4Ixl3ixcwE1yuTTQ3vJj4T8M9fLqCaJTCPfNCBs6IAaMULbFUqWp9Uty952tc9wK1cDw/f1+xgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mcOow3cE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mcOow3cE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RBKhMTgodoS0/tflFpfhE9/Na+KY+SoCg6nBvDiYDmE=; b=mcOow3cEciheDpJiVqxC73jiwC
	O1DNSYs+QyufvwSDGlKD2he91LmIXA+N2hkH4Vc7DpESXcbw5qCQ/81fTgZnQ30GJ8pK5jSPB9l9n
	WIiKv/wJc2qtHPxKH+wdWEdikOG22ee+5L+DypFNSXO2LgCruideo9rPE0Iwr9jjAggOBJxAJE3J5
	vESLZ2KePkFGWedEeeiHzc5MezHUzAbnpMAxZgZTaR/4SpawuSv8KjjPFsQi0T7f7RI0tDZIRuU6Q
	2MAJWd7AtMAftUaJtHcAcznkXGq8YAg0IpvSqNo3cW+w6n5z3mzAeeGjLyG0Q1m2dOiZD8f6mBbUF
	7Slb3VpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGs5J-0077S2-0e;
	Mon, 19 May 2025 12:26:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 12:26:41 +0800
Date: Mon, 19 May 2025 12:26:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, giovanni.cabiddu@intel.com, linux@treblig.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bharatb.linux@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3/4 RESEND] crypto: octeontx2: Fix address alignment on
 CN10K A0/A1 and OcteonTX2
Message-ID: <aCqzAQH06FAoYpYO@gondor.apana.org.au>
References: <20250514051043.3178659-1-bbhushan2@marvell.com>
 <20250514051043.3178659-4-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514051043.3178659-4-bbhushan2@marvell.com>

On Wed, May 14, 2025 at 10:40:42AM +0530, Bharat Bhushan wrote:
>
> @@ -429,22 +431,50 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
>  		return NULL;
>  	}
>  
> -	g_sz_bytes = ((req->in_cnt + 3) / 4) *
> -		      sizeof(struct otx2_cpt_sglist_component);
> -	s_sz_bytes = ((req->out_cnt + 3) / 4) *
> -		      sizeof(struct otx2_cpt_sglist_component);
> +	/* Allocate memory to meet below alignment requirement:
> +	 *  ----------------------------------
> +	 * |    struct otx2_cpt_inst_info     |
> +	 * |    (No alignment required)       |
> +	 * |     -----------------------------|
> +	 * |    | padding for 8B alignment    |
> +	 * |----------------------------------|
> +	 * |    SG List Gather/Input memory   |
> +	 * |    Length = multiple of 32Bytes  |
> +	 * |    Alignment = 8Byte             |
> +	 * |----------------------------------|
> +	 * |    SG List Scatter/Output memory |
> +	 * |    Length = multiple of 32Bytes  |
> +	 * |    Alignment = 8Byte             |
> +	 * |    (padding for below alignment) |
> +	 * |     -----------------------------|
> +	 * |    | padding for 32B alignment   |
> +	 * |----------------------------------|
> +	 * |    Result response memory        |
> +	 *  ----------------------------------
> +	 */
>  
> -	dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
> -	align_dlen = ALIGN(dlen, align);
> -	info_len = ALIGN(sizeof(*info), align);
> -	total_mem_len = align_dlen + info_len + sizeof(union otx2_cpt_res_s);
> +	info_len = sizeof(*info);
> +
> +	g_len = ((req->in_cnt + 3) / 4) *
> +		 sizeof(struct otx2_cpt_sglist_component);
> +	s_len = ((req->out_cnt + 3) / 4) *
> +		 sizeof(struct otx2_cpt_sglist_component);
> +
> +	dlen = g_len + s_len + SG_LIST_HDR_SIZE;
> +
> +	/* Allocate extra memory for SG and response address alignment */
> +	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + dlen;
> +	total_mem_len = ALIGN(total_mem_len, OTX2_CPT_RES_ADDR_ALIGN) +
> +			 sizeof(union otx2_cpt_res_s);

This doesn't look right.  It would be correct if kzalloc returned
a 32-byte aligned pointer to start with.  But it doesn't anymore,
which is why you're making this patch in the first place :)

So you need to add extra memory to bridge the gap between what it
returns and what you expect.  Since it returns 8-byte aligned
memory, and you expect 32-byte aligned pointers, you should add
24 bytes.

IOW the calculation should be:

	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + dlen;
	total_mem_len = ALIGN(total_mem_len, OTX2_CPT_DPTR_RPTR_ALIGN);
	total_mem_len += (OTX2_CPT_RES_ADDR_ALIGN - 1) &
			 ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);

>  	info = kzalloc(total_mem_len, gfp);
>  	if (unlikely(!info))
>  		return NULL;
>  
>  	info->dlen = dlen;
> -	info->in_buffer = (u8 *)info + info_len;
> +	info->in_buffer = PTR_ALIGN((u8 *)info + info_len,
> +				    OTX2_CPT_DPTR_RPTR_ALIGN);
> +	info->out_buffer = info->in_buffer + 8 + g_len;

I presume the 8 here corresponds to SG_LIST_HDR_SIZE from the dlen
calculation above.  If so please spell it out as otherwise it's just
confusing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
