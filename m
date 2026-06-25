Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B447319ADA4;
	Thu, 25 Jun 2026 05:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782365926; cv=fail; b=MezAM5f1N+mxZZgxX2M0Yr6rY2OpGGmTJYvMLJLSqmWiJMq+4vk2dNNHQTqU5kKFq9gKzVGxhcKkCd3yxQqYw2IRdOqdnocv++a/UfEzNovS/9PhIjEHTHCs8txSRgy6K3+dEQ896lFQP8aJne+9sgJKsZgRxWRWZWWnzKwsyqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782365926; c=relaxed/simple;
	bh=SCRUgaxEbVMAquzh+uKbdu6KvsgpXLVUaNkvUmMScQs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bvzelA+chMoBzp93vtOoJrIvlGKmxKPVEWchSXsrGWTzp2+GWOe8jM0uUxkklZr+aly0HNeJiTL6cu8tDEU6JolmDSd9S581osYUcnhw6Hg9eUHL4WacAIWxSYvd3/CVqhgZdu3CYFJ7acTQ28eGqH/47c4+5r3LV453UMxb9TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z7Dln54o; arc=fail smtp.client-ip=52.101.62.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z7Dln54o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FmCeoL4I2mzUSWx2tnpDeHQ+IoCPIVnEwO/XD/vDYaeWTE02xoOadOlBwuHsw+HnA3FihpzKrbV0HTDT83O0cemQC2/u/08bOipq1KjHic7wN3IAcQexHQvRO0DkDom4svWrfPI3hKFQpVEovfOqiXoSYul5pFujAMCQX56jRa6hGffDRK7mBhTB6Y3fm+nj1BYT3DJUB/v6K5stjN7SdD9Ix9/8Wg81GH3VDXvMJkGChnZsYurkiv4RXhZHSk/LKpZECD1E0mRGPbKBiNLpfvoBJMWgIy3f4IDrNToG+41DgitwAeic8VQSSILsQEThfElNSe/Np096g98ve4e5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVh3NC/D7Kn29MlhwGkIN4FN0sO1XYKbJD1eOwJdTLk=;
 b=hHP4KTCYTGrdQs8UYwrMuyB968egg7sTn0NWpSpdFj3QuumnccJB34DnwisUer5V6WgfgF4GvnQqTE+UyIEsetbebqZKPNh3D+0rCMTykV5o4KUjWQ/IjQTKAKz6iNk2x9WU0HqVZKmRsreHYBdscHSVEyFAYCzXjPhhInr6FciE69m0UOOqdA6N2k9idGYSlZCMn3BR1Pe8l5HSX9fKHGafewiut2YDMCDfOwEctfOtn6xgORvgID7e5pAlxmPWUctMsB4o7QN2gpBnkhWMdyuxh1KOHY8HxYtOonYY43qeTgjfH7tf+xT2MQiO13woPWkQbIL3TGw+243EugK6kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVh3NC/D7Kn29MlhwGkIN4FN0sO1XYKbJD1eOwJdTLk=;
 b=Z7Dln54ofBe12o/sT+oQcmIGCXPV4UJszIRiEcl1jcMgFFCjdwpRs2q1avi0E5ZZrgOMsG+ptRUF6CC/L2lF5w1nmn4kEWNi8gdOgN18EMrCZ9lyZxO0o9hkju2x/e0lyNOnj3jtaLtL0MX9UKV0D7RQoykkiTO86rFbneeTmMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB7018.namprd12.prod.outlook.com (2603:10b6:510:1b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 05:38:40 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Thu, 25 Jun 2026
 05:38:40 +0000
Message-ID: <94d5e5d7-a27e-41a8-9729-81cd55d399bf@amd.com>
Date: Thu, 25 Jun 2026 00:38:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <fe9927ad-a06a-4a4b-8122-12644513ed14@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <fe9927ad-a06a-4a4b-8122-12644513ed14@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:610:4c::12) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB7018:EE_
X-MS-Office365-Filtering-Correlation-Id: fe74dbdb-b388-4847-9eaf-08ded27c02e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|921020|56012099006|3023799007|6133799003|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	zMxzrwO5VUBMk4GwZ0a7DzWr6qehVaZGu9r4/qxJYEuH5r2ojyi+Oq7qTBouvVldc6XSdCi0SMUkSSyREsKEm7yLiRx7dd0yb01IEopmp38flcvkTWB60z4nuN2PqSLpdxnqR5spAog3ZSQENOzAl2gI7TBipL11B0GEubjavN0OjHJsHtcDGL26conTtCFB6mNt/7Gj2aQjV6G92aWh8bX09LmD1L1gaLVn2DmfYpMHjd2JXksNq5c2Si6vmw2KLEyDXfzBrti757mGnBBEy+I5cgmz0daMZwYy1MjwTkhyhBjXXNiapO83WvLImCcGvGK/I6xrTQUVPcgA5oMUFedoqDO/pak2G3SNgZ7h4bThVt+Omf+jeG0B5YqnpuOST5kT0R/SMmsq+EyS7di5VwsFQhF6NbEG388hdvTHSnAQL1Frc1ZbnTBqAKvLi2Pvyaf3+isuSwXmZ+sKlZ8YaAsQBll+invogJFLxrtCasFZ3AFRqgicimffEQvsAzsy1F3opHr7jQlTLGnU6QAu8QtU+/TPVyHpL2MexLlFmUTLbSpoUPsEHTiVm2WTdCAE7Hs1yxr3lge9b15p3HIVKUQp+B0hlo59bjKMk93U03t7ODBylW4F91sZvLHHSJwETFgStFupeYOVs+zThvlhRiqkJmfcthjLTIkiWU/nsoztbALWRLR2qSpSkRmxdBZoYHXiNpWrFAnqKrZxHxDPCA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(921020)(56012099006)(3023799007)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUMySnlQUmZyOEFPSzhjWC94UUU3M1JBMGVoZ3hZZ0RCclZGbUtEK0w1eWp2?=
 =?utf-8?B?aytCcTZYZWhZL0NaQmlKclNVVGE4TEZCMXErWUxwU1ZRMXpmUDAwcGllTDZl?=
 =?utf-8?B?eFkrVG1UeWNPMjFldGxsRmZjRmNjMWh4Y2R0VkFtOGlCNXQzdjBrOWZqZnBv?=
 =?utf-8?B?SklkNDJ0V3VlZHVZVm16c2p3WXVCNE9mSkJ1cmRKQ29iNFlYVjJFWTJNTkY1?=
 =?utf-8?B?Nkk5ZUR1TWNSZVJybHQ0Y1MvK2NYMy9Hb29NcS9CaFZqVm5RYTBDL1g1eXJi?=
 =?utf-8?B?SDZqSFFHU25XOTdCSDZsdTRUUUd6SzJCOHBGRWc0ZnZrUG4vdlpZY3IzeVFi?=
 =?utf-8?B?bUU1WnBjMjJzcnhiS0lXbEpxb2pPeU1JZWVramFNc0JVdy95T1paTm0wbGxS?=
 =?utf-8?B?RnlOMEhvQi9uYmk5M24wdFR0T1dWczd6ZUphRlFJbzBwUjVvUjR2djd1elJJ?=
 =?utf-8?B?WjNqcWN2NUF4c1E5VVdlQ2E1RHhEeHRnOTBqZkh0bGVkYks3MDlqMVN3ZmRv?=
 =?utf-8?B?K1diRWNPTXVTd0RJbytYMk1yV2F2VGZSR1d2ckx1NHNOOENNV1JTcG1FTmE0?=
 =?utf-8?B?VmpxbjBGcWxBRElRQk9VOUF2aGVSblJiaXloVVRlaXVLR0lYVms3cDNHMVZl?=
 =?utf-8?B?MlJ2Skl2cmNDOTdPcDZQS3hVVXE1Q0FGVmhqTm9hbGJMMkV0aXBleUhRd00x?=
 =?utf-8?B?MEczL09jOXo3WGVUUHpUT0YxQWEwSUQ2SGUya3B6WFl1MG4zUml2cEV1SU04?=
 =?utf-8?B?U2p1ZXlnaG1DRUhLcGhOakdHU3F4dkU3Q1lONEY4c1NmUW5EL2luV004cDdq?=
 =?utf-8?B?ZWk5VW05QVhWUVp0ZUl3aGN3blBIVHBQenFZL1Bpd3RZVmttRGdUWkozZTU1?=
 =?utf-8?B?c1NKVlpweHJOdXZRN2NMdkhmUXh4a1VIMlhzdzRXSGNKSHU4Y1E4TmFSUkdU?=
 =?utf-8?B?KzlqWVA3cjNsTDl0TFNxSHArYm5EcmF6TW82UzYyQ2tMZ2xReHQrT0h1WmhH?=
 =?utf-8?B?YWRrQWZsVzU2akgxWDg5dDZFSUFXT2FhcUNBNGlRbHczdHJxY1lBTnBaMEw4?=
 =?utf-8?B?QmF6aFBWaVN1UGdsRnJ2QmxkNWFqSHIyWERza24vT0ovRWZIZ1FwL0J3SmxJ?=
 =?utf-8?B?U0ljSGVtUDZQaVE3M2RtelNNN0xrSXA3NTBLc2M1a1IvWTNDSUhNWTJIVTd4?=
 =?utf-8?B?b2xBaU5OSFNFdmxnT3VRK250MVNZdnFVMVNoRUNFbm43UzBQdm4rNmFEeVdX?=
 =?utf-8?B?OWVoOXZuZlR5UzVTNzl0QU5EeFFmQUgwdDBEL1RKWkNvZ2d0d2I5dE1nSmxi?=
 =?utf-8?B?OFA4K3phTzhYbFVPWmh3cDU1N3pRdUJXUnJNQmJJSVBSQzdsYklJTVhZVS9X?=
 =?utf-8?B?WkRBUExHbDNRRlBZUFV6djJ5OVZBRHdmZERmYTI3Y2hxTlR4eG5GckJhbUI2?=
 =?utf-8?B?S200WC9KSDZuVkFZOUYyU1dEd04yem5JbndoR0VPb3NCcVQ1RmlPZkxQYXVU?=
 =?utf-8?B?YkZsdVJVTlVoWkJ4NmpYVCtFekNTU1JBSEV1QUJVQThyS2M5NUN4ZUZwRzh6?=
 =?utf-8?B?c2F5NEx5UXVsVU1JVjNpQ2txRlljaUttR1MwQlhUZVRCYVdyb0hEdzBrUmFE?=
 =?utf-8?B?UC9GQzBRSk15QjRUY3ArWEJCdE5rZDE5TDEzUlp4c1hwNXUvblpSZkEwVHp1?=
 =?utf-8?B?VW5iQjZoZThLMmdUQXRjQ2l1TVlUdkZUYzVDL2liVGNRT2JiUkM3WnlUL05E?=
 =?utf-8?B?MGFjMjNpL01ySEQvY3V6b2E4b1d6UGZRNm8wTFV5TzRmYzNuNHVrazZCTWdN?=
 =?utf-8?B?NVdJUmNwV3VaZDRYcnNLeC9FeExVem1WUFNsaFV5ejA4cGM0ZXh0NEgzYTZQ?=
 =?utf-8?B?RjU0MitFWmtwNEhOSTRMbXZjaDVBZnVKdjY3Q1BGZTVSOU9nejVFWDVVQWUz?=
 =?utf-8?B?S1NPSmoweXgrSXR3Q3RUSmEzb21ZMzRsZXdoOWYveXhFdUhZNTJoOXQraUZZ?=
 =?utf-8?B?NnhWdDl2am02ZHBkQ01GazBHWERMdEJOSEtuVW9vcEI0VUN0OGlxK2VXOXpa?=
 =?utf-8?B?MElBVGNSTzVhQ0VvNGtiYlhlSW1NODVWZzFBL29hK3pyeHNtYVY5S2IxWTZR?=
 =?utf-8?B?T1Y1d1BWWU5CQytMQXVlU2ttdTl4aVVkRjdtcy9xV1lxWE9GaVBuTzhWdjBN?=
 =?utf-8?B?cS9UV242Zk9yV2N3OCt3dUEyRFBkTmhOL1ZQa1RITDZESHFaRDJ3Q0IrVEI0?=
 =?utf-8?B?amZWSGUxQWFoYmRWQm9TRVd4QUs0SEVLMHQ5NE5FdTFlL3B1bFcwZW1tOUdF?=
 =?utf-8?Q?7cQjWk2jvD2cenAz5u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe74dbdb-b388-4847-9eaf-08ded27c02e1
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 05:38:40.2308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBMdrWv/mb8K+H04OiUY2YEcvM14rwmuzxUfH9Vrw3S4JmT1xBWYMBykpH+DXJSUbTyXkV5xuZaaUSUZhIKWKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7018

