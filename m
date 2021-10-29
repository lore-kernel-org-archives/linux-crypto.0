Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E62C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B41F610CB
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJ2Oru (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:47:50 -0400
Received: from mail-mw2nam12on2047.outbound.protection.outlook.com ([40.107.244.47]:9346
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229811AbhJ2Ors (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:47:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0Y11pdznUIfYcYRIuBgFXcutmSfU8mu85D/XYGo2WQrVhwZm1CWLicfP+qwJTII3Ay+PbQUiGPbf4gkLhOu41nf85SPIuV1RR5uTQxNCI6s0/rUhKJPiNS80DB11kAvVOkx+3tjNaZK/LxJVxl5kB14EwLO7Cg8s7nYTNUWNLXqfto1Fwq8ZcjfodZY7SYmFkXz/cn907O2A7VFnpY8GTcbJPWAZEmHixOHrU62QE5Szm4BBYy7LI/A6FBA8s8ud6ZbuyG863w8iJ3n4zGXjNpRwR56YuJ16olupQ1+JoaOOgN6tOQsh2G2J0RM+/odX4WTQ7kM9i+W+WuWIi8jhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9GG9A6RyFdztiRTUHpL8Zy2fj2S2FrW3/7zWncSQkg=;
 b=EtcEwngwoXR3flCQPrqMyrjBMX1enliWx4uUztuIVrKUbtudnmLu/jbPkooZthfgGdD47XFBi9p86CA2O/SzDfKtR+eoEZUvyxeDvSQVwf27aqIYw5vlhiF1TqrWnMIa6tqucAGj0Iq6D+yC3CpwQU7SecHBIXNUX0SunMszgKfjZxoxq3+o7P5DFdbCi4NFYfxtX6RD2yXxF4hLXEE6clHSqLxS9uHVGD8H72vfTYkHzdo55aF1acC+Mkk+FW4PYqLB0Oh/Vc6ztgDoM6ha2t4AKVARyuX/IRuU1FF8z28KMHHVzOp3uZ5a74AYVCz9hjG9hLdVbXv6n6d8lSpx0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9GG9A6RyFdztiRTUHpL8Zy2fj2S2FrW3/7zWncSQkg=;
 b=OK2N7KS8PM0Q7lBYK7iSQ3C4tk2tbdw00Dad08Vl+Tziyfvjb/4X5dscso4cYVYxJRhpeWxSAgp8c2ksn+1XJt1nGJz0I0LGEpFZ81mjq4tD30W8DAa3JtY79NEAmhBO/KhHlzKQ8dzurj5yzu3IAj/oXhA4PYwfzrIjFUXL1l8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5231.namprd12.prod.outlook.com (2603:10b6:5:39b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 14:45:17 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 14:45:16 +0000
Subject: Re: [PATCH 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Peter Gonda <pgonda@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211028175749.1219188-1-pgonda@google.com>
 <20211028175749.1219188-5-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c2076ecf-8b30-c96e-2169-bc1f031d309e@amd.com>
Date:   Fri, 29 Oct 2021 09:45:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211028175749.1219188-5-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0077.namprd12.prod.outlook.com
 (2603:10b6:802:20::48) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN1PR12CA0077.namprd12.prod.outlook.com (2603:10b6:802:20::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 14:45:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7095acc-5cc4-4a68-8a33-08d99aeab8f9
X-MS-TrafficTypeDiagnostic: DM4PR12MB5231:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5231E35F31691973701707F0EC879@DM4PR12MB5231.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IaLLKpuxgGOGupCvsnxrikDhVSG1Xm2oyXp2C62JD5Z+/X4AfvykAK3aKkKw9Xz/66vjIglgl4M7B+y/dWepaQNOWGV56zjvQzNohxrnxcvsNn+Wz4f/1oaW74lud4FQzgA/JGy3jIeR+kf0MEVYTuMXtd2zD5xgDF3qkdBHlcj0SO3/wM0mf9qoLZNw0Xim5Wmjh/A3K2pmCb1bflS7LoNC1o/ph/6NTzYkI3Gj1wm/DC0r4LVPPWIzvuTfhU2Ni0SgH++kEqtTYf5F5OnqfL4BIA8pHnXkbmaq1D8GTIJoM5WW8FCVSQbrHv1IvrwaedddX84bYzbxFbng6i88SXm94LP0z1vBPBsu++yPqj7AOgdyP9YyUnKd1YbjoX8CX6Dvb/SodsehUUILEKMzPdPKYVX1DT9C+ufS9iJEHV4ZXwqaHYAAZF/ngVOJKPq3fCiiqd3nXv3fvt8/I3DUavkrQ4aqu5O4Q8CStHHYx7dDKT3Y00YbcP8sGAwI51CvyR8/OazTadVs6D7i6HUYuPaFoKFLSnnNStTXO45IMh3Iaw+H/qCfehuasyarPtMSVomhuYZgDYANwEwzi3HP32tpX9pJ0EhzOOZpaoLEJTu9lbcmI+RfkCj8rHsMrEAHomGlqWKUYZtpaoKH+r9OalCqo+kiKkWBPBO1biCh43CSqPGlUYZdpcT0KCcOa47kBttrbNVj0THHqKhP7LOuQD52x6RnUbFodo4lWb50TL2WKvchMbCiQZDbAnNO+3VW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2906002)(6512007)(86362001)(54906003)(26005)(6486002)(316002)(31686004)(508600001)(30864003)(5660300002)(36756003)(53546011)(4326008)(66476007)(956004)(8936002)(2616005)(31696002)(8676002)(6916009)(83380400001)(6506007)(38100700002)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M05YU1k2L2RYc2F5LzZ0SXF5RXErVkZoUTF5Njl3RmtmdTNhQXFxZDhGYUdn?=
 =?utf-8?B?T2gvWVVMWUxZQlVEaFd4N2RjRWtGYWplNHVVaU1DR2E2eGxiQWh1Y0dqS05x?=
 =?utf-8?B?Wm5XOTZkRWNFcVFmTXNsMnFMeU5WcWZjTVNkUytPRnd0VTdoTnNuYmRDaGdT?=
 =?utf-8?B?TERiZWVrZkxHSVZpUEVacCtYM1k4R1NxK1BCL3RTL2FuMDV3WEp5d0NTRVZP?=
 =?utf-8?B?K3F2eXZRRkFwaWJHcXpSdUwyVCtPc0E5cS9OQzNBWEYxby92OHEzTnNsYThl?=
 =?utf-8?B?UklHcnpYUzJWWk9SUFlpMERpSWw3VWF5RjF0WXdVaTdTT1ByNE1YandzWHRG?=
 =?utf-8?B?enN4RVpUL0MxK3pWaXpBVHAwV3BFL3AwakViVGtSRGFzcUZZL0tBT29RcUNa?=
 =?utf-8?B?Y09SOHMvQVNDaGlUVXdpdG84K0dYUUh3bndVbFVNQVE4cFd0U1lWN3pyOU1r?=
 =?utf-8?B?SFhtazFKaDZoWm1rSDlnbkZDYzBOWnpMeHVhVFFTb2Z3QVgxcEhDQTVDUjI1?=
 =?utf-8?B?SDhVd0xtUG9nWEQ2M1c2WjNiTVRTcjJHL3FSTXV0bUdEQVpxNWwzSUlKR3Rx?=
 =?utf-8?B?ZWhpN09EaEJISFpORkFFNVhzL1VpeFlmbUNUc21hMUw2THlrSDdGaXc0MnU1?=
 =?utf-8?B?d1hQZVVwRWxhWTN2cTgxVXNwYzNQT2Q5UDQzRTZLRHdDNTBMUjJaWDNNMGtx?=
 =?utf-8?B?blJ2ZDZjNkgxMk5tREoyLzJBdnVObUs0bURValA2NGhtZ2JJYTJ2OHIzeWlJ?=
 =?utf-8?B?WnVUVTc0d2ZCcEx3RzJ4eStJUGhZbHJBQmN2K3V0QXM1NyttYUtZQXJqcU04?=
 =?utf-8?B?U1NycjBJaWQ0eDdtZ1hWQzd2TkFjZ1lNVkFQclp4ZGM0VkgxOWRiS3lEZisr?=
 =?utf-8?B?YjdzSWxkK0srcjVHOHR2VFdIbE03YTR4V2NlcU5aSlRDUTY0Y1BtaUlSNGRO?=
 =?utf-8?B?QTNFbGd4RStnUVdjK1VuM0g5Y2dPNGw4RkQvRG9aSG5jMWkrdDlZR1lHcVpO?=
 =?utf-8?B?eVpsSk54cGF2ZURIVjFvakVQUzhOVThvTE42Vk1pZDJQdjViUStxR1ZJejRF?=
 =?utf-8?B?YWJucExTTm9IUlFVSGthckRMMG5RKzlKVHh5RktMdDc1TU9KYU42cUx0YzVE?=
 =?utf-8?B?dDJnaVFSbnFOa0VqN09lNE5hVFhodjhkT0QyNldWSmVEaVFxSHBwWTZVYjA2?=
 =?utf-8?B?Z2V0M01sSUNHRWMvYUs2dmtzOUdnUTZoL1F2a1Jjak90MTVRa0NmRjIxWkgw?=
 =?utf-8?B?M1Zwd1ZTQU1ZM25TK3Radjl5NksxbGc3SjNTazNtNi9iWWkxRjZacUVaWnNw?=
 =?utf-8?B?RmNWbnJ3TDlILzRnRWFHUDF4enJTcmdwVEpqTkJ6My96YlZsakFLOHNmbW5F?=
 =?utf-8?B?a1pwSFhTc2VTOE1lRnBiOVo2QVBFd3hmMi8yRTN0UGt5RVNYalFiRlpZV25i?=
 =?utf-8?B?TDBSalNFVE1lblJxVjJxUzdnZ25naFB4VzNkdGpRZ1BRcnRjcEx5NysrOWJV?=
 =?utf-8?B?VUZtQjRTZzJ1SHlhOWJ4Y1BBOWhPRkcxcXlLUStqWGxmZUFveHY3ZU1EdnV6?=
 =?utf-8?B?aDE4cGJDWnhpS2hZTFlRMmRVMmc5Q1BDQUtKTlNwZlBxRldwajBhSVppN2pu?=
 =?utf-8?B?aEN2TlBKcS9ueThDNjdjN2tEWlQ5cm5DTFdsUGFoQWp1dkt1YWNQbXMvTDdk?=
 =?utf-8?B?dWFFOTV4dDZodzhxS0J3UXNSMlBoSGxCK0pnRTJod0Z0RDB0KzBYV09WLy9k?=
 =?utf-8?B?TlQ2SmR4ejFRa0NsTXNxRktiWVB1YlRSTzdIbXRIbVFtYmtSZ2N0MzBHdGlP?=
 =?utf-8?B?N1JlV0xVOGYxb0xTT212TzE2dFRXLzB2VTBVYmZnQzZ6eGhPSTF0LzJmWm5D?=
 =?utf-8?B?c09ZMTROZ0k0M3AxOFRRKzdqY0xnYXEvWElEQjN1VDE3L1RqZGxJc3BTWGFr?=
 =?utf-8?B?dlZHTFNSaUxsYWxsOHJZRHYweHRIS3BicTcrSW82MEZsMmRxRGRobU5vb3BO?=
 =?utf-8?B?eXoyd0FGSkxEZWswenNsSTI1em8wdysrSjl4UDg3R3M4dGdIanViWHJmNUlv?=
 =?utf-8?B?M2l6cnR2K1dVa2VtM3RCUmE5NWYyOHMrNE1Ub1BTV2xYaEZERlpvK3QzT0Zz?=
 =?utf-8?B?NWZ2Wkg2UnFWQVk4eG1oeDJpazZ5N2YvOGZTMU1RK0lMUWcvN0hVNUxBcG9E?=
 =?utf-8?Q?6r9uR5k3ylaQqwUZGZhpCxs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7095acc-5cc4-4a68-8a33-08d99aeab8f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 14:45:16.8371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzhgYrCwSm2NCLjkFfoTC1cPxB83cBVL+Y+bUtY1vcNGpdllSXQ07RKd+30vITrgcWmrU9IsbOYLhgrMbDxMzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5231
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/28/21 12:57 PM, Peter Gonda wrote:
> From: David Rientjes <rientjes@google.com>
> 
> Add new module parameter to allow users to use SEV_INIT_EX instead of
> SEV_INIT. This helps users who lock their SPI bus to use the PSP for SEV
> functionality. The 'init_ex_path' parameter defaults to NULL which means
> the kernel will use SEV_INIT, if a path is specified SEV_INIT_EX will be
> used with the data found at the path. On certain PSP commands this
> file is written to as the PSP updates the NV memory region. Depending on
> file system initialization this file open may fail during module init
> but the CCP driver for SEV already has sufficient retries for platform
> initialization. During normal operation of PSP system and SEV commands
> if the PSP has not been initialized it is at run time.

IIUC, it looks as though the file has to exist before the very first use, 
otherwise the initialization will fail. Did you consider checking for the 
presence of the file first and, if not there, just using a memory area of 
all f's (as documented in the SEV API)? Then on successful INIT, the 
memory would be written and the file created.

Either way, probably worth adding to the commit message. And if you stay 
with having to pre-allocate the file, it's worth adding to the SEV 
documentation what is required to be done to initialize the file.

Although, INIT_EX is probably worth adding to the SEV documentation in 
general.

> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Co-developed-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paolo Bonzini <pbonzini@redhat.com> (
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/crypto/ccp/sev-dev.c | 186 ++++++++++++++++++++++++++++++++---
>   include/linux/psp-sev.h      |  21 ++++
>   2 files changed, 192 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b568ae734857..c8718b4cbc93 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -22,6 +22,7 @@
>   #include <linux/firmware.h>
>   #include <linux/gfp.h>
>   #include <linux/cpufeature.h>
> +#include <linux/fs.h>
>   
>   #include <asm/smp.h>
>   
> @@ -43,6 +44,10 @@ static int psp_probe_timeout = 5;
>   module_param(psp_probe_timeout, int, 0644);
>   MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
>   
> +static char *init_ex_path;
> +module_param(init_ex_path, charp, 0660);
> +MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
> +
>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -58,6 +63,14 @@ static int psp_timeout;
>   #define SEV_ES_TMR_SIZE		(1024 * 1024)
>   static void *sev_es_tmr;
>   
> +/* INIT_EX NV Storage:
> + *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Use the page
> + *   allocator to allocate the memory, which will return aligned memory for the
> + *   specified allocation order.
> + */
> +#define NV_LENGTH (32 << 10)

Just me, but I think '32 * 1024' would be a bit clearer.

> +static void *sev_init_ex_nv_address;
> +
>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> @@ -135,6 +148,7 @@ static int sev_cmd_buffer_len(int cmd)
>   	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
>   	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
>   	case SEV_CMD_SEND_CANCEL:			return sizeof(struct sev_data_send_cancel);
> +	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);

Maybe move this to just under the SEV_CMD_INIT: case statement?

>   	default:				return 0;
>   	}
>   
> @@ -156,6 +170,89 @@ static void *sev_fw_alloc(unsigned long len)
>   	return page_address(page);
>   }
>   
> +static int sev_read_nv_memory(void)
> +{
> +	struct file *fp;
> +	ssize_t nread;
> +
> +	if (!sev_init_ex_nv_address)
> +		return -EOPNOTSUPP;
> +
> +	fp = filp_open(init_ex_path, O_RDONLY, 0);
> +	if (IS_ERR(fp)) {
> +		dev_err(psp_master->dev, "sev could not open file for read\n");
> +		return PTR_ERR(fp);
> +	}
> +
> +	nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, 0);
> +	dev_dbg(psp_master->dev, "sev NV read %d bytes\n", nread);
> +	filp_close(fp, NULL);

Add a blank line here.

> +	return 0;
> +}
> +
> +static int sev_write_nv_memory(void)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct file *fp;
> +	loff_t offset = 0;
> +	int ret;
> +
> +	if (!sev_init_ex_nv_address)
> +		return -EOPNOTSUPP;
> +
> +	fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
> +	if (IS_ERR(fp)) {
> +		dev_err(sev->dev, "sev NV data could not be created\n");
> +		return PTR_ERR(fp);
> +	}

Add a blank line here.

> +	ret = kernel_write(fp, sev_init_ex_nv_address, NV_LENGTH, &offset);
> +	vfs_fsync(fp, 0);
> +	filp_close(fp, NULL);
> +
> +	if (ret != NV_LENGTH) {
> +		dev_err(sev->dev,
> +			"failed to write %d bytes to non volatile memory area, ret=%lu\n",
> +			NV_LENGTH, ret);
> +		if (ret >= 0)
> +			return -EIO;
> +		return ret;
> +	}
> +
> +	dev_dbg(sev->dev, "wrote to non volatile memory area\n");

Add a blank line here.

> +	return 0;
> +}
> +
> +static void sev_write_nv_memory_if_required(int cmd_id)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	int ret;
> +
> +	if (!sev_init_ex_nv_address)
> +		return;
> +
> +	/*
> +	 * Only a few platform commands modify the SPI/NV area,
> +	 * but none of the non-platform commands do. Only INIT,

maybe say INIT(_EX)?

> +	 * PLATFORM_RESET, PEK_GEN, PEK_CERT_IMPORT, and
> +	 * PDH_GEN do.

Does SHUTDOWN modify the SPI/NV area? Otherwise a separate comment about 
why it is included below.

> +	 */
> +	switch (cmd_id) {
> +	case SEV_CMD_FACTORY_RESET:
> +	case SEV_CMD_INIT_EX:
> +	case SEV_CMD_PDH_GEN:
> +	case SEV_CMD_PEK_CERT_IMPORT:
> +	case SEV_CMD_PEK_GEN:
> +	case SEV_CMD_SHUTDOWN:
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	ret = sev_write_nv_memory();
> +	if (ret)
> +		dev_err(sev->dev, "sev NV write failed %d\n", ret);

You already have error messages in the sev_write_nv_memory() function, 
this one probably isn't needed.

> +}
> +
>   static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   {
>   	struct psp_device *psp = psp_master;
> @@ -225,6 +322,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
>   			cmd, reg & PSP_CMDRESP_ERR_MASK);
>   		ret = -EIO;
> +	} else {
> +		sev_write_nv_memory_if_required(cmd);
>   	}
>   
>   	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> @@ -251,22 +350,42 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>   	return rc;
>   }
>   
> -static int __sev_platform_init_locked(int *error)
> +static int __sev_init_locked(int *error)
>   {
> -	struct psp_device *psp = psp_master;
>   	struct sev_data_init data;
> -	struct sev_device *sev;
> -	int rc = 0;
>   
> -	if (!psp || !psp->sev_data)
> -		return -ENODEV;
> +	memset(&data, 0, sizeof(data));
> +	if (sev_es_tmr) {
> +		u64 tmr_pa;
>   
> -	sev = psp->sev_data;
> +		/*
> +		 * Do not include the encryption mask on the physical
> +		 * address of the TMR (firmware should clear it anyway).
> +		 */
> +		tmr_pa = __pa(sev_es_tmr);
>   
> -	if (sev->state == SEV_STATE_INIT)
> -		return 0;
> +		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> +		data.tmr_address = tmr_pa;
> +		data.tmr_len = SEV_ES_TMR_SIZE;
> +	}
> +
> +	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +}
> +
> +static int __sev_init_ex_locked(int *error)
> +{
> +	struct sev_data_init_ex data;
> +	int ret;
>   
>   	memset(&data, 0, sizeof(data));
> +	data.length = sizeof(data);
> +	data.nv_address = __psp_pa(sev_init_ex_nv_address);
> +	data.nv_len = NV_LENGTH;
> +
> +	ret = sev_read_nv_memory();
> +	if (ret)
> +		return ret;
> +
>   	if (sev_es_tmr) {
>   		u64 tmr_pa;
>   
> @@ -276,12 +395,30 @@ static int __sev_platform_init_locked(int *error)
>   		 */
>   		tmr_pa = __pa(sev_es_tmr);
>   
> -		data.flags |= SEV_INIT_FLAGS_SEV_ES;

Inadvertant deletion?

>   		data.tmr_address = tmr_pa;
>   		data.tmr_len = SEV_ES_TMR_SIZE;
>   	}

Add a blank line here.

> +	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> +}
> +
> +static int __sev_platform_init_locked(int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	int rc;
> +	int (*init_function)(int *error) = sev_init_ex_nv_address ?
> +			__sev_init_ex_locked :
> +			__sev_init_locked;

This seems a bit much in the declaration. How about moving the assignment 
down to just before the first call?

> +
> +	if (!psp || !psp->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp->sev_data;
>   
> -	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +	if (sev->state == SEV_STATE_INIT)
> +		return 0;
> +
> +	rc = init_function(error);
>   	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
>   		/*
>   		 * INIT command returned an integrity check failure
> @@ -290,8 +427,8 @@ static int __sev_platform_init_locked(int *error)
>   		 * failed and persistent state has been erased.
>   		 * Retrying INIT command here should succeed.
>   		 */
> -		dev_dbg(sev->dev, "SEV: retrying INIT command");
> -		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +		dev_err(sev->dev, "SEV: retrying INIT command");

Maybe dev_notice() instead of dev_err()?

> +		rc = init_function(error);
>   	}
>   
>   	if (rc)
> @@ -307,7 +444,7 @@ static int __sev_platform_init_locked(int *error)
>   
>   	dev_dbg(sev->dev, "SEV firmware initialized\n");
>   
> -	return rc;
> +	return 0;
>   }
>   
>   int sev_platform_init(int *error)
> @@ -987,7 +1124,7 @@ static int sev_misc_init(struct sev_device *sev)
>   
>   	init_waitqueue_head(&sev->int_queue);
>   	sev->misc = misc_dev;
> -	dev_dbg(dev, "registered SEV device\n");
> +	dev_err(dev, "registered SEV device\n");

