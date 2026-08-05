Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2FA2F7EF6;
	Wed,  5 Aug 2026 02:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785897498; cv=fail; b=aXXVL2glm8cMChJM78uqsAFnvviwTMuRp+ea8pfFP+7PeCUbacHr50Fk+Iif8TXbf9pCoLBA6vhp4MojoC8jAZJrW9BzT7JjvSZ8yHknWODKlp8gfI4IvItZiqup92hBnIVovICyl66MFoMthXJAlonxSDGZFhcOZ8QtxSDIfTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785897498; c=relaxed/simple;
	bh=q1ZbwsNt/EcAV+t954SQ1OWroJFK6/Raevvrg0Mq2wQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BtuAGnWy4uMmouarjfnZYTO7rN6QUkMzpWxP7lOtGCeT9E+YwiXznwalVGRRSyxISUM7tft2YTLiVIFGQXybHNyP18Uk73GpAXBC7J3pu4jXJl/fMl9G01GaSPSh+tO3kTs5eE1HpjC6NDdXHpvmX4IW4oLJ76zdP4ER08o6aAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uLDVFV74; arc=fail smtp.client-ip=52.101.46.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uLDVFV74"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ma++QaPs7gAf7nNgwbPYQ+xBfZTyf/FeHd2ENRu7VqaXpcA1f912mQ7RwkcboI/Cy319IvF84ZbElRZnS1eExewx8FdM4K/QmbChLV51znRgcn0E1ww0IlTgxyA+ZnNUPq5V4Q9PQO1SphdJvEQ73bfZvcLJosAWiafX5zx7FNYNogCcDv/NjWiuaoH/SCbFIPWL7ujSsy9q4ynfxwi6gynB4+I82clChM51JnCvbHEwtApiDIMjHKWbiVQIzXeJ/s1AS2H6oW70H4+uTkuR3M5SHIPJg+KY3/zyBR6RM9SUHGBnbWwVGu8r0joCsm5vr3ml8ml9Wa8+1kX4xroQ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yA1UdTZHxAp1rO0nO0O/Sn8ep6hyA90g1ZqrN+wGp4w=;
 b=tuJfMRxaQu/ZM+lGp5lOPLrRIqG/tFUjy6faAjUsxTt6s5L2sZQa9TNRPiFlmEyMzJpn0zhLOfvhr0oTejvJgIJm6WI+oxlmnjQ8pNUE/kS7LGPK7W+mA9nBUe2GLj9/fouA0n1ASYzRN0siYvNh6KCfT2xa22R3M2BCzhHMRD1G1u4x5pSbFn0caZZ9UKJywMTpTeR6KKwc4OXXcDVOxnh7Hxlwp2AbSi0S7wASfP9PX6OYvG9fOXYyxqR0DLRyXwJihAS0gjVx+1y3FSJv4fZxrHwKB1sBxmUegRHbbnuLwGFa75YBK6HgDQ70CHkVZjO+7XcJwHiMvQtVc5bWNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yA1UdTZHxAp1rO0nO0O/Sn8ep6hyA90g1ZqrN+wGp4w=;
 b=uLDVFV74Ise7yXBHKBRlia7CdPcspT/2WeDSC+4NiV/goRx5te7uyQQxbCxz/g4GHN2e/No1iIOyCzDpSpaBxgnLC0iqNhtG7I+DYQJt5C+61qZwiE7awJOdJirjF5DDxSOBABeMPmsa54HlBKxiHjpA/ESQw4onwgZXMg1PflE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DM4PR12MB6061.namprd12.prod.outlook.com (2603:10b6:8:b3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Wed, 5 Aug 2026 02:38:11 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.21.0270.016; Wed, 5 Aug 2026
 02:38:11 +0000
Message-ID: <63867f3f-a7a3-4d6e-83b4-0683688512e9@amd.com>
Date: Tue, 4 Aug 2026 21:38:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
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
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
 <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
 <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
 <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
 <20260805004913.GBanKIiW-O3pDjIqjH@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260805004913.GBanKIiW-O3pDjIqjH@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::25) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DM4PR12MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d141bb-23d1-4a9e-d609-08def29a9748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|6133799003|22082099003|18002099003|56012099006|5023799004|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	dsRSIR4UB+T1CgyxVhmpRcnugjx94avWVi3Gx6RhS3YsVKfbUjV4iKR6DuPkxYWxv66Nw59kCWzecfov3ofILFdOZ9sgXnHLn69c4nKHISpguW/Z9od4FFUT70Kk84GvQpJUb/EzSxbun1xMCsBbKRBHVyYTRKZjfGIbV0Lyp773U0lbv6Agl7yzmlGsahs0BaSOcykBHq/wQu5IomIrmD/8zru14eKJ0qm1oxcujqRGVDqiLDDFg+IkaEMChLWv5gLu/qL5+oBUIlfBYM6gLo3sP0XJzRyVkiAaSLKpR2SnWbJtji7B0vpZwsaan7qgdc5VAlYZnRPi7QIj3rX3Vfq53gimpWmL9PTFY2N6fqHnFywJrv8mnD1Rno9IEEyTWBOvLfZAo8+y6YttVxgJ2ZlgoJsWNkBzp2kZBCF1PFUHzmiZCJ5EI/g14eiyIWUa9REmrU+Kt1LXKomI6Fr55o9TcSMeMmM7tmsE2/vO5yXs9fnp2ZeMm19x2NAWKvGo6NEDcLffgakXa1vQK48mnYb4Auq1IANNEdSNvIs8EViEz2M2WHyK92yQoN6tmQjIpcVVnYSr8rYVjM71aY3ZuPc3l75TKejynemyW2Gs0b8wAi6fVy3bCfM1h4kHDLR+3ffxzO0YINmfxZPNqwkuJyGTTXvHv+0bChxfo7N6V8s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(6133799003)(22082099003)(18002099003)(56012099006)(5023799004)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlM3UU5IeVFuWkJEYlFjWDVrdTNGSWZwUHhHYXJ4ZENaM1RLRG1FTHRIN2hU?=
 =?utf-8?B?Z29CNHEranhxVE9hOFVNUjljbk1wT2NLZ1poeDdXWEpSRE1PTDBUZ29HU0l3?=
 =?utf-8?B?M3hQT0ZaVW5JQ0JOVjkycVRSL2tJOXgwQWc3aFRLcFp6K1pYdlVvWllrRFc4?=
 =?utf-8?B?SFE1VHN0d3A4VjNXdVp3ZEJLRjgwOEo0bVhZZ0tpY3pXTWdjaU11b00zWGRP?=
 =?utf-8?B?bTF6YWpXUTJyYkdrSDZmbHVYaGMzUmhmd0NiYkhzYWk1c3BNWWxiZkxnMFN2?=
 =?utf-8?B?Ly9MRkhzT1Jvd2R5aHZUcjMzcWlIcm0zWDdZUU1HcVI4aVVIeDh2cGIxbFE1?=
 =?utf-8?B?cnNQVXROQjhJNjVQbGxUS09zVWdFOUxrcUNhMU1SdTBFNnVrMlVqSVVkd0hl?=
 =?utf-8?B?U3M1T0x4TnBpK0JadFdTSEJDZHB0OHNVRGtFVGlieDdRN0xQUzFmakdTVEJs?=
 =?utf-8?B?NStVMTgxYXowaExYTGpKUzd3R1VrUUdQVDZRTmtkdEVKM3J5Tnk5YkZQaDBm?=
 =?utf-8?B?dG5UTUZ1QUg4TDl1M29ZU3FaaEFhZEtrekRCZk9GeEU3ZHplcUlrTm0zNzJl?=
 =?utf-8?B?aUwwZk1RODhEVjVPV3NoNTdwTXQvZFZBK3U5THhWbnNiS1FEcjRnVGU5KzRR?=
 =?utf-8?B?QTFCZWtUQVNucE1qMk82SmljUWNmY3pEcFRqOEZEVnB1ZHRreWhnSFdibGpK?=
 =?utf-8?B?aUhDRkI5UUhUNHRrTEwxcG9rNEx1ejVvWkJ4ZGxqVGN5aEZpN0ZHZmtLWTNS?=
 =?utf-8?B?d3dwdFVtQWhvdjIyT1NRYzNRY3RSZU9qWG1RYmpYN1NtL2lhMEJkRG1tOFVY?=
 =?utf-8?B?bXhqODU0aW10QUFIQVhOUFh6RlFTV2ZHNjNBNGhsMmF2dlJOYktqRzVsQ2ph?=
 =?utf-8?B?ZmI5WUNvVmtaN1M3bC9TTGptUVRoZzdGV2VIbkMyTXF1TEM2NUJjNW0zSXJV?=
 =?utf-8?B?MXFQZ2MvRGlwUzU5ZkpuKzhWQTVneVJncWdpdEFxb2RYN1Z2MzN1RUMwbDlr?=
 =?utf-8?B?aE41QUg1Tk5Sc2pWNXJNaUlqSzQ4a1EvN2daMEw3ZHVNRHEycGhQSU83clJQ?=
 =?utf-8?B?alp2T3dPT1dhNHdzT3JkdmJ6VmRrMm5PRVI3NHVGZEdxQXdaK3NHWFo4QVpR?=
 =?utf-8?B?MEhpdElJS3Y3MUl6TzZDK25kT01weGJrdlcwNWVMVHlDRUc5eVdtOGQybjln?=
 =?utf-8?B?bFBqQTdBZHBHNkVkMGlKWmN5eDNjZ2RTM2c1bnRNV1VPSG9QTTlLTXFTUlYw?=
 =?utf-8?B?SitzNTV0a2NNUHA3RlA2ZGM5a1kyUlRlTkxLUkdrcU5NQ3BaK0Z5cHZUbSt1?=
 =?utf-8?B?NnFSamZ2TytabS9YOGkyc1lsN09wVkl6REcxdU1SRkhla0JUaXRvTVYwWklN?=
 =?utf-8?B?dTYvSmFyYVQ3VUtNbFo2Y1dPTExvdzhZQ1hRWkNSOE85V25HMkpNVC9xMnN2?=
 =?utf-8?B?Vmo0TnFMTlFKQnBncTZMa3ZLRXgyN20wYTc2VEJpSTJRUy92bUxrQ3F2T2s1?=
 =?utf-8?B?VFdjT0NhMGMvcVdhMUhYVHJRVHlQNThLMVVRVGV3aXU2Ymp4ZDNUZHFKSHhN?=
 =?utf-8?B?V3RKZnNnbzBzTndSTldCL0ZDTk4ybjFaTHdtYkdFR1lUM3BkSXMzZmhzT1dl?=
 =?utf-8?B?dFpsQnJKVWpFVlpUbW9wNWZJOHdDOTRndDZ2cDdwYUplSVBjUnVWdzhrL1VV?=
 =?utf-8?B?NFk5K0tsdlk2UDJGdDZvMmptUDUzMUQxelYzMFRnQmxFZWc0Sjg5c0RMTFhs?=
 =?utf-8?B?SjV2bGs3d3VObWRuUm5QcFRPVjZQdnQveDhiWWU0ZzA4NnFGUG9vVTlET3k0?=
 =?utf-8?B?dXVmWkhGeTVqRGdHNzliNWJNNXR0aUNBU0ltR29vam8zdk5zU0pPbWxnN3NV?=
 =?utf-8?B?UUg5YVloSWZPTHM3TnlsSVBqdFpMQkp2V3BURUhHQ0loU05PUmJoM0RmZkFI?=
 =?utf-8?B?aEp1MkN4aC9wVUdvNzVuNVNDdTZSQXFwZExhdlNSSFVLNUxDUkVSWkl1Q2s0?=
 =?utf-8?B?OGRhU3ZmZHphY2ZqcnJlN2FxYmZFYjErOE8rcWRySlRpRkIrb0V6MmloS2hD?=
 =?utf-8?B?WC92d1MvcTFKTWtrbXpZaDN3cVh6blF3b3FQZGYvYTNqWWM0NWMyK1pDRGJ6?=
 =?utf-8?B?b2x4OGdyMzUzZVFPdE1tc0tzM3Jlb3lOVHZvUTNLeE05VGFVS3FnQ3dmaHpE?=
 =?utf-8?B?U0EwVW1GNW1va1BWZWE1WEgvdVpZUkZMdGNBR3ZJaXdqMTBKNVNNSkpoMUpk?=
 =?utf-8?B?ZmhCMkJ6Y0NBU3VRY3BEZEhBeEpTK0VnSXlJTEN3d3pTRGMwRmRuV1dHNVM0?=
 =?utf-8?Q?YOWi/Rp2w2hBuxe9LK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d141bb-23d1-4a9e-d609-08def29a9748
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 02:38:11.2929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwY2WZlyrx1g0NvVs3kHa69YmXoyp69Dt/bMaCkh4m084LXxHtF8jdVQe2JZew3kEYXb3ebBqdedCYmX9TTEng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6061


