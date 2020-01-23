Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB909C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B789D24683
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="RBrLD8IC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgAWLMK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 06:12:10 -0500
Received: from mail-eopbgr700060.outbound.protection.outlook.com ([40.107.70.60]:61728
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgAWLMK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 06:12:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2nC5socG/fSHRNN3GTjhIfFTq673a9rAXERIYd8ReTMXal4EdkTfVW7BtM7M+L2PLyOpX5/bMWli3doF7Ie3qX3iMB1ZNcH8FT/8ez5VZBLfqloTCnPvzxZxhLLMjWPa/x0VSEvVgUR5qHmR+H/hnxW6+OFdI23NXKyKgLcPihR52c7t48ZosQh4tX1Lgq72QlS3paYTyVIKa5u+h/PADYhcXUGhlEV6G6w0km43BKouWEhyAxMTU0napfekzKw0WwJlCva2So11yQ9S6mVEn/A38jBXIF9uREyUL7eu6DumYieoNwDLeX9MKDFkKbuwSLxHxxMRo/zc3ssoN9hVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRcJGTJ7ccwuUpDdOhHh+Wa43S12x7wZsjJlbNeUdDs=;
 b=ZbVk1IvUghaAcyXz+ZD2yILDg/pdR+85rOZCJumXb2PoH+CvKKXFe8/csABMR/Raa/Ql7jQUuq8wpfGqSURXyDvyUtKyd2Ct6hREGaxn7jIaOIC/O4E6UDag/d7K4eogerRTcz0qeo6lwl7WJD2XyeLbqZ4Y2jxAbuNEDqhhWNafrtxEILH5KdNoXgXK692fX54bNZTCII0EALmrQXnVWg8eYcOtXSMvNqc4zHeaO447JBTH/wTQDghRnVFXuSgC4fU49nNWNT5AfP2T7RSRLVXqtCVRtXzFpXG5xsqbSd9epQBGGKPvreNcFG3FJiZnUEFJZDRd+eQihlaR+v3Bpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRcJGTJ7ccwuUpDdOhHh+Wa43S12x7wZsjJlbNeUdDs=;
 b=RBrLD8ICAY4G+Qf8zDirvueJucfkCrCZpeWBuUmixVkaAGucL0AqN6LbiG3/OiJtk3gQAKBkMj5iiM0awh7tvU4S4IfzPvPOR4Jr6D9FQJ5d52xtxqCnv5lkpxcS0axsLBtPNyNVe99hI1ZeOgxsyTUXNi7kY5wfyB3ezmUzSO8=
Received: from BN7PR02CA0004.namprd02.prod.outlook.com (2603:10b6:408:20::17)
 by BN6PR02MB2418.namprd02.prod.outlook.com (2603:10b6:404:54::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.23; Thu, 23 Jan
 2020 11:12:06 +0000
Received: from BL2NAM02FT029.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by BN7PR02CA0004.outlook.office365.com
 (2603:10b6:408:20::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.21 via Frontend
 Transport; Thu, 23 Jan 2020 11:12:05 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT029.mail.protection.outlook.com (10.152.77.100) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 11:12:03 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaP4-0007hX-R8; Thu, 23 Jan 2020 03:12:02 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaOz-0007VJ-NY; Thu, 23 Jan 2020 03:11:57 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iuaOv-0007Ua-3L; Thu, 23 Jan 2020 03:11:53 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 1381C800C0; Thu, 23 Jan 2020 16:41:26 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, monstr@seznam.cz,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev <git-dev@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V5 2/4] dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
Date:   Thu, 23 Jan 2020 16:41:15 +0530
Message-Id: <1579777877-10553-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
References: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(199004)(189003)(107886003)(6666004)(6266002)(44832011)(186003)(356004)(8936002)(81156014)(81166006)(336012)(26005)(36756003)(426003)(2906002)(4326008)(8676002)(2616005)(54906003)(70206006)(42186006)(5660300002)(70586007)(478600001)(316002)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2418;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22fc142f-4c69-4a51-c64c-08d79ff51389
X-MS-TrafficTypeDiagnostic: BN6PR02MB2418:
X-Microsoft-Antispam-PRVS: <BN6PR02MB24180B4230564BA38FC763ECAF0F0@BN6PR02MB2418.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0n9q+SBgnD8ETf5IAGijQUTx82NE2FGufVmULGimUI5FHlV9qslzNx5iea3oqMEF+0Gn/bLnfwX9wAfR8LqXvajMfWZA14DrMSciWx1afXJixBl3xObge6Yzmbs8EhXiD3U3tSuO1c3hPowp7TIDejulk6EjDei6wDv+m0MjEWXoEj7JbUFq+QLLbgo/mqy0tuViEno2bifZoYG45dfzQDpKxA9zKEs0v7zxfQNBKA+pjMzMgpl4Y9T1KImaeUE2mH6YOi58oZsqh5O+ZWPDopN198CXFjjqLXN/vhYCArPT0NNA/di8Fjbx1SMFxUJfdIM+kLEMmd8BZk8+Bbnmns6+n3XDKcReyD36AJ4TC2UF7+aDqZdQaWUS14+OqsenNY/XCU2pKalA+0ccZivV32B5Zu4yGJw+fuywjeHZxDxVZn6b4se0G5pVepAUKDE1gAWCoLAFdmBRMG5/VPQiLwcAoxkdPr3UitQHAygLaoI=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 11:12:03.8025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fc142f-4c69-4a51-c64c-08d79ff51389
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2418
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add documentation to describe Xilinx ZynqMP AES-GCM driver bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---

V5 Changes:
- Moved dt-bindings patch from 1/4 to 2/4
- Converted dt-bindings from .txt to .yaml format.

 .../bindings/crypto/xlnx,zynqmp-aes.yaml           | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
new file mode 100644
index 0000000..b2bca4b
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/xlnx,zynqmp-aes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Xilinx ZynqMP AES-GCM Hardware Accelerator Device Tree Bindings
+
+maintainers:
+  - Kalyani Akula <kalyani.akula@xilinx.com>
+  - Michal Simek <michal.simek@xilinx.com>
+
+description: |
+  The ZynqMP AES-GCM hardened cryptographic accelerator is used to
+  encrypt or decrypt the data with provided key and initialization vector.
+
+properties:
+  compatible:
+    const: xlnx,zynqmp-aes
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    firmware {
+      zynqmp_firmware: zynqmp-firmware {
+        compatible = "xlnx,zynqmp-firmware";
+        method = "smc";
+        xlnx_aes: zynqmp-aes {
+          compatible = "xlnx,zynqmp-aes";
+        };
+      };
+    };
+...
-- 
1.9.5

