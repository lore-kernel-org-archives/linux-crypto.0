Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6AFC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E9B61040
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhJYJ4p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Oct 2021 05:56:45 -0400
Received: from pv50p00im-ztdg10021101.me.com ([17.58.6.44]:59045 "EHLO
        pv50p00im-ztdg10021101.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhJYJ4o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Oct 2021 05:56:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2021 05:56:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1635155264;
        bh=G+FOxiIgoU4RLIEAMKdN/+O3vHCLg2/M7+D9hk1Wxgc=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=zhWyf9HFsJHQ9qBU5yxf5ue/U4+9wtwiN4YIjUubaLDCQrn5S/30DXXeTGr8f3EKo
         uTto5tQr1raMVEFrLERR3NEUDBc9szTe0zng8jQoMxrYPcM2OtSaEPQ3P3+ls38qLw
         CML3mSAKLahBjjL3PQpGr/8bEmovTSiqQ8ZcZdl3TXsQixOVqtdTrKJBwMvGPh6aJp
         vpQqwT56d/dX+XubQyfyBT5X5NqdJ3NK3Dx5X7pjtWgSUzLUHIrTa1HuJKp9+0KRAO
         la93ONjCMpecCmF+Q0k8tK2FY5H0wDfyzh0WGTHdR98kZV0MzgNBlDt7eeX6cIOpmh
         hScs4qH/JP3IA==
Received: from debian.lan (unknown [171.214.215.34])
        by pv50p00im-ztdg10021101.me.com (Postfix) with ESMTPSA id 4C634180545;
        Mon, 25 Oct 2021 09:47:42 +0000 (UTC)
From:   Richard van Schagen <vschagen@icloud.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com
Cc:     linux-crypto@vger.kernel.org,
        Richard van Schagen <vschagen@icloud.com>
Subject: [PATCH 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto engine
Date:   Mon, 25 Oct 2021 17:47:24 +0800
Message-Id: <20211025094725.2282336-2-vschagen@icloud.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025094725.2282336-1-vschagen@icloud.com>
References: <20211025094725.2282336-1-vschagen@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-10-25_03:2021-10-25,2021-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2110250060
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add bindings for the Mediatek EIP-93 crypto engine.

Signed-off-by: Richard van Schagen <vschagen@icloud.com>
---
 .../bindings/crypto/mediatek, mtk-eip93.yaml  | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek, mtk-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/mediatek, mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek, mtk-eip93.yaml
new file mode 100644
index 0000000000..6116599404
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/mediatek, mtk-eip93.yaml	
@@ -0,0 +1,41 @@
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
+    crypto: crypto@1e004000 {
+         compatible = "mediatek,mtk-eip93";
+         reg = <0x1e004000 0x1000>;
+         interrupt-parent = <&gic>;
+         interrupts = <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.30.2

