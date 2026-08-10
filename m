Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3653A48ED
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 08:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350943; cv=none; b=WzmK1EMMpGQA+AaaH1Ht+PiFvgPtPwhVoVyweFvabj+MkYLQAePVWj8zJsjB1cevt/bOTeRj7spxaLPRkqxLLjNIqk7XjwRDaqMZA/Hg2KmIqkKbHaUC3G5JXAic+NT966W0beBifSUGmRqbXz26x/v3fDN8OU8FGw4+8hJ0HP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350943; c=relaxed/simple;
	bh=wBZcTox4F6LASJUmclT99vP1pn1sI2z48vVegbLb7do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdNpEL4HnvDMWoOmMH/Sh2uTxdoBZ5h8tBG9xHy+xfvUOXDLPFmlg4E+KXjsdQ02ikrQbUDoeA/N06lXhoxhNkR9ocOCuDxRT46xfq2Wyxow4zm4cf55ghlKVwv3HMrqY44ZyIJjRgXtxL0TqsvTsNNdITdUkYLG+Duy9H0+ct8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oeXfQ5Ym; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oeXfQ5Ym"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ola35yOA0er45AOrjM+MaYYWyxnq4tNathzmFkD7JU0=; 
	b=oeXfQ5Ym14yYNgh3IKIpaYzMEJg14a9/rrCLBz/w1BuDEjKyUyF7e/dX+sjacj+u9YidjWFz0Cn
	BrRHRX11DeJ0itRFdYS/dU3eF7ICk6jrfypsDRLQ3tmR7osbTJk41ht9qYSzFu6zUZqcNNGS6EQle
	21PHLsT/OxI044A4CvuRPILJnglcPzz7x3cK/KX+a0sCAYBQoMxhfDDl52+gP0VjtJgQ4pwc264Nf
	399Nn/txzZcDlFaE4PNEUImLQqQ7EhGHALU57q88hGKCSDUPf9GeaTdTh1y3wipU7ZzIN/AxmIyxE
	FnNLg2v2t6vcxxBo3Z6eFGZGWLy/yrFeRZoA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLTs-00000003Wpn-3aog;
	Mon, 10 Aug 2026 16:35:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:35:36 +1000
Date: Mon, 10 Aug 2026 18:35:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-drivers-review@eclists.intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Subject: Re: [PATCH] crypto: qat - remove dead ADF_HEX code
Message-ID: <anmNWLbMDNlABXCp@gondor.apana.org.au>
References: <20260731124832.159453-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731124832.159453-1-ahsan.atta@intel.com>

On Fri, Jul 31, 2026 at 01:48:32PM +0100, Ahsan Atta wrote:
> The ADF_HEX value type is defined in the adf_cfg_val_type enum and
> handled in adf_cfg_add_key_value_param(), but no caller in the tree
> uses it.
> 
> Remove the unused ADF_HEX enum value and its dead handling code.
> 
> Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c        | 3 ---
>  drivers/crypto/intel/qat/qat_common/adf_cfg_common.h | 1 -
>  2 files changed, 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
