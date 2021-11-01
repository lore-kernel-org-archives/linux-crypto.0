Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96161C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 18:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7130060C40
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 18:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhKASnq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:43:46 -0400
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:51648
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231822AbhKASnp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 14:43:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aem5JixzO5EDA/e89VXHhCtxL+dS1u+4g9wT5N6RRMPPyLSsLpQG12ZGJfBAFhWPjKqGYGK6pR8xR0Pl2BfnkbgU63vMCAm5QLKbleUQFS7F3udbyLRoYrJQf0961LEZBsP1DcX2DyYElQGdPHSMdzkioCIfv0JvbFKlGYBpT0wZQFvzEkMHEF8aFhyrIwm1LOoeJxDJ38FM/Y6I+P7v+34RJbAkPwSQ8sJVY9EShiYjhu6a/QT3pcyyJd0s0mfSxPguRlBLA6lKLSrxbzWGrB2x6O9avl09VFtit/7EBr9BghJ6FETUvpKNnJIEbNN1vo8m97aW3LyRiW3QQDXjPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqtDfVH4Zzdk5iw0wdw1G9cAz/CF+ps/6n30MeR66Z0=;
 b=Oc9w/X47zgnKEHp7dT8QDGILacyHH4p4Lle8EDpxQnM9M1b9uSdf0CuMhBjVwQiVesLZhmiACbdym0EC6vIt91kxsZZWojgIX2HJ91gx0PUScSJHPgaBff51x/LCIXBxWw7omwOrMAlSVIdOBcvdqatTYNXAHL74jBe92v8B9ZApKhItg8l0WTHiTn9tR9RMo2qZ8Nor7buCd1kwI2KcDs8tF/hU7EvdZ9ZOjpJcxoicmYncpFqKVvMQ8SvEgaTET5eSp/+EZYmKQ/BmzTeXjSw3fAybALVgXmXrdrt71xLymFDPhxKmx+x4Jl4d9PhfqT6KykeycURwc3UjfR5jgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqtDfVH4Zzdk5iw0wdw1G9cAz/CF+ps/6n30MeR66Z0=;
 b=kPFvYD+rVl1xE1z3AaeWmE5YeOoU5Ia3LKKuP5z2SQH38mOsK1GpP5f+P2nNCPAdOBnGZIpTl8gMJcxL2XU4KZ7h6ToadUzOFniGCzkvRdxIpS4aISYHVloexIzeEZOrdwJc7jq+GjBZn0+WyAJGq1noIUVCBNCGxarM84N0nXY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5495.namprd12.prod.outlook.com (2603:10b6:8:33::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Mon, 1 Nov
 2021 18:41:10 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%8]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 18:41:10 +0000
