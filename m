Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16236C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7E3A20872
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="dvmTSc/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKTHod (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:44:33 -0500
Received: from mail-eopbgr800042.outbound.protection.outlook.com ([40.107.80.42]:61312
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfKTHod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:44:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMGupWuJsFa08k+WYp2uYBUxetc8jLCq1xnQSGcEv/xWcV4TYNUZQ85F3whFzAYjcMKeAWvrYxZFZU2nn/IVawFWU324+v5R0cyuhLWYJ/N4/3MY0Vodi35GC9pKMY2lyC1B8syeWEsMm5botnGiFF9wEqbJ8S18a7jIzgz1d4yWMWlGnVpQiyJAKJFdaDeKpQxYNRqGFms1gwwxT/I/fCljFBH02RWV9iC6JiDujK7vVZc0cWCao9wk2a5u07nEU6uAfsSwwX1LcHHSns0DWt//OE8cf6TsQiU4REH3CYC8ff0iJaQsK3WyF/3HzlwFOr8qcXctE8Z8bV8XK7HBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnt7qafzNYB7jP3M3KSlNKDI8pBrpEwCe8f6zV6JIO4=;
 b=Yy58QChy0TLjjkD/ObEPsUFYF7M5XyJoQaKaKdfw2YxmI5lgEsD3FPQ15HbK+ahnxOY0flp4CpllaejqO7eu6zKB//Sb5JAMRZ+M2uKrl/Kxu1I/Q8xbZf56V8Sdy5DvRP+V8n4HOSME6zYSmlQIT32bzuAz5nPQRLvK4Hnv7tMJJPA/07FdRj+8S9buyzYtI3ibRPM3T+KA/CHkpsxOjC216QZxFN0Yj8IJQdKuBiwDiRY0gVwrLiS0UGelj42u++MvWNv6a8QMKrqoIotGFIMy9ceyWJ5W+fCeWGPSuYidhS9/weOx3cOHV41o21LXgRkLpxGzk1gwY5CHZlpaFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnt7qafzNYB7jP3M3KSlNKDI8pBrpEwCe8f6zV6JIO4=;
 b=dvmTSc/g59qtuO6aDJXJF0aKoVYzj19mGqXMVoXRhGj612lYG6DCBtTVxxMFAdDHTXDhxahgGikZV3j/pfvWA6MH4rk6AXr0283bQlsIp+KimCUeRd15JS4H2Lnbv23EdY3YisAWWbykqd6q0eHmF1uTG19WaV4DOnLP9TV0IAc=
Received: from CY4PR02CA0008.namprd02.prod.outlook.com (2603:10b6:903:18::18)
 by DM6PR02MB4108.namprd02.prod.outlook.com (2603:10b6:5:a3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.30; Wed, 20 Nov
 2019 07:44:30 +0000
Received: from SN1NAM02FT006.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by CY4PR02CA0008.outlook.office365.com
 (2603:10b6:903:18::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.16 via Frontend
 Transport; Wed, 20 Nov 2019 07:44:30 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT006.mail.protection.outlook.com (10.152.72.68) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 07:44:30 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf8-0006Ha-1I; Tue, 19 Nov 2019 23:44:30 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf2-0003nV-Re; Tue, 19 Nov 2019 23:44:24 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iXKes-0003mE-F1; Tue, 19 Nov 2019 23:44:14 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id BDDB885FFF; Wed, 20 Nov 2019 13:14:13 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V4 3/4] firmware: xilinx: Add ZynqMP aes API for AES functionality
Date:   Wed, 20 Nov 2019 13:14:01 +0530
Message-Id: <1574235842-7930-4-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(346002)(39860400002)(396003)(376002)(189003)(199004)(103686004)(305945005)(48376002)(50466002)(47776003)(26005)(2906002)(476003)(126002)(486006)(44832011)(446003)(336012)(426003)(51416003)(11346002)(2616005)(76176011)(186003)(54906003)(36386004)(450100002)(478600001)(6666004)(106002)(356004)(8676002)(50226002)(81166006)(8936002)(5660300002)(81156014)(16586007)(42186006)(316002)(36756003)(4326008)(70206006)(14444005)(70586007)(6266002)(107886003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB4108;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd089d0e-928a-400d-f8c7-08d76d8d7a3f
X-MS-TrafficTypeDiagnostic: DM6PR02MB4108:
X-Microsoft-Antispam-PRVS: <DM6PR02MB41088B390A4D83C7727B24AFAF4F0@DM6PR02MB4108.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNt1i1yYkiKgulqieiBP8inyKxu0OTFodSowwt9uljndakvr6ZCi05e9Dn8wCiWEZS1yGMB7/OBd+fqOVfVu1v2Fs+sMIPq7YZIB17jymfk1rl/Vkk5JKArYbVrlWvr2KcTTevO+BHFY6W+I/IQlAsTbfOvaVjWkyqwT4I+dBr3sg3337d/lF9hypeHbBYeG+z3BNggW0DMDLH9YZ/v+fPHQIkwe9+ZN9aA24Ew1dSPeig6B9wfwfNlN9x/ZNLn7DPA2UDlwSEUD65dLqElTkHqP5CKm9Kfik7XVuIn7OL7HDcnqTljL2QTGy+IZTkMHXkO9ol0RrZkk7COLv9xaXH0W7Vc2spoBO8clk6Is0JwpRrkCNWTtNZRMCsbfhnYeovCdXtcycM90M6olbjV3kZFtwg0l1jhziW07cHcd7JmCL1QVY3jqBfIvG8fR+wdl
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 07:44:30.3912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd089d0e-928a-400d-f8c7-08d76d8d7a3f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4108
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

