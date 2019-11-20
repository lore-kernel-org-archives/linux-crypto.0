Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18417C43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A5020872
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="PAb+HIr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfKTHof (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:44:35 -0500
Received: from mail-eopbgr730050.outbound.protection.outlook.com ([40.107.73.50]:17546
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727240AbfKTHoe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:44:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqn5nuj3n+SoN4V2HzqaXi+9qTJX0Pvvgx5/wxVtz4HDnD4JTZJ4wNYobV2UNt3RM/U4+VVj5zW2upN6IDDcctAL361iFlirIvg0cPQ+tZDvytqoEPOeL/zIj3V+Mt/sdIhpyQeANM5zaVt77k7HSO4jqlSuQ10qfFabGPZQOoZGG6PYoJa3lsrDFk2Jr2adFbkpQ9AJl4fqh3QjUEJIwpHAqcukAMz3Mpehke1PNBS6WwmzAvBx9VvCbIxalmVQyLXO2OCSAFK4xad/zHv1gyIuDkZW2mxgRBfUkVT+k1P8YrUDfL9UoWcyZkB6e1j1VmDUS1w/lyjff46h09E46g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAn30VXDorqpjiJKtNpGUob6agiBRg14ig1lTjuC3mw=;
 b=WjB3MycZ6J5dK1RKsYw1HIx+K1Sp6P+pzpggYo4m4SQ+RWL9ne64V2tupEkcwWtufmS676Nl9RWkMtwILfrkBLiCrBC1cR5kyEduVzaO8I5PA/Et5qe3WdO9u7th9azExE9ckCrgXwG9w3O6f3VkfM0/1PMwnvFWVgekJQ5F8WhiW3/N8z63RmMkq1/Fg8NqAM87D51Ev9ErRSLCuJjkjUyGluEl19S9vrbf45kEj4wt3GthaXq0Y7Ay52DS+zX6eUPW8jKDQcRnmyvZl0bfvMj4JXDeG2xxB03scu8GUBHiN2jbPGqV0rTYbnQ4Z9obIuKgUOSn8+KZDjyqhh6mHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAn30VXDorqpjiJKtNpGUob6agiBRg14ig1lTjuC3mw=;
 b=PAb+HIr+l3TyifOq3LjdOTDx2KgmmWAyPyWhH+gUHOV4I6/6Tiq3/Rx9yeeIZsGn8lQF2NhzNg18pUaGaxDaRySD/RlUz/ObUh+sVzQgiatUKak8JLx5EwYagJQ0EF9Qt+OFIlNvwFUsYj+XHc0FugBkISlIZtguJV9yN46H3EI=
Received: from CY4PR02CA0013.namprd02.prod.outlook.com (2603:10b6:903:18::23)
 by MWHPR02MB3248.namprd02.prod.outlook.com (2603:10b6:301:61::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.30; Wed, 20 Nov
 2019 07:44:30 +0000
Received: from CY1NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by CY4PR02CA0013.outlook.office365.com
 (2603:10b6:903:18::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Wed, 20 Nov 2019 07:44:30 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT051.mail.protection.outlook.com (10.152.74.148) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 07:44:30 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf7-0006HZ-QM; Tue, 19 Nov 2019 23:44:29 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf2-0003nV-LE; Tue, 19 Nov 2019 23:44:24 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iXKes-0003mB-Df; Tue, 19 Nov 2019 23:44:14 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id B2E5680223; Wed, 20 Nov 2019 13:14:13 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Date:   Wed, 20 Nov 2019 13:13:58 +0530
Message-Id: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(189003)(199004)(51416003)(305945005)(14444005)(26005)(356004)(6666004)(70206006)(70586007)(5660300002)(103686004)(478600001)(36756003)(450100002)(4326008)(36386004)(186003)(54906003)(48376002)(50466002)(47776003)(486006)(126002)(44832011)(81166006)(50226002)(8936002)(8676002)(81156014)(336012)(476003)(6266002)(107886003)(316002)(2906002)(16586007)(42186006)(106002)(426003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB3248;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55e2ffbe-589a-4335-45fe-08d76d8d7a2f
X-MS-TrafficTypeDiagnostic: MWHPR02MB3248:
X-Microsoft-Antispam-PRVS: <MWHPR02MB3248C2D8ED0BD9BC8873A6F4AF4F0@MWHPR02MB3248.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2HAmJzzdxCo6Lj+ocs1bsVCKshSZ7SCbm2Pq7ynUAKYOvC74qHMKV7yM3k5fHLhhpa3BzF9oV+TD5HnljRrFc87oMMNBDX3zf8NSmG1Wi8X6YzabE6XgHdLgmAioucI1A/SvgaHcK8eW8+7Airj64J8Y/byID4U67WlX837v0dmQlz565XRCH1o8H6jomAptwBxwsx/A9n/emdc5IpgyV57DuXdqltRe+BaS8ThyXiLdQxjDES/uaoYE04O49F7cHvE+OrNtiwgke3h58iFJfQsTGilbNmBz+Rk21dkUq4H8LfsR2jcMQd3tnGeKRkA193SFgi22/tI3oG28xOaxHfwUYATugTzSS/WFcMh2DtmksAWNDxJI8rtsbCaiPLK8WKyNbU8/SPPmJdW2PLHzVEOtJbNN2UsOrFZsZdp5SHhaedgQ5HKmosEH41eipBG
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 07:44:30.2658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e2ffbe-589a-4335-45fe-08d76d8d7a2f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB3248
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP AES driver
- Adds device tree node for ZynqMP AES driver
- Adds communication layer support for aes in zynqmp.c
- Adds Xilinx ZynqMP driver for AES Algorithm

V4 Changes :
- Addressed review comments.

V3 Changes :
- Added software fallback in cases where HW doesnt have  the capability to handle the request.
- Removed use of global variable for storing the driver data.
- Enabled CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and executed all  the kernel selftests. Also covered tests with tcrypt module.

V2 Changes :
- Converted RFC PATCH to PATCH
- Removed ALG_SET_KEY_TYPE that was added to support keytype
  attribute. Taken using setkey interface.
- Removed deprecated BLKCIPHER in Kconfig
- Erased Key/IV from the buffer.
- Renamed zynqmp-aes driver to zynqmp-aes-gcm.
- Addressed few other review comments


Kalyani Akula (4):
  dt-bindings: crypto: Add bindings for ZynqMP AES driver
  ARM64: zynqmp: Add Xilinix AES node.
  firmware: xilinx: Add ZynqMP aes API for AES functionality
  crypto: Add Xilinx AES driver

 .../devicetree/bindings/crypto/xlnx,zynqmp-aes.txt |  12 +
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   5 +
 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/xilinx/Makefile                     |   3 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 469 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  23 +
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 8 files changed, 526 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

-- 
1.9.5

