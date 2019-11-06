Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA7CC5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF572173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="kuslZl+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfKFLkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:40:53 -0500
Received: from mail-eopbgr770054.outbound.protection.outlook.com ([40.107.77.54]:59181
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727709AbfKFLkw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 06:40:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZS326OEZOnsrj68nCSCPXwewGwZfXOaePZE8VS5uFYwXQLxrMgieRVIpFU+ekUgnTKRmSQvVOlERFYWq+lX9WsQbtd4w8TrrcjQg0Ai54E5NVME5ZXTQBs6IEnQeekAodkaCRHrEIz1sU4jUrr578iKoYmU4HdjXbB8nm9y54f71qbzVxE5pWWaHO84RVrBwYGyrazs1lpBGgEhkHcXryZWoJUH+kbaSc7v4HNRkrnPawYuQjHM3M+FdkrMsGUX+xfc/4DFkJVvwcmQ3T3InDzhUSx7FsEFcSBaSW+usCkrAxRa/gvCtYSJQa1EQ2RgoV7HqVkDYi97vsQcrX7VrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnt7qafzNYB7jP3M3KSlNKDI8pBrpEwCe8f6zV6JIO4=;
 b=SjegW9Rm7HhSdHB1wUYiAQ+FAtQrAgPsG7y40h8p4gE8LqLyBm1hRj3GyTvncilqQA9E/1D5GZ0oHTiCtdcF9Uw+m16Dezc3tpR9Be2KTRrnwe+ghcZhD4mebCHuBq8z60WCEiUu7k4ov58e/T29MWD8kDFwzz9Ov+Fy1UL1/rjC3S5UzImQWWJPWpksJx94WYUOD+2rXOvl2xeCVBdNrHjwfdMdHpdZyVI30eKvxHliOF3sFs2HzZ4/peztYan3MWncgmVM7EwuFQP/Ydewc3w5+yJ/rQYgnREf8OLHuap4bIsgg5RlU+eyLajKkLLZFR/FD9ykJaKdmx4IR53w4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnt7qafzNYB7jP3M3KSlNKDI8pBrpEwCe8f6zV6JIO4=;
 b=kuslZl+1eIYG7xc7CycpHd6/vouqAPKqCBSRF8QIFfv7JnXYsjYDC9GQVKUgZTzkyv1T3phUabjycBXGiP5HZ4+PRrQbcf/WyT8PUxvmNOlviMAzrC4XchszQoyRwJGhJbPGaWaELmrAFFerUYcTuHgEn9NfPz29ZBVpqYsfbu0=
Received: from MWHPR0201CA0052.namprd02.prod.outlook.com
 (2603:10b6:301:73::29) by BN6PR02MB2273.namprd02.prod.outlook.com
 (2603:10b6:404:2a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20; Wed, 6 Nov
 2019 11:40:49 +0000
Received: from CY1NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by MWHPR0201CA0052.outlook.office365.com
 (2603:10b6:301:73::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2408.24 via Frontend
 Transport; Wed, 6 Nov 2019 11:40:49 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT064.mail.protection.outlook.com (10.152.74.64) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Wed, 6 Nov 2019 11:40:48 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg8-0003DN-Bv; Wed, 06 Nov 2019 03:40:48 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg3-0005wm-7k; Wed, 06 Nov 2019 03:40:43 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iSJfz-0005wI-KQ; Wed, 06 Nov 2019 03:40:39 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id D833C803DE; Wed,  6 Nov 2019 17:10:38 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V3 3/4] firmware: xilinx: Add ZynqMP aes API for AES functionality
Date:   Wed,  6 Nov 2019 17:10:34 +0530
Message-Id: <1573040435-6932-4-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
References: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(199004)(189003)(336012)(36386004)(76176011)(50226002)(50466002)(186003)(81166006)(81156014)(8936002)(8676002)(450100002)(26005)(316002)(14444005)(356004)(42186006)(51416003)(6666004)(16586007)(106002)(2906002)(54906003)(478600001)(70206006)(70586007)(5660300002)(6266002)(107886003)(47776003)(44832011)(4326008)(426003)(446003)(11346002)(305945005)(2616005)(476003)(126002)(48376002)(486006)(36756003)(103686004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2273;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bde81ba6-28ce-4c0b-aedb-08d762ae2b7a
X-MS-TrafficTypeDiagnostic: BN6PR02MB2273:
X-Microsoft-Antispam-PRVS: <BN6PR02MB22732F95BA0AD750BA0801D9AF790@BN6PR02MB2273.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 02135EB356
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MSik9GBnjlIemJN5fIR6PjJXc3risADjMSYnvkWLCT+HIkzbVstLN4Atj9SMD8gMJ3fW2SAqywztl+gnY7e0NtE4IDnIQmTAFqNts02G2iF7pIlZkx0BU0rHkqF+P2DxFVpswARWd/8mFe3ckGHlEIE0ggrZqUrqgYMB0Q80Mc06cM1RREWC6Lc+x1J2Eh18XLG9jz44kNBTNjQO6VfT3oWhnrMj0sJ0V9ydnnNWrufe8qnhYCQ6vt2v3MNy0sgPbv1z8/SNTQ8d3dzcjYxtPe7BRv4JbK4TUtbbfvSkmvnhq7mZexM2/klW7hgd7/sPzwnVRk9Cx2SHCQB4F6zqwegvF2eG7ceL5+T9ngmNhgLdS2I4vwhpQLbU2q1+JNh/eIV6L4h9JnviP7pYbZPX9U1PhhdNgnXv2MKg5aC5hg54J3aw4soQH0ndVMwI2glA
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2019 11:40:48.8095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bde81ba6-28ce-4c0b-aedb-08d762ae2b7a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2273
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ZynqMP firmware AES API to perform encryption/decryption of given data.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/firmware/xilinx/zynqmp.c     | 23 +++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index fd3d837..7ddf38e 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -664,6 +664,28 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
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
+	return ret;
+}
 static const struct zynqmp_eemi_ops eemi_ops = {
 	.get_api_version = zynqmp_pm_get_api_version,
 	.get_chipid = zynqmp_pm_get_chipid,
@@ -687,6 +709,7 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 	.set_requirement = zynqmp_pm_set_requirement,
 	.fpga_load = zynqmp_pm_fpga_load,
 	.fpga_get_status = zynqmp_pm_fpga_get_status,
+	.aes = zynqmp_pm_aes_engine,
 };
 
 /**
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 778abbb..508edd7 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -77,6 +77,7 @@ enum pm_api_id {
 	PM_CLOCK_GETRATE,
 	PM_CLOCK_SETPARENT,
 	PM_CLOCK_GETPARENT,
+	PM_SECURE_AES = 47,
 };
 
 /* PMU-FW return status codes */
@@ -294,6 +295,7 @@ struct zynqmp_eemi_ops {
 			       const u32 capabilities,
 			       const u32 qos,
 			       const enum zynqmp_pm_request_ack ack);
+	int (*aes)(const u64 address, u32 *out);
 };
 
 int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
-- 
1.9.5

