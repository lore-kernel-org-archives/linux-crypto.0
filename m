Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EF4C5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBDFC2173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="L9ZLVRzq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfKFLkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:40:53 -0500
Received: from mail-eopbgr730060.outbound.protection.outlook.com ([40.107.73.60]:55616
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727652AbfKFLkw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 06:40:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwusqXqwaLDZGmJ6dXXM5r3wilmYZbKYT4ntqhJJWxdOjLVYY59Tj3dgKswBTFmMzPubzFrLt1nGtHfaeGO0RFyYlrzrS8EBbpXqu4Sw+7aghWAbG1+mhl0DlBTke+4Q57pbcKpuaC7aIrGW0kA2Okuz3WsexvHtOidvERTv5i5x8XbWV6M3KcX+COb/VSSn3iBQlRv5zhQ/xlTFFXVh2dD9kGgwbQkCsUuGIaySprPhY8pPuBS25SI9+IqSwzVkqh1K2oQLNXAcuZ9CTLARoXJSt0ZY2qhy+fWIY3vbgQ1FJaV9ruzSj4dNv+7VQxMV6UcUtYkMdvZ/naGY+g8gqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33cVFXr2DqndquPcJiseowvTTtL+4TtO3k1vxNipVpc=;
 b=A9pkLG1/zHPQz6LjV+KQO6ZfMJppY3C+FkOuS/F2L+kOkn3mEDxfEqFNg/IvNXdd8S+numAIVTX2Zln17rQQ/6dLFGlRZCS+zh7OfE+YLSU2VesP6MTTIOzY2xbWhlqpblGOPHx24Hxt8dk8yhnn7nO0/QkuaXZ0qwiQS+3drlE2NyMO3Jc9Cg4OYAQ716gFnzGRkTus2vp9XBLiv9aC8L9aSdrp+EovPogqstU+QNfLzDElo6ZD74y79SGp9AAfodYPFHeYkQUpj6kaeIBU9WrdqskKwbfHDUQzZz1IHJHWC1pLIQ/hXHfOZ1v1S36hctsZV2pPhRYCwF/0+q1yQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33cVFXr2DqndquPcJiseowvTTtL+4TtO3k1vxNipVpc=;
 b=L9ZLVRzqrocG0tieYEEqEnxff+cwU3RAfNhrbVKMh0s0xL/zLWBg85Ka76zt67dkg1SNStpeXmgQ7bUiHtuuUTXn2lfXJPTgfkqALO4Icl3n525nB+rdIf95AuZ/55NzRADcW5TdA+89sQ9ogu6wsrb8afBtv69ipd51CkMeJBc=
Received: from SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) by DM6PR02MB4812.namprd02.prod.outlook.com
 (2603:10b6:5:17::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20; Wed, 6 Nov
 2019 11:40:49 +0000
Received: from BL2NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by SN4PR0201CA0035.outlook.office365.com
 (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2408.24 via Frontend
 Transport; Wed, 6 Nov 2019 11:40:49 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT013.mail.protection.outlook.com (10.152.77.19) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Wed, 6 Nov 2019 11:40:48 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg8-0003DL-5f; Wed, 06 Nov 2019 03:40:48 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg3-0005wm-1g; Wed, 06 Nov 2019 03:40:43 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iSJfz-0005wH-Jr; Wed, 06 Nov 2019 03:40:39 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id D3C8C803C5; Wed,  6 Nov 2019 17:10:38 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V3 2/4] ARM64: zynqmp: Add Xilinix AES node.
Date:   Wed,  6 Nov 2019 17:10:33 +0530
Message-Id: <1573040435-6932-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
References: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(136003)(199004)(189003)(336012)(106002)(36756003)(36386004)(11346002)(426003)(70586007)(446003)(6266002)(44832011)(50466002)(2616005)(476003)(126002)(16586007)(42186006)(316002)(48376002)(5660300002)(4326008)(107886003)(70206006)(26005)(186003)(76176011)(51416003)(4744005)(54906003)(8936002)(450100002)(486006)(478600001)(2906002)(81156014)(81166006)(8676002)(50226002)(47776003)(356004)(103686004)(6666004)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB4812;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33d0758-bbaa-4613-5914-08d762ae2b8f
X-MS-TrafficTypeDiagnostic: DM6PR02MB4812:
X-Microsoft-Antispam-PRVS: <DM6PR02MB481217F20BDCE8ACDBFF9B4DAF790@DM6PR02MB4812.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 02135EB356
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: il/UB/XtnutqM5vaJwmXrtp2ZAHhmAYv14Xox1sIX5AdYlsT3oP+b5TwZZk6+Yxx6MiLtXJQHoZpjSBIhoTNHNzBXFqqiWXC5S/a4Iy4su9KgzYmegEpkjYVpeYQm//9g1uBWCbcua9V+NOjkvQRDODnDVcNgpWaXVIGJPZ8JVIfiF8pK0Pm9RckbbUdJVMXsVnQx17usYOlWOTkeJwsi8YdXS8YAeGMmfirKuewRXdLmOgDuN8QtgPFMM/LMkV/J0/lsXKK+CCXPuJq/Fglk87sNPj8rDXMTmC6W4AQkRneLg15W8MXx7pjVJz7XB6y8Wl8nnPmt32uyWs5n5vYro0m0gc8KWFFbRi4STQhi2tJsM35UWZGie2sdmegGJy3PBjxovTxjh2uS8h+zBodNGU/9nL6nR/U/omCeQBbsMjtFdupb2d825V9fnTZkbAX
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2019 11:40:48.9129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c33d0758-bbaa-4613-5914-08d762ae2b8f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4812
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

