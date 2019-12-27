Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D92C2D0C3
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5B6C2173E
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="C+dz5ncZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfL0GUP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 01:20:15 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:35118
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfL0GUO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 01:20:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gu9JZCFtK4a1Or0TpqBIN7v85Lu3h1tCwdF8nL9LLUA0twiX4dm7m1Oom3p8n/wDFznITVo4zAG3p+LMJfdDsIqEGq7deI1QHzEanQod/XUynb+NisSDN+HziEF4LuLzZV22whGENWZBPXud65jY0xWuv+Fa42zS8dF/Fb5gZweGVLmrsT1QfY0Xu/GHz1SmVpUwPYR0ZTSO18BOD5sgi0n1uDGCSUPnkzZRgVE/70K6kf4ow3NVZVi8cdGgTNBUlfL4NGlC9DNdBMPHplqfQOTMycRr1O+Iw21f0Pc51iOaEH79pvwhCBjbpnGOcZ8J8IHJT1JURclRtBnGT0Wm6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/z5L72yKVgKh3dYAF2b+K7hwaaTHRjAlkF32xi0n3o=;
 b=fZxgxOKHx6bngL0p2fNGk/ee0A5AfFMDAjqiZARNUO61k6+NpBaBCwdxTAi/J8NaEmMQkUK//RL7r/VE7nkFl7NbW+V2lQARiPQvLd92pccp1px/sSzJ1eAiw+8CGg9PQagZjc33VfNN0c+EBhSdvJd18sECeyrCkjEQxgZ7YHQdlq9nUusK/FRe17wJhYCVLgP0zk6e81qGiSGsAKotufrGmeVhDZKCexvy7eGZlCVOCsBJpbLvrBlHdz4tIWlyO3Zwb5Y5svAt6OQyBw0osCEOihocu+8ibmk2QFP+6e1xOwaLclfqcy4w5Y/2+4OealUQMo5RkXtNJKvIjuRT9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/z5L72yKVgKh3dYAF2b+K7hwaaTHRjAlkF32xi0n3o=;
 b=C+dz5ncZpjfern75/rhB5h7odhaJuHCBsnGX2AqEUTR6/2Yx9XUulDyzchcWIFScHgXDo7S5JgiLEzZw1jM7Cv4Cx9xNnSEW9bvCwqR3+N8Hi2Zk+bgQEq0CSLtCLGe1aYEwpMZadgYerBmOtUIzk1NhWVYqDntzHJflYWwJidg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1366.namprd12.prod.outlook.com (10.168.168.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 06:20:07 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 06:20:07 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Subject: [PATCH 4/4] Documentation: tee: add AMD-TEE driver details
Date:   Fri, 27 Dec 2019 10:54:03 +0530
Message-Id: <25ce91ed381479fd0003d2b9670093b8c5cbf638.1577423898.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::32) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang1.amd.com (165.204.156.251) by MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 06:20:03 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 001d203f-2754-48af-6bf3-08d78a94d13f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:|CY4PR12MB1366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1366851581D77E5E7D16AFA9CF2A0@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(189003)(199004)(81166006)(110136005)(316002)(8676002)(66556008)(478600001)(6486002)(66946007)(5660300002)(186003)(26005)(8936002)(2906002)(81156014)(966005)(54906003)(66476007)(956004)(4326008)(86362001)(2616005)(52116002)(16526019)(7696005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1366;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2h+IBsvPjZnoXkD63MtdyPHVT9LZToJbYQe/ZMha2H3YMop1cDSDNT48giNC6BWWu2w9N8z/sVG0pBNh/yOofSvFr4T7OqSVuf9TyK+HsRdyFLKjAQwbeEkHlva5KEc5srSgZ2+pboOiWRFcsVrciYRzKFhNKhw4Msd+6HxDro0BLbsSkXmljH3aObFnNFrbrZGXwZffvmTLVC894UDdUT9acHRNeMe3E5ZJu1lOjsPlvJEOw1s8+Ipr5rgzfnj5EFLpnnkx20tXNKOyDMaz8+lOXVhbFG1n0zBzRenL0vUOt5+yEEzPSK/aDfPEdN8mE0C2xonK+sPwgFsLLpWvx8CVjkoB7eaylc9NARBAi/3GWMdVS31LHZkYhfkKLlUkyQwz2z7YgIWefOUTHn3AOzedQ8J3brbxjJmIuc5t9drHbdCZ5+qKn++3p5qAIEbGum42UJ4NUbflXrE6omUwTYlRpE7t16rMdro+wxhgJQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 001d203f-2754-48af-6bf3-08d78a94d13f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 06:20:07.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: moB84e99O1mzdBtVtnlJaz06RjetAUjLPaZDflxulY098vqxehrlqgGySbmE87yEjdaSJrQJiP3gaQlzP8YxAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update tee.txt with AMD-TEE driver details. The driver is written
to communicate with AMD's TEE.

Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 Documentation/tee.txt | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/tee.txt b/Documentation/tee.txt
index afacdf2..c8fad81 100644
--- a/Documentation/tee.txt
+++ b/Documentation/tee.txt
@@ -112,6 +112,83 @@ kernel are handled by the kernel driver. Other RPC messages will be forwarded to
 tee-supplicant without further involvement of the driver, except switching
 shared memory buffer representation.
 
+AMD-TEE driver
+==============
+
+The AMD-TEE driver handles the communication with AMD's TEE environment. The
+TEE environment is provided by AMD Secure Processor.
+
+The AMD Secure Processor (formerly called Platform Security Processor or PSP)
+is a dedicated processor that features ARM TrustZone technology, along with a
+software-based Trusted Execution Environment (TEE) designed to enable
+third-party Trusted Applications. This feature is currently enabled only for
+APUs.
+
+The following picture shows a high level overview of AMD-TEE::
+
+                                             |
+    x86                                      |
+                                             |
+ User space            (Kernel space)        |    AMD Secure Processor (PSP)
+ ~~~~~~~~~~            ~~~~~~~~~~~~~~        |    ~~~~~~~~~~~~~~~~~~~~~~~~~~
+                                             |
+ +--------+                                  |       +-------------+
+ | Client |                                  |       | Trusted     |
+ +--------+                                  |       | Application |
+     /\                                      |       +-------------+
+     ||                                      |             /\
+     ||                                      |             ||
+     ||                                      |             \/
+     ||                                      |         +----------+
+     ||                                      |         |   TEE    |
+     ||                                      |         | Internal |
+     \/                                      |         |   API    |
+ +---------+           +-----------+---------+         +----------+
+ | TEE     |           | TEE       | AMD-TEE |         | AMD-TEE  |
+ | Client  |           | subsystem | driver  |         | Trusted  |
+ | API     |           |           |         |         |   OS     |
+ +---------+-----------+----+------+---------+---------+----------+
+ |   Generic TEE API        |      | ASP     |      Mailbox       |
+ |   IOCTL (TEE_IOC_*)      |      | driver  | Register Protocol  |
+ +--------------------------+      +---------+--------------------+
+
+At the lowest level (in x86), the AMD Secure Processor (ASP) driver uses the
+CPU to PSP mailbox regsister to submit commands to the PSP. The format of the
+command buffer is opaque to the ASP driver. It's role is to submit commands to
+the secure processor and return results to AMD-TEE driver. The interface
+between AMD-TEE driver and AMD Secure Processor driver can be found in [6].
+
+The AMD-TEE driver packages the command buffer payload for processing in TEE.
+The command buffer format for the different TEE commands can be found in [7].
+
+The TEE commands supported by AMD-TEE Trusted OS are:
+* TEE_CMD_ID_LOAD_TA          - loads a Trusted Application (TA) binary into
+                                TEE environment.
+* TEE_CMD_ID_UNLOAD_TA        - unloads TA binary from TEE environment.
+* TEE_CMD_ID_OPEN_SESSION     - opens a session with a loaded TA.
+* TEE_CMD_ID_CLOSE_SESSION    - closes session with loaded TA
+* TEE_CMD_ID_INVOKE_CMD       - invokes a command with loaded TA
+* TEE_CMD_ID_MAP_SHARED_MEM   - maps shared memory
+* TEE_CMD_ID_UNMAP_SHARED_MEM - unmaps shared memory
+
+AMD-TEE Trusted OS is the firmware running on AMD Secure Processor.
+
+The AMD-TEE driver registers itself with TEE subsystem and implements the
+following driver function callbacks:
+
+* get_version - returns the driver implementation id and capability.
+* open - sets up the driver context data structure.
+* release - frees up driver resources.
+* open_session - loads the TA binary and opens session with loaded TA.
+* close_session -  closes session with loaded TA and unloads it.
+* invoke_func - invokes a command with loaded TA.
+
+cancel_req driver callback is not supported by AMD-TEE.
+
+The GlobalPlatform TEE Client API [5] can be used by the user space (client) to
+talk to AMD's TEE. AMD's TEE provides a secure environment for loading, opening
+a session, invoking commands and clossing session with TA.
+
 References
 ==========
 
@@ -125,3 +202,7 @@ References
 
 [5] http://www.globalplatform.org/specificationsdevice.asp look for
     "TEE Client API Specification v1.0" and click download.
+
+[6] include/linux/psp-tee.h
+
+[7] drivers/tee/amdtee/amdtee_if.h
-- 
1.9.1

