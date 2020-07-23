Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9418C433E5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 06:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A17206C1
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 06:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgGWGZV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 02:25:21 -0400
Received: from out29-3.mail.aliyun.com ([115.124.29.3]:33419 "EHLO
        out29-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgGWGZV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 02:25:21 -0400
X-Alimail-AntiSpam: AC=SUSPECT;BC=0.6009111|-1;BR=01201311R141b1;CH=blue;DM=|SUSPECT|false|;DS=CONTINUE|ham_system_inform|0.00674285-0.000426882-0.99283;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03307;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=22;RT=22;SR=0;TI=SMTPD_---.I6H7HEV_1595485508;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.I6H7HEV_1595485508)
          by smtp.aliyun-inc.com(10.147.40.7);
          Thu, 23 Jul 2020 14:25:16 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     arnd@arndb.de, gregkh@linuxfoundation.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, hadar.gat@arm.com,
        prasannatsmkumar@gmail.com, krzk@kernel.org, masahiroy@kernel.org,
        rdunlap@infradead.org, xuzaibo@huawei.com,
        daniel.thompson@linaro.org, tmaimon77@gmail.com,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, yanfei.li@ingenic.com,
        sernia.zhou@foxmail.com, zhenwenjin@gmail.com
Subject: [PATCH v2 1/2] dt-bindings: RNG: Add Ingenic RNG bindings.
Date:   Thu, 23 Jul 2020 14:24:45 +0800
Message-Id: <20200723062446.84013-2-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200723062446.84013-1-zhouyanjie@wanyeetech.com>
References: <20200723062446.84013-1-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the RNG bindings for the JZ4780 SoC and
the X1000 SoC from Ingenic.

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---

Notes:
    v1->v2:
    No change.

 .../devicetree/bindings/rng/ingenic,rng.yaml       | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/ingenic,rng.yaml b/Documentation/devicetree/bindings/rng/ingenic,rng.yaml
new file mode 100644
index 000000000000..b2e4a6a7f93a
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ingenic,rng.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/ingenic,rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bindings for RNG in Ingenic SoCs
+
+maintainers:
+  - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
+
+description:
+  The Random Number Generator in Ingenic SoCs.
+
+properties:
+  compatible:
+    enum:
+      - ingenic,jz4780-rng
+      - ingenic,x1000-rng
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    rng: rng@d8 {
+        compatible = "ingenic,jz4780-rng";
+        reg = <0xd8 0x8>;
+    };
+...
-- 
2.11.0

