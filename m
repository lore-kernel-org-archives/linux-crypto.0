Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D8FC2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C1824683
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="IM26DjR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgAWLLt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 06:11:49 -0500
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:5601
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgAWLLt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 06:11:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ic5Wv+Atqbbx56WRW8F0EIbUg6EzKkCQ/xS7l4j90EhbTZgtqqicwaDZ1ieT6j9XB0oQOC18YDQOnA7KTnXKbzfZkjPhz6KzXECysDd8eKmnmRSY4y1Z7Tdb2m7Y19OQNaZUJ1gu6XQQEquoEUBuDXqy81/ODzrZEFUkfi5ANAHRDpVs0MtGYkOi8/oFR4IQXm2+v8MeULX1L66vG53cuFz2jABD115Xu75EBDMgnr3MwNfxqk8jKCeqsOvt43JGuKmAQIR/7WUgKuqsIOL2tnqfeTn/+0f7IlwGAd8qdlmmLPfKP3u+T3GF+a1Vi4ubBVXT8rOqwDEF3Yf6bsP/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX5ukczZrJGk/Z0LXvsuGStYE5lceFsvHv/SczbRGS8=;
 b=gU2AL/2hotHErsfHgVDtuwRqQXMNZFJl6T6g51MiEJfHVyDajSWJU8rTv/iVb5XdGObCO8qnnPnD3NreGzqgb2Clp3N1U/wq1cUfn3U9frGwW4q0VJaidYBtpNKY/DqoXFk/XzZaX6+MfEkTCDXSZBh7qRLyiRhtFtxfW7YEhPNcCmOnFlzqYQ5zwXsHeq+MA13YwiLYDBdXJYat3wXi8exmSVdHk2+lp/9P+cTpbcS4zJKVY9Br2bWnKu8ikQeT0PJ9NyKBcI6I+7NX0IgzkJE87VSILjhqHSPWuSDkaC6je2CI2ZAcA03Em/tK0L1mfnJbNEE8ro7E+YQocreHjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX5ukczZrJGk/Z0LXvsuGStYE5lceFsvHv/SczbRGS8=;
 b=IM26DjR4vb/5iCbUHrrqHHO4OhWy3QmhLwMhRFVUAIK9eu86Vokb0MmIRAKE0V7+rPUeQFdpEozP2SFg3p6NMHl0IA2KpRcWTkr/Rd7so6TBJDjObuhECNV+aE8ArSiQWPMVbq/frCmVxh+syD7pHZNiz6sxTyRgzrWdK333PUU=
Received: from CY4PR02CA0030.namprd02.prod.outlook.com (2603:10b6:903:117::16)
 by MWHPR02MB2221.namprd02.prod.outlook.com (2603:10b6:300:5a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.25; Thu, 23 Jan
 2020 11:11:44 +0000
Received: from BL2NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by CY4PR02CA0030.outlook.office365.com
 (2603:10b6:903:117::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend
 Transport; Thu, 23 Jan 2020 11:11:44 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT014.mail.protection.outlook.com (10.152.76.154) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2665.18
 via Frontend Transport; Thu, 23 Jan 2020 11:11:43 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaOk-0007hK-Gz; Thu, 23 Jan 2020 03:11:42 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iuaOf-0007S2-DB; Thu, 23 Jan 2020 03:11:37 -0800
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iuaOU-0007Ob-QR; Thu, 23 Jan 2020 03:11:27 -0800
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id 0B5C4800B8; Thu, 23 Jan 2020 16:41:26 +0530 (IST)
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
Subject: [PATCH V5 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Date:   Thu, 23 Jan 2020 16:41:13 +0530
Message-Id: <1579777877-10553-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(478600001)(26005)(336012)(966005)(316002)(2616005)(44832011)(426003)(186003)(42186006)(6266002)(81156014)(8676002)(81166006)(8936002)(107886003)(4326008)(5660300002)(2906002)(70206006)(70586007)(36756003)(54906003)(6666004)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB2221;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ac33d93-5592-4e41-3ea5-08d79ff50772
X-MS-TrafficTypeDiagnostic: MWHPR02MB2221:
X-Microsoft-Antispam-PRVS: <MWHPR02MB2221FF17F43BE14382E30336AF0F0@MWHPR02MB2221.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 029174C036
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Iac/qm7/gYVhv5Zq6KVjfpLcVX44vT1m+LTZGf435FkVb/Odlly5tes14p3Rr3nc5JPuTq4pecy6ohaAmcZPM4tX/hbml2FMU152gfF51j8/CuHxS3N9sElT/BB0hIV1LHyYanEcE0s4gbX3XjQRfNnSIH83wSFKN9tPapWBMxgHAiOHJFru4l+3CT3zsOdQqFtZm5h20NiJaQGqhiIZwErESn50vAn+ExoBeqPCK48MJUR4z95Up3ow0xjb86Rtq/nfuHsxbX7MDQQMEWyrH2I5CYTnlnKMLQljL+8nxL2iHzH9xwi+2uZEeUkxUiqei/LaO1/sKronS67EFzn9aBK5xLJoKpKm/65RCKkGO2vLGOHBoOWcSewiGQU/s0QJ3mrFYWzn2k0qPUJXz+UCCT5zB0o0i8/SgYEY40pVX0DGRyGIrG7JvkSYKzh5WwBDHu52hGz1PIxpjtS9XlnvTHTkD0N5iyPeiJu6TJddXo=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2020 11:11:43.4496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac33d93-5592-4e41-3ea5-08d79ff50772
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2221
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

