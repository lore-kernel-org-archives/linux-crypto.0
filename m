Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106E7C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D132A24683
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="Vrb573eH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAWLL7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 06:11:59 -0500
Received: from mail-co1nam11on2071.outbound.protection.outlook.com ([40.107.220.71]:6137
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgAWLL7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 06:11:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWyNKpo9KSVAodFhKU7xFlLSAawlxSXYC3TDc6PFfGI2PxBod8nG2zcPlvCBZAasc/WuyFRx2vIxuOL4+K/j2ndmA1e1vGPm5xm7itmctyZUOWzw8lgZT10fG4ZSfNzzU+INy1Rae60RBDmkTNUkFBfS0CFvWAH3lXg+d1ANwuS8jb4vzVpmaYA6Kzd7qQ1c92g/x+h+1wLKqrmQ0rh67dXRgj8f24AjPO5UqTgSBhW3hZfT4ZkVMvY29O5PMKYk3BFIm+mdy+04kEVJfz40lXgN7z/2bYvVITTh3AQVkjw9yJ7hLxmqYdsqLp4C/2yLQl6ymvvCHMt3wxy0iTyBwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3DHOPE3HyCVhLkx+wecK+YSJq5GU6t150aQ8dTemAE=;
 b=XVAndfZqZ7o8qDYJHuHj/jkLiX6umhxP2KiJzZkKWhfarSUCM5XBXcfKJMbwDu9N628R+TmteGOVFCf5b8aXjjRaUu1RzaZPdgXjmJrj8mQJ0jfpOEq6psv5LV+PGZ6HocM90GdpgJ2q3o0aMz1ZvDzekW50omKuWqeILoci9nSzQsYSTURJO8Ei/wZMpU24TgG8/0R9YXQ9eZATJRkKIqZ8MyiEMDlhLDclK44Wxk2IA4YUy3mQzY8JkfriAaCDCvIBovbgj15IRFew2q7D0+Alazk1xqyweUAm/J9XIjOc3p/4kvpqoQEx6GtYbNtjyIbDPQGIaQ4rPOQVr6YZ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3DHOPE3HyCVhLkx+wecK+YSJq5GU6t150aQ8dTemAE=;
 b=Vrb573eH9f42Z7j+Bay2u51wxUMyMoE2X03GHmXZWtd8/gpv1IYNbbOFvJ2pPCyr6jxmotz5Mpnqpz0O50zxWcMqDjE7Rw5Fq2hXT+Jb06kzCw0RJPFdFR0xNiyJCDYcq1aACwz7VKQHMVaMeneXInEkiEQZ+pxEUejwYZ/LbaU=
Received: from SN4PR0201CA0032.namprd02.prod.outlook.com
 (2603:10b6:803:2e::18) by DM5PR02MB3896.namprd02.prod.outlook.com
 (2603:10b6:4:b7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20; Thu, 23 Jan
 2020 11:11:54 +0000
Received: from BL2NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by SN4PR0201CA0032.outlook.office365.com
 (2603:10b6:803:2e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19 via Frontend
 Transport; Thu, 23 Jan 2020 11:11:54 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT052.mail.protection.outlook.com (10.152.77.0) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 11:11:53 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaOu-0007hQ-MD; Thu, 23 Jan 2020 03:11:52 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaOp-0007Tt-IV; Thu, 23 Jan 2020 03:11:47 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iuaOh-0007SQ-Ug; Thu, 23 Jan 2020 03:11:40 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 0E6CA800B7; Thu, 23 Jan 2020 16:41:26 +0530 (IST)
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
Subject: [PATCH V5 1/4] firmware: xilinx: Add ZynqMP aes API for AES functionality
Date:   Thu, 23 Jan 2020 16:41:14 +0530
Message-Id: <1579777877-10553-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
References: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(346002)(199004)(189003)(6666004)(42186006)(186003)(356004)(336012)(8936002)(426003)(81166006)(316002)(81156014)(8676002)(6266002)(107886003)(2906002)(5660300002)(36756003)(478600001)(70586007)(44832011)(4326008)(26005)(70206006)(54906003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR02MB3896;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a16ad728-a283-4fb9-e19f-08d79ff50d8e
X-MS-TrafficTypeDiagnostic: DM5PR02MB3896:
X-Microsoft-Antispam-PRVS: <DM5PR02MB3896B035B941CB703081970FAF0F0@DM5PR02MB3896.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 10K07J7sSP11I/WUTYWbs6Bs9o6o3O9JodgxlsYKq2RITFsSjBPeObpsqTFqLDqVM0W/69j9Ztq2tUnSrBZ+BK66mxlgLQFK4L6CHoYFC1KGzE7XMb/KgkLufbkbywRsN26N6xqg7Zrr5H1kXSYCQL0EmQyFdGq4YhYhx0bhI6i08JW+V5St6pX0ZIBdlMefQdGs8zbTFIYBeKLr/yDjEAEECXYwp8f4KdeqWCFIwKjOyQ/qgZwYgxofc8PtLSgXGGswUoPFIMSpoY3nLe3bGOCoFZDzMdY+k+BJ6esjs9sfQGIUT7fn2JOHRXoTOW5KSMRatqVwBX3mftJWLe3rr9OQWfqPAWAvytKq8SKkju3c0PC7xhMZbQ8sizeAzizfZFCk+Xvi5fO/ZvNc77OFRcJQS73BAWIWdurUgHEvMb1pjiknMZvzjIzF+a+h+17X
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 11:11:53.7024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a16ad728-a283-4fb9-e19f-08d79ff50d8e
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3896
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ZynqMP firmware AES API to perform encryption/decryption of given data.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
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
index 0137bf3..20c084f 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -705,6 +705,30 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
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
@@ -728,6 +752,7 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 	.set_requirement = zynqmp_pm_set_requirement,
 	.fpga_load = zynqmp_pm_fpga_load,
 	.fpga_get_status = zynqmp_pm_fpga_get_status,
+	.aes = zynqmp_pm_aes_engine,
 };
 
 /**
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index e72eccf..5455830 100644
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
@@ -313,6 +314,7 @@ struct zynqmp_eemi_ops {
 			       const u32 capabilities,
 			       const u32 qos,
 			       const enum zynqmp_pm_request_ack ack);
+	int (*aes)(const u64 address, u32 *out);
 };
 
 int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
-- 
1.9.5

