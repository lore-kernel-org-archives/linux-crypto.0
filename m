Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED0034B697;
	Thu,  6 Nov 2025 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762438673; cv=none; b=P+th5hEB5h7WZG8lwaOrPXQseNnrH3X/Dj7B+cgRhJHVjRblZmI8PY7wjkKGZhT9Th8CUAtrbdFcdGMK8Axkl04nDryIijokoWtBHrG9lcarAQhygAr5lTHF+p/h4N+9xfkv228FczsXSYGGEty7rdHQuFQFccJzEGTMR/qM4zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762438673; c=relaxed/simple;
	bh=73BGhvKMNb47QwSIbILtdrmjjwsgEPzmzbHkiobgcPU=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hS4jhF8qxRIyFYvZBsKTDnztFOajoufP+CGz2ujL6IW03qP8LKaMc7Qjo+MTm9eahBeCqWiDwGOp2IK3Ow/rk833kB82/FCf2AR2vmLVOLx/FdMEj9F1eng1fdGsVXiocPqpgAHH0NJta+myBhRCjImJiMkBbHhqsueyqpTKs3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DOGrg8nq; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DOGrg8nq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762438670; x=1793974670;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=73BGhvKMNb47QwSIbILtdrmjjwsgEPzmzbHkiobgcPU=;
  b=DOGrg8nqDCiWtvuPxggXa3hY/r/gMje8raC4LMXnv4V2vIlucfDw9C5d
   ykAFVu3O1lu+RlJc2VAjrfHi9L9jSpg47vBUk5EYpSLChHcVFDab18gyz
   fOzV+VkmJXDhcLX4uJAJ24toeUD0sjvCVgTWFr/aqb+RjFKpdtWIsOry9
   gyOzmIwjyWx2bmsDR8kIPmCOy0cbTXXAf1bdf07LDcmmjD2CqjHQCKKPv
   Iesj4jzaeXxLfh7xGLu0gdxNuWIPpO1zKYfW/lYjKLs6v7d9MJguecgyK
   4BqditKQr+7xIUhbnY+UnebE5E15UhiikYTwCwqIA2kptmmXyq9Chfpvr
   A==;
X-CSE-ConnectionGUID: YTCshfk4QdSzwFdQZh93gQ==
X-CSE-MsgGUID: 9VF4ohBISMebJCHGvQAc9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="74865002"
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="74865002"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 06:17:43 -0800
X-CSE-ConnectionGUID: x8YjcRYUTD+yyJ3HEuVmxQ==
X-CSE-MsgGUID: 6mznVLqERL+KyXah/sALpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="191865011"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.187])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 06:17:38 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 6 Nov 2025 16:17:34 +0200 (EET)
To: Ron Li <xiangrongl@nvidia.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
cc: hdegoede@redhat.com, vadimp@nvidia.com, alok.a.tiwari@oracle.com, 
    kblaiech@nvidia.com, davthompson@nvidia.com, 
    platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] platform/mellanox/mlxbf_pka: Add core BlueField
 PKA platform driver
In-Reply-To: <20250919195132.1088515-2-xiangrongl@nvidia.com>
Message-ID: <8abccdcc-ad40-8f08-457b-d5567aee7083@linux.intel.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com> <20250919195132.1088515-2-xiangrongl@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-493857866-1762435353=:981"
Content-ID: <e2020bbc-5169-460d-3612-ba76a1c3bb1c@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-493857866-1762435353=:981
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <98119786-811a-acf1-6410-643f62d23144@linux.intel.com>

On Fri, 19 Sep 2025, Ron Li wrote:

> Add the initial mlxbf_pka driver to support the BlueField DPU Public Key
> Acceleration (PKA) hardware. The PKA provides a simple, complete framewor=
k
> for crypto public key hardware offload. It supports direct access to the
> public key hardware resources from the user space, and makes available
> several arithmetic operations: some basic operations (e.g., addition and
> multiplication), some complex operations (e.g., modular exponentiation an=
d
> modular inversion), and high-level operations such as RSA, Diffie-Hellman=
,
> Elliptic Curve Cryptography, and the Federal Digital Signature Algorithm
> (DSA as documented in FIPS-186) public-private key systems.

Hi,

Before I spend more time on this, I dug up your earlier reply:

https://lore.kernel.org/all/DS7PR12MB57191E5CCC239A43370B8729A999A@DS7PR12M=
B5719.namprd12.prod.outlook.com/

You stated there:

"This PKA module is a platform-specific implementation that allows user=20
space drivers to read/write the BlueField PKA hardware registers. It=20
doesn=E2=80=99t offer any crypto service to the kernel or implement any cry=
pto=20
API."

Yet, crypto operations ARE provided (to user space), is that correct?

Crypto API also has an user spac interface [1] so to me it looks here=20
you're trying to build another interface that provides user space crypto=20
services but is independent of crypto API?

[1] Documentation/crypto/userspace-if.rst

--
 i.

