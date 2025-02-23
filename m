Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368B18D;
	Sun, 23 Feb 2025 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740272172; cv=none; b=eZWt6JnFQeJfVPTKDyAy8JjhcsjyDvEEgfyWi7qHrBoNkhy7Z1RciAZsQ2c7SqlVvuPxp6FHIj9DSMddFsHFz+dYGsAVbp14bx3/JXT3FbAJJt4CSoKCLS2nytjoIEI9s5ngrn0t+pdmqu/TDEFmq0BiDYsyOPNgwuzYKSEhE7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740272172; c=relaxed/simple;
	bh=DIlBiMye26V00PPCS7SMF0yioT2NlpSHONHNVSpLX/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4uikVujzhM6thuGjsh4tjcjm7N0gtVx0JMfUvfpuD7F+VVqOrmlvlHTSpgvAsWh4K/EscZ3qU1HtLvZnyDlT1YSw+4H2yL77GoX+JLlohPzG9R8AMS6qOhWhqhR2QXxUbEbksgkt+h+gQq40ngTc63Dx4cTTEcheaqgNQG7iOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=m1MhMvTd; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="m1MhMvTd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=jS2MCvXdweiAOOldAmreNKtpgXrTKSGIHamkWI99yVQ=; b=m1MhMvTdejD7VLMu
	cnzhZSxxWuqD+q2y5Up2C2LiZXBYcuGKEaTEyUuCA+Rx5eWxMs/29R0QyA6RnguYYnbRs3sFBtJw6
	yLEOW/a1Wpc3fcH0v6WEiSUmyf6RlF/SHCFPWneTvGJQeNyFDPc9dOtSNX4x31dMEKtheFM6dVh/1
	rB75DRzEMbRlRAFVURMuuY8/ZvKiI2v9gJn8+1mLOJVBTBs/DObZ3kIpJu+ePzFPGcfhWY4Dkbs4G
	r3L+nMb8/JZOhMZBieV1JTXMgPwqRk7DEi5OrB5NBlLSdsXyD5V94TY698Bv1WJ7HLiA06EmvCQUr
	5Gg42cACS1vQoHTAog==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1tm0Hs-0008Sn-2s;
	Sun, 23 Feb 2025 00:56:04 +0000
Date: Sun, 23 Feb 2025 00:56:04 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontxs -: Remove unused function
 otx_cpt_eng_grp_has_eng_type
Message-ID: <Z7pyJCvzOmslwmyM@gallifrey>
References: <20250223005443.86343-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20250223005443.86343-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 00:55:50 up 290 days, 12:09,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

NAK - let me unbreak that subject line...

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> otx_cpt_eng_grp_has_eng_type() was added in 2020 by
> commit d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT
> engine")
> but has remained unused.
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c | 11 -----------
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h |  2 --
>  2 files changed, 13 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> index c4250e5fcf8f..9472798678f9 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> @@ -505,17 +505,6 @@ int otx_cpt_uc_supports_eng_type(struct otx_cpt_ucode *ucode, int eng_type)
>  }
>  EXPORT_SYMBOL_GPL(otx_cpt_uc_supports_eng_type);
>  
> -int otx_cpt_eng_grp_has_eng_type(struct otx_cpt_eng_grp_info *eng_grp,
> -				 int eng_type)
> -{
> -	struct otx_cpt_engs_rsvd *engs;
> -
> -	engs = find_engines_by_type(eng_grp, eng_type);
> -
> -	return (engs != NULL ? 1 : 0);
> -}
> -EXPORT_SYMBOL_GPL(otx_cpt_eng_grp_has_eng_type);
> -
>  static void print_ucode_info(struct otx_cpt_eng_grp_info *eng_grp,
>  			     char *buf, int size)
>  {
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
> index 8620ac87a447..df79ee416c0d 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
> +++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
> @@ -174,7 +174,5 @@ int otx_cpt_try_create_default_eng_grps(struct pci_dev *pdev,
>  void otx_cpt_set_eng_grps_is_rdonly(struct otx_cpt_eng_grps *eng_grps,
>  				    bool is_rdonly);
>  int otx_cpt_uc_supports_eng_type(struct otx_cpt_ucode *ucode, int eng_type);
> -int otx_cpt_eng_grp_has_eng_type(struct otx_cpt_eng_grp_info *eng_grp,
> -				 int eng_type);
>  
>  #endif /* __OTX_CPTPF_UCODE_H */
> -- 
> 2.48.1
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
