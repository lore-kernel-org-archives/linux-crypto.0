Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5611381B0A;
	Mon, 31 Aug 2026 20:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788206439; cv=fail; b=FKSJWJSt06CIXqbSrf+WenqxDmusJY5ypl5NDJzAnBAoZBygJHiKqoAzXtjm/71FT8/KSdjo3BkDvCccv2q4rGIIxcg1dtbv7Mh2lr+Flei18kTp9hfYs8QmfKPJO8iK0AqwaFFDINsUQg3c0oJp/LMY+sZFIaU2+7JSzlWk5bU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788206439; c=relaxed/simple;
	bh=YR8KT0fi1T0LPz1YZLI7B6WFUgLrJFemJRZXg4un4q0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZpC33d5KgTWkIFbuQ2OzHGnShIIzHxLE1NY77rolt2xw+PjZyhHzSND83Ih2WxUFdP3s24SR0634D1ceIjJF1/xYVRfTkigpLJeGR3hU1pREtXi+jAG2FqAEKQxIY7F8mSjnJUpXt+j7aXuqvI4nA9Z4y9tDQyhMWjyoOC4yiao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wW6bvJz3; arc=fail smtp.client-ip=52.101.43.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wW6bvJz3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cg5Mi4CitMiJaDcZCUaRNrUK2Tq3/bWiX+v5P8mkgupnhG0/vfJekuM28+4XyNQBvCe5abrMlxm2MIZ7NJ82IXC6289GWhZv6FxTdKLc0G+1kHyTCtJWGbo+aXWmPI0+rNgnEyYGyYtEVEjxjsHXzNvTNjDDhEZ6wfhgmu3pP+sIUlK9BTFWlSm14kidp274CrzLeP9HcYlLBbP3f22+eMI7OliawQEEbewvMs6ndselwirqoVNduVMbBqyaqKChsRvev3w9v6JAZ5soN4BXuvBCKBTwGZI8bbz2Xxb6kPNuhl4psu+JesDSOFoqoEfTa0/pHVSxxfL+3bdcGkF+fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jUFCCNkOnQLi9Mdn7j9yzUNAEcdX6KLzKkVJ1+Za4w=;
 b=oTeaWISZiofLrjh40kFcF3PxBdpMljt2fDBXkJkn/Q2sP7NtwrmJ391qVcUbt6P8x3xpVEhppBmAKwPQUv0nckOotdAKqJjpNJfl+mkst3+LqZh2adG9fPBb3rxBiIvCW3grfy4q6sNcDeIZ6Ma8XpZwDTe69yJw+wbPYWuJCSetyTJad6lUTu/Z0n3KRpOG2L+cb7eW8ojMqpCYdL+X9UTNbtYAm1avcg/QkUjsKgbEMzdkZg7z1M8nuZqGjUuK6vzrZKBIWxWqZqgiFjLs7SC0KxwHwrhs2ZL2va4oWNaycvujhcUXzLLDsV7/N8BSBEIOsJE9XC67hSPlqYCpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jUFCCNkOnQLi9Mdn7j9yzUNAEcdX6KLzKkVJ1+Za4w=;
 b=wW6bvJz3nZXVX3ATvYTboMDEsW0vGt/kV5/VbW5Hmavb9dEvxVpYkVTxX7kssURsf8nggfeikzZFoJRpY3VcXR8m8vdgNyvZzsBWVX3crINw20nswby3T4jpo03x864atK9m3Q1Ng53yEqsTRf5GwOmn5EuQmFoSMmVjumAi6uY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM3PR12MB9413.namprd12.prod.outlook.com (2603:10b6:8:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 20:00:29 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 20:00:29 +0000
Message-ID: <c699a686-dab2-4e7b-af6e-3ea89cbed202@amd.com>
Date: Mon, 31 Aug 2026 15:00:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 4/5] x86/sev: Add support to perform RMP optimizations
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
References: <cover.1786389115.git.ashish.kalra@amd.com>
 <9c9502278f68af9da19f0dd583ba303d0e6d66d2.1786389115.git.ashish.kalra@amd.com>
 <20260829205208.GDapNGeGMOs02IrkGS@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260829205208.GDapNGeGMOs02IrkGS@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM3PR12MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e406f8-866d-4da8-eb6a-08df079a80ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|18002099003|22082099003|56012099006|5023799004|4143699003|11063799006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	bIDZhLE1QF6czjKssCwEzzZsLAiIO4y7Zjkc70Lsn4G+yLLjq5i0u6xlYH2KcooluBGtSzzSeEz5AFB/PoQFSPOSutdnQ7yGMQQWuAbQcTMuFvQxKwCo1awfzc8GBFq6oAKBgv/9LEY0+fC9FvapWtoOc3whCOGdsxd3KTk9yacPt7d3XkvXNMQMAAVnDzHfSxZ8UPh68LbHExQUrBuG+96cuy5iqhbj9frIjmpYErwANVfLxVNaDOQ0Ne+fK2RkZf90VlZU1P79rkvSg2BLfRf2L6DZeeFVX5jriPDADR2V1JdeWwlONqWVoq3lU0y1L7mgi0Ll+BqhKWO1RPbiCvuRkcs4GghU6ng9CPntwYacUlZeKqPL2CkFSWmpc9Xfj8OL96yexrX+nhATi12SkZfXXzebu1VASsPoOx60KzKoHznl+mgf03pxe2VYiPuN0k1d8iv2FzOuB+ossAne6G08zRfjaVnlXunia5OCefe53MhHf6RINfLE9IF/q83CdsmkvW6tzI09+qREEKBWQnMv6wKInR+jQBc+KnqhpeV91491vDTQBdIulE5MXUOLu45SXrX6MQULuqGjWbldGnwPuOOEsfXXE8i5A6NT9XiCLv+T+zo8Boxa9K2DIWY3YrsyZNHfL3O3lEUzEw9S7pDoTEcJObvuPmY8PH+982w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(5023799004)(4143699003)(11063799006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzFHUFg2dHN0RmpGM1lLZXU1STR2SzBQSGkzM3UyN3ltSVlrcUg0LzRpeU9R?=
 =?utf-8?B?Q2FlQVJyWGpDU09IeGJkcWk4RTdlQXBFQndFVTRrUXM1NWdBUW1kcDNuOWpq?=
 =?utf-8?B?Q1N5NFF1em9sU1NjNS9ndGs0bm1hNk1ZNnd5aVJCMTlZL0xSanB4ZWhLblpN?=
 =?utf-8?B?dWdtak9jVGJkQWZNSjZML1dhNHJERGQ3aVZNNU1DdnlocDZEbVAydm4xQ3hU?=
 =?utf-8?B?YVhTUXNvcy9oNFdnWkJKQ29QTWZ4b3dkdmdJMUFBQ3NLY1BxbVJKRXFENEpi?=
 =?utf-8?B?OUNvOHZ1UlNrUkVTYy84T0dQM0xrUGZPWUJySmNFc2F5VGtPSHIxOVlCZ1Vo?=
 =?utf-8?B?WFhGS2VBb2p2bEVFUXgxS2lLekNYK2t1SEhyTElKRjRaYWtYWlJvRkRaQTFx?=
 =?utf-8?B?anp5SEo2QmFGbTNpeVBlY3N4ZEVhdCs5R1IwaEJ4YnhRVkkyVnBsM3lZWDJo?=
 =?utf-8?B?OVNwUFUwVFh0YVJSWCtkNnhRRkdDclljNi9wOGdBcjA5c0xPNENpUFVFVlpW?=
 =?utf-8?B?OUREKzc4M2UwMFdJSUc1NFF4YWRRd2Z2dU15NTVZL0VUZkpPT0VzZ3drcGg4?=
 =?utf-8?B?eFExTm1QWTU3ekIzY1ZUNmI3SUo1TjlyZlRXWStZcVB4YWhORmdkWVUzRXg2?=
 =?utf-8?B?TldMRGxCYWJJajk4bEF1YVpwdHA2bC9tcVRzTUEyV0VzS09BdS8yTXRlejNs?=
 =?utf-8?B?bGNCR1dSWVg4b2I2WGI4UUhXM2lNM0JpZTUxMzRUdEk2RHdTbWVrV0wrRW82?=
 =?utf-8?B?NDZjTGcyeHZ3emY1eGFLR3kzQzdVenBMcys3VlBxU09nNGxkN3lralhXeC8y?=
 =?utf-8?B?MzFGdkdVNjNRK08vS0RHTVYrUFVCbkJSd0ZOZDJVWEl4VE82QUd5TC8rV21W?=
 =?utf-8?B?cDkzRHlPa1ZDWVltOE41djI0TVdaMENJZGJ2NHIxbUljamdQdmVheHZ2K1Fz?=
 =?utf-8?B?dXZrNXowVlYxUGZodzBrUkw3L3FRMVZYTU11NFM5WVJtSXFiSXY1VGZCaVVZ?=
 =?utf-8?B?Q0liaFZ0N1ZYeFlBQVdLLzlnZTMyazhLNDN3bmwyNklBd3UvUTA0Y3BpOE41?=
 =?utf-8?B?TDM1TE05c1pHR2xhQmRQWk9hVWwzV2k1dnVINDlTVjg5TStPdUFidm4yTzhG?=
 =?utf-8?B?SGFSNXhYRWJUUTRJdzUzS2FJZklrRFZUM3BoTlA0b1pIcWRJNGo0d0ViZk56?=
 =?utf-8?B?SEo3aWUwb1U0ZEJUODdUUUk1WFEveGRVV2VuK2ZOQTB5TjBpTjJuZHVLTzUz?=
 =?utf-8?B?WVpUbUZrVG5yMk5GeTdEZzY5dWd1bXF3d292WXBLd1cxT1haUHlpUml6SmZt?=
 =?utf-8?B?Wi9DZVIwSEU4RnUvVEQ3bnRqNXdvYkQvUzUwSmh1WE9lUHRqZHNISzhTRXNO?=
 =?utf-8?B?cElrZU5SQVZiU2Y5WEtVOEg5SWJkR1QvbzQra1NEek5oN0YyZ3FsTHp3SzZW?=
 =?utf-8?B?V281WXRDMEEycFRTM0s2ZGZmSk01K2RJMXlkOERBaFV4aVNPRmEzd3RwOHE0?=
 =?utf-8?B?blZSUS85dkc5QSswRmNkWndHMUhpRmVscVZpdkh1ZDc1SzZ3TnpETG9ZVUVm?=
 =?utf-8?B?b2RKb3phTmtmOWU2R0xmMFR4ZHkrdmF4SGRnWE9HbXRWMjlwZXRZQnlDVUZ0?=
 =?utf-8?B?aDB0QVlyUnZYTURMY2FkeldPRENvNklVMjJxQ1FrRUpGQkdaR3hFdTkxK2pJ?=
 =?utf-8?B?Wm1KelBrZThQMVIrS2hBc0twWEJOWFpRQXJRamI0aXhjaCtPV1JUR3FqUUFs?=
 =?utf-8?B?WW8rMmkzWThkRndkT3owU2lVUjJHRDhpN0lnazBVUjZTaXVhOU1ubTF1YS9n?=
 =?utf-8?B?VTA1VEIyY1JJVHo2RTdnWTEwRDZIcXRPS1piMnJXMFQ3eGIzdzdMSlRjWEpv?=
 =?utf-8?B?d0RPT3FPU1E4elg1bWlkc3lkZVdkV1BBZjUya2owVDdZaXhKQzdDcFJWY054?=
 =?utf-8?B?dzR5cFlhek9JUWVvWmJvaTlULzgxbzBObWlDclQ3VlNqczZEZEdLcFg1c2V3?=
 =?utf-8?B?MDVrRnlaWnhMYlpPT0JzdlNYaFdSeG01RWJKYkxOYXo2Vk9sQW1wN1pnWnk0?=
 =?utf-8?B?S1lwN0xxa25iSGltcmtza1NmWkVSQ01wNGxOcGF0bGN6a2plUW9QRW9uc1A4?=
 =?utf-8?B?ZU9HWHhEM0FhUGY1SFJTNzVJWVdYUnY3dDRESklBblNFcnE5LzIzQ09TS2ww?=
 =?utf-8?B?UnQ5aDBUUFQvQXVIcWFiL29IWndOYzArQ1gvNkhpd2c5VVJwb3FtV2dodjNY?=
 =?utf-8?B?Z1o1OU1CcTVHaHhMYnkwVEZrVzhxd05iU3FLUDlLTzJSYVpVd0tnTVBnZVNi?=
 =?utf-8?Q?6ptYhZBpOb3wiFgCGU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e406f8-866d-4da8-eb6a-08df079a80ca
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 20:00:28.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d8an3nMPbBomqNWMGwCHVPXQwS+/rDh6T8Z+S7QM4/ApzeEYNaXnuc5bTcYCESJTsCEXtuoHI7qkTD9PYmyCyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9413

Hello Boris,

On 8/29/2026 3:52 PM, Borislav Petkov wrote:
> On Mon, Aug 10, 2026 at 07:22:10PM +0000, Ashish Kalra wrote:
>> +/*
>> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
>> + * memory does not contain any SNP guest memory.
>> + *
>> + * @pa is a system physical address; RMPOPT operates on the containing 1GB.
>> + */
>> +static void rmpopt(u64 pa)
>> +{
>> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
>> +	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
>> +
>> +	/*
>> +	 * RMPOPT (F2 0F 01 FC): RAX = 1GB-aligned SPA, RCX = op type, CF set if
>> +	 * the range was optimized (result unused on this path).
>> +	 *
>> +	 * Binutils does not support the RMPOPT mnemonic yet, so the instruction
>> +	 * is encoded with .byte.
>> +	 */
> 
> I don't know whether you've checked the binutils sources but this should have
> the version of binutils which supports it and I think there is no such version
> yet - I've pinged binutils team to see what their plans are.
> 
>> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
>> +		     :: "a" (pa_start), "c" (op)
>> +		     : "memory", "cc");
>> +}
>> +
>> +/* on_each_cpu() callback: optimize the whole RMPOPT range on this CPU. */
>> +static void rmpopt_scan_range(void *arg)
>> +{
>> +	u64 pa;
>> +
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		rmpopt(pa);
>> +}
>> +
>> +static void rmpopt_work_handler(struct work_struct *work)
>> +{
>> +	int this_cpu;
>> +
>> +	/*
>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>> +	 * reserved processor memory. The RMP scan is the most expensive
>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>> +	 * if they can see a cached result in the reserved processor memory.
>> +	 *
>> +	 * Run RMPOPT on one CPU first (the leader), then on every other primary
>> +	 * thread (the followers).  A follower skips the expensive RMP scan by
>> +	 * reusing the cached scan results the leader produced.
>> +	 *
>> +	 * migrate_disable() pins this work to the current CPU so it stays the
>> +	 * leader for the whole leader loop: this_cpu remains valid and the
>> +	 * RMPOPT instruction runs on it.
>> +	 */
>> +	migrate_disable();
>> +	this_cpu = smp_processor_id();
>> +
>> +	cpumask_andnot(rmpopt_follower_mask, rmpopt_cpumask,
>> +		       topology_sibling_cpumask(this_cpu));
>> +
>> +	rmpopt_scan_range(NULL);
>> +
>> +	migrate_enable();
>> +
>> +	/*
>> +	 * Followers: one IPI per remaining core, each optimizing the whole
>> +	 * range.  Each runs with interrupts disabled, but only issues cache-hit
>> +	 * RMPOPTs (the leader populated the scan cache above), so the window is
>> +	 * short.  cpus_read_lock() is intentionally not held: CPU hotplug is
>> +	 * disabled the entire time SNP is active (see snp_prepare()), and this
>> +	 * work only runs while SNP is active, so the follower set stays valid.
>> +	 */
>> +	on_each_cpu_mask(rmpopt_follower_mask, rmpopt_scan_range, NULL, true);
> 
> If the leader ran once and the results are cached, then does it matter if
> I run RMPOPT on it again? IOW, what's stopping me from doing
> 
> 	on_each_cpu_mask(rmpopt_cpumask, rmpopt_scan_range, NULL, true);
> 
> and don't care about leaders and followers at all?
> 
> Also, rmpopt_mask is cpu_primary_thread_mask and you don't need any of those
> gymnastics.

Agreed.

rmpopt_cpumask is indeed just cpu_primary_thread_mask: all primary threads are online whenever SNP is acrtive (snp_prepare() check),
so my online-filtered set is identical.

And yes - re-running RMPOPT on the leader in the fan-out is just a cache hit, so excluding it isn't worth the andnot + separate follower mask.

The one piece to keep (which your diff below *does* already): the single warm-up scan before the fan out - 

migrate_disable();
rmopt_scan_range(NULL);
migrate_enable();
on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);

