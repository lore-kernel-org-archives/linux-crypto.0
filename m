From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 90/113] crypto/xts.c:254:2-8: WARNING: NULL check
 before freeing functions like kfree, debugfs_remove,
 debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
 reorganizing relevant code to avoid passing NULL values.
Date: Tue, 29 Nov 2016 01:55:11 +0800
Message-ID: <201611290109.QX2C2GNz%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37409 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752677AbcK1R4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 12:56:02 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   eb0955935e2ae3aa1fc9c34ec684ffe086e81da7
commit: f1c131b45410a202eb45cc55980a7a9e4e4b4f40 [90/113] crypto: xts - Convert to skcipher


coccinelle warnings: (new ones prefixed by >>)

>> crypto/xts.c:254:2-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