Subject: Re: [PATCH V2 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Peter Gonda <pgonda@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211101172127.3060453-1-pgonda@google.com>
 <20211101172127.3060453-5-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <952fa937-d139-bd90-825c-f7dfca8d8cb9@amd.com>
Date:   Mon, 1 Nov 2021 13:41:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211101172127.3060453-5-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:208:160::14) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR13CA0001.namprd13.prod.outlook.com (2603:10b6:208:160::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6 via Frontend Transport; Mon, 1 Nov 2021 18:41:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52bf1ff3-74c1-4c62-4478-08d99d672c3d
X-MS-TrafficTypeDiagnostic: DM8PR12MB5495:
X-Microsoft-Antispam-PRVS: <DM8PR12MB549577B8E442840427D38351EC8A9@DM8PR12MB5495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWMscPMmkw0g0EIo1ANk7iiI1jWQg8o/+ha99T+mJQE/sTCq6y8GfI6d0ROqbUQIbHJ0t2s0OFnTR/AIe3TTr0NkWRjSbvnZOJPP8ueWR/KJ92YYj+8GImvLHmoJlf1nP3IR6MHZ6vsRAas2xvT0BvdFHdztSB2ID6hiAgzofD0UYF3kSgC3PZ7ZpTzp8zKoLm581S0V9F6hsHnVymz5ILK7B/xk3yzwo6nXakRLyxW1CcqOHbeEtCCa7m0rbgix/HTfqgr0L5gom1MvH082AH6z6sZNvv1463kKUP4ENMRxtMrh4ztLkytmd/xg6ywG2YaIZJ5PWDma/Lz4c0Z0AGpb6cjWqCu6AMPCC5UOtkSBHqHrb4KFduHMFF3ARftFgMne3CeyGF8C5+yDPjFe/+6Obp6ANcwwJQnkWo1Qya7YFi1mTlPyP+38j3b6jIBtXlSdFSNk0VJB4lT261cw42J7xmQIzcmyTjjy2jBk3BQpZJYiIzXwsDegDxLbkZaqWUSGs7sWSP64iSE0xztvGqoJuM6OVvdq3xNQ/zfLXZGSUNAJ75x7LudoZ++XuKaKLbRu7kCzw+IjY9rWiv1uqMtsQkxUuUvj5cpJUqWfOjmMW5+IOspcTVm/ntKgx7+NHpR7lfEyshIUU/qMJ2DQKCxbvAoZgaQG1hwQ7oqTDBSiG+rPyo2nPgAaawomZNaxbMq408BHuB5QORIeReEvtcBeusV/lXvWDG4KtetnKuzbFh8zd7aYKsUwgWi+qat+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(66946007)(16576012)(31686004)(956004)(186003)(316002)(508600001)(26005)(54906003)(66476007)(5660300002)(86362001)(2616005)(6486002)(38100700002)(30864003)(31696002)(36756003)(83380400001)(2906002)(8936002)(8676002)(4326008)(66556008)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFZTMEpqdDN1RkNOTkdmc1hBYm1jTGpJajl6K1BEYTkwelQ2R1VzL1hRMCt0?=
 =?utf-8?B?cUU4OXFGUWxSVGV3TDc3MENSTCtBWW1oN1lJdUN5MlNJYnZERmNkWkttYzlO?=
 =?utf-8?B?UjJETVhmbXl4ZGJqdC9uSFZNcjI3TEtCSkZWY0dXZHJ4OG9uMXJlUGhHNUNV?=
 =?utf-8?B?bWRjeVhXaHJoU2UyT3crTUVpSTZRQTBHZ28xUnBWRS9NMUM0UklRRlN3ZG5Y?=
 =?utf-8?B?VWxUWHU5WVRhcWFXQ21kV0xpbENrWEVBaS9KTWh0VHp2eC80cGp2VytuUUt2?=
 =?utf-8?B?MHlOZThLU21sRjJPdG41WFA2aENmL0RtMlVJNVlQN1ZKenV6SjZIcENWdlRm?=
 =?utf-8?B?ZWs4Y0lPYmFlZXEyY2U1aDFPa0RNaXloZE92c3pZc1RXaFpkR0dPS1pBQ3p1?=
 =?utf-8?B?elQ2T1ZhalJnVWJSUnFvbGo3bldiM09DcVA2RjJ0Ujl0OGM2eTljYkRWSkpj?=
 =?utf-8?B?N013WHJsN0ZVYjUzbGRUeUZNN2FucGVzRHloYVd2M29vL1pPbDlFWTFxcjJo?=
 =?utf-8?B?WUN5WGQrcGhtNlI5Z1lQYVlxcWlhNXExQzMyblNyeW0vd29pTzJXV2lEM09B?=
 =?utf-8?B?R0s3UHdEVzA2ZHJWT0RMMzk2Q2c5SHNXYXpQcW55SWFNN2hXNXgwTVNkVTVC?=
 =?utf-8?B?Sm9aTEhjVk9VUW5QWjNzeXlLcE14WDRidXJ6cEJhTFN3bzNmcHV1YjJKMkwz?=
 =?utf-8?B?MUUySEM5cmViTHJZa2ExRHVjOGNKbGdBblgycHZCVEVwSHBvTnMxbGtmelkx?=
 =?utf-8?B?VmpaaC9tbkFEYXlHM1J4WXFWakZ3QnM4U0kwZS9sN3pramsyYm5JTVVSckhu?=
 =?utf-8?B?M2lvaDFFWG1LOWxiWjN1ak85cnlXWkNWZGF0WFY3ajhWRjd0WU8rNmFrUC9E?=
 =?utf-8?B?L0V5MTJtdVFCUTZ3R0hFSDJQN0V5UkV6WmtHRElkMmlpaUltY2QvL3JaNXJB?=
 =?utf-8?B?UEFrVGg2Z3F1S1RMVnEzWU5vMitvSW1qdERUMHpaSjRXRTRLbmFPTFNUZFc1?=
 =?utf-8?B?cFZ4em1uTS9qckRxWUY0YUliVCtxWCtXRHRJbDh5dXFxS1JnNDZVTDl0bThM?=
 =?utf-8?B?TWw3N2k5WnJRb1hzZTRsSnZrb2R2Rkt0MEhhT25lTUF4UTh6UFQ3eEhwcERl?=
 =?utf-8?B?akdtZWI3R3EvOW1qWFFhcW9LT0Z4QlpueGNaeVpqeFZYK01TMEl6RVpJSE1N?=
 =?utf-8?B?eXI5eVVsQ1RScjA3ek90WENMeFhVdjd0WXIzZkhFbm90VWVNODAyRURvaHlN?=
 =?utf-8?B?SjNyM2RzTmE0Y1lSZExpMzZmMHA1N2dVZnA1ekZoWGFtMElwbjNoRENNWnZE?=
 =?utf-8?B?aXlxV3hpSjlPZ1ZCNzVQRVd6S0V6djYrVEpDcUViMEFPblAzRnRHZzhIaFgw?=
 =?utf-8?B?OFcwOTFWR09UbEE0cDYrQ0tDY3pQelJsUGlySHYrTzRBRTRRRmNmSTVaZDRj?=
 =?utf-8?B?REt2eGV6QUhoUVpYaERCNnNFck1VOS91R0lqRW5sUkJ0bDc3YSttcEs1Z2V2?=
 =?utf-8?B?R0lLdkxucVAzb3FTUmR4eTUrOWhwSUVVVjRhWDdRVEJKd1hrNDlnWXVYRVZp?=
 =?utf-8?B?YnZJbGFGOTNYVVdTTytWcjJIN2dtVi9sb0ZDWUZvZWxlb3FSZ1hSKzhodmhx?=
 =?utf-8?B?MkRnajNjTDRGUGFOV08reTlLWWxGWldycVF1VlU2YXpkM2RHaGhMK01RN2hW?=
 =?utf-8?B?cmU2Y1ZQeWlwdjZGZnk4VnQrcnNMUmtYQ2NGamtKVUdDMXFhWElCbUlpTS9P?=
 =?utf-8?B?Z2UwcEN3MU9OY0FZRkFNSUo1TmdwMUx5UkdqeFJuMWNLdkZwZmVwaWJGRkpx?=
 =?utf-8?B?S0xDeEE5ZkhITDBLWTFuQjM3OFlHckdZNXljNmRteDlML1RGMXB0VUFUZTVj?=
 =?utf-8?B?ODA4U2psMlVrcllKWkkwUlRaeElMcVBzeXpUekQ3SGRhd1laS1BDNzQ3cVF6?=
 =?utf-8?B?MitjZ3kxdmxVRjBCVTlMNnJuT2RwMDA1c1gvQlprN1RyNjc4L0F6OFFXVDRQ?=
 =?utf-8?B?UkFjQ1B1cDdINXRPQlNlZXVQVTI3dlRLVS9FcVJuTFBndit4RjhxdEZEZFFQ?=
 =?utf-8?B?QjBDMUdRbU1meVBxKytNZGVsVFRVUUhBa2hvT3V5ZWVMcGxEeU1sRTcrbHRs?=
 =?utf-8?B?dCtTRkcwS3VFZUtNSkJmNGtqajVvVDdyZUMyWVhEb0E3MEVrV2lDblgvbEds?=
 =?utf-8?Q?B/xb7Omv59YkeBtOQwqDnaE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bf1ff3-74c1-4c62-4478-08d99d672c3d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 18:41:10.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JmZvn3IjeI3RLTrOtW9DyWXYI5QtU/Iy9IFb2bs4CuBm39Cb3VqHN50WeDWd79TQNr0cFUp8DjyCQpHvhbUzTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5495
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/1/21 12:21 PM, Peter Gonda wrote:
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
> if the PSP has not been initialized it is at run time. If the file at
> 'init_ex_path' does not exist the PSP will not be initialized. The user
> must create the file prior to use with 32Kb of 0xFFs per spec.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Co-developed-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   .../virt/kvm/amd-memory-encryption.rst        |   4 +
>   drivers/crypto/ccp/sev-dev.c                  | 185 ++++++++++++++++--
>   include/linux/psp-sev.h                       |  21 ++
>   3 files changed, 196 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 5c081c8c7164..6d906a47e568 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -84,6 +84,10 @@ guests, such as launching, running, snapshotting, migrating and decommissioning.
>   
>   The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
>   context. In a typical workflow, this command should be the first command issued.

Add a blank line here.

> +The AMD-SP can be initialized either by using its own non-volatile storage or

Just to be consistent within the document, s/AMD-SP/firmware/

> +the system can manage the NV storage for the AMD-SP using the module parameter

s/system/OS/
s/AMD-SP/firmware/

> +``init_ex_path``. This file must exist, to create a new NV storage file allocate

s/This file must exist/The file specified by ``init_ex_path`` must exist./
s/, to create/ To create/

> +a the file with 32Kb of 0xFF as required by the SEV FW spec.

s/a the/the/
s/32Kb/32KB bytes/

Just to be consistent within the document, s/SEV FW spec/SEV spec/

>   
>   Returns: 0 on success, -negative on error
>   
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 00ca74dd7b3c..1bbb9c3dd1ce 100644
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
> +#define NV_LENGTH (32 * 1024)
> +static void *sev_init_ex_nv_address;
> +
>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> @@ -107,6 +120,7 @@ static int sev_cmd_buffer_len(int cmd)
>   {
>   	switch (cmd) {
>   	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
> +	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
>   	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status);
>   	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
>   	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
> @@ -152,6 +166,89 @@ static void *sev_fw_alloc(unsigned long len)
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
> +		const int ret = PTR_ERR(fp);

I don't think you need the "const" here.

> +
> +		dev_err(psp_master->dev,
> +			"sev could not open file for read, error %d\n",
> +			ret);

Maybe "SEV: could not open %s for read, ret=%d\n"

> +		return ret;
> +	}
> +
> +	nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, NULL);

