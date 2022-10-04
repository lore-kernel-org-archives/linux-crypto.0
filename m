Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E667C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 09:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJDJwl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 05:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDJwR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 05:52:17 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F8315FD6
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 02:51:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n80Z5WOTFUy7n9OWUqxyzmimgya3PhbKUwKZC2tBLucnZvcg8/ARNa7qixtCPZjpJSV8vUIZpuK08YxFIsGXHaDbdd/poaVnKRz2Kr4DNM48Vt3VgKeDqQ3T7thCtKiUBgUL4fT/Ty4wjo2OQ6dzwxWycazCHYGH12GvmCIrbXudVHzS974MaidrabRwa6/DEGlaEBoh6Nlid2eqpy4fMjibQkOXfqV4y7C3lt6v26j/iIKUkF1E7MkkEHO5vtks2ZY2mqT/o++6kAp7y+X6IznfXcmAQZYES5AVQj8aW5JFgsnRJTB87CtnefKzI7EZp/OfYitjkes0KXqd/5DvGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3oo7L8nhoTDk0hjtVdsdt4KSxQFQFuqwNDyPnFxI7w=;
 b=Uwo6xMZtgLe9mh4Zs1gg/hAIdiMEtI/3HRwUwXlTKXBeFDpJTI2so1eoR04wLTLozgXC3fejhQT5KVp/02pVqr9UuWZk+ezGgXrzuXRzrwsKxlXf6W5+ezC85qXi+bFvSUTa5OkbaJJUGa4jKmUx4+mW1oKFtR8SOOjtth/l0ec6fkKMmtTP8U8ytwti5uoRFTRY6jO7v5NvlYqHA22PMR9nWdvqMOKgpsHwgAbny0iB17QTOgVG/JET4emIIaIHCVHyBdmD9C09XK4mJya1MSA5OjbKLCiqtK2PIfQZg383LiFjmLOTkDLZZPkm1GJ8DMCKSyh4dI16wfoTq1SrvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3oo7L8nhoTDk0hjtVdsdt4KSxQFQFuqwNDyPnFxI7w=;
 b=1d/MVaP1FK219ME6RwWlnwxtlKFPm8KtScDOxUSu0xOzkojqB2dEM63YDkQjBqIagAMX26MjbcpqDWsFBdeBzWMx9Exr4kAQgIOHDPJCpMNOK30kW8O6cwvaP8qtzBlut3ZsqHbPkYtrSg5KHi90kPIfaJW2gGdIQ1u8q2VRuos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN0PR12MB6320.namprd12.prod.outlook.com (2603:10b6:208:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Tue, 4 Oct 2022 09:51:08 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002%3]) with mapi id 15.20.5676.028; Tue, 4 Oct 2022
 09:51:08 +0000
