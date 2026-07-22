Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6A13B7B70;
	Wed, 22 Jul 2026 19:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784749423; cv=fail; b=DoV5uq/GN9UkWECO02CLu3lO4m6S41H+leu42/Xq1t16MmapmRHOpWU//Kz5t04qVXwQPRN30vrJmJowC2M2AL/gdB6ZcNN7aMhY10yNS+4JNIQqgztFbgA51ZHQDIvgyyn4IjHcwG95nxwV1sR7hNOBQpBjud1BiC7Di0SRwGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784749423; c=relaxed/simple;
	bh=Hj4HrDD0nh1ayVqld+5JFonegNxrMc6eLe3INw/ZnRk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KLT+SPM4S3eXhDYAJ9J3EvLWYVjylf436v7TmO1YF47gXeoFeFybSJLd301S80iZYOo9XNzL84pb2C20CASuUhrBAdTkTXYmfUzXfMBmR92Gi0vRmkaXvEsvU/aP0iA8hsmUrp7UWK1o/uDRsQ73yCT2gGrB3UgZ2XWeoTULZFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=apk7AyoU; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="apk7AyoU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iaM/jDzTvuBkrhB48i9HY2RGWCgJMdKftwJnFrvbZbhjW41kUqCfm5FiTiMQFRNr+GjvypTFggkfNKoI+oky3IulScGGrHOgJ1NIyQMOACk9sD06QNdYdfVeP8IMgDTXMhHghdQ6MbuZyVhrOUJEesNJOy+8Dg9oTu3i49PivE2OZfp83ywDvU1kBbRT4IL9/wkFvBExjxbntH3wOG0mmni9+8+f119w2ModBPcUN1mzYtTT/RvvMj5uk44Ix3biIDCudvUdwjwzpxoGMoIjWSjZSnK7kW7DsjI/xFTrJJs8c1WnU0E97o/Da2pzP57jO7Rrk2cKaP//g5UukDFgKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZivwGl12IVljTl1IsizBPOO8etDpEi/Ut87p/ODyW3Q=;
 b=uF0MoMCGwBgsvsjEpB5pkADPEvWw877hSg141kjbCm1rS0izzUt5mG1daYC+C0KBrZII5wLeYnRoI2APUVB4ZNytC5wd5AWx3yl8fAl7Th2WAXijU1UaUfiWWYrb5nPl95kr8zlQttztMB65+p/7rMlxL63renJtCVCjqnLJ4xrhuH6lbVljQOwHvdVsZB6VreD9dGRCa7O2MdpQBR32tliYrK2/uYtA4IYx0810AroJuQi2lowlTESiDWj24/1XPAGK952pvqPpXhgMhS2Qj2I6zRrr0a4hCBjF8ZQHC47x4ML0cuBZJAQ3/qfhV+xg2T7iKEnGL1aco8AP+JEATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZivwGl12IVljTl1IsizBPOO8etDpEi/Ut87p/ODyW3Q=;
 b=apk7AyoUSGFtr0HtcjOP1/NAbZcnYg7iH6swYnpsA5av/E0oKYa33aHRDNZCbEDfbA+E9auicMojTt29qa0VhHod9a+9dOYMqwuEDobrceCFRqgEMTbzIRoIbMhIFWxiTy2sT+fEAhEQyUNSadhP9YNrhswZp35duB44S8Bd5uA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 19:43:37 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 19:43:37 +0000
