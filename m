Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99CC13D53C
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123845; cv=none; b=tuhZnRhBCfOxT7S3IYlWPZUOpenJXx8s/EnP5vYojsAxiv9ykN7xU4VOudUVjzv5tstDf2YF2Ii+kXAJT9DwV2vMb8vXOnXnYvjIfk8aqF2n8C1VcsrHDFlT95g2omcF6F+GnOpX7Z7u0qYIyNVgZIkphXzpMDEa4FqEGmYAaB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123845; c=relaxed/simple;
	bh=WUdiSMi+xodRniBJjxbUmGkG2ZgnM/vH40KpoV32pEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCsoIXD38EZFtq3ia8XSJjjunDFSJAwXAAMnjHhVC3++4zdQm7x5bM7OMC+7kadJEt9b6l/xCMt6mv7kKyY1cgJTxqZJHc94tKYMytqCquxaqjHzN1QSaW/igoTk9akwE/htuF2TBbexvMEgdofJZj+8JT0KwWSBGexzpX8zJLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0Huh-006eKd-PU; Fri, 26 Apr 2024 17:30:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:30:57 +0800
Date: Fri, 26 Apr 2024 17:30:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - validate slices count returned by FW
Message-ID: <Zit0UetFSdQfIVk1@gondor.apana.org.au>
References: <20240416103337.792676-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416103337.792676-1-lucas.segarra.fernandez@intel.com>

On Tue, Apr 16, 2024 at 12:33:37PM +0200, Lucas Segarra Fernandez wrote:
> The function adf_send_admin_tl_start() enables the telemetry (TL)
> feature on a QAT device by sending the ICP_QAT_FW_TL_START message to
> the firmware. This triggers the FW to start writing TL data to a DMA
> buffer in memory and returns an array containing the number of
> accelerators of each type (slices) supported by this HW.
> The pointer to this array is stored in the adf_tl_hw_data data
> structure called slice_cnt.
> 
> The array slice_cnt is then used in the function tl_print_dev_data()
> to report in debugfs only statistics about the supported accelerators.
> An incorrect value of the elements in slice_cnt might lead to an out
> of bounds memory read.
> At the moment, there isn't an implementation of FW that returns a wrong
> value, but for robustness validate the slice count array returned by FW.
> 
> Fixes: 69e7649f7cc2 ("crypto: qat - add support for device telemetry")
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../crypto/intel/qat/qat_common/adf_gen4_tl.c |  1 +
>  .../intel/qat/qat_common/adf_telemetry.c      | 21 +++++++++++++++++++
>  .../intel/qat/qat_common/adf_telemetry.h      |  1 +
>  3 files changed, 23 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
