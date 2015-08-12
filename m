From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 118/125]
 drivers/crypto/qat/qat_common/adf_sriov.c:258:1-4: WARNING: end returns can
 be simpified and declaration on line 212 can be dropped
Date: Wed, 12 Aug 2015 12:50:17 +0800
Message-ID: <201508121211.ta8z9Ugl%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:39960 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbbHLEuZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 00:50:25 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   d5cf4023ebcbae13e14e3ab3c55cb744321b352e
commit: ed8ccaef52fa03fb03cff45b380f72c9f869f273 [118/125] crypto: qat - Add support for SRIOV


coccinelle warnings: (new ones prefixed by >>)

>> drivers/crypto/qat/qat_common/adf_sriov.c:258:1-4: WARNING: end returns can be simpified and declaration on line 212 can be dropped

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