Message-ID: <a9ea7eac-0fa4-63dd-42ad-87109c8fe0e4@amd.com>
Date:   Tue, 4 Oct 2022 15:20:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Early init for few crypto modules for Secure Guests
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
References: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com>
 <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
 <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0107.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN0PR12MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c2d2b9-55aa-4331-100c-08daa5edf60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCVfZJhX6kC4FqgvZ6MUntrZxue+39+AxdMOGrKk1k3iKlMYLbVJOCB77Dax44lTpJGmInK2Lo0H5pAZEGf4fU/gPM93BjtzRjxUBbmE+x85LlJjbKc/5aK+h3vxyAwUMYSo+ZfSOlHyGhtsXfNCqESya+Km58+F0d4rc/5ZwqVG79nsuodDCA5n0674WSV9wmupSBjSv44vwIyf0Xjhtoj2Q2L+3gnDGZ1A3lpYNZe6Owg9mmo+TZ0LAGI8cmT+s+nfUMzBrY/fpPY5ES4Wy6B2gCfZjP/wfHtrn32Pn0fF7GjESHWJewFiXE3vlm4iF96iVElGFAoQNEfnbxVqQxKm1v9USnIPCXzDK7OB9LgztjD4ZZhliCAJG3W2qBUZlOwCcYHoNjzgOMu9swNM9OgYYWLwMWoxONmBx4lU0ky6cFeovDhWGUXMm9pw83yNMQVNipi0WowsaqpPjkC2xuT1pXnrXRNYxaToYDWKrZAflo67lndexyNhIEbyowAZZ0ZGlRoQYl6QPx05mBybrawkJElkZ5hRpvTtNBbcvKL52hifmbQTWv4ZQhkKxzjkmWFU90q2JHPwYnINknqW2uvijk/WKM2+jEzeZ+K3na+3kOL5O3gQde1SuccrtjSL3rtKHFvcAtb1DTOS0LA9Zybm5n6LS3L1MQUCCNCMnvyCeDG66rUg+iHADZhapTcV1kXNViik0IedvszhuAeHtmDs+RsBoy/0ZoSrPo6BSga3OToD+VS5Gksv/r8sbd5a9BlMGbDWDvTSbb02rHyEVrphHMwzRtrMnaZY+C3TO44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199015)(31686004)(186003)(2616005)(83380400001)(66476007)(38100700002)(66556008)(66946007)(478600001)(5660300002)(8676002)(4326008)(31696002)(8936002)(26005)(316002)(2906002)(6486002)(6512007)(6666004)(6506007)(36756003)(41300700001)(6916009)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG10dmxEU3VzU1NTSVlLUEE1cGVjdGxCNVZ2RXAxbGRZZTVsUE5SNmpJMUJ2?=
 =?utf-8?B?TDh6OGVLdjVYa3l5UEp1V1MyWlE0SGlyUUVyV3hMN2VRRXdtcUZha0UxdGdB?=
 =?utf-8?B?aUt0TGhOYmJnUGZIZkpSNTM2bVQ3K09kSWczZEZuV1hPVmpDLzBYWnpKZFo1?=
 =?utf-8?B?OTZuWjFlbE9rcXJtcjdSeXQ0cjRIVDB3cDdmUGs1eHFjVW9OZUZ2U3A1QkFl?=
 =?utf-8?B?bkhrcGQyWHJyc1ZMUE1tVTBOSDRoYXpsM0ZrdGpzZ0h1VFZTOS9kbmNaUlR2?=
 =?utf-8?B?K1B3ZlBuQmZUZ3JSQ045cHduN1c3QStOSEhkeTRLOFBjbzZNZ3RYMWMvc29t?=
 =?utf-8?B?b0orMzlwNUJYQytXQzgvSVZ5VTRHTDhYVlBSQjd3SFM0YkFxQWF0Mm5KRzFl?=
 =?utf-8?B?eXBFN3RxNERWN2h4YXZRTFBzS0VoVThpWitJRCtYcUhyRjBCL0tzSTdkZGJF?=
 =?utf-8?B?L3RYczBHZmhaNy94ZTVRbW5pUFo0azU5RC9yUVhrSkdjK2RYZlRHM3ZMSC90?=
 =?utf-8?B?VnQ0VlBwckkrMmNSYzhxWWJDaTdvZXhCSTJ0bW9OaGJsYVlVN0tTdlV0YWxU?=
 =?utf-8?B?ZkU0ejZDNFNocE9FVzNZMnl2WEhjcHJ2KzU0dXQyejQ3M1VaQnk0dUpGOXpo?=
 =?utf-8?B?T2NLMkx1VE9JS3ArSXVwN0lkVVNVYzcrSE9ZUFh2L1hQcVBSM3BzYjEyaHZk?=
 =?utf-8?B?WTZpOFIwVThBSVBoRlVGdk5BMWMzUnJ3M05CaURRSW4wT01wZE82ZVFZNVhL?=
 =?utf-8?B?Y3NvbjNvbzdxdjU1QzhuM1VkeXZ2K2YxaVpqSlNEVkpJVTBQVytQVFBsYzgw?=
 =?utf-8?B?TUEzanpnbXI1eHZkN1A2Q3EwQ0RWcGliNGk4L1Nsd3JpYXpZL0QvUmpDZ1Vk?=
 =?utf-8?B?VnJuRkkvbUtVVkJVV2F2NCtCL2tLYXBPTFZDYmpIRzMyL0JtV0tMNHVieVlM?=
 =?utf-8?B?OGhQVUQwQ0wzMityM0NNQ096a0liVHNOTlhwL2VQa3BIZ1ZGSzI2WURYTVZU?=
 =?utf-8?B?TG5LeXlSUU9yamQxb0l0bHVWOVQ1WlVWY0xFV0RiUXJxWVVETkhsaGZBNkJz?=
 =?utf-8?B?VlhJM3hRVWQ5S0hGV3dIaVpIMzdvVllqN1cySEZvNzkxRlJsa290bE5lQnJC?=
 =?utf-8?B?bS96RXdaNGtReFpLQmw5cnF1RUNkQnk0YlJKYmJMUXpLYTVNb3BLWitHYlBt?=
 =?utf-8?B?Z3Zudi9tb1FpSUViU0F5M2tFMFlRR0VaUmgyUHpKNUQxRHVWWlgxM0JQSjA5?=
 =?utf-8?B?RXhhUFZCSis2ZkxRcHB0djZEVWVFK3N4eDFHVTdEanYrTkNZcUJkeEhTbHpz?=
 =?utf-8?B?VnZwc0F2Tk4zNDI0OVB5cjBLSWNOb01MWTlFWFVDYmwzREhnYzByUnRWaXhK?=
 =?utf-8?B?RXl4RXJWb2M4ekZWcFY3QVluQklZOEZGeVZmcStEbitwVmJ3RlllbjZURThl?=
 =?utf-8?B?Q0VwOUtaOTZDODdoSXVzVjFLa2VURnlCQWxzeFhlckhuYSsyVU5oeXl4OXBQ?=
 =?utf-8?B?Sm4yVmVoTEZqY1A4azJ3UGgxQ1RrV1p3Qng1a0ZhRWJmSkR4SDBBa0xrQWUx?=
 =?utf-8?B?bWI2dWY5NmV6ZHJqRTFNR3BGY3pCdG5zZHNjQUN1M21KN3UzSk43VHZFYTFR?=
 =?utf-8?B?eUNZVm9uNEprRWE2SUhNS0E2R1hZcjdJd29xQkczZkYwUWRBNExmT0V0RVRP?=
 =?utf-8?B?Z1N3dzhIdndiN0tEUWUxc0ZNczlHVTRycEpYU3VwM2pnbnVwLzlCakhzaHZV?=
 =?utf-8?B?SkJHUGttbDB5ZHlqNlBwTlkrSUZyeFF4eGViN2wrakIwMXRtdG15Vm91TkhD?=
 =?utf-8?B?ZWx6ZzBsaUxPdDR2cUFScE41LzlYYnZ6QnJtbXlXNFRzVjdGM2dqWGdodzRh?=
 =?utf-8?B?SHg3K1drTDBWaDlJeVpXbU9OQTNWZVE5bVl1V0pJekNESFBmMUszbzFaNzI5?=
 =?utf-8?B?UGVIdzV5TXU4am9xamRGdEw5ZmkrTkFZakdwQ1UwbzVEUUU1cVdLTXVhTDVu?=
 =?utf-8?B?QjJxNDAxVno0cURtajA1NFIrVzMzR3lSaDJWcFUwQUV2OWRYTEg0dDhSTUhn?=
 =?utf-8?B?T0NiQjhpb0RZWlMzeDJiM0FBeDdUVzlkend4YmRZb3luWmZEdFowT0x1VFB3?=
 =?utf-8?Q?H0gDMw/8R/eEFV0Rl3Y0eqvqK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c2d2b9-55aa-4331-100c-08daa5edf60e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 09:51:08.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dULMD8VK1tZcPNAlhCEev6npcmO7pUzMM4Xm7liN1NPnPUi1YCxGJQ/4+W8WYWlO+nXvXDGne/0kGtRZifZweg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04/10/22 13:58, Ard Biesheuvel wrote:
