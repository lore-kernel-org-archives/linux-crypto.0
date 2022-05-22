Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7D3C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 May 2022 11:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiEVLom (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 May 2022 07:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343529AbiEVLok (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 May 2022 07:44:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A193A25E8E
        for <linux-crypto@vger.kernel.org>; Sun, 22 May 2022 04:44:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjPRwstxQkQW/ec7Qrx8rOLwUSJjJ+YygdMfbqetsGN5SDDmLqMtOp9qje+s8U0t5fjXUNxzrDNcgWEacu2xZbafxGvrip3wYqgSXHTM5H9yBBFUPj323gp8+0Ne0DIu8YEH77++e+h1x/j360cTvVH+GBS6KAYt6jpzfGd+X5shBAbHLzfaDZMbSQWGtgfsK8KMkssT3e7nHKNvxFS1qn60fZAza0lu4qXcDbpTA4YJ6Da74w2RscArtRRfwtQ7NOV8DSXrJiABN0IKW54kkAmQX5Abllw5jRNqOohRyZrUeSObS12H+vrn9p+Ivw28IdiRyanYKGd394d3rA1SNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q121TQNH3wJUxCnXYLCMoAyw2WeUAjeGBz4QW/fe4JM=;
 b=fwxumb56MnDNawyIot78LGOsq82nsRfvdkyAr2Ekk0wF8OJQnO2wMy/xyE/snPamPU4j+2Ez/DNoq3VVlhPMoBSZCZIgtvG3meTf0z1lncHw/SJClAvhT5tq2IXoVD+Hu8b78WMogQP5a6e15hRiy5XutoSUyJX4IXDwKON25f7HwgBYsy3tOh5DbLbYXsuGBoVqYDnm5zBNUs86KkWFv/iPFwj6dcEoy/0zOJFJHKJkoKidi6NkKKm8sGWZWAhao+wjM7+XhSdmynrTbvZNSkyuMM/Dzn3D7EPdNWZCCa88HT8Gn8+QvaLQLSGkTwry/WdGBrceBWSmjc+uVTVy1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q121TQNH3wJUxCnXYLCMoAyw2WeUAjeGBz4QW/fe4JM=;
 b=qmsfs6nWoCNIm3s4Yp2KF1g8+xVz4BzIfSwSTVQ8j/u3o4asDEnf4+m+j1PzQ13UFge+uDr4/OlIE6RObNbjPuhNssbKaZDEU2iRdzalbV2FYi0cio06ROS18KeM0OobfSgMa5OsdbTyr4d/Pbm9ipBNod0eNUls5mdOVql65xy7oDNw6WmIicdxjzOBrF/iL7PN64BHrxmSInCyNnmMgjwNPLzOJCSjvVOX4cvwKF3nPRHCR2r98oAvr9EnSnq4aOOLeOJp4uz/BIg6REO09ezfDnsKTHgtjN5bF+hgSG+WjiYsPpZOA4OChP7WYQlA2yXxRmpc83tC3+j6LWOfLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by IA1PR12MB6308.namprd12.prod.outlook.com (2603:10b6:208:3e4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Sun, 22 May
 2022 11:44:30 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::b3:bdef:2db6:d64e]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::b3:bdef:2db6:d64e%8]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 11:44:30 +0000
Message-ID: <e13a0c12-362d-e4b6-c558-03367815264b@nvidia.com>
Date:   Sun, 22 May 2022 14:44:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20220518112234.24264-1-hare@suse.de>
 <20220518112234.24264-10-hare@suse.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20220518112234.24264-10-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0499.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::18) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0195414e-a784-4e3b-4668-08da3be86e99
