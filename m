Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34FB64F
	for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2023 03:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rJ3Yw-00FG8u-B2; Fri, 29 Dec 2023 11:29:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Dec 2023 11:29:41 +0800
Date: Fri, 29 Dec 2023 11:29:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2 0/4] crypto: qat - enable telemetry for QAT GEN 4
Message-ID: <ZY49JQyS1w+FFSle@gondor.apana.org.au>
References: <20231222103508.1037442-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231222103508.1037442-1-lucas.segarra.fernandez@intel.com>

On Fri, Dec 22, 2023 at 11:35:04AM +0100, Lucas Segarra Fernandez wrote:
> Expose through debugfs telemetry data for QAT GEN4 devices.
> 
> This allows to gather metrics about the performance and the utilization
> of a QAT device and/or a group of ring pairs. In particular, statistics
> on (1) the utilization of the PCIe channel, (2) address translation and
> device TLB, when SVA is enabled and (3) the internal engines for crypto
> and data compression.
> 
> The device periodically gathers telemetry data from hardware registers
> and writes it into a DMA memory region which is sampled by the driver.
> The driver then uses this data to compute basic metrics on the counters
> and exposes them through debugfs attributes in the folder
> /sys/kernel/debug/qat_<device>_<BDF>/telemetry.
> 
> Here is a summary of the changes:
>  * Patch #1 adds an helper function to math.h to compute the average of
>    values within an array.
>  * Patch #2 includes a missing header in the file adf_accel_devices.h to
>    allow to use the macro GET_DEV().
>  * Patch #3 introduces device level telemetry and the associated documentation
>    in /Documentation/ABI.
>  * Patch #4 extends #3 by introducing ring pair level telemetry and
>    documentation about it.
> 
> This set is based on earlier work done by Wojciech Ziemba.
> 
> ---
> v1 -> v2:
> - define avg_array() in the C file where it is used
> - set `accel_dev->telemetry` to NULL in adf_tl_free_mem()
> - add ring pair service type info to debugfs telemetry/rp_<X>_data output
> ---
> 
> Lucas Segarra Fernandez (4):
>   crypto: qat - include pci.h for GET_DEV()
>   crypto: qat - add admin msgs for telemetry
>   crypto: qat - add support for device telemetry
>   crypto: qat - add support for ring pair level telemetry
> 
>  .../ABI/testing/debugfs-driver-qat_telemetry  | 228 ++++++
>  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   3 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   3 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   3 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   6 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |  37 +
>  .../crypto/intel/qat/qat_common/adf_admin.h   |   4 +
>  .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   3 +
>  .../intel/qat/qat_common/adf_gen4_hw_data.h   |   1 +
>  .../crypto/intel/qat/qat_common/adf_gen4_tl.c | 153 ++++
>  .../crypto/intel/qat/qat_common/adf_gen4_tl.h | 158 ++++
>  .../crypto/intel/qat/qat_common/adf_init.c    |  12 +
>  .../intel/qat/qat_common/adf_telemetry.c      | 288 +++++++
>  .../intel/qat/qat_common/adf_telemetry.h      |  99 +++
>  .../intel/qat/qat_common/adf_tl_debugfs.c     | 710 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_tl_debugfs.h     | 117 +++
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |  10 +
>  17 files changed, 1835 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-driver-qat_telemetry
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_tl.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_telemetry.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_telemetry.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
> 
> 
> base-commit: b4719435c14199548ed49f036a7c31040a6b5353
> -- 
> 2.41.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
