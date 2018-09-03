From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 6/7] crypto: add sdmdev support to Hisilicon QM
Date: Sun, 2 Sep 2018 19:19:03 -0700
Message-ID: <46e57b2b-756e-e256-5b3c-30749d865512@infradead.org>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180903005204.26041-7-nek.in.cn@gmail.com>
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
In-Reply-To: <20180903005204.26041-7-nek.in.cn@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/02/2018 05:52 PM, Kenneth Lee wrote:
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index 1d155708cd69..b85fab48fdab 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -17,6 +17,16 @@ config CRYPTO_DEV_HISI_SEC
>  	  To compile this as a module, choose M here: the module
>  	  will be called hisi_sec.
>  
> +config CRYPTO_DEV_HISI_SDMDEV
> +	bool "Enable SDMDEV interface"
> +	depends on CRYPTO_DEV_HISILICON
> +	select VFIO_SDMDEV
> +	help
> +	  Enable this enable the SDMDEV, "shared IOMMU Domain Mediated Device"

At a minimum:
	  Enable this to enable the SDMDEV,

although that could be done better.  Maybe just:
	  Enable the SDMDEV "shared IOMMU Domain Mediated Device"

	  
> +	  interface for all Hisilicon accelerators if they can. The SDMDEV

probably drop "if they can":          accelerators.  The SDMDEV interface

> +	  enable the WarpDrive user space accelerator driver to access the

	  enables

> +	  hardware function directly.
> +


-- 
~Randy
