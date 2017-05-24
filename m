From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v6 5/5] MAINTAINERS: add a maintainer for the Inside Secure crypto driver
Date: Wed, 24 May 2017 16:10:35 +0200
Message-ID: <20170524141035.21031-6-antoine.tenart@free-electrons.com>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41745 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940373AbdEXOLE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 10:11:04 -0400
In-Reply-To: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A new cryptographic engine driver was added in
drivers/crypto/inside-secure. Add myself as a maintainer for this
driver.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f7d568b8f133..1f2017604f16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6602,6 +6602,12 @@ F:	Documentation/input/multi-touch-protocol.rst
 F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
 
+INSIDE SECURE CRYPTO DRIVER
+M:	Antoine Tenart <antoine.tenart@free-electrons.com>
+F:	drivers/crypto/inside-secure/
+S:	Maintained
+L:	linux-crypto@vger.kernel.org
+
 INTEL ASoC BDW/HSW DRIVERS
 M:	Jie Yang <yang.jie@linux.intel.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
2.9.4
