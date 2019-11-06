Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1806FC5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C95232173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 11:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="ixvk4ce+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfKFLlL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:41:11 -0500
Received: from mail-eopbgr720068.outbound.protection.outlook.com ([40.107.72.68]:63488
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731035AbfKFLlL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 06:41:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHAzMb5BbpR+1QRcAe7+rgL329WHcVAQYGZZmXf0Txjcr8BrMZD17mZd0BgVWxhK74ga2tQ+dP/1BEVLiZ/UH0nlXcoj8mDyn14ewTD4wk8JXIJdRih74AX1sw+CcVqifHv4yDMSHL0NwtH5c8Hs5kDI93+qUYHxOnP4KVHLhOchjRELL8IsQTGTqtCtutW3v6KZVTE2J2gNd0GDBnp0Faar0BoVlhiB6ej53HVOTbUQIQBfmzOk1kgqaNpd/ROFkhiLzC4aYAFcJpJS33yPl7Ndgq2nwW4rEt4112KXtfvI4s6vByvTN7V3GCZFwnkYDkfR6eVMUdjBlCCK2oft+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxexEvfRJvzGJkvTX2fqmfvQNu7V446qEZ9qWQ1rU9g=;
 b=Gd5iPONQKT9IH7y4kAJPd+R9Uj7FGWckX+bczcK+u8iTPB44yAMX+2WorNIuqxpIZ9K+lH9bVkAeQOkdEGIrwZw1cuQlCXCuoA8hP15g1QKswkFjgVdHbp/0VZNQqDW2rYm6mFBtoHoT9pmCV8Bn36niE8jdk55R8Up7ALVh8o00RNlUHledMy1vwA7D9y8YbY4R/pwVlf9RUevJ7tWUKJVv3Fn2VXBufY1oZ2Ee9/aH4n4rrLHN96TRzAgyqUQE45WBik7z+nOHmgN8BtdQzxLRmerhHxeFO3DxqD/UrBPv2K5+l09ChD67S6ATWPWBmFGOsHTZsmyYP39iitNhHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxexEvfRJvzGJkvTX2fqmfvQNu7V446qEZ9qWQ1rU9g=;
 b=ixvk4ce+HSTd9UfEMY5LS5M1Ag4rNicpSABVYoVhi2r/rmY57SvmDaJpAQGGCSfgeC31j+l1mBigvY+5eUvVnWN1rmWriPx11HfBJZ1m9SDwAPWahyHxFrAow2uD+TasVe7f+qMlS8IGdp3S3BKoobfM72j4B66Y2HcaLVCuW4E=
Received: from BN7PR02CA0015.namprd02.prod.outlook.com (2603:10b6:408:20::28)
 by DM5PR02MB3179.namprd02.prod.outlook.com (2603:10b6:4:66::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2408.24; Wed, 6 Nov
 2019 11:40:49 +0000
Received: from CY1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::205) by BN7PR02CA0015.outlook.office365.com
 (2603:10b6:408:20::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20 via Frontend
 Transport; Wed, 6 Nov 2019 11:40:49 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT046.mail.protection.outlook.com (10.152.74.232) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Wed, 6 Nov 2019 11:40:48 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg8-0003DM-AE; Wed, 06 Nov 2019 03:40:48 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iSJg3-0005wm-6F; Wed, 06 Nov 2019 03:40:43 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iSJfz-0005wF-JE; Wed, 06 Nov 2019 03:40:39 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id CCFD480396; Wed,  6 Nov 2019 17:10:38 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V3 0/4] Add Xilinx's ZynqMP AES driver support
Date:   Wed,  6 Nov 2019 17:10:31 +0530
Message-Id: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(4636009)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(16586007)(103686004)(126002)(107886003)(2616005)(70206006)(70586007)(2906002)(426003)(54906003)(106002)(486006)(336012)(44832011)(478600001)(5660300002)(356004)(6666004)(305945005)(50466002)(48376002)(4326008)(6266002)(47776003)(8676002)(476003)(36756003)(14444005)(8936002)(26005)(36386004)(81166006)(186003)(50226002)(81156014)(51416003)(42186006)(316002)(450100002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR02MB3179;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2943bb40-8d24-40cd-4f75-08d762ae2b76
X-MS-TrafficTypeDiagnostic: DM5PR02MB3179:
X-Microsoft-Antispam-PRVS: <DM5PR02MB3179082882C50808EB7E7E8EAF790@DM5PR02MB3179.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 02135EB356
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEmd6tE+ryCcczNJTCwLOPStHp75NNNefSEu8O8tesUUrKE9GpUiy2f43nonpqU2nREEia6FC1v7YX98SiLnxc0zFyh8kCil7uC6mcFIcw8GtFnQBv/JRhXwbibqIJ20kAh34LQ9Nkp5Xmge3YizUwAmk+BSE+sC/x8/fckilCNeV7gEt5qDipE0RI4isA7tTH1fHo2Werq3cD4pEorVeSQrxov4GeEZRPZJDCRDncBqyOALbXnB85WQ62NOfYocnOpTeiIUmEIVLwnOWvftFavSHAyL/0TdWv9XtQ7KzBGsASxptxUBkxLb0J5zeMNScWgWniehEDMX/fOLUFHb2JAvDGP7XZoaL4Wv3GadUeTgb2NBPwJorTYgiGfwUy65/Uzw0uk6Dn0xEYPjhs9zmOyKTyj+vYx4NqFIKpnzOBY011r5cKMTxdNAOOwItZOk
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2019 11:40:48.7828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2943bb40-8d24-40cd-4f75-08d762ae2b76
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3179
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP AES driver
- Adds device tree node for ZynqMP AES driver
- Adds communication layer support for aes in zynqmp.c
- Adds Xilinx ZynqMP driver for AES Algorithm

V3 Changes :
- Added software fallback in cases where HW doesnt have 
 the capability to handle the request.
- Removed use of global variable for storing the driver data.
- Enabled CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and executed all
 the kernel selftests. Also covered tests with tcrypt module.

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
 drivers/crypto/Makefile                            |   2 +
 drivers/crypto/xilinx/Makefile                     |   3 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 457 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  23 ++
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 8 files changed, 515 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

-- 
1.9.5

