Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2616CC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 11:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiCVLl6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiCVLl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 07:41:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E49F5BE68
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 04:40:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReTLTGnWwDOY1kzG76FtK4nlEDdPNYcq8429sbAsf954N1pQkg0RnRqb3LpzaqxQzSEEGsnrDE3zNzt/plNI7q4CyqN4jj3LUjdeWIyArCmhwfff4eQLUz+1Bmj9Me3J2ekoBU+llNPaM7yxskmnbeX9c/3kP8Ck3kzbM7ECN4tkCG5sQXPto4DuOEakNEqCoK2cTjFRcfIddg1Ww5W8L0w9hXQ5c2lzJyyk7FsGPerJIFwt1dL23cOZDpJqINHLQD0CZHzuyiAQUAT1q6rcJSXUEgvDCu5P+LuqnuXBYm5RgoSrUidD6GGS/CnimOtVVTjJSMtkQBT0QDBBTDzQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8e8/I0mH0qLObh+l9DhQsMXxpkpJ4Jxs0hIupRO6cPM=;
 b=YBjl/sd4X/sNyKIedql3+uxM+90QbFCrpMLeRsXQrH+WAAxADr2G2I3QblQ+JfHy7TWCgSZmYIzJjo3EB1yycLxUK2a03IsuauYITxbCIp5cqOawoSkH6aa4IQN1iqzDvawoxvFApc8e334Ezf5m1zmYz/jZGixNxZBw1rMQ6AHU/arEKTSVPV2LCgToZI+/xQ9/z+6TFxsPE6i9em7ulD/qTbhI9GUpXZXLKQQq6mVa2TZCVJSzmXqU5BdKtQbV1EySqO/0KeKj0sxAZWEEEQHijLg4Jz5ux21gjFoO5siu/UBkh8Djq+vPvepCFoWcV5AMtWIQG/yMNcaLsALTiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e8/I0mH0qLObh+l9DhQsMXxpkpJ4Jxs0hIupRO6cPM=;
 b=V4JknrOQM0Q7P9axA4wieXt9rVodzrgwWObP6nyq5Zl0784RQvbh0wKMfesXA2djFZyFQ24dPjFMe1eMI7JT32OHAEpjcnnA9yF+VBjqsYQyj8sFi/AASBARCtUyMii/4z+hTcoEiQA/vgsJi1SJWUhxdOZTdWO0AOvTMmG6RiTOtOGOKzSjJko0h9jdBMJKeoVyybu97QMb7o/0Qkqwb5Td3QVWS7Xa8E3sq20PA+KcUUDL2Odra7fxtxg9wIOZNamRbv21qPxmURCYDi2FUnDX+D7VsI9i5jmpGCI6vbvgUF3UCwaE81Ynw941/vMvrBSnxhd97PSwgq3yuY5gtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by BY5PR12MB3876.namprd12.prod.outlook.com (2603:10b6:a03:1a7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 11:40:24 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::f037:e2a1:f108:125a]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::f037:e2a1:f108:125a%7]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 11:40:24 +0000
Message-ID: <346e03e9-ece1-73f9-f7f4-c987055c5b9f@nvidia.com>
Date:   Tue, 22 Mar 2022 13:40:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211202152358.60116-8-hare@suse.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211202152358.60116-8-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0107.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::48) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 293fbfd8-da8d-484c-5095-08da0bf8c09c
X-MS-TrafficTypeDiagnostic: BY5PR12MB3876:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3876775A4AD40B1913356E78DE179@BY5PR12MB3876.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YG97/Wi07QBcP3oc/TI95/wq/bWLXklYoDSq/+N0nCBru80Ag0Mldgq8PznXH5jy8Vgs9BXiThLAUQYJZ/RdEo+szGiFJOvo5d3yz5PEKsve/lb98BXQYsYLlW1ByXcNOSsss2EIeBliMnlo/q0fvE8ED5QBP2KnNXuuX9NKVOhHjT+rR/UIw+BNOFqUP+r+36TNPfhnZnDLf4VgOUnUIP7mg6Qr6vsCkFUL2cDrHDZz9RdbGGz/90vr1nXJlnwGecy1HW+2gwv82/RdQRc4EtT/Z+aJKRvugQUh9KwI98+oDjOuYGBI1zCNNmAM6TpI4Zpa5kNm+L4IK2WyLO6tcU1alDaiqVnqrAi2dQaiukMR43k+qJy4mNffTz/C/dzM1iux44iRN8HJ82xNMx+xZanu5hmJ5JgoZ6jLUmBp9BYofu1V1vSSNEFyDKcqJyj9pHBJ/FdyI7zoIEjGgjrtlLMQH6x4CxmY0DH9q6khT0qFltriObJ20+pmRlmcuGcL8LQ3Y9uuDQn7yo9cQ3mIdO6mKAAW+gSrUjL85YzlRbMJnOKzVIiIWmqYIq309da8HIAtzSXhReoJ5Mf7rKyssf1Cw+yQP+ucxo9X6ZE9ROhq8BAfxB2UbPW1SuKDPcTbgWqanD/FAbLgN+KYEVE6jG4/U1lKmJjVPKRJjcL/raXsJGrw1y4ootB4tKlcETzasJ7jtcgAMTAONTh2+2+qJlhOpp1vJFAQvv9VjVcsyOH/iotqIbLvyQo6YkR+QMH3YpGyup9Tg3ZwEinDnqrzaD+E3+EqQHDr2NlvPcxjT4QJ50re3gOfSLQ2KII4xwFa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(8936002)(30864003)(5660300002)(6512007)(2906002)(508600001)(6506007)(6666004)(6486002)(966005)(53546011)(38100700002)(110136005)(186003)(26005)(83380400001)(31696002)(36756003)(8676002)(31686004)(66556008)(66476007)(316002)(4326008)(66946007)(54906003)(45980500001)(43740500002)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnZhWGN0T1o1SkVIM1J2WnJsRTlwY1BZcjA5UWM4dUFyMVFxNHRkUFcxTFd4?=
 =?utf-8?B?dlllWEFVMXhtTEhkY20zL0svRUNQK2xSRGxkZWY2a1UvNDg3OHZKMVduUTU2?=
 =?utf-8?B?MHljREdNVTNEMFdET0ZrcGZEN3FsdndnaW5tazVBcitFQ1NQVVlqYVp2NS9z?=
 =?utf-8?B?bVVrMDNVamhNZzkrekNSVVNOd1crMUNCOC9rNjRiVEFwandEeHpNQ25HdUQz?=
 =?utf-8?B?ZHV6ZkdNRkpJSUhEd24rUUlCOGEyWnFHOFV5MERSbkVLSUFwK1hmSVlvOFYy?=
 =?utf-8?B?OThTaGFnR1NyY2hjbmRnVGFqUVcrcndZQmQrRm9uN3pNUmE1YkN2UnYzZk1Q?=
 =?utf-8?B?L2FhTzYvcER5aS8vY1FMUjQzWnFiRW5FWFVwSWRRendiOGhrR3FwR0ZRZnBM?=
 =?utf-8?B?elVtcEFPbUtQQmhUQmFlQnJCNHFvT2R0YXFabGNQREwwVDRDaGFhbmtBU25o?=
 =?utf-8?B?dXVLNWkrdFQ5dVdBdWtiWDZtaXlBNUZJbUFuS2hJUVFuaFhYdk0zOFJKcDNR?=
 =?utf-8?B?QnRLa3pjTkpHZmNQQnF0V1JiaTNkVjhpUzYxLzJjRVBzejBkRGh1WVNQN0hM?=
 =?utf-8?B?WUZFWWZITzZVdXA3eXlkMDdVWWhiaVlabFZjc05qbjBpYVVNTVpXUG9TVEE4?=
 =?utf-8?B?R2I2ZzJJeXgyTHUyM0p0L1Rnd255ZVhWRDFBcEVEUXdpVFljODBIVm1wTmZX?=
 =?utf-8?B?WXhSZitqZEp2QkFmcGdYeGlia1lIN3BOSUVyQkhwMW02MVQ0cUJFcXZzcXJx?=
 =?utf-8?B?RFFTK0dUVWhvb3FGMTU4UlcxOEY0QnZNZ1VSYi9IdDVoZmMwWUhmdTdsNy96?=
 =?utf-8?B?MTZXbjBHays0dlNXaVdBc0NVLzE5WVA3V2JxTldzT1l2c0UyUHAyZEx1UHR0?=
 =?utf-8?B?MHZTRE1NaWI2VU4wVEx5V25BeEw4LytTK08yL0pHS281cHYwSlg0WWdLbXVh?=
 =?utf-8?B?SlFpKzBoZ2hIWVpWZVVhcWFiWDhPSlNORVRLSHlQWUtOd2NaVGRXYWRNYXNo?=
 =?utf-8?B?KzVGU1pVanV3eCtXT3BCRzRaZ3dCN2tJVWlGdDczTnNoWDRJS1hIZmdYU2p5?=
 =?utf-8?B?Z29ncU9qTnZBSHpXV0VCZ0dSb3hrZHRMV29CQnpzTUVBUGZFMUJCUFlTNFJP?=
 =?utf-8?B?OS9ISS9KMDJMM3kvR3gvdDhHMnM4ZHhPZDFOOFoxRHRYbk9yTlpWdkRuc3Jv?=
 =?utf-8?B?VmdPQWhVRi9lWXkvRmc0OTlkdG1mQWxQeStDUzZvQk5qMWNjRHdjTk1qdFBI?=
 =?utf-8?B?b2RBMU82RVVVQXBpa3Jad3pwQlhTRk1CSkRoT2UyenNOZERQVEpEZWVMOEpt?=
 =?utf-8?B?RVc4Uyt4T1B0WlJsREp6QzZUamZsaWtIaktDckxOK0RhaG5UMzcyYlZzUWdt?=
 =?utf-8?B?MjhjSDVFeU9uU3ZoTlpxNGRQL2JRNjN0OU5mejF3bzc3ZzNkaWlTS0pDKzJm?=
 =?utf-8?B?NjQzL3NiZzltckZWd09XNGtFd3lSc1JMVVNwNGk5VWlMenI4QXBkMUdOQy8z?=
 =?utf-8?B?c1pGaG0renozTzNoNnY2TGoyRy93eUtraU1CQmRLVjhiUGczamVKQXBYNUNn?=
 =?utf-8?B?a0QxS2NmSStiQUkvWlJRdno0L0JtdU5TUmpMVjFVaGkxdFN4aFJXS3dEZzdn?=
 =?utf-8?B?bjZOV0VKaTFCTXhaVmlQK3ludE1oUnh0dktlbUcwcVRudUowL2FaSU1Ia2tF?=
 =?utf-8?B?UjRWM2x2U3dGVTRYTmJqU1RVUTRIUzZzMkFteTR2dndHWUZVczVzdndKdEI2?=
 =?utf-8?B?UEZtZ1B2Q2FJVVo1MmNCdUZGNDh6WHhQK0pGcGZFb1V4SkZldGxwSnB5eE1C?=
 =?utf-8?B?YmZ4UkgvYjZLUkJ4YkovdWd4MmIvdE4xaFl3Zm9GcUs3K1dRbGU3RkV1ZVN0?=
 =?utf-8?B?M2lsWmpLckNlOEpua1RxSUhPcXJuNDk2THVvdlZPMHBONFJ0NTQzaXcvNmdu?=
 =?utf-8?B?d2txdnhPaWFYbElMalB2bDdUSUlhMUVLN3RxZStTREcxQ2tYb29meEtFcE9Q?=
 =?utf-8?B?NmU0VzJBQWdBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 293fbfd8-da8d-484c-5095-08da0bf8c09c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 11:40:24.1204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvwLnY5rWs1MrIPOgfnMPpMj59gGPvT1jOWYXzHJNaXSNk/hxZX98wf7eVpE2Ml3LmDL/nuasTjg4KFDOlNfcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3876
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hannes,

