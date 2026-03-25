Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012057.outbound.protection.outlook.com [40.93.195.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39903290C4;
	Wed, 25 Mar 2026 21:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774475616; cv=fail; b=d1fs2zHGvmkINTWZS46nWNuxkwEAxQ73I87MBNOYiJgDG6UeikHlojL4N8ZalVsYtcNZ2HMj4ecGhxtzExIrsTVwxXYso91uFDXEZiTxp24+gZ65RM0Zc9CVxhBH86MGCRjDAYtcxtclSkCkLAkOLsl9dVpQS+p6GnG77GSaTJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774475616; c=relaxed/simple;
	bh=02YXm6TApnmdm8brpHh2rKTaEmixoBBcvHU961kNFyo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CXtIwlytdQLo7/eBESNEpJhhLsXuX7Mj/1be809v3Ou6HrJaE0xQykOrRvKkAKk6pW8ZLpdljGr+/wvYKy5zzJac2jEdBNtnBDNTRDi+7lUqUERmBzT/VxbUbvUpiG7/aYfk6DZwZd8bAMxuMmBsVnEqgXh+6SlLzxPewYZJC3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5jANi6Af; arc=fail smtp.client-ip=40.93.195.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5jANi6Af"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lNIuiYjzesm92g4fBynmMj0DUuw0rDH2JdmJ/RKEBOKZPGxMiHNzqsSZra6ZxbGNEmqMm3rpXjSSRQAAVe1ZpQlEFAdUElxW6udkaA+T3rsXqXKA3qEERGjxq0w4mU7DL3XNDHpuijTzbcTaGPtkJ1ejM6H1fXIgU80Rt5c9pw7GXcuVjYsn71aUsNSJxpuPQuL1C8IU2vaTf6XoP498EJXPssxMpM8h9OwlzPPe+0xkFEj+CtJLzL3JEBMMz4+84MryrJekZcKV+2S1/PicS+6HxzVjZv4z0KsU+ucp/8qDc8zlncbiraHAdBdr6QuOtMb205ZCUiRRGDZR0RMoaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4lKXO7+7TwacohCjD3/WS3TwEuEcAUIGJ1sjIaywlM=;
 b=RmIeSHGga4+jf6LMEx/kDsI5aNH3vC1DwRI3W7pnNmDloDQOm65XlId7w1Q41Cvm3v094JLqFXk1F9FbPB1YkiEtNxlevHO/vvrNrmHfkeSvgBJebtjpYFzW9Lq/TrrNv13a2NPtENEGHeJxNEZIVemk6hw+DJaozqkaf/Qd1m+TnUDPG0grp8IxsYbaHzimGhy36C42f9SYa3tdrRRCaKgUHs8tykWmzyNs+HIZhppguHGyL67eWpXajXUBMpUVSR6w5Cs/AJV1ISFx20P+CHvu/zS4UX1QLMcQ8KHcT3akOzISPZIC2PJoCH2hTr5Vgqx57KBBmDDNYvgJAn9odw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4lKXO7+7TwacohCjD3/WS3TwEuEcAUIGJ1sjIaywlM=;
 b=5jANi6AfdRnmE5rIq/mTkfSL7yH2T3Llwg3/kEVooul/C19QcFXlCGEQ4cNggtpiizn+bEkb6vocoKI/Ir/myZ3Wg8K2BxfY8jNKhAAu7q/yQRq239brCF2DSvjwuvWUsAe5IBuB+7XtvdtWresxhYgeWJA1bZryCtiygASyYkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CH1PR12MB9695.namprd12.prod.outlook.com (2603:10b6:610:2af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 21:53:30 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 21:53:30 +0000
Message-ID: <48f11469-6435-4f3c-ab67-705ad730b042@amd.com>
Date: Wed, 25 Mar 2026 16:53:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: Andrew Cooper <andrew.cooper3@citrix.com>, dave.hansen@intel.com
Cc: KPrateek.Nayak@amd.com, Michael.Roth@amd.com, Nathan.Fontenot@amd.com,
 Tycho.Andersen@amd.com, aik@amd.com, ardb@kernel.org, babu.moger@amd.com,
 bp@alien8.de, darwi@linutronix.de, dave.hansen@linux.intel.com,
 davem@davemloft.net, dyoung@redhat.com, herbert@gondor.apana.org.au,
 hpa@zytor.com, jackyli@google.com, jacobhxu@google.com, john.allen@amd.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, nikunj@amd.com, pawan.kumar.gupta@linux.intel.com,
 pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com,
 rientjes@google.com, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, xin@zytor.com
References: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
 <4ec520a1-68c7-4833-9e8f-edc610e5fdfa@citrix.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <4ec520a1-68c7-4833-9e8f-edc610e5fdfa@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::36) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CH1PR12MB9695:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff0c71b-031b-4440-91d6-08de8ab8f3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FRwAY5JHG5elRd/Uct6mPmv2nxu9HfwgqdPXFulCt9B3NmJeKKaU7baAzaLab0k6RP1gA9+MGOSe/b7jqrJ25Mcc1rb3+PlAtjZIgqHmrzbvHEMW/9aLMLHVGI+tWH6YsAiuHdbscq1Gar9wq19KitdC77RP3sqblYdr0x332ihpq2C5xAtVQE4qENOUGLxXlgE4Q+sdAdF/2uOnKn65w/TJ24O7kwphr2Tkv973AzjGa3OVr8vdFS+jdFMM1LYKD9LHTaqC6oZnYM2Uoq7UdpjCjVjioIdFQmjmvwn+vDx8S4cdHWvHbvMRI04sKBhfMF3+Q7nvb9SyYOrAbYhb7qbXdygFgE7R47J0fLnBbK/eOTqz1mOh9S952s5Ol3npIaD4uB1LG9bnJ7paT+a7LEH+xXMIsqDj3+2zMEB0S4ZAPMQty9E3L+fNiauTfiJv1HBPjHgfZenJZ9tyDTe2V+FQ7UdsfgiHeiNEKM6r89Ajd0uNxh1aMgCPrXTNb0eDQvlT+q6h9twuwtVhXmCZGt3OGeeRzGn+fq8KYLXIQS+jAR03eOMItsFdhR4uA+3pcCG4zMpnB17iB6PJw0Jrw8Xvgso/K8KPbj1sK4W9QZwcaHEsIKHxkf+HxUXgLQaLzK8+LHhWqsmvG1FHWBA5rCso53jrWTNvaBKvv/dJ5Met2/HUAoyChBtT2NVT0V4/Ra700HSPHes6banlK6rdlX5qlaBf+1v66rEhAgOrNP4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkNhUjdSQlAySTV2eGFIZHJhaHA3RlE1a0RDTTlyOTZxZ1YwbUFZVGhMZnJn?=
 =?utf-8?B?c0drWFpWWkd0bjRuTU16cjFvcklxclMvMkd6N0dleVJoQTYxRW5ZN1RYMXVV?=
 =?utf-8?B?ZFJJWFlUeGlqZHROSVBWMjlXOW9LNjVjenB6RXNMdTZWNmlpVjdpS3lhU3Zv?=
 =?utf-8?B?aksvUlM2dnRJd0JMbVFza2ZyMWo5ZDEyZGl0VzZQaldCcE95Z0Vjby9YbC95?=
 =?utf-8?B?WnRMZDM1Ti9GTmkyQWR1YUc3Tks4ZE02dFZVV3FDMytDQXRHZTRJcER0UjdI?=
 =?utf-8?B?ZzJwZ3ZSZG12cnNrZmNoTFd4YTk5Wk5sU3VnQjdvWUdxNTBoMjJOa0FQQ0RD?=
 =?utf-8?B?UlFlN3k1Zm5LSXg4bmExUm9BVXlMRHVxdEdYa2p6NUxiQzhBNWp5WHRpY3ZY?=
 =?utf-8?B?YjB1K1BNS3NMbHVlY0Y2NTNwUm9sRDVUZ3RxRWptU2V4QzNrWTBGQmVxQk1o?=
 =?utf-8?B?NitXSndyUHduSStVek45alNBN00wN3Rwdm1rS3U0SG9BTDhLSDJEQmNUSWs0?=
 =?utf-8?B?S1VQd1hESWJUbmpoSkU3RG5scFV2YThOc1QyWGI0WEh5OVFKUDB2WVJaU3l2?=
 =?utf-8?B?MERIVzl5RzNpbnFDcHpmTGd6WFRZVm5hUVJINzZBMXBmaG9BbFpwTjhRMDRP?=
 =?utf-8?B?SlVrTWJMZ2VaV0FaWHk1MjMxQVF1RjY2VHpnMXg2WUp5T2t1NFB1WlVYVmNM?=
 =?utf-8?B?V0ZETGpHZ1pYemlUTGtMQVdGaEE0SHlTM1dDWG9kTWtYbjRyZXdEWVdCUnlJ?=
 =?utf-8?B?M3ZTUlRPK2oyQmV5MVZ3RldyeXZXWFM3bVB3R2ZLN3MxTEVHRjlEUnlPRGkr?=
 =?utf-8?B?bGgrOWNSam9kZEVyY1dVcFNPV0tEZHA3aVNzQzdHRm9QR2hIWWpMV1AxMVhu?=
 =?utf-8?B?c2R1Y1piUjVXZVFBSk0rY0Q0OXo1YVB4WVorbGROVmFFcEtaZWVvdkdDU3ZD?=
 =?utf-8?B?K0JCQkVtTjNpbTNDWXZtMHFvYWRCRVVSRCs3ZTlyZy9HR3d3MzBXa1Q5Yk5u?=
 =?utf-8?B?VUhSRDhhLzM1VEE2NG5MZFRRdlR6ZlFuOUN1M2RGYjZ5Y2VxdHJSYWg3bHpE?=
 =?utf-8?B?czdIT0RtSEJJUEo5SGx1N0xmQ1c1Y2F4QldWd3lKMW5LQ2VSS2hsQkhCTkF3?=
 =?utf-8?B?L2hITGZ4cGFidVhRUGQxaE4yVFVGSDlEaDFkcmt3V09BMmdYR05FMU96c3JG?=
 =?utf-8?B?d2lhSTVRTW1HMTFScUV0bWxJNC9VTkZIbEZSRGRzT2V0RDRRNkZWN3N0a0VX?=
 =?utf-8?B?Zm9NM0YrVEp4NjdraUlSY09RZlgxaER3SldhNzZQL1hwc1JvcS8vbGFOVWdu?=
 =?utf-8?B?bGxQZWNzZVRlbng5UnNBYVBHOXBKSHFvT25rYUtNSmlEY3NlZmlpZDE3UjFi?=
 =?utf-8?B?RktxSytVNENUSGhjb1ZCNjNUcEZjUWlUanBqZ2ZIVEJSN1hFTjBMYitseHhy?=
 =?utf-8?B?N0U0clUxcWZoSUJkZEFhRXlmdmhLZ3pwL2NNSWZoNWE2YVhOL0plRzNJODFn?=
 =?utf-8?B?aXZuTm9pck1zOWU4ODFPM2pEejRpZEdBRHVwdkQvWkR1YkVVTUh6MDhZZXR1?=
 =?utf-8?B?L1pZcDFmU0ZSMXorSVg3MVplTHRTdGNaTkI1MUZrVmJ3VE9oanBKSnIzUkdM?=
 =?utf-8?B?cHN6U2ExUnBicXJZWWJQVUtPNitBMUlaZ0w2WHkzci8zaGhidEtXUTVjWjcr?=
 =?utf-8?B?L2VpS3VYZEZBbG52ekNkdHRtN0Yxa1dMN24wc0w1Q0ZKU0F3eVdabTNoTzBB?=
 =?utf-8?B?aHNhZGNhMlR3eWxIZGY0cm45WnI1RTF3VXlwMndpT3ZxSXNBeWtyTDFESGVq?=
 =?utf-8?B?akt3V1VZaUxsTGgxMFhRYURlS2VrcmtMTm8xb2Y2RFNQeHUvQXpXM3RMSUR2?=
 =?utf-8?B?eE16RkUydCtQR05rOUtwQkswWjFFdW1tSjRsekN0dllVeUxEYk9LRUh5NWlP?=
 =?utf-8?B?THFpcTU0TVpzMGRyMlpma0hEZDh1S0pEUVgxWjAyQTVJZllibjNHandEWnJV?=
 =?utf-8?B?bUUzaWdodG1HWEN6bjA1dmE2S0JzT1hBaCtOYVExQlYwbDlOeGZCeVFFcXUw?=
 =?utf-8?B?V3NzdTVJVkhFY2d6VDNqZU53NHVDcWQwbTVUemFYTklNM0tDWGx3UXFETHcx?=
 =?utf-8?B?TGxiTFlBNytXSmVOZlJ1VjM5V2VNaDBsbUtuWlllWUppOUtXd2dSRm5objFV?=
 =?utf-8?B?QlhGT05wRlgvS1BOM25DK2VMVlJWajdWaUpFUEJlU3BNNU5ocEJUbDVNT3Bz?=
 =?utf-8?B?MnRHeURDU3FKb2pLKzI5MnRVTnhRTTB1dWN2NWxlSlE0M1ZscG80cWtCTGlr?=
 =?utf-8?B?eC9BVFRXUVBVd2lEdHRmaUZHUjJpQjdvaWxiTndBK2dJS0VRM1FGQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff0c71b-031b-4440-91d6-08de8ab8f3e9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 21:53:30.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmnkp7vYnEceJwXb2WAQF294T1KE5ZS6rjRBDspZShdLknARMPXO+h/7yK069kmVxJcXihwvNhHk2Z6QE9rSAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9695


On 3/4/2026 9:56 AM, Andrew Cooper wrote:
>>> +/* + * 'val' is a system physical address aligned to 1GB OR'ed with
>>> + * a function selection. Currently supported functions are 0 + *
>>> (verify and report status) and 1 (report status). + */ +static void
>>> rmpopt(void *val) +{ + asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc" +
>>> : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1) + : "memory",
>>> "cc"); +}
>> Doesn't this belong in:
>>
>> arch/x86/include/asm/special_insns.h
>>
>> Also, it's not reporting *any* status here, right? So why even talk
>> about it if the kernel isn't doing any status checks? It just makes it
>> more confusing.
> 
> The "c" (val & 0x1) constraint encodes whether this is a query or a
> mutation, but both forms produce an answer via the carry flag.
> 
> Because it's void, it's a useless helper, and the overloading via one
> parameter makes specifically poor code generation.

