Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DCEC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 00:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D320E2176D
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 00:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="pPgaQxqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfLRASH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 19:18:07 -0500
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:2145
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbfLRASH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 19:18:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWqcOv/d6rqzcCBL9/aM9v3vfr+o7rJyx0zmvzSVpHalHJnid+2CTvSizAhGbbwHWwq6o1QDSZGrGxxc7gdUkaiiVJ24orrUxJicOJmcXHOZsQd9l+NTkwxf662mjBGFEpHihB/gr3pd6lJoWU1Z4IG3Gbcn+pwrn3ICQpBvF0CdgYLiJLTO20C7QTRsVSquNnM4frFSxbs26OJU+vcrWX9DVKI1Ue+JWrQKocn6jor+Vx+y1E3MMAP33G1vx+ycMIt8hBnnUl3bvhqqnRvY96iTACJ5krQjpAng/HiTys8Py43sHV1A51Enzw8Lwerl7tagKOpIWf31V6mnVLrJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HYudlir81P9YYIWw0q0zdfvqg0TRBm5/if+pndPW44=;
 b=EM3ur4yXNnnKNOYfWTVL4akjqZ4mHwQmE/gNitfC0ZKaFfRNkHnasa7puVzpKNfsFAxG8NyG8hdL1m72+w+OTF9ua8xVwEFQuJbGS4JDN+6MQNKTOAcJPmCWB/tqFwFo+kkQG/AkMyDVkzbklA8sb0yyYrHwTdUhYaUH0ib40SfnY+OmRzhPFLFRygUNkBsIfxW6yab6/NWzIUdLEFifLw5/FGZ3LOR6qI1M2kQcWHxwbEZtUJ5di6F8qGTFXtWm6sp1IwiOIufWo/ZDZcVH3TjBZRcHuqNMnau0HM/nk9QxBHqCTt7KymKI73slFAJ1albD82lzq7yT7y77QEqb/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HYudlir81P9YYIWw0q0zdfvqg0TRBm5/if+pndPW44=;
 b=pPgaQxqtldpacqFWTOm/OfyV79Yv3u5VXEQIeSjkoFcmdcHp/CECD+9o2kYmaumC+40OZSYEU2tzNw4Iz+94oLs7n9ZcLhRNTWUenqLBQnEaHFuMX6OUIS6ex9WEp0R1x5G95s/RULZ9OKDldTQ/ZyxytNsi1ivbo5ZRUfNeOPo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2342.namprd12.prod.outlook.com (52.132.208.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 00:18:02 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61%5]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 00:18:02 +0000
Subject: Re: [RFC PATCH v3 1/6] crypto: ccp - rename psp-dev files to sev-dev
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
 <57c6797e99b1f62ff13222c8f0ee4687e8617a48.1575438845.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <78c28a44-dbec-07c5-9f9b-133d4d9df5f0@amd.com>
Date:   Tue, 17 Dec 2019 18:18:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <57c6797e99b1f62ff13222c8f0ee4687e8617a48.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0045.prod.exchangelabs.com (2603:10b6:800::13) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ce79aa8-ca93-46dd-3ba1-08d7834fbebd
X-MS-TrafficTypeDiagnostic: DM5PR12MB2342:|DM5PR12MB2342:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB23425786BD955118D1F9F952FD530@DM5PR12MB2342.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0255DF69B9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(189003)(199004)(6486002)(8936002)(2906002)(316002)(81166006)(81156014)(52116002)(8676002)(110136005)(66556008)(66476007)(5660300002)(4326008)(36756003)(6512007)(66946007)(86362001)(478600001)(31686004)(186003)(26005)(6506007)(54906003)(31696002)(53546011)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2342;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydxieSke7mLMlYFpMEBAoiepK98LNV3FG5xpL145q9sqYTEPS5Y/gjqxcoXNWd6SM49JiiLcQZRzQbzBlYIB9w7IWeOPb6bMAwKBDRFgqk8i16H4nDv/UqN7vc5HWP2PiX1wbnK5siX0SCxaM7SFnpMR7zF8ylyeGZbgv0WdldKm0nkfNayWX3utbECZJ5i1Fvv7Idfm78QVJx1tNNoOkTfCNyj8gXWvLMlrqnNIvoJAmr6GfbbaHhPPEVWIWoZN8BlhUCOcKqrqLuoI94DvSExZMnscJl0nWInaYpjctiWNHJHEE3kE3SxWT4nsHvh30U4djr+YumAJ3zLNu22GdRpJE4V2FqbjSwE8zDn0ahLqiYXNXtrn4t54co1IH43HFVwrwjQfj2By9bw52EgOiIgJo/13GZKVkMiPC7PTMHD9soZ08KWBO0tnw8DnRxHa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce79aa8-ca93-46dd-3ba1-08d7834fbebd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2019 00:18:02.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmKIQOewhP9tgvCHBJQ/v0zwwpVvgK6tNB+XyEv2PKWzsKYrs2vutvwLHXaRUjOw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2342
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

Minor nit, for next time: the copyright dates should be <first 
year>,<current year>. I got this wrong the last time I updated it. :-(

The change above, for sev-dev.c, is correct.

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

