Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EBCC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F0764E6C
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 04:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCJE2l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:28:41 -0500
Received: from mail-eopbgr770089.outbound.protection.outlook.com ([40.107.77.89]:23310
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229570AbhCJE2I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 23:28:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJ51hf0E9oGbEyCU6chwZic8JEupURpNdeHyOB8jAyMlOZUbcxj7acNWit+9t87uRsqNyrQy3BDKPOTHidSh3Vb9MBRkYbnviVKDvb0AP/nDEpBi/nTq/RQGnn27aL4cCHfBMW3lR+m8VIn44acM9C2XzqNksneqdoKDXmn7V0Jb+ZEDkL0/gLHyKTmwygRl/me90gHjuqeb/zzPhIpIYPtal4SHdbPZC+JBD/ArVZIXdKt4UUqFJL8d7PDuB6793HSnB95MwutuzHP/qOXnX11B6iEoulqnAxm2hm3rJJnZbje/7WavrH448KO3pjcCCdoqhRyxYslXvdtp3mLGpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLqAASgLefKGTGBbNlbEojnTcH4zBgYqc0R4jv5hae8=;
 b=b3fr3VzmWybI9gj/H7J48dhbZlyXbnGgJecEyLNe1HrJSnRpmDZq39nnEzj8e98d/zDesKxLe1/uzzsgtyEUA5uC9X1ZFjiO/uEnXTZpnHwna4h8VecnbQsbvweFjWRSjxGVTK2u1AW3QJs0RPG3apUve7KXzDc5weHeH0DuG4qjgTzOzQ0X/VlQ2lLVg5e9KYf1/dqzfZ0M6H5L2Vj84mtewWfPTcACg7dzLvoFatOWQ8r8fXHD3eFcOvK4e2y4Sc8eMNzwWLmp9lo0i3bXARuqzArtOQNhC34OdM44oQJvn/0I93ezIMBpHabnOw/B08J+/Sf3QT3NiwrPgpSw1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLqAASgLefKGTGBbNlbEojnTcH4zBgYqc0R4jv5hae8=;
 b=CcTyVUVAqaGnnjbV8lUNSlKQL/GyASmqf0TQN12zdW0nKZLS4Zdf7tobsU53SmdJO6Y85oMRKdQmXRpzIM5GL1ttOGC1GxWjLkFf61EU5TswTmb+ZMkwKaqe67kFWgGK1xQGx5F5A5dvMjMKttr5fMYZoCLv4EdYP79sSyse60s=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SA0PR12MB4494.namprd12.prod.outlook.com (2603:10b6:806:94::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Wed, 10 Mar
 2021 04:28:04 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::c32:245b:4812:ee03%3]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 04:28:04 +0000
Subject: Re: [PATCH 0/3] PSP TEE driver update and bug fixes
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
 <6f036523-6eb4-4b74-c22c-e45a98f63f86@amd.com>
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
Message-ID: <1f8d3fe9-a945-811e-c1ec-b82f45c1d272@amd.com>
Date:   Wed, 10 Mar 2021 09:57:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <6f036523-6eb4-4b74-c22c-e45a98f63f86@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR0101CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::23) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.138.129.146] (165.204.156.251) by MA1PR0101CA0013.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:28:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 052cf0d8-30d1-4fc7-54d8-08d8e37ce5fc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4494:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44946E955AC66A7085C3998BCF919@SA0PR12MB4494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VKi2P3rLdaLqzuabfm6kx7fy8oyBoIg3xsQ0oZV5pMDbTRlawmUAcTZVbIFDs3kAvrv/6Tp/OG/8B1wkw6mnviwAPfboCGh8/k1enTJuFiKXuY6R6hU9ECJwE53DKXsOMEQnRVlZNGAQN486SFv/ZKbSCBfICyqM3CBYXoWinFoAHpixk8aH0pkH2Hzjf8i/aZtv96ncG44TlmDpDsqUw2zdMYtHcFrp1UshkhzOHlVaj/EhnRuAET7oQzMirGK4SD4O1CovvL1fIwg5kLBizsOaRHlwVUqMn5tGaMIDBBrD3ZAzw4CVonR5VNlUK89DUr8j3yq5O9ker7zdBl/0siuXzuZwMCzBAYF7cYIPaw0k3UION3T4b1CA1mCqclsxU4vnULvHSaAOlFfNkg9YPfK/Nea4YCwxLT0bTqNFscAwb16gq5gtGVyK2Ylw/T2WdDn3Nux6i6CgogCmU7grrPVH08NVTDXPusCG9BVj2d2Hw8cRenFwKeZfh46SCtrxYjR/GzcvatQ7Hx0f8Fsqak7nT2vksc78j5RAPDm34gzODooY5/hvDQQL8fpAhQeavFAc4DAX4Jckv5LDAjMMnXRRQwZnGKZ3BksuzoqJq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(36756003)(6486002)(52116002)(53546011)(4326008)(31686004)(66946007)(66476007)(478600001)(66556008)(2906002)(316002)(110136005)(6666004)(5660300002)(956004)(83380400001)(86362001)(8676002)(8936002)(54906003)(186003)(16526019)(15650500001)(31696002)(16576012)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d24ra0NBa3RXR0VaVUpLVVFvNTFIYUZ4QlhvZmpyMEZzNk8zQlc3Um9hcDR5?=
 =?utf-8?B?Z0NIVFhJTmhZcEpIMVhmc1RGWE52b25aWXNzQlZXYjdhbGczcXdxdHBYbnpn?=
 =?utf-8?B?QVpVUGhCTlJGb1JUT3RkOEltMEZTVGxJYVdSMllwS2dPZzg0NldYc1V0WFhD?=
 =?utf-8?B?bm1DVEY5Q2xXSUQ4U2ZOaEgwbDd5L29LVzkzd2tOZHM4VkFET0g5MXR1dGxJ?=
 =?utf-8?B?MUZweDYxRjEyZWd0allaRjJjV05sRjIxWWhnNDl5Tm9xdXlMOWF5djhTL0lI?=
 =?utf-8?B?dTI0ZGNWbjhvTXlpNHNtV21VOFR2Y3hxT2xZRlNtWVl4QVRlNFRNVFhzdGRj?=
 =?utf-8?B?dFVpMVV5WFVXZXZudUsrUk9GU3AwamlqMXB4LzhyUTJTWEd0WnJmdDdHY21a?=
 =?utf-8?B?aUdFWlRoZDRNK3lQcnY3TUpEN3FyQmpKUkt3eG0weVJvaW1GakltY2ZMY1VE?=
 =?utf-8?B?NjIrMjVNaGV1TWtENW5NUnRNdWRxQ1kvYnRlTk94WU5ZQ1dpaWxuTzJtK3U0?=
 =?utf-8?B?dk8rbTk3c05JREQrSWNyOVVmSzl5cGhrWlhKRHNYakF0SXRtUHM0OUJqL08w?=
 =?utf-8?B?V1FGaCsrL2xGOXRpLzZIMVJTZGZzMGlyOGZtSDk3c01CYW9kUldNcmJaa3RE?=
 =?utf-8?B?T0lsQWFtOTNadkpSTXZPSkhMR0FqdjU0dGppYXZ1R0o5aG45RCtabUk2eU9t?=
 =?utf-8?B?K0svZ3BadnhSc2oyR0NMVlZEb0k1cEdvY2FTbCsrZ3V4RXVoVjVackNCRm5F?=
 =?utf-8?B?bHM5cGtYME1sT2NPd1p5REZWZEdTR3UwYUVTOWtsNUIzVUQxaTlLUDVmLzJF?=
 =?utf-8?B?NkNyYWRzY1E0VmFTbkJWeFU0Mk4vK0dvbWtPRVVkYmxkL0xGNnRNS2xEbFU0?=
 =?utf-8?B?dnRzclExT2N5YjFMUEtpeWN3Q0ladDJEckNiQkgrbHdUT09WMTJsTTM5dWFJ?=
 =?utf-8?B?YmMrV1A5cE5xenRNZHlpekttZDA4amlIWHhpM1c2dU1kRkpVYjJiNWtERzJ5?=
 =?utf-8?B?d3ovbjBKSUxzeVdGSGduSnZycGlacHNvekc5TGZiWVZrbVgxMnJzOXE0b3BL?=
 =?utf-8?B?cCtTOHF1Q3VyaFpwSWdRYjFEMXMwWSs0R3dKa21kNlV6RENXZmg1cGEwamJw?=
 =?utf-8?B?R1YxVG5aaGF4OWE3dnN0ajhMSm5pRkNLU1QxQ0lwVVhoS0dIQWF1YUdDZ3Rx?=
 =?utf-8?B?UTBYeEd4S0VSY2tJSTdNK1I3L3YxSXRZeWpDZVFMbzVsV0c3MkpkTmxRRWJ5?=
 =?utf-8?B?RWdaUFNjZFZKV3hmMjlTVDVSS0V0ZlhGNmZFeHBXZ1l3MHA2cFhBYmRmUUIr?=
 =?utf-8?B?b3RQcXZEd1BJZGZMdDNJTzVPOEtvQjR3NE4yV0RoTk9YVGN2VlRjc1hJUDJK?=
 =?utf-8?B?bVJSU1prdFRMSGN0RDNYVmxCd1ovMGFmbUNRSmlRUTFINTMxb3RuL1hTNkt6?=
 =?utf-8?B?ZmdiSk9XUVFkNVhmQmo0TEFnTTZONExvNTlWTW9YSENqbnlDSkx5UVFTZ1NN?=
 =?utf-8?B?SGRmNkIwdlhsS3l6RlF4R0cyTWc5OUwvdGtHWjRocUF2Zmt2MmxZckVJa0RB?=
 =?utf-8?B?ZHJ1eFpOMWhiTVJGQzM1Z3NraERnS2pNSTBNZDZ2d1F4andvTVMrRzJxSGVi?=
 =?utf-8?B?Q0dycWlrSVZ5Z3h6YzBIQ0Y5Qm1lL0JGaVM0WHcvVW9TWVoxTUpUTnpLYnZv?=
 =?utf-8?B?Y0F2ZmlrU3hscmc3V3I3S3NHUEVVb1AxdGNSU2dpc1hvUzY1OTZDK2d0UTY1?=
 =?utf-8?Q?S4aekr4QjMJu1C9XCmzzzfl4RwKPSXEDwbzkuYV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052cf0d8-30d1-4fc7-54d8-08d8e37ce5fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:28:04.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjCUzRemzKeo9Fn6ssvbyvy/IlIB9kwrbBvncHEcdYJhmDN2w6/nxF44gOZuXoaoa1I70gRwGwLByurqKOIeZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4494
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 09/03/21 10:06 pm, Tom Lendacky wrote:
> On 3/9/21 2:11 AM, Rijo Thomas wrote:
>> The first patch helps to improve the response time by reducing the
>> polling time of the tee command status variable.
>>
>> Second patch is a bug fix to handle multi-threaded use-case.
>> During testing, race condition was seen due to missing synchronisation
>> in writes to the TEE ring buffer. This patch helps to resolve that.
>>
>> Third patch is to update the copyright year for the tee driver files.
>>
> 
> Just something to think about and not as part of this patch series, but
> think about submitting a patch that adds you as maintainer of the TEE
> portion of the driver (see how the SEV portion is handled).
> 

Sure Tom. I will add myself as maintainer for TEE portion of driver.
I will post that as a separate patch.

Thanks,
Rijo

> Thanks,
> Tom
> 
>> Rijo Thomas (3):
>>   crypto: ccp - reduce tee command status polling interval from 5ms to
>>     1ms
>>   crypto: ccp - fix command queuing to TEE ring buffer
>>   crypto: ccp - update copyright year for tee
>>
>>  drivers/crypto/ccp/tee-dev.c | 57 ++++++++++++++++++++++++------------
>>  drivers/crypto/ccp/tee-dev.h | 20 +++++++++++--
>>  2 files changed, 57 insertions(+), 20 deletions(-)
>>
