Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9FBC761A2
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B3E220725
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="YfjZdZKk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgBQK1D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:27:03 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:6258
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729266AbgBQK1C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 05:27:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV/q8tLky8O/GpNfdQCqkSzEgvoz1+PN7zGjZhfcG2FuYtmvfSFNbu21W8e9SwJcy2Ry04EdklUi8/1wKmXs3f7mdsXrPjVNVU2889P+9kX0/c1f3BWRhsp2rz0YVhzf8kXMxFqP1gE4KliRYisL4E6W5w64hbNVFXLFmRYSQbyHPvnVqpe49srvKDTrHmsuXdhBys9hR0+NS3U7HBiYiIgKA3GI54+AMWcX0CAGEYzHJjof288FHUc1lCy4XplGtfGgnidr11kT3D0lWZIQAbyR9Pe6RlznpslTkR5eyIxiTr/tDhhkhr1E267yyUKBZ0rM4dicyEosOXSGhiJMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ejiPFd1Q8s8XZ1RtNIDxLSdWKvHnL0I5ACJ8w0vYY0=;
 b=TTy6/IKeTZVnhvg6psJdcK7qpufBOnyDy9Flb2aekUxnuJi2e6+9D35x3C8m0SENYB2ptdlCnD9rD7kbWgMCT2KyUEAt4Pt3aSyuNgqd8Sdb9hVTg8Y5k0h1RQUYvP20SbbL5y8LPDdwSwrXRiiDjatHm9SUYBHuGdGK2oJ96AcZAoPITFKElPTQzeZoVBxsYam8IUewRP/akodUCJfxfW3c+DiCmuknnlFn2kR5hLQAnq5EqcuBMgzPsJ6Qe2xxggZV2CAK6zEloeLLp9sQDH0IEtmUCLhSoRNwVGtNWXtAbM8T2DobNO3bKRaTnMg7pfV9vJpIPPoxVPVvRDKrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ejiPFd1Q8s8XZ1RtNIDxLSdWKvHnL0I5ACJ8w0vYY0=;
 b=YfjZdZKklX57jF+wJNn9pLXdzc/Jm6CQdR6ufZBKhJzf349Jyu3RnFhXPcZWjd2OFd3X/zvwLyMwfVyLBAsFDTCtUFQkl15Kl1vX+b1oWgeH5ilQoU4vidjfYVc1O2LWBx2C4e1Ofbed08XqI9WaxYrRQRnD5Tjut64+GuTkSDg=
