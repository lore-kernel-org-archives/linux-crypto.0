Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012007.outbound.protection.outlook.com [40.107.209.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB73502A7;
	Fri, 26 Jun 2026 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782505405; cv=fail; b=Gb43wiMnuF62kILERcOFpk3PTpVn/H04CAOhDtFMUNRsN2rO/o+CzRZmgne8Ati4nN1SbfdGPoWztXV9ijgvMJBIgSJejWc4xI6No8EcS+aIBlqpWmrCI60R/t46ko2w26GuN6zWF/wIP62KCOY8P7uBdBF7J/hZu3EiLFNzwks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782505405; c=relaxed/simple;
	bh=vlqFZlaFhTmifDlTlQu+nCT6+FSj1xeKO59BmXpLvIc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LU6MQlabtjKXRYHII+GMHsd2bq4ik9YhZLllOJdu2XdyICN4OotyfUDbJSAHYbYd5Scdk5EWNR4cUUAk4BSZYKaXXmNNU+nHHauhTvj4sWMVkUHbLKk71Wl5utmvFSQJO/59ioGckLx+FkeR1jJhOoZ95EfLFoLlTRpTKBzwgZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bnGiA9Et; arc=fail smtp.client-ip=40.107.209.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bnGiA9Et"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XT8/jLAyFxcOG0Kl1ivHgCnl/d2ELJW1CKN98AZd18MluBmpgvxg/ZvqVoBPtA0/hV9Fl2OzfhZTurr04RIBCBPibZp3D/ogCgSbXngRJeS7+QVopdIMriejQWNnlesQyV+daepCkFKrvxhCmMriJplnu3hkgr8xGGLzxUcM58k+n7JLFSKi2ODKFwYTY6BZ+Mtg0URHhXLpIldtPkVH448OIoZPUGPpcThuugV9JgH5yqc01bXZBPloB2DTqkEhUSSH6YFf5J32UnSJ9QJzW6Yg1q0YCzLEMXiaRVBtV8dZgcO6GMil0d8R2RUq6Zk+XdcsFspAWa1apw7F8ELpEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3N9RS3sxWgWJ2jOxkNQB3c4HOdQ3H4Pq8bDfafmEujM=;
 b=qQFaHGmp2O8MCZwh54WmsMLBvVxCnZOfpmxOwd72M9JfXXK1CIOrD3FbLj7D4q9Tc+zfxwzPzCb8dbPrb+p+vfSwEoKgQwfjpBI1BFyU7wOSfITfqPGBSkc3S7HH+r06uR4aq95/EbECtaS5ZL4f/9PWiJv7hJOKTVbUdPXESC1Zn7Xx+VUi/f7jhCOPlQXpYYLCNBVWXAPlZZ7nAx+DGZvpGSDrexkf55OViIOwpTQomrpgCkk/rZ6isiSGjfJtaG3uaf9OHEOdD4NkObVqjCl7+vzrgQ/xv5w0m+lCHQ4rOAFSN4/ixfj6OEgQGmqOa3WxnI9+6qbIX+L4E3WVlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3N9RS3sxWgWJ2jOxkNQB3c4HOdQ3H4Pq8bDfafmEujM=;
 b=bnGiA9EtuJXIaQn89BKgZDgTw6VbSGDzDYUlFPNGNh3IEpy6tMIdqmZhiV+WntuRjbrsm9XX04CMyr/s5Nv/Hdm/Zyy7zW1GTBipqkLOnB+IRBLoTz1SZSvp7Mi/sGCuVK2ufXpvhCxUKh6CsfuBfAL3lb9cOxP8NvVn0ZI3ZcE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB9346.namprd12.prod.outlook.com (2603:10b6:8:1be::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 20:23:19 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Fri, 26 Jun 2026
 20:23:18 +0000
Message-ID: <afa0570c-6ff3-4438-bceb-4f29a04b5725@amd.com>
Date: Fri, 26 Jun 2026 15:23:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: K Prateek Nayak <kprateek.nayak@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
 <898e378a-cf7c-4310-b439-e28ec0a71338@amd.com>
 <b9777de5-a6fa-418c-92d2-89c095e91837@amd.com>
 <24aef42a-86da-42d4-92d1-9a6d2d329592@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <24aef42a-86da-42d4-92d1-9a6d2d329592@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:610:77::32) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB9346:EE_
X-MS-Office365-Filtering-Correlation-Id: d0db0e2d-b02e-405b-46ef-08ded3c0c279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|4143699003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	zi2zv8MjaxIs7i3e96iU52CBuCJyhSWCbSOkrViAnW0DAJ3qkeftFTFk2IIqfEz4bB66l26690hg7wurpP2HOHB9SrD312ialumYju0AGP39tOZH7b2a3OlpSFcBzO4FY5EyicNSOyiKJ4bOpsV5QrSAjQlriHyuEzNNRJ0GlHU6Knn3+5GzEB754MdERovB5NjFTHsqJi1S+H0lzGltWUDOZ8puFGlicxsMPOH/26b10aW58hU43fP4sdcMFU0uiq/Gh6D1rMffDltNkM6i+gzxykXn8QrvDojr7S6Y581GAz34YWVe991bhWNHQoxmlnDpmWX+vtDLwA7jvXx6xsQkk9/qrOQKoFa1SXg3suzn/u/aVj7IYIGWlK/l742BgVsVaFE2NC4U7Cn+JCb/vQZeFbFdBB1bCx5UNHG3FdyHQT9dcm5dIzN/nitbkr8cmR/d5fJnGfgF9KP/kC416Qk5tVV3mdSf09FpPF3MhOErVLz1q61bauot1Niw2Q7i2o70sznIG1kTVvYVxmCAKk/sKlEkWFKuEr/4+TWBnv/rSad6MHCu33SXcxOj1O1hiiKW1LjBh2TYvI3YSCUPiVp7IheXCxmMIYAqi1K15P0Xo6TOMDIRKRbQR6ocHdOiJlFnKPHYDgj7u3Is3iwl1g647bgr0sziJWDWqeROcuA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rmt5a2hSWk1rUUplVjlySUZWSFBhSzg0QmVWckNaREdSMXd5RWZNOGlkRzVz?=
 =?utf-8?B?d3BCQUdoWnJCZ0VqaTlXb1JTQ3B3WU05ZDRQd0RXYmMwaEZmWkVLcUZ3cTJm?=
 =?utf-8?B?aEh3bSt3TU9tUE9pa2FpakZrZUhnbEp0YUdOVjV6RkpvMXNUQ1FseHFuTlFS?=
 =?utf-8?B?M3BtUXNUbkRuc2hDZVNVeG0vOUgzaUpIa0lwMDQxUnQ2TG0zZjYzZFdHZTZu?=
 =?utf-8?B?azFnekIrbG9IR1dzRzc0SXBycWtNYS9BeDRDVy8yK3k4dW9UUlBvMjd2M1NM?=
 =?utf-8?B?Z1puL3FtR1JoRjBZcmVZNWpKK1FDODZGS1NuZHltQThTWkNmbU9GRnhvaFpw?=
 =?utf-8?B?T09aVVgzR2F3bE5DTHkxOFRCZmtrbmgrV2d0dnRqMklLekRBeWM0dUFaWlZ3?=
 =?utf-8?B?WEtBakxvNHZiTFVxcTNMd3ZDZUFRbUxiekREV1JiS0x4aFZrbmJZS3hxdEVt?=
 =?utf-8?B?U2dPcmFuNGhRditmcmEzYXF2SHdPcEgvNFZLMDI0elB1WFpTR1dlaktqM0ky?=
 =?utf-8?B?U0lMdFhXVVVSQ2JvRjA5bW5TY2tsQW14TlBBQ294R3BDVnJoSnErSFFzMEF0?=
 =?utf-8?B?ZU1UaEF1OGNERlJLendSeVVNN2hadUY4QnI0bytDOHZuZGdlbEljdWpvcTFU?=
 =?utf-8?B?RlJXWVFoVHFWY3hYYVJSdmRjbzJKaFNJTURRRGRwNXNRS3FhajJZRVJVTkgr?=
 =?utf-8?B?YmQ5cE93a05lZkNranlTZXgzeGFCSysvc3BkZmpuMy9NTEJkbkp6RWFuZ0dN?=
 =?utf-8?B?SzY3VmRsTE9TWlJnSEdPNzZ6VW1rNHlIV3N1V2xPaVVrUUtsNTE3UTB1c0s3?=
 =?utf-8?B?bmFWVG83Qi9ZYURmM2dIRG8vMVZzNllUVE4vVEpNZXBQVElGZ1BrSXBqc1k4?=
 =?utf-8?B?a2hzM3RoSzRrbllyWHNRdlh0N09lZEJ6ektqMWUrYVkzT0ZtS0JKWDc0a0x4?=
 =?utf-8?B?ZnMvRDJxL0lrOURjcVdtMmlhb29kaS93OERCQmVNTDlUb09uMGYzZmgvMW1J?=
 =?utf-8?B?dU5MSllSZUhHVGcxczN0RWQyOU16eDJQUjE0eXdUQm9nQzBqaGdSNE9oVVlL?=
 =?utf-8?B?SGo2WkFnM05PMWxOdWxZVURVZWtYZ3FTUTVNUldPWFhFYzYrK1JPYkJVR3Zv?=
 =?utf-8?B?akwwU0pleUJ3MGtjSmVGS1VDSGlVSDFIU21EZzIwVjJKTEc2OEZOYlBxY0FN?=
 =?utf-8?B?Nk9LWGIyQjV4N3RnSlV2RE5rek0vVXJtTU0rRWtQOXNseERxSFUyQi96dFBp?=
 =?utf-8?B?ZTJZUlFZWmdTdFNORGx0cUQyWU5oeDhXUE1nVmU1d1JHOU4zVEx0c3hSYWFr?=
 =?utf-8?B?aVF5TVdLRVZ3TDRKU0N1aW5EN1R0R05nY3E3WThkYllpclRIMnkrQzloNTBI?=
 =?utf-8?B?WjVtKy9yK1oxa0JYS1RZZUNybzF4anB6WFAyU0xuZC9TOVBCVWpCVkdTdXhm?=
 =?utf-8?B?alNXbkVTTGtCVm8yZjYvQVZvL0VHUXZ6ZG1BMjAzdy94ck94cnkzaWxDK0R2?=
 =?utf-8?B?UkdIMEdJR2NmSEltZ0JaTWw1VWM0a1BNSEdWWWg3NXgxdnlzYm5HdWhUYlJL?=
 =?utf-8?B?WVdjMzJjNmpUS1BCdzUrdkd4M0VhL2dMeXNHblpIdW5TaUdVcGRlbEExMFVp?=
 =?utf-8?B?WGNDUFVidUZjUEVibjNHOVhhY3hMTU1YTDFibXFPeHBJQlVkUHE1ZENzZlJC?=
 =?utf-8?B?QjRycUdHYlJaK1ZxS1hITW1UL1Q4MzlyK0FweFVFN2tZMGo1WTJQRkpScEhM?=
 =?utf-8?B?Z08zeGVMQ2lSMkhxc1EzMEh0eUtmZXVrUVdMSm1YZ3ZYTk9rdXlxZnZwbGZH?=
 =?utf-8?B?TkZIN3hKb3VQSXRKeUQ0ZHRkOEJOaDE0RE9pVEJQK1dqQ3JsaUhaeEpDQ2hn?=
 =?utf-8?B?SXhzZXpoWFJsTkNLTW1oQVNFcnBTTWQ3MXBnZG8wNndwZjhlR3Y2dDlGTmN0?=
 =?utf-8?B?WVJJN1VWampBNFpTeTZlT1VWTTRXVGpNVTRkMDlXY0RIMlZIR2MxbmIyYkFl?=
 =?utf-8?B?eEtVNnV2R3N5QUFTK2l2WmRYV0p2Zm8xZWRESURGZkRaUzNZN1R0eWtrTXl5?=
 =?utf-8?B?ZGczTkphY0IzTkQ1YWx1UEV5SCtZL1QrcE5VRHhLVlRQZS9xUU1STlV1R0lN?=
 =?utf-8?B?OWlQR1I5ZWJITk5YcStwajJUcEFLMjVqSjJsVDF3NlhhS1dIKzFlalU1Unox?=
 =?utf-8?B?cC9NYzJmSEROZnVsRXF5VDVVb0I4aTFpWnBaSjdCQTkyekhnZUp4WkVzWUtL?=
 =?utf-8?B?MXdUcElTR3JFVUlKL0QvTGEyMkQ1N1FzSkRMTVY3MlFXMmNQVXkrdGVkRkMy?=
 =?utf-8?Q?UqPY4ud2Fn6CndCmwu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0db0e2d-b02e-405b-46ef-08ded3c0c279
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 20:23:18.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIEkfgjyrN8foPym/tDNdrWhtH2pKbcfSqGbTYMDh8dMVCBu1jlS0zddYj4Ivu16S0/mjXp3viHfYHNo9SahZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9346

Hello Prateek,

On 6/25/2026 11:01 PM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/26/2026 8:08 AM, Kalra, Ashish wrote:
>>> Looking at snp_prepare(), we have an early-bailout for
>>>
>>>     rdmsrq(MSR_AMD64_SYSCFG, val);
>>>     if (val & MSR_AMD64_SYSCFG_SNP_EN)
>>>          return;
>>>
>>> Does executing SHUTDOWN command lead to the firmware clearing SNP_EN in
>>> SYSCFG on all CPUS?
>>
>> Yes, in case of X86_SNP_SHUTDOWN (available if firmware supports X86SnpShutdown feature)
>> SNP is disabled on all cores by clearing SYSCFG[SNPEn] bit.
>>
>> If X86_SNP_SHUTDOWN is set to 1, the firmware clears the SYSCFG[SNPEn] bit in each core. 
>>
>> But, in case of legacy SNP shutdown, SNP_EN bit is not cleared and so SNP remains enabled.
> 
> Ah! That was the bit I was missing. Thanks a ton for clarifying.
> 
>>
>>>
>>> If SNP_EN remains set (and Linux can't clear it since it is
>>> "Write-1-only" bit), then a subsequent snp_prepare() will skip setting
>>> SYSCFG if it sees SNP_EN on local CPU.
>>>
>>> It can so happen that we enable hotlpug at shutdown, CPUs come online
>>> without setting SNP_EN in SYSCFG, subsequent snp_prepare() runs on a CPU
>>> where SNP_EN is still set and skips configuring it for the CPUs that
>>> don't have it set, and we'll be in a pickle still.
>>>
>>> The comment above that bailout saying "this can happen in case of kexec
>>> boot" makes me believe that SNP_EN remains set until a full system
>>> reset.
>>>
>>> The only safe way to do this is to ensure all possible CPUs are online
>>> during snp_prepare() and do snp_enable() regardless of whether local CPU
>>> has SNP_EN or not.
>>>
>>> Am I missing something?
>>>
>>
>> The piece that makes the early bailout safe is the disable this patch adds:
>> hotplug is disabled while SNP is active, so the online set can't change under an
>> active SNP. snp_prepare() already requires online == present, so at a successful
>> init every present CPU gets SNP_EN,
> 
> How is this enforced? AFAICT, on_each_cpu(snp_enable) will only covers
> the online CPUs and there could be CPUs that have been offlined before
> that right
Right that on_each_cpu() only covers online CPUs -- but snp_prepare() refuses to
proceed unless online == present. 

  if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
          ret = -EOPNOTSUPP;
          pr_warn("SNP init failed: not all CPUs online. ...");
          goto unlock;
  }
  
