Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D8FC2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C88124684
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="i6KS5hEH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAWLMh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 06:12:37 -0500
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:6232
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729012AbgAWLMh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 06:12:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5Ea8IqwlapU6uwT3Rd3zHZbOEiGLzQy7uOXuuM8OfdKDULD0MdJ9gERut/kTJGih59f66YG89l9w092Yl3n6qOqiYE9M78Hy3QwUKPjjEjr4RC5sgTLcy0WLovj0JjwWz5jARNQ23aRWEkFAIA+qpAVmdlVdvadvP2yWeC89S8AJiagOy6Ab4d/Gkvi1dVqYiWdpwhnXNxPo4QtEcG/GaVfsyQxIGwPCBipFek5ZJhfHqV2Qcra/HbIzPjGsG2wQauL64d9XUugBca1olEOkgEoYAqWUv8Az+Z7R3MUorseU1cudqvDU0OdmitwPprID7V8BCOCDT7ECocRwR6YJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1bM0EYu5TyW0Xfnl54FBQ/xod4oyrMnC4TJCUFLFYU=;
 b=UbXvJKN0gV++pI6+TluV0tkzPqOmaLOQVM8vokCsxVhqk9ylCowZhYsax0+gKus9a3P5q8fPr9ITkTojLHqUoLukIR5KfrbfsHkzx35xUtkp4Ec+++50M+iBc86WSZDp7bBruQwtVjGygnlCEYesS99OIkfhO0GhnMT0buJxAp32sth6LLGIzK027qZA4qRftwZK5HR6Rc37vLPtU9xodWf9U4IlwdMkrgrjKJEXvXmT6xQKrWzmF88RneYyCR1QFehCy6uip4lopU7tdb7xvJP7bDOl7chKdsXJIcx9wPBNveKaDp1y+jJ9pzHzidzXykLdU+ZUa6uEjZpKJ592rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1bM0EYu5TyW0Xfnl54FBQ/xod4oyrMnC4TJCUFLFYU=;
 b=i6KS5hEHORt82pUPC90nA7XabszvW80IbkfH41VqKahJzfrBOu7h023nqP+VG6FinYCWQUuv5rBBfebhMS5x17/U+fcVqTKAJI1CAtcXhqoqqlIHCBy9TLxjCnYmGaQ7/l2GgbQ1MuG/xjeoI/s1/0AIaFv2QbRDUz142enKPVo=
Received: from MN2PR02CA0008.namprd02.prod.outlook.com (2603:10b6:208:fc::21)
 by BN7PR02MB5348.namprd02.prod.outlook.com (2603:10b6:408:2c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19; Thu, 23 Jan
 2020 11:12:34 +0000
Received: from BL2NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by MN2PR02CA0008.outlook.office365.com
 (2603:10b6:208:fc::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend
 Transport; Thu, 23 Jan 2020 11:12:34 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT022.mail.protection.outlook.com (10.152.77.153) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 11:12:33 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaPZ-0007hk-40; Thu, 23 Jan 2020 03:12:33 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaPU-0007gf-0O; Thu, 23 Jan 2020 03:12:28 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iuaPL-0007fL-Ih; Thu, 23 Jan 2020 03:12:19 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 1E47C800C7; Thu, 23 Jan 2020 16:41:26 +0530 (IST)
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
Subject: [PATCH V5 4/4] arm64: zynqmp: Add Xilinx AES node.
Date:   Thu, 23 Jan 2020 16:41:17 +0530
Message-Id: <1579777877-10553-5-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
References: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(81156014)(26005)(81166006)(36756003)(8676002)(4744005)(107886003)(2906002)(316002)(5660300002)(336012)(70586007)(70206006)(356004)(6266002)(6666004)(54906003)(2616005)(478600001)(44832011)(426003)(186003)(4326008)(42186006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5348;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dbda26b-bcfc-4a39-0d32-08d79ff52564
X-MS-TrafficTypeDiagnostic: BN7PR02MB5348:
X-Microsoft-Antispam-PRVS: <BN7PR02MB53483362B4FDA292FB8107A7AF0F0@BN7PR02MB5348.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DioHXt3j88T2TcrzNCoSZ220A6hNcQdnio/Do8GIPrB0Qh1DTNxJJQeAp5c0g8Li7QSKY0aNVAR7BON6P0Syv0LCL73wKsKtSk727j0rbwJQ6sgGV2MN/Ph0D2WBoIlCTkU/LFjJr4SjRsbBJlCoIHv91mIVZt0LG5ZKb3NJpcIlhY40A3v0Y8xya4VEWD7YNsRhAqvstEPVLcEYhqVsJomLxQTiu+J9qfPloFpcmLFSwm2jQyJgWPi1Ns3GtBb6tbgEcW5HHyyWT38QT6VgnXu6RReKKoAwNuK3TZ9wMEPomWTIa4/Q29N2jkH+3IqJ+Juz+RJxF+ypxeV/DfgWyGUVXUYl7SVaStvNSk0B7ccrkiuR/4jIKWiv3L5F9yh5sh+uPVhVa7MVF/wTUBlBqeYn5UaD12yS1JlzoWljdSkoSrY8DEMF7OXU27g6GitK
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 11:12:33.7552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbda26b-bcfc-4a39-0d32-08d79ff52564
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5348
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a AES DT node for Xilinx ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---

V5 Changes:
- Moved arm64: zynqmp: Add Xilinx AES node patch from 2/4 to 4/4
- Corrected typo in the subject.
- Updated zynqmp-aes node to correct location.


 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 3c731e7..e9fbbe1 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -133,6 +133,10 @@
 			zynqmp_pcap: pcap {
 				compatible = "xlnx,zynqmp-pcap-fpga";
 			};
+
+			xlnx_aes: zynqmp-aes {
+				compatible = "xlnx,zynqmp-aes";
+			};
 		};
 	};
 
-- 
1.9.5

