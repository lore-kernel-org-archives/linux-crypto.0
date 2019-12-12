Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6D1C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 12:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6730722B48
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 12:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="KXqhQYlM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbfLLMeX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 07:34:23 -0500
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:6048
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729170AbfLLMeX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 07:34:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOeNBEkkbyoDL65aoqPkg/TG2RtnJJ2YrELEUhUHvYUlRaUL5PVwF5AqLPgqh808JqGK4pdF/r1Gh5Chl6aKM9b4cohTM94bJ6N6G4Ua/LuTovB4zcrJYVeKRsKYvj1cMsSVv6uVMCRDZEVbIQENtx0m3LSTgSV01l2GK1JyVChkV5Qw7HAqD8933oxCyIw1rfBiIaFG8qoeZU5KZgTmTWjvsPMzIq6W4bMey4MeUoQJbtsVKofvtPpe1OL2BQ3zSdwl54suN5siVD3wt2c3GjowR223TaKv80wU5fnKe5X9oirLgQRmWkiYhXlOeLwVlgfPK6iU/WEkfXYr/HXEVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUQpfeIDYSarxxOJ7lZR89YNELOGct65WAfmtDuodAc=;
 b=eX/7UN1e828S1Lx7FaPcuYS1bwd+At8BNunNJ3E0mmlUXVSAOOy6QY77vTvLXTp6QdXb5gWV91o2PI1yePcqcp3fLPbluP5kit+mFwH1b4Ieou5GaUHGrUOxDxKu1ukeMcdHihcB7LYcQzlXwkxRUohObDrR55nNoW0a+ssHjUNSt10wQWMGyW5CMHXMPujrMgN5wsMV6ODUuMofKq/LP1LXNqw7YX59K1Y9l2B7CH8YPM3ya5onZEnRFNDVec47StAIJolbefeB3LA0e8jcIp3IAeqz1kfTYOsp2F/zs3lW6jsvRMc75v7z0H5IHT85btkZdJlcJFiAxQd0qqIVnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUQpfeIDYSarxxOJ7lZR89YNELOGct65WAfmtDuodAc=;
 b=KXqhQYlMdBT4bJMCcJTBxPo02MaCc9wBvTn7d2C8CQ04BEGiZauubkKNoTkbxm8uBOOCBhMx7MKg3515FPNb4YV7JqSodbN0dcrYQtYY41f1kbk9q5AN/KDCAkOaQRZyUeqYtadopK6C1meQBk+TctR0lS81CeoZWlN4Bg/xanI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1575.namprd12.prod.outlook.com (10.172.71.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Thu, 12 Dec 2019 12:33:40 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::cd8b:1d7e:31c2:e8b4%7]) with mapi id 15.20.2516.018; Thu, 12 Dec 2019
 12:33:40 +0000
