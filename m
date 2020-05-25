Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4F5C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9885C2070A
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="dW8kg6wb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390704AbgEYUHL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 16:07:11 -0400
Received: from mail-db5eur03hn2211.outbound.protection.outlook.com ([52.100.12.211]:3649
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388794AbgEYUHI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 16:07:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bt41si0isPbvRGp5Z7q741R0EW+KsP6/oCXZqHCC3mCraj9Cg0Vv7GwwgysBg0YLxtzl6F6v4nD/3OhPUt2c3Iu8CgG+flf6GYeEU7tLxm9+KFIQuYOTsUI5hfpvTvjh1dAobxQYkZT7gykfXzDtUB9ixRWetYh8KlDdgz7FW2hueWBXh8a0aQ1nx3kQZ/CYj8yFN0mB3geINGa8iK+VpfXCncRXtKMasfLDrYSDBrs5RksNfz7gy8amOgeUDdESHAH5nVQo7OPe7SWmwsHZGzp53kooQePQo94IFHE470LA1l6Pblrwhvc9EhGkHls7nYLWDol6hPC4Sa4d/gUB1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/p+Tj3HYIX+MEo/f4dnNeBfUAuIsaaHRHxF5hv7Rvw=;
 b=oEHOn6CDygWkcc7pZahpGjl5W8AiB9NP1/eYhrY93/TxqAerJP2D92mMGscaxCuA1w0ZF6XCcts+qWelBzYjPrEliiOIo7XrwVjuu+RqhE/FHOvbK0u+87WdROtlcVXUpYzvZjXPLqo6uxqrrylC4VP0g3+iDhEhwfZ95tvZs8XAm2hXq06Qf72wJy9xW/LSP7pnx28zSPLlThO4FE5Z0AurMduZwXAv20OPPPQcKFPib4OBMC4dJ0Wd+sujGJ4t8IvJBd4DAp3cvXQvzKl4nB3WaIjp1o0uMZI5A/3vLQTEuxybDndAkNou9eSZjF+8LqOeAHM207cbFcVJwMczXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/p+Tj3HYIX+MEo/f4dnNeBfUAuIsaaHRHxF5hv7Rvw=;
 b=dW8kg6wbm3egreBLDaLQX2Zd/m6heD2bQM9i7sWJ/04EmcDonUtIhtZih/GOD5CT0DSocbMqF8Sx0vFbs1+e3ihfGLE5uQPmiWhpUU3huMut+SjQJg1sF1n1Lj7dnXKusBbJR5+UQ/DX25saDyEjaQblo8wrw7uUDUB9/Xpobsg=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3735.eurprd09.prod.outlook.com (2603:10a6:20b:dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 20:07:00 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 20:07:00 +0000
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
        sebastien.rabou@silexinsight.com
Subject: [PATCH 2/3] dt-bindings: rng: document Silex Insight BA431 hwrng
Date:   Mon, 25 May 2020 21:56:05 +0200
Message-Id: <20200525195606.2941649-3-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0071.eurprd04.prod.outlook.com
 (2603:10a6:208:1::48) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:30f9:36cf:6713:51ae) by AM0PR04CA0071.eurprd04.prod.outlook.com (2603:10a6:208:1::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 20:06:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:30f9:36cf:6713:51ae]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d83e4426-2630-41b9-87df-08d800e72ef6
X-MS-TrafficTypeDiagnostic: AM7PR09MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB373538E27089EF8B522D04E6F4B30@AM7PR09MB3735.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3otZcwKOQORmHTSBByxdlv7WBYhu5G42PQNQb69PyRg9PfbpxRshu36cRZMVbIK0wCQ/J8hdkWeXi6w/b8cY01Tb63OCN0+m69uiBqCU3p9YeN7Idgc0BI9oqRn9DRqc2S9uuLVZ0V9UNcU4RTndn/T9QVai1nV2Im7hl1hMihwjnBzwDIe0wJOwTF9N1zLU3FV97OwN+llEpFq8++LifTFuZIdJ+3dTK9koMCeTk80f9zzmCxJhxRFJeXGLEt8ezqF5ke70lNlvr+EDckZvKe2jOX8Q8iaVP1/f1v6AnTZ4MGR+0aJ/5Whrj5thOTaY0ijh1+JLncUhrWqXksrAAmw4HukQQxD0LIhowF/OwzxrhYyqJdcz0vLGgmo70t1Tx/58wS3ZrY/yzFHxW8VFlpM/Mt5KbuzvxDE5K3FWjxyXtI0hPBhyhyxugdfETKVaNvWHrHJ2lIWxHfy8O09KgbjJd66/lh6nODdXxSxahqbQHMu5CSn5pmCr5SH4//qQ4v4CLDL+GQXzXmSVGFLMQ8YSTmRcdBywdhJ989kEvp1ZTTNWXH8obeLAxwNsLoJRRFVGNQpEd4kCggdSI+tvY9guPq5LrxpfQs+AwMndj0kL452DeplaxHxdoCYglzs2pmmkec96yN23uwF3/RQOIU29RyEnLIdFUvkxQxmpyqbudwrqYuRNvtE2V4R+0YvsjHsAx9a1CUIPq+vu1TZBqB4Gt9ux90Au7dzhtyYaMbTGp1fU8i/VE1sx67OBDow9BzHgb44lqE4oFy6bvvUkkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(396003)(39840400004)(136003)(376002)(346002)(366004)(186003)(16526019)(66556008)(52116002)(2616005)(2906002)(66476007)(6496006)(107886003)(44832011)(66946007)(54906003)(110136005)(316002)(508600001)(6486002)(8936002)(36756003)(1076003)(966005)(6666004)(4326008)(5660300002)(8676002)(86362001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: EjXN0T7KaUtzx5ROSU8tSu12KK2sFGc81OiK6taKDSBhoEVVTwhsrXvV8OrDtbEDgEgKNUjR6zpdoQPYy9nwMBwBGIrCQwHErQsGbJPOPer6QapvacGugOiBJWsZ8vlpTCMIgCBb5XiFWqav/44MjnjHOVgzSLSe/Eao/0qNUCx+MxE1YbK8LColpMvh74U+h+/pkPfFzKWNTdbzZm3+wV8oTpU/JZ70rZeDvt95vs9RmpJi0d7fsBVD2wNeNxcfq7no3QS200htT465MLGA8AxrsCZIO6zEErUVQU/lFUm2zQHCygN9HNK14gEb1yvF0gw63qVuU+wOTr12Mw3avLv76u5YqkRv1x05xHS4ywbUf2uVBk3emnkmbR9cTQZxn/2bP0TzSzEXaYxyl5711jmRSIZHOe/fMNARJv9Ein9ohG8t7OxKCfCGsxp/rENCDt7GGTfQxr5u/FTjgAnvgzD0VxN1wOQrsuKFAL26AduTnX8PNLyIHrguk9xKjRN3N2/Nelnmq2RlZ4pgL+jGHGsv8rrjGd+acVIY6MGtD5w=
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d83e4426-2630-41b9-87df-08d800e72ef6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 20:07:00.0091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLdeH4BtaaBpYovYfkBiY/Dc9I0Y119tHYpneWvC/xu9ZFgjy2hnUKyJMwG4kZ08gZssH51QQLMIa4QA+Kuv7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3735
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch documents the device tree bindings of the BA431 hardware
random number generator.

This IP is for instance present in the Viper OEM boards sold by Silex
Insight.

Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
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

