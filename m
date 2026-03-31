Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010034.outbound.protection.outlook.com [40.93.198.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B216531F9AB;
	Tue, 31 Mar 2026 04:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774932317; cv=fail; b=Tgq9UUz3Oq1o9g50VNHbeXeA2/qC2O+xtnzc07db2iVDIg1GKJ7vWFJkE+dvWrpbQ9s33TrXjuqQ3W4hWpgJyTdLCRU2nXuVUSp6nbPahJvCBO+KM1xt0trVu/+ppb2HZxjVDO0jUQySF3PZSS2fZkMmLpgRocAs26dq0xw+7X4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774932317; c=relaxed/simple;
	bh=bDOLxcvA1nHLQ0JLJHu7LRQ5NuBKDzVtDUlh37ZBkyc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O8xaGgwriRtt9Zn6RFMmLimcO6pIEL77WubsXCdOkNuGcjb7J183aMgi/mHYpfslHpjRNUeEQzBUUciUWVzQw0WAD3WW2SYXy4bIwSC/9iNFhchOIdeX76pcYxlYR7kzD/UjJKwQP8CyfEZmJP3vaNRUE09Ko6DjS7ni7PwvzwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DxEupBbl; arc=fail smtp.client-ip=40.93.198.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DxEupBbl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvOPszrq/I5r9kAhedDVc8xLSc5HLrHxK46ew0VXh6y5lBUeIXoktE5Zft0Vq0Hk1+ZK6LsMJAmhgsd2Dg9VP7QfcCteq12lWceyZbRI2qsS1Xs31rwMqaFFlcGMoZxlhzuMaroUXYmvUf3DtSnN9WBCH+0emJrxecBLmMEJILPdAk4Z1VSfCa61rHLEnC+gm43UU3Z5FyOKmW5/Goxc6erUiTWatntEqnKaxhaz6JFcDkaFVaIOjHoMD6S9BBpU1Y/v55xp+QpB3IAPziaA5jVm4Sagla1v/8+dlh1MRwnOPLjloz4cuxInMYp1FMtAa7WhQSnBOYQr4+PJytLE6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNV9rV5q+GiAwur9YcKzHHLssJ7EGWLajE0mFsPn6PE=;
 b=MMf0hI4pw1TPX4y7uia/8rU40cCUktdih1FWaGnKxB5RIWb2ZH8ls9kvHCjqsFqm++sIlTQke4zrM/De2vsEOs38MpyBYPRgQ4ov5ZHE5yxXrn3/3mM4LkcO9TjeqhtpyIi1OAGyQO/3hrR4ys65zC65cAUsW/VT5B+h1yG/1TfPEozBHf1F8w+8HSgyBa68bZGvAxFu8IpbPbSTukG7KpBXyZjdU9w2MSmgorcMCzSLyQRC/MhARZjPjS/gKdYxtlU350HRZsI5sZoPos3t7r+9c00i4c0Q33eZQBo4lNgJN8iaBQDgosClm9y/wMaY+7jcGwh4bwE4L2sF54rAwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNV9rV5q+GiAwur9YcKzHHLssJ7EGWLajE0mFsPn6PE=;
 b=DxEupBblPOpoF7kISgT8j+REzGRO1ozKq7Voyc3PAASFbUHzWi1uVqdgS9erNpJNxJuMe6VUQfeYKGmnnYr/FGyHBmI8VduYuKmxzja/ov3S221F9bReSeQdIb10zyloQ/lZPfGeHnCsDaNgou2ywlafdL3XTe0ctGkBhLp6738=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH8PR12MB7278.namprd12.prod.outlook.com (2603:10b6:510:222::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 04:45:09 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 04:45:09 +0000
Message-ID: <31040bb7-653a-40f9-8899-40bc852f7e1f@amd.com>
Date: Mon, 30 Mar 2026 23:45:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest
 teardown
To: Ackerley Tng <ackerleytng@google.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
 <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
 <98313534-af6a-4c00-a016-9d9010f145da@amd.com>
 <CAEvNRgGdaA1ynF8jxQDPh9U0U8Q0RkE0=KJx4FNrh_=+dVRaLQ@mail.gmail.com>
 <75cd28a5-fb51-47ae-97c7-191fe9a6e045@amd.com>
 <CAEvNRgFJ8csUW0fXGB3cimjP=jev7mzaexUnfyj0p1ptFdPvCA@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgFJ8csUW0fXGB3cimjP=jev7mzaexUnfyj0p1ptFdPvCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:806:d2::12) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH8PR12MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: 9199e0b1-88ff-41bd-51ee-08de8ee04962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l6yz4RcJJ6Y4Gf1kxaskVEIGb90kDMjpltAUeJd7rTotg2/Blw6z9AfuOGpVs+ObTRozVxWFsjteWyyyg9XKVLREJWP115k3GNwEEBNSuajCL3S7k7EwGcHjb4AwRI03CVOvReqb0qFYXABkVEEZz4Bl+cLisEkExSnzLa7VVqjDhWIJdCfpp+llTZUb6HTX4YngFGVx7pXwXi8v5SauMdCcDj1Js+2F0XCUPvxiqPfb4IKyU+o7DTmUqP/+XCEcUIyfD9fkUaclHIwc1xvPDW+K78ivGIDaq9ncbd1OsHduP6OFdHYJuh4pA8+q8muwymkrTYsABgCPwkpL+Vg16KiFZvykQHegp1KydK47CfwlzSgiU+aSw3AMExjnudRoDq2aM5p2DFJTfhUs6PNWDOrOqFv8oj0eRbrl5o6NPOhzff9UNuDHGlGjReUbTtqlYbN4pYYksiv3JtGOoOvfKk5LUZUASslAm1sIdf19EMMl4tdFwcDGeeIf5flAjWaa4zSgyalKkYdxI/dcKiwYyO0HL5zJm49xPvvPVE3BMymRQZ3P3oL3c11Ucz/snZSiy+BpLZ6xq3IswQpTiLgKzgXAnrfMiv4mhDcfF/If/xIIyHBStdR4/a0RakruyhMT6AiOHjNlOQxFjgswRBzh0hxzLqKnCYeWEDUqiIkJjLI3mQYIljIlv38BrBpIhtLUDvzBYd2DmpyL4se7fICzLu4cYccklQXr2xH4xtoLWI6quQI6VJcZZ2zGayN+oOpnwpxcZkRaTGsCHArMVVN1OQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDIwK2I3OFBXdlQ1SWRXTkl5UmZ1N21FclFmNWVnazBnMkRUK0wzSnNVcFdV?=
 =?utf-8?B?OXFuMzNVdXVrenpCRytncE04djFZSUNmNVZScFo4cHBEUTdiWmlzVW9hMVBP?=
 =?utf-8?B?QXB0YUJrNUxkdlBxdCtXTXg5SkswdEhrdDNsZS96Tkk1K0E1Qm1NZXhVbThm?=
 =?utf-8?B?bmlJZEF2UTZOU1BHMFFVSFhEdEFUaXFRZDFwMnp5bVFhTHZTT1lsVmoybzZC?=
 =?utf-8?B?eDl6YkoyeFNGR25IMTRyK0dSN3pqRGQ4UHdDRmFSNWp1Q1FKdlQ4VU9vc3da?=
 =?utf-8?B?dENKTy8wY3NwMXJVeVRneDNEUXFJZE5RL25jdXRadlFacnNnbWYwY25vWTdR?=
 =?utf-8?B?ZFF4MDFIdFdLd2I0SmdENDZRaVE1UUFNVWtoSllOcm9BM0VZbXA3YzlYS0lx?=
 =?utf-8?B?R2ZDaWZUcVdWanpVZWttWnV0NGY2U2d3bDJlSktSRUo1Q0NDdHBTNnZ6ZS84?=
 =?utf-8?B?T1FFS3VvNm9xcW9hMmdtMG9ONjdaRCtkcHFIQVFJVVdQQnZnL3N6NDBRWWF3?=
 =?utf-8?B?bTd5SHQydkhSV0JCdFp0ZVU2NjZyMVhiNlpOUC9FY0RiOWcrdElXeEp6dFdu?=
 =?utf-8?B?d1NaTW5qR29DcFFoQ1M0c0haeVBBbGFnazRJYnU5eDVxN1d6bnU3M0tqWXd1?=
 =?utf-8?B?QW8reXBzQWRVRXREU1JuOW1RSVY5ZDBDTUFuNlp4Y3ZPTmhhbW4yUm8wN3NR?=
 =?utf-8?B?T0NRT0RTeGRCbk4xK2pnclNQMG1pclViUTh3cDZCdFpOVXQzb0U1S0kvV1FW?=
 =?utf-8?B?SXZIYnFaVkRNcU16d3N1V3lQeC9IRmRBcTRiRisvdnN5SFE1MDAyMUxMaXo2?=
 =?utf-8?B?ZHF5RjVjT2t0eVJ1MGNXdFJwQXpIQSt0bU9HTFNzdVRqUXowc2cvdEVFUjVT?=
 =?utf-8?B?TW9WWElodTFRbXd3SWZNZjA2Z1RnWlBWaXJabkx6T3ExK2VRZXl2RFRkSFkv?=
 =?utf-8?B?d0QwSWtxSTFRd2lEdXBoWUxwN2dEeWE4eU5vQ1c4Q21FK1dJNmRPVTJ6WFJ6?=
 =?utf-8?B?aVFFYWZnRjVjRzJFSDRRYUtQK2ZYUHdHR2xqallvcERQdjFSSDR2a3QydlUz?=
 =?utf-8?B?NVkxOHFJTnhNVFl2NWd4MVc3RkhkYnRRbmQ5WHJaV1F1UGpHL0JwNTM3ZEM1?=
 =?utf-8?B?bExMMUxDK083WXM3U1E0TkZiQnlkbm9wWW1HY3cvL3B6dkdpeHRrazRoQWRL?=
 =?utf-8?B?UndLMEJRb1V2bEJPaTdQeHVzSmRnMGVDZWo0VFNIT0IvUk40MTFvWDJDMGhW?=
 =?utf-8?B?Y3c4MEFmS2Y3Ui9LRGlWZWlSWFJ1Y0ZOczk1cE53ZDBYRDRzUHk1eVJaVTEx?=
 =?utf-8?B?OHJXazc0aHpTVmxDdFhudUovZldPYjhiS3ZtYk9iQ0VYMmFEcmZLdmZqV3dS?=
 =?utf-8?B?YkUvZk43cExKY283Vk9QQ01oYUF6UXlvVDFhN3JpNWdrVVpqSmU5S29ZL3Zm?=
 =?utf-8?B?bDg0Nk92ckpZV3YycW4xdlBDOURCUW8rdGNPRjFxQmVKSWFGMUJMZ3RMbGhj?=
 =?utf-8?B?YTRDRDg1LzcrMm9NWWJtWUZYc0NXYlFRMGVvL1JkSzBIUkNOMjIrT2JWNnpj?=
 =?utf-8?B?RDlzQ2pqYmJiSzd0T3U0cG5VNzgxYXVuUkNiSm0wWkN1Szg2WitvY3pqcTNE?=
 =?utf-8?B?OWNScHhZclVXeEM3RlJsZkRNb3hoRjR5UVNibE5kbWcwcWdqTnlwa1dxWnJm?=
 =?utf-8?B?WUNXcHV6U0t2aDRGTnhENVY5Nmh2amUvNEs3eWV1Mis2T0Fyemo4VURDb1Zp?=
 =?utf-8?B?VjltcGh5Um1yckZGVWgvT3FJUkpzdk4vQWQrY1RXR1NST0pnK0kzRVRKbFlU?=
 =?utf-8?B?WUdSdjltUEF1dW1lbjFCN21zWGx5WFplMEkxdXYrak45UUZsWmJyTWlDL0NG?=
 =?utf-8?B?a052QXhyZVpYMm04OTc0OFNrRE9SVjhHWVZZZC9ZR3NKNzVDTGt6UGVpRmJh?=
 =?utf-8?B?dTlnSVhKQ1h5S2lacE9hK3FJUXE3RnNFbEFuTk5DbmlYMG9SdzZnb2ZLa3Bp?=
 =?utf-8?B?R0J3bXdWbFBXRms4WHJlbTVOc0R5UC8yK2k2Wmc2d1VzeHY1UFFlNE1ESmpu?=
 =?utf-8?B?cG1aRElYV2o2UVRuNmQvdEgyWHZPd0RHeXlZTlhwYlpUWUE3aExncDFJOVpS?=
 =?utf-8?B?NTN6TEcrMWlOYmJjU016b2RBMXZrdXRLTWRUcDFlQzMzaHVKcXNrMm03NGpu?=
 =?utf-8?B?eHdXWWplYjdEeFlhcjF5Q0V0dFVjdXlXM202QkdaS29DajZxaUZEYVFlb3Rn?=
 =?utf-8?B?S1U4ZDFhV3dIR2IxQWYwL3B4Z3RTS05UQlZmQVcwRDlMZDlEd0RVUFUwWE9T?=
 =?utf-8?B?NC83NXZhN3lkUEd0cmgwblZSaUUzQ0lHRDRKVTE0K0pYam91UUc2dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9199e0b1-88ff-41bd-51ee-08de8ee04962
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 04:45:09.0214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/H2qNUtdKGsFtaywBnfOc19FtLIH/669eyg7OsR7pDkStc4p9kxakbQC3CLAuCGxY+JS5c0+Lv4l/MaTR1wlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7278

Hello Ackerley,

On 3/27/2026 12:16 PM, Ackerley Tng wrote:
> "Kalra, Ashish" <ashish.kalra@amd.com> writes:
> 
>> Hello Ackerley,
>>
>> On 3/11/2026 1:00 AM, Ackerley Tng wrote:
>>> "Kalra, Ashish" <ashish.kalra@amd.com> writes:
>>>
>>>> Hello Ackerley,
>>>>
>>>> On 3/9/2026 4:01 AM, Ackerley Tng wrote:
>>>>> Ashish Kalra <Ashish.Kalra@amd.com> writes:
>>>>>
>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>
>>>>>> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
>>>>>> cleanups when the last file descriptor for the guest_memfd inode is
>>>>>> closed. This typically occurs during guest shutdown and termination
>>>>>> and allows for final resource release.
>>>>>>
>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>> ---
>>>>>>
>>>>>> [...snip...]
>>>>>>
>>>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>>>>> index 017d84a7adf3..2724dd1099f2 100644
>>>>>> --- a/virt/kvm/guest_memfd.c
>>>>>> +++ b/virt/kvm/guest_memfd.c
>>>>>> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>>>>>>
>>>>>>  static void kvm_gmem_free_inode(struct inode *inode)
>>>>>>  {
>>>>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>>>>>> +	/*
>>>>>> +	 * Finalize cleanup for the inode once the last guest_memfd
>>>>>> +	 * reference is released. This usually occurs after guest
>>>>>> +	 * termination.
>>>>>> +	 */
>>>>>> +	kvm_arch_gmem_cleanup();
>>>>>> +#endif
>>>>>
>>>>> Folks have already talked about the performance implications of doing
>>>>> the scan and rmpopt, I just want to call out that one VM could have more
>>>>> than one associated guest_memfd too.
>>>>
>>>> Yes, i have observed that kvm_gmem_free_inode() gets invoked multiple times
>>>> at SNP guest shutdown.
>>>>
>>>> And the same is true for kvm_gmem_destroy_inode() too.
>>>>
>>>>>
>>>>> I think the cleanup function should be thought of as cleanup for the
>>>>> inode (even if it doesn't take an inode pointer since it's not (yet)
>>>>> required).
>>>>>
>>>>> So, the gmem cleanup function should not handle deduplicating cleanup
>>>>> requests, but the arch function should, if the cleanup needs
>>>>> deduplicating.
>>>>
>>>> I agree, the arch function will have to handle deduplicating,  and for that
>>>> the arch function will probably need to be passed the inode pointer,
>>>> to have a parameter to assist with deduplicating.
>>>>
>>>
>>> By the time .free_folio() is called, folio->mapping may no longer exist,
>>> so if we definitely want to deduplicate using something in the inode,
>>> .free_folio() won't be the right callback to use.
>>
>> Ok.
>>
>>>
>>> I was thinking that deduplicating using something in the folio would be
>>> better. Can rmpopt take a PFN range? Then there's really no
>>> deduplication, the cleanup would be nicely narrowed to whatever was just
>>> freed. Perhaps the PFNs could be aligned up to the nearest PMD or PUD
>>> size for rmpopt to do the right thing.
>>>
>>
>> It will really be ideal if the cleanup can be narrowed down to whatever was just freed.
>>
>> RMPOPT takes a SPA which is GB aligned, so if the PFNs are aligned to the nearest
>> PUD, then RMPOPT will be perfectly aligned to optimize the 1G regions that contained
>> memory associated with that guest being freed.
>>
>> This will also be the most optimal way to use RMPOPT, as we only optimize the 1G regions
>> that contains memory associated with that guest, which should be much smaller than
>> optimizing the whole 2TB RAM.
>>
>> And that's what the actual plans for RMPOPT are.
>>
>> We had planned for a phased RMPOPT implementation.
>>
>> In the first phase, we were planning to do RMP re-optimizations for entire 2TB
>> RAM.
>>
>> Once 1GB hugetlb guest_memfd support is merged, we planned to support re-enabling
>> RMPOPT optimizations during 1GB page cleanup as a follow-on series.
>>
>> But i believe this support is dependent on:
>> 1). in-place conversion for guest_memfd,
>> 2). 2M hugepage support for guest_memfd.
>>
> 
> You're right about this dependency. Do you meant guest_memfd THP support
> for "2M hugepage"?
> 

