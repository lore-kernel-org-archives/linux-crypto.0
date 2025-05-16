Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48B422E3E2;
	Fri, 16 May 2025 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747387189; cv=none; b=sgpPzgsQUx02QzO7KCIUOUttVpLJgYfZKmAfrtvL3zM4gxGNWV+KwAUcMwLFgaE58S2SVx/mnfpuPtYvt1TTM0SF18ozsNw3NRmY0HR3C8zx2QRqNrthnoBFDOF0evEmEd2WUXQQH+/3O2lYqsYy9iTOJGxn+P0i+EYPmV6HPZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747387189; c=relaxed/simple;
	bh=bk5HEhe0dD2AHbCE6ADrh5LkJufnH0Dkpjk4IAxpfAw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MY8p07VH6OqRJd1cBnDanoWmvRa3ISNvBzER87aPFgN0NBCNq+KTN83V1I16wFrnhS5s3ZM66FcoggfRblZMsIWAAtwnZojInThZXfEX3HxOaArK5ZGxIBcalBcl0IExQsvpVec8gMS350nUvlWw3FCSzoidqq2gzb23u/FAVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ck1sUA/b; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ck1sUA/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747387184; x=1778923184;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=bk5HEhe0dD2AHbCE6ADrh5LkJufnH0Dkpjk4IAxpfAw=;
  b=ck1sUA/bV1u71ilC/lvMSPFJ1aRGHKbOt8mhB48+fuOu2637LIk2CPmg
   KdUDddh8TFXcx/Y9Oq3gGTcy8+edkZMODaGsVLtO1LixVB5XY3PxWm7oS
   Fo2cgNKPqyJGhgRLNxn1yyanr2NPHBeRvuBPL9DY70qGSiYgy9giSbAIW
   664jtZ9EbyQ6xVvx+oyq7UXRqQBAXCGEHgdQ6vDTrmiHy/hIyZCzt/GQE
   wEq2limEIaZUmFu6JBcqANoTp+D4SCmBrA/SFElR7GuxQQLx5hVLq5UCb
   xWDo3qnujNJQGuAfB9SqgDe5gaZNvSuGKf+sRxttyVgx/4kVLIq+CtJrO
   g==;
X-CSE-ConnectionGUID: L/TKfdoyQ0epPWSicIgdsA==
X-CSE-MsgGUID: XH0umRuVSkGRW/pcewCsRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="71858065"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="71858065"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:19:42 -0700
X-CSE-ConnectionGUID: 0M2DV4MKQWin5qcQAYhMaA==
X-CSE-MsgGUID: 9Gn/gKuYRKuDOrdv8UpBmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="139029527"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.94])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:19:39 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 16 May 2025 12:19:36 +0300 (EEST)
To: Ron Li <xiangrongl@nvidia.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
cc: Hans de Goede <hdegoede@redhat.com>, vadimp@nvidia.com, 
    kblaiech@nvidia.com, davthompson@nvidia.com, 
    platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] platform/mellanox: Add mlxbf_pka driver for BlueField
 Soc
In-Reply-To: <20250515193234.2436452-1-xiangrongl@nvidia.com>
Message-ID: <c85784ee-5f06-6d7a-377e-07db7af8bd35@linux.intel.com>
References: <20250515193234.2436452-1-xiangrongl@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-891142650-1747387176=:1009"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-891142650-1747387176=:1009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 15 May 2025, Ron Li wrote:

> Add the mlxbf_pka driver to support the BlueField SoC Public Key
> Acceleration (PKA) hardware. The PKA provides a simple, complete
> framework for crypto public key hardware offload. It supports direct
> access to the public key hardware resources from the user space, and
> makes available several arithmetic operations: some basic operations
> (e.g., addition and multiplication), some complex operations (e.g.,
> modular exponentiation and modular inversion), and high-level
> operations such as RSA, Diffie-Hallman, Elliptic Curve Cryptography,
> and the Federal Digital Signature Algorithm (DSA as documented in
> FIPS-186) public-private key systems.
>
> The PKA driver initializes the PKA hardware interface and implements
> file operations so that user space libraries can bypass the kernel and
> have direct access to a specific set of device registers. The Arm cores
> interface to the PKA hardware through rings and a 64KB memory known as
> Window RAM. There are multiple PKA devices on the BlueField SoC. In
> general, each PKA device has 4 rings, 1 window RAM and 1 True Random
> Number Generator (TRNG). Thus, the driver has been designed to probe
> each PKA and each individual ring inside a given PKA. It also registers
> the TRNG to feed the kernel entropy (i.e., /dev/hwrng). To implement
> such design, the driver creates individual device files for each ring
> and TRNG module. The ring device files are identified using their ids,
> i.e., /dev/mlxbf_pka/<ring_id>.
>=20
> The main driver logic such as probe() and remove() are implemented in
> mlxbf_pka_drv.c. The PKA ring device operations are also implemented in
> this source file, such as open(), release() and mmap().
>=20
> The mlxbf_pka_dev.c source file implements functions to operate the
> underlying PKA hardware, such as TRNG operation, PKA hardware I/O
> access, PKA memory resource operation, etc.
>=20
> The PKA driver is a lighweight driver that implements file operations
> and map memory regions of the PKA hardware to user space drivers and
> libraries. There is no in-kernel crypto support. Therefore, the PKA
> driver is included under drivers/platform/mellanox.
>
> Testing
>=20
> - Successful build of kernel for ARM64.
>=20
> - Tested ARM64 build on several Mellanox BlueField 2 and 3 SoC boards
> that include the PKA hardware. The testing includes the validation of
> the PKA hardware execution, random number generation and public key
> acceleration performance.

Hi,

We've the in-kernel crypto framework but I don't see any attempt to build=
=20
into that framework AFAICT. Why is that? You brush it off as "The PKA=20
driver is a lightweight driver ..." but lets see if the crypto people=20
agree with that approach (I added them).

(Please also Cc crypto people in any further submission.)

> Reviewed-by: David Thompson  <davthompson@nvidia.com>
> Reviewed-by: Khalil Blaiech  <kblaiech@nvidia.com>

Remove the extra space. x2

> Signed-off-by: Ron Li <xiangrongl@nvidia.com>
> ---
>  .../ABI/testing/sysfs-platform-mellanox-pka   |   35 +
>  MAINTAINERS                                   |    8 +
>  drivers/platform/mellanox/Kconfig             |   10 +
>  drivers/platform/mellanox/Makefile            |    1 +
>  drivers/platform/mellanox/mlxbf_pka/Makefile  |   10 +
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        | 1891 +++++++++++++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        |  657 ++++++
>  .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        | 1066 ++++++++++
>  8 files changed, 3678 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-mellanox-pka
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/Makefile
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
>  create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
>=20
> diff --git a/Documentation/ABI/testing/sysfs-platform-mellanox-pka b/Docu=
mentation/ABI/testing/sysfs-platform-mellanox-pka
> new file mode 100644
> index 000000000000..2ec5ed70dbf7
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
> @@ -0,0 +1,35 @@
> +What:=09=09/sys/devices/platform/<pka-device-id>/<pka-ring-device-id>
> +Date:=09=09Jun 2025
> +KernelVersion:=096.15
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
> +
> +=09=09Each PKA device supports four PKA ring devices. The PKA ring devic=
e IDs are:
> +
> +=09=09=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +=09=09BlueField-1  MLNXBF11:xx, where xx ranges from '00' to '0F'
> +=09=09BlueField-2  MLNXBF21:xx, where xx ranges from '00' to '20'
> +=09=09BlueField-3  MLNXBF52:xx, where xx ranges from '00' to '60'
> +=09=09=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +=09=09For each PKA ring device, the following operation interfaces:
> +
> +=09=09- open(): open the PKA ring device specified by the device ID, and=
 initiate the
> +=09=09  related RAM regions.
> +=09=09- release(): close the PKA ring device specified by the device ID,=
 and release the
> +=09=09  related RAM regions.
> +=09=09- unlocked_ioctl(): make PKA related system calls, including getti=
ng ring device or
> +=09=09  RAM region inofrmation, clearing PKA ring counter and getting ra=
ndom bytes from
> +=09=09  the TRNG module from the PKA device.
> +=09=09- mmap(): map the PKA ring device to the virtual memory region.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f21f1dabb5fe..31821caf8a81 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15299,6 +15299,14 @@ L:=09linux-i2c@vger.kernel.org
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
> index aa760f064a17..6b99a7d866d8 100644
> --- a/drivers/platform/mellanox/Kconfig
> +++ b/drivers/platform/mellanox/Kconfig
> @@ -108,4 +108,14 @@ config NVSW_SN2201
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
> index ba56485cbe8c..1b2c61b26639 100644
> --- a/drivers/platform/mellanox/Makefile
> +++ b/drivers/platform/mellanox/Makefile
> @@ -5,6 +5,7 @@
>  #
>  obj-$(CONFIG_MLX_PLATFORM)=09+=3D mlx-platform.o
>  obj-$(CONFIG_MLXBF_BOOTCTL)=09+=3D mlxbf-bootctl.o
> +obj-$(CONFIG_MLXBF_PKA)     +=3D mlxbf_pka/
>  obj-$(CONFIG_MLXBF_PMC)=09=09+=3D mlxbf-pmc.o
>  obj-$(CONFIG_MLXBF_TMFIFO)=09+=3D mlxbf-tmfifo.o
>  obj-$(CONFIG_MLXREG_HOTPLUG)=09+=3D mlxreg-hotplug.o
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
> index 000000000000..0c953c9e48c7
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
> @@ -0,0 +1,1891 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
> +// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All ri=
ghts reserved.
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/ioport.h>
> +#include <linux/timex.h>
> +#include <linux/types.h>
> +#include <linux/compiler.h>
> +#include <linux/io.h>
> +
> +#include "mlxbf_pka_dev.h"
> +
> +#define MASTER_CONTROLLER_OUT_OF_RESET 0
> +
> +/* Personalization string "NVIDIA-MELLANOX-BLUEFIELD-TRUE_RANDOM_NUMBER_=
GEN". */
> +static u32 mlxbf_pka_trng_drbg_ps_str[] =3D {
> +=090x4e564944, 0x49412d4d, 0x454c4c41, 0x4e4f582d,
> +=090x424c5545, 0x4649454c, 0x442d5452, 0x55455f52,
> +=090x414e444f, 0x4d5f4e55, 0x4d424552, 0x5f47454e
> +};
> +
> +/* Personalization string for DRBG test. */
> +static u32 mlxbf_pka_trng_drbg_test_ps_str[] =3D {
> +=090x64299d83, 0xc34d7098, 0x5bd1f51d, 0xddccfdc1,
> +=090xdd0455b7, 0x166279e5, 0x0974cb1b, 0x2f2cd100,
> +=090x59a5060a, 0xca79940d, 0xd4e29a40, 0x56b7b779
> +};
> +
> +/* First Entropy string for DRBG test. */
> +static u32 mlxbf_pka_trng_drbg_test_etpy_str1[] =3D {
> +=090xaa6bbcab, 0xef45e339, 0x136ca1e7, 0xbce1c881,
> +=090x9fa37b09, 0x63b53667, 0xb36e0053, 0xa202ed81,
> +=090x4650d90d, 0x8eed6127, 0x666f2402, 0x0dfd3af9
> +};
> +
> +/* Second Entropy string for DRBG test. */
> +static u32 mlxbf_pka_trng_drbg_test_etpy_str2[] =3D {
> +=090x35c1b7a1, 0x0154c52b, 0xd5777390, 0x226a4fdb,
> +=090x5f16080d, 0x06b68369, 0xd0c93d00, 0x3336e27f,
> +=090x1abf2c37, 0xe6ab006c, 0xa4adc6e1, 0x8e1907a2
> +};
> +
> +/* Known answer for DRBG test. */
> +static u32 mlxbf_pka_trng_drbg_test_output[] =3D {
> +=090xb663b9f1, 0x24943e13, 0x80f7dce5, 0xaba1a16f
> +};
> +
> +/* Known answer for poker test. */
> +static u64 poker_test_exp_cnt[] =3D {
> +=090x20f42bf4, 0xaf415f4, 0xf4f4fff4, 0xfff4f4f4
> +};
> +
> +struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
> +
> +/* Global PKA shim resource info table. */
> +static struct mlxbf_pka_dev_gbl_shim_res_info_t mlxbf_pka_gbl_res_tbl[ML=
XBF_PKA_MAX_NUM_IO_BLOCKS];
> +
> +/* Start a PKA device timer. */
> +static inline u64 mlxbf_pka_dev_timer_start_msec(u32 msec)
> +{
> +=09u64 cur_time =3D get_cycles();
> +
> +=09return (cur_time + (mlxbf_pka_early_cpu_speed() * msec) / MSEC_PER_SE=
C);

+ #include <linux/time.h>

Should this be rounded to some direction?

Remove all unnecessary parentheses from return statements.

> +}
> +
> +/* Test a PKA device timer for completion. */
> +static inline int mlxbf_pka_dev_timer_done(u64 timer)
> +{
> +=09return (get_cycles() >=3D timer);
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
> + * Mapping PKA Ring address into Window RAM address.
> + * It converts the ring address, either physical address or virtual addr=
ess, to valid address into
> + * the Window RAM. This is done assuming the Window RAM base, size and m=
ask. Here, base is the
> + * actual physical address of the Window RAM, with the help of mask it i=
s reduced to Window RAM
> + * offset within that PKA block. Further, with the help of addr and size=
, we arrive at the Window
> + * RAM offset address for a PKA Ring within the given Window RAM.

All comments must be folded to 80 chars.

> + */
> +static inline u64 mlxbf_pka_ring_mem_addr(u64 base, u64 mask, u64 addr, =
u64 size)
> +{
> +=09return ((base) & (mask)) |
> +=09       (((addr) & MLXBF_PKA_WINDOW_RAM_RING_ADDR_MASK) |
> +=09       ((((addr) & ~((size) - 1)) & MLXBF_PKA_WINDOW_RAM_RING_SIZE_MA=
SK) >>
> +=09       MLXBF_PKA_WINDOW_RAM_RING_SIZE_SHIFT));

Please use FIELD_GET() and get rid of _SHIFT defines if they're only used=
=20
for constructs like this.

> +}
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
> +=09=09if (res_ptr && strcmp(res_ptr->name, res->name) =3D=3D 0) {

!strcmp(), although I'd reverse the entire logic and use continue instead.

Add #include for strcmp().


> +=09=09=09mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx] =3D NULL;
> +=09=09=09mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt--;
> +=09=09=09break;
> +=09=09}
> +=09}
> +
> +=09/*
> +=09 * Check whether the resource shares the same memory map; If so, the =
memory map shouldn't
> +=09 * be released.
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
> +static void mlxbf_pka_dev_unset_resource_config(struct mlxbf_pka_dev_shi=
m_s *shim,
> +=09=09=09=09=09=09struct mlxbf_pka_dev_res_t *res_ptr)
> +{
> +=09if (res_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED)
> +=09=09return;
> +
> +=09if (res_ptr->ioaddr && -EBUSY !=3D mlxbf_pka_dev_put_resource(res_ptr=
, shim->shim_id)) {

Reverse logic and return.

I suggest you split this into two as well.

> +=09=09pr_debug("mlxbf_pka: PKA device resource released\n");
> +=09=09res_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +=09}
> +}
> +
> +int mlxbf_pka_dev_clear_ring_counters(struct mlxbf_pka_dev_ring_t *ring)
> +{
> +=09struct mlxbf_pka_dev_res_t *master_seq_ctrl_ptr;
> +=09u64 master_reg_base, master_reg_off;
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09void __iomem *master_reg_ptr;
> +
> +=09shim =3D ring->shim;
> +=09master_seq_ctrl_ptr =3D &shim->resources.master_seq_ctrl;
> +=09master_reg_base =3D master_seq_ctrl_ptr->base;
> +=09master_reg_ptr =3D master_seq_ctrl_ptr->ioaddr;
> +=09master_reg_off =3D mlxbf_pka_dev_get_register_offset(master_reg_base,
> +=09=09=09=09=09=09=09   MLXBF_PKA_MASTER_SEQ_CTRL_ADDR);
> +
> +=09/* Push the EIP-154 master controller into reset. */
> +=09mlxbf_pka_dev_io_write(master_reg_ptr, master_reg_off, MLXBF_PKA_MAST=
ER_SEQ_CTRL_RESET_VAL);
> +
> +=09/* Clear counters. */
> +=09mlxbf_pka_dev_io_write(master_reg_ptr, master_reg_off,
> +=09=09=09       MLXBF_PKA_MASTER_SEQ_CTRL_CLEAR_COUNTERS_VAL);
> +
> +=09/* Take the EIP-154 master controller out of reset. */
> +=09mlxbf_pka_dev_io_write(master_reg_ptr, master_reg_off, MASTER_CONTROL=
LER_OUT_OF_RESET);
> +
> +=09return 0;
> +}
> +
> +/*
> + * Initialize ring. Set ring parameters and configure ring resources. It=
 returns 0 on success, a
> + * negative error code on failure.
> + */
> +static int mlxbf_pka_dev_init_ring(struct device *dev,
> +=09=09=09=09   struct mlxbf_pka_dev_ring_t *ring,
> +=09=09=09=09   u32 ring_id,
> +=09=09=09=09   struct mlxbf_pka_dev_shim_s *shim)
> +{
> +=09struct mlxbf_pka_dev_res_t *ring_window_ram_ptr;
> +=09struct mlxbf_pka_dev_res_t *ring_info_words_ptr;
> +=09struct mlxbf_pka_dev_res_t *ring_counters_ptr;
> +=09u8 window_ram_split;
> +=09u32 ring_words_off;
> +=09u32 ring_cntrs_off;
> +=09u32 ring_mem_base;
> +=09u32 ring_mem_off;
> +=09u32 shim_ring_id;
> +
> +=09if (ring->status !=3D MLXBF_PKA_DEV_RING_STATUS_UNDEFINED) {
> +=09=09dev_err(dev, "PKA ring must be undefined\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09if (ring_id > MLXBF_PKA_MAX_NUM_RINGS - 1) {
> +=09=09dev_err(dev, "invalid ring identifier\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09ring->ring_id =3D ring_id;
> +=09ring->shim =3D shim;
> +=09ring->resources_num =3D MLXBF_PKA_MAX_NUM_RING_RESOURCES;
> +=09shim_ring_id =3D ring_id % MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS;
> +=09shim->rings[shim_ring_id] =3D ring;
> +
> +=09/* Configure ring information control/status words resource. */
> +=09ring_info_words_ptr =3D &ring->resources.info_words;
> +=09ring_words_off =3D shim_ring_id * MLXBF_PKA_RING_WORDS_SPACING;
> +=09ring_info_words_ptr->base =3D ring_words_off + shim->mem_res.eip154_b=
ase +
> +=09=09=09=09    MLXBF_PKA_RING_WORDS_ADDR;
> +=09ring_info_words_ptr->size =3D MLXBF_PKA_RING_WORDS_SIZE;
> +=09ring_info_words_ptr->type =3D MLXBF_PKA_DEV_RES_TYPE_MEM;
> +=09ring_info_words_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +=09ring_info_words_ptr->name =3D "MLXBF_PKA_RING_INFO";
> +
> +=09/* Configure ring counters registers resource. */
> +=09ring_counters_ptr =3D &ring->resources.counters;
> +=09ring_cntrs_off =3D shim_ring_id * MLXBF_PKA_RING_CNTRS_SPACING;
> +=09ring_counters_ptr->base =3D ring_cntrs_off + shim->mem_res.eip154_bas=
e +
> +=09=09=09=09  MLXBF_PKA_RING_CNTRS_ADDR;
> +=09ring_counters_ptr->size =3D MLXBF_PKA_RING_CNTRS_SIZE;
> +=09ring_counters_ptr->type =3D MLXBF_PKA_DEV_RES_TYPE_REG;
> +=09ring_counters_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +=09ring_counters_ptr->name =3D "MLXBF_PKA_RING_CNTRS";
> +
> +=09/* Configure ring window RAM resource. */
> +=09window_ram_split =3D shim->window_ram_split;
> +=09if (window_ram_split =3D=3D MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED) =
{
> +=09=09ring_mem_off =3D shim_ring_id * MLXBF_PKA_RING_MEM_1_SPACING;
> +=09=09ring_mem_base =3D ring_mem_off + shim->mem_res.alt_wndw_ram_0_base=
;
> +=09} else {
> +=09=09ring_mem_off =3D shim_ring_id * MLXBF_PKA_RING_MEM_0_SPACING;
> +=09=09ring_mem_base =3D ring_mem_off + shim->mem_res.wndw_ram_base;
> +=09}
> +
> +=09ring_window_ram_ptr =3D &ring->resources.window_ram;
> +=09ring_window_ram_ptr->base =3D ring_mem_base;
> +=09ring_window_ram_ptr->size =3D MLXBF_PKA_RING_MEM_SIZE;
> +=09ring_window_ram_ptr->type =3D MLXBF_PKA_DEV_RES_TYPE_MEM;
> +=09ring_window_ram_ptr->status =3D MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
> +=09ring_window_ram_ptr->name =3D "MLXBF_PKA_RING_WINDOW";
> +
> +=09ring->ring_info =3D devm_kzalloc(dev, sizeof(*ring->ring_info), GFP_K=
ERNEL);
> +=09if (!ring->ring_info)
> +=09=09return -ENOMEM;
> +
> +=09mutex_init(&ring->mutex);

devm_mutex_init() + don't forget error handling.

> +=09ring->status =3D MLXBF_PKA_DEV_RING_STATUS_INITIALIZED;
> +
> +=09return 0;
> +}
> +
> +/* Release a given Ring. */
> +static int mlxbf_pka_dev_release_ring(struct mlxbf_pka_dev_ring_t *ring)
> +{
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09u32 shim_ring_id;
> +
> +=09if (ring->status =3D=3D MLXBF_PKA_DEV_RING_STATUS_UNDEFINED)
> +=09=09return 0;
> +
> +=09if (ring->status =3D=3D MLXBF_PKA_DEV_RING_STATUS_BUSY) {
> +=09=09pr_err("mlxbf_pka error: PKA ring is busy\n");
> +=09=09return -EBUSY;
> +=09}
> +
> +=09shim =3D ring->shim;
> +
> +=09if (shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_RUNNING) {
> +=09=09pr_err("mlxbf_pka error: PKA shim is running\n");

dev_err()

> +=09=09return -EPERM;
> +=09}
> +
> +=09mlxbf_pka_dev_unset_resource_config(shim, &ring->resources.info_words=
);
> +=09mlxbf_pka_dev_unset_resource_config(shim, &ring->resources.counters);
> +=09mlxbf_pka_dev_unset_resource_config(shim, &ring->resources.window_ram=
);
> +
> +=09ring->status =3D MLXBF_PKA_DEV_RING_STATUS_UNDEFINED;
> +=09shim_ring_id =3D ring->ring_id % MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS;
> +=09shim->rings[shim_ring_id] =3D NULL;
> +=09shim->rings_num--;
> +
> +=09return 0;
> +}
> +
> +/*
> + * Partition the window RAM for a given PKA ring.  Here we statically di=
vide the 16K memory region
> + * into three partitions:  First partition is reserved for command descr=
iptor ring (1K), second
> + * partition is reserved for result descriptor ring (1K), and the remain=
ing 14K are reserved for
> + * vector data. Through this memory partition scheme, command/result des=
criptor rings hold a total
> + * of 1KB/64B =3D 16 descriptors each. The addresses for the rings start=
 at offset 0x3800.  Also note
> + * that it is possible to have rings full while the vector data can supp=
ort more data,  the opposite
> + * can also happen, but it is not suitable. For instance ECC point multi=
plication requires 8 input
> + * vectors and 2 output vectors, a total of 10 vectors. If each vector h=
as a length of 24 words
> + * (24x4B =3D 96B), we can process 14KB/960B =3D 14 operations which is =
close to 16 the total
> + * descriptors supported by rings. On the other hand, using 12K vector d=
ata region, allows to
> + * process only 12 operations, while rings can hold 32 descriptors (ring=
 usage is significantly
> + * low).
> + *
> + * For ECDSA verify, we have 12 vectors which require 1152B, with 14KB w=
e can handle 12 operations,
> + * against 10 operations with 12KB vector data memory. We believe that t=
he aforementioned memory
> + * partition help us to leverage the trade-off between supported descrip=
tors and required vectors.
> + * Note that these examples give approximative values and does not inclu=
de buffer word padding
> + * across vectors.
> + *
> + * The function also writes the result descriptor rings base addresses, =
size and type. And
> + * initialize the read and write pointers and statistics. It returns 0 o=
n success, a negative error
> + * code on failure.
> + *
> + * This function must be called once per ring, at initialization before =
any other functions are
> + * called.
> + */
> +static int mlxbf_pka_dev_partition_mem(struct mlxbf_pka_dev_ring_t *ring=
)
> +{
> +=09u64 rslt_desc_ring_base;
> +=09u64 cmd_desc_ring_base;
> +=09u32 cmd_desc_ring_size;
> +=09u64 window_ram_base;
> +=09u64 window_ram_size;
> +=09u32 ring_mem_base;
> +
> +=09if (!ring->shim || ring->status !=3D MLXBF_PKA_DEV_RING_STATUS_INITIA=
LIZED)
> +=09=09return -EPERM;
> +
> +=09window_ram_base =3D ring->resources.window_ram.base;
> +=09window_ram_size =3D ring->resources.window_ram.size;
> +=09/*
> +=09 * Partition ring memory.  Give ring pair (cmmd descriptor ring and r=
slt descriptor ring) an
> +=09 * equal portion of the memory.  The cmmd descriptor ring and result =
descriptor ring are
> +=09 * used as "non-overlapping" ring. Currently set aside 1/8 of the win=
dow RAM for command and
> +=09 * result descriptor rings - giving a total of 1K/64B =3D 16 descript=
ors per ring. The
> +=09 * remaining memory is "Data Memory" - i.e. memory to hold the comman=
d operands and results
> +=09 * - also called input/output vectors (in all cases these vectors are=
 just single large
> +=09 * integers - often in the range of hundreds to thousands of bits lon=
g).
> +=09 */
> +=09ring_mem_base =3D window_ram_base + MLXBF_PKA_WINDOW_RAM_DATA_MEM_SIZ=
E;
> +=09cmd_desc_ring_size =3D MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE /
> +=09=09=09     MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV;
> +=09ring->num_cmd_desc =3D MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE /
> +=09=09=09     MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV / CMD_DESC_SIZE;
> +=09/*
> +=09 * The command and result descriptor rings may be placed at different=
 (non-overlapping)
> +=09 * locations in Window RAM memory space. PKI command interface: Most =
of the functionality is
> +=09 * defined by the EIP-154 master firmware on the EIP-154 master contr=
oller Sequencer.
> +=09 */
> +=09cmd_desc_ring_base =3D ring_mem_base;
> +=09rslt_desc_ring_base =3D ring_mem_base + cmd_desc_ring_size;
> +
> +=09cmd_desc_ring_base =3D mlxbf_pka_ring_mem_addr(window_ram_base,
> +=09=09=09=09=09=09     ring->shim->mem_res.wndw_ram_off_mask,
> +=09=09=09=09=09=09     cmd_desc_ring_base,
> +=09=09=09=09=09=09     window_ram_size);
> +=09rslt_desc_ring_base =3D mlxbf_pka_ring_mem_addr(window_ram_base,
> +=09=09=09=09=09=09      ring->shim->mem_res.wndw_ram_off_mask,
> +=09=09=09=09=09=09      rslt_desc_ring_base,
> +=09=09=09=09=09=09      window_ram_size);
> +
> +=09/* Fill ring information. */
> +=09memset(ring->ring_info, 0, sizeof(struct mlxbf_pka_dev_hw_ring_info_t=
));

Please use the destination's sizeof() in the size parameter.

> +=09ring->ring_info->cmmd_base =3D cmd_desc_ring_base;

Is cmmd a typo?

> +=09ring->ring_info->rslt_base =3D rslt_desc_ring_base;
> +=09ring->ring_info->size =3D MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE /
> +=09=09=09=09MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV / CMD_DESC_SIZE - 1;
> +=09ring->ring_info->host_desc_size =3D CMD_DESC_SIZE / sizeof(u32);
> +=09ring->ring_info->in_order =3D ring->shim->ring_type;
> +
> +=09return 0;
> +}
> +
> +/*
> + * Write the ring base address, ring size and type, and initialize (clea=
r) the read and write
> + * pointers and statistics.
> + */
> +static int mlxbf_pka_dev_write_ring_info(struct mlxbf_pka_dev_res_t *buf=
fer_ram_ptr,
> +=09=09=09=09=09 u8 ring_id,
> +=09=09=09=09=09 u32 ring_cmmd_base_val,
> +=09=09=09=09=09 u32 ring_rslt_base_val,
> +=09=09=09=09=09 u32 ring_size_type_val)
> +{
> +=09u32 ring_spacing;
> +=09u64 word_off;
> +
> +=09if (buffer_ram_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +=09    buffer_ram_ptr->type !=3D MLXBF_PKA_DEV_RES_TYPE_MEM)
> +=09=09return -EPERM;
> +
> +=09pr_debug("mlxbf_pka: writing ring information control/status words\n"=
);

dev_dbg()

> +
> +=09ring_spacing =3D ring_id * MLXBF_PKA_RING_WORDS_SPACING;
> +=09/*
> +=09 * Write the command ring base address that the EIP-154 master firmwa=
re uses with the
> +=09 * command ring read pointer to get command descriptors from the Host=
 ring. After the
> +=09 * initialization, although the word is writeable it should be regard=
ed as read-only.
> +=09 */
> +=09word_off =3D mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +=09=09=09=09=09=09 MLXBF_PKA_RING_CMMD_BASE_0_ADDR + ring_spacing,
> +=09=09=09=09=09=09 MLXBF_PKA_BUFFER_RAM_SIZE);
> +=09mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, ring_cmmd_ba=
se_val);
> +
> +=09/*
> +=09 * Write the result ring base address that the EIP-154 master firmwar=
e uses with the result
> +=09 * ring write pointer to put the result descriptors in the Host ring.=
 After the
> +=09 * initialization, although the word is writeable it should be regard=
ed as read-only.
> +=09 */
> +=09word_off =3D mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +=09=09=09=09=09=09 MLXBF_PKA_RING_RSLT_BASE_0_ADDR + ring_spacing,
> +=09=09=09=09=09=09 MLXBF_PKA_BUFFER_RAM_SIZE);
> +=09mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, ring_rslt_ba=
se_val);
> +
> +=09/*
> +=09 * Write the ring size (number of descriptors), the size of the descr=
iptor and the result
> +=09 * reporting scheme. After the initialization, although the word is w=
riteable it should be
> +=09 * regarded as read-only.
> +=09 */
> +=09word_off =3D mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +=09=09=09=09=09=09 MLXBF_PKA_RING_SIZE_TYPE_0_ADDR + ring_spacing,
> +=09=09=09=09=09=09 MLXBF_PKA_BUFFER_RAM_SIZE);
> +=09mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, ring_size_ty=
pe_val);
> +
> +=09/*
> +=09 * Write the command and result ring indices that the EIP-154 master =
firmware uses. This
> +=09 * word should be written with zero when the ring information is init=
ialized. After the
> +=09 * initialization, although the word is writeable it should be regard=
ed as read-only.
> +=09 */
> +=09word_off =3D mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +=09=09=09=09=09=09 MLXBF_PKA_RING_RW_PTRS_0_ADDR + ring_spacing,
> +=09=09=09=09=09=09 MLXBF_PKA_BUFFER_RAM_SIZE);
> +=09mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, 0);
> +
> +=09/*
> +=09 * Write the ring statistics (two 16-bit counters, one for commands a=
nd one for results)
> +=09 * from EIP-154 master firmware point of view. This word should be wr=
itten with zero when
> +=09 * the ring information is initialized. After the initialization, alt=
hough the word is
> +=09 * writeable it should be regarded as read-only.
> +=09 */

