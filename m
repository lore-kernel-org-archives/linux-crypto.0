Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA9CC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC75223D1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="skbiYBS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfKTHop (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:44:45 -0500
Received: from mail-eopbgr740052.outbound.protection.outlook.com ([40.107.74.52]:61344
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727304AbfKTHoe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:44:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dksow9opxgiwFrPR66KqEpi7LFytZ5z5G6VmIzzOjBn1wn620ZCPWjNQi6mMWYU2havb1gJsdFsIwQHvdM565YAjgL0V+adJ/c9Pdur+tv+ttYHiW7lsPtZoP/8HtCr/XcLPJqx4phCUonjppGrtY731yo0INRPqf0jgNPf0H/AuLs34qWGG5sdxHCMynPGce7vRlz27GCcSn9U6+jb6gr9BKJCdLU0HFI+PNX4M2KIVtDAA5wZDTaRRaUQMVJDIWndoZ9kwYpYLMmOaBqVxkzcNBdsqGaNJ1GKg1fCiNCqP3yLL9VJfGFijcCyx5TpZ7sey1B/0ggQdXF1XjrvGlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33cVFXr2DqndquPcJiseowvTTtL+4TtO3k1vxNipVpc=;
 b=MZ9msavsrMfDCUGPUf7/9X9tS16dhrHUDstcIa9QUhQeirH4ZSL3lNDgTUzjy47xm9Tbi/MAWG7WgW8QxsEcxlkICEyn4SzlBtTaKnRb8nYYqn6H+girE9lL+x3mhOO3NcsWTAfmvizgUNZ3mKvFM0QxIl4WK9tnHUAGeomPMkZLKSD/3zb7PjMq2Xoh4cZw1GuBKamGxQOkFEZGxJSImu9G7kyga61ViU4MriqBI5wpWQoJV4O7agDNr3Hu4nl1v0s1iyQ9NsqtKCCBrfsalIxIO3FOiXc7SIQnpCJetEkah1OCH8mWXQsEsGLQjxCO1ZHXAnqKvJPdT7+jQFE98Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33cVFXr2DqndquPcJiseowvTTtL+4TtO3k1vxNipVpc=;
 b=skbiYBS8dM6c8g6c2rfy3peRDNdO08BbN8Qj4oFYRHhKb5/juRuis4dulvqeCKXaG9AiADJDeX7t9ONDhWRtyu9utjI3qZoO5FXMJp+8Gee1aKSnrNFtgrwuJHOrdqF3vnUTYV6wS74cQ3mNl6L5odxuLH2VY6GQxAlSWLRJTQ4=
Received: from BL0PR02CA0128.namprd02.prod.outlook.com (2603:10b6:208:35::33)
 by MWHPR02MB2814.namprd02.prod.outlook.com (2603:10b6:300:108::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Wed, 20 Nov
 2019 07:44:31 +0000
Received: from CY1NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BL0PR02CA0128.outlook.office365.com
 (2603:10b6:208:35::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Wed, 20 Nov 2019 07:44:30 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT013.mail.protection.outlook.com (10.152.75.162) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 07:44:30 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf8-0006Hb-2q; Tue, 19 Nov 2019 23:44:30 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf2-0003nV-TI; Tue, 19 Nov 2019 23:44:24 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iXKes-0003mD-EI; Tue, 19 Nov 2019 23:44:14 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id B8F1E8035C; Wed, 20 Nov 2019 13:14:13 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V4 2/4] ARM64: zynqmp: Add Xilinix AES node.
Date:   Wed, 20 Nov 2019 13:14:00 +0530
Message-Id: <1574235842-7930-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(189003)(199004)(4326008)(305945005)(47776003)(450100002)(186003)(2906002)(16586007)(6666004)(50466002)(356004)(54906003)(103686004)(36756003)(107886003)(26005)(76176011)(106002)(36386004)(51416003)(478600001)(5660300002)(6266002)(2616005)(70586007)(44832011)(316002)(8936002)(48376002)(126002)(8676002)(426003)(81166006)(476003)(81156014)(336012)(4744005)(446003)(50226002)(42186006)(70206006)(11346002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB2814;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64540bc2-7774-4522-0800-08d76d8d7a56
X-MS-TrafficTypeDiagnostic: MWHPR02MB2814:
X-Microsoft-Antispam-PRVS: <MWHPR02MB28146B806461313C28AE00C7AF4F0@MWHPR02MB2814.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vmdqr1mFk53Ozshwc18kwwRrAKCaLKx7rCFFmJPigQSUFGs5Py/OXrVsjG9L1MdOvV1Qj0JKRxw1zxGbmKyBg9iLCyqwgC3kTfMWPPrDq0NBngEaiM6Kf80/+/eCiQ2mM8Ct5E/4vQXYvaQ3wih2//67jEg22ZD6MjMqgwRmVCOqCEfs3We5HNej7zQULDCdbcVffOWgCZVyrIp8EbgP5PRloRA2ev0oSk379em/Bq3vdBdvFy4aq+3jiqWsxUqDEXogYE1ldUFawL3o/MMJ/CJGpiBG3SfhBx6H5w0tDtb7MMzYSB2nzvxg0LmDMPQ6RXTskZdjgstaF15L9oWALwRmamCKM31gJJC/vXiq6rpT0rJtKYGfF6B9ijO4V9kw1/WAXYt4mROnj2m22DQ5hWyKsriSR5sXF9mgR/kHDX1fosQlhp5GG6MMYhK+e9FN
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 07:44:30.5198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64540bc2-7774-4522-0800-08d76d8d7a56
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a AES DT node for Xilinx ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 9aa6734..9a0b7f4 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -626,4 +626,9 @@
 			timeout-sec = <10>;
 		};
 	};
+
+	xlnx_aes: zynqmp_aes {
+		compatible = "xlnx,zynqmp-aes";
+	};
+
 };
-- 
1.9.5

