From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/7] vfio: add sdmdev support
Date: Tue, 4 Sep 2018 23:32:04 +0800
Message-ID: <20180904153204.GJ17047@intel.com>
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

Hi Kenneth,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.19-rc2 next-20180831]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kenneth-Lee/A-General-Accelerator-Framework-WarpDrive/20180903-162733
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__
:::::: branch date: 3 hours ago
:::::: commit date: 3 hours ago

>> drivers/vfio/sdmdev/vfio_sdmdev.c:106:30: sparse: symbol 'vfio_sdmdev_groups' was not declared. Should it be static?
   drivers/vfio/sdmdev/vfio_sdmdev.c: In function 'vfio_sdmdev_mdev_remove':
   drivers/vfio/sdmdev/vfio_sdmdev.c:178:2: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     if (sdmdev->ops->put_queue);
     ^~
   drivers/vfio/sdmdev/vfio_sdmdev.c:179:3: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
      sdmdev->ops->put_queue(q);
      ^~~~~~

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
