Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C472C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5656F206E0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 05:32:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="IKss/fU+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLCFcN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 00:32:13 -0500
Received: from mail-eopbgr690089.outbound.protection.outlook.com ([40.107.69.89]:35200
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfLCFcN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 00:32:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeQ6z8QD+pZNXk3ONfS/zPksgi6bYODld2V06G7iCr8b/Vkx4MotoAmAFgr+LsWKU9ebaYhjW5Apz77rsCTX6Zp55MuDWOi+Y9sQRTP9+gODQb8C6RJxErKTu7hjsfb9toIS5030X+xyokMHhp3mqWoLNfacStv2cYfOwbFCoHztkNa0d/o5wxF0w5hsYF4gfBRv33jRDtp4HSWjJoFhYahHGtkeCgIw6j+2BQ5VWoSggEAiYYRWy3yXm3I1ZAGZLtDZrq7E6GnGWBw6+u0JELo4J6jtQSx9Vg3Ujq6DFR36zq2KtFS9p69ohSq8jBHAvkWjW3baPTpQr0ohUgwAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTEEFD06D0EkWGzivoVVxvmD+yuMFI4cJFO52RLEY7M=;
 b=jtTg+eCPs00MBHYxmKZlhaG/ahK8iK2DGyPd8SNv10UNEMDezpKDgnaKLOCXOKV3EOd30XgkS3s6AUMGn1AmFj9uu/x/wNpZtn9uLJY//7To08MouxtakLOqPxYwnbUI7GMdCbUu1kW+AL8DXfBlOLyAiOELK4MoVOdUhMlzXgR1FO251zTCZDzaHm8iBeRJbD3rLfWZ55VBO+1cknVDkgOoCVercvwPzyz+orZeEsqYGK0hyNMeb3LU4G5gre52uNQS4MvMEGFIkc4QMlwUi/2cMDYdgPMZesZsEOSFYx4SMOJfq1Z2NyZPnYCKihHEvfRv5GItNoyWca1Sxyr5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTEEFD06D0EkWGzivoVVxvmD+yuMFI4cJFO52RLEY7M=;
 b=IKss/fU+myvqyB9HSdQJGQ9ICEE7HwS0RbeT29jChV+ePgKd3zyeAbE9TnEfaDy6Ftibw4CSKq7jTFklmLSxCsbZlrSE2HUtzl35uGhE5pEVuW+o2PxJMJ4/0Q8hgkC1+85jyq090nUyI8mJqHR79qgqiWFC7dALEAkeRxjbShk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1430.namprd12.prod.outlook.com (10.168.167.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Tue, 3 Dec 2019 05:32:10 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 05:32:09 +0000
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
Subject: [RFC PATCH v2 0/6] Add TEE interface support to AMD Secure Processor driver
Date:   Tue,  3 Dec 2019 10:09:15 +0530
Message-Id: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 1.9.1
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::16) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 98ff1c47-f031-4742-257f-08d777b22434
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:|CY4PR12MB1430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1430D2530248DC59B0097E97CF420@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 02408926C4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(81156014)(3846002)(50226002)(52116002)(305945005)(2616005)(186003)(316002)(110136005)(6486002)(16586007)(26005)(48376002)(66556008)(66476007)(66946007)(54906003)(14444005)(5660300002)(6666004)(478600001)(14454004)(36756003)(51416003)(8676002)(8936002)(50466002)(99286004)(386003)(6436002)(25786009)(6506007)(7736002)(47776003)(6116002)(86362001)(6512007)(2906002)(66066001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1430;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsWiK3Whcu/mMXkR/TLDdyNdhblj8xEuy8i4Pj96CSTT2tNJO8Hma4utVLWQjxOehGsxxF+9I+zL1gPClczB5pI1drpUuuzlwrnSpIfkAns3faHKRsAjbeG9hNu1nyETCEIOlJ84Kn+QQrnYgxbPlB4qCDphLEmNxJjXiCLaXCQXZilS5sThnIrK4EOUD6Hxji0czR6SDpbnfRswnK2QCS/H85plLpn1JVtZU7/XfaIYa8oO4Gbqza82rCsO46G/YYNd/v/6yWDGJTgbAjHu9N+A5Vs8wQYoDsIWwKDYRhwb6A9/eCZM/7SDrVt+VKTLObyNSYyBGH5RLjRgywdpXt/NjOzF8jtctprWaWvGKMf8o8e6yr0KVR7M3RItuCkXGQJPMngiyj1HACP4vM/DhHYAHsfM+Lx0SF5njgK6paSTpVfRxY5GAwfINfnDqXDa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ff1c47-f031-4742-257f-08d777b22434
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 05:32:09.7273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zeAkGPnKd7c1SqTE3+trEovj7Dszdd4QeJOZK6enT5fB+csNBp3zkdViuBAA8g+QlxNwySq+TiqONfi3N7B5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
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
 drivers/crypto/ccp/psp-dev.c | 1020 ++++------------------------------------
 drivers/crypto/ccp/psp-dev.h |   50 +-
 drivers/crypto/ccp/sev-dev.c | 1053 ++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   62 +++
 drivers/crypto/ccp/sp-dev.h  |   17 +-
 drivers/crypto/ccp/sp-pci.c  |   43 +-
 drivers/crypto/ccp/tee-dev.c |  364 +++++++++++++++
 drivers/crypto/ccp/tee-dev.h |  110 +++++
 include/linux/psp-tee.h      |   73 +++
 10 files changed, 1827 insertions(+), 969 deletions(-)
 create mode 100644 drivers/crypto/ccp/sev-dev.c
 create mode 100644 drivers/crypto/ccp/sev-dev.h
 create mode 100644 drivers/crypto/ccp/tee-dev.c
 create mode 100644 drivers/crypto/ccp/tee-dev.h
 create mode 100644 include/linux/psp-tee.h

--
1.9.1

