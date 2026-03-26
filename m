Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE3E25E469;
	Thu, 26 Mar 2026 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774491305; cv=fail; b=q6Z9fIij/qpdvUudGr+Uchltxw3J2L+D4rqculkncsYB3rFtlPrmFVccT20kgwjObji0nLhoRvPndAFZePkRtpZWXvYzDvh8+EkYQq8S6sY0oXncXFe16DMQ6UKsVdDwCEoBlaGttMB+pELDtYQi/FUh13gjgaOMoccgntbSe0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774491305; c=relaxed/simple;
	bh=b8RVqY5vEmjPjzAn542RXKlK1ghD5w8kULOA+9mflME=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RT0rhD616GF+RPf1K3+OZWio3hcGjGCFmyvWpOHZQaudBVSeeMTz+nzE9RmbBO+mJKO9BsG4pnQ1aXRG4ZxD4wh4yjvfXj4e8gLFhxl4bKICW1Y8tcxPnpPkFnUTXZ9gEJlALyIrAVFTMjipHd/vZSCD6sgvw+K5jAX9EPQF8fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q0BdqyMu; arc=fail smtp.client-ip=52.101.61.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q0BdqyMu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HEqq0qOUYbQNLYM75jSTTL9BqGG/3pTO04jLpGc7p2JJeHnCj4IEcl4rK+3izu7pMUTlDCGKeCE4kqUyIFTkGX5J+ESLf1qpx7ifufGQOU+j50zW8h+YCioHo7is77DDtT38sQ3dnS53HHhWJ2p1/VYlrDK3369nY/7ZfZGoliXqqaX2h2/GvgVnj9sCUgslxyTv1k6PDNe0o8mIH3kho5QFwM4sTBenqMLgMfjRpIQ2wFCPgFliIxxZ4sUuBqMZJowH9FqeiXQrtWbyBWGI/RSmcs4xFujsvImYW4o9BdJV6tAOkx6xWi40B56nd6chmPdkzbfeVbS6nk1wkZ5pFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GROvV4t/MBm1+B7l2smkCnD64fblO2z4lg32mfNaBPs=;
 b=Ld7vYxFfR8NayHAmidmx9UCygbC809PqzZeNxrApoTWxZrphbXKagsRHiv4fe/FVxEF3/efBtsc6Ky42iefKnlvJtaGTDZIh5+J1OmtUDcmg4a/rXBOHBIAYRkbEdlNucaRuGagBFx0RVEYTR+OfSPA+cV42C2w2FJJOewftCOJfHiDPKcOXXX8u+Syu+/kIOeFqyKHCERk9dTD5aPeodIONcPVvwiml7NqO7PCj7KrbLi+WEJ2AhiRviYHB8UVR/eCSFDecT4RwiuRx6WtN3hE/t9Ed1sg7FWfGoHc6PdCzOcl3VqDrM+qXzZ1LbivRiVLVvAqFLIQT8vN9BBLaGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GROvV4t/MBm1+B7l2smkCnD64fblO2z4lg32mfNaBPs=;
 b=q0BdqyMuAK404K8ClMBSo4aIS598UVWxFF2pfOxFT/8jidvWEflYCbPfemQ+xkR7K1D6J6J7PJtJp9hF19tDO4L4LZ5tVkkBnjnp1mzRpmUzHyTUXFwu5OuvR3M5aTQ7itAz3Jgsj0Bi+t9xckbcRfqm9Rl85KPYeHwQCN6ddOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by SJ2PR12MB8109.namprd12.prod.outlook.com (2603:10b6:a03:4f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 02:15:00 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 02:15:00 +0000
Message-ID: <66ddc571-1d3f-4cfd-a2a6-8e66be861e83@amd.com>
Date: Wed, 25 Mar 2026 21:14:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>, dave.hansen@intel.com
Cc: KPrateek.Nayak@amd.com, Michael.Roth@amd.com, Nathan.Fontenot@amd.com,
 Tycho.Andersen@amd.com, aik@amd.com, ardb@kernel.org, babu.moger@amd.com,
 bp@alien8.de, darwi@linutronix.de, dave.hansen@linux.intel.com,
 davem@davemloft.net, dyoung@redhat.com, herbert@gondor.apana.org.au,
 hpa@zytor.com, jackyli@google.com, jacobhxu@google.com, john.allen@amd.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, nikunj@amd.com, pawan.kumar.gupta@linux.intel.com,
 pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com,
 rientjes@google.com, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, xin@zytor.com
References: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
 <4ec520a1-68c7-4833-9e8f-edc610e5fdfa@citrix.com>
 <48f11469-6435-4f3c-ab67-705ad730b042@amd.com>
 <dc8d4117-3089-48bb-8911-b4d64481fc44@citrix.com>
 <4698d9ba-7030-4447-89c0-c992b776377b@amd.com>
Content-Language: en-US
In-Reply-To: <4698d9ba-7030-4447-89c0-c992b776377b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:610:1ee::21) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|SJ2PR12MB8109:EE_
X-MS-Office365-Filtering-Correlation-Id: abf2b59f-c923-477b-2c17-08de8add7ba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	F+wkrRezRxSbyIysAzkLN9T+L3U6/prtA52TNB55JIgUuYmX25AmCadqP93hzOsk0z+t/+QL0aS1IMJcoRuya+KdEVcTPaVGqNlmr2lgD7jPrWo8HHHHYEBotY830ombrgKzipecYUUMm30R0yJ4TpMVb82rN4DjHC8/BXIP4IHveOsas4cfuLoO8xiaapLTS0QOj+t0qF3C0lBlRo8holmZ9hsc8ycosgTMBSWSzYEkFPKnQbvUxiWKsMXtCPheObB7i6giwpJrrUZCYoO7e26sq0HWAjMEKgTHsVufkGYlH5StcBafJWz53adzd/LD/4EgL19HQQ2bmOOtoM2YokY5jbkckxtVreBsaQqffc1+qZ/9U4N0Kyl2j5UuihHzXSdcEYuQSi6Yt6XRQTiCzCH/eq02aQLDHfxchyh44rpbWviyMKSuVCav54nwz/31QyKY78rBlviN8yQ3pSTZqhawv1x+WbwhlfMVFOVO/nQhk9wshLrMOUJ8Ozcf5Q1MyQSQF0+2nsX+Q2IAI7fO/T4iIMwuom3B3H5bqxlaNPl/mGP6PwaTi0S8vCPkVEB+XZ+jUHqgd7chhHPL4Go1VyW95jbtVhJU3TVaR3uuDhwL1GciBmmG0eIEgnqJU8HD3AarnOhlNis5lmArbWkjr1JI+BsnaBL+/ve3TpRrqpbTpSqlpqMnvmHNu+7nzJgjnjmki0p6HX1wcmWTKlTqepsYttXb/74wIvpyAz6GDfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjMrMUhqSjJoaENjT3AvWW1KaEhqSitiYWxQM0pRQklCMml2MzQ0cFZVU1J5?=
 =?utf-8?B?VTc5dFNrdTdDT3I2VjA4Ulpma0VRNGw5Zk9SNmROM1Rnc1BHRGdyL1pJaFpT?=
 =?utf-8?B?NCtjQTI5eEcxMzZhR2ZxM3FPMzR6eExNUjNIdlBWTDVkRGlqWHdiZUorVk5n?=
 =?utf-8?B?U2pHWXVpYzJobmZhV0pZbnQ2M0pqZ0FadkJTVTVwZXVRZnlRdjlyZXZ0ODZn?=
 =?utf-8?B?d0JyejJOc3VnZ2JRNUlPUTZQVlFWNHlpZjhONHNzK2NTWG5OSmVUYWpuM3Fz?=
 =?utf-8?B?cE1vVFFLWjgrSzhWNHp1ZXRkNHJSbzRUSXp0MFhzNG1LUGFFdDNCaTlMeE5w?=
 =?utf-8?B?TUJZZlBoRGcybTlkclBIem9iRTNXaE1MRGpTUys4dVIxc1hIUnY3eWs0ZzJa?=
 =?utf-8?B?R292bkdlS0ZRcExRZ1A4Z0ZSa3RSS0tCbkF1bXBuWVdRdkR6cGFVNEc2UmQ5?=
 =?utf-8?B?S0dkSU54K1dONndvZU9ObmNXeVlaN1ZSRkZHajBPbkRBSUh6WXl0cDJORzU0?=
 =?utf-8?B?MDdKRkFRc1E0NU5NWFhMdUVwejJlOTY5ajVpcjFTOGZSSWZYcHNEblp5cTBx?=
 =?utf-8?B?dUlHT3BqQ1V5cFdNMnlydnFNREVIenZ2QXlMdWcrcGY4UVBpVndNbUZnL3Br?=
 =?utf-8?B?V2VGU1hYTjZMUjN6Nk5OMlVSeGtLMTVRRTRaM0FWVzd2aWV1SnV5blZKQTJs?=
 =?utf-8?B?ZDZNeVVQbUtvbW1YUzN3bWNIV1AxN3FJc3ZTZVZDUG5lbXl5QmZ5MHBId29K?=
 =?utf-8?B?VEhPOTFpcCsyYVk4SUhmOWJxNVRPTm53QzJNcWxaVHV6UGtLd25MR3RXSzYw?=
 =?utf-8?B?WUxjMGJYMGp6V1l4TmVGbnFHdzRJNnFCaDkybUo4TmpraVJJbkJqSlhmLzNS?=
 =?utf-8?B?UWNOdGVqR1lxUlhueFI0anhKMzl5UWpMd2d4Skl4aWNuNmI5TmMrYzhGN0JJ?=
 =?utf-8?B?TDMrck9PMHkzZVpFUlFPZzZwb2V5Q0gzRmlJYzg4SFVxamdueDV2ZHBuQ29w?=
 =?utf-8?B?eTcxaitrWnlOdzZlbWhIQU4yRVVTUEVsK0p2OG5YY1RWMGZGTUhQdVB5TGd6?=
 =?utf-8?B?TnNvNkJFbTIyMW1HaWVmM3F3ZTNjN1JkRVUvcE5ldktyR0h4azEvZElRNVpG?=
 =?utf-8?B?QzlBMkpoMHlYZktnd2JtbTR5S3ZqMjI0VWNYOUo4dUNLNHYyZ1hWZk52a2VS?=
 =?utf-8?B?Y1ZSSExpWjZEL2Rrakp5YnpUZExnbWFGNnhIbk80VUlBRHcySDZUTDNTQmF6?=
 =?utf-8?B?TmI0NysvUmtoZkdEa0VIb3JOdXdxeXAvWjdYWW9ieDlwR0VKRlQ5SWppblZx?=
 =?utf-8?B?RnVzaE55L3FKeVNQUG4yOXZIZXVrbXcrWVpyVTZ3QndQaE5GMHVqYnJJNWhj?=
 =?utf-8?B?akJBTzI4SG1CWFZnR25HVjJqOGNWU29XUDJBeldDM0huenhyWklUWHJJLzhG?=
 =?utf-8?B?SXgwaXI4c0Z3UlZvaGtCOXh1L2thMWRWb2VOaDRqZ0pCQm94ZHF6SVcxdDcx?=
 =?utf-8?B?c0h1VzFEME5RbHF3aVBCU0pmVm1sNjVtNTkzRTNxbU01azdVWjRHUGY0c1E2?=
 =?utf-8?B?K1lqbWVyd0w2YmIvY2tVRHcyc3pTdTlPU3FkK1Vuem9SVmtQTTlFSHZyOXo1?=
 =?utf-8?B?VVZiWm5HQ2g0M0k3ZkQ2Y0tmclEreHgvc2x1MjJ4ME1QWWpDK0h6aFFDQ1Rh?=
 =?utf-8?B?eEwySDRaM1JnazFqS2krbWtpTVNPQmRlcjFQN1d6ZnpsWERrK3hQazJYUUhK?=
 =?utf-8?B?cjVsL3ZyKzNGaXhKZFVxandrSFFUV1htbnFpTlpXMnJ4eHZKZW5GOGNDS3F4?=
 =?utf-8?B?WmZBcmFYZUJ0MTRQTG0rS05zYjVxZm1NMkhFMkFkRVlIRzBQcmYrdndYSktS?=
 =?utf-8?B?d09nbytVMDEzbE9CalBxWC9lUHJ6d2tZNStsV0hId1dxSTRZU0ZYQlk1RFZo?=
 =?utf-8?B?cHQ1UTlzamIvZVN3UjQvTHZnelFJaGkxSVpWRldlVE1yQjZ3Yk9UY0dzM053?=
 =?utf-8?B?bnQzK0h4VnB0M1dQaDhLNTE4Q1hlNzZBQzkwb0FlMEpXUGk0US96WDc1QTRI?=
 =?utf-8?B?c0VhY1dHajV0VjVLQUFIaDYvRHpmUXF2djIrNXNkNEprVXc2a0NLMnNOSGxW?=
 =?utf-8?B?TTA0a1dielQ1S0Rjais4R09KcFhTdjVic2syeks0bzl4K3ZTVDFYTVdMY09N?=
 =?utf-8?B?bnFLcm44czcvR1ljYVhqMGtIbVUyRkxBYzBsM3ZtT0hVRGZZN3d5Vk5QZjR4?=
 =?utf-8?B?K25YTHJ4K29qZVF6UFhjZ0hYdXZKZlQvK2tuaCtaTWIxSk55bGIxbWNLR3lQ?=
 =?utf-8?B?NS9oeDNKNXJIZ2VjcjBTZjQ4dlZENEZJaThNNU1XdzFjbWwrRmRudz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf2b59f-c923-477b-2c17-08de8add7ba1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 02:15:00.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PdZrhE7NfPSRzAHCLZBWQCYhKFcNbliz++I/Ur5aWb6MTLztexOIxpF6H1Gp7gamJAQqZ31EjozCSC8IvDYdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8109


