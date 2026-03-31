Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010021.outbound.protection.outlook.com [52.101.193.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE8F1A840A;
	Tue, 31 Mar 2026 00:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917982; cv=fail; b=POO/r1bqAVX9BU4cr5cW1BEwkYmL3jyST3iu8aIqyrwm9p7HUEgHlF+/NuLFVLuq2DzscJY57hhaMw2EPeMopA4uemnnIdrekbkyKuFBHC0KeefwgCbShPIyYxyWZAk5QWqi2hQtfKMzNDF/wCDIxz2vKHreHWsmGP+6+VSE3IE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917982; c=relaxed/simple;
	bh=ccj4yYO3x/bv+3B9GMKXwruo9OPc0DRpWvz3g8feGdo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c9Jzw9+kijCHrdTU9bZSJKL+Eks6vu7w1mxjAqLblY6R8MvGnrMJAvc0I1aQ3Ff3Q/0gHRZWIV2QZ7VD/nCmUcl/0mBesynLIbtPuTKGxVNfZbekaDzMJs4Y2vC+oJ+alapjal9IddeU2q1bsBHAFrKViAgG/OQXYdNJ9Zymy8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=obh4Oup+; arc=fail smtp.client-ip=52.101.193.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="obh4Oup+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4q+TUhO976thWOhczbpJ4+C2u+XwI/O4nsQaI0h3BgTc7sRlQXY0Im7KR9iNBjtdIbBnWJBoSUPdBOvZ1Bp7ntLULPtboEpAT9V+zdAfnorLF5d6VjhPkDat3/0xeQOhjX9qfBwP+eddWhNt2VgvEiU4V8Nt7kaelii3kvNndn658/tBSlXP4JUeUSGj9LbYNpNEiVIXs6GW7HID3h4GHkxbjR249HlnTb6VLOXQ5ZGrhShOZ/jACyX58wUgis2Kuc/9RUzp9/TrE3BoDI0q4HZ9x/2GQz2oQVgJwnwZpr5XxBMXfQaCjElKTy+nB/IiXXujv3cqEoU4gqFGjkc2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+c7EQvyEM3nGdGSNfS3RSeaIVISFwjj65cW1Q+svtDI=;
 b=Mg5MM06wH1iBChQg+XF3T6DsP5fMgvcS6Bx9Ah/YjxW/2kdAmPUW9vW92/OTRA1gjbLbq/cMTYBluDkyDe+BbHTgcbI4T7IUQgx5A0vBk1bCgKTvfUH5NMUF0ErTtAYXsYR0wuWK4JYACM0DW/1wh8ErWm4VtxbtqQnYu2SJ4knCEYt/1Wy5aINhp+KaHmBOEf6rjpibPD1lkJs1swboJxb1SM0jqFAAO7Uk6ZadH8BaqNTs4nzepVh3prG/i+DeIZOkaoct2he93h+MlyXGyc7Et6RFcvVvo6SuzTdJTH3f2ILbUiwCQvUagz5WlR3ljZFnY3VvmQoYQ+IO4ieGnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c7EQvyEM3nGdGSNfS3RSeaIVISFwjj65cW1Q+svtDI=;
 b=obh4Oup+FEJZeT9AJr0ZlCp1f9faxiyBfOcC1FD0renr7h0JmnutLkLlgPhMOFTtCIUyk/1cwDulpDefjnalPfcn2QHIKW0JQLq1XybPuDx0TTaYzhVhZW9KuIKapYzXwlQiiJAFhNWMfxOc0KmAEat6HIhxAfX5cK4zwVKSVsM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV2PR12MB5773.namprd12.prod.outlook.com (2603:10b6:408:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 00:46:17 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 00:46:17 +0000
Message-ID: <e2e38a91-ef8c-41d0-9373-0fdb6f246847@amd.com>
Date: Mon, 30 Mar 2026 19:46:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
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
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ab41b1d8-e464-4ad6-ac07-7318686db10e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:610:5b::39) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV2PR12MB5773:EE_
X-MS-Office365-Filtering-Correlation-Id: e44c6e86-9f47-4b9c-3b26-08de8ebeead7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bUGLZal+IKDeV8S6RPAR/lDnt819w949ZMU+bny0pCeUFcfGYlss3P2rr92bCidxLSk5oy2ZWqoFPXgX2zOuamgbrRd+xj4Q50f83PgczUYhj/MY9afbhQW4FANXaIz6xhX32ybnT/UlSy3HwU0pGBGPNr7z8XSKaDBFc9UA2dVMOt0p60gpfCMbTBQlSb/LPJ0sG6GnPbvCAcRE6wtEfv17138JsM2BjBfqqJ7SbHr4Fa8hPIuiLurPBEPmxiDv4sU0Ls7UTZVp7EQwTHTkOJ6NcdyO2QvsEio6WfnxuzIkJn9e+9LoE2MNNVsgLWj6VoLrAhYc3ygXyDIaRZyLGu11psh3RrabEbyJIubEofyXt3XD62NCKCJZSVHCdlk2Xo0oeP1fvmi45AogQAun4lXlSK8fENkWGbf0PgOYkpJqviTh6QPHXmze1LVlNyytABxbgBZ+VLnEX2YwCItLhJzx7pQaAbWWCtvCA0HVcdwhpoR1xSteJ1YH+pLDgGLxp7u895ITcRx521r14qvZ+R9g/sNvr3eEcY0wJb88FfqKwAy7eb4lKEUxvNq8kw5V9AJtPIpcp6nKeSXCHGfVTn0WkYoNuO+7dD9+w6UARbv2vRFqXDwGbqBbmE+VFCjtdt4ROQtGsl9kNXVfnP+nD8z+E7Y4O5H9VToSZ58+mzv1RhNcqsQG4sfULn243QMvQLgY+PFX25rT9y8vhlwgRBc1U9BfnPs3smEyDZl6f8VryRmuA1HzejoKiqCHRgfML1ZgCcqjAObBbjqSmyhUtw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?di9ocENlTWI2dnc1ejNBZERscmZHSmxNNnZWR1plSC9zMEZscTZmVGQ4bGpk?=
 =?utf-8?B?RVFBdTNuR0d4ZVRLejB2dFJ1R0JBYURVdDBPVzhaRlJMZStxRDZKbGlaU0E2?=
 =?utf-8?B?N0NUUjRMNmJGMlN6UkZNRGF5T3hZN013dmdYdEZBUHNrZTBrc2RxZHRoN2hV?=
 =?utf-8?B?UmlCTk5jUDFldUxDV1FXZlJJMUxybWl5WnV6RkxpQ3BpSTVocUlLbStidk5V?=
 =?utf-8?B?VzB1RWRWYkZtVTNCc1hPWlFxdnh3cGtONzltdjEzS3NtS2ZRSmNtQ3pyczFU?=
 =?utf-8?B?dm9ZYUt1SXF2MTZCSHF2WTNIN09hSkMzTFdqTmVRT0F4RXJDOXFFQUJaNlJq?=
 =?utf-8?B?aURsVEh0UzVvWEdmWDFtcnBOTUM5U3BGMFMvbi9wa1p4TFg2WWJnWk1lWVUz?=
 =?utf-8?B?dWdCTDZVbWNWcEgrVkVrWTlhNDNuME93WklGc2RwVThNOWdlMWlnSUpGQTln?=
 =?utf-8?B?QWdwSEhFTW5RVkhpOWVVR1VMaE5hMTI1dXN0RlpoUENkTlNnOUlIdnpqaWor?=
 =?utf-8?B?bVdKU3RhR1R3clliT3lnU3RCWTRzNVpVV20vZ2JNOXd4WElkZmZFenpzRS8w?=
 =?utf-8?B?azltTllqTWU3WnBYbGdITXY2bFh6RkNLdERrajRaNGhGalgydGFhYUpwWnlR?=
 =?utf-8?B?VVpxcjBESkFYSk84L3p6M2dYcC9oZnVxaDREYmdzaitKeFZmL0l1WmNheFFO?=
 =?utf-8?B?b25CU3V0L1V6VzNIelprYnZXd1hsQlBCcjF2YStaREtMQkw5MnFsOXJSOTlt?=
 =?utf-8?B?VUptV2RZQng0SlBmSWpzRWR2Uyt6anhOenhZYUcrVlpKZFova2VzTUxLMmNo?=
 =?utf-8?B?ZU5jUDBkU1VTUHMrWVFXVFBtTFFWQUF5dFFnOW9NckJvZ3h4QzhhWHRBUGVk?=
 =?utf-8?B?RFNKL0VEU3dKQ2tlWnNFQlh1ejJBMWFmQkRnM2dJaEpIK0dkWWVJKys1cWhU?=
 =?utf-8?B?Rm9jRnpnQjhDSDNXcjFXRzA2bmVodU4zcDdtRlNiTVh0Q0JSMFkwOXlxRytj?=
 =?utf-8?B?d2F0TUp1bTA5ZFNBdmZkengzakgrSkdNOWkwVnAycmdVNmtRN1N0OFVUSzBa?=
 =?utf-8?B?azV2WDZ1NnR0ZkZ3dG5oa1V3TWtBZndZNXgrQXBmMGVSYUFVQjJzbEdKU0xY?=
 =?utf-8?B?TVNjU3B6UmtCMy96V1U4YzdiMHRGKzlCM2pLM3FJNmhyWjdIa3BtSksxRTFZ?=
 =?utf-8?B?azlXVURMcEFtMTlKdXVWcmpZbWtCYjMxYUVnUDJkQU11ZFNuYXFKNUY1ek1u?=
 =?utf-8?B?cTFjdkV4RExzK014cFJSVGJQRmUvcW5jUHQrc1NENWV0UGsrbGhPTlBqb3hL?=
 =?utf-8?B?My9rdjV0MmRFL0h6d0tKSkQrYmJkVlVZODJBaTY5ZFBwb2NnSTQrRXFqUS8r?=
 =?utf-8?B?cHhLNWxlL2psOW5WWU1zbVVFeTRNaWx5eU9YNjAxaWVGaUtsS3ZXQ0U0RGQ4?=
 =?utf-8?B?alpKNnB6b0dRd2VrZVQ1VTVOUnY4S3F5ZisrSUk5TGh4UitwT3dSNUYvNCs4?=
 =?utf-8?B?ZENzWVpadHV5K3FXZ3Yxb3ZrL0d1SWVRMEJielJ5WjNGUnJKalZMRmRLSjRv?=
 =?utf-8?B?VHN3SktIcnVuVyt0MkkreityZll2SGpCTG9JeTdJVXZ5OWo0MGdJdEh1MXda?=
 =?utf-8?B?dG1tajRNdkNVYlhvUmlvVjRkZlBBY2lQSXhaTy9MWWdVRk1BMUZQSWo4NW5E?=
 =?utf-8?B?WHpBcmZlYkVaT3UzWkhFa3JBYUh1cU9abWtqb2RnekJLcEZPd3NJSTBVTE9S?=
 =?utf-8?B?TTJaazh2T1hCLzJOVjAxWW4xZWhCQlV1Y1hIVzJQK0FLdStXaU52K29sK0tn?=
 =?utf-8?B?dDBpWGIzUVpneldnMlc1NzY2czRROEFKVzFURnB2TzJvbUExR3RGVVB0Q3BO?=
 =?utf-8?B?QmJiMkI4Sk0vbSthWVcvSGhOa25meVJ2b3RycHFheEhvbG52Z200S04yUHc4?=
 =?utf-8?B?TjZKKzhGKzAzKzJSK0xtV0dvWUdtK1h5L3JRZnczNGtBMlBydVJkTHJvRmlX?=
 =?utf-8?B?RGVBTUVwOWN5T1ZlcTUyV0p2TnlYOVZBK0ptTktmM09lY2V5bytqYVdvNVpC?=
 =?utf-8?B?VXdORFFqUjQzTkhPN3NscjB3NTdpSXN1eCtlT2lRMmYrTkRGV09oYmExOXVn?=
 =?utf-8?B?RU9IcDhPNUF3TGxmRmxtMTJzb0gxd3JkME9PN0RnRVI4d2RxYkhudHY4RStm?=
 =?utf-8?B?eUJ5SkNVZ05jeUlSd2lQdmQ1alYrZzBmQTArUXgxblQzb2VneXB4THZmUDFT?=
 =?utf-8?B?anJrYWlwbHV3RGc3TGYxOGNQVEJKMlgvVGRRbUwxV2h4Vm16Z1huUUxPS3BE?=
 =?utf-8?B?V3dKcGxOaERiaGdhSVNrb0xzWlpDN1dPTWtBZEEwSjZpRXcweUdNQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44c6e86-9f47-4b9c-3b26-08de8ebeead7
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 00:46:17.0497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLw4lsb4c9T52LJNjiFTNtgSvd2e5Wdn3s0lmD8zmho5CahYTLplW4QIRsZNaI8kLQxaSmN2PchSWavZMuSOzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5773


On 3/30/2026 6:22 PM, Dave Hansen wrote:
> On 3/30/26 15:26, Ashish Kalra wrote:
> ...
>> As SEV-SNP is enabled by default on boot when an RMP table is
>> allocated by BIOS, the hypervisor and non-SNP guests are subject to
>> RMP write checks to provide integrity of SNP guest memory.
> 
> This is a long-winded way of saying:
> 
> 	When SEV-SNP is enabled, all writes to memory are checked to
> 	ensure integrity of SNP guest memory. This imposes performance
> 	overhead on the whole system.
> 
>> RMPOPT is a new instruction that minimizes the performance overhead of
>> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
>> checks to be skipped for 1GB regions of memory that are known not to
>> contain any SEV-SNP guest memory.
>>
>> Add support for performing RMP optimizations asynchronously using a
>> dedicated workqueue, scheduling delayed work to perform RMP
>> optimizations every 10 seconds.
> 
> Gah, does it really do this _every_ 10 seconds? Whether or not any
> guests are running or if the SEV-SNP state has changed at *all*? This
> code doesn't implement that, right? If so, why mention it here?
> 
>> +static void rmpopt_work_handler(struct work_struct *work)
>> +{
>> +	phys_addr_t pa;
>> +
>> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
>> +		rmpopt_pa_start, rmpopt_pa_end);
>> +
>> +	/*
>> +	 * RMPOPT optimizations skip RMP checks at 1GB granularity if this
>> +	 * range of memory does not contain any SNP guest memory. Optimize
>> +	 * each range on one CPU first, then let other CPUs execute RMPOPT
>> +	 * in parallel so they can skip most work as the range has already
>> +	 * been optimized.
>> +	 */
> 
> This comment could be much more clear.
> 
> First, the granularity has *zero* to do with this optimization.
> 
> Second, the optimization this code is doing only makes sense if the RMP
> itself is caching the RMPOPT result in a global, single place. That's
> not explained. It needs something like:
> 
> 	RMPOPT does three things: It scans the RMP table, stores the
> 	result of the scan in the global RMP table and copies that
> 	result to a per-CPU table. The scan is the most expensive part.
> 	If a second RMPOPT occurs, it can skip the expensive scan if it
> 	sees the "cached" scan result in the RMP.
> 
> 	Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
> 	on every other primary thread. This potentially allows the
> 	followers to use the "cached" scan results to avoid repeating
> 	full scans.
> 
>> +	cpumask_clear_cpu(smp_processor_id(), &primary_threads_cpumask);
> 
> How do you know that the current CPU is *in* 'primary_threads_cpumask'
> in the first place? I guess it doesn't hurt to do RMPOPT in two places,
> but why not just be careful about it?
> 
> Also, logically, 'primary_threads_cpumask' never changes (modulo CPU
> hotplug). The thing you're tracking here is "primary CPUs that need to
> have RMPOPT executed on them". That's a far different thing than the
> name for the variable.

Ok, i will name it more appropriately.

> 
>> +	/* current CPU */
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		rmpopt((void *)pa);
> 
> This _looks_ rather wonky because it's casting a 'pa' to a virtual
> address for no apparent reason.

This is re-using the rmpopt() wrapper, which exists for using the
on_each_cpu_mask() call below, and that needs the "void *' parameter. 

The on_each_cpu_mask() is needed to execute RMPOPT instructions in
parallel, as that is part of the bare minimum optimizations needed
for the RMPOPT loop.

I will add another wrapper for calling rmpopt() with the 'pa'
parameter directly.

> 
> Also, rmpopt() itself does 1G alignment. This code ^ also aligns the
> start and end. Why?

Yes, RMPOPT instruction does 1G alignment on the specified PA, this code
alignment is to ensure the PFNs - min_low_pfn and max_pfn are aligned
appropriately.

> 
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +		on_each_cpu_mask(&primary_threads_cpumask, rmpopt,
>> +				 (void *)pa, true);
>> +
>> +		 /* Give a chance for other threads to run */
>> +		cond_resched();
>> +
>> +	}
>> +
>> +	cpumask_set_cpu(smp_processor_id(), &primary_threads_cpumask);
>> +}
> 
> Honestly, I _really_ wish this series would dispense with *all* the
> optimizations in the first version. This looks really wonky because
> 'primary_threads_cpumask' is a global variable and is initialized before
> the work function when it could probably be done within the work function.
> 

