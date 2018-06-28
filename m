From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/4] crypto: ccree: fix iv handling
Date: Thu, 28 Jun 2018 19:42:36 +0800
Message-ID: <201806281901.KbE00xRE%fengguang.wu@intel.com>
References: <1530171175-31960-4-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530171175-31960-4-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

I love your patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.18-rc2 next-20180628]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Gilad-Ben-Yossef/crypto-ccree-fix-finup/20180628-162032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/ccree/cc_cipher.c:369:17: sparse: Variable length array is used.
>> drivers/crypto/ccree/cc_cipher.c:599:6: sparse: symbol 'cc_update_ctr' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
