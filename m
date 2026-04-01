Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012069.outbound.protection.outlook.com [52.101.43.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CCA3D565B;
	Wed,  1 Apr 2026 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058432; cv=fail; b=BMEn5AQh/gaYfRicYhqy9Xk1co6UAoVP69leYZJVKfYT4OPYCffTvpKW27OPWK4iY6uPP/shW5twatNpjoTvGPxwfXMeDSsebcwZKDrZJCP0EM+3oF2GE2vH1+oaKAZ5DkeL5uH+8j1pVc0a5X/oOPpgqOoDwX3B2rwOkN3zW64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058432; c=relaxed/simple;
	bh=P3fahCrnxIcg+FmEs/RGVR3owe/294+8nL0eLLXijpM=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fYNkjTKzZRr8f19WFP7lPxwe5tUPc6RW+LTqUR5gxjOBoRml4uLZHOjG+rjFLiYplCfA1hyvOP5paDPmbXuJ5VcE4Yww0PFlkqFRWBXviblfIA6FZ+y01PXQ7A2nzF/TpukW+AgbA1xxGwMYqEEG7SmFjkm/F+MYq9wPSjY3Z0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PMzjBhIX; arc=fail smtp.client-ip=52.101.43.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PMzjBhIX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WgcnLQ/gbjVJvQY4LZK9tU3WNMwvHCnp32dTY70maEuUvTmS9ckUicP+MlrhZMpRShYBmFFugvLWWwZfV+3d605kYbxPPHrXef0xPT5mlmIzsWxx1bpNK0mIxEYpnXqp1V38mK5u3dc9n86wwnVlE29VLvxjY+Tyii7TSxf6M7f9qV7ez6t8gcsp8FB+Hk16Zybd8M4RLLFDlUKScYChc8iXCNjj2leN73JQ0ndL5lzPQTemJLqKtWY/FF9r12DvnVYQ4i41Y5IvUlzXMQOTlNU8gzYZtxE3sDhy2Cz79K+fQ6y8t3TfFQZX0RT3qowvDweTfcCYhS2rrh+da0lc8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EZc2bxyH15FlxL5FwLliB0fVLdcBMZZ68VG+lXsMuc=;
 b=nU6YvNtDVRzfn9GarZ/9ECUrTx+XUCN4y1ZjBpWwGQCSgrL2uSDmiUf8A66ehbNE7/1LuIVusg1HwvMhQMfWwJO9QJoFDMLc+wnRxQI9FjSGCMYxBJecGrsY6fQmm3wHPbBtXDPp94lUKX0U9q0MUrt5lLFVMUqW/OoiqqwAP0NK/DndMlwC427IFnSHf0qWjFD0xV487tA2lgoSVvHWcHLrwSFeAeAEGAFIk0wr5B5Nd8nrgjaAHQ46B+Ht3AVvX0tHe2h8BTxD6HSGelbJds3groRA2b/taHjPsmi8IJgrvtwQIAcFHMgZtWVfcQdh6gmaCN0dvp/qQqpqu4QHgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EZc2bxyH15FlxL5FwLliB0fVLdcBMZZ68VG+lXsMuc=;
 b=PMzjBhIXtkeFQdtqSbCa64zBA6RiiVCAq9mJbYVDBxxOIxo5mMYWJOETQsOslm1x0L1nR4jFy1p1xTfCHUCt0BT9HUGlES4zJZY3DxwHcbcXGwnrCbnjhvYAB14F8cIwwbrttUfBAEa2jXlnotsiRHmY+i4OyBEEcPc3+1ru2vQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY5PR12MB9053.namprd12.prod.outlook.com (2603:10b6:930:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 15:47:07 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9769.015; Wed, 1 Apr 2026
 15:47:07 +0000
Message-ID: <a1a5fa97-b067-4145-a4dc-fbb04fe9c720@amd.com>
Date: Wed, 1 Apr 2026 10:47:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
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
References: <cover.1774755884.git.ashish.kalra@amd.com>
 <6345df31337125280f91ad8f37843aa865fd85fc.1774755884.git.ashish.kalra@amd.com>
 <ab41b1d8-e464-4ad6-ac07-7318686db10e@intel.com>
 <e2e38a91-ef8c-41d0-9373-0fdb6f246847@amd.com>
Content-Language: en-US
In-Reply-To: <e2e38a91-ef8c-41d0-9373-0fdb6f246847@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY5PR12MB9053:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d7ed696-32b4-4137-bcb2-08de9005ed8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XoHfQ+LIIKfeKy2xivMN66rEIsPmebg8oV47o4OdXWssxMFGtprjfibf2FEdCmcTVJRCXiYTdL+mQAuh83lA+/p6XNF2pRd6k0u9ALiBlZ13OTDO6G+KIjcyR+WYI/Lo2+OIkrezs3S+XnBwOEEmiotVR9PfGlaEenLBEb+Y1w4E/8JWD0L8nKQxSAaWHFJsaAmfhg59aS7V7GJsA9zjTJO8pOUkPD6erenoR8SGuoy867jg4s3BtlPV5cJdly+Qi+FIprPPconJm1srulD4iYAxT6hPd0Hd+X4iZLHVrh52GotFSkvArUB4ypLEMgie8mSP0dZEuliAYH8JTN5XX9ONU0dk81pGscuY3KFbP1/0xy4eDWVae3is2muijMjlNhkibFYm/nvRhOGJxaPLJDcag2Y+xjcm+UFqic7XPg3Mu6sAldZ0yj1HqeYhZR78sZxDTsUc5E/ZoolTfljfE6EeHL4P0lsxDzqdi/r6J1//UuBiVAIjRxE6jn54Qj7yRh2zTlaD6mNk/VioHhvNNKgojQ6FF1XCQ04bQL/q5OTsv3JAYYDf41RNxonhyVf4Bz7iuUpLaqdOkhsjacKk9uGsYO67OPWlAoNZFX9WH+7Vo2WgLpKpeMDxRF9RgHHHEaPjiWyfOUm8MW0ORcexPhG18QGsNLYBv30w5Z+LSZF95+9o+MCtOqUNKLpMAnG82y89/tY8nICwnjEUo/zNDn+bnx28MRrMq5NEKpPajAZFsV5jx35YJLBhZegIqwYMmtYWxR/3El7zbPLcLw0htA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFBxdGVIbDhpR0VUZHNPNDQyNndpL3dwY2NjTmVLWDhaY1haNmZ5VG1hZ09N?=
 =?utf-8?B?eHdna2NUci9wNjY0aXEva2VyRnFIeEdxQzVpNHljNnV4OGpTZ3B0QmJZRUxz?=
 =?utf-8?B?MlZQRlJzSHYwREQ1TUJPUzhsMUxjM1A1THZKTlp5MXJoWDJLTDcxQ2FYcXN4?=
 =?utf-8?B?UjBUREhjWE41ZHNXNjdFMnJaZG9oQzZrbDJDUDFLeUZjUVllS3B2N2lIK0Zk?=
 =?utf-8?B?ZUVwM0hVdnZtdUx4NGpZWUowRXo0VjRvT1FqeWcrNjJDNHFCdm82bXNaTStn?=
 =?utf-8?B?ekpRcEdpcElmRnZ0ZWk3d2RrNGl0S2ltd2FpSElHa2tHT3JzZ1lhZUErWGJR?=
 =?utf-8?B?bGYyQ0NiczZQTGVuSER4RGdMTTREc2hXdkRlTmZZaWpFUXFKbFBSaDhKaEF2?=
 =?utf-8?B?eERIWkVTRENQZ2RlNkpseG5Ed25YYy9acVczVTkwRlBxS010OEg4TkNmcXpN?=
 =?utf-8?B?eE4xTzh5RDFUaXJlWDNIK2VyUE9KdmZIdFpJallrVjM3aHV1S0ZIczc3bk53?=
 =?utf-8?B?aGNieUE4MHhHYkgreFI1MEsrMFg4blAxMkVDRUphM2FwYndXazZ0L2ZTN2Ft?=
 =?utf-8?B?OTJDd3EwVldmWFRmMUhTZ0lZb2o0S0VlSm00UUVaZEdiTXBvdmpXbVFvZHBX?=
 =?utf-8?B?NTRISGFHZTFkOFRBSTdnS05CNGc2QkNUdTBXQ0pLeGJRY2thYlU0Y1dWaUgz?=
 =?utf-8?B?SmJrb1NBN0Ivd3Q3RXRMTU9XeTJadWhEL0xTMzlLOTZHMGpVTzRpeHd5dG41?=
 =?utf-8?B?UlU3eFlUdXRBYzduOTdJUDNGV0ptRHlDVXF2NFN0ZVdobmZ2QitjbzYydCsz?=
 =?utf-8?B?WnNuSTFGcE1iQWFKN2pUWTZIN3dwb05xeFRMS2owRnllbFhaeGlMeGRuWUJY?=
 =?utf-8?B?YS9zc3ZsdzJyblJ1dUJuampDRXk5cUNZNEo4RGJaWk1kMHFpdzc4ZG5wWkdo?=
 =?utf-8?B?NXFuSndwemZyRGNORElIYWxYalZDK3V0UXlValduOHh4d0g0WW9ucVoySUNZ?=
 =?utf-8?B?SDduejcvRG5kS0V2UFo0ckZDOFZKWnhhTFJ5TmhmZ2pGaXFUZ2dMNE5Kb0RO?=
 =?utf-8?B?RFMwek1vbUVXM2Z4cGVMaHpvREMwN3FLOTlwa01HdFhCM1dmL0JqT3ZkOGpF?=
 =?utf-8?B?RXEwazFpMFUrZUJKeityOUVVTjEyam1FY2c5SUJaU2RaZmlIR2VlQkVFcnkw?=
 =?utf-8?B?d3JqbFkvL2FMUzZTOVVyRlZZaUtzVVV5VnZtUVVTOGRSeGJ3Q0FOdThXTDgx?=
 =?utf-8?B?cDR6dllBb0tsRkNITTB0UWlJbDViSTlmN2VQdlVDZkVENGdDa2s2VVEySThO?=
 =?utf-8?B?bXZsZmQzaUtHZ3FJKzI3aERhS0tZQzBKbVhmRmpRblZaQ3FTelBRU2dUYmdT?=
 =?utf-8?B?cXVqM0g3UEVJalNSeEI3aTNvQmxlUHUwTkZXNGN2OFN1TWZkMzVWTlNqSEwx?=
 =?utf-8?B?bFhZVjRBN0FmdFB3VG9TZi94SG4vQXpuOXNycWVMc29McHVTd3lIeWVyY01l?=
 =?utf-8?B?Z1pubmZ5QTFlUUdlSVBPYUJValFmU0lyZGxOODhnSGtsMHQ2L0V4SXR2TytG?=
 =?utf-8?B?Mlhsc2VkUUF5ZFZYZllKWGN2dVZlZk9CQ0syeFVwRE1iazBXTExPdVNRbDlt?=
 =?utf-8?B?VUsyT2ZnQ294Q0FOZnEyeEJQTCtEazFmMDQ1S0lleUkvb2k4enRWc3JqL2dq?=
 =?utf-8?B?dzBMMUNuekhMVjYwSlBRVU1yYmlMMGRHK2prbDNYVkRtdy9tTzRINWVVbE5q?=
 =?utf-8?B?K0NUVFcydU05WDN3NHVZcjdpWWNDQ3R2UE5yeFFyWmJvTjZrNmJ4TU5wRzND?=
 =?utf-8?B?VmVVYXEvYVFRZ1NPRElWMzFMVEtkM1kzbmc0M3FpZG9MUXVpVXJJcWlkMWhQ?=
 =?utf-8?B?ci9uQ2hRRnlySndmUTltQnlNOE9vQWdaV0k2Y0g5cVdpN2ZJU3FYeVhNb0M2?=
 =?utf-8?B?Yk9HSmRlV2NyZjFDRUorMTFBdDZiL2pReTBxZTdjczhvZ0lGdkVhcGkwQUlX?=
 =?utf-8?B?QU5RSUxKYzRvODB2V1lLYk45dXVXblcxc3JGVXVkYXV5WDdIZTVOR250MGpx?=
 =?utf-8?B?Tk1tZWJEKzZ4K213NEtFcnJRTVRYRDQxWWxBZFFvQkdsaDlncEc3QW0yUXpp?=
 =?utf-8?B?bEx3ZEtQOUNmSGVQV0FTUjRsRXBiR0UwZndCOGlDY2hGOFBPbS9lRnB0T1FT?=
 =?utf-8?B?WUQ4RVBPSTdVTHh5YnRjZ2MvZVViTXBBeVcrL1hxWTViTGFXSk4wVzNBTWxp?=
 =?utf-8?B?N0FmalJZWUZDbHNmS3gyYitFSXBWYW5yL0hSa3RQamN5QWZUZFpHR1BwL0hz?=
 =?utf-8?B?Um5hMFRZQ1pnWUJaMjVRaUlPQXRNdS9kS1hXelFFeVhJRGhQc0tBZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7ed696-32b4-4137-bcb2-08de9005ed8a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 15:47:07.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRArw5bSO1kEUli2TuH8H0uy81HwCCk8WFmEsh8r8C0J1N1HAHtJJOuPEHqKYMQczplOXH2hujR/GhxEdMmUTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9053


Hello Dave,

On 3/30/2026 7:46 PM, Kalra, Ashish wrote:
> 
> On 3/30/2026 6:22 PM, Dave Hansen wrote:

>>
>>>  static __init void configure_and_enable_rmpopt(void)
>>>  {
>>>  	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>>> @@ -499,6 +582,37 @@ static __init void configure_and_enable_rmpopt(void)
>>>  	 */
>>>  	for_each_online_cpu(cpu)
>>>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>>
>> What is the scope of MSR_AMD64_RMPOPT_BASE? Can you have it enabled on
>> one thread and not the other? Could they be different values both for
>> enabling and the rmpopt_base value?
>>
>> If it's not per-thread, then why is it being initialized for each thread?
>>
> 
> Only one logical thread per core needs to set RMPOPT_BASE MSR as it is per-core,
> so i will use the "primary_threads_cpumask" here to use it for programming this
> MSR.
> 
> Just another reason, to set the "primary_threads_cpumask" here in this function 
> and then re-use it for the RMPOPT worker.
> 

Coming back to this ...

For using the "primary_thread_cpumask" i will need to use something like
on_each_cpu_mask() similar to what i was doing in v2.

In v2, i was programming the RMPOPT_BASE MSR using on_each_cpu_mask(),
that required using a callback function to do the WRMSR: 

+static void __configure_rmpopt(void *val)
+{
+       u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
+
+       wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+

+       on_each_cpu_mask(cpu_online_mask, __configure_rmpopt, (void *)pa_start, true);


But, that required using the (void *) casting, which you objected to and you 
suggested the use of for_each_online_cpu() and wrmsrq_on_cpu(), and i has replied
that i need to do it (only) once on each thread per core, and that's why i may need
to use on_each_cpu_mask() and then you had suggested that if you *need* performance  
then i can implement/add something like wrmsrq_on_cpumask(). 

For programming the RMPOPT_BASE MSR performance is not really that important as 
it is for issuing the RMPOPT instruction on only thread per core, and as we are
programming the RMPOPT_BASE MSRs on all CPUs/threads to the same (starting) physical
address to support all RAM up-to 2TB for RMP optimizations, therefore, i don't
think it is that critical to implement wrmsrq_on_cpumask() and instead we can continue
to program the RMPOPT_BASE MSR on all CPUs (threads).

Thanks,
Ashish