On 8/4/2026 7:49 PM, Borislav Petkov wrote:
> On Mon, Aug 03, 2026 at 05:22:17PM -0500, Kalra, Ashish wrote:
>> Periodic re-optimization was already considered in an earlier RMPOPT series
> 
> Link?

Re-optimizing at guest termination rather than via a periodic/runtime interface was Dave Hansen's suggestion in the v2
review — see https://lore.kernel.org/kvm/5102edd8-8eaa-4688-b3f7-3004c4cbc8f3@intel.com/"

> 
>> and dropped because of being too disruptive — a timer-based scan would run
>> on all cores every time it fires, even when no memory has been freed.
> 
> What if it ran very seldomly, say once an hour?
> 
>> Running it at guest teardown (batched by the timeout) is a better fit:
>> teardown is when large contiguous regions actually go back to the
>> hypervisor, so the scan only runs when there's real work to do instead of on
>> a fixed timer. The case of a guest freeing a 1 GB region mid-life is then
>> handled by the 1 GB-hugetlb page-cleanup follow-on, not by a periodic scan.
> 
> Are you saying a periodic scan won't handle anything?
> 
> Because if it catches something, it will handle that something.
A couple more reasons the event-driven trigger fits better than a fixed period:

- Under churn (many SNP guests terminating and respawning), an hourly scan is too coarse — freed regions would sit
un-optimized for up to an hour. The teardown trigger re-optimizes right after each burst of terminations (batched by the
timeout), so it's more responsive than a periodic scan exactly when there's the most optimization work to do.
- When no SNP guests run, a periodic scan achieves nothing: the initial pass already optimized all of memory and
nothing has changed, so it just re-scans physmem for zero benefit.

So the event-driven approach self-scales with real work — it runs as often as memory is actually freed and not at all
when the system is idle — whereas a fixed timer is both too slow under load and pure overhead when idle. The mid-life
contiguous-1 GB case is then caught precisely by the 1 GB-hugetlb page-cleanup hook when that lands, rather than by a
coarse sweep.

Thanks,
Ashish

> 
>> I will also like to avoid looping on this — periodic vs teardown was already
>> worked through in an earlier revision, and this is where we landed. Happy to
>> revisit if there's a specific new concern, but otherwise I'd prefer to keep
>> the current approach.
> 
> Sorry, this is not how upstream review works.
> 
