Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7C9C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F71420640
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 07:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="n7O0ZN76"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfLDHLh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 02:11:37 -0500
Received: from mail-eopbgr680074.outbound.protection.outlook.com ([40.107.68.74]:51470
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbfLDHLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 02:11:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGteV2PxuQyQy7FgoDDbtmlwGcJb2HUTOiWWXirXRnkpyQrQEkRIWd8CnN0x+vR13wDZvDTbKuh7tAThyoxDDtFvWyTlzoWHqP4mO+oNSy3Sdo6I7WloxgC7ygG3JTvusI5UFJUM7ErVsqYTg8lIhDVWOTpxKFMV/9UO7iePKRVCRuaNuhX+UCeZnrj59PZ285gTsDBxI8QR4cV0T+ddnfqF9i5Agl0Kgye+46Vwf3iBcshpAWRsEP2BEqKjCdisf0cAwDyDAhzrQT/qBXXR9f5t7RENgPLEkMfNdjYTfknDJKe/Z7ppNx9syjE+1VJVGRUQ3mNj8MSTW6Jxsb0ueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISyUCZL8RpTJ1zgQiaPCB/kDas2VKZifHvvznAdk6AE=;
 b=oHyXjr15C/FWyUIjQ6cIYB12333PRlcreg8HS2/RPQTjxb4xvc1CZ+/wiqP/u846fYYpRcF3Ewev15+7Hi62lUqzoRk+VXH7SwHy1jtScxlaDLEItH7sibv04/i1N1T4hVkdwnBA4V4y0tGl0WTKsXl9Mv2Kfx8OyoeaEPZxHSHBfjIJIwBg7Natvz00CkLgwUHYrTN+z07YIhDWCQdSrnBAbeJHJ1ZVfnE9xm/4e+mnurBXnsXg13/2PmkqWfn9j3V+m2fL5ief7GEELqjr3X9OUqE2HZqNX4CyFK9WCYnNMiHFAh/lHkCxG4wT+0drr8dzgQjNiyc2ZSa6SPZQtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISyUCZL8RpTJ1zgQiaPCB/kDas2VKZifHvvznAdk6AE=;
 b=n7O0ZN76lm1vastHlIXelrP1eu8db2NQSTs5ENf0HY5gbpFnir7ha4K1roW/YogEwJommMW5unNkaHgGLkD72AnzoVMWxfHjAGMHuESUzB83qR9PQ6E3Jaleb7MIDaL+188j8lgb9P2emRqFGHky5l2fLbjrHKdswEoUzfu3KDc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1400.namprd12.prod.outlook.com (10.168.165.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 07:11:34 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 07:11:34 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v3 0/6] Add TEE interface support to AMD Secure Processor driver
Date:   Wed,  4 Dec 2019 11:48:57 +0530
Message-Id: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0065.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::27) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 375bf922-5d02-4a9d-0aaf-08d778893197
X-MS-TrafficTypeDiagnostic: CY4PR12MB1400:|CY4PR12MB1400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1400B9EB9474EEF51789D5DACF5D0@CY4PR12MB1400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(2616005)(66556008)(2906002)(66476007)(50466002)(48376002)(478600001)(14454004)(50226002)(36756003)(81156014)(26005)(54906003)(110136005)(81166006)(3846002)(66946007)(8936002)(8676002)(5660300002)(6486002)(6116002)(386003)(186003)(6436002)(4326008)(99286004)(25786009)(6506007)(14444005)(16586007)(316002)(86362001)(52116002)(7736002)(51416003)(6666004)(6512007)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1400;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i6rziHalWpc7pIdR59QBqdqD1jTYn9VP8TFy+P+lTNMAwFRS/eRnudoywsF2Vg0ZnkezmiUHsf2V/GnVlyyljoSICC2UmrYohFsn8qPYRaRQ3cvfQwC+e0xwO5xfY0Qb08NJAKnzYcME80wGvV6iYW3muyZaG7Gc/2jM2GcEAddmG+XoTy3TSQIwVurfoGeWUKxKCEKaQJdZkIkmowYqts9EwbJ2o3DWgZu8boHYax5BobK/OAiETl10W5rR6c7HKy/YFIVWO382nTywT4QV1RA1LlQyp90bPUDnzyh6L19SlPI66A2JbwXmTASUrzpmWzwo71I7OPVbZ7TWxXUcArM0/3WlLsAkO2jix6PWz4DsBGmvT3XbgWcg4ZK8oSL2UWlrvHnVLfttsEKVVrfVb9h1iuN05r+lSvDnBSDNXEadu42J39Q0kMQ6FOKi62Bm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375bf922-5d02-4a9d-0aaf-08d778893197
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 07:11:33.9387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +DUgwjVakkZqwmoLS/iIga9bcrWv8XbsopIsHdXhGMRXVLrMSxLe5udRWkWSGF2Afxv/gcHwutBMjkmH4lVfUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1400
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The goal of this patch series is to introduce TEE (Trusted Execution
Environment) interface support to AMD Secure Processor driver. The
TEE is a secure area of a processor which ensures that sensitive data
is stored, processed and protected in an isolated and trusted
environment. The Platform Security Processor (PSP) is a dedicated
processor which provides TEE to enable HW platform security. It offers
protection against software attacks generated in Rich Operating System
(Rich OS) such as Linux running on x86.

Based on the platform feature support, the PSP is capable of supporting
either SEV (Secure Encrypted Virtualization) and/or TEE. The first three
patches in this series is about moving SEV specific functions and data
structures from PSP device driver file to a dedicated SEV interface
driver file. The last two patches add TEE interface support to AMD
Secure Processor driver. This TEE interface will be used by AMD-TEE
driver to submit command buffers for processing in PSP Trusted Execution
Environment.

v3:
* Rebased the patches onto cryptodev-2.6 tree with base commit
  4ee812f6143d (crypto: vmx - Avoid weird build failures)

v2:
* Rebased the patches on cryptodev-2.6 tree with base commit
  d158367682cd (crypto: atmel - Fix selection of CRYPTO_AUTHENC)
* Regenerated patch with correct diff-stat to show file rename
* Used Co-developed-by: tag to give proper credit to co-author

Rijo Thomas (6):
  crypto: ccp - rename psp-dev files to sev-dev
  crypto: ccp - create a generic psp-dev file
  crypto: ccp - move SEV vdata to a dedicated data structure
  crypto: ccp - check whether PSP supports SEV or TEE before
    initialization
  crypto: ccp - add TEE support for Raven Ridge
  crypto: ccp - provide in-kernel API to submit TEE commands

 drivers/crypto/ccp/Makefile  |    4 +-
 drivers/crypto/ccp/psp-dev.c | 1033 ++++------------------------------------
 drivers/crypto/ccp/psp-dev.h |   51 +-
 drivers/crypto/ccp/sev-dev.c | 1068 ++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   63 +++
 drivers/crypto/ccp/sp-dev.h  |   17 +-
 drivers/crypto/ccp/sp-pci.c  |   43 +-
 drivers/crypto/ccp/tee-dev.c |  364 ++++++++++++++
 drivers/crypto/ccp/tee-dev.h |  110 +++++
 include/linux/psp-tee.h      |   73 +++
 10 files changed, 1842 insertions(+), 984 deletions(-)
 create mode 100644 drivers/crypto/ccp/sev-dev.c
 create mode 100644 drivers/crypto/ccp/sev-dev.h
 create mode 100644 drivers/crypto/ccp/tee-dev.c
 create mode 100644 drivers/crypto/ccp/tee-dev.h
 create mode 100644 include/linux/psp-tee.h

--
1.9.1

