Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBAD24A061
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746447934; cv=none; b=CnPjaWTAlyC9Ljqzymbe3x98vqE0N64tK3OgydsrBgMwfssIUdqdiXjPQY2I3MN+1A9vgEftKv0wKeCrMo/OXnEQo489ocj9yUUAhUFbqr2vcDvzxP/owNb7GCy6K7cmJIBIN2VFi5qd/qmKGH+JwfWEZyIrFXV9JfwVuczD7eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746447934; c=relaxed/simple;
	bh=QfHPC8RL31uBHL4ODC6O5vJH6h/qfhxJAZwev+kBth4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJ8NJN1nOvFnfzKAawipOemqp5Gx3zBVVTWkf0tSXxoRDj/DI03xuQ+NVOBJu9w13FrWc9+SX8rY3dhnXxswTawJF05DprCyFtji18tQ5tTvLZSA2XwRHYjYGheZCIE7B5UpKHuX5HQnL9ICDk2ilPvwPva638ZqFl+8e0H61uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=B1JQSbif; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="B1JQSbif"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OylLUnkwX8RAyf8/t3Fb4FUiYbXaPBj+0xgeqacXRjA=; b=B1JQSbifL5fxxi6jJZokUJTB+6
	pE3jH5sFKV3e3RHin3vJXpBoPtoXwW3yiudB8ZPQq92TpxmpuSypYm+77j1QMC/G//dBbSkFm9PoX
	vtrFZjV8AcWIiisDmuFSnhH2QLRrlnsx3w+ET4ZIG88wuIVkGd95WKogx/TRjoOM9M8jQXgeEQw2j
	zx7t+wtkr6ucldGo8zEmW8qxbr4vE7T3V65J2iO/uYaF+9hidvfqBGWeYBYYuaJv9ucRIIzzbeMc7
	CLct6NAYK7Z0HxCbm/qUJFKE74iDOhtWOkftUJlAP79NVthSnruwtU3QfyiHjeNxswfmYA9L865yA
	DZO+FIug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBusy-003YFh-05;
	Mon, 05 May 2025 20:25:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:25:28 +0800
Date: Mon, 5 May 2025 20:25:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 00/11] crypto: qat - add support for QAT GEN6 devices
Message-ID: <aBiuOArfRAFIbIef@gondor.apana.org.au>
References: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>

On Wed, Apr 30, 2025 at 12:34:42PM +0100, Suman Kumar Chakraborty wrote:
> This patchset adds support for QAT GEN6 devices, the successor to QAT GEN4
> devices, by introducing a new driver, qat_6xxx.
> This initial implementation lays the groundwork for future enhancements that
> will be introduced in subsequent patchsets.
> 
> The first part of the set (patches #1 to #3) reworks and relocates some of the
> existing features from the GEN4 device driver to the qat_common folder so that
> the implementation can be shared between GEN4 and GEN6 device drivers.
> 
> The second part (patches #4 and #5) reworks the firmware loader to support the
> `dual signing method` used by GEN6 devices.
> 
> The third part (patches #6 to #8) exposes symbols that are needed by the
> qat_6xxx driver.
> 
> The fourth part (patches #9 and #10) updates the firmware APIs for GEN6
> devices.
>  
> The last patch (#11) introduces the qat_6xxx driver.
> 
> George Abraham P (1):
>   crypto: qat - rename and relocate timer logic
> 
> Giovanni Cabiddu (1):
>   crypto: qat - export adf_get_service_mask()
> 
> Jack Xu (2):
>   crypto: qat - refactor FW signing algorithm
>   crypto: qat - add GEN6 firmware loader
> 
> Laurent M Coquerel (1):
>   crypto: qat - add qat_6xxx driver
> 
> Suman Kumar Chakraborty (6):
>   crypto: qat - refactor compression template logic
>   crypto: qat - use pr_fmt() in qat uclo.c
>   crypto: qat - expose configuration functions
>   crypto: qat - export adf_init_admin_pm()
>   crypto: qat - update firmware api
>   crypto: qat - add firmware headers for GEN6 devices
> 
>  drivers/crypto/intel/qat/Kconfig              |  12 +
>  drivers/crypto/intel/qat/Makefile             |   1 +
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   7 +-
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   7 +-
>  drivers/crypto/intel/qat/qat_6xxx/Makefile    |   3 +
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 843 ++++++++++++++++++
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     | 148 +++
>  drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   | 224 +++++
>  .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   1 -
>  .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   1 -
>  .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |   1 -
>  .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   1 -
>  drivers/crypto/intel/qat/qat_common/Makefile  |   6 +-
>  .../intel/qat/qat_common/adf_accel_devices.h  |   8 +-
>  .../crypto/intel/qat/qat_common/adf_admin.c   |   1 +
>  .../intel/qat/qat_common/adf_cfg_common.h     |   1 +
>  .../intel/qat/qat_common/adf_cfg_services.c   |   3 +-
>  .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
>  .../qat_common/{adf_gen2_dc.c => adf_dc.c}    |  50 +-
>  drivers/crypto/intel/qat/qat_common/adf_dc.h  |  17 +
>  .../intel/qat/qat_common/adf_fw_config.h      |   1 +
>  .../crypto/intel/qat/qat_common/adf_gen2_dc.h |  10 -
>  .../intel/qat/qat_common/adf_gen2_hw_data.c   |  57 ++
>  .../intel/qat/qat_common/adf_gen2_hw_data.h   |   1 +
>  .../intel/qat/qat_common/adf_gen4_config.c    |   6 +-
>  .../intel/qat/qat_common/adf_gen4_config.h    |   3 +
>  .../crypto/intel/qat/qat_common/adf_gen4_dc.c |  83 --
>  .../crypto/intel/qat/qat_common/adf_gen4_dc.h |  10 -
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   |  70 ++
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |   2 +
>  .../crypto/intel/qat/qat_common/adf_gen6_pm.h |  28 +
>  .../intel/qat/qat_common/adf_gen6_shared.c    |  49 +
>  .../intel/qat/qat_common/adf_gen6_shared.h    |  15 +
>  .../{adf_gen4_timer.c => adf_timer.c}         |  18 +-
>  .../{adf_gen4_timer.h => adf_timer.h}         |  10 +-
>  .../intel/qat/qat_common/icp_qat_fw_comp.h    |  23 +-
>  .../qat/qat_common/icp_qat_fw_loader_handle.h |   1 +
>  .../intel/qat/qat_common/icp_qat_hw_51_comp.h |  99 ++
>  .../qat/qat_common/icp_qat_hw_51_comp_defs.h  | 318 +++++++
>  .../intel/qat/qat_common/icp_qat_uclo.h       |  23 +
>  .../intel/qat/qat_common/qat_comp_algs.c      |   5 +-
>  .../intel/qat/qat_common/qat_compression.c    |   1 -
>  .../intel/qat/qat_common/qat_compression.h    |   1 -
>  drivers/crypto/intel/qat/qat_common/qat_hal.c |   3 +
>  .../crypto/intel/qat/qat_common/qat_uclo.c    | 437 ++++++---
>  .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   1 -
>  .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   1 -
>  47 files changed, 2293 insertions(+), 319 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_6xxx/Makefile
>  create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
>  create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
>  create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
>  rename drivers/crypto/intel/qat/qat_common/{adf_gen2_dc.c => adf_dc.c} (59%)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dc.h
>  delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_dc.h
>  delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.c
>  delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
>  rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.c => adf_timer.c} (78%)
>  rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.h => adf_timer.h} (58%)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h
> 
> 
> base-commit: fef208fd85f67ab4a4552d2d141b3f811ab22f00
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
