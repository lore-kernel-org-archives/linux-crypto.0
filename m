Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BE7C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FEF64FE8
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhCJE0T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:26:19 -0500
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:38913
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229485AbhCJEZ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 23:25:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cum3zkVjiSIdqtdSdut6/ZRwv0H0iPK6FxqVsutBXF+AnWNA0mD8iKzuD6MNOquem3c0xTbEQkwSA6VGEr+8cHE2I4jR0bqyX9Z9cSwGNB78/7gPnSEdWwfodBP7qRIBrLWmnvDFimAgOYGLaz3iAQDPolqKm/RhLu8EN22VaYOSy3OrEOmKI6jP6jqPHfHFJdWK+36FuMXEubZxzeT4mVtG5rRpXyqyFzUNxBMQX+w3kN9S2lyg4Uo7uDXtjEb04GXpL58ddAHKDtjCsXUouGfc+5aROAJTLOtyfnQSJhMPkofH92OMGxInvzsvz5vqRR8siWeDatX/pa5s+4M/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krytRQ46vMNwbqiym8Er2LPEv6S832EROOmDKI9TawI=;
 b=CVjFtBsqjeVTVDh22vn+FdZP0pPb3McUoX+uK32p6qgNN/4kxJ6PhY9fdMItPM5iO+1n0GjH2bBFQVjympIS3pFns2Rk0W3h3S7nerEE8rGziphp9Kqkp4vf+nCRfGt7Ike0kTPAyOyhEyMkgN4OULv7FEk/STCl+i1ZnyUhFCHjePmyKl3aXPGOo3qMocUIF1AVvpUQD+XytSRWd9LQeNniPhhLFMar7QjUX75PehfQ9TXqWkjZ8YVdU4PZhh/Q/vTU6sxujtay5IE/OCiHDi8NEEoeawFvIB5CIlhLJS3AZ/nCwhFlK0pLsAj0XfCHm5YaSNFcedb5GQ5SxtcawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krytRQ46vMNwbqiym8Er2LPEv6S832EROOmDKI9TawI=;
 b=NpETPzFjJmGe6z4xd12awvAvRAD6eCpw6/Yriy4tFBdsmRtKZXpnxD26AoNtXPfys2wNc70HWyGJPtxr3yy21RrfZyxiuhw2ssJN4xA+kQJt6EEPDf6rPq32CNZQdjVgLyUQdJh0i9wjE7h3OLeUh5w4dt4km47MIF595yGfgqw=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SN1PR12MB2478.namprd12.prod.outlook.com (2603:10b6:802:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 10 Mar
 2021 04:25:57 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 04:25:57 +0000
Subject: Re: [PATCH 3/3] crypto: ccp - update copyright year for tee
To:     Tom Lendacky <thomas.lendacky@amd.com>,
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
 <e0af4167-a54b-94f2-de0a-91b0b2c544c0@amd.com>
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
Message-ID: <50132b7f-f105-80f5-c843-40c7d084fc96@amd.com>
Date:   Wed, 10 Mar 2021 09:55:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e0af4167-a54b-94f2-de0a-91b0b2c544c0@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::34) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.138.129.146] (165.204.156.251) by MAXPR01CA0092.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:25:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78a27ee1-c154-484e-119f-08d8e37c9a2d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2478AEBE956B4FFE08F101FCCF919@SN1PR12MB2478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFOob+VsrEvvsw48qB/Kij0jm4oH1R7u0U4FJQCHI2Y+xjRfCBNRa8ONvnhXuLeAg5FzkLaPOlvVsJvm0GP82vPyI1zyfYRqW/o90TE5QwQTPaeiKgqTcFiSOTvrdHpJwW96nHKQsMri+CFAh7lGKpevdrxgebFaxOA0W988Yehbn5IJI0lT7i6HxztSiPzCb+5uYAZhOr0veklLwSZyhEtA0DjizdQ3NOOUjuDXItWCp4KTqC0xTsbP5hV1YIaFPsOdN5nznJbpzaDDeVyhKlNNh7vB03ximOD59ZlzHp9dzzfBP0HoJcUR9bgV0dur5ZnXEqmnAKKvXtOtCq5FG3A93CWtB2BVvJcEZ6OfF7lW177yRqLFElt2hfM4V/amNpy9dI18KrMx7xX/FtuUlIReQykIMgtI4b9FKKXXtcUjKvqkACFWIDVO8b+4SH32Vo6inY5jCVy81tvZ92M52BzFiQwJx/4KxGnjeFP8OnqOMcVR3vyb7/w9rMwbi4EbYiMgyeJGaf9JIWXlaouoWPShGJmv+0SSR9a9GtgzYFzsfUtCI9a3ZO19ZmerzDLahXwtKioz3dqjr+jvZQq/4aE6gt95NP2O1zCEvaKqYmE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(53546011)(16576012)(316002)(83380400001)(8676002)(54906003)(15650500001)(36756003)(110136005)(2906002)(5660300002)(4326008)(52116002)(66476007)(478600001)(31686004)(2616005)(186003)(66946007)(16526019)(956004)(26005)(31696002)(8936002)(66556008)(6666004)(86362001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ajE5QlFSUFFYb0pJL1hpbjR3WDFTejNobjFiUlgwcFZsU2tjYWJXVTNWcDBh?=
 =?utf-8?B?YVlRWDFwOUhJeCtHYUpPb3FiWWlCNENNY2s0WVh5U1Z5blFJK2lLak51TzIw?=
 =?utf-8?B?M1hINXMzeXJia0NkN1h0ZHp3OWx5T0JrQ0JxakNCMkdWM2VpOXVwUGQ5aTFC?=
 =?utf-8?B?aU9EMitqZXphOUZxR0xIQW85SlkrOUNDa1VueHJDbHZ2OTFWVnhaVDZtZ3ZP?=
 =?utf-8?B?TGh4ZUNmaXk4b1NyaStYS2h2ZUNXRWxKcjV5T1A4TDV4M1lDNHMxN3dETXJS?=
 =?utf-8?B?NXRGdG9ZZUlrckphcFNIU2NDWEV6bTRueEp3aExDOGRiak5Bc2R6YXYzdGhj?=
 =?utf-8?B?TnhPR3FvenYvSm9iYjBOV1NBMG0zdG5rSlQ4NHlER1doYkplbG1UUVIyZXNX?=
 =?utf-8?B?OFBwUkk1SjRXMVFWVkhjT1JneEh0ZzJQRTE1ck1iZHpJV1BoandTYU44aE9p?=
 =?utf-8?B?c3piL3ZyQWdsc2dNYVVQVmxCcDZUd0tyN2tIYXVLRVNKcW1aeXZUZCtYK0hN?=
 =?utf-8?B?dUtIRkNDdWp6a1ByemcwSnJwUnhCWG96VnRmanQrL0hkRHNzSzJjL0swR3lI?=
 =?utf-8?B?NllJZ3JjeHJ6Ry9YcSt3cVA0cnJXd1YzQlNOc0taTmpuZG9PYiswM3FOTXZB?=
 =?utf-8?B?UzdIUWRxVkQ2K3NFQzJDVjI5cUhnK2tFN3lwUzJZa1E0OHZTWWtnNUZsdGlq?=
 =?utf-8?B?ZTJaQ3NpcTMwQm1aek5wSzFyZDNxcGJ2ZEowN2hBMWkrRDFZWUZIdXByNFk1?=
 =?utf-8?B?ZXZZMThScUE3UG9zRGM1T01RSXlub3ZVelBYS2J5NzVFNHNyNTBCMEtFRHBw?=
 =?utf-8?B?cngyY2ZDWnVKZXJLSlc5NkE1NnhVVm9LMWduTWNsb0hCZlVBM2dRd3ErZGJu?=
 =?utf-8?B?THNtOGxWbVJiMGJza253a3ZPYnkyZkJCYmh3WVBSZWNJMHBQRStlbkw2ZVR5?=
 =?utf-8?B?UUxQRlk5bGg2MmFqR2ZEV0MvbXhXaVNyUUpIK1Vsb2ZTcWVrNmRkbEg1UjRn?=
 =?utf-8?B?S0lIaElWSVBCcWpMTWdCYXlsN3NVcHFpbFlxSmxXZXhSM1F6azAwYjE0OTQy?=
 =?utf-8?B?V3ladVdIQ3JWaFpZM1JYSmI2a3RNWGFxQjd3eUJIcXFBdDJnMXd3RGsxUXhT?=
 =?utf-8?B?Z21BMHc5b1Q4VWJncnIzSGVpc204cTlxMWpnUkVwTFhsQ2FaN0V2Viswb25k?=
 =?utf-8?B?dmNvbVdyK1ZCbWJiRDZVZU5PVWJmd2xmdnpIZkpqZWxsRHJsR0FKdUxoRS9p?=
 =?utf-8?B?RVVFeXFOSHEzU05ZeGRrY0YyZktLWEJ2MlRLblk1RUpWdU9NNmduN3h1dkg5?=
 =?utf-8?B?NVRBWUZ0Sk4xS2RVdEt4TzJrZUFoVkdnL2IzMHRna2VoUlhGQThsZEFNbG1m?=
 =?utf-8?B?UXc3blJwclY4Q21nblBDaEZCanZWaC9lYXRPSDJkY2NtV082YWx4M3J2bW1i?=
 =?utf-8?B?V3ZOUE1RbSs0Rjd3eGZMRmlPTzl0SHhyOUQ0dm41b2VPcGpSQ2xhRUtid1JC?=
 =?utf-8?B?bzFrOWNlT1hwSGc4T2R2cVh2dDM4K0Vpd3U3MUttaG5OT3ozcUVSUUtKUkNY?=
 =?utf-8?B?Y3JqMlZQdzJXSDZhcC9oK3pjUXU5UTJHWkFiR1JFU1UyemFmS0lKZlRucnF6?=
 =?utf-8?B?VE1PRVVFMUIrWTZiNFh6N0cvSjZicFo5TDJKajRzelUyZHFwaDFuT2ZRZ2gy?=
 =?utf-8?B?dE1Wam1PUU9la0Fma3ZZZG44dW9BZXNkM3RYTUNQOFhXT0ZFb1hySk9CVXdz?=
 =?utf-8?Q?iZ5VjGhsAqDM26Bhy6SMuwM7QCq227rECA8MJP4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a27ee1-c154-484e-119f-08d8e37c9a2d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:25:57.6908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbj6dS7d+ZSTv3MYZr3/Xm+CPCTv6aiJFaJjV1Sd0+1pvTlhHgRMbpWt8hs1I7rDUtbhAcSsXx8iSZ942HV6pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2478
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 09/03/21 10:03 pm, Tom Lendacky wrote:
> On 3/9/21 2:11 AM, Rijo Thomas wrote:
>> Update the copyright year for PSP TEE driver files.
>>
>> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> 
> The copyright updates really should occur as part of the changes in the
> other patches vs a separate patch.

Ack. Shall update in next patch version.

Thanks,
Rijo

> 
> Thanks,
> Tom
> 
>> ---
>>  drivers/crypto/ccp/tee-dev.c | 2 +-
>>  drivers/crypto/ccp/tee-dev.h | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>> index 1aa264815028..8cade4775115 100644
>> --- a/drivers/crypto/ccp/tee-dev.c
>> +++ b/drivers/crypto/ccp/tee-dev.c
>> @@ -5,7 +5,7 @@
>>   * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
>>   * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>>   *
>> - * Copyright 2019 Advanced Micro Devices, Inc.
>> + * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
>>   */
>>  
>>  #include <linux/types.h>
>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>> index dbeb7d289acb..49d26158b71e 100644
>> --- a/drivers/crypto/ccp/tee-dev.h
>> +++ b/drivers/crypto/ccp/tee-dev.h
>> @@ -1,6 +1,6 @@
>>  /* SPDX-License-Identifier: MIT */
>>  /*
>> - * Copyright 2019 Advanced Micro Devices, Inc.
>> + * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
>>   *
>>   * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
>>   * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>>
