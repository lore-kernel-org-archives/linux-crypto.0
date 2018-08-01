From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 3/7] vfio: add spimdev support
Date: Wed, 1 Aug 2018 09:23:52 -0700
Message-ID: <d11c7745-2f31-0f33-1bd8-78379dc66e6e@infradead.org>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801102221.5308-4-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linuxarm@huawei.com
To: Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801102221.5308-4-nek.in.cn@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/01/2018 03:22 AM, Kenneth Lee wrote:
> From: Kenneth Lee <liguozhu@hisilicon.com>
> 
> SPIMDEV is "Share Parent IOMMU Mdev". It is a vfio-mdev. But differ from
> the general vfio-mdev:
> 
> 1. It shares its parent's IOMMU.
> 2. There is no hardware resource attached to the mdev is created. The
> hardware resource (A `queue') is allocated only when the mdev is
> opened.
> 
> Currently only the vfio type-1 driver is updated to make it to be aware
> of.
> 
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>  drivers/vfio/Kconfig                |   1 +
>  drivers/vfio/Makefile               |   1 +
>  drivers/vfio/spimdev/Kconfig        |  10 +
>  drivers/vfio/spimdev/Makefile       |   3 +
>  drivers/vfio/spimdev/vfio_spimdev.c | 421 ++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c     | 136 ++++++++-
>  include/linux/vfio_spimdev.h        |  95 +++++++
>  include/uapi/linux/vfio_spimdev.h   |  28 ++
>  8 files changed, 689 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/vfio/spimdev/Kconfig
>  create mode 100644 drivers/vfio/spimdev/Makefile
>  create mode 100644 drivers/vfio/spimdev/vfio_spimdev.c
>  create mode 100644 include/linux/vfio_spimdev.h
>  create mode 100644 include/uapi/linux/vfio_spimdev.h
> 
> diff --git a/drivers/vfio/spimdev/Kconfig b/drivers/vfio/spimdev/Kconfig
> new file mode 100644
> index 000000000000..1226301f9d0e
> --- /dev/null
> +++ b/drivers/vfio/spimdev/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config VFIO_SPIMDEV
> +	tristate "Support for Share Parent IOMMU MDEV"
> +	depends on VFIO_MDEV_DEVICE
> +	help
> +	  Support for VFIO Share Parent IOMMU MDEV, which enable the kernel to

	                                                  enables

> +	  support for the light weight hardware accelerator framework, WrapDrive.

	  support the lightweight hardware accelerator framework, WrapDrive.

> +
> +	  To compile this as a module, choose M here: the module will be called
> +	  spimdev.


-- 
~Randy
