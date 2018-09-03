From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 4/7] crypto: add hisilicon Queue Manager driver
Date: Sun, 2 Sep 2018 19:15:07 -0700
Message-ID: <4e46a451-d1cd-ac68-84b4-20792fdbc733@infradead.org>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180903005204.26041-5-nek.in.cn@gmail.com>
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
In-Reply-To: <20180903005204.26041-5-nek.in.cn@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/02/2018 05:52 PM, Kenneth Lee wrote:
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index 8ca9c503bcb0..02a6eef84101 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -1,4 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
> +config CRYPTO_DEV_HISILICON
> +	tristate "Support for HISILICON CRYPTO ACCELERATOR"
> +	help
> +	  Enable this to use Hisilicon Hardware Accelerators

	                                        Accelerators.


-- 
~Randy