This function has overly long and in part repetitively worded comments.
And you should not comment what is readable from the code itself.

> +=09word_off =3D mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +=09=09=09=09=09=09 MLXBF_PKA_RING_RW_STAT_0_ADDR + ring_spacing,
> +=09=09=09=09=09=09 MLXBF_PKA_BUFFER_RAM_SIZE);
> +=09mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, 0);
> +
> +=09return 0;
> +}
> +
> +/*
> + * Set up the control/status words. Upon a PKI command the EIP-154 maste=
r firmware will read and
> + * partially update the ring information.
> + */
> +static int mlxbf_pka_dev_set_ring_info(struct mlxbf_pka_dev_ring_t *ring=
)
> +{
> +=09u32 ring_cmmd_base_val;
> +=09u32 ring_rslt_base_val;
> +=09u32 ring_size_type_val;
> +=09int ret;
> +
> +=09/* Ring info configuration MUST be done when the PKA ring is initiali=
zed. */
> +=09if ((ring->shim->status !=3D MLXBF_PKA_SHIM_STATUS_INITIALIZED &&
> +=09     ring->shim->status !=3D MLXBF_PKA_SHIM_STATUS_RUNNING &&
> +=09     ring->shim->status !=3D MLXBF_PKA_SHIM_STATUS_STOPPED) ||
> +=09     ring->status !=3D MLXBF_PKA_DEV_RING_STATUS_INITIALIZED)
> +=09=09return -EPERM;
> +
> +=09/* Partition ring memory. */
> +=09ret =3D mlxbf_pka_dev_partition_mem(ring);
> +=09if (ret) {
> +=09=09pr_err("mlxbf_pka error: failed to initialize ring memory\n");

dev_err(), please go through all printing.

> +=09=09return ret;
> +=09}
> +
> +=09/* Fill ring information. */
> +=09ring_cmmd_base_val =3D ring->ring_info->cmmd_base;
> +=09ring_rslt_base_val =3D ring->ring_info->rslt_base;
> +=09ring_size_type_val =3D (ring->ring_info->in_order &
> +=09=09=09     MLXBF_PKA_RING_INFO_IN_ORDER_MASK) <<
> +=09=09=09     MLXBF_PKA_RING_INFO_IN_ORDER_OFFSET;

Looks FIELD_PREP().

> +=09ring_size_type_val |=3D (ring->ring_info->host_desc_size &
> +=09=09=09      MLXBF_PKA_RING_INFO_HOST_DESC_SIZE_MASK) <<
> +=09=09=09      MLXBF_PKA_RING_INFO_HOST_DESC_SIZE_OFFSET;

Ditto.

> +=09ring_size_type_val |=3D (ring->num_cmd_desc - 1) & MLXBF_PKA_RING_NUM=
_CMD_DESC_MASK;
> +
> +=09/* Write ring information status/control words in the PKA Buffer RAM.=
 */
> +=09ret =3D mlxbf_pka_dev_write_ring_info(&ring->shim->resources.buffer_r=
am,
> +=09=09=09=09=09    ring->ring_id % MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS,
> +=09=09=09=09=09    ring_cmmd_base_val,
> +=09=09=09=09=09    ring_rslt_base_val,
> +=09=09=09=09=09    ring_size_type_val);
> +=09if (ret) {
> +=09=09pr_err("mlxbf_pka error: failed to write ring information\n");
> +=09=09return ret;
> +=09}
> +
> +=09ring->status =3D MLXBF_PKA_DEV_RING_STATUS_READY;
> +
> +=09return ret;
> +}
> +
> +/*
> + * Create shim. Set shim parameters and configure shim resources. It ret=
urns 0 on success, a
> + * negative error code on failure.

Even if not explicitly marking things for kerneldoc (with /**), please use=
=20
the format compatible with it, so:

/*
 * mlxbf_pka_dev_create_shim - Create shim.
 *
 * Set shim parameters and configure shim resources.
 *
 * Return: ...
 */

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
> +=09shim->ring_type =3D MLXBF_PKA_RING_TYPE_IN_ORDER;
> +=09shim->ring_priority =3D MLXBF_PKA_RING_OPTIONS_PRIORITY;
> +=09shim->rings_num =3D MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS;
> +=09shim->rings =3D devm_kzalloc(dev,
> +=09=09=09=09   shim->rings_num * sizeof(struct mlxbf_pka_dev_ring_t),

devm_kcalloc() ?

> +=09=09=09=09   GFP_KERNEL);
> +=09if (!shim->rings) {
> +=09=09dev_err(dev, "unable to allocate memory for ring\n");
> +=09=09return -ENOMEM;
> +=09}
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
> +=09/* Set PKA device TRNG registers. */
> +=09reg_size =3D PAGE_SIZE;
> +=09reg_base =3D mlxbf_pka_dev_get_register_base(shim->mem_res.eip154_bas=
e,
> +=09=09=09=09=09=09   MLXBF_PKA_TRNG_OUTPUT_0_ADDR);
> +=09ret =3D mlxbf_pka_dev_set_resource_config(dev,
> +=09=09=09=09=09=09shim,
> +=09=09=09=09=09=09&shim->resources.trng_csr,
> +=09=09=09=09=09=09reg_base,
> +=09=09=09=09=09=09reg_size,
> +=09=09=09=09=09=09MLXBF_PKA_DEV_RES_TYPE_REG,
> +=09=09=09=09=09=09"MLXBF_PKA_TRNG_CSR");
> +=09if (ret) {
> +=09=09dev_err(dev, "unable to setup the TRNG\n");
> +=09=09return ret;
> +=09}
> +
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_CREATED;
> +
> +=09return ret;
> +}
> +
> +/* Delete shim and unset shim resources. */
> +static int mlxbf_pka_dev_delete_shim(struct mlxbf_pka_dev_shim_s *shim)
> +{
> +=09struct mlxbf_pka_dev_res_t *res_master_seq_ctrl, *res_aic_csr, *res_t=
rng_csr;
> +=09struct mlxbf_pka_dev_res_t *res_buffer_ram;
> +
> +=09pr_debug("mlxbf_pka: PKA device delete shim\n");
> +
> +=09if (shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_UNDEFINED)
> +=09=09return 0;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_FINALIZED &&
> +=09    shim->status !=3D MLXBF_PKA_SHIM_STATUS_CREATED) {
> +=09=09pr_err("mlxbf_pka error: PKA device status must be finalized\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09res_buffer_ram =3D &shim->resources.buffer_ram;
> +=09res_master_seq_ctrl =3D &shim->resources.master_seq_ctrl;
> +=09res_aic_csr =3D &shim->resources.aic_csr;
> +=09res_trng_csr =3D &shim->resources.trng_csr;
> +
> +=09mlxbf_pka_dev_unset_resource_config(shim, res_buffer_ram);
> +=09mlxbf_pka_dev_unset_resource_config(shim, res_master_seq_ctrl);
> +=09mlxbf_pka_dev_unset_resource_config(shim, res_aic_csr);
> +=09mlxbf_pka_dev_unset_resource_config(shim, res_trng_csr);
> +
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_UNDEFINED;
> +
> +=09return 0;
> +}
> +
> +/* Configure ring options. */
> +static int mlxbf_pka_dev_config_ring_options(struct mlxbf_pka_dev_res_t =
*buffer_ram_ptr,
> +=09=09=09=09=09     u32 rings_num,
> +=09=09=09=09=09     u8 ring_priority)
> +{
> +=09u64 control_word;
> +=09u64 word_off;
> +
> +=09if (buffer_ram_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +=09    buffer_ram_ptr->type !=3D MLXBF_PKA_DEV_RES_TYPE_MEM)
> +=09=09return -EPERM;
> +
> +=09if (rings_num > MLXBF_PKA_MAX_NUM_RINGS || rings_num < 1) {
> +=09=09pr_err("mlxbf_pka error: invalid rings number\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09pr_debug("mlxbf_pka: configure PKA ring options control word\n");
> +
> +=09/*
> +=09 * Write MLXBF_PKA_RING_OPTIONS control word located in the MLXBF_PKA=
_BUFFER_RAM. The value
> +=09 * of this word is determined by the PKA I/O block (Shim). Set the nu=
mber of implemented
> +=09 * command/result ring pairs that is available in this EIP-154, encod=
ed as binary value,
> +=09 * which is 4.
> +=09 */
> +=09control_word =3D (u64)0x0;

Unnecessary cast.

> +=09control_word |=3D ring_priority & MLXBF_PKA_RING_OPTIONS_RING_PRIORIT=
Y_MASK;

FIELD_PREP()

> +=09control_word |=3D ((rings_num - 1) << MLXBF_PKA_RING_OPTIONS_RING_NUM=
_OFFSET) &
> +=09=09=09MLXBF_PKA_RING_OPTIONS_RING_NUM_MASK;

FIELD_PREP()

> +=09control_word |=3D (MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE <<
> +=09=09=09MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE_OFFSET) &
> +=09=09=09MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE_MASK;

FIELD_PREP()

You can alternatively chain these with |.

> +=09word_off =3D mlxbf_pka_dev_get_word_offset(buffer_ram_ptr->base,
> +=09=09=09=09=09=09 MLXBF_PKA_RING_OPTIONS_ADDR,
> +=09=09=09=09=09=09 MLXBF_PKA_BUFFER_RAM_SIZE);
> +=09mlxbf_pka_dev_io_write(buffer_ram_ptr->ioaddr, word_off, control_word=
);
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_dev_config_trng_clk(struct mlxbf_pka_dev_res_t *aic=
_csr_ptr)
> +{
> +=09u32 trng_clk_en =3D 0;
> +=09void __iomem *csr_reg_ptr;
> +=09u64 csr_reg_base;
> +=09u64 csr_reg_off;
> +=09u64 timer;
> +
> +=09if (aic_csr_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +=09    aic_csr_ptr->type !=3D MLXBF_PKA_DEV_RES_TYPE_REG)
> +=09=09return -EPERM;
> +
> +=09pr_debug("mlxbf_pka: turn on TRNG clock\n");

dev_dbg()

> +
> +=09csr_reg_base =3D aic_csr_ptr->base;
> +=09csr_reg_ptr =3D aic_csr_ptr->ioaddr;
> +
> +=09/*
> +=09 * Enable the TRNG clock in MLXBF_PKA_CLK_FORCE. In general, this reg=
ister should be left in
> +=09 * its default state of all zeroes. Only when the TRNG is directly co=
ntrolled via the Host
> +=09 * slave interface, the engine needs to be turned on using the 'trng_=
clk_on' bit in this
> +=09 * register. In case the TRNG is controlled via internal firmware, th=
is is not required.
> +=09 */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_CLK_FORCE_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_CLK_FORCE_=
TRNG_ON);
> +=09/*
> +=09 * Check whether the system clock for TRNG engine is enabled. The clo=
ck MUST be running to
> +=09 * provide access to the TRNG.
> +=09 */
> +=09timer =3D mlxbf_pka_dev_timer_start_msec(100);
> +=09while (!trng_clk_en) {
> +=09=09trng_clk_en |=3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off)
> +=09=09=09=09=09=09     & MLXBF_PKA_CLK_FORCE_TRNG_ON;
> +=09=09if (mlxbf_pka_dev_timer_done(timer)) {
> +=09=09=09pr_debug("mlxbf_pka: failed to enable TRNG clock\n");
> +=09=09=09return -EAGAIN;
> +=09=09}
> +=09}
> +=09pr_debug("mlxbf_pka: trng_clk_on is enabled\n");
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_dev_trng_wait_test_ready(void __iomem *csr_reg_ptr,=
 u64 csr_reg_base)
> +{
> +=09u64 csr_reg_off, timer, csr_reg_val, test_ready =3D 0;
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_STATUS_ADDR);
> +=09timer =3D mlxbf_pka_dev_timer_start_msec(1000);

MSEC_PER_SEC ?

> +
> +=09while (!test_ready) {
> +=09=09csr_reg_val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09=09test_ready =3D csr_reg_val & MLXBF_PKA_TRNG_STATUS_TEST_READY;
> +
> +=09=09if (mlxbf_pka_dev_timer_done(timer)) {
> +=09=09=09pr_debug("mlxbf_pka: TRNG test ready timer done, 0x%llx\n", csr=
_reg_val);
> +=09=09=09return 1;
> +=09=09}
> +=09}
> +
> +=09return 0;

Should this function return bool ?

> +}
> +
> +static int mlxbf_pka_dev_trng_enable_test(void __iomem *csr_reg_ptr, u64=
 csr_reg_base, u32 test)
> +{
> +=09u64 csr_reg_val, csr_reg_off;
> +
> +=09/*
> +=09 * Set the 'test_mode' bit in the TRNG_CONTROL register and the 'test=
_known_noise' bit in
> +=09 * the TRNG_TEST register =E2=80=93 this will immediately set the 'te=
st_ready' bit (in the
> +=09 * TRNG_STATUS register) to indicate that data can be written. It wil=
l also reset the
> +=09 * 'monobit test', 'run test' and 'poker test' circuits to their init=
ial states. Note that
> +=09 * the TRNG need not be enabled for this test.
> +=09 */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09csr_reg_val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
> +=09=09=09       csr_reg_val | MLXBF_PKA_TRNG_CONTROL_TEST_MODE);
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_TEST_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, test);
> +=09/* Wait until the 'test_ready' bit is set. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_STATUS_ADDR);
> +=09do {
> +=09=09csr_reg_val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09} while (!(csr_reg_val & MLXBF_PKA_TRNG_STATUS_TEST_READY));
> +
> +=09/* Check whether the 'monobit test', 'run test' and 'poker test' are =
reset. */
> +=09if (csr_reg_val &
> +=09    (MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL |
> +=09    MLXBF_PKA_TRNG_STATUS_RUN_FAIL |
> +=09    MLXBF_PKA_TRNG_STATUS_POKER_FAIL)) {

Align.

> +=09=09pr_err("mlxbf_pka error: test bits aren't reset, TRNG_STATUS:0x%ll=
x\n",
> +=09=09       csr_reg_val);
> +=09=09return -EAGAIN;
> +=09}
> +
> +=09/*
> +=09 * Set 'stall_run_poker' bit to allow inspecting the state of the res=
ult counters which
> +=09 * would otherwise be reset immediately for the next 20,000 bits bloc=
k to test.
> +=09 */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_ALARMCNT_ADDR);
> +=09csr_reg_val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr,
> +=09=09=09       csr_reg_off,
> +=09=09=09       csr_reg_val | MLXBF_PKA_TRNG_ALARMCNT_STALL_RUN_POKER);
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_dev_trng_test_circuits(void __iomem *csr_reg_ptr,
> +=09=09=09=09=09    u64 csr_reg_base,
> +=09=09=09=09=09    u64 datal, u64 datah,
> +=09=09=09=09=09    int count, u8 add_half,
> +=09=09=09=09=09    u64 *monobit_fail_cnt,
> +=09=09=09=09=09    u64 *run_fail_cnt,
> +=09=09=09=09=09    u64 *poker_fail_cnt)
> +{
> +=09u64 status, csr_reg_off;
> +=09int test_idx;

unsigned int.

> +
> +=09if (!monobit_fail_cnt || !run_fail_cnt || !poker_fail_cnt)
> +=09=09return -EINVAL;
> +
> +=09for (test_idx =3D 0; test_idx < count; test_idx++) {
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_RAW_L_ADDR);
> +=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, datal);
> +
> +=09=09if (add_half) {
> +=09=09=09if (test_idx < count - 1) {
> +=09=09=09=09csr_reg_off =3D
> +=09=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,

Misaligned.

> +=09=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_RAW_H_ADDR);
> +=09=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, datah);
> +=09=09=09}
> +=09=09} else {
> +=09=09=09csr_reg_off =3D
> +=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_RAW_H_ADDR);
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, datah);
> +=09=09}

