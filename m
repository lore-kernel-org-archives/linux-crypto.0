Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEAF36E548;
	Wed, 19 Nov 2025 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567499; cv=none; b=WV19eam8FmKS5+B/KCgh72Wnn2kDO95ddhu4nJzz31fSDcI7Y6y/qObSaNudMhrUJCjnPC3i2LOQSllPPL8IhP9d/+D7nryfzbak7GPJcpNyaCRitKL/BKYKvgcdcEwrbuHE+6x6SfJLWG0nQ3ulpY/4Kv4o7eQHOTP8NWOiz64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567499; c=relaxed/simple;
	bh=1QJF7MRNQ3QQ/LYH7IQvouon6q5fcmP8Q7BoymQVWMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCta//zoCYaRNO1qzU/tpR09jl6dtKww6323O08hR8Nm+m5thaujBV9jMb6md3NpU9jaWAMSHkmYHzy6qGkhaT5Zg+Dke1JcRR+X4L6jyUP0KD4ClW9gXeL8y1rj8FL4o9H2U0VS+1fVbM4g9P10UTHMEf3o8O2TGpZL6W0m7uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3sA7iHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3sA7iHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B42C4AF51;
	Wed, 19 Nov 2025 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763567499;
	bh=1QJF7MRNQ3QQ/LYH7IQvouon6q5fcmP8Q7BoymQVWMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O3sA7iHn4Z2YK1UHXuRcG5qdRzUfpvPxfJwhqW9IgR5PDrkPXN2XlNQEH8mirtAKF
	 NqrfM32u5sTWR4P6GCe4UQfhAqWORAEx657HR/rXXrAGuiJ5IHAc1zm2/Qj4ZJ2OTx
	 WPNydukCJRGavvzthdZ8j112vYrzxUbbmEdcv7YZWjbIu5V3zoucyFGynaMl5u0siG
	 sTF4TkkDsfCIzUDCS8tiePmx5HvKLWQXPuf6QLAnRm+whh356x4l5EaytaRFWSYI91
	 iBDMZImBLqgEsJMgmjx41M8R0Sdy234Wh04FjxazeevJWT7mhzWUy1nJ0V1YhCZquW
	 fiYNoZxJ2uRqQ==
Message-ID: <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
Date: Wed, 19 Nov 2025 16:51:34 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] platform/mellanox/mlxbf_pka: Add userspace PKA
 ring device interface
To: Ron Li <xiangrongl@nvidia.com>, ilpo.jarvinen@linux.intel.com,
 vadimp@nvidia.com, alok.a.tiwari@oracle.com, kblaiech@nvidia.com,
 davthompson@nvidia.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
 <20250919195132.1088515-3-xiangrongl@nvidia.com>
From: Hans de Goede <hansg@kernel.org>
Content-Language: en-US, nl
In-Reply-To: <20250919195132.1088515-3-xiangrongl@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 19-Sep-25 9:51 PM, Ron Li wrote:
> Expose each BlueField PKA ring as a character device for userspace offload.
> This focuses on per-ring resources, layout, and control, without in-kernel
> crypto algorithms.
> 
> - Create ring device nodes and lifecycle: open/close, mmap, ioctl
> - Partition 16KB Window RAM per ring (1KB cmd, 1KB result, 14KB vectors)
> - Program ring info words (cmd/rslt bases, size, host_desc_size, in-order)
> - Provide UAPI ioctls:
>   - MLXBF_PKA_RING_GET_REGION_INFO
>   - MLXBF_PKA_GET_RING_INFO
>   - MLXBF_PKA_CLEAR_RING_COUNTERS
> - ACPI-based probe for BF1/BF2/BF3 and per-shim ring setup
> - Document device/ring identifiers and interface in sysfs ABI

IMHO you really should use the standard hw-accel crypto kernel APIs
for this and not introduce a set of custom ioctls.

I guess an exception can be made if:

1. You can motivate why using the standard hw-accel crypto kernel APIs will
   not work for your use-case; *and*
2. You can get an ack from one of the linux-crypto MAINTAINERs for doing this
   outside of the crypto subsystems.

Sorry, but we cannot merge these patches adding this custom crypto API
under drivers/platform/mellanox without explicit permission to deviate
from the standard crypto APIs by the linux-crypto MAINTAINERs.

Regards,

Hans





