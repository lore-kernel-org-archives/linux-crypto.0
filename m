Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388FCC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 14:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D926112E
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 14:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhKKONd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Nov 2021 09:13:33 -0500
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:47585
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232630AbhKKONc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Nov 2021 09:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhzLP5v5q3Lo85/BSmXHV83SinahaWv3uwt1jr1sd6590tS4MDHYOMYB7i/G6b9U/RV6gmG3uGVOYc3AZwUFE6PWRT5yJtHbaaa4JmbKB84X7ZKaq1O1aPREinfw39ZnNHm3t2IMHsQ6vqhgL2HJgyH6XB3wOG9TLuPVfJBfYG/Y24zGahmQrGGNAPFbKGt9ahDQMEZjEhEnICpDvAdfYwGW7efvzZ0mipnErUu2e4VGzmxq8ZqsYfWF71CmQPeRt5Vm4LH9Zd4VWkPxXxArPhUzFn8LXFip/QLxzvchAiqpjcMsIM1T3Qo5HrZYizAF+cmVYVeuOi2HImEWetb+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HE+SsJxlPraSdv6EQMY2lEyd7A4e9V29lU4E5cgjHPs=;
 b=KtRglIWrHfpMVKncU0l4aL6KFot5dfJIXegN7OoufdbeTgGENeh9g9haYuluPsJehEeiKtawV//zcm2cXoUObtIYLHLV8mvJzo9jQU4e0Hd3NN/+borVQugksyY5R+SDWectjJr3085dbGVtvOYS5Cak4hiBu6E3KU5POqjpUICW8T5UQ08R1XL3f7lIiy410sdQtVnrenFRrtlIxIodfcUAd6n8ni8fIpGr7IMNhZhN6be5WIWaeG9p7HH4WRGmP7eYbScMHnvOenZ3IQKHGJMFc40aEPdJU0x5kJBnhBKxn4V1cZxnwgyrgUQIaAB9nB+vdAtkY29o/sW/AIBxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HE+SsJxlPraSdv6EQMY2lEyd7A4e9V29lU4E5cgjHPs=;
 b=qmfleEmPnGBxDU5xXhxau3gIDyfCsUl4d20j4vE9ESrRj8eAPM1XsJ6Q246zjpobUqUvFfhke32cOhniwAEtjTmcHLIxerVdFsNf3zpL/bMozgWp8yvwVFH9Lbof/4Xhyk44M3k0UCkiM+fJ0jLNXcvPD29UWzk0D9pNzaGApdE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5479.namprd12.prod.outlook.com (2603:10b6:8:38::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 14:10:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%9]) with mapi id 15.20.4690.020; Thu, 11 Nov 2021
 14:10:39 +0000
Subject: Re: [PATCH V3 1/4] crypto: ccp - Fix SEV_INIT error logging on init
To:     Peter Gonda <pgonda@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
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
 <45af7051-aab0-2b19-2904-64eceec93df5@amd.com>
 <CAMkAt6pivYG=nV_EhP9Uj2gB8kBQB4dAnTcSeGd9249KuWzsyg@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a6823579-c4af-6506-ba13-d6391b42d4ec@amd.com>