The entire logic here should be rethought such that code is not=20
duplicated.

> +
> +=09=09/*
> +=09=09 * Wait until the 'test_ready' bit in the TRNG_STATUS register bec=
omes '1' again,
> +=09=09 * signaling readiness for the next 64 bits of test data. At this =
point, the
> +=09=09 * previous test data has been handled so the counter states can b=
e inspected.
> +=09=09 */
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_STATUS_ADDR);
> +=09=09do {
> +=09=09=09status =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09=09} while (!(status & MLXBF_PKA_TRNG_STATUS_TEST_READY));

Infinite loop if HW misbehaves? Use read_poll_timeout() & handle errors.

> +
> +=09=09/* Check test status bits. */
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_INTACK_ADDR);
> +=09=09if (status & MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL) {
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL);
> +=09=09=09*monobit_fail_cnt +=3D 1;
> +=09=09} else if (status & MLXBF_PKA_TRNG_STATUS_RUN_FAIL) {
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_STATUS_RUN_FAIL);
> +=09=09=09*run_fail_cnt +=3D 1;
> +=09=09} else if (status & MLXBF_PKA_TRNG_STATUS_POKER_FAIL) {
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_STATUS_POKER_FAIL);
> +=09=09=09*poker_fail_cnt +=3D 1;
> +=09=09}

Are these fails prioritized like this so it's should count just into one=20
counter if more than one FAIL is asserted?

> +=09}
> +
> +=09return (*monobit_fail_cnt || *poker_fail_cnt || *run_fail_cnt) ? -EIO=
 : 0;
> +}
> +
> +static void mlxbf_pka_dev_trng_disable_test(void __iomem *csr_reg_ptr, u=
64 csr_reg_base)
> +{
> +=09u64 status, val, csr_reg_off;

Add an empty line.

> +=09/*
> +=09 * When done, clear the 'test_known_noise' bit in the TRNG_TEST regis=
ter (will immediately
> +=09 * clear the 'test_ready' bit in the TRNG_STATUS register and reset t=
he 'monobit test',
> +=09 * 'run test' and 'poker test' circuits) and clear the 'test_mode' bi=
t in the TRNG_CONTROL
> +=09 * register.
> +=09 */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_TEST_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_STATUS_ADDR);
> +=09status =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +
> +=09if (status & MLXBF_PKA_TRNG_STATUS_TEST_READY)
> +=09=09pr_info("mlxbf_pka warning: test ready bit is still set\n");
> +
> +=09if (status &
> +=09    (MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL |
> +=09    MLXBF_PKA_TRNG_STATUS_RUN_FAIL |
> +=09    MLXBF_PKA_TRNG_STATUS_POKER_FAIL))

Fix alignment.

Add define for this bit combination as you used it twice already.

> +=09=09pr_info("mlxbf_pka warning: test bits are still set, TRNG_STATUS:0=
x%llx\n", status);
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, (val & ~MLXBF_PKA_TR=
NG_STATUS_TEST_READY));
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_ALARMCNT_ADDR);
> +=09val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr,
> +=09=09=09       csr_reg_off,
> +=09=09=09       (val & ~MLXBF_PKA_TRNG_ALARMCNT_STALL_RUN_POKER));
> +}
> +
> +static int mlxbf_pka_dev_trng_test_known_answer_basic(void __iomem *csr_=
reg_ptr, u64 csr_reg_base)
> +{
> +=09u64 poker_cnt[MLXBF_PKA_TRNG_POKER_TEST_CNT];
> +=09u64 monobit_fail_cnt =3D 0;
> +=09u64 poker_fail_cnt =3D 0;
> +=09u64 run_fail_cnt =3D 0;
> +=09u64 monobit_cnt;
> +=09u64 csr_reg_off;
> +=09int cnt_idx;
> +=09int cnt_off;
> +=09int ret;
> +
> +=09pr_debug("mlxbf_pka: run known-answer test circuits\n");
> +
> +=09ret =3D mlxbf_pka_dev_trng_enable_test(csr_reg_ptr, csr_reg_base,
> +=09=09=09=09=09     MLXBF_PKA_TRNG_TEST_KNOWN_NOISE);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D mlxbf_pka_dev_trng_test_circuits(csr_reg_ptr,
> +=09=09=09=09=09       csr_reg_base,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_TEST_DATAL_BASIC_1,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_TEST_DATAH_BASIC_1,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_TEST_COUNT_BASIC_1,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_TEST_HALF_NO,
> +=09=09=09=09=09       &monobit_fail_cnt,
> +=09=09=09=09=09       &run_fail_cnt,
> +=09=09=09=09=09       &poker_fail_cnt);
> +
> +=09ret |=3D mlxbf_pka_dev_trng_test_circuits(csr_reg_ptr,
> +=09=09=09=09=09=09csr_reg_base,
> +=09=09=09=09=09=09MLXBF_PKA_TRNG_TEST_DATAL_BASIC_2,
> +=09=09=09=09=09=09MLXBF_PKA_TRNG_TEST_DATAH_BASIC_2,
> +=09=09=09=09=09=09MLXBF_PKA_TRNG_TEST_COUNT_BASIC_2,
> +=09=09=09=09=09=09MLXBF_PKA_TRNG_TEST_HALF_ADD,
> +=09=09=09=09=09=09&monobit_fail_cnt,
> +=09=09=09=09=09=09&run_fail_cnt,
> +=09=09=09=09=09=09&poker_fail_cnt);
> +
> +=09pr_debug("mlxbf_pka: monobit_fail_cnt : 0x%llx\n", monobit_fail_cnt);
> +=09pr_debug("mlxbf_pka: poker_fail_cnt   : 0x%llx\n", poker_fail_cnt);
> +=09pr_debug("mlxbf_pka: run_fail_cnt     : 0x%llx\n", run_fail_cnt);
> +
> +=09for (cnt_idx =3D 0, cnt_off =3D 0;
> +=09     cnt_idx < MLXBF_PKA_TRNG_POKER_TEST_CNT;
> +=09     cnt_idx++, cnt_off +=3D 8) {
> +=09=09csr_reg_off =3D
> +=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,

Misaligned.

> +=09=09=09=09=09=09  (MLXBF_PKA_TRNG_POKER_3_0_ADDR + cnt_off));
> +=09=09poker_cnt[cnt_idx] =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_=
off);
> +=09}
> +
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base,

Misaligned.

