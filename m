From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 0/4] crypto: omap-sham: Add support for SHA384/SHA512 for OMAP5/AM43xx Soc's
Date: Fri, 26 Jul 2013 12:29:13 +0530
Message-ID: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
	<herbert@gondor.hengli.com.au>, <rnayak@ti.com>, <nsekhar@ti.com>,
	<joelf@ti.com>, <lokeshvutla@ti.com>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38503 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab3GZG7x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jul 2013 02:59:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds support for SHA348 and SHA512 in addition to MD5,
SHA1, SHA224 SHA256 that the omap sha module supports. Also adding the pdata
for OMAP5 and AM43xx Soc's.
And using devm_* calls to make cleanup paths simpler.

Lokesh Vutla (4):
  crypto: omap-sham: Add SHA384 and SHA512 Support
  crypto: omap-sham: Add OMAP5/AM43XX SHAM Support
  crypto: omap-sham: Convert to devm_request_irq()
  crypto: omap-sham: Convert to devm_kzalloc()

 drivers/crypto/Kconfig     |   11 +-
 drivers/crypto/omap-sham.c |  314 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 262 insertions(+), 63 deletions(-)

-- 
1.7.9.5
