Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D5CC35673
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 20:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E22A1208C4
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 20:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="UdXKmzUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgBVUBL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Feb 2020 15:01:11 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:13526 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgBVUBL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Feb 2020 15:01:11 -0500
Date:   Sat, 22 Feb 2020 20:00:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1582401668;
        bh=9QTCFtpYa096BcF+fNJ+hFEpUdDElt7IQEIk4DEbu8Q=;
        h=Date:To:From:Cc:Reply-To:Subject:Feedback-ID:From;
        b=UdXKmzUu7Gi5seNkwIDeLnuW+YM0twYXl5lC4KsTW2NdfsR/GKPL61yxUPlMHnvaO
         /k2uDlMfAaUmVWjahNU81RmYhYo/u0YVf6HavZMoh4QI3Uw15U3nVqedWKwqidDfm4
         jmA98Tq5/2163O55NCtKoeFvTuS9RIaBYsksRTEE=
To:     devicetree@vger.kernel.org
From:   =?UTF-8?Q?N=C3=ADcolas_F=2E_R=2E_A=2E_Prado?= 
        <nfraprado@protonmail.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org
Reply-To: =?UTF-8?Q?N=C3=ADcolas_F=2E_R=2E_A=2E_Prado?= 
          <nfraprado@protonmail.com>
Subject: [PATCH v2] dt-bindings: rng: Convert BCM2835 to DT schema
Message-ID: <20200222200037.3203931-1-nfraprado@protonmail.com>
Feedback-ID: cwTKJQq-dqva77NrgNeIaWzOvcDQqfI9VSy7DoyJdvgY6-nEE7fD-E-3GiKFHexW4OBWbzutmMZN6q4SflMDRw==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert BCM2835/6368 Random number generator bindings to DT schema.

Signed-off-by: N=C3=ADcolas F. R. A. Prado <nfraprado@protonmail.com>
---

Changes in v2:
- Remove description for common properties
- Drop label from example

This patch was tested with:
make ARCH=3Darm dt_binding_check
make ARCH=3Darm DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/rng/brc=
m,bcm2835.yaml dtbs_check

Thanks,
N=C3=ADcolas

 .../devicetree/bindings/rng/brcm,bcm2835.txt  | 40 -------------
 .../devicetree/bindings/rng/brcm,bcm2835.yaml | 59 +++++++++++++++++++
 2 files changed, 59 insertions(+), 40 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Docum=
entation/devicetree/bindings/rng/brcm,bcm2835.txt
deleted file mode 100644
index aaac7975f61c..000000000000
--- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-BCM2835/6368 Random number generator
-
-Required properties:
-
-- compatible : should be one of
-=09"brcm,bcm2835-rng"
-=09"brcm,bcm-nsp-rng"
-=09"brcm,bcm5301x-rng" or
-=09"brcm,bcm6368-rng"
-- reg : Specifies base physical address and size of the registers.
-
-Optional properties:
-
-- clocks : phandle to clock-controller plus clock-specifier pair
-- clock-names : "ipsec" as a clock name
-
-Optional properties:
-
-- interrupts: specify the interrupt for the RNG block
-
-Example:
-
-rng {
-=09compatible =3D "brcm,bcm2835-rng";
-=09reg =3D <0x7e104000 0x10>;
-=09interrupts =3D <2 29>;
-};
-
-rng@18033000 {
-=09compatible =3D "brcm,bcm-nsp-rng";
-=09reg =3D <0x18033000 0x14>;
-};
-
-random: rng@10004180 {
-=09compatible =3D "brcm,bcm6368-rng";
-=09reg =3D <0x10004180 0x14>;
-
-=09clocks =3D <&periph_clk 18>;
-=09clock-names =3D "ipsec";
-};
diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Docu=
mentation/devicetree/bindings/rng/brcm,bcm2835.yaml
new file mode 100644
index 000000000000..42d9a38e4e1a
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/brcm,bcm2835.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: BCM2835/6368 Random number generator
+
+maintainers:
+  - Stefan Wahren <stefan.wahren@i2se.com>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Herbert Xu <herbert@gondor.apana.org.au>
+
+properties:
+  compatible:
+    enum:
+      - brcm,bcm2835-rng
+      - brcm,bcm-nsp-rng
+      - brcm,bcm5301x-rng
+      - brcm,bcm6368-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: ipsec
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    rng {
+        compatible =3D "brcm,bcm2835-rng";
+        reg =3D <0x7e104000 0x10>;
+        interrupts =3D <2 29>;
+    };
+
+  - |
+    rng@18033000 {
+        compatible =3D "brcm,bcm-nsp-rng";
+        reg =3D <0x18033000 0x14>;
+    };
+
+  - |
+    rng@10004180 {
+        compatible =3D "brcm,bcm6368-rng";
+        reg =3D <0x10004180 0x14>;
+
+        clocks =3D <&periph_clk 18>;
+        clock-names =3D "ipsec";
+    };
--=20
2.25.0


