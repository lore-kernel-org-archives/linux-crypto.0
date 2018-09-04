From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] vfio: vfio_sdmdev_groups[] can be static
Date: Tue, 4 Sep 2018 23:31:35 +0800
Message-ID: <20180904153135.GI17047@intel.com>
References: <20180903005204.26041-4-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>,
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
In-Reply-To: <20180903005204.26041-4-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Fixes: 1e47d5e60865 ("vfio: add sdmdev support")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 vfio_sdmdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/sdmdev/vfio_sdmdev.c b/drivers/vfio/sdmdev/vfio_sdmdev.c
index c6eb5d4..e7d3c23 100644
--- a/drivers/vfio/sdmdev/vfio_sdmdev.c
+++ b/drivers/vfio/sdmdev/vfio_sdmdev.c
@@ -103,7 +103,7 @@ static const struct attribute_group vfio_sdmdev_group = {
 	.name  = VFIO_SDMDEV_PDEV_ATTRS_GRP_NAME,
 	.attrs = vfio_sdmdev_attrs,
 };
-const struct attribute_group *vfio_sdmdev_groups[] = {
+static const struct attribute_group *vfio_sdmdev_groups[] = {
 	&vfio_sdmdev_group,
 	NULL,
 };
