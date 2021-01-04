Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF2FC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 14:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97732072C
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 14:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbhADOhr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 09:37:47 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:19008
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725840AbhADOhq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 09:37:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM0l96H5jt9mCRGJfp9afXci99mOb24haaIjbPrdEZSYBoMF79aPoI44tXVR/Dmd6WyjBTBb5wHVEPcPT8SaqQ/fUzfm6oMVV/xOoogbIGpjwaxfCZeADDH5IPxZov+1vW36z2xjOCR6xY755wyKQgGJazoX9S9iHLRrZXevO/onQVaFFPt1H8N52YrTvew7IKgBrki3C8MWiUezHAMbsQcfP2UkaoVHI/gwXObfGPqwnlWDQKWABZkPlZiBTfEscNpzUZ+A7gghBCiIu8PjjhMZG32x2PpIO0qwYoqIUkUaeyyL9SMUQA06pc6TTqBnlrTQ11gQDQ51H2lp2Pr46w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDcnNOe7tz0K0zPdFI9nM+FIYohKErZgYM1+QOOI4Ug=;
 b=IZVoCes5CWNQh+4UV8Sn5sGNz+zECoovqyIXBprb+uLN6Fz7Z4f77wOmOE8uI+yetvtcHsOF3EoTT7+lF2l8POTGSel8Tv8FcR7ztBVtn+i+06/Mj4eyiL8SKwBLy5Jh1fhf7ya73ylMuYQzGMH/J/KOfOAYbH1hAcSTcGtf5z1NqA1A2vkbBKmHyDdG1WwINg0SwvmcZwIL5f43rXiMi8GLsiCm9cqtgB6gHbVpzSWr8w1gMwP5QppaQLKJ7GxSle7JP9/wcFoUNCP7MNPEfkyAbCJXD/675JedZdcREYyzpOUhj0l3LbhZ6KYvV6pglPlFyU9jFO+VsKCSCG2F6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDcnNOe7tz0K0zPdFI9nM+FIYohKErZgYM1+QOOI4Ug=;
 b=r6SYmxGWqAjXRWAWn4+g6Uuf/pV6Ewfr2EN0EJnaGmP9/gjOswWqTNdXbz8Iv+5Hjuw88i+8piFCAxhGzeeu4jaPp02z7D3xZdlaDixHHe4vPCaNSXNfrTbt2uSWWpQCpX8cxNcA7d9D5/sMYsQQrP7vyZH6IgkojwSc5QzVzqI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.20; Mon, 4 Jan 2021 14:36:54 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 14:36:54 +0000
Subject: Re: problem with ccp-crypto module on apu
To:     John Allen <john.allen@amd.com>,
        Domen Stangar <domen.stangar@gmail.com>
Cc:     linux-crypto@vger.kernel.org
References: <em96a2a8ae-80a7-4608-905e-5d932c0cf9bb@domen1-pc>
 <20201228152245.GA90548@nikka.amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <95c0d9f7-e8e9-0b71-1f0a-44230c3dbfe5@amd.com>
