Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FF2C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 19:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93C261211
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 19:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbhKIT17 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 14:27:59 -0500
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:38753
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235259AbhKIT16 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 14:27:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRAk04kVfwmLusQdDJpWVyl3pZ//Ezk0Ruq//pxs7feVneoP/59mrp4EoZAmnGZdpwciLp+1VjMlZkw0JR9WIsAzvAIdm1Sz+WnStuUCuY1EVmTm3hIGDoFswz3B6sTw/U4oXPqaFDKIc/Cc2CqNQPTq73YWk1ZyiHEmGC1Kl0PX3AAC62vnvCJzZSV+dxaz9LJMDtamrAC8u38A5i1cIsgLsigSlNu9ZSQFVttGqM0jlbzTfBHyFjHiz08olhjTutPXUGzIoz3ifQBdZidwfBWHSSKOyE9fe4EtHUfLGl+TesYYuYowMcORejE7mAzFp+asoYhr8CGdu7yj/vD6JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZII3zDYh1Qn7f5O1uPhYaA1/BxSVACeSR/4Hvwa2mY=;
 b=e+8a75ZYAxcvJjphuDVG+tmbIK+xT05tGcoIiDl7oxV/LxFULS+hTWKpUnVKO2xJEXKTRctDimUIrc7GveIGo4wCrKc6kulgsVPIlUf6LgKb0u2hPWnbQjzmkicA0XYAh/M9qwERFAipSOX6aP/g4WefhXHnYSCilr98WSnpOIQvuIAzKIkBHxwVYjw+bldHohiqQoMdLgW2aL7C9xgQ91UvFkPDFzT08ly4s1javgOlURqjI1YXxLbSZAFCrGrrkeebUMHrfZ15W9L7V2dnOiFPPUxGkOL0CW8yFV8VsMlyXoCMzSGlfhR2iSmhtB0hgICy8FijPrFKSa2ifQPz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZII3zDYh1Qn7f5O1uPhYaA1/BxSVACeSR/4Hvwa2mY=;
 b=ad7sE2DJCKY8KUZRF4dm13UmZuA3KgPFKf6be+zEUm2F/r6551wylU8gAhOYkxfYm/bL414BmFhhuU59+Qi3rYQZGybSjIC8ma5jq8WTOLUr2IpPfAtYOFq2hALOfOENKq4KD1Qi4qPCRE7c6F9mUpswEwCsreL8rUNuXR1R3wo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 19:25:11 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 19:25:11 +0000
Subject: Re: [PATCH V3 1/4] crypto: ccp - Fix SEV_INIT error logging on init
To:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211102142331.3753798-1-pgonda@google.com>
 <20211102142331.3753798-2-pgonda@google.com> <YYqhT+Enba5xa4cO@google.com>
 <CAMkAt6oVySH-1g+EXKvxQ9vmBV8rwTLq=qfe2+VZC+c6vATL7w@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <45af7051-aab0-2b19-2904-64eceec93df5@amd.com>
