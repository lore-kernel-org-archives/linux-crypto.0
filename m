Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B38C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 08:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5787460F9D
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 08:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbhJ0ImU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:42:20 -0400
Received: from pv50p00im-ztdg10021801.me.com ([17.58.6.56]:48516 "EHLO
        pv50p00im-ztdg10021801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231551AbhJ0ImT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 04:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1635323994;
        bh=DEoHn8g3b1iscZQo3FM8Z9EYCUkrXa3JCiKpVhju4yw=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=TfB8zBea4BlD88UOcVggcJ9iZnnGmpvXseKGNUwt0pkys4d8OEou0XPrQQPIEYzM/
         L9rXLXO3BXe6l7xIiJyDL/mH9rN+dJBEsioh9X4peR+eNvd5GCwLshUyk4OijIR/I1
         HbSWnkPNHo5M8cEKJB7VudrhwaJLAO4BmlAV3rZH9Gl76upd2ztJ+gerREr1n4Y035
         +XdYfsQr/cUUICacBnbO8YBb03b25fxhV6ieFB8JkAvsmbNuqEKYODY7Ld66Sfz1qF
         jR9U2dANr73PxC7dv+PGD/SiKslZhdIhHkzj4hB0ZPGbEsBQrRCQsP4Odblyzl/ENb
         pRdzX/J+QHyoA==
Received: from debian.lan (dhcp-077-251-223-151.chello.nl [77.251.223.151])
        by pv50p00im-ztdg10021801.me.com (Postfix) with ESMTPSA id 7E0893605E1;
        Wed, 27 Oct 2021 08:39:49 +0000 (UTC)
From:   Richard van Schagen <vschagen@icloud.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Richard van Schagen <vschagen@icloud.com>
Subject: [PATCH v2 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto engine
Date:   Wed, 27 Oct 2021 16:39:01 +0800
Message-Id: <20211027083902.3093181-2-vschagen@icloud.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211027083902.3093181-1-vschagen@icloud.com>
References: <20211027083902.3093181-1-vschagen@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-10-27_02:2021-10-26,2021-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=621 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2110270052
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add bindings for the Mediatek EIP-93 crypto engine.

Signed-off-by: Richard van Schagen <vschagen@icloud.com>
---
Changes since V1
 - Add missing #include to examples

 .../bindings/crypto/mediatek,mtk-eip93.yaml   | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
new file mode 100644
index 000000000..422870afb
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
@@ -0,0 +1,43 @@
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
+      - mediatek, mtk-eip93
+
+  reg:
+    maxItems: 1
+
+  interrupts-parent:
+    maxItems: 1
+
+  interrupts:
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
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+
+    crypto: crypto@1e004000 {
+         compatible = "mediatek,mtk-eip93";
+         reg = <0x1e004000 0x1000>;
+         interrupt-parent = <&gic>;
+         interrupts = <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.30.2

