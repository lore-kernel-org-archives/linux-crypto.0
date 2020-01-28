Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A048FC33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69CFA2467E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="cSQAiEMX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgA1GTH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 01:19:07 -0500
Received: from mail-eopbgr690055.outbound.protection.outlook.com ([40.107.69.55]:55517
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgA1GTH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 01:19:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5RS5qixpbva4S+eyWzSVOobR6bkQ1D3IrTKIWPrjJrrmmgHtoHqm0Y9slcJ+BVpNgNT4Tha5qnXA6fDOevnumJHAUTzj0grSwxt8k13nT7xW6APpEY2C3il61NQ10HhnanATD/Xr9yfyZ2uE2GP+eLvpESlistqOC/pW7BSiyWmqgtR4sWGXkXNqPN2S+w64W/a+Y8RL0kEwwic3q44ez3uyzfaug6X4NJ4/5AeTqREw8/7PiDQVCSpo2zFvQSd29zdWZQ7/rXuTxxXxncP0PSNF0K9mF5bIZXWVVdVO6wLPHiGbe8t7cn6y6V0tswLPTLwwbU5BzVxy6kgzIY0zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyKqqDc1nlWJBBJSBTttwPl2znQmklrg+si0t1ftdZ8=;
 b=SrPPwThD4dT+FRXGxP044UTiyHZ1tkxfrb/k0PnQ1uQhGDSn79ClbWXQRJLky1vC+Pj+kFALdoBls2hrueHv5HawYPoOpUyW2jlb8gn+W2peRJf03TKcOGzlordbDS3odQ/9GKhenbdYrdK4YihC1xJoVc3b92v6+M4IDjIVjAwSuowIaLdqOeMzaUJTVq8TYzH5VdI1QJX3QCylHesWkAN7qa2fVTJPSDBrIlTaC2mdaxlU1PXO0LoU2I6pJpiEXA8SdICqB1MEJ6BnUCwj1U/Q5b3lIHno13/dOiCf/PcAg8tl6L5SxFDoVYR6aaNbIRRAkIB0/8k8/eKMQGxsow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyKqqDc1nlWJBBJSBTttwPl2znQmklrg+si0t1ftdZ8=;
 b=cSQAiEMXbS14gOLH7pgPPIHWBXAMwT8+e7ctSeJXnQN8oCftclGQ7UxbFbUsWuXJTATYkr9ekPIL6Z+5L3gX3X4RUogGv4cOoNjUMAKC6wbFLIuoMbOmlilRd/LDKEjDg9I2usn+0CtLysHaHxHQYbuVccpxUluny921fEUyaAI=
Received: from CY4PR02CA0018.namprd02.prod.outlook.com (2603:10b6:903:18::28)
 by CY4PR02MB3144.namprd02.prod.outlook.com (2603:10b6:910:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22; Tue, 28 Jan
 2020 06:19:04 +0000
Received: from BL2NAM02FT054.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by CY4PR02CA0018.outlook.office365.com
 (2603:10b6:903:18::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend
 Transport; Tue, 28 Jan 2020 06:19:04 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT054.mail.protection.outlook.com (10.152.77.107) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Tue, 28 Jan 2020 06:19:03 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKDH-0005Ka-0K; Mon, 27 Jan 2020 22:19:03 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKDB-0000hL-Sa; Mon, 27 Jan 2020 22:18:57 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00S6IlUp018109;
        Mon, 27 Jan 2020 22:18:47 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iwKD0-0000gF-Tu; Mon, 27 Jan 2020 22:18:47 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 5FA4C800BD; Tue, 28 Jan 2020 11:48:32 +0530 (IST)
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
Subject: [PATCH V6 1/4] firmware: xilinx: Add ZynqMP aes API for AES functionality
Date:   Tue, 28 Jan 2020 11:48:25 +0530
Message-Id: <1580192308-10952-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
References: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(426003)(81156014)(8676002)(2616005)(36756003)(81166006)(26005)(336012)(316002)(70586007)(70206006)(356004)(6666004)(186003)(54906003)(2906002)(42186006)(5660300002)(107886003)(44832011)(6266002)(478600001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR02MB3144;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc1f5d0d-219e-429f-c019-08d7a3b9f8fe
X-MS-TrafficTypeDiagnostic: CY4PR02MB3144:
X-Microsoft-Antispam-PRVS: <CY4PR02MB314473046969EF4D3ED13DDAAF0A0@CY4PR02MB3144.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 029651C7A1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JO1Dhkzs/p6YVUPTJgDKVjMIqr1x/gBTN0+Rf0Ukxhw/SSemiyHd9F6ShBMx99l0aEeOJr/qUuCY7Aa9Yt4qogzZy/mC1scENIbXiQZMyPZaBGI+rpTYoNDi0LCmS7hua13SrhKGnMLMQdMMZTo9ncmCbtne5X0VqY0izpTudDtL0N6Wof9ClO4ZponJ9+ADn0X3TtC/LxbV6o5O7Ep6zrNk+BDr8jypkngjKabMzF/ZnNcok8IGDczNsjdtE+ATms12M7r+Awl4OczlfpE1st1zn9FlyRbXCDdt3aAySfxF/U97vuRR+S5iai/ktV61+xzEROrmqpjIkxEM8veyPGpyQoZtZwTyyzXzQ4gAX0Ai4l7tFhNepvfw2cd72fVGNm+ATJkpYSPZrbgkWd2b3TISIc73G59ltWXqgxDq2Y/cxLVDFyz339uhAEip1fJ5
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2020 06:19:03.5534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1f5d0d-219e-429f-c019-08d7a3b9f8fe
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB3144
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

