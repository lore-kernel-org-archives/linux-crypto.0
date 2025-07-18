Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8C32BEC24
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 11:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837152; cv=none; b=oVhH4Ij11vXH+sWotMOIwe5Kj6u+EEBXWi3eBfCY9vN9U4gRZvK0rzhFsx7xdgHE+US+V7/7iwOHnJU/NJLliOapV4loLE78GP3SUxmFzkme0Um3ZPsliCnEclwCk2JSS6poOgG4X38y5kBUrRJseWNYyZO3y63u4QuAzpowG1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837152; c=relaxed/simple;
	bh=37voNvQ4CbL7ac9zL/oiANF4zfA+HXOB4oAMtFRoVtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9S3ZGR3oIYZ9T77RnbMvG6LDs00cyyUXm8ZfTBBFCCjLB53fHwU54DCeRi0tQ5Vc+/DLzEaslG8xCxk792Q4vmpRIVoMsI3tBIG4KXlouoYx6qXJwx9dwgUp+pcxzA34oVIeSSPV+RGUqawUimhcHzz+nYMb5ySZ++o42hltn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HjTTlKiR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HjTTlKiR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oKNyGVjgRmdmM5ddf77/4RbL7E4muk8Nb3dleA0i8Go=; b=HjTTlKiR+oNBGOieOcsrlUVvFl
	dOLQqcbu4aFA2784pBVKJTAuGAKs1SkyRqpQpWupv7J6DRpqxFpJl0GwriN0Z+wdvZBAjpWIuTdo/
	J5oPSwQViF674eyEAxd0wngb1ruNMOyPNFnkxvofIBufS9MzNVdug1bA8mCATg11+Nsc/HsLnOZvZ
	1Bhal5oCrkRek+HsaK1dECfiTWOmvSEAAn5ulDG3Ws8DdCaI2wWNOaFnBR7ctL5VkeatmfA6ucucU
	0wGa5Ioz3Ki/9gZRPTuXsIRHVSx4rM5Wz2/+b0qXf2r8ybsmIpoKP9mDtACo2EF220B6YAwbOlbhN
	oKD15vnA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucilT-007ymc-0d;
	Fri, 18 Jul 2025 19:12:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:12:27 +1000
Date: Fri, 18 Jul 2025 21:12:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/3] crypto: qat - enable telemetry for GEN6 devices
Message-ID: <aHosGzt2Wd0Rj5eU@gondor.apana.org.au>
References: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>

On Thu, Jul 10, 2025 at 07:39:42AM +0100, Suman Kumar Chakraborty wrote:
> This patch set enables telemetry for QAT GEN6 devices and adds handling
> for DECOMP service.
> 
> Vijay Sundar Selvamani (3):
>   crypto: qat - add decompression service to telemetry
>   crypto: qat - enable telemetry for GEN6 devices
>   Documentation: qat: update debugfs-driver-qat_telemetry for GEN6
>     devices
> 
>  .../ABI/testing/debugfs-driver-qat_telemetry  |  10 +-
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   3 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 146 +++++++++++++
>  .../crypto/intel/qat/qat_common/adf_gen6_tl.h | 198 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_tl_debugfs.c     |   3 +
>  6 files changed, 358 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h
> 
> 
> base-commit: d1d2ba1cebb7cf113f7ad3fd3eb8089a0cb2bd46
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
