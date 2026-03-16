Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6CF33B96F;
	Mon, 16 Mar 2026 19:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773687817; cv=fail; b=boEvMpjVgfBGhM/FWPB5nH30obTlf4wxLSeaawNkJ4sDOEwajMJ3HBBXsJ8Osh7pPaorzx+wsogcjIID0uViah/syHdjbDIvd2FdVlVncSu4mzEh794wDvuqEJvEC6QQq4RVvfWEvYYUUVwh/rKo2rCd2gVIO4aj2v7WVERo2wI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773687817; c=relaxed/simple;
	bh=z2EfDeKKVIPI1eW6BFQ+3df+hWq3vNsTC8VYPkIYbgo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I9/JFVGPwFRy5Qie4D+q63zigys4eltwB4O9e//mz40nkT/LBAH3HMzqdO59lMofONIA0cRajLB+Yj3mGfK8Yq0Vb+ZAPJ6HiFvJ11/IFYhyPJRHRoMlOP/E/5y5Jh3HfrlRtptxhJLDDQQgxcNtv3HGWjbFRSHzScuW05EI1nQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pfPwKHEf; arc=fail smtp.client-ip=52.101.62.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pfPwKHEf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K5Oc7jWhImRvoT20MXrjf69X+YpoFnd1yAHNgZ9tY8Csaf9Cv10aZy+2rKcTYe1D+Aezo+k7SPN9eNCGPvKcAhUfTItUhQvueSC6JlLV/Jkv6M+uUS6jAZf8XxP0E+MdpfjrpImfEz6geoNInP+F9i/pAvS3AUrxv1/vJzLxS8FFQTu0trvs/FZkWlnBqAbUqxKYOijlEBrZ5jUferukDo53ejpeVQ4vVYsbMms6JKR9xBrxV08NIcuq03RJM+C9G+ux+MmkCD+1FEwtBbzB5pGIFa5DdNHLfCZoq4kA4t4xD4X7ChNvnIdbtDsKdm2z3f3/UukJTIVq4K3Bim8nig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPUqA+yrmWvrLXbLwPRklGslo+oVrgDi5ocou/8bX7c=;
 b=qOw3sXFijp3Xr6A1E80Plb2EjQ1zFJrKfyyIgjMgchqibqGLoGT8wUlze0hE0B5cxvAQiybA545NM+r7XLrbj8LAkD/0wgU/7zowfcTRyht8fbaApgJBvaVrexzbnyiMxX0CO85xLsp1niLYWadqfRpDmCS5bmmStl+D78MEtwrFjXE/fYQ3tPhqqa1D7B1kv96x0U3FX67YLD1oYHH24EU8DvYr2fRDQJgQTflfoD/EbnxWHTKZP5C3SvaDWXtar06vFu1vZ2cF2dFlQk+QRuFZ1O1A9ZC5C1kyz66yPRXS0HEpf80TaBzQr0mwGbip7yfr1Ykhtk6C0xXXzI6GKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPUqA+yrmWvrLXbLwPRklGslo+oVrgDi5ocou/8bX7c=;
 b=pfPwKHEfcl8xd4b3lxZw/5j7Z26zk7ZvcRhlqKDR4lUUbrSw78fbDTntGHDjC4SeRoxPTsgiAAoDOnGdwUWjs/ZF+SQlO6j8RkDpQjRmTNrCA7njKnmWx+MuReLZINlJsgQWEqDjGPGoxJLLCAmOKJLMXT2i8OSwcaVBdlA6e3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB8224.namprd12.prod.outlook.com (2603:10b6:208:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.13; Mon, 16 Mar
 2026 19:03:28 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9723.014; Mon, 16 Mar 2026
 19:03:28 +0000
Message-ID: <cdedb126-777a-4e40-a5a5-93aa5dbc38aa@amd.com>
Date: Mon, 16 Mar 2026 14:03:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
 Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
 <aahH4XARlftClMrQ@google.com>
 <7ab8d3af-b4f5-481c-ab2e-059ddd7e718e@intel.com>
 <0fbb94ad-bfcf-4fbe-bf40-d79051d67ad8@amd.com>
 <6a4f4ecf-ffc0-43a9-98d4-06235b42063e@amd.com>
 <d7ba3790-a959-4150-87e0-c87dea4d09c5@intel.com>
 <cc9bf918-a14b-4619-a084-3f424fa16ea1@amd.com>
 <5102edd8-8eaa-4688-b3f7-3004c4cbc8f3@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <5102edd8-8eaa-4688-b3f7-3004c4cbc8f3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: cfe64522-8156-466e-4c61-08de838eb520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Vn+mZkdG9viizaOMpe3RPS02PaW/3WnhnYb8fAE9V9H7KETkIk3lDI9meASBDN+eIH8NJG/+GMXD/CLVfFJxR7SOXvkGmiyK8EzHN5DeNYpsDqIik6nkhmPImDPZaaSEvV67SW0zmktYu8H/JOXxua6ofmMLayjGQiXa6VJfOYpUzIg4xqCHDCAWpvDr203tXaIWFCF51TFXVNdFA0hTQs0VNUXyyzh//7GYmPyoJ212p33UQ8O0A5wLV1KsfpQz6sJ/C2fEU/ERe3SbPQcUsViJ6L71K50oYJDghmeLjPLLBQClgwVmCeI287OouIOIPfdHkAfTsRqBkzXI1bDQCQSO8uHLJYmqgOUFfroICkzOwrt1JnLO8EWzv7RB20hLc9KQY9sVQXkbVVqaB25x6NrNUdmf7VeDSDpXXIhiifFh2K1yHqf+AUWi68nocHFrHHDyJcuuSFnsxpwHmCtDyw5B/1Y1livA01dEIK9Txcyk7Z2GHXXXc4py3ku0WGG5Y16p0BBGCMUCFJVEy1NZPlHq2hriYA401/W5yP1yX/MkJYbTT8OKWH7pLRYpIoL8YeATtLkRVZFJZaTzwwl70E0K8/Nl1jz1Ujn6z+h1RvMpg1jf0mUMUH9KwnotzgYlrdrLfllitvFWs3z8ySnOeJRUYyiSnCNV+smTsVJQPclPO/gn9Baca+6YDC3WxYYuhqjZ7DEdYtYqh5vmVJVM1zFtI/v92nKVhab8K0DTs8U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b041RFpVSDdzakQxMHVZUTFzVlVmVjlCYWxiaFg4THRTUW01MUFqNmRNYlpp?=
 =?utf-8?B?M0p6YzkvYmkxZVdsUnd3NHdSUmlJc3hLNStraWNTdDBBMkFZdStTRElHV2Ri?=
 =?utf-8?B?UTVWUFJrZUNrMndPNW45cm9mcXlzaUplM2xTRDNMRWl0UCtJUUlYQURzdjM2?=
 =?utf-8?B?WmswalpDZUdSQXQ2UW5VQmh1YVIydTh1cVJnSXNQQStsQmN1dzVGRUU0d1Nm?=
 =?utf-8?B?cjBhUURSb2VFM0dOSUo4QnA1TjliSmFRKzU1TmpCSW82Q2JpdFZvYzYrVUw1?=
 =?utf-8?B?Y1lBYWplVlVDZmUzc0Erd1k1OTFydEhVZ0hNNGxhR3BQQk00d2RTanM1V2pU?=
 =?utf-8?B?VktSM3VqZzQ3dDhCM1RiTGI4Wmc2Qm03MkVhazEwcWtla0tLbG96R3pjV1U5?=
 =?utf-8?B?RXBSb0pleXByN2Frd2NjVkpEVnVNQkxWb2ZHaDNXUDdQd0xrV3pKYVpGOStC?=
 =?utf-8?B?WmtNU2E1bllXVW1MMzZLTEc1U3U3YlRlWE5ScUgyUlFrZjZiZXNNbU4xZTB4?=
 =?utf-8?B?aklQMW9QOVBrRUYxQ3dVT2FZTFh3TGhkTEF0aFhnZ3hvbkxpUTdPUlc1U3Mz?=
 =?utf-8?B?ZVQwem1LN1J1K1ZFSmVBTlppMUJaV3NHYnpqRHRWazFOQUU5QW5CV01xRFNF?=
 =?utf-8?B?YjBnYUdlTDFrS3pXTWFvcndhYXhjL1ViMlJzV2RxL2ZtZFVWb2QzQkR2TkZm?=
 =?utf-8?B?UWRTNm1lRThMK2hhc2tSVW5qMFQzWE5PbExZUmZ6UXo4aldhb2FsNTNHMC9X?=
 =?utf-8?B?WGtaWjZjY2czUTJDOHMvUEFHcHhpa3hBeHFYbkJTQjVTWDR3ek5sOXREWkVr?=
 =?utf-8?B?NzM4V0g5L3ZpbFUwTDZ0SVh3RnNRcWpUV3dHZHpmQmVraktzSkxpbktQL3li?=
 =?utf-8?B?eTcrOUVzQjNMdTdBRUduQXRsQzVmMjlCellCd2FXTE5pck1wZ3EvVDA4TXkx?=
 =?utf-8?B?eW9nbFFwckp2aXBZc3FYcHFlTFJIOHRTSEFHMDVnTUtFL3ZiaXVYcy84dUZ6?=
 =?utf-8?B?ZXo2R0pnSW0vNzlqVU0yZkVKZk1lQm55VFBESFdSNCtlZVQ3bTduOVZFN0xU?=
 =?utf-8?B?VmMvSUpHY2tnckpaL01UMDdsK09Jc1dsMFJVb1loVG5zSS9jZ2tUL2kzZGEy?=
 =?utf-8?B?TFNRQnlIaWFXT0FPVTJLeWhHKzBsQUovdFh1WDBuT3ltN3htSzJGUDhhK1JM?=
 =?utf-8?B?V1hFRG5pZlE4bHUwSndmY2MrcFF2NkFEQzFxOExrU0JiYlpRVlRhWVNXZVlH?=
 =?utf-8?B?d05UOHZ1bEY1U3BsYWpJNVExK1g1bkxIRWQ0eDZWME5ML1JoTG1VR1ArQXNN?=
 =?utf-8?B?Sk52bGRaSWtzUnYyYXY2N1lOMlU4RFdEN2k0cEw5WUxZazRybVhaWE9mb1Q0?=
 =?utf-8?B?N1dja1NIY0dnbUJKeCthMm5VQXlNVVFPVWlaalR5WnNXWUxtNFVsZWlwbVFP?=
 =?utf-8?B?Z0o2UURrbW1NS1IxeE8rSGVUMTg3MkZHUDZqcW40TWY1OTRabkVDL1VHbTR2?=
 =?utf-8?B?UzF5VTg0TEtLL1NJeHc0Tms2NmsxdHhBcHJoeDZjdVA1SEI3d1NEb2ZVbUpD?=
 =?utf-8?B?UE4wV0tIKzE2RkJjTm1XZnQwQ2JOSWVOZm94Y3huVUdsWTF3aXNHeHJZdmhR?=
 =?utf-8?B?dFhjK0UyRGJ6aGtieWs3WVB3SFA3Y256V0NnQ3g5MnpucVJjcmFObi94UVRP?=
 =?utf-8?B?bFhsQ1VIenhEdnpITEZwcVcvM2p3MVFlTFdCWFJ0eUlCTzFqeFgxVE9aNE00?=
 =?utf-8?B?dk03OStvMjArNVppK3lVSEIzc284ODZuUVBkbHF4U0krcUZIekp2KytZbGta?=
 =?utf-8?B?eTVuMUJ3Z3hkRllzWlc0RldvVWtpN2txUVpLTEkxbklNYUVUd0xGeUp1RCtD?=
 =?utf-8?B?c1JsSG4yMXphbllWWFR3Umx6bUEyMThjV2pLdUFzQ0JTN0ZDaEVjZS9ZVzBF?=
 =?utf-8?B?dk94bHduMVdxR1NTank1YjVQa1AzU2E4czJPQ2JrdERLNUdFMEVGM2hhdlZE?=
 =?utf-8?B?MHI5Yk96RWpUUnNmcVgwZ2hmMGpoRFlVelBWd0d4VXhCUEdKZW90WHl1azZh?=
 =?utf-8?B?MkFhWE4rWVVuQ2RzZGtuRnhGMEVLR3BPUjVkNllDbkVzazNOTGNJYzQvbzRt?=
 =?utf-8?B?RGhBaUM5U21peWhoOGVEc0gzeHYyZG1uU2Z1WTdIQkgrVzM2bEc1ZnUzRGh0?=
 =?utf-8?B?TmZhOEM2c0hlTDRPei9oeEVQa1crRG5UcXBHZUNaWFlrSDZ1bWJ5VWR5SFUx?=
 =?utf-8?B?U2cxN2JOUDJMM2J1YjJvbW5pZWJvenNGajJuaFhyZENrVVhzZWdTRFdhV1ZJ?=
 =?utf-8?Q?wrjkixoAYo8ZZjut26?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe64522-8156-466e-4c61-08de838eb520
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 19:03:28.2988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8eeGz8aXTpklqxH0GsX49OGdbyaDzZsnSl5TkxByZxtExV+mS9i/4dHNDvNtO9B2aOABNiy8RhzoMxDHAX+NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8224

Hello Dave,

On 3/11/2026 5:20 PM, Dave Hansen wrote:
> On 3/11/26 14:24, Kalra, Ashish wrote:
> ...
>> There are 2 active SNP VMs here, with one SNP VM being terminated, the other SNP VM is still running, both VMs are configured with 100GB guest RAM: 
>>
>> When this loop is executed when the SNP guest terminates:
>>
>> [  232.789187] SEV-SNP: RMPOPT execution time 391609638 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~391 ms
>>
>> [  234.647462] SEV-SNP: RMPOPT execution time 457933019 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~457 ms
> 
> That's better, but it's not quite what am looking for.
> 
> The most important case (IMNHO) is when RMPOPT falls flat on its face:
> it tries to optimize the full 2TB of memory and manages to optimize nothing.
> 
> I doubt that two 100GB VMs will get close to that case. It's
> theoretically possible, but unlikely.
> 
> You also didn't mention 4k vs. 2M vs. 1G mappings.
> 
>> Now, there are a couple of additional RMPOPT optimizations which can be applied to this loop : 
>>
>> 1). RMPOPT can skip the bulk of its work if another CPU has already optimized that region.
>> The optimal thing may be to optimize all memory on one CPU first, and then let all the others
>> run RMPOPT in parallel.
> 
> Ahh, so the RMP table itself caches the result of the RMPOPT in its 1G
> metadata, then the CPUs can just copy it into their core-local
> optimization table at RMPOPT time?
> 
> That's handy.
> 
> *But*, for the purposes of finding pathological behavior, it's actually
> contrary to what I think I was asking for which was having all 1G pages
> filled with some private memory. If the system was in the state I want
> to see tested, that optimization won't function.