RMPOPT instructions for a given 1 GB page can be executed concurrently across CPUs,
reducing the overall penalty of enabling the optimization, hence we use 
on_each_cpu_mask() to execute RMPOPT instructions in parallel.

Now, the issue with that is the callback function to run on_each_cpu_mask() is of the type: 
(typedef void (*smp_call_func_t)(void *info)).

Hence, the rmpopt() function here has return "void" type and additionally takes "void *"
as parameter.

> 
> It should be:
> 
> static inline bool __rmpopt(unsigned long addr, unsigned int fn)
> {
>     bool res;
> 
>     asm volatile (".byte 0xf2, 0x0f, 0x01, 0xfc"
>                  : "=ccc" (res)
>                  : "a" (addr), "c" (fn));
> 
>     return res;
> }
>

The above constraints to use on_each_cpu_mask() is forcing the use of:

void rmpopt(void *val)

Thanks,
Ashish
 
> with:
> 
>     static inline bool rmpopt_query(unsigned long addr)
>     static inline bool rmpopt_set(unsigned long addr)
> 
> built on top.
> 
> Logic asking hardware to optimise a 1G region because of no guest memory
> should at least WARN() if hardware comes back and says "well hang on now..."
> 
> The memory barrier isn't necessary and hinders the optimiser.
> 
> ~Andrew
