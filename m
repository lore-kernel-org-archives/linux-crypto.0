Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D29C5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1A92173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="PM0a1xz8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfKFLkv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:40:51 -0500
Received: from mail-eopbgr770044.outbound.protection.outlook.com ([40.107.77.44]:14463
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfKFLkv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 06:40:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfK4Cv29iQIElLOie5uJqWcwALsw7OjeCkFdoBRndDaaNMgnqj3v0KDz9GD/mQgmyrULGXN7RLaoF/SusTXCOWg/3b3pdzjOOjNRdMYbSdwXYQWXWvRW9oxF/84GYx9mZxtjemRgSfMbYK8ptjsEk3i79Qw8bPcoAb01almxgs08M6/srrU1IG6AyOtqg7bcLbhNhefjwNkcCqTH6Q8MF75wac45t3Rk9j4yAiOFp83jI6pkSjgDU8epbh2J6VLntoIXZrri+4FsMm5qJtfRto/YghVw0IVeFWLSRNiE2n5LgKfJDR1Ib3iW13XaO4VhsTt3/nSHeO6omQWIJ4TAKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz2gQAyyXjKJI0YHf3nIvhpy1HTmtXK4N/3r5qfyiBE=;
 b=VNVVQvw7pQuuQLiMbbXoXgG/L2Pc72ycEIAmept69jURpJik1Wu3zR1lqv0BS8wgT2UvgcL2pnWk+YPAaNcORddHoVXwmhL1EXN+Hc+FgZkr+L+ISDUfF7ex53LAae6QT3f8/ualp9q5LpEUgQ5NoNMv2iq0HdQNXCLGYF718IEQ4Kc9AXNG0ey6fUMRHoaVDbc7gYEI9Y4YjEXUjcAAyJhafjDbHHvDjfEvHDIIAvXzJbpl41wcfRx9pGGkhx18ubnx3eqA39Zj7wV/EbFefTPC56b7vjzuk02/78Joz/EwmpC2Mu9V4lju8aGNyM+DRJYQVo9Z+oYE5JSPBBujvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz2gQAyyXjKJI0YHf3nIvhpy1HTmtXK4N/3r5qfyiBE=;
 b=PM0a1xz8sIfTQYS0KUmvkUVpBpXgt0RalIgadh6AoRx4y+XwFzaYfo7vneSb6rIxrVrvppm3kb4Uf7cogWAH4i5IGFMVviYZ2sV9nLicx3LEk4HEx6i7Izrp+bCGXiS86gwGla21pqP5o+Kc5gKxzHQwErhity1D+Z4upT0TBhM=
Received: from CH2PR02CA0004.namprd02.prod.outlook.com (2603:10b6:610:4e::14)
 by DM6PR02MB6494.namprd02.prod.outlook.com (2603:10b6:5:208::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20; Wed, 6 Nov
 2019 11:40:49 +0000
Received: from SN1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by CH2PR02CA0004.outlook.office365.com
 (2603:10b6:610:4e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22 via Frontend
 Transport; Wed, 6 Nov 2019 11:40:49 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT033.mail.protection.outlook.com (10.152.72.133) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Wed, 6 Nov 2019 11:40:48 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg8-0003DO-H4; Wed, 06 Nov 2019 03:40:48 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg3-0005wm-Cf; Wed, 06 Nov 2019 03:40:43 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iSJfz-0005wG-JQ; Wed, 06 Nov 2019 03:40:39 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id CF984801D8; Wed,  6 Nov 2019 17:10:38 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V3 1/4] dt-bindings: crypto: Add bindings for ZynqMP AES driver
Date:   Wed,  6 Nov 2019 17:10:32 +0530
Message-Id: <1573040435-6932-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
References: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(199004)(189003)(54906003)(70206006)(4326008)(70586007)(5660300002)(336012)(42186006)(305945005)(478600001)(36386004)(2616005)(450100002)(50466002)(16586007)(8676002)(103686004)(107886003)(6666004)(81156014)(426003)(26005)(81166006)(356004)(446003)(11346002)(106002)(6266002)(51416003)(126002)(486006)(476003)(316002)(2906002)(8936002)(48376002)(4744005)(44832011)(186003)(76176011)(36756003)(50226002)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB6494;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b333e0c5-020d-4804-b483-08d762ae2b88
X-MS-TrafficTypeDiagnostic: DM6PR02MB6494:
X-Microsoft-Antispam-PRVS: <DM6PR02MB6494ED34EF2F27A7DADA2014AF790@DM6PR02MB6494.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 02135EB356
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQibF3fP6xWbsJbtcDoh0mQMWwR7aUP+ytQflhdDVDXSdbIyoxqWADj4M376aKF3P7/Q/j3Cyrj6TUR5iUPY2wv9gX5/CUA+JSbzfOscDok3i7bv2YEylkqyLjk6QAH+WU6xXx4C8uUPP3x/NMvvIHBowlLauOshx2YCphdtwGdyHhfXYch8dakImUyt3EYmL1TtsO0tUIOgeUxyX5aWyJFjC7zO9yDGJx6USe13IvhzkupkUwfX3s4Tk/wqwojmUd6O+IjQf0PkUMEh+hUT0Z8Wni/+OulZg0AMYskxNMNzabdAq2/l1zn5wWSMAyLcy26ewhbLbG0ZXtZUFDpN1ojLW6tOIcpFVRbmCmNp094Z02aX/BGsU/wpleXoxVx+L/CXLyQaJnTNCDvMkCfEiFkMHp7bXKOiPgC/upcKFw6KVidtKvlfi7xQfSmRiUPq
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2019 11:40:48.9294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b333e0c5-020d-4804-b483-08d762ae2b88
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6494
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add documentation to describe Xilinx ZynqMP AES driver bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
new file mode 100644
index 0000000..226bfb9
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
@@ -0,0 +1,12 @@
+Xilinx ZynqMP AES hw acceleration support
+
+The ZynqMP PS-AES hw accelerator is used to encrypt/decrypt
+the given user data.
+
+Required properties:
+- compatible: should contain "xlnx,zynqmp-aes"
+
+Example:
+	zynqmp_aes {
+		compatible = "xlnx,zynqmp-aes";
+	};
-- 
1.9.5

