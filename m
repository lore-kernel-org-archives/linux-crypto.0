Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D37C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 15:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1883E2336D
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 15:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbhATP1v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:27:51 -0500
Received: from mail-eopbgr680055.outbound.protection.outlook.com ([40.107.68.55]:30531
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403884AbhATPZz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 10:25:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLgOJcBMyx5bxFJqoAGPFivI6+NwsMcpBW8sRNTuJDXOyp1kWEAksW9b5LXvdL9/EmfnKhMPp/mocFwS6BvVt0AHQ3PqOeQVAYcggO7yzd09zW7AMgwwQfQ0KtBmSKLrbI9VyC6l57m1aLCTjwJ6YNpUU/HxuQQmeylV5CDsJWKHKgMdGBrOmLSkjQAR4/INcso97jurW4EpRDsqIeHomPofsFf9lYD35VRGfb7DX3Tu6JvpTTq25voatr38jwolIcJwVX7goYiIwhrENCirwFfk6mL81JTiSjT+3PrFhye9vLXjuF5Yi+e5KPIGj85jQnNF0FP1/+m+3hf8q/95dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCr/qdLxEpNC0FHiou+7HIgv02CQUoVPSTjnucGU8jY=;
 b=faeqqVCupfRQ3HBkWA5tJ9+LG92IEh9fuuoGCfdgNmA9Vmv/Yrezl3TwGPoB49dvW2oXX0Nmvg2P/orLo79ut+eOkKwqzB4NZtca9azBhx7dazH7Xw24yOAa8E1g9QSF3X/CrSa7nKFgNZ84iCZByaCxhmz3RuhTkYLx0t2DmVbO9i+R0DjSUJqpAv+fm9uNs4fJAibjxszwJOzfjbmrYg7knb3bNDPohnY0WfLFoh6P1KQMTL31N9VpLDqfbizxARZyrTP7CSbm89eJ9AP3nJilUrtRRP6CSJnn99r0GiHeWvTUGLbM/Clot77jEC3V9aTc4W8V/m+6cbNKUJWsXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCr/qdLxEpNC0FHiou+7HIgv02CQUoVPSTjnucGU8jY=;
 b=Iaykhvo78li3AoMK1nGt1pgZvc87sQvPWbSurhCP2MzcggJDdMqWbOh7Epgm15EgFHeuK8ZmqxUqybLHM9UDUsBxhxZ7g8kNUNL5v6SU8w9zh7idkFt4cL3UJ7RdAKuhTVmeoradlJWh+oeeD2bmxNwPm7imAO/hrlrUOKjVAYc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Wed, 20 Jan 2021 15:25:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 15:25:07 +0000
Subject: Re: problem with ccp-crypto module on apu
To:     Domen Stangar <domen.stangar@gmail.com>,
        John Allen <john.allen@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <em96a2a8ae-80a7-4608-905e-5d932c0cf9bb@domen1-pc>
 <20201228152245.GA90548@nikka.amd.com>
 <95c0d9f7-e8e9-0b71-1f0a-44230c3dbfe5@amd.com>
 <eme43aecb9-708c-4fda-ba76-a446ecc12790@domen-5950x>
 <20210107151050.GA30454@nikka.amd.com>
 <emf3681a05-10b5-44ad-b516-c8492fdf8f3a@domen-5950x>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e4b683a5-28d3-ab4e-22eb-6f94e2799ea3@amd.com>
Date:   Wed, 20 Jan 2021 09:25:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <emf3681a05-10b5-44ad-b516-c8492fdf8f3a@domen-5950x>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0038.namprd11.prod.outlook.com
 (2603:10b6:806:d0::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0038.namprd11.prod.outlook.com (2603:10b6:806:d0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Wed, 20 Jan 2021 15:25:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f731698-ec24-4008-5025-08d8bd57917c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4484596070DC647E9362F6B0ECA20@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dvoFFx52jKHRsjVlVWOj00I6UDqKEi+4inm5Hq5pI58TrOPMmwN/VJj4N3Y4tHkJXXWuwkqrysqWwy22yxErwU+kk79PGb0PyMrOm9FuUkp/vJ6im6IbmZ0XSLxeZONxkWtGWfTF35I1xhP6hELjR+AAnQke6TlG4SGo3fay4q7gvDiKNGBmyXMPYjK4N0zwg15amFZmHNm4OlhcljCQtx4isBhpYMEb6KZuqVhacyxI/nO046gXCtAKIwKCVAMJTCLVXNlEDbUmLLN/7Tcorv0Y7yXJwt+0G+op68I03ZtbtjfZlOubWCgp0Pe1imroXEBLkrNriUlEFqspKZmYH/ibdxWSL1uIpfaWjIZ+W7+7S2LaL706rXbms4VN7sPpSWKuDcIwZsNSiK69WFLilea5p3YpS9CGbA2S/67dwYtgKVXUeRNSfrEJ2khXrIdU8IYRCJOjYW1VSfGiqa2uTSgrKIPIHNuYx22FIJDn3A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6486002)(8936002)(4326008)(478600001)(26005)(16526019)(2616005)(53546011)(31696002)(66946007)(8676002)(2906002)(66556008)(110136005)(5660300002)(186003)(956004)(6636002)(6512007)(6506007)(31686004)(36756003)(316002)(66476007)(86362001)(83380400001)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUFVUXR0Y3RsMHIvVkdhUktWOTMyVEZ1ZmpSeWJsWUhGUy84allFMHh2aDNX?=
 =?utf-8?B?c3NiVjMyMXpXdVRZREx4dmRZbnBXVkNHTUhvVGNGdUJJSi9JRkVobUsydllk?=
 =?utf-8?B?V1ExbHNKOGw4QXhXMmE4Y0hDZ1NEVW5hdW5jQU5leFEyTmVRQTJheFJKM0dM?=
 =?utf-8?B?OTRyU1dwbUVtMm5wblN6dWdiZ2JJS05EQW5OMG16dDJmL0VueDlzWHVTMXFP?=
 =?utf-8?B?TE0yUGxCd2lhTDkyTnVodkpDbFFacUhneUttdHpzUUZmMmdvZnd0Y0NtVkd6?=
 =?utf-8?B?ZjVQOWwwUHhabXRZenhod3pEYWJZcEFhanp2YnFoQ0VBbVpyRTkwYTNWT0FM?=
 =?utf-8?B?MHZhekNqQk5NbDByODEzV0cxY1hFeXlnYWVCY3QzVCtqcWdReGVlSkNGU0s5?=
 =?utf-8?B?OUUrajJRektUNVBvdWxhVlFDS0I3Snk3Ly9PbHhYUU9EbzRWQ280L2tGbEZN?=
 =?utf-8?B?Njg4dENsVlVKYUZQczNLR3hQWUFpVVNVVnpXVkkzWWdnUElPa2tLR2s0SEtk?=
 =?utf-8?B?VDRkVm1GTnFCQVFyWDIvdkZBYWtRejF6SEkrNCttMmFRUWZUYjMxSFJyR25B?=
 =?utf-8?B?S0pGRjVTSHNkbWY0aThFK2dVMG10RFo5WUQzZE1scC84MHRoNk5PTC8zV1Bz?=
 =?utf-8?B?bHNzZXVoeXBaWFA5dVY1dEJya3ZFWXZkK091bEU3TFFlRXk5S2ZtZDA1KzRW?=
 =?utf-8?B?aVhoVjVrS3N1WjREWStaZFZmMTQxK1dkWi9MbVAxQmwraU9EcncwNTcrQ2pr?=
 =?utf-8?B?aWFBUzRhSlczeGg3WUVDUjFSNnhVajdaam94ZU9JUXdaRFdPSjc1R1Vqc3ZX?=
 =?utf-8?B?dkx3QnRvb3BGQjg2c0grUDEzOE9wOXdEVCtTenphSlg5T3FlUWU3am9JKzht?=
 =?utf-8?B?NkZmRFhJdDlXRWZaVjRtK0xEV0EvWmpuWS9EZHA0THBLOTc0WWt6bHJZSHBB?=
 =?utf-8?B?YXJLZktLV2ErSk1zVlBZRGpOT1BnSjdkVktuNWR2ejNaNk1SUFpMTlNyRWNI?=
 =?utf-8?B?TWNhOVZydTc2Qk1lQTU4U1FyQTR3VUZGNnJPMFRxWXZ2dmVJL0pSNWdnT2hC?=
 =?utf-8?B?TTNoL0srd0pLT1ZKdnZZb1JFcXoyTEYzY2ZhV0p0Q1c4N09FZmJld3cxRDVR?=
 =?utf-8?B?d2gySGFKT1lMMUFEd2szREVPYlJscmJSa3ZJaGUyTm05OUpQbWRlLy9Wc3dz?=
 =?utf-8?B?a29uYnZzcE9JMitUTlpGbmJSZkF0dXoxdE1Lb1Y2TWIyZEhLR1FuRXhOdFNK?=
 =?utf-8?B?VU9nekljdm40RmdaYkZXVmNrVzJ1YUZyMk1XaXhtR3VTNlpuN1JjNFVCa3hZ?=
 =?utf-8?Q?BMJ36y2zz68oP0DPO8/zAryebtflcsMms8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f731698-ec24-4008-5025-08d8bd57917c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 15:25:07.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D34vH4NrBai58CFgMRd58VRmWbYlnpoP63dc92qf3bsO2sfZBV4oEMQHw4Lo0IijUttVgImI8WWr/J3xDbp61Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/17/21 4:16 AM, Domen Stangar wrote:
> Sorry for late answer, somewhat missed mail.
> 
> dmesg last lines that where added
> 
> [  325.691756] ccp 0000:0a:00.2: enabling device (0000 -> 0002)
> [  325.692217] ccp 0000:0a:00.2: ccp enabled
> [  325.702401] ccp 0000:0a:00.2: tee enabled
> [  325.702405] ccp 0000:0a:00.2: psp enabled
> 
>   /sys/kernel/debug/ccp/ccp-1/stats
> Total Interrupts Handled: 0
>          Total Operations: 1
>                       AES: 0
>                   XTS AES: 0
>                       SHA: 0
>                       SHA: 0
>                       RSA: 0
>                 Pass-Thru: 1
>                       ECC: 0
> 
> interrupts output attached.

Ok, the interrupts are not being delivered from the CCP (running in the 
AMD Secure Processor or psp) to the x86. This is a BIOS/AGESA issue that 
will require a BIOS fix. I don't know what level of AGESA it will be 
delivered in and when your BIOS supplier would incorporate it, so my only 
suggestion is to not use the ccp and ccp-crypto modules for now.

Thanks,
Tom

> 
> Domen
> 
> ------ Original Message ------
> From: "John Allen" <john.allen@amd.com>
> To: "Domen Stangar" <domen.stangar@gmail.com>
> Cc: "Tom Lendacky" <thomas.lendacky@amd.com>; 
> "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
> Sent: 07/01/2021 17:10:50
> Subject: Re: problem with ccp-crypto module on apu
> 
>> On Mon, Jan 04, 2021 at 04:10:26PM +0000, Domen Stangar wrote:
>>>  Device name: ccp-1
>>>     RNG name: ccp-1-rng
>>>     # Queues: 3
>>>       # Cmds: 0
>>>      Version: 5
>>>      Engines: AES 3DES SHA RSA ECC ZDE TRNG
>>>       Queues: 5
>>>  LSB Entries: 128
>>>
>>>  Let me know if you need anything else.
>>
>> Hi Domen,
>>
>> Looks like we may have a lead on this problem.
>>
>> Could you provide the following when you're loading the module?
>>
>> dmesg
>> /proc/interrupts
>> /sys/kernel/debug/ccp/ccp-1/stats
>>
>> Thanks,
>> John
>>
>>>  Domen
>>>
>>>  > Domen, do you have the debugfs support enabled? Could you supply the 
>>> output from /sys/kernel/debug/ccp/ccp-X/info (where X is replaced with 
>>> each of the present ccp ordinal values)?
>>>  >
>>>  > Thanks,
>>>  > Tom
>>>  >
>>>