> On Tue, 4 Oct 2022 at 10:24, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>> On Tue, 4 Oct 2022 at 06:41, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>>>
>>> Hi!
>>>
>>> We are trying to implement Secure TSC feature for AMD SNP guests [1]. During the boot-up of the
>>> secondary cpus, SecureTSC enabled guests need to query TSC info from Security processor (PSP).
>>> This communication channel is encrypted between the security processor and the guest,
>>> hypervisor is just the conduit to deliver the guest messages to the security processor.
>>> Each message is protected with an AEAD (AES-256 GCM).
>>>
>>> As the TSC info is needed during the smpboot phase, few crypto modules need to be loaded early
>>> to use the crypto api for encryption/decryption of SNP Guest messages.
>>>
>>> I was able to get the SNP Guest messages working with initializing few crypto modules using
>>> early_initcall() instead of subsys_initcall().
>>>
>>> Require suggestion/inputs if this is acceptable. List of modules that was changed
>>> to early_initcall:
>>>
>>> early_initcall(aes_init);
>>> early_initcall(cryptomgr_init);
>>> early_initcall(crypto_ctr_module_init);
>>> early_initcall(crypto_gcm_module_init);
>>> early_initcall(ghash_mod_init);
>>>
>>
>> I understand the need for this, but I think it is a bad idea. These
>> will run even before SMP bringup, and before pure initcalls, which are
>> documented as
> 
> /*
>  * A "pure" initcall has no dependencies on anything else, and purely
>  * initializes variables that couldn't be statically initialized.
>  */> 
> So basically, you should not be relying on any global infrastructure
> to have been initialized. This is also something that may cause
> different problems on different architectures, and doing this only for
> x86 seems like a problem as well.
> 
> Can you elaborate a bit on the use case? 

Parameters used in TSC value calculation is controlled by
the hypervisor and a malicious hypervisor can prevent guest from
moving forward. Secure TSC allows guest to securely use rdtsc/rdtscp
as the parameters being used now cannot be changed by hypervisor once
the guest is launched.

For the boot-cpu, TSC_SCALE/OFFSET is initialized as part of the guest 
launch process. During the secure guest boot, boot cpu will start bringing 
up the secondary CPUs. While creation of secondary CPU, TSC_SCALE/OFFSET 
field needs to be initialized appropriately. SNP Guest messages are the 
mechanism to communicate with the PSP to prevent risks from a malicious 
hypervisor snooping.

The PSP firmware provides each guests with four Virtual Machine Platform 
Communication key(VMPCK) and is passed to the guest using a special secrets page 
as part of the guest launch process. The key is either with the guest or the 
PSP firmware.

The messages exchanged between the guest and the PSP firmware is 
encrypted/decrypted using this key.

> AES in GCM mode seems like a
> thing that we might be able to add to the crypto library API without
> much hassle (which already has a minimal implementation of AES)

That will be great !

Regards,
Nikunj
