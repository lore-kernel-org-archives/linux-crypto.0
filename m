From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 9/38] drivers/crypto/ccree/cc_cipher.c:629:15-22:
 WARNING opportunity for kmemdep
Date: Fri, 16 Feb 2018 00:40:13 +0800
Message-ID: <201802160011.TvUkTLwK%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1451 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1426100AbeBOQlL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 11:41:11 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   a43a34845a156c9e1dae00e33595a508d53e0365
commit: 63ee04c8b491ee148489347e7da9fbfd982ca2bb [9/38] crypto: ccree - add skcipher support


coccinelle warnings: (new ones prefixed by >>)

>> drivers/crypto/ccree/cc_cipher.c:629:15-22: WARNING opportunity for kmemdep

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
