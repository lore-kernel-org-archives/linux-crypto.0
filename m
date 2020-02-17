Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02581C3B185
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD182465D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="hduf3fJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgBQK1y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:27:54 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:25727
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729381AbgBQK1x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 05:27:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNGbo3kYzVq5K5ueg0ZomnN6kggkARw/yHVbJTOFEEKWeWxWqmbDoORZsAsxtgNbGhj5i0oqjybb3VDsqwYFpE59XsxoMqWPPswqcu8hUhJIjLTecUXUruqXLWEsG8uYXdTXCAl9qnh0pH9JW8Y4wG49NvwL7NPVMqJR625oWfg4tvO6rcQarzGG35lHydbwLm3eLv6JZzMYsj+I1qZFXFb+K0JtRW+Ygj8lNApbHKDs+GltFhdcbOaWRfL4pyA7BZLftQptODZSuEqrV5Cv5NHUaQ7jGUxVwMkUDQogAD0Va8SJeIQhUkGOuoxSxNK04AEpVvPlf56GD5dZkbvqtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHCfGC/h+co6K42dAvgN40+/3m0ac0bqAT9iyNUvTFs=;
 b=CR31ZlPkbBiRU6GS9Fh6286q6g+oQhL0W8XW+TRMwUKTe/PirmV3fiL7br8TexlA3BLzMRHtDEFMJYwdiLS6OLUyjiUA0t8k5vizBP4b24KhtOaIROc6ZKyMl2ASEU6qr4/v4MIo1VN4t//eXTN35i6UQhFMxAecXzYDuDlZy1sPziIZbsa+INuyLPq59p7kJWcY99wpy+9x0dBVkoniok7o+uZ07Dyv5qGQ4cIpqA4IQJ2cfMTOK4TvA7VoBwzWv5958gHPFzS+/vYW/O0JNjfE4s2tAjrZ7+y1K61jLWoUEsSOyZaOXYhZfv24G5qq+Fg4Pi3H48el+Nxt6+OmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHCfGC/h+co6K42dAvgN40+/3m0ac0bqAT9iyNUvTFs=;
 b=hduf3fJ2zxfSyJuTDGkQKCI6a603HHjgIRekh/FA+MLILBxyPAQ8k5oEazSlDcktVfwwCZvl5GfuHg5cFhmzBvibkdgoCe5ZhY1b87dAbmJXh2GYY7vwq9EzjZn1x92Suab9OQ7heIi3O3B+LMEeHnCaCohwP7JsayWtkFm8b/s=
Received: from SN4PR0201CA0070.namprd02.prod.outlook.com
 (2603:10b6:803:20::32) by MWHPR02MB3357.namprd02.prod.outlook.com
 (2603:10b6:301:61::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.31; Mon, 17 Feb
 2020 10:27:50 +0000
Received: from SN1NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::204) by SN4PR0201CA0070.outlook.office365.com
 (2603:10b6:803:20::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend
 Transport; Mon, 17 Feb 2020 10:27:50 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT052.mail.protection.outlook.com (10.152.72.146) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2729.22
 via Frontend Transport; Mon, 17 Feb 2020 10:27:50 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dcz-0007ny-MZ; Mon, 17 Feb 2020 02:27:49 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dcu-00034b-JN; Mon, 17 Feb 2020 02:27:44 -0800
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 01HARdDh000804;
        Mon, 17 Feb 2020 02:27:39 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1j3dcp-00034H-Bv; Mon, 17 Feb 2020 02:27:39 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 23D3681415; Mon, 17 Feb 2020 15:56:46 +0530 (IST)
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
Subject: [PATCH V7 4/4] arm64: zynqmp: Add Xilinx AES node.
Date:   Mon, 17 Feb 2020 15:56:44 +0530
Message-Id: <1581935204-25673-5-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
References: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(346002)(199004)(189003)(8936002)(107886003)(70206006)(4326008)(81166006)(70586007)(2616005)(81156014)(2906002)(6266002)(8676002)(36756003)(478600001)(356004)(426003)(186003)(44832011)(336012)(54906003)(42186006)(5660300002)(26005)(4744005)(316002)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB3357;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7db1332a-1876-4f5a-8c42-08d7b3940a15
X-MS-TrafficTypeDiagnostic: MWHPR02MB3357:
X-Microsoft-Antispam-PRVS: <MWHPR02MB33579584133804E9041A7749AF160@MWHPR02MB3357.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0316567485
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GrWQC6zJgYCnPX25G4byOS5V+H+QxoQVC4gXU9OYi0jeiLGw/TvOXSjuR6v9CQlhQdcJusdUCUJrX6NWW6yfAzu+aF7Aa8jXqo/9HLvHJUjtTwzgKy2TxqdRYSlgmfiELA40KYkCLM1zSY6+AXd6t9ZZiUdppShMgLek3a1jv9FA5W+ahXhgdHmUWIUqgo5FB2K2zhEk2zt6E0+zQWtscrL3YZO1yol4ujERvBM1ppB6zWhM+19+LaFEWkTadVQx5tlBNeFT+ft0zm06An9ttlElBGcfZmoF4pocdZbKFXp7RjsrSPCv50obEWqpAQzDi39Qk1y91nUYbsaxPTBYspinepdnQC9HP1FcJ+/Qy/YaWbd8+uu/RzKWecwKAQakjv3aqMw0A5hYV/gZLLKGx+vSg731C9u2PtzPWDWjDkkI2ZnnP5rVS5voZJDl0bN6LQdvCE0zKi97c4k0b0ciVmet9hvvLpbRKP5ogCNdLLTmDBhrtJN8GhRPA8xfmatr
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 10:27:50.0799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db1332a-1876-4f5a-8c42-08d7b3940a15
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB3357
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
index 26d926e..de4c694 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -158,6 +158,10 @@
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

