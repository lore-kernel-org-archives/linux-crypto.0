Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B321E8322
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 05:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634325; cv=none; b=Rxdm9Nf9QNeIq3+HO/uOYyYmZNeU8aySt7PLBUrMm2TLPxKOjFG0qW1kruAq3bktztWNdex4CskovLaqhh8aVInvmsDETqOGF4ZXRmtCcJM6Cum9WKbmv7uoY3Nz/iBrN5C44CU5wKr7+1m35FOtN8GvdVij9LWkuuXXl3jGVh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634325; c=relaxed/simple;
	bh=L6DvC/5HSx5XLARaW/LR4kd7oJqsCahL78oYOwkfagk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUHLGlmo39/Gwx0Vtp7ZhezMNvnZsUgt1VkpXpGz6h+ArbsmWGv7EpQ35N+T7RXK/yqxUWxiVHR4V3elopWlEffhHOXA9h3O1VAOSKvtbjgEDailsYk+AvhP0cNZXmrnx15cAWlrbkenIWhUYUHH9P9GF/FLRAkfAKjHmIyyV/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WsHFAux6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WsHFAux6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d+JTU/4Med0M3vnjCBqdrk8GJnxsX6A5qSHuC2NLAHA=; b=WsHFAux6Z602g9WciS7R9Qa58v
	W3BcLz/BsncC7BKdGyHKj1glSk0nFePi7vlFAaldiKmwZz9qEX+ngXLJ/HFss2yRTq5Gz7uH2tBLJ
	sV58ffa4rIFBuCYJ21FM+Z74dDbV3jnUJr+0bcEQY3VJheC1rEx5kedmlIbySUNMOCIJyaBGTPYLY
	XrPDc51220zGinRd7jwt87BwjUpvbm7UzWoy4ipagWpu2OMUOt2/OvoZsch2fMFvULllFbdPPDhps
	TQ2PeKQdmD7ZEpQgVyP5O2oZim2gu+ivFEHt7/SkkyqhI4c4O5/0XRhHSGA1Lo4mWoTZSCDnllcPL
	JdyQQ4yQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtWH-00782E-2w;
	Mon, 19 May 2025 13:58:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 13:58:37 +0800
Date: Mon, 19 May 2025 13:58:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - enable RAS for GEN6 devices
Message-ID: <aCrIjSq_puCb5sY_@gondor.apana.org.au>
References: <20250513102527.1181096-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513102527.1181096-1-suman.kumar.chakraborty@intel.com>

On Tue, May 13, 2025 at 11:25:25AM +0100, Suman Kumar Chakraborty wrote:
> This patch set enables the reporting and handling of errors for
> QAT GEN6 devices. It also enables the reporting of error counters
> through sysfs and updates the ABI documentation. 
> 
> Suman Kumar Chakraborty (2):
>   crypto: qat - enable RAS support for GEN6 devices
>   crypto: qat - enable reporting of error counters for GEN6 devices
> 
>  .../ABI/testing/sysfs-driver-qat_ras          |   8 +-
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   2 +
>  drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   |   2 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../intel/qat/qat_common/adf_gen6_ras.c       | 818 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_gen6_ras.h       | 504 +++++++++++
>  6 files changed, 1331 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
> 
> 
> base-commit: 3e9254bcf48fb7e387209be7cec96f0de6d2d37f
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