Hello Prateek,

On 6/24/2026 10:45 PM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/25/2026 3:26 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> While SNP is active, every memory write is checked against the RMP to
>> protect the integrity of SEV-SNP guest memory.  By the SNP architecture
>> these checks cannot be disabled on a subset of CPUs: they are gated
>> per-core by SYSCFG[SNP_EN], which the SEV firmware requires to be set on
>> every present CPU before SNP initialization.  A CPU that does not have
>> SNP_EN set and was not initialized via SNP_INIT performs no RMP checks at
>> all, so there is no valid configuration with SNP active and any CPU exempt
>> from RMP checks.
>>
>> The firmware determines which CPUs are present from the processor and the
>> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
>> them at SNP init; it is not aware of the OS bringing CPUs online or
>> offline afterwards.  A CPU brought online after SNP init was not
>> enumerated at SNP_INIT and does not have SNP_EN set, so writes from it are
>> not RMP-checked and could corrupt SEV-SNP guest memory, and there is no
>> way to keep work off such a CPU once it is online.  OS CPU hotplug can thus
>> diverge from the firmware's expectations and break SNP.
> 
> If this is true ...
> 
> [..snip..]
> 
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 217b6b19802e..66475145b3fa 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1479,6 +1479,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  
>>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>>  
>> +	/* Disable CPU hotplug while SNP is active (see snp_disable_cpu_hotplug). */
>> +	snp_disable_cpu_hotplug();
> 
> ... then this should be done at snp_prepare() before
> on_each_cpu(snp_enable) right?
> 
> If not, then any CPU hotplug between the cpus_read_unlock() there and
> the snp_disable_cpu_hotplug() here will not have the SNP_EN set.
> 
> Isn't that a concern?

