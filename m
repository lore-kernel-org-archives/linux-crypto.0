Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38181C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E32120836
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 19:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="05UltIxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgFZTJy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 15:09:54 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:17441
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgFZTJx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 15:09:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3whRNuCRG0vqbu6rOM54R33Bo1l/EIuREjpPobpwSn8q1heaUCsVGmx+8QebwmY1RDo9juPbZ4j0I9ZkEJs1IkXeEii6aGkE3Il2onxyq5Wu/5xh9c9MTPfRaGbfL4Eo32BqcgkAUxtrF8S5IZVPfLOYDkw8Ey6TXo0m8OlL+10KXDFhnNK/63lz4N4nRNegoUI2p45NwCSefQ4QT3gBIL6aPo6sF73lFUhLBWUTUwbuCGosPr5mANDM2YksWGDCT9I1H5JxXEgJyamQGzX06k2zFKCRmqShIZA5rfFy4Uoj5tJiwyLQV7fpf/SNbztefbxqEJ7kFS+utWTYoxADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DH7tInMaX571eFowTP2x20fCXJI2RElkAMJFqS69Wak=;
 b=X0BS9ChmXNiUIbevrVOvJ94Nnu1fi+dOsSGMXNZK6qHX1ZUQvN7QGQOrNpotrpzmmoz9q6MKTY8nlL5QbJUBgkPN53xUEvFGrpHW30HbVStKxXKS2M9xQH3csCWTsCrm5zMmjKVZxnuupS6Sbi/O05ChDGuuqmYlZ54c2CFMllEv0N980mpWmB8FyxiUv3xUEJIj6kV5sQdEZPOap32zd98EFhSc5ab27xMLeORpcttSv8qFYCxz3ZdDRXK0sqOPYg1fbhi7aLXMn6eJSQi2LOcxvtON0YyWgqa3zpzd+bcvVcVJvMyQnGQVanK6j+jSHmMO1I81XgEparQ7n/fTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DH7tInMaX571eFowTP2x20fCXJI2RElkAMJFqS69Wak=;
 b=05UltIxMR0FlAqFXizpDVv6zbkpOYfo4e/YC8ZJGlF7xYdEpKzgslLqbIR2VE5r+kMq850RxsmCIlsZphnYdwcyBTeW1v5q1qs9ZooPWOvHQgS4eKtvBZSA7GtdMqEE9ladKXjrZXE3hM1xQYkMffT9HYrGnjyi+ntXQa5n71ZM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1303.namprd12.prod.outlook.com (2603:10b6:903:40::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 19:09:50 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::135:b45b:bf4c:e3]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::135:b45b:bf4c:e3%10]) with mapi id 15.20.3131.025; Fri, 26 Jun 2020
 19:09:50 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        John Allen <john.allen@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v2] crypto: ccp - Update CCP driver maintainer information
Date:   Fri, 26 Jun 2020 14:09:39 -0500
Message-Id: <0a2a04b15abc35af1ec651b3f45d43365e286ac4.1593198579.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR15CA0029.namprd15.prod.outlook.com
 (2603:10b6:4:4b::15) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR15CA0029.namprd15.prod.outlook.com (2603:10b6:4:4b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24 via Frontend Transport; Fri, 26 Jun 2020 19:09:50 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f969e45-40bb-43b0-777d-08d81a04801e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB13034E5853EFB7D9F34C2A68EC930@CY4PR12MB1303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZBUHxkmHnXsRrrRZ/5XpU5E+36ZoJcP+DmEYm2snvIPHu+U/wGhUfJrbNmD3ssmmDlXC6aCIRx6Yvz7V/0Lcet2I9uhRJVL7JDLZuM61h0+ikIZBkisLeeLFG8qUbQ24it+WheCrSf9DdcyxosBfyuJyvO1jGk0cyi/oExdQJ+g/WgwJLNMt4GTsASmoA49HNr3bO4X0O62vBPM0QESnJ6Py8lDoXfuw3X2fePkhV4gPZqtGdzZ3EiFzv+FGFYQbUWIPeJqLDQQYobHA+uPA9/jZGZlcrAiEAqL5yLAQSxzAvqtSyijmBOWwSpf5OT1foT/RewrwjZtst7MoqEnybqUwKRWPSB5WnhXpzJOmAW5pvyWxXvmUuNK0gGKS07Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(478600001)(8936002)(8676002)(26005)(36756003)(4326008)(7696005)(52116002)(2906002)(5660300002)(956004)(2616005)(6666004)(54906003)(6486002)(186003)(16526019)(66946007)(66556008)(316002)(66476007)(86362001)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5r+MKOsHQE7tVFTLdziaK0cRx5KWCQbQV20hJe5xWhM4llLSD5Y2fG2LjGu7n8gf9knP5rfVgYcBJQWw3anbGSEbuOUApw/+CaQsG026y3FHO3vTmsU1tpzfXEicYOQZWuiYbjyIUxd40cfhargx2pJEUqDgtA+NWrZPVkku9w4iRL+XzKtDBxh8MAYCm5yMgKOK4rlctFZPb7E3uInZCc7FhOvKG9FK42SYufcdOl2MX80X4+HIEA/b4jIPpBQ05jdGHO21nKaEFdFDStj+NDvCAvtEiHzXCBSHclwPpcLslsrb8y52/gqEHjKl2JNGJbTW+am6IlnlPFl25Lrlo4Mv4rNdpM23ddT86C/toUjp3qB5iNoWz+KWWPYr43XH50C8+HcE64gqjYWGLrhbLq+OJk6K6Fu3DWEu9LNLBRlZnKtG78SUCdvA/AjKJaCQmdeXOQAVxEE8ikux/TpubbPLutkykSDtC7NoeM0yHRM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f969e45-40bb-43b0-777d-08d81a04801e
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 19:09:50.6745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GC7Pu+6q5/sNbdQjXBe2cNC2S/EaL2nk15zOW/I29V3dpyaPFXjUVKNj3L0Uw7nlgggA3oNfBIzzqJsTwpDWHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1303
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add John Allen as a new CCP driver maintainer. Additionally, break out
the driver SEV support and create a new maintainer entry, with Brijesh
Singh and Tom Lendacky as maintainers.

Cc: John Allen <john.allen@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---

Changes from v1:
- Change the email for Brijesh. The previous one is an alias, use the
  proper email address in case the alias is ever removed.
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 68f21d46614c..de266ca5f921 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -830,11 +830,20 @@ F:	include/uapi/rdma/efa-abi.h
 
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
+M:	John Allen <john.allen@amd.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/ccp/
 F:	include/linux/ccp.h
 
+AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
+M:	Brijesh Singh <brijesh.singh@amd.com>
+M:	Tom Lendacky <thomas.lendacky@amd.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/ccp/sev*
+F:	include/uapi/linux/psp-sev.h
+
 AMD DISPLAY CORE
 M:	Harry Wentland <harry.wentland@amd.com>
 M:	Leo Li <sunpeng.li@amd.com>
-- 
2.27.0

