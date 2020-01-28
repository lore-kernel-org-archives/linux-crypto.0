Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE2FC33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 095FC24681
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="lkxMWKhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgA1GTT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 01:19:19 -0500
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:39953
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgA1GTT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 01:19:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Smo2WTYllZDiyBA6Ut2WyVX/W3WumpvBm4pB8GBjxmCy+jz0SINxHy/U4mYCTInqf/2tmaje8naoLzEzWPTXGL0+p14H97mWg/saEZiLKZMIeAPZm3c2DyMf37lyOciV2Nhp84D+zaXj4/h3TGRkSlwxpRt4mzoQ4Etay07xaXyPF3MKt4sGXa2Ehm0xNZyxV246OgV1OBav8V1yJy16KGEAj4ApxKSG5FsrApZsjjSMv8FKdONo4aFln6ua9Hdk21EPgQmE0iiASpeK/jypAHSDAY19ZznGRUi0oGDkUsa3334XdFOavCUD+kLm8ZvkOgFP3PrzoIeoEfQBWScV9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqOP/WPrORmvvQYN10IxFL0fblby8/ItvVQYGRTMke4=;
 b=MASTin+ejBephauHU6c51bT8N9lBNecmVM5gWgFulMk8Ta5bfW7SzR3x/Nc8RCWkDo+koZS1jEF0EfslJ0HffrTmhNeHkzPZgSqFXDcMTPO/Et+j2hY+Usp+NZv6ryJkoJ7+VVHvoPnV+RsO2UsoHoDGnd++LWrQSzMEQNDHCkd7mo0uPXEQ8SkZgYO6zJQdCgk5eYO3U04cS4At/c1lQz6B6WH2kfjtFymRNUOnTM6RVrOSGYaiOnKE0F2TNX5rqq91RHLe5UYDFqQ3Ki1rOmrtYLTI86ImdSxcLBLWsuS936O2ouYedwjVZzb3iacJHhEXuxiqjejMEHcUai4sGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqOP/WPrORmvvQYN10IxFL0fblby8/ItvVQYGRTMke4=;
 b=lkxMWKhGBiYMYVold5RDkA1IBgC+w22m8FeUCYMuqLFU/eBsB6x7onR/14zX976mvbmjAZfFIm4lpKOOsOHyX6/a471ciMEF+FpPXDyMWqpxUS6EDy0GUV+ifFiW0pk/ItV5c2gzKQ/iJkrJ3xQ5Rkj55FtXXa/STF0hQBYY83c=
Received: from BYAPR02CA0046.namprd02.prod.outlook.com (2603:10b6:a03:54::23)
 by MN2PR02MB5886.namprd02.prod.outlook.com (2603:10b6:208:110::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.23; Tue, 28 Jan
 2020 06:19:14 +0000
Received: from BL2NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by BYAPR02CA0046.outlook.office365.com
 (2603:10b6:a03:54::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.17 via Frontend
 Transport; Tue, 28 Jan 2020 06:19:14 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT015.mail.protection.outlook.com (10.152.77.167) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Tue, 28 Jan 2020 06:19:13 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKDR-0005Kg-5Q; Mon, 27 Jan 2020 22:19:13 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKDM-0000mZ-1Q; Mon, 27 Jan 2020 22:19:08 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00S6J0Ot018171;
        Mon, 27 Jan 2020 22:19:00 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iwKDE-0000i8-1p; Mon, 27 Jan 2020 22:19:00 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 65184800E3; Tue, 28 Jan 2020 11:48:32 +0530 (IST)
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
Subject: [PATCH V6 2/4] dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
Date:   Tue, 28 Jan 2020 11:48:26 +0530
Message-Id: <1580192308-10952-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
References: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(199004)(189003)(8936002)(5660300002)(70586007)(6266002)(70206006)(107886003)(8676002)(81156014)(36756003)(81166006)(26005)(186003)(44832011)(336012)(356004)(2616005)(426003)(6666004)(42186006)(4326008)(316002)(54906003)(966005)(2906002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB5886;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14eb475f-1521-4ee7-9b57-08d7a3b9ff02
X-MS-TrafficTypeDiagnostic: MN2PR02MB5886:
X-Microsoft-Antispam-PRVS: <MN2PR02MB5886DD3C004463C4EA57FB39AF0A0@MN2PR02MB5886.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 029651C7A1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqc1RqVdux9ynlo2Wusx5CEbBLE9Drt8qiwlrWqZEN0QpUMU70E2x25EF9K1JJV+dRACR/NcsCcsydIj+JYNXJFcgW9t/cu82u2BJDbt06gLeRdpBnnSoAkFCkdyQWeoTIL03fjWmSYToFs45Upei1kq6zQLDWWnQIBaD+hzD48aIgt+GJCcSG55R8dBKfSDIO2eya0it7Ou+m7yfM8tUekBuglUJbFV1yq8oI9EZwRzFbZ4rL17CxYgU+BFj/dGseS7ojtoZgyqIlB5o74LZW3Jdp7yP/T/Dv5d8fl/JHiHDaksSE742psuDdocOQncP42Fkm5v3tydeOKDPNULj7xmcBqZifzMF1IKd+zkeCCYj/oq3lJhuhWFxPE20kJ2m0VTygnFw6KNsDh/JydugRCPqDkZ1slWbN2LA2fubUTH1jGYWw4IdOFcADqvXMwFDq/GiieYW/s+rOq1JejrMLGGddlPpKFtrFNPdQA4n57Ng/Qgr461Jfgkx1da8FC/GeenZGGjqbQq6/2oYZRc7Q==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2020 06:19:13.7091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14eb475f-1521-4ee7-9b57-08d7a3b9ff02
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB5886
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add documentation to describe Xilinx ZynqMP AES-GCM driver bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---

V6 Changes:
- Updated SPDX-License-Identifier.

V5 Changes:
- Moved dt-bindings patch from 1/4 to 2/4
- Converted dt-bindings from .txt to .yaml format.

 .../bindings/crypto/xlnx,zynqmp-aes.yaml           | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
new file mode 100644
index 0000000..55dd6e3
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
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

