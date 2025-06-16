Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A351A28D8C0
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 02:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042687; cv=none; b=GNhopJmO497XF8Uwno3Y6gWHSCl+yGsKVzdPDFM9QVkBD22/DJiPTvdLRPfIHm/0L51HCn5Q62JXC20mcFjesXOB2pPxClfy8GKCcRiTOCXnfgg1GHbWLtangS4+B4kSWerLaH+gwDsyB5JjFeWO5o33yg7jcZTGRj0srYLa/r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042687; c=relaxed/simple;
	bh=suRLOJorftEVFJExTrrKRGQIMQpu/z5TEkP5VaYaLf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ypt/IHPl89hLcjWkohg0E+8yoJYzdKYgKNIXU4kLwcqY0QLHMylPwrRz9b7aif/fb0Qjc5GH6vto1zFhpLu7X9kTJ971M/T+/1PUXM2jD+GAyT0+wSiPuECVYpdbvKE7PFCrTQQBjKTcBVbyCyQjlnmMsb8CEH+m476Ba8lI5Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ohi3AShk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ohi3AShk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uU0Y/RZ+gTrqZehPHojqCTU7akXPm3XNXKzRiqk1WzE=; b=Ohi3AShk3yYgRKPsMSIJMN8t2j
	SWw7q/asFMuub/k5Tt2f6IkArYMG3PfHP8+mg4a5F076Ul+5IfK9Xf7fsDyhykdeiMcRvPtEqUYDc
	eN5Nwum1eZHhYnE8qVERga4Zl2a2phYizCkS0MJXeqmUP0B2grgfLexmRHuPyTJ/jzmp1b9kIiKzM
	QKGoWscryFDyGHiH59Jun3RyLGe4vEAlfnfekk+/ugpSdFGGgEnm5AiIl0rYi+ij1uv0W0JYwAyeS
	dxtHiVYfdaITAoMSCIdNL3+MnJP/7gtjM+H+kHQhSWmU5LFgPPmS/Pehv/I/llz5PvptY6Ufzf1zR
	aUPt1CDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQzni-000IdW-0E;
	Mon, 16 Jun 2025 10:58:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 10:58:01 +0800
Date: Mon, 16 Jun 2025 10:58:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - enable decompression service for GEN6
 devices
Message-ID: <aE-IOeKbCvMHjjVh@gondor.apana.org.au>
References: <20250605112527.1185116-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605112527.1185116-1-suman.kumar.chakraborty@intel.com>

On Thu, Jun 05, 2025 at 12:25:25PM +0100, Suman Kumar Chakraborty wrote:
> This patch set enables the decompression service for QAT GEN6 devices
> and updates the ABI documentation.
> 
> Suman Kumar Chakraborty (2):
>   crypto: qat - add support for decompression service to GEN6 devices
>   Documentation: qat: update sysfs-driver-qat for GEN6 devices
> 
>  Documentation/ABI/testing/sysfs-driver-qat    | 50 ++++++++++---------
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 13 ++++-
>  .../intel/qat/qat_common/adf_cfg_common.h     |  1 +
>  .../intel/qat/qat_common/adf_cfg_services.c   |  5 ++
>  .../intel/qat/qat_common/adf_cfg_services.h   |  1 +
>  .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   |  3 ++
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   |  2 +
>  8 files changed, 52 insertions(+), 24 deletions(-)
> 
> 
> base-commit: bc952a652f56cf45027b68f4de57f4182b2975dc
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
