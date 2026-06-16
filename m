Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B3837B030;
	Tue, 16 Jun 2026 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781639792; cv=fail; b=eaxUszLEOSJebGUMesCS9dDxA86klbrGkpZLIGK/cGytOr1PRCwXdj9ahSPMhj2pCB3A1yrogpnpc89ah/Eqmx7bn/CvmN0YgjI6Su//xUdj/cbYYrbtmzTQ0/mtWMzuK/w5rI8Gekb6fNSnX5DxJAx+d4GZQI6JxBwL4Eiy0+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781639792; c=relaxed/simple;
	bh=yZSPwI5Fe1MbJAwJ+Rms4tFEKk5/P1YwIu7gAvzt/rU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uJ+peMJ0Ob1R7bD/u0Vt54G7wStoLE4bLLv1vlirLkUdEvZqhVmo84d93wF7acZex8nKeDim3wxdObL6gz9IFKlFyyJe68zA7TH8NkQ3nVALPh9Cs3zmkixvTapToE1V3ldoFtHkiGLonSEOTZ1T6DvMVNKIXAH9vEinWmbRsgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hhBnxhzB; arc=fail smtp.client-ip=52.101.61.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hhBnxhzB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NkYOFCgjYn7PFSqs4RUNDrGztfUSBRD3mhggoAudu8ZdKtXYnzf0JZl6CeSbyahiMwS98ChViS8EEi0HuXb82KU0AJPpcvV2nkBC0YZHWVUaF5+N+300x/dY6d/1OjQLnwsCdMP/qI0J0PMNXjohRziNNEP2/U6nzhHV1BEmSkmLnhHfBQ3cI9GDHSQTEWcoEGFC82k35CfpumLu2goMgv0HbSgqNbGHTudO5xDCQNa8DwopR8PkUCCXr7/1LsV9wwcJqpppl9UCFljTp91vzsRMZa73C3tgcrGaDAwNn0oSz8N5gRFvY8qWPiGC1dMQDWH0ewIRQIvrHOYL1bYiSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWAeFW/Kypu80ln5WAgrVfeJCfaMVo73VRMrrZd/zAo=;
 b=C2PIhaG+vLMIMVe0C2OcG9qPUhGLFc8i+Yz/bC5Sp45iBUu9xDJTC+OydIRd5o/K+F4eLAYWKhLljoY+zXELwV1tBfBLoFPgTjAzZrmUEbFXaD0LBf9Nd4UWm3idvQrwPGVGZKIq3SLv856yLwj0WK+bWN7RWHXUj9MWpheVK8ygH+CUSL0tkGXOnOhIeet7LP0JBpAwL/SUBkmZqjWe5ljLx77ge+QqPshZFrsL4lXfQFGa7HqM2HmXfLY3XQMK0lLOGWpnaLpbGjlIZUyiJcQO73PzKgltKNMtS543rqalt1MI0NmXsTIDaPyBCnxOILwKXgiQ+Hvcw6ziiO+8UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWAeFW/Kypu80ln5WAgrVfeJCfaMVo73VRMrrZd/zAo=;
 b=hhBnxhzBtvWItU2eUpmpXU5cS+dUCuixFVJg4RdjxGmzRZ7PGdUyKZt/6/lCU7ZjoMUG6bLMOcX6LBZIgXHK7nyxtJTecA8XlsD5Ab7cJ3XuBLz4YfB9lXQGFXUGH3Qtz5bi5hiQ0URVwQ0816MfPWrrcCUxTCVtvjj7u3AztLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM6PR12MB4449.namprd12.prod.outlook.com (2603:10b6:5:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 19:56:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 19:56:26 +0000
Message-ID: <8c5f4082-e3a5-4f65-b058-33938a7ee324@amd.com>
Date: Tue, 16 Jun 2026 14:56:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] x86/sev: Add support to perform RMP optimizations
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
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <de274c2fb3f794ff1f19f0c96184ee50d04d1282.1781419998.git.ashish.kalra@amd.com>
 <0fa0bc95-ff31-40c5-b083-3c885d09d0ab@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <0fa0bc95-ff31-40c5-b083-3c885d09d0ab@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR14CA0056.namprd14.prod.outlook.com
 (2603:10b6:610:56::36) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM6PR12MB4449:EE_