Message-ID: <d823a2b3-b6e7-4cb3-b970-7add385d1354@amd.com>
Date: Wed, 22 Jul 2026 14:43:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <ada64cdc976b98a70687b3a347bca0c25c89eb09.1782841284.git.ashish.kalra@amd.com>
 <e4aacc32-ac61-45cd-bf76-5442afc45082@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <e4aacc32-ac61-45cd-bf76-5442afc45082@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0190.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::15) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 881b1125-12b9-430e-8958-08dee82985de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|22082099003|18002099003|11063799006|4143699003|3023799007|10067099003|56012099006|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	jY0B8vaDAIWiQ1a2fpNRsAmNoCm/3mvtKVzy4W898CLPOmFtAUfebJg4mWzYiivdJcRSrtxfvzt6uiDHzDNbt7C41dSdlPx5f0jBdVbO3jRL40CVnBJTXeieldI0VKcRl6kzqG/2/CEdmNKR3muAD8z1QQaruDS+AgNLnUogxNgc9Bacq0Ab5jq9CvH2cbJ2tYM4mHguAv1fSiB9Wr5FFAp1C4LDfJZceJ7NpDRqr1WIzlhki88xV61+0zU7i83/0FFUeufcY2bb6b86gIxJ34v+dZdxmADRylHDWGwXtMbioNovKslQQ2dboATNSKH3ARPmKQvv9VYED4DH8TTow0S1xnaAUn2GSYPMgTyU/0KKuo8TRqqRryu1r2OmlxJeIqkGJj6KsmT5oJZ7BpqubdkEcFgswuaRs2m/Jj1huiDQE2njdNcLheRoicKD+A/nEwALWb8VmnR3NSwmhtrLtNNsEfVVt3PbUqb/Y/5FqlQQ3C60F+990RiinNrwzkf87No2g8XQLDJ+CVMNlvbvCouMWW30ZAgmonrUPuy9q77Kt+SLOJljzBYLke2FG1tXyh29CAyiwiPrjxT8/KCr5h5TRSsjlUkBlwNJwdaw9D8wKd0gHapP8/3JcC1EOYfqKG6SNf2xNKXg4G2pAMABlt91T+NcJUVQwJwImfRrxBzh7xOTjDd2TYeYsmHonRNGXmUTDWA/zEbE1EtgoqZYLg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(3023799007)(10067099003)(56012099006)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWV4dG5Md1pRdnI2RHR0bjdrSkVRYzJnWE56ZGtwTVluZHlrSWw4d2lIM1lL?=
 =?utf-8?B?RTFVM0lIS05BSDRLSDczb1pzLzMwN28zck0xMVc0VE5iQk11N2RFbCtFVE9H?=
 =?utf-8?B?dytBQW1iYUhJYW8xckdkTERCb0ZSZFIxamRiazJuaHdZcjlPRWhocUlzTDFI?=
 =?utf-8?B?S3VySVkzd1ozN3RxNW12Sm9LeFo4WUFXQ3BUZVRGNzl4OGhXdW9XTU4xRFJC?=
 =?utf-8?B?alZBaW5waUJyNTIvdUVNTEpHaHpoTHZRUkc4T01JQ2s2QzcxTVNzN2hPQTZT?=
 =?utf-8?B?TVZhUXhMTlRwMHRZSytjUnN6cmpscjZGTmdLcXd4K2s0bWR2ZHhsOHN0YjEv?=
 =?utf-8?B?U0xVMjlxTktINFQzd3N4T3JhS0tISHkyZWhuK2lzRmNWemZ3M3dtaXNBRzhs?=
 =?utf-8?B?TktLem15cVZZdWExRXpOK2g4YVdxcFNZcjdUek84MXpIdVBtMEs3NHlJa2l3?=
 =?utf-8?B?OFRuZkdlRzJzNjVoYzBlbHZEanhyaXhobHhIVk01d2FFT2Q4YVVRRFN1amt1?=
 =?utf-8?B?ZndEU2NMdk44c09JVnFQeU1rK2ptMDFoOXU1Tm5CMXB3MXB4ZXRIdDJPdVUy?=
 =?utf-8?B?Z0RQUVJrY2Q2WGdRTDQ2WXJMTVBvMTZCeW1aZXQ4ZEVaY084VzNZZmZkODZv?=
 =?utf-8?B?YmdHQnlhdHR0NC9VWkRvOGthTEhHOTRqT3ByTHZNdUx6SHp4aVE3OFUwalZL?=
 =?utf-8?B?eitXL2JLV0VkRThKOXcydVhnbDlRMzNhNFFHenQyRXNqNzgvdVNGMnBoNGJm?=
 =?utf-8?B?NmdtVXJCWlFxOWU1UTVXZkdnYnEwS1g0WFMySldmbERHY1p1b0xBSGNtMjlB?=
 =?utf-8?B?cHlpUTNWQ1h5MVk1c3dpNWZjbDRFN0FxcW9XeS9Pa3J2ZHZ4Z3dPS1dtUXow?=
 =?utf-8?B?U2orSnhmb2RoNXNZTlN1OHZIWFVPY0hTNW1iQ1oxUkpINDNGVjY2aVZ1MVQr?=
 =?utf-8?B?TTgxVWxKNTVPZU0wUzBucGJJYkJ2aGwxMFoyUHJNbk14eTEyOUxHN2VEUjJM?=
 =?utf-8?B?OHJnRzN4aWZOVm1lZG05a29tWmJaOStEbVdBNjUvMHhrTmRZTUFLM25FOU9k?=
 =?utf-8?B?bmhiV0hsT3E1b09sMEROSlFwTmhsS0pXZFN0TWFUNFpURXc3ZkowSWR2dzBx?=
 =?utf-8?B?d3pUUHV3M1VNbldZYnZFSkpLT2VrNlRjZi9rbnl6S21pMjNhUTc2eFo4cFhW?=
 =?utf-8?B?NndEV3hNb09CdG56UXFKWmV2c3h4NGRhL0xqZ0dybjBuZWZXaTNwUTFlUVRZ?=
 =?utf-8?B?M3ZkaHZ5VUN1NDJGam1FSUVRZHNSWTk5QXp3UDY2Vm9kc1FjOGVwZnFyY3M3?=
 =?utf-8?B?c25Uc1VUanptc1BLMmZKYlUvTWorNHROQ09TVU11NHo0OWpBT3BqM1hNblhq?=
 =?utf-8?B?UGtrMyt0cmNSeWpxeEkvaXgzK2dNczdqMVpVaDRHRGZuMWR2RGducnZHaGg0?=
 =?utf-8?B?RGlwdEpyMTB4MUlhTjVKb2dwN200SUE0cWJSdGRIeU9majZBbFppcS9pZGFO?=
 =?utf-8?B?YkxQTUFQNUZSRW9KbmhHRnlWZ251bldtMkVZcThGajNqK1FUcC9MNHBLNnps?=
 =?utf-8?B?dkp4ck9IUXh5VS9WT3k1eWZBclRzeGVBSnk5eHcwL2VRU2VDcjdLYTVOQ2VP?=
 =?utf-8?B?VEdKN0JLeTlmcWxFbStSQXk1MktZUUk3ZWMyaHRKc01GbmFOcFhZRVJubEl5?=
 =?utf-8?B?RFY1Mk85eDVDc05YS1VhTGNwYUY0TEJYR0poemFBSVVrRjBCY2lGVnFnUnlF?=
 =?utf-8?B?UnVOeThhMk5TZEYrK05iN0lPc2tuUlpNelRMdkJNclVVWDhnMEZhSHJtMG14?=
 =?utf-8?B?Wk90S2RZc0R5VUwwdHN3UG5UNWRSTDJHMWhVd2hFY1AyQ3RzQmp1YmRqVkdi?=
 =?utf-8?B?QlZlSkNBZnR2dEh1eGdTdlk2Zi9WMHgwN1NDWFJzb0kzdXljMHY3Yk5CL0Zu?=
 =?utf-8?B?RnpwU1lxMWVJVUVoL1Jsb29YMWNQdzUzOEhwcVhvdVd6U3pMeEhvZDBLWHlz?=
 =?utf-8?B?ckVMblMzUFBLWFZHSlE2dHVQamhGMm94SWEwNWV4UGZubjNxU0ZPYnBxZVJB?=
 =?utf-8?B?UmxUVVlvbjNyalpCWFdYck96ZHBVdmo1ZjkxVlk4RmVKV25jSzRocDlYcFpE?=
 =?utf-8?B?RG11eDNjZ21ndFIvVDZWRU92UDNRZndHbHVuYmdhaXBoSnM4WGRqNWpyNm1a?=
 =?utf-8?B?di82SGFvQU43bkwzLzkrMzk5NUh3aGxBZHE1VC9mTFdiWjc4dGR1b3ZYVXF3?=
 =?utf-8?B?aXpsM1JGUE4ySkVtRVp0NDVHN2NmRkxZM2c0c0QyRHhCM2FUb0hTUzNZbk1z?=
 =?utf-8?Q?9ESYKa/MWUyAm+Fgb1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881b1125-12b9-430e-8958-08dee82985de
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 19:43:37.2652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVFZwlg9RzcjB5mqM7E6a8pnRIhdUE0qTEtNPzdo42mR7IVZ2N3ioQhU9wZdLovXx4OvRzQNIAg8QAQsE29t/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Hello Prateek,

