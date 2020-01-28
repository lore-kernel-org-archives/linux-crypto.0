Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10C0C35246
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BAB024682
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="mOF7YWSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgA1GTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 01:19:40 -0500
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:58752
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgA1GTj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 01:19:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IswHpkTUZpxhAN+jeUfEtQ7/id+rG4Rr7iiO+YXZyYPF2RRhxlIksfB7wdD8NFj3xabuBlZKsc66B1OaVPSoQ21pqy0tIUPVyexNnTt0kVGqivP1rawwvdeejKOVFJoqgtn9/OqVd2S979DvyQPCu2YV0LjaHchXfmGIn8RMoA4icaCgn5eg79vAQnPmbojO71jGtkgy+NjuVFsqasbJMDoXtTYVeigVud9PsHuKJDPd5yblvJdlsrY+mzds2lFGJNoWwhGNPbAB4JfM71eo4QilcIjHMKO0TEMl/aeypFnWfQRzDzG4b2t3AxU7IcdsXNCgy1YhwBXoALckeSlnEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxgJiN9ou7/jqPKFe41iw2pWZuL7GB5PGCcTyd6vM/U=;
 b=UyVBO5y5Ep1ss9rbyswYDJsQU6oAcysKBXX0HBJBVqoFCL+GLQG2yIMBbAOo6Hdr5oMVeGeVRSpaLennlng3A8ggBu766AXBnXEuh/o/463uvTfbwdsy9BmT2wmpYJD4g8KWeeI5puuRP3DgSIGEqoSXimjVO8WY7H7YIHtfDYZkivHbsyyLY3I1e5wgsVVQUjaLTmoKnjIwwanU6ZtrD3s8IQhzE6KBIKN/1PMlCydwpSJ4dvhbf4qayXEyea/q+lITmKpOBXV2xRaqJASdne19VlgGpsUp3tnvgGCMdg/J0vVGjnxgtvIvaiPQVwzmpnLWVnLy5OmQHvdICtI6pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxgJiN9ou7/jqPKFe41iw2pWZuL7GB5PGCcTyd6vM/U=;
 b=mOF7YWSg29hyKaQ28nAUhX5LHy9RELRc6WBKpWiCCfQsAracVH/pSVZ/g7hT+GY9FArVTIqKXqRajOjCUpV8AnzfPGa7i4N5ophOH7XvG6eE0X5Tqd3juI5kimT6tllyrUjaFT46n1t9PV05gnTO1elPJ55AE+lcetT7XhLpn9g=
Received: from MWHPR02CA0004.namprd02.prod.outlook.com (2603:10b6:300:4b::14)
 by BL0PR02MB3731.namprd02.prod.outlook.com (2603:10b6:207:40::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.23; Tue, 28 Jan
 2020 06:19:34 +0000
Received: from CY1NAM02FT025.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by MWHPR02CA0004.outlook.office365.com
 (2603:10b6:300:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.23 via Frontend
 Transport; Tue, 28 Jan 2020 06:19:34 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT025.mail.protection.outlook.com (10.152.75.148) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Tue, 28 Jan 2020 06:19:34 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKDl-0005Kt-Dv; Mon, 27 Jan 2020 22:19:33 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKDg-0000oj-9s; Mon, 27 Jan 2020 22:19:28 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00S6JQ3h018284;
        Mon, 27 Jan 2020 22:19:26 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iwKDe-0000oI-HK; Mon, 27 Jan 2020 22:19:26 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 6EE528019B; Tue, 28 Jan 2020 11:48:32 +0530 (IST)
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
Subject: [PATCH V6 4/4] arm64: zynqmp: Add Xilinx AES node.
Date:   Tue, 28 Jan 2020 11:48:28 +0530
Message-Id: <1580192308-10952-5-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
References: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(189003)(199004)(44832011)(5660300002)(4326008)(70206006)(70586007)(2616005)(81166006)(81156014)(107886003)(36756003)(8936002)(6266002)(8676002)(4744005)(356004)(6666004)(26005)(478600001)(2906002)(336012)(186003)(42186006)(426003)(316002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB3731;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db071a2b-ba55-40ff-87f4-08d7a3ba0b1f
X-MS-TrafficTypeDiagnostic: BL0PR02MB3731:
X-Microsoft-Antispam-PRVS: <BL0PR02MB3731602423D6A5B2F1CB0A2FAF0A0@BL0PR02MB3731.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 029651C7A1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujdvTVVL8jM5K4jd8NQU0Af861RyLOdpIPRoj1eIJbiZSZVQxsiz2BGlPjod6Xgmi6AvHIa6kzDBnVlTyO2b27WpZvRbKo9eNvRLyzVJXfnxlV6W45tRK4BkpdvOw6Ti7XDx35wQXXIudbluI3P0EiYQsvBm+5vmoAmpn+0uGnq4ODWHDmw80+5gDmwohzcNmW9etw7YAipZVOKYqwWFwx41VyqOvPP9k5wpSMByVtQu6zJYj7wnz322gjoZdxR9tNsMPinZJ8E6Giknbo/wsI8U2aOoRi/zNNKYEjcnPk7D263tgSsSh64XcAiigMFPQ7X6SvOxd/pQ+t+fyzU2AIxj8cD4LOPWrxFoJTe8hpgr89RCkFeQ+LxKYnjrg9hEUcOCQO3KC+dF0KmsT9piFWW4XxpjcT/OMU3WpR3ntj7jxHURdRr3GgI1yd7u6J2W
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2020 06:19:34.0793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db071a2b-ba55-40ff-87f4-08d7a3ba0b1f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3731
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a AES DT node for Xilinx ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
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