> This patch wires up the platform driver and the device/shim layer:
>=20
> - ACPI matching for BF1/BF2/BF3 (MLNXBF10/20/51)
> - Probe flow to verify boot status, discover EIP154, Window RAM, alt Wind=
ow RAM,
>   and CSR resources
> - Register a PKA "shim" via the device layer, which maps resources and tr=
acks
>   per-shim state
> - Provide shim lifecycle helpers (register/unregister)
>=20
> This driver is placed under drivers/platform/mellanox as it exposes platf=
orm
> resources and does not provide in-kernel crypto offload.
>=20
> Reviewed-by: David Thompson <davthompson@nvidia.com>
> Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
> Signed-off-by: Ron Li <xiangrongl@nvidia.com>
> ---
>  .../ABI/testing/sysfs-platform-mellanox-pka   |  16 +
>  MAINTAINERS                                   |   8 +
>  drivers/platform/mellanox/Kconfig             |  10 +
>  drivers/platform/mellanox/Makefile            |   1 +
>  drivers/platform/mellanox/mlxbf_pka/Makefile  |  10 +
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        | 395 +++++++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        | 298 +++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        | 413 ++++++++++++++++++
>  8 files changed, 1151 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-mellanox-pka
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/Makefile
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
>=20
> diff --git a/Documentation/ABI/testing/sysfs-platform-mellanox-pka b/Docu=
mentation/ABI/testing/sysfs-platform-mellanox-pka
> new file mode 100644
> index 000000000000..cf8dd292c781
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
> @@ -0,0 +1,16 @@
> +What:=09=09/sys/devices/platform/<pka-device-id>/<pka-ring-device-id>
> +Date:=09=09Oct 2025
> +KernelVersion:=096.18
> +Contact:=09"Ron Li <xiangrongl@nvidia.com>"
> +Description:
> +=09=09The mlxbf_pka driver to support the BlueField SoC Public Key Accel=
eration (PKA)
> +=09=09hardware. It supports direct access to the public key hardware res=
ources from the
> +=09=09user space.
> +
> +=09=09There are three PKA device IDs that support different BlueField pr=
oduct:
> +
> +=09=09=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +=09=09BlueField-1  MLNXBF10:xx, where xx ranges from '00' to '03'
> +=09=09BlueField-2  MLNXBF20:xx, where xx ranges from '00' to '07'
> +=09=09BlueField-3  MLNXBF51:xx, where xx ranges from '00' to '17'
> +=09=09=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f6206963efbf..64b995b16d1a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15755,6 +15755,14 @@ L:=09linux-i2c@vger.kernel.org
>  S:=09Supported
>  F:=09drivers/i2c/busses/i2c-mlxbf.c
> =20
> +MELLANOX BLUEFIELD PKA DRIVER
> +M:=09Ron Li <xiangrongl@nvidia.com>
> +M:=09Khalil Blaiech <kblaiech@nvidia.com>
> +L:=09platform-driver-x86@vger.kernel.org
> +S:=09Supported
> +F:=09Documentation/ABI/testing/sysfs-platform-mellanox-pka
> +F:=09drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_*
> +
>  MELLANOX ETHERNET DRIVER (mlx4_en)
>  M:=09Tariq Toukan <tariqt@nvidia.com>
>  L:=09netdev@vger.kernel.org
> diff --git a/drivers/platform/mellanox/Kconfig b/drivers/platform/mellano=
x/Kconfig
> index e3afbe62c7f6..b09681c137e6 100644
> --- a/drivers/platform/mellanox/Kconfig
> +++ b/drivers/platform/mellanox/Kconfig
> @@ -121,4 +121,14 @@ config NVSW_SN2201
>  =09  C3338R which is one of the Denverton product families.
>  =09  System equipped with Nvidia=C2=AESpectrum-1 32x100GbE Ethernet swit=
ch.
> =20
> +config MLXBF_PKA
> +        tristate "Mellanox BlueField Public Key Accelerator driver"
> +        depends on ARM64 && ACPI
> +        help
> +          If you say yes to this option, support will be included for th=
e
> +          Public Key Accelerator device on Mellanox BlueField SoCs.
> +
> +          This driver can also be built as a module. If so, the module w=
ill
> +          be called pka-mlxbf.
> +
>  endif # MELLANOX_PLATFORM
> diff --git a/drivers/platform/mellanox/Makefile b/drivers/platform/mellan=
ox/Makefile
> index e86723b44c2e..a6535959cde4 100644
> --- a/drivers/platform/mellanox/Makefile
> +++ b/drivers/platform/mellanox/Makefile
> @@ -5,6 +5,7 @@
>  #
>  obj-$(CONFIG_MLX_PLATFORM)=09+=3D mlx-platform.o
>  obj-$(CONFIG_MLXBF_BOOTCTL)=09+=3D mlxbf-bootctl.o
> +obj-$(CONFIG_MLXBF_PKA)=09=09+=3D mlxbf_pka/
>  obj-$(CONFIG_MLXBF_PMC)=09=09+=3D mlxbf-pmc.o
>  obj-$(CONFIG_MLXBF_TMFIFO)=09+=3D mlxbf-tmfifo.o
>  obj-$(CONFIG_MLXREG_DPU)=09+=3D mlxreg-dpu.o
> diff --git a/drivers/platform/mellanox/mlxbf_pka/Makefile b/drivers/platf=
orm/mellanox/mlxbf_pka/Makefile
> new file mode 100644
> index 000000000000..67465a63edb8
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/Makefile
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
> +# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rig=
hts reserved.
> +#
> +# Mellanox BlueField PKA Driver
> +#
> +
> +obj-$(CONFIG_MLXBF_PKA) +=3D mlxbf-pka.o
> +
> +mlxbf-pka-objs :=3D mlxbf_pka_drv.o
> +mlxbf-pka-objs +=3D mlxbf_pka_dev.o
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c b/driver=
s/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
> new file mode 100644
> index 000000000000..0a5db1be6eaa
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
> @@ -0,0 +1,395 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
> +// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All ri=
ghts reserved.
> +
> +#include <linux/bitfield.h>
> +#include <linux/compiler.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/math.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/time.h>
> +#include <linux/timex.h>
> +#include <linux/types.h>
> +
> +#include "mlxbf_pka_dev.h"
> +
> +struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
> +
> +/* Global PKA shim resource info table. */
> +static struct mlxbf_pka_dev_gbl_shim_res_info_t mlxbf_pka_gbl_res_tbl[ML=
XBF_PKA_MAX_NUM_IO_BLOCKS];
> +
> +/* Add the resource to the global resource table. */
> +static int mlxbf_pka_dev_add_resource(struct mlxbf_pka_dev_res_t *res_pt=
r, u32 shim_idx)
> +{
> +=09u8 res_cnt;
> +
> +=09res_cnt =3D mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt;
> +=09if (res_cnt >=3D MLXBF_PKA_DEV_SHIM_RES_CNT)
> +=09=09return -ENOMEM;
> +
> +=09mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_cnt] =3D res_ptr;
> +=09mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt++;
> +
> +=09return 0;
> +}
> +
> +/* Remove the resource from the global resource table. */
> +static int mlxbf_pka_dev_put_resource(struct mlxbf_pka_dev_res_t *res, u=
32 shim_idx)
> +{
> +=09struct mlxbf_pka_dev_res_t *res_ptr;
> +=09u8 res_idx;
> +
> +=09for (res_idx =3D 0; res_idx < MLXBF_PKA_DEV_SHIM_RES_CNT; res_idx++) =
{
> +=09=09res_ptr =3D mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx];
> +=09=09if (!res_ptr || strcmp(res_ptr->name, res->name))
> +=09=09=09continue;
> +
> +=09=09mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx] =3D NULL;
> +=09=09mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt--;
> +=09=09break;
> +=09}
> +
> +=09/*
> +=09 * Check whether the resource shares the same memory map; If so, the =
memory
> +=09 * map shouldn't be released.
> +=09 */
> +=09for (res_idx =3D 0; res_idx < MLXBF_PKA_DEV_SHIM_RES_CNT; res_idx++) =
{
> +=09=09res_ptr =3D mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx];
> +=09=09if (res_ptr && res_ptr->base =3D=3D res->base)
> +=09=09=09return -EBUSY;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static void __iomem *mlxbf_pka_dev_get_resource_ioaddr(u64 res_base, u32=
 shim_idx)
