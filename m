Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0FBC43215
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9377B218A3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="c8QTc0bX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfKSGQB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:16:01 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21405 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbfKSGQB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 01:16:01 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574144065; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=jYsQ/Ang1g/QV7bYQiF7N9psKdbFqIWI67awWl7sGQ5sUVq4pFa7DdVBs7hGmwTHz8e9JwIGnhBohnjFSxDR1UAhJdYNSHDb2Ia2YFT4AI0GecIrUmMdammD0jdjZZxl9wRxcns9vxN6SauBLDF6oGV/ri8OHGCG118Q6eBq0bM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574144065; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=IPoYpGPpQsih0UlY0KIRwlvTF5g15RLNEpbWU4+o53c=; 
        b=JmauD1JpuJv5SlGgLaMJKAIZM+poM3PtTuyxq0enqgNMZ9vqofR628kLGgsi1d1uglvRid4KdT8MnM3qnUC+Fk+NxtmwOAZwI2J4YDBuF+xIwkApufX325uQPXyWx6wXTqtq9shVjmCN5eEaLZdC2SD3JPUXbQDio0XnvC45OkI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574144065;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=3354; bh=IPoYpGPpQsih0UlY0KIRwlvTF5g15RLNEpbWU4+o53c=;
        b=c8QTc0bXkXSsr9jbhaFvBMSJM+Wj9IzfOuuUVE42e+ZOLMQvBuNAoh9HZPFRWCDJ
        TqsbrWzvMm1zWpNWqV+BBEIzqdQ99LsiK26cUp88uwmOuvaiTi+4/0wADf8uFkhOGB6
        I2LtJvViCfsBkvWA7r3n/u+KFtHpDfhjYOwgCeTA=
Received: from localhost (195.173.24.136.in-addr.arpa [136.24.173.195]) by mx.zohomail.com
        with SMTPS id 1574144064042832.9788464647007; Mon, 18 Nov 2019 22:14:24 -0800 (PST)
From:   Stephen Brennan <stephen@brennan.io>
To:     stephen@brennan.io
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Message-ID: <20191119061407.69911-4-stephen@brennan.io>
Subject: [PATCH v2 3/3] ARM: dts: bcm2711: Enable HWRNG support
Date:   Mon, 18 Nov 2019 22:14:07 -0800
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119061407.69911-1-stephen@brennan.io>
References: <20191119061407.69911-1-stephen@brennan.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM2711 features a RNG200 hardware random number generator block, which is
different from the BCM283x from which it inherits. Move the rng block from
BCM283x into a separate common file, and update the rng declaration of
BCM2711.

Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
 arch/arm/boot/dts/bcm2711.dtsi        |  6 +++---
 arch/arm/boot/dts/bcm2835.dtsi        |  1 +
 arch/arm/boot/dts/bcm2836.dtsi        |  1 +
 arch/arm/boot/dts/bcm2837.dtsi        |  1 +
 arch/arm/boot/dts/bcm283x-common.dtsi | 11 +++++++++++
 arch/arm/boot/dts/bcm283x.dtsi        |  6 ------
 6 files changed, 17 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/boot/dts/bcm283x-common.dtsi

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dts=
i
index ac83dac2e6ba..4975567e948e 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -92,10 +92,10 @@ pm: watchdog@7e100000 {
 =09=09};
=20
 =09=09rng@7e104000 {
+=09=09=09compatible =3D "brcm,bcm2711-rng200";
+=09=09=09reg =3D <0x7e104000 0x28>;
 =09=09=09interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
-
-=09=09=09/* RNG is incompatible with brcm,bcm2835-rng */
-=09=09=09status =3D "disabled";
+=09=09=09status =3D "okay";
 =09=09};
=20
 =09=09uart2: serial@7e201400 {
diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dts=
i
index 53bf4579cc22..f7b2f46e307d 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "bcm283x.dtsi"
+#include "bcm283x-common.dtsi"
 #include "bcm2835-common.dtsi"
=20
 / {
diff --git a/arch/arm/boot/dts/bcm2836.dtsi b/arch/arm/boot/dts/bcm2836.dts=
i
index 82d6c4662ae4..a85374195796 100644
--- a/arch/arm/boot/dts/bcm2836.dtsi
+++ b/arch/arm/boot/dts/bcm2836.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "bcm283x.dtsi"
+#include "bcm283x-common.dtsi"
 #include "bcm2835-common.dtsi"
=20
 / {
diff --git a/arch/arm/boot/dts/bcm2837.dtsi b/arch/arm/boot/dts/bcm2837.dts=
i
index 9e95fee78e19..045d78ffea08 100644
--- a/arch/arm/boot/dts/bcm2837.dtsi
+++ b/arch/arm/boot/dts/bcm2837.dtsi
@@ -1,4 +1,5 @@
 #include "bcm283x.dtsi"
+#include "bcm283x-common.dtsi"
 #include "bcm2835-common.dtsi"
=20
 / {
diff --git a/arch/arm/boot/dts/bcm283x-common.dtsi b/arch/arm/boot/dts/bcm2=
83x-common.dtsi
new file mode 100644
index 000000000000..3c8834bee390
--- /dev/null
+++ b/arch/arm/boot/dts/bcm283x-common.dtsi
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/ {
+=09soc {
+=09=09rng@7e104000 {
+=09=09=09compatible =3D "brcm,bcm2835-rng";
+=09=09=09reg =3D <0x7e104000 0x10>;
+=09=09=09interrupts =3D <2 29>;
+=09=09};
+=09};
+};
diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dts=
i
index 3caaa57eb6c8..5219339fc27c 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -84,12 +84,6 @@ clocks: cprman@7e101000 {
 =09=09=09=09<&dsi1 0>, <&dsi1 1>, <&dsi1 2>;
 =09=09};
=20
-=09=09rng@7e104000 {
-=09=09=09compatible =3D "brcm,bcm2835-rng";
-=09=09=09reg =3D <0x7e104000 0x10>;
-=09=09=09interrupts =3D <2 29>;
-=09=09};
-
 =09=09mailbox: mailbox@7e00b880 {
 =09=09=09compatible =3D "brcm,bcm2835-mbox";
 =09=09=09reg =3D <0x7e00b880 0x40>;
--=20
2.24.0



