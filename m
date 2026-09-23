Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42775419FDA;
	Wed, 23 Sep 2026 08:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153364; cv=none; b=A+11bw+MVlPYv3GQBp9GkotYlMLlaOyMrq6A0WJ3snd07KDwMi4xxv2QSqoNewd4iFqhhsKLmtx2WHAqf9F9T8zZKAvA9pvrZ6+VbRHwE+3i5J2N7Fkb+vNeRZ1et94yTJNk3N9qMbHDOQYnitUuZu2sat7MwpgFFGUzpi0ReMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153364; c=relaxed/simple;
	bh=D1g91ZjWmHkh7Ktrud+n9+yw3chYZxh3hH2ykynfykI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aa7lU/tQRFApJNX1+lpECoqe6kV63vijhf8lVOF8ucgJAvJEchMAszj/lRogH/Vf8x5olo1mH+LLp+8EHtDHOhNMdnqePM4GI/Wgu7PNkn1qiYpgobUBVkfWwVz8S5w6C0XfuKKsap1gNaNK8A6y9TztKPvUbVyhjLlxLAV3TOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aQ9M6abU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aQ9M6abU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+zcspmb0hquHO5ANgjZOz1PbyctOi3LbJHzh5KTF0lQ=; 
	b=aQ9M6abUGkcUdIjIgE7/KAqKFg5EalYVj5q5C77oG0GH2DD2TB1KVsTsns3InR4cZZryZdHK1bG
	8lazk64Oqy2rSMaSEgiVLkRxjTGL9pN2+F+jsaNC4Bh5XloYo21BtLQDLKXdYPiTc1PNSi57rB4/Y
	uRelxQ/hTwv0VWIKPpHf1s8DH8Er7etor61tyQtnw8wFB+yzJdRQxsgBEwlC7hS8+4QUEh+MjIUPK
	p/ERQgp+B7jOFX3kiFrLc+DBwIDBd6O7nUbIA9jsBRpjvuhndh7VVc4x3Z1K46U4TYetkICypoPwa
	sAUdadzU5cbpmd6Dl1v0uu4w6FdePM2GGvoQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IfE-0000000GyCK-0CiQ;
	Wed, 23 Sep 2026 16:49:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:49:16 +1000
Date: Wed, 23 Sep 2026 18:49:16 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - fix error source for QAT GEN6 transmit
 interface faults
Message-ID: <arOSjKbX-VIucSUI@gondor.apana.org.au>
References: <20260916075536.1361895-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916075536.1361895-1-suman.kumar.chakraborty@intel.com>

On Wed, Sep 16, 2026 at 07:55:36AM +0000, Suman Kumar Chakraborty wrote:
> TI_CD_PAR_STS faults were being decoded under ERRSOU1, which is
> incorrect for QAT GEN6 devices. They are actually raised on ERRSOU3.
> 
> Move the handling of TI_CD_PAR_STS faults as part of the ERRSOU3 logic
> and split the status bits by their actual source:
> 
>  - Bits 0-18 (TI_INT_ERR_DEVHALT) handled when a DEVHALT is signalled
>    and are counted once as ADF_RAS_FATAL.
>  - Bit 19 (TIMISCSTS) handled separately and counted as ADF_RAS_UNCORR.
> 
> Previously, a TI_INT_ERR_DEVHALT fault also incremented ADF_RAS_UNCORR
> in addition to ADF_RAS_FATAL. Since a DEVHALT is already fatal, remove
> the redundant increment.
> 
> Bits 20-25 of TI_CD_PAR_STS are unused/reserved on QAT GEN6. Remove them
> from the mask.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7f3401d0a506 ("crypto: qat - enable RAS support for GEN6 devices")
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  .../intel/qat/qat_common/adf_gen6_ras.c       | 20 +++++++++++++---
>  .../intel/qat/qat_common/adf_gen6_ras.h       | 24 ++++++++++---------
>  2 files changed, 30 insertions(+), 14 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
