From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 1/7] vfio/spimdev: Add documents for WarpDrive
 framework
Date: Mon, 6 Aug 2018 14:27:33 +0200
Message-ID: <20180806122733.GA17232@xo-6d-61-c0.localdomain>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801102221.5308-2-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Corbet <corbet@lwn.net>,
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
        Sanjay Kumar <sanjay.k.kumar@intel.com>, linuxarm@huawei.com
To: Kenneth Lee <nek.in.cn@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801102221.5308-2-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> WarpDrive is a common user space accelerator framework.  Its main component
> in Kernel is called spimdev, Share Parent IOMMU Mediated Device. It exposes

spimdev is really unfortunate name. It looks like it has something to do with SPI, but
it does not.

> +++ b/Documentation/warpdrive/warpdrive.rst
> @@ -0,0 +1,153 @@
> +Introduction of WarpDrive
> +=========================
> +
> +*WarpDrive* is a general accelerator framework built on top of vfio.
> +It can be taken as a light weight virtual function, which you can use without
> +*SR-IOV* like facility and can be shared among multiple processes.
> +
> +It can be used as the quick channel for accelerators, network adaptors or
> +other hardware in user space. It can make some implementation simpler.  E.g.
> +you can reuse most of the *netdev* driver and just share some ring buffer to
> +the user space driver for *DPDK* or *ODP*. Or you can combine the RSA
> +accelerator with the *netdev* in the user space as a Web reversed proxy, etc.

What is DPDK? ODP?

> +How does it work
> +================
> +
> +*WarpDrive* takes the Hardware Accelerator as a heterogeneous processor which
> +can share some load for the CPU:
> +
> +.. image:: wd.svg
> +        :alt: This is a .svg image, if your browser cannot show it,
> +                try to download and view it locally
> +
> +So it provides the capability to the user application to:
> +
> +1. Send request to the hardware
> +2. Share memory with the application and other accelerators
> +
> +These requirements can be fulfilled by VFIO if the accelerator can serve each
> +application with a separated Virtual Function. But a *SR-IOV* like VF (we will
> +call it *HVF* hereinafter) design is too heavy for the accelerator which
> +service thousands of processes.

VFIO? VF? HVF?

Also "gup" might be worth spelling out.

> +References
> +==========
> +.. [1] Accroding to the comment in in mm/gup.c, The *gup* is only safe within
> +       a syscall.  Because it can only keep the physical memory in place
> +       without making sure the VMA will always point to it. Maybe we should
> +       raise the VM_PINNED patchset (see
> +       https://lists.gt.net/linux/kernel/1931993) again to solve this probl


I went through the docs, but I still don't know what it does.
											Pavel
