Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF1614B09F
	for <linux-crypto@vger.kernel.org>; Fri,  2 Aug 2024 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604528; cv=none; b=LojBk/vrXnKGjA6YddReD2DCkGPossh8ctLYsnRv58R0uW5g9I56TXLEyRC+m8PZUV1ywsdjoSPtteZp9m7mRM27YJVYsqAPj8gy6Q1BZAlkubaLkpLkbPTIxdTdo0tBprr8K2I6w4zPBo4nM293q1ls+ZpDL62p+pKqpK9Ady8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604528; c=relaxed/simple;
	bh=I28jMkqM7AgUX+7oezGmKhEEg8SQySTdGDqYUVNCMek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHPxhzLm/XGlyXuR92vaeOB3YNyzth9gzEO1NXXtN3Y2jNIImQKZJ/xNdNoSUpoUmiXMmrhaALOTEupCIKiNYlsIbLL4bVt2SdtVNjFmlhRg+U7WIEGei+oG2TKsmCEs17xSyVqE6d0RkBbaM2uNzyrLmD8CAr8dSclxjqbgEdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sZrzP-002037-26;
	Fri, 02 Aug 2024 21:15:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Aug 2024 21:15:20 +0800
Date: Fri, 2 Aug 2024 21:15:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michal Witwicki <michal.witwicki@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/5] crypto: qat - Disable VFs through a sysfs interface
Message-ID: <Zqzb6DDYpntap0mL@gondor.apana.org.au>
References: <20240717114544.364892-1-michal.witwicki@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717114544.364892-1-michal.witwicki@intel.com>

On Wed, Jul 17, 2024 at 07:44:55AM -0400, Michal Witwicki wrote:
> The main goal of this patch series is to introduce the ability to
> disable SR-IOV VFs by writing zero to the sriov_numvfs sysfs file.
> Alongside this, a few additional enhancements and fixes have been
> implemented.
> 
> Summary of Changes:
> Patch #1: Preserves the entire ADF_GENERAL_SEC section during device
>   shutdown.
> Patch #2: Adjusts the order in adf_dev_stop() to disable IOV before
>   stopping the AEs.
> Patch #3: Adds support for the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE
>   message to ensure proper VF shutdown notification.
> Patch #4: Fixes a race condition by setting the vf->restarting flag
>   before sending the restart message.
> Patch #5: Enables SR-IOV VF disablement through the sysfs interface.
> 
> Adam Guerin (1):
>   crypto: qat - preserve ADF_GENERAL_SEC
> 
> Michal Witwicki (4):
>   crypto: qat - disable IOV in adf_dev_stop()
>   crypto: qat - fix recovery flow for VFs
>   crypto: qat - ensure correct order in VF restarting handler
>   crypto: qat - allow disabling SR-IOV VFs
> 
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |   4 +-
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   4 +-
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |   4 +-
>  .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |   4 +-
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |   4 +-
>  drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |   4 +-
>  drivers/crypto/intel/qat/qat_common/adf_aer.c |   2 +-
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c |  29 +++
>  drivers/crypto/intel/qat/qat_common/adf_cfg.h |   2 +
>  .../intel/qat/qat_common/adf_common_drv.h     |   2 +-
>  .../crypto/intel/qat/qat_common/adf_ctl_drv.c |   6 +-
>  .../crypto/intel/qat/qat_common/adf_init.c    |  44 +---
>  .../intel/qat/qat_common/adf_pfvf_pf_msg.c    |   9 +-
>  .../intel/qat/qat_common/adf_pfvf_vf_msg.c    |  14 ++
>  .../intel/qat/qat_common/adf_pfvf_vf_msg.h    |   1 +
>  .../crypto/intel/qat/qat_common/adf_sriov.c   | 194 ++++++++++++------
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   |   4 +-
>  .../crypto/intel/qat/qat_common/adf_vf_isr.c  |   4 +-
>  .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |   4 +-
>  .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |   4 +-
>  20 files changed, 212 insertions(+), 131 deletions(-)
> 
> 
> base-commit: 64409cf846e03f8372654e3b50cd31644b277f8c
> -- 
> 2.44.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