> +{
> +=09struct mlxbf_pka_dev_res_t *res_ptr;
> +=09u8 res_cnt, res_idx;
> +
> +=09res_cnt =3D mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt;
> +=09if (!res_cnt)
> +=09=09return NULL;
> +
> +=09for (res_idx =3D 0; res_idx < res_cnt; res_idx++) {
> +=09=09res_ptr =3D mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx];
> +=09=09if (res_ptr->base =3D=3D res_base)
> +=09=09=09return res_ptr->ioaddr;
> +=09}
> +
> +=09return NULL;
> +}
> +
> +/* Set PKA device resource config and map io memory if needed. */
> +static int mlxbf_pka_dev_set_resource_config(struct device *dev,
> +=09=09=09=09=09     struct mlxbf_pka_dev_shim_s *shim,
> +=09=09=09=09=09     struct mlxbf_pka_dev_res_t *res_ptr,
> +=09=09=09=09=09     u64 res_base,
> +=09=09=09=09=09     u64 res_size,
> +=09=09=09=09=09     u64 res_type,
> +=09=09=09=09=09     char *res_name)
> +{
> +=09if (res_ptr->status =3D=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED)
> +=09=09return -EPERM;
> +
> +=09switch (res_type) {
> +=09case MLXBF_PKA_DEV_RES_TYPE_REG:
> +=09=09res_ptr->base =3D res_base;
> +=09=09break;
> +=09case MLXBF_PKA_DEV_RES_TYPE_MEM:
> +=09=09res_ptr->base =3D shim->mem_res.eip154_base + res_base;
> +=09=09break;
> +=09default:
> +=09=09return -EINVAL;
> +=09}
> +
> +=09res_ptr->size =3D res_size;
> +=09res_ptr->type =3D res_type;
> +=09res_ptr->name =3D res_name;
> +=09res_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +=09res_ptr->ioaddr =3D mlxbf_pka_dev_get_resource_ioaddr(res_ptr->base, =
shim->shim_id);
> +=09if (!res_ptr->ioaddr) {
> +=09=09if (!devm_request_mem_region(dev, res_ptr->base, res_ptr->size, re=
s_ptr->name)) {
> +=09=09=09dev_err(dev, "failed to get io memory region\n");
> +=09=09=09return -EPERM;
> +=09=09}
> +
> +=09=09res_ptr->ioaddr =3D devm_ioremap(dev, res_ptr->base, res_ptr->size=
);
> +=09=09if (!res_ptr->ioaddr) {
> +=09=09=09dev_err(dev, "unable to map io memory into CPU space\n");
> +=09=09=09return -ENOMEM;
> +=09=09}
> +=09}
> +
> +=09res_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_MAPPED;
> +
> +=09if (!res_ptr->ioaddr || mlxbf_pka_dev_add_resource(res_ptr, shim->shi=
m_id)) {
> +=09=09dev_err(dev, "unable to map io memory\n");
> +=09=09return -ENOMEM;
> +=09}
> +
> +=09return 0;
> +}
> +
> +/* Unset PKA device resource config - unmap io memory if needed. */
> +void mlxbf_pka_dev_unset_resource_config(struct device *dev,
> +=09=09=09=09=09 struct mlxbf_pka_dev_shim_s *shim,
> +=09=09=09=09=09 struct mlxbf_pka_dev_res_t *res_ptr)
> +{
> +=09if (res_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED)
> +=09=09return;
> +
> +=09if (!res_ptr->ioaddr)
> +=09=09return;
> +
> +=09if (-EBUSY =3D=3D mlxbf_pka_dev_put_resource(res_ptr, shim->shim_id))
> +=09=09return;
> +
> +=09dev_dbg(dev, "PKA device resource released\n");
> +=09res_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +}
> +
> +/*
> + * mlxbf_pka_dev_create_shim - Create shim.
> + *
> + * Set shim parameters and configure shim resources.
> + *
> + * Return: 0 on success, a negative error code on failure.
> + */
> +static int mlxbf_pka_dev_create_shim(struct device *dev,
> +=09=09=09=09     struct mlxbf_pka_dev_shim_s *shim,
> +=09=09=09=09     u32 shim_id,
> +=09=09=09=09     u8 split,
> +=09=09=09=09     struct mlxbf_pka_dev_mem_res *mem_res)
> +{
> +=09u64 reg_base;
> +=09u64 reg_size;
> +=09int ret;
> +
> +=09if (shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_CREATED)
> +=09=09return 0;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_UNDEFINED) {
> +=09=09dev_err(dev, "PKA device must be undefined\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09if (shim_id > MLXBF_PKA_MAX_NUM_IO_BLOCKS - 1) {
> +=09=09dev_err(dev, "invalid shim identifier\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09shim->shim_id =3D shim_id;
> +=09shim->mem_res =3D *mem_res;
> +
> +=09if (split)
> +=09=09shim->window_ram_split =3D MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED=
;
> +=09else
> +=09=09shim->window_ram_split =3D MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_DISABLE=
D;
> +
> +=09/* Set PKA device Buffer RAM config. */
> +=09ret =3D mlxbf_pka_dev_set_resource_config(dev,
> +=09=09=09=09=09=09shim,
> +=09=09=09=09=09=09&shim->resources.buffer_ram,
> +=09=09=09=09=09=09MLXBF_PKA_BUFFER_RAM_BASE,
> +=09=09=09=09=09=09MLXBF_PKA_BUFFER_RAM_SIZE,
> +=09=09=09=09=09=09MLXBF_PKA_DEV_RES_TYPE_MEM,
> +=09=09=09=09=09=09"MLXBF_PKA_BUFFER_RAM");
> +=09if (ret) {
> +=09=09dev_err(dev, "unable to set Buffer RAM config\n");
> +=09=09return ret;
> +=09}
> +
> +=09/* Set PKA device Master Controller register. */
> +=09reg_size =3D PAGE_SIZE;
> +=09reg_base =3D mlxbf_pka_dev_get_register_base(shim->mem_res.eip154_bas=
e,
> +=09=09=09=09=09=09   MLXBF_PKA_MASTER_SEQ_CTRL_ADDR);
> +=09ret =3D mlxbf_pka_dev_set_resource_config(dev,
> +=09=09=09=09=09=09shim,
> +=09=09=09=09=09=09&shim->resources.master_seq_ctrl,
> +=09=09=09=09=09=09reg_base,
> +=09=09=09=09=09=09reg_size,
> +=09=09=09=09=09=09MLXBF_PKA_DEV_RES_TYPE_REG,
> +=09=09=09=09=09=09"MLXBF_PKA_MASTER_SEQ_CTRL");
> +=09if (ret) {
> +=09=09dev_err(dev, "unable to set Master Controller register config\n");
> +=09=09return ret;
> +=09}
> +
> +=09/* Set PKA device AIC registers. */
> +=09reg_size =3D PAGE_SIZE;
> +=09reg_base =3D mlxbf_pka_dev_get_register_base(shim->mem_res.eip154_bas=
e,
> +=09=09=09=09=09=09   MLXBF_PKA_AIC_POL_CTRL_ADDR);
> +=09ret =3D mlxbf_pka_dev_set_resource_config(dev,
> +=09=09=09=09=09=09shim,
> +=09=09=09=09=09=09&shim->resources.aic_csr,
> +=09=09=09=09=09=09reg_base,
> +=09=09=09=09=09=09reg_size,
> +=09=09=09=09=09=09MLXBF_PKA_DEV_RES_TYPE_REG,
> +=09=09=09=09=09=09"MLXBF_PKA_AIC_CSR");
> +=09if (ret) {
> +=09=09dev_err(dev, "unable to set AIC registers config\n");
> +=09=09return ret;
> +=09}
> +
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_CREATED;
> +
> +=09return ret;
> +}
> +
> +/* Delete shim and unset shim resources. */
> +static int mlxbf_pka_dev_delete_shim(struct device *dev, struct mlxbf_pk=
a_dev_shim_s *shim)
> +{
> +=09struct mlxbf_pka_dev_res_t *res_master_seq_ctrl, *res_aic_csr;
> +=09struct mlxbf_pka_dev_res_t *res_buffer_ram;
> +
> +=09dev_dbg(dev, "PKA device delete shim\n");
> +
> +=09if (shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_UNDEFINED)
> +=09=09return 0;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_FINALIZED &&
> +=09    shim->status !=3D MLXBF_PKA_SHIM_STATUS_CREATED) {
> +=09=09dev_err(dev, "PKA device status must be finalized\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09res_buffer_ram =3D &shim->resources.buffer_ram;
> +=09res_master_seq_ctrl =3D &shim->resources.master_seq_ctrl;
> +=09res_aic_csr =3D &shim->resources.aic_csr;
> +
> +=09mlxbf_pka_dev_unset_resource_config(dev, shim, res_buffer_ram);
> +=09mlxbf_pka_dev_unset_resource_config(dev, shim, res_master_seq_ctrl);
> +=09mlxbf_pka_dev_unset_resource_config(dev, shim, res_aic_csr);
> +
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_UNDEFINED;
> +
> +=09return 0;
> +}
> +
> +/*
> + * Initialize PKA IO block referred to as shim. It configures shim's
> + * parameters and prepares resources by mapping corresponding memory. Th=
e
> + * function also configures shim registers and loads firmware to shim
> + * internal rams. The struct mlxbf_pka_dev_shim_s passed as input is als=
o
> + * an output. It returns 0 on success, a negative error code on failure.
> + */
> +static int mlxbf_pka_dev_init_shim(struct device *dev, struct mlxbf_pka_=
dev_shim_s *shim)
> +{
> +=09int ret;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_CREATED) {
> +=09=09dev_err(dev, "PKA device must be created\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09ret =3D devm_mutex_init(dev, &shim->mutex);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_INITIALIZED;
> +
> +=09return ret;
> +}
> +
> +/* Release a given shim. */
> +static int mlxbf_pka_dev_release_shim(struct device *dev, struct mlxbf_p=
ka_dev_shim_s *shim)
> +{
> +=09int ret =3D 0;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_INITIALIZED &&
> +=09    shim->status !=3D MLXBF_PKA_SHIM_STATUS_STOPPED) {
> +=09=09dev_err(dev, "PKA device must be initialized or stopped\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_FINALIZED;
> +
> +=09return ret;
> +}
> +
> +/* Return the shim associated with the given identifier. */
> +struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id)
> +{
> +=09return mlxbf_pka_gbl_config.dev_shims[shim_id];
> +}
> +
> +int mlxbf_pka_dev_register_shim(struct device *dev,
> +=09=09=09=09u32 shim_id,
> +=09=09=09=09struct mlxbf_pka_dev_mem_res *mem_res,
> +=09=09=09=09struct mlxbf_pka_dev_shim_s **shim)
> +{
> +=09struct mlxbf_pka_dev_shim_s *shim_ptr;
> +=09u8 split;
> +=09int ret;
> +
> +=09if (!shim)
> +=09=09return -EINVAL;
> +
> +=09dev_dbg(dev, "register shim id=3D%u\n", shim_id);
> +
> +=09shim_ptr =3D devm_kzalloc(dev, sizeof(*shim_ptr), GFP_KERNEL);
> +=09if (!shim_ptr)
> +=09=09return -ENOMEM;
> +
> +=09/*
> +=09 * Shim state MUST be set to undefined before calling
> +=09 * 'mlxbf_pka_dev_create_shim' function.
> +=09 */
> +=09shim_ptr->status =3D MLXBF_PKA_SHIM_STATUS_UNDEFINED;
> +
> +=09/* Set the Window RAM user mode. */
> +=09split =3D MLXBF_PKA_SPLIT_WINDOW_RAM_MODE;
> +
> +=09/* Create PKA shim. */
> +=09ret =3D mlxbf_pka_dev_create_shim(dev, shim_ptr, shim_id, split, mem_=
res);
> +=09if (ret) {
> +=09=09dev_err(dev, "failed to create shim %u\n", shim_id);
> +=09=09mlxbf_pka_dev_delete_shim(dev, shim_ptr);
> +=09=09goto exit_create_shim;
> +=09}
> +
> +=09/* Initialize PKA shim. */
> +=09ret =3D mlxbf_pka_dev_init_shim(dev, shim_ptr);
> +=09if (ret) {
> +=09=09dev_err(dev, "failed to init shim %u\n", shim_id);
> +=09=09goto exit_init_shim;
> +=09}
> +
> +=09mlxbf_pka_gbl_config.dev_shims[shim_ptr->shim_id] =3D shim_ptr;
> +=09mlxbf_pka_gbl_config.dev_shims_cnt +=3D 1;
> +
> +=09*shim =3D shim_ptr;
> +=09return 0;
> +
> +exit_init_shim:
> +=09mlxbf_pka_dev_release_shim(dev, shim_ptr);
> +
> +exit_create_shim:
> +=09mlxbf_pka_dev_delete_shim(dev, shim_ptr);
> +=09return ret;
> +}
> +
> +int mlxbf_pka_dev_unregister_shim(struct device *dev, struct mlxbf_pka_d=
ev_shim_s *shim)
> +{
> +=09int ret;
> +
> +=09if (!shim)
> +=09=09return -EINVAL;
> +
> +=09mlxbf_pka_gbl_config.dev_shims[shim->shim_id] =3D NULL;
> +=09mlxbf_pka_gbl_config.dev_shims_cnt -=3D 1;
> +
> +=09/* Release shim. */
> +=09ret =3D mlxbf_pka_dev_release_shim(dev, shim);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Delete shim. */
> +=09return mlxbf_pka_dev_delete_shim(dev, shim);
> +}
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h b/driver=
s/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> new file mode 100644
> index 000000000000..df51202f79bd
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> @@ -0,0 +1,298 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
> +/* SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All ri=
ghts reserved. */
> +
> +#ifndef __MLXBF_PKA_DEV_H__
> +#define __MLXBF_PKA_DEV_H__
> +
> +/*
> + * @file
> + *
> + * API to handle the PKA EIP-154 I/O block (shim). It provides functions=
 and
> + * data structures to initialize and configure the PKA shim. It's the "s=
outhband
> + * interface" for communication with PKA hardware resources.
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +#include <linux/ioctl.h>
> +#include <linux/mutex.h>
> +#include <linux/sizes.h>
> +#include <linux/types.h>
> +#include <linux/units.h>
> +
> +#define MASTER_CONTROLLER_OUT_OF_RESET 0
> +
> +/* PKA address related definitions. */
> +
> +/*
> + * Global Control Space CSR addresses/offsets. These are accessed from t=
he ARM
> + * as 8 byte reads/writes. However only the bottom 32 bits are implement=
ed.
> + */
> +#define MLXBF_PKA_CLK_FORCE_ADDR 0x11C80
> +
> +/*
> + * Advanced Interrupt Controller CSR addresses/offsets. These are access=
ed from
> + * the ARM as 8 byte reads/writes. However only the bottom 32 bits are
> + * implemented.
> + */
> +#define MLXBF_PKA_AIC_POL_CTRL_ADDR 0x11E00
> +
> +/*
> + * Control register address/offset. This is accessed from the ARM using =
8 byte
> + * reads/writes. However only the bottom 32 bits are implemented.
> + */
> +#define MLXBF_PKA_MASTER_SEQ_CTRL_ADDR 0x27F90
> +
> +/* PKA buffer RAM */
> +#define MLXBF_PKA_BUFFER_RAM_BASE 0x00000
> +#define MLXBF_PKA_BUFFER_RAM_SIZE SZ_16K
> +
> +/*
> + * PKA Buffer RAM offsets. These are NOT real CSR's but instead are spec=
ific
> + * offset/addresses within the EIP154 MLXBF_PKA_BUFFER_RAM.
> + */
> +
> +/* Alternate Window RAM size. */
> +#define MLXBF_PKA_WINDOW_RAM_REGION_SIZE SZ_16K
> +
> +/* PKA configuration related definitions. */
> +
> +/* The maximum number of PKA shims referred to as IO blocks. */
> +#define MLXBF_PKA_MAX_NUM_IO_BLOCKS 24
> +
> +/*
> + * PKA Window RAM parameters.
> + * Define whether to split window RAM during PKA device creation phase.
> + */
> +#define MLXBF_PKA_SPLIT_WINDOW_RAM_MODE 0
> +
> +/* Defines for window RAM partition, valid for 16K memory. */
> +#define MLXBF_PKA_WINDOW_RAM_DATA_MEM_SIZE=090x3800 /* 14KB. */
> +
> +/* Window RAM/Alternate window RAM offset mask for BF1 and BF2. */
> +#define MLXBF_PKA_WINDOW_RAM_OFFSET_BF1_BF2_MASK (GENMASK(17, 16) | GENM=
ASK(22, 20))
> +
> +/* Window RAM/Alternate window RAM offset mask for BF3. */
> +#define MLXBF_PKA_WINDOW_RAM_OFFSET_BF3_MASK GENMASK(18, 16)
> +
> +/*
> + * PKA Master Sequencer Control/Status Register.
> + * Writing '1' to bit [31] puts the Master controller Sequencer in a res=
et
> + * state. Resetting the Sequencer (in order to load other firmware) shou=
ld
> + * only be done when the EIP-154 is not performing any operations.
> + */
> +#define MLXBF_PKA_MASTER_SEQ_CTRL_RESET BIT(31)
> +/*
> + * Writing '1' to bit [30] will reset all Command and Result counters. T=
his bit
> + * is write-only and self clearing and can only be set if the 'Reset' bi=
t [31]
> + * is '1'.
> + */
> +#define MLXBF_PKA_MASTER_SEQ_CTRL_CLEAR_COUNTERS BIT(30)
> +
> +/**
> + * struct mlxbf_pka_dev_res_t - Device resource structure
> + * @ioaddr: The (iore)mapped version of addr, driver internal use
> + * @base: Base address of the device's resource
> + * @size: Size of IO
> + * @type: Type of resource addr points to
> + * @status: Status of the resource
> + * @name: Name of the resource
> + */
> +struct mlxbf_pka_dev_res_t {
> +=09void __iomem *ioaddr;
> +=09u64 base;
> +=09u64 size;
> +=09u8 type;
> +=09s8 status;
> +=09char *name;
> +};
> +
> +/* Defines for mlxbf_pka_dev_res->type. */
> +#define MLXBF_PKA_DEV_RES_TYPE_MEM=091 /* Resource type is memory. */
> +#define MLXBF_PKA_DEV_RES_TYPE_REG=092 /* Resource type is register. */
> +
> +/* Defines for mlxbf_pka_dev_res->status. */
> +#define MLXBF_PKA_DEV_RES_STATUS_MAPPED=09=091 /* The resource is (iore)=
mapped. */
> +#define MLXBF_PKA_DEV_RES_STATUS_UNMAPPED=09-1 /* The resource is unmapp=
ed. */
> +
> +/**
> + * struct mlxbf_pka_dev_shim_res_t - PKA Shim resources structure
> + * @buffer_ram: Buffer RAM
> + * @master_seq_ctrl: Master sequencer controller CSR
> + * @aic_csr: Interrupt controller CSRs
> + */
> +struct mlxbf_pka_dev_shim_res_t {
> +=09struct mlxbf_pka_dev_res_t buffer_ram;
> +=09struct mlxbf_pka_dev_res_t master_seq_ctrl;
> +=09struct mlxbf_pka_dev_res_t aic_csr;
> +};
> +
> +/* Number of PKA device resources. */
> +#define MLXBF_PKA_DEV_SHIM_RES_CNT 6
> +
> +/* Platform global shim resource information. */
> +struct mlxbf_pka_dev_gbl_shim_res_info_t {
> +=09struct mlxbf_pka_dev_res_t *res_tbl[MLXBF_PKA_DEV_SHIM_RES_CNT];
> +=09u8 res_cnt;
> +};
> +
> +/**
> + * struct mlxbf_pka_dev_mem_res - PKA device memory resources
> + * @eip154_base: Base address for EIP154 mmio registers
> + * @eip154_size: EIP154 mmio register region size
> + * @wndw_ram_off_mask: Common offset mask for alt window RAM and window =
RAM
> + * @wndw_ram_base: Base address for window RAM
> + * @wndw_ram_size: Window RAM region size
> + * @alt_wndw_ram_0_base: Base address for alternate window RAM 0
> + * @alt_wndw_ram_1_base: Base address for alternate window RAM 1
> + * @alt_wndw_ram_2_base: Base address for alternate window RAM 2
> + * @alt_wndw_ram_3_base: Base address for alternate window RAM 3
> + * @alt_wndw_ram_size: Alternate window RAM regions size
> + * @csr_base: Base address for CSR registers
> + * @csr_size: CSR area size
> + */
> +struct mlxbf_pka_dev_mem_res {
> +=09u64 eip154_base;
> +=09u64 eip154_size;
> +
> +=09u64 wndw_ram_off_mask;
> +=09u64 wndw_ram_base;
> +=09u64 wndw_ram_size;
> +
> +=09u64 alt_wndw_ram_0_base;
> +=09u64 alt_wndw_ram_1_base;
> +=09u64 alt_wndw_ram_2_base;
> +=09u64 alt_wndw_ram_3_base;
> +=09u64 alt_wndw_ram_size;
> +
> +=09u64 csr_base;
> +=09u64 csr_size;
> +};
> +
> +/**
> + * struct mlxbf_pka_dev_shim_s - PKA Shim structure
> + * @mem_res: Memory resources
> + * @shim_id: Shim identifier
> + * @resources: Shim resources
> + * @window_ram_split: If non-zero, the split window RAM scheme is used
> + * @status: Status of the shim
> + * @mutex: Mutex lock for sharing shim
> + */
> +struct mlxbf_pka_dev_shim_s {
> +=09struct mlxbf_pka_dev_mem_res mem_res;
> +=09u32 shim_id;
> +=09struct mlxbf_pka_dev_shim_res_t resources;
> +=09u8 window_ram_split;
> +=09s8 status;
> +=09struct mutex mutex;
> +};
> +
> +/* Defines for mlxbf_pka_dev_shim->status. */
> +#define MLXBF_PKA_SHIM_STATUS_UNDEFINED=09=09-1
> +#define MLXBF_PKA_SHIM_STATUS_CREATED=09=091
> +#define MLXBF_PKA_SHIM_STATUS_INITIALIZED=092
> +#define MLXBF_PKA_SHIM_STATUS_RUNNING=09=093
> +#define MLXBF_PKA_SHIM_STATUS_STOPPED=09=094
> +#define MLXBF_PKA_SHIM_STATUS_FINALIZED=09=095
> +
> +/* Defines for mlxbf_pka_dev_shim->window_ram_split. */
> +
> +/* Window RAM is split into 4 * 16KB blocks. */
> +#define MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED 1
> +/* Window RAM is not split and occupies 64KB. */
> +#define MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_DISABLED 2
> +
> +/**
> + * struct mlxbf_pka_dev_gbl_config_t - Platform global configuration str=
ucture
> + * @dev_shims_cnt: Number of registered PKA shims
> + * @dev_shims: Table of registered PKA shims
> + */
> +struct mlxbf_pka_dev_gbl_config_t {
> +=09u32 dev_shims_cnt;
> +=09struct mlxbf_pka_dev_shim_s *dev_shims[MLXBF_PKA_MAX_NUM_IO_BLOCKS];
> +};
> +
> +extern struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
> +
> +/*
> + * Processor speed in hertz, used in routines which might be called very=
 early
> + * in boot.
> + */
> +static inline u64 mlxbf_pka_early_cpu_speed(void)
> +{
> +=09/*
> +=09 * Initial guess at our CPU speed.  We set this to be larger than any
> +=09 * possible real speed, so that any calculated delays will be too lon=
g,
> +=09 * rather than too short.
> +=09 *
> +=09 * CPU Freq for High/Bin Chip - 1.255GHz.
> +=09 */
> +=09return 1255 * HZ_PER_MHZ;
> +}
> +
> +/* Start a PKA device timer. */
> +static inline u64 mlxbf_pka_dev_timer_start_msec(u32 msec)
> +{
> +=09u64 cur_time =3D get_cycles();
> +
> +=09return cur_time + mlxbf_pka_early_cpu_speed() * msec / MSEC_PER_SEC;
> +}
> +
> +/* Test a PKA device timer for completion. */
> +static inline bool mlxbf_pka_dev_timer_done(u64 timer)
> +{
> +=09return get_cycles() >=3D timer;
> +}
> +
> +/* Return register base address. */
> +static inline u64 mlxbf_pka_dev_get_register_base(u64 base, u64 reg_addr=
)
> +{
> +=09return (base + reg_addr) & PAGE_MASK;
> +}
> +
> +/* Return register offset. */
> +static inline u64 mlxbf_pka_dev_get_register_offset(u64 base, u64 reg_ad=
dr)
> +{
> +=09return (base + reg_addr) & ~PAGE_MASK;
> +}
> +
> +/* Return word offset within io memory. */
> +static inline u64 mlxbf_pka_dev_get_word_offset(u64 mem_base, u64 word_a=
ddr, u64 mem_size)
> +{
> +=09return (mem_base + word_addr) & (mem_size - 1);
> +}
> +
> +static inline u64 mlxbf_pka_dev_io_read(void __iomem *mem_ptr, u64 mem_o=
ff)
> +{
> +=09return readq_relaxed(mem_ptr + mem_off);
> +}
> +
> +static inline void mlxbf_pka_dev_io_write(void __iomem *mem_ptr, u64 mem=
_off, u64 value)
> +{
> +=09writeq_relaxed(value, mem_ptr + mem_off);
> +}
> +
> +/*
> + * Shim getter for mlxbf_pka_dev_gbl_config_t structure which holds all =
system
> + * global configuration. This configuration is shared and common to kern=
el
> + * device driver associated with PKA hardware.
> + */
> +struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id);
> +
> +void mlxbf_pka_dev_unset_resource_config(struct device *dev,
> +=09=09=09=09=09 struct mlxbf_pka_dev_shim_s *shim,
> +=09=09=09=09=09 struct mlxbf_pka_dev_res_t *res_ptr);
> +
> +/*
> + * Register PKA IO block. This function initializes a shim and configure=
s its
> + * related resources, and returns the error code.
> + */
> +int mlxbf_pka_dev_register_shim(struct device *dev,
> +=09=09=09=09u32 shim_id,
> +=09=09=09=09struct mlxbf_pka_dev_mem_res *mem_res,
> +=09=09=09=09struct mlxbf_pka_dev_shim_s **shim);
> +
> +/* Unregister PKA IO block. */
> +int mlxbf_pka_dev_unregister_shim(struct device *dev, struct mlxbf_pka_d=
ev_shim_s *shim);
> +
> +#endif /* __MLXBF_PKA_DEV_H__ */
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c b/driver=
s/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> new file mode 100644
> index 000000000000..42bfe30fbe49
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> @@ -0,0 +1,413 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
> +// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All ri=
ghts reserved.
> +
> +#include <linux/acpi.h>
> +#include <linux/bitfield.h>
> +#include <linux/cdev.h>
> +#include <linux/cleanup.h>
> +#include <linux/device.h>
> +#include <linux/idr.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
> +#include <linux/ioport.h>
> +#include <linux/kdev_t.h>
> +#include <linux/kernel.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +
> +#include "mlxbf_pka_dev.h"
> +
> +#define MLXBF_PKA_DRIVER_DESCRIPTION=09=09"BlueField PKA driver"
> +
> +#define MLXBF_PKA_DEVICE_ACPIHID_BF1=09=09"MLNXBF10"
> +
> +#define MLXBF_PKA_DEVICE_ACPIHID_BF2=09=09"MLNXBF20"
> +
> +#define MLXBF_PKA_DEVICE_ACPIHID_BF3=09=09"MLNXBF51"
> +
> +#define MLXBF_PKA_DEVICE_ACCESS_MODE=090666
> +#define MLXBF_PKA_DEVICE_RES_CNT=097
> +#define MLXBF_PKA_DEVICE_NAME_MAX=0914
> +
> +enum mlxbf_pka_mem_res_idx {
> +=09MLXBF_PKA_ACPI_EIP154_IDX =3D 0,
> +=09MLXBF_PKA_ACPI_WNDW_RAM_IDX,
> +=09MLXBF_PKA_ACPI_ALT_WNDW_RAM_0_IDX,
> +=09MLXBF_PKA_ACPI_ALT_WNDW_RAM_1_IDX,
> +=09MLXBF_PKA_ACPI_ALT_WNDW_RAM_2_IDX,
> +=09MLXBF_PKA_ACPI_ALT_WNDW_RAM_3_IDX,
> +=09MLXBF_PKA_ACPI_CSR_IDX
> +};
> +
> +enum mlxbf_pka_plat_type {
> +=09/* Platform type Bluefield-1. */
> +=09MLXBF_PKA_PLAT_TYPE_BF1 =3D 0,
> +=09/* Platform type Bluefield-2. */
> +=09MLXBF_PKA_PLAT_TYPE_BF2,
> +=09/* Platform type Bluefield-3. */
> +=09MLXBF_PKA_PLAT_TYPE_BF3
> +};
> +
> +struct mlxbf_pka_drv_plat_info {
> +=09enum mlxbf_pka_plat_type type;
> +=09u64 wndw_ram_off_mask;
> +};
> +
> +static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf1_info =3D {
> +=09.type =3D MLXBF_PKA_PLAT_TYPE_BF1,
> +=09.wndw_ram_off_mask =3D MLXBF_PKA_WINDOW_RAM_OFFSET_BF1_BF2_MASK,
> +};
> +
> +static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf2_info =3D {
> +=09.type =3D MLXBF_PKA_PLAT_TYPE_BF2,
> +=09.wndw_ram_off_mask =3D MLXBF_PKA_WINDOW_RAM_OFFSET_BF1_BF2_MASK,
> +};
> +
> +static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf3_info =3D {
> +=09.type =3D MLXBF_PKA_PLAT_TYPE_BF3,
> +=09.wndw_ram_off_mask =3D MLXBF_PKA_WINDOW_RAM_OFFSET_BF3_MASK,
> +};
> +
> +static DEFINE_MUTEX(mlxbf_pka_drv_lock);
> +
> +static u32 mlxbf_pka_device_cnt;
> +
> +static const char mlxbf_pka_acpihid_bf1[] =3D MLXBF_PKA_DEVICE_ACPIHID_B=
F1;
> +
> +static const char mlxbf_pka_acpihid_bf2[] =3D MLXBF_PKA_DEVICE_ACPIHID_B=
F2;
> +
> +static const char mlxbf_pka_acpihid_bf3[] =3D MLXBF_PKA_DEVICE_ACPIHID_B=
F3;
> +
> +static const struct acpi_device_id mlxbf_pka_drv_acpi_ids[] =3D {
> +=09{ MLXBF_PKA_DEVICE_ACPIHID_BF1, (kernel_ulong_t)&mlxbf_pka_bf1_info, =
0, 0 },
> +=09{ MLXBF_PKA_DEVICE_ACPIHID_BF2, (kernel_ulong_t)&mlxbf_pka_bf2_info, =
0, 0 },
> +=09{ MLXBF_PKA_DEVICE_ACPIHID_BF3, (kernel_ulong_t)&mlxbf_pka_bf3_info, =
0, 0 },
> +=09{},
> +};
> +
> +struct mlxbf_pka_info {
> +=09/* The device this info struct belongs to. */
> +=09struct device *dev;
> +=09/* Device name. */
> +=09const char *name;
> +=09/* Device ACPI HID. */
> +=09const char *acpihid;
> +=09/* Device flags. */
> +=09u8 flag;
> +=09struct module *module;
> +=09/* Optional private data. */
> +=09void *priv;
> +};
> +
> +/* Defines for mlxbf_pka_info->flags. */
> +#define MLXBF_PKA_DRIVER_FLAG_DEVICE 2
> +
> +struct mlxbf_pka_platdata {
> +=09struct platform_device *pdev;
> +=09struct mlxbf_pka_info *info;
> +=09/* Generic spinlock. */
> +=09spinlock_t lock;
> +};
> +
> +#define MLXBF_PKA_DRIVER_DEV_MAX MLXBF_PKA_MAX_NUM_IO_BLOCKS
> +
> +struct mlxbf_pka_device {
> +=09struct mlxbf_pka_info *info;
> +=09struct device *device;
> +=09u32 device_id;
> +=09struct resource *resource[MLXBF_PKA_DEVICE_RES_CNT];
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +};
> +
> +static int mlxbf_pka_drv_verify_bootup_status(struct device *dev)
> +{
> +=09const char *bootup_status;
> +=09int ret;
> +
> +=09ret =3D device_property_read_string(dev, "bootup_done", &bootup_statu=
s);
> +=09if (ret < 0) {
> +=09=09dev_err(dev, "failed to read bootup_done property\n");
> +=09=09return ret;
> +=09}
> +
> +=09if (strcmp(bootup_status, "true")) {
> +=09=09dev_err(dev, "device bootup required\n");
> +=09=09return -ENODEV;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static void mlxbf_pka_drv_get_mem_res(struct mlxbf_pka_device *mlxbf_pka=
_dev,
> +=09=09=09=09      struct mlxbf_pka_dev_mem_res *mem_res,
> +=09=09=09=09      u64 wndw_ram_off_mask)
> +{
> +=09enum mlxbf_pka_mem_res_idx acpi_mem_idx;
> +
> +=09acpi_mem_idx =3D MLXBF_PKA_ACPI_EIP154_IDX;
> +=09mem_res->wndw_ram_off_mask =3D wndw_ram_off_mask;
> +
> +=09/* PKA EIP154 MMIO base address. */
> +=09mem_res->eip154_base =3D mlxbf_pka_dev->resource[acpi_mem_idx]->start=
;
> +=09mem_res->eip154_size =3D resource_size(mlxbf_pka_dev->resource[acpi_m=
em_idx]);
> +=09acpi_mem_idx++;
> +
> +=09/* PKA window RAM base address. */
> +=09mem_res->wndw_ram_base =3D mlxbf_pka_dev->resource[acpi_mem_idx]->sta=
rt;
> +=09mem_res->wndw_ram_size =3D resource_size(mlxbf_pka_dev->resource[acpi=
_mem_idx]);
> +=09acpi_mem_idx++;
> +
> +=09/*
> +=09 * PKA alternate window RAM base address.
> +=09 * Note: the size of all the alt window RAM is the same, depicted by
> +=09 * 'alt_wndw_ram_size' variable. All alt window RAM resources are rea=
d
> +=09 * here even though not all of them are used currently.
> +=09 */
> +=09mem_res->alt_wndw_ram_0_base =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]->start;
> +=09mem_res->alt_wndw_ram_size =3D resource_size(mlxbf_pka_dev->resource[=
acpi_mem_idx]);
> +
> +=09if (mem_res->alt_wndw_ram_size !=3D MLXBF_PKA_WINDOW_RAM_REGION_SIZE)
> +=09=09dev_warn(mlxbf_pka_dev->device, "alternate Window RAM size from AC=
PI is wrong.\n");
> +
> +=09acpi_mem_idx++;
> +
> +=09mem_res->alt_wndw_ram_1_base =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]->start;
> +=09acpi_mem_idx++;
> +
> +=09mem_res->alt_wndw_ram_2_base =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]->start;
> +=09acpi_mem_idx++;
> +
> +=09mem_res->alt_wndw_ram_3_base =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]->start;
> +=09acpi_mem_idx++;
> +
> +=09/* PKA CSR base address. */
> +=09mem_res->csr_base =3D mlxbf_pka_dev->resource[acpi_mem_idx]->start;
> +=09mem_res->csr_size =3D resource_size(mlxbf_pka_dev->resource[acpi_mem_=
idx]);
> +}
> +
> +/*
> + * Note: this function must be serialized because it calls
> + * 'mlxbf_pka_dev_register_shim' which manipulates common counters for t=
he
> + * PKA devices.
> + */
> +static int mlxbf_pka_drv_register_device(struct mlxbf_pka_device *mlxbf_=
pka_dev,
> +=09=09=09=09=09 u64 wndw_ram_off_mask)
> +{
> +=09struct mlxbf_pka_dev_mem_res mem_res;
> +=09u32 mlxbf_pka_shim_id;
> +=09int ret;
> +
> +=09/* Assert that the driver lock is held for serialization */
> +=09lockdep_assert_held(&mlxbf_pka_drv_lock);
> +
> +=09mlxbf_pka_shim_id =3D mlxbf_pka_dev->device_id;
> +
> +=09mlxbf_pka_drv_get_mem_res(mlxbf_pka_dev, &mem_res, wndw_ram_off_mask)=
;
> +
> +=09ret =3D mlxbf_pka_dev_register_shim(mlxbf_pka_dev->device,
> +=09=09=09=09=09  mlxbf_pka_shim_id,
> +=09=09=09=09=09  &mem_res,
> +=09=09=09=09=09  &mlxbf_pka_dev->shim);
> +=09if (ret) {
> +=09=09dev_dbg(mlxbf_pka_dev->device, "failed to register shim\n");
> +=09=09return ret;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_unregister_device(struct mlxbf_pka_device *mlxb=
f_pka_dev)
> +{
> +=09if (!mlxbf_pka_dev || !mlxbf_pka_dev->shim)
> +=09=09return -EINVAL;
> +
> +=09dev_dbg(mlxbf_pka_dev->device, "unregister device shim\n");
> +=09return mlxbf_pka_dev_unregister_shim(mlxbf_pka_dev->device, mlxbf_pka=
_dev->shim);
> +}
> +
> +static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
> +{
> +=09struct mlxbf_pka_drv_plat_info *plat_info;
> +=09enum mlxbf_pka_mem_res_idx acpi_mem_idx;
> +=09struct mlxbf_pka_device *mlxbf_pka_dev;
> +=09const struct acpi_device_id *aid;
> +=09struct platform_device *pdev;
> +=09u64 wndw_ram_off_mask;
> +=09struct device *dev;
> +=09int ret;
> +
> +=09if (!info)
> +=09=09return -EINVAL;
> +
> +=09dev =3D info->dev;
> +=09pdev =3D to_platform_device(dev);
> +
> +=09mlxbf_pka_dev =3D devm_kzalloc(dev, sizeof(*mlxbf_pka_dev), GFP_KERNE=
L);
> +=09if (!mlxbf_pka_dev)
> +=09=09return -ENOMEM;
> +
> +=09scoped_guard(mutex, &mlxbf_pka_drv_lock) {
> +=09=09mlxbf_pka_device_cnt +=3D 1;
> +=09=09if (mlxbf_pka_device_cnt > MLXBF_PKA_DRIVER_DEV_MAX) {
> +=09=09=09dev_dbg(dev, "cannot support %u devices\n", mlxbf_pka_device_cn=
t);
> +=09=09=09return -ENOSPC;
> +=09=09}
> +=09=09mlxbf_pka_dev->device_id =3D mlxbf_pka_device_cnt - 1;
> +=09}
> +
> +=09mlxbf_pka_dev->info =3D info;
> +=09mlxbf_pka_dev->device =3D dev;
> +=09info->flag =3D MLXBF_PKA_DRIVER_FLAG_DEVICE;
> +
> +=09for (acpi_mem_idx =3D MLXBF_PKA_ACPI_EIP154_IDX;
> +=09     acpi_mem_idx < MLXBF_PKA_DEVICE_RES_CNT;
> +=09     acpi_mem_idx++) {
> +=09=09mlxbf_pka_dev->resource[acpi_mem_idx] =3D platform_get_resource(pd=
ev,
> +=09=09=09=09=09=09=09=09=09      IORESOURCE_MEM,
> +=09=09=09=09=09=09=09=09=09      acpi_mem_idx);
> +=09}
> +
> +=09/* Verify PKA bootup status. */
> +=09ret =3D mlxbf_pka_drv_verify_bootup_status(dev);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Window RAM offset mask is platform dependent. */
> +=09aid =3D acpi_match_device(mlxbf_pka_drv_acpi_ids, dev);
> +=09if (!aid)
> +=09=09return -ENODEV;
> +
> +=09plat_info =3D (struct mlxbf_pka_drv_plat_info *)aid->driver_data;
> +=09if (!plat_info) {
> +=09=09dev_err(dev, "missing platform data\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09wndw_ram_off_mask =3D plat_info->wndw_ram_off_mask;
> +
> +=09scoped_guard(mutex, &mlxbf_pka_drv_lock) {
> +=09=09ret =3D mlxbf_pka_drv_register_device(mlxbf_pka_dev, wndw_ram_off_=
mask);
> +=09=09if (ret) {
> +=09=09=09dev_dbg(dev, "failed to register shim\n");
> +=09=09=09return ret;
> +=09=09}
> +=09}
> +
> +=09info->priv =3D mlxbf_pka_dev;
> +
> +=09return 0;
> +}
> +
> +static void mlxbf_pka_drv_remove_device(struct platform_device *pdev)
> +{
> +=09struct mlxbf_pka_platdata *priv =3D platform_get_drvdata(pdev);
> +=09struct mlxbf_pka_info *info =3D priv->info;
> +=09struct mlxbf_pka_device *mlxbf_pka_dev =3D (struct mlxbf_pka_device *=
)info->priv;
> +
> +=09if (!mlxbf_pka_dev)
> +=09=09return;
> +
> +=09mlxbf_pka_drv_unregister_device(mlxbf_pka_dev);
> +}
> +
> +static int mlxbf_pka_drv_acpi_probe(struct platform_device *pdev, struct=
 mlxbf_pka_info *info)
> +{
> +=09struct device *dev =3D &pdev->dev;
> +=09struct acpi_device *adev;
> +=09int ret;
> +
> +=09if (acpi_disabled)
> +=09=09return -ENOENT;
> +
> +=09adev =3D ACPI_COMPANION(dev);
> +=09if (!adev) {
> +=09=09dev_dbg(dev, "ACPI companion device not found for %s\n", pdev->nam=
e);
> +=09=09return -ENODEV;
> +=09}
> +
> +=09info->acpihid =3D acpi_device_hid(adev);
> +=09if (WARN_ON(!info->acpihid))
> +=09=09return -EINVAL;
> +
> +=09if (!strcmp(info->acpihid, mlxbf_pka_acpihid_bf1) ||
> +=09    !strcmp(info->acpihid, mlxbf_pka_acpihid_bf2) ||
> +=09    !strcmp(info->acpihid, mlxbf_pka_acpihid_bf3)) {
> +=09=09ret =3D mlxbf_pka_drv_probe_device(info);
> +=09=09if (ret) {
> +=09=09=09dev_dbg(dev, "failed to register device\n");
> +=09=09=09return ret;
> +=09=09}
> +=09=09dev_info(dev, "device probed\n");
> +=09}
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_probe(struct platform_device *pdev)
> +{
> +=09struct mlxbf_pka_platdata *priv;
> +=09struct device *dev =3D &pdev->dev;
> +=09struct mlxbf_pka_info *info;
> +=09int ret;
> +
> +=09priv =3D devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +=09if (!priv)
> +=09=09return -ENOMEM;
> +
> +=09spin_lock_init(&priv->lock);
> +=09priv->pdev =3D pdev;
> +
> +=09info =3D devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
> +=09if (!info)
> +=09=09return -ENOMEM;
> +
> +=09info->name =3D pdev->name;
> +=09info->module =3D THIS_MODULE;
> +=09info->dev =3D dev;
> +=09priv->info =3D info;
> +
> +=09platform_set_drvdata(pdev, priv);
> +
> +=09ret =3D mlxbf_pka_drv_acpi_probe(pdev, info);
> +=09if (ret) {
> +=09=09dev_dbg(dev, "unknown device\n");
> +=09=09return ret;
> +=09}
> +
> +=09return ret;
> +}
> +
> +static void mlxbf_pka_drv_remove(struct platform_device *pdev)
> +{
> +=09struct mlxbf_pka_platdata *priv =3D platform_get_drvdata(pdev);
> +=09struct mlxbf_pka_info *info =3D priv->info;
> +
> +=09if (info->flag =3D=3D MLXBF_PKA_DRIVER_FLAG_DEVICE) {
> +=09=09dev_info(&pdev->dev, "remove PKA device\n");
> +=09=09mlxbf_pka_drv_remove_device(pdev);
> +=09}
> +}
> +
> +MODULE_DEVICE_TABLE(acpi, mlxbf_pka_drv_acpi_ids);
> +
> +static struct platform_driver mlxbf_pka_drv =3D {
> +=09.driver =3D {
> +=09=09   .name =3D KBUILD_MODNAME,
> +=09=09   .acpi_match_table =3D ACPI_PTR(mlxbf_pka_drv_acpi_ids),
> +=09=09  },
> +=09.probe =3D mlxbf_pka_drv_probe,
> +=09.remove =3D mlxbf_pka_drv_remove,
> +};
> +
> +module_platform_driver(mlxbf_pka_drv);
> +MODULE_DESCRIPTION(MLXBF_PKA_DRIVER_DESCRIPTION);
> +MODULE_AUTHOR("Ron Li <xiangrongl@nvidia.com>");
> +MODULE_AUTHOR("Khalil Blaiech <kblaiech@nvidia.com>");
> +MODULE_AUTHOR("Mahantesh Salimath <mahantesh@nvidia.com>");
> +MODULE_AUTHOR("Shih-Yi Chen <shihyic@nvidia.com>");
> +MODULE_LICENSE("Dual BSD/GPL");
>=20

--=20
 i.
--8323328-493857866-1762435353=:981--
