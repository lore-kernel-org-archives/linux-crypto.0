Return-Path: <SRS0=KYvO=NY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50294 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbeKMTio (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Nov 2018 14:38:44 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>
Cc: Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: ccree: add co-maintainer
Date: Tue, 13 Nov 2018 09:40:37 +0000
Message-Id: <1542102039-22256-4-git-send-email-gilad@benyossef.com>
In-Reply-To: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Yael Chemla as co-maintainer of Arm TrustZone CryptoCell REE
driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f485597..ab42acb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3388,6 +3388,7 @@ F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
 CCREE ARM TRUSTZONE CRYPTOCELL REE DRIVER
+M:	Yael Chemla <yael.chemla@foss.arm.com>
 M:	Gilad Ben-Yossef <gilad@benyossef.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
-- 
2.7.4
