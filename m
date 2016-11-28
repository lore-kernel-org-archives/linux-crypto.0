From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 89/113] crypto/lrw.c:313:2-7: WARNING: NULL check
 before freeing functions like kfree, debugfs_remove,
 debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
 reorganizing relevant code to avoid passing NULL values.
Date: Tue, 29 Nov 2016 01:42:38 +0800
Message-ID: <201611290136.N4sAw6FB%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8621 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752333AbcK1RnB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 12:43:01 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   eb0955935e2ae3aa1fc9c34ec684ffe086e81da7
commit: 700cb3f5fe755b1a2d0f5cf3ae89ad7ef69d321f [89/113] crypto: lrw - Convert to skcipher


coccinelle warnings: (new ones prefixed by >>)

>> crypto/lrw.c:313:2-7: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
