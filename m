Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE672C47254
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 10:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE27120787
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 10:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="SFWRdbx7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEAKPd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 06:15:33 -0400
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:6051
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728119AbgEAKPc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 06:15:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1H3I6c4ULuqL9myjwS/6ZNX2WYCHsvo4nuoipV6fLwYZq9Fa+ZcYIvbCPdLyxgT3mlSZoXuQcBbk0iniCN36Y2Rhtz2TX/xtlzaX1ELMhPJ7ig9NqD9EOd6h8MOersxMpsyEBbx0xFK1j4rRSwlSWM9ADhcz5u43x5T/GpJwYzJi/K14/JWJgzFgJPWumJ8+fIco2fx2jS0N/YbgyKslbBWefmuwvFWQbtnEwrwp5uWGlwMv+wGDI8y5FMqmlhR+UOTzWN67Aoc8exnuSv7flptMbaRyfFa4F/3cjlnPc/PNSsoIvGo/vTX+DyCjMEdnEvc5XtjybRkTq3McnDOWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTCwm9Dvm7Zuz1+5QpjudlP3iwJF8lYiHxDv3j3ej2Q=;
 b=ZprIFJTvr+kN5bhJusfGKOosK2uZozW8BKxEx4FeMjzYFQMv0mGUZ/lr9Us/4hW2G6yATUQjbsvSOcGEQ02gDCKHpYe5+T6nCjIFSjbF67bJaU+12KFF14XHMWf5yDL06bnnKEQlRm/A8/KuEhJdjorl1sGu+wW9w+PMQvc0kXHSmvtlxUuzTHbComZfr3wyR0Gk/LlqfK65YNZCXFP1Ue9Dqa0Hs/i2YekQY4+GdG/UwyjuDB52s3SnEdg83Gc6msnbf2G0698bLAEYAdECB2CasM8p/M9R+tc0UOdCgGDL2HsncJosfhJ7QSSQ4OSS6k5nvNzkDnZX8eptbQtubg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=xilinx.com; dmarc=bestguesspass action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTCwm9Dvm7Zuz1+5QpjudlP3iwJF8lYiHxDv3j3ej2Q=;
 b=SFWRdbx7X39bg406bInu/qImycflv9NtgSVByanjwIOnan8wwCjnjsC4Zwo73EQkdtn+1T8lpJ2Ogar5+obQCrVbNfrW0lFZYAqQNCaoUp5IjO9c3RE6EKLaf8G3FPEOT/MbLn32AUhvqGoa2Dp6VAFYsKRDTt6eMqDItq+AZIY=
Received: from MN2PR12CA0017.namprd12.prod.outlook.com (2603:10b6:208:a8::30)
 by DM6PR02MB6778.namprd02.prod.outlook.com (2603:10b6:5:212::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 10:15:28 +0000
Received: from BL2NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:a8:cafe::2a) by MN2PR12CA0017.outlook.office365.com
 (2603:10b6:208:a8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Fri, 1 May 2020 10:15:28 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT060.mail.protection.outlook.com (10.152.76.124) with Microsoft SMTP
 Server id 15.20.2937.23 via Frontend Transport; Fri, 1 May 2020 10:15:27
 +0000
Received: from [149.199.38.66] (port=34748 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.90)
        (envelope-from <rajan.vaja@xilinx.com>)
        id 1jUShZ-0007Vb-2T; Fri, 01 May 2020 03:15:25 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <rajan.vaja@xilinx.com>)
        id 1jUSha-0006Xo-J5; Fri, 01 May 2020 03:15:26 -0700
Received: from [172.19.2.91] (helo=xsjjollys50.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <rajan.vaja@xilinx.com>)
        id 1jUShQ-0006VK-4y; Fri, 01 May 2020 03:15:16 -0700
From:   Rajan Vaja <rajan.vaja@xilinx.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org, kalyani.akula@xilinx.com
Cc:     michal.simek@xilinx.com, jolly.shah@xilinx.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rajan Vaja <rajan.vaja@xilinx.com>
Subject: [PATCH char-misc-next] crypto: xilinx: Handle AES PM API return status
Date:   Fri,  1 May 2020 03:14:51 -0700
Message-Id: <1588328091-16368-1-git-send-email-rajan.vaja@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapsmtpgw01;PTR:unknown-60-83.xilinx.com;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966005)(2906002)(9786002)(47076004)(336012)(356005)(82310400002)(81166007)(6636002)(5660300002)(107886003)(36756003)(426003)(8676002)(8936002)(2616005)(4326008)(316002)(70206006)(70586007)(44832011)(7696005)(478600001)(186003)(26005)(6666004)(82740400003);DIR:OUT;SFP:1101;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b10435-abc1-4ad6-a4ac-08d7edb891d3
X-MS-TrafficTypeDiagnostic: DM6PR02MB6778:
X-Microsoft-Antispam-PRVS: <DM6PR02MB67787F5097ED470875F0B8D2B7AB0@DM6PR02MB6778.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKzcNiSCEoTbly1XwyfgqhXHzhHOKdW1IPbx3alBHBBiUlW1Kh4IksZIXqkvhW58fXNm6FNFwCeJU0uYFCWF1IgoRuErpqOl1JdU0FwUQZ1xCJMXGFml6dqqs8oalLI8qFFPq6kGPDQmxwR1BcM0tPhpiBBIZI9vg3TRzjpcOgAsPDFki7tolxhLi7LitqjJ7jRAGFWs89d/I93dJuf3CfQHmMkZ0dnOhMBY8tkM6j1TTb8JeXlITkQxzeosOvQJU8G7Dww2rvLfMIeTA9j6xX7AZM4Gd+EHYtOqsFD37ZF3D2Ad0G/S4AszgWcIKyEGOvbkETdRM7YhqP1weyNXIa1IREFeA7+S+VT73qZdBLMmjNQeMo57axDH68JPuH9P4qRi4dk3/SiDRlae2T6YeLINY4sqA4fGMjtD7u6HjQoNlRleTKx871A1aDt2uljEdMWm8FpDzbnMPGh4XGk7uyWanQi6eOvGIfEB2kmi1945C9+LQ0APE319Fy9akgvvwd1rhDEXuVemo4AkqCDcYg==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 10:15:27.2446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b10435-abc1-4ad6-a4ac-08d7edb891d3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6778
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes: bc86f9c54616 ("firmware: xilinx: Remove eemi ops for aes engine")

Return value of AES PM API is not handled which may result in
unexpected value of "status" in zynqmp_pm_aes_engine().

Consider "status" value as valid only if AES PM API is successful.

Signed-off-by: Rajan Vaja <rajan.vaja@xilinx.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index d0a0daf..a27e3550 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -85,6 +85,7 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	dma_addr_t dma_addr_data, dma_addr_hw_req;
 	unsigned int data_size;
 	unsigned int status;
+	int ret;
 	size_t dma_size;
 	char *kbuf;
 	int err;
@@ -132,9 +133,12 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 		hwreq->key = 0;
 	}
 
-	zynqmp_pm_aes_engine(dma_addr_hw_req, &status);
+	ret = zynqmp_pm_aes_engine(dma_addr_hw_req, &status);
 
-	if (status) {
+	if (ret) {
+		dev_err(dev, "ERROR: AES PM API failed\n");
+		err = ret;
+	} else if (status) {
 		switch (status) {
 		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
 			dev_err(dev, "ERROR: Gcm Tag mismatch\n");
-- 
2.7.4

