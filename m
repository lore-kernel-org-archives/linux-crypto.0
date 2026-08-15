Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8FB2EA732;
	Sat, 15 Aug 2026 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757374; cv=none; b=Lr+k9eKPBh1Byod2KgbAEVPRU3IJkfVRc85oW5X8mjLXjZzhQ3r9f27i4nW7EzUGtvL3lLrA4UrInp97b3j4aKihS/g+ZJO/08OyPSx8wuQecvigHEnx4h+IDoQB8W4W91OGcgtxdByz8iEQa5LCFUOKpCeLUtIiAFr+heRtBXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757374; c=relaxed/simple;
	bh=75x3FYMu6RPT5C9banVQ+giOfwegPCbAFDAMCqUlGa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVLM/gSwCY1sl768z5T9Ydn+s+DoDX7VI+QIlb65XBkEuVGIT8KiJN3C1i1s+9SmCxBE0RMVUjLN/4puGN6ak5WPXfxCSCCxMCZt/lcofOPg2chKdTMowd/8/VpqVm7Zo8e/iVog+e+AuumGulUwBHkOgUFdlvLP65zLsrkJLJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PezA0FeX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PezA0FeX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/lRxqFIy57wr0rIvp/SJiwwkRKQoz+OECrLvNZgu9Bc=; 
	b=PezA0FeXkVqohyW1JhGvjjl+szzrYfGuJoRFmgvNYWEqeCrcqUBYgbCSYtp/SSJ5CBsORWRqi/B
	QRkpy2M3KfGAfS/M+PGiFmAVAAA4HFio+/jUPOc7E6xwPQx32PnkxsidqsLqCVPcVzY4/A5i994bQ
	uxdJwauvdmH3kgDq5PdNGfp5ArtWGocOIwXfFFS+rt5bKlQ+s7msykLUiN5ushGU0BTsk20F6KZCm
	cXbNqB9eqN/tJQ/f7mJ+nuEgjzgsnCYX9f+MMp/Zg06ccCq/c/9WnENHdH5Xp2lELKB2ksNMRlfwn
	gKH/j+B4gcDa5rIkta5+NtZ0QYhOa1mAttVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3DE-00000005507-2Kgy;
	Sat, 15 Aug 2026 09:29:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:29:28 +1000
Date: Sat, 15 Aug 2026 11:29:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Md Sadre Alam <md.alam@oss.qualcomm.com>
Cc: brgl@kernel.org, davem@davemloft.net, thara.gopinath@linaro.org,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	varadarajan.narayanan@oss.qualcomm.com
Subject: Re: [PATCH] crypto: qce: fix CCM AAD buffer underallocation
Message-ID: <an_A-IUOL0yPFAKE@gondor.apana.org.au>
References: <20260807065454.1640815-1-md.alam@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807065454.1640815-1-md.alam@oss.qualcomm.com>

On Fri, Aug 07, 2026 at 12:24:54PM +0530, Md Sadre Alam wrote:
> The AAD buffer allocated in qce_aead_ccm_prepare_buf_assoclen()
> can be smaller than the length later programmed into the DMA
> scatterlist.
> 
> The allocation size is currently calculated as:
> 
>   ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN
> 
> while the DMA length is set to:
> 
>   ALIGN(assoclen + adata_header_len, 16)
> 
> Since ALIGN() does not distribute over addition, the allocation
> can be smaller than the DMA length. For example, when
> assoclen = 32 and adata_header_len = 2:
> 
>   allocation = ALIGN(32, 16) + 6 = 38
>   DMA length = ALIGN(32 + 2, 16) = 48
> 
> As a result, the QCE hardware can read beyond the allocated
> buffer while computing the CBC-MAC over the associated data.
> The extra bytes are folded into the authentication tag,
> resulting in an incorrect tag and causing CCM self-test
> failures such as:
> 
>   alg: aead: ccm-aes-qce encryption test failed (wrong result)
>   on test vector 8
> 
> Fix the allocation by adding the maximum possible AAD header
> length before alignment:
> 
>   ALIGN(assoclen + MAX_CCM_ADATA_HEADER_LEN, 16)
> 
> This guarantees that the allocated buffer is large enough
> for the fully padded AAD data for all supported header sizes.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
> Signed-off-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
> ---
>  drivers/crypto/qce/aead.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