That first scan is the whole reason for a "leader": it populates the shared scan cache in preemptible context, so every RMPOPT the IPI issues
is a cache hit and the IRQ‑off window per core stays short. 

And we drop the leader/follower bookkeeping, but the warm-up stays.

Minor nit with the patch below : with the andnot gone, this_cpu is now unused, so please drop it.

Thanks,
Ashish

> 
> IOW, this is how my cleanup ontop looks like so far:
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 55a6e2319899..a1f6f3111517 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -125,7 +125,6 @@ static void *rmp_bookkeeping __ro_after_init;
>  
>  static u64 probed_rmp_base, probed_rmp_size;
>  
> -static cpumask_var_t rmpopt_cpumask, rmpopt_follower_mask;
>  static u64 rmpopt_pa_start, rmpopt_pa_end;
>  
>  enum rmpopt_op_type {
> @@ -587,11 +586,9 @@ static void rmpopt_disable(void)
>  	cancel_delayed_work_sync(&rmpopt_delayed_work);
>  	destroy_workqueue(rmpopt_wq);
>  
> -	for_each_cpu(cpu, rmpopt_cpumask)
> +	for_each_cpu(cpu, cpu_primary_thread_mask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
>  
> -	free_cpumask_var(rmpopt_cpumask);
> -	free_cpumask_var(rmpopt_follower_mask);
>  	rmpopt_pa_start = rmpopt_pa_end = 0;
>  	rmpopt_wq = NULL;
>  }
> @@ -632,16 +629,9 @@ static bool rmpopt_capable(void)
>   */
>  static void rmpopt(u64 pa)
>  {
> -	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
>  	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
>  
> -	/*
> -	 * RMPOPT (F2 0F 01 FC): RAX = 1GB-aligned SPA, RCX = op type, CF set if
> -	 * the range was optimized (result unused on this path).
> -	 *
> -	 * Binutils does not support the RMPOPT mnemonic yet, so the instruction
> -	 * is encoded with .byte.
> -	 */
>  	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
>  		     :: "a" (pa_start), "c" (op)
>  		     : "memory", "cc");
> @@ -656,43 +646,22 @@ static void rmpopt_scan_range(void *arg)
>  		rmpopt(pa);
>  }
>  
> -static void rmpopt_work_handler(struct work_struct *work)
> +static void do_rmpopt_work(struct work_struct *work)
>  {
>  	int this_cpu;
>  
>  	/*
> -	 * RMPOPT scans the RMP table, stores the result of the scan in the
> -	 * reserved processor memory. The RMP scan is the most expensive
> -	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> -	 * if they can see a cached result in the reserved processor memory.
> -	 *
> -	 * Run RMPOPT on one CPU first (the leader), then on every other primary
> -	 * thread (the followers).  A follower skips the expensive RMP scan by
> -	 * reusing the cached scan results the leader produced.
> -	 *
> -	 * migrate_disable() pins this work to the current CPU so it stays the
> -	 * leader for the whole leader loop: this_cpu remains valid and the
> -	 * RMPOPT instruction runs on it.
> +	 * RMPOPT caches the results of a RMP table scan in reserved processor
> +	 * memory, allowing future invocations to skip such costly operations.
>  	 */
>  	migrate_disable();
>  	this_cpu = smp_processor_id();
>  
> -	cpumask_andnot(rmpopt_follower_mask, rmpopt_cpumask,
> -		       topology_sibling_cpumask(this_cpu));
> -
>  	rmpopt_scan_range(NULL);
>  
>  	migrate_enable();
>  
> -	/*
> -	 * Followers: one IPI per remaining core, each optimizing the whole
> -	 * range.  Each runs with interrupts disabled, but only issues cache-hit
> -	 * RMPOPTs (the leader populated the scan cache above), so the window is
> -	 * short.  cpus_read_lock() is intentionally not held: CPU hotplug is
> -	 * disabled the entire time SNP is active (see snp_prepare()), and this
> -	 * work only runs while SNP is active, so the follower set stays valid.
> -	 */
> -	on_each_cpu_mask(rmpopt_follower_mask, rmpopt_scan_range, NULL, true);
> +	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
>  }
>  
>  void snp_setup_rmpopt(void)
> @@ -729,30 +698,7 @@ void snp_setup_rmpopt(void)
>  		return;
>  	}
>  
> -	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
> -
> -	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
> -		pr_err("Failed to allocate RMPOPT cpumask\n");
> -		destroy_workqueue(rmpopt_wq);
> -		rmpopt_wq = NULL;
> -		return;
> -	}
> -
> -	if (!zalloc_cpumask_var(&rmpopt_follower_mask, GFP_KERNEL)) {
> -		pr_err("Failed to allocate RMPOPT follower cpumask\n");
> -		free_cpumask_var(rmpopt_cpumask);
> -		destroy_workqueue(rmpopt_wq);
> -		rmpopt_wq = NULL;
> -		return;
> -	}
> -
> -	/*
> -	 * The RMPOPT_BASE MSR has core scope. All primary threads are online,
> -	 * otherwise SNP would not have been enabled.
> -	 */
> -	for_each_online_cpu(cpu)
> -		if (topology_is_primary_thread(cpu))
> -			cpumask_set_cpu(cpu, rmpopt_cpumask);
> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
>  
>  	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>  	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
> @@ -761,7 +707,7 @@ void snp_setup_rmpopt(void)
>  	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
>  	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
>  	 */
> -	for_each_cpu(cpu, rmpopt_cpumask)
> +	for_each_cpu(cpu, cpu_primary_thread_mask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>  
>  	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
> 
