Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82500226D02
	for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2026 08:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082875; cv=none; b=q9VcXZvLFlS3Xr01bV9YYPZWUBG8e1F4cNf8NIoc9Fidxl7NOGe/MVjNoxN9jgPDpKMWPceTAXD1tDhp2p/Kb5tfFrH1Ks3xWASjr4b9nowCJ1ajHkfT2NKDE1WT6xMv8IsCfqjDN6Ob8hrSxRfODugg0XsU4otoJdvz4U8C6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082875; c=relaxed/simple;
	bh=h3kKUBIZeZBG7kzo+mbzr1j4JRsaRd2kkfZK7mSDoRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KkbSy6YBuYY4g0UYXmTlyjR57b4g7c4bszl8Vhw6ZmxlkiVbldXK2ogBcdVYMMOQ0S/Nblv5wc1siQIaI0pn0iLrMG+KKkg6MRQG9ObmGPWtdVGzJrgZO6k8rVuY0eJyPf5OM3QXGMtNGDIEVfLzKpZPnuyJfvtkeQ2hOUS2uU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LbTajhyT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LbTajhyT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pUfecxcA13Lf6tynzlgdhNIBPuNl6g+Kw0UHCAi0NkM=; 
	b=LbTajhyT6fQAWKKaoOGP5/01o9s8mID9UZkONQRuON1ruV3v49zMMJVCQTmbT2DoKgc2322uCTs
	gMQbGOc6ifFgqTiog53AM0iO46yIekNKGGIXkvfrGGcr991fmS6PnYfA1OG9Clix15MsVTJtDGKKl
	dCSDd/a5IFv+HvX7wo9SPLZmoc7Ec8akJ1fSmWEsFjT7KDTKHZFg4eFdEXpmCrXROXiXaFPMz8tG4
	Yc4j+jX58G9HDHVMjerDv+tmQnK9CGL4LA4EPux2hhFIims93W7wNNfSXU640KAQnnWglDhDQXIQ8
	VP86JzRNWEPhieuBBOjcWi5ZLCDqrvQgrvdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3rzq-00GJ9N-2b;
	Sat, 21 Mar 2026 16:47:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:47:50 +0900
Date: Sat, 21 Mar 2026 17:47:50 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Abraham P <george.abraham.p@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Aviraj Cj <aviraj.cj@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - add wireless mode support for QAT GEN6
Message-ID: <ab5bNrlMg74ZeXGy@gondor.apana.org.au>
References: <20260311082245.3466672-1-george.abraham.p@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311082245.3466672-1-george.abraham.p@intel.com>

On Wed, Mar 11, 2026 at 01:52:45PM +0530, George Abraham P wrote:
> Add wireless mode support for QAT GEN6 devices.
> 
> When the WCP_WAT fuse bit is clear, the device operates in wireless
> cipher mode (wcy_mode). In this mode all accelerator engines load the
> wireless firmware and service configuration via 'cfg_services' sysfs
> attribute is restricted to 'sym' only.
> 
> The get_accel_cap() function is extended to report wireless-specific
> capabilities (ZUC, ZUC-256, 5G, extended algorithm chaining) gated by
> their respective slice-disable fuse bits. The set_ssm_wdtimer() function
> is updated to configure WCP (wireless cipher) and WAT (wireless
> authentication) watchdog timers. The adf_gen6_cfg_dev_init() function is
> updated to use adf_6xxx_is_wcy() to enforce sym-only service selection
> for WCY devices during initialization.
> 
> Co-developed-by: Aviraj Cj <aviraj.cj@intel.com>
> Signed-off-by: Aviraj Cj <aviraj.cj@intel.com>
> Signed-off-by: George Abraham P <george.abraham.p@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 97 +++++++++++++++++--
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     | 14 +++
>  drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   | 33 ++++++-
>  .../intel/qat/qat_common/adf_fw_config.h      |  1 +
>  .../intel/qat/qat_common/adf_gen6_shared.c    |  6 --
>  .../intel/qat/qat_common/adf_gen6_shared.h    |  1 -
>  .../crypto/intel/qat/qat_common/icp_qat_hw.h  |  3 +-
>  7 files changed, 137 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
