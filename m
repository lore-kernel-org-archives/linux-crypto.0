From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v7 11/14] crypto: marvell/CESA: add allhwsupport module parameter
Date: Thu, 18 Jun 2015 15:46:27 +0200
Message-ID: <1434635190-27733-12-git-send-email-boris.brezillon@free-electrons.com>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"Imre Kaloz" <kaloz@openwrt.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:37576 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932295AbbFRNrO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 09:47:14 -0400
In-Reply-To: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The old and new marvell CESA drivers both support Orion and Kirkwood SoCs.
Add a module parameter to choose whether these SoCs should be attached to
the new or the old driver.

The default policy is to keep attaching those IPs to the old driver if it
is enabled, until we decide the new CESA driver is stable/secure enough.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index af590bf..a05b5cb 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -31,6 +31,10 @@
 
 #include "cesa.h"
 
+static int allhwsupport = !IS_ENABLED(CONFIG_CRYPTO_DEV_MV_CESA);
+module_param_named(allhwsupport, allhwsupport, int, 0444);
+MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the mv_cesa driver)");
+
 struct mv_cesa_dev *cesa_dev;
 
 static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
-- 
1.9.1