The check right before on_each_cpu(snp_enable) returns -EOPNOTSUPP if any present CPU
is offline, so SNP init simply fails in that case -- there is no successful init
that leaves a CPU without SNP_EN. The check and on_each_cpu(snp_enable) both run
under cpus_read_lock(), so the online set can't change between the two, at a
successful snp_prepare(), online == present and every present CPU has SNP_EN.
After that this patch disables hotplug, so the set stays == present.

(That online == present requirement is existing snp_prepare() behavior, not
something this patch adds.)

And cpu_hotplug_disable() comes right before cpus_read_lock() as it must not be called
while holding cpus_read_lock(), something like this: 


        rdmsrq(MSR_AMD64_SYSCFG, val);
        if (val & MSR_AMD64_SYSCFG_SNP_EN)
                return 0;                 /* bailout: re-init/kexec, SNP_EN already set */

        clear_rmp();

        cpu_hotplug_disable();            /* <-- here: after bailout, before cpus_read_lock */

        cpus_read_lock();
        if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
                ret = -EOPNOTSUPP;
                ...
                goto unlock;             /* will re-enable below */
        }
        on_each_cpu(mfd_reconfigure, ...);
        on_each_cpu(snp_enable, ...);
        ...
  unlock:
        cpus_read_unlock();
        if (ret)
                cpu_hotplug_enable();    /* undo: failed before SNP_EN was set */
        return ret;

