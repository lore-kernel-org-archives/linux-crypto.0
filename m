From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v3 3/3] MAINTAINERS: add a maintainer for the Inside Secure crypto driver
Date: Mon, 24 Apr 2017 09:54:07 +0200
Message-ID: <20170424075407.19730-4-antoine.tenart@free-electrons.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:48564 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166315AbdDXHyW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 03:54:22 -0400
In-Reply-To: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
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
index c265a5fe4848..7240b9bca638 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6487,6 +6487,12 @@ F:	Documentation/input/multi-touch-protocol.txt
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
2.11.0
