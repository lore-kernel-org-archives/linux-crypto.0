Return-Path: <SRS0=0npx=CW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E507C43461
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Sep 2020 16:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 564FF221EB
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Sep 2020 16:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgIMQLP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Sep 2020 12:11:15 -0400
Received: from out29-76.mail.aliyun.com ([115.124.29.76]:45972 "EHLO
        out29-76.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgIMQLJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Sep 2020 12:11:09 -0400
X-Alimail-AntiSpam: AC=SUSPECT;BC=0.5951735|-1;BR=01201311R201b1;CH=blue;DM=|SUSPECT|false|;DS=CONTINUE|ham_system_inform|0.0217601-0.00197904-0.976261;FP=0|0|0|0|0|-1|-1|-1;HT=e01a16378;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=25;RT=25;SR=0;TI=SMTPD_---.IWac2C6_1600013452;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.IWac2C6_1600013452)
          by smtp.aliyun-inc.com(10.147.41.187);
          Mon, 14 Sep 2020 00:11:00 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     arnd@arndb.de, gregkh@linuxfoundation.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, hadar.gat@arm.com,
        geert+renesas@glider.be, krzk@kernel.org, wahrenst@gmx.net,
        masahiroy@kernel.org, tmaimon77@gmail.com, rdunlap@infradead.org,
        qianweili@huawei.com, daniel.thompson@linaro.org,
        xuzaibo@huawei.com, olivier.sobrie@silexinsight.com,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, yanfei.li@ingenic.com,
        sernia.zhou@foxmail.com, zhenwenjin@gmail.com
Subject: [PATCH 1/2] dt-bindings: RNG: Add Ingenic TRNG bindings.
Date:   Mon, 14 Sep 2020 00:10:20 +0800
Message-Id: <20200913161021.120226-2-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200913161021.120226-1-zhouyanjie@wanyeetech.com>
References: <20200913161021.120226-1-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the TRNG bindings for the X1830 SoC from Ingenic.

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---
 .../devicetree/bindings/rng/ingenic,trng.yaml      | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,trng.yaml

diff --git a/Documentation/devicetree/bindings/rng/ingenic,trng.yaml b/Documentation/devicetree/bindings/rng/ingenic,trng.yaml
new file mode 100644
index 000000000000..808f247c8421
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/ingenic,trng.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/ingenic,trng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bindings for DTRNG in Ingenic SoCs
+
+maintainers:
+  - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
+
+description:
+  The True Random Number Generator in Ingenic SoCs.
+
+properties:
+  compatible:
+    enum:
+      - ingenic,x1830-dtrng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/x1830-cgu.h>
+
+    dtrng: trng@10072000 {
+        compatible = "ingenic,x1830-dtrng";
+        reg = <0x10072000 0xc>;
+
+        clocks = <&cgu X1830_CLK_DTRNG>;
+    };
+...
-- 
2.11.0

