Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099FA2949E0;
	Tue,  5 Aug 2025 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754417157; cv=none; b=uW3LOTg4y6R++q+f3W/aXuuw2crjnoNp4q3KZUT/Pa5sEksnAH92bXhUvplQk4do0R+x2TbcsihauQB+bgs08eHLvKOmg71AhC/0hD3SGftPLmV7BJ43HGqwhI6B3f2UsVdWtpX+WqXp4UThm6ond1cnPB53XIFkJcm5ao/5IwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754417157; c=relaxed/simple;
	bh=URnrMaC1oLePcNVZtSGDaxkZGV0Hf88wRGTzBWXY5sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1LT5QChX9bluPShifqh9x5r98FCy5KkrEQNMSnn4gomlLDlbjzyMBCPwIzcJH40aqFcNj1K7hMFcsd2x1p3djQmJ0Ks5HjW9vmyci4FFbVVCUdM6r1Sq798+2/CpLg8Gw7ic3PhBgNAKQoq9dPdY0WIoccCHiaXmSaZ5UANZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jwwq9e0Q; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jwwq9e0Q"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5ECE740E0198;
	Tue,  5 Aug 2025 18:05:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CberBSLOwsen; Tue,  5 Aug 2025 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1754417140; bh=1nAuTC1gfkQkqmVFl2D9/hSFOvW8mlV/yNtnNuDj09Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jwwq9e0QRaJGgoUePS7lscmgyep+95TpXlRpaMxKYiyFMZEJs9sjRhov3xOWBrXa5
	 69PCnrftUxDFmSjgEe7HUu6JpH0V/sevKAGsUzRZmcLw6mbGHTSzfoYNkvJ1JPUGBX
	 GTv3cquIxGMwam3GJE9K+kggtpdeKogokC/WHOjy0wNyWMk5TfyfdnSXb0dsluIqg8
	 Xy4CXH6+A7XQOWq6tKiw9FMqezBSLf375RLYn3Fas/E2+zy7r+Ywvlx14m7BbiEh64
	 deYpSzD8xG2QaGapW6Prn+/4lh4pi/nyZrxxCSfTt5f8i+KmKdsW+TYNVxshH+O4Z7
	 /PINTrpV1fz+48p7dAtirMDB5omjQDWY3oOJrJPtB6eQonYhdwRDgA1OhUfv2Usyna
	 yjH9KbSkNOKe6wKxsiFepUz9WudJ2D+Rn3XUdDJRP9eGZJD/ntgVUbWt22BOkr5ZSF
	 guqry0Hv5ECRJw48I+3I1/9fSz8f0YKoApDTCKdo+8Xh20XJiDkXU7kQW+LThrYHL9
	 Im1xyXqvvF4MW0mX9nfcDiMrh1rorHvNi3SYrdkoHncaSQA1/brz06/H9qWPzA0Geg
	 shOHd4BIoOsDtaxSgvrniislpMz9/Am2ORu9jm6YmCf/E6wWElAb/o0WcpRN3zTjdl
	 YePlYuRnz+S98eDlwQOVcFE8=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 983DC40E0177;
	Tue,  5 Aug 2025 18:05:34 +0000 (UTC)
Date: Tue, 5 Aug 2025 20:05:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
Subject: Re: [PATCH] crypto: ccp: Fix checks for SNP_VLEK_LOAD input buffer
 length
Message-ID: <20250805180528.GGaJJH6PjqvB1AJYLR@fat_crate.local>
References: <20250728234303.2836702-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250728234303.2836702-1-michael.roth@amd.com>

I think this should go to Herbert who's collecting crypto stuff.

 To: x86@kernel.org is perhaps not really the right place :)

On Mon, Jul 28, 2025 at 06:43:03PM -0500, Michael Roth wrote:
> The SNP_VLEK_LOAD IOCTL currently fails due to sev_cmd_buffer_len()
> returning the default expected buffer length of 0 instead of the correct
> value, which would be sizeof(struct sev_user_data_snp_vlek_load). Add
> specific handling for SNP_VLEK_LOAD so the correct expected size is
> returned.
> 
> Reported-by: Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
> Cc: Diego GonzalezVillalobos <Diego.GonzalezVillalobos@amd.com>
> Fixes: 332d2c1d713e ("crypto: ccp: Add the SNP_VLEK_LOAD command")
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3451bada884e..7843973ba4c6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
>  	default:				return 0;
>  	}
>  
> -- 
> 2.25.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
