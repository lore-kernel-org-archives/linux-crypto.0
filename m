Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF44238C1D
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670707; cv=none; b=XbPOxMG2yjtDRRckKrIpIoSxd46l6kPeZxMOmctKlG9xhM/CXK7n+rqK2HhlOx/PnRYi066bYTS+61qLScO5Pluvaev3QPD9ZYXrU7jdtHMsMeeJ4cpEhRDedJKPPr5vJI9L2jTzcvwMLQbvpIc8pebaRK34Be/7arsx/tmuy84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670707; c=relaxed/simple;
	bh=Lw9kWGglVNVe+2UZR39tyFbv/yQbnRudIYQN9sEZT8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YanBxm7ECDG/i9X+RPBpspHDXTVgJQsc3VOyGthZsj0NsnztI+299wr1498tEIt5A8Wd9KwHMOJjU29SldVjZYo4heNpBOBv/4K8tlU0ffwHoxQP0+HbL58f6eVNTzjO0mvQ/9JXPVK/jODJ8xUCwXAz/MZZSmgD14zull/VoPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CaH7/bGW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CaH7/bGW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nTNpPIwbLTH7qsfer0cRQKXIlTDr7ZJibx9p57D1+RQ=; b=CaH7/bGWlnG8oSO2iPdF4cnq+d
	WUkQ3H7BJHIKhaPP449IIfL8BrPLBQhThTZsyucBeB3vJIUEhLo/PhA/cb/PcsAkyr2XJLPTAflHh
	s9EodqCbw/KF0V96x4tWc1neezf4NiqihTfOwaByL5+07Tm31NZYkT8dbatwUEowYld2G2o4Z2Z8+
	WL+KNdRCNQmNKCOlTUS3psHJCKE9pwufSzh67KissMJpncCCwSkQek+4m3ppMfEiSt5UzyyRP8gJ0
	vBcAj33fDU5Z3B6jGa7Tgc2Cn+PH9JCaagY8zLlRs2uA5ycppPrOkNNfaDJEfmQDSbdM607kQrMoR
	mRVqh0Sg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTdAm-000FeK-2b;
	Mon, 23 Jun 2025 17:25:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:25:01 +0800
Date: Mon, 23 Jun 2025 17:25:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - remove duplicate masking for GEN6 devices
Message-ID: <aFkdbdo2C_PHkAnK@gondor.apana.org.au>
References: <20250617105232.979689-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617105232.979689-1-suman.kumar.chakraborty@intel.com>

On Tue, Jun 17, 2025 at 11:52:32AM +0100, Suman Kumar Chakraborty wrote:
> The ICP_ACCEL_CAPABILITIES_CIPHER capability is masked out redundantly
> for QAT GEN6 devices.
> 
> Remove it to avoid code duplication.
> 
> This does not introduce any functional change.
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