X-MS-Office365-Filtering-Correlation-Id: 034340e8-2b05-4b10-9037-08decbe15913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|23010399003|921020|10063799003|3023799007|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	Wp7Av7kGyTzFeWhxt9d1i4oAHS/vV+3c1Q3sDapXpp5Ws/+wuUuRTito5h+dLQaC1zkeltUuencvj1ORbhDL+fno3LXnvCft2eFnVGWVXrlekP2knKkepLxBLapiMg5JbAR4ZoQlxS/5uwwjZPp+GIvGoO1reafdd8rpzL25FGa1+Bj8CPMQ+M6qOuKYJQzMj5gmXd7zshe2aqqV0EPScKd/CgnuDnVkoM7/0iOB2EWxEZA15xXisjVU6QShbf0GGbZAh5mI1hMV+yIDeDZesybrRe1yyQ1V+5OiRHs+fvmGYIQC2LxYOVUy8/fT4RfaOt9fPqrAsLjCovXIsduPegbCuffjHTFho5Tgsbi+q+jsAZ5PtfWlYKguSTvu4tpAEM4E0da0DsYG0zUoYZR4f6p/mVEMaA+fumHdLls45mRiJFpOg6I5a5OmVBWN2GXdTMI/9ZZNiKTbgVnlfqPLe2K55tD73/zC3L/7v6+xqadODrTZnne5GhfEjwkmFGToH9cpkxD7J3maCBURBLeDQkkfVWlGIMbx1yf9fw/TuH2IJsxh5t+LVGCr/fc6b3sfvdZYSk7pf00qzgr+fu4xVLuGhNVBuvIoHbWkfZM/NurhvDwpIanWryhnP1rzF041Ycj1WbHgMhJ+tz/aCaOgrznKl7xZvRwU93/luWLpjpslWgDNFvbmtg3lvAhSQfkPEYEtiCiiLD8h/rWqAkBjRffN5ZLp0lQZU6tda+y/TvY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(23010399003)(921020)(10063799003)(3023799007)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aC9iNGplTDR5bDB1RjRZSXA1U2dLeUhOQzF5WjNnd3FqaWZ0NXFrUWMyVnl1?=
 =?utf-8?B?MXdLS00ra0xaUkFNVFNJMm81Rkg0MXRLT2ZoaHBydGFxU2lSOWlobFY5aERw?=
 =?utf-8?B?WUNjWWZHSlBad01wSkUrSXBWbkk1YnkrVEZsYTNKNU1RYmE4NTVKVmhuU0xU?=
 =?utf-8?B?REVyb083QnpmMDdnb0Jka1BtSG8ydWlYQlIrcVZFOEJDNDlvZ2dTWVhDeUo5?=
 =?utf-8?B?L1ZTVWJzMzlzamtLZE8zQm9kV1htS1hvRW1Ma2xVbTBta2lwMWpUNzZ1dzFV?=
 =?utf-8?B?ZGJkNlRwS3lPTWF0MmF3ZlNlUUxIUzBZdVpFb21xbmVUOE84aDVCT2dPbjhH?=
 =?utf-8?B?OWZCTUw2c0pQWk5OUE80VVo0ZlZZdm1CK3B6S0xJYS9waGc2SElIZGhxQlg2?=
 =?utf-8?B?OEQ3a0Y5VDEvVXZZL245NEVkR0orbHNvMnM5anV1NHJMNFlEQmFGejNodzAw?=
 =?utf-8?B?UFA0eGhJOVFOVGZYQU8waUl2bVdLTjdrSk1jUmZHcDU0ZWpwZWV2QXdHTEQ5?=
 =?utf-8?B?VG8yeEF5SmpodTAyaE15U3VXSmhJbUZUNDdkQ0JrNmprZjRVZHFqYTdkcGR2?=
 =?utf-8?B?SkJjYzZVdXhwMVBaL0duYzhKZWt0N2tacXRzbEd0UlNJc0ZlRTF2VnhsdjND?=
 =?utf-8?B?WCt4V3ZTcGpPR1hQV1AyNkViclNnby9LSENlZ1hSUGlaT1huaVVCMktaRXVs?=
 =?utf-8?B?TmI2UW40T3orNjZhUTN1aXB3VnJZcWxrQ3FNQi9ZazdKeVpPeVp4OWh0N1NM?=
 =?utf-8?B?N0cvMlhVTzJVVEMxcjN5VStGS3lYbm4vUkdNeVVwcWg0VkQ3Mm93M05SdXM2?=
 =?utf-8?B?ZVB1UHFNTkxUZURpQ1RkY1ByN2FjalZ6OTgySDhKcVZWUmI0anVmWVZONERn?=
 =?utf-8?B?MFBXOGlFWks2bHF0dXlDSkgrMmg2clVEQ25yK2dlcW51OU85cW5sSUxINlJh?=
 =?utf-8?B?dlNHN3E4ejlhV0JxZkYveGFObmMzdUlBLzVudmlXVi9qTHZqV0FSYURaYlMw?=
 =?utf-8?B?ODRtU3VCRGdpcG9mRVg0WFJZTnlHU0tEc0d6UHhJR04xMkJjRGFaU2lMNzZC?=
 =?utf-8?B?SEZFam92Z01HTERUVFVXV2xvS3ZzOUowL0x5NTI1TU53NHlnSWxneHRwWURy?=
 =?utf-8?B?YnRPd2V6SnA5WEhxcnREa0dWc2RGYTdMWFFhQmVoVWx3bTl2Sm1tWlNIZUlQ?=
 =?utf-8?B?ZTBFOC8ydkt1Zkl6bldTVlJJQk5IcEdUUXlpY1ZrZnhXMzFFWUxmeUVPUVgz?=
 =?utf-8?B?Z0FWb3NUaUlKTmZlUFYzL0JjbUlwNlpJUDdNNFYzd20vdGJlWFpvWmFoaTRx?=
 =?utf-8?B?ZFIzUFR0YXZCKytrS2ovMDBxZlZBREgzUFFNUm1iZnBKWGtwdkYrYVFJd0hG?=
 =?utf-8?B?dUVxNkkzb0I4OTVkL0NiRVAxU1l3Nyt0UzRaYkNkWWpLeVplaVVOL1dtMGM1?=
 =?utf-8?B?VXg0TWgwdmV6R2hReEV1Y0VMbW9Wek1qaWVoZlgwQkRGWmoxdm43QzFRMmoz?=
 =?utf-8?B?WEhQOFhKRUZwNzkvSUR1WTRZekRkc3pwVjRCbGZsd2c3MTFEUTJXMit2ZmJU?=
 =?utf-8?B?SFVlMUhPWDFYV21OSitYelJvVGxPSTAyWXZsZWtueDduMGtaYytsRndrWENw?=
 =?utf-8?B?cGo5bzBIVXlaOS9uOEZyT0xROC9udUxsUFQ5bGsvTldZZ3ZPQUFIVGlPRW8w?=
 =?utf-8?B?T0V3UUFUSWFlUm9zL2ZEbnVUNmlVVHFlQUNNN3EyQ2FBeUN5TUhWVTRieFNN?=
 =?utf-8?B?ajV2REtUOWJZQ2dQSVlDVWFNN3FUcFo5U0hsSW8rQ0VOL0N1K24rNUE3OEtZ?=
 =?utf-8?B?R2c0c1pVOVlJNmwwV0YrY3JpNE8vaTFLM0dDVE5yeHhZbzRPUVlvNjhLa0hp?=
 =?utf-8?B?WUV6a2RHclVWS0hKQTRabmhHc3dGeFdVWXh1bjlvcitpbnRxN2padWlXV0l5?=
 =?utf-8?B?c2Z3L09vN1FadVByVXVwMVJWOUhQMnA4eUhpUFpmc1NPRjZHbTdKQjJJSHF3?=
 =?utf-8?B?VEFYOWlSVjZjQkNhK25idDNpTTJyV2QrQmFtTzFDaFUvS2pmNGFYdW96SVQ2?=
 =?utf-8?B?QXRYT0NDaTJRN1ZLTFFVUGtGVTh4S0FmK0NDWkJuN29pNEtzWWV6QWpkbnRC?=
 =?utf-8?B?V2lSanh2ZS9qSmllWGR5TW56UUZJdm9ISCsrK2VETFFkU3QyeWs0bGhoWjdn?=
 =?utf-8?B?QjRidmJKaDdoUmhaVXlhNmtoRjNXNHBzTG1oSTFHZmc4UWVsOWRYNFh0Qytv?=
 =?utf-8?B?Sld0RU5tVFZEdm9TY2hLOElDam8vaGxTUnlGNDN5c1JaUnd5amZJSHZsblpQ?=
 =?utf-8?B?QXBtcGJna3pJQVFhcVpzb0wvTGIzbDhhZVVsaFRZckhsVnI2V3RtQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034340e8-2b05-4b10-9037-08decbe15913
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 19:56:25.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UxvI8HbljayIEFYf6dRAQGGMtZlHlkwLfJPgTOiGe4DnraD5ErYj9H2gY6LE08ZS8BTCKNbuiguTjjzqD+HFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4449

