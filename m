From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 3/3] drivers: crypto: Enable CPT options crypto for
 build
Date: Thu, 12 Jan 2017 21:38:57 +0800
Message-ID: <201701122154.qOAETU7M%fengguang.wu@intel.com>
References: <1484132211-917-4-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, david.daney@cavium.com,
        clabbe.montjoie@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        George Cherian <george.cherian@cavium.com>
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484132211-917-4-git-send-email-george.cherian@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi George,

[auto build test WARNING on v4.9-rc8]
[cannot apply to cryptodev/master crypto/master sparc-next/master next-20170111]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/George-Cherian/Add-Support-for-Cavium-Cryptographic-Acceleration-Unit/20170112-192240


coccinelle warnings: (new ones prefixed by >>)

>> drivers/crypto/cavium/cpt/cptvf_reqmanager.c:312:2-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.
   drivers/crypto/cavium/cpt/cptvf_reqmanager.c:315:2-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.
   drivers/crypto/cavium/cpt/cptvf_reqmanager.c:318:2-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.
   drivers/crypto/cavium/cpt/cptvf_reqmanager.c:321:2-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