Received: from CY4PR02CA0042.namprd02.prod.outlook.com (2603:10b6:903:117::28)
 by BYAPR02MB5894.namprd02.prod.outlook.com (2603:10b6:a03:121::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Mon, 17 Feb
 2020 10:26:59 +0000
Received: from SN1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by CY4PR02CA0042.outlook.office365.com
 (2603:10b6:903:117::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend
 Transport; Mon, 17 Feb 2020 10:26:59 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT016.mail.protection.outlook.com (10.152.72.113) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2729.22
 via Frontend Transport; Mon, 17 Feb 2020 10:26:59 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dcA-0007nT-R0; Mon, 17 Feb 2020 02:26:58 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1j3dc5-0002oV-Np; Mon, 17 Feb 2020 02:26:53 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 01HAQlr0014398;
        Mon, 17 Feb 2020 02:26:47 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1j3dby-0002nK-S7; Mon, 17 Feb 2020 02:26:47 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 16AF58133F; Mon, 17 Feb 2020 15:56:46 +0530 (IST)
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
Subject: [PATCH V7 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Date:   Mon, 17 Feb 2020 15:56:40 +0530
Message-Id: <1581935204-25673-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(189003)(199004)(966005)(36756003)(6266002)(478600001)(2906002)(70206006)(356004)(4326008)(107886003)(8676002)(8936002)(54906003)(44832011)(316002)(70586007)(336012)(81166006)(186003)(81156014)(42186006)(2616005)(426003)(5660300002)(26005)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5894;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 380d2705-d802-43b3-c873-08d7b393ebd1
X-MS-TrafficTypeDiagnostic: BYAPR02MB5894:
X-Microsoft-Antispam-PRVS: <BYAPR02MB589453090FE7EFA8E027F62EAF160@BYAPR02MB5894.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-Forefront-PRVS: 0316567485
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOACV/rN9vdbmVSp0X7LJ+ZcHwn4IYvIFrJ0uDdfwLbubAxHX9bRpTN1jgMP6nGp5lA18H7Kod8nxU/wnjLjT6fIdrtRHzicD00bGASkvFADoZdsGcTMURp3CvWNgI3EeuxSB+xlt2Wi1rkTg0pex4pMeWlKmMIG9HX+tG7LKlc2KVQBZqmX0SuLcJqKiYb2jaDzeIJwCujTfVP1MkuF9Ug997Lu0lA32wn20FAfoSpLqlBMfxEE0a0QqPU1ncg5kQlasHqHSGHIXS4XR2mhodYmNGbNTrfhvc3kr4gD+0tiNhSe7DVSP3P6yX5j/Wu0b+i2YwNztAylspXxG1t910ASwciiAZUgIsfDxqJmaKha7ZAvZ9UPFz9HJGW2iuD7U5fqxk3EzJOx8zJFIEBpZWopkj5gIXSbmYWjms22WfT0Ed2MD7NucjYa9ghvqKMyEAO30jtnvMu4UyE0bGFvinul8CoiL/eZdo8QbWZnYnq2wp0AgCwky0ua5FuT1FFCtu4jQiPyzZyLUctI64ibpg==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 10:26:59.2701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 380d2705-d802-43b3-c873-08d7b393ebd1
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5894
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP AES driver
- Adds device tree node for ZynqMP AES driver
- Adds communication layer support for aes in zynqmp.c
- Adds Xilinx ZynqMP driver for AES Algorithm

NOTE: This patchset is based on Michal's branch
https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git/log/?h=arm/drivers
because of possible merge conflict for 1/4 patch with below commit
commit 461011b1e1ab ("drivers: firmware: xilinx: Add support for feature check")

V7 Changes:
- Rebased this patchset on Cryptodev-2.6 tree and fixed compilation
 issue seen. The issue is seen due to the below
 commit af5034e8e4a5("crypto: remove propagation of CRYPTO_TFM_RES_* flags")

V6 Changes:
- Updated SPDX-License-Identifier in xlnx,zynqmp-aes.yaml.

V5 Changes :
- Moved arm64: zynqmp: Add Xilinx AES node from 2/4 to 4/4.
- Moved crypto: Add Xilinx AES driver patch from 4/4 to 3/4.
- Moved dt-bindings patch from 1/4 to 2/4
- Moved firmware: xilinx: Add ZynqMP aes API for AES patch from 3/4 to 1/4
- Converted dt-bindings from .txt to .yaml format.
- Corrected typo in the subject.
- Updated zynqmp-aes node to correct location.
- Replaced ARCH_ZYNQMP with ZYNQMP_FIRMWARE in Kconfig
- Removed extra new lines and added wherever necessary. 
- Updated Signed-off-by sequence.
- Ran checkpatch for all patches in the series.

V4 Changes :
- Addressed review comments.

V3 Changes :
- Added software fallback in cases where Hardware doesn't have
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
  firmware: xilinx: Add ZynqMP aes API for AES functionality
  dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
  crypto: Add Xilinx AES driver
  arm64: zynqmp: Add Xilinx AES node.

 .../bindings/crypto/xlnx,zynqmp-aes.yaml           |  37 ++
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
 drivers/crypto/Kconfig                             |  12 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/xilinx/Makefile                     |   2 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 457 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  25 ++
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 8 files changed, 540 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

-- 
1.9.5