True that in this case RMPOPT will not do any optimizations and the system performance will be worst, but actually 
if you see in this case, for this loop which we are considering, the loop will actually have the smallest runtime.
More on this below.

> 
>> [  363.926595] SEV-SNP: RMPOPT execution time 317016656 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~317 ms
>>
>> [  365.415243] SEV-SNP: RMPOPT execution time 369659769 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~369 ms.
>>
>> So, with these two optimizations applied, there is like a ~16-20% performance improvement (when SNP guest terminates) in the execution of this loop
>> which is executing RMPOPT on upto 2TB of RAM on all CPUs.
>>
>> Any thoughts, feedback on the performance numbers ? 
> 
> 16-20% isn't horrible, but it isn't really a fundamental change.
> 
> It would also be nice to see elapsed time for each CPU. Having one
> pegged CPU for 400ms and 99 mostly idle ones is way different than
> having 100 pegged CPUs for 400ms.
> 
> That's why I was interested in "how long it takes per-cpu".
> 
> But you could get some pretty good info with your new optimized loop:
> 
>                 start = ktime_get();
> 
>                 for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
>                         rmpopt() // current CPU
> 
>                 middle = ktime_get();
> 
>                 for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
>                         on_each_cpu_mask(...) // remote CPUs
> 
>                 end = ktime_get();
> 
> If you do that ^ with a system:
> 
> 	1. full of private memory