On 12/2/2021 5:23 PM, Hannes Reinecke wrote:
> Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
> This patch adds two new fabric options 'dhchap_secret' to specify the
> pre-shared key (in ASCII respresentation according to NVMe 2.0 section
> 8.13.5.8 'Secret representation') and 'dhchap_ctrl_secret' to specify
> the pre-shared controller key for bi-directional authentication of both
> the host and the controller.
> Re-authentication can be triggered by writing the PSK into the new
> controller sysfs attribute 'dhchap_secret' or 'dhchap_ctrl_secret'.

Can you please add to commit log an example of the process ?

 From target configuration through the 'nvme connect' cmd.


> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/nvme/host/Kconfig   |   11 +
>   drivers/nvme/host/Makefile  |    1 +
>   drivers/nvme/host/auth.c    | 1169 +++++++++++++++++++++++++++++++++++
>   drivers/nvme/host/auth.h    |   34 +
>   drivers/nvme/host/core.c    |  141 ++++-
>   drivers/nvme/host/fabrics.c |   79 ++-
>   drivers/nvme/host/fabrics.h |    7 +
>   drivers/nvme/host/nvme.h    |   31 +
>   drivers/nvme/host/rdma.c    |    1 +
>   drivers/nvme/host/tcp.c     |    1 +
>   drivers/nvme/host/trace.c   |   32 +
>   11 files changed, 1500 insertions(+), 7 deletions(-)
>   create mode 100644 drivers/nvme/host/auth.c
>   create mode 100644 drivers/nvme/host/auth.h
>
> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> index dc0450ca23a3..49269c581ec4 100644
> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -83,3 +83,14 @@ config NVME_TCP
>   	  from https://github.com/linux-nvme/nvme-cli.
>   
>   	  If unsure, say N.
> +
> +config NVME_AUTH
> +	bool "NVM Express over Fabrics In-Band Authentication"
> +	depends on NVME_CORE
> +	select CRYPTO_HMAC
> +	select CRYPTO_SHA256
> +	select CRYPTO_SHA512
> +	help
> +	  This provides support for NVMe over Fabrics In-Band Authentication.
> +
> +	  If unsure, say N.
> diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
> index dfaacd472e5d..4bae2a4a8d8c 100644
> --- a/drivers/nvme/host/Makefile
> +++ b/drivers/nvme/host/Makefile
> @@ -15,6 +15,7 @@ nvme-core-$(CONFIG_NVME_MULTIPATH)	+= multipath.o
>   nvme-core-$(CONFIG_BLK_DEV_ZONED)	+= zns.o
>   nvme-core-$(CONFIG_FAULT_INJECTION_DEBUG_FS)	+= fault_inject.o
>   nvme-core-$(CONFIG_NVME_HWMON)		+= hwmon.o
> +nvme-core-$(CONFIG_NVME_AUTH)		+= auth.o
>   
>   nvme-y					+= pci.o
>   
> diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
> new file mode 100644
> index 000000000000..774085e4f400
> --- /dev/null
> +++ b/drivers/nvme/host/auth.c
> @@ -0,0 +1,1169 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2020 Hannes Reinecke, SUSE Linux
> + */
> +
> +#include <linux/crc32.h>
> +#include <linux/base64.h>
> +#include <linux/prandom.h>
> +#include <asm/unaligned.h>
> +#include <crypto/hash.h>
> +#include <crypto/dh.h>
> +#include <crypto/ffdhe.h>
> +#include "nvme.h"
> +#include "fabrics.h"
> +#include "auth.h"
> +
> +static u32 nvme_dhchap_seqnum;
> +static DEFINE_MUTEX(nvme_dhchap_mutex);
> +
> +struct nvme_dhchap_queue_context {
> +	struct list_head entry;
> +	struct work_struct auth_work;
> +	struct nvme_ctrl *ctrl;
> +	struct crypto_shash *shash_tfm;
> +	void *buf;
> +	size_t buf_size;
> +	int qid;
> +	int error;
> +	u32 s1;
> +	u32 s2;
> +	u16 transaction;
> +	u8 status;
> +	u8 hash_id;
> +	size_t hash_len;
> +	u8 dhgroup_id;
> +	u8 c1[64];
> +	u8 c2[64];
> +	u8 response[64];
> +	u8 *host_response;
> +};
> +
> +u32 nvme_auth_get_seqnum(void)
> +{
> +	u32 seqnum;
> +
> +	mutex_lock(&nvme_dhchap_mutex);
> +	if (!nvme_dhchap_seqnum)
> +		nvme_dhchap_seqnum = prandom_u32();
> +	else {
> +		nvme_dhchap_seqnum++;
> +		if (!nvme_dhchap_seqnum)
> +			nvme_dhchap_seqnum++;
> +	}
> +	seqnum = nvme_dhchap_seqnum;
> +	mutex_unlock(&nvme_dhchap_mutex);
> +	return seqnum;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_get_seqnum);
> +
> +static struct nvme_auth_dhgroup_map {
> +	u8 id;
> +	const char name[16];
> +	const char kpp[16];
> +	size_t privkey_size;
> +	size_t pubkey_size;
> +} dhgroup_map[] = {
> +	{ .id = NVME_AUTH_DHGROUP_NULL,
> +	  .name = "null", .kpp = "null",
> +	  .privkey_size = 0, .pubkey_size = 0 },
> +	{ .id = NVME_AUTH_DHGROUP_2048,
> +	  .name = "ffdhe2048", .kpp = "dh",
> +	  .privkey_size = 256, .pubkey_size = 256 },
> +	{ .id = NVME_AUTH_DHGROUP_3072,
> +	  .name = "ffdhe3072", .kpp = "dh",
> +	  .privkey_size = 384, .pubkey_size = 384 },
> +	{ .id = NVME_AUTH_DHGROUP_4096,
> +	  .name = "ffdhe4096", .kpp = "dh",
> +	  .privkey_size = 512, .pubkey_size = 512 },
> +	{ .id = NVME_AUTH_DHGROUP_6144,
> +	  .name = "ffdhe6144", .kpp = "dh",
> +	  .privkey_size = 768, .pubkey_size = 768 },
> +	{ .id = NVME_AUTH_DHGROUP_8192,
> +	  .name = "ffdhe8192", .kpp = "dh",
> +	  .privkey_size = 1024, .pubkey_size = 1024 },
> +};
> +
> +const char *nvme_auth_dhgroup_name(u8 dhgroup_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
> +		if (dhgroup_map[i].id == dhgroup_id)
> +			return dhgroup_map[i].name;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_name);
> +
> +size_t nvme_auth_dhgroup_pubkey_size(u8 dhgroup_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
> +		if (dhgroup_map[i].id == dhgroup_id)
> +			return dhgroup_map[i].pubkey_size;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_pubkey_size);
> +
> +size_t nvme_auth_dhgroup_privkey_size(u8 dhgroup_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
> +		if (dhgroup_map[i].id == dhgroup_id)
> +			return dhgroup_map[i].privkey_size;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_privkey_size);
> +
> +const char *nvme_auth_dhgroup_kpp(u8 dhgroup_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
> +		if (dhgroup_map[i].id == dhgroup_id)
> +			return dhgroup_map[i].kpp;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_kpp);
> +
> +u8 nvme_auth_dhgroup_id(const char *dhgroup_name)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
> +		if (!strncmp(dhgroup_map[i].name, dhgroup_name,
> +			     strlen(dhgroup_map[i].name)))
> +			return dhgroup_map[i].id;
> +	}
> +	return NVME_AUTH_DHGROUP_INVALID;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_id);
> +
> +static struct nvme_dhchap_hash_map {
> +	int id;
> +	int len;
> +	const char hmac[15];
> +	const char digest[15];
> +} hash_map[] = {
> +	{.id = NVME_AUTH_HASH_SHA256, .len = 32,
> +	 .hmac = "hmac(sha256)", .digest = "sha256" },
> +	{.id = NVME_AUTH_HASH_SHA384, .len = 48,
> +	 .hmac = "hmac(sha384)", .digest = "sha384" },
> +	{.id = NVME_AUTH_HASH_SHA512, .len = 64,
> +	 .hmac = "hmac(sha512)", .digest = "sha512" },
> +};
> +
> +const char *nvme_auth_hmac_name(u8 hmac_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
> +		if (hash_map[i].id == hmac_id)
> +			return hash_map[i].hmac;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_hmac_name);
> +
> +const char *nvme_auth_digest_name(u8 hmac_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
> +		if (hash_map[i].id == hmac_id)
> +			return hash_map[i].digest;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_digest_name);
> +
> +u8 nvme_auth_hmac_id(const char *hmac_name)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
> +		if (!strncmp(hash_map[i].hmac, hmac_name,
> +			     strlen(hash_map[i].hmac)))
> +			return hash_map[i].id;
> +	}
> +	return NVME_AUTH_HASH_INVALID;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_hmac_id);
> +
> +size_t nvme_auth_hmac_hash_len(u8 hmac_id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
> +		if (hash_map[i].id == hmac_id)
> +			return hash_map[i].len;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_hmac_hash_len);
> +
> +struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
> +					      u8 key_hash)
> +{
> +	struct nvme_dhchap_key *key;
> +	unsigned char *p;
> +	u32 crc;
> +	int ret, key_len;
> +	size_t allocated_len = strlen(secret);
> +
> +	/* Secret might be affixed with a ':' */
> +	p = strrchr(secret, ':');
> +	if (p)
> +		allocated_len = p - secret;
> +	key = kzalloc(sizeof(*key), GFP_KERNEL);
> +	if (!key)
> +		return ERR_PTR(-ENOMEM);
> +	key->key = kzalloc(allocated_len, GFP_KERNEL);
> +	if (!key->key) {
> +		ret = -ENOMEM;
> +		goto out_free_key;
> +	}
> +
> +	key_len = base64_decode(secret, allocated_len, key->key);
> +	if (key_len < 0) {
> +		pr_debug("base64 key decoding error %d\n",
> +			 key_len);
> +		ret = key_len;
> +		goto out_free_secret;
> +	}
> +
> +	if (key_len != 36 && key_len != 52 &&
> +	    key_len != 68) {
> +		pr_err("Invalid DH-HMAC-CHAP key len %d\n",
> +		       key_len);
> +		ret = -EINVAL;
> +		goto out_free_secret;
> +	}
> +
> +	if (key_hash > 0 &&
> +	    (key_len - 4) != nvme_auth_hmac_hash_len(key_hash)) {
> +		pr_err("Invalid DH-HMAC-CHAP key len %d for %s\n", key_len,
> +		       nvme_auth_hmac_name(key_hash));
> +		ret = -EINVAL;
> +		goto out_free_secret;
> +	}
> +
> +	/* The last four bytes is the CRC in little-endian format */
> +	key_len -= 4;
> +	/*
> +	 * The linux implementation doesn't do pre- and post-increments,
> +	 * so we have to do it manually.
> +	 */
> +	crc = ~crc32(~0, key->key, key_len);
> +
> +	if (get_unaligned_le32(key->key + key_len) != crc) {
> +		pr_err("DH-HMAC-CHAP key crc mismatch (key %08x, crc %08x)\n",
> +		       get_unaligned_le32(key->key + key_len), crc);
> +		ret = -EKEYREJECTED;
> +		goto out_free_secret;
> +	}
> +	key->len = key_len;
> +	key->hash = key_hash;
> +	return key;
> +out_free_secret:
> +	kfree_sensitive(key->key);
> +out_free_key:
> +	kfree(key);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_extract_key);
> +
> +void nvme_auth_free_key(struct nvme_dhchap_key *key)
> +{
> +	if (!key)
> +		return;
> +	kfree_sensitive(key->key);
> +	kfree(key);
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_free_key);
> +
> +u8 *nvme_auth_transform_key(struct nvme_dhchap_key *key, char *nqn)
> +{
> +	const char *hmac_name = nvme_auth_hmac_name(key->hash);
> +	struct crypto_shash *key_tfm;
> +	struct shash_desc *shash;
> +	u8 *transformed_key;
> +	int ret;
> +
> +	if (key->hash == 0) {
> +		transformed_key = kmemdup(key->key, key->len, GFP_KERNEL);
> +		return transformed_key ? transformed_key : ERR_PTR(-ENOMEM);
> +	}
> +
> +	if (!key || !key->key) {
> +		pr_warn("No key specified\n");
> +		return ERR_PTR(-ENOKEY);
> +	}
> +	if (!hmac_name) {
> +		pr_warn("Invalid key hash id %d\n", key->hash);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
> +	if (IS_ERR(key_tfm))
> +		return (u8 *)key_tfm;
> +
> +	shash = kmalloc(sizeof(struct shash_desc) +
> +			crypto_shash_descsize(key_tfm),
> +			GFP_KERNEL);
> +	if (!shash) {
> +		ret = -ENOMEM;
> +		goto out_free_key;
> +	}
> +
> +	transformed_key = kzalloc(crypto_shash_digestsize(key_tfm), GFP_KERNEL);
> +	if (!transformed_key) {
> +		ret = -ENOMEM;
> +		goto out_free_shash;
> +	}
> +
> +	shash->tfm = key_tfm;
> +	ret = crypto_shash_setkey(key_tfm, key->key, key->len);
> +	if (ret < 0)
> +		goto out_free_shash;
> +	ret = crypto_shash_init(shash);
> +	if (ret < 0)
> +		goto out_free_shash;
> +	ret = crypto_shash_update(shash, nqn, strlen(nqn));
> +	if (ret < 0)
> +		goto out_free_shash;
> +	ret = crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
> +	if (ret < 0)
> +		goto out_free_shash;
> +	ret = crypto_shash_final(shash, transformed_key);
> +out_free_shash:
> +	kfree(shash);
> +out_free_key:
> +	crypto_free_shash(key_tfm);
> +	if (ret < 0) {
> +		kfree_sensitive(transformed_key);
> +		return ERR_PTR(ret);
> +	}
> +	return transformed_key;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
> +
> +#define nvme_auth_flags_from_qid(qid) \
> +	(qid == NVME_QID_ANY) ? 0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED
> +#define nvme_auth_queue_from_qid(ctrl, qid) \
> +	(qid == NVME_QID_ANY) ? (ctrl)->fabrics_q : (ctrl)->connect_q
> +
> +static int nvme_auth_send(struct nvme_ctrl *ctrl, int qid,
> +		void *data, size_t tl)
> +{
> +	struct nvme_command cmd = {};
> +	blk_mq_req_flags_t flags = nvme_auth_flags_from_qid(qid);
> +	struct request_queue *q = nvme_auth_queue_from_qid(ctrl, qid);
> +	int ret;
> +
> +	cmd.auth_send.opcode = nvme_fabrics_command;
> +	cmd.auth_send.fctype = nvme_fabrics_type_auth_send;
> +	cmd.auth_send.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
> +	cmd.auth_send.spsp0 = 0x01;
> +	cmd.auth_send.spsp1 = 0x01;
> +	cmd.auth_send.tl = cpu_to_le32(tl);
> +
> +	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, data, tl, 0, qid,
> +				     0, flags);
> +	if (ret > 0)
> +		dev_warn(ctrl->device,
> +			"qid %d auth_send failed with status %d\n", qid, ret);
> +	else if (ret < 0)
> +		dev_err(ctrl->device,
> +			"qid %d auth_send failed with error %d\n", qid, ret);
> +	return ret;
> +}
> +
> +static int nvme_auth_receive(struct nvme_ctrl *ctrl, int qid,
> +		void *buf, size_t al)
> +{
> +	struct nvme_command cmd = {};
> +	blk_mq_req_flags_t flags = nvme_auth_flags_from_qid(qid);
> +	struct request_queue *q = nvme_auth_queue_from_qid(ctrl, qid);
> +	int ret;
> +
> +	cmd.auth_receive.opcode = nvme_fabrics_command;
> +	cmd.auth_receive.fctype = nvme_fabrics_type_auth_receive;
> +	cmd.auth_receive.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
> +	cmd.auth_receive.spsp0 = 0x01;
> +	cmd.auth_receive.spsp1 = 0x01;
> +	cmd.auth_receive.al = cpu_to_le32(al);
> +
> +	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, buf, al, 0, qid,
> +				     0, flags);
> +	if (ret > 0) {
> +		dev_warn(ctrl->device,
> +			 "qid %d auth_recv failed with status %x\n", qid, ret);
> +		ret = -EIO;
> +	} else if (ret < 0) {
> +		dev_err(ctrl->device,
> +			"qid %d auth_recv failed with error %d\n", qid, ret);
> +	}
> +
> +	return ret;
> +}
> +
> +static int nvme_auth_receive_validate(struct nvme_ctrl *ctrl, int qid,
> +		struct nvmf_auth_dhchap_failure_data *data,
> +		u16 transaction, u8 expected_msg)
> +{
> +	dev_dbg(ctrl->device, "%s: qid %d auth_type %d auth_id %x\n",
> +		__func__, qid, data->auth_type, data->auth_id);
> +
> +	if (data->auth_type == NVME_AUTH_COMMON_MESSAGES &&
> +	    data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
> +		return data->rescode_exp;
> +	}
> +	if (data->auth_type != NVME_AUTH_DHCHAP_MESSAGES ||
> +	    data->auth_id != expected_msg) {
> +		dev_warn(ctrl->device,
> +			 "qid %d invalid message %02x/%02x\n",
> +			 qid, data->auth_type, data->auth_id);
> +		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE;
> +	}
> +	if (le16_to_cpu(data->t_id) != transaction) {
> +		dev_warn(ctrl->device,
> +			 "qid %d invalid transaction ID %d\n",
> +			 qid, le16_to_cpu(data->t_id));
> +		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE;
> +	}
> +	return 0;
> +}
> +
> +static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	struct nvmf_auth_dhchap_negotiate_data *data = chap->buf;
> +	size_t size = sizeof(*data) + sizeof(union nvmf_auth_protocol);
> +
> +	if (chap->buf_size < size) {
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
> +		return -EINVAL;
> +	}
> +	memset((u8 *)chap->buf, 0, size);
> +	data->auth_type = NVME_AUTH_COMMON_MESSAGES;
> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
> +	data->t_id = cpu_to_le16(chap->transaction);
> +	data->sc_c = 0; /* No secure channel concatenation */
> +	data->napd = 1;
> +	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
> +	data->auth_protocol[0].dhchap.halen = 3;
> +	data->auth_protocol[0].dhchap.dhlen = 6;
> +	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_HASH_SHA256;
> +	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_HASH_SHA384;
> +	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_HASH_SHA512;
> +	data->auth_protocol[0].dhchap.idlist[30] = NVME_AUTH_DHGROUP_NULL;
> +	data->auth_protocol[0].dhchap.idlist[31] = NVME_AUTH_DHGROUP_2048;
> +	data->auth_protocol[0].dhchap.idlist[32] = NVME_AUTH_DHGROUP_3072;
> +	data->auth_protocol[0].dhchap.idlist[33] = NVME_AUTH_DHGROUP_4096;
> +	data->auth_protocol[0].dhchap.idlist[34] = NVME_AUTH_DHGROUP_6144;
> +	data->auth_protocol[0].dhchap.idlist[35] = NVME_AUTH_DHGROUP_8192;
> +
> +	return size;
> +}
> +
> +static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	struct nvmf_auth_dhchap_challenge_data *data = chap->buf;
> +	u16 dhvlen = le16_to_cpu(data->dhvlen);
> +	size_t size = sizeof(*data) + data->hl + dhvlen;
> +	const char *hmac_name, *kpp_name;
> +
> +	if (chap->buf_size < size) {
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
> +		return NVME_SC_INVALID_FIELD;
> +	}
> +
> +	hmac_name = nvme_auth_hmac_name(data->hashid);
> +	if (!hmac_name) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: invalid HASH ID %d\n",
> +			 chap->qid, data->hashid);
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
> +		return NVME_SC_INVALID_FIELD;
> +	}
> +
> +	if (chap->hash_id == data->hashid && chap->shash_tfm &&
> +	    !strcmp(crypto_shash_alg_name(chap->shash_tfm), hmac_name) &&
> +	    crypto_shash_digestsize(chap->shash_tfm) == data->hl) {
> +		dev_dbg(ctrl->device,
> +			"qid %d: reuse existing hash %s\n",
> +			chap->qid, hmac_name);
> +		goto select_kpp;
> +	}
> +
> +	/* Reset if hash cannot be reused */
> +	if (chap->shash_tfm) {
> +		crypto_free_shash(chap->shash_tfm);
> +		chap->hash_id = 0;
> +		chap->hash_len = 0;
> +	}
> +	chap->shash_tfm = crypto_alloc_shash(hmac_name, 0,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY);
> +	if (IS_ERR(chap->shash_tfm)) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: failed to allocate hash %s, error %ld\n",
> +			 chap->qid, hmac_name, PTR_ERR(chap->shash_tfm));
> +		chap->shash_tfm = NULL;
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
> +		return NVME_SC_AUTH_REQUIRED;
> +	}
> +
> +	if (crypto_shash_digestsize(chap->shash_tfm) != data->hl) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: invalid hash length %d\n",
> +			 chap->qid, data->hl);
> +		crypto_free_shash(chap->shash_tfm);
> +		chap->shash_tfm = NULL;
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
> +		return NVME_SC_AUTH_REQUIRED;
> +	}
> +
> +	/* Reset host response if the hash had been changed */
> +	if (chap->hash_id != data->hashid) {
> +		kfree(chap->host_response);
> +		chap->host_response = NULL;
> +	}
> +
> +	chap->hash_id = data->hashid;
> +	chap->hash_len = data->hl;
> +	dev_dbg(ctrl->device, "qid %d: selected hash %s\n",
> +		chap->qid, hmac_name);
> +
> +select_kpp:
> +	kpp_name = nvme_auth_dhgroup_kpp(data->dhgid);
> +	if (!kpp_name) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: invalid DH group id %d\n",
> +			 chap->qid, data->dhgid);
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
> +		return NVME_SC_AUTH_REQUIRED;
> +	}
> +
> +	if (data->dhgid != NVME_AUTH_DHGROUP_NULL) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: unsupported DH group %s\n",
> +			 chap->qid, kpp_name);
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
> +		return NVME_SC_AUTH_REQUIRED;
> +	} else if (dhvlen != 0) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: invalid DH value for NULL DH\n",
> +			 chap->qid);
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
> +		return NVME_SC_INVALID_FIELD;
> +	}
> +	chap->dhgroup_id = data->dhgid;
> +
> +	chap->s1 = le32_to_cpu(data->seqnum);
> +	memcpy(chap->c1, data->cval, chap->hash_len);
> +
> +	return 0;
> +}
> +
> +static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	struct nvmf_auth_dhchap_reply_data *data = chap->buf;
> +	size_t size = sizeof(*data);
> +
> +	size += 2 * chap->hash_len;
> +
> +	if (chap->buf_size < size) {
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
> +		return -EINVAL;
> +	}
> +
> +	memset(chap->buf, 0, size);
> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
> +	data->t_id = cpu_to_le16(chap->transaction);
> +	data->hl = chap->hash_len;
> +	data->dhvlen = 0;
> +	memcpy(data->rval, chap->response, chap->hash_len);
> +	if (ctrl->opts->dhchap_ctrl_secret) {
> +		get_random_bytes(chap->c2, chap->hash_len);
> +		data->cvalid = 1;
> +		chap->s2 = nvme_auth_get_seqnum();
> +		memcpy(data->rval + chap->hash_len, chap->c2,
> +		       chap->hash_len);
> +		dev_dbg(ctrl->device, "%s: qid %d ctrl challenge %*ph\n",
> +			__func__, chap->qid, (int)chap->hash_len, chap->c2);
> +	} else {
> +		memset(chap->c2, 0, chap->hash_len);
> +		chap->s2 = 0;
> +	}
> +	data->seqnum = cpu_to_le32(chap->s2);
> +	return size;
> +}
> +
> +static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	struct nvmf_auth_dhchap_success1_data *data = chap->buf;
> +	size_t size = sizeof(*data);
> +
> +	if (ctrl->opts->dhchap_ctrl_secret)
> +		size += chap->hash_len;
> +
> +	if (chap->buf_size < size) {
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
> +		return NVME_SC_INVALID_FIELD;
> +	}
> +
> +	if (data->hl != chap->hash_len) {
> +		dev_warn(ctrl->device,
> +			 "qid %d: invalid hash length %u\n",
> +			 chap->qid, data->hl);
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
> +		return NVME_SC_INVALID_FIELD;
> +	}
> +
> +	/* Just print out information for the admin queue */
> +	if (chap->qid == -1)
> +		dev_info(ctrl->device,
> +			 "qid 0: authenticated with hash %s dhgroup %s\n",
> +			 nvme_auth_hmac_name(chap->hash_id),
> +			 nvme_auth_dhgroup_name(chap->dhgroup_id));
> +
> +	if (!data->rvalid)
> +		return 0;
> +
> +	/* Validate controller response */
> +	if (memcmp(chap->response, data->rval, data->hl)) {
> +		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
> +			__func__, chap->qid, (int)chap->hash_len, data->rval);
> +		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
> +			__func__, chap->qid, (int)chap->hash_len,
> +			chap->response);
> +		dev_warn(ctrl->device,
> +			 "qid %d: controller authentication failed\n",
> +			 chap->qid);
> +		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
> +		return NVME_SC_AUTH_REQUIRED;
> +	}
> +
> +	/* Just print out information for the admin queue */
> +	if (chap->qid == -1)
> +		dev_info(ctrl->device,
> +			 "qid 0: controller authenticated\n");
> +	return 0;
> +}
> +
> +static int nvme_auth_set_dhchap_success2_data(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	struct nvmf_auth_dhchap_success2_data *data = chap->buf;
> +	size_t size = sizeof(*data);
> +
> +	memset(chap->buf, 0, size);
> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2;
> +	data->t_id = cpu_to_le16(chap->transaction);
> +
> +	return size;
> +}
> +
> +static int nvme_auth_set_dhchap_failure2_data(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	struct nvmf_auth_dhchap_failure_data *data = chap->buf;
> +	size_t size = sizeof(*data);
> +
> +	memset(chap->buf, 0, size);
> +	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
> +	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_FAILURE2;
> +	data->t_id = cpu_to_le16(chap->transaction);
> +	data->rescode = NVME_AUTH_DHCHAP_FAILURE_REASON_FAILED;
> +	data->rescode_exp = chap->status;
> +
> +	return size;
> +}
> +
> +static int nvme_auth_dhchap_setup_host_response(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
> +	u8 buf[4], *challenge = chap->c1;
> +	int ret;
> +
> +	dev_dbg(ctrl->device, "%s: qid %d host response seq %u transaction %d\n",
> +		__func__, chap->qid, chap->s1, chap->transaction);
> +
> +	if (!chap->host_response) {
> +		chap->host_response = nvme_auth_transform_key(ctrl->host_key,
> +						ctrl->opts->host->nqn);
> +		if (IS_ERR(chap->host_response)) {
> +			ret = PTR_ERR(chap->host_response);
> +			chap->host_response = NULL;
> +			return ret;
> +		}
> +	} else {
> +		dev_dbg(ctrl->device, "%s: qid %d re-using host response\n",
> +			__func__, chap->qid);
> +	}
> +
> +	ret = crypto_shash_setkey(chap->shash_tfm,
> +			chap->host_response, ctrl->host_key->len);
> +	if (ret) {
> +		dev_warn(ctrl->device, "qid %d: failed to set key, error %d\n",
> +			 chap->qid, ret);
> +		goto out;
> +	}
> +
> +	shash->tfm = chap->shash_tfm;
> +	ret = crypto_shash_init(shash);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, challenge, chap->hash_len);
> +	if (ret)
> +		goto out;
> +	put_unaligned_le32(chap->s1, buf);
> +	ret = crypto_shash_update(shash, buf, 4);
> +	if (ret)
> +		goto out;
> +	put_unaligned_le16(chap->transaction, buf);
> +	ret = crypto_shash_update(shash, buf, 2);
> +	if (ret)
> +		goto out;
> +	memset(buf, 0, sizeof(buf));
> +	ret = crypto_shash_update(shash, buf, 1);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, "HostHost", 8);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
> +				  strlen(ctrl->opts->host->nqn));
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, buf, 1);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
> +			    strlen(ctrl->opts->subsysnqn));
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_final(shash, chap->response);
> +out:
> +	if (challenge != chap->c1)
> +		kfree(challenge);
> +	return ret;
> +}
> +
> +static int nvme_auth_dhchap_setup_ctrl_response(struct nvme_ctrl *ctrl,
> +		struct nvme_dhchap_queue_context *chap)
> +{
> +	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
> +	u8 *ctrl_response;
> +	u8 buf[4], *challenge = chap->c2;
> +	int ret;
> +
> +	ctrl_response = nvme_auth_transform_key(ctrl->ctrl_key,
> +				ctrl->opts->subsysnqn);
> +	if (IS_ERR(ctrl_response)) {
> +		ret = PTR_ERR(ctrl_response);
> +		return ret;
> +	}
> +	ret = crypto_shash_setkey(chap->shash_tfm,
> +			ctrl_response, ctrl->ctrl_key->len);
> +	if (ret) {
> +		dev_warn(ctrl->device, "qid %d: failed to set key, error %d\n",
> +			 chap->qid, ret);
> +		goto out;
> +	}
> +
> +	dev_dbg(ctrl->device, "%s: qid %d ctrl response seq %u transaction %d\n",
> +		__func__, chap->qid, chap->s2, chap->transaction);
> +	dev_dbg(ctrl->device, "%s: qid %d challenge %*ph\n",
> +		__func__, chap->qid, (int)chap->hash_len, challenge);
> +	dev_dbg(ctrl->device, "%s: qid %d subsysnqn %s\n",
> +		__func__, chap->qid, ctrl->opts->subsysnqn);
> +	dev_dbg(ctrl->device, "%s: qid %d hostnqn %s\n",
> +		__func__, chap->qid, ctrl->opts->host->nqn);
> +	shash->tfm = chap->shash_tfm;
> +	ret = crypto_shash_init(shash);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, challenge, chap->hash_len);
> +	if (ret)
> +		goto out;
> +	put_unaligned_le32(chap->s2, buf);
> +	ret = crypto_shash_update(shash, buf, 4);
> +	if (ret)
> +		goto out;
> +	put_unaligned_le16(chap->transaction, buf);
> +	ret = crypto_shash_update(shash, buf, 2);
> +	if (ret)
> +		goto out;
> +	memset(buf, 0, 4);
> +	ret = crypto_shash_update(shash, buf, 1);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, "Controller", 10);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
> +				  strlen(ctrl->opts->subsysnqn));
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, buf, 1);
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
> +				  strlen(ctrl->opts->host->nqn));
> +	if (ret)
> +		goto out;
> +	ret = crypto_shash_final(shash, chap->response);
> +out:
> +	if (challenge != chap->c2)
> +		kfree(challenge);
> +	return ret;
> +}
> +
> +int nvme_auth_generate_key(u8 *secret, struct nvme_dhchap_key **ret_key)
> +{
> +	struct nvme_dhchap_key *key;
> +	u8 key_hash;
> +
> +	if (!secret) {
> +		*ret_key = NULL;
> +		return 0;
> +	}
> +
> +	if (sscanf(secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
> +		return -EINVAL;
> +
> +	/* Pass in the secret without the 'DHHC-1:XX:' prefix */
> +	key = nvme_auth_extract_key(secret + 10, key_hash);
> +	if (IS_ERR(key)) {
> +		return PTR_ERR(key);
> +	}
> +
> +	*ret_key = key;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
> +
> +static void __nvme_auth_reset(struct nvme_dhchap_queue_context *chap)
> +{
> +	chap->status = 0;
> +	chap->error = 0;
> +	chap->s1 = 0;
> +	chap->s2 = 0;
> +	chap->transaction = 0;
> +	memset(chap->c1, 0, sizeof(chap->c1));
> +	memset(chap->c2, 0, sizeof(chap->c2));
> +}
> +
> +static void __nvme_auth_free(struct nvme_dhchap_queue_context *chap)
> +{
> +	if (chap->shash_tfm)
> +		crypto_free_shash(chap->shash_tfm);
> +	kfree_sensitive(chap->host_response);
> +	kfree(chap->buf);
> +	kfree(chap);
> +}
> +
> +static void __nvme_auth_work(struct work_struct *work)
> +{
> +	struct nvme_dhchap_queue_context *chap =
> +		container_of(work, struct nvme_dhchap_queue_context, auth_work);
> +	struct nvme_ctrl *ctrl = chap->ctrl;
> +	size_t tl;
> +	int ret = 0;
> +
> +	chap->transaction = ctrl->transaction++;
> +
> +	/* DH-HMAC-CHAP Step 1: send negotiate */
> +	dev_dbg(ctrl->device, "%s: qid %d send negotiate\n",
> +		__func__, chap->qid);

maybe you can use a local variable for ctrl->device


> +	ret = nvme_auth_set_dhchap_negotiate_data(ctrl, chap);
> +	if (ret < 0) {
> +		chap->error = ret;
> +		return;
> +	}
> +	tl = ret;
> +	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
> +	if (ret) {
> +		chap->error = ret;
> +		return;
> +	}
> +
> +	/* DH-HMAC-CHAP Step 2: receive challenge */
> +	dev_dbg(ctrl->device, "%s: qid %d receive challenge\n",
> +		__func__, chap->qid);
> +
> +	memset(chap->buf, 0, chap->buf_size);
> +	ret = nvme_auth_receive(ctrl, chap->qid, chap->buf, chap->buf_size);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "qid %d failed to receive challenge, %s %d\n",
> +			 chap->qid, ret < 0 ? "error" : "nvme status", ret);
> +		chap->error = ret;
> +		return;
> +	}
> +	ret = nvme_auth_receive_validate(ctrl, chap->qid, chap->buf, chap->transaction,
> +					 NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE);
> +	if (ret) {
> +		chap->status = ret;
> +		chap->error = NVME_SC_AUTH_REQUIRED;
> +		return;
> +	}
> +
> +	ret = nvme_auth_process_dhchap_challenge(ctrl, chap);
> +	if (ret) {
> +		/* Invalid challenge parameters */
> +		goto fail2;
> +	}
> +
> +	dev_dbg(ctrl->device, "%s: qid %d host response\n",
> +		__func__, chap->qid);
> +	ret = nvme_auth_dhchap_setup_host_response(ctrl, chap);
> +	if (ret)
> +		goto fail2;
> +
> +	/* DH-HMAC-CHAP Step 3: send reply */
> +	dev_dbg(ctrl->device, "%s: qid %d send reply\n",
> +		__func__, chap->qid);
> +	ret = nvme_auth_set_dhchap_reply_data(ctrl, chap);
> +	if (ret < 0)
> +		goto fail2;
> +
> +	tl = ret;
> +	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
> +	if (ret)
> +		goto fail2;
> +
> +	/* DH-HMAC-CHAP Step 4: receive success1 */
> +	dev_dbg(ctrl->device, "%s: qid %d receive success1\n",
> +		__func__, chap->qid);
> +
> +	memset(chap->buf, 0, chap->buf_size);
> +	ret = nvme_auth_receive(ctrl, chap->qid, chap->buf, chap->buf_size);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "qid %d failed to receive success1, %s %d\n",
> +			 chap->qid, ret < 0 ? "error" : "nvme status", ret);
> +		chap->error = ret;
> +		return;
> +	}
> +	ret = nvme_auth_receive_validate(ctrl, chap->qid,
> +					 chap->buf, chap->transaction,
> +					 NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1);
> +	if (ret) {
> +		chap->status = ret;
> +		chap->error = NVME_SC_AUTH_REQUIRED;
> +		return;
> +	}
> +
> +	if (ctrl->opts->dhchap_ctrl_secret) {
> +		dev_dbg(ctrl->device,
> +			"%s: qid %d controller response\n",
> +			__func__, chap->qid);
> +		ret = nvme_auth_dhchap_setup_ctrl_response(ctrl, chap);
> +		if (ret)
> +			goto fail2;
> +	}
> +
> +	ret = nvme_auth_process_dhchap_success1(ctrl, chap);
> +	if (ret) {
> +		/* Controller authentication failed */
> +		goto fail2;
> +	}
> +
> +	/* DH-HMAC-CHAP Step 5: send success2 */
> +	dev_dbg(ctrl->device, "%s: qid %d send success2\n",
> +		__func__, chap->qid);
> +	tl = nvme_auth_set_dhchap_success2_data(ctrl, chap);
> +	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
> +	if (!ret) {
> +		chap->error = 0;
> +		return;
> +	}
> +
> +fail2:
> +	dev_dbg(ctrl->device, "%s: qid %d send failure2, status %x\n",
> +		__func__, chap->qid, chap->status);
> +	tl = nvme_auth_set_dhchap_failure2_data(ctrl, chap);
> +	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
> +	if (!ret)
> +		ret = -EPROTO;
> +	chap->error = ret;
> +}
> +
> +int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
> +{
> +	struct nvme_dhchap_queue_context *chap;
> +
> +	if (!ctrl->host_key) {
> +		dev_warn(ctrl->device, "qid %d: no key\n", qid);
> +		return -ENOKEY;
> +	}
> +
> +	mutex_lock(&ctrl->dhchap_auth_mutex);
> +	/* Check if the context is already queued */
> +	list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
> +		WARN_ON(!chap->buf);
> +		if (chap->qid == qid) {
> +			dev_dbg(ctrl->device, "qid %d: re-using context\n", qid);
> +			mutex_unlock(&ctrl->dhchap_auth_mutex);
> +			flush_work(&chap->auth_work);
> +			__nvme_auth_reset(chap);
> +			queue_work(nvme_wq, &chap->auth_work);
> +			return 0;
> +		}
> +	}
> +	chap = kzalloc(sizeof(*chap), GFP_KERNEL);
> +	if (!chap) {
> +		mutex_unlock(&ctrl->dhchap_auth_mutex);
> +		return -ENOMEM;
> +	}
> +	chap->qid = qid;
> +	chap->ctrl = ctrl;
> +
> +	/*
> +	 * Allocate a large enough buffer for the entire negotiation:
> +	 * 4k should be enough to ffdhe8192.
> +	 */
> +	chap->buf_size = 4096;
> +	chap->buf = kzalloc(chap->buf_size, GFP_KERNEL);
> +	if (!chap->buf) {
> +		mutex_unlock(&ctrl->dhchap_auth_mutex);
> +		kfree(chap);
> +		return -ENOMEM;
> +	}
> +
> +	INIT_WORK(&chap->auth_work, __nvme_auth_work);
> +	list_add(&chap->entry, &ctrl->dhchap_auth_list);
> +	mutex_unlock(&ctrl->dhchap_auth_mutex);
> +	queue_work(nvme_wq, &chap->auth_work);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_negotiate);
> +
> +int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid)
> +{
> +	struct nvme_dhchap_queue_context *chap;
> +	int ret;
> +
> +	mutex_lock(&ctrl->dhchap_auth_mutex);
> +	list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
> +		if (chap->qid != qid)
> +			continue;
> +		mutex_unlock(&ctrl->dhchap_auth_mutex);
> +		flush_work(&chap->auth_work);
> +		ret = chap->error;
> +		__nvme_auth_reset(chap);
> +		return ret;
> +	}
> +	mutex_unlock(&ctrl->dhchap_auth_mutex);
> +	return -ENXIO;
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_wait);
> +
> +void nvme_auth_reset(struct nvme_ctrl *ctrl)
> +{
> +	struct nvme_dhchap_queue_context *chap;
> +
> +	mutex_lock(&ctrl->dhchap_auth_mutex);
> +	list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
> +		mutex_unlock(&ctrl->dhchap_auth_mutex);
> +		flush_work(&chap->auth_work);
> +		__nvme_auth_reset(chap);
> +	}
> +	mutex_unlock(&ctrl->dhchap_auth_mutex);
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_reset);
> +
> +static void nvme_dhchap_auth_work(struct work_struct *work)
> +{
> +	struct nvme_ctrl *ctrl =
> +		container_of(work, struct nvme_ctrl, dhchap_auth_work);
> +	int ret, q;
> +
> +	/* Authenticate admin queue first */
> +	ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "qid 0: error %d setting up authentication\n", ret);
> +		return;
> +	}
> +	ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "qid 0: authentication failed\n");
> +		return;
> +	}
> +
maybe add a comment /* Authenticate IO queues */
> +	for (q = 1; q < ctrl->queue_count; q++) {
> +		ret = nvme_auth_negotiate(ctrl, q);
> +		if (ret) {
> +			dev_warn(ctrl->device,
> +				 "qid %d: error %d setting up authentication\n",
> +				 q, ret);
> +			break;
> +		}

shouldn't we wait for nvme_auth_wait ?

> +	}
> +
> +	/*
> +	 * Failure is a soft-state; credentials remain valid until
> +	 * the controller terminates the connection.
> +	 */
> +}
> +
> +void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
> +{
> +	INIT_LIST_HEAD(&ctrl->dhchap_auth_list);
> +	INIT_WORK(&ctrl->dhchap_auth_work, nvme_dhchap_auth_work);
> +	mutex_init(&ctrl->dhchap_auth_mutex);
> +	nvme_auth_generate_key(ctrl->opts->dhchap_secret, &ctrl->host_key);
> +	nvme_auth_generate_key(ctrl->opts->dhchap_ctrl_secret, &ctrl->ctrl_key);
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_init_ctrl);
> +
> +void nvme_auth_stop(struct nvme_ctrl *ctrl)
> +{
> +	struct nvme_dhchap_queue_context *chap = NULL, *tmp;
> +
> +	cancel_work_sync(&ctrl->dhchap_auth_work);
> +	mutex_lock(&ctrl->dhchap_auth_mutex);
> +	list_for_each_entry_safe(chap, tmp, &ctrl->dhchap_auth_list, entry)
> +		cancel_work_sync(&chap->auth_work);
> +	mutex_unlock(&ctrl->dhchap_auth_mutex);
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_stop);
> +
> +void nvme_auth_free(struct nvme_ctrl *ctrl)
> +{
> +	struct nvme_dhchap_queue_context *chap = NULL, *tmp;
> +
> +	mutex_lock(&ctrl->dhchap_auth_mutex);
> +	list_for_each_entry_safe(chap, tmp, &ctrl->dhchap_auth_list, entry) {
> +		list_del_init(&chap->entry);
> +		flush_work(&chap->auth_work);
> +		__nvme_auth_free(chap);
> +	}
> +	mutex_unlock(&ctrl->dhchap_auth_mutex);
> +	if (ctrl->host_key) {
> +		nvme_auth_free_key(ctrl->host_key);
> +		ctrl->host_key = NULL;
> +	}
> +	if (ctrl->ctrl_key) {
> +		nvme_auth_free_key(ctrl->ctrl_key);
> +		ctrl->ctrl_key = NULL;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(nvme_auth_free);
> diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
> new file mode 100644
> index 000000000000..2f39d17296d1
> --- /dev/null
> +++ b/drivers/nvme/host/auth.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Hannes Reinecke, SUSE Software Solutions
> + */
> +
> +#ifndef _NVME_AUTH_H
> +#define _NVME_AUTH_H
> +
> +#include <crypto/kpp.h>
> +
> +struct nvme_dhchap_key {
> +	u8 *key;
> +	size_t len;
> +	u8 hash;
> +};
> +
> +u32 nvme_auth_get_seqnum(void);
> +const char *nvme_auth_dhgroup_name(u8 dhgroup_id);
> +size_t nvme_auth_dhgroup_pubkey_size(u8 dhgroup_id);
> +size_t nvme_auth_dhgroup_privkey_size(u8 dhgroup_id);
> +const char *nvme_auth_dhgroup_kpp(u8 dhgroup_id);
> +u8 nvme_auth_dhgroup_id(const char *dhgroup_name);
> +
> +const char *nvme_auth_hmac_name(u8 hmac_id);
> +const char *nvme_auth_digest_name(u8 hmac_id);
> +size_t nvme_auth_hmac_hash_len(u8 hmac_id);
> +u8 nvme_auth_hmac_id(const char *hmac_name);
> +
> +struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
> +					      u8 key_hash);
> +void nvme_auth_free_key(struct nvme_dhchap_key *key);
> +u8 *nvme_auth_transform_key(struct nvme_dhchap_key *key, char *nqn);
> +
> +#endif /* _NVME_AUTH_H */
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 4b5de8f5435a..db9c8bc1cf50 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -24,6 +24,7 @@
>   
>   #include "nvme.h"
>   #include "fabrics.h"
> +#include "auth.h"
>   
>   #define CREATE_TRACE_POINTS
>   #include "trace.h"
> @@ -303,6 +304,7 @@ enum nvme_disposition {
>   	COMPLETE,
>   	RETRY,
>   	FAILOVER,
> +	AUTHENTICATE,
>   };
>   
>   static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
> @@ -310,6 +312,9 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
>   	if (likely(nvme_req(req)->status == 0))
>   		return COMPLETE;
>   
> +	if ((nvme_req(req)->status & 0x7ff) == NVME_SC_AUTH_REQUIRED)
> +		return AUTHENTICATE;
> +
>   	if (blk_noretry_request(req) ||
>   	    (nvme_req(req)->status & NVME_SC_DNR) ||
>   	    nvme_req(req)->retries >= nvme_max_retries)
> @@ -346,11 +351,13 @@ static inline void nvme_end_req(struct request *req)
>   
>   void nvme_complete_rq(struct request *req)
>   {
> +	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
> +
>   	trace_nvme_complete_rq(req);
>   	nvme_cleanup_cmd(req);
>   
> -	if (nvme_req(req)->ctrl->kas)
> -		nvme_req(req)->ctrl->comp_seen = true;
> +	if (ctrl->kas)
> +		ctrl->comp_seen = true;
>   
>   	switch (nvme_decide_disposition(req)) {
>   	case COMPLETE:
> @@ -362,6 +369,14 @@ void nvme_complete_rq(struct request *req)
>   	case FAILOVER:
>   		nvme_failover_req(req);
>   		return;
> +	case AUTHENTICATE:
> +#ifdef CONFIG_NVME_AUTH
> +		queue_work(nvme_wq, &ctrl->dhchap_auth_work);
> +		nvme_retry_req(req);
> +#else
> +		nvme_end_req(req);
> +#endif
> +		return;
>   	}
>   }
>   EXPORT_SYMBOL_GPL(nvme_complete_rq);
> @@ -699,7 +714,9 @@ bool __nvme_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
>   		switch (ctrl->state) {
>   		case NVME_CTRL_CONNECTING:
>   			if (blk_rq_is_passthrough(rq) && nvme_is_fabrics(req->cmd) &&
> -			    req->cmd->fabrics.fctype == nvme_fabrics_type_connect)
> +			    (req->cmd->fabrics.fctype == nvme_fabrics_type_connect ||
> +			     req->cmd->fabrics.fctype == nvme_fabrics_type_auth_send ||
> +			     req->cmd->fabrics.fctype == nvme_fabrics_type_auth_receive))
>   				return true;
>   			break;
>   		default:
> @@ -3494,6 +3511,108 @@ static ssize_t nvme_ctrl_fast_io_fail_tmo_store(struct device *dev,
>   static DEVICE_ATTR(fast_io_fail_tmo, S_IRUGO | S_IWUSR,
>   	nvme_ctrl_fast_io_fail_tmo_show, nvme_ctrl_fast_io_fail_tmo_store);
>   
> +#ifdef CONFIG_NVME_AUTH
> +static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
> +	struct nvmf_ctrl_options *opts = ctrl->opts;
> +
> +	if (!opts->dhchap_secret)
> +		return sysfs_emit(buf, "none\n");
> +	return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
> +}
> +
> +static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
> +	struct nvmf_ctrl_options *opts = ctrl->opts;
> +	char *dhchap_secret;
> +
> +	if (!ctrl->opts->dhchap_secret)
> +		return -EINVAL;
> +	if (count < 7)
> +		return -EINVAL;
> +	if (memcmp(buf, "DHHC-1:", 7))
> +		return -EINVAL;
> +
> +	dhchap_secret = kzalloc(count + 1, GFP_KERNEL);
> +	if (!dhchap_secret)
> +		return -ENOMEM;
> +	memcpy(dhchap_secret, buf, count);
> +	nvme_auth_stop(ctrl);
> +	if (strcmp(dhchap_secret, opts->dhchap_secret)) {
> +		int ret;
> +
> +		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->host_key);
> +		if (ret)

shouldn't we free dhchap_secret ?

> +			return ret;
> +		kfree(opts->dhchap_secret);
> +		opts->dhchap_secret = dhchap_secret;
> +		/* Key has changed; re-authentication with new key */
> +		nvme_auth_reset(ctrl);
> +	}
> +	/* Start re-authentication */
> +	dev_info(ctrl->device, "re-authenticating controller\n");
> +	queue_work(nvme_wq, &ctrl->dhchap_auth_work);
> +
> +	return count;
> +}
> +DEVICE_ATTR(dhchap_secret, S_IRUGO | S_IWUSR,
> +	nvme_ctrl_dhchap_secret_show, nvme_ctrl_dhchap_secret_store);
> +
> +static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
> +	struct nvmf_ctrl_options *opts = ctrl->opts;
> +
> +	if (!opts->dhchap_ctrl_secret)
> +		return sysfs_emit(buf, "none\n");
> +	return sysfs_emit(buf, "%s\n", opts->dhchap_ctrl_secret);
> +}
> +
> +static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
> +	struct nvmf_ctrl_options *opts = ctrl->opts;
> +	char *dhchap_secret;
> +
> +	if (!ctrl->opts->dhchap_ctrl_secret)
> +		return -EINVAL;
> +	if (count < 7)
> +		return -EINVAL;
> +	if (memcmp(buf, "DHHC-1:", 7))
> +		return -EINVAL;
> +
> +	dhchap_secret = kzalloc(count + 1, GFP_KERNEL);
> +	if (!dhchap_secret)
> +		return -ENOMEM;
> +	memcpy(dhchap_secret, buf, count);
> +	nvme_auth_stop(ctrl);
> +	if (strcmp(dhchap_secret, opts->dhchap_ctrl_secret)) {
> +		int ret;
> +
> +		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->ctrl_key);
> +		if (ret)

