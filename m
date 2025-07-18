Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E142BE7D5
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 11:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837173; cv=none; b=KGFte/zIwp39bIK8JhzMN4DsyDIBTy0HlMeM9zCu8hshYaAYnQN5sYTGHjUB9V5+jnZwH9Bp28U4x8Tr76v53/+md0FoNZ79hsHpz0PEMZRdQ0h9jSu9LFZwjEWIq6/TVMClbmoM82i/3S0OoiJXJsLjjwt+7M99kqDecOkrlPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837173; c=relaxed/simple;
	bh=CQL5OswgIXZKwyJDClLtF0Odp2YQH8GWb65HZRY3XvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBnu75ids2A7YsZFXjESNvkn3Ygx+StJHy7xqvbYy3ohucUtGI4/7KNZmKqkB7M9QHNBTYjePpaAqjKXnajHzYIgbbJMBaPZY3xsgLHA5wYO09Q2PuMZ0qnzYiHkxYFG5JGxh4Or83sLX7giDwhTfE/CWX4WQcHFSwq/TZeSgLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=h0U4VYJK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="h0U4VYJK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pZak1Mka8hh/24346CzvJaj9wYXYBpu7k0zZRYhuDz0=; b=h0U4VYJK9ykNOD7xxFt12ieKcV
	RAE41xz8yfRUbT8qUEqvV72YJ9q/IIQ4vyujsM0iVDhIIPD2GlMluRf2MzWjlvE/yZ+xZr00ClgMg
	4d2S/rLPCk+5KX0bhhRCIdPf84+a8xVaVnoTZGdJ/dkFQaROtXGEgTzSGul8Ge27biJ5hJ4itU43r
	jf1jpRG1Y0OuYQ59zxbcxtumfsIUK/9k3qq3cNXYjXu2WXEXIWNTxVieINA4mi7BdUirDu/48Xrqd
	3mDar5ZDYoI2ubfnmLfu7GHDEi673BBfzaREeUiDwNwZxBDAGqomFhHUfLeQpKUtD+2oLDRCFnkyQ
	B+TD/e7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciln-007ymq-1g;
	Fri, 18 Jul 2025 19:12:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:12:47 +1000
Date: Fri, 18 Jul 2025 21:12:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/8] crypto: qat - add rate limiting (RL) support for
 GEN6 devices
Message-ID: <aHosL1deFQ0vUiLU@gondor.apana.org.au>
References: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>

On Thu, Jul 10, 2025 at 02:33:39PM +0100, Suman Kumar Chakraborty wrote:
> This patch set introduces and extends the rate limiting (RL) infrastructure
> in the Intel QAT (QuickAssist Technology) driver, with a focus on enabling
> RL support for QAT GEN6 devices and enhancing support for decompression
> service.
> 
> The series begins by enforcing service validation in the RL sysfs API to
> prevent misconfiguration. It then adds decompression (DECOMP) service,
> including its enumeration and visibility via sysfs. Subsequently, service
> enums are refactored and consolidated to remove duplication and clearly
> differentiate between base and extended services.
> 
> Further patches improve modularity by relocating is_service_enabled() into
> the appropriate C file, introduce a flexible mechanism using
> adf_rl_get_num_svc_aes() and get_svc_slice_cnt() APIs, and implement these
> for both GEN4 and GEN6 platforms. Additionally, the compression slice count
> (cpr_cnt) is now cached for use within the RL infrastructure.
> 
> Finally, the series enables full RL support for GEN6 by initializing the
> rl_data and implementing platform-specific logic to query acceleration
> engines and slice counts for QAT GEN6 hardware.
> 
> Summary of Changes:
> 
> Patch #1 Validates service in RL sysfs API.
> Patch #2 Adds decompression (DECOMP) service to RL to enable SLA support for
> 	 DECOMP where supported (e.g., GEN6).
> Patch #3 Consolidated the service enums.
> Patch #4 Relocates the is_service_enabled() function to improve modularity and
> 	 aligns code structure.
> Patch #5 Adds adf_rl_get_num_svc_aes() to enable querying number of engines per
> 	 service.
> Patch #6 Adds get_svc_slice_cnt() to device data to generalizes AE count lookup.
> Patch #7 Adds compression slice count tracking.
> Patch #8 Enables RL for GEN6.
> 
> Suman Kumar Chakraborty (8):
>   crypto: qat - validate service in rate limiting sysfs api
>   crypto: qat - add decompression service for rate limiting
>   crypto: qat - consolidate service enums
>   crypto: qat - relocate service related functions
>   crypto: qat - add adf_rl_get_num_svc_aes() in rate limiting
>   crypto: qat - add get_svc_slice_cnt() in device data structure
>   crypto: qat - add compression slice count for rate limiting
>   crypto: qat - enable rate limiting feature for GEN6 devices
> 
>  Documentation/ABI/testing/sysfs-driver-qat_rl | 14 +--
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |  9 +-
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  9 +-
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 77 ++++++++++++++++-
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     | 20 +++++
>  .../intel/qat/qat_common/adf_accel_devices.h  |  2 +
>  .../intel/qat/qat_common/adf_cfg_services.c   | 40 ++++++++-
>  .../intel/qat/qat_common/adf_cfg_services.h   | 12 ++-
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 42 ++++++++-
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |  3 +
>  drivers/crypto/intel/qat/qat_common/adf_rl.c  | 86 ++++++-------------
>  drivers/crypto/intel/qat/qat_common/adf_rl.h  | 11 +--
>  .../intel/qat/qat_common/adf_rl_admin.c       |  1 +
>  .../intel/qat/qat_common/adf_sysfs_rl.c       | 21 +++--
>  14 files changed, 251 insertions(+), 96 deletions(-)
> 
> 
> base-commit: db689623436f9f8b87c434285a4bdbf54b0f86d2
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