yes — it's a concern, and i agree the disable belongs in snp_prepare() before SNP_EN is programmed.

snp_enable runs via on_each_cpu() over the set that is online at snp_prepare() time, and SNP_INIT_EX runs
right after. With the disable where it is now (after SNP_INIT_EX/DF_FLUSH), there's a window starting at
snp_prepare()'s cpus_read_unlock() in which a CPU can come online that never had snp_enable run on it, i.e.
with SNP_EN clear. .

So hotplug needs to be frozen before SNP_EN is programmed, so the online set that gets SNP_EN cannot change underneath us.

I'll move the disable into snp_prepare(), before cpus_read_lock() rather than just before on_each_cpu(snp_enable):
cpu_hotplug_disable() takes cpu_add_remove_lock, which nests above cpu_hotplug_lock, so calling it under
cpus_read_lock() would invert the order, causing deadlock.

On the failure paths where SNP does not end up active, i.e., SNP_INIT_EX/DF_FLUSH error, then I'll
re-enable hotplug so a failed init doesn't leave it permanently disabled; the success path continues to re-enable
only on the full shutdown path.

Will fix in v10.

Thanks,
Ashish

> 
> Also, this patch can probably go first since the FW assumptions on
> hotplug exists independent of RMPOPT bits.
> 
>> +
>>  	snp_setup_rmpopt();
>>  
>>  	sev->snp_initialized = true;
> 
