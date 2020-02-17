Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9DCC35254
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9724724125
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="B38SOaYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgBQK1d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:27:33 -0500
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:6025
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728956AbgBQK1c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 05:27:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLW32+tltBeE5w1lmG1AftIITIxc4B+Qz+3S2Tq+oA7MxKopX7/bljlC/8UGj9ZwiX7BdRoIBuctSMfOI251Yw0WthaVFRIBhSji3s862URACSChigorsGMQM7wbX/kbHrMKwHQA3GjxW5Bl1Xs0C6TDZZ2AwDm3L5DxRStUVKdy7qt4X1a+c/4RE1wnmuzAZ1NteuuK+ggu9d1F6pa08IR2g61nnRPbci5Z4ONeMPbP6OaY/C9q3H8ByvTNYCg1B9ubnUxlONuy67VuOt/PblcN6lD2VZWMwYM0dOi7ixu3WkzlchTpmp+QlulcqWx3dEEM0QywUe3IBjYK7IsLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqOP/WPrORmvvQYN10IxFL0fblby8/ItvVQYGRTMke4=;
 b=h4QzFDN4gKSI8L/JHx7ddmB+8jif/abgeriWTH8G2UOBbul2x9rDxnLSR03CMiYtFGdCz9dPcI05bZ+5NRrFVdCYsPJK2vEiN7fVAwlq2jW43WRJd9K9Rvysb95ZQcg5w9dYNb7ddoxQC8ci0eCsmeWtQ8UxlvoqN2vpZNYSEJ6K5b0PBOXWW5cCHY9qFk9/e8AFayEmIyjWVYpHob/D/AIkIHKzEm1Wb+0Yj/O3Xm6ZnGQHlsIJGF+M0y/rSFl7eVgYvo+wka0pTm8UoZ1BpYHR+zfMIcrSPX+rWDZX+PmA+xBxXZr3pfnNx8xHrI36IXJMFm5JHFmZEG+ySu+IwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqOP/WPrORmvvQYN10IxFL0fblby8/ItvVQYGRTMke4=;
 b=B38SOaYvEjD7I0xACL6ZocgcMSfcowyEBN6TZMVq1IZL9tm6D0LGVB3xMJVLkcIBiThFM+xpmKRcZMFBA2vqrIAs9ARdfWuVcCPZ1gcISfh7oUypsxKvXRJcsOG/Dwjk8ZnqPycwyogVHoQb3zEyt1OlZXe2UrlYqYI/0KRLc4M=
Received: from BL0PR02CA0011.namprd02.prod.outlook.com (2603:10b6:207:3c::24)
 by DM6PR02MB5947.namprd02.prod.outlook.com (2603:10b6:5:17c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23; Mon, 17 Feb
 2020 10:27:29 +0000
Received: from SN1NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BL0PR02CA0011.outlook.office365.com
 (2603:10b6:207:3c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend
 Transport; Mon, 17 Feb 2020 10:27:29 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT021.mail.protection.outlook.com (10.152.72.144) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2729.22
 via Frontend Transport; Mon, 17 Feb 2020 10:27:29 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dcf-0007nf-6n; Mon, 17 Feb 2020 02:27:29 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dca-00031i-3k; Mon, 17 Feb 2020 02:27:24 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 01HARD69000732;
        Mon, 17 Feb 2020 02:27:13 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1j3dcP-00030F-0j; Mon, 17 Feb 2020 02:27:13 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 1B609800C9; Mon, 17 Feb 2020 15:56:46 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, monstr@seznam.cz,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        git-dev@xilinx.com,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V7 2/4] dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
Date:   Mon, 17 Feb 2020 15:56:42 +0530
Message-Id: <1581935204-25673-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
References: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(346002)(39860400002)(199004)(189003)(81156014)(8936002)(81166006)(44832011)(8676002)(6266002)(966005)(4326008)(6666004)(356004)(107886003)(478600001)(2616005)(36756003)(70586007)(426003)(2906002)(5660300002)(336012)(42186006)(70206006)(186003)(26005)(54906003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB5947;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50ded809-def7-40bb-c13b-08d7b393fddd
X-MS-TrafficTypeDiagnostic: DM6PR02MB5947:
X-Microsoft-Antispam-PRVS: <DM6PR02MB594748BAD3649549BFCFCB63AF160@DM6PR02MB5947.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 0316567485
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJleQeRM3tkKWNAVVwMcJFUbaRBk6+8H9LQURunLybRKX1xVtzW/eAwDLUEOroajIrpdm9JYqCiLjbNUloUe3LnI1mTSe+M4UWlrHodfTZMvpd4l/jITVRTNuSBq5mfYR8MwiWZr5IDOyG0AmjoK0fBzMrCYI7vBcp5vJw2ZDeDjgDD4aZEey5QI7nJokYY6Av0vAInZMrCbJimJo68HllSXhanH+Zm4iuOGb02c53M8K9TTz9houBDle6nQWBKw++4rFtMSSZ8nYBpsQ1/hOCDHqvXAQR6eOiq/0qfpd7A+1oe9ZDrpg3JyZQ4ScbegchCfGK+6KCciVD2URHQ/Ph9R6G1MX5G/2O7Ig7hUmWLnrDaLbGL7mx7DeSVueimXdgiftrvo+8cPdwJc/+gSjNYG3HZ0g122a2iQO8zvBD6rnPnS6oP8Sc5bqs7z+JkdErDV7/pD/DJaMg8x68aUnzVQE0JH0YhOMhAQyYa24q5kRtKd49huga/+MGiXos14aB/4Vyzwz6Gj+E+JiNq9aA==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 10:27:29.5826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ded809-def7-40bb-c13b-08d7b393fddd
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5947
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