Again, for this case RMPOPT fails to do any optimizations, but for this loop which we are considering, this case will have the smallest runtime.


> 	2. empty of private memory
> 	3. empty again

In both these cases, RMPOPT does the best optimizations for system performance, but for the loop which we are considering, these cases will have
the longest runtime, as in this case RMPOPT has to check *all* the RMP entries in each 1GB region (and for every 1G region it is executed for) and
so each RMPOPT instruction and this loop itself will take the maximum time.

Here are the actual numbers: 

These measurements are done with the *new* optimized loop: 

		...
		/* Only one thread per core needs to issue RMPOPT instruction */
        	for_each_online_cpu(cpu) {
                	if (!topology_is_primary_thread(cpu))
                        	continue;

                	cpumask_set_cpu(cpu, cpus);
        	}

		...
		start = ktime_get();
                
                /*
                 * RMPOPT is optimized to skip the bulk of its work if another CPU has already
                 * optimized that region. Optimize all memory on one CPU first, and then let all
                 * the others run RMPOPT in parallel.
                 */
                cpumask_clear_cpu(smp_processor_id(), cpus);

                /* current CPU */
                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
                        rmpopt((void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS));

                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
                        /* Bit zero passes the function to the RMPOPT instruction. */
                        on_each_cpu_mask(cpus, rmpopt,
                                         (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
                                         true); 
                }
                end = ktime_get();

                elapsed_ns = ktime_to_ns(ktime_sub(end, start));
                pr_info("RMPOPT execution time %llu ns for physical address range 0x%016llx - 0x%016llx on all cpus\n",
                                elapsed_ns, pa_start, pa_end);
		...

