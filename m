Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78D4C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 18:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJMS4a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 14:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiJMSz7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 14:55:59 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452391849AC
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 11:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665687218;
        bh=+JkfL4QqEFJ8WgRQicVqobBgwB9oGVGhbb7eNfPAgYA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=J8BacS7EUKiJDLAYRXY8YLAKnBir7evSjM492PS6oyFgnPujquD05wVRnUKMxXHWi
         80XpcwJlGMDoC5VaZHoon3dFx2nG1LDorakow9S0XVRTXCiv+P9fQHYCW26rMRoBa9
         73o5jjevWBgUEFsDKBqKPIZ6baDwb1VApEn+cn/4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fedora.willemsstb.de ([94.31.86.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MAfYm-1opfuQ1LWS-00B0M1; Thu, 13
 Oct 2022 20:40:30 +0200
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH 6/6] crypto/realtek: add devicetree documentation
Date:   Thu, 13 Oct 2022 20:40:26 +0200
Message-Id: <20221013184026.63826-7-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221013184026.63826-1-markus.stockhausen@gmx.de>
References: <20221013184026.63826-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O4TFgX83LNUyGW2NkrZGyHBDDjfd5OBqwAmP4/DK2K7BhgDB2SG
 RwJbI/9gLa3dmmE5X0q09gN/nHQ8u05c8iTFn6mcIlfsFsa8x99SmKEy+S65iuRB++HIagi
 LesSSpIs67JJcGoaaSwn6Z6NHJrZ1Ymq/RsT12Uze+dth9kPNOM7Znd0RT1jsiLjqQK3caK
 3qTbYaNmadsaV6KOnDqeA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eWkWF4HUf1E=:m8UlQC4LeziGWduFXwDnYQ
 ssynfpKJs88vnp8yBfuOPl8hpkm0r+6QZ6HBAA+OpkoeSH83GCcuAvyHUo1oD78c/j/4Kt4co
 k58t4RIKhloLvGhcckYXmLB+MSCeNwdLlf2Vp/qGH153hsUcZNRjv4EMMNEzkfwxiqzVbVhtQ
 I0XFIo5D4NkJKUMqSJMOfOrjA7gCfXikLRYVD9FTIaujZBopTfKVHIPl+prIUdJzpSh4yVxba
 7KwLigh74D6jFUtCxq/3sBoljS/0pU6jqEJPq1nN7GM0EG3/ZlKltiIZ+HsZOaQ5DcXl/ifNL
 N1hjp5zdQPPEM9M5UxaiNjJSnrwUUjOqi2q+gBfiWcm+v4kxk55k5yRt4w1NNE9oWXC7Dt5B/
 7LdF5BTE2dLx2ihfeBnc0em9uGZfqdxCGf77BXKBETrBIcDzxlKa59pX/AA276iRU8h5QK18X
 O/HMnR+kXyCoNmgxfZJofYVqt0DemuslW2+lWakz2gEIAQKvlJD74Wvmf7yKEilNz3lxC1oKp
 1hvpkodD3nsKYy+ShJt6TNULeLkEPxa2KjqgMWsjbZbYaF2tnzeYVXFLAdBMNlqbhYy0Pd46U
 gfc0chRlNLw6ateqJp8rQ9KpyKuphbvO5DG//WruxQ4nUSihw6lG0ZfNqS772qvzomfMy7V20
 4hK5a4jOxTgGdusPRkknlhIPdaZgP7uZmkGzd7AuVS/KxNPBbDVsdJrk0IGnNCdwd+NFGRKm7
 yorCUbqqTncqqijbEIAlBm17TBhldbGRoeI7VzoOVJ9UReO8KRcFkA8mdyWNkkbcyjq/Eqouc
 rLIYko57LFfHKQrtlmkmRqPr/rvjPnaph2jYAJJ0z2bHnu2ET1HZeVfjM01jJcnPie69BNmY5
 dSEyKSRIplnhw408CN9siAzjmoHkFnpPp6ihUgqApFBOCAtYb03d5WMKncftusqe6RN6msBO4
 WL3S/CGhL+GIALio2PFKRqNOy5IikCV4X43VTzTQ7jXgH8wfP5AtTgspvcxOYobGN3TYqHi3w
 /VPefSlNbsHqP+TBnczc6bIOyV2WTke0pjjFU9FEj+kLgXrvj6MAQLTo2Dnt5XGer2/1U3eOy
 rAHX/zl0ZhVS9vxsKVfbMtHsSXt8wSwTePry9t9BcMHItDwSjw8Ha72yKV1YF83rsTphqDEI0
 GEVKtI8bJhY97DB9WlOjMMToWvmE2fAA5DW+scy79sT4j9jGSkOWKb2Hu39uVbQ5peIcG/S8Z
 HdjxWQkGYINhkQw5o/i8B3xDD+oXL9QpRxpekOgtnL4MV5EoFUOKKBrAd+TWrhO6cqzXT751P
 c19FgLncYA/4NF8ch5qcxYa66JW/UNdCajZrr1OIUGyFKwyhCmJ6E6tsCyn2TR9CBj/eU33rw
 9asZec4ph2Y0aNeAzxCcaXKpm5M9eFSs5dKNtlE7kCkvJvy0Q3OUzHvxkPEbrkhwnUksZrjo0
 2JsKBNrtuk2Z/2M6yfPncbQvnovAsFPnoon28qBY+nZwnbrah4wYC5JWAYBk/dObfT9Ub53Tx
 wIgz9ZBfE2jAoDV+QdGp10Nj+32JDoLXjzZKvdZY+pA+d
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
2.37.3