Date:   Thu, 11 Nov 2021 08:10:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAMkAt6pivYG=nV_EhP9Uj2gB8kBQB4dAnTcSeGd9249KuWzsyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0044.namprd02.prod.outlook.com
 (2603:10b6:803:2e::30) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0201CA0044.namprd02.prod.outlook.com (2603:10b6:803:2e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Thu, 11 Nov 2021 14:10:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f63cdfe-5e7b-4966-4e58-08d9a51d09fe
X-MS-TrafficTypeDiagnostic: DM8PR12MB5479:
X-Microsoft-Antispam-PRVS: <DM8PR12MB547998A65B50664D3DA025DFEC949@DM8PR12MB5479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjHxGUzxgS7Ng78x+wp1iJ5CwlZxUBq1Z91SHjD49IlIEO22G1v45CFISzQ7F3DmyZJ9Or2NYUAH+jY0WSgWdJWtbB/jB+uIGLCy01ycSJ/P0+jzCdqKCk1uEXfQaeEntHtWxKui1OE8/TuoXITLzE3VN++f40kADjh7NssL5uDC2aW95Y4vuIMbAcOH5L7PAVOr9/52PtI828aFfwGB0/UqM/Igzd6veq6zid597mPIpKhUr8DR3bD7j8e57VqqyaZDCoWjxQdBWZ1RaX/1YyrHEPjbdTOsq9xt2jJXtzLDOVxaGLLcKzxIK8+QhE2993jz4cPg6tCLDPNOA/dMldsS7PQmOQOdxfAd+tTCVnTg5Gn8hR63msPkDKykZtnKRJmzgobLjHQdRfAEMbMPzmUoxZ3V1jP/FBMtHh22dAvaC6U8O0KMA8reCmTk2alwQOqNlXN+m9PaCDixuZKWdik3qd2lKtlfymxXv/OKLEVdLM/4AG3hW3DBlYtYZLbN7Ghwy+A4VDaB+IUILc/d2nwFShVYmkXV87zwNoIHDT0d2VSMueO2Q3X3cH8PsO9Juef85VOs7HLNphqqOQX+SoHpMckUWoyu1wh/onLRhqNUQMPaxEH0qg3UGlw1V9NSS3TNWtoDpSkWe1zVCV6Yx5km2r3LHpxKKIDa0n4fPCb9+fRt1RW0FH/+zYjMt1WUukFPY8IgXGAuWNih+NhmGq2ZqRnxIWxJpoFqHKtqZ678vhcIdk4rSYCDWVmUqdec
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(2616005)(8936002)(4326008)(66946007)(36756003)(508600001)(8676002)(6486002)(38100700002)(66556008)(66476007)(186003)(31696002)(316002)(6506007)(956004)(26005)(6512007)(2906002)(53546011)(54906003)(6916009)(86362001)(83380400001)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cENMcHIwenp0MFdMNnozZ1RBdkFIS25mbVFMbzlUVnd0QllJNzBUdGRuWmpj?=
 =?utf-8?B?UGRrRHlTeU9iTnYyL0RtamZ1T2R2YklIVEpZNUxLaHJ2WW8vQjA5KzVnSFly?=
 =?utf-8?B?RjdOUGdtbmkyUkFlUDE0RlFlbHVYSzdWRUl2UU52ZFlhRURoTlg5Nk9qdEts?=
 =?utf-8?B?MnkrcUJIV2hzSUFVdjhHeWlBWlVhZEtqTHIvN2xVdUdjbjhucXVXQnZsMDE2?=
 =?utf-8?B?TGVWK0Y0WDhsRjVjRVgwaTV2cmlacjlSSFpseklMQzNWb1BYcHpGMHd6U3dR?=
 =?utf-8?B?MHk0WllkQzdTWjJiV1FTOTJsRUF3dmpFQU1HMWxpbXhsZkllWmFZMzkxY3Yw?=
 =?utf-8?B?WU1saVpjUDI4ajk4U2FUMHErbnAxN1NWQnZqM3dzRmFMRFltVEtHU3pYQXFT?=
 =?utf-8?B?SytpWHVFZmJyS1lwVzFFL2JzZWc1a3FwL2FZTEtoNzI5WU54WUlPYzlvZSt1?=
 =?utf-8?B?WjV6Mk43c3BKSDFZVDczcEdoUHZ0UVhmbUhwNjluY3NMeDFOY3hMbTJCeUJB?=
 =?utf-8?B?ZTM1aGVIS0cyOXlHMmVRcUhoa1VaZmlieGR3RjZBbDU3eUxqNTFLbzJ6Slpa?=
 =?utf-8?B?dnZZY2RQSzVnVmwxdTFXSkFUQkhoS2l0a2hiaW9pNmVjaGZHdDM0U3JTRi9o?=
 =?utf-8?B?MnBBRkFpUGZKcVFXaDJHRDAzazU5MVd1Q0FhcVNNa0VUd1h3U0RvdXlhV0Qz?=
 =?utf-8?B?ZHBXb0FLb2FhQlBqUHhLMHh6ZGlwRk1WN1VVUHIzU2NsZkxpZ1FMSE16dTgr?=
 =?utf-8?B?R0VEa05HTjBXQnZoV1JPY2xxTy9aMk5HV2VSRGNjOGZoSklka3BzMWUwakVx?=
 =?utf-8?B?VVVNN0pWK09WNlgzUm5TSFhrYVBDaFhuTlFKZ2ZoS0xMdDNpVG45eEVJZW9t?=
 =?utf-8?B?ZTRxdXRTcVZ0TnR6dWVweWp3WkVQTHJrK3ByM0s4bW9iOWlibFYwSnVoeXZh?=
 =?utf-8?B?a1FxcVpnZFphcUk5WGpRaytXUXFqOTl5SE5jVkxIbnM5YTJTYW8zWmVyNGNi?=
 =?utf-8?B?NDdKM0c3ZlpoN3dFam9XcXowWWtLY0lTUU9ZNnkvSnBwZW56VFdOaXd4U2R5?=
 =?utf-8?B?TDE0b0Ywak1uT3BDYUgyRTBxdE9yeUZoQ1dMd1JXcTBkUVNIYTlkY0FJY2pW?=
 =?utf-8?B?TFNuSW1KMERyVHltVlgxU2VmUGVKM0UxY0tvZ0R5eC83bWV6WE9MRmg2a0JK?=
 =?utf-8?B?M0duOStVMWRJZ0FNVDJPWmtPc015UGh6L2R1UDFIbklYNDZOeUZrUVhiaWw5?=
 =?utf-8?B?N3plRXlBRXQzbDZPYkRIMU1ROUZkM2ZETlY4UGE1YTdUNjhiUy9mOFdOellG?=
 =?utf-8?B?UjlyZ25hQ3dhOTdTc2Z5bjA4YjZOQ2FaZkJTM3NndU9KanU2S2dCUUVwTDlM?=
 =?utf-8?B?cnRQQ1AwV3AwMXRXTEZXN3M3ekRHaC9oQ1hLTERLa2RpeTd6SUtFNG1iZkVy?=
 =?utf-8?B?eFdhV1NHSndyS1RlTk5UaVRhU2JSUG9yNVN3SlpvZDV6UThWMkY1WllLY3Ru?=
 =?utf-8?B?bitXVEl6ZXhGMWFTWTJjS1ZZSUd0RlR1QU5UTis4eGY5aFU0SjNoMzYvMi9O?=
 =?utf-8?B?Vko2K1RlbThrSmFZS2lIQ0Zya01uckZkSmFRQU8rSFhkYWpwblJPVng0WldK?=
 =?utf-8?B?ZGdHYmZ3OWMrQWk3a24xMEFrUjVuWXo1ZmsyZ1N6S05OTThBUmZQTkFSb3p0?=
 =?utf-8?B?Y2VnVS94OUZpQ0dGSHNtME9IaU5UWllPTTBzTUo1Vjh5SjNIamZyT0pCdzlZ?=
 =?utf-8?B?NGlzSi9oZUhaVGZQd2hZcnNENmlOYXNqdnJqWXRRQzNEeFB5UEJ1STFUR0Nh?=
 =?utf-8?B?K3RHNzFSR0JRUGJONU9xVUpFV050K2g4M3NwdUx2SEpVdFh0dmwrb0hUbTNS?=
 =?utf-8?B?ZzZwQjN4MkYxSGowTm1IaDlXclZlelJNRXpJYytpWkFIc1dITVd5akN3RzJM?=
 =?utf-8?B?a1RzQVZuYjBURDNCTEZOZnZTRm1QeGtQK05iaGFyU0hEcjdiaUFJSkxFazZq?=
 =?utf-8?B?VlhXdUcwNndYN1dLMy9kR1dLMlA1T3RaaEF5OGtUcVJqaG1ydzlWYU9LNk5B?=
 =?utf-8?B?R29HVnBTOGtSbXZnblpZcjUwMzVZK3NudXFpVzJwd3VKM0lUR1h0NXBqQ0t6?=
 =?utf-8?B?dEVWOGZVS2tKL0ZSMFNab0s2cjFXQ2pXK0NGaCtjbHEzUTFzU0FFejVFSXFJ?=
 =?utf-8?Q?2huj+C8BEEW3ngOvX8d8bvo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f63cdfe-5e7b-4966-4e58-08d9a51d09fe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 14:10:39.1713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zuWEwq4dQFxDNt8h9Gc/unMOrqVpjDMftk0TMcSNIcarM7TS9AqrmERezRfI79bCsQtgx8QtwSfnptageDqLVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5479
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/10/21 11:29 AM, Peter Gonda wrote:
> On Tue, Nov 9, 2021 at 12:25 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> On 11/9/21 10:46 AM, Peter Gonda wrote:
>>> On Tue, Nov 9, 2021 at 9:27 AM Sean Christopherson <seanjc@google.com> wrote:
>>>> On Tue, Nov 02, 2021, Peter Gonda wrote:
>>

...

>>
>> That's one of those things we've wanted to get around to improving but
>> just haven't had the time. So, yes, if you wish to refactor the 'error'
>> related area, that would be great.
> 
> OK so when I actually sat down to work on this. I realized this is
> bigger than I thought. If we want to have error == -1 for all return
> from psp-sev.h functions where the PSP isn't called yet there are a
> lot of changes. For example if CONFIG_CRYPTO_DEV_SP_PSP is not defined
> all these stubs need to be to set `*errror == -`, basically all these
> functions need to be updated.
> 
> So to keep this series more targeted. I think I'll drop the error
> here. And just have this patch print the rc value. If what I said

In that case, I think you should keep the error value and initialize it to 
0. That is consistent with the other paths. Then, if you take on the 
fixups, it can be changed then.

> above seems reasonable I'll do those error refactors. Are people
> envisioning something else for the error fixups?

The main refactoring I wanted was to make sure the caller didn't have to 
initialize the error variable. Whether to initialize it to 0 or -1 wasn't 
part of my original thoughts. But I do like the -1 value because, 
theoretically, we shouldn't get such a value back from the PSP. So if the 
value printed is not -1, that is an indication that the PSP API was called 
no matter the value of rc.

Thanks,
Tom

> 
>>
>> Thanks,
>> Tom
>>
>>>
