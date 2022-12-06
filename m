Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2C9C63704
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 19:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLFTUu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 14:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiLFTUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 14:20:45 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F00940902
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 11:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670354441; bh=qhP4xagevY2rvdNlq0yus5MslI8QTd0WduUXHJHOFhE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=d9HPfjA6z7darC+JVcKrCwfpR1Ut9J2dMSFD3WWpfjEHMlNLxpbQWMGRkiN7CuPNm
         iJjoalBOHaEJ4APYzsKPgNbMI02K+4oRPqIQdfCs6usdMarMBLi7NiXs2/x+pSeDZ3
         JZDMrMFUVsZJWhGByvF3AZVsr8ErI0dZAT3pFHILz3Xb/FVWsPDmmYuQ/QnyHsij6v
         m5ULOJf0AT5Bx4imjwHrCXV5qbJSt+lkqaOgSOZv6/MX19h2Dyo0zYttkqDN0VW2vH
         3OE+IS3zxNibRBuWdNfdFA804NQ6lM7x5YPNCyxOhJYd1gafiSe/2t4kKWpRnV6yyw
         cEwkdo/t8oPcw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.87.22]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N3bWr-1osydu2Hyd-010bwE; Tue, 06
 Dec 2022 20:20:41 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v2 6/6] crypto/realtek: add devicetree documentation
Date:   Tue,  6 Dec 2022 20:20:37 +0100
Message-Id: <20221206192037.608808-7-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206192037.608808-1-markus.stockhausen@gmx.de>
References: <20221206192037.608808-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4ydH6bfS5gSYDeu1BxjlbMefgyBp7SJJZArYGejjm8UFrUnwCPb
 H+eyhFNjynGRi0sSK3DAIiH8+yNN6HgZ7mYpsbxPOSIpJtvWswxnLb++xSOzjc4BHYK0u09
 4H3tHAdgo62cuZC/w/T3eAKXBvLyE0aCzEeHTWoLQQHDgd/iTM/H8KV6Z0NTkhVFmOW77mN
 KqWCwyNWJNjccm3RuNDGg==
UI-OutboundReport: notjunk:1;M01:P0:IaAgWUHpmeg=;O43+V+5trkJZwHoNKFoHkild/XK
 1bPaUlfjCMf5tzOiLlRnCYcyEgZzLUvvpmm9Z0gTaAF3Xr46olcBUZH/Ih0X8xKjJ2UMLZhsx
 iV7CybLBmEuYYZ6pUbfKmSPEBNCr+6pRwrV9WvidHT0q6XFYTboCnD1+udJjkqymFzvYfFqS6
 OZwmaH8uAmaJcqwYcTygK+NAjLFeusi3D177dlVpl/RUig7lnojZ4x+RD+4d8cw3eTge2ySjv
 hfEC0JwXk/iIDEmIwkhoX7fokoAmfdW5IRzkMJ0XVx+Ym3lWLqH3+cuOAwh2qsByozibLtLP/
 m8ctZYv0OBdi0DkSBPdEnAkaw9MzuKucV+9MnFiM1FRIA1jvmeSZ6vVmQpF2qQQt2WNyEG/Lb
 G0JqDT2rHRAu2NhPxilOw63q/SMxfHOU7gJhplcsbRHHWJiKBW7f18zbvVcyj9xBbK+/4t49V
 +9F6KuCmoXocl5dSGmSQzT093DpnaNdnHC8GMu0arF3t+oJ29ysqErGyJ4QzTzbHjj7ABjjYQ
 MLM3Qt/ExkMF+ez2Qq+/KwmFZQWFXxDrPNjtEXu4RJnhlCgrJ6SsCFYSy4HTUIZ+UfMZ6hdts
 UzzvZ9RYgh+uGUpb+jlMvjb96Cj8TfR3hmoNOGNUz5AUMPCCOvE+vt1AOeISPv/RXZ1B7nrQe
 EQ80Cay2ABvUxYqwjU1swFc/d15wq7Jz7hDdjqzTZ+wM0ZS4wWGm1IOVbgilPfyAmPZp7K9xm
 ek6Zla4aQqAF7u3nbVaEPsJPeBR2n7pzDfcEt8KdmKDS49pU6MlfG2bbonUeQzXDMn/CNz/nE
 zkyonrLp3Kn1uuxmV9h6VH5MMlth0j/9MSCgshyiTmBbqULHYYZFEIMklYgkPiuS9LD25rxVi
 Nx1oRZjLQV36fg2MY827Cv5TwFUUHHNZpg9fIqg4OAFrdqBShZGSbXZ7D12gZ/X0lBifuFN3y
 k22hEw==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add devicetree documentation of new Realtek crypto device.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 .../crypto/realtek,realtek-crypto.yaml        | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/realtek,realt=
ek-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/realtek,realtek-cryp=
to.yaml b/Documentation/devicetree/bindings/crypto/realtek,realtek-crypto.=
yaml
new file mode 100644
index 000000000000..443195e2d850
=2D-- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/realtek,realtek-crypto.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/realtek,realtek-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Realtek crypto engine bindings
+
+maintainers:
+  - Markus Stockhausen <markus.stockhausen@gmx.de>
+
+description: |
+  The Realtek crypto engine provides hardware accelerated AES, SHA1 & MD5
+  algorithms. It is included in SoCs of the RTL838x series, such as RTL83=
80,
+  RTL8381, RTL8382, as well as SoCs from the RTL930x series, such as RTL9=
301,
+  RTL9302 and RTL9303.
+
+properties:
+  compatible:
+    const: realtek,realtek-crypto
+
+  reg:
+    minItems: 1
+    maxItems: 1
+
+  interrupt-parent:
+    minItems: 1
+    maxItems: 1
+
+  interrupts:
+    minItems: 1
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupt-parent
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto0: crypto@c000 {
+      compatible =3D "realtek,realtek-crypto";
+      reg =3D <0xc000 0x10>;
+      interrupt-parent =3D <&intc>;
+      interrupts =3D <22 3>;
+    };
+
+...
=2D-
2.38.1