On 7/21/2026 10:06 AM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/30/2026 11:41 PM, Ashish Kalra wrote:
>> +	/*
>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>> +	 * reserved processor memory. The RMP scan is the most expensive
>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>> +	 * if they can see a cached result in the reserved processor memory.
>> +	 *
>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>> +	 * on every other primary thread. Followers are "designed to"
>> +	 * skip the scan if they see the "cached" scan results.
>> +	 *
>> +	 * Pin the worker to the current CPU for the leader loop so that
>> +	 * this_cpu remains valid and the RMPOPT instruction executes on
>> +	 * the correct CPU.  Use migrate_disable() rather than get_cpu() to
>> +	 * prevent migration while still allowing preemption.
>> +	 */
>> +	migrate_disable();
>> +	this_cpu = smp_processor_id();
>> +
>> +	cpumask_andnot(follower_mask, rmpopt_cpumask,
>> +		       topology_sibling_cpumask(this_cpu));
>> +
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +		rmpopt(pa);
>> +		cond_resched();
>> +	}
>> +	migrate_enable();
>> +
>> +	/*
>> +	 * Followers: run RMPOPT on remaining cores.  CPUs cannot go offline
>> +	 * while SNP is active, so the follower set stays valid across the
>> +	 * scan and cpus_read_lock() is uncontended.
>> +	 */
>> +	scoped_guard(cpus_read_lock) {
> 
> We can only reach here after disabling hotplug. Do we still to hold the
> cpus_read_lock?
> 

Right — hotplug is disabled for the whole SNP-active window and this work only runs while SNP is active, so the follower set is already stable.
I'll drop the cpus_read_lock() and document it:

        /*
         * Followers: run RMPOPT on the remaining cores.  cpus_read_lock() is
         * intentionally not held here: CPU hotplug is disabled for the entire
         * time SNP is active (see snp_prepare()), and this work only runs while
         * SNP is active, so the follower set stays valid across the whole scan.
         */

I'll also trim the matching sentence in patch 3's commit log ("ensures cpus_read_lock() in the scan is uncontended"). 
 
Actually one of the reasons, why i am still holding the cpus_read_lock is that Sashiko is likely to flag the *bare* on_each_cpu_mask() as missing
cpus_read_lock() — the comment above captures why it's safe, so the reasoning is in-tree if it comes up.

>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +			on_each_cpu_mask(follower_mask, rmpopt_smp,
>> +					 (void *)pa, true);
>> +
>> +			/* Give a chance for other threads to run */
>> +			cond_resched();
> 
> Ever since commit 7dadeaa6e851 ("sched: Further restrict the preemption
> modes"), one cannot select PREEMPT_VOLUNTARY on x86 and cond_resched()
> is a nop with all the other preemption models (PREEMPT_NONE will not
> preempt a kernel thread; PREEMPT_LAZY / PREEMPT / PREEMPT_RT all make
> the kernel fully preemptible except for sections with
> preempt_count != 0)
> 
> You can drop these cond_resched() calls in your respin.
> 

Will do — with PREEMPT_VOLUNTARY unavailable on x86 and the remaining models fully preemptible, so cond_resched() are nops. Dropping both.

Thanks,
Ashish

>> +		}
>> +	}
>> +
>> +	free_cpumask_var(follower_mask);
>> +}
>> +
> 
