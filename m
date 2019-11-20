Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB13C43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6975A219FA
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="srXfMVV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725268AbfKTHoe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:44:34 -0500
Received: from mail-eopbgr820074.outbound.protection.outlook.com ([40.107.82.74]:35360
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727378AbfKTHod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:44:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6svi5yvLRb/+fKS1lo9zUxjOV8EG4ntZXlc3A91kT7oXnITGT86Qz0PHVNHvX4IYiuo9GvIuf6RJ+tYea7zqdqmkrI4ur5bDNUaC8xykDiLxdMUEzJvlS1lhPtFTwVtWv6DAvloJGKs8fpNPyDPlBw71JfFais942LlJKW+azuKzBIeZyMrGkBigfHVl/oaGDHNpLEsHrDt2MI7yi4xmr1b1Fl/1szqeiSMAk/AJz3cV+0Apyd8u2o2e5j80j5wSLP+6jlwimW3TA5sMhvuMxkTV5sMyAi5MwaaWxRqTKDWIiv9JTM0+ZTJTMUpIMQfOalMmlotwGxFeSOvZLCcBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz2gQAyyXjKJI0YHf3nIvhpy1HTmtXK4N/3r5qfyiBE=;
 b=Edc/ntSCFJL5vErWwVONtAKrgBYXwAGLZgK3APohFayxxGWFltQcwHBBhCodiEBf7EgPA4/Z23orC+368Ql3tN/7/TB/Y9an3PlqYwSK2w+wNjS8OKoyz8Oz1jN3kAF4MsnhD6LOkQgaWNPoxomWLWErStPKOhTlOpjWeQ5z8+gJKe/WiEY8/l2pDB8bS3nn88fdMkMfvKpiWZ2WsDCmKwLTXn60qTzW2/lNn95DP/eLOfV0y99hpPQrP2yjMcgGaqvq+w3lx5ovfBNXgft1KzI4Zp68pLSA3AhyGgoLB7FvTFkzSjPRpEdDXo+YcGSLfoZl2yPQ2jr4OCLVd2KHKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz2gQAyyXjKJI0YHf3nIvhpy1HTmtXK4N/3r5qfyiBE=;
 b=srXfMVV/iMb4Eyf2H8h0Xo83alDaj0Sy/4jvP9ANPz0fJgEEzptw9YzcMHvL+3dqum5Z2oWay16AzhE0YGXM06o3mM0vC1ZoIYc467RjRCGbpDD+6YvfnyIQvqX2qPAPjEMPGZ0ZsQ7XJHNRgZZAnBHH3VivNBvezJZWu4kJxE0=
Received: from BL0PR02CA0006.namprd02.prod.outlook.com (2603:10b6:207:3c::19)
 by BN6PR02MB2498.namprd02.prod.outlook.com (2603:10b6:404:52::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.29; Wed, 20 Nov
 2019 07:44:30 +0000
Received: from SN1NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BL0PR02CA0006.outlook.office365.com
 (2603:10b6:207:3c::19) with Microsoft SMTP Server (version=TLS1_2,
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
 SN1NAM02FT064.mail.protection.outlook.com (10.152.72.143) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2451.23
 via Frontend Transport; Wed, 20 Nov 2019 07:44:30 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf8-0006Hc-3p; Tue, 19 Nov 2019 23:44:30 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1iXKf2-0003nV-Ut; Tue, 19 Nov 2019 23:44:25 -0800
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1iXKes-0003mC-Dt; Tue, 19 Nov 2019 23:44:14 -0800
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id B5336801D9; Wed, 20 Nov 2019 13:14:13 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan <mohand@xilinx.com>, Kalyani Akul <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V4 1/4] dt-bindings: crypto: Add bindings for ZynqMP AES driver
Date:   Wed, 20 Nov 2019 13:13:59 +0530
Message-Id: <1574235842-7930-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(189003)(199004)(11346002)(2616005)(486006)(446003)(48376002)(356004)(126002)(36756003)(36386004)(6666004)(476003)(44832011)(426003)(336012)(186003)(51416003)(26005)(50226002)(81156014)(81166006)(8936002)(76176011)(8676002)(450100002)(4326008)(107886003)(6266002)(316002)(4744005)(16586007)(106002)(2906002)(42186006)(54906003)(50466002)(103686004)(478600001)(305945005)(5660300002)(70586007)(70206006)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2498;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f4a2061-1d17-423b-083e-08d76d8d7a52
X-MS-TrafficTypeDiagnostic: BN6PR02MB2498:
X-Microsoft-Antispam-PRVS: <BN6PR02MB24980D332E6D0436C0314BB2AF4F0@BN6PR02MB2498.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UgQsQQJbb0K2peK90iLSlvVSPFf8/TM5E+HoY5UTfmGnhlrD/tspaG8TzIbBAAfz8NYJRaYyuH3v6oh8M2H9W4Nfs3SDO8Il1xKIzl0ytzBiz3s4noD5iq+36U/u1/JvIzevaaYnqWwjeujAUfJm9qMhMZDveQILjW2NSeYafH2s1Et5CWd9Rf1EOei/pinIln9FiZPTOyX8hFGyd4FyVqFdfm7qK9aZy8t1Jj/oTcFxor+FdoCKtMrKi9FAhXsHXTL3eHwyw+KGfGimR62NB70R6VwHI7F6O3JY0ewS9djGYbl/395ZuoWi/Syecfj59vwgyGlNsa03TvzeqWPYizngnhFhOytvCeisjLDmZuZtraXkvuJMe4k4G//lRJuJPD16u3rcbBPtUSBPV3Ry+v52HeMGCq1YczHbMxz6s4JYgKzt04m01NpaFc0Q4fF
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 07:44:30.5106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4a2061-1d17-423b-083e-08d76d8d7a52
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2498
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add documentation to describe Xilinx ZynqMP AES driver bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
new file mode 100644
index 0000000..226bfb9
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
@@ -0,0 +1,12 @@
+Xilinx ZynqMP AES hw acceleration support
+
+The ZynqMP PS-AES hw accelerator is used to encrypt/decrypt
+the given user data.
+
+Required properties:
+- compatible: should contain "xlnx,zynqmp-aes"
+
+Example:
+	zynqmp_aes {
+		compatible = "xlnx,zynqmp-aes";
+	};
-- 
1.9.5

