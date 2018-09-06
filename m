From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [PATCH 3/7] vfio: add sdmdev support
Date: Thu, 6 Sep 2018 16:08:24 +0800
Message-ID: <20180906080824.GA230707@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180903005204.26041-4-nek.in.cn@gmail.com>
 <0574e7dc-bed2-d2d0-3aa6-93590d54ce81@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <linux-accelerators@lists.ozlabs.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>, <linuxarm@huawei.com>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0574e7dc-bed2-d2d0-3aa6-93590d54ce81@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 02, 2018 at 07:11:12PM -0700, Randy Dunlap wrote:
> Date: Sun, 2 Sep 2018 19:11:12 -0700
> From: Randy Dunlap <rdunlap@infradead.org>
> To: Kenneth Lee <nek.in.cn@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
>  Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
>  <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>, Alex Williamson
>  <alex.williamson@redhat.com>, Kenneth Lee <liguozhu@hisilicon.com>, Hao
>  Fang <fanghao11@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, Zaibo Xu
>  <xuzaibo@huawei.com>, Philippe Ombredanne <pombredanne@nexb.com>, Greg
>  Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner
>  <tglx@linutronix.de>, linux-doc@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
>  iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
>  linux-accelerators@lists.ozlabs.org, Lu Baolu <baolu.lu@linux.intel.com>,
>  Sanjay Kumar <sanjay.k.kumar@intel.com>
> CC: linuxarm@huawei.com
> Subject: Re: [PATCH 3/7] vfio: add sdmdev support
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
>  Thunderbird/52.9.1
> Message-ID: <0574e7dc-bed2-d2d0-3aa6-93590d54ce81@infradead.org>
> 
> On 09/02/2018 05:52 PM, Kenneth Lee wrote:
> > diff --git a/drivers/vfio/sdmdev/Kconfig b/drivers/vfio/sdmdev/Kconfig
> > new file mode 100644
> > index 000000000000..51474272870d
> > --- /dev/null
> > +++ b/drivers/vfio/sdmdev/Kconfig
> > @@ -0,0 +1,10 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +config VFIO_SDMDEV
> > +	tristate "Support for Share Domain MDEV"
> > +	depends on VFIO_MDEV_DEVICE
> > +	help
> > +	  Support for VFIO Share Domain MDEV, which enables the kernel to
> > +	  support light weight hardware accelerator framework, WarpDrive.
> 
> 	          lightweight
> 
Thank you, will fix it.
> > +
> > +	  To compile this as a module, choose M here: the module will be called
> > +	  sdmdev.
> 
> 
> thanks,
> -- 
> ~Randy

-- 
			-Kenneth(Hisilicon)
