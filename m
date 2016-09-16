From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 1/8] dt-bindings: Add vendor prefix for INSIDE Secure
Date: Fri, 16 Sep 2016 12:08:49 +0200
Message-ID: <20160916100856.31727-2-romain.perier@free-electrons.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60835 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754490AbcIPKMI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 06:12:08 -0400
In-Reply-To: <20160916100856.31727-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This commits adds a vendor for the company INSIDE Secure.
See https://www.insidesecure.com, for more details.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 1992aa9..6a5e872 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -132,6 +132,7 @@ infineon Infineon Technologies
 inforce	Inforce Computing
 ingenic	Ingenic Semiconductor
 innolux	Innolux Corporation
+inside-secure	INSIDE Secure
 intel	Intel Corporation
 intercontrol	Inter Control Group
 invensense	InvenSense Inc.
-- 
2.9.3