Not sure this is a necessary change... but, if you don't want this as a 
dev_dbg() then it should be a dev_info(), because it is not an error.

>   
>   	return 0;
>   }
> @@ -1061,6 +1198,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>   			   get_order(SEV_ES_TMR_SIZE));
>   		sev_es_tmr = NULL;
>   	}
> +
> +	if (sev_init_ex_nv_address) {
> +		free_pages((unsigned long)sev_init_ex_nv_address,
> +			   get_order(NV_LENGTH));
> +		sev_init_ex_nv_address = NULL;
> +	}
>   }
>   
>   void sev_dev_destroy(struct psp_device *psp)
> @@ -1105,6 +1248,19 @@ void sev_pci_init(void)
>   	    sev_update_firmware(sev->dev) == 0)
>   		sev_get_api_version();
>   
> +	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
> +	 * instead of INIT.
> +	 */
> +	if (init_ex_path) {
> +		sev_init_ex_nv_address = sev_fw_alloc(NV_LENGTH);
> +		if (!sev_init_ex_nv_address) {
> +			dev_warn(

Shouldn't this be a dev_err(), since you are erroring out?

> +				sev->dev,

Move this up to the previous line, i.e.: dev_err(sev->dev,

> +				"SEV: INIT_EX NV storage allocation failed, INIT-EX support unavailable\n");

Since you're erroring out, probably enough to just have the first part of 
that message. But if not:

s/INIT-EX/INIT_EX/

Thanks,
Tom

> +			goto err;
> +		}
> +	}
> +
>   	/* Obtain the TMR memory area for SEV-ES use */
>   	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
>   	if (!sev_es_tmr)
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d48a7192e881..1595088c428b 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -52,6 +52,7 @@ enum sev_cmd {
>   	SEV_CMD_DF_FLUSH		= 0x00A,
>   	SEV_CMD_DOWNLOAD_FIRMWARE	= 0x00B,
>   	SEV_CMD_GET_ID			= 0x00C,
> +	SEV_CMD_INIT_EX                 = 0x00D,
>   
>   	/* Guest commands */
>   	SEV_CMD_DECOMMISSION		= 0x020,
> @@ -102,6 +103,26 @@ struct sev_data_init {
>   	u32 tmr_len;			/* In */
>   } __packed;
>   
> +/**
> + * struct sev_data_init_ex - INIT_EX command parameters
> + *
> + * @length: len of the command buffer read by the PSP
> + * @flags: processing flags
> + * @tmr_address: system physical address used for SEV-ES
> + * @tmr_len: len of tmr_address
> + * @nv_address: system physical address used for PSP NV storage
> + * @nv_len: len of nv_address
> + */
> +struct sev_data_init_ex {
> +	u32 length;                     /* In */
> +	u32 flags;                      /* In */
> +	u64 tmr_address;                /* In */
> +	u32 tmr_len;                    /* In */
> +	u32 reserved;                   /* In */
> +	u64 nv_address;                 /* In/Out */
> +	u32 nv_len;                     /* In */
> +} __packed;
> +
>   #define SEV_INIT_FLAGS_SEV_ES	0x01
>   
>   /**
> 