> 
>> and because hotplug is then disabled none
>> can leave or rejoin without it. So whenever the bailout is hit with SNP active,
>> every online CPU already has SNP_EN:
>>
>>   - kexec: SNP_EN is already set on all CPUs by the previous kernel.
> 
> There is a catch here: you can have offline CPUs during the previous boot
> (say you have maxcpus=8 in your cmdline), and then you kexec with a different
> kernel / cmdline that brings online a bunch more CPUs.
> 
> SNP_EN will only be set for a subset of then with the legacy SNP_INIT and
> if snp_prepare() runs on those legacy CPUs, you still skip setting it for
> the ones that don't have SNP_EN set.
> 
> Is that case covered somehow or is it a non-issue?
> 

It's a non-issue, for two independent reasons.

First, kexec with SNP active currently requires a full SNP shutdown before the
kexec. SNP_SHUTDOWN_EX (and the IOMMU SNP shutdown it performs) fail if there
are any active SNP guests or assigned ASIDs, so a working kexec has to terminate
all SNP guests and run a full shutdown first (via systemctl kexec). On
firmware that supports X86_SNP_SHUTDOWN, that full shutdown clears SNP_EN on all
CPUs, so the kexec target boots with SNP_EN clear and runs a complete, fresh
snp_prepare() -- where online == present is enforced, so every present CPU gets
SNP_EN. There is no inherited partial-SNP_EN state.

