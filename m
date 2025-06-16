Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3A29898B
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 02:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042615; cv=none; b=d6+Bvv7im9/Ml/mqVJt1FA7HPGawKYasSAwMsqH8hHVv+oNkrgFBvh0/2ClgNIBbDviQrC47SEe7WNJBLmc+yzWwzFje84APBxxMpwW470SmoYgXDrdINPzSLSg3jFPf/yKBFo1u7dQkqTN52wHyT3HS6x18dGNbz7cII5Fsm1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042615; c=relaxed/simple;
	bh=etyxWPNpyFykIyO3dPMJ6TRiaEJhzDZy5neoGdx44RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0idyXTbtBZSEdI5MtCetsKDEe6VdPgUNjeN3B3edWRNwjczgcHLOb4Km+YiM/b0MbzFtHvMQ1wn9Rgijvp/hHpIhFTCe07hmimDwiFS33VICHXU9lakxLeyW16JPSMzplTIrVQv+RXfpxwWjBQ51L9agOdJXv02715nAWQXStc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dLpuQNFH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dLpuQNFH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mwRzun+OCMOHqh4Zs9bRVswNFDpAXk8FDOnudhpSSb8=; b=dLpuQNFHROxEEZqKcBiZ/HT367
	adNRvcQ4Iv+PXfZA0039N0LbptEqXK4gMLcJv6Jv6w/+A7sImsS2r2b0aVTeVGIRkaytTjU1723BE
	7FDGN3y2EygFUIzSVSkS/cmun4QV7i+gvrEb1WGaCsAhjX91xfESg5ucRo8hca5yJn+pc9MAAGRhE
	Y3TWQX99TPkuiPx/xl0kWJXOtmHp4HEPQ8ThxCQTVUsVJEIpTf/mPldE7GVQXWmIcFBXhwgPtuhkB
	wLJRgA/e8yUuLaHXRXmAsFjqLZaJSjBy/+m/nZfmtvkWIzetrAED1TiAfIGQsCYLzfBBqzw8uvpvX
	v5MIqfnA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQzmW-000Ibb-1o;
	Mon, 16 Jun 2025 10:56:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 10:56:48 +0800
Date: Mon, 16 Jun 2025 10:56:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - allow enabling VFs in the absence of IOMMU
Message-ID: <aE-H8DTXQuDkjB6I@gondor.apana.org.au>
References: <20250604082343.26819-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604082343.26819-1-ahsan.atta@intel.com>

On Wed, Jun 04, 2025 at 09:23:43AM +0100, Ahsan Atta wrote:
> The commit ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
> introduced an unnecessary change that prevented enabling SR-IOV when
> IOMMU is disabled. In certain scenarios, it is desirable to enable
> SR-IOV even in the absence of IOMMU. Thus, restoring the previous
> functionality to allow VFs to be enumerated in the absence of IOMMU.
> 
> Fixes: ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_sriov.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
