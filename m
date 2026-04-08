Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010000.outbound.protection.outlook.com [40.93.198.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA98523535E;
	Wed,  8 Apr 2026 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676731; cv=fail; b=NVEV8SDjdR4FFJikW1lLBhwq3RSbLIGCE6CrqxzfUuEYWL0cQxet1O0OQbAV3XB1NCwmGGWveXGiEJTw7kL3zpPoDSejsPclzI4lh7Xy0eA683D/+n90rgjoE5iNQ4++TKMwYMrr8AY0oO7Xal/hMy1mORmjNJyCyLllye4mzFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676731; c=relaxed/simple;
	bh=Q9/khuEbd25Gl9794ECMBorPNpoVs8t97+Z/pMrZ4ZY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LnGoNaq8FlnJl5aixo/o7LL10qg8Lvi+4oUo/rJid2d7Eugyq3ZIH1p2Gikffrx/1Ay+906PbavApInVphhP6SqHaz5JKtH6EKtPJId54mQJXeQGQ8Rc3GNm5N8aDv/14fRWjflOmaDO23295DWHvMqB/sIXK1mFXrfpzMiSbUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gumfme54; arc=fail smtp.client-ip=40.93.198.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gumfme54"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=klbpOWYS310TR5pkqConVwbACqUIZsBuPR53OFAIzQ7AWoCaMuSZdHTMMfXVNllGG3bgZR031cgkfEdryGISY1oRxdU7HJZGqjwk3Mc1qT3Er2t8m7RDQ+GC1nLYhnCsVOMY9OC30io+Pe0MMvW3p/aiz1EYdRMQsKPqqukxPZdpNJQumBnqzAMaJRSKfvjYuujd78oB5fOPF9i3KKkgL2/wy8LZfgNDtDSlsP0ZJmHx3Rd5sZzJpYhKSE+k0DLNaDiDaIGTKnhbqycGeJ/GFDNANP17XSLFmjzHbGa6V3BuYYeC2gpBfZNETxpl/GhcdWi0WWcNWSN76Tzt8zsRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNosiPAbG4TFVi2gkqRW+v94xq3L68FIu9wuMth6iiE=;
 b=qvdWJlSQScpqP9LSQ/ejq9t+VVGwTOktJrw5us+Gr2OwCStGEBgO56HJG2Dr9tH9UAIayhfZVuKfWsh8j0XpfWn6+r63iV3plUXUNe7vK9AwwHbrJPMMQtOSHiehl4sZ0sJU3XBGYIVV7DQqyvTbkbdNOWP4FySXiC+oVhA6fKMGeiSWzHzgEK2ukLo0U4F03RQWhWd6yXCOqG0H/DChm0O/Koyj7O5u73jeuK/0qWNV7m6DYWcms4aEOzDXQOM+4bCJW3yFEHMnhvKIosm8vKvBOqXfrB+XQlehxsVs2fgXk39K4no7X5Qj3gI/snFc4hA2c06Ty8O9zO4ktEjE+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNosiPAbG4TFVi2gkqRW+v94xq3L68FIu9wuMth6iiE=;
 b=gumfme54JI5HZvZkaRVnDC7yWHTaGlqjhbbWJvcfqGdrwrZnvnoklIFfNbzUJAOIdFLSdvAjH6/i+NfSk+u8XNgmoErn6JIwZ3vHov8uqs5gHWJwpuWnUkrjkCfCgq1nOXsMg4KaRo5xprd1Hjw5sFpCXGHJfS25JiEz81bmfKI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB8209.namprd12.prod.outlook.com (2603:10b6:610:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 19:32:06 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 19:32:05 +0000
Message-ID: <2ef6cf92-3c84-43f6-a17e-cf9d5a026167@amd.com>
Date: Wed, 8 Apr 2026 14:32:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] x86/sev: Add interface to re-enable RMP
 optimizations.
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
 <a30809d43368d6ddeb82e6717be83327282ee52e.1774755884.git.ashish.kalra@amd.com>
 <23267200-9fed-43a9-a28b-a6daa701159b@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <23267200-9fed-43a9-a28b-a6daa701159b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0086.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB8209:EE_
X-MS-Office365-Filtering-Correlation-Id: 1586dcaf-37b5-4543-d8ad-08de95a58469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fQAo/EvYo6kcc/1+75xBpEsLemQY2jG254aM1SOMV/MtCfV9nJEI529VMt7M29322hr/Uqahoopu3yqsVQADnaFaccdnOO/1JVnZpITnGNqvo6b7XUGM1xH/20IgBvCu0gzh8EMD6uUvzSKrJxWc9gCEPktxHpWjd6GLIsalwkl5oZWSndnnJO0Ol8G8lu/87dtklVPupQ7uG9VP7EWb0Z37c/6zr4sOOiLj5aTOu8QWjvHN5GoI3MxTLLw8LK3WD55AhJcsQ+hHM1s1PVVMCPOyb4o4ouaj5U2s2zAng5C3uR0XJ11/BwR1VkFDfLrw83xZf87HLNXAJTWu+1hozzc/DOWBkXzisapd1vksC+gcNTk7n8mz/+S08dr1rk3GprMQsnUKBerzrbODjv91LzNASwUthXh/SWHCJBsGvUE4nWroAR/BB1cxwvUNHsaLakimtWZjP3SLqH1KoQ5xoEgTuk9Jf/69JhXfAxwrCJNI1H8G5YUTBEYPRJuXtifuDlVzRsCECJDrND8TcS+cRKXXPswIOEr/FxtaXdh3uperZQAxFDsFUC+L7XznN3ZIXTIqRSkysE0cNLlNVukDRJkkIY3jLCYoxHSVSf0xGXfL4hYf15E/FHtsq8Vd5/YtmJUpc9gHMIutkXWOpMRO4LTX6opDwgvyVrVzo5WDGuZrQCwbc2aBs1IXg07iL0mc0Bia7KNrMPKtsl70l5cP41qEnLwtOOgTYoB/Xh53Lpkq1UFish0tbgJW0+zD87r2JZpN2eJ0HXRfj9zsRGPuAA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3F1NkVJVmZ2ZmRWZThUTWNyQXZZek9PQjc4YUJkR1hBTFBITkdwN1Ixb0d0?=
 =?utf-8?B?VUhXQkxhNVZIeDZzdHY1UGpmZUZ4MENCbFN3TmRSWVZRbWJydmF5bHBUTmQv?=
 =?utf-8?B?SDcyUGNDQ3BsRVpQcUloNFU4MFdhUHRJYnRsaG5SaEtPU2k5MHJJQ05tNnhH?=
 =?utf-8?B?d3lRckpEeVlpZ2t1V0tjbk1UK3lyZ1B6Zm9TWmpHK1JTUFF5c0grQjNCQ0RJ?=
 =?utf-8?B?ZDRST3FoQTZpZk55aDhzMkJYVVJ1aDN5UEczV01hT1pNMlc4VUpQVSs4Ty9Q?=
 =?utf-8?B?b1hvRWNuTTNmQkliaXF4bzFvVnBERXRjU1FzajA3N3NOYlF1aHVmbktXRWZT?=
 =?utf-8?B?a0gya01RYisxbk1Rd3NpemJtbnF3M0ppQnZTQWJick1jaDlXbHhWaExhS0k1?=
 =?utf-8?B?TG90SlVPTXIyT2JuNmNTWXA1RWtUYmYrcVQ4ck5oTmF6a3FjN0NzRyttZXFG?=
 =?utf-8?B?bFBsNFFObjRjTHlFOXBiamp0U25HZm1LLzN5NytDNGdlQUt5OGRHVXBTL0gw?=
 =?utf-8?B?d2NYUzVEeWFWRWNJN1YveW14L3RJcHlwb1Z5M29GbTNUMmdTTHNyZkxwd2VL?=
 =?utf-8?B?SDkvNm43VXAwTHRjUU9uNFY2cWViT3BtendjOTBKdXJtaGZscDBkZ0p2YmJG?=
 =?utf-8?B?YllBKzhSbzdRTE0yTFY3OHdmclkrOHhldjQ3MzlIU0k3R1dWcUJyTkJka2Nu?=
 =?utf-8?B?dlFVRHlETUJZK1BRMGg0am03M2E0dnZ1SEc3RHl1T1pYUmcyVGc2MmV3VW80?=
 =?utf-8?B?SXV6aUdZU1Q5Z2xCUXFzcVRyd0lUR2w0ZHJsVlFkSi9ocm5aR0RpVGtFSnYr?=
 =?utf-8?B?K2d0dWpSdnJNRmNFWmFWek5GaXBuM3phMC9nSThoUEhKTzhEZTNtM1hMUEdp?=
 =?utf-8?B?SytacndNTTJwcHJ2ZnFMTXJyQitXSzhLVk1CUTMySUdtUXMrWEkwYk5RMGty?=
 =?utf-8?B?YmljSVB3SkZHbDNPNmxtVTNLckY5dDAwYkpHYjRwT2ZPMVNiTmF0cE9MVzVy?=
 =?utf-8?B?aXJTUFZiTGhwcEpBNjczZ0huZHFRVFlBZUJKYzNTclJmZDI5VHF3Z2hyZmRt?=
 =?utf-8?B?WlpFaWlQT0k0SlhyWWc4V0NKRWxvK1ljQytkTXRlRG5zVUZwSURNeFFVcita?=
 =?utf-8?B?a2psQkd3YkdvRmJFeTBBZjFnZGwwVVZNNUVpdEtGVVlvVTQyb2d4a256NUY2?=
 =?utf-8?B?UnVTRENkZ2RxNzNTT0Vqb3NPU25LRWVIRlRpRXVucDlLcFYxclpPMnZQdkVJ?=
 =?utf-8?B?TUhhTnh1aXpSemFORDdqUnN0S3F2c09tQ0dhc3hrZzdrRjkvVjZMZDVSa2p5?=
 =?utf-8?B?cWRMaHdSUHFaaXIzOThwRkM4eXZneDlEVXhyWTB6MUx1aW9rNDVNdzhDY1NG?=
 =?utf-8?B?bTRJT05kOGdwWm1hSjl6V0kwTmpWUGs4MXFuV1NlM3J4THh3dXF0bkd2a3Vr?=
 =?utf-8?B?UFpQakIwMThweG9GaWRHK3duckRtWXp6eURHVFI3Y044M3IxU1d6ZDNZTmc2?=
 =?utf-8?B?c1puSDVNb2hQUjlYWUVWKzUyUE5QMjBNbTk3cERraDdYTnl5WUJIV0RQYnRa?=
 =?utf-8?B?ZG9wd2ltK3VBZHdqTWttTlNmRzFSUXJNbjV2OGc3K1Nib3ppNEF4WDBqNldu?=
 =?utf-8?B?RHU2WHVOS2oraFRFQXF5OFNXTnpCR3BRR1hBR1llSmZqVEJ0UVdkZWFFRE5F?=
 =?utf-8?B?YkhBYWpuK1BhRjZYeW9HVURMdFdHUTM1Ly9GNm0rN1I4WmlIeG5tWDZOTGNK?=
 =?utf-8?B?SjNZcGRWQlBsVVdhYTlmMytGMGlUT2RndTJienVmV1c5cnpKNWxVcUNMNHdj?=
 =?utf-8?B?QXFTa0NDK3duZXlpcHhhVm1DTFFaR0QxMWp2TjBrdnFVaXRWVCtOMVZFUXAz?=
 =?utf-8?B?NVhORUd4YmlSeU9lbldIK1RsUXBZRkIxVHltSm1pZ0E1bDN5d21LQkh0S2R1?=
 =?utf-8?B?cmdzNWljOHZSRmVOeEw2ZDRud09tSjd2YmRobW5rMFNZYjNlM3Y5d29qaldk?=
 =?utf-8?B?MFJkSm45cmI5VG9lRVd1VEliYXhocGk3ZGlMSXpxTDk4UzAwc0Vnb3ppVm9D?=
 =?utf-8?B?ajBoOWJSUGhkZ3hQRHVDRW92bmpCQnJScER6UGtYbVhvZnJlTW9yYjA5WVJU?=
 =?utf-8?B?R280T1JBKzM4cjlBOVh2SUd0N3FiRVJPd1ZlYVdPMGw5TzV4T0U1VXR0RUsz?=
 =?utf-8?B?Rk5wRVEzbEsvS2xzYy9xUFhONFR6UHMzTytabWpEQ05PRHlCSG1SLzZUWDBj?=
 =?utf-8?B?aTE3T3M2cnpMT0VYUmRJSUZXV05qVWxFUDd1Yzl3bU5TRkk0ODh3eFF2eWZw?=
 =?utf-8?Q?jTR1Lnuk4rTkCbE+IF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1586dcaf-37b5-4543-d8ad-08de95a58469
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 19:32:05.8429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJU2cL3a/GyUNKbC73DuHbLq2I2HfB5Wr07MFlPZ5CKOco5QPB1ii+NOO6X7ZGVS2rzCS+MkydhfjPmuNEJgTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8209

Hello Dave,

On 3/30/2026 6:33 PM, Dave Hansen wrote:

>> +int snp_perform_rmp_optimization(void)
>> +{
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>> +		return -EINVAL;
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +		return -EINVAL;
>> +
>> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED))
>> +		return -EINVAL;
> 
> This seems wrong. How about we just make 'X86_FEATURE_RMPOPT' the one
> true source of RMP support?
> 
> If you don't have CC_ATTR_HOST_SEV_SNP you:
> 
> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT)
> 
> Ditto for MSR_AMD64_SEG_RMP_ENABLED.
> 
> It could also potentially replace the 'rmpopt_wq' checks.
> 

Following up on this ...

It is straightforward to clear X86_FEATURE_RMPOPT if the RMPOPT setup
function (that is, configure and enable RMPOPT function) gets called, but 
if CC_ATTR_HOST_SEV_SNP is not set, then __sev_snp_init_locked() (CCP module)
does not invoke the RMPOPT setup function. 

And then as this function snp_perform_rmp_optimization() is an external
API, it needs to check for both CC_ATTR_HOST_SEV_SNP and MSR_AMD64_SEG_RMP_ENABLED.

Otherwise, we will need to clear X86_FEATURE_RMPOPT, wherever CC_ATTR_HOST_SEV_SNP
is cleared all across call sites like the AMD IOMMU driver, 
AMD SVM-SEV command line parsing support code and AMD CPU detection and BSP init
code.

And for clearing X86_FEATURE_RMPOPT, if MSR_AMD64_SEG_RMP_ENABLED is not set, 
the support will need to be added in setup_rmptable().

It is much more straightforward to check for both CC_ATTR_HOST_SEV_SNP and
MSR_AMD64_SEG_RMP_ENABLED in this API function itself.

Thanks,
Ashish