same free here.

> +			return ret;
> +		kfree(opts->dhchap_ctrl_secret);
> +		opts->dhchap_ctrl_secret = dhchap_secret;
> +		/* Key has changed; re-authentication with new key */
> +		nvme_auth_reset(ctrl);
> +	}
> +	/* Start re-authentication */
> +	dev_info(ctrl->device, "re-authenticating controller\n");
> +	queue_work(nvme_wq, &ctrl->dhchap_auth_work);
> +
> +	return count;
> +}
> +DEVICE_ATTR(dhchap_ctrl_secret, S_IRUGO | S_IWUSR,
> +	nvme_ctrl_dhchap_ctrl_secret_show, nvme_ctrl_dhchap_ctrl_secret_store);
> +#endif
> +
>   static struct attribute *nvme_dev_attrs[] = {
>   	&dev_attr_reset_controller.attr,
>   	&dev_attr_rescan_controller.attr,
> @@ -3515,6 +3634,10 @@ static struct attribute *nvme_dev_attrs[] = {
>   	&dev_attr_reconnect_delay.attr,
>   	&dev_attr_fast_io_fail_tmo.attr,
>   	&dev_attr_kato.attr,
> +#ifdef CONFIG_NVME_AUTH
> +	&dev_attr_dhchap_secret.attr,
> +	&dev_attr_dhchap_ctrl_secret.attr,
> +#endif

Not sure if we need to change the user interface according to kernel CONFIGs


>   	NULL
>   };
>   
> @@ -3538,6 +3661,10 @@ static umode_t nvme_dev_attrs_are_visible(struct kobject *kobj,
>   		return 0;
>   	if (a == &dev_attr_fast_io_fail_tmo.attr && !ctrl->opts)
>   		return 0;
> +#ifdef CONFIG_NVME_AUTH
> +	if (a == &dev_attr_dhchap_secret.attr && !ctrl->opts)
> +		return 0;
> +#endif
>   
>   	return a->mode;
>   }
> @@ -4302,8 +4429,10 @@ static void nvme_handle_aen_notice(struct nvme_ctrl *ctrl, u32 result)
>   		 * recovery actions from interfering with the controller's
>   		 * firmware activation.
>   		 */
> -		if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
> +		if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING)) {
> +			nvme_auth_stop(ctrl);
>   			queue_work(nvme_wq, &ctrl->fw_act_work);
> +		}
>   		break;
>   #ifdef CONFIG_NVME_MULTIPATH
>   	case NVME_AER_NOTICE_ANA:
> @@ -4350,6 +4479,7 @@ EXPORT_SYMBOL_GPL(nvme_complete_async_event);
>   void nvme_stop_ctrl(struct nvme_ctrl *ctrl)
>   {
>   	nvme_mpath_stop(ctrl);
> +	nvme_auth_stop(ctrl);
>   	nvme_stop_keep_alive(ctrl);
>   	nvme_stop_failfast_work(ctrl);
>   	flush_work(&ctrl->async_event_work);
> @@ -4404,6 +4534,8 @@ static void nvme_free_ctrl(struct device *dev)
>   
>   	nvme_free_cels(ctrl);
>   	nvme_mpath_uninit(ctrl);
> +	nvme_auth_stop(ctrl);
> +	nvme_auth_free(ctrl);
>   	__free_page(ctrl->discard_page);
>   
>   	if (subsys) {
> @@ -4494,6 +4626,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
>   
>   	nvme_fault_inject_init(&ctrl->fault_inject, dev_name(ctrl->device));
>   	nvme_mpath_init_ctrl(ctrl);
> +	nvme_auth_init_ctrl(ctrl);
>   
>   	return 0;
>   out_free_name:
> diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
> index a1343a0790f6..0ac054f80a82 100644
> --- a/drivers/nvme/host/fabrics.c
> +++ b/drivers/nvme/host/fabrics.c
> @@ -370,6 +370,7 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
>   	union nvme_result res;
>   	struct nvmf_connect_data *data;
>   	int ret;
> +	u32 result;
>   
>   	cmd.connect.opcode = nvme_fabrics_command;
>   	cmd.connect.fctype = nvme_fabrics_type_connect;
> @@ -402,8 +403,25 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
>   		goto out_free_data;
>   	}
>   
> -	ctrl->cntlid = le16_to_cpu(res.u16);
> -
> +	result = le32_to_cpu(res.u32);
> +	ctrl->cntlid = result & 0xFFFF;
> +	if ((result >> 16) & 2) {
> +		/* Authentication required */
> +		ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
> +		if (ret) {
> +			dev_warn(ctrl->device,
> +				 "qid 0: authentication setup failed\n");
> +			ret = NVME_SC_AUTH_REQUIRED;
> +			goto out_free_data;
> +		}
> +		ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
> +		if (ret)
> +			dev_warn(ctrl->device,
> +				 "qid 0: authentication failed\n");
> +		else
> +			dev_info(ctrl->device,
> +				 "qid 0: authenticated\n");
> +	}
>   out_free_data:
>   	kfree(data);
>   	return ret;
> @@ -436,6 +454,7 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
>   	struct nvmf_connect_data *data;
>   	union nvme_result res;
>   	int ret;
> +	u32 result;
>   
>   	cmd.connect.opcode = nvme_fabrics_command;
>   	cmd.connect.fctype = nvme_fabrics_type_connect;
> @@ -461,6 +480,21 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
>   		nvmf_log_connect_error(ctrl, ret, le32_to_cpu(res.u32),
>   				       &cmd, data);
>   	}
> +	result = le32_to_cpu(res.u32);
> +	if ((result >> 16) & 2) {
> +		/* Authentication required */
> +		ret = nvme_auth_negotiate(ctrl, qid);
> +		if (ret) {
> +			dev_warn(ctrl->device,
> +				 "qid %d: authentication setup failed\n", qid);
> +			ret = NVME_SC_AUTH_REQUIRED;
> +		} else {
> +			ret = nvme_auth_wait(ctrl, qid);
> +			if (ret)
> +				dev_warn(ctrl->device,
> +					 "qid %u: authentication failed\n", qid);
> +		}
> +	}

