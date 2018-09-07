From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 7 Sep 2018 14:04:13 -0400
Message-ID: <20180907180412.GC3519@redhat.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180904150019.GA4024@redhat.com>
 <20180904101509.62314b67@t450s.home>
 <20180906094532.GG230707@Turing-Arch-b>
 <20180906133133.GA3830@redhat.com>
 <20180907040138.GI230707@Turing-Arch-b>
 <20180907165303.GA3519@redhat.com>
 <404f0944-d514-b450-f743-89ae798ac694@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <liguozhu@hisilicon.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, Alex Williamson <alex.williamson@redhat.com>,
        linux-crypto@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-accelerators@lists.ozlabs.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <404f0944-d514-b450-f743-89ae798ac694@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 07, 2018 at 06:55:45PM +0100, Jean-Philippe Brucker wrote:
> On 07/09/2018 17:53, Jerome Glisse wrote:
> > So there is no reasons to do that under VFIO. Especialy as in your example
> > it is not a real user space device driver, the userspace portion only knows
> > about writting command into command buffer AFAICT.
> > 
> > VFIO is for real userspace driver where interrupt, configurations, ... ie
> > all the driver is handled in userspace. This means that the userspace have
> > to be trusted as it could program the device to do DMA to anywhere (if
> > IOMMU is disabled at boot which is still the default configuration in the
> > kernel).
> 
> If the IOMMU is disabled (not exactly a kernel default by the way, I
> think most IOMMU drivers enable it by default), your userspace driver
> can't bypass DMA isolation by accident. It just won't be allowed to
> access the device. VFIO requires an IOMMU unless the admin forces the
> NOIOMMU mode with the "enable_unsafe_noiommu_mode" module parameter, and
> the userspace explicitly asks for it with VFIO_NOIOMMU_IOMMU, which
> taints the kernel. Not for production. A normal userspace driver that
> uses VFIO can only do DMA to its own memory.
> 

Didn't know about VFIO check, which is a sane thing. On Intel  IOMMU
is disabled by default (see INTEL_IOMMU_DEFAULT_ON Kconfig option).
I am pretty sure it use to be the same for AMD but maybe it is now
enabled by default.

Cheers,
Jérôme