Hello Prateek,

On 6/16/2026 2:27 AM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/16/2026 1:19 AM, Ashish Kalra wrote:
>> +	/*
>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>> +	 * reserved processor memory. The RMP scan is the most expensive
>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>> +	 * if they can see a cached result in the reserved processor memory.
>> +	 *
>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>> +	 * on every other primary thread. Followers are "designed to"
>> +	 * skip the scan if they see the "cached" scan results.
>> +	 */
>> +	cpumask_copy(follower_mask, &rmpopt_cpumask);
> 
> rmpopt_cpumask is constructed after hotplug is disabled but ...
> 
>> +
>> +	/*
>> +	 * Pin the worker to the current CPU for the leader loop so that
>> +	 * this_cpu remains valid and the RMPOPT instruction executes on
>> +	 * the correct CPU.
>> +	 *
>> +	 * Use migrate_disable() rather than get_cpu() to prevent
>> +	 * migration while still allowing preemption.
>> +	 */
>> +	migrate_disable();
>> +	this_cpu = smp_processor_id();
>> +
>> +	if (cpumask_test_cpu(this_cpu, follower_mask)) {
>> +		/*
>> +		 * Current CPU is a primary thread in rmpopt_cpumask.
>> +		 * Run leader locally and remove from follower mask.
>> +		 */
>> +		cpumask_clear_cpu(this_cpu, follower_mask);
>> +
>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +			rmpopt(pa);
>> +			cond_resched();
>> +		}
>> +	} else if (cpumask_intersects(topology_sibling_cpumask(this_cpu),
>> +				      follower_mask)) {
>> +		/*
>> +		 * Current CPU is a sibling thread whose primary is in
>> +		 * rmpopt_cpumask.  RMPOPT_BASE MSR is per-core, so it
>> +		 * is safe to run the leader locally.  Remove the sibling's
>> +		 * primary from the follower mask as this core is already
>> +		 * covered by the leader.
>> +		 */
>> +		cpumask_andnot(follower_mask, follower_mask,
>> +			       topology_sibling_cpumask(this_cpu));
>> +
>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +			rmpopt(pa);
>> +			cond_resched();
>> +		}
>> +	} else {
>> +		/*
>> +		 * Current CPU does not have RMPOPT_BASE MSR programmed.
>> +		 * Pick an explicit leader from the cpumask to avoid #UD.
>> +		 * Use work_on_cpu() to run in process context on the leader,
>> +		 * avoiding IPI latency.
>> +		 */
> 
> ... this_cpu is neither in the "rmpopt_cpumask", nor is any of its
> siblings on "rmpopt_cpumask".
> 
> How does that happen?

Actually, this was the implementation before the CPU hotplug disable enforcement code was implemented and added in v8,
and i should have fixed this rmpopt_work_handler() accordingly for v8.

With the enforced cpu hotplug disable support, case #3 here (above) is now dead code, and removing it lets
cases #1 and #2 collapse too.

snp_prepare() requires cpu_online_mask == cpu_present_mask before SNP init — so when snp_setup_rmpopt() programs the MSRs, every
core's primary is online -> every core is in rmpopt_cpumask.
  
So now the work handler always runs on a CPU whose core is programmed. topology_sibling_cpumask(this_cpu) therefore always intersects
rmpopt_cpumask -> case #1 or #2 always matches.

So i should actually drop case #3 here - which is: "this_cpu is neither in the "rmpopt_cpumask", nor is any of its
siblings on rmpopt_cpumask"


> 
>> +		int leader_cpu = cpumask_first(follower_mask);
>> +
>> +		if (WARN_ON_ONCE(leader_cpu >= nr_cpu_ids)) {
>> +			migrate_enable();
>> +			goto out;
>> +		}
>> +
>> +		cpumask_clear_cpu(leader_cpu, follower_mask);
>> +
>> +		/* Release migration pin before work_on_cpu(). */
>> +		migrate_enable();
>> +
>> +		work_on_cpu(leader_cpu, rmpopt_leader_fn, NULL);
> 
> This creates a delayed work and also waits for it to finish execution
> which will add more latency than a simple IPI if the comment about IPI
> latency above is accurate.
> 
> I think there is some corner case in construction of the
> "rmpopt_cpumask" that requires this not-so-pretty else block. Can you
> elaborate why this is required?
> 
> Perhaps the "rmpopt_cpumask" construction needs:
> 
>     for_each_online_cpu(cpu) {
>         /* Nominate the first CPU on the sibling mask for RMPOPT */
>         if (cpu != cpumask_first(topology_sibling_cpumask(cpu)))
>             continue;
>         cpumask_set_cpu(cpu, &rmpopt_cpumask);
>     }
> 
> 
> and all you need here is:
> 
>     /* Do RMPOPt for local core */
>     for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>         rmpopt(pa);
> 
>     /* Skip this core from concurrent RMPOPT */
>     cpumask_and_not(follower_mask, &rmpopt_cpumask, topology_sibling_cpumask(cpu));
> 
> No?
> 

Yes, a simpler implementation will be like this: 
...

 	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL))
                return;

 	cpumask_copy(follower_mask, &rmpopt_cpumask);

        /*
         * The current CPU's core always has RMPOPT_BASE programmed
         * (snp_prepare() required all CPUs online at setup and CPU hotplug
         * is disabled while SNP is active), so it can always be the leader.
         * RMPOPT_BASE is per-core; exclude this core from the followers.
         */
        migrate_disable();
        cpumask_andnot(follower_mask, follower_mask,
                       topology_sibling_cpumask(smp_processor_id()));

        for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
                rmpopt(pa);
                cond_resched();
        }
        migrate_enable();

        cpus_read_lock();
        for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
                on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
                cond_resched();
        }
        cpus_read_unlock();

        free_cpumask_var(follower_mask);


 Here, the leader exclusion must use the sibling mask, not clear_cpu(this_cpu). That's why my collapsed version uses:

        cpumask_andnot(follower_mask, follower_mask,
                       topology_sibling_cpumask(smp_processor_id()));

  - If this_cpu is a primary: its sibling mask contains itself (the primary) -> andnot removes this core's primary from the followers.
  
  - If this_cpu is a secondary: it isn't in follower_mask at all, but its sibling mask contains its primary, which is in
  follower_mask -> andnot still removes this core's primary. 

  So either way the current core is dropped from the followers. (The old code needed two branches because case #1 used
  clear_cpu(this_cpu) — only correct when this_cpu is the primary — while case #2 used the sibling andnot. The single andnot works for
  both cases).

Thanks,
Ashish

>> +		goto followers;
>> +	}
>> +
>> +	migrate_enable();
>> +
