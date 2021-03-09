Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E0DC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 16:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542E565250
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 16:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCIQeG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 11:34:06 -0500
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:38688
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229775AbhCIQdt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 11:33:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pid59IHWwlyjd/0Ur34DBbctw0lWvlLIoedffeT9WqkUFwMJyVTdAU0gqO9GWFYnqqiMHOgd2J+fmq6+nRq+dVqHQPp1lszXJrUXCDpvew7S9yTPQhVpU4XYvk2HrYTQss0KNvgUxjGOLomD0Tw68qvZAyV/hoomLVCN1yvKflxTrD1yffVTa5WhMqoheajc0+d0i0mZHCy4vf7MudN5RIAXV4p+bXq8S6Ky7udz6SIrdpOAoXN/6RqtJcnM2D2X2QwJGG9ZSc7WehnwqsKOZflVu6AgezdQ/Y9ZQwgfNA4bUpMNNT7S/Gke2Shg4PqgZ5tyLQZrcqpyKSCvdBDxXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6SvKEhecHv2nwKI0LpjpLTVhXdKjOQbvJ3nGcvVi6w=;
 b=I9plfDxKnmwccsvuoe4ZMN43v/d06nE/LYUO0YZ37Gwlzj479UmBk4xtT6pgiLBtqXmVSV3Qsm1MucY+CE3R4qUrtKtD+eR4GU8kYr6Zh7BTZR0bTjnXAu+e6Mpz7AengcePaIsKIX/6ogdX0RcjbeLtHyzGZZgeYN2oeb5zcrDg/S2Dw5AKvYxQcwxPxinTb5ot3gvKJg0XfUqsSnpZr5uItNZLuX/Uj6YxcfexwitROMGQ3/Q/ORUVnvY8tqrFr4M+jzltIzycP9nX90pmQ42LdtJVpCg78B3vutuBvIYDQK8K9AifD+Hykspk0IuImlrzAZ0mNjmsdtFOULVZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6SvKEhecHv2nwKI0LpjpLTVhXdKjOQbvJ3nGcvVi6w=;
 b=DJnCzoB1ya6yRvUqgfb7d97GVOW5bZcXBqJ8cGJOFfDwwBuwK8WKHaPafTjKFj8l5gi0oWt3iadO6lCYw48udSKNmFdYx8quKBDfnvS3KXBB3i2PmxP9B+aGmig+j6ynQDIYBPAUVgYzNnTtJU8puceE5rrhCEc3/mNAhA+CJa0=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4748.namprd12.prod.outlook.com (2603:10b6:5:33::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.26; Tue, 9 Mar 2021 16:33:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 16:33:46 +0000
Subject: Re: [PATCH 3/3] crypto: ccp - update copyright year for tee
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1615276206.git.Rijo-john.Thomas@amd.com>
 <a87bc3ff11249e0cfa891a80a65cda555be723be.1615276206.git.Rijo-john.Thomas@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e0af4167-a54b-94f2-de0a-91b0b2c544c0@amd.com>
Date:   Tue, 9 Mar 2021 10:33:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <a87bc3ff11249e0cfa891a80a65cda555be723be.1615276206.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend Transport; Tue, 9 Mar 2021 16:33:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a48f1b2-31af-4015-b93a-08d8e3191c52
X-MS-TrafficTypeDiagnostic: DM6PR12MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4748389BED16932C71E5CA71EC929@DM6PR12MB4748.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUfmrY80MEYC4J676Llr1ibKnOHBFFZdSR5Q9dlZ3qzaupsxTuIeGwjUs7pcpGaGRc4QPGldgjj1Nd+9fu1IVQoX1xq6+Rd8CDl10ZGCMfehpbGxva9c+FB61b4MRT7bhKA+CH5TcAHL1ggIlvi1zeuoFdrb4wP7vMi+gigY7gVGI2vnNK8+iRjTZdwQRXeW49dLnAtSUYgUGJxH5jBvwP8J2LTmRgiYP+hgo8fExeHjpkngZgGA+rjqj2lONjrR7i0i1loXqMnKEbFhABUATeI2UVhpPtFqWk2abLJAIMvaiDlc91am/OBlMWarHKcNP6wuiv+W6/VLTDpm7AGBJopDKdsyoGokmn/A7f+LngX2nMn3etmqz15QjAEzhnZeVI3B24IolQJvwZaN7V/Eus9CVfYCdmEkcm/4eJtLiyAeHWJvBlKSqvsueYHSHv+47IOAs2G2E4sBmWC66xGXSKaWqNSw1ijB42/ANCY9iCTQOYeXOAs9DApwKpf5P6BtFisQbrAtwRkWoG2gVFCQrveSfVwuA01luSnm1U5BfhYoD0LCE2wW2uH6CmtAbsyEuus5Mca3Z1o7uj0qYcoA65XIVb41mUN8CpfzQcljbZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(16526019)(53546011)(52116002)(8676002)(4326008)(66946007)(15650500001)(316002)(8936002)(6486002)(16576012)(478600001)(66476007)(31686004)(5660300002)(31696002)(186003)(110136005)(54906003)(2616005)(83380400001)(36756003)(2906002)(86362001)(26005)(66556008)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VTFuOHlMNTROcDczdnBnTzhFNVF5djRCU1F2ZFZDZ09MYmsxY1ZIY0JxZ2hH?=
 =?utf-8?B?UWswd2lmRWxROHIxN3I3L3VFRVVIajZpUVZxMnFGNDVQRjJyZGtOeDZFRTAv?=
 =?utf-8?B?eEZsaDU3Q1o1MmZaNFA2a2JOVHdhWlJNOXJoQVl3Q2ZyZXkwdFRReTNBTGVt?=
 =?utf-8?B?SU1UVjVuaXlnN0hGemx3MTkxZ0JjYXcxb3d3UW1MbVRmd3NzNFpWNWFrVy9y?=
 =?utf-8?B?VTV0TWtvM0JkSkJoUXJMUFJlZ2hWWEFwN3RhMUtkbWxtbE5FSkxpNlVnT1A2?=
 =?utf-8?B?dVBLazNKNHJ0Zi81WXBZRzVaM0dSdWRZMU12ekxSTEhobGVIem5aYUY3NGZo?=
 =?utf-8?B?K0lmaTR1dCtWbTVselVhZnV0eHNGQkVjYUcycUhiT1FhTTF1S3ZsRDJEU1dE?=
 =?utf-8?B?SkdkaDJKLzZZcm1GWkc5Nzd1VDk1NlhMR1Z2MktyYk1OUkZCSU1rZEJyZkIy?=
 =?utf-8?B?WHFkWmEwMXlMT0wwVDVhdjVtb2lwYm9zTjdWdTR6dGh2UzYrU1pxd0tKT1dn?=
 =?utf-8?B?T1E5UEVvRnc0S0k3bS81VElPdXo4aEdDbHFBMDkvd0o4QThlWEJaTHVoTnht?=
 =?utf-8?B?RG90SVQyUVdMUFFMaWhDL3VrRjE4SXJOY3AvZjlQWnkvUlBuakt3MWwrUmlK?=
 =?utf-8?B?N3hkUy96S0NRUXVhVzhhYTAyYXU5M2VtNWo5KzNFcHVFSnVTNkcxS0ZCenlW?=
 =?utf-8?B?cUsyaDFjS0ljdVhXSS9PQVI1K1M5aE9UMmY3RkJKSG1lUHZONUVjR0ZucUhH?=
 =?utf-8?B?MXNDZmd1U25JNndJeSt0RHRCTmxKUHdFVkRYNjZzWnkxdmEzdVFaUkRCd2ow?=
 =?utf-8?B?VVFkZ01JK0VCZE0wL2YzaXh2M002dlFyeGV4eGhXTXBlQTZRWnF0bS9IQ3Nn?=
 =?utf-8?B?OXZ2RExWbjB1d1duemhkVG5sYlpRY2poZzBnVUsrTlY2em4vNlpKY2FpNW1n?=
 =?utf-8?B?TzlkY2Y5VmtqZmphZC9RclMzTXlwdWJGYXZRbG1TTm8wdjBVUzkvT1VMRzBx?=
 =?utf-8?B?WVI3STBPMExXc2lSUE5Vdjg2SEJ6eC94czFlN2ZSR0wvS2xQa1BCNGt2V1Ns?=
 =?utf-8?B?U1A5dURQbjgwc3VSYkRneHIwbkhwOFFDeEtZT0ZVK0NRcnh5WnNsTXRhVkdK?=
 =?utf-8?B?ZXRoakhISTJxeDU2OGo1WDdOMi9hcUtTazlZMG9KaFIxMU5JRm1hWXlLNm11?=
 =?utf-8?B?eUlldWFJSEJpVGJOa3FYT1pIQWJvR2l3T1hreUtOVDNSZUx5bnlZaFdYaktl?=
 =?utf-8?B?cDRHelBDUDMwOTVyWHFrRWgwMEZQVHpJbVpqRDBGQU1OeFM3ZkhOWUFoWXJi?=
 =?utf-8?B?OENMcGJWQzVJaHV3OC9RWmk2RHplMEVuMjdhVldCTXVLK0hsWnFRSHllQkwv?=
 =?utf-8?B?M1JlcHF2cXgzOGZYb2pTaFZMNEhRSWwxNE5Sa0N5c0M5WlBza1h4dk0zc0RO?=
 =?utf-8?B?SnZ6OG40dVpkK0hwTjhRMHQ3a1V2Q0V5NDNMYVM2c3ZaRmQ3NXFuUHo2NE0r?=
 =?utf-8?B?T0hoa1dUNjFEbXJYVFp0cUhxS1RpaU9udXY1QldOQVlXSkRmNDJDZmpKR0Uz?=
 =?utf-8?B?YnhkUzhQRTFVejRvd294cmg1d3V1QmJ2RkdLd1N0TlowbnJ3a3M1RndCLy9N?=
 =?utf-8?B?Y2VuTExTWUxGVmVUMzFyU0NIS0JBL3pBNys0SXhpcGRKanVQeS9ZTFhWbmRv?=
 =?utf-8?B?NldtSzBlcUZlSUF4Q2R5MGN3N042MEpGRXFTanpYV2FSR1dZcWxPaktqZ21J?=
 =?utf-8?Q?Ua/po41WquQjVL3xljWBtXgVWLAJVTj8dDbKJBd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a48f1b2-31af-4015-b93a-08d8e3191c52
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 16:33:46.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5MQz+jf+9w+MwX/ZjQP39l7yof2sm7bjLJgdRRL9bUh6kKA6e4V49VMxSgFCN9pPIUB4+5z9IAMhFym1ROCEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4748
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/9/21 2:11 AM, Rijo Thomas wrote:
> Update the copyright year for PSP TEE driver files.
> 
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

The copyright updates really should occur as part of the changes in the
other patches vs a separate patch.

Thanks,
Tom

> ---
>  drivers/crypto/ccp/tee-dev.c | 2 +-
>  drivers/crypto/ccp/tee-dev.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 1aa264815028..8cade4775115 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -5,7 +5,7 @@
>   * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
>   * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>   *
> - * Copyright 2019 Advanced Micro Devices, Inc.
> + * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
>   */
>  
>  #include <linux/types.h>
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index dbeb7d289acb..49d26158b71e 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: MIT */
>  /*
> - * Copyright 2019 Advanced Micro Devices, Inc.
> + * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
>   *
>   * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
>   * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> 
