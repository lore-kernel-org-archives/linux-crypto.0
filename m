Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB5EC433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 20:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 825EC2073B
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 20:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="FYQ8DtDK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFAU2H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 16:28:07 -0400
Received: from mail-ve1eur02hn2208.outbound.protection.outlook.com ([52.100.10.208]:41954
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727096AbgFAU2H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 16:28:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ph5iWcpHNdfzwjS8HF7Wo4mFdL1HYixmd/QbKz1VBe60+zk3CM6ajTgb+0BTEfI+tnUr/I+Zg4jCkNOwEfeFo5G4mXGM0WIITh5Jb8c2s8Dzm/6X5G7QT1JIYtM6xlPqJlKb05DuGAusGpZbN2RRtQvarYdiv22wqKxOVo/egD8XiKhu0f3Meihj+pgw+SAnzbRznzo+at3AS7YQT/NfujuiwaatgvfBkywqKbKuVz6gVeDrmq1+FZLqjFA5+yzuaJo2YIf150piVJMVOO6SYmnEulgpJiizxwpqtPyZDFGHK8o2qCzkYqukrV0Az/GfkEDljEQj7H2foo+cC9ZoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI39xH1WqQQBgXgPDXQkmWYQzoXym045+XWk5We7amg=;
 b=fp8kc9AG/K7TWMYcMaByjeW/3+sJ/NcM4gUvpKdx/6Oj3es1yCgbpeYfSMm6ze89azWJ38ftAATYQWDyV9e0XaIUjnj+xRnLDR07DHIEaUCIddHdgIw0Af3Z/VUrWd5uUi+mQWTI/4vJlwmp1s8dzT2TP14U70oPrAt2EoAuzJ5kLvqUCXKT5PqSRyMXVuzRmHbBTcGIVzVSFjgtlkhlbEUyOEGWT8cwvE3yr6uUyl8mQc1JQx87G9sn7LwHr7n195ah6vKKmrDGhplgslGgYQicWEi2d8maiXXVRxCf4jpH9VT8Opv2W8497tr2yEMBuxtgyOygDH+1dLdllsv4Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI39xH1WqQQBgXgPDXQkmWYQzoXym045+XWk5We7amg=;
 b=FYQ8DtDKQHeVpSca2RqvVlwgFSnH4gZ5wVgJRVJ6SKk4Cwkd7RwnrsOK1n9CQoBquhjhcGeMbVWVJXiEsCjUcVsxfAVP/Op4FAR5y/w8/VWwivulmSMJ0Kxy36qzLjndU8sap5t8RaJlo5kcTo3/wI6YvrbhLYa6K4qZMGi2oIc=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3957.eurprd09.prod.outlook.com (2603:10a6:20b:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Mon, 1 Jun
 2020 20:28:03 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%8]) with mapi id 15.20.3045.024; Mon, 1 Jun 2020
 20:28:03 +0000
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Olivier Sobrie <olivier.sobrie@silexinsight.com>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: rng: document Silex Insight BA431 hwrng
Date:   Mon,  1 Jun 2020 16:27:39 +0200
Message-Id: <20200601142740.443548-2-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
References: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0023.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::33) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:3173:2902:9670:18b) by AM4PR0902CA0023.eurprd09.prod.outlook.com (2603:10a6:200:9b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Mon, 1 Jun 2020 20:28:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:3173:2902:9670:18b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1344dd5-bc83-4d6c-5769-08d8066a4898
X-MS-TrafficTypeDiagnostic: AM7PR09MB3957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB3957820A32E3A52A52DEDAF8F48A0@AM7PR09MB3957.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZbKt6ls/tVVKPFDcWXUEUROGfBIBx6ZQ/roeKPqprgyQLP6ommpUfCEYQsjoLueaOgAQv0fFFAAzSKySAg+M8QukOGGZQ1ARwKn5NGyU15j56pJkbaIdIiboposjY//wUun9txwozZVLjm4bnbKM6LbNCdbzEgfq+s3nQiDD09X1vhSFCBE7ODtyMq3Ze6VtDkVnHR5SHMFvBhSoxE3HRsjQNClvltYFUXs5VDYC9dRzpGD2e/qxks1Hhg5/jPYXzfeR894cr0/pypIrc3flXTXNw1aVSAEsWHq9FX4UCtPZgxwnLEh3OTwCFqzLtLGd7EbJmljmzGAeCmmlyIxVKJELcFQ7rzdKeaMwqVOD0UnrT6YIN1r5Gw1i9Zk2QbpmaG6LVYFF8damnu0xVc2ekZOgs/ZYk45gggJ/xCIJm+0RoVPgiRPNC/FD95ukEXY+EneQvRqkfrypFZVogcWjf5EcrH8ygBNZzZXZUv4W3gPPGw1yyzK3/w3MC9nCxssCXgaHWJe7WTHT31K2Cc7GkryjC/V34l031qCsaM8zDLYXbw/nQgeZvhovqcbhwg8vqa8TfCd0snfO50r8C3UO8SjSQLGor6XlWbWBcoX0bfuVYJCOPiJsfYRnFeT0Oqpu3HDBMJqZ7A8jrohTmzZgcUIxEM7JcjCcRic+x1H1gXoiaW1g7UyZusFpdlSof+GVE5WsaX3SODdnT2oEW3+en7tmKxq7GVes7zPf0MIswzL2T/3m3R2sqjeqrCOrpO+dq8tUZ7vlvCRhHpIlfJsHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(366004)(396003)(346002)(136003)(39830400003)(376002)(5660300002)(36756003)(6496006)(52116002)(66556008)(8936002)(1076003)(7416002)(86362001)(16526019)(186003)(66476007)(66946007)(2616005)(8676002)(44832011)(4326008)(508600001)(966005)(2906002)(316002)(6486002)(110136005)(54906003)(6666004)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: RlDNK9LOJUQcuoZnBElHT2Qapw2lfcpn9jbeANIKDWadpoTnUOAtGQMClTayAbAhinQzEwYnJqEuF3MOrfskrqIFGOT95DPzLTL8zmWgIWn5dQH6wozYsT/nFZl7scYDgGX9ODy5PO2jQ68kf7Vgi6l1IqOUtzSU9wEDFa1R3oqClCDrX64WGXqu4pWlUv82JtliWt77i3NAbo4dDHXnOxA1c7z+JsgiVZaflawBICb8XkiMfSeDZK+MS/TSUaMSW1dsfqM0K9AEFXBA6OgxtGMKavpFIumFtC+94XeIYzKRsRMppoP1VTaKIKk7EfaeQSpt8DlmGJun33t1+E4uY0OyOJDg3ZFZzE9iJN57pQZiqY0olPQfVl9ycSzYR4bBn+73+Oyp5sZyTzIlll1+TwFJ9/eu8uEtZ3LnedkpZcQutdY6Z55cRgf0DSNzGqoE3KTHtbzDaPdVjCHnGyj1Nc/zJAHLSKvg8O0aHR9rC71j/NDHVgz6lNb1njAeRxKHxx87L3JVmJHVFKzHkftPOFIbrCYU8jN211EhC499xGze4I9mx9l+hu1ZfbjZPS0K
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1344dd5-bc83-4d6c-5769-08d8066a4898
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 20:28:02.8910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqYzSuCYw8h4bXcw1qQQMMW/MmY8fGaX1lFiW6UF+foTiY/ya5ZqxhQkmu/77ty0Yg4jEG77h/L8xI5fOzfwEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3957
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch documents the device tree bindings of the BA431 hardware
random number generator.

This IP is for instance present in the Viper OEM boards sold by Silex
Insight.

Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/rng/silex-insight,ba431-rng.yaml | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml b/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
new file mode 100644
index 0000000000000..48ab82abf50ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/silex-insight,ba431-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Silex Insight BA431 RNG bindings
+
+description: |
+  The BA431 hardware random number generator is an IP that is FIPS-140-2/3
+  certified.
+
+maintainers:
+  - Olivier Sobrie <olivier.sobrie@silexinsight.com>
+
+properties:
+  compatible:
+    const: silex-insight,ba431-rng
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
+    rng@42800000 {
+      compatible = "silex-insight,ba431-rng";
+      reg = <0x42800000 0x1000>;
+    };
+
+...
-- 
2.26.2