Date:   Tue, 9 Nov 2021 13:25:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAMkAt6oVySH-1g+EXKvxQ9vmBV8rwTLq=qfe2+VZC+c6vATL7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0369.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::14) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL1PR13CA0369.namprd13.prod.outlook.com (2603:10b6:208:2c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 19:25:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dfe1398-297e-40a4-c1e9-08d9a3b6a5ac
X-MS-TrafficTypeDiagnostic: DM4PR12MB5264:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52640592846AC1C60FEF8E16EC929@DM4PR12MB5264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkkyWvgyUJReHfVgv3mWQV6zxP+WuwrJzCHFOOr+UuF0WeanF6KPtsfq+OkPGEghvdmvwzR7TcUVoRLQokj1cX7/+4VnKOx5TdtRZ+JDYLDi0OWWJ6pxqKQH0eOawexZpXO6UHTsCuikYxs/xkxeYAWUTPjg2ywhk3ukqpa3Tm0N4GIjBife1RTkdilNudzcJMuT8r/Vamrqda1r5KBLQiNvowrWYR2RnJTox+bU8xtZwMSC5SIQynx+b8ZUCu9ekfNvVK4HKADRSWy4RoBQjSkT4uqvbweERw7s2uCPA1QrdXOPMENpvu+vhw1DTWLbFFx1NWjm0LJnH1Fde8ex6UIcXi8xQM1O7x1iFyn6IJpwuHp5EIAmwGg8sYL1pGDCD/W4VksB+9ZiaO0eg6tJWea6Vk7VZ6RCAYrs6FS5K3sKlFI8NlMXeJls6rARtgQIPeHRghyJBcg+18ptrPM/pZlli4uwBo4Wmq0F/ZA0VtIKZKGj2arQBxEKTn8KuohCA9pk7Ki5XAMhXVY3TlyM2VW9R7tyyF0Vp8/8hsQy+4tTNo4sQ9wHZVV3IBdfrLVuPdQto/YT3m6I3pJ5h/e4hgN9d98fE4CbzGpMvcuc2dAkL6veKjyhPMIuP0U4XgA1ir3jzmkQLMzBqjxyltgG2kAid/rWv64EgLbA/anwGyaxWyud011YrnULKmNQ4edxHVQm/AWZIjcAcNLEaV9bo2jJKlvZurI/OG5p6sVw+3z5EsD4lE2oLKG+u/mmq0CN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(86362001)(7416002)(31696002)(54906003)(110136005)(8676002)(6486002)(186003)(66476007)(53546011)(66556008)(16576012)(5660300002)(66946007)(2906002)(508600001)(31686004)(316002)(8936002)(956004)(4326008)(2616005)(38100700002)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW1kRGkrTmlOOFJkZmZ1eHpiclZOKytOWkdwOGpiUDl3bXhwWW05Q2xCMGlS?=
 =?utf-8?B?T3E1QnlrMEZMMnRLOXJEVGk2bk9TUGtVcHZ6YWR2aHlqUlc0TUVpRUFjaXc3?=
 =?utf-8?B?SENjaEpjaUMwUXBYM1ZyR0lzek15QmdMTFJXKy9xc0ZQVHVEL2VHWXArekF2?=
 =?utf-8?B?NDMwRUp1OHBGVG1aMVF6YzVZRWxnQndYZHYxaFhMcENuKzZ0b3BFYnl3RWpG?=
 =?utf-8?B?VkFJV0RQQ0N5SE5pRXdsTkVHcE04TFo5QTdFdllhcmkvODhIU0dXOWpXS1dx?=
 =?utf-8?B?d3AvalArR0NYVW9KR0M0UW9Xa3h3bGcxVG1RanVzTmtZSjg5akVMYjY5YTNI?=
 =?utf-8?B?am9kd1pSV3BLdnlIRjVIR3l2U1NkTzdOVFNyc1RQK0VEU1JEWExGMklHMTRI?=
 =?utf-8?B?dnpXdmMzMzdUVkFJMU5xLy9ROEJKVU9NYlJpQ3NCQVhnYkJueGEyV1NudDl0?=
 =?utf-8?B?QUN4aktRNUFBREFJT2I0S0FmWFBpLzYxTFA4TW5qTEZ2Y1JEOTBpRllMQjZs?=
 =?utf-8?B?dC9mSG45WmNlSkZWSVU5N3ZOa05RcXhOR3RFakd1QXRSZGxuNlJzcTZ0cDZS?=
 =?utf-8?B?NHRQc1A0RzEwbHo2UDNzUXN5N2lta0xPTkJYcFhRL05MUUR3V2g4Rnl0S05H?=
 =?utf-8?B?bWVkOS9LcG1hWjQ2MEdrMjd2ejRzdUhFV2pGbGFsVnBDam1YTTZVRWNHS0ty?=
 =?utf-8?B?OVVxVjFmZG9RV1FTZDd6Zy9BRy9HRUlGeUI0TldEL2VGa0p6alp3MStWSytQ?=
 =?utf-8?B?RUVrWFYxYkpKL3EwMHFNM0tMQ00ydStlRFFPYTB3SGEzaFpzTytIVGw1akNi?=
 =?utf-8?B?K0VIOFFwclBzMWgwZmFVUUJKcmF4VWdSQVFlSkdxb1c2aHJSbk9ZL3lqYUVp?=
 =?utf-8?B?RWl5OVN3bys1akpHV1Jsa2pmQjg3Qzl4SGlVRGNxaDhFVEF2cDdYNjFldUtn?=
 =?utf-8?B?ZzdIcXliU1RFaEZ6Rkc1RzRNT3JUQkdkUVVrc3dsOTRZOTd6YjlNMWN1a0Nj?=
 =?utf-8?B?VWVzY28zRGVMUWxDeHdmRHhXclY5WHB3UmxKTy9IeWhkbGdadSsydXpzOU9O?=
 =?utf-8?B?ZkM5MlBCdjk2Zlk1emtETTZLYWtXZENseDFuZVlyWEE0UjZ6RUFBZ05oRkhp?=
 =?utf-8?B?cTQzZGVlRk9IRmRIMXY5SVdndFNzM041clpTMzVrbEtFMEl4YzEzTjR3RG9w?=
 =?utf-8?B?VkNJQ3JvemxTMERVY3BNR1JuTUl5MVhNUDdpU0hCWDhzRVVyZlMzUnltREpt?=
 =?utf-8?B?dXBCUjQrVDFOVzVoVEtPWHpBdEVTanVoV2VDSlg2VHd2N2d3YW1icWlFeUxC?=
 =?utf-8?B?RXNKYVV1N2cvVEVkc3JZNjNpbGtGSVNweTE1YzJiQnlHTkhGMUJqT1R5YWt3?=
 =?utf-8?B?Vi92dVNuR3MxWEFQQjQxZk5wMjJOQlBGYU42byt1SVBzQWZ4eGZFNmdLcWpi?=
 =?utf-8?B?MmhvamdiaGpra2JleFdndkJCdWVoMEZ6MG1XanJuUHJubStHc0hLbTZhMG5o?=
 =?utf-8?B?dW85eCtGbUgvNlkwbmRCTU9TM1piTU5SQnd0cVRhNEVUNitWczBtaVFwUklE?=
 =?utf-8?B?VmIxdXN1SlR0UkR2SlN5VUh5QzE2OGhTcGFPcjF5SGw3OFFZRDNQbWFraHEv?=
 =?utf-8?B?ZmgxdE9kbWtXQU16SmVwaWJjdTYveWQ4OEgxNnB4bEJoeGFqV3ZLd1VQOTFt?=
 =?utf-8?B?NlNsK0Zma1VPRWUyZUFWN1Z1M2RzZVJDVU9ZQ3dhczhuZjI2YUcrcWtxOWI0?=
 =?utf-8?B?QzlFU2dDUUxybWJJdWFDTm1zRGliK3cvQW9Fc0JlOUs1azZjSnhxVUtRNDBJ?=
 =?utf-8?B?eGl5VWRSL1RTK3h0OENJdmdjWHlNLzRYTDVLdVdZSVFrZkdYRXRMRjVjOXhC?=
 =?utf-8?B?bkhGR0NlUkZOd3NwNXV3SENIblprQW1iZzhSVzAyYkIvQW9Yc3BJK0ZFa3Bn?=
 =?utf-8?B?K2FXV3RnbGcybUYzOEtJYnNIdUNXY2lLUXpmYmUyWmRySVlpK2pRS3QrVGlv?=
 =?utf-8?B?NjBvdUhGTk1teWpwbXJnOUVFYXdtbHBodkE1SFlvZ25uWFJaMnZrSDMyM0VT?=
 =?utf-8?B?YTJHdURrL2RPVmkyT3poRzdoenJaRVptcFVlWU9uS2tSSlp5T1o3Ym5Gc0da?=
 =?utf-8?B?MHhIYktTbVVBTnRrL25DZmdKYjJtQVZobUNGdW8wRjdMd25VZUtUU3dvZVVJ?=
 =?utf-8?Q?MP3pldZgicYyjHA9XtJfzN4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfe1398-297e-40a4-c1e9-08d9a3b6a5ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 19:25:11.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 409lAHUtMirtsQgn6yITuJW5OlyoLjyFbItZ7kqFtw0QeeUtzWmoxYdfLu+lI7miXWj7p1A3mkbIWPYUwNwd2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5264
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/9/21 10:46 AM, Peter Gonda wrote:
> On Tue, Nov 9, 2021 at 9:27 AM Sean Christopherson <seanjc@google.com> wrote:
>> On Tue, Nov 02, 2021, Peter Gonda wrote:

...

>>
>>          SEV: failed to INIT error 0, rc -16
>>
>> which a bit head scratching without looking at the code.  AFAICT, the PSP return
>> codes aren't intrinsically hex, so printing error as a signed demical and thus
>>
>>          SEV: failed to INIT error -1, rc -16
>>
>> would be less confusing.
>>
>> And IMO requiring the caller to initialize error is will be neverending game of
>> whack-a-mole.  E.g. sev_ioctl() fails to set "error" in the userspace structure,
>> and literally every function exposed via include/linux/psp-sev.h has this same
>> issue.  Case in point, the retry path fails to re-initialize "error" and will
>> display stale information if the second sev_platform_init() fails without reaching
>> the PSP.
> 
> OK I can update __sev_platform_init_locked() to set error to -1. That
> seems pretty reasonable. Tom, is that OK with you?

Yup, I'm ok with using -1.

> 

...

> 
> These comments seem fine to me. But I'll refrain from updating
> anything here since this seems out-of-scope of this series. Happy to
> discuss further and work on that if Tom is interested in those
> refactors too.

That's one of those things we've wanted to get around to improving but 
just haven't had the time. So, yes, if you wish to refactor the 'error' 
related area, that would be great.

Thanks,
Tom

> 