can we add helper function to the above code to avoid duplication ?


>   	kfree(data);
>   	return ret;
>   }
> @@ -553,6 +587,8 @@ static const match_table_t opt_tokens = {
>   	{ NVMF_OPT_TOS,			"tos=%d"		},
>   	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
>   	{ NVMF_OPT_DISCOVERY,		"discovery"		},
> +	{ NVMF_OPT_DHCHAP_SECRET,	"dhchap_secret=%s"	},
> +	{ NVMF_OPT_DHCHAP_CTRL_SECRET,	"dhchap_ctrl_secret=%s"	},
>   	{ NVMF_OPT_ERR,			NULL			}
>   };
>   
> @@ -831,6 +867,34 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
>   		case NVMF_OPT_DISCOVERY:
>   			opts->discovery_nqn = true;
>   			break;
> +		case NVMF_OPT_DHCHAP_SECRET:
> +			p = match_strdup(args);
> +			if (!p) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
> +				pr_err("Invalid DH-CHAP secret %s\n", p);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +			kfree(opts->dhchap_secret);
> +			opts->dhchap_secret = p;
> +			break;
> +		case NVMF_OPT_DHCHAP_CTRL_SECRET:
> +			p = match_strdup(args);
> +			if (!p) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
> +				pr_err("Invalid DH-CHAP secret %s\n", p);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +			kfree(opts->dhchap_ctrl_secret);
> +			opts->dhchap_ctrl_secret = p;
> +			break;
>   		default:
>   			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
>   				p);
> @@ -949,6 +1013,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
>   	kfree(opts->subsysnqn);
>   	kfree(opts->host_traddr);
>   	kfree(opts->host_iface);
> +	kfree(opts->dhchap_secret);
>   	kfree(opts);
>   }
>   EXPORT_SYMBOL_GPL(nvmf_free_options);
> @@ -958,7 +1023,8 @@ EXPORT_SYMBOL_GPL(nvmf_free_options);
>   				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
>   				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
>   				 NVMF_OPT_DISABLE_SQFLOW | NVMF_OPT_DISCOVERY |\
> -				 NVMF_OPT_FAIL_FAST_TMO)
> +				 NVMF_OPT_FAIL_FAST_TMO | NVMF_OPT_DHCHAP_SECRET |\
> +				 NVMF_OPT_DHCHAP_CTRL_SECRET)
>   
>   static struct nvme_ctrl *
>   nvmf_create_ctrl(struct device *dev, const char *buf)
> @@ -1175,7 +1241,14 @@ static void __exit nvmf_exit(void)
>   	BUILD_BUG_ON(sizeof(struct nvmf_connect_command) != 64);
>   	BUILD_BUG_ON(sizeof(struct nvmf_property_get_command) != 64);
>   	BUILD_BUG_ON(sizeof(struct nvmf_property_set_command) != 64);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_send_command) != 64);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_receive_command) != 64);
>   	BUILD_BUG_ON(sizeof(struct nvmf_connect_data) != 1024);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_negotiate_data) != 8);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_challenge_data) != 16);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_reply_data) != 16);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_success1_data) != 16);
> +	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_success2_data) != 16);
>   }
>   
>   MODULE_LICENSE("GPL v2");
> diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
> index c3203ff1c654..c2a03d99ac26 100644
> --- a/drivers/nvme/host/fabrics.h
> +++ b/drivers/nvme/host/fabrics.h
> @@ -68,6 +68,8 @@ enum {
>   	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
>   	NVMF_OPT_HOST_IFACE	= 1 << 21,
>   	NVMF_OPT_DISCOVERY	= 1 << 22,
> +	NVMF_OPT_DHCHAP_SECRET	= 1 << 23,
> +	NVMF_OPT_DHCHAP_CTRL_SECRET = 1 << 24,
>   };
>   
>   /**
> @@ -97,6 +99,9 @@ enum {
>    * @max_reconnects: maximum number of allowed reconnect attempts before removing
>    *              the controller, (-1) means reconnect forever, zero means remove
>    *              immediately;
> + * @dhchap_secret: DH-HMAC-CHAP secret
> + * @dhchap_ctrl_secret: DH-HMAC-CHAP controller secret for bi-directional
> + *              authentication
>    * @disable_sqflow: disable controller sq flow control
>    * @hdr_digest: generate/verify header digest (TCP)
>    * @data_digest: generate/verify data digest (TCP)
> @@ -121,6 +126,8 @@ struct nvmf_ctrl_options {
>   	unsigned int		kato;
>   	struct nvmf_host	*host;
>   	int			max_reconnects;
> +	char			*dhchap_secret;
> +	char			*dhchap_ctrl_secret;
>   	bool			disable_sqflow;
>   	bool			hdr_digest;
>   	bool			data_digest;
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index b334af8aa264..740a2780a4d4 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -324,6 +324,15 @@ struct nvme_ctrl {
>   	struct work_struct ana_work;
>   #endif
>   
> +#ifdef CONFIG_NVME_AUTH
> +	struct work_struct dhchap_auth_work;
> +	struct list_head dhchap_auth_list;
> +	struct mutex dhchap_auth_mutex;
> +	struct nvme_dhchap_key *host_key;
> +	struct nvme_dhchap_key *ctrl_key;
> +	u16 transaction;
> +#endif
> +
>   	/* Power saving configuration */
>   	u64 ps_max_latency_us;
>   	bool apst_enabled;
> @@ -910,6 +919,28 @@ static inline bool nvme_ctrl_sgl_supported(struct nvme_ctrl *ctrl)
>   	return ctrl->sgls & ((1 << 0) | (1 << 1));
>   }
>   
> +#ifdef CONFIG_NVME_AUTH
> +void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl);
> +void nvme_auth_stop(struct nvme_ctrl *ctrl);
> +int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid);
> +int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid);
> +void nvme_auth_reset(struct nvme_ctrl *ctrl);
> +void nvme_auth_free(struct nvme_ctrl *ctrl);
> +int nvme_auth_generate_key(u8 *secret, struct nvme_dhchap_key **ret_key);
> +#else
> +static inline void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl) {};
> +static inline void nvme_auth_stop(struct nvme_ctrl *ctrl) {};
> +static inline int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
> +{
> +	return -EPROTONOSUPPORT;
> +}
> +static inline int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid)
> +{
> +	return NVME_SC_AUTH_REQUIRED;
> +}
> +static inline void nvme_auth_free(struct nvme_ctrl *ctrl) {};
> +#endif
> +
>   u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>   			 u8 opcode);
>   int nvme_execute_passthru_rq(struct request *rq);
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 850f84d204d0..a8db8ab87dbc 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1199,6 +1199,7 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
>   	struct nvme_rdma_ctrl *ctrl = container_of(work,
>   			struct nvme_rdma_ctrl, err_work);
>   
> +	nvme_auth_stop(&ctrl->ctrl);
>   	nvme_stop_keep_alive(&ctrl->ctrl);
>   	nvme_rdma_teardown_io_queues(ctrl, false);
>   	nvme_start_queues(&ctrl->ctrl);
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 33bc83d8d992..bd8c724b3d13 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -2096,6 +2096,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
>   				struct nvme_tcp_ctrl, err_work);
>   	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
>   
> +	nvme_auth_stop(ctrl);
>   	nvme_stop_keep_alive(ctrl);
>   	nvme_tcp_teardown_io_queues(ctrl, false);
>   	/* unquiesce to fail fast pending requests */
> diff --git a/drivers/nvme/host/trace.c b/drivers/nvme/host/trace.c
> index 2a89c5aa0790..1c36fcedea20 100644
> --- a/drivers/nvme/host/trace.c
> +++ b/drivers/nvme/host/trace.c
> @@ -287,6 +287,34 @@ static const char *nvme_trace_fabrics_property_get(struct trace_seq *p, u8 *spc)
>   	return ret;
>   }