Case 2 and 3: 

When the following loop is executed, after SNP is enabled at snp_rmptable_init(), the RMP table does not have any assigned pages, which is 
essentially case 2.

So the loop has the worst runtime, as can be seen below: 

[   12.961935] SEV-SNP: RMP optimizations enabled on physical address range @1GB alignment [0x0000000000000000 - 0x0000020000000000]
[   13.286659] SEV-SNP: RMPOPT execution time 311135734 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~311 ms.

At this point, i simulate the case you are looking for, where the RAM is full of private memory/assigned pages, essentially case 1.

In other words, i simulated a case, where the first 4K page at every 1GB boundary is an assigned page.
This means that RMPOPT will exit immediately and early as it finds an assigned page on the first page it checks in every 1GB range, as below: 

	...
      	for (pfn = 0; pfn < max_pfn; pfn += (1 << (PUD_SHIFT - PAGE_SHIFT)))
                  rmp_make_private(pfn, 0, PG_LEVEL_4K, 0, true);
	...
              
And so RMPOPT instruction itself and executing this loop after programming the RMP table as above has the smallest runtime: 

[   13.430801] SEV-SNP: RMP optimizations enabled on physical address range @1GB alignment [0x0000000000000000 - 0x0000020000000000]
[   13.539667] SEV-SNP: RMPOPT execution time 95275588 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~95 ms.