> +=09=09=09=09=09  MLXBF_PKA_TRNG_MONOBITCNT_ADDR);
> +=09monobit_cnt =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +
> +=09if (!ret) {

Reverse logic + use goto.

> +=09=09if (memcmp(poker_cnt,
> +=09=09=09   poker_test_exp_cnt,
> +=09=09=09   sizeof(poker_test_exp_cnt))) {
> +=09=09=09pr_debug("mlxbf_pka: invalid poker counters!\n");
> +=09=09=09ret =3D -EIO;
> +=09=09}
> +
> +=09=09if (monobit_cnt !=3D MLXBF_PKA_TRNG_MONOBITCNT_SUM) {
> +=09=09=09pr_debug("mlxbf_pka: invalid sum of squares!\n");
> +=09=09=09ret =3D -EIO;
> +=09=09}
> +=09}
> +
> +=09mlxbf_pka_dev_trng_disable_test(csr_reg_ptr, csr_reg_base);
> +
> +=09return ret;
> +}
> +
> +static int mlxbf_pka_dev_trng_test_known_answer_poker_fail(void __iomem =
*csr_reg_ptr,
> +=09=09=09=09=09=09=09   u64 csr_reg_base)
> +{
> +=09u64 monobit_fail_cnt =3D 0;
> +=09u64 poker_fail_cnt =3D 0;
> +=09u64 run_fail_cnt =3D 0;
> +
> +=09pr_debug("mlxbf_pka: run known-answer test circuits (poker fail)\n");
> +
> +=09mlxbf_pka_dev_trng_enable_test(csr_reg_ptr, csr_reg_base, MLXBF_PKA_T=
RNG_TEST_KNOWN_NOISE);
> +
> +=09/*
> +=09 * Ignore the return value here as it is expected that poker test sho=
uld fail. Check failure
> +=09 * counts thereafter to assert only poker test has failed.
> +=09 */
> +=09mlxbf_pka_dev_trng_test_circuits(csr_reg_ptr,
> +=09=09=09=09=09 csr_reg_base,
> +=09=09=09=09=09 MLXBF_PKA_TRNG_TEST_DATAL_POKER,
> +=09=09=09=09=09 MLXBF_PKA_TRNG_TEST_DATAH_POKER,
> +=09=09=09=09=09 MLXBF_PKA_TRNG_TEST_COUNT_POKER,
> +=09=09=09=09=09 MLXBF_PKA_TRNG_TEST_HALF_NO,
> +=09=09=09=09=09 &monobit_fail_cnt,
> +=09=09=09=09=09 &run_fail_cnt,
> +=09=09=09=09=09 &poker_fail_cnt);
> +
> +=09pr_debug("mlxbf_pka: monobit_fail_cnt : 0x%llx\n", monobit_fail_cnt);
> +=09pr_debug("mlxbf_pka: poker_fail_cnt   : 0x%llx\n", poker_fail_cnt);
> +=09pr_debug("mlxbf_pka: run_fail_cnt     : 0x%llx\n", run_fail_cnt);
> +
> +=09mlxbf_pka_dev_trng_disable_test(csr_reg_ptr, csr_reg_base);
> +
> +=09return (poker_fail_cnt && !run_fail_cnt && !monobit_fail_cnt) ? 0 : -=
EIO;
> +}
> +
> +static int mlxbf_pka_dev_trng_test_unknown_answer(void __iomem *csr_reg_=
ptr, u64 csr_reg_base)
> +{
> +=09u64 datal =3D 0, datah =3D 0, csr_reg_off;
> +=09int ret =3D 0, test_idx;
> +
> +=09pr_debug("mlxbf_pka: run unknown-answer self test\n");
> +
> +=09/* First reset, the RAW registers. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_RAW_L_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_RAW_H_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09/*
> +=09 * There is a small probability for this test to fail. So run the tes=
t 10 times, if it
> +=09 * succeeds once then assume that the test passed.
> +=09 */
> +=09for (test_idx =3D 0; test_idx < 10; test_idx++) {
> +=09=09mlxbf_pka_dev_trng_enable_test(csr_reg_ptr, csr_reg_base,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_TEST_NOISE);
> +
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_RAW_L_ADDR);
> +=09=09datal =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_RAW_H_ADDR);
> +=09=09datah =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +
> +=09=09pr_debug("mlxbf_pka: datal=3D0x%llx\n", datal);
> +=09=09pr_debug("mlxbf_pka: datah=3D0x%llx\n", datah);
> +
> +=09=09mlxbf_pka_dev_trng_disable_test(csr_reg_ptr, csr_reg_base);
> +
> +=09=09if (!datah && !datal)
> +=09=09=09ret =3D -EIO;
> +=09=09else
> +=09=09=09return 0;
> +=09}
> +=09return ret;
> +}
> +
> +/* Test TRNG. */
> +static int mlxbf_pka_dev_test_trng(void __iomem *csr_reg_ptr, u64 csr_re=
g_base)
> +{
> +=09int ret;
> +
> +=09ret =3D mlxbf_pka_dev_trng_test_known_answer_basic(csr_reg_ptr, csr_r=
eg_base);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D mlxbf_pka_dev_trng_test_known_answer_poker_fail(csr_reg_ptr, =
csr_reg_base);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09ret =3D mlxbf_pka_dev_trng_test_unknown_answer(csr_reg_ptr, csr_reg_b=
ase);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09return ret;
> +}
> +
> +static void mlxbf_pka_dev_trng_write_ps_ai_str(void __iomem *csr_reg_ptr=
,
> +=09=09=09=09=09       u64 csr_reg_base,
> +=09=09=09=09=09       u32 input_str[])
> +{
> +=09u64 csr_reg_off;
> +=09int i;

unsigned int for loop variables that count from 0 upwards.

> +
> +=09for (i =3D 0; i < MLXBF_PKA_TRNG_PS_AI_REG_COUNT; i++) {
> +=09=09csr_reg_off =3D
> +=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,

Please fix all these alignment issues.

> +=09=09=09=09=09=09  MLXBF_PKA_TRNG_PS_AI_0_ADDR +
> +=09=09=09=09=09=09  (i * MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET));

Unnecessary ().

> +
> +=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, input_str[i]);
> +=09}
> +}
> +
> +static void mlxbf_pka_dev_trng_drbg_generate(void __iomem *csr_reg_ptr, =
u64 csr_reg_base)
> +{
> +=09u64 csr_reg_off;
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTR=
OL_REQ_DATA_VAL);
> +}
> +
> +static int mlxbf_pka_dev_test_trng_drbg(void __iomem *csr_reg_ptr, u64 c=
sr_reg_base)
> +{
> +=09u64 csr_reg_off, csr_reg_val;
> +=09int i, ret;
> +
> +=09/* Make sure the engine is idle. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09/* Enable DRBG, TRNG need not be enabled for this test. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTR=
OL_DRBG_ENABLE_VAL);
> +
> +=09/* Set 'test_sp_800_90' bit in the TRNG_TEST register. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_TEST_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_TEST_=
DRBG_VAL);
> +
> +=09/* Wait for 'test_ready' bit to be set. */
> +=09ret =3D mlxbf_pka_dev_trng_wait_test_ready(csr_reg_ptr, csr_reg_base)=
;
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* 'Instantiate' function. */
> +=09mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr,
> +=09=09=09=09=09   csr_reg_base,
> +=09=09=09=09=09   mlxbf_pka_trng_drbg_test_ps_str);
> +=09ret =3D mlxbf_pka_dev_trng_wait_test_ready(csr_reg_ptr, csr_reg_base)=
;
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* 'Generate' function. */
> +=09mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr,
> +=09=09=09=09=09   csr_reg_base,
> +=09=09=09=09=09   mlxbf_pka_trng_drbg_test_etpy_str1);
> +=09ret =3D mlxbf_pka_dev_trng_wait_test_ready(csr_reg_ptr, csr_reg_base)=
;
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/*
> +=09 * A standard NIST SP 800-90A DRBG known-answer test discards the res=
ult of the first
> +=09 * 'Generate' function and only checks the result of the second 'Gene=
rate' function. Hence
> +=09 * 'Generate' is performed again.
> +=09 */
> +
> +=09/* 'Generate' function. */
> +=09mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr,
> +=09=09=09=09=09   csr_reg_base,
> +=09=09=09=09=09   mlxbf_pka_trng_drbg_test_etpy_str2);
> +=09ret =3D mlxbf_pka_dev_trng_wait_test_ready(csr_reg_ptr, csr_reg_base)=
;
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Check output registers. */
> +=09for (i =3D 0; i < MLXBF_PKA_TRNG_OUTPUT_CNT; i++) {
> +=09=09csr_reg_off =3D
> +=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09  MLXBF_PKA_TRNG_OUTPUT_0_ADDR +
> +=09=09=09=09=09=09  (i * MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET));
> +
> +=09=09csr_reg_val =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +
> +=09=09if ((u32)csr_reg_val !=3D mlxbf_pka_trng_drbg_test_output[i]) {
> +=09=09=09pr_debug
> +=09=09=09("mlxbf_pka: DRBG known answer test failed: output register:%d,=
 0x%x\n",
> +=09=09=09 i, (u32)csr_reg_val);
> +=09=09=09return 1;
> +=09=09}
> +=09}
> +
> +=09/* Clear 'test_sp_800_90' bit in the TRNG_TEST register. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_TEST_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09return 0;
> +}
> +
> +/* Configure the TRNG. */
> +static int mlxbf_pka_dev_config_trng_drbg(struct mlxbf_pka_dev_res_t *ai=
c_csr_ptr,
> +=09=09=09=09=09  struct mlxbf_pka_dev_res_t *trng_csr_ptr)
> +{
> +=09u64  csr_reg_base, csr_reg_off;
> +=09void __iomem *csr_reg_ptr;
> +=09int ret;
> +
> +=09if (trng_csr_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +=09    trng_csr_ptr->type !=3D MLXBF_PKA_DEV_RES_TYPE_REG)
> +=09=09return -EPERM;
> +
> +=09pr_debug("mlxbf_pka: starting up the TRNG\n");
> +
> +=09ret =3D mlxbf_pka_dev_config_trng_clk(aic_csr_ptr);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09csr_reg_base =3D trng_csr_ptr->base;
> +=09csr_reg_ptr  =3D trng_csr_ptr->ioaddr;
> +
> +=09/*
> +=09 * Perform NIST known-answer tests on the complete SP 800-90A DRBG wi=
thout BC_DF
> +=09 * functionality.
> +=09 */
> +=09ret =3D mlxbf_pka_dev_test_trng_drbg(csr_reg_ptr, csr_reg_base);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Starting up the TRNG with a DRBG. */
> +
> +=09/* Make sure the engine is idle. */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09/* Disable all FROs initially. */
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_FROENA=
BLE_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_FRODET=
UNE_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09/*
> +=09 * Write all configuration values in the TRNG_CONFIG and TRNG_ALARMCN=
T, write zeroes to the
> +=09 * TRNG_ALARMMASK and TRNG_ALARMSTOP registers.
> +=09 */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONFIG_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONFI=
G_REG_VAL);
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_ALARMCNT_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_ALARM=
CNT_REG_VAL);
> +
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMM=
ASK_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMS=
TOP_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09/*
> +=09 * Enable all FROs in the TRNG_FROENABLE register. Note that this can=
 only be done after
> +=09 * clearing the TRNG_ALARMSTOP register.
> +=09 */
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_FROENA=
BLE_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_FROEN=
ABLE_REG_VAL);
> +
> +=09/*
> +=09 * Optionally, write 'Personalization string' of up to 384 bits in TR=
NG_PS_AI_xxx registers.
> +=09 * The contents of these registers will be XOR-ed into the output of =
the SHA-256
> +=09 * 'Conditioning Function' to be used as seed value for the actual DR=
BG.
> +=09 */
> +=09mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr, csr_reg_base, mlxbf_p=
ka_trng_drbg_ps_str);
> +
> +=09/*
> +=09 * Run TRNG tests after configuring TRNG.
> +=09 * NOTE: TRNG need not be enabled to carry out these tests.
> +=09 */
> +=09ret =3D mlxbf_pka_dev_test_trng(csr_reg_ptr, csr_reg_base);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/*
> +=09 * Start the actual engine by setting the 'enable_trng' and 'drbg_en'=
 bit in the
> +=09 * TRNG_CONTROL register (also a nice point to set the interrupt mask=
 bits).
> +=09 */
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTR=
OL_DRBG_REG_VAL);
> +
> +=09/*
> +=09 * The engine is now ready to handle the first 'Generate' request usi=
ng the 'request_data'
> +=09 * bit of the TRNG_CONTROL register. The first output for these reque=
sts will take a while,
> +=09 * as Noise Source and Conditioning Function must first generate seed=
 entropy for the DRBG.
> +=09 *
> +=09 * Optionally, when buffer RAM is configured: Set a data available in=
terrupt threshold using
> +=09 * the 'load_thresh' and 'blocks_thresh' fields of the TRNG_INTACK re=
gister. This allows
> +=09 * delaying the data available interrupt until the indicated number o=
f 128-bit words are
> +=09 * available in the buffer RAM.
> +=09 *
> +=09 * Start the actual 'Generate' operation using the 'request_data' and=
 'data_blocks' fields
> +=09 * of the TRNG_CONTROL register.
> +=09 */
> +=09mlxbf_pka_dev_trng_drbg_generate(csr_reg_ptr, csr_reg_base);
> +
> +=09/* Delay 200 ms. */
> +=09mdelay(200);
> +
> +=09return 0;
> +}
> +
> +/*
> + * Initialize PKA IO block referred to as shim. It configures shim's par=
ameters and prepare
> + * resources by mapping corresponding memory. The function also configur=
es shim registers and load
> + * firmware to shim internal rams. The struct mlxbf_pka_dev_shim_s passe=
d as input is also an
> + * output. It returns 0 on success, a negative error code on failure.
> + */
> +static int mlxbf_pka_dev_init_shim(struct mlxbf_pka_dev_shim_s *shim)
> +{
> +=09u32 data[MLXBF_PKA_TRNG_OUTPUT_CNT];
> +=09int ret;
> +=09u8 i;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_CREATED) {
> +=09=09pr_err("mlxbf_pka error: PKA device must be created\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09/* Configure PKA Ring options control word. */
> +=09ret =3D mlxbf_pka_dev_config_ring_options(&shim->resources.buffer_ram=
,
> +=09=09=09=09=09=09shim->rings_num,
> +=09=09=09=09=09=09shim->ring_priority);
> +=09if (ret) {
> +=09=09pr_err("mlxbf_pka error: failed to configure ring options\n");
> +=09=09return ret;
> +=09}
> +
> +=09shim->trng_enabled   =3D MLXBF_PKA_SHIM_TRNG_ENABLED;
> +=09shim->trng_err_cycle =3D 0;
> +
> +=09/* Configure the TRNG. */
> +=09ret =3D mlxbf_pka_dev_config_trng_drbg(&shim->resources.aic_csr, &shi=
m->resources.trng_csr);
> +
> +=09/*
> +=09 * Pull out data from the content of the TRNG buffer RAM and start th=
e regeneration of new
> +=09 * numbers; read and drop 512 words. The read must be done over the 4=
 TRNG_OUTPUT_X
> +=09 * registers at a time.
> +=09 */
> +=09for (i =3D 0; i < MLXBF_PKA_TRNG_NUM_OF_FOUR_WORD; i++)
> +=09=09mlxbf_pka_dev_trng_read(shim, data, sizeof(data));
> +
> +=09if (ret) {
> +=09=09/* Keep running without TRNG since it does not hurt, but notify us=
ers. */
> +=09=09pr_err("mlxbf_pka error: failed to configure TRNG\n");
> +=09=09shim->trng_enabled =3D MLXBF_PKA_SHIM_TRNG_DISABLED;
> +=09}
> +
> +=09mutex_init(&shim->mutex);

devm_mutex_init() + error handling

> +=09shim->busy_ring_num =3D 0;
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_INITIALIZED;
> +
> +=09return ret;
> +}
> +
> +/* Release a given shim. */
> +static int mlxbf_pka_dev_release_shim(struct mlxbf_pka_dev_shim_s *shim)
> +{
> +=09u32 ring_idx;
> +=09int ret =3D 0;
> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_INITIALIZED &&
> +=09    shim->status !=3D MLXBF_PKA_SHIM_STATUS_STOPPED) {
> +=09=09pr_err("mlxbf_pka error: PKA device must be initialized or stopped=
\n");
> +=09=09return -EPERM;
> +=09}
> +
> +=09/*
> +=09 * Release rings which belong to the shim. The operating system might=
 release ring devices
> +=09 * before shim devices. The global configuration must be checked befo=
re proceeding to the
> +=09 * release of ring devices.
> +=09 */
> +=09if (mlxbf_pka_gbl_config.dev_rings_cnt) {
> +=09=09for (ring_idx =3D 0; ring_idx < shim->rings_num; ring_idx++) {
> +=09=09=09ret =3D mlxbf_pka_dev_release_ring(shim->rings[ring_idx]);
> +=09=09=09if (ret) {
> +=09=09=09=09pr_err("mlxbf_pka error: failed to release ring %d\n", ring_=
idx);
> +=09=09=09=09return ret;
> +=09=09=09}
> +=09=09}
> +=09}
> +
> +=09shim->busy_ring_num =3D 0;
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_FINALIZED;
> +
> +=09return ret;
> +}
> +
> +/* Return the ring associated with the given identifier. */
> +struct mlxbf_pka_dev_ring_t *mlxbf_pka_dev_get_ring(u32 ring_id)
> +{
> +=09return mlxbf_pka_gbl_config.dev_rings[ring_id];
> +}
> +
> +/* Return the shim associated with the given identifier. */
> +struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id)
> +{
> +=09return mlxbf_pka_gbl_config.dev_shims[shim_id];
> +}
> +
> +struct mlxbf_pka_dev_ring_t *mlxbf_pka_dev_register_ring(struct device *=
dev,
> +=09=09=09=09=09=09=09 u32 ring_id,
> +=09=09=09=09=09=09=09 u32 shim_id)
> +{
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09struct mlxbf_pka_dev_ring_t *ring;
> +=09int ret;
> +
> +=09shim =3D mlxbf_pka_dev_get_shim(shim_id);
> +=09if (!shim)
> +=09=09return NULL;
> +
> +=09ring =3D devm_kzalloc(dev, sizeof(*ring), GFP_KERNEL);
> +=09if (!ring)
> +=09=09return NULL;
> +
> +=09ring->status =3D MLXBF_PKA_DEV_RING_STATUS_UNDEFINED;
> +
> +=09/* Initialize ring. */
> +=09ret =3D mlxbf_pka_dev_init_ring(dev, ring, ring_id, shim);
> +=09if (ret) {
> +=09=09dev_err(dev, "failed to initialize ring %d\n", ring_id);
> +=09=09mlxbf_pka_dev_release_ring(ring);
> +=09=09return NULL;
> +=09}
> +
> +=09mlxbf_pka_gbl_config.dev_rings[ring->ring_id] =3D ring;
> +=09mlxbf_pka_gbl_config.dev_rings_cnt +=3D 1;
> +
> +=09return ring;
> +}
> +
> +int mlxbf_pka_dev_unregister_ring(struct mlxbf_pka_dev_ring_t *ring)
> +{
> +=09if (!ring)
> +=09=09return -EINVAL;
> +
> +=09mlxbf_pka_gbl_config.dev_rings[ring->ring_id] =3D NULL;
> +=09mlxbf_pka_gbl_config.dev_rings_cnt -=3D 1;
> +
> +=09/* Release ring. */
> +=09return mlxbf_pka_dev_release_ring(ring);
> +}
> +
> +struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_register_shim(struct device *=
dev,
> +=09=09=09=09=09=09=09 u32 shim_id,
> +=09=09=09=09=09=09=09 struct mlxbf_pka_dev_mem_res *mem_res)
> +{
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09u8 split;
> +=09int ret;
> +
> +=09dev_dbg(dev, "register shim id=3D%u\n", shim_id);
> +
> +=09shim =3D devm_kzalloc(dev, sizeof(*shim), GFP_KERNEL);
> +=09if (!shim)
> +=09=09return shim;
> +
> +=09/*
> +=09 * Shim state MUST be set to undefined before calling 'mlxbf_pka_dev_=
create_shim' function.
> +=09 */
> +=09shim->status =3D MLXBF_PKA_SHIM_STATUS_UNDEFINED;
> +
> +=09/* Set the Window RAM user mode. */
> +=09split =3D MLXBF_PKA_SPLIT_WINDOW_RAM_MODE;
> +
> +=09/* Create PKA shim. */
> +=09ret =3D mlxbf_pka_dev_create_shim(dev, shim, shim_id, split, mem_res)=
;
> +=09if (ret) {
> +=09=09dev_err(dev, "failed to create shim %u\n", shim_id);
> +=09=09mlxbf_pka_dev_delete_shim(shim);
> +=09=09return NULL;
> +=09}
> +
> +=09/* Initialize PKA shim. */
> +=09ret =3D mlxbf_pka_dev_init_shim(shim);
> +=09if (ret) {
> +=09=09dev_err(dev, "failed to init shim %u\n", shim_id);
> +=09=09mlxbf_pka_dev_release_shim(shim);
> +=09=09mlxbf_pka_dev_delete_shim(shim);
> +=09=09return NULL;

Instead of duplicating rollbacks, please make a proper rollback path with=
=20
labels and gotos.

> +=09}
> +
> +=09mlxbf_pka_gbl_config.dev_shims[shim->shim_id] =3D shim;
> +=09mlxbf_pka_gbl_config.dev_shims_cnt +=3D 1;
> +
> +=09return shim;
> +}
> +
> +int mlxbf_pka_dev_unregister_shim(struct mlxbf_pka_dev_shim_s *shim)
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
> +=09ret =3D mlxbf_pka_dev_release_shim(shim);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Delete shim. */
> +=09return mlxbf_pka_dev_delete_shim(shim);
> +}
> +
> +static bool mlxbf_pka_dev_trng_shutdown_oflo(struct mlxbf_pka_dev_res_t =
*trng_csr_ptr,
> +=09=09=09=09=09     u64 *err_cycle)
> +{
> +=09u64 curr_cycle_cnt, fro_stopped_mask, fro_enabled_mask;
> +=09u64 csr_reg_base, csr_reg_off, csr_reg_value;
> +=09void __iomem *csr_reg_ptr;
> +
> +=09csr_reg_base =3D trng_csr_ptr->base;
> +=09csr_reg_ptr =3D trng_csr_ptr->ioaddr;
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_STATUS_ADDR);
> +=09csr_reg_value =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +
> +=09if (csr_reg_value & MLXBF_PKA_TRNG_STATUS_SHUTDOWN_OFLO) {
> +=09=09curr_cycle_cnt =3D get_cycles();
> +=09=09/*
> +=09=09 * See if any FROs were shut down. If they were, toggle bits in th=
e FRO detune
> +=09=09 * register and reenable the FROs.
> +=09=09 */
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_ALARMSTOP_ADDR);
> +=09=09fro_stopped_mask =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_of=
f);
> +=09=09if (fro_stopped_mask) {
> +=09=09=09csr_reg_off =3D
> +=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_FROENABLE_ADDR);
> +=09=09=09fro_enabled_mask =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg=
_off);
> +=09=09=09csr_reg_off =3D
> +=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_FRODETUNE_ADDR);
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, fro_stopped_ma=
sk);
> +
> +=09=09=09csr_reg_off =3D
> +=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_FROENABLE_ADDR);
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
> +=09=09=09=09=09       fro_stopped_mask | fro_enabled_mask);
> +=09=09}
> +
> +=09=09/* Reset the error. */
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_ALARMMASK_ADDR);
> +=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_ALARMSTOP_ADDR);
> +=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
> +
> +=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_INTACK_ADDR);
> +=09=09mlxbf_pka_dev_io_write(csr_reg_ptr,
> +=09=09=09=09       csr_reg_off,
> +=09=09=09=09       MLXBF_PKA_TRNG_STATUS_SHUTDOWN_OFLO);
> +
> +=09=09/*
> +=09=09 * If this error occurs again within about a second, the hardware =
is malfunctioning.
> +=09=09 * Disable the trng and return an error.
> +=09=09 */
> +=09=09if (*err_cycle &&
> +=09=09    (curr_cycle_cnt - *err_cycle < MLXBF_PKA_TRNG_TEST_ERR_CYCLE_M=
AX)) {
> +=09=09=09csr_reg_off =3D
> +=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_CONTROL_ADDR);
> +=09=09=09csr_reg_value  =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_o=
ff);
> +=09=09=09csr_reg_value &=3D ~MLXBF_PKA_TRNG_CONTROL_REG_VAL;
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, csr_reg_value)=
;
> +=09=09=09return false;
> +=09=09}
> +
> +=09=09*err_cycle =3D curr_cycle_cnt;
> +=09}
> +
> +=09return true;
> +}
> +
> +static int mlxbf_pka_dev_trng_drbg_reseed(void __iomem *csr_reg_ptr, u64=
 csr_reg_base)
> +{
> +=09u64 csr_reg_off;
> +=09int ret;
> +
> +=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF=
_PKA_TRNG_CONTROL_ADDR);
> +=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTR=
OL_DRBG_RESEED);
> +
> +=09ret =3D mlxbf_pka_dev_trng_wait_test_ready(csr_reg_ptr, csr_reg_base)=
;
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Write personalization string. */
> +=09mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr, csr_reg_base, mlxbf_p=
ka_trng_drbg_ps_str);
> +
> +=09return ret;
> +}
> +
> +/* Read from DRBG enabled TRNG. */
> +int mlxbf_pka_dev_trng_read(struct mlxbf_pka_dev_shim_s *shim, u32 *data=
, u32 cnt)
> +{
> +=09u64 csr_reg_base, csr_reg_off, csr_reg_value, timer;
> +=09struct mlxbf_pka_dev_res_t *trng_csr_ptr;
> +=09u8 output_idx, trng_ready =3D 0;
> +=09u32 data_idx, word_cnt;
> +=09void __iomem *csr_reg_ptr;
> +=09int ret =3D 0;
> +
> +=09if (!shim || !data || (cnt % MLXBF_PKA_TRNG_OUTPUT_CNT !=3D 0))
> +=09=09return -EINVAL;
> +
> +=09if (!cnt)
> +=09=09return ret;
> +
> +=09mutex_lock(&shim->mutex);

Please use guard() to reduce complexity of the error handling.

> +
> +=09trng_csr_ptr =3D &shim->resources.trng_csr;
> +
> +=09if (trng_csr_ptr->status !=3D MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
> +=09    trng_csr_ptr->type !=3D MLXBF_PKA_DEV_RES_TYPE_REG) {
> +=09=09ret =3D -EPERM;
> +=09=09goto exit;
> +=09}
> +
> +=09csr_reg_base =3D trng_csr_ptr->base;
> +=09csr_reg_ptr =3D trng_csr_ptr->ioaddr;
> +
> +=09if (!mlxbf_pka_dev_trng_shutdown_oflo(trng_csr_ptr, &shim->trng_err_c=
ycle)) {
> +=09=09ret =3D -EWOULDBLOCK;
> +=09=09goto exit;
> +=09}
> +
> +=09/* Determine the number of 32-bit words. */
> +=09word_cnt =3D cnt >> 2;

word_cnt =3D cnt >> ilog2(sizeof(u32));

With that, you don't need the comment at all as the code explains itself.

> +
> +=09for (data_idx =3D 0; data_idx < word_cnt; data_idx++) {
> +=09=09output_idx =3D data_idx % MLXBF_PKA_TRNG_OUTPUT_CNT;
> +
> +=09=09/* Tell the hardware to advance. */
> +=09=09if (!output_idx) {
> +=09=09=09csr_reg_off =3D mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09=09=09MLXBF_PKA_TRNG_INTACK_ADDR);
> +=09=09=09mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
> +=09=09=09=09=09       MLXBF_PKA_TRNG_STATUS_READY);
> +=09=09=09trng_ready =3D 0;
> +
> +=09=09=09/*
> +=09=09=09 * Check if 'data_blocks' field is zero in TRNG_CONTROL registe=
r. If it is
> +=09=09=09 * zero, need to issue a 'Reseed and Generate' request for DRBG=
 enabled
> +=09=09=09 * TRNG.
> +=09=09=09 */
> +=09=09=09csr_reg_off =3D
> +=09=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09=09=09  MLXBF_PKA_TRNG_CONTROL_ADDR);
> +=09=09=09csr_reg_value =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_of=
f);
> +
> +=09=09=09if (!((u32)csr_reg_value & MLXBF_PKA_TRNG_DRBG_DATA_BLOCK_MASK)=
) {
> +=09=09=09=09/* Issue reseed. */
> +=09=09=09=09ret =3D mlxbf_pka_dev_trng_drbg_reseed(csr_reg_ptr, csr_reg_=
base);
> +=09=09=09=09if (ret) {
> +=09=09=09=09=09ret =3D -EBUSY;
> +=09=09=09=09=09goto exit;
> +=09=09=09=09}
> +
> +=09=09=09=09/* Issue generate request. */
> +=09=09=09=09mlxbf_pka_dev_trng_drbg_generate(csr_reg_ptr, csr_reg_base);
> +=09=09=09}
> +=09=09}
> +
> +=09=09/*
> +=09=09 * Wait until a data word is available in the TRNG_OUTPUT_X regist=
ers, using the
> +=09=09 * interrupt and/or 'ready' status bit in the TRNG_STATUS register=
=2E The only way
> +=09=09 * this would hang is if the TRNG is never initialized. This funct=
ion cannot be
> +=09=09 * called if that happened.
> +=09=09 */
> +=09=09timer =3D mlxbf_pka_dev_timer_start_msec(1000);
> +=09=09csr_reg_off =3D
> +=09=09mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_STA=
TUS_ADDR);
> +=09=09while (!trng_ready) {
> +=09=09=09csr_reg_value =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_of=
f);
> +=09=09=09trng_ready =3D csr_reg_value & MLXBF_PKA_TRNG_STATUS_READY;

Eh, where's the closing brace?

> +
> +=09=09if (mlxbf_pka_dev_timer_done(timer)) {
> +=09=09=09pr_debug("mlxbf_pka: shim %u got error obtaining random number\=
n",
> +=09=09=09=09 shim->shim_id);
> +=09=09=09ret =3D -EBUSY;
> +=09=09=09goto exit;
> +=09=09}
> +=09}
> +
> +=09/* Read the registers. */
> +=09csr_reg_off =3D
> +=09mlxbf_pka_dev_get_register_offset(csr_reg_base,
> +=09=09=09=09=09  MLXBF_PKA_TRNG_OUTPUT_0_ADDR +
> +=09=09=09=09=09  (output_idx * MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET));
> +=09csr_reg_value =3D mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
> +=09data[data_idx] =3D (u32)csr_reg_value;
> +=09}

?????