I think we need to add a dedicated commit for the traces.


>   
> +static const char *nvme_trace_fabrics_auth_send(struct trace_seq *p, u8 *spc)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p);
> +	u8 spsp0 = spc[1];
> +	u8 spsp1 = spc[2];
> +	u8 secp = spc[3];
> +	u32 tl = get_unaligned_le32(spc + 4);
> +
> +	trace_seq_printf(p, "spsp0=%02x, spsp1=%02x, secp=%02x, tl=%u",
> +			 spsp0, spsp1, secp, tl);
> +	trace_seq_putc(p, 0);
> +	return ret;
> +}
> +
> +static const char *nvme_trace_fabrics_auth_receive(struct trace_seq *p, u8 *spc)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p);
> +	u8 spsp0 = spc[1];
> +	u8 spsp1 = spc[2];
> +	u8 secp = spc[3];
> +	u32 al = get_unaligned_le32(spc + 4);
> +
> +	trace_seq_printf(p, "spsp0=%02x, spsp1=%02x, secp=%02x, al=%u",
> +			 spsp0, spsp1, secp, al);
> +	trace_seq_putc(p, 0);
> +	return ret;
> +}
> +
>   static const char *nvme_trace_fabrics_common(struct trace_seq *p, u8 *spc)
>   {
>   	const char *ret = trace_seq_buffer_ptr(p);
> @@ -306,6 +334,10 @@ const char *nvme_trace_parse_fabrics_cmd(struct trace_seq *p,
>   		return nvme_trace_fabrics_connect(p, spc);
>   	case nvme_fabrics_type_property_get:
>   		return nvme_trace_fabrics_property_get(p, spc);
> +	case nvme_fabrics_type_auth_send:
> +		return nvme_trace_fabrics_auth_send(p, spc);
> +	case nvme_fabrics_type_auth_receive:
> +		return nvme_trace_fabrics_auth_receive(p, spc);
>   	default:
>   		return nvme_trace_fabrics_common(p, spc);
>   	}

did you test this code with NVMe/RDMA transport too ?