Subject: Re: [RFC PATCH v3 0/6] Add TEE interface support to AMD Secure
 Processor driver
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Message-ID: <26cb9589-8774-897b-4d1e-919e7ad2200f@amd.com>
Date:   Thu, 12 Dec 2019 18:03:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::14) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14a89bfa-969c-4019-9e36-08d77eff8479
X-MS-TrafficTypeDiagnostic: CY4PR12MB1575:|CY4PR12MB1575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1575355D830B4119387F6F19CF550@CY4PR12MB1575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0249EFCB0B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(36756003)(2616005)(81156014)(8936002)(66556008)(8676002)(81166006)(110136005)(6666004)(54906003)(31686004)(66946007)(316002)(6506007)(66476007)(53546011)(52116002)(4326008)(6486002)(6512007)(478600001)(31696002)(26005)(186003)(5660300002)(2906002)(966005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1575;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xS5xpqFEZpzYyqI72Wb6SlAsd42QtY1bC9Q5he8otvt/Zxuy9zrr+/kqGkxiHfEXc4sMvGwKv3EBS3UgrGEmea/EViuE1aafRRoXAkU70IzS/IYF8y3j1f/A6ubtEp66FP2OLn/xPsQdn1oOOG3KHER2HsDo8mdydIbbMdh8DGzJ2Ev0uBz7+NTfDW/6FDx/6zerafTznZKOEBpIgrnsK9m8VqPpKLJ07ax138fmBC0rsaa9Zx11eHcFRpMHHQtvIgjGH2m8swIOAC0ppDKv7sNYboeQMImBHOwUvvZvGhf1GwlqrrWaz8C4W/dxZopSuaRcX8JaHFS35VFJWu0Uq6X5M/nI0Ys99PeKQ5fnTXZ/siA1CjF9paRiB0AMpYaA7cfvS6AGmMosjlj1BWIiHvzPLw1ZmUO/ldcuFJNyzhm5w6j5bpFod9M7otccT0mA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a89bfa-969c-4019-9e36-08d77eff8479
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2019 12:33:40.2826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QhdxlKxjvQ6eQC3t6BleU0s1RqCqkbPlgcLm3YXPWeJJvieu4I+HsXTJCuAlBAMY3e0YLXJuE4CD9FK6hozJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1575
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Please let me know if you have any comment for this patch series.
Request you to consider these patches for next merge cycle.

This patch series exports an in-kernel API which will be used by
AMD-TEE driver. The patch series which introduces AMD-TEE driver can
be found at: https://lkml.org/lkml/2019/12/6/17

Thanks,
Rijo

On 04/12/19 11:48 am, Rijo Thomas wrote:
> The goal of this patch series is to introduce TEE (Trusted Execution
> Environment) interface support to AMD Secure Processor driver. The
> TEE is a secure area of a processor which ensures that sensitive data
> is stored, processed and protected in an isolated and trusted
> environment. The Platform Security Processor (PSP) is a dedicated
> processor which provides TEE to enable HW platform security. It offers
> protection against software attacks generated in Rich Operating System
> (Rich OS) such as Linux running on x86.
> 
> Based on the platform feature support, the PSP is capable of supporting
> either SEV (Secure Encrypted Virtualization) and/or TEE. The first three
> patches in this series is about moving SEV specific functions and data
> structures from PSP device driver file to a dedicated SEV interface
> driver file. The last two patches add TEE interface support to AMD
> Secure Processor driver. This TEE interface will be used by AMD-TEE
> driver to submit command buffers for processing in PSP Trusted Execution
> Environment.
> 
> v3:
> * Rebased the patches onto cryptodev-2.6 tree with base commit
>   4ee812f6143d (crypto: vmx - Avoid weird build failures)
> 
> v2:
> * Rebased the patches on cryptodev-2.6 tree with base commit
>   d158367682cd (crypto: atmel - Fix selection of CRYPTO_AUTHENC)
> * Regenerated patch with correct diff-stat to show file rename
> * Used Co-developed-by: tag to give proper credit to co-author
> 
> Rijo Thomas (6):
>   crypto: ccp - rename psp-dev files to sev-dev
>   crypto: ccp - create a generic psp-dev file
>   crypto: ccp - move SEV vdata to a dedicated data structure
>   crypto: ccp - check whether PSP supports SEV or TEE before
>     initialization
>   crypto: ccp - add TEE support for Raven Ridge
>   crypto: ccp - provide in-kernel API to submit TEE commands
> 
>  drivers/crypto/ccp/Makefile  |    4 +-
>  drivers/crypto/ccp/psp-dev.c | 1033 ++++------------------------------------
>  drivers/crypto/ccp/psp-dev.h |   51 +-
>  drivers/crypto/ccp/sev-dev.c | 1068 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   63 +++
>  drivers/crypto/ccp/sp-dev.h  |   17 +-
>  drivers/crypto/ccp/sp-pci.c  |   43 +-
>  drivers/crypto/ccp/tee-dev.c |  364 ++++++++++++++
>  drivers/crypto/ccp/tee-dev.h |  110 +++++
>  include/linux/psp-tee.h      |   73 +++
>  10 files changed, 1842 insertions(+), 984 deletions(-)
>  create mode 100644 drivers/crypto/ccp/sev-dev.c
>  create mode 100644 drivers/crypto/ccp/sev-dev.h
>  create mode 100644 drivers/crypto/ccp/tee-dev.c
>  create mode 100644 drivers/crypto/ccp/tee-dev.h
>  create mode 100644 include/linux/psp-tee.h
> 
> --
> 1.9.1
> 