On 3/25/2026 9:02 PM, Kalra, Ashish wrote:
> 
> On 3/25/2026 7:40 PM, Andrew Cooper wrote:
>> On 25/03/2026 9:53 pm, Kalra, Ashish wrote:
>>> On 3/4/2026 9:56 AM, Andrew Cooper wrote:
>>>> It should be:
>>>>
>>>> static inline bool __rmpopt(unsigned long addr, unsigned int fn)
>>>> {
>>>>     bool res;
>>>>
>>>>     asm volatile (".byte 0xf2, 0x0f, 0x01, 0xfc"
>>>>                  : "=ccc" (res)
>>>>                  : "a" (addr), "c" (fn));
>>>>
>>>>     return res;
>>>> }
>>>>
>>> The above constraints to use on_each_cpu_mask() is forcing the use of:
>>>
>>> void rmpopt(void *val)
>>
>> No.  You don't break your thin wrapper in order to force it into a
>> wrong-shaped hole.
>>
>> You need something like this:
>>
>> void do_rmpopt_optimise(void *val)
>> {
>>     unsigned long addr = *(unsigned long *)val;
>>
>>     WARN_ON_ONCE(__rmpopt(addr, OPTIMISE));
>> }
>>
>> to invoke the wrapper safely from the IPI.  That will at obvious when
>> something wrong occurs.
> 
> This wrapper i can/will use, but doing a WARN_ON_ONCE() is probably avoidable as 
> there will be ranges where RMPOPT will always fail, such as while checking 
> the RMP table entries itself, so there is a good chance that we will always trigger
> the WARN_ON_ONCE() on the memory range containing the RMP table.
> 

To add, the above is in context of the current implementation, where we scan all 
memory up-to 2TB for applying RMP optimizations when SNP is enabled (and/or SNP_INIT).

We will *always* get this stack trace during booting, so i think it makes sense
to avoid this WARN_ON_ONCE().

Thanks,
Ashish
