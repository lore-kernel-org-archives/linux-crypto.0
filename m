Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBA0C4167B
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 16:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiLaQZi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 11:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiLaQZf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 11:25:35 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E255B631E
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 08:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672503933; bh=qhP4xagevY2rvdNlq0yus5MslI8QTd0WduUXHJHOFhE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ktKgYRqDhg0SHr2W4iCxovReqh54Cotq/CnzD7LAhGGpdC8d6JEW5UTok6e3NgnBG
         qIvEY8OHyHYU6gXaQ3hBm5MhHKychIpfOyr1Hd3hWvpP5XOTf1zRZ56WKubpFz5BBm
         zt4AplJeB0LbcpjArHjoARfkNX71xrWCxCeeNdyRtJucq9+nf6DH02m1sJxItmt0To
         4nyNOHRkB5nM9bgTLHHi5o8eASrrSNOjmMn/Bl9fmIJembg/gVtY7hIFEA23yACL6e
         3qA11qdwvWENWK6S9ncCkI5easxl7GZzczmBU/yY6cLzd6sMmDjpBf+si2EXXAj+m9
         XnuzyC0h2LIvQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N17YY-1oo30L0v4E-012VUb; Sat, 31
 Dec 2022 17:25:33 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v3 6/6] crypto/realtek: add devicetree documentation
Date:   Sat, 31 Dec 2022 17:25:25 +0100
Message-Id: <20221231162525.416709-7-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221231162525.416709-1-markus.stockhausen@gmx.de>
References: <20221231162525.416709-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ripQ/mr3RH131cOE+oDKcEk292k6IVc7I5tKt0s2AZo5cPuJkMO
 edWTGoUeFcfqelS3aF4FrQobkJ/VpOiqgdLy84uDrc7e2d1/J3StId0gd5LTZioWscnjKg9
 rpQ/D5iBs81eBCLTlEJLOEMI/9vQSamAqbAv+Vd98H1WRGSV9GpW1FSlZmFFsE9gimzYKl+
 N1vsukKsXZ0wgtnshdW4A==
UI-OutboundReport: notjunk:1;M01:P0:U5b3XbdMwGI=;wRQXJQllBnCU2cS5ch94o15IXuU
 CschzKoauy6nR5lUJkdtmVzAo6EP0NNv9f0EzL4+HeN1z779hvfe3AHR/kOM3RTEljGo0aeog
 PF3jSnmaJ1B+swXvz1UQlvIIsWcmuQjTTESKKcXrB8gM6394zd3Wu2TZBjqaym/UM9IL5+XfZ
 sof6n6Wj6qRKTVzmOADWXwe08wkUy6NcbJHPCk8TejGAJoA6R+DXKQrXBYcNw1Kn4bZbKiZux
 P9hGHoZmfDyfCX9K0O54dPGlmmWtQIqFVWNC+UO83dnG3/CI58CcB7CNNbrb3iVMZSfLeIVM1
 EbaICCZsgX72Iq3N5Sr0RCunMFuzpkHa4O4IGNjtfWERQ9RYFqkZxr1XWarqK+vFqxPrinxgJ
 2KVEWSsEE4gLsRf3zPmc7C3/1Cg7l8rvrBcVWZ/odlFWO9A8uEzRInOMwoP28IPAh7pJC2ur0
 dcM6lRwDMsfsRCdPEpYU0RHPBJXh4dKacZVnIERmzByfHNIeF8qrve7pKzKHkGmuzOM4RNIsO
 h/FgHlqI6DrTRD0Gc33LaVkB3aNJDS5tRGHb45XrIEQfTFVOLWSRMUBfTCoWIpCqGUys6LKwr
 8kZAWv+SDkKCogR8CBp4+dc6ojnoQAK3FxOmLLUwucZzDRuv4IW5JZ5EG4e5XC3LcmyU6zO9A
 m3ivzMUj/MiiWTMiKeOjhYZKDBhesahYXdylfh+gXBfFM6BFmas4nMC99UqUFljwoWWLt7Po4
 I8+VZtERI5upp9ZRsLAYVoLaMgxPcB8JRjFeTWAAbIJO79t6RuTSMmQNNec2EapXSGGRCU8U+
 CjHYRenc2N5EkQePJbVT/gbzl3m1fwnjRXThrAV5MTsRP5XEMcBIA+a97ME2Y9GSnffqsBI0T
 f10GUSKTQOlu60hbDOsNJ41Ls8I/wufX446S40QFsQFI2P7770f3tiBKG6qdYGUV1hRZ2CuCe
 Su0YZA==
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

