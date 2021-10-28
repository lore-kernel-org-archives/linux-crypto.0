Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E341DC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 01:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C385A611C1
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 01:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhJ1CAo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 22:00:44 -0400
Received: from pv50p00im-hyfv10011601.me.com ([17.58.6.43]:53527 "EHLO
        pv50p00im-hyfv10011601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhJ1CAn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 22:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1635386296;
        bh=eoowPApjQTt3Fpvb/HtK5vM7m3kPohFGnJyf66uzQwQ=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=RSDNbGM1CBAe8uWDfqDH0JyixQfcMLznTZBWu4KkTHmSlRLXIgyb1E0E7LWT2n6TY
         DeASaEA72wSLip2eUsZexlMkDpmKg6i//7x3kUSudiXJiYAbzFnBGQu2YRuwxtNMvf
         I8vcLR71cyTyFmYduYrsBKH/n6H3ETnDoSUR+pACn8om6iFpijnBzWW7c9T2C/aOvN
         gIM6jGOBe4M3NyiYQGm0FdWJ/3bIXVWNfQBngp9gje5vTzBxbc5H1GjvKcrWHx4zT+
         7h+IBSvFsOHDBVL6fOaYs95NDoMtujwHu1TGmVKatD4KSpbMBggpGFk7LDS/aevHAI
         ExFVLBV3AFHFw==
Received: from debian.lan (unknown [171.214.215.34])
        by pv50p00im-hyfv10011601.me.com (Postfix) with ESMTPSA id 5AAA2380490;
        Thu, 28 Oct 2021 01:58:14 +0000 (UTC)
From:   Richard van Schagen <vschagen@icloud.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Richard van Schagen <vschagen@icloud.com>
Subject: [PATCH v3 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto engine
Date:   Thu, 28 Oct 2021 09:58:00 +0800
Message-Id: <20211028015800.3449040-1-vschagen@icloud.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-10-27_07:2021-10-26,2021-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=838 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2110280008
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add bindings for the Mediatek EIP-93 crypto engine.

Signed-off-by: Richard van Schagen <vschagen@icloud.com>
---
Changes since V3:
 - Corrected typo
 - Removed "interrupt-parent"

Changes since V2:
 - Adding 2 missing "static" which got lost in my editing (sorry)

Changes since V1
 - Add missing #include to examples

 .../bindings/crypto/mediatek,mtk-eip93.yaml   | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
new file mode 100644
index 000000000..76f924719
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/mediatek,mtk-eip93.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Mediatek EIP93 crypto engine
+
+maintainers:
+  - Richard van Schagen <vschagen@icloud.com>
+
+properties:
+  compatible:
+    enum:
+      - mediatek,mtk-eip93
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+
+    crypto: crypto@1e004000 {
+      compatible = "mediatek,mtk-eip93";
+      reg = <0x1e004000 0x1000>;
+      interrupts = <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.30.2

