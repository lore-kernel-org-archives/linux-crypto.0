Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4800EC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EF2B24679
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="TFLIfnI7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLSW4L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:56:11 -0500
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:47393
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbfLSW4L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 17:56:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH9mHsMQR5f1QuhTFBeYz7n6LWtSTUeVxZFtfDQkVHuBQpfdtiCuSQRp0quT6uo8GSB76MOyuYs0yiv/s1Lnw08IB6vi4Ke3DWkBocekpBenpsFZ/0ypa2VcCS84MIKK2/I31nT8u06qBFo53A1ym8uKBEkjch7hIGWXJzmJZmmrE6aNDIG4sLEQQZgqFLqLEjzmg8fJE7UdOtAjIrHyU5VB72CJaPJ/PU/39o4lfHlWsL/gXWqUKwH8lP7CLxFSW5YIqLUJOUMWOjLfd3e2AANqs3/07IK7jikdJz+sOh6owiiDZ0vCX+YhorBFqkRu3k2NHIWcjI2EDhF4czUZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WW6fJEDATV3eyANmm4Tdeq9vm/D9wIuWRvSHLGAkszE=;
 b=BRa/ihB8cDnt1Q71mEeDse/9/J3ygV5V93yeyoPaZBQtZmbrG9OljC9ycxgrP2jPakD+WEYjlregexQ9oMGvrTaAxn0HsMGH4U0Z0LfZqEYNpFANsQjr9M4w39wcvstr2W5AK6fn9lPbRTpNuVg+ExXD4WBQOLtWDNLLm2U5lfvvGO6/4Auwu2IjO2i1vX7XuFUn0XBvszwvLbw+H2uqLPE4yayrJXEi3pM+19QZ1lcoYaWBrw8k/rHbLF387D4r4k6KK99k9IPWNacz7LMHe+pKmFXTR3hue2s2vCXTI1A/vyaHn30vK5KMrGQ02NprkjGlhc6mmeWtm9OcXf7i1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WW6fJEDATV3eyANmm4Tdeq9vm/D9wIuWRvSHLGAkszE=;
 b=TFLIfnI7UTtIgQQWUqtOxvHGPLAANVbYRVWVQSZNaRU1W+q8qBkY/38OOf4LIfGJvXylhFpFbrN/hwweEDHVU7nUlmfD40Gx8+Z6xEpfwBCAG3vaJty01hcsUNZFVV6yO2mLrTOlchvqeVcmL5voe0STetNEVA59/iksBA4Q2OE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2421.namprd12.prod.outlook.com (52.132.141.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Thu, 19 Dec 2019 22:56:06 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61%5]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 22:56:06 +0000
Subject: Re: [RFC PATCH v3 1/6] crypto: ccp - rename psp-dev files to sev-dev
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
 <57c6797e99b1f62ff13222c8f0ee4687e8617a48.1575438845.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <12183576-32a5-c75d-b773-9dc0b7ba15bc@amd.com>