X-MS-TrafficTypeDiagnostic: IA1PR12MB6308:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB63085AB83D224175F7E7C77BDED59@IA1PR12MB6308.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P6d3OuwqILN8VAeWCeI+pYDxn8tBYMvDhliSMH94cVvBDE2E0J3IB39UCiDgD5O66747dpxLglXvKZewZBVguhANN25eZ3RFhrB0TCgIhqMUWmBSjisREOLwtZ8ilOcBHeQarjopPnHjHlqI0zozwKZu62lrpKuwJIe79Htx6RbgKxI0V6kbhitqCuW4xtdxf7wSbuwGmanFkYbaub0xLRCwuxIUNJC2ZzSO8t/RE+Fsawdp+9ULxgMMZZAzirB57lkYJETIyqTPqSY1l7WXlCrSTXFyVGGQMNIlY+NWhWg7rQKpWemo1wsBqZ44hAhN/JrPm3No21/w8ByGz8hPARfQYWHKle4abqKvsezCv0z1uko4pIqrE3O8vuS98bKTGIBNAkKkbLhQFzSVwT2p8e7SSI9ugKgbCgQvPIceOWCQJ+j/Z1qqUeJmPpqu+6Oh0m9oxktc7zZStDdTgHwl2cAXsPld1Y+9SuCHoiSxqxclXQzfA6bzobvawJe1bBSoUvZv3tO7KF4TC0lYDjCXHc0TQxHNRx9LgGD3aR0MFepSLOLOTXTTo2I5FOIZthcveU6e+akKejAw4QrT83OeXigONEdiugboGxOS9QErNHd5yhHJk237V3qjwcK/yRh5ZcCFWmH/LMdRHFrHJSfRnmDrl/7/JfQzqR3yHPdbJzoRlV42TaPwLewCQi7z28JjSk26FbePi6QOZdDxTXPh0CYQLOZ+pmMzyR3pNtwVS7Eb1qG5YRiL2HYTEW2crWHa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6512007)(2616005)(83380400001)(6506007)(36756003)(4326008)(8676002)(66476007)(66556008)(66946007)(31686004)(53546011)(508600001)(6486002)(6666004)(186003)(54906003)(110136005)(316002)(2906002)(38100700002)(86362001)(31696002)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGQvTmpLaWhBVEczZlRCaFp1MURlR3RTb2k0MTl2MDFEeVdGYWxvZklzbldv?=
 =?utf-8?B?Z3ovTUFpQmtLaUkvM2pXc1FlUENXOEVJMjU4RzFSeVNlQVI4REVWdURXSnZJ?=
 =?utf-8?B?UHROM1pzSVpuT0Q4R0pGN2dyQ3RFc0YxbWRabHJBMW9KVGR5VkU2QVVHRHUv?=
 =?utf-8?B?Ly9OSVpTMVBsUHpRZkVDc0N5L2M0MWpqdk1xbUlMODR3QXZaYllSeWFlV0ly?=
 =?utf-8?B?VG9WSVZBYnA3WFNPZjBtdklldkduVS9Hb2x5d1Vxcjg3OFpqNkNwYjg2Z20y?=
 =?utf-8?B?UW00bTRHa2czWllOOUg0U1Zyc3NuVHFoYkZTUjMrbGNlL3BPcGpMTmFvWnBL?=
 =?utf-8?B?SWFmdHVzYW1ickVHYUV2c1NHOEZTVVFnckRIdkNhWUd3OSt2SFAzeGZ6S2Iz?=
 =?utf-8?B?aDRrUlhNViswYmdtNUo0UUp1cVVmRDVxN1pDNm5TWi9CRW8rZm9wc0dQdEJG?=
 =?utf-8?B?amMrN25pb1U1N0Z3MXpUOHVQTzVDTDdUMmRYbTQyMUtzREhSYnErRmwyMXkr?=
 =?utf-8?B?UWZlZ2VNNW15bFF3b2UxVWdXQmY3SEQ4UFZDaHZWb3ZJSEpYa3BOZHlIdlhv?=
 =?utf-8?B?bG0xeElBWk9Oa050ajdiTDBGZVdnUUJmbnBtUzdSbXhGREtPM21PWWFON3My?=
 =?utf-8?B?YW5ieEZWY0JldDNRdkhSSUhPZDM2dnJ2RGdzZ3dPMEFIQy9LSXhqeEIxS25r?=
 =?utf-8?B?cUVBcEp2N0NVTy9uOFVDVVVKclVwWTFHWGlqSG1aOWRHMk96bHFhZ01IQ0NZ?=
 =?utf-8?B?bkErRDFZSWc0a1F1d0dYYVdXc1czQkhRODFhWnhEbGxDa09oNnVPd2J1b001?=
 =?utf-8?B?eC9oK251RzIrYXp5VUw4ZEl0UlhyQnhZR21vK1kzTWptaysvSmdPZFZBa0Yz?=
 =?utf-8?B?Vm90R05pNkI3MExmemd0N0krdEM3N2F3SnhtdFh2SUM3LzFZYWswTUtuVjlR?=
 =?utf-8?B?MTFGQjRTMDlpTXBOOUtCUXJPYStKcjZPVVR5Qk9KOWJza1N4ZENyY2VIQlp4?=
 =?utf-8?B?T1lvWURKV3lJVDhoNFNEbmNtTEIvaDNBTVZPVXZaMnVmYzF0cWF0eGFBQmQr?=
 =?utf-8?B?U0ROMElZOW5pZGtDMXZOQ0VsRDdXa1JUbHdPZHEzcWFKQkFtTUlBUXgvTVlW?=
 =?utf-8?B?T01PVEtVSlJtYldheHZ0TzV5SnZmaEFHMU0xbnBCM3V3aER1ZnRjOUN1R25B?=
 =?utf-8?B?eDRvMlR1RzF5UmtzWUMweXdUY3Rka0l4dEQxeUFmVjQyclVtcjF4dnBhTTVw?=
 =?utf-8?B?TGZ6b3lzT1ZVMkw4eVFDVjZpb0dYeEpCbjI1OTZwRE9QcEpBazNkZkF2T2FT?=
 =?utf-8?B?bHQ3blplcjYyd3NLVWt0clU2VzBGYUcyb0NSM1V2RWlUbkpENXNYcmMrbStU?=
 =?utf-8?B?SElDeVE5UHBqa0R4dldxSGtrTElmM0ZQTG1LdGJBTUZTbFBpZmtUZHhsOUlH?=
 =?utf-8?B?UGhrMzE4SjVZbUpBNC9aOXVkSU1qc0ZYbG43elh5MHpqelU5dU01d2xOYXlO?=
 =?utf-8?B?aHA5cjh0S0VmbVYxZWVRZ1IrNEdWWThITGRBN0JSVlJleWU0Y3gyck9nOTJa?=
 =?utf-8?B?a2VucFFMZjI5YjdITU9RVWRIejNjck9oeXE1SjJ3RDNpNVA3ZStwZWVrRTBl?=
 =?utf-8?B?NDRMZVhzY1pmZ1A5YjBPd0lRNWN4d0piQWR6YS9IR2FhQXdnbWVaaHRXNzB1?=
 =?utf-8?B?czI1RjRIb1pSV2t1WmtGbncxcVA2ZTZrK29scXNvYXR4WmVIMXJocHd3V2N5?=
 =?utf-8?B?TTZHZ3VBRWVmcG16ZVJZVXVoUUxpOWpuSTdmV0xkR2gyQTI3TGN4RFhYRkZy?=
 =?utf-8?B?SE5VcGpOZkFNRTJYV0RqcC9ucVRNckVWTURiUUkzUDJFd1FLY3d1NDhEZUh5?=
 =?utf-8?B?THVDZjZpbnQ1UCtTOFdMK2h6ZWRLOWtrUm4wVjFUS3phTlkybjRWOWtPYXRT?=
 =?utf-8?B?Q2tyVm1Lek9EdTBNT0lBNHZzNmR2WmkrWDUza0RoNm9mTjgxQUJra3lIY0o0?=
 =?utf-8?B?U3B2QTlwUnUrcVVESHJ3NEVLajBEaXdxWUJLKzNjV3RrMWJkR3k0dDdaaXhw?=
 =?utf-8?B?dklwZVVkMnhlOEp2b3Ftd2F1RXM1NU81VXA4Q0NkWXFwZkJkSi9BZmRHcXZv?=
 =?utf-8?B?Q2U0T1Vwc2c2RGVDZ2sxVkNSa3R3ZWN1QzlsYW9GYk9VSVcraEdET2Iwelg3?=
 =?utf-8?B?dm10RFFPRElTYUZRcVJ5L1JNZEdZUldJRHNyNU5NMDRBWVVndm1wTUVzenRk?=
 =?utf-8?B?SDJnbmRtQXE5Q1drcjFEMmlsSnlvTmVrK1ptVnJTbVFVdEpNRkRoZXJyNmhz?=
 =?utf-8?B?cFRsb3lXOVJXdDFKdExQS1lxTmRNZ2tZVnNCNG82M2JzaEJDZjE0K2IvZG51?=
 =?utf-8?Q?DgB2dnrSSpOdB6Zk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0195414e-a784-4e3b-4668-08da3be86e99
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 11:44:30.4086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YD5P1NKWAJ7HCawFyQmUbhOyjw+h4sss/wlDZrhtjsRpRTvOPtEMpK4r3son44Om3L0p1VS/RzlTj8lLZKYPgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6308
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hannes,