Date:   Mon, 4 Jan 2021 08:36:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201228152245.GA90548@nikka.amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0401CA0042.namprd04.prod.outlook.com
 (2603:10b6:803:2a::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0401CA0042.namprd04.prod.outlook.com (2603:10b6:803:2a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Mon, 4 Jan 2021 14:36:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c02409c9-f197-4944-1b10-08d8b0be2eac
X-MS-TrafficTypeDiagnostic: DM6PR12MB4043:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4043C1B205BB68EBDFB2194BECD20@DM6PR12MB4043.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqVhVSGmdJqnPhDjwN77oT14+yUDQJMWIcK6OCvcicuD0H8oZ1w3e9T8qWNKlQ9EPBjylOEmAgafEMDEyG1mYCKzZHckRKloZrIvNitIkzXc3tJPhhnIxxUwR5PjDra3x98gC5WeM1bY9RL/39/cjUjEbZqV/tuxduyi/gpBBQBSzPn2JQUxpmKqqu1EGBDCxEYz1XXoAOtF7ngv+crVdAa2o359n1Y8EnESpwa5+jmDBvd7zECz1QDQVnHAjCeZFEsA7kRVzZelpJMxpeHd8+AZuPIjuYC864EFcVSP5yvgyLKUbgLyqXNY1TtkdpPLfpZSqA3pQgTDwO7JdVy1ccP8Sgl5eb5EJOamFfuzv2UUID7Z7lmdkAe55yai4wKc0m5TSINDGLxhC9vgozuvb4POuwHDT4e4KwlBhi+niPhrJsM0fCMTNXrH8IHpNvH2qPdlU+kmQXu4DPeC1sNBzeTXlioCWuTvDSUfxMfWHDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(110136005)(2616005)(316002)(8936002)(8676002)(6486002)(31686004)(36756003)(478600001)(956004)(83380400001)(16526019)(2906002)(4744005)(26005)(66556008)(6506007)(53546011)(4326008)(186003)(66946007)(31696002)(6512007)(5660300002)(52116002)(86362001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MWZKZWtOKy9acDFYNUYxekZLWk1mNTJSNEY5elIySXhHTytPYS9xSWZPbTBq?=
 =?utf-8?B?N21GODRleVlaQ2FtNFlIcys3Slk0cXJFUmRZUC9DMTZ2dWY0WHpMaVhuYWJP?=
 =?utf-8?B?U2h5K1VsUnBJQWIzdEpyUmVrMGxuOUR3TERzOTJkN09rZnRWQkZUZFBudmF6?=
 =?utf-8?B?eERzZU81VUU1QWpBV2NZMGRBSjBiZ1B6L0dQblk0NEVuWEladHhDOUhqYith?=
 =?utf-8?B?bFVrYU0rOTFqckJLUlZrRTQ2OWZCakk5QlduOEpTSFNLMElZK282LzFObkRE?=
 =?utf-8?B?ZklieXRwblBPcE9SZFVoY0I5UjdOS0ljTzA3dy9kcWRXa1JDWlYxZVpqUnAv?=
 =?utf-8?B?VE1pWWh6RmQxeXBxZTVWWERoZERaYUlnTWlZRjE2MzROdU1aY1hoZFJmc3hW?=
 =?utf-8?B?MjBUSzY5VUFnOFVOc1ZxcWJUcGZiWldnTk9OcG8vekNrSGdoNHlibXZveDlp?=
 =?utf-8?B?dVZhdDdjRXNobFlFdmE4TEZxTlpjTG5xd0w3cm9tMTlLYVZJajdqdHB3enI5?=
 =?utf-8?B?bnBvVnZvYk0vRDVtc2JaTndsRVVGUnlmQS9ncFkyMzUrUlJIcWpXUjNVSzl3?=
 =?utf-8?B?TUpOdGRlQ3M5TDBNQytqaW10VmFoNzZqUFZFSkZMQmQ3cWp4dlJZQy9PMGIz?=
 =?utf-8?B?OHBRWVFZdGlTczhvcmZ6SFNxNnBtTkZiaU9IZEt2K2dBdWxXWlI4ZDBMb1ds?=
 =?utf-8?B?S3dVV21VQmx4U29tN3RuTHRiditzUlJKTmgyazFVNjM4OUU4SFJkRGQ5MnFr?=
 =?utf-8?B?cnlZc2F1dWRFYkpjN05jVUZUS2JRWk5vSktqV1VYdHBUc3hyV0gzTDd2S3Ew?=
 =?utf-8?B?cklEYVRpZVhxQ00rbDNYUHh3d2xHUFZUeXBuNDNUYUw4T2RFTzAxWXAwRFF0?=
 =?utf-8?B?Z3lMTDUyZ2FFR3dDS0V5c3ZhZ3ZVVVZDUmlXV2FaTWI4QmdEaXVhalRHY0Yy?=
 =?utf-8?B?S0p6TFhiNjBOZk9mTG1GTVo4cUU5dVFwdyt1cEdJY014dVVuWXdzY1BOa1FB?=
 =?utf-8?B?Rmh3WjU1T20vajhsTGd6c1JiS1hRbmJQbnBacFk4RmxtT2I0UzVFQ0J5RTho?=
 =?utf-8?B?WDJhTmVjT0UvcjVtaytIaktMK2F2QUR6K2RZcGhFMkNpZVh0eHIyKzZlMXZp?=
 =?utf-8?B?T1hsZlVJei9leGJNNStza1J3ci9jYno0R1ZjMmJrZDJqckFUZ25EWUtQcHY1?=
 =?utf-8?B?Y08wK243R1F4bGVNb0hyeWFSWGxablkrZzJiSE4xYnh4RmxFQkk3ZEdzMEZW?=
 =?utf-8?B?aDBnZCtGYUw5L2N3blU0L3p1aFdCbW5PSkFjT05xa3JkUkNsUkMwVDRTenlv?=
 =?utf-8?Q?yYGBByDhtOaNNLyLd8vZP8yK93j/jMChHJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 14:36:54.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c02409c9-f197-4944-1b10-08d8b0be2eac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnpU0QfiuTLi8OcJARnPDnbebh3EV4HMFJDCnyUzbQliB0hTBHm9TBe0x3cbazWJ6zh3hdOHQmhsY2kHybUCMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/28/20 9:22 AM, John Allen wrote:
> On Thu, Dec 17, 2020 at 07:42:52AM +0000, Domen Stangar wrote:
>> Hi,
>> I would like to report issue with ccp-crypto.
>> When I issue modprobe command, it would not continue, without SIGINT signal
>> (ctrl+c).
>> If module is compiled in kernel, boot doesn't finish.
>> Looks like problem is that ecb(aes) selftest do not finish ?
> 
> Hi Domen,
> 
> Thanks for reporting this issue. I'll look into this as soon as
> possible. Once I can track down some hardware, I'll reproduce and debug.

Domen, do you have the debugfs support enabled? Could you supply the 
output from /sys/kernel/debug/ccp/ccp-X/info (where X is replaced with 
each of the present ccp ordinal values)?

Thanks,
Tom

> 
> Thanks,
> John
> 
