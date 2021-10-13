Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C98C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFBF61130
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhJMLsz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:48:55 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:35169
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232486AbhJMLsr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 07:48:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTpchfUGV1UaEAJyLLLtSRozmCAaMcdFokFWSlnYGHAmeN86IuY3mbPsUNYTkgk0HD0Hj54nLSPhaiZDjNWz/jjzvR4aIXmM/xXcc3py2wCLaDWOXgYUGvyiinARtWePZIysbQ/EbHJOtjRIae/2QsbEpjnebYPeBcJPziJRemfHcwKn8AMbr/RO6SLVbL56ofzBiIvECxdZ8LRqcMdyxhq5M0+hGwMqZ+v5V+yMAjQxVwb5cCq1ljS5hNTiRQQMyTKNwyiWe8NonssqY+pKUKlIlcCubPBPp2pBVGUTzk8+o/ll8HH0w/eZrofXyYH/eKuCZ7a/Jjmqmim2CAwLag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlL4hUkF7PF0UWQnOh7LuyYVPo/v6vZ5Vc1exUBkw3E=;
 b=XIwFkXqAqVeFmdKi+ESqRkVuJD4lfbkLJKgVkEre8lXDq/imwtnabn1s/LhTECN9SrvtP/0UUDaC4yjm4KEh8Wd2x+ZkSarxzAiT2cm1r2E1R6AFt9jxXBmSo2KfYuENzzzKtsHxZtKoSgbuT8la6gQFLBKhWmfuJbnVxmoY0V8F1Qwxh+hM/QQET6H+kKTPUx11Y8VgJIrA4TZOIGxHyBAapzHC/xXWu08GNq9JTvbzXYeZ7zI+pMVYCZXjXGZgT8O20qEbFN2V7r2QSSob7ltsS3ZaAG5OvR0BdP2wo9QC5+S6cWnKq8lk3jBo8jecoR4FgyX1yknfvyYxi0JGrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlL4hUkF7PF0UWQnOh7LuyYVPo/v6vZ5Vc1exUBkw3E=;
 b=E59xqah+u9Oho9cldUCeddnUj5ID3/T4yiHfvz3AbiPC2gxj9rpjH1YRm+otOq2qf1Y3PuO2oRcSFg6/L4DpfUIfTRYoLcLrsVZZShtBeNEMntvNu/Heva7yNT4y5HJcxgkBhtq5VuCwon9Rl/cduvcT/WVPBu2a8sKUT+9gmds=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 11:46:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 11:46:42 +0000
Cc:     brijesh.singh@amd.com,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Consolidate sev INIT logic
To:     Peter Gonda <pgonda@google.com>
References: <20211005195213.2905030-1-pgonda@google.com>
 <fdf0c263-38e9-7780-d0ac-943b6d2dd3a3@amd.com>
 <CAMkAt6piNiJdHDMzSqgm-aQ0o-xxM=ax4qMgn81fKzVuaNukPg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <54f66e72-a33a-2f07-fe51-992ba0c7444c@amd.com>