Yes.

>> Another alternative we are considering is implementing a bitmap of 1GB regions in guest_memfd
>> that tracks when they are being freed and then issue RMPOPT on those 1GB regions.
>> (and this will be independent of the 1GB hugeTLB support for guest_memfd).
>>
>>> Or perhaps some more tracking is required to check that the entire
>>> aligned range is freed before doing the rmpopt.
>>>
>>> I need to implement some of this tracking for guest_memfd HugeTLB
>>> support, so if the tracking is useful for you, we should discuss!
>>
>> Yes, this tracking is going to be useful for RMPOPT.
>>
>> Is this going to be implemented as part of the 1GB hugeTLB support for guest_memfd ?
>>
> 
> Yes, this is going to be implemented as part of the HugeTLB support
> for guest_memfd. HugeTLB support for guest_memfd extends to any HugeTLB
> page size the host supports, so not just 1G, 2M as well. :)
> 

Ok. 

>>>
>>>>>
>>>>> Also, .free_inode() is called through RCU, so it could be called after
>>>>> some delay. Could it be possible that .free_inode() ends up being called
>>>>> way after the associated VM gets torn down, or after KVM the module gets
>>>>> unloaded?  Does rmpopt still work fine if KVM the module got unloaded?
>>>>
>>>> Yes, .free_inode() can probably get called after the associated VM has
>>>> been torn down and which should be fine for issuing RMPOPT to do
>>>> RMP re-optimizations.
>>>>
>>>> As far as about KVM module getting unloaded, then as part of the forthcoming patch-series,
>>>> during KVM module unload, X86_SNP_SHUTDOWN would be issued which means SNP would get
>>>> disabled and therefore, RMP checks are also disabled.
>>>>
>>>> And as CC_ATTR_HOST_SEV_SNP would then be cleared, therefore, snp_perform_rmp_optimization()
>>>> will simply return.
>>>>
>>>
>>> I think relying on CC_ATTR_HOST_SEV_SNP to skip optimization should be
>>> best as long as there are no races (like the .free_inode() will
>>> definitely not try to optimize when SNP is half shut down or something
>>> like that.
>>
>> Yeah, i will have to take a look at such races.
>>
>>>
>>>> Another option is to add a new guest_memfd superblock operation, and then do the
>>>> final guest_memfd cleanup using the .evict_inode() callback. This will then ensure
>>>> that the cleanup is not called through RCU and avoids any kind of delays, as following:
>>>>
>>>> +static void kvm_gmem_evict_inode(struct inode *inode)
>>>> +{
>>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>>>> +        kvm_arch_gmem_cleanup();
>>>> +#endif
>>>> +       truncate_inode_pages_final(&inode->i_data);
>>>> +       clear_inode(inode);
>>>> +}
>>>> +
>>>>
>>>
>>> At the point of .evict_inode(), CoCo-shared guest_memfd pages could
>>> still be pinned (for DMA or whatever, accidentally or maliciously), can
>>> rmpopt work on shared pages that might still be used for DMA?
>>>
>>
>> Yes, RMPOPT should be safe to work here, as it checks the RMP table for assigned
>> or private pages in the 1GB range specified. For a 1GB range full of shared pages,
>> it will mark that range to be RMP optimized.
>>
>> If all RMPUPDATE's for all private->shared pages conversion have been completed at
>> the point of .evict_inode(), then RMPOPT re-optimizations will work nicely.
>>
> 
> Ah okay. The kvm_arch_gmem_invalidate() call in .free_folio is the part
> that updates the RMP table to make anything private become shared.
> 
> So the RMPOPT probably needs to happen after the invalidate in .free_folio
> 
> The RMPOPT stuff is still useful even if the host never uses huge pages
> for guest_memfd, right? If so, I think we still need a solution
> regardless of when huge page support for guest_memfd lands.
> 

Yes.

> What if we do it this way: in .free_folio, after doing the invalidate,
> take the pfn of the folio being freed, align that to the GB containing
> that pfn, then RMPOPT that? This way there is no dependency on the inode
> being around.

The issue with doing it in .free_folio after doing the invalidate OR after P->S translation,
and aligning it to the GB containing that pfn, the chances of that being the only
private page in the range is small and there is a high probability of multiple pages
still existing in this range which are still assigned. 

So doing RMPOPT for such page(s) (aligned to 1GB) will most likely fail, as there are
still private/assigned pages in this 1GB range.

RMPOPT will succeed or work optimally when we issue it when RMPOPT-able ranges or
full 1GB regions are actually becoming available/freed from guest_memfd. 

> 
> RMPOPT looks up the shared/private-ness of the page in the RMP table
> anyway so as long as the RMP table is updated, we should be good?
> 

Yes.

> The awkward part is if RMPOPT is run twice when the RMP table state
> hasn't changed. Is my understanding right that there will be no
> correctness issues, just performance?
>

Yes. 

 
> We can perhaps optimize (away or otherwise) unnecessary RMPOPTs later?
> 
> With this aligning-up-to-the-GB, at least we're not iterating the entire
> host memory.
>

Until we have full 1GB regions available on which we can issue RMPOPT it does
not make sense to issue RMPOPT as most likely it will fail. 

That's why until hugeTLB support for guest_memfd is available, for the initial
series, iterating all system RAM for RMPOPT after SNP VM teardown is an option. 
As this is being scheduled like 10 seconds later, then if other VMs terminate
there is already work scheduled and we skip scheduling another RMPOPT work.

Thanks,
Ashish
 
>>> .invalidate_folio() and .free_folio() both actually happen on removal
>>> from guest_memfd ownership, though both are not exactly when the folio
>>> is completely not in use.
>>>
>>> Is the best time to optimize when the pages are truly freed?
>>>
>>
>> Yes.
>>
>> Thanks,
>> Ashish
>>
> 
> Thank you!
> 
>>>> @@ -971,6 +979,7 @@ static const struct super_operations kvm_gmem_super_operations = {
>>>>         .alloc_inode    = kvm_gmem_alloc_inode,
>>>>         .destroy_inode  = kvm_gmem_destroy_inode,
>>>>         .free_inode     = kvm_gmem_free_inode,
>>>> +       .evict_inode    = kvm_gmem_evict_inode,
>>>>  };
>>>>
>>>>
>>>> Thanks,
>>>> Ashish
>>>>
>>>>>
>>>>> IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>>>> is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
>>>>> kmem_cache_destroy(kvm_gmem_inode_cachep);.
>>>>>
>>>>>>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>>>>>  }
>>>>>>
>>>>>> --
>>>>>> 2.43.0
