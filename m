Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889ADC6FA8E
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 15:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiI0Puu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 11:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiI0Pu0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 11:50:26 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92A95A2E6
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 08:48:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFuUWWIBIUpnKvcEYXuJRsF9xJhmYr6wtm4p6ygML1A5d8OIucffJ1YI4aIw8gYlmrNoVvl6tqYi42AbvVjFxARbDgpcOnWD9CEsH4PyJG1IJQoP5UZynG2BnND3U4S2g7tAAJyIAAT+Vu9gXm5O8Lkf6aP82/XRNwbHTdl2jxu5N/St6i3V5eIRjEAqU8NTCRiWsw4taI4J+cAC/KzldrAgAMYX8S2AVxr8b5cVjcrGjvyQdcA0tW+U6VsDxWazfL9gEGVYN7BBE6PSNjQySHDzMHFJ8Zc6X13w8feaniUK06OdbYRMPJ9pEljh8uOhtAzbgmpLWCvYPjFzOdK0BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrVjhbAb9q2MSWhGGAfTPYE35JQQYe/zwvgxMwxKSjw=;
 b=l4RSadUtLuE83UiJES0tJRc0nz9kTsbkA4F2jOoxyBwt5vDpsSciaoEoTzi8i+/f7SkBgYlm6VrLGEXP4kWbr75xFrq4v3TgAS5YEkz5uXNGuKuQnNHmQ3AjN65peXe8yq5ilwJCVgI3QDUvaAiwZJzmrwtqjg7/bXFNfTB7ce0O+xQUiIRYNKN5XdDa7eMmDSCdyeHoTZ9RQWTb+O8LuLiTx/BJJ94RFJSFgAfspi16Q4bKLmOsKe+r3AwFnyWH/OfpoySssMJu8cL7ZRZVrv5qf/hGql9MDPkZ0Vs8g2NwOXP0yBs29UWJRMwOI0Qxp5gdYtkREn8x6UKG/BMeeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrVjhbAb9q2MSWhGGAfTPYE35JQQYe/zwvgxMwxKSjw=;
 b=bMBdplReWP3SGqOhhP3AMBbyRfp3dO4lA3v8gVoU4hMzeS2L+WOwEPfyQUu3ef+9qVbRF46t4t7vgFiDUCYI+wvAOZVDB3cadOuwSRys0IabCB+PHn+kgQNJByCS2nhCu32NUAr2Y8YoZDHNphNkwIxosT8mJC7RTbduWfunv60=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BL1PR12MB5079.namprd12.prod.outlook.com (2603:10b6:208:31a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 15:48:28 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::297f:558e:dba9:9564]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::297f:558e:dba9:9564%8]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 15:48:28 +0000