Date:   Wed, 13 Oct 2021 06:46:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <CAMkAt6piNiJdHDMzSqgm-aQ0o-xxM=ax4qMgn81fKzVuaNukPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:806:130::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SA0PR13CA0023.namprd13.prod.outlook.com (2603:10b6:806:130::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 11:46:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 225d53de-37b4-46f4-5cb5-08d98e3f2003
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2782B12A1FBFF430FC23BD3AE5B79@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oi3FSY9ywUCnnBvJOpMrMnsDzyUEjVvcWSrY5xgUfjEwv3+OVqEGkIL2y46LCBQkL9/83uv+zzPMDurmnki1Pt1yqyfucJkSESgPAIYOnfv72/orPNK1IWB67ECeT6j8X91dGMXakvSPvufBYroTNd3uxybudFbOlDR/6tl9TN+NOX5/tklNqcyTJnhWqgFXXStw5/1n/GzmOGm8YZkvc5aF5UaGcYgyl+7KaYzoco4fnLAZGuraaoGanpdZ6bXoUhge3OROToj+bfBmApXa+cjUSyv+0PiNvwsbimtaSc4iDJ/yzEtGGqq51wT3Jzb1XNbMcchwO6TLdM8xVJFNAs5GrFmVlnjnA4LAVIJ98W2cRMsLCc0dJPR90K0BVdITMTrhBZhHkoefU5Sf/vS4r2Mwo9KS3VHft2b3Yk0Z5Llip1alCw9jAhmAN6vBtr8VdB97GqsrGfCz3NJMM7Lg//L++V0V76Nuo3pm/t37/XQZiWPVL/QekgWHVoVPvlp323ci8AWrQdVKJH3RzZ0dQfsQ8JU1GEWh8yjHRv3894O1potrdcwDT03h4xFlQdTaPncUtpc0cEYZa6VCHSV40Gni8PSepsZBUX7KpG9LKZQcLV2Y8kBiWsIERI0qJZB/RR1j8s7EvQxNEKxkI2nfyxWxqFOqx5Fu8mJGCSIzux+DviJJzhpLzlrpp+MUNwUiRSWViLOmg2kx7KJtPK8DfYuqaCi797doRhuYZwAthnB0MQiEtW4r7v0aVK8SX542
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(31686004)(508600001)(38100700002)(31696002)(316002)(26005)(54906003)(2616005)(44832011)(8936002)(956004)(83380400001)(86362001)(2906002)(8676002)(66556008)(66946007)(6506007)(6486002)(66476007)(4326008)(6512007)(36756003)(53546011)(6916009)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXE2bHZwcmwvWktiNmtVWnhGWHNRQXBScWhqZ1kvUHZsc1NaejhDQy9jYVdn?=
 =?utf-8?B?bk1WT3pxMS9ZZGxRS1BJNkhOT3RZNlRxL0p4clFsUUZteXlOSm4vZmQ5ekRX?=
 =?utf-8?B?NHFoUVgwbnVpTEkxM2hvdXdxMi9MTk9NaFB2UzBTbmRkbEI0ZFFleGF2Kzlv?=
 =?utf-8?B?bjFTNk9POWgxQk9hSktndmpJY2V3Mmk2amtURnVHajhPSGdTbHprVTU2aVVH?=
 =?utf-8?B?V01KSEVZYnNMZ0VNV1dwZzZmcldNSDhIM0krTm51YXB4Q0F1czNObW02WHl5?=
 =?utf-8?B?cnF5Nmpad0VoZEtibmJ4UVpuOVN0cTlLQWpLV1NjVUp3TnRSbmNzakg1cXgz?=
 =?utf-8?B?SDVUQWUxeFNyZElZYmpaTVZOOS9WM0J4SjhHZHgxUHFOR2ozTEF5UXdqUDBz?=
 =?utf-8?B?bDYxakFWVFp4MFNjd01sUFFWQk5iN0ZhNEhDTEZaaVZWYlVneXVmWWlDM29n?=
 =?utf-8?B?RnZuRDEyUXkzZys3OGlMWER3NW5wS1RrWXJQSWR4Mm42NTZjMVlBd1kvT3JU?=
 =?utf-8?B?SUZ5Z1JoTkpxUGMySE9VNGJQUzBrc1U5WVcxd0RhbmpvUGdYUTM4SEx1dHlF?=
 =?utf-8?B?MEpZZ3lVTkRMbFBRZjlLaUpvVkpnNDFpUnN1MHdTVGMrSDYrVVNIUi9DSUpw?=
 =?utf-8?B?cU54UGZRdU0xYXdSaVcyQlRYdXZTODk0eEY3Sml1bW00cm03NkVVWmc4Mitm?=
 =?utf-8?B?UEtzYlZ2TFpJUithbHRSMTBjaFpZTTFPait5YXhTZ2x1TkNRL1pBdC9UV3Y0?=
 =?utf-8?B?MHY2aHR2TXJxMldQcFd0T1FsTmRZV0taVGIzdC9PNy9rUzZ6Tkp0S0RNKytk?=
 =?utf-8?B?eVRVcUp5TERvTDByZGoxMnpVei9lTkJhaGZwRENxMkxqbitsOTdJQ29mQURz?=
 =?utf-8?B?L0ZGdHRkK1pnMTducWRNV1pxTWVDMTJTa3Nwb3lMR28rUlBPTklKQzlTS2Nu?=
 =?utf-8?B?WDBYZ3gvKy83NWRpQld1dkpwc05QbjBzOVM0eXRvOGZ4NVJHZ3BYMnpOajVI?=
 =?utf-8?B?MFNmTU1oYTh3ME1kempxeVQ1UEtjSm56RktGdUJzUk5OY00ycGQ1RFBBekZW?=
 =?utf-8?B?RjJFaDBZMHRrVWFzUGY0QnFoNHI4a21PaE44c0pNQ29RQWl0VUFNUDB4emY3?=
 =?utf-8?B?TEdsZGhWVnBacU1zbzhkNytpdjVVY245MTNOVUsyVnROZWxzR2RvVzJ3b29F?=
 =?utf-8?B?WkhjRmJmRzhFWjYrcXY2dXM1QmtCek5icTI2KzNyMWlBQzh1d1MxK1Y5bFZP?=
 =?utf-8?B?Y1FTQnBtSU5hOW04M3RQTU1HRjB3UHptZkpMVDdDMXdxUzJMRmQxYnlVc0pt?=
 =?utf-8?B?NmZha0RTODhLR3BNQU9OSUVGSnZkRlltSXVWWVQrODk2YXhkam5ZY2ZUMm56?=
 =?utf-8?B?cWNPVUhkU0JwaUFaNmdGWHFZdzlML3JxZmIva0ZOYVZvQVZjbVpaVExQZllT?=
 =?utf-8?B?NDdCdVdGam9hVXdBVEIvR1hQSWxPWGkxL1hWY1pNU0N3NktmVnhkWU5tZkNk?=
 =?utf-8?B?QXpKY3VEeGcxclZ6TkwyRy80QlB0SzRpSWhDYlJ3SkxNNXQ0YUM0L1A0ZUJ1?=
 =?utf-8?B?Uzg3TTZWNGdDSXM0d3hlQm9wS1NzVGJsVXZPcFhjR3VzT2dyQ1ZNYk1TeHcx?=
 =?utf-8?B?QWtUbEx4OWROSHRSc1FUNThpTUN2YWEvNzNIYUl6U0ZSZW1aazU4bS9tNWlh?=
 =?utf-8?B?RXplRzE5S2tHVEpYTWNrdDVnWmpIbzZCdlJlN09TNUVqMS8yUTFpcG5GNGxQ?=
 =?utf-8?Q?nhr3WrdsFD7HG+hzdMLP288sfrszUdAIdPtYWNB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225d53de-37b4-46f4-5cb5-08d98e3f2003
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 11:46:42.1750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6W6pgi+nbBi8zaypZOn7FtvqAneRnojkGqp0T5yHXpCKVtqKxhTxUQRHP6/92Q6EHhf/OFORpjPJtXyzr4/Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 10/12/21 7:34 AM, Peter Gonda wrote:
> On Fri, Oct 8, 2021 at 9:52 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>> On 10/5/21 12:52 PM, Peter Gonda wrote:
>>> +static int sev_init_if_required(int cmd_id, bool writable,
>>> +                             struct sev_issue_cmd *argp)
>>> +{
>>> +     struct sev_device *sev = psp_master->sev_data;
>>> +
>>> +     lockdep_assert_held(&sev_cmd_mutex);
>>> +
>>> +     if (!writable)
>>> +             return -EPERM;
>>> +
>>> +     if (cmd_id == SEV_FACTORY_RESET || cmd_id == SEV_PLATFORM_STATUS ||
>>> +         cmd_id == SEV_GET_ID || cmd_id == SEV_GET_ID2)
>>> +             return 0;
>>> +
>>> +     if (sev->state == SEV_STATE_UNINIT)
>>> +             return __sev_platform_init_locked(&argp->error);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>>  {
>>>       void __user *argp = (void __user *)arg;
>>> @@ -840,8 +825,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>>
>>>       mutex_lock(&sev_cmd_mutex);
>>>
>>> -     switch (input.cmd) {
>>> +     ret = sev_init_if_required(input.cmd, writable, &input);
>>> +     if (ret)
>>> +             goto copy_out;
>> We need to call this function only for the SEV commands (i.e input.cmd
>>> =0 && input.cmd <= SEV_GET_ID2). Otherwise a invalid command may
>> trigger SEV_INIT. e.g below sequence:
>>
>> 1) SEV_FACTORY_RESET   // this will transition the fw to UNINIT state.
>>
>> 2) <INVALID_CMD_ID>   // since fw was in uninit this invalid command
>> will initialize the fw and then later switch will fail.
> Good catch, I took Marc's suggested approach for a V2. Does that sound
> reasonable?

Yes, that works.

thanks