> +
> +exit:
> +=09mutex_unlock(&shim->mutex);
> +=09return ret;
> +}
> +
> +bool mlxbf_pka_dev_has_trng(struct mlxbf_pka_dev_shim_s *shim)
> +{
> +=09if (!shim)
> +=09=09return false;
> +
> +=09return (shim->trng_enabled =3D=3D MLXBF_PKA_SHIM_TRNG_ENABLED);
> +}
> +
> +/* Syscall to open ring. */
> +static int __mlxbf_pka_dev_open_ring(u32 ring_id)
> +{
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09struct mlxbf_pka_dev_ring_t *ring;
> +=09int ret;
> +
> +=09if (!mlxbf_pka_gbl_config.dev_rings_cnt)
> +=09=09return -EPERM;
> +
> +=09ring =3D mlxbf_pka_dev_get_ring(ring_id);
> +=09if (!ring || !ring->shim)
> +=09=09return -ENXIO;
> +
> +=09shim =3D ring->shim;
> +
> +=09mutex_lock(&ring->mutex);

Use guard() so you can return instead of using gotos below.

> +
> +=09if (shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_UNDEFINED ||
> +=09    shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_CREATED ||
> +=09    shim->status =3D=3D MLXBF_PKA_SHIM_STATUS_FINALIZED) {
> +=09=09ret =3D -EPERM;
> +=09=09goto unlock_return;
> +=09}
> +
> +=09if (ring->status =3D=3D MLXBF_PKA_DEV_RING_STATUS_BUSY) {
> +=09=09ret =3D -EBUSY;
> +=09=09goto unlock_return;
> +=09}
> +
> +=09if (ring->status !=3D MLXBF_PKA_DEV_RING_STATUS_INITIALIZED) {
> +=09=09ret =3D -EPERM;
> +=09=09goto unlock_return;
> +=09}
> +
> +=09/* Set ring information words. */
> +=09ret =3D mlxbf_pka_dev_set_ring_info(ring);
> +=09if (ret) {
> +=09=09pr_err("mlxbf_pka error: failed to set ring information\n");
> +=09=09ret =3D -EWOULDBLOCK;
> +=09=09goto unlock_return;
> +=09}
> +
> +=09if (!shim->busy_ring_num)
> +=09=09shim->status =3D MLXBF_PKA_SHIM_STATUS_RUNNING;
> +
> +=09ring->status =3D MLXBF_PKA_DEV_RING_STATUS_BUSY;
> +=09shim->busy_ring_num +=3D 1;
> +
> +unlock_return:
> +=09mutex_unlock(&ring->mutex);
> +=09return ret;
> +}
> +
> +/* Open ring. */
> +int mlxbf_pka_dev_open_ring(struct mlxbf_pka_ring_info_t *ring_info)
> +{
> +=09return __mlxbf_pka_dev_open_ring(ring_info->ring_id);
> +}
> +
> +/* Syscall to close ring. */
> +static int __mlxbf_pka_dev_close_ring(u32 ring_id)
> +{
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09struct mlxbf_pka_dev_ring_t *ring;
> +=09int ret =3D 0;
> +
> +=09if (!mlxbf_pka_gbl_config.dev_rings_cnt)
> +=09=09return -EPERM;
> +
> +=09ring =3D mlxbf_pka_dev_get_ring(ring_id);
> +=09if (!ring || !ring->shim)
> +=09=09return -ENXIO;
> +
> +=09shim =3D ring->shim;
> +
> +=09mutex_lock(&ring->mutex);

guard()

> +
> +=09if (shim->status !=3D MLXBF_PKA_SHIM_STATUS_RUNNING &&
> +=09    ring->status !=3D MLXBF_PKA_DEV_RING_STATUS_BUSY) {
> +=09=09ret =3D -EPERM;
> +=09=09goto unlock_return;
> +=09}
> +
> +=09ring->status =3D MLXBF_PKA_DEV_RING_STATUS_INITIALIZED;
> +=09shim->busy_ring_num -=3D 1;
> +
> +=09if (!shim->busy_ring_num)
> +=09=09shim->status =3D MLXBF_PKA_SHIM_STATUS_STOPPED;
> +
> +unlock_return:
> +=09mutex_unlock(&ring->mutex);
> +=09return ret;
> +}
> +
> +/* Close ring. */
> +int mlxbf_pka_dev_close_ring(struct mlxbf_pka_ring_info_t *ring_info)
> +{
> +=09if (ring_info)
> +=09=09return __mlxbf_pka_dev_close_ring(ring_info->ring_id);
> +
> +=09return 0;
> +}
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h b/driver=
s/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> new file mode 100644
> index 000000000000..3054476215bd
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
> @@ -0,0 +1,657 @@
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
 and data structures to
> + * initialize and configure the PKA shim. It's the "southband interface"=
 for communication with PKA
> + * hardware resources.
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/types.h>
> +#include <linux/ioctl.h>

Please order any includes alphabetically.

> +
> +/* PKA ring device related definitions. */
> +#define CMD_DESC_SIZE 64
> +
> +/*
> + * Describes the PKA command/result ring as used by the hardware. A pair=
 of command and result rings
> + * in PKA window memory, and the data memory used by the commands.
> + */
> +struct mlxbf_pka_ring_desc_t {
> +=09u32 num_descs; /* Total number of descriptors in the ring. */
> +
> +=09u32 cmd_ring_base; /* Base address of the command ring. */
> +=09u32 cmd_idx; /* Index of the command in a ring. */
> +
> +=09u32 rslt_ring_base; /* Base address of the result ring. */
> +=09u32 rslt_idx; /* Index of the result in a ring. */
> +
> +=09u32 operands_base; /* Operands memory base address. */
> +=09u32 operands_end; /* End address of operands memory. */
> +
> +=09u32 desc_size; /* Size of each element in the ring. */
> +
> +=09u64 cmd_desc_mask; /* Bitmask of free(0)/in_use(1) cmd descriptors. *=
/
> +=09u32 cmd_desc_cnt; /* Number of command descriptors currently in use. =
*/
> +=09u32 rslt_desc_cnt; /* Number of result descriptors currently ready. *=
/

Please move those comments into kerneldoc before the struct.

> +};
> +
> +/* This structure declares ring parameters which can be used by user int=
erface. */
> +struct mlxbf_pka_ring_info_t {
> +=09int fd; /* File descriptor. */
> +=09int group; /* Iommu group. */
> +=09int container; /* VFIO cointainer. */
> +
> +=09u32 idx; /* Ring index. */
> +=09u32 ring_id; /* Hardware ring identifier. */
> +
> +=09u64 mem_off; /* Offset specific to window RAM region. */
> +=09u64 mem_addr; /* Window RAM region address. */
> +=09u64 mem_size; /* Window RAM region size. */
> +
> +=09u64 reg_off; /* Offset specific to count registers region. */
> +=09u64 reg_addr; /* Count registers region address. */
> +=09u64 reg_size; /* Count registers region size. */
> +
> +=09void *mem_ptr; /* Pointer to mapped memory region. */
> +=09void *reg_ptr; /* Pointer to mapped counters region. */
> +
> +=09struct mlxbf_pka_ring_desc_t ring_desc; /* Ring descriptor. */
> +
> +=09u8 big_endian; /* Big endian byte order when enabled. */

comments -> kerneldoc.

> +};
> +
> +/* PKA IOCTL related definitions. */
> +#define MLXBF_PKA_IOC_TYPE 0xB7
> +
> +/*
> + * MLXBF_PKA_RING_GET_REGION_INFO - _IORW(MLXBF_PKA_IOC_TYPE, 0x0, mlxbf=
_pka_dev_region_info_t).
> + *
> + * Retrieve information about a device region. This is intended to descr=
ibe MMIO, I/O port, as well
> + * as bus specific regions (ex. PCI config space). Zero sized regions ma=
y be used to describe
> + * unimplemented regions.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct mlxbf_pka_dev_region_info_t {
> +=09u32 reg_index; /* Registers region index. */
> +=09u64 reg_size; /* Registers region size (bytes). */
> +=09u64 reg_offset; /* Registers region offset from start of device fd. *=
/
> +
> +=09u32 mem_index; /* Memory region index. */
> +=09u64 mem_size; /* Memory region size (bytes). */
> +=09u64 mem_offset; /* Memory region offset from start of device fd. */
> +};
> +
> +#define MLXBF_PKA_RING_GET_REGION_INFO \
> +=09_IOWR(MLXBF_PKA_IOC_TYPE, 0x0, struct mlxbf_pka_dev_region_info_t)
> +
> +/*
> + * MLXBF_PKA_GET_RING_INFO - _IORW(MLXBF_PKA_IOC_TYPE, 0x1, mlxbf_pka_de=
v_ring_info_t).
> + *
> + * Retrieve information about a ring. This is intended to describe ring =
information words located in
> + * MLXBF_PKA_BUFFER_RAM. Ring information includes base addresses, size =
and statistics.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +
> +/* Bluefield specific ring information. */
> +struct mlxbf_pka_dev_hw_ring_info_t {
> +=09/* Base address of the command descriptor ring. */
> +=09u64 cmmd_base;
> +
> +=09/* Base address of the result descriptor ring. */
> +=09u64 rslt_base;
> +
> +=09/*
> +=09 * Size of a command ring in number of descriptors, minus 1. Minimum =
value is 0 (for 1
> +=09 * descriptor); maximum value is 65535 (for 64K descriptors).
> +=09 */
> +=09u16 size;
> +
> +=09/*
> +=09 * This field specifies the size (in 32-bit words) of the space that =
PKI command and result
> +=09 * descriptor occupies on the Host.
> +=09 */
> +=09u16 host_desc_size : 10;
> +
> +=09/*
> +=09 * Indicates whether the result ring delivers results strictly in-ord=
er ('1') or that result
> +=09 * descriptors are written to the result ring as soon as they become =
available, or out-of-
> +=09 * order ('0').
> +=09 */
> +=09u8 in_order : 1;
> +
> +=09/* Read pointer of the command descriptor ring. */
> +=09u16 cmmd_rd_ptr;
> +
> +=09/* Write pointer of the result descriptor ring. */
> +=09u16 rslt_wr_ptr;
> +
> +=09/* Read statistics of the command descriptor ring. */
> +=09u16 cmmd_rd_stats;
> +
> +=09/* Write statistics of the result descriptor ring. */
> +=09u16 rslt_wr_stats;
> +};
> +
> +/* ring_info related definitions. */
> +#define MLXBF_PKA_RING_INFO_IN_ORDER_MASK 0x0001

GENMASK() or BIT() + add #include.

> +#define MLXBF_PKA_RING_INFO_IN_ORDER_OFFSET 31
> +#define MLXBF_PKA_RING_INFO_HOST_DESC_SIZE_MASK 0x03FF

GENMASK()

> +#define MLXBF_PKA_RING_INFO_HOST_DESC_SIZE_OFFSET 18

Probably can be dropped after FIELD_GET()/PREP() conversion.

> +#define MLXBF_PKA_RING_NUM_CMD_DESC_MASK 0xFFFF

GENMASK()

> +
> +#define MLXBF_PKA_GET_RING_INFO _IOWR(MLXBF_PKA_IOC_TYPE, 0x1, struct ml=
xbf_pka_dev_hw_ring_info_t)

This not an uapi header?

> +
> +/* Ring option related definitions. */
> +#define MLXBF_PKA_RING_OPTIONS_RING_PRIORITY_MASK 0xFF
> +#define MLXBF_PKA_RING_OPTIONS_RING_NUM_OFFSET 8
> +#define MLXBF_PKA_RING_OPTIONS_RING_NUM_MASK 0xFF00
> +#define MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE_OFFSET 24
> +#define MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE_MASK 0xFF000000
> +
> +/*
> + * MLXBF_PKA_CLEAR_RING_COUNTERS - _IO(MLXBF_PKA_IOC_TYPE, 0x2).
> + *
> + * Clear counters. This is intended to reset all command and result coun=
ters.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +#define MLXBF_PKA_CLEAR_RING_COUNTERS _IO(MLXBF_PKA_IOC_TYPE, 0x2)
> +
> +/*
> + * MLXBF_PKA_GET_RANDOM_BYTES - _IOWR(MLXBF_PKA_IOC_TYPE, 0x3, mlxbf_pka=
_dev_trng_info_t).
> + *
> + * Get random bytes from True Random Number Generator(TRNG).
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +
> +/* TRNG information. */
> +struct mlxbf_pka_dev_trng_info_t {
> +=09/* Number of random bytes in the buffer or length of the buffer. */
> +=09u32 count;
> +
> +=09/* Data buffer to hold the random bytes. */
> +=09u8 *data;
> +};
> +
> +#define MLXBF_PKA_GET_RANDOM_BYTES _IOWR(MLXBF_PKA_IOC_TYPE, 0x3, struct=
 mlxbf_pka_dev_trng_info_t)
> +
> +/* PKA address related definitions. */
> +
> +/*
> + * Global Control Space CSR addresses/offsets. These are accessed from t=
he ARM as 8 byte reads/
> + * writes. However only the bottom 32 bits are implemented.
> + */
> +#define MLXBF_PKA_CLK_FORCE_ADDR 0x11C80
> +
> +/*
> + * Advanced Interrupt Controller CSR addresses/offsets. These are access=
ed from the ARM as 8 byte
> + * reads/writes. However only the bottom 32 bits are implemented.
> + */
> +#define MLXBF_PKA_AIC_POL_CTRL_ADDR 0x11E00
> +
> +/*
> + * The True Random Number Generator CSR addresses/offsets. These are acc=
essed from the ARM as 8 byte
> + * reads/writes. However only the bottom 32 bits are implemented.
> + */
> +#define MLXBF_PKA_TRNG_OUTPUT_0_ADDR 0x12000
> +#define MLXBF_PKA_TRNG_STATUS_ADDR 0x12020
> +#define MLXBF_PKA_TRNG_INTACK_ADDR 0x12020
> +#define MLXBF_PKA_TRNG_CONTROL_ADDR 0x12028
> +#define MLXBF_PKA_TRNG_CONFIG_ADDR 0x12030
> +#define MLXBF_PKA_TRNG_ALARMCNT_ADDR 0x12038
> +#define MLXBF_PKA_TRNG_FROENABLE_ADDR 0x12040
> +#define MLXBF_PKA_TRNG_FRODETUNE_ADDR 0x12048
> +#define MLXBF_PKA_TRNG_ALARMMASK_ADDR 0x12050
> +#define MLXBF_PKA_TRNG_ALARMSTOP_ADDR 0x12058
> +#define MLXBF_PKA_TRNG_TEST_ADDR 0x120E0
> +#define MLXBF_PKA_TRNG_RAW_L_ADDR 0x12060
> +#define MLXBF_PKA_TRNG_RAW_H_ADDR 0x12068
> +#define MLXBF_PKA_TRNG_MONOBITCNT_ADDR 0x120B8
> +#define MLXBF_PKA_TRNG_POKER_3_0_ADDR 0x120C0
> +#define MLXBF_PKA_TRNG_PS_AI_0_ADDR 0x12080
> +
> +/*
> + * Control register address/offset. This is accessed from the ARM using =
8 byte reads/writes. However
> + * only the bottom 32 bits are implemented.
> + */
> +#define MLXBF_PKA_MASTER_SEQ_CTRL_ADDR 0x27F90
> +
> +/*
> + * Ring CSRs: these are all accessed from the ARM using 8 byte reads/wri=
tes. However only the bottom
> + * 32 bits are implemented.
> + */
> +/* Ring 0 CSRS. */
> +#define MLXBF_PKA_COMMAND_COUNT_0_ADDR 0x80080
> +
> +/* MLXBF_PKA_BUFFER_RAM: 1024 x 64 - 8K bytes. */
> +#define MLXBF_PKA_BUFFER_RAM_BASE 0x00000
> +#define MLXBF_PKA_BUFFER_RAM_SIZE SZ_16K /* 0x00000...0x03FFF. */

The comment and define do not match???

If you derive size from something, it would be nice to use that formula=20
directly in the define itself.

Missing include for SZ_16K.

> +
> +/*
> + * PKA Buffer RAM offsets. These are NOT real CSR's but instead are spec=
ific offset/addresses within
> + * the EIP154 MLXBF_PKA_BUFFER_RAM.
> + */
> +
> +/* Ring 0. */
> +#define MLXBF_PKA_RING_CMMD_BASE_0_ADDR 0x00000
> +#define MLXBF_PKA_RING_RSLT_BASE_0_ADDR 0x00010
> +#define MLXBF_PKA_RING_SIZE_TYPE_0_ADDR 0x00020
> +#define MLXBF_PKA_RING_RW_PTRS_0_ADDR 0x00028
> +#define MLXBF_PKA_RING_RW_STAT_0_ADDR 0x00030
> +
> +/* Ring Options. */
> +#define MLXBF_PKA_RING_OPTIONS_ADDR 0x07FF8
> +
> +/* Alternate Window RAM size. */
> +#define MLXBF_PKA_WINDOW_RAM_REGION_SIZE SZ_16K
> +
> +/* PKA configuration related definitions. */
> +
> +/* The maximum number of PKA shims referred to as IO blocks. */
> +#define MLXBF_PKA_MAX_NUM_IO_BLOCKS 24
> +/* The maximum number of rings supported by the IO block (shim). */
> +#define MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS 4
> +
> +#define MLXBF_PKA_MAX_NUM_RINGS (MLXBF_PKA_MAX_NUM_IO_BLOCK_RINGS * MLXB=
F_PKA_MAX_NUM_IO_BLOCKS)
> +/*
> + * Resources are regions which include info control/status words, count =
registers and host window
> + * RAM.
> + */
> +#define MLXBF_PKA_MAX_NUM_RING_RESOURCES 3
> +
> +/*
> + * PKA Ring resources.
> + * Define Ring resources parameters including base address, size (in byt=
es) and ring spacing.
> + */
> +#define MLXBF_PKA_RING_WORDS_ADDR MLXBF_PKA_BUFFER_RAM_BASE
> +#define MLXBF_PKA_RING_CNTRS_ADDR MLXBF_PKA_COMMAND_COUNT_0_ADDR
> +
> +#define MLXBF_PKA_RING_WORDS_SIZE SZ_64
> +#define MLXBF_PKA_RING_CNTRS_SIZE SZ_32
> +#define MLXBF_PKA_RING_MEM_SIZE SZ_16K
> +
> +#define MLXBF_PKA_RING_WORDS_SPACING SZ_64
> +#define MLXBF_PKA_RING_CNTRS_SPACING SZ_64K
> +#define MLXBF_PKA_RING_MEM_0_SPACING SZ_16K
> +#define MLXBF_PKA_RING_MEM_1_SPACING SZ_64K
> +
> +/*
> + * PKA Window RAM parameters.
> + * Define whether to split window RAM during PKA device creation phase.
> + */
> +#define MLXBF_PKA_SPLIT_WINDOW_RAM_MODE 0
> +
> +/* Defines for window RAM partition, valid for 16K memory. */
> +#define MLXBF_PKA_WINDOW_RAM_RING_MEM_SIZE SZ_2K
> +#define MLXBF_PKA_WINDOW_RAM_RING_MEM_DIV 2 /* Divide into halves. */
> +#define MLXBF_PKA_WINDOW_RAM_DATA_MEM_SIZE 0x3800 /* 14KB. */
> +#define MLXBF_PKA_WINDOW_RAM_RING_ADDR_MASK 0xFFFF
> +#define MLXBF_PKA_WINDOW_RAM_RING_SIZE_MASK 0xF0000

GENMASK() x2

> +#define MLXBF_PKA_WINDOW_RAM_RING_SIZE_SHIFT 2

Now I'm lost what this is about, you've (xx & 0xF0000) >> 2 in the code
when using MLXBF_PKA_WINDOW_RAM_RING_SIZE_* which looks weird black=20
magic.

> +
> +/* Window RAM/Alternate window RAM offset mask for BF1 and BF2. */
> +#define MLXBF_PKA_WINDOW_RAM_OFFSET_MASK1 0x730000

GENMASK()

> +
> +/* Window RAM/Alternate window RAM offset mask for BF3. */
> +#define MLXBF_PKA_WINDOW_RAM_OFFSET_MASK2 0x70000

GENMASK()

Why isn't BF1 & BF3 in the name of the define?

> +
> +/*
> + * PKA Master Sequencer Control/Status Register.
> + * Writing '1' to bit [31] puts the Master controller Sequencer in a res=
et state. Resetting the
> + * Sequencer (in order to load other firmware) should only be done when =
the EIP-154 is not
> + * performing any operations.
> + */
> +#define MLXBF_PKA_MASTER_SEQ_CTRL_RESET_VAL BIT(31)

Missing include.

> +/*
> + * Writing '1' to bit [30] will reset all Command and Result counters. T=
his bit is write-only and
> + * self clearing and can only be set if the 'Reset' bit [31] is '1'.
> + */
> +#define MLXBF_PKA_MASTER_SEQ_CTRL_CLEAR_COUNTERS_VAL BIT(30)
> +/*
> + * MLXBF_PKA_RING_OPTIONS field to specify the priority in which rings a=
re handled:
> + *  '00' =3D full rotating priority,
> + *  '01' =3D fixed priority (ring 0 lowest),
> + *  '10' =3D ring 0 has the highest priority and the remaining rings hav=
e rotating priority,
> + *  '11' =3D reserved, do not use.
> + */
> +#define MLXBF_PKA_RING_OPTIONS_PRIORITY=090x0

The comment is extremely odd given the define. 'priority' means 'full=20
rotation priority' and not e.g. 'fixed priority'?!? :-/

> +
> +/*
> + * 'Signature' byte used because the ring options are transferred throug=
h RAM which does not have a
> + * defined reset value. The EIP-154 master controller keeps reading the =
MLXBF_PKA_RING_OPTIONS word
> + * at start-up until the 'Signature' byte contains 0x46 and the 'Reserve=
d' field contains zero.
> + */
> +#define MLXBF_PKA_RING_OPTIONS_SIGNATURE_BYTE 0x46
> +
> +/*
> + * Order of the result reporting: two schemas are available:
> + *  InOrder    - the results will be reported in the same order as the c=
ommands were provided.
> + *  OutOfOrder - the results are reported as soon as they are available.
> + * Note: only the OutOfOrder schema is used in this implementation.
> + */
> +#define MLXBF_PKA_RING_TYPE_OUT_OF_ORDER_BIT 0
> +#define MLXBF_PKA_RING_TYPE_IN_ORDER MLXBF_PKA_RING_TYPE_OUT_OF_ORDER_BI=
T
> +
> +/*
> + * Byte order of the data written/read to/from Rings.
> + *  Little Endian (LE) - the least significant bytes have the lowest add=
ress.
> + *  Big    Endian (BE) - the most significant bytes come first.
> + * Note: only the little endian is used in this implementation.
> + */
> +#define MLXBF_PKA_RING_BYTE_ORDER_LE 0
> +#define MLXBF_PKA_RING_BYTE_ORDER MLXBF_PKA_RING_BYTE_ORDER_LE

Both seem unused.

> +/*
> + * 'trng_clk_on' mask for PKA Clock Switch Forcing Register. Turn on the=
 TRNG clock. When the TRNG
> + * is controlled via the host slave interface, this engine needs to be t=
urned on by setting bit 11.
> + */
> +#define MLXBF_PKA_CLK_FORCE_TRNG_ON 0x800

BIT() ?

> +
> +/* Number of TRNG output registers. */
> +#define MLXBF_PKA_TRNG_OUTPUT_CNT 4
> +
> +/* Number of TRNG poker test counts. */
> +#define MLXBF_PKA_TRNG_POKER_TEST_CNT 4
> +
> +/* TRNG configuration. */
> +#define MLXBF_PKA_TRNG_CONFIG_REG_VAL 0x00020008
> +/* TRNG Alarm Counter Register value. */
> +#define MLXBF_PKA_TRNG_ALARMCNT_REG_VAL 0x000200FF
> +/* TRNG FRO Enable Register value. */
> +#define MLXBF_PKA_TRNG_FROENABLE_REG_VAL 0x00FFFFFF

