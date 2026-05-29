Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010033.outbound.protection.outlook.com [52.101.193.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7638330C149;
	Fri, 29 May 2026 00:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780014598; cv=fail; b=UBabjgL7w6tJcOzEW36xGz7jewLlhSbudqDhR2UomAEBJ8dfeQhB+ldCmf0asgI7rJsM69ZsKahyOaDTxsLXN9eJ+1ncgPNsWYDS2iSZRj3THa9MCE7jFVTSk7P7m2x6AeOt0zVQF821l6I2oilUA9M4VM2yxO9eRtoYma0d5po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780014598; c=relaxed/simple;
	bh=IuB9zGUQ6E+rmVYydivyUytXd1I/CYS7SK7t8O7A44s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iIScuzYo16ycX75l8rO3WTXHk0QniG92Y6InfOkaqeD7KB79wqW61hNirXLLbH1RuSXx4KRii88OSXMeQJSaEDfCnXNWxvvMLkeuRAwRzEKA689j+WwWT48MBdPmthKNr007KFk5TGU+WtBYAfTuroNtLvJVeUkT3/BxXJoNSPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M8Gdbgq0; arc=fail smtp.client-ip=52.101.193.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M8Gdbgq0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8FGy9ZhmD355h7aa3MDNkTGDCBtFX31g1T0JVKMC79I/znJhNH4Jvy6Bb6fWSp16xR/r0KyZA2+Zqp2eH23MzdMruY7QSNcUV2IDqzsFtLEawaNzsUH0LRbbq+sdrGSZIuCAe+aULGRUIOPW9+qiyGaWeFx1WbmLhtK8lGSGHMlch2ohIkUp7DWugJgj+ouZJDUnr7U3UyqGuCy6bclPXJU07bKYoFcLAlQ4bqM7J3UNl9oegjnG9vxHFTwogXyMUuTbwAzDw1rUdscFo+PUIA8C1tdNOm6HY/iH25A7JrPx7+iFtY6NsdYRe+9ZsohayDVNlKwtv1ibghXb4WMiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGYlPY79XV5sVv3UGKxOBPzdJSMiEpTUcoQZO+0AOI8=;
 b=qNu7fC19hBNRJrW84z8wMvDsllt5mHU+XwCGMB0iibNA3Q6CGZ3cnnjRzb61XBKoCKy6/6LyqbTSdfPnQveurvY7vcCPi9ueIKisY8TVE17TGKmOVvjqQDjb+SrHXtG3A6AdcQMpgLH2zDjhmSVYLjVJ7ir+xvBEX9yYc+5Zt64nRzLsg+lKSPdCdubfk2G2cZAtjdQ6wicW4pHNtJ0aeWfdwlyqxqFspkePmgNQu7VpGLtc80jDKA6HGCjtWyUXiiK2rr9jvzSZv+ygzKWpKfHdHykwICC5L7jedJ9iXxCl4birYGV1TSOgFEQS1JPZc9KISJlvyhhyyd4mj16uZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGYlPY79XV5sVv3UGKxOBPzdJSMiEpTUcoQZO+0AOI8=;
 b=M8Gdbgq0AtmVIRmA5CX6FLw146iXyBw5IUSNvl2Gt8xHJBpSBjNCLtyQSPiggsqSNKAMrZmSAA5J41eBq8ij/ASXF6aiGhGVlJO60WvWVLbnMrteMiPJCDWTfRKbmTyGArBjDseDHEqUMHYK1Iko7N/vZmVNdcWpBlyCvPdwemw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA5PPF9D25F0C6D.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Fri, 29 May
 2026 00:29:52 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 00:29:52 +0000
Message-ID: <12e42f5e-95f7-4013-b96e-8241524f494f@amd.com>
Date: Thu, 28 May 2026 19:29:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
 <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>
 <20260528004332.GDahePtGqVp2boiEJL@fat_crate.local>
 <2d164e19-5cc6-47ca-9150-f4d432dd10c4@amd.com>
 <c40dcb8c-5706-4c0f-ac85-c22957b9e192@intel.com>
 <3334a64a-9a5e-4ad5-94f3-01fef788df2e@amd.com>
 <20260529002613.GEahjdJRsX2uNz0GnH@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20260529002613.GEahjdJRsX2uNz0GnH@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::13) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA5PPF9D25F0C6D:EE_
