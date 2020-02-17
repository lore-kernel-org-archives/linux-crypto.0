Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C2FC35254
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE0A20801
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="A5wkmguJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgBQK1w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:27:52 -0500
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:6083
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729336AbgBQK1p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 05:27:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bljOpzgWkEhkcrghr8CfAdF60oQRj61hfjxLXZlJM+BUkZNsicthC5R86uABEQ4BNI2td62CJRzREauhZQ//a2RxZT/IJUlBgFbcFoOtVZPMcuzvPfjbAvG9DOI8MJwyPBBYuuPSZO8/eay3T7Q9xknV4Rixp7EBQBqMfXMxnlBqqqiRalZw83cqKz+tLTDRSCc8YUw4kWzOMZwuOdDYLMtGOSEltJjf70W+No3ifz7h1GIkiPOA0WKwkekI8AVgMbgdeya4tgFudMKWzThAoiCoJGjiF4u09ZYPIEIlVYAnfNYCStsthqZMIjNKwiASG6w1PzdbmGXgW7jsN0eWgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiDtpWIhO3ZycZxVkARdI4WPQ+lhJypYK/CxdjJGDgQ=;
 b=G+ndrOvscSBUiz/e4uPsm8J38Kb+Kwn46rph5Q056Aed25hyEXS4GzAZDKlHo85CH/bbkg8FqLS8CPo4U8TEF7fVNh0JJW3X7KEjYl3HhS2EUhJ6/4KmeFOtArVA+hVbAFGiWx1+FQuo3/eLDUrm940qQ46MuIf2t2eTYKdLt810tPr2SIoS4Pik4w/SqAKo41jPG2ZH+M9Up1uztIMbGWEjDNeMixT9MFeS/vd4KTfdD2/mHY5NBXVcVf/HrNosU4mR8M1D7uNwKkw29+QC14g0vwuNfMca0qgP75e/HUj0L3A9SW0MsHqlSEVnYzIdvoJ+oH2LPjWGJVaVzJISzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiDtpWIhO3ZycZxVkARdI4WPQ+lhJypYK/CxdjJGDgQ=;
 b=A5wkmguJxq3zndSduhu0tA0wF5enVPCgZeOuHaa9bjajUhw2WMIGlImQUudOoXMQPiDz43Zeqc5URoNivhxt88/ND7n5KJeOSIYLjGBuql6JxkGp9dQql6CvJxe0Z9ZnFxTBs/4N26FVFiM1fYN2/9adhu5B6OtpKREQ6AwE47w=