IMO, "_REG_VAL" suffixes just makes your code lines longer and adds little=
=20
value. The same goes for _MASK btw.

> +/*
> + * TRNG Control Register value. Set bit 10 to start the EIP-76 (i.e. TRN=
G engine), gathering entropy
> + * from the FROs.

What FRO stands for? Perhaps it would be possible to have it mentioned in=
=20
the changelog with the opened form.

> + */
> +#define MLXBF_PKA_TRNG_CONTROL_REG_VAL 0x00000400
> +
> +/* TRNG Control bit. */
> +#define MLXBF_PKA_TRNG_CONTROL_TEST_MODE 0x100
> +
> +/*
> + * TRNG Control Register value. Set bit 10 and 12 to start the EIP-76 (i=
=2Ee. TRNG engine) with DRBG
> + * enabled, gathering entropy from the FROs.
> + */
> +#define MLXBF_PKA_TRNG_CONTROL_DRBG_REG_VAL 0x00001400
> +
> +/*
> + * DRBG enabled TRNG 'request_data' value. REQ_DATA_VAL (in accordance w=
ith DATA_BLOCK_MASK)
> + * requests 256 blocks of 128-bit random output. 4095 blocks is the maxi=
mum number that can be
> + * requested for the TRNG (with DRBG) configuration on Bluefield platfor=
ms.
> + */
> +#define MLXBF_PKA_TRNG_CONTROL_REQ_DATA_VAL 0x10010000

Maybe drop _VAL ?

> +
> +/* Mask for 'Data Block' in TRNG Control Register. */
> +#define MLXBF_PKA_TRNG_DRBG_DATA_BLOCK_MASK 0xfff00000
> +
> +/* Set bit 12 of TRNG Control Register to enable DRBG functionality. */
> +#define MLXBF_PKA_TRNG_CONTROL_DRBG_ENABLE_VAL BIT(12)
> +
> +/* Set bit 7 (i.e. 'test_sp_800_90 DRBG' bit) in the TRNG Test Register.=
 */
> +#define MLXBF_PKA_TRNG_TEST_DRBG_VAL BIT(7)
> +
> +/* Number of Personalization String/Additional Input Registers. */
> +#define MLXBF_PKA_TRNG_PS_AI_REG_COUNT 12
> +
> +/* Offset bytes of Personalization String/Additional Input Registers. */
> +#define MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET 0x8
> +
> +/* Maximum TRNG test error cycle, about one second. */
> +#define MLXBF_PKA_TRNG_TEST_ERR_CYCLE_MAX (1000 * 1000 * 1000)
> +
> +/* DRBG Reseed enable. */
> +#define MLXBF_PKA_TRNG_CONTROL_DRBG_RESEED BIT(15)
> +
> +/* TRNG Status bits. */
> +#define MLXBF_PKA_TRNG_STATUS_READY BIT(0)
> +#define MLXBF_PKA_TRNG_STATUS_SHUTDOWN_OFLO BIT(1)
> +#define MLXBF_PKA_TRNG_STATUS_TEST_READY BIT(8)
> +#define MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL BIT(7)
> +#define MLXBF_PKA_TRNG_STATUS_RUN_FAIL BIT(4)
> +#define MLXBF_PKA_TRNG_STATUS_POKER_FAIL BIT(6)

For any group of defines, please align the values with tabs

> +
> +/* TRNG Alarm Counter bits. */
> +#define MLXBF_PKA_TRNG_ALARMCNT_STALL_RUN_POKER BIT(15)
> +
> +/* TRNG Test bits. */
> +#define MLXBF_PKA_TRNG_TEST_KNOWN_NOISE BIT(5)
> +#define MLXBF_PKA_TRNG_TEST_NOISE BIT(13)
> +
> +/* TRNG Test constants*/
> +#define MLXBF_PKA_TRNG_MONOBITCNT_SUM 9978
> +
> +#define MLXBF_PKA_TRNG_TEST_HALF_ADD 1
> +#define MLXBF_PKA_TRNG_TEST_HALF_NO 0
> +
> +#define MLXBF_PKA_TRNG_TEST_DATAL_BASIC_1 0x11111333
> +#define MLXBF_PKA_TRNG_TEST_DATAH_BASIC_1 0x3555779f
> +#define MLXBF_PKA_TRNG_TEST_COUNT_BASIC_1 11
> +
> +#define MLXBF_PKA_TRNG_TEST_DATAL_BASIC_2 0x01234567
> +#define MLXBF_PKA_TRNG_TEST_DATAH_BASIC_2 0x89abcdef
> +#define MLXBF_PKA_TRNG_TEST_COUNT_BASIC_2 302
> +
> +#define MLXBF_PKA_TRNG_TEST_DATAL_POKER 0xffffffff
> +#define MLXBF_PKA_TRNG_TEST_DATAH_POKER 0xffffffff
> +#define MLXBF_PKA_TRNG_TEST_COUNT_POKER 11
> +
> +#define MLXBF_PKA_TRNG_NUM_OF_FOUR_WORD 128
> +
> +/* PKA device related definitions. */
> +#define MLXBF_PKA_DEVFS_RING_DEVICES "mlxbf_pka/%d"
> +
> +/* Device resource structure. */
> +struct mlxbf_pka_dev_res_t {
> +=09void __iomem *ioaddr; /* The (iore)mapped version of addr, driver int=
ernal use. */
> +=09u64 base; /* Base address of the device's resource. */
> +=09u64 size; /* Size of IO. */
> +=09u8 type; /* Type of resource addr points to. */
> +=09s8 status; /* Status of the resource. */
> +=09char *name; /* Name of the resource. */

Please put the per field comments into kerneldoc.

> +};
> +
> +/* Defines for mlxbf_pka_dev_res->type. */
> +#define MLXBF_PKA_DEV_RES_TYPE_MEM 1 /* Resource type is memory. */
> +#define MLXBF_PKA_DEV_RES_TYPE_REG 2 /* Resource type is register. */
> +
> +/* Defines for mlxbf_pka_dev_res->status. */
> +#define MLXBF_PKA_DEV_RES_STATUS_MAPPED 1 /* The resource is (iore)mappe=
d. */
> +#define MLXBF_PKA_DEV_RES_STATUS_UNMAPPED -1 /* The resource is unmapped=
=2E */
> +
> +/* PKA Ring resources structure. */
> +struct mlxbf_pka_dev_ring_res_t {
> +=09struct mlxbf_pka_dev_res_t info_words; /* Ring information words. */
> +=09struct mlxbf_pka_dev_res_t counters; /* Ring counters. */
> +=09struct mlxbf_pka_dev_res_t window_ram; /* Window RAM. */
> +};
> +
> +/* PKA Ring structure. */
> +struct mlxbf_pka_dev_ring_t {
> +=09u32 ring_id; /* Ring identifier. */
> +=09struct mlxbf_pka_dev_shim_s *shim; /* Pointer to the shim associated =
to the ring. */
> +=09u32 resources_num; /* Number of ring resources. */
> +=09struct mlxbf_pka_dev_ring_res_t resources; /* Ring resources. */
> +=09struct mlxbf_pka_dev_hw_ring_info_t *ring_info; /* Ring information. =
*/
> +=09u32 num_cmd_desc; /* Number of command descriptors. */
> +=09s8 status; /* Status of the ring. */
> +=09struct mutex mutex; /* Mutex lock for sharing ring device. */

Ditto. Please do this for all structs here.

> +};
> +
> +/* Defines for mlxbf_pka_dev_ring->status. */
> +#define MLXBF_PKA_DEV_RING_STATUS_UNDEFINED -1
> +#define MLXBF_PKA_DEV_RING_STATUS_INITIALIZED 1
> +#define MLXBF_PKA_DEV_RING_STATUS_READY 2
> +#define MLXBF_PKA_DEV_RING_STATUS_BUSY 3
> +
> +/* PKA Shim resources structure. */
> +struct mlxbf_pka_dev_shim_res_t {
> +=09struct mlxbf_pka_dev_res_t buffer_ram; /* Buffer RAM. */
> +=09struct mlxbf_pka_dev_res_t master_seq_ctrl; /* Master sequencer contr=
oller CSR. */
> +=09struct mlxbf_pka_dev_res_t aic_csr; /* Interrupt controller CSRs. */
> +=09struct mlxbf_pka_dev_res_t trng_csr; /* TRNG module CSRs. */
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
> +struct mlxbf_pka_dev_mem_res {
> +=09u64 eip154_base; /* Base address for EIP154 mmio registers. */
> +=09u64 eip154_size; /* EIP154 mmio register region size. */
> +
> +=09u64 wndw_ram_off_mask; /* Common offset mask for alt window RAM and w=
indow RAM. */
> +=09u64 wndw_ram_base; /* Base address for window RAM. */
> +=09u64 wndw_ram_size; /* Window RAM region size. */
> +
> +=09u64 alt_wndw_ram_0_base; /* Base address for alternate window RAM 0. =
*/
> +=09u64 alt_wndw_ram_1_base; /* Base address for alternate window RAM 1. =
*/
> +=09u64 alt_wndw_ram_2_base; /* Base address for alternate window RAM 2. =
*/
> +=09u64 alt_wndw_ram_3_base; /* Base address for alternate window RAM 3. =
*/
> +=09u64 alt_wndw_ram_size; /* Alternate window RAM regions size. */
> +
> +=09u64 csr_base; /* Base address for CSR registers. */
> +=09u64 csr_size; /* CSR area size. */
> +};
> +
> +/* PKA Shim structure. */
> +struct mlxbf_pka_dev_shim_s {
> +=09struct=09mlxbf_pka_dev_mem_res mem_res;
> +=09u64 trng_err_cycle; /* TRNG error cycle. */
> +=09u32 shim_id; /* Shim identifier. */
> +=09u32 rings_num; /* Number of supported rings (hardware specific). */
> +=09struct mlxbf_pka_dev_ring_t **rings; /* Pointer to rings which belong=
 to the shim. */
> +=09u8 ring_priority; /* Specify the priority in which rings are handled.=
 */
> +=09u8 ring_type; /*Indicates whether the result ring delivers results st=
rictly in-order. */
> +=09struct mlxbf_pka_dev_shim_res_t resources; /* Shim resources. */
> +=09u8 window_ram_split; /* If non-zero, the split window RAM scheme is u=
sed. */
> +=09u32 busy_ring_num; /* Number of active rings (rings in busy state). *=
/
> +=09u8 trng_enabled; /* Whether the TRNG engine is enabled. */
> +=09s8 status; /* Status of the shim. */
> +=09struct mutex mutex; /* Mutex lock for sharing shim. */
> +};
> +
> +/* Defines for mlxbf_pka_dev_shim->status. */
> +#define MLXBF_PKA_SHIM_STATUS_UNDEFINED -1
> +#define MLXBF_PKA_SHIM_STATUS_CREATED 1
> +#define MLXBF_PKA_SHIM_STATUS_INITIALIZED 2
> +#define MLXBF_PKA_SHIM_STATUS_RUNNING 3
> +#define MLXBF_PKA_SHIM_STATUS_STOPPED 4
> +#define MLXBF_PKA_SHIM_STATUS_FINALIZED 5
> +
> +/* Defines for mlxbf_pka_dev_shim->window_ram_split. */
> +
> +/* Window RAM is split into 4 * 16KB blocks. */
> +#define MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED 1
> +/* Window RAM is not split and occupies 64KB. */
> +#define MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_DISABLED 2
> +
> +/* Defines for mlxbf_pka_dev_shim->trng_enabled. */
> +#define MLXBF_PKA_SHIM_TRNG_ENABLED 1
> +#define MLXBF_PKA_SHIM_TRNG_DISABLED 0
> +
> +/* Platform global configuration structure. */
> +struct mlxbf_pka_dev_gbl_config_t {
> +=09u32 dev_shims_cnt; /* Number of registered PKA shims. */
> +=09u32 dev_rings_cnt; /* Number of registered Rings. */
> +
> +=09/* Table of registered PKA shims. */
> +=09struct mlxbf_pka_dev_shim_s *dev_shims[MLXBF_PKA_MAX_NUM_IO_BLOCKS];
> +
> +=09/* Table of registered Rings. */
> +=09struct mlxbf_pka_dev_ring_t *dev_rings[MLXBF_PKA_MAX_NUM_RINGS];
> +};
> +
> +extern struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
> +
> +/* Processor speed in hertz, used in routines which might be called very=
 early in boot. */
> +static inline u64 mlxbf_pka_early_cpu_speed(void)
> +{
> +=09/*
> +=09 * Initial guess at our CPU speed.  We set this to be larger than any=
 possible real speed,
> +=09 * so that any calculated delays will be too long, rather than too sh=
ort.
> +=09 *
> +=09 * CPU Freq for High/Bin Chip - 1.255GHz.
> +=09 */
> +=09return 1255 * 1000 * 1000;

Please use linux/units.h instead of literal 1000s.

> +}
> +
> +/*
> + * Ring getter for mlxbf_pka_dev_gbl_config_t structure which holds all =
system global configuration.
> + * This configuration is shared and common to kernel device driver assoc=
iated with PKA hardware.
> + */
> +struct mlxbf_pka_dev_ring_t *mlxbf_pka_dev_get_ring(u32 ring_id);
> +
> +/*
> + * Shim getter for mlxbf_pka_dev_gbl_config_t structure which holds all =
system global configuration.
> + * This configuration is shared and common to kernel device driver assoc=
iated with PKA hardware.
> + */
> +struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id);
> +
> +/*
> + * Register a ring. This function initializes a Ring and configures its =
related resources, and
> + * returns a pointer to that ring.
> + */
> +struct mlxbf_pka_dev_ring_t *mlxbf_pka_dev_register_ring(struct device *=
dev,
> +=09=09=09=09=09=09=09 u32 ring_id,
> +=09=09=09=09=09=09=09 u32 shim_id);
> +
> +/* Unregister a Ring. */
> +int mlxbf_pka_dev_unregister_ring(struct mlxbf_pka_dev_ring_t *ring);
> +
> +/*
> + * Register PKA IO block. This function initializes a shim and configure=
s its related resources, and
> + * returns a pointer to that ring.
> + */
> +struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_register_shim(struct device *=
dev,
> +=09=09=09=09=09=09=09 u32 shim_id,
> +=09=09=09=09=09=09=09 struct mlxbf_pka_dev_mem_res *mem_res);
> +
> +/* Unregister PKA IO block. */
> +int mlxbf_pka_dev_unregister_shim(struct mlxbf_pka_dev_shim_s *shim);
> +
> +/* Reset a Ring. */
> +int mlxbf_pka_dev_reset_ring(struct mlxbf_pka_dev_ring_t *ring);
> +
> +/*
> + * Clear ring counters. This function resets the master sequencer contro=
ller to clear the command
> + * and result counters.
> + */
> +int mlxbf_pka_dev_clear_ring_counters(struct mlxbf_pka_dev_ring_t *ring)=
;
> +
> +/*
> + * Read data from the TRNG. Drivers can fill up to 'cnt' bytes of data i=
nto the buffer 'data'. The
> + * buffer 'data' is aligned for any type and 'cnt' is a multiple of 4.
> + */
> +int mlxbf_pka_dev_trng_read(struct mlxbf_pka_dev_shim_s *shim, u32 *data=
, u32 cnt);
> +
> +/* Return true if the TRNG engine is enabled, false if not. */
> +bool mlxbf_pka_dev_has_trng(struct mlxbf_pka_dev_shim_s *shim);
> +
> +/*
> + * Open the file descriptor associated with ring. It returns an integer =
value, which is used to
> + * refer to the file. If not successful, it returns a negative error.
> + */
> +int mlxbf_pka_dev_open_ring(struct mlxbf_pka_ring_info_t *ring_info);
> +
> +/*
> + * Close the file descriptor associated with ring. The function returns =
0 if successful, negative
> + * value to indicate an error.
> + */
> +int mlxbf_pka_dev_close_ring(struct mlxbf_pka_ring_info_t *ring_info);
> +
> +#endif /* __MLXBF_PKA_DEV_H__ */
> diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c b/driver=
s/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> new file mode 100644
> index 000000000000..a8fe0ac1df78
> --- /dev/null
> +++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
> @@ -0,0 +1,1066 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
> +// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All ri=
ghts reserved.
> +
> +#include <linux/acpi.h>
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/hw_random.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
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
> +#define MLXBF_PKA_DRIVER_DESCRIPTION "BlueField PKA driver"
> +
> +#define MLXBF_PKA_DEVICE_ACPIHID_BF1 "MLNXBF10"
> +#define MLXBF_PKA_RING_DEVICE_ACPIHID_BF1 "MLNXBF11"
> +
> +#define MLXBF_PKA_DEVICE_ACPIHID_BF2 "MLNXBF20"
> +#define MLXBF_PKA_RING_DEVICE_ACPIHID_BF2 "MLNXBF21"
> +
> +#define MLXBF_PKA_DEVICE_ACPIHID_BF3 "MLNXBF51"
> +#define MLXBF_PKA_RING_DEVICE_ACPIHID_BF3 "MLNXBF52"
> +
> +#define MLXBF_PKA_DEVICE_ACCESS_MODE 0666
> +
> +#define MLXBF_PKA_DEVICE_RES_CNT 7
> +
> +#define MLXBF_PKA_DEVICE_NAME_MAX 14
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
> +=09MLXBF_PKA_PLAT_TYPE_BF1 =3D 0, /* Platform type Bluefield-1. */
> +=09MLXBF_PKA_PLAT_TYPE_BF2, /* Platform type Bluefield-2. */
> +=09MLXBF_PKA_PLAT_TYPE_BF3 /* Platform type Bluefield-3. */
> +};

These don't look necessary. Variations should be put into driver_data.

