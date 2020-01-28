Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E32AC35246
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7516E2173E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 06:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="NCgU0gO8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgA1GSs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 01:18:48 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:61521
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgA1GSs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 01:18:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8EnEZZdDxL4qzaP/gqJ2n1XgflgyyXVLxvcoIdLFe4Jcgi/up8qVxhBv18EOBRvFASpiLbUmlGHHIXQJu2whMx6Re2bGLKRNxM1s8EDtRjpe4qzELFjVANNKZ9Uw1IICwc3BwN5GSWkfq07VKug4nnuuHCD9RPo+Iqx41UXgRIj91AhBCTmyc/Y4MZxp3fcjv5ZFKphgA5No4d1ZJuQigZhnw+a1Ulm2fBuvXG8qqRcIh9mSl3EamU/gZjWuqiXtjDXfzaQmsmIOjBKdY/8ceJWLhnJwlRwfWG/n+KzUBihT2W8vjX3B+tHJZae/fY8ApCzLHH+ZirZl3od2BtDVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8g68MBdZ5tm+EFRIHkHFdVkzQJw9IOCX4ShdjxOoLY=;
 b=jk7FJrAuhVCD5vJEy/Upp1KZXOcFTGnDit8LFWgDhP80e1lTKiTvNecTR4znTQMCEnFb5PMxM6Uso6u39M8EFqtTuLUzpm7u7YW7CNprdHWCW6kB6colxrMplmaNQQ4IIg/1cTpqdENQENJTELXARl+/Jke+dnMHHRT+TCEwojxFnx+pX4jLOu1PXm56Tm6e2eU3Cuj/xicggGyxeWr/aab/j/YRBoBabGl/fveOyZjrk4LzBDBi2gyw9vcChuzT26hCWNYRWFNdWL4wcf6rzdhpNxRweAbFVoVbzMfk5J4OcsKZq/Aj1s1CBCGrKjTtKiCpIvAnky/Idtdh9dgR4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8g68MBdZ5tm+EFRIHkHFdVkzQJw9IOCX4ShdjxOoLY=;
 b=NCgU0gO8y9oyVbg5xBPRPVvoRkyeZfz/CurOEpWur6WA8n/WVooo7bjMgj++Cnst1RZEbj9y/NPOw9zLzKCjV/cXdW71pDzOlbacSIIYKfC97HVC1/NHf2QwnlZ0NFNou4CdRAWGB81umlz1VV0u5UkeXjos1+XqvYlGVg8TUqo=
Received: from CY4PR02CA0035.namprd02.prod.outlook.com (2603:10b6:903:117::21)
 by BY5PR02MB6338.namprd02.prod.outlook.com (2603:10b6:a03:1b5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20; Tue, 28 Jan
 2020 06:18:43 +0000
Received: from CY1NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::205) by CY4PR02CA0035.outlook.office365.com
 (2603:10b6:903:117::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend
 Transport; Tue, 28 Jan 2020 06:18:43 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT053.mail.protection.outlook.com (10.152.74.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Tue, 28 Jan 2020 06:18:43 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKCw-0005KU-PC; Mon, 27 Jan 2020 22:18:42 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iwKCr-0000fd-Kp; Mon, 27 Jan 2020 22:18:37 -0800
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00S6IYWU015113;
        Mon, 27 Jan 2020 22:18:34 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iwKCn-0000fD-Pl; Mon, 27 Jan 2020 22:18:34 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 5C419800C5; Tue, 28 Jan 2020 11:48:32 +0530 (IST)
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
Subject: [PATCH V6 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Date:   Tue, 28 Jan 2020 11:48:24 +0530
Message-Id: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(396003)(199004)(189003)(6666004)(2906002)(356004)(44832011)(6266002)(186003)(36756003)(8676002)(26005)(336012)(107886003)(426003)(2616005)(316002)(4326008)(42186006)(54906003)(81156014)(81166006)(966005)(5660300002)(70206006)(8936002)(478600001)(70586007)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB6338;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8323f3-5d9b-47fa-e963-08d7a3b9ecda
X-MS-TrafficTypeDiagnostic: BY5PR02MB6338:
X-Microsoft-Antispam-PRVS: <BY5PR02MB63380ACFAEE8994154CF7CD0AF0A0@BY5PR02MB6338.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 029651C7A1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93/A2JgOXWXb1cUrkypOcyCNT7IUxGM4vJPsFn7CNOJZRCw6zg3sPmTjmxUGNGEhEeU6e/Rh9YijY5UZ+146jG+pD0cG+xL9mWjsvh/IFSlHaaNhZVhRuA94OWrmLZJBaDSRguF35j1LYxcqqs/EYnlQS8JoF99KEcd2xRPtDnw0JvRgcyt9e7OLEh1qFLanlCs0vLh708H0zak5r5s+kgZHCitUf5IS+rEYYFhS+fiam4D1q2aiGixUAROOns2c9VTIzjMFA4ZsOXoaRGdhgg21pPiiB+Apr8leeTdoCs9Lgh94K5VA4P4GHwEfRuzDSYVQcET1mtdRzcZ2eR+Yj3L3pYsvvmF37AMoSWFzfE1H65HWBi2fqaWyRUjS1YDubsnCG+UpNXNj7GHoJF2oHnHjmseuAc7xCbLHnJZlH+H9RWX3xMxy90oIuXy0bMEv465V6irXCZLTgmyrBceXBhxHXz1wQfR89jxud77hNeO2SMLUGjT9cMFYsR1cysGkBav/QGd8p88kHQDadyS0YhdnezxsOuwCn1Ls7Kmwbcg6FrQQu21i6NNoeDn9z0H/
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2020 06:18:43.2540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8323f3-5d9b-47fa-e963-08d7a3b9ecda
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6338
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
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 466 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  25 ++
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 8 files changed, 549 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c

-- 
1.9.5