Received: from BL0PR02CA0070.namprd02.prod.outlook.com (2603:10b6:207:3d::47)
 by BYAPR02MB3974.namprd02.prod.outlook.com (2603:10b6:a02:f2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25; Mon, 17 Feb
 2020 10:27:10 +0000
Received: from CY1NAM02FT006.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by BL0PR02CA0070.outlook.office365.com
 (2603:10b6:207:3d::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend
 Transport; Mon, 17 Feb 2020 10:27:09 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT006.mail.protection.outlook.com (10.152.74.104) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2729.22
 via Frontend Transport; Mon, 17 Feb 2020 10:27:09 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dcK-0007nZ-W9; Mon, 17 Feb 2020 02:27:09 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dcF-0002vH-Si; Mon, 17 Feb 2020 02:27:03 -0800
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 01HAR0wZ000527;
        Mon, 17 Feb 2020 02:27:00 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1j3dcB-0002pl-Ua; Mon, 17 Feb 2020 02:27:00 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 1A993800AA; Mon, 17 Feb 2020 15:56:46 +0530 (IST)
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
Subject: [PATCH V7 1/4] firmware: xilinx: Add ZynqMP aes API for AES functionality
Date:   Mon, 17 Feb 2020 15:56:41 +0530
Message-Id: <1581935204-25673-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
References: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(39860400002)(189003)(199004)(26005)(336012)(186003)(2616005)(426003)(44832011)(42186006)(54906003)(316002)(478600001)(5660300002)(8676002)(107886003)(8936002)(4326008)(81156014)(356004)(6666004)(70586007)(70206006)(6266002)(36756003)(2906002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB3974;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cac23b6-a22d-4058-e364-08d7b393f1dd
X-MS-TrafficTypeDiagnostic: BYAPR02MB3974:
X-Microsoft-Antispam-PRVS: <BYAPR02MB39748EB65BAC90631253687DAF160@BYAPR02MB3974.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 0316567485
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ctZlSAeeMJZkCZ3YLTwW1O5YtwoTx2N2W23XxKjbITG4pSx+HFrkrlBTpHZ9Bp3CddFrMZHqU6rZr1cqn5D/lr426/fMzpKQGsxV45NPumvy6qKakiYkOH60QvF/1CDKZEClVUQTrT/FilZG4HLsBedukf2c5mD+V7XBHIRGpt9p1mgbPw6dbMzrvse5lTLZZJKZvLq23UfBpc3X94v5u2uOvAA3xOQgjiWU8Pm1pavhackI4MueOd17c9bS/FRteHFdB3K6cX0tQjV7oUpwitqx/BB9B6QKlgiXQh1WzcE1ejC+v4kzfS4ujdnMMTUrndsGyMqk0woS28AhCNfXT64UeOXdDoYxxuA2dQ5+pPhrS6fRODSy5T2IwcUhOAK+Hww0ES5kl4VvVHNBLQHlgTcd88aw50VzfI/rkBLfymep19NSVG7Uxxycukbq/UlV
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 10:27:09.3908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cac23b6-a22d-4058-e364-08d7b393f1dd
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB3974
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ZynqMP firmware AES API to perform encryption/decryption of given data.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---

V5 Changes:
- Moved firmware: xilinx: Add ZynqMP aes API for AES patch from 3/4 to 1/4
- This patch (1/4) is based on below commit id because of possible merge conflict
  commit 461011b1e1ab ("drivers: firmware: xilinx: Add support for feature check")
- Added newlines in between at the start and end of zynqmp_pm_aes_engine function


 drivers/firmware/xilinx/zynqmp.c     | 25 +++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index ecc339d..1dea880 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -707,6 +707,30 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 				   qos, ack, NULL);
 }
 
+/**
+ * zynqmp_pm_aes - Access AES hardware to encrypt/decrypt the data using
+ * AES-GCM core.
+ * @address:	Address of the AesParams structure.
+ * @out:	Returned output value
+ *
+ * Return:	Returns status, either success or error code.
+ */
+static int zynqmp_pm_aes_engine(const u64 address, u32 *out)
+{
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	if (!out)
+		return -EINVAL;
+
+	ret = zynqmp_pm_invoke_fn(PM_SECURE_AES, upper_32_bits(address),
+				  lower_32_bits(address),
+				  0, 0, ret_payload);
+	*out = ret_payload[1];
+
+	return ret;
+}
+
 static const struct zynqmp_eemi_ops eemi_ops = {
 	.get_api_version = zynqmp_pm_get_api_version,
 	.get_chipid = zynqmp_pm_get_chipid,
@@ -730,6 +754,7 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 	.set_requirement = zynqmp_pm_set_requirement,
 	.fpga_load = zynqmp_pm_fpga_load,
 	.fpga_get_status = zynqmp_pm_fpga_get_status,
+	.aes = zynqmp_pm_aes_engine,
 };
 
 /**
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 2cd12eb..8acace4 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -82,6 +82,7 @@ enum pm_api_id {
 	PM_CLOCK_GETRATE,
 	PM_CLOCK_SETPARENT,
 	PM_CLOCK_GETPARENT,
+	PM_SECURE_AES = 47,
 	PM_FEATURE_CHECK = 63,
 	PM_API_MAX,
 };
@@ -315,6 +316,7 @@ struct zynqmp_eemi_ops {
 			       const u32 capabilities,
 			       const u32 qos,
 			       const enum zynqmp_pm_request_ack ack);
+	int (*aes)(const u64 address, u32 *out);
 };
 
 int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
-- 
1.9.5

