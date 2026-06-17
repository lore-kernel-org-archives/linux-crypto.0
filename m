Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011026.outbound.protection.outlook.com [52.101.62.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4932EEE74;
	Wed, 17 Jun 2026 22:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735017; cv=fail; b=h90UQXIsMamBPhmltiTAe6QpOubI/Y0xSvjoG2S0b3I+CtyWzpFYbrG3Ieq3M6WA1OJ9YgnY4N75cKTQ30NCs+bQ1di/q/skBhJufPuzDJhFflUNzZI3R1HFF9Yk+98C3OicdIfjFtt6B6uiblAt2ms+kAu5ft0lfks4xi1ofU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735017; c=relaxed/simple;
	bh=CkWG/B2oByR7WflOiI3cCNWunX4NkDgUXFz7rXZ8TYk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t3M/7+wItWvWcWOhDiOw8HMXyfausskY4KLGzp6KyzwISEzRfgX7WFw3tqGUO+T04kbV2fSQqD/KTzW2aKYZTENB+/R1rk2wFrMHokVrpbckvlm6tnDQn8dIQmP/chewsW9dN7H/7BWrLOxwCHbdqNBU5pERB9SqPeCCPGecn6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hT9/szgD; arc=fail smtp.client-ip=52.101.62.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hT9/szgD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THIIbj1h7/c6dh4/cdzmWjAZODCXbZ+7WAtCPwTYZNG4hg8WPXQprKIDN3sxfEzLHEweR4sij5wIvNCGXuvBf8T3Uu1Viq/gBAcxLWPOCtLzD9OtpmB7ikzveWfOwZflp+hK/sB3FTVYZLir0dxTn8yktaAVROnSnkqBCPNgDvvuNYbhbTKxh+GF5jjZqNxjt3O82JDfz8bVvL5C2SUFeV0q23ZnmY9bEdsxtwP3xtEKFbwG1kmWQO5gPIPrNsdGW587KZvTGJx65ZVB2KJejzFn/p9P0Ba7C+kkr6kjMLTo47vkP7As37NbkZOg4bQIbZUNCdEGzY8M0OV+d77LWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QZfOGqhrg4YdAo5eJaGLq5eEdsuqegma4SLTe+9p6vc=;
 b=FPqd331RlwBAXGIuoSZDIo+QxnI5VwxE61CdY4IMyfVrOnJ4mUXoG98Kc+F9a0tv4IZFo/UhSaVGNe5CpCDbKFukcizCmNIvYH5BS+vFk1gCcpm3E2BBFQSc92ef3d/Tl7/woExJGgrY0PfuLrWX01lcpVdsw3gQK5UBaEaCjj4RfsTCeWDtAnzl87/JfZAO8pdsUlF5a0Vxot0KiyhxTSZb9jvcfnUC3LtwKKMD4Zk4LD7G/ERj/jSYjXH2vwK+cMBrAEYOCVzN8gCYVLuwH1CK1fuNHu3r2ShEDon6DG8Nr60O28kVNyVAYDZOeVzw4R1Xv60CPHZ7X6a2e/+V5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZfOGqhrg4YdAo5eJaGLq5eEdsuqegma4SLTe+9p6vc=;
 b=hT9/szgDnsAbXBwckUqx5ae9sLXUFxxmVSZVxIlv8TSkQHKGPbaxndIFtgOZc57KSHA7GV6TJLfa6r6hCRY10us3HSasa6CFhgB390RsDWb6c11xd/HEI2IlEgqH702iMJkSb5UTt+mvTAv+nj2kBHAowKv0WZnQOVovjRQhaT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY1PR12MB9581.namprd12.prod.outlook.com (2603:10b6:930:fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 22:23:31 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 22:23:30 +0000
Message-ID: <aaf08f03-ada1-4e2a-88ae-2e900e1f5c89@amd.com>
Date: Wed, 17 Jun 2026 17:23:26 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
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
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <763bff29-e737-4033-ab30-cec8fd3e7438@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <763bff29-e737-4033-ab30-cec8fd3e7438@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:610:4c::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY1PR12MB9581:EE_
X-MS-Office365-Filtering-Correlation-Id: 77050e6d-56dc-40ff-52f4-08deccbf0f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|11063799006|6133799003|22082099003|18002099003|3023799007|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	+eQeSW280QfbuBY08r8rKIuu2NgLlDjXp4FDeW5QX3H4TPqliI981ecV7FZ2eS3ZlXZZuG2DZ8EwNZjnvnS1/oJRudj1tIgRvWJUOvtW+3Uz+4c3lwWkDzAWxtrUDLJjUZ5I0CDQJ5gc9hhF2HfRrKaepmbKGr5pC9tQhN87lq0qQtION5BTjsW27N7HrdCEwQxfHwH9G5UDcqARGUz7+zw2dEqZvfKkhbCmr3q1LesFznEjlofvoYHu5PW5KZRPlYxfukuWDPyC+wMURd8mE6Xao7qjiE3sjpBoU7cX2XM4ee0PWf4N77YCi6bkWfgGqbqfBK65QHBOHn6R1Xhd/yes1nr7rvODpF3ggV+mfwJUMdf6xhCS7YFIarVO/xa01ntmc4RNlvWTXwEAwV986ObRYmdvNAouB1+bi3sse9bdFhMeeQSqCjEY+eKxYdBUES5Sei9ao5ghkYxLVe4OtTWVGb9RgecLWVEoknWDMGQ8HsiQMY9BSAkVql9ihuxkPPTD9bIPzF37Ql+EWy699LHeWPp0DIY7xdB/Aiyl1VZ3gLWEn0/09SO5pyta2GKsVladZFNHZ1WyT+eRQwPKrEuxkaP41J8lPhUVXZRU7zjwg9rFCTzygzCWzUQc4HUuyyO+8z9Ibl+ma0I/TpWGEeOax+IJNdNMzgVb6FdP/uOrHLr3ie2tDJf16yh32D4cczlNXCDe6gwqMq6MZiQwX9Q0ht1dGS7rdNh9kJTXFmg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003)(3023799007)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekQvbUJ1V2VmbmJCbnMzUTJON2RzUU5NZmtBaXpid2VhYjU4OXhIb0kwR01K?=
 =?utf-8?B?bXNTYU1QdWRKZ05PMDVYcXNzaFNNQUhuRDBoY2x6QnBiWnB5Sjh6eEkwaFJ0?=
 =?utf-8?B?YkoyMHhjdjRhUFZMajNwRlQ3dGdxU000bHdhVFJJenMzM2FkaGI3OTNicGdj?=
 =?utf-8?B?UjdmK2RUS25QcjF1eTh5TG5pSWNieWpVaWVlSUxMLzJvRkRFN3JULzdZaHYz?=
 =?utf-8?B?NnNha3VTSHVNaktNaGYzcnlCaDBsWjFUOHVpVmcveFhuRi9tS2JDU1Vmelcr?=
 =?utf-8?B?MVk2dEEva25nTXgxWXZ5eERWZEV1K0RnUGxwOUlTNGNrc3pNTU1ibzJCRlJu?=
 =?utf-8?B?emR1ZXpoVjJZYXhRMjFkOVlObHQvbjlFaVo0dU5vdHN5aGlPSDcvREVjYk5a?=
 =?utf-8?B?SFUzRENFREdhZG0wSm80SXg5ZW81WC9wOWkyUjVHazluT1lrSldiUi9zQ2Zx?=
 =?utf-8?B?UG9iVHlGZjZ5bE1wWEREbUMvejNjcnFCRkFOTmxMUE5OUDBvNWI0Q0VRcHdE?=
 =?utf-8?B?RUZaWkpWSzVlZXozeEZkTWI4a2hFOHZLYmM4aUwxOVNyaUY1T1BaZkhPc1BO?=
 =?utf-8?B?M3QwMVJUVWlKQTZzdXZRVjJWMUJLRTFoaXFLUDYvK0tPSHFqVUN6LzBMWnVG?=
 =?utf-8?B?T0lsNjV0ZmlrWWlxN0VsdElTbitHTWcrbFI4bGtlb0VpQk96b1ZMd1NLcHZS?=
 =?utf-8?B?cG96QzBjT0ozQkdTZG5RelZYMTl2UmhQSGk4akxYWkl2bnVyczlGMU9LeGFO?=
 =?utf-8?B?TUg4RnRvMlAwOE9ObUNFNTVQOUlIMnF1TUVrNC8zMjRlY2UzUVk3end4aWRr?=
 =?utf-8?B?a0xzbkxTRzdZNG83Tnl5b203bWlwVXRLY1NUaStLVXlERXZBTVhLQ05YaGtM?=
 =?utf-8?B?aEprZkNsbmxxd1VMQXA3Vlp6WDNjclYyZUw5d3dsTXlmRzZFT0orWFJuM281?=
 =?utf-8?B?QlVTZ1NPQVZSa2VrS0JqNlpTZUR0SWRvU3Z5WmJVQ29LV1lJZWxrNjQ3ZUI5?=
 =?utf-8?B?eTlwVFlxTkJjbUR6MmhYRUlRcmhuK3VSZFMxTGZPdlFsNkZZME9lS25yamd5?=
 =?utf-8?B?bk1vWE9zWlBxN2NsSW0wanNLS0tCSVhvQk01TmJIZGl0RFQwa3k3OHJiSXMz?=
 =?utf-8?B?cFF0dytEWWcyZTBSOG5lbnRWR3Z0MXpCUFhyTndQaEZYbkRyN2JzaWlqT3Jh?=
 =?utf-8?B?a093WkFzMWxLUzhjdEtGazBoeWdTN0Z2TGMzeUxCOVlZaHE5QjJUOUZwd0Rj?=
 =?utf-8?B?dmRyU3VKYXJveXM1Y1hmSHlnWlRpNUExSGV4alBDR2d2ZDBNK1NBMnE5Um1a?=
 =?utf-8?B?L0hnZ1dheTZpQTczYVhFdUp6ZURLODhLMEVNanB2YVhuSW0veWxUcUdXNWRJ?=
 =?utf-8?B?Y3I1eTZQQy9Od1plZ1JYQkpTck43RlhtMllRSWpVWm91Z2F3Mk5oRW5hbDdM?=
 =?utf-8?B?bFNYWDZGOUJpQjkzY2xyckpOZGZLVURvOUVMZ2hnV01kYWNTTm8zWUlOVWJ4?=
 =?utf-8?B?V01DRnZRQXBHbmppblhJM2JsQTA1NzZZcWN3M2tlNFdXOG85NHZJd3Y4cjB4?=
 =?utf-8?B?TGpYS2FvMUpROE84SjMvM0FjOHh6RnkwZG1yNWI4WGNTbCtkbmFscnFhRHBQ?=
 =?utf-8?B?ZkNVSUdKem5ZM3ZhMTZlK3o5aklCZjMzdG92YlppTVRzbTZBNWZlL0xTR1Mr?=
 =?utf-8?B?VmU4eEFuQnVYS2lNT3RyQTRLbmNmVEYxWmVHZXRzbm45bXN6ZGZRRFBMMExu?=
 =?utf-8?B?YmpKdWtmY29pRytYb1pmajg3Q3o5OE1Db1FaRGp6WDNGcTVhd2EvM1dPamNn?=
 =?utf-8?B?eHlXRFFWa2dwTUE1RHFiMlZKMU9aYzlpNjJjYVZIRkFZVDd4clNnZHJQRFFt?=
 =?utf-8?B?TU5YUTVLdE5DK3lCTXJqMUFFb09NVjN6YVhoUWUwZFZMNjAxSGRhOFVKYnQ5?=
 =?utf-8?B?czBESk9DakRWMmw1VHBOL1JXNlNsYm52TEwxSW5BdFNTZ3JuQXdzWkhObGdu?=
 =?utf-8?B?VysxOXVnUUtsK21MN2pxMllVK3piS0FWdEV4YnZNYW92eExjaVZWY3hrVWJl?=
 =?utf-8?B?QjJMS2NZMzMxZDZOQmFvL05RakM4RHVyUmUweHlQWXhVSGdFeXAxT0x1bkxm?=
 =?utf-8?B?bmN1b0tOaE4xUzBMb1hFS3hlU3AyUjBEOGRPdHpkV3V5K0dhNXZ5RmZ6SXM0?=
 =?utf-8?B?WFJ1QTI2U3VXWFZ5QnArTmtrRVlNd05PRmYwakZFMGpJY3g1aGVCeUFHQ05l?=
 =?utf-8?B?NCtkc2UzZ1Z5ZTZtbjJHNnhIK2RweW1MaDQ1dUptcU83TUpBQndMN1p0UFRr?=
 =?utf-8?Q?wg2nBmLVAQ1JVs3mFh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77050e6d-56dc-40ff-52f4-08deccbf0f43
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 22:23:30.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTg20ryOiLqPxpfWFnW+dCgBfS4mpi9IZ5eJ2+hxlwb9Ubcfh1ux8/CFSGCf7WtPUMrOjAcQqP/0N3ZDE2Zemg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9581

Hello Prateek,

On 6/16/2026 11:33 PM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/16/2026 1:19 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The SEV firmware enumerates the CPUs at SNP initialization and is not
>> aware of the OS bringing CPUs online or offline afterwards, so OS CPU
>> hotplug can diverge from the firmware's expectations and break SNP.
>> Disable CPU hotplug while SNP is active.
> 
> Dumb question: Is this specific to RMPOPT? Otherwise ...

The actual reason is purely about the SEV firmware: it enumerates the BIOS-enabled CPUs at SNP_INIT_EX
and has no knowledge of OS hotplug afterward. That's true whether or not RMPOPT exists. 
RMPOPT only benefits from the side effect, which is a stable rmpopt_cpumask and an uncontended cpus_read_lock()
in the work handler.

So it is specific to SNP, but RMPOPT patches that come later in the series rely on it, therefore it
is a pre-patch here.

> 
>>
>> SNP is fully torn down only on the SNP_SHUTDOWN_EX x86_snp_shutdown
>> path; the legacy path leaves SNP enabled in hardware while clearing
>> snp_initialized, so __sev_snp_init_locked() can run again.  Track the
>> disable with a flag so it is balanced by a matching enable rather than
>> stacked, and re-enable hotplug only on the x86_snp_shutdown path, after
>> snp_shutdown() has cleared the per-core RMPOPT_BASE MSRs with hotplug
>> still disabled.
>>
>> This also keeps the CPU set stable for the asynchronous RMPOPT scan
>> added later in this series, and ensures cpus_read_lock() in the scan
>> is uncontended.
>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 29 ++++++++++++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 217b6b19802e..c8c3c577463c 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -106,6 +106,9 @@ struct snp_hv_fixed_pages_entry {
>>  
>>  static LIST_HEAD(snp_hv_fixed_pages);
>>  
>> +/* Set while SNP has CPU hotplug disabled. */
>> +static bool snp_cpu_hotplug_disabled;
>> +
>>  /* Trusted Memory Region (TMR):
>>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>>   *   to allocate the memory, which will return aligned memory for the specified
>> @@ -1479,6 +1482,17 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  
>>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>>  
>> +	/*
>> +	 * Disable CPU hotplug while SNP is active.  Guard against stacking
>> +	 * the disable count: the legacy SNP_SHUTDOWN_EX path clears
>> +	 * snp_initialized without re-enabling hotplug, so this can run
>> +	 * again while hotplug is already disabled.
>> +	 */
>> +	if (!snp_cpu_hotplug_disabled) {
>> +		cpu_hotplug_disable();
>> +		snp_cpu_hotplug_disabled = true;
>> +	}
>> +
> 
> ... should this be done before __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX)
> is issued?
> 
> I'm assuming that is when the firmware enumerates the CPUs during SNP
> initialization and any hotplug after that should be disallowed?

Yes, it makes sense to do it before SNP_INIT_EX is issued.

Thanks,
Ashish

> 
>>  	snp_setup_rmpopt();
>>  
>>  	sev->snp_initialized = true;