X-MS-Office365-Filtering-Correlation-Id: 6412dde1-dcff-4bae-ce33-08debd196635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|4143699003|22082099003|56012099006|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	LlM4+Q84XhDkzwWUpV6KZcAYGDOymuPix00eICgqj3VWrsky+RKvyDJftQ2izCZvqeeMFnUR26m8342DWjNt20W3bfnWCiERB53Ra4unt5YZPPHpfXW++uo9yfpvRHMsaidzMQelOli/h+V57Ot3H4kgAZEVVwEu90vWmIdNxFq9soTlX40GQy1lRK7l22TtvIYUZ0pHQNfBFuxXESSnpSGDOU3AgBUw2+Xex3AGbi47oDKPS/q59SZpScu21h5uW+hg9/cr/1K9O92JMYD8nvV1Bovr1kJBDEqXVWXw3JTqDmQq/TuRyZERlhhNRMJ1bptLJebr1//iKp48Jm6hVyN/myhFN8bHAlYi0Fgs7wyLJXUq9B4Nc3J1WlcIVt9wXk1veL0cmNrh/48rXIuAGW7gvrrZEiL+vk2ld+ECe6uYXqeUdW65s5C9R/qgrWmJk9yQKW4PVQNN/vx/9orAuZ+U+C8NSZgQWm+6it9CJSGMJjkPh2TZUGXd1w3TZTIT4E+HJxLWLIZAQeWhq2OwXGX99EK+DhZq0tI0vBloPZk1xDf+7p9g+nzNkvx748W9mLiUdhC5991kgp4L9oPE6Lwo+FI/u9qtec++dnc/uqQs81fa9AJ8XmKw71JhECE11HEo6nqfN9Ucamg9ojuqNg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(4143699003)(22082099003)(56012099006)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NURMK3lvTjVwN1ZLelgzWnd0dTV3WGErTTJmUDYyWlJvdXRIZ3ZLMmI1NGJk?=
 =?utf-8?B?SFduSjVzZ3dRUGJMRUNNcnhIRXdMR2pySjQ0ZUlLY3Jhd2VPM1NGaXRCcWZI?=
 =?utf-8?B?dFkxb1lEcVFkYU5FQSthYnFHTlNaa2dVM0hwMmZkMlhUTkpWZjhGTnJWSEt0?=
 =?utf-8?B?RkszZnQyYTBueHFQdDFLaHJvQ2RyVDZUTDBNUENLVnpha3pPalZYNjFGeDFa?=
 =?utf-8?B?Tmp3TWF5MzZFaTd5UWtUM2Z5bWJuQ3dKUEtvd25BVThvclZxVEpEWjRnaXV5?=
 =?utf-8?B?aVJwR3pzckFZY1F6VDJ5NGgvazFvZHZXcFFFbzNlcHI0MGtiQUhRUjhaaW0z?=
 =?utf-8?B?QkdXT1RNaStmZ3N4VGNoRWpTSDlSODM0UFJlWUd0K21QVUlnVk8vRXlDTC9U?=
 =?utf-8?B?NnE5TmlXZzhiVHFObnFQWGcwRGRON0NWNiszZlZDUVltY1gvajBFeU5TL29i?=
 =?utf-8?B?Z25MaEhURGhkMjJleHV5UjQzYXliUkhYTWtMTmxrOFdibUZLYnMzTDVXRnVo?=
 =?utf-8?B?QUx2c3dyTmtja3RRTXk5MlFJZFVYdDNjN3Fnc1orUlBxSGhRZU9xanYrdTRG?=
 =?utf-8?B?M01oSTBOUkVtOWR6MW1lRFkxaEo3MFpOMEhDTGlrcUJSd2F6eU1INTRLVC9l?=
 =?utf-8?B?OVVpai90dmN0Y0hKT0pUZGUrK0wwS3pkRmJ3cEJ4MDNUYnQ3Q1pjb2QyREx3?=
 =?utf-8?B?bXF4RlhPZkcySjFWL0dTMjhOVFF4bmdoWnFpZzJ4d3JjbnR3Q0hqNmpXajNN?=
 =?utf-8?B?Qk9tWFFLeTd5R2k3NG1VYktSVGJEeUgyRmZqeEFZNm85eGF5N0tzRllmaUM3?=
 =?utf-8?B?dHc5dkYrZmNydjRGV0ZhYWFKRjdoV3JCRHByYTNWZFpoNHFmT2thTjlscUlH?=
 =?utf-8?B?MG9oRDEwTVFZcnpOVldNeGRZRm8yeG4vckgyUlhOUC9PYkJOdkFLcG9LN3Az?=
 =?utf-8?B?ZHdUUDBEZ2tnUXdlalBlaUhnc0tPVmhCK0lxcmZSQlpzVGlrdHAwaVMrRjcy?=
 =?utf-8?B?cVRELzNhQjk3VTNheTcrTVNOcGtuYzIrRXd3MnVrU254aDIveE42c3dnMUVX?=
 =?utf-8?B?WklPaS9XelkrMmhrTExMakdDUU1BL2NLTVNRRWdlV3prclNCMFArUWhwcDFz?=
 =?utf-8?B?S1VBSHVxSE9SWkVIQlM5Ky9nbVNrWUpJNS95eW9SQnBJWnJMV3JsSkN3YWNv?=
 =?utf-8?B?QUZPZ0k3aEpXV3o3aWRGcGVEcFAySVplNEpQME9lNEp0RkhTYzJ6RG9aREVO?=
 =?utf-8?B?Yk9vcTZJQ2J2bnNIWGpTT3diZktwMks5SlgwNEh4VlBxYmw0amxHb1loK2Jp?=
 =?utf-8?B?WWdQSnpic0xlMzJCK1QwaXZqaC9KWWxXdzZKbmkxSERvMG9iUXl1OEphamgx?=
 =?utf-8?B?Z2ZKRUxKQTM5MEhqa2NOTWxneVBhT0RnNTBuUVkvSUxKMmIrT1I5NzY0QlBs?=
 =?utf-8?B?MFJWRFludzR0WVNxaG5hN0MraHdxMjNJVDdjUEFTN2tLaHlTc1l6a3JoMjNm?=
 =?utf-8?B?VWcxM3pFejRNck5kN2NlSmk1czV3Skl3dDF3aFd3ak1mSlNEbGZNZWVCQXpm?=
 =?utf-8?B?OGF1bVRmWWNVaVdpVDd6eTN3R2EyTERXdjdJTG0vQTk5ZCsxTXM2TmpWaHFK?=
 =?utf-8?B?UDU0MzlxTUVqR29QcmdGVzRhUnRSVzVGVEErckVYUEM3MXFqYjM3N0d4SUhv?=
 =?utf-8?B?ZkdmUHkvSDN0OVBnTGZ5dTd4SW1FNlQzZHhZODRudDRzSU5jL3VkT0c2M0h5?=
 =?utf-8?B?RENta2VaRW1PZldPdFo4TjdZa1FUdG0yazhod3BOVjg3bk4zN2U5S1NrT1lO?=
 =?utf-8?B?emFzTjlMTVpnYU5VVFY5ZXJoOHFtd1loNDBVK1BTVkVKSFVFdXFWRUVGS2lB?=
 =?utf-8?B?UWJqNmhuQWVPUk5JSGxub29mb29Za2lOYUY1bUZqb2dtMWp6OXVkUExXRkds?=
 =?utf-8?B?akRzM0VaOHVCS29xNDRaQlpmMklrclhCa3NjN29aV3Jac0FrS3dnTG8xWENx?=
 =?utf-8?B?TlhOZ3pvOUNtZFgvOFJLNmRpVzJkWWdNL0RESXFiOEdCc1pjc041T1gvN0Jr?=
 =?utf-8?B?OVU1enh4M1BVeFRtWFFoV2FsNThPQzNsNFhEL1l5RnYxTG5EditQRW5aVVZO?=
 =?utf-8?B?L21yT2swUzd5QzZmbHJTMlFNalRadVN2M09scHhEUThqeTlxRG5Eci9IL1FD?=
 =?utf-8?B?N0tsaEwvbG5rbHkxOUVMYlNPQklGNkN0ZnFYYURMV0t4V0hxRDJrdXR3RHVF?=
 =?utf-8?B?NjFkZFl2L1htQUREWE45Y1pZM3h4MlZGeFRKTkY3bG0xaFZpSDZUdWJPeUFU?=
 =?utf-8?Q?+CmQldjtg++PfO5cpy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6412dde1-dcff-4bae-ce33-08debd196635
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 00:29:52.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wMkwg9ON/y1IElDzsQCsOcSBmTh49sNF1Q2gPtHmjCVDP7GVYVfg+ILgYRJKhKYM/D3DB0m08byrWxLytjoBuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9D25F0C6D