Second, even independent of kexec, this kernel's snp_prepare() never sets SNP_EN
on a subset: on_each_cpu(snp_enable) runs only after the
cpumask_equal(cpu_online_mask, cpu_present_mask) check passes, so it's all (every
present CPU) or nothing (snp_prepare() returns -EOPNOTSUPP and SNP_EN is never
set). With maxcpus=8 on a larger system, online != present, so SNP simply does
not initialize -- it cannot leave SNP_EN set on only those 8 cores. A successful
init therefore implies every present CPU has SNP_EN, and the present mask is the
same physical hardware across kexec.

So producing a partial SNP_EN set would require a source kernel that both sets
SNP_EN partially (i.e. doesn't enforce online == present) and skips the
full shutdown before kexec -- neither of which applies here. I think it's a
non-issue in practice.

>>   - re-init while SNP is still active (e.g. after a legacy SNP_SHUTDOWN that
>>   leaves SNP_EN set): hotplug was disabled the whole time, so the online set is
>>   unchanged and all of them still have SNP_EN.
>>
>> The only way a CPU can be online without SNP_EN is when SNP is not active --
>> i.e. after an SNP_INIT failure, where this patch re-enables hotplug. That is
>> deliberately the same as the behavior before this support existed (hotplug was
>> never disabled then), and it is benign: SNP_EN only gates RMP checks, the RMP
>> itself is initialized by SNP_INIT, so on a failed init the RMP is all-zeroes --
>> every entry is in the default HV-owned state, no page is assigned, no check ever blocks
>> and snp_initialized stays false, so no SNP guest can be created.
>> Nothing is enforced and nothing is protected.
>>
>> So I've kept snp_prepare()'s existing bailout / snp_enable() behavior unchanged;
>> what this patch adds is disabling hotplug while SNP is active, which is what
>> actually closes the window (a CPU coming online without SNP_EN while SNP is
>> live). That window -- and the SNP_EN-stays-set-on-failure situation -- already
>> exist in today's code, this patch constrains the dangerous (active) case and
>> otherwise matches current behavior.
> 
> Ack! Just that one small bit up above bothers me but other than that,
> doing it in snp_prepare() should be good.
> 
> This is all new to me so thanks a ton for answering my queries.
> 

Thanks,
Ashish

>>
>> (On the v9 placement specifically: I'm moving the disable into snp_prepare()
>> ahead of SNP_EN in the next version; in v9 it sits after SNP_INIT, which leaves
>> the window you originally pointed out.)
