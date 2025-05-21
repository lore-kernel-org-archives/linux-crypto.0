Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950FE262D0B;
	Wed, 21 May 2025 11:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747826920; cv=none; b=WbWpdaVwfnuqk9uL3QzRC0KH11kDtolkys7AGWC+ndI/+6HjacduVRRd42jAEIbamfJJ+Ot+iomVjqSttx175WDNX8IMe1E7omJ8UypxId+APAFx74O7H+Di84T8YiFcgKvc3DG4AEqv/uadIOk7tsWtuoAPD7hQ7c/WTOMmGcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747826920; c=relaxed/simple;
	bh=S9J75qZ9bJZpjs/7dCU9nfqhLhErtrlIyKhvRSHvv74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p2vlVOaifQ5bE8WROPXeRk2QTFCRYF637F6N2efZ/iYuGcDjXsLbIXvMwCoXDVXKb6YVhNAYz8VnyX/6qRyWTqLrKSJNTFQg8leh30KB7M9CPctB5TX1Qm2k18l/KR6ImsWVido3+j2iXEvSbfPMfzbsC1p5woYaxPhTDXe0qjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mvSyopFz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mvSyopFz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xRV7o4nf6uZfEwRx0m1diQcLpzdjD3YqmbdMSDeP5Y8=; b=mvSyopFzFt5x7LgmI5IrRknwWr
	0ttg5XA6mQtvVHBPWlAohxD9VeSA4NJ1qTPHQk4Tqf5razQIgyietmDxM9VuVZOKc2mh/pnDMsni8
	f7COgJkSN37Lqz2Pi+4A6ar27RIeAUZoF2Zw324x7Cp+s0aEOJxiTnt82ZyLXg/gr7b6K3Vijnlpo
	XjGsSgpMO8U4HGnjcSULm550DdIMNRRie2VvA5qDsWJ/AwIzb8XQ8+R+yeGHPRm1UKjr4Z63AbMO9
	Wwm1NVkWXIWmrY2cM0ijpEaBdsmGrPpAAeXDrQNz7TeUZPc4cAO98s8bzJ5YVxUnfhJoPDm6s2o2D
	9k2V4Pqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHhcR-007nYB-0o;
	Wed, 21 May 2025 19:28:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 19:28:19 +0800
Date: Wed, 21 May 2025 19:28:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	bharatb.linux@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4 v3] crypto: octeontx2: Fix address alignment on CN10K
 A0/A1 and OcteonTX2
Message-ID: <aC2406qOlaI17_f3@gondor.apana.org.au>
References: <20250521100447.94421-1-bbhushan2@marvell.com>
 <20250521100447.94421-4-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250521100447.94421-4-bbhushan2@marvell.com>

On Wed, May 21, 2025 at 03:34:46PM +0530, Bharat Bhushan wrote:
>
> @@ -429,22 +431,51 @@ otx2_sg_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
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

This should be updated to show that everything following this
is on an 128-byte boundary.

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
> +	total_mem_len = ALIGN(info_len, ARCH_DMA_MINALIGN) + dlen;
> +	total_mem_len = ALIGN(total_mem_len, OTX2_CPT_DPTR_RPTR_ALIGN);
> +	total_mem_len += (OTX2_CPT_RES_ADDR_ALIGN - 1) &
> +			  ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
> +	total_mem_len += sizeof(union otx2_cpt_res_s);

This calculation is wrong again.  It should be:

	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN);
	total_mem_len += (ARCH_DMA_MINALIGN - 1) &
			 ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
	total_mem_len += ALIGN(dlen, OTX2_CPT_RES_ADDR_ALIGN);
	total_mem_len += sizeof(union otx2_cpt_res_s);

Remember ALIGN may not actually give you extra memory.  So if you
need to add memory for alignment padding, you will need to do it
by hand.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