It is static and will never change, so i was doing it here outside the work function, 
but i can move it inside the work function.

> It's also *really* generically and non-descriptively named for a
> global-scope variable.
> 

I can name it appropriately. 

I definitely want to have the bare minimum set of optimizations for the RMPOPT loop
in place for the first series of patches, which is:  

1). Issuing RMPOPT on one only one CPU first, before doing it in parallel on
all other CPUs. 

2). Issuing RMPOPT on only one thread per core.

This is the bare minimum set of optimizations for RMPOPT loop, for which
i had the performance numbers computed before: 

Best runtime for the RMPOPT loop:
When RMPOPT exits early as it finds an assigned page on the first RMP entry it checks in the 1GB -> ~95ms.

Worst runtime for the RMPOPT loop:
When RMPOPT does not find any assigned page in the full 1GB range it is checking -> ~311ms.

The following series will have support for system RAM > 2TB and other optimizations, but 
these bare minimum set of optimizations for RMPOPT should definitely be part of initial 
patch series.

>> +static void rmpopt_all_physmem(bool early)
>> +{
>> +	if (!rmpopt_wq)
>> +		return;
>> +
>> +	if (early)
>> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
>> +				   msecs_to_jiffies(1));
>> +	else
>> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
>> +				   msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
>> +}
> 
> This is rather unfortunate on several levels.
> 
> First, even if the 'bool early' thing was a good idea, this should be
> written:
> 
> 	unsigned long timeout = RMPOPT_WORK_TIMEOUT;
> 
> 	if (early)
> 		timeout = 1;
> 	
> 	queue_delayed_work(rmpopt_wq,
> 			   &rmpopt_delayed_work,			
> 			   msecs_to_jiffies(timeout));
> 
> But, really, why does it even *need* a bool for early/late? Just do a
> late_initcall() if you want this done near boot time.
> 

