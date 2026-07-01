Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012039.outbound.protection.outlook.com [40.107.200.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693C3CBE89;
	Wed,  1 Jul 2026 21:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941118; cv=fail; b=XiZwQoC1apLbXhTVf1vt8GISLM8HkL5+Iqm3ciaits7BnvsH4G/IEWji7STRmz8KeHfcLrM8X4vY9pw6OHL7KASNKL6KldzMZdWM1NGVt4sUZvH/zB6uY5+mYczWt6CdyP7Vlx/IjFpppMS8PakPPkYyvFAryLzZ5p9CLWjjayo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941118; c=relaxed/simple;
	bh=tUGEafcTWy70gyhX4DIrx/OZ//fNUqe37Z7nXzPBaBs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qStSiMDrUfwgrHaPvyG9KvANfL886WYib4+co/sukz60g/vBZ4evo6YPAGpNLVBqMRuF0pvc3gl80IFnhCodh+WcIqLo8GAbhip6p0zA7esju10uWQxGVZh+kgQmBK7GwfzhCYPjUoldx4v4tyBYRdpyvqyMf2fP2NAcz/nmxoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AAigArrp; arc=fail smtp.client-ip=40.107.200.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AAigArrp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=biBGO3JcGyVBHStSrM1m6xiG2OViO7QeubD0b+z7zWcomJtDhJzLqaa7jRVXd8AjpgHckp6VL0/Mtup9/8iD7/JyZF+3EiZ7MWtRgwd+0UY+lCxbSPXo1UdhCYf7lSpzXJ/ZmhMB6bvinpYkNrl+EKetkUzGgmQHGnoevWoREXd78YOHDAjVlUbBw1ENYZaxULTpPsJIBKh/v+f+awHT4+nKC7f3gfzN3loMwwvk2WAMRAkXsue7cwaLZpzR3CbFeCOyFCXQc+5zFLJwi/36m/twU6ti6d/E8TZZMVEgwuEns6UWYWfEhsXJ4BQ5a9ieD4GmKiF/8NewwpbV/5R6UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0j7ZRiOuPaW4q9gTYpGlHeQCIVuF5Vf8K4HYOLfbNqs=;
 b=C50RcWKvGUYsfxXQYQjTfFiWsRyARSXFeDUcu1qUj+gzMk49+VsaZvZ/8/NOlL342donphTRttY5L/a62gf9y0V6exm4uBthEW7Ga5JJAPRyC/1kygI8zrVsopiYuyUvgLVFK54uvLlQ8KAyrp0D1JLks7O4ZTZ7Ciqv8sKPUeOi++m62QLkyLAq21m29hlZialCLEzK/QH29JgzY6aO4CgUrFRMnH4OIW3sZyxiwv042nz7GJw2R+Fom4Q3GuyCSiebj5gs5BKgP+3g3jDy5FaOTQBV/vdcKT0JvSk1dwbH0HO2tE3cvnzNuHjnk7Xlmie/QTbKdEdWJllP86ZSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0j7ZRiOuPaW4q9gTYpGlHeQCIVuF5Vf8K4HYOLfbNqs=;
 b=AAigArrp5oOnMSAB3Y+Pmrk1p65YDS06oQLRNc7NcyOxKchPHAFB7qm1drodn4kSeVOlMPu+uIJMmatTToWh+B5YPZlHcJsUAWpdaiRZSvXk4MDiMjZ9yfK3lGQeJVH1+jXxxkoNYVVpIonuT5EZ71OnB3h44Uuj3z/a13RUFNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV8PR12MB9619.namprd12.prod.outlook.com (2603:10b6:408:2a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 21:25:11 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Wed, 1 Jul 2026
 21:25:11 +0000
Message-ID: <5147d9bd-42f8-4ceb-aca4-6ac5fd5cb7f0@amd.com>
Date: Wed, 1 Jul 2026 16:25:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: Jethro Beekman <jethro@fortanix.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0123.namprd04.prod.outlook.com
 (2603:10b6:303:84::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV8PR12MB9619:EE_
X-MS-Office365-Filtering-Correlation-Id: 932be9a5-8741-41b6-0ddc-08ded7b73b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|6133799003|5023799004|11063799006|56012099006|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	iXHYiBVXaum3p8SAOFFFJyyCSWvw1D3r1V8ISzNqdzz0dmPix8/VeEudVfP/hHgpSnvg9ASMUaR54LgmJSyGVwLuXqH2ecSSh7I03YdOhj3xyUIoCogxFo3U4xxYNpxHyd79EsvLpGj/RlcfpFaANkxUM4CMBCWIzxe6/APwBEnEEvrYfvzn02bmLLZL4P0RiBdAyxtbbLMdpiQu8P/JK2P/MxjJ2nc8AsLEDxWkat5cBQymhUZRlUzHvmaQnyocvaL4HjHMvopSOStPXtxa/bK5YqPBw/XUgfoqW8wgGjXm78jFJ10fTQyOPrIV2udfZza2s62REbWBxiKkkqc/+MX/7vBFJzDx49YkQ559L79Pwb7vje51JKjE5POcP3MMal3ZzTVyqn0OF61J5rjOYQJudP5e1htd7SZxVWlfk1hDYWEmWyydHPKqfOaC8UJMsEXHS06oo12PPKPo7ZqIwEXzdfCah2/eksna4CDRG5Ya3hGmKQtYxV6jA0bzqwKueIUO8+pchdYU8PkSerpO56JsY5fyTj2op0iqLd51eNuNpXNfj1onAKcx1cH3GLSFZ2UBr33si/C4tM5GLJ7XYlovpQW0PNizzSFRqOPGpbcfgBFDKUPMHOggvByXW+DcrDdWP9k/p119K0QTRalSdjqf+5BPJJtsi81zJTOKwXCUZv7Ljady6lsCH1gv1Ux+ziwYLzW/GDQVEHnbx7RSGQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(6133799003)(5023799004)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTVFM2c5SG0zZHVFZ2xnREZlei8xWkVxRHdWV0x2RkE5TnRhV0luM1ozNVM5?=
 =?utf-8?B?TFM1TUh2Ykh2bC93YkxFeTlMMjhqL2R3dE5HVVBWREltZ3hSbG1vQTRDSDh0?=
 =?utf-8?B?dzU5TEVCc1NOaVZ5QUR6ZmdYenNGdG16VzNuWXNMeld6dTBjRlRJTy93b0dR?=
 =?utf-8?B?dHpTQ3JKd2VZTGFTcVNjTVJGTTVvUU9neGdnRk94ME0vbWduZHFFUXRCdUhZ?=
 =?utf-8?B?blZsdEs0dTNpSHk0Y1dXdU9Pb0haT2puSHdZUmxkRU5BaFBCL0puTkVrbExB?=
 =?utf-8?B?d2hVdGt4ZnZMaVc0TEJHK0NzR1gydVdsRGZnTXhVRFVZaUFCZWZRV0VIOEhM?=
 =?utf-8?B?MGpuMmgyc1ZQcHhkbnZPTlAzNlJ2OHZYUzEzSU1JbjZRWFBMUFptYU5mbWpp?=
 =?utf-8?B?V1dsZzFPZEh6MGhVVlhiQUpNZ2VBaFJ1dWVITk9wMWRTVWVIYmxHVFc4N0Jz?=
 =?utf-8?B?NjV6ekVZSDVWbE9KVlBsamdTdjI0ZkdpQm9PaHAvS1BndlI1ZzRpRHBmbEJ4?=
 =?utf-8?B?SWVDZlNRYlM5bGNpSzAwSlcvWGMrRVRXTSs2Rm5sWGdqclE4VFpUWlFPbDRx?=
 =?utf-8?B?NFVFS3hobmZoWVhTem5DREtVZnI5YXRFWGwrdDkzZ2lEWnMyMU1aaDU3Y3R3?=
 =?utf-8?B?ZEZtY0xER21MaW15V1hEY2VlWjcwRmtvZjRWempGTU96V0toMDFyWFRXRTc4?=
 =?utf-8?B?ZEZ5SDFTU0hoQ0dqT08yQURPOGloM2xFSGdmOFRJbXJBU1cvMU9ITDN1Nmh1?=
 =?utf-8?B?UCtreEl5WXc4Q29YdVFqWW1qaGZVNzVqWkRUYno4OCs5Z3Z6UGdHMUxDcERv?=
 =?utf-8?B?UDJuRURmV1d5dXNZRWtMaTZ2anBOKzZoMUF0aDZhR09CMVNCWVpCeTNXVG1J?=
 =?utf-8?B?MUlidUljV25MNEtGN1JSM1c0UFBJVHFMVS9lSTdZVmJwMkI2cXh3UlQ3MmlP?=
 =?utf-8?B?WlJoa04xZDRDSzkwdEpiSUxVa3FRZG1SNkFQYTRJWmZVMEtPc0kzQnROTHBJ?=
 =?utf-8?B?NVdTWlYzUEVXQ0ZVQWR0U1dSdDV5Tnl0OHNRZ2hlQW9GcGIzTGdqSlVXdllq?=
 =?utf-8?B?MnE2eDBZK3V2cy9aaVFOalo2cFdzUE9TZkpmbXVyemx4ZzNPTGk1MitsdEY0?=
 =?utf-8?B?M2JyNCtwS2ZzT3dBMmhKZEpJTjZ5bHVIWktOejhjWXFSZGV0Z2t4SWNGQ1NO?=
 =?utf-8?B?OGtOaGZ6enZvK0tQeVhTZm84WG8rUmVZbmhGdHpzMUNGWmtuWUtqLzJUYm8y?=
 =?utf-8?B?TjJGbzEzT3hDc3Z0R2dJSFRFallXNnF1bEJtbk92aFg1THJEQVJGUWNBVVVn?=
 =?utf-8?B?TzFaU28yMmFjOUVkT2ExNm1ZbDRUZGpqdHd3NE5JSE5PcFFzVjhwM3E2NXZS?=
 =?utf-8?B?NS90eFhnWWhmTVdnK1JlRFpmU0gzMlFESytjZFp1dnF6TExGRFFpOGp0Z3dX?=
 =?utf-8?B?L2tFSnFUWjJlUkJFNk5YZ0duSWNMTGxnRkFGMnpMemJvYXNOaUM2R2wvbmhK?=
 =?utf-8?B?ZkpIemhhdkU2dm1IeW9HbEpmQ0ZPZitFVW1PaDRYNkJicGhpaVpSUnlEWjZD?=
 =?utf-8?B?Syt0QWptVUY1YUNuODFqYmoyMHFRSEEvdENvQUp3RVNGa082NnVlOEhiamRR?=
 =?utf-8?B?R3pTOUNtQjFXNG9BdTIxaU5EOFNLeHFoVDRhWGlTaGN2ZmJWTVdidTRGK2Rr?=
 =?utf-8?B?dmU1clUyU2RtRUoxTFdtZi9lL3NEZytqVE1BSGVCUzdleXIvUUlzOFpVaDha?=
 =?utf-8?B?RTZuamVXMGlIVUhHNmpXa0IxcndFTDgzVjdqWnFWb1U4RDMvU3VjTXRkMklT?=
 =?utf-8?B?OHE5MGZZK3k3aWNVYkN1KytEZnRET0FLTy9MQ2lqdW84M2xWYzNtZjNiSW1D?=
 =?utf-8?B?SXY0bHN1aXlNSXArWDRsY0FPdmFzOFBxWkFhaHYwQXlsQVNPT1hQb0syZWhD?=
 =?utf-8?B?MlROU2NLenhXME1FVktjV1h5RjdJOUZMcDM5V2RpT0tjZHNxMk1RYkYrQjR3?=
 =?utf-8?B?WkcxSStLcndObjNSaUQzQVM3aTFJSFR4Vnhaa3k3d3hrbVNmNTJsQ1kxM3JO?=
 =?utf-8?B?Q1R3bVhXeTJjUXQ2ZjVxY3lIZmpXSVk1SjFSWUV2MWg4cXR4dFN4OXNPb3Q5?=
 =?utf-8?B?RXlzU0h4SnF4dTRNRHYra09JUFhaYjJMQzRrLzN2M3c1ak42aExwOWlXckVE?=
 =?utf-8?B?MVJOc2o4WkJIZmkzK2x6WFUzZ1g4MFpKYXFSeHBuMFN4cXZOem1GTmp6akNt?=
 =?utf-8?B?YkVGYzIrNjBqRzVzdzRGRUN2b1BhQm5RVVVBTHVZd1dTdUc1em95QVdkb1dL?=
 =?utf-8?Q?xinXf6B8Wh9ulnzYUj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932be9a5-8741-41b6-0ddc-08ded7b73b35
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 21:25:10.8445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: an00yi1Uzu1lcRPQHwYCXefCUYlvFgjwak6mgaRrPLQXzHoxcJ8f935TvyWQLUKAgE7TZIJa+mOM6SbZsjYWDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9619


On 7/1/2026 4:40 AM, Jethro Beekman wrote:
> Hi Ashish,
> 
> I don't believe my concern has been addressed
> 
> https://lore.kernel.org/lkml/0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com/
> 
> --

The disable tracks SNP_INIT, not "SNP" in general: SNP_INIT requires SnpEn to be set on all present CPUs, and a CPU brought online afterward wouldn't have it, so the kernel that runs SNP_INIT must keep its CPU set stable. Today the only kernel that runs SNP_INIT is the bare-metal host, so a plain L1 guest keeps full CPU hotplug.

Concretely, the path is gated by CC_ATTR_HOST_SEV_SNP, which bsp_determine_snp() sets only when X86_FEATURE_HYPERVISOR is clear and clears otherwise 
(as Prateek pointed out). So a Linux L1 guest never has it set, never reaches snp_prepare()/snp_rmptable_init(), and keeps CPU hotplug — 
including while running SEV/SEV-ES confidential L2 guests. Only SNP initialization disables hotplug; the other SEV variants don't. And KVM doesn't expose
SNP to L1, so an L1 can't be an SNP host today in any case.
  
On the nested scenario you raised: if SNP-guest-as-L2 support is added, an L1 acting as an SNP host would run a *virtualized* SNP_INIT. A faithful virtualization carries the same constraint as physical SNP_INIT — all present (v)CPUs must be SnpEn — so that L1 would have the same (v)CPU-hotplug-disable requirement, just over its virtual CPUs, and this same code would apply at that level. So the disable isn't too broad; it correctly tracks SNP_INIT. It simply doesn't apply to a plain L1 guest today, because such a guest isn't running SNP_INIT.

Thanks,
Ashish

> Jethro Beekman | CTO | Fortanix
> 
> On 2026-06-30 20:11, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> While SNP is active, every memory write is checked against the RMP to
>> protect SEV-SNP guest memory.  A core performs these RMP checks only once
>> SNP has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is
>> set on that core; the firmware requires the SNP-enable bit to be set on
>> every present CPU before SNP initialization.  A core that is not
>> SNP-enabled and not SNP-initialized performs no RMP checks at all, so
>> there is no valid configuration with SNP active and any CPU exempt from
>> RMP checks.
>>
>> The firmware determines which CPUs are present from the processor and the
>> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
>> them at SNP init; it is not aware of the OS bringing CPUs online or
>> offline afterwards.  SNP_INIT fails unless SnpEn is set on all CPUs, so a
>> CPU that is offline at SNP init does not have SnpEn set, SNP_INIT fails,
>> and there can be no SNP guest memory.  OS CPU hotplug can thus diverge
>> from the firmware's expectations and break SNP.
>>
>> Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
>> SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
>> disabled SNP.  If snp_prepare() fails before enabling SNP it re-enables
>> hotplug itself; once SNP is enabled hotplug stays disabled, including
>> across a failed SNP_INIT and across the legacy SNP_SHUTDOWN_EX path, both
>> of which leave SNP enabled.  A kexec target that boots with SNP already
>> enabled disables hotplug once in snp_rmptable_init(), since snp_prepare()
>> bails when SNP is already enabled.
>>
>> This also keeps the CPU set stable for the asynchronous RMPOPT scan added
>> later in this series, and ensures cpus_read_lock() in the scan is
>> uncontended.
>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/virt/svm/sev.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index dab6e1c290bc..04a58ac4339c 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -535,6 +535,15 @@ int snp_prepare(void)
>>  
>>  	clear_rmp();
>>  
>> +	/*
>> +	 * Disable CPU hotplug before enabling SNP, so no CPU can come online
>> +	 * without SnpEn while SNP is enabled; it is re-enabled in snp_shutdown()
>> +	 * once SNP is disabled.  Must be before cpus_read_lock():
>> +	 * cpu_hotplug_disable() takes cpu_add_remove_lock, which nests above
>> +	 * cpu_hotplug_lock.
>> +	 */
>> +	cpu_hotplug_disable();
>> +
>>  	cpus_read_lock();
>>  
>>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
>> @@ -560,6 +569,10 @@ int snp_prepare(void)
>>  unlock:
>>  	cpus_read_unlock();
>>  
>> +	/* Re-enable CPU hotplug; SnpEn was never set. */
>> +	if (ret)
>> +		cpu_hotplug_enable();
>> +
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>> @@ -587,6 +600,13 @@ void snp_shutdown(void)
>>  
>>  	rmpopt_cleanup();
>>  
>> +	/*
>> +	 * Re-enable CPU hotplug now that the firmware has disabled SNP; CPU
>> +	 * hotplug is not re-enabled for a legacy SNP shutdown.  After
>> +	 * rmpopt_cleanup() so RMPOPT_BASE is cleared with hotplug still disabled.
>> +	 */
>> +	cpu_hotplug_enable();
>> +
>>  	clear_rmp();
>>  	on_each_cpu(mfd_reconfigure, NULL, 1);
>>  }
>> @@ -645,6 +665,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
>>   */
>>  int __init snp_rmptable_init(void)
>>  {
>> +	u64 val;
>> +
>>  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>>  		return -ENOSYS;
>>  
>> @@ -654,6 +676,15 @@ int __init snp_rmptable_init(void)
>>  	if (!setup_rmptable())
>>  		return -ENOSYS;
>>  
>> +	/*
>> +	 * On a kexec boot SNP may already be enabled (legacy firmware leaves
>> +	 * SnpEn set across shutdown), in which case snp_prepare() bails without
>> +	 * disabling CPU hotplug, so disable it here.
>> +	 */
>> +	rdmsrq(MSR_AMD64_SYSCFG, val);
>> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
>> +		cpu_hotplug_disable();
>> +
>>  	/*
>>  	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
>>  	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
> 