> +
> +static DEFINE_MUTEX(mlxbf_pka_drv_lock);
> +
> +static u32 mlxbf_pka_device_cnt;
> +static u32 mlxbf_pka_ring_device_cnt;
> +
> +static const char mlxbf_pka_acpihid_bf1[] =3D MLXBF_PKA_DEVICE_ACPIHID_B=
F1;
> +static const char mlxbf_pka_ring_acpihid_bf1[] =3D MLXBF_PKA_RING_DEVICE=
_ACPIHID_BF1;
> +
> +static const char mlxbf_pka_acpihid_bf2[] =3D MLXBF_PKA_DEVICE_ACPIHID_B=
F2;
> +static const char mlxbf_pka_ring_acpihid_bf2[] =3D MLXBF_PKA_RING_DEVICE=
_ACPIHID_BF2;
> +
> +static const char mlxbf_pka_acpihid_bf3[] =3D MLXBF_PKA_DEVICE_ACPIHID_B=
F3;
> +static const char mlxbf_pka_ring_acpihid_bf3[] =3D MLXBF_PKA_RING_DEVICE=
_ACPIHID_BF3;
> +
> +struct mlxbf_pka_drv_plat_info {
> +=09enum mlxbf_pka_plat_type type;
> +};
> +
> +static struct mlxbf_pka_drv_plat_info mlxbf_pka_drv_plat[] =3D {
> +=09[MLXBF_PKA_PLAT_TYPE_BF1] =3D {.type =3D MLXBF_PKA_PLAT_TYPE_BF1,},
> +=09[MLXBF_PKA_PLAT_TYPE_BF2] =3D {.type =3D MLXBF_PKA_PLAT_TYPE_BF2,},
> +=09[MLXBF_PKA_PLAT_TYPE_BF3] =3D {.type =3D MLXBF_PKA_PLAT_TYPE_BF3,}

Add spaces inside the braces.

Actually, now that I looked more into how it's used. The entire array=20
looks unnecessary, just make them independent:

static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf1_info =3D {
=09...
};

static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf2_info =3D {
=09...



> +};
> +
> +static const struct acpi_device_id mlxbf_pka_drv_acpi_ids[] =3D {
> +=09{ MLXBF_PKA_DEVICE_ACPIHID_BF1,
> +=09  (kernel_ulong_t)&mlxbf_pka_drv_plat[MLXBF_PKA_PLAT_TYPE_BF1],
> +=09  0,
> +=09  0 },

Put zeros on a single line.

> +=09{ MLXBF_PKA_RING_DEVICE_ACPIHID_BF1, 0, 0, 0 },
> +=09{ MLXBF_PKA_DEVICE_ACPIHID_BF2,
> +=09  (kernel_ulong_t)&mlxbf_pka_drv_plat[MLXBF_PKA_PLAT_TYPE_BF2],
> +=09  0,
> +=09  0 },
> +=09{ MLXBF_PKA_RING_DEVICE_ACPIHID_BF2, 0, 0, 0 },
> +=09{ MLXBF_PKA_DEVICE_ACPIHID_BF3,
> +=09  (kernel_ulong_t)&mlxbf_pka_drv_plat[MLXBF_PKA_PLAT_TYPE_BF3],
> +=09  0,
> +=09  0 },
> +=09{ MLXBF_PKA_RING_DEVICE_ACPIHID_BF3, 0, 0, 0 },
> +=09{},
> +};
> +
> +static struct pka {
> +=09struct idr ring_idr;
> +=09struct mutex idr_lock; /* PKA ring device IDR lock mutex. */
> +} pka;
> +
> +struct mlxbf_pka_info {
> +=09struct device *dev; /* The device this info struct belongs to. */
> +=09const char *name; /* Device name. */
> +=09const char *acpihid;
> +=09u8 flag;
> +=09struct module *module;
> +=09void *priv; /* Optional private data. */
> +};
> +
> +/* Defines for mlxbf_pka_info->flags. */
> +#define MLXBF_PKA_DRIVER_FLAG_RING_DEVICE 1
> +#define MLXBF_PKA_DRIVER_FLAG_DEVICE 2
> +
> +struct mlxbf_pka_platdata {
> +=09struct platform_device *pdev;
> +=09struct mlxbf_pka_info *info;
> +=09spinlock_t lock; /* Generic spinlock. */
> +=09unsigned long irq_flags;
> +};
> +
> +/* Bits in mlxbf_pka_platdata.irq_flags. */
> +enum {
> +=09MLXBF_PKA_IRQ_DISABLED =3D 0,
> +};
> +
> +struct mlxbf_pka_ring_region {
> +=09u64 off;
> +=09u64 addr;
> +=09resource_size_t size;
> +=09u32 flags;
> +=09u32 type;
> +};
> +
> +/* Defines for mlxbf_pka_ring_region->flags. */
> +#define MLXBF_PKA_RING_REGION_FLAG_READ BIT(0) /* Region supports read. =
*/
> +#define MLXBF_PKA_RING_REGION_FLAG_WRITE BIT(1) /* Region supports write=
=2E */
> +#define MLXBF_PKA_RING_REGION_FLAG_MMAP BIT(2) /* Region supports mmap. =
*/
> +
> +/* Defines for mlxbf_pka_ring_region->type. */
> +#define MLXBF_PKA_RING_RES_TYPE_WORDS 1=09/* Info control/status words. =
*/
> +#define MLXBF_PKA_RING_RES_TYPE_CNTRS 2=09/* Count registers. */
> +#define MLXBF_PKA_RING_RES_TYPE_MEM 4 /* Window RAM region. */
> +
> +#define MLXBF_PKA_DRIVER_RING_DEV_MAX MLXBF_PKA_MAX_NUM_RINGS
> +
> +struct mlxbf_pka_ring_device {
> +=09struct mlxbf_pka_info *info;
> +=09struct device *device;
> +=09u32 device_id;
> +=09u32 parent_device_id;
> +=09struct mutex mutex; /* PKA ring device mutex. */
> +=09struct mlxbf_pka_dev_ring_t *ring;
> +=09u32 num_regions;
> +=09struct mlxbf_pka_ring_region *regions;
> +=09struct miscdevice misc;
> +};
> +
> +#define MLXBF_PKA_DRIVER_DEV_MAX MLXBF_PKA_MAX_NUM_IO_BLOCKS
> +
> +/* Defines for region index. */
> +#define MLXBF_PKA_RING_REGION_WORDS_IDX 0
> +#define MLXBF_PKA_RING_REGION_CNTRS_IDX 1
> +#define MLXBF_PKA_RING_REGION_MEM_IDX 2
> +#define MLXBF_PKA_RING_REGION_OFFSET_SHIFT 40
> +#define MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(index) \
> +=09((u64)(index) << MLXBF_PKA_RING_REGION_OFFSET_SHIFT)

Add the field as GENMASK(), use FIELD_PREP() and remove the _SHIFT define?

> +
> +struct mlxbf_pka_device {
> +=09struct mlxbf_pka_info *info;
> +=09struct device *device;
> +=09u32 device_id;
> +=09struct resource *resource[MLXBF_PKA_DEVICE_RES_CNT];
> +=09struct mlxbf_pka_dev_shim_s *shim;
> +=09long irq; /* Interrupt number. */

The comment is dead obvious and can be dropped.

Why is this long?

> +=09struct hwrng rng;
> +};
> +
> +/* Defines for mlxbf_pka_device->irq. */
> +#define MLXBF_PKA_IRQ_CUSTOM -1
> +#define MLXBF_PKA_IRQ_NONE 0
> +
> +/* Hardware interrupt handler. */
> +static irqreturn_t mlxbf_pka_drv_irq_handler(int irq, void *device)
> +{
> +=09struct mlxbf_pka_device *mlxbf_pka_dev =3D (struct mlxbf_pka_device *=
)device;
> +=09struct platform_device *pdev =3D to_platform_device(mlxbf_pka_dev->de=
vice);
> +=09struct mlxbf_pka_platdata *priv =3D platform_get_drvdata(pdev);
> +
> +=09dev_dbg(&pdev->dev, "handle irq in device\n");
> +
> +=09/* Just disable the interrupt in the interrupt controller. */
> +=09spin_lock(&priv->lock);
> +=09if (!__test_and_set_bit(MLXBF_PKA_IRQ_DISABLED, &priv->irq_flags))
> +=09=09disable_irq_nosync(irq);
> +
> +=09spin_unlock(&priv->lock);
> +
> +=09return IRQ_HANDLED;

This always returns IRQ_HANDLED, yet you've given IRQF_SHARED flag? If=20
the IRQ is shared, you must distinguish whether IRQ is for you or not, if=
=20
it's not for you, IRQ_NONE should be returned.

> +}
> +
> +static int mlxbf_pka_drv_register_irq(struct mlxbf_pka_device *mlxbf_pka=
_dev)
> +{
> +=09if (mlxbf_pka_dev->irq && mlxbf_pka_dev->irq !=3D MLXBF_PKA_IRQ_CUSTO=
M) {
> +=09=09/* Allow sharing the irq among several devices (child devices so f=
ar). */
> +=09=09return request_irq(mlxbf_pka_dev->irq,
> +=09=09=09=09   (irq_handler_t)mlxbf_pka_drv_irq_handler,
> +=09=09=09=09   IRQF_SHARED, mlxbf_pka_dev->info->name,
> +=09=09=09=09   mlxbf_pka_dev);
> +=09}
> +
> +=09return -ENXIO;
> +}
> +
> +static int mlxbf_pka_drv_ring_regions_init(struct mlxbf_pka_ring_device =
*ring_dev)
> +{
> +=09struct mlxbf_pka_ring_region *region;
> +=09struct mlxbf_pka_dev_ring_t *ring;
> +=09struct mlxbf_pka_dev_res_t *res;
> +=09u32 num_regions;
> +
> +=09ring =3D ring_dev->ring;
> +=09if (!ring || !ring->shim)
> +=09=09return -ENXIO;
> +
> +=09num_regions =3D ring->resources_num;
> +=09ring_dev->num_regions =3D num_regions;
> +=09ring_dev->regions =3D devm_kzalloc(ring_dev->device,
> +=09=09=09=09=09 num_regions * sizeof(struct mlxbf_pka_ring_region),

devm_kcalloc()

> +=09=09=09=09=09 GFP_KERNEL);
> +=09if (!ring_dev->regions)
> +=09=09return -ENOMEM;
> +
> +=09/* Information words region. */
> +=09res =3D &ring->resources.info_words;
> +=09region =3D &ring_dev->regions[MLXBF_PKA_RING_REGION_WORDS_IDX];
> +=09/* Map offset to the physical address. */
> +=09region->off =3D MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(MLXBF_PKA_RING_=
REGION_WORDS_IDX);
> +=09region->addr =3D res->base;
> +=09region->size =3D res->size;
> +=09region->type =3D MLXBF_PKA_RING_RES_TYPE_WORDS;
> +=09region->flags |=3D (MLXBF_PKA_RING_REGION_FLAG_MMAP |
> +=09=09=09  MLXBF_PKA_RING_REGION_FLAG_READ |
> +=09=09=09  MLXBF_PKA_RING_REGION_FLAG_WRITE);
> +
> +=09/* Counters registers region. */
> +=09res =3D &ring->resources.counters;
> +=09region =3D &ring_dev->regions[MLXBF_PKA_RING_REGION_CNTRS_IDX];
> +=09/* Map offset to the physical address. */
> +=09region->off =3D MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(MLXBF_PKA_RING_=
REGION_CNTRS_IDX);
> +=09region->addr =3D res->base;
> +=09region->size =3D res->size;
> +=09region->type =3D MLXBF_PKA_RING_RES_TYPE_CNTRS;
> +=09region->flags |=3D (MLXBF_PKA_RING_REGION_FLAG_MMAP |
> +=09=09=09  MLXBF_PKA_RING_REGION_FLAG_READ |
> +=09=09=09  MLXBF_PKA_RING_REGION_FLAG_WRITE);

Unnecessary parenthesis.

> +
> +=09/* Window RAM region. */
> +=09res =3D &ring->resources.window_ram;
> +=09region =3D &ring_dev->regions[MLXBF_PKA_RING_REGION_MEM_IDX];
> +=09/* Map offset to the physical address. */
> +=09region->off =3D MLXBF_PKA_RING_REGION_INDEX_TO_OFFSET(MLXBF_PKA_RING_=
REGION_MEM_IDX);
> +=09region->addr =3D res->base;
> +=09region->size =3D res->size;
> +=09region->type =3D MLXBF_PKA_RING_RES_TYPE_MEM;
> +=09region->flags |=3D (MLXBF_PKA_RING_REGION_FLAG_MMAP |
> +=09=09=09  MLXBF_PKA_RING_REGION_FLAG_READ |
> +=09=09=09  MLXBF_PKA_RING_REGION_FLAG_WRITE);
> +
> +=09return 0;
> +}
> +
> +static void mlxbf_pka_drv_ring_regions_cleanup(struct mlxbf_pka_ring_dev=
ice *ring_dev)
> +{
> +=09/* Clear PKA ring device regions. */
> +=09ring_dev->num_regions =3D 0;
> +}
> +
> +static int mlxbf_pka_drv_ring_open(void *device_data)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev =3D device_data;
> +=09struct mlxbf_pka_info *info =3D ring_dev->info;
> +=09struct mlxbf_pka_ring_info_t ring_info;
> +=09int ret;
> +
> +=09dev_dbg(ring_dev->device, "open ring device (device_data:%p)\n", ring=
_dev);
> +
> +=09if (!try_module_get(info->module))
> +=09=09return -ENODEV;
> +
> +=09ring_info.ring_id =3D ring_dev->device_id;
> +=09ret =3D mlxbf_pka_dev_open_ring(&ring_info);
> +=09if (ret) {
> +=09=09dev_dbg(ring_dev->device, "failed to open ring\n");
> +=09=09module_put(info->module);
> +=09=09return ret;
> +=09}
> +
> +=09/* Initialize regions. */
> +=09ret =3D mlxbf_pka_drv_ring_regions_init(ring_dev);
> +=09if (ret) {
> +=09=09dev_dbg(ring_dev->device, "failed to initialize regions\n");
> +=09=09mlxbf_pka_dev_close_ring(&ring_info);
> +=09=09module_put(info->module);

Please convert this to proper rollback path.

> +=09=09return ret;
> +=09}
> +
> +=09return ret;

return 0; , followed by the rollback path.

> +}
> +
> +static void mlxbf_pka_drv_ring_release(void *device_data)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev =3D device_data;
> +=09struct mlxbf_pka_info *info =3D ring_dev->info;
> +=09struct mlxbf_pka_ring_info_t ring_info;
> +=09int ret;
> +
> +=09dev_dbg(ring_dev->device, "release ring device (device_data:%p)\n", r=
ing_dev);
> +
> +=09mlxbf_pka_drv_ring_regions_cleanup(ring_dev);
> +
> +=09ring_info.ring_id =3D ring_dev->device_id;
> +=09ret =3D mlxbf_pka_dev_close_ring(&ring_info);
> +=09if (ret)
> +=09=09dev_dbg(ring_dev->device, "failed to close ring\n");
> +
> +=09module_put(info->module);
> +}
> +
> +static int mlxbf_pka_drv_ring_mmap_region(struct mlxbf_pka_ring_region r=
egion,
> +=09=09=09=09=09  struct vm_area_struct *vma)
> +{
> +=09u64 req_len, pgoff, req_start;
> +
> +=09req_len =3D vma->vm_end - vma->vm_start;
> +=09pgoff =3D vma->vm_pgoff & ((1U << (MLXBF_PKA_RING_REGION_OFFSET_SHIFT=
 - PAGE_SHIFT)) - 1);
> +=09req_start =3D pgoff << PAGE_SHIFT;
> +
> +=09region.size =3D roundup(region.size, PAGE_SIZE);
> +
> +=09if (req_start + req_len > region.size)
> +=09=09return -EINVAL;
> +
> +=09vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> +=09vma->vm_pgoff =3D (region.addr >> PAGE_SHIFT) + pgoff;
> +
> +=09return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, req_len, vm=
a->vm_page_prot);
> +}
> +
> +static int mlxbf_pka_drv_ring_mmap(void *device_data, struct vm_area_str=
uct *vma)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev =3D device_data;
> +=09struct mlxbf_pka_ring_region *region;
> +=09unsigned int index;
> +
> +=09dev_dbg(ring_dev->device, "mmap device\n");
> +
> +=09index =3D vma->vm_pgoff >> (MLXBF_PKA_RING_REGION_OFFSET_SHIFT - PAGE=
_SHIFT);
> +
> +=09if (vma->vm_end < vma->vm_start)
> +=09=09return -EINVAL;
> +=09if (!(vma->vm_flags & VM_SHARED))
> +=09=09return -EINVAL;
> +=09if (index >=3D ring_dev->num_regions)
> +=09=09return -EINVAL;
> +=09if (vma->vm_start & ~PAGE_MASK)
> +=09=09return -EINVAL;
> +=09if (vma->vm_end & ~PAGE_MASK)
> +=09=09return -EINVAL;
> +
> +=09region =3D &ring_dev->regions[index];
> +
> +=09if (!(region->flags & MLXBF_PKA_RING_REGION_FLAG_MMAP))
> +=09=09return -EINVAL;
> +
> +=09if (!(region->flags & MLXBF_PKA_RING_REGION_FLAG_READ) && (vma->vm_fl=
ags & VM_READ))
> +=09=09return -EINVAL;
> +
> +=09if (!(region->flags & MLXBF_PKA_RING_REGION_FLAG_WRITE) && (vma->vm_f=
lags & VM_WRITE))
> +=09=09return -EINVAL;
> +
> +=09vma->vm_private_data =3D ring_dev;
> +
> +=09if (region->type & MLXBF_PKA_RING_RES_TYPE_CNTRS ||
> +=09    region->type & MLXBF_PKA_RING_RES_TYPE_MEM)
> +=09=09return mlxbf_pka_drv_ring_mmap_region(ring_dev->regions[index], vm=
a);
> +
> +=09if (region->type & MLXBF_PKA_RING_RES_TYPE_WORDS)
> +=09=09/* Currently user space is not allowed to access this region. */
> +=09=09return -EINVAL;
> +
> +=09return -EINVAL;
> +}
> +
> +static long mlxbf_pka_drv_ring_ioctl(void *device_data, unsigned int cmd=
, unsigned long arg)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev =3D device_data;
> +
> +=09if (cmd =3D=3D MLXBF_PKA_RING_GET_REGION_INFO) {
> +=09=09struct mlxbf_pka_dev_region_info_t info;
> +
> +=09=09info.mem_index =3D MLXBF_PKA_RING_REGION_MEM_IDX;
> +=09=09info.mem_offset =3D ring_dev->regions[info.mem_index].off;
> +=09=09info.mem_size =3D ring_dev->regions[info.mem_index].size;
> +
> +=09=09info.reg_index =3D MLXBF_PKA_RING_REGION_CNTRS_IDX;
> +=09=09info.reg_offset =3D ring_dev->regions[info.reg_index].off;
> +=09=09info.reg_size =3D ring_dev->regions[info.reg_index].size;
> +
> +=09=09return copy_to_user((void __user *)arg, &info, sizeof(info)) ? -EF=
AULT : 0;
> +
> +=09} else if (cmd =3D=3D MLXBF_PKA_GET_RING_INFO) {
> +=09=09struct mlxbf_pka_dev_hw_ring_info_t *this_ring_info;
> +=09=09struct mlxbf_pka_dev_hw_ring_info_t  hw_ring_info;
> +
> +=09=09this_ring_info =3D ring_dev->ring->ring_info;
> +
> +=09=09hw_ring_info.cmmd_base =3D this_ring_info->cmmd_base;
> +=09=09hw_ring_info.rslt_base =3D this_ring_info->rslt_base;
> +=09=09hw_ring_info.size =3D this_ring_info->size;
> +=09=09hw_ring_info.host_desc_size =3D this_ring_info->host_desc_size;
> +=09=09hw_ring_info.in_order =3D this_ring_info->in_order;
> +=09=09hw_ring_info.cmmd_rd_ptr =3D this_ring_info->cmmd_rd_ptr;
> +=09=09hw_ring_info.rslt_wr_ptr =3D this_ring_info->rslt_wr_ptr;
> +=09=09hw_ring_info.cmmd_rd_stats =3D this_ring_info->cmmd_rd_ptr;
> +=09=09hw_ring_info.rslt_wr_stats =3D this_ring_info->rslt_wr_stats;
> +
> +=09=09return copy_to_user((void __user *)arg,
> +=09=09=09=09    &hw_ring_info,
> +=09=09=09=09    sizeof(hw_ring_info)) ? -EFAULT : 0;

Please split this return statement to smaller components.

> +=09} else if (cmd =3D=3D MLXBF_PKA_CLEAR_RING_COUNTERS) {
> +=09=09return mlxbf_pka_dev_clear_ring_counters(ring_dev->ring);
> +=09} else if (cmd =3D=3D MLXBF_PKA_GET_RANDOM_BYTES) {
> +=09=09struct mlxbf_pka_dev_trng_info_t trng_data;
> +=09=09struct mlxbf_pka_dev_shim_s *shim;
> +=09=09bool trng_present;
> +=09=09u32 byte_cnt;
> +=09=09u32 *data;
> +=09=09int ret;
> +
> +=09=09shim =3D ring_dev->ring->shim;
> +=09=09ret =3D copy_from_user(&trng_data,
> +=09=09=09=09     (void __user *)(arg),
> +=09=09=09=09     sizeof(struct mlxbf_pka_dev_trng_info_t));
> +=09=09if (ret) {
> +=09=09=09dev_dbg(ring_dev->device, "failed to copy user request.\n");
> +=09=09=09return -EFAULT;
> +=09=09}
> +
> +=09=09/*
> +=09=09 * Need byte count which is multiple of 4 as required by the
> +=09=09 * mlxbf_pka_dev_trng_read() interface.
> +=09=09 */
> +=09=09byte_cnt =3D round_up(trng_data.count, MLXBF_PKA_TRNG_OUTPUT_CNT);
> +
> +=09=09data =3D kzalloc(byte_cnt, GFP_KERNEL);

Use __free() to handle the release of data.

> +=09=09if (!data)
> +=09=09=09return -ENOMEM;
> +
> +=09=09trng_present =3D mlxbf_pka_dev_has_trng(shim);
> +=09=09if (!trng_present) {
> +=09=09=09kfree(data);
> +=09=09=09return -EAGAIN;
> +=09=09}
> +
> +=09=09ret =3D mlxbf_pka_dev_trng_read(shim, data, byte_cnt);
> +=09=09if (ret) {
> +=09=09=09dev_dbg(ring_dev->device, "TRNG failed %d\n", ret);
> +=09=09=09kfree(data);
> +=09=09=09return ret;
> +=09=09}
> +
> +=09=09ret =3D copy_to_user((void __user *)(trng_data.data), data, trng_d=
ata.count);
> +=09=09kfree(data);
> +=09=09return ret ? -EFAULT : 0;
> +=09}
> +
> +=09return -ENOTTY;
> +}
> +
> +static int mlxbf_pka_drv_open(struct inode *inode, struct file *filep)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev;
> +=09int ret;
> +
> +=09mutex_lock(&pka.idr_lock);
> +=09ring_dev =3D idr_find(&pka.ring_idr, iminor(inode));
> +=09mutex_unlock(&pka.idr_lock);
> +=09if (!ring_dev) {
> +=09=09pr_err("mlxbf_pka error: failed to find idr for device\n");
> +=09=09return -ENODEV;
> +=09}
> +
> +=09ret =3D mlxbf_pka_drv_ring_open(ring_dev);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09filep->private_data =3D ring_dev;
> +=09return ret;
> +}
> +
> +static int mlxbf_pka_drv_release(struct inode *inode, struct file *filep=
)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev =3D filep->private_data;
> +
> +=09filep->private_data =3D NULL;
> +=09mlxbf_pka_drv_ring_release(ring_dev);
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_mmap(struct file *filep, struct vm_area_struct =
*vma)
> +{
> +=09return mlxbf_pka_drv_ring_mmap(filep->private_data, vma);
> +}
> +
> +static long mlxbf_pka_drv_unlocked_ioctl(struct file *filep, unsigned in=
t cmd, unsigned long arg)
> +{
> +=09return mlxbf_pka_drv_ring_ioctl(filep->private_data, cmd, arg);
> +}
> +
> +static const struct file_operations mlxbf_pka_ring_fops =3D {
> +=09.owner =3D THIS_MODULE,
> +=09.open =3D mlxbf_pka_drv_open,
> +=09.release =3D mlxbf_pka_drv_release,
> +=09.unlocked_ioctl =3D mlxbf_pka_drv_unlocked_ioctl,
> +=09.mmap =3D mlxbf_pka_drv_mmap,
> +};
> +
> +static int mlxbf_pka_drv_add_ring_device(struct mlxbf_pka_ring_device *r=
ing_dev)
> +{
> +=09struct device *dev =3D ring_dev->device;
> +=09char name[MLXBF_PKA_DEVICE_NAME_MAX];
> +=09int minor_number;
> +=09int ret;
> +
> +=09ret =3D snprintf(name, sizeof(name), MLXBF_PKA_DEVFS_RING_DEVICES, ri=
ng_dev->device_id);

scnprintf().

> +=09if (ret < 0) {
> +=09=09dev_err(dev, " -- snprintf failed: ret=3D%d\n", ret);

No you don't want to print this.

And I don't think the s*printf() even return errors so the entire check=20
is pointless.

> +=09=09return ret;
> +=09}
> +
> +=09ring_dev->misc.minor =3D MISC_DYNAMIC_MINOR;
> +=09ring_dev->misc.name =3D &name[0];
> +=09ring_dev->misc.mode =3D MLXBF_PKA_DEVICE_ACCESS_MODE;
> +=09ring_dev->misc.fops =3D &mlxbf_pka_ring_fops;
> +
> +=09ret =3D misc_register(&ring_dev->misc);
> +=09if (ret) {
> +=09=09dev_err(dev, " -- misc_register failed: ret=3D%d\n", ret);

Please try to avoid C code references in user visible error message, write=
=20
the explanation of the problem in English instead.

> +=09=09return ret;
> +=09}
> +
> +=09mutex_lock(&pka.idr_lock);
> +=09minor_number =3D idr_alloc(&pka.ring_idr,
> +=09=09=09=09 ring_dev,
> +=09=09=09=09 ring_dev->misc.minor,
> +=09=09=09=09 MINORMASK + 1,
> +=09=09=09=09 GFP_KERNEL);

Use less lines.

Missing #include ?

> +=09mutex_unlock(&pka.idr_lock);
> +=09if (minor_number !=3D ring_dev->misc.minor) {

Why you're not checking idr_alloc()'s return value as per the usual < 0 ??

Are you using idr only for reverse mapping these?

> +=09=09dev_err(dev, " -- idr_alloc failed with minor number %d\n", ring_d=
ev->misc.minor);

Remove "--".

> +=09=09return ring_dev->misc.minor;
> +=09}
> +
> +=09dev_info(dev, "ring device minor:%d\n", ring_dev->misc.minor);

dev_dbg() at most, if at all.

> +
> +=09return ret;
> +}
> +
> +static struct mlxbf_pka_ring_device *mlxbf_pka_drv_del_ring_device(struc=
t device *dev)
> +{
> +=09struct platform_device *pdev =3D container_of(dev, struct platform_de=
vice, dev);
> +=09struct mlxbf_pka_platdata *priv =3D platform_get_drvdata(pdev);
> +=09struct mlxbf_pka_info *info =3D priv->info;
> +=09struct mlxbf_pka_ring_device *ring_dev =3D info->priv;
> +
> +=09if (ring_dev) {
> +=09=09mutex_lock(&pka.idr_lock);
> +=09=09idr_remove(&pka.ring_idr, ring_dev->misc.minor);
> +=09=09mutex_unlock(&pka.idr_lock);
> +=09=09misc_deregister(&ring_dev->misc);
> +=09}
> +
> +=09return ring_dev;
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
> +=09mem_res->eip154_size =3D mlxbf_pka_dev->resource[acpi_mem_idx]->end -
> +=09=09=09       mem_res->eip154_base + 1;

resource_size(), please change all of them.

> +=09acpi_mem_idx++;
> +
> +=09/* PKA window RAM base address. */
> +=09mem_res->wndw_ram_base =3D mlxbf_pka_dev->resource[acpi_mem_idx]->sta=
rt;
> +=09mem_res->wndw_ram_size =3D mlxbf_pka_dev->resource[acpi_mem_idx]->end=
 -
> +=09=09=09=09 mem_res->wndw_ram_base + 1;
> +=09acpi_mem_idx++;
> +
> +=09/*
> +=09 * PKA alternate window RAM base address.
> +=09 * Note: the size of all the alt window RAM is the same, depicted by =
'alt_wndw_ram_size'
> +=09 * variable. All alt window RAM resources are read here even though n=
ot all of them are used
> +=09 * currently.
> +=09 */
> +=09mem_res->alt_wndw_ram_0_base =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]->start;
> +=09mem_res->alt_wndw_ram_size   =3D mlxbf_pka_dev->resource[acpi_mem_idx=
]->end -
> +=09=09=09=09       mem_res->alt_wndw_ram_0_base + 1;
> +
> +=09if (mem_res->alt_wndw_ram_size !=3D MLXBF_PKA_WINDOW_RAM_REGION_SIZE)
> +=09=09dev_err(mlxbf_pka_dev->device, "alternate Window RAM size from ACP=
I is wrong.\n");

Should this return error and result in failing to register the device?

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
> +=09mem_res->csr_size =3D mlxbf_pka_dev->resource[acpi_mem_idx]->end - me=
m_res->csr_base + 1;
> +}
> +
> +/*
> + * Note: this function must be serialized because it calls 'mlxbf_pka_de=
v_register_shim' which

Please assert the condition for serialization with lockdep so it is=20
properly enforced.

> + * manipulates common counters for the PKA devices.
> + */
> +static int mlxbf_pka_drv_register_device(struct mlxbf_pka_device *mlxbf_=
pka_dev,
> +=09=09=09=09=09 u64 wndw_ram_off_mask)
> +{
> +=09struct mlxbf_pka_dev_mem_res mem_res;
> +=09u32 mlxbf_pka_shim_id;
> +
> +=09/* Register shim. */

Obvious comment.

> +=09mlxbf_pka_shim_id =3D mlxbf_pka_dev->device_id;
> +
> +=09mlxbf_pka_drv_get_mem_res(mlxbf_pka_dev, &mem_res, wndw_ram_off_mask)=
;
> +
> +=09mlxbf_pka_dev->shim =3D mlxbf_pka_dev_register_shim(mlxbf_pka_dev->de=
vice,
> +=09=09=09=09=09=09=09  mlxbf_pka_shim_id,
> +=09=09=09=09=09=09=09  &mem_res);
> +=09if (!mlxbf_pka_dev->shim) {
> +=09=09dev_dbg(mlxbf_pka_dev->device, "failed to register shim\n");
> +=09=09return -EFAULT;

No, please shadow errnos like this (-EFAULT is wrong errno anyway, at=20
least most of the error I can see in that call chain). Change=20
mlxbf_pka_dev_register_shim()  to return correct errors and pass it on=20
here. You need to fix the entire call chain as some functions=20
mlxbf_pka_dev_register_shim() calls to also return errnos which it doesn't=
=20
properly propagate here.

> +=09}
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_unregister_device(struct mlxbf_pka_device *mlxb=
f_pka_dev)
> +{
> +=09if (!mlxbf_pka_dev)
> +=09=09return -EINVAL;
> +
> +=09if (mlxbf_pka_dev->shim) {

Can this be false as register side returned error?

If it can (which I'm skeptical about), reverse the logic and return early=
=20
instead.

> +=09=09dev_dbg(mlxbf_pka_dev->device, "unregister device shim\n");
> +=09=09return mlxbf_pka_dev_unregister_shim(mlxbf_pka_dev->shim);
> +=09}
> +
> +=09return 0;
> +}
> +
> +/*
> + * Note: this function must be serialized because it calls 'mlxbf_pka_de=
v_register_ring' which
> + * manipulates common counters for the PKA ring devices.
> + */
> +static int mlxbf_pka_drv_register_ring_device(struct mlxbf_pka_ring_devi=
ce *ring_dev)
> +{
> +=09u32 shim_id =3D ring_dev->parent_device_id;
> +=09u32 ring_id =3D ring_dev->device_id;
> +
> +=09ring_dev->ring =3D mlxbf_pka_dev_register_ring(ring_dev->device, ring=
_id, shim_id);
> +=09if (!ring_dev->ring) {
> +=09=09dev_dbg(ring_dev->device, "failed to register ring device\n");
> +=09=09return -EFAULT;
> +=09}
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_unregister_ring_device(struct mlxbf_pka_ring_de=
vice *ring_dev)
> +{
> +=09if (!ring_dev)
> +=09=09return -EINVAL;
> +
> +=09if (ring_dev->ring) {
> +=09=09dev_dbg(ring_dev->device, "unregister ring device\n");
> +=09=09return mlxbf_pka_dev_unregister_ring(ring_dev->ring);
> +=09}
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_rng_read(struct hwrng *rng, void *data, size_t =
max, bool wait)
> +{
> +=09struct mlxbf_pka_device *mlxbf_pka_dev =3D container_of(rng, struct m=
lxbf_pka_device, rng);
> +=09u32 *buffer =3D data;
> +=09int ret;
> +
> +=09ret =3D mlxbf_pka_dev_trng_read(mlxbf_pka_dev->shim, buffer, max);
> +=09if (ret) {
> +=09=09dev_dbg(mlxbf_pka_dev->device,
> +=09=09=09"%s: failed to read random bytes ret=3D%d",
> +=09=09=09rng->name, ret);
> +=09=09return 0;
> +=09}
> +
> +=09return max;
> +}
> +
> +static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
> +{
> +=09struct mlxbf_pka_drv_plat_info *plat_info;
> +=09enum mlxbf_pka_mem_res_idx acpi_mem_idx;
> +=09struct mlxbf_pka_device *mlxbf_pka_dev;
> +=09const struct acpi_device_id *aid;
> +=09const char *bootup_status;
> +=09u64 wndw_ram_off_mask;
> +=09struct hwrng *trng;
> +=09int ret;
> +

Please don't lave empty lines into variable declaration block.

> +=09struct device *dev =3D info->dev;
> +=09struct device_node *of_node =3D dev->of_node;
> +=09struct platform_device *pdev =3D to_platform_device(dev);
> +
> +=09if (!info)

Can this happen? Besides, you already dereferenced it above.

> +=09=09return -EINVAL;
> +
> +=09mlxbf_pka_dev =3D devm_kzalloc(dev, sizeof(*mlxbf_pka_dev), GFP_KERNE=
L);
> +=09if (!mlxbf_pka_dev)
> +=09=09return -ENOMEM;
> +
> +=09mutex_lock(&mlxbf_pka_drv_lock);

scoped_guard()

> +=09mlxbf_pka_device_cnt +=3D 1;
> +=09if (mlxbf_pka_device_cnt > MLXBF_PKA_DRIVER_DEV_MAX) {
> +=09=09dev_dbg(dev, "cannot support %u devices\n", mlxbf_pka_device_cnt);
> +=09=09mutex_unlock(&mlxbf_pka_drv_lock);
> +=09=09return -EPERM;

Wrong error code.

> +=09}
> +=09mlxbf_pka_dev->device_id =3D mlxbf_pka_device_cnt - 1;
> +=09mutex_unlock(&mlxbf_pka_drv_lock);
> +
> +=09mlxbf_pka_dev->info =3D info;
> +=09mlxbf_pka_dev->device =3D dev;
> +=09info->flag =3D MLXBF_PKA_DRIVER_FLAG_DEVICE;
> +
> +=09for (acpi_mem_idx =3D MLXBF_PKA_ACPI_EIP154_IDX;
> +=09=09acpi_mem_idx < MLXBF_PKA_DEVICE_RES_CNT; acpi_mem_idx++) {

Misaligned.

> +=09=09mlxbf_pka_dev->resource[acpi_mem_idx] =3D platform_get_resource(pd=
ev,
> +=09=09=09=09=09=09=09=09=09      IORESOURCE_MEM,
> +=09=09=09=09=09=09=09=09=09      acpi_mem_idx);
> +=09}
> +
> +=09/* Verify PKA bootup status. */
> +=09ret =3D device_property_read_string(dev, "bootup_done", &bootup_statu=
s);
> +=09if (ret < 0 || strcmp(bootup_status, "true")) {

For ret < 0 case, you should return the original error code.

> +=09=09dev_err(dev, "device bootup required\n");
> +=09=09return -EPERM;

Likely wrong error code.

> +=09}
> +
> +=09/* Window RAM offset mask is platform dependent. */
> +=09aid =3D acpi_match_device(mlxbf_pka_drv_acpi_ids, dev);
> +=09if (!aid)
> +=09=09return -ENODEV;
> +
> +=09plat_info =3D (struct mlxbf_pka_drv_plat_info *)aid->driver_data;
> +=09if (plat_info->type <=3D MLXBF_PKA_PLAT_TYPE_BF2) {
> +=09=09wndw_ram_off_mask =3D MLXBF_PKA_WINDOW_RAM_OFFSET_MASK1;
> +=09} else if (plat_info->type <=3D MLXBF_PKA_PLAT_TYPE_BF3) {
> +=09=09wndw_ram_off_mask =3D MLXBF_PKA_WINDOW_RAM_OFFSET_MASK2;

Put this mask into a field in driver_data.

> +=09} else {

Can this happen?

> +=09=09dev_err(dev, "invalid platform type: %d\n", (int)plat_info->type);
> +=09=09return -EINVAL;
> +=09}
> +
> +=09/* Set interrupts. */
> +=09ret =3D platform_get_irq(pdev, 0);
> +=09mlxbf_pka_dev->irq =3D ret;

Assign directly to mlxbf_pka_dev->irq ?

> +=09if (ret =3D=3D -ENXIO && of_node) {
> +=09=09mlxbf_pka_dev->irq =3D MLXBF_PKA_IRQ_NONE;
> +=09} else if (ret < 0) {
> +=09=09dev_err(dev, "failed to get device IRQ\n");
> +=09=09return ret;
> +=09}
> +
> +=09/* Register IRQ. */
> +=09ret =3D mlxbf_pka_drv_register_irq(mlxbf_pka_dev);
> +=09if (ret) {
> +=09=09dev_err(dev, "failed to register device IRQ\n");
> +=09=09return ret;
> +=09}
> +
> +=09mutex_lock(&mlxbf_pka_drv_lock);

scoped_guard()

> +=09ret =3D mlxbf_pka_drv_register_device(mlxbf_pka_dev, wndw_ram_off_mas=
k);
> +=09if (ret) {
> +=09=09dev_dbg(dev, "failed to register shim\n");
> +=09=09mutex_unlock(&mlxbf_pka_drv_lock);
> +=09=09return ret;
> +=09}
> +=09mutex_unlock(&mlxbf_pka_drv_lock);
> +
> +=09/* Setup the TRNG if needed. */
> +=09if (mlxbf_pka_dev_has_trng(mlxbf_pka_dev->shim)) {
> +=09=09trng =3D &mlxbf_pka_dev->rng;
> +=09=09trng->name =3D pdev->name;
> +=09=09trng->read =3D mlxbf_pka_drv_rng_read;
> +
> +=09=09ret =3D hwrng_register(&mlxbf_pka_dev->rng);
> +=09=09if (ret) {
> +=09=09=09dev_err(dev, "failed to register trng\n");
> +=09=09=09return ret;
> +=09=09}
> +=09}
> +
> +=09info->priv =3D mlxbf_pka_dev;
> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_remove_device(struct platform_device *pdev)
> +{
> +=09struct mlxbf_pka_platdata *priv =3D platform_get_drvdata(pdev);
> +=09struct mlxbf_pka_info *info =3D priv->info;
> +=09struct mlxbf_pka_device *mlxbf_pka_dev =3D (struct mlxbf_pka_device *=
)info->priv;
> +
> +=09if (!mlxbf_pka_dev) {
> +=09=09pr_err("mlxbf_pka error: failed to unregister device\n");

Remove.

> +=09=09return -EINVAL;
> +=09}
> +
> +=09if (mlxbf_pka_dev_has_trng(mlxbf_pka_dev->shim))
> +=09=09hwrng_unregister(&mlxbf_pka_dev->rng);
> +
> +=09if (mlxbf_pka_drv_unregister_device(mlxbf_pka_dev))
> +=09=09dev_err(&pdev->dev, "failed to unregister device\n");

Yeah, just as I thought, nothing useful can be done on  this error. Just=20
remove the error print and convert the unregister chain into void.

> +
> +=09return 0;
> +}
> +
> +static int mlxbf_pka_drv_probe_ring_device(struct mlxbf_pka_info *info)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev;
> +=09struct device *dev =3D info->dev;
> +=09const char *bootup_status;
> +=09int ret;
> +
> +=09if (!info)
> +=09=09return -EINVAL;
> +
> +=09ring_dev =3D devm_kzalloc(dev, sizeof(*ring_dev), GFP_KERNEL);
> +=09if (!ring_dev)
> +=09=09return -ENOMEM;
> +
> +=09if (!mlxbf_pka_ring_device_cnt) {
> +=09=09mutex_init(&pka.idr_lock);

What protects these two lines? I don't see any locks here or=20
lockdep asserts.

devm_mutex_init() + error handling.

> +=09=09mutex_lock(&pka.idr_lock);
> +=09=09/* Only initialize IDR if there is no ring device registered. */
> +=09=09idr_init(&pka.ring_idr);
> +=09=09mutex_unlock(&pka.idr_lock);
> +=09}
> +
> +=09mutex_lock(&mlxbf_pka_drv_lock);

scoped_guard()

> +=09mlxbf_pka_ring_device_cnt +=3D 1;
> +=09if (mlxbf_pka_ring_device_cnt > MLXBF_PKA_DRIVER_RING_DEV_MAX) {
> +=09=09dev_dbg(dev, "cannot support %u ring devices\n", mlxbf_pka_ring_de=
vice_cnt);
> +=09=09mutex_unlock(&mlxbf_pka_drv_lock);
> +=09=09return -EPERM;

Wrong error code.

> +=09}
> +=09ring_dev->device_id =3D mlxbf_pka_ring_device_cnt - 1;
> +=09ring_dev->parent_device_id =3D mlxbf_pka_device_cnt - 1;
> +=09mutex_unlock(&mlxbf_pka_drv_lock);
> +
> +=09ring_dev->info =3D info;
> +=09ring_dev->device =3D dev;
> +=09info->flag =3D MLXBF_PKA_DRIVER_FLAG_RING_DEVICE;
> +=09mutex_init(&ring_dev->mutex);
> +
> +=09/* Verify PKA bootup status. */
> +=09ret =3D device_property_read_string(dev, "bootup_done", &bootup_statu=
s);
> +=09if (ret < 0 || strcmp(bootup_status, "true")) {
> +=09=09dev_err(dev, "device bootup required\n");
> +=09=09return -EPERM;

Duplicated code should be moved into a helper (I didn't check the full=20
extent of it but I got a dejavu here).

> +=09}
> +
> +=09mutex_lock(&mlxbf_pka_drv_lock);

scoped_guard() ?

> +=09/* Add PKA ring device. */
> +=09ret =3D mlxbf_pka_drv_add_ring_device(ring_dev);
> +=09if (ret) {
> +=09=09dev_dbg(dev, "failed to add ring device %u\n", ring_dev->device_id=
);
> +=09=09mutex_unlock(&mlxbf_pka_drv_lock);
> +=09=09return ret;
> +=09}
> +
> +=09/* Register PKA ring device. */
> +=09ret =3D mlxbf_pka_drv_register_ring_device(ring_dev);
> +=09if (ret) {
> +=09=09dev_dbg(dev, "failed to register ring device\n");
> +=09=09mutex_unlock(&mlxbf_pka_drv_lock);
> +=09=09goto err_register_ring;
> +=09}
> +=09mutex_unlock(&mlxbf_pka_drv_lock);
> +
> +=09info->priv =3D ring_dev;
> +
> +=09return 0;
> +
> + err_register_ring:
> +=09mlxbf_pka_drv_del_ring_device(dev);
> +=09return ret;
> +}
> +
> +static int mlxbf_pka_drv_remove_ring_device(struct platform_device *pdev=
)
> +{
> +=09struct mlxbf_pka_ring_device *ring_dev;
> +=09struct device *dev =3D &pdev->dev;
> +=09int ret;
> +
> +=09ring_dev =3D mlxbf_pka_drv_del_ring_device(dev);
> +=09if (ring_dev) {
> +=09=09ret =3D mlxbf_pka_drv_unregister_ring_device(ring_dev);
> +=09=09if (ret) {
> +=09=09=09dev_err(dev, "failed to unregister pka device\n");
> +=09=09=09return ret;
> +=09=09}
> +=09=09mlxbf_pka_ring_device_cnt--;
> +=09}
> +
> +=09if (!mlxbf_pka_ring_device_cnt) {
> +=09=09mutex_lock(&pka.idr_lock);
> +=09=09/* Only destroy IDR if there is no ring device registered. */
> +=09=09idr_destroy(&pka.ring_idr);
> +=09=09mutex_unlock(&pka.idr_lock);
> +=09}
> +
> +=09return 0;
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
> +=09if (!strcmp(info->acpihid, mlxbf_pka_ring_acpihid_bf1) ||
> +=09    !strcmp(info->acpihid, mlxbf_pka_ring_acpihid_bf2) ||
> +=09    !strcmp(info->acpihid, mlxbf_pka_ring_acpihid_bf3)) {
> +=09=09ret =3D mlxbf_pka_drv_probe_ring_device(info);
> +=09=09if (ret) {
> +=09=09=09dev_dbg(dev, "failed to register ring device\n");
> +=09=09=09return ret;
> +=09=09}
> +=09=09dev_dbg(dev, "ring device probed\n");
> +
> +=09} else if (!strcmp(info->acpihid, mlxbf_pka_acpihid_bf1) ||
> +=09=09   !strcmp(info->acpihid, mlxbf_pka_acpihid_bf2) ||
> +=09=09   !strcmp(info->acpihid, mlxbf_pka_acpihid_bf3)) {

Split these two types to use own probe functions so you don't need to=20
duplicate matching here like this.

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
> +=09/* Interrupt is disabled to begin with. */
> +=09priv->irq_flags =3D 0;
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
> +=09if (info->flag =3D=3D MLXBF_PKA_DRIVER_FLAG_RING_DEVICE) {
> +=09=09dev_info(&pdev->dev, "remove ring device\n");
> +=09=09if (mlxbf_pka_drv_remove_ring_device(pdev))
> +=09=09=09dev_dbg(&pdev->dev, "failed to remove ring device\n");
> +=09}
> +
> +=09if (info->flag =3D=3D MLXBF_PKA_DRIVER_FLAG_DEVICE) {
> +=09=09dev_info(&pdev->dev, "remove PKA device\n");
> +=09=09if (mlxbf_pka_drv_remove_device(pdev))
> +=09=09=09dev_dbg(&pdev->dev, "failed to remove PKA device\n");
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

This is extremely long and it would make reviewing it significantly easier=
=20
if it would be split into multiple, logical patches. Mixing two types of=20
devices in a single probe adds to the confusion, can like one of those be=
=20
introduced first and then the other?

--=20
 i.

--8323328-891142650-1747387176=:1009--