kernel_read can return an error, you should check nread before continuing.

> +	dev_dbg(psp_master->dev, "sev NV read %d bytes\n", nread);

"SEV: read %ld bytes from NV file\n"

> +	filp_close(fp, NULL);
> +
> +	return 0;
> +}
> +
> +static int sev_write_nv_memory(void)

The return code is never checked by the caller. Is it expected that any 
error is not supposed to stop SEV for the current boot? Should you make 
this void, then?

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

You should output a message similar to what is in sev_read_nv_memory().

> +		return PTR_ERR(fp);
> +	}
> +
> +	ret = kernel_write(fp, sev_init_ex_nv_address, NV_LENGTH, &offset);

kernel_write returns a ssize_t, but ret is an int. and maybe use nwrite 
similar to nread in sev_read_nv_memory()?

> +	vfs_fsync(fp, 0);
> +	filp_close(fp, NULL);
> +
> +	if (ret != NV_LENGTH) {
> +		dev_err(sev->dev,
> +			"failed to write %d bytes to non volatile memory area, ret=%lu\n",

"SEV: failed to write %u bytes to NV file, ret=%ld\n"

> +			NV_LENGTH, ret); > +		if (ret >= 0)
> +			return -EIO;
> +		return ret;
> +	}
> +
> +	dev_dbg(sev->dev, "wrote to non volatile memory area\n");