Date:   Thu, 19 Dec 2019 16:56:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <57c6797e99b1f62ff13222c8f0ee4687e8617a48.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0072.prod.exchangelabs.com (2603:10b6:800::40) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c8c0ec2-65fa-418e-b256-08d784d6a141
X-MS-TrafficTypeDiagnostic: DM5PR12MB2421:|DM5PR12MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2421A8561995EA7F637F63BFFD520@DM5PR12MB2421.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(199004)(31686004)(8936002)(81166006)(5660300002)(66946007)(86362001)(110136005)(54906003)(53546011)(186003)(478600001)(52116002)(26005)(81156014)(6506007)(8676002)(36756003)(316002)(4326008)(2616005)(66476007)(6666004)(31696002)(2906002)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2421;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XvID1hu3NUAXNVbPBoKACPYb/M+vl8QGTR6JwPbWwtanYwfeObP9R/uvbSGo0lmQ2bQrjwODW2/phx9Pzgzo0QMXw6iG1NTUlAxSwiGwEPysn6tMVK0qrKdI84E2I1Qbx5UGX7WAehPbsdnlNd9J0jjzVdicn60rUV/l9ev8xjuWyakxPnSnXErmoHBTJDb1+H+MUSYGylITSLuyle/jPgNOH+HRpwosuME7yr8YF8Ie4AmLMGqYye6LGmWwTKaI2NqKtM1xzMR0KN+XRQ+tDkZfwVB9YFK9yzrbvMmpUoBqVf/Q20itMxd535lAA2FIvRnjKGTCHG2dNfnR/zU2zlVm1e1jZiUIkjAqxc0cTGE2aNVcp50IIMyhVdm4AESam4JGh5u8Mlwn+bo+fKKA7AgFHBp1wHmXb0lQTZcKrrLXeUtBjidP/PeHAke7NUnV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8c0ec2-65fa-418e-b256-08d784d6a141
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 22:56:06.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TndydQwWeG1h9z1q6MVdN1FymouEbaKjKItrV8u1kAPYcUPY0yEe6RasTOf+ymhx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2421
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/4/19 12:18 AM, Rijo Thomas wrote:
> This is a preliminary patch for creating a generic PSP device driver
> file, which will have support for both SEV and TEE (Trusted Execution
> Environment) interface.
> 
> This patch does not introduce any new functionality, but simply renames
> psp-dev.c and psp-dev.h files to sev-dev.c and sev-dev.h files
> respectively.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/Makefile                 | 2 +-
>   drivers/crypto/ccp/{psp-dev.c => sev-dev.c} | 6 +++---
>   drivers/crypto/ccp/{psp-dev.h => sev-dev.h} | 8 ++++----
>   drivers/crypto/ccp/sp-pci.c                 | 2 +-
>   4 files changed, 9 insertions(+), 9 deletions(-)
>   rename drivers/crypto/ccp/{psp-dev.c => sev-dev.c} (99%)
>   rename drivers/crypto/ccp/{psp-dev.h => sev-dev.h} (90%)
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 6b86f1e..9dafcf2 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -8,7 +8,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>   	    ccp-dmaengine.o
>   ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) += ccp-debugfs.o
>   ccp-$(CONFIG_PCI) += sp-pci.o
> -ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o
> +ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += sev-dev.o
>   
>   obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>   ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/sev-dev.c
> similarity index 99%
> rename from drivers/crypto/ccp/psp-dev.c
> rename to drivers/crypto/ccp/sev-dev.c
> index 5ff842c..9a8c523 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1,8 +1,8 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   /*
> - * AMD Platform Security Processor (PSP) interface
> + * AMD Secure Encrypted Virtualization (SEV) interface
>    *
> - * Copyright (C) 2016,2018 Advanced Micro Devices, Inc.
> + * Copyright (C) 2016,2019 Advanced Micro Devices, Inc.
>    *
>    * Author: Brijesh Singh <brijesh.singh@amd.com>
>    */
> @@ -22,7 +22,7 @@
>   #include <linux/firmware.h>
>   
>   #include "sp-dev.h"
> -#include "psp-dev.h"
> +#include "sev-dev.h"
>   
>   #define DEVICE_NAME		"sev"
>   #define SEV_FW_FILE		"amd/sev.fw"
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/sev-dev.h
> similarity index 90%
> rename from drivers/crypto/ccp/psp-dev.h
> rename to drivers/crypto/ccp/sev-dev.h
> index dd516b3..e861647 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -2,13 +2,13 @@
>   /*
>    * AMD Platform Security Processor (PSP) interface driver
>    *
> - * Copyright (C) 2017-2018 Advanced Micro Devices, Inc.
> + * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
>    *
>    * Author: Brijesh Singh <brijesh.singh@amd.com>
>    */
>   
> -#ifndef __PSP_DEV_H__
> -#define __PSP_DEV_H__
> +#ifndef __SEV_DEV_H__
> +#define __SEV_DEV_H__
>   
>   #include <linux/device.h>
>   #include <linux/spinlock.h>
> @@ -64,4 +64,4 @@ struct psp_device {
>   	u8 build;
>   };
>   
> -#endif /* __PSP_DEV_H */
> +#endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index b29d2e6..473cf14 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -22,7 +22,7 @@
>   #include <linux/ccp.h>
>   
>   #include "ccp-dev.h"
> -#include "psp-dev.h"
> +#include "sev-dev.h"
>   
>   #define MSIX_VECTORS			2
>   
> 