On 5/28/2026 7:26 PM, Borislav Petkov wrote:
> On Thu, May 28, 2026 at 02:55:44PM -0500, Kalra, Ashish wrote:
>> Hello Dave,
>>
>> On 5/28/2026 2:50 PM, Dave Hansen wrote:
>>> On 5/28/26 12:37, Kalra, Ashish wrote:
>>>> A simple loop would be perfectly fine and avoids the need for the wrmsrq_on_cpus() helper entirely:
>>>>
>>>>   for_each_cpu(cpu, &rmpopt_cpumask)
>>>>       wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>>>
>>> I'm glad we're on the same page finally. I just hope we can get to this
>>> point more quickly next time. I started off with exactly this
>>> suggestion, but someone chimed in to the thread and said it was "slower":
>>>
>>>> https://lore.kernel.org/lkml/6a50d050-f602-43fd-a44a-cecedd9823eb@amd.com/
>>>
>>
>> Yes, actually i should have made it explicitly clear that we need to do it in
>> parallel especially for issuing the RMPOPT instruction itself, as that is
>> in a performance critical path (and for that we are using on_each_cpu_mask()).
> 
> So which is it? Do we need the wrmsrq_on_cpus() helper or not?
> 
> I'm confused.
> 

No, we don't need it, i will drop this helper function patch.

Thanks,
Ashish
