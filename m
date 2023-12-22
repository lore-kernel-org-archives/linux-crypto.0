Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92448C1F
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 04:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rGXLy-00DhZ7-25; Fri, 22 Dec 2023 12:41:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Dec 2023 12:41:52 +0800
Date: Fri, 22 Dec 2023 12:41:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jie Wang <jie.wang@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/5] crypto: qat - add support for 420xx devices
Message-ID: <ZYUTkK/x24IfDRem@gondor.apana.org.au>
References: <20231215100147.1703641-1-jie.wang@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215100147.1703641-1-jie.wang@intel.com>

On Fri, Dec 15, 2023 at 05:01:43AM -0500, Jie Wang wrote:
> This set adds support for 420xx devices.
> 
> Compared to 4xxx devices, 420xx devices have more acceleration engines
> (16 service engines and 1 admin) and support the wireless cipher
> algorithms ZUC and Snow 3G.
> 
> Here is a summary of the changes:
> * Patch #1 relocates and renames get_service_enabled() since it is
>   not specific to 4xxx.
> * Patch #2 changes the signature of the function uof_get_num_objs()
>   as it is required by the 420xx driver.
> * Patch #3 moves the common logic between QAT GEN4 accelerators to
>   the intel_qat folder.
> * Patch #4 moves the fw config related structures to a newly created
>   header file.
> * Patch #5 implements the QAT 420xx driver.
> 
> The first 4 patches just refactor the code and do not introduce any
> functional changes.
> 
> Jie Wang (5):
>   crypto: qat - relocate and rename get_service_enabled()
>   crypto: qat - change signature of uof_get_num_objs()
>   crypto: qat - relocate portions of qat_4xxx code
>   crypto: qat - move fw config related structures
>   crypto: qat - add support for 420xx devices
> 
>  drivers/crypto/intel/qat/Kconfig              |  11 +
>  drivers/crypto/intel/qat/Makefile             |   1 +
>  drivers/crypto/intel/qat/qat_420xx/Makefile   |   4 +
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 552 ++++++++++++++++++
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |  55 ++
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c  | 202 +++++++
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 232 ++------
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |  52 --
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 277 +--------
>  drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   5 +-
>  .../intel/qat/qat_common/adf_accel_engine.c   |   2 +-
>  .../intel/qat/qat_common/adf_cfg_common.h     |   1 +
>  .../intel/qat/qat_common/adf_cfg_services.c   |  27 +
>  .../intel/qat/qat_common/adf_cfg_services.h   |   4 +
>  .../intel/qat/qat_common/adf_fw_config.h      |  18 +
>  .../intel/qat/qat_common/adf_gen4_config.c    | 287 +++++++++
>  .../intel/qat/qat_common/adf_gen4_config.h    |  11 +
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 148 +++++
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |  74 +++
>  .../crypto/intel/qat/qat_common/icp_qat_hw.h  |  14 +-
>  .../intel/qat/qat_common/icp_qat_uclo.h       |   2 +-
>  drivers/crypto/intel/qat/qat_common/qat_hal.c |   6 +-
>  .../crypto/intel/qat/qat_common/qat_uclo.c    |   1 +
>  24 files changed, 1457 insertions(+), 530 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_420xx/Makefile
>  create mode 100644 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
>  create mode 100644 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
>  create mode 100644 drivers/crypto/intel/qat/qat_420xx/adf_drv.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_config.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_config.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_config.h
> 
> 
> base-commit: 1ac058e8f5b5adc5e365d72361486922bfbd0cb9
> -- 
> 2.32.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
