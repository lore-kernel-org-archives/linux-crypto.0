Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F354A2E88BD;
	Fri, 21 Nov 2025 03:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763694685; cv=none; b=aEg4gHeq6ZjMuKuakkCzGNsTbv1K3D+huizYdgmh2wMF/V1HCCfuol4Y6jeABLoQc/gJXdlv8NctpMOLCRQ3pETbV/Ero88oPrWS23ybuodnHDbTu2+QZQ0k8WVrHvGsEjYGoggDy2Ga3vePS6MR5CNh1hiS7V3DnoLbxIgtcYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763694685; c=relaxed/simple;
	bh=MKyh0DSs+PdpyZTeHzw6phnLfP7FjPXzkTMdrXHF2Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uad0Nh0VjqazOJbmbzPvK9GnBrHBMJqHJm5KzhyxwocIQ8kZGAUqx3DnTcZNWnoE3RymcaHsD0UjSYxleftjFMYOYpo2xCsLWo6K32/3brDPFXfAZHH9zxUOfiB+7ksagJno+iORm9TUw/XKeOSuLoYviZYqlfPi1qNlaqH3Pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ldIBQRkV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ldIBQRkV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KALNcJApPn3SnQzr7hhkWYDp+pfZlkgBJrIioQ8BpAU=; 
	b=ldIBQRkVJ3LQ7swsqovH5MQC/PC5fS9MVbDJCt3bOxROWv+HoLRbyVVTXKnyM2EpSlFK1mX9GAD
	44TFb5itGKQZK3mBXvVjN+M+xO4fvVfTTMVDRtnlMlfi/KFBoZIJqQIb4F9mnVpzE/wz1aDumb7d2
	mUuAIgCq3jSvEhRytPqbg5uwgKSvmLqmQNwZpKIIjizJkJ+QVywQOwlVm8Y03aAwS7nGM+mfAzM8H
	Zd3Bxe51X27GLcyqO+5CH7/7V/X+QAemFPBro8E+qodg4GgXrvokYWV6zkE+kUMAWao10w9RgBW5c
	kUMoApgeFiDgelj74qXKxLu1YXX6yhaNquNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMHY7-004qaw-0J;
	Fri, 21 Nov 2025 11:11:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Nov 2025 11:11:03 +0800
Date: Fri, 21 Nov 2025 11:11:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/4] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aR_YR_nF4sjUlgN6@gondor.apana.org.au>
References: <20251111112137.976121-1-t-pratham@ti.com>
 <20251111112137.976121-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111112137.976121-3-t-pratham@ti.com>

On Tue, Nov 11, 2025 at 04:38:31PM +0530, T Pratham wrote:
>
> @@ -270,12 +326,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
>  	struct scatterlist *src = req->src;
>  	struct scatterlist *dst = req->dst;
>  
> +	struct scatterlist src_pad[2], dst_pad[2];
> +
>  	int src_nents = sg_nents_for_len(src, len);
> -	int dst_nents;
> +	int dst_nents = sg_nents_for_len(dst, len);
>  
>  	int src_mapped_nents;
>  	int dst_mapped_nents;
>  
> +	u8 pad_buf[AES_BLOCK_SIZE] = {0};

You can't put stack memory into an SG list since the ability to
DMA to the stack is not guaranteed.

I suggest that you place the buffer into the request object instead.
The request object is designed to allow DMA and you can allocate as
much memory as you like by setting reqsize.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
