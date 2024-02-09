Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DC852F8D
	for <linux-crypto@vger.kernel.org>; Fri,  9 Feb 2024 05:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707454856; cv=none; b=JKlwf6wvvAYuYP+xhaPzeg9hIL8s9eTObMdCu+x68y7O8sRMy93q9qv2OzrTG+F7/znsk+8wx77G8Zd6Bp3jYDqaXxZNtzsr73koXyaK1PcOS5JiU6pO1yHXkaTMWjkjmJ+mhYj6MUUR0d1NBn0y0ioBhQYRc0BDRSkbzEaEl3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707454856; c=relaxed/simple;
	bh=9TmeleTrxoLRRotp5wdlpAYRPwt+NixSXzG6Y2M/sjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m32tgls2X4Plmg8cv1q2+lWw0U1xzRZpm+mGxgFN/u2gAb2CeTIN+GbUeB7bg+NHMKOPHQ5nXqEt7UCNjo7zuwfvfzS8TJq/sW85rGqsKTiq7WuQHLija2er1yFelp/KG4rEAIbwX6vsD2Js8/Ii0UJhwZWLLn2ue6ZzLEGkxP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rYJ0K-00BhhN-0L; Fri, 09 Feb 2024 13:00:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Feb 2024 13:01:01 +0800
Date: Fri, 9 Feb 2024 13:01:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mun Chun Yep <mun.chun.yep@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2 0/9] crypto: qat - improve recovery flows
Message-ID: <ZcWxjVWcl1560gAe@gondor.apana.org.au>
References: <20240202105324.50391-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202105324.50391-1-mun.chun.yep@intel.com>

On Fri, Feb 02, 2024 at 06:53:15PM +0800, Mun Chun Yep wrote:
> This set improves the error recovery flows in the QAT drivers and
> adds a mechanism to test it through an heartbeat simulator.
> 
> When a QAT device reports either a fatal error, or an AER fatal error,
> or fails an heartbeat check, the PF driver sends an error notification to
> the VFs through PFVF comms and if `auto_reset` is enabled then
> the device goes through reset flows for error recovery.
> If SRIOV is enabled when an error is encountered, this is re-enabled after
> the reset cycle is done.
> 
> Changed in v2:
> - Removed redundant default value in Kconfig
> - Removed ccflags define, use the CONFIG option directly in the code
> - Reworked the AER reset and recovery flow
> 
> Damian Muszynski (2):
>   crypto: qat - add heartbeat error simulator
>   crypto: qat - add auto reset on error
> 
> Furong Zhou (3):
>   crypto: qat - add fatal error notify method
>   crypto: qat - disable arbitration before reset
>   crypto: qat - limit heartbeat notifications
> 
> Mun Chun Yep (4):
>   crypto: qat - update PFVF protocol for recovery
>   crypto: qat - re-enable sriov after pf reset
>   crypto: qat - add fatal error notification
>   crypto: qat - improve aer error reset handling
> 
>  Documentation/ABI/testing/debugfs-driver-qat  |  26 ++++
>  Documentation/ABI/testing/sysfs-driver-qat    |  20 +++
>  drivers/crypto/intel/qat/Kconfig              |  14 +++
>  drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 116 +++++++++++++++++-
>  .../intel/qat/qat_common/adf_cfg_strings.h    |   1 +
>  .../intel/qat/qat_common/adf_common_drv.h     |  10 ++
>  .../intel/qat/qat_common/adf_heartbeat.c      |  20 ++-
>  .../intel/qat/qat_common/adf_heartbeat.h      |  21 ++++
>  .../qat/qat_common/adf_heartbeat_dbgfs.c      |  52 ++++++++
>  .../qat/qat_common/adf_heartbeat_inject.c     |  76 ++++++++++++
>  .../intel/qat/qat_common/adf_hw_arbiter.c     |  25 ++++
>  .../crypto/intel/qat/qat_common/adf_init.c    |  12 ++
>  drivers/crypto/intel/qat/qat_common/adf_isr.c |   7 +-
>  .../intel/qat/qat_common/adf_pfvf_msg.h       |   7 +-
>  .../intel/qat/qat_common/adf_pfvf_pf_msg.c    |  64 +++++++++-
>  .../intel/qat/qat_common/adf_pfvf_pf_msg.h    |  21 ++++
>  .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |   8 ++
>  .../intel/qat/qat_common/adf_pfvf_vf_proto.c  |   6 +
>  .../crypto/intel/qat/qat_common/adf_sriov.c   |  38 +++++-
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   |  37 ++++++
>  22 files changed, 571 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
