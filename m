Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D5A28726E;
	Tue, 23 Jun 2026 19:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782242155; cv=fail; b=au8IrkSQ087y3RFZVeLTEkk+DiYBi2pjM6jUppI4Ihl+nZeIncP8ATxSe5fYKYw/w3eZeDIJ9JrJ57fB2sYasfUUcHd5yN98KnXMoIlbMO0t4YqpBlUp0ylfdeZ4KIwvPRU8JHpM//m4BoanCQIss5cBqs1oqzyzwKNmRV4nGBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782242155; c=relaxed/simple;
	bh=UQyyMPNJ0Zpsd/rsN4XUT4sZy1/McOr5OLYGnZtK9lI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CLJi9VYa5MJG2ZK9JHPkjexjunetZvO3FP26hXPM6tKs1/TYdq5geiKpJKdZ/Xm23GAMSLeeYHrmP89Iyt9qGCEemaAyVVlKw/PYS97YjIW9v8J6a/syL7wJwnVCRWgz4VZHQFrtx9CuZfGZsF0wnGzmXg5pGpolxpXoDo5+WQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zgzoo/KE; arc=fail smtp.client-ip=52.101.62.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zgzoo/KE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OiKU8lJuP45v3gPniI+gH/LcLLfIGNlIRSwIYYeXe+qkBg3HNy5++uHUFnVX00jL5NyrqMMO+niQiS3bCBfQhir3TSJEFkcT/2Rx7wJ4pZh1BFH1gXkhS6suHZibJO2KupMtdR/9PwzD34+WvUn7T4Nledr8R17ZlIsRaeyyDm7s7e21NQyGVNL7iCdREDe6xWZ5Gt8lKRhPp9lis0HGvUfdzWAIsLbM5vULUBozuTC8CHH3YKzSb8VTLodVNVQnxD8m551WYdLcBfYzDhyfNVUWJYjNyLqdCaiykag9K0EVUVok4Yu3x5Mzr3tchyOh0pVY1tSypMdd0Co7mQh/UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETgMD5YgQY/TiTNqnjcWQRVSkulxu8b73IKyFkWXix0=;
 b=GILIsPJ63r/1oLqOX4oqjUuoiTHE5tPhm0xEWfZEUOrMvd0sQYDMCyUHELZbySfWq9jik5b090ckqtQ89/1iNyxXd6GuGINNutKzvy/JYYtL7gkeoGSPjMBe/E1JzrzSmyvfodIHv8MS4elh0O77E/ygUJVpcPBejq46bjYJ+qeNHB/Ah31s6awyNBdr4PBSSAe3SLzk7Igu+vFTfIO+wpSMnEaZ6swduFE95iBxdQoel31MghsuQohpvMaf0JhCW6NhkLvjfxY3bVuUtsIy73EFpH5fzvMk9DI4VDzugEo6pn+cmjPf4qPMin6UXru+KFgZ07IvT6DHhgHNK7KG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETgMD5YgQY/TiTNqnjcWQRVSkulxu8b73IKyFkWXix0=;
 b=zgzoo/KEG6pjOvWHWhAkzJxKIODdvK2TU1VKPwAj7L6NBb0OeZ41f6thrYrAmtI4C8/93X3cHTUqwN/N7OUnmM+03K8gsFot+BZvPhUxWQTSB6tfvh7krF1VNY2xlDH+2JAKESwBLi3tfk8SWTwrjRAB110/BmTpmt4VhnCTFl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA0PR12MB8205.namprd12.prod.outlook.com (2603:10b6:208:400::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Tue, 23 Jun
 2026 19:15:48 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Tue, 23 Jun 2026
 19:15:48 +0000
Message-ID: <8e4af4f3-da52-40a0-9916-072952551295@amd.com>
Date: Tue, 23 Jun 2026 14:15:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Ackerley Tng <ackerleytng@google.com>,
 Jethro Beekman <jethro@fortanix.com>, tglx@kernel.org, mingo@redhat.com,
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
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com>
 <CAEvNRgHDNGCETxLsy0v-_cBO1=1U+tXtOXWEFrXLU7pYz7U9ow@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <CAEvNRgHDNGCETxLsy0v-_cBO1=1U+tXtOXWEFrXLU7pYz7U9ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:806:21::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA0PR12MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: ef470413-a6c3-4541-d008-08ded15bd4d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|5023799004|11063799006|4143699003|3023799007|6133799003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+RFwluUu7lsI4rHmLNGksg5/lFaW7wdpCUlEZnZ+qPgKeLMQvO+mnh9ZDFIywCIXftBieQyWx+vyyllD2r5Sb5caRG84SXw1UmAJZGmhVcS75C+tALEbmQCmDQJOCf7ukPuzDvZ2Ubqx5Cx6lwxrPqJmdpfZGuCZB+g4chooMYCS6aBSRoJjO6ory3V2ZnHD+NB6EkqWrhBqkLfqfXlaCmWJ0NwI6dOtIFliv33RVFdqwk6uyj3UFfnxxAPl16pypsPtsUciSvEfg9+jtn+Ey+iRB1i63jFz+IcDW1Wj9eJv8pSUewBqRETjvsn/ax+SBZ3sAXJg5blMHSzeE77aLx9D4Gg0C9X8agj3HXsJQegMVJOCssLKNTFxm0SwGz07Rd84FEkEyF2f2p1aY268nhl1CearX8CfCsVR/VHTU+ksQT3xtWKPz81im3OjaeNSuQMLAa1aBaFVSHYP5rFwLL7Q1w3FmUK9pYl85tD0iOmXbGEII2hiO61p3ZQMx8jRG3B6izNvVb/MQMUdHl/A7AaW/F1yufHVgwja64kWhj7eJFCv8WzSeh0B4lZCoTGt2Qahqeh7o14ir8QV5YhRavvgudgw1DQiQhMrP0IlTM214wW9s5ZCPyv1v30R+TGHDD948gPgFnqy45qD2BSrw5ezfEzVGqu+hOPlVCiJMZ5KUCz+t3p/KVrJ1IQB9MYZ/bBoCXD/R2RtH01am1j2qQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(5023799004)(11063799006)(4143699003)(3023799007)(6133799003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnFUV2IvaFc2aEh5aEFmMjZ6QU0zSTVKNWx2N05YbDBhVUl5MnphQTloQmdT?=
 =?utf-8?B?VUNvakRsTDcrcmJnK3hYVE1hZUVZa0kvbXNSRUk2d0NsV1MyM0dodjg5dnh0?=
 =?utf-8?B?a0tUeHozUjFYQmZ1UzdwbjVxZVhXVmlaQTJHV2pTOGw0RTlIY09VK2ZtVzVI?=
 =?utf-8?B?RmV0Zi82S2JLSkViWUhEU2Y3ZlhLVS8zLzN1ZjkvQ1JpK3ZSUndFclA5YmMr?=
 =?utf-8?B?K0RqWXBBc1MzUXBCZnhmaXplYXpxUElpVWZKNFExUXlNQy9hU1I3TFh4d3hN?=
 =?utf-8?B?Z2xUM1VmU2hFeGxoZ2JYdWVjbGttRjlDNXlLbzFLaTdKbU4rYzg0R3VMU25M?=
 =?utf-8?B?Y0NBVlVXREdKdnJ5WVZ5Q2crTTZDanlYekFoalAwU3ZrdlU1UG90Vk9BQmhj?=
 =?utf-8?B?a1FGZFpaNFQ2NEovZkNMa2xyQTFsSEJNS3ZRUSs0YUIwSWlmN3N0ZlFaeUdv?=
 =?utf-8?B?UHAxbGJ6eTlXc3dIOUk3WEYrQzRLNjV0TjJXY0xQaFRZbUlBS1NiaU5ZZ2ZO?=
 =?utf-8?B?U2NiTFJsYmJlSDIrdU8rUWl4Zm9oU2toTk5KSkp0dWJWR1JjbEVkbld4SjJp?=
 =?utf-8?B?bW9VT0FodmhKV3FTVHBzUmVtTk5IL0hjZ1lzMW1WbzdVRXErSjlBUXI3Nkox?=
 =?utf-8?B?cW80c1BTK0RxaHJod3Awb1NqWTlLbnNEcDZiWFdQaXFGaC84NHVJR08wckpF?=
 =?utf-8?B?aWtqbytFaGJyd1prUjMyaHFxVDF6N1Axc25VS1dPNlRyUkYyMzhhc3ppWkta?=
 =?utf-8?B?ZysySndTaGxKUVpKdjZUMEZvN1ppVC9nc1FTdTFYV0FDbmNFRmw5d01aV2VR?=
 =?utf-8?B?c0VNSmJjNXpHazRsNHdxYWFJbk1aWnRUUUF0MTBRRk5iNmxjeTllaUIzOHdh?=
 =?utf-8?B?N3FLZHNnOEdTTWdsZzUycWlhWFdxVmdWdlpQU2ZrUzZzYzlaRkpMVGEwcndo?=
 =?utf-8?B?T1Z1VlNSUFlQU1dPUTRMaXQrbWR0VzRiR0tRSEhhYVkyb0RCVnUwMUVIK1JS?=
 =?utf-8?B?aWE5STNJTENRaTMvWk91Y1g0NWYxOVFBZll0K3o0KzZDMmlIMWJtdit0anlV?=
 =?utf-8?B?VGVlOThnOUx2R1ZVWE9SV3liNUpZNFBOaUVPSjR2ay9uK2dVUG8vYzFPZ1dV?=
 =?utf-8?B?cHZkajRKWU9EZXFMbmlta01WYjBFS3dKSTBBMWErQi9TcjNVWVNNaUM4YzNU?=
 =?utf-8?B?MlhsUnYzUXNheTJiVGtxNjdlMG4rdXI1cThvbVl3RWc4UHFPdUNReDlaWGJz?=
 =?utf-8?B?VEJFcUgzYzM1bkdhS2ZGSnNMN0FoVDFpejhvQmJyc0E1YzBmTmtWVG1hclpT?=
 =?utf-8?B?a2o0R3FQY3IxZ1U2VkxhU001MnF4VitlQkxYN2dnUGlBcDMwSDF4ODZDNmhq?=
 =?utf-8?B?MUZmYW1RM1NYbEdZVDZBd2UxSC9CT2IvOUI1MnhtSDNTZ2JpMUw1ZCtvamtw?=
 =?utf-8?B?NHpRditOejd2dXFEaXdtRm4wR2UrakZLa0Y4Y3pLaG1FaHNEM3lFNldESU1Z?=
 =?utf-8?B?L1hvSzFQcnN1WFVKYVFxalBXMk1qV2pWOFJ4TTF2d3NXdU1zcnAxSzFlcTFs?=
 =?utf-8?B?eFZDU3A5YnovVlFEUzZIV0FLa1ZrYUpkQkFqNlN5UC8yUE0yUXRrMFloUnlt?=
 =?utf-8?B?ZjhJV29vYVJ4TTAvSElUbWQ4S2JUbDYrWEtzbXQ1b0hYb2pyM1QrVlVxRnMv?=
 =?utf-8?B?V0E3WHRYeVRrNUhQMGlPSXlVNE1MdEduQlJIVmVLOEFkUGhGbzNMYWxtMTUy?=
 =?utf-8?B?VnhYQzU4Nmhoa3UvbVdaQ0VpNURCV0tzK1I2em4rMWV5WXM1MFF4ZjdiUHZP?=
 =?utf-8?B?eDk4ZG1vK1Y3T2tjT3JoUFJtelJlUXZRbzRIZDhURWVFbGxHYnV2eWdNbGFV?=
 =?utf-8?B?cWQ0ODFmajVVLzFoZWF0ODN3Umd4RWlxa2wzVm45RkZIMDBtbnJOenA3aTZw?=
 =?utf-8?B?T0s4MzAxSVlteDRUTlJNOCtWdGYxMTZuNkFTQnEyVGFCZ09nS2tXYjNkYzI2?=
 =?utf-8?B?K1RrcWMrbEIwNlorVG1PZzhBNmVCVkhZMUtkdTVMSFJiUzdKdGU0aHRCYm1K?=
 =?utf-8?B?ZDlqOEVjQ25HM0JtMml3Ynd5MEl4dHh1TTlqamhwMDQzbnFLaTVWb25VUnpX?=
 =?utf-8?B?Nm5yMlhDalhBWk43cmhicE5wRUFUQ1JGdUVSbG9uN2UyaE9qOTczVi9Wa0tr?=
 =?utf-8?B?cWE3SCtDYXViR21Td0JXRDM4UnFqYlhMZTVYRVBFM0dPN21zK3EwTEs5UjNo?=
 =?utf-8?B?RGNUU0ZzVUtzUVF4MG5PRDRnY3QzOGs4eE9KcU5wWmhWc0lDN0cyQ0Q1UXQw?=
 =?utf-8?Q?/cwlKBxNeTRM4AELtt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef470413-a6c3-4541-d008-08ded15bd4d5
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 19:15:47.8604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPpNsRH8FPyrVMSdddOs17LsGN/LABxC4h9dv5navecm5fw4+6TP1kXDnX+RFRQWA42mv5+HoIWbpPCMhEc2Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8205

Hello Ackerley,

On 6/23/2026 12:48 PM, Ackerley Tng wrote:
> Jethro Beekman <jethro@fortanix.com> writes:
> 
>> On 2026-06-15 21:49, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> The SEV firmware enumerates the CPUs at SNP initialization and is not
>>> aware of the OS bringing CPUs online or offline afterwards, so OS CPU
>>> hotplug can diverge from the firmware's expectations and break SNP.
>>> Disable CPU hotplug while SNP is active.
>>
>> I think this is too broad. If I have a hypervisor that supports SNP virtualization, a (non-confidential) L1 guest running Linux should still support CPU hotplug while also running confidential L2 guests.
>>
>> --
>> Jethro Beekman | CTO | Fortanix
>>
> 
> Were any other solutions considered other than disabling CPU hotplug?
> 
> Is this temporary until something else is implemented?
> 
> I'm not sure how commonly CPU hotplug is used, and if people are okay
> with trading in CPU hotplug to get SNP.
> 
> Is it that fundamentally the SEV firmware can't support hotplug, so
> there's no point in keeping it enabled anyway?

Yes, essentially. The SEV firmware knows nothing about when the OS takes CPUs online or offline. At SNP_INIT it accounts for all
the CPUs enabled via the BIOS/UEFI and establishes the per-core SNP state for them; it has no notion of the OS bringing CPUs up or
down afterwards. So OS hotplug actions can diverge from the firmware's expectations and break SNP. Disabling hotplug just makes
that constraint explicit — there's nothing useful to keep it enabled for:  a hot-removed core still "exists" as far as
the firmware and the per-core RMP/RMPOPT state are concerned, and a core brought online later was never set up for SNP.

> 
> Is there some way of supporting hotplug for CPUs that won't be used with
> SNP, for serving non-SNP VMs on the same host as SNP VMs, or is that too
> complicated?
>

Not really. SNP's memory-integrity guarantee rests on a single invariant: every memory write is subject to RMP checks to protect
against corruption of SEV-SNP guest memory. The moment any CPU can issue writes that aren't RMP-checked, that protection is
broken for the whole system — it's not something that can be confined to "that one core."

That's because SNP isn't per-core in that sense — it's a system-wide mode. SYSCFG[SNP_EN] is set on every core, the RMP covers all
of physical memory, and once SNP is enabled every memory write is subject to RMP checks on every core. A non-SNP guest sharing the
host still runs on cores that are part of the SNP-enabled system.

By the SNP architecture there simply can't be a CPU that isn't doing RMP checks while SNP is active, so SNP_EN has to be enforced
on every core. RMP enforcement is gated per-core by SYSCFG[SNP_EN] and it must be set on every core before SNP_INIT; a core with
SNP_EN clear performs no RMP checks at all, which the architecture doesn't allow once SNP is up. A newly hotplugged CPU comes up
without SNP_EN (SNP not enabled on it), and since it wasn't present when SNP_INIT ran it isn't part of the initialized SNP
configuration either — so it does no RMP checking. And because an SNP guest's vCPUs (or any guest for that matter) can be scheduled
on any online CPU, the guest could end up running on that core, accessing memory with no RMP enforcement and breaking SNP's memory integrity. 
There's no way to prevent that: KVM doesn't fence SNP guests (or any guests for that matter) off particular online cores.
And carving out cores for non-SNP-only use isn't possible by the architecture: SNP requires RMP checks on every CPU, so there's no valid
configuration with SNP active and a subset of cores exempt.

Thanks,
Ashish

 
>>>
>>> [...snip...]
>>>