On 5/18/2022 2:22 PM, Hannes Reinecke wrote:
> Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
> This patch adds three additional configfs entries 'dhchap_key',
> 'dhchap_ctrl_key', and 'dhchap_hash' to the 'host' configfs directory.
> The 'dhchap_key' and 'dhchap_ctrl_key' entries need to be in the ASCII
> format as specified in NVMe Base Specification v2.0 section 8.13.5.8
> 'Secret representation'.
> 'dhchap_hash' defaults to 'hmac(sha256)', and can be written to to
> switch to a different HMAC algorithm.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/nvme/target/Kconfig            |  12 +
>   drivers/nvme/target/Makefile           |   1 +
>   drivers/nvme/target/admin-cmd.c        |   2 +
>   drivers/nvme/target/auth.c             | 367 ++++++++++++++++++
>   drivers/nvme/target/configfs.c         | 107 +++++-
>   drivers/nvme/target/core.c             |  11 +
>   drivers/nvme/target/fabrics-cmd-auth.c | 491 +++++++++++++++++++++++++
>   drivers/nvme/target/fabrics-cmd.c      |  38 +-
>   drivers/nvme/target/nvmet.h            |  62 ++++
>   9 files changed, 1088 insertions(+), 3 deletions(-)
>   create mode 100644 drivers/nvme/target/auth.c
>   create mode 100644 drivers/nvme/target/fabrics-cmd-auth.c
>
> diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
> index 973561c93888..e569319be679 100644
> --- a/drivers/nvme/target/Kconfig
> +++ b/drivers/nvme/target/Kconfig
> @@ -83,3 +83,15 @@ config NVME_TARGET_TCP
>   	  devices over TCP.
>   
>   	  If unsure, say N.
> +
> +config NVME_TARGET_AUTH
> +	bool "NVMe over Fabrics In-band Authentication support"
> +	depends on NVME_TARGET
> +	depends on NVME_AUTH
> +	select CRYPTO_HMAC
> +	select CRYPTO_SHA256
> +	select CRYPTO_SHA512
> +	help
> +	  This enables support for NVMe over Fabrics In-band Authentication
> +
> +	  If unsure, say N.
> diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefile
> index 9837e580fa7e..c66820102493 100644
> --- a/drivers/nvme/target/Makefile
> +++ b/drivers/nvme/target/Makefile
> @@ -13,6 +13,7 @@ nvmet-y		+= core.o configfs.o admin-cmd.o fabrics-cmd.o \
>   			discovery.o io-cmd-file.o io-cmd-bdev.o
>   nvmet-$(CONFIG_NVME_TARGET_PASSTHRU)	+= passthru.o
>   nvmet-$(CONFIG_BLK_DEV_ZONED)		+= zns.o
> +nvmet-$(CONFIG_NVME_TARGET_AUTH)	+= fabrics-cmd-auth.o auth.o
>   nvme-loop-y	+= loop.o
>   nvmet-rdma-y	+= rdma.o
>   nvmet-fc-y	+= fc.o
> diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
> index 31df40ac828f..fc8a957fad0a 100644
> --- a/drivers/nvme/target/admin-cmd.c
> +++ b/drivers/nvme/target/admin-cmd.c
> @@ -1018,6 +1018,8 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
>   
>   	if (nvme_is_fabrics(cmd))
>   		return nvmet_parse_fabrics_admin_cmd(req);
> +	if (unlikely(!nvmet_check_auth_status(req)))
> +		return NVME_SC_AUTH_REQUIRED | NVME_SC_DNR;
>   	if (nvmet_is_disc_subsys(nvmet_req_subsys(req)))
>   		return nvmet_parse_discovery_cmd(req);
>   
> diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
> new file mode 100644
> index 000000000000..003c0faad7ff
> --- /dev/null
> +++ b/drivers/nvme/target/auth.c
> @@ -0,0 +1,367 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * NVMe over Fabrics DH-HMAC-CHAP authentication.
> + * Copyright (c) 2020 Hannes Reinecke, SUSE Software Solutions.
> + * All rights reserved.
> + */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <crypto/hash.h>
> +#include <linux/crc32.h>
> +#include <linux/base64.h>
> +#include <linux/ctype.h>
> +#include <linux/random.h>
> +#include <asm/unaligned.h>
> +
> +#include "nvmet.h"
> +#include "../host/auth.h"

maybe we can put the common stuff to include/linux/nvme-auth.h instead 
of doing ../host/auth.h ?