Message-ID: <f3f7b7ed-4dc0-c880-79aa-5e84b71a615f@amd.com>
Date:   Tue, 27 Sep 2022 10:47:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] crypto: ccp - Remove unused struct ccp_crypto_cpu
Content-Language: en-US
To:     Yuan Can <yuancan@huawei.com>, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
References: <20220927133955.104353-1-yuancan@huawei.com>
From:   John Allen <john.allen@amd.com>
In-Reply-To: <20220927133955.104353-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:332::34) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BL1PR12MB5079:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ee5d53a-266c-4593-1cc1-08daa09fb8a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lA/n9WonJRjsNHKQXRzxnIlJyvDR5Ghuej1mtQlR8I2suF3IEweK16vRZTNio7A++duQNiP+BvDx72e/9WpE5nxwJt7J8KUTEEwU3ushCXM3FBv2LUkU8pS/33x/WQzyeH6geMqJs/Gwq/xANqfYPaq15HRqFEeZraUBfP+2Gn3fQsvrpv1nCq6icHhTBe/SDlAtNsfAadJ07r7QkyzTpDQgYBFT3AWFCSXpVQIKEi3WM0FBYHhTOs7UUgcZHS9VRs2eVOXrnRh+2FyyKCrZ7T6hfj/LG8DMK7dEGb7pUyREXp3OQqvrQ5vql1gvrQZndbRw9los2nb2yKBbeGO221RdrBNBcrZtbtAvm7fE5Ukb7ijOBduTY94LxYVW42iJnmvgufdBBIo8A74loJlW3mmT1wrHpS2DlkywNN8E5GxE4hzlGn6KP5ZSm0z0aRGTY+lxS240m/JOLYGghF9FJrUzURbBl5XRkJMhanKOuo8i9N1nGJGz2BoqbmCmo+5x8QRJMvHj/czE8IJTIX3XauOOFinVA+QYtfMncHJOu39VfpPtcVkUqi1GE6x6up7aTMYQ8hzHpN43dXyZ+WoVhROI5SlfGh5OM05P3mZt136AECnFeKSsgLN9MniG4LNMfPc5qrmCb9rdZLJwn+nnx2O/AIYQEnGPM2CyLuR9JG6KKV3+ApO1nia08e117Xza47TfRH1ko3XdYIuXqsta5arnpr9qAb+tZSU9vxSOiBKWDFc3sluzPG+i02/SVXSAY710x/ObyA96dJioA20RSA2L8MNo5bTZXnVbswy66/A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199015)(26005)(8936002)(31686004)(66476007)(2906002)(44832011)(66556008)(316002)(36756003)(8676002)(5660300002)(66946007)(4744005)(41300700001)(6486002)(478600001)(53546011)(6512007)(6506007)(2616005)(6666004)(83380400001)(186003)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek1oRWEzdFFwcG0wZ1dqWEx4MStSSlBrQmtwQ3B3Z2tuYW16cHRJUFBMc0hm?=
 =?utf-8?B?dXQrZEI3Y3E5QzRSd3FIcUNmZkQ4T1BXTGNhakwrdHI1OFZ4MTZEMmxXYUVF?=
 =?utf-8?B?bXVoaVdzaEhNZUoydURmSFBxZFpFSTYyVmI4ZHZ3ejl6M2JZdzIrcFVleWFk?=
 =?utf-8?B?dURsYzY2Rnhkd0tDZnlNbHQxNWVhdHhwNDNObG1RTHlmcDczVHVZSXBrOEdl?=
 =?utf-8?B?WTJrV2crOWdqSk1SS1UxWlg2eDhqNnpVeDFlVkxsNlBZQkF3aUZYejJPTFha?=
 =?utf-8?B?aTBLdi9oUS9tUHpRN3NvdlU4cVFUemVuZWNIcmg2Qk84RTVvbHJFa0NndzFk?=
 =?utf-8?B?WlYyVXlob3FyUEt4Z0FLeVo0ODBMKzFmQWRYdTZwMU9RVVdiajMyQ05wL1JI?=
 =?utf-8?B?L0dUenhnT3RubEd6emtYZks1Y2FSVVFOeGxvSm1sYW9HYWQ1VERNNHdPMWlV?=
 =?utf-8?B?RjNhVzNxdWwwVlJDVnhCOXlWQ2J6Sy9mMTdkMmNvREJkenYrbE1uQ0ltZnNF?=
 =?utf-8?B?Snl5WDlRY3gyVm84bWZsSC9DKzhSeVFMMVhIc2l6RjV0ZE5kYVhCenU4VTli?=
 =?utf-8?B?dm94RVo5Y0lyTS9sZkdHMUc3VkRmUTltMGZGNkZlRnpvWGl3c0lSR3FXQ29u?=
 =?utf-8?B?ZEhEWklFMUZOUnp1d0daejRSV093M0gyVUltdnI1MGRFODFrVk8waUZNc3A4?=
 =?utf-8?B?WVZhMFlid3gwQTVUWkdVNTFYQTJjMzUwdEI4ck00TVM5dlVKdjN6VmU1c3VM?=
 =?utf-8?B?UTliZzhocTFMMHZpQ3VRYTFFODg0QUMwdzNoTTE3bFY2c1V4WW5oam1NMG5p?=
 =?utf-8?B?QjJsQlE1RUxyUFRNb3NidnNzT2duUWdVb0daRHpYOUVuM0gvbGNTOEkxM1RV?=
 =?utf-8?B?Mm1Eb05kS3I4VHdUNEgwcEx6YW9mTEZnUGhCZVB1dG9oOTBlQ3poMzdpNnFG?=
 =?utf-8?B?a1BkL1FsWTFTZFd6TEllTkVvajNuOEhiUDFXQTkzb2haNnE3WW1TUlZHa3JD?=
 =?utf-8?B?d2tOc0I0TTZpQXQvM2tFaXdNN3RSbEo5UzZqNTVydE0xZ3RRc0JXWURYRVR5?=
 =?utf-8?B?Y0FEdDdmT3BaeE9Ua29tRXFRVUF2dVp3V0IwdnNFWmVSME9NaEFWN3lCYnlx?=
 =?utf-8?B?R00vc3oxYURRMUwwbXVsSnhvSWw0QVg0c2sxZGpPZFlUcmw1ekVhQzRvNUtx?=
 =?utf-8?B?SzVYWjg5YTI1bU9PbWZQanhWQlR5ck4rM2lyNm9SdkIrNk8xMmVNNzVJTlpD?=
 =?utf-8?B?MERidUx0MFh6T0g4Yk1lSGpNOUNUUDFVWDhVVmNWcFhpOUp3NDgvanpUbWNW?=
 =?utf-8?B?NDZFSkpUN3QxNFNMaVVNTW95dG5oaFljaEVqYlhYR2Q1RmdKSnkyS3prMFpa?=
 =?utf-8?B?OTZkWjdaclYwUUhuR3lOaTdoaEw1WGFJbjQzMmR6RUprSENpTmg1WFFmMUxW?=
 =?utf-8?B?UmJlUGlxcHpyUHVEZHowdC9STlRRc1lrdVVKNGFWRzhCaFZXSFA5NGNZZkpN?=
 =?utf-8?B?T3hTbEdDTEpxaUFWaHJYSzUzbjhHejlwMmQwRHdWUnc0bk14VW9ZS0hXYUZl?=
 =?utf-8?B?aktObE01S1R2aVRkUy9zakx6Z3NRb3RlYmkySlhXQmhGS3JyTDJiYXBYUWxn?=
 =?utf-8?B?M2I0ODhZNUNDUkprR09NVkxrVEdmWElZQk9SRHVmdlVFVm55Y2VNTmpsTENj?=
 =?utf-8?B?S1N0NjU0U2F2RnNaOUc5c0hlbS8wWlcrRktqdUNQOGtJZGlwd2FoTzJBbW1y?=
 =?utf-8?B?bUo4aFh0VHVpczVGTHFPc2lNaUtOTWwxUXc3RGVsSEJmOFgvcmtlQVlTbk5u?=
 =?utf-8?B?clhleTFzTzgvYU5lR2pvYjFLeGR4T2duZWdQY1NqZElDdnFQOUFkcktiZGJh?=
 =?utf-8?B?SWN4OS9tZDBVMmozWkFtUmdjRW15dnVINUtEalRUY0hwdm9KNmc3cU1FL2RH?=
 =?utf-8?B?SHdIcmVha01vYUhvNG1Db292alNkcHovaTc4dlNnNldQWUU2aWVxSHhPd1NI?=
 =?utf-8?B?N1E5UmUrWVN6RDhrUzMwMDljUHNGeWRXdE5sc2hSVEtPL3ViQjJmRTdOV2hT?=
 =?utf-8?B?cDBoYWhTYWhlODdjcnJpd1QyNmtrb2dUWUN6MHdWNWNWOGZ1RmkxMk9VTWkx?=
 =?utf-8?Q?LGFlRC79ZXxf8PvMTD59XE43k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee5d53a-266c-4593-1cc1-08daa09fb8a0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 15:48:28.5810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odQnehhPpyEPPvupekZR4PNevxIDUAH2K61BzAXoVTviJjF+skJ5vUNTD2V5ASvkk4hVM0cW1ZQXNf/D5JvL1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5079
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/27/22 8:39 AM, Yuan Can wrote:
> After commit bc3854476f36("crypto: ccp - Use a single queue for proper ordering
> of tfm requests"), no one use struct ccp_crypto_cpu, so remove it.
> 
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Acked-by: John Allen <john.allen@amd.com>

> ---
>   drivers/crypto/ccp/ccp-crypto-main.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
> index 5976530c00a8..c8f3345c66e2 100644
> --- a/drivers/crypto/ccp/ccp-crypto-main.c
> +++ b/drivers/crypto/ccp/ccp-crypto-main.c
> @@ -78,13 +78,6 @@ struct ccp_crypto_cmd {
>   	int ret;
>   };
>   
> -struct ccp_crypto_cpu {
> -	struct work_struct work;
> -	struct completion completion;
> -	struct ccp_crypto_cmd *crypto_cmd;
> -	int err;
> -};
> -
>   static inline bool ccp_crypto_success(int err)
>   {
>   	if (err && (err != -EINPROGRESS) && (err != -EBUSY))

