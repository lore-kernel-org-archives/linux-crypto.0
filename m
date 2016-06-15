From: kbuild test robot <fengguang.wu@intel.com>
Subject: [cryptodev:master 47/51] crypto/drbg.c:1637:39-40: Unneeded semicolon
Date: Wed, 15 Jun 2016 19:13:25 +0800
Message-ID: <201606151923.o07hQ3Ki%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15462 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbcFOLOM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 07:14:12 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   5a7de97309f5af4458b1a25a2a529a1a893c5269
commit: 355912852115cd8aa4ad02c25182ae615ce925fb [47/51] crypto: drbg - use CTR AES instead of ECB AES


coccinelle warnings: (new ones prefixed by >>)

>> crypto/drbg.c:1637:39-40: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
