Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9C0C2D0CE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F3921744
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 06:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="4XBpeG9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfL0GUB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 01:20:01 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:35118
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfL0GUA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 01:20:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/8ds/7porKPlDANNPewiD0Q2vRv+hZY+3vvFO3iIwVZF6zN9wPhtMMQUJW/9mTnm1O7hH3I4fqvKU8VkxkUPoicCs60qrrH6klqN/vTInCqeshSNFz4skEoL6LwQ0F1ugbuCGlWVr6WMIboZMy55QNf1bNjkXbm9OMyj+wsIDEZinLtnRFTx/CPrYeCBJymymFBuuw9427gutY5cRwMYkyBT22JJDKiBuPWuxcFL/VeCaxGDPmYQ0jeoDoGbxv/u4u2SSkMECoaiWWhxHol8iFePYf8An14qgzsu1F2CbhQlGBsczfxJuVO6AUfkXHH8B4l61bDw5A4vn5vLfunTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+B8J45YslOQPoE43m6M2aiHKuxqBYtbNYkdUp/M3ns=;
 b=FEGHblghqHjXxm5kKY6SdcUsC8IG7OZzi9l09aNb0G5dVLNNYxgrqWFBSLJCPLCAckvV61wbE/2bldxv0ryUdTMLP7u7Cv0Huv15Kg3aUx0GTTq4FO7+a4GUMzSjUH+YL7ZuhGoNCdHtD3VEB0IQAj7qP2hlQ4t+Rk3gxZY6aU/fIR3UXPQPqo8p1rPYEOM/aWSC2//tZVdBFz+9vQxGULAUQSXzL6NeS2/cJZLSDmbwSEsBVxulW7hMg9q4gjuVoN+i3jX2H1ARka7OWdu8J2JByLsv07aIua7LedTDkmJqBpwmJ3NtnqYJEYcE+UO3Ir9jqVsn009giqI5g3iuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+B8J45YslOQPoE43m6M2aiHKuxqBYtbNYkdUp/M3ns=;
 b=4XBpeG9JlXDfe+a4q7lOt+4XyIk6Do42rZCrjzpb1vSNqFA0dc66yXFro2Fcx+2A+FRcZSnX/ha7pHNxODxMSmSKU110HBq3Hg88Fg+ivx1Ykq03EjArUmaD+kb89O7Wriz25MJtlnHWOp9KwEPrRxp3HEs5XZUt0wA66mpol6g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1366.namprd12.prod.outlook.com (10.168.168.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 06:19:51 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 06:19:51 +0000
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
Subject: [PATCH 0/4] TEE driver for AMD APUs
Date:   Fri, 27 Dec 2019 10:53:59 +0530
Message-Id: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::32) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from andbang1.amd.com (165.204.156.251) by MA1PR0101CA0022.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 06:19:47 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f69ea735-daf5-4bb3-503e-08d78a94c7dc
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:|CY4PR12MB1366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB13664F52A2BFCD5CF629253CCF2A0@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(189003)(199004)(81166006)(110136005)(316002)(8676002)(66556008)(478600001)(6486002)(66946007)(5660300002)(186003)(26005)(8936002)(2906002)(81156014)(966005)(54906003)(66476007)(956004)(4326008)(86362001)(2616005)(6666004)(52116002)(16526019)(7696005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1366;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UqNmycvFc8lffPhH+ZU5HE2VRQIoHqK4g0uB4tQjXgfIBGP0VCPqrmdfm7arnUPaEZOl2pK6egTHhQckC6/HJHGIuB8yMGF13xx7ffu3U6XA36dR0890pdxxG61R3yBINoCaEoW5J6CFIg1ez7y58uUaOhlpkqze1fi2KJ5KErq0QepRWWm6CJpy0UWJqzVy6gM9jk9mn8zZd+Z7nQRiOk0zCVdKGJsm9eWqljbNICwXJ535mOUNP+RsL/RHDt3aovYoryrALHxpAukiZ0/GgHqxhlTgzNxU3EkJhs6AvLpMGlHn5xnZ5LcfmXeV0y8CdNYXpzgDKXO7ts01cDmszvNXacyILJxxTMdId/StSmuW61y9U7zjinGbhFpELlxr9P6NjdkXzeXf6uMM5IiSJneog8JOkqbHzyQw3KruQUQnKT2pvCh7qa02sfrs84Ukm+pISrfsoiXz878hLhjc5biUNIhvsLHFAgQsBkbuilM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f69ea735-daf5-4bb3-503e-08d78a94c7dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 06:19:51.4199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/0g0NEbCwXXZ8pwe/qKfkUGC1J6mJnKJQlrWE6WqiZoG58yTDsU+KGOzSo1nPX4mJHo3UOR9PQNtkbu9r2iYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series introduces Trusted Execution Environment (TEE) driver
for AMD APU enabled systems. The TEE is a secure area of a processor which
ensures that sensitive data is stored, processed and protected in an
isolated and trusted environment. The AMD Secure Processor is a dedicated
processor which provides TEE to enable HW platform security. It offers
protection against software attacks generated in Rich Operating
System (Rich OS) such as Linux running on x86. The AMD-TEE Trusted OS
running on AMD Secure Processor allows loading and execution of security
sensitive applications called Trusted Applications (TAs). An example of
a TA would be a DRM (Digital Rights Management) TA written to enforce
content protection.

Linux already provides a tee subsystem, which is described in [1]. The tee
subsystem provides a generic TEE ioctl interface which can be used by user
space to talk to a TEE driver. AMD-TEE driver registers with tee subsystem
and implements tee function callbacks in an AMD platform specific manner.

The following TEE commands are recognized by AMD-TEE Trusted OS:
1. TEE_CMD_ID_LOAD_TA : Load Trusted Application (TA) binary into TEE
   environment
2. TEE_CMD_ID_UNLOAD_TA : Unload TA binary from TEE environment
3. TEE_CMD_ID_OPEN_SESSION : Open session with loaded TA
4. TEE_CMD_ID_CLOSE_SESSION : Close session with loaded TA
5. TEE_CMD_ID_INVOKE_CMD : Invoke a command with loaded TA
6. TEE_CMD_ID_MAP_SHARED_MEM : Map shared memory
7. TEE_CMD_ID_UNMAP_SHARED_MEM : Unmap shared memory

Each command has its own payload format. The AMD-TEE driver creates a
command buffer payload for submission to AMD-TEE Trusted OS. The driver
uses the services of AMD Secure Processor driver to submit commands
to the Trusted OS. Further details can be found in [1].

This patch series is based on cryptodev-2.6 tree with base commit
c6d633a92749 (crypto: algapi - make unregistration functions return void).

[1] https://www.kernel.org/doc/Documentation/tee.txt

Rijo Thomas (4):
  tee: allow compilation of tee subsystem for AMD CPUs
  tee: add AMD-TEE driver
  tee: amdtee: check TEE status during driver initialization
  Documentation: tee: add AMD-TEE driver details

 Documentation/tee.txt               |  81 ++++++
 drivers/crypto/ccp/tee-dev.c        |  11 +
 drivers/tee/Kconfig                 |   4 +-
 drivers/tee/Makefile                |   1 +
 drivers/tee/amdtee/Kconfig          |   8 +
 drivers/tee/amdtee/Makefile         |   5 +
 drivers/tee/amdtee/amdtee_if.h      | 183 +++++++++++++
 drivers/tee/amdtee/amdtee_private.h | 159 +++++++++++
 drivers/tee/amdtee/call.c           | 373 ++++++++++++++++++++++++++
 drivers/tee/amdtee/core.c           | 516 ++++++++++++++++++++++++++++++++++++
 drivers/tee/amdtee/shm_pool.c       |  93 +++++++
 include/linux/psp-tee.h             |  18 ++
 include/uapi/linux/tee.h            |   1 +
 13 files changed, 1451 insertions(+), 2 deletions(-)
 create mode 100644 drivers/tee/amdtee/Kconfig
 create mode 100644 drivers/tee/amdtee/Makefile
 create mode 100644 drivers/tee/amdtee/amdtee_if.h
 create mode 100644 drivers/tee/amdtee/amdtee_private.h
 create mode 100644 drivers/tee/amdtee/call.c
 create mode 100644 drivers/tee/amdtee/core.c
 create mode 100644 drivers/tee/amdtee/shm_pool.c

-- 
1.9.1