To summarize, these two are the worst and best performance numbers for this loop which we are considering.

Best runtime for the loop:
When RMPOPT exits early as it finds an assigned page on the first RMP entry it checks in the 1GB -> ~95ms.

Worst runtime for the loop:
When RMPOPT does not find any assigned page in the full 1GB range it is checking -> ~311ms. 

So looking at this range [95ms - 311ms], we need to decide if we want to use the kthread approach ?

> 
> You'll hopefully see:
> 
> 	1. RMPOPT fall on its face. Worst case scenario (what I want to
> 	   see most)
> 	2. RMPOPT sees great success, but has to scan the RMP at least
> 	   once. Remote CPUs get a free ride on the first CPU's scan.
> 	   Largest (middle-start) vs. (end-middle)/nr_cpus delta.
> 	3. RMPOPT best case. Everything is already optimized.
> 
>> Ideally we should be issuing RMPOPTs to only optimize the 1G regions that contained memory associated with that guest and that should be 
>> significantly less than the whole 2TB RAM range. 
>>
>> But that is something we planned for 1GB hugetlb guest_memfd support getting merged and which i believe has dependency on:
>> 1). in-place conversion for guest_memfd, 
>> 2). 2M hugepage support for guest_memfd and finally 
>> 3). 1GB hugeTLB support for guest_memfd.
> 
> It's a no-brainer to do RMPOPT when you have 1GB pages around. You'll
> see zero argument from me.
> 

Yes.

> Doing things per-guest and for smaller pages gets a little bit harder to
> reason about. In the end, this is all about trying to optimize against
> the RMP table which is a global resource. It's going to get wonky if
> RMPOPT is driven purely by guest-local data. There are lots of potential
> pitfalls.
> 
> For now, let's just do it as simply as possible. Get maximum bang for
> our buck with minimal data structures and see how that works out. It
> might end up being a:
> 
> 	queue_delayed_work()
> 
> to do some cleanup a few seconds out after each SNP guest terminates. If
> a bunch of guests terminate all at once it'll at least only do a single
> set of IPIs.

Again, looking at the numbers above, what are your suggestions for 

1). using the kthread approach OR 
2). probably scheduling it for later execution after SNP guest termination via a workqueue OR
3). use some additional data structure like a bitmap to track 1G pages in guest_memfd 
to do the RMP re-optimizations.

Thanks,
Ashish
