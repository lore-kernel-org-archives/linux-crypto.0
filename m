From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 112/119] drivers/crypto/ccp/ccp-dev.c:120:2-20:
 ERROR: nested lock+irqsave that reuses flags from line 118.
Date: Fri, 11 Mar 2016 22:17:19 +0800
Message-ID: <201603112217.4r9mhpQL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7465 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbcCKOSH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 09:18:07 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   34074205bb9f04b416efb3cbedcd90f418c86200
commit: 553d2374db0bb3f48bbd29bef7ba2a4d1a3f325d [112/119] crypto: ccp - Support for multiple CCPs


coccinelle warnings: (new ones prefixed by >>)

>> drivers/crypto/ccp/ccp-dev.c:120:2-20: ERROR: nested lock+irqsave that reuses flags from line 118.

vim +120 drivers/crypto/ccp/ccp-dev.c

   112		unsigned long flags;
   113		struct ccp_device *dp = NULL;
   114	
   115		/* We round-robin through the unit list.
   116		 * The (ccp_rr) pointer refers to the next unit to use.
   117		 */
 > 118		read_lock_irqsave(&ccp_unit_lock, flags);
   119		if (!list_empty(&ccp_units)) {
 > 120			write_lock_irqsave(&ccp_rr_lock, flags);
   121			dp = ccp_rr;
   122			if (list_is_last(&ccp_rr->entry, &ccp_units))
   123				ccp_rr = list_first_entry(&ccp_units, struct ccp_device,

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