Ok.

> 
>>  static __init void configure_and_enable_rmpopt(void)
>>  {
>>  	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>> @@ -499,6 +582,37 @@ static __init void configure_and_enable_rmpopt(void)
>>  	 */
>>  	for_each_online_cpu(cpu)
>>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> 
> What is the scope of MSR_AMD64_RMPOPT_BASE? Can you have it enabled on
> one thread and not the other? Could they be different values both for
> enabling and the rmpopt_base value?
> 
> If it's not per-thread, then why is it being initialized for each thread?
> 

Only one logical thread per core needs to set RMPOPT_BASE MSR as it is per-core,
so i will use the "primary_threads_cpumask" here to use it for programming this
MSR.

Just another reason, to set the "primary_threads_cpumask" here in this function 
and then re-use it for the RMPOPT worker.

>> +	/*
>> +	 * Create an RMPOPT-specific workqueue to avoid scheduling
>> +	 * RMPOPT workitem on the global system workqueue.
>> +	 */
>> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
>> +	if (!rmpopt_wq)
>> +		return;
> 
> I'd probably just put this first. Then if the allocation fails, you
> don't even bother doing the WRMSRs. Heck if you did that, you could even
> use the MSR bit for the indicator of if RMPOPT is supported.

Ok.

> 
>> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
>> +
>> +	rmpopt_pa_start = pa_start;
> 
> Why is there a 'rmpopt_pa_start' and 'pa_start'?

Again, just statically setting the 'rmpopt_pa_start' for the RMPOPT worker,
but i can just use 'rmpopt_pa_start' here. 

Thanks,
Ashish

> 
>> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
>> +
>> +	/* Limit memory scanning to the first 2 TB of RAM */
>> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
>> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
>> +
>> +	/* Only one thread per core needs to issue RMPOPT instruction */
>> +	for_each_online_cpu(cpu) {
>> +		if (!topology_is_primary_thread(cpu))
>> +			continue;
>> +
>> +		cpumask_set_cpu(cpu, &primary_threads_cpumask);
>> +	}
>> +
>> +	/*
>> +	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
>> +	 * optimizations on all physical memory.
>> +	 */
>> +	rmpopt_all_physmem(TRUE);
>>  }
