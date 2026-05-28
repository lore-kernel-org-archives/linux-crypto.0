Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CDC32FA2B;
	Thu, 28 May 2026 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997045; cv=fail; b=fAI6AAL6lqbKaMZcRMYMiqJbrLYwm6iCR/b4TwexvZ6kRf+yMpjVaZUc5eu+TYfgH3IYjBoO8WlB+pnXy24kORQWEBcxVWN0PuygAVqz2ScIUMAhNHSzgBGHttf8jzCBek9jVo6DMSuCaBxwAm1T3P6zunHr5UfQ3YX5/7+Bp48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997045; c=relaxed/simple;
	bh=IBBHekFivHcZUjR1+HFnfIE34RwZBTdkuaN383D0/NE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MWU3x3yxwrcwK73YPZOpQZiZ6eNlqqhMYloWQ1xXXCLvfF0UeYxYiUxwgstspbMy8pbY7bK1hM8ogrLrZykTbAetnxKO6ltHvv2S7bpR6Lmip1dBgnLxQOIcr6AsX3tcBEJ9GnmPpfkR2KoyTCImHE1uYhbum7eJ+mo+TJagDFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mXkGnTpw; arc=fail smtp.client-ip=40.93.196.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mXkGnTpw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZTQ9ugBlL39VT76cJE7YHBl3gu4qHwyh00PmEsKGFRBlYQx4VA8ZyHLlYWGhH1e4WHID27cFZ7KRdWiF5Pg6Eu106YhT/HBh/NzrK0Wra7XaRjZC/nIOtMKq+XPI34MSZzMbLeMN9vuGnSAmkK7OHhK/m91ft2OhLylEH3aWmnFLppxNmEjNdBt8RTC8XVGipA98JrrbXHYyOOSmXi+xkLVaNeJYSDCfB6ht1Ixh26lShmOrqmr4id7bfpNdflCuHNn/RHSVol9IQFHLgo0/XOzyDHfPX828pml9yAC2IlwBo0s4a9eNxeQOHlRGY20PhO+ykv3AxlCr+kxs4WHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUVN9I81c0RWYMf4lvssTVluakG2Lh9lUer7LfMtw3Q=;
 b=jIptEXiXz1Ul1ZeQrOVHM2zOwFs/ejLJMRHlVLmOu5HnO6PVuEZy0GG6rxJ2LGwtJXcUMaV+P/hvz5VIZCKyKZapeCzeKB9y4daN9NteO9LLBZMdwXB8IXMYj2K55Y+skSvYzRi8KzvIGT8qK67/0Md61Eicwa32KQu1k3csVmao4MxivyGwGpUdeTq+x9dhxBl8d+HDSwHQxnQiWbeXq5BSdMA2wABGWsC1MgpuslSwbrJiwmhGtRg37MpUJqfCjIkR41NLdHMvASeThNXaYMQco0XCJCVt0uPNh6wmCshLRx4j37tJqxCGddBnToc5w+ARvCaC9XrT7btcUHd4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUVN9I81c0RWYMf4lvssTVluakG2Lh9lUer7LfMtw3Q=;
 b=mXkGnTpwyh8bt6K3FX95aOFlhzYfrE8zznPIHQcB6ZSkJXMCIuRdC3dUNuPEfTu9JmlS5xe4DgWXTavOWIVRGLAlsx/Qy1+4VFp+sn75RW7Lbl3FQmo4tiT8Uukz4Nef32ncTpuUE8jLxQDlDXQog2KDWAMfSz6oQDeHG+/PhG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CHXPR12MB999222.namprd12.prod.outlook.com (2603:10b6:610:2f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 28 May
 2026 19:37:21 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 19:37:20 +0000
Message-ID: <2d164e19-5cc6-47ca-9150-f4d432dd10c4@amd.com>
Date: Thu, 28 May 2026 14:37:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
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
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
 <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>
 <20260528004332.GDahePtGqVp2boiEJL@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20260528004332.GDahePtGqVp2boiEJL@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CHXPR12MB999222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5195d562-496d-4343-1d13-08debcf08886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|11063799006|56012099006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	3JOkk8XF0ID/Crl09193PZR0HxToOSF2VNXTce4Ri8m66WPpyK8OYuovJ183s3jUv/EfO3EESdxmv9OZiyLZdKF4uifGCbQobDNMcrFdbI5f7c6+B34CsM/PO6G0Z3ZoRLESSKnWZloSTsDYF6TBdkPtq9VxKOEG4vO1i9CQFCSZeUTpZ4RbQd+cMCVfN13jzxMjiiG3IhRP0ln4X9+nnNX6npHfnd7SRCXdjzBs1EKhCe2SZVxLq5BT6WYOl1Tu0pGoQTKVGN4MFcUFSLD82rU5A79x2/uTGYb+BeTm+NeuqoApVZa6kOGmBgpOUXKP//g3+6vLUa9ECX+FPmtBWR7Lr/UTUzR0j28uT782c7MR584Gh+y6ullqF2JnkQiHwWRTwJ0TjMr21jLxX20K2gIZnj7H+o14AVPgzCdhGtkbP+yrD/GQtF/yoIUAjxS7GSAMB/pD8ZXfzxWJfUxk+EdZDy2oZB2p6GrYoDL3UJqiCMM2sKtNFxcr6mCzquDPTZ9wjD3JxBVrZ0io/VU26vzrJZ/hUcuUJ8gMYOscnQxFAsSgSjDeHMQV2XiVbG9DHBHkBYmuskyNUTuMHarfiDvFK3aplebYmRlTHRY19ypN1mR1ehlHDNnw4hGSmkAPfqnSOkcJZ9CNQh5nyYSd/NArUjp2QIVGz65TZx7fg5mWqiSq2Loms3pqSkMbIk2J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUkvVzhZUkFYZHhOUENlOUQ0bUZMVU5VMlFFZmxDNDQyNzBiNlFYVWw2bTdS?=
 =?utf-8?B?ajEwclJwWHpVMnM5NzFxc2JwYnByWVVIdWtielBVYkF6YWRFWG5rRUhtNEox?=
 =?utf-8?B?WW9LWW0wdVdwR05FbTBxOUZLL09RcGZ6NEZIc1VOZk4xSkpPUWlCNCttT2x0?=
 =?utf-8?B?WmJTZG5CU0hRWDlOQTNkQ3B2RUR1WXkwZmluMDdkL2VjU1Ewa01uZENMQ1JB?=
 =?utf-8?B?N2lscTZMRGEzZFdYZ2RnQzl2Vm1SeW94aG5aRjEyY2JiTk9jWUU0WkYvUlU0?=
 =?utf-8?B?QWJwL3RGeHluZ1M3VGh4UFJPM1c4WWY0REI2YVFCcGFaRjlwUVp2U2hSM2pj?=
 =?utf-8?B?ODE5eGY2dE9uUTdlSXEzczdTNHlITGZDM1R0cEQrNDBGTG5kNWFCUlA0VVph?=
 =?utf-8?B?WFBoaU5CSWVwb3g2OUNKaXdJenRtNm94VjI1dXY3RHB3Y0c5NEI0TEQ0QUlQ?=
 =?utf-8?B?bzdNb3gwTVVXNUZsZUxYdDhwbHJhWXVqMXEzMUE3Wk9KcmFIWGhxNXJtdEIr?=
 =?utf-8?B?b0FjOEtZVUtBQlBYdytrazN4VElOc1BZWVpINGdjMlpRdGtkV2Rqbjk1YTFw?=
 =?utf-8?B?K0xSZi9uUk5LdkE5anRnMDBSRUY2VGdpNkIvb1ExcVRRYVgwQm9XWVlYa3Vh?=
 =?utf-8?B?S0hCVkhNdTFKN0xxWXhyMWI1dVU1MlFMYlhqaWR6WUM2Zzg4R1VoRHBFTFJQ?=
 =?utf-8?B?cG1rb3RTUUtnU3JvTCtac1o4VE1sNzA1clY1YVBTUlRCRXBSOEFkRVJXOHJP?=
 =?utf-8?B?UFNtOHJDc08rM3BMZDM2d0xiQnBqL1c0TTlTczVIWGVSSldxYmRoZ1N1NkhJ?=
 =?utf-8?B?RTFvMzhXNUpUbmY3alA0eTFJL1Z6Q29hQm5tWko3OUllaWhBZklPWkhjNjVj?=
 =?utf-8?B?QnFlbjc1ZGxaVXRwMytZaXkwRXNMblJXVlQzVWR3emlnNVUwQVJFYVl0b0o2?=
 =?utf-8?B?MWwzRkNiL3ZIbXh6TzZjNHhHcDN1YXdxcXR4cFEyMmV2eGRHZU1Tcm1vSGJ2?=
 =?utf-8?B?VGhrZ2lPTmI5TER0eUhJTXMyWWdaSnhCbXVIZ1VrRmFDYTdXWGZnN1Uwbm15?=
 =?utf-8?B?YWkrMkQ0TEY4TjY5WTlRdzhmejRHa0xLZ3BLRytaVmxxRUdMSWhuU3BLZmpx?=
 =?utf-8?B?dC9EQktDeXBHMkpWd0J6bmdaQWtPY1lOR2RzTU0wYW9wOEt3SGZWc3Y5VEFy?=
 =?utf-8?B?R3d1d0hTdWFFMU5YbHU4TVdUVkw1TURiQW9KLzNCaDR3eGZpK0diTVpJME50?=
 =?utf-8?B?NUFPWmpQbUsvYkJpb0Z5aXlOejlzamk4N25QTGFTOU9CeFdQK2taRXVrYzYr?=
 =?utf-8?B?elM1TUkycHhNM3VBd0VPd0VsRjJPSTcwbUY2NGFhTU1WZmsyNVN6V3hsdUR5?=
 =?utf-8?B?azJPN3dtUktjbWdGMnJwUmNNUWF0bzdsREVITExWTmZQc3hkd2ROOWplT2c0?=
 =?utf-8?B?SGM4aW5iSE1YNGFWNGhDZlRXZ0FESE1YMVNSRmxNZ21INTJrNDI1Zlc0YUJa?=
 =?utf-8?B?cEVVR0Q4UFJGTUdsdVlQY0lTVHRlOXBLL3R4dWFzR3Y0N0VPaWxTek9qemtI?=
 =?utf-8?B?Z01vTDkya2F2N2tiUWVLUS8zTGZUdy9lQjRkbFI1OWJZRzJBS0pVdjdiYlRv?=
 =?utf-8?B?U1kxR09HTnJKazFwSTYzcVZ2Ynoxa1M0ZnZzWStDNzJ0bUx6b2hyRGUzZFF0?=
 =?utf-8?B?ZGxaTm95OWdsYUJqd3ZOYUppS1RuQ1RtMnI3aEVuY2d0RUc5aGVEbC9ZTkJq?=
 =?utf-8?B?ZGI0WHA4MWNKOWNwN2llYkF0dHZadDgxckY0V2hQNlFsRjFXSWI2SHp5ck9q?=
 =?utf-8?B?Q2ZrbDBUZzc0d3ZMUWdVZnJNTTBwN21ieWhOSUJzdVVDaW5JY1B1WUhBRXVy?=
 =?utf-8?B?RVJJNWd0Sk5DcVRTSjdocjBoSjNaNitISlFFYnJDUFJkVnBQQ2ZCUVNITGty?=
 =?utf-8?B?QllEVWdDQ3dDSHpOdVFEa3dPWFFsNlozMEsrZUFFTEdCajZWOEtFZDVEa2Yv?=
 =?utf-8?B?ekxUYXRYdjBJcjkxejJHcEFQZU9wT0Y0cWJha0RMcjcraFdnZzNPNG5NUm5K?=
 =?utf-8?B?Rnd0VGFFWVQrb1hqOEtLaWprMHQ2SENHV1VDSjk2SXZXNnZsWm8rSCtYZzRh?=
 =?utf-8?B?Z25selIvZFhtVFZ2ak1YNFVkK3RNWTMxM2c0VEp4SGZDZkpjc3hycXI4ZVRr?=
 =?utf-8?B?cUVhaHBaeGdtZ2JuUEloVWZwUmZ4YldUZUlVeDYwTXZVVldLbG4wVkhQSDB6?=
 =?utf-8?B?TkpVQ3ZwVXNuOXFJNGRMbElHb1U2TmlsVnFUSUFpZnlDR1A3d0ZEWGpzLzRI?=
 =?utf-8?Q?JvtBTz4fs6amOFcRSx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5195d562-496d-4343-1d13-08debcf08886
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 19:37:20.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVnztuI1QtxehO5BG8wV5NFfQ7L1XfUu47V44quwPMm3kMPxxl28F5sCYUdsRoPQ9I63H33wcpTRRcnEkOqtXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHXPR12MB999222

Hello Boris and Dave,

On 5/27/2026 7:43 PM, Borislav Petkov wrote:
> On Wed, May 27, 2026 at 02:38:05PM -0700, Dave Hansen wrote:
>> This one is my doing.
> 
> I know.
> 
> But hey, maybe we should not disagree on the public ML because the submitter
> might disappear like the last one. :-P
> 
>> wrmsr_on_cpus() is kinda a mess. I think it only has a single user. It's
>> also not very flexible because it needs a 'struct msr __percpu *msrs'
>> argument where each MSR has a value in memory.
> 
> Right, we did that a looong time ago.
> 
> The only reason I'd have for per-CPU MSR structs is reading different MSR
> values on different cores, modifying only the bits you need and then *keeping*
> the remaining values as they were. And that interface allows you to do that
> while this new thing won't.
> 
> And I'm going to venture a guess here that adding a simpler interface which
> simply forces a new value ontop of a whole MSR could cause a lot of subtle
> bugs when people don't pay attention to keep the old values.
> 
>> The use case for RMPOPT is that all CPUs get the same value. It'd be a
>> little awkward to go create a percpu data structure to duplcate the same
>> value to call wrmsr_on_cpus(). The RMPOPT case is also arguably
>> performance sensitive since it's done during boot. It should do the IPIs
>> in parallel.
> 
> Oh sure, my meaning was to create something that serves both purposes.
> 
>> toggle_ecc_err_reporting(), on the other hand, is done at module init
>> time. It's not really performance sensitive. It's probably pretty easy
>> to zap wrmsr_on_cpus() and just have toggle_ecc_err_reporting() do
>> something slightly less efficient.
> 
> Sure. That's fine.
> 
>> Yeah, the
>>
>> 	wrmsr_on_cpus()
>> 	wrmsrq_on_cpus()
>>
>> naming pain is real. There's little chance of bugs coming from it
>> because the function signatures are *SO* different. But, it certainly
>> could confuse humans for a minute.
> 
> Yap.
> 
>> But the real solution to this is axing wrmsr_on_cpus(). 
> 
> Yap, for example. Basically reingeneering the whole
> write-MSRs-on-multiple-CPUs functionality is what I meant.
> 
>> Which I think we could do after killing its one user which the attached
>> (completely untested) patch does. The only downside of the patch is that it
>> does RDMSR via IPIs one CPU at a time. But, looking at the code, I'm not
>> sure anyone would care. If anyone did, I _think_ all those MSRs have the
>> same value and the code could be simplified further. But that would take
>> more than 3 minutes.
>>
>> It's also possible that my grepping was bad or I'm completely
>> misunderstanding amd64_edac.c. Cluebat welcome if I'm being dense.
> 
> Looks ok to me, we can surely do that. I even hw to test it. I think...
> 
>> BTW, I also don't feel the need to make Ashish go do any of this edac
>> cleanup. I think it can just be done in parallel. But I wouldn't stop
>> him if he volunteered.
> 
> Why not?
> 
> It has always been the case: cleanups and bug fixes first, new features ontop.
> 
> So yeah, modulo figuring out how to redefine the *msr_on_cpus() interface,
> I think this all makes sense.

snp_setup_rmpopt() runs once during init and rmpopt_cleanup() runs once during shutdown. The batch IPI optimization
is irrelevant here. This RMPOPT_BASE MSR setup/programming is not in a performance critical path.

A simple loop would be perfectly fine and avoids the need for the wrmsrq_on_cpus() helper entirely:

  for_each_cpu(cpu, &rmpopt_cpumask)
      wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);

Calling wrmsrq_on_cpus() here for programming RMPOPT_BASE MSR:

-       wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+       for_each_cpu(cpu, &rmpopt_cpumask)
+               wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);

So i will drop this helper patch.

Thanks,
Ashish

> 
> Thx.
> 
