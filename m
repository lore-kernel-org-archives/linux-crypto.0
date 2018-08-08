From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC PATCH 2/7] iommu: Add share domain interface in iommu for
 spimdev
Date: Wed, 8 Aug 2018 11:13:54 +0200
Message-ID: <20180808091354.ppqgineql3pufwwr@8bytes.org>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801102221.5308-3-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
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
In-Reply-To: <20180801102221.5308-3-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 01, 2018 at 06:22:16PM +0800, Kenneth Lee wrote:
> From: Kenneth Lee <liguozhu@hisilicon.com>
> 
> This patch add sharing interface for a iommu_group. The new interface:
> 
> 	iommu_group_share_domain()
> 	iommu_group_unshare_domain()
> 
> can be used by some virtual iommu_group (such as iommu_group for spimdev)
> to share their parent's iommu_group.
> 
> When the domain of the group is shared, it cannot be changed before
> unshared.  In the future, notification can be added if update is required.

>From the description or the patch I don't really get why this is needed.
Please update the description and make a case for this API addition.


	Joerg