> 
> Reviewed-by: David Thompson <davthompson@nvidia.com>
> Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
> Signed-off-by: Ron Li <xiangrongl@nvidia.com>
> ---
>  .../ABI/testing/sysfs-platform-mellanox-pka   |  18 +
>  .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>  drivers/platform/mellanox/mlxbf_pka/Makefile  |   1 +
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        |  40 ++
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        |  23 +
>  .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        | 528 ++++++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_ring.c       | 563 ++++++++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_ring.h       | 255 ++++++++
>  include/uapi/linux/mlxbf-pka.h                |  93 +++
>  9 files changed, 1523 insertions(+)
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.c
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.h
>  create mode 100644 include/uapi/linux/mlxbf-pka.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-platform-mellanox-pka b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
> index cf8dd292c781..e7d331bca8fb 100644
> --- a/Documentation/ABI/testing/sysfs-platform-mellanox-pka
> +++ b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
> @@ -14,3 +14,21 @@ Description:
>  		BlueField-2  MLNXBF20:xx, where xx ranges from '00' to '07'
>  		BlueField-3  MLNXBF51:xx, where xx ranges from '00' to '17'
>  		===========  ==============================================
> +
> +		Each PKA device supports four PKA ring devices. The PKA ring device IDs are:
> +
> +		===========  ==============================================
> +		BlueField-1  MLNXBF11:xx, where xx ranges from '00' to '0F'
> +		BlueField-2  MLNXBF21:xx, where xx ranges from '00' to '20'
> +		BlueField-3  MLNXBF52:xx, where xx ranges from '00' to '60'
> +		===========  ==============================================
> +
> +		For each PKA ring device, the following operation interfaces:
> +
> +		- open(): open the PKA ring device specified by the device ID, and initiate the
> +		  related RAM regions.
> +		- release(): close the PKA ring device specified by the device ID, and release the
> +		  related RAM regions.
> +		- unlocked_ioctl(): make PKA related system calls, including getting ring device or
> +		  RAM region information, clearing PKA ring counter.
> +		- mmap(): map the PKA ring device to the virtual memory region.
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 406a9f4d0869..0bbabf07a495 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -383,6 +383,8 @@ Code  Seq#    Include File                                             Comments
>  0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
>  0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
>                                                                         <mailto:linux-hyperv@vger.kernel.org>
> +0xBF  00-0F  uapi/linux/mlxbf-pka.h                                    NVIDIA BlueField PKA driver
> +
>  0xC0  00-0F  linux/usb/iowarrior.h
>  0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
>  0xCA  10-2F  uapi/misc/ocxl.h
> diff --git a/drivers/platform/mellanox/mlxbf_pka/Makefile b/drivers/platform/mellanox/mlxbf_pka/Makefile
> index 67465a63edb8..6e536794d339 100644
> --- a/drivers/platform/mellanox/mlxbf_pka/Makefile
> +++ b/drivers/platform/mellanox/mlxbf_pka/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_MLXBF_PKA) += mlxbf-pka.o
>  
>  mlxbf-pka-objs := mlxbf_pka_drv.o
>  mlxbf-pka-objs += mlxbf_pka_dev.o
> +mlxbf-pka-objs += mlxbf_pka_ring.o
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
> index 0a5db1be6eaa..12df11dd1eee 100644
> --- a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
> @@ -17,6 +17,7 @@
>  #include <linux/types.h>
>  
>  #include "mlxbf_pka_dev.h"
> +#include "mlxbf_pka_ring.h"
>  
>  struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
>  
> @@ -192,6 +193,18 @@ static int mlxbf_pka_dev_create_shim(struct device *dev,
>  	else
>  		shim->window_ram_split = MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_DISABLED;
>  
> +	shim->ring_type = MLXBF_PKA_RING_TYPE_IN_ORDER;
> +	shim->ring_priority = MLXBF_PKA_RING_OPTIONS_PRIORITY;
> +	shim->rings_num = MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS;
> +	shim->rings = devm_kcalloc(dev,
> +				   shim->rings_num,
> +				   sizeof(struct mlxbf_pka_dev_ring_t),
> +				   GFP_KERNEL);
> +	if (!shim->rings) {
> +		dev_err(dev, "unable to allocate memory for ring\n");
> +		return -ENOMEM;
> +	}
> +
>  	/* Set PKA device Buffer RAM config. */
>  	ret = mlxbf_pka_dev_set_resource_config(dev,
>  						shim,
> @@ -288,10 +301,21 @@ static int mlxbf_pka_dev_init_shim(struct device *dev, struct mlxbf_pka_dev_shim
>  		return -EPERM;
>  	}
>  
> +	/* Configure PKA Ring options control word. */
> +	ret = mlxbf_pka_dev_config_ring_options(dev,
> +						&shim->resources.buffer_ram,
> +						shim->rings_num,
> +						shim->ring_priority);
> +	if (ret) {
> +		dev_err(dev, "failed to configure ring options\n");
> +		return ret;
> +	}
> +
>  	ret = devm_mutex_init(dev, &shim->mutex);
>  	if (ret)
>  		return ret;
>  
> +	shim->busy_ring_num = 0;
>  	shim->status = MLXBF_PKA_SHIM_STATUS_INITIALIZED;
>  
>  	return ret;
> @@ -300,6 +324,7 @@ static int mlxbf_pka_dev_init_shim(struct device *dev, struct mlxbf_pka_dev_shim
>  /* Release a given shim. */
>  static int mlxbf_pka_dev_release_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
>  {
> +	u32 ring_idx;
>  	int ret = 0;
>  
>  	if (shim->status != MLXBF_PKA_SHIM_STATUS_INITIALIZED &&
> @@ -308,6 +333,21 @@ static int mlxbf_pka_dev_release_shim(struct device *dev, struct mlxbf_pka_dev_s
>  		return -EPERM;
>  	}
>  
> +	/*
> +	 * Release rings which belong to the shim. The operating system might
> +	 * release ring devices before shim devices. The global configuration
> +	 * must be checked before proceeding to the release of ring devices.
> +	 */
> +	if (mlxbf_pka_gbl_config.dev_rings_cnt) {
> +		for (ring_idx = 0; ring_idx < shim->rings_num; ring_idx++) {
> +			ret = mlxbf_pka_dev_release_ring(dev, shim->rings[ring_idx]);
> +			if (ret) {
> +				dev_err(dev, "failed to release ring %d\n", ring_idx);
> +				return ret;
> +			}
> +		}
> +	}
> +	shim->busy_ring_num = 0;
>  	shim->status = MLXBF_PKA_SHIM_STATUS_FINALIZED;
>  
>  	return ret;
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> index df51202f79bd..12512850cf79 100644
> --- a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> @@ -14,12 +14,15 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/bits.h>
> +#include <linux/io.h>
>  #include <linux/ioctl.h>
>  #include <linux/mutex.h>
>  #include <linux/sizes.h>
>  #include <linux/types.h>
>  #include <linux/units.h>
>  
> +#include <uapi/linux/mlxbf-pka.h>
> +
>  #define MASTER_CONTROLLER_OUT_OF_RESET 0
>  
>  /* PKA address related definitions. */
> @@ -60,6 +63,11 @@
>  /* The maximum number of PKA shims referred to as IO blocks. */
>  #define MLXBF_PKA_MAX_NUM_IO_BLOCKS 24
>  
> +/* The maximum number of rings supported by the IO block (shim). */
> +#define MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS 4
> +
> +#define MLXBF_PKA_MAX_NUM_RINGS (MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS * MLXBF_PKA_MAX_NUM_IO_BLOCKS)
> +
>  /*
>   * PKA Window RAM parameters.
>   * Define whether to split window RAM during PKA device creation phase.
> @@ -173,16 +181,26 @@ struct mlxbf_pka_dev_mem_res {
>   * struct mlxbf_pka_dev_shim_s - PKA Shim structure
>   * @mem_res: Memory resources
>   * @shim_id: Shim identifier
> + * @rings_num: Number of supported rings (hardware specific)
> + * @rings: Pointer to rings which belong to the shim
> + * @ring_priority: Specify the priority in which rings are handled
> + * @ring_type: Indicates whether the result ring delivers results strictly in-order
>   * @resources: Shim resources
>   * @window_ram_split: If non-zero, the split window RAM scheme is used
> + * @busy_ring_num: Number of active rings (rings in busy state)
>   * @status: Status of the shim
>   * @mutex: Mutex lock for sharing shim
>   */
>  struct mlxbf_pka_dev_shim_s {
>  	struct mlxbf_pka_dev_mem_res mem_res;
>  	u32 shim_id;
> +	u32 rings_num;
> +	struct mlxbf_pka_dev_ring_t **rings;
> +	u8 ring_priority;
> +	u8 ring_type;
>  	struct mlxbf_pka_dev_shim_res_t resources;
>  	u8 window_ram_split;
> +	u32 busy_ring_num;
>  	s8 status;
>  	struct mutex mutex;
>  };
> @@ -205,11 +223,15 @@ struct mlxbf_pka_dev_shim_s {
>  /**
>   * struct mlxbf_pka_dev_gbl_config_t - Platform global configuration structure
>   * @dev_shims_cnt: Number of registered PKA shims
> + * @dev_rings_cnt: Number of registered Rings
>   * @dev_shims: Table of registered PKA shims
> + * @dev_rings: Table of registered Rings
>   */
>  struct mlxbf_pka_dev_gbl_config_t {
>  	u32 dev_shims_cnt;
> +	u32 dev_rings_cnt;
>  	struct mlxbf_pka_dev_shim_s *dev_shims[MLXBF_PKA_MAX_NUM_IO_BLOCKS];
> +	struct mlxbf_pka_dev_ring_t *dev_rings[MLXBF_PKA_MAX_NUM_RINGS];
>  };
>  
>  extern struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
> @@ -279,6 +301,7 @@ static inline void mlxbf_pka_dev_io_write(void __iomem *mem_ptr, u64 mem_off, u6
>   */
>  struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id);
>  
> +/* Unset PKA device resource config - unmap io memory if needed. */
>  void mlxbf_pka_dev_unset_resource_config(struct device *dev,
>  					 struct mlxbf_pka_dev_shim_s *shim,
>  					 struct mlxbf_pka_dev_res_t *res_ptr);
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> index 42bfe30fbe49..a009437e4a48 100644
> --- a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> @@ -21,14 +21,18 @@
>  #include <linux/uaccess.h>
>  
>  #include "mlxbf_pka_dev.h"
> +#include "mlxbf_pka_ring.h"
>  
>  #define MLXBF_PKA_DRIVER_DESCRIPTION		"BlueField PKA driver"
>  
>  #define MLXBF_PKA_DEVICE_ACPIHID_BF1		"MLNXBF10"
> +#define MLXBF_PKA_RING_DEVICE_ACPIHID_BF1	"MLNXBF11"
>  
>  #define MLXBF_PKA_DEVICE_ACPIHID_BF2		"MLNXBF20"
> +#define MLXBF_PKA_RING_DEVICE_ACPIHID_BF2	"MLNXBF21"
>  
>  #define MLXBF_PKA_DEVICE_ACPIHID_BF3		"MLNXBF51"
> +#define MLXBF_PKA_RING_DEVICE_ACPIHID_BF3	"MLNXBF52"
>  
>  #define MLXBF_PKA_DEVICE_ACCESS_MODE	0666
>  #define MLXBF_PKA_DEVICE_RES_CNT	7
> @@ -76,20 +80,33 @@ static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf3_info = {
>  static DEFINE_MUTEX(mlxbf_pka_drv_lock);
>  
>  static u32 mlxbf_pka_device_cnt;
> +static u32 mlxbf_pka_ring_device_cnt;
>  
>  static const char mlxbf_pka_acpihid_bf1[] = MLXBF_PKA_DEVICE_ACPIHID_BF1;
> +static const char mlxbf_pka_ring_acpihid_bf1[] = MLXBF_PKA_RING_DEVICE_ACPIHID_BF1;
>  
>  static const char mlxbf_pka_acpihid_bf2[] = MLXBF_PKA_DEVICE_ACPIHID_BF2;
> +static const char mlxbf_pka_ring_acpihid_bf2[] = MLXBF_PKA_RING_DEVICE_ACPIHID_BF2;
>  
>  static const char mlxbf_pka_acpihid_bf3[] = MLXBF_PKA_DEVICE_ACPIHID_BF3;
> +static const char mlxbf_pka_ring_acpihid_bf3[] = MLXBF_PKA_RING_DEVICE_ACPIHID_BF3;
>  
>  static const struct acpi_device_id mlxbf_pka_drv_acpi_ids[] = {
>  	{ MLXBF_PKA_DEVICE_ACPIHID_BF1, (kernel_ulong_t)&mlxbf_pka_bf1_info, 0, 0 },
> +	{ MLXBF_PKA_RING_DEVICE_ACPIHID_BF1, 0, 0, 0 },
>  	{ MLXBF_PKA_DEVICE_ACPIHID_BF2, (kernel_ulong_t)&mlxbf_pka_bf2_info, 0, 0 },
> +	{ MLXBF_PKA_RING_DEVICE_ACPIHID_BF2, 0, 0, 0 },
>  	{ MLXBF_PKA_DEVICE_ACPIHID_BF3, (kernel_ulong_t)&mlxbf_pka_bf3_info, 0, 0 },
> +	{ MLXBF_PKA_RING_DEVICE_ACPIHID_BF3, 0, 0, 0 },
>  	{},
>  };
>  
> +static struct pka {
> +	struct idr ring_idr;
> +	/* PKA ring device IDR lock mutex. */
> +	struct mutex idr_lock;
> +} pka;
> +
>  struct mlxbf_pka_info {
>  	/* The device this info struct belongs to. */
>  	struct device *dev;
> @@ -105,6 +122,7 @@ struct mlxbf_pka_info {
>  };
>  
>  /* Defines for mlxbf_pka_info->flags. */
> +#define MLXBF_PKA_DRIVER_FLAG_RING_DEVICE 1
>  #define MLXBF_PKA_DRIVER_FLAG_DEVICE 2
>  
>  struct mlxbf_pka_platdata {
> @@ -114,6 +132,53 @@ struct mlxbf_pka_platdata {
>  	spinlock_t lock;
>  };
>  
> +struct mlxbf_pka_ring_region {
> +	u64 off;
> +	u64 addr;
> +	resource_size_t size;
> +	u32 flags;
> +	u32 type;
> +};
> +
> +/* Defines for mlxbf_pka_ring_region->flags. */
> +/* Region supports read. */
> +#define MLXBF_PKA_RING_REGION_FLAG_READ		BIT(0)
> +/* Region supports write. */
> +#define MLXBF_PKA_RING_REGION_FLAG_WRITE	BIT(1)
> +/* Region supports mmap. */
> +#define MLXBF_PKA_RING_REGION_FLAG_MMAP		BIT(2)
> +
> +/* Defines for mlxbf_pka_ring_region->type. */
> +/* Info control/status words. */
> +#define MLXBF_PKA_RING_RES_TYPE_WORDS  1
> +/* Count registers. */
> +#define MLXBF_PKA_RING_RES_TYPE_CNTRS  2
> +/* Window RAM region. */
> +#define MLXBF_PKA_RING_RES_TYPE_MEM    4
> +
> +#define MLXBF_PKA_DRIVER_RING_DEV_MAX  MLXBF_PKA_MAX_NUM_RINGS
> +
> +/* Defines for region index. */
> +#define MLXBF_PKA_RING_REGION_WORDS_IDX		0
> +#define MLXBF_PKA_RING_REGION_CNTRS_IDX		1
> +#define MLXBF_PKA_RING_REGION_MEM_IDX	  2
> +#define MLXBF_PKA_RING_REGION_OFFSET_SHIFT     40
> +#define MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(index) \
> +	((u64)(index) << MLXBF_PKA_RING_REGION_OFFSET_SHIFT)
> +
> +struct mlxbf_pka_ring_device {
> +	struct mlxbf_pka_info *info;
> +	struct device *device;
> +	u32 device_id;
> +	u32 parent_device_id;
> +	/* PKA ring device mutex. */
> +	struct mutex mutex;
> +	struct mlxbf_pka_dev_ring_t *ring;
> +	u32 num_regions;
> +	struct mlxbf_pka_ring_region *regions;
> +	struct miscdevice misc;
> +};
> +
>  #define MLXBF_PKA_DRIVER_DEV_MAX MLXBF_PKA_MAX_NUM_IO_BLOCKS
>  
>  struct mlxbf_pka_device {
> @@ -143,6 +208,338 @@ static int mlxbf_pka_drv_verify_bootup_status(struct device *dev)
>  	return 0;
>  }
>  
> +static int mlxbf_pka_drv_ring_regions_init(struct mlxbf_pka_ring_device *ring_dev)
> +{
> +	struct mlxbf_pka_ring_region *region;
> +	struct mlxbf_pka_dev_ring_t *ring;
> +	struct mlxbf_pka_dev_res_t *res;
> +	u32 num_regions;
> +
> +	ring = ring_dev->ring;
> +	if (!ring || !ring->shim)
> +		return -ENXIO;
> +
> +	num_regions = ring->resources_num;
> +	ring_dev->num_regions = num_regions;
> +	ring_dev->regions = devm_kcalloc(ring_dev->device,
> +					 num_regions,
> +					 sizeof(struct mlxbf_pka_ring_region),
> +					 GFP_KERNEL);
> +	if (!ring_dev->regions)
> +		return -ENOMEM;
> +
> +	/* Information words region. */
> +	res = &ring->resources.info_words;
> +	region = &ring_dev->regions[MLXBF_PKA_RING_REGION_WORDS_IDX];
> +	/* Map offset to the physical address. */
> +	region->off = MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(MLXBF_PKA_RING_REGION_WORDS_IDX);
> +	region->addr = res->base;
> +	region->size = res->size;
> +	region->type = MLXBF_PKA_RING_RES_TYPE_WORDS;
> +	region->flags = MLXBF_PKA_RING_REGION_FLAG_MMAP |
> +			MLXBF_PKA_RING_REGION_FLAG_READ |
> +			MLXBF_PKA_RING_REGION_FLAG_WRITE;
> +
> +	/* Counters registers region. */
> +	res = &ring->resources.counters;
> +	region = &ring_dev->regions[MLXBF_PKA_RING_REGION_CNTRS_IDX];
> +	/* Map offset to the physical address. */
> +	region->off = MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(MLXBF_PKA_RING_REGION_CNTRS_IDX);
> +	region->addr = res->base;
> +	region->size = res->size;
> +	region->type = MLXBF_PKA_RING_RES_TYPE_CNTRS;
> +	region->flags = MLXBF_PKA_RING_REGION_FLAG_MMAP |
> +			MLXBF_PKA_RING_REGION_FLAG_READ |
> +			MLXBF_PKA_RING_REGION_FLAG_WRITE;
> +
> +	/* Window RAM region. */
> +	res = &ring->resources.window_ram;
> +	region = &ring_dev->regions[MLXBF_PKA_RING_REGION_MEM_IDX];
> +	/* Map offset to the physical address. */
> +	region->off = MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(MLXBF_PKA_RING_REGION_MEM_IDX);
> +	region->addr = res->base;
> +	region->size = res->size;
> +	region->type = MLXBF_PKA_RING_RES_TYPE_MEM;
> +	region->flags = MLXBF_PKA_RING_REGION_FLAG_MMAP |
> +			MLXBF_PKA_RING_REGION_FLAG_READ |
> +			MLXBF_PKA_RING_REGION_FLAG_WRITE;
> +
> +	return 0;
> +}
> +
> +static void mlxbf_pka_drv_ring_regions_cleanup(struct mlxbf_pka_ring_device *ring_dev)
> +{
> +	/* Clear PKA ring device regions. */
> +	ring_dev->num_regions = 0;
> +}
> +
> +static int mlxbf_pka_drv_ring_open(void *device_data)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev = device_data;
> +	struct mlxbf_pka_info *info = ring_dev->info;
> +	struct mlxbf_pka_ring_info_t ring_info;
> +	int ret;
> +
> +	dev_dbg(ring_dev->device, "open ring device (device_data:%p)\n", ring_dev);
> +
> +	if (!try_module_get(info->module))
> +		return -ENODEV;
> +
> +	ring_info.ring_id = ring_dev->device_id;
> +	ret = mlxbf_pka_dev_open_ring(ring_dev->device, &ring_info);
> +	if (ret) {
> +		dev_dbg(ring_dev->device, "failed to open ring\n");
> +		goto exit_open_ring;
> +	}
> +
> +	/* Initialize regions. */
> +	ret = mlxbf_pka_drv_ring_regions_init(ring_dev);
> +	if (ret)
> +		goto exit_ring_regions_init;
> +
> +	return 0;
> +
> +exit_ring_regions_init:
> +	mlxbf_pka_dev_close_ring(&ring_info);
> +
> +exit_open_ring:
> +	module_put(info->module);
> +
> +	return ret;
> +}
> +
> +static void mlxbf_pka_drv_ring_release(void *device_data)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev = device_data;
> +	struct mlxbf_pka_info *info = ring_dev->info;
> +	struct mlxbf_pka_ring_info_t ring_info;
> +	int ret;
> +
> +	dev_dbg(ring_dev->device, "release ring device (device_data:%p)\n", ring_dev);
> +
> +	mlxbf_pka_drv_ring_regions_cleanup(ring_dev);
> +
> +	ring_info.ring_id = ring_dev->device_id;
> +	ret = mlxbf_pka_dev_close_ring(&ring_info);
> +	if (ret)
> +		dev_dbg(ring_dev->device, "failed to close ring\n");
> +
> +	module_put(info->module);
> +}
> +
> +static int mlxbf_pka_drv_ring_mmap_region(struct mlxbf_pka_ring_region region,
> +					  struct vm_area_struct *vma)
> +{
> +	u64 req_len, pgoff, req_start;
> +
> +	req_len = vma->vm_end - vma->vm_start;
> +	pgoff = vma->vm_pgoff & ((1U << (MLXBF_PKA_RING_REGION_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	req_start = pgoff << PAGE_SHIFT;
> +
> +	region.size = roundup(region.size, PAGE_SIZE);
> +
> +	if (req_start + req_len > region.size)
> +		return -EINVAL;
> +
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
> +
> +	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, req_len, vma->vm_page_prot);
> +}
> +
> +static int mlxbf_pka_drv_ring_mmap(void *device_data, struct vm_area_struct *vma)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev = device_data;
> +	struct mlxbf_pka_ring_region *region;
> +	unsigned int index;
> +
> +	dev_dbg(ring_dev->device, "mmap device\n");
> +
> +	index = vma->vm_pgoff >> (MLXBF_PKA_RING_REGION_OFFSET_SHIFT - PAGE_SHIFT);
> +
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +	if (index >= ring_dev->num_regions)
> +		return -EINVAL;
> +	if (vma->vm_start & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (vma->vm_end & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	region = &ring_dev->regions[index];
> +
> +	if (!(region->flags & MLXBF_PKA_RING_REGION_FLAG_MMAP))
> +		return -EINVAL;
> +
> +	if (!(region->flags & MLXBF_PKA_RING_REGION_FLAG_READ) && (vma->vm_flags & VM_READ))
> +		return -EINVAL;
> +
> +	if (!(region->flags & MLXBF_PKA_RING_REGION_FLAG_WRITE) && (vma->vm_flags & VM_WRITE))
> +		return -EINVAL;
> +
> +	vma->vm_private_data = ring_dev;
> +
> +	if (region->type & MLXBF_PKA_RING_RES_TYPE_CNTRS ||
> +	    region->type & MLXBF_PKA_RING_RES_TYPE_MEM)
> +		return mlxbf_pka_drv_ring_mmap_region(ring_dev->regions[index], vma);
> +
> +	if (region->type & MLXBF_PKA_RING_RES_TYPE_WORDS)
> +		/* Currently user space is not allowed to access this region. */
> +		return -EINVAL;
> +
> +	return -EINVAL;
> +}
> +
> +static long mlxbf_pka_drv_ring_ioctl(void *device_data, unsigned int cmd, unsigned long arg)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev = device_data;
> +
> +	if (cmd == MLXBF_PKA_RING_GET_REGION_INFO) {
> +		struct mlxbf_pka_dev_region_info info;
> +
> +		info.mem_index = MLXBF_PKA_RING_REGION_MEM_IDX;
> +		info.mem_offset = ring_dev->regions[info.mem_index].off;
> +		info.mem_size = ring_dev->regions[info.mem_index].size;
> +
> +		info.reg_index = MLXBF_PKA_RING_REGION_CNTRS_IDX;
> +		info.reg_offset = ring_dev->regions[info.reg_index].off;
> +		info.reg_size = ring_dev->regions[info.reg_index].size;
> +
> +		if (copy_to_user((void __user *)arg, &info, sizeof(info)))
> +			return -EFAULT;
> +		else
> +			return 0;
> +
> +	} else if (cmd == MLXBF_PKA_GET_RING_INFO) {
> +		struct mlxbf_pka_dev_hw_ring_info *this_ring_info;
> +		struct mlxbf_pka_dev_hw_ring_info  hw_ring_info;
> +
> +		this_ring_info = ring_dev->ring->ring_info;
> +
> +		hw_ring_info.cmd_base = this_ring_info->cmd_base;
> +		hw_ring_info.rslt_base = this_ring_info->rslt_base;
> +		hw_ring_info.size = this_ring_info->size;
> +		hw_ring_info.host_desc_size = this_ring_info->host_desc_size;
> +		hw_ring_info.in_order = this_ring_info->in_order;
> +		hw_ring_info.cmd_rd_ptr = this_ring_info->cmd_rd_ptr;
> +		hw_ring_info.rslt_wr_ptr = this_ring_info->rslt_wr_ptr;
> +		hw_ring_info.cmd_rd_stats = this_ring_info->cmd_rd_ptr;
> +		hw_ring_info.rslt_wr_stats = this_ring_info->rslt_wr_stats;
> +
> +		if (copy_to_user((void __user *)arg, &hw_ring_info, sizeof(hw_ring_info)))
> +			return -EFAULT;
> +		else
> +			return 0;
> +
> +	} else if (cmd == MLXBF_PKA_CLEAR_RING_COUNTERS) {
> +		return mlxbf_pka_dev_clear_ring_counters(ring_dev->ring);
> +	}
> +
> +	return -ENOTTY;
> +}
> +
> +static int mlxbf_pka_drv_open(struct inode *inode, struct file *filep)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev;
> +	int ret;
> +
> +	scoped_guard(mutex, &pka.idr_lock) {
> +		ring_dev = idr_find(&pka.ring_idr, iminor(inode));
> +	}
> +	if (!ring_dev) {
> +		pr_err("mlxbf_pka error: failed to find idr for device\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = mlxbf_pka_drv_ring_open(ring_dev);
> +	if (ret)
> +		return ret;
> +
> +	filep->private_data = ring_dev;
> +	return ret;
> +}
> +
> +static int mlxbf_pka_drv_release(struct inode *inode, struct file *filep)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev = filep->private_data;
> +
> +	filep->private_data = NULL;
> +	mlxbf_pka_drv_ring_release(ring_dev);
> +
> +	return 0;
> +}
> +
> +static int mlxbf_pka_drv_mmap(struct file *filep, struct vm_area_struct *vma)
> +{
> +	return mlxbf_pka_drv_ring_mmap(filep->private_data, vma);
> +}
> +
> +static long mlxbf_pka_drv_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	return mlxbf_pka_drv_ring_ioctl(filep->private_data, cmd, arg);
> +}
> +
> +static const struct file_operations mlxbf_pka_ring_fops = {
> +	.owner = THIS_MODULE,
> +	.open = mlxbf_pka_drv_open,
> +	.release = mlxbf_pka_drv_release,
> +	.unlocked_ioctl = mlxbf_pka_drv_unlocked_ioctl,
> +	.mmap = mlxbf_pka_drv_mmap,
> +};
> +
> +static int mlxbf_pka_drv_add_ring_device(struct mlxbf_pka_ring_device *ring_dev)
> +{
> +	struct device *dev = ring_dev->device;
> +	char name[MLXBF_PKA_DEVICE_NAME_MAX];
> +	int minor_number;
> +	int ret;
> +
> +	scnprintf(name, sizeof(name), MLXBF_PKA_DEVFS_RING_DEVICES, ring_dev->device_id);
> +
> +	ring_dev->misc.minor = MISC_DYNAMIC_MINOR;
> +	ring_dev->misc.name = &name[0];
> +	ring_dev->misc.mode = MLXBF_PKA_DEVICE_ACCESS_MODE;
> +	ring_dev->misc.fops = &mlxbf_pka_ring_fops;
> +
> +	ret = misc_register(&ring_dev->misc);
> +	if (ret) {
> +		dev_err(dev, "ring device registration failed: ret=%d\n", ret);
> +		return ret;
> +	}
> +
> +	scoped_guard(mutex, &pka.idr_lock) {
> +		minor_number = idr_alloc(&pka.ring_idr, ring_dev, ring_dev->misc.minor,
> +					 MINORMASK + 1, GFP_KERNEL);
> +	}
> +	if (minor_number != ring_dev->misc.minor) {
> +		dev_err(dev, "failed to allocate minor number %d\n", ring_dev->misc.minor);
> +		return minor_number;
> +	}
> +
> +	dev_dbg(dev, "ring device minor:%d\n", ring_dev->misc.minor);
> +
> +	return ret;
> +}
> +
> +static struct mlxbf_pka_ring_device *mlxbf_pka_drv_del_ring_device(struct device *dev)
> +{
> +	struct platform_device *pdev = container_of(dev, struct platform_device, dev);
> +	struct mlxbf_pka_platdata *priv = platform_get_drvdata(pdev);
> +	struct mlxbf_pka_info *info = priv->info;
> +	struct mlxbf_pka_ring_device *ring_dev = info->priv;
> +
> +	if (ring_dev) {
> +		scoped_guard(mutex, &pka.idr_lock) {
> +			idr_remove(&pka.ring_idr, ring_dev->misc.minor);
> +		}
> +		misc_deregister(&ring_dev->misc);
> +	}
> +
> +	return ring_dev;
> +}
> +
>  static void mlxbf_pka_drv_get_mem_res(struct mlxbf_pka_device *mlxbf_pka_dev,
>  				      struct mlxbf_pka_dev_mem_res *mem_res,
>  				      u64 wndw_ram_off_mask)
> @@ -230,6 +627,38 @@ static int mlxbf_pka_drv_unregister_device(struct mlxbf_pka_device *mlxbf_pka_de
>  	return mlxbf_pka_dev_unregister_shim(mlxbf_pka_dev->device, mlxbf_pka_dev->shim);
>  }
>  
> +/*
> + * Note: this function must be serialized because it calls
> + * 'mlxbf_pka_dev_register_ring' which manipulates common counters for the PKA
> + * ring devices.
> + */
> +static int mlxbf_pka_drv_register_ring_device(struct mlxbf_pka_ring_device *ring_dev)
> +{
> +	u32 shim_id = ring_dev->parent_device_id;
> +	u32 ring_id = ring_dev->device_id;
> +	int ret;
> +
> +	ret = mlxbf_pka_dev_register_ring(ring_dev->device, ring_id, shim_id, &ring_dev->ring);
> +	if (ret) {
> +		dev_dbg(ring_dev->device, "failed to register ring device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mlxbf_pka_drv_unregister_ring_device(struct mlxbf_pka_ring_device *ring_dev)
> +{
> +	if (!ring_dev)
> +		return;
> +
> +	if (!ring_dev->ring)
> +		return;
> +
> +	dev_dbg(ring_dev->device, "unregister ring device\n");
> +	mlxbf_pka_dev_unregister_ring(ring_dev->device, ring_dev->ring);
> +}
> +
>  static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
>  {
>  	struct mlxbf_pka_drv_plat_info *plat_info;
> @@ -315,6 +744,91 @@ static void mlxbf_pka_drv_remove_device(struct platform_device *pdev)
>  	mlxbf_pka_drv_unregister_device(mlxbf_pka_dev);
>  }
>  
> +static int mlxbf_pka_drv_probe_ring_device(struct mlxbf_pka_info *info)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev;
> +	struct device *dev = info->dev;
> +	int ret;
> +
> +	if (!info)
> +		return -EINVAL;
> +
> +	ring_dev = devm_kzalloc(dev, sizeof(*ring_dev), GFP_KERNEL);
> +	if (!ring_dev)
> +		return -ENOMEM;
> +
> +	if (!mlxbf_pka_ring_device_cnt) {
> +		mutex_init(&pka.idr_lock);
> +		scoped_guard(mutex, &pka.idr_lock) {
> +			/* Only initialize IDR if there is no ring device registered. */
> +			idr_init(&pka.ring_idr);
> +		}
> +	}
> +
> +	scoped_guard(mutex, &mlxbf_pka_drv_lock) {
> +		mlxbf_pka_ring_device_cnt += 1;
> +		if (mlxbf_pka_ring_device_cnt > MLXBF_PKA_DRIVER_RING_DEV_MAX) {
> +			dev_dbg(dev, "cannot support %u ring devices\n", mlxbf_pka_ring_device_cnt);
> +			return -ENOSPC;
> +		}
> +		ring_dev->device_id = mlxbf_pka_ring_device_cnt - 1;
> +		ring_dev->parent_device_id = mlxbf_pka_device_cnt - 1;
> +	}
> +
> +	ring_dev->info = info;
> +	ring_dev->device = dev;
> +	info->flag = MLXBF_PKA_DRIVER_FLAG_RING_DEVICE;
> +	mutex_init(&ring_dev->mutex);
> +
> +	/* Verify PKA bootup status. */
> +	ret = mlxbf_pka_drv_verify_bootup_status(dev);
> +	if (ret)
> +		return ret;
> +
> +	scoped_guard(mutex, &mlxbf_pka_drv_lock) {
> +		/* Add PKA ring device. */
> +		ret = mlxbf_pka_drv_add_ring_device(ring_dev);
> +		if (ret) {
> +			dev_dbg(dev, "failed to add ring device %u\n", ring_dev->device_id);
> +			return ret;
> +		}
> +
> +		/* Register PKA ring device. */
> +		ret = mlxbf_pka_drv_register_ring_device(ring_dev);
> +		if (ret) {
> +			dev_dbg(dev, "failed to register ring device\n");
> +			goto err_register_ring;
> +		}
> +	}
> +
> +	info->priv = ring_dev;
> +
> +	return 0;
> +
> + err_register_ring:
> +	mlxbf_pka_drv_del_ring_device(dev);
> +	return ret;
> +}
> +
> +static void mlxbf_pka_drv_remove_ring_device(struct platform_device *pdev)
> +{
> +	struct mlxbf_pka_ring_device *ring_dev;
> +	struct device *dev = &pdev->dev;
> +
> +	ring_dev = mlxbf_pka_drv_del_ring_device(dev);
> +	if (ring_dev) {
> +		mlxbf_pka_drv_unregister_ring_device(ring_dev);
> +		mlxbf_pka_ring_device_cnt--;
> +	}
> +
> +	if (!mlxbf_pka_ring_device_cnt) {
> +		scoped_guard(mutex, &pka.idr_lock) {
> +			/* Only destroy IDR if there is no ring device registered. */
> +			idr_destroy(&pka.ring_idr);
> +		}
> +	}
> +}
> +
>  static int mlxbf_pka_drv_acpi_probe(struct platform_device *pdev, struct mlxbf_pka_info *info)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -343,6 +857,15 @@ static int mlxbf_pka_drv_acpi_probe(struct platform_device *pdev, struct mlxbf_p
>  			return ret;
>  		}
>  		dev_info(dev, "device probed\n");
> +	} else if (!strcmp(info->acpihid, mlxbf_pka_ring_acpihid_bf1) ||
> +		   !strcmp(info->acpihid, mlxbf_pka_ring_acpihid_bf2) ||
> +		   !strcmp(info->acpihid, mlxbf_pka_ring_acpihid_bf3)) {
> +		ret = mlxbf_pka_drv_probe_ring_device(info);
> +		if (ret) {
> +			dev_dbg(dev, "failed to register ring device\n");
> +			return ret;
> +		}
> +		dev_dbg(dev, "ring device probed\n");
>  	}
>  
>  	return 0;
> @@ -387,6 +910,11 @@ static void mlxbf_pka_drv_remove(struct platform_device *pdev)
>  	struct mlxbf_pka_platdata *priv = platform_get_drvdata(pdev);
>  	struct mlxbf_pka_info *info = priv->info;
>  
> +	if (info->flag == MLXBF_PKA_DRIVER_FLAG_RING_DEVICE) {
> +		dev_info(&pdev->dev, "remove ring device\n");
> +		mlxbf_pka_drv_remove_ring_device(pdev);
> +	}
> +
>  	if (info->flag == MLXBF_PKA_DRIVER_FLAG_DEVICE) {
>  		dev_info(&pdev->dev, "remove PKA device\n");
>  		mlxbf_pka_drv_remove_device(pdev);
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.c
> new file mode 100644
> index 000000000000..2f08975223e9
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.c
> @@ -0,0 +1,563 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
> +// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved.
> +
> +#include <linux/device.h>
> +
> +#include "mlxbf_pka_dev.h"
> +#include "mlxbf_pka_ring.h"
> +
> +/*
> + * Mapping PKA Ring address into Window RAM offset address.
> + *
> + * It converts the ring address, either physical address or virtual address, to
> + * valid address into the Window RAM. This is done using the provided Window RAM
> + * win_base, ring_addr and win_mask parameters. Here, win_base is the actual
> + * physical address of the Window RAM, with the help of win_mask it is reduced
> + * to Window RAM offset within that PKA block. Further, with the help of
> + * ring_addr and ring_size, we arrive at the Window RAM offset address for a
> + * PKA Ring within the given Window RAM.
> + *
> + * The hardware encoded the ring size in 32-bit words, not bytes. Therefore,
> + * the ring size is right-shifted to convert bytes into words.
> + */
> +static inline u64 mlxbf_pka_ring_mem_addr(u64 win_base, u64 win_mask, u64 ring_addr, u64 ring_size)
> +{
> +	return (win_base & win_mask) |
> +	      FIELD_PREP(MLXBF_PKA_WINDOW_RAM_RING_ADDR_MASK, ring_addr) |
> +	      FIELD_PREP(MLXBF_PKA_WINDOW_RAM_RING_SIZE_MASK,
> +			 ((ring_addr & ~(ring_size - 1)) >>
> +			  MLXBF_PKA_WINDOW_RAM_RING_SIZE_SHIFT));
> +}
> +
> +int mlxbf_pka_dev_clear_ring_counters(struct mlxbf_pka_dev_ring_t *ring)
> +{
> +	struct mlxbf_pka_dev_res_t *master_seq_ctrl_ptr;
> +	u64 master_reg_base, master_reg_off;
> +	struct mlxbf_pka_dev_shim_s *shim;
> +	void __iomem *master_reg_ptr;
> +
> +	shim = ring->shim;
> +	master_seq_ctrl_ptr = &shim->resources.master_seq_ctrl;
> +	master_reg_base = master_seq_ctrl_ptr->base;
> +	master_reg_ptr = master_seq_ctrl_ptr->ioaddr;
> +	master_reg_off = mlxbf_pka_dev_get_register_offset(master_reg_base,
> +							   MLXBF_PKA_MASTER_SEQ_CTRL_ADDR);
> +
> +	/* Push the EIP-154 master controller into reset. */
> +	mlxbf_pka_dev_io_write(master_reg_ptr, master_reg_off, MLXBF_PKA_MASTER_SEQ_CTRL_RESET);
> +
> +	/* Clear counters. */
> +	mlxbf_pka_dev_io_write(master_reg_ptr, master_reg_off,
> +			       MLXBF_PKA_MASTER_SEQ_CTRL_CLEAR_COUNTERS);
> +
> +	/* Take the EIP-154 master controller out of reset. */
> +	mlxbf_pka_dev_io_write(master_reg_ptr, master_reg_off, MASTER_CONTROLLER_OUT_OF_RESET);
> +
> +	return 0;
> +}
> +
> +/*
> + * Initialize ring. Set ring parameters and configure ring resources. It returns
> + * 0 on success, a negative error code on failure.
> + */
> +static int mlxbf_pka_dev_init_ring(struct device *dev,
> +				   struct mlxbf_pka_dev_ring_t *ring,
> +				   u32 ring_id,
> +				   struct mlxbf_pka_dev_shim_s *shim)
> +{
> +	struct mlxbf_pka_dev_res_t *ring_window_ram_ptr;
> +	struct mlxbf_pka_dev_res_t *ring_info_words_ptr;
> +	struct mlxbf_pka_dev_res_t *ring_counters_ptr;
> +	u8 window_ram_split;
> +	u32 ring_words_off;
> +	u32 ring_cntrs_off;
> +	u32 ring_mem_base;
> +	u32 ring_mem_off;
> +	u32 shim_ring_id;
> +	int ret;
> +
> +	if (ring->status != MLXBF_PKA_DEV_RING_STATUS_UNDEFINED) {
> +		dev_err(dev, "PKA ring must be undefined\n");
> +		return -EPERM;
> +	}
> +
> +	if (ring_id > MLXBF_PKA_MAX_NUM_RINGS - 1) {
> +		dev_err(dev, "invalid ring identifier\n");
> +		return -EINVAL;
> +	}
> +
> +	ring->ring_id = ring_id;
> +	ring->shim = shim;
> +	ring->resources_num = MLXBF_PKA_MAX_NUM_RING_RESOURCES;
> +	shim_ring_id = ring_id % MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS;
> +	shim->rings[shim_ring_id] = ring;
> +
> +	/* Configure ring information control/status words resource. */
> +	ring_info_words_ptr = &ring->resources.info_words;
> +	ring_words_off = shim_ring_id * MLXBF_PKA_RING_WORDS_SPACING;
> +	ring_info_words_ptr->base = ring_words_off + shim->mem_res.eip154_base +
> +				   MLXBF_PKA_RING_WORDS_ADDR;
> +	ring_info_words_ptr->size = MLXBF_PKA_RING_WORDS_SIZE;
> +	ring_info_words_ptr->type = MLXBF_PKA_DEV_RES_TYPE_MEM;
> +	ring_info_words_ptr->status = MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +	ring_info_words_ptr->name = "MLXBF_PKA_RING_INFO";
> +
> +	/* Configure ring counters registers resource. */
> +	ring_counters_ptr = &ring->resources.counters;
> +	ring_cntrs_off = shim_ring_id * MLXBF_PKA_RING_CNTRS_SPACING;
> +	ring_counters_ptr->base = ring_cntrs_off + shim->mem_res.eip154_base +
> +				 MLXBF_PKA_RING_CNTRS_ADDR;
> +	ring_counters_ptr->size = MLXBF_PKA_RING_CNTRS_SIZE;
> +	ring_counters_ptr->type = MLXBF_PKA_DEV_RES_TYPE_REG;
> +	ring_counters_ptr->status = MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +	ring_counters_ptr->name = "MLXBF_PKA_RING_CNTRS";
> +
> +	/* Configure ring window RAM resource. */
> +	window_ram_split = shim->window_ram_split;
> +	if (window_ram_split == MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED) {
> +		ring_mem_off = shim_ring_id * MLXBF_PKA_RING_MEM_1_SPACING;
> +		ring_mem_base = ring_mem_off + shim->mem_res.alt_wndw_ram_0_base;
> +	} else {
> +		ring_mem_off = shim_ring_id * MLXBF_PKA_RING_MEM_0_SPACING;
> +		ring_mem_base = ring_mem_off + shim->mem_res.wndw_ram_base;
> +	}
> +
> +	ring_window_ram_ptr = &ring->resources.window_ram;
> +	ring_window_ram_ptr->base = ring_mem_base;
> +	ring_window_ram_ptr->size = MLXBF_PKA_RING_MEM_SIZE;
> +	ring_window_ram_ptr->type = MLXBF_PKA_DEV_RES_TYPE_MEM;
> +	ring_window_ram_ptr->status = MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +	ring_window_ram_ptr->name = "MLXBF_PKA_RING_WINDOW";
> +
> +	ring->ring_info = devm_kzalloc(dev, sizeof(*ring->ring_info), GFP_KERNEL);
> +	if (!ring->ring_info)
> +		return -ENOMEM;
> +
> +	ret = devm_mutex_init(dev, &ring->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ring->status = MLXBF_PKA_DEV_RING_STATUS_INITIALIZED;
> +
> +	return 0;
> +}
> +
> +/* Release a given Ring. */
> +int mlxbf_pka_dev_release_ring(struct device *dev, struct mlxbf_pka_dev_ring_t *ring)
> +{
> +	struct mlxbf_pka_dev_shim_s *shim;
> +	u32 shim_ring_id;
> +
> +	if (ring->status == MLXBF_PKA_DEV_RING_STATUS_UNDEFINED)
> +		return 0;
> +
> +	if (ring->status == MLXBF_PKA_DEV_RING_STATUS_BUSY) {
> +		dev_err(dev, "PKA ring is busy\n");
> +		return -EBUSY;
> +	}
> +
> +	shim = ring->shim;
> +
> +	if (shim->status == MLXBF_PKA_SHIM_STATUS_RUNNING) {
> +		dev_err(dev, "PKA shim is running\n");
> +		return -EPERM;
> +	}
> +
> +	mlxbf_pka_dev_unset_resource_config(dev, shim, &ring->resources.info_words);
> +	mlxbf_pka_dev_unset_resource_config(dev, shim, &ring->resources.counters);
> +	mlxbf_pka_dev_unset_resource_config(dev, shim, &ring->resources.window_ram);
> +
> +	ring->status = MLXBF_PKA_DEV_RING_STATUS_UNDEFINED;
> +	shim_ring_id = ring->ring_id % MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS;
> +	shim->rings[shim_ring_id] = NULL;
> +	shim->rings_num--;
> +
> +	return 0;
> +}
> +
> +/*
> + * Partition the window RAM for a given PKA ring. Here we statically divide the
> + * 16K memory region into three partitions: First partition is reserved for
> + * command descriptor ring (1K), second partition is reserved for result
> + * descriptor ring (1K), and the remaining 14K are reserved for vector data.
> + * Through this memory partition scheme, command/result descriptor rings hold a
> + * total of 1KB/64B = 16 descriptors each. The addresses for the rings start at
> + * offset 0x3800. Also note that it is possible to have rings full while the
> + * vector data can support more data, the opposite can also happen, but it is
> + * not suitable. For instance ECC point multiplication requires 8 input vectors
> + * and 2 output vectors, a total of 10 vectors. If each vector has a length of
> + * 24 words (24x4B = 96B), we can process 14KB/960B = 14 operations which is
> + * close to 16 the total descriptors supported by rings. On the other hand,
> + * using 12K vector data region, allows to process only 12 operations, while
> + * rings can hold 32 descriptors (ring usage is significantly low).
> + *
> + * For ECDSA verify, we have 12 vectors which require 1152B, with 14KB we can
> + * handle 12 operations, against 10 operations with 12KB vector data memory. We
> + * believe that the aforementioned memory partition help us to leverage the
> + * trade-off between supported descriptors and required vectors. Note that these
> + * examples give approximative values and does not include buffer word padding
> + * across vectors.
> + *
> + * The function also writes the result descriptor rings base addresses, size and
> + * type. And initialize the read and write pointers and statistics. It returns
> + * 0 on success, a negative error code on failure.
> + *
> + * This function must be called once per ring, at initialization before any
> + * other functions are called.
> + */
> +static int mlxbf_pka_dev_partition_mem(struct mlxbf_pka_dev_ring_t *ring)
> +{
> +	u64 rslt_desc_ring_base;
> +	u64 cmd_desc_ring_base;
> +	u32 cmd_desc_ring_size;
> +	u64 window_ram_base;
> +	u64 window_ram_size;
> +	u32 ring_mem_base;
> +
> +	if (!ring->shim || ring->status != MLXBF_PKA_DEV_RING_STATUS_INITIALIZED)
> +		return -EPERM;
> +
> +	window_ram_base = ring->resources.window_ram.base;
> +	window_ram_size = ring->resources.window_ram.size;
> +	/*
> +	 * Partition ring memory. Give ring pair (cmd descriptor ring and rslt
> +	 * descriptor ring) an equal portion of the memory. The cmd descriptor
> +	 * ring and result descriptor ring are used as "non-overlapping" ring.
> +	 * Currently set aside 1/8 of the window RAM for command and result
> +	 * descriptor rings - giving a total of 1K/64B = 16 descriptors per
> +	 * ring. The remaining memory is "Data Memory" - i.e. memory to hold
> +	 * the command operands and results - also called input/output vectors
> +	 * (in all cases these vectors are just single large integers - often in
> +	 * the range of hundreds to thousands of bits long).
> +	 */
> +	ring_mem_base = window_ram_base + MLXBF_PKA_WINDOW_RAM_DATA_MEM_SIZE;
> +	cmd_desc_ring_size = MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE /
> +			    MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV;
> +	ring->num_cmd_desc = MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE /
> +			    MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV / CMD_DESC_SIZE;
> +	/*
> +	 * The command and result descriptor rings may be placed at different
> +	 * (non-overlapping) locations in Window RAM memory space. PKI command
> +	 * interface: Most of the functionality is defined by the EIP-154 master
> +	 * firmware on the EIP-154 master controller Sequencer.
> +	 */
> +	cmd_desc_ring_base = ring_mem_base;
> +	rslt_desc_ring_base = ring_mem_base + cmd_desc_ring_size;
> +
> +	cmd_desc_ring_base = mlxbf_pka_ring_mem_addr(window_ram_base,
> +						     ring->shim->mem_res.wndw_ram_off_mask,
> +						     cmd_desc_ring_base,
> +						     window_ram_size);
> +	rslt_desc_ring_base = mlxbf_pka_ring_mem_addr(window_ram_base,
> +						      ring->shim->mem_res.wndw_ram_off_mask,
> +						      rslt_desc_ring_base,
> +						      window_ram_size);
> +
> +	/* Fill ring information. */
> +	memset(ring->ring_info, 0, sizeof(*ring->ring_info));
> +
> +	ring->ring_info->cmd_base = cmd_desc_ring_base;
> +	ring->ring_info->rslt_base = rslt_desc_ring_base;
> +	ring->ring_info->size = MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE /
> +				MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV / CMD_DESC_SIZE - 1;
> +	ring->ring_info->host_desc_size = CMD_DESC_SIZE / sizeof(u32);
> +	ring->ring_info->in_order = ring->shim->ring_type;
> +
> +	return 0;
> +}
> +
> +/*
> + * Write the ring base address, ring size and type, and initialize (clear) the
> + * read and write pointers and statistics.
> + */
> +static int mlxbf_pka_dev_write_ring_info(struct device *dev,
> +					 struct mlxbf_pka_dev_res_t *buffer_ram_ptr,
> +					 u8 ring_id,
> +					 u32 ring_cmd_base_val,
> +					 u32 ring_rslt_base_val,
> +					 u32 ring_size_type_val)
> +{
> +	u32 ring_spacing;
> +	u64 word_off;
> +
> +	if (buffer_ram_ptr->status != MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +	    buffer_ram_ptr->type != MLXBF_PKA_DEV_RES_TYPE_MEM)
> +		return -EPERM;
> +
> +	dev_dbg(dev, "writing ring information control/status words\n");
> +
> +	ring_spacing = ring_id * MLXBF_PKA_RING_WORDS_SPACING;
> +
> +	/* Get command descriptors from the Host ring. */
> +	word_off = mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +						 MLXBF_PKA_RING_CMD_BASE_0_ADDR + ring_spacing,
> +						 MLXBF_PKA_BUFFER_RAM_SIZE);
> +	mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, ring_cmd_base_val);
> +
> +	/* Put the result descriptors in the Host ring. */
> +	word_off = mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +						 MLXBF_PKA_RING_RSLT_BASE_0_ADDR + ring_spacing,
> +						 MLXBF_PKA_BUFFER_RAM_SIZE);
> +	mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, ring_rslt_base_val);
> +
> +	/* Write the ring size (number of descriptors) */
> +	word_off = mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +						 MLXBF_PKA_RING_SIZE_TYPE_0_ADDR + ring_spacing,
> +						 MLXBF_PKA_BUFFER_RAM_SIZE);
> +	mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, ring_size_type_val);
> +
> +	/* Write the command and result ring indices. */
> +	word_off = mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +						 MLXBF_PKA_RING_RW_PTRS_0_ADDR + ring_spacing,
> +						 MLXBF_PKA_BUFFER_RAM_SIZE);
> +	mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, 0);
> +
> +	/*
> +	 * Write the ring statistics (two 16-bit counters, one for commands and
> +	 * one for results).
> +	 */
> +	word_off = mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +						 MLXBF_PKA_RING_RW_STAT_0_ADDR + ring_spacing,
> +						 MLXBF_PKA_BUFFER_RAM_SIZE);
> +	mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, 0);
> +
> +	return 0;
> +}
> +
> +/*
> + * Set up the control/status words. Upon a PKI command the EIP-154 master
> + * firmware will read and partially update the ring information.
> + */
> +static int mlxbf_pka_dev_set_ring_info(struct device *dev, struct mlxbf_pka_dev_ring_t *ring)
> +{
> +	u32 ring_cmd_base_val;
> +	u32 ring_rslt_base_val;
> +	u32 ring_size_type_val;
> +	int ret;
> +
> +	/*
> +	 * Ring info configuration MUST be done when the PKA ring is
> +	 * initialized.
> +	 */
> +	if ((ring->shim->status != MLXBF_PKA_SHIM_STATUS_INITIALIZED &&
> +	     ring->shim->status != MLXBF_PKA_SHIM_STATUS_RUNNING &&
> +	     ring->shim->status != MLXBF_PKA_SHIM_STATUS_STOPPED) ||
> +	     ring->status != MLXBF_PKA_DEV_RING_STATUS_INITIALIZED)
> +		return -EPERM;
> +
> +	/* Partition ring memory. */
> +	ret = mlxbf_pka_dev_partition_mem(ring);
> +	if (ret) {
> +		dev_err(dev, "failed to initialize ring memory\n");
> +		return ret;
> +	}
> +
> +	/* Fill ring information. */
> +	ring_cmd_base_val = ring->ring_info->cmd_base;
> +	ring_rslt_base_val = ring->ring_info->rslt_base;
> +	ring_size_type_val = FIELD_PREP(MLXBF_PKA_RING_INFO_IN_ORDER_MASK,
> +					ring->ring_info->in_order);
> +	ring_size_type_val |= FIELD_PREP(MLXBF_PKA_RING_INFO_HOST_DESC_SIZE_MASK,
> +					ring->ring_info->host_desc_size);
> +	ring_size_type_val |= FIELD_PREP(MLXBF_PKA_RING_NUM_CMD_DESC_MASK, ring->num_cmd_desc - 1);
> +
> +	/* Write ring information status/control words in the PKA Buffer RAM. */
> +	ret = mlxbf_pka_dev_write_ring_info(dev,
> +					    &ring->shim->resources.buffer_ram,
> +					    ring->ring_id % MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS,
> +					    ring_cmd_base_val,
> +					    ring_rslt_base_val,
> +					    ring_size_type_val);
> +	if (ret) {
> +		dev_err(dev, "failed to write ring information\n");
> +		return ret;
> +	}
> +
> +	ring->status = MLXBF_PKA_DEV_RING_STATUS_READY;
> +
> +	return ret;
> +}
> +
> +/* Configure ring options. */
> +int mlxbf_pka_dev_config_ring_options(struct device *dev,
> +				      struct mlxbf_pka_dev_res_t *buffer_ram_ptr,
> +				      u32 rings_num,
> +				      u8 ring_priority)
> +{
> +	u64 control_word;
> +	u64 word_off;
> +
> +	if (buffer_ram_ptr->status != MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +	    buffer_ram_ptr->type != MLXBF_PKA_DEV_RES_TYPE_MEM)
> +		return -EPERM;
> +
> +	if (rings_num > MLXBF_PKA_MAX_NUM_RINGS || rings_num < 1) {
> +		dev_err(dev, "invalid rings number\n");
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "configure PKA ring options control word\n");
> +
> +	/*
> +	 * Write MLXBF_PKA_RING_OPTIONS control word located in the
> +	 * MLXBF_PKA_BUFFER_RAM. The value of this word is determined by the
> +	 * PKA I/O block (Shim). Set the number of implemented command/result
> +	 * ring pairs that is available in this EIP-154, encoded as binary
> +	 * value, which is 4.
> +	 */
> +	control_word = FIELD_PREP(MLXBF_PKA_RING_OPTIONS_RING_PRIORITY_MASK, ring_priority) |
> +		       FIELD_PREP(MLXBF_PKA_RING_OPTIONS_RING_NUM_MASK, (rings_num - 1)) |
> +		       FIELD_PREP(MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE_MASK,
> +				  MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE);
> +	word_off = mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +						 MLXBF_PKA_RING_OPTIONS_ADDR,
> +						 MLXBF_PKA_BUFFER_RAM_SIZE);
> +	mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, control_word);
> +
> +	return 0;
> +}
> +
> +/* Return the ring associated with the given identifier. */
> +struct mlxbf_pka_dev_ring_t *mlxbf_pka_dev_get_ring(u32 ring_id)
> +{
> +	return mlxbf_pka_gbl_config.dev_rings[ring_id];
> +}
> +
> +int mlxbf_pka_dev_register_ring(struct device *dev,
> +				u32 ring_id,
> +				u32 shim_id,
> +				struct mlxbf_pka_dev_ring_t **ring)
> +{
> +	struct mlxbf_pka_dev_ring_t *ring_ptr;
> +	struct mlxbf_pka_dev_shim_s *shim;
> +	int ret;
> +
> +	if (!ring)
> +		return -EINVAL;
> +
> +	shim = mlxbf_pka_dev_get_shim(shim_id);
> +	if (!shim)
> +		return -ENODEV;
> +
> +	ring_ptr = devm_kzalloc(dev, sizeof(*ring_ptr), GFP_KERNEL);
> +	if (!ring_ptr)
> +		return -ENOMEM;
> +
> +	ring_ptr->status = MLXBF_PKA_DEV_RING_STATUS_UNDEFINED;
> +
> +	/* Initialize ring. */
> +	ret = mlxbf_pka_dev_init_ring(dev, ring_ptr, ring_id, shim);
> +	if (ret) {
> +		dev_err(dev, "failed to initialize ring %d\n", ring_id);
> +		mlxbf_pka_dev_release_ring(dev, ring_ptr);
> +		return ret;
> +	}
> +
> +	mlxbf_pka_gbl_config.dev_rings[ring_ptr->ring_id] = ring_ptr;
> +	mlxbf_pka_gbl_config.dev_rings_cnt += 1;
> +
> +	*ring = ring_ptr;
> +	return 0;
> +}
> +
> +int mlxbf_pka_dev_unregister_ring(struct device *dev, struct mlxbf_pka_dev_ring_t *ring)
> +{
> +	if (!ring)
> +		return -EINVAL;
> +
> +	mlxbf_pka_gbl_config.dev_rings[ring->ring_id] = NULL;
> +	mlxbf_pka_gbl_config.dev_rings_cnt -= 1;
> +
> +	/* Release ring. */
> +	return mlxbf_pka_dev_release_ring(dev, ring);
> +}
> +
> +/* Syscall to open ring. */
> +static int __mlxbf_pka_dev_open_ring(struct device *dev, u32 ring_id)
> +{
> +	struct mlxbf_pka_dev_shim_s *shim;
> +	struct mlxbf_pka_dev_ring_t *ring;
> +	int ret;
> +
> +	if (!mlxbf_pka_gbl_config.dev_rings_cnt)
> +		return -EPERM;
> +
> +	ring = mlxbf_pka_dev_get_ring(ring_id);
> +	if (!ring || !ring->shim)
> +		return -ENXIO;
> +
> +	shim = ring->shim;
> +
> +	guard(mutex)(&ring->mutex);
> +
> +	if (shim->status == MLXBF_PKA_SHIM_STATUS_UNDEFINED ||
> +	    shim->status == MLXBF_PKA_SHIM_STATUS_CREATED ||
> +	    shim->status == MLXBF_PKA_SHIM_STATUS_FINALIZED)
> +		return -EPERM;
> +
> +	if (ring->status == MLXBF_PKA_DEV_RING_STATUS_BUSY)
> +		return -EBUSY;
> +
> +	if (ring->status != MLXBF_PKA_DEV_RING_STATUS_INITIALIZED)
> +		return -EPERM;
> +
> +	/* Set ring information words. */
> +	ret = mlxbf_pka_dev_set_ring_info(dev, ring);
> +	if (ret) {
> +		dev_err(dev, "failed to set ring information\n");
> +		return -EWOULDBLOCK;
> +	}
> +
> +	if (!shim->busy_ring_num)
> +		shim->status = MLXBF_PKA_SHIM_STATUS_RUNNING;
> +
> +	ring->status = MLXBF_PKA_DEV_RING_STATUS_BUSY;
> +	shim->busy_ring_num += 1;
> +
> +	return ret;
> +}
> +
> +/* Open ring. */
> +int mlxbf_pka_dev_open_ring(struct device *dev, struct mlxbf_pka_ring_info_t *ring_info)
> +{
> +	return __mlxbf_pka_dev_open_ring(dev, ring_info->ring_id);
> +}
> +
> +/* Syscall to close ring. */
> +static int __mlxbf_pka_dev_close_ring(u32 ring_id)
> +{
> +	struct mlxbf_pka_dev_shim_s *shim;
> +	struct mlxbf_pka_dev_ring_t *ring;
> +
> +	if (!mlxbf_pka_gbl_config.dev_rings_cnt)
> +		return -EPERM;
> +
> +	ring = mlxbf_pka_dev_get_ring(ring_id);
> +	if (!ring || !ring->shim)
> +		return -ENXIO;
> +
> +	shim = ring->shim;
> +
> +	guard(mutex)(&ring->mutex);
> +
> +	if (shim->status != MLXBF_PKA_SHIM_STATUS_RUNNING &&
> +	    ring->status != MLXBF_PKA_DEV_RING_STATUS_BUSY)
> +		return -EPERM;
> +
> +	ring->status = MLXBF_PKA_DEV_RING_STATUS_INITIALIZED;
> +	shim->busy_ring_num -= 1;
> +
> +	if (!shim->busy_ring_num)
> +		shim->status = MLXBF_PKA_SHIM_STATUS_STOPPED;
> +
> +	return 0;
> +}
> +
> +/* Close ring. */
> +int mlxbf_pka_dev_close_ring(struct mlxbf_pka_ring_info_t *ring_info)
> +{
> +	if (ring_info)
> +		return __mlxbf_pka_dev_close_ring(ring_info->ring_id);
> +
> +	return 0;
> +}
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.h b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.h
> new file mode 100644
> index 000000000000..f5be406656c0
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.h
> @@ -0,0 +1,255 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
> +/* SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved. */
> +
> +#ifndef __MLXBF_PKA_RING_H__
> +#define __MLXBF_PKA_RING_H__
> +
> +/* PKA ring device related definitions. */
> +#define CMD_DESC_SIZE 64
> +
> +/**
> + * struct mlxbf_pka_ring_desc_t - PKA command/result ring descriptor
> + * @num_descs: Total number of descriptors in the ring
> + * @cmd_ring_base: Base address of the command ring
> + * @cmd_idx: Index of the command in a ring
> + * @rslt_ring_base: Base address of the result ring
> + * @rslt_idx: Index of the result in a ring
> + * @operands_base: Operands memory base address
> + * @operands_end: End address of operands memory
> + * @desc_size: Size of each element in the ring
> + * @cmd_desc_mask: Bitmask of free(0)/in_use(1) cmd descriptors
> + * @cmd_desc_cnt: Number of command descriptors currently in use
> + * @rslt_desc_cnt: Number of result descriptors currently ready
> + *
> + * Describes the PKA command/result ring as used by the hardware. A pair of
> + * command and result rings in PKA window memory, and the data memory used by
> + * the commands.
> + */
> +struct mlxbf_pka_ring_desc_t {
> +	u32 num_descs;
> +	u32 cmd_ring_base;
> +	u32 cmd_idx;
> +	u32 rslt_ring_base;
> +	u32 rslt_idx;
> +	u32 operands_base;
> +	u32 operands_end;
> +	u32 desc_size;
> +	u64 cmd_desc_mask;
> +	u32 cmd_desc_cnt;
> +	u32 rslt_desc_cnt;
> +};
> +
> +/**
> + * struct mlxbf_pka_ring_info_t - Ring parameters for user interface
> + * @fd: File descriptor
> + * @group: Iommu group
> + * @container: VFIO container
> + * @idx: Ring index
> + * @ring_id: Hardware ring identifier
> + * @mem_off: Offset specific to window RAM region
> + * @mem_addr: Window RAM region address
> + * @mem_size: Window RAM region size
> + * @reg_off: Offset specific to count registers region
> + * @reg_addr: Count registers region address
> + * @reg_size: Count registers region size
> + * @mem_ptr: Pointer to mapped memory region
> + * @reg_ptr: Pointer to mapped counters region
> + * @ring_desc: Ring descriptor
> + * @big_endian: Big endian byte order when enabled
> + *
> + * This structure declares ring parameters which can be used by user interface.
> + */
> +struct mlxbf_pka_ring_info_t {
> +	int fd;
> +	int group;
> +	int container;
> +	u32 idx;
> +	u32 ring_id;
> +	u64 mem_off;
> +	u64 mem_addr;
> +	u64 mem_size;
> +	u64 reg_off;
> +	u64 reg_addr;
> +	u64 reg_size;
> +	void *mem_ptr;
> +	void *reg_ptr;
> +	struct mlxbf_pka_ring_desc_t ring_desc;
> +	u8 big_endian;
> +};
> +
> +/* ring_info related definitions. */
> +#define MLXBF_PKA_RING_INFO_IN_ORDER_MASK      GENMASK(31, 31)
> +#define MLXBF_PKA_RING_INFO_HOST_DESC_SIZE_MASK	GENMASK(27, 18)
> +#define MLXBF_PKA_RING_NUM_CMD_DESC_MASK	GENMASK(15, 0)
> +
> +/* Ring option related definitions. */
> +#define MLXBF_PKA_RING_OPTIONS_RING_PRIORITY_MASK      GENMASK(7, 0)
> +#define MLXBF_PKA_RING_OPTIONS_RING_NUM_MASK	   GENMASK(15, 8)
> +#define MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE_MASK     GENMASK(31, 24)
> +
> +/*
> + * Ring CSRs: these are all accessed from the ARM using 8 byte reads/writes.
> + * However only the bottom 32 bits are implemented.
> + */
> +/* Ring 0 CSRS. */
> +#define MLXBF_PKA_COMMAND_COUNT_0_ADDR 0x80080
> +
> +/* Ring 0. */
> +#define MLXBF_PKA_RING_CMD_BASE_0_ADDR 0x00000
> +#define MLXBF_PKA_RING_RSLT_BASE_0_ADDR 0x00010
> +#define MLXBF_PKA_RING_SIZE_TYPE_0_ADDR 0x00020
> +#define MLXBF_PKA_RING_RW_PTRS_0_ADDR  0x00028
> +#define MLXBF_PKA_RING_RW_STAT_0_ADDR  0x00030
> +
> +/* Ring Options. */
> +#define MLXBF_PKA_RING_OPTIONS_ADDR    0x07FF8
> +
> +/*
> + * Resources are regions which include info control/status words, count
> + * registers and host window RAM.
> + */
> +#define MLXBF_PKA_MAX_NUM_RING_RESOURCES 3
> +
> +/*
> + * PKA Ring resources.
> + * Define Ring resources parameters including base address, size (in bytes)
> + * and ring spacing.
> + */
> +#define MLXBF_PKA_RING_WORDS_ADDR MLXBF_PKA_BUFFER_RAM_BASE
> +#define MLXBF_PKA_RING_CNTRS_ADDR MLXBF_PKA_COMMAND_COUNT_0_ADDR
> +
> +#define MLXBF_PKA_RING_WORDS_SIZE      SZ_64
> +#define MLXBF_PKA_RING_CNTRS_SIZE      SZ_32
> +#define MLXBF_PKA_RING_MEM_SIZE		SZ_16K
> +
> +#define MLXBF_PKA_RING_WORDS_SPACING   SZ_64
> +#define MLXBF_PKA_RING_CNTRS_SPACING   SZ_64K
> +#define MLXBF_PKA_RING_MEM_0_SPACING   SZ_16K
> +#define MLXBF_PKA_RING_MEM_1_SPACING   SZ_64K
> +
> +/* Defines for window RAM partition, valid for 16K memory. */
> +#define MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE     SZ_2K
> +#define MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV      2 /* Divide into halves. */
> +#define MLXBF_PKA_WINDOW_RAM_RING_ADDR_MASK    GENMASK(15, 0)
> +#define MLXBF_PKA_WINDOW_RAM_RING_SIZE_MASK    GENMASK(19, 16)
> +#define MLXBF_PKA_WINDOW_RAM_RING_SIZE_SHIFT   2
> +
> +/*
> + * MLXBF_PKA_RING_OPTIONS_PRIORITY field to specify the priority in which rings
> + * are handled. In this implementation, the priority is full rotating priority,
> + * with the value of 0x0.
> + */
> +#define MLXBF_PKA_RING_OPTIONS_PRIORITY	0x0
> +
> +/*
> + * 'Signature' byte used because the ring options are transferred through RAM
> + * which does not have a defined reset value. The EIP-154 master controller
> + * keeps reading the MLXBF_PKA_RING_OPTIONS word at start-up until the
> + * 'Signature' byte contains 0x46 and the 'Reserved' field contains zero.
> + */
> +#define MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE 0x46
> +
> +/*
> + * Order of the result reporting: two schemas are available:
> + *  InOrder - the results will be reported in the same order as the commands
> + *	    were provided.
> + *  OutOfOrder - the results are reported as soon as they are available.
> + * Note: only the OutOfOrder schema is used in this implementation.
> + */
> +#define MLXBF_PKA_RING_TYPE_OUT_OF_ORDER_BIT   0
> +#define MLXBF_PKA_RING_TYPE_IN_ORDER	   MLXBF_PKA_RING_TYPE_OUT_OF_ORDER_BIT
> +
> +/* PKA device related definitions. */
> +#define MLXBF_PKA_DEVFS_RING_DEVICES "mlxbf_pka/%d"
> +
> +/**
> + * struct mlxbf_pka_dev_ring_res_t - PKA Ring resources structure
> + * @info_words: Ring information words
> + * @counters: Ring counters
> + * @window_ram: Window RAM
> + */
> +struct mlxbf_pka_dev_ring_res_t {
> +	struct mlxbf_pka_dev_res_t info_words;
> +	struct mlxbf_pka_dev_res_t counters;
> +	struct mlxbf_pka_dev_res_t window_ram;
> +};
> +
> +/**
> + * struct mlxbf_pka_dev_ring_t - PKA Ring structure
> + * @ring_id: Ring identifier
> + * @shim: Pointer to the shim associated to the ring
> + * @resources_num: Number of ring resources
> + * @resources: Ring resources
> + * @ring_info: Ring information
> + * @num_cmd_desc: Number of command descriptors
> + * @status: Status of the ring
> + * @mutex: Mutex lock for sharing ring device
> + */
> +struct mlxbf_pka_dev_ring_t {
> +	u32 ring_id;
> +	struct mlxbf_pka_dev_shim_s *shim;
> +	u32 resources_num;
> +	struct mlxbf_pka_dev_ring_res_t resources;
> +	struct mlxbf_pka_dev_hw_ring_info *ring_info;
> +	u32 num_cmd_desc;
> +	s8 status;
> +	struct mutex mutex;
> +};
> +
> +/* Defines for mlxbf_pka_dev_ring->status. */
> +#define MLXBF_PKA_DEV_RING_STATUS_UNDEFINED    -1
> +#define MLXBF_PKA_DEV_RING_STATUS_INITIALIZED  1
> +#define MLXBF_PKA_DEV_RING_STATUS_READY		2
> +#define MLXBF_PKA_DEV_RING_STATUS_BUSY	 3
> +
> +/*
> + * Ring getter for mlxbf_pka_dev_gbl_config_t structure which holds all system
> + * global configuration. This configuration is shared and common to kernel
> + * device driver associated with PKA hardware.
> + */
> +struct mlxbf_pka_dev_ring_t *mlxbf_pka_dev_get_ring(u32 ring_id);
> +
> +/* Configure ring options. */
> +int mlxbf_pka_dev_config_ring_options(struct device *dev,
> +				      struct mlxbf_pka_dev_res_t *buffer_ram_ptr,
> +				      u32 rings_num,
> +				      u8 ring_priority);
> +
> +				      /* Release a given Ring. */
> +int mlxbf_pka_dev_release_ring(struct device *dev, struct mlxbf_pka_dev_ring_t *ring);
> +
> +/*
> + * Register a ring. This function initializes a Ring and configures its related
> + * resources, and returns the error code.
> + */
> +int mlxbf_pka_dev_register_ring(struct device *dev,
> +				u32 ring_id,
> +				u32 shim_id,
> +				struct mlxbf_pka_dev_ring_t **ring);
> +
> +/* Unregister a Ring. */
> +int mlxbf_pka_dev_unregister_ring(struct device *dev, struct mlxbf_pka_dev_ring_t *ring);
> +
> +/* Reset a Ring. */
> +int mlxbf_pka_dev_reset_ring(struct mlxbf_pka_dev_ring_t *ring);
> +
> +/*
> + * Clear ring counters. This function resets the master sequencer controller to
> + * clear the command and result counters.
> + */
> +int mlxbf_pka_dev_clear_ring_counters(struct mlxbf_pka_dev_ring_t *ring);
> +
> +/*
> + * Open the file descriptor associated with ring. It returns an integer value,
> + * which is used to refer to the file. If not successful, it returns a negative
> + * error.
> + */
> +int mlxbf_pka_dev_open_ring(struct device *dev, struct mlxbf_pka_ring_info_t *ring_info);
> +
> +/*
> + * Close the file descriptor associated with ring. The function returns 0 if
> + * successful, negative value to indicate an error.
> + */
> +int mlxbf_pka_dev_close_ring(struct mlxbf_pka_ring_info_t *ring_info);
> +
> +#endif /* __MLXBF_PKA_RING_H__ */
> diff --git a/include/uapi/linux/mlxbf-pka.h b/include/uapi/linux/mlxbf-pka.h
> new file mode 100644
> index 000000000000..9da6c1e5044b
> --- /dev/null
> +++ b/include/uapi/linux/mlxbf-pka.h
> @@ -0,0 +1,93 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved. */
> +
> +#ifndef _UAPI_LINUX_MLXBF_PKA_H
> +#define _UAPI_LINUX_MLXBF_PKA_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +/* PKA IOCTL related definitions. */
> +#define MLXBF_PKA_IOC_TYPE 0xBF
> +
> +/**
> + * struct mlxbf_pka_dev_region_info - Device region information
> + * @reg_index: Registers region index
> + * @reg_size: Registers region size (bytes)
> + * @reg_offset: Registers region offset from start of device fd
> + * @mem_index: Memory region index
> + * @mem_size: Memory region size (bytes)
> + * @mem_offset: Memory region offset from start of device fd
> + *
> + * MLXBF_PKA_RING_GET_REGION_INFO:
> + * _IOWR(MLXBF_PKA_IOC_TYPE, 0x0, mlxbf_pka_dev_region_info).
> + *
> + * Retrieve information about a device region. This is intended to describe
> + * MMIO, I/O port, as well as bus specific regions (ex. PCI config space). Zero
> + * sized regions may be used to describe unimplemented regions.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct mlxbf_pka_dev_region_info {
> +	__u32 reg_index;
> +	__u64 reg_size;
> +	__u64 reg_offset;
> +	__u32 mem_index;
> +	__u64 mem_size;
> +	__u64 mem_offset;
> +};
> +
> +#define MLXBF_PKA_RING_GET_REGION_INFO \
> +	_IOWR(MLXBF_PKA_IOC_TYPE, 0x0, struct mlxbf_pka_dev_region_info)
> +
> +/**
> + * struct mlxbf_pka_dev_hw_ring_info - Bluefield specific ring information
> + * @cmd_base: Base address of the command descriptor ring
> + * @rslt_base: Base address of the result descriptor ring
> + * @size: Size of a command ring in number of descriptors, minus 1. Minimum
> + *	value is 0 (for 1 descriptor); maximum value is 65535 (for 64K
> + *	descriptors)
> + * @host_desc_size: This field specifies the size (in 32-bit words) of the space
> + *		  that PKI command and result descriptor occupies on the Host
> + * @in_order: Indicates whether the result ring delivers results strictly
> + *	    in-order ('1') or that result descriptors are written to the
> + *	    result ring as soon as they become available, or out-of-order ('0')
> + * @cmd_rd_ptr: Read pointer of the command descriptor ring
> + * @rslt_wr_ptr: Write pointer of the result descriptor ring
> + * @cmd_rd_stats: Read statistics of the command descriptor ring
> + * @rslt_wr_stats: Write statistics of the result descriptor ring
> + *
> + * MLXBF_PKA_GET_RING_INFO:
> + * _IOWR(MLXBF_PKA_IOC_TYPE, 0x1, mlxbf_pka_dev_hw_ring_info).
> + *
> + * Retrieve information about a ring. This is intended to describe ring
> + * information words located in MLXBF_PKA_BUFFER_RAM. Ring information
> + * includes base addresses, size and statistics.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct mlxbf_pka_dev_hw_ring_info {
> +	__u64 cmd_base;
> +	__u64 rslt_base;
> +	__u16 size;
> +	__u16 host_desc_size : 10;
> +	__u8 in_order : 1;
> +	__u16 cmd_rd_ptr;
> +	__u16 rslt_wr_ptr;
> +	__u16 cmd_rd_stats;
> +	__u16 rslt_wr_stats;
> +};
> +
> +#define MLXBF_PKA_GET_RING_INFO _IOWR(MLXBF_PKA_IOC_TYPE, 0x1, struct mlxbf_pka_dev_hw_ring_info)
> +
> +/**
> + * MLXBF_PKA_CLEAR_RING_COUNTERS:
> + * _IO(MLXBF_PKA_IOC_TYPE, 0x2).
> + *
> + * Clear counters. This is intended to reset all command and result counters.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +#define MLXBF_PKA_CLEAR_RING_COUNTERS _IO(MLXBF_PKA_IOC_TYPE, 0x2)
> +
> +#endif /* _UAPI_LINUX_MLXBF_PKA_H */

