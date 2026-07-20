Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011006.outbound.protection.outlook.com [40.107.208.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC29B3C07A;
	Mon, 20 Jul 2026 22:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784587097; cv=fail; b=Sbhha1opZqENoJ2WUzqXbiw1X9RjAqYzacx8xCHIvNgbBadTdaxnB3SpdlWUL3Ee9NC2+clp7SxGbXUbf4mIrNqYgtwSdhuNvlfP54jy2P9Sbnfi7a0B/odNKcJCD1fRd8LJZ9nQMcLSasW9F3j4sY6GjTUqaaflXO629UzkXa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784587097; c=relaxed/simple;
	bh=KOuYYzPh8tO0ViM4p6QIp2w/L09uz4fb9Jd6P38PCqg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gKc6Dx/LoOpErPOYi6I6Bi1xP0BGzsHoTIfOj+9C3gz5whr6f16WKPDzMXGovGGS5Cb2SbSNfIWBdFB1TcY9dhDl4wu3cd6R0Hh11/LDJECbofXY+IbQyeNKC2d53PI+zdFcMB/GtWQ9n7tRD+m7en7HMU9+dj+f0u66dlHVU/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VHoFtEYT; arc=fail smtp.client-ip=40.107.208.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VHoFtEYT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dboVhEgtoIZ3tLXlFquDz03UCy4bGCkdZFGrS41yibvdReBDbXwfGoW9HquH+ybjFSf9CFFywXkNr92wK48swDPZ72hoH5wTG/PPYnZdDRn4gzqOYStmD8nCPO5ASWF3wwBHSKssdsE6nPgYGXnBYxXyLf3YvuvNaL4UjahaKlntYIGy8+OIoG7U7isEVSeml12LrRcWVDVHL+PNupXISArkqLoaJrQpiypckK0kCwjQWl4dcMg+OgmOmFrSWNX6xVUdnPiUFOxsHR6wR9I+mfbKiSBPAxltAGn3enymyjDZiWo5KGxZV4PrRoP2tW/up7BhWxwQw9uG3WgAUNJAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvCi1LV+3Q0WoaCfNyV72Yt2H3O89+ExSXDRDTQ0E1w=;
 b=PMOIJbtG46P0E4Uy3PGhHxehHcgFDLmGRX03FLRMXjCWJeYmWq6CwN6WVutYtWODvc66o7byfTFjtmuVfiB11fB8D3HXpkNZcn+jqDGm8wzcvUMY3AKzXsfEub/5natF8ZRqdjFDnzNM9gftLYBMPPxqQ9vi1/RYSguXP51IoxY8CL1LQ8/LzbgZxAVzu2CRISCVxuarc0GneEjgDSILUBdzXfTkP1L1SYYF53iRYX/de9zh9yuIiAZYp+OYHYwJSi8HCGP2pWPD2lL2v4onHCNRdVvpuxnl9k6AyYAAHwhr7fvyyniEa3eH8YQ4X53Hyrzihh4OLi+80y2SgyNwAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvCi1LV+3Q0WoaCfNyV72Yt2H3O89+ExSXDRDTQ0E1w=;
 b=VHoFtEYT+nq8U9KP+iiVFvQnjIKH1ArKyDQuYD7koMe4J6VCSNi6tMyalgWEcYjNHZYyuCNZl59BuovI54AbLd1gK+e1kHqPV4yiJ1NIzefKNMYQ526MW02ePLS9ThmEBfq2+X522kIWiIa6ERCg/lP3sryDiagtbOgEanJGo/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA3PR12MB8763.namprd12.prod.outlook.com (2603:10b6:806:312::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 22:38:09 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 22:38:09 +0000
Message-ID: <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
Date: Mon, 20 Jul 2026 17:38:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:610:5a::33) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA3PR12MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b6b5ca6-a3b3-4f4c-5c7e-08dee6af92bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|22082099003|18002099003|56012099006|5023799004|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	rlmFZLwKjLddYisOddR5wtsjTRU1UIslD9HplwzAUZYu0uGP9NCbGQCYQdU8BEm+na6f2XOHgynxEN1yv/gY/4c++aLCSOJeD7tObmOP5CIUpH1w2Aox+HWCYNvc1UQorDlIhRK+mcmVO9wXd/g/RlUElJ2ZohjcdqfefkbeNe2b5G9HlWsS+JhGTj3BruxdYJQNgNu1+3P3k2sAPZ+oCDOIIN8Qbt9guQr5QowpK/lU4x6iwQ2Tt2lV1IDzpl+QbHjcj8bUnqWzdS5e2MIacvVTwwEhuIR0Y21ZuAkhSk1hIrZSLOwrPZlJv+4tKiDihyHr1Y9M/84PuebF2UDdlMe6EK/y4h/aWywjKPAWn351whJxo9dIId+zUuD5YnJF8MGxEy1K7h1cjKCa0/eL9R4iD+TXZB/bg7yi5slAEBvZG1DG2Z0hCW8NHmMvy7GUghaZ/gN8V8gPB1a2XJFnz9qUT3Qeno0dZ+BwZAl1bAUrPt+BgTw3xscIo1ps7Q91YirEbFNVzr8Kv6f8JYyuxpgof0ayUEBbE0xeRrduKeer/mM0ePWuTKKn3W4V3zLJp9HOptpU6TcbXalj24zhnxSXRgrhQaWUBh8RYY1BffY5emHjHsmW6jzaM1wFtsrsjJxtIPQaQSM8xD0lPaKeSiL6WlsKLgGEKuoOZ4MWCeE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjJKMGpZUkgrR00yMHhrTUJWOUhhcU9aRTIxeVdBVmRuSmIrK1RjcElTNU9Q?=
 =?utf-8?B?TE83WEpickZkVFZIRmtTaEhFQzlWRlJoUnMwT045Mkw0VW02ZjdpM1I5cEMw?=
 =?utf-8?B?LzZOVk11Y2ZidkkvaGxZNVZ6eVBZN3AzM0piMkVWd1JWQU1KcXRjUE9RRkJy?=
 =?utf-8?B?UzE0c1NsSlQyYXY3OEVkWnVTRnBYSldrK3VwOVViNVBCR2tJdUtiK1k4dmR2?=
 =?utf-8?B?UWR3cnV1bTNGMndWc1JvZEdQazFkZVBPZURvSExkaTlVTHp1V3BabW1GWVFT?=
 =?utf-8?B?V0RYdlFsQzdpa2V5WXdEaGFoNXNvRDIwYm5RRFIrQlR6TG5OUExQeUVRa1ZD?=
 =?utf-8?B?d3M4ZEVFbTBrVGkwQnFhZDlQeksyUnExOWJBc0F2RndreFY1VmZpaEkzRFZ4?=
 =?utf-8?B?VnI5eG5wK3h6NDJDamJEa05BN2d5Vk85b3hmUUoxWHoxZzNuWEFoZGtIN253?=
 =?utf-8?B?QmRydEhmUW1zNnBGVStwMUJRTUNPMlBxdlhCVTZFN0tnUGN4eFpvdER0SFRK?=
 =?utf-8?B?eEdZUEhNNitZVTdoa1NMbHJQVWg0Y3F4UGQ3R1EwSGRzcGUrWXRlQlhJbVpN?=
 =?utf-8?B?OFNYQ0ZCeWYydkF3UXpKTXVuekxHVjVCYWE1R2RVcHBzNlZQaUlCQjNNbm53?=
 =?utf-8?B?YU9mc2lZK1VMR1JXZmN3VmM2ancwVVBhL2luL2tQRm5FZlJyVHNWWmtvNmxt?=
 =?utf-8?B?Z3lybHFwVm5kMWhZa29uNXFHWkd5dnZIck9TZktaSDZsd2lkSmoxVUNTOFQ1?=
 =?utf-8?B?Uy94WTNRektIWUJ3QUtvZGVjTzFFc0QwNFdBemVJQXU0RHFtSGRVNmF3Uzh2?=
 =?utf-8?B?YVQzeS82V0pSQmkwMVJFdG5zbnZoVVJxb3lGV3BDa3lmTEtvdVJZd1llc2p4?=
 =?utf-8?B?VmM4dDZxWlF2ajZhV0tiaDhPdG9VNUwybjU0V3A5OHM3MEI5TmtOdDdTaG0y?=
 =?utf-8?B?ZEk4eE1DVUlLb3QyRFpjcitGVzRVTGkyRXA3c2hYbVVKUGQwY2lFTExrNXNy?=
 =?utf-8?B?a2RFeFZGT0MvcXUxRlNrcDUza3hSZStlOUZqdTByNGhEOWZ1bkduY3N6bEht?=
 =?utf-8?B?Q3ROQmR5OEhia2RsV2hiZzZHenlQOU1hRlpoL0hMeSswMGhQWHU1ZnZmVDB2?=
 =?utf-8?B?anRHdDh6Y05zT3pqRWd3VVpYZys0cXJxVkJ5cGpRaHZTbVhSc0hLb20rcWdl?=
 =?utf-8?B?NGd6ckM2TlZ1akdiTGx2NjQzWVdIQmYrWVZTMVlwRkFLdFFneFBYUTB1Y2ti?=
 =?utf-8?B?R0hWMW8zb29Gd0pTaHkyd25nUjcyUzljU1BGZFhGQUNOMEZrZWYycGFrZVVU?=
 =?utf-8?B?ell5dU95bkR0ZWR2WEl3ZkFoRDkxS2xNQjdUcS9IZWdka2gyRDk0YytqN2Fy?=
 =?utf-8?B?SDNZT3F2bUl5c1ROOFJzYTF1R21mYjZmL25DR2lJWlNRanFjVElaZHRpUEs5?=
 =?utf-8?B?cmNkelRWcFZxUEE1aWdsY0M1OWcwQjMwS1FvMFBROE5xc25oY1o2N2pwRXVn?=
 =?utf-8?B?N1lNejRwTFZLMjludHlhQTJYc1RIVjB2MEMwUzRKRjZOYmNsOEdrRk9yRU1u?=
 =?utf-8?B?UmFhL0JiZWZnSVZZNXc0MFltNXYxdEZyUVFsV0pieFc0SlFLNkJwUVMyY2NV?=
 =?utf-8?B?UWRlaUtkM2FsOEZiNjBaejFMMFhJQXc5Z3BGSlk3WG1lS1FaeVZtMkUrYk1S?=
 =?utf-8?B?NE0xOXc3SjQwYi9BaVZpZk80d0FLOE5oclZiNDZYakRPWU5STVNKMWxJQUlr?=
 =?utf-8?B?UkZzcUtVVXphYy9FYlIvOU1zdUFzK0Rqa3BPZDE4Qm13VzUvbmlnMFlwQi9R?=
 =?utf-8?B?aFhBei9jRmRnNkRvcllrQlNGODRibHhzQlhJeW81czBMZFBNVzc4S052Tlpv?=
 =?utf-8?B?N09PUmN4OUdiK1hJaEN0RHNYa0NGTnkrdVRUaFRHb1VFUkp0bWFEdGN1NFJP?=
 =?utf-8?B?RWgvYmZNa202SEx6VjRTZ3NYSEZSTUs0YzBNMFNkUUVGQitYTklDRm43Mkda?=
 =?utf-8?B?dmRRczAvUlNMQlZXM0Y1THE1Y0t5b2tCZnhhMEV3OWxNUTRXZkt6VmROeCt0?=
 =?utf-8?B?cjFBM3I1VTl1UzBnZkFEcldqSEZzYklSVHJ4U1BmcTMrTXRhR0tIY1hLN1NB?=
 =?utf-8?B?bi9malAxQ0ZVZFNTTXNKNURDSGZMV0RBcmwvN28rK1U0R29EYzM2TUF0UDVq?=
 =?utf-8?B?VkRyanhXa2JXbFZrMy9FTk56ZStUSWE0MVN1VjRnVnhpNzZ0ZERxUjZZb1Nq?=
 =?utf-8?B?dk96ZlFvdDljRFN1cTlLanRtQ3VaOUpOVzZvbnZMSUxLbVQxajRlaGJ1U25Q?=
 =?utf-8?Q?9HkrEs155p2tUd5vad?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6b5ca6-a3b3-4f4c-5c7e-08dee6af92bb
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 22:38:09.2773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKcKWDhj60Hvc9jCyUxP0D8AdmJ7IncXTqHNalcbcsSftjClzu7YgTtVUz5N+UiddMUkbcfY+eOR7lFlUc16fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8763

Hello Boris,

On 7/20/2026 5:17 PM, Borislav Petkov wrote:
> On Tue, Jun 30, 2026 at 06:10:13PM +0000, Ashish Kalra wrote:
>> @@ -490,6 +494,11 @@ static bool __init setup_rmptable(void)
>>  	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>>  		if (!setup_segmented_rmptable())
>>  			return false;
>> +		/*
>> +		 * RMPOPT requires a segmented RMP, so indicate that the
>> +		 * system is capable of configuring and running RMPOPT.
>> +		 */
>> +		rmpopt_capable = true;
> 
> So we're capable of doing RMPOPT when setup_segmented_rmptable() has
> succeeded. Which means, when rmp_segment_table is not NULL, i.e., when we have
> a segmented table.
> 
> Which means that instead of testing rmpopt_capable, you need to test
> CC_ATTR_HOST_SEV_SNP and rmp_segment_table != NULL and you can put that in
> a helper local to arch/x86/virt/svm/sev.c
> 
> Which means, you don't need that bool.
> 

Agreed on dropping the bool — I'll derive it in a local helper.

One issue though: rmp_segment_table != NULL isn't segmented-only. setup_contiguous_rmptable() also allocates rmp_segment_table
(the contiguous RMP is stored as a single segment in the same table), so it's non-NULL for the contiguous case too.

To keep it segmented-only, I'll also need to gate on the segmented-RMP mode, something like: 

  static bool rmpopt_capable(void)
  {
        return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
               cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
               (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&
               rmp_segment_table;
  }

The CC_ATTR_HOST_SEV_SNP check also handles SNP being disabled at runtime, so snp_clear_rmpopt_capable() and its caller go away as well.

Thanks,
Ashish