"SEV: write successful to NV file\n"

> +
> +	return 0;
> +}
> +
> +static void sev_write_nv_memory_if_required(int cmd_id)
> +{
> +	if (!sev_init_ex_nv_address)
> +		return;
> +
> +	/*
> +	 * Only a few platform commands modify the SPI/NV area, but none of the
> +	 * non-platform commands do. Only INIT(_EX), PLATFORM_RESET, PEK_GEN,
> +	 * PEK_CERT_IMPORT, and PDH_GEN do.
> +	 */
> +	switch (cmd_id) {
> +	case SEV_CMD_FACTORY_RESET:
> +	case SEV_CMD_INIT_EX:
> +	case SEV_CMD_PDH_GEN:
> +	case SEV_CMD_PEK_CERT_IMPORT:
> +	case SEV_CMD_PEK_GEN:
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	sev_write_nv_memory();
> +}
> +
>   static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   {
>   	struct psp_device *psp = psp_master;
> @@ -221,6 +318,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
>   			cmd, reg & PSP_CMDRESP_ERR_MASK);
>   		ret = -EIO;
> +	} else {
> +		sev_write_nv_memory_if_required(cmd);
>   	}
>   
>   	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> @@ -247,22 +346,42 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
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
> @@ -277,7 +396,27 @@ static int __sev_platform_init_locked(int *error)
>   		data.tmr_len = SEV_ES_TMR_SIZE;
>   	}
>   
> -	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> +}
> +
> +static int __sev_platform_init_locked(int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	int rc;
> +	int (*init_function)(int *error);
> +
> +	if (!psp || !psp->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp->sev_data;
> +
> +	if (sev->state == SEV_STATE_INIT)
> +		return 0;
> +
> +	init_function = sev_init_ex_nv_address ? __sev_init_ex_locked :
> +	    __sev_init_locked;
> +	rc = init_function(error);
>   	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
>   		/*
>   		 * INIT command returned an integrity check failure
> @@ -286,8 +425,8 @@ static int __sev_platform_init_locked(int *error)
>   		 * failed and persistent state has been erased.
>   		 * Retrying INIT command here should succeed.
>   		 */
> -		dev_dbg(sev->dev, "SEV: retrying INIT command");
> -		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> +		dev_notice(sev->dev, "SEV: retrying INIT command");
> +		rc = init_function(error);
>   	}
>   
>   	if (rc)
> @@ -303,7 +442,7 @@ static int __sev_platform_init_locked(int *error)
>   
>   	dev_dbg(sev->dev, "SEV firmware initialized\n");
>   
> -	return rc;
> +	return 0;
>   }
>   
>   int sev_platform_init(int *error)
> @@ -1057,6 +1196,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
> @@ -1101,11 +1246,23 @@ void sev_pci_init(void)
>   	    sev_update_firmware(sev->dev) == 0)
>   		sev_get_api_version();
>   
> +	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
> +	 * instead of INIT.
> +	 */
> +	if (init_ex_path) {
> +		sev_init_ex_nv_address = sev_fw_alloc(NV_LENGTH);
> +		if (!sev_init_ex_nv_address) {
> +			dev_err(sev->dev,
> +				"SEV: INIT_EX NV storage allocation failed, INIT-EX support unavailable\n");

Since this is a file, maybe s/storage/memory/ ?

At this point, SEV will fail to initialize, it won't fall back to the INIT 
support. So I think the ", INIT-EX support unavailable" can be removed 
from the message.

> +			goto err;
> +		}
> +	}
> +
>   	/* Obtain the TMR memory area for SEV-ES use */
>   	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
>   	if (!sev_es_tmr)
>   		dev_warn(sev->dev,
> -			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> +			 "SEV: TMR allocation failed\n");

This message shouldn't be changed.


I should have made some of these comments on the first version, sorry 
about that.

Thanks,
Tom

>   
>   	/* Initialize the platform */
>   	rc = sev_platform_init(&error);
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
