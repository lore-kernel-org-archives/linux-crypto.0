Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B2814A0B8
	for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2024 06:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925740; cv=none; b=jD3akHC4VnqShpxXCQHda2QaGAs67biv9Tmtwp5kkvZHavfUjqQrJn2vo8KH0ojFJ+MpuulSvGEUrLDv76YbyvrOfe2J7qvDxFk+jSOoOFQiuCnO/brr2crTDUFuyBAhoK8JSfAArPqLBiFuZ4O2JHPyXsyve+74voug4rppxWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925740; c=relaxed/simple;
	bh=qhXOJkMA858DFgcdbUhwNqx90OpkY7XJbuTQJhVCWWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOHFNMhOOZPEeWawro/+QYyAdDeWFSCve2MJ9VW3EJ5obGUR49dKhlThx4xJNxUf1U8mVzOswJagqJvqpPpQz9qnIKwPRnRyPI3j5EuB03IiLaWcCHW7KHhlD1hgdZc1cWBeSrNvsWpHLHWsg0So3eamNRO2/V5aAtdrpJTR4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=j5d+ucAv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="j5d+ucAv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GcNYaKjJmk+alw4hwvBzzM1ZqnEt71r5wN3C9IOGZaM=; b=j5d+ucAv7S4HtEISuFlHJHG5vf
	OiI7copdFdir7KXfgbOSCFDebdv1MiLJCG5Nc8uYrOdOH7zoJbZZKw/AVrGfn3g4rttZ9yPivDHtk
	KyW1Miy9Bt7nVEY3hk/s7KPxeMUf9q46g43qBkV75hRSLcxjprLBDqQSo4TYnNtAV+Y2UZ3xiJRge
	/aHxtP/2LE3C7ZfFeUxB+wksvk/T44+mD4P+gNul9OgrjpBKW1Y78wPBONNb5vAebDzp7/5QHq7Y4
	oz3Mma/hNTINWUJbUYJaU9fZCdAc3Smp86XuneWGmi08YOIhrhg8RhT2Y9uWqrbPfr6FMXZV98Ayq
	qg6OWm4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ahj-00CFuB-2U;
	Sat, 26 Oct 2024 14:55:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:55:19 +0800
Date: Sat, 26 Oct 2024 14:55:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yi Yang <yiyang13@huawei.com>
Cc: steffen.klassert@secunet.com, davem@davemloft.net,
	daniel.m.jordan@oracle.com, lujialin4@huawei.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: pcrypt - Call crypto layer directly when
 padata_do_parallel() return -EBUSY
Message-ID: <ZxySV0ME0pqQEGjS@gondor.apana.org.au>
References: <Zr1ij_rbPicAc6-f@gondor.apana.org.au>
 <20241015020935.296691-1-yiyang13@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015020935.296691-1-yiyang13@huawei.com>

On Tue, Oct 15, 2024 at 02:09:35AM +0000, Yi Yang wrote:
> Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for
> PADATA_RESET"), the pcrypt encryption and decryption operations return
> -EAGAIN when the CPU goes online or offline. In alg_test(), a WARN is
> generated when pcrypt_aead_decrypt() or pcrypt_aead_encrypt() returns
> -EAGAIN, the unnecessary panic will occur when panic_on_warn set 1.
> Fix this issue by calling crypto layer directly without parallelization
> in that case.
> 
> Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
> Signed-off-by: Yi Yang <yiyang13@huawei.com>
> ---
>  crypto/pcrypt.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
