Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013022.outbound.protection.outlook.com [40.93.196.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4563651DDE3;
	Thu, 17 Sep 2026 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662677; cv=fail; b=Z+GfTBRQ2k7qOAkTV2xE/i673ayeY1tas+aw/yYDDwAYJXUGBtDD64xx/J/w4aZBHcgvMPu6hasY+0Q8odj441Ok/yPqBW+GRAdtJdZA0mQ1uJxsawiiMCiyxYAM+mwzoWyS5KjQQzaPKbpumAloMYJXL7rbxu/GeRTV65uOwo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662677; c=relaxed/simple;
	bh=wAtfWqf1oH7+uuntaS2F0kM/KHcfPTfaoD41V/h4CMI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NrnQ9NlIBczBHVSturtH22B2yol2yZS2K9XPjq+v8n/HgQTRVRTpIuWvxcQyZ5o71gjUSS65y+wwxIQUp1ddKYDaE+lruvEj2ouFwAZfCH21DM85xwNa9du8y+abCbpUtdFgw/+BIZGbKE675RqWF0I2YqBq4e4CWSWEh5pa43w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QTeqZQS1; arc=fail smtp.client-ip=40.93.196.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QTeqZQS1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubPUJ2mTgMz4CeWZL36IUYLxDQpWy/hi755ltnfT31As4dsKE4ZR94EKq7npY9jmTQ3BaYnxtDg+0PycY0FH4pukPqSr3tOCq4ypRIOQDDHlgXilxS9vYlnHJznaQdle2q3nA7HwR/KQVH7zKmKi+QaOOqINoo8QFtKKOcTPQKVS2mg8a78R1WWi9TrM/eNEa7JyCi6/MTqvE9YeqX3BXDPUHY8lbrJ085Qa7xhdeyEDCL+E/gujaThasBJn+7KlfbZEx53SOG+NZi1cofL4WHhl+xw7EnJ9PN52+lQaSBcPZiOf22urI1gM+SCexw5eEQvYRlmH0hE7s7mmqrpQRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NA4GgDyz/kObfkQta7kRWMjc/T3z6KvqLEtLFRXeKAc=;
 b=hR41V27onfYB6S8FWFuBST/uU5S4uzJvPuYIuoP7MfdSZmjcBoSiN0O0r056+TnvGuMMpPi4iF5RcgZSSW8sCho7S6TD/KMGBdbHzpVdLUN3ykPG5zqXUdPG20Rozr0w4qstd1EiGMfJPaadslwdWd2sbLl0QbyqTIdUONlCnbW878w/4fm/ZDrLdrRGVeAs+hpE9pDnDbYMa6CIgd14u2XmHloMLBn6GWA5BDqtjwQJBAexnUTnotga+BEESrWZz4UcHqsJDmFch7y+H8dM29LYEDfU/Y0OGUmZBBwXegANeL/0uXR1hZE72c3vzFquaIoudOOxo/aCaZOUOGsJqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NA4GgDyz/kObfkQta7kRWMjc/T3z6KvqLEtLFRXeKAc=;
 b=QTeqZQS1fKLkpUWurKD6P0lFnbAG0giGlfr1yZhXE7K9HqFueC40YrPGlvP2Vz+NjUPGmzKT0M0LrBiBGTRl6XAGHjaTW7OrXDHzc+HPZmMZV3J+/ysvVvzPDIGAOyP3tyOiBHYUOIF/RhnJg/rhioGV+AmnTEpC3+3BYcwYI28=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CY8PR12MB7753.namprd12.prod.outlook.com (2603:10b6:930:93::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 16:31:11 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.21.0428.008; Thu, 17 Sep 2026
 16:31:10 +0000
Message-ID: <dacf788f-7921-4a76-92d3-2218ff23c44f@amd.com>
Date: Thu, 17 Sep 2026 11:31:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 2/5] x86/sev: Disable CPU hotplug while SNP is active
To: Borislav Petkov <bp@alien8.de>, sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1789594774.git.ashish.kalra@amd.com>
 <cd6962a88d691a020c2bf40fe77a6a3f3852fdfc.1789594774.git.ashish.kalra@amd.com>
 <20260916223630.C5E1C1F000FF@smtp.kernel.org>
 <20260917021937.GEaqtOOfbceTzNy0um@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260917021937.GEaqtOOfbceTzNy0um@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:806:27::13) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CY8PR12MB7753:EE_
X-MS-Office365-Filtering-Correlation-Id: b08883dd-a844-4034-f57e-08df14d914ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|18002099003|22082099003|11063799006|56012099006|4143699003|3023799007|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	O7ydBNNDKBGJElbeOPI2HMsy+rUVEHRIIMW1m3/XDzrDxKiO4nJMHXS8tW2dnxsgd/fugl3PlBkOuSfGzDKtu7jDgsi/JZ3J+vFT8RSikdTz6bdzShKOmY6/1TTEY0gbRsDeQ8gQaTuI2KASTFd8sH3IOQGQjQe4/d7szZkSHw+h8Xy/mP/W8BzfabFrW1zMfQpkOYzNAgKxt3hH28nxmwNytYixRMVUfSjwONnlG05WMqXn3aSDusgd7l2aoDumYrfubq8mp2YxTvPBEa84oAvx0/BlorR15T7uQh3frQZ6bcoPrGEsfwowTYnfkHU4ji+N4qWrflEGnXRQ7oL8P71/z5igs66v61LoXtSxlA0ws2Qj7kdkEsvfphzyK4G0/yD9dKsPsaZjiLGIQ5W6MO6oMOZk4IS3hKFG1xC4utwXu+xNPtadMmfii7yIF6GZfj5HD5msIv1NdBNuyq3Fi2MpUuf7VoWDiCMowm6N+mty2/oRiskPsILleZ+3DQXgyBQGLPWuwOFhl7IJrXJ2fcpRTVaUkq+caaEAWI9fXM3s4INn1c7ct7xP5arq44CZbt652NLVm2S8dVVcbLUqSjolYluzvIWmgjRB6hQPZeY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(3023799007)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnQ3Z1lVem1KelhBMGU4THNnMXhqc3VTcURuK2RxZTFFSjBXMnZzelMwVDBI?=
 =?utf-8?B?UUVIakxhbU9WRTdpamNKNTl0Z2RGWTVuSW5oVXJHWHRodCtJaGxPTE5JZCtv?=
 =?utf-8?B?SWQ2aGU1T0lWYUlrM2pmb2I3bUdWNHg4SmVZakgvdWkwcXlCRXEydzQxZmRW?=
 =?utf-8?B?NC9oY09Tbm1ZN1R0cTRvS0NYUmVDajAyVTlPYkNSbndOVXdXYmpLTDFYNm1x?=
 =?utf-8?B?K3kyZjBsK2RheC84R0p0NSs4aXBpMHRBVHhLTmZhcXJDWjR6a21PWG9QMEV6?=
 =?utf-8?B?MC96QmlJTWl1NkhON2VvRGZBZXUzeGxqdm10TmVtVmZPOXU1YlIzNE1RaDYv?=
 =?utf-8?B?WERLRGdUYXF5L3NWU3ZVSFMzMlNKb3BEcUxYVDBVS0VxQlR0RFlZRWlSODV3?=
 =?utf-8?B?Y3NSdzBLVTdUVFVLdnpRUFoyNFNzS1FGeGFoNjlVSlVBT3NGQ3dNTVNtTGpB?=
 =?utf-8?B?YzdqalJnWUkweVFmeENGNGU5eWxBUWNmQXhadnVjUVY4UkpqZkFEbDBWNk44?=
 =?utf-8?B?ZU1pSndES2htc2doWkpaUG9QcGJsSm1VVyt1cVlqUFRlUENzSzRlWVVMcktU?=
 =?utf-8?B?bUtwVUdmV3l4dVpXaVNWNUs4UFdXRFF4MnNOeUdYem91djJIYkk5Y3pQRnBY?=
 =?utf-8?B?bEhMbkZiT1JSMUZQYmpDVXVGZFFHaXpwSWRSUUlaSFljSkJ2T1pWZ2hOTmdp?=
 =?utf-8?B?aTZyVUdJdTFDSGFiY1puYWxqdnB5MGJTVngycTE5UUx4Q2FWYk9pQ2hLWE1p?=
 =?utf-8?B?Wk1VQWJaSmtFM2R4V09DTzh0UWw5NVV4RmNldFgzK2xaMncvMWJjVkd6OGEx?=
 =?utf-8?B?b05ENGVQK2ZvdHJZNk81bFJiUGdZeXVGb1dEMWlhelUxY1lkdlNwZ21ZRjhS?=
 =?utf-8?B?NGJHSVFlUVYyTXg1cng1d1RzaGtxVWduaEdhNDB2QnIyR0x4bDduRFNPMXhL?=
 =?utf-8?B?dnRucllLanFtQ2xZUzNoRk9jd3pKSEFXbkVvTDRGS1VYUUg2azlCYzlKNWwx?=
 =?utf-8?B?LzFUVXg3Q2gxZmRSK3hOVUN4Z25zMXlQT204Mzltc3RjaXUyWUoyRm1QUldG?=
 =?utf-8?B?VXZtbDRjMzRUZEw1ZExCbkF0VjJMUTVFSlArejBiSkNOMytkWDNndkltb2Z1?=
 =?utf-8?B?VkhCR0VEZnJqN0NEN2p5VjJuV2dNM0ozMnJwMDNzSjBKOUwzVW1hbHpxM212?=
 =?utf-8?B?Q3U5bmgxQ3ZQaXdjS3NGUlVtQ2JTNmhEQkhHYVM4cFpSUnVlUWhGZXUrbVNx?=
 =?utf-8?B?SUNsOXM4VEEwYVNpRHd6VmZIZnk0eVBrQVE0ZTZ4WERFV1k4UW0wY0JpeHFB?=
 =?utf-8?B?VW1VVFVBck14YkJSOGJ6eHRxT1I4NkY3NU1sYXh2eEZJM21vMHd4SEdzTEI3?=
 =?utf-8?B?eHpXOGNDcmJxWS9DNmZDZkxuNCtiMzU2L1BPVmVYaXpSTUJadVl4WWhWcG5j?=
 =?utf-8?B?TmRMVjg3MXEzdWlkSUF3dlFQYXBjakdoMmNDL1hra0hRSEUyTXFJOGNySCt1?=
 =?utf-8?B?V0huY3I4TW91RG5nVGptS2pTeU1ucklySjdQbXAvdDd4NHYrSEF6Y1RhdXM1?=
 =?utf-8?B?ZEpBUVhOK3lRdEN3c3o4NGhFKzdXM1BZcFlISC85VlNheGFDY0lVZDlhWHhB?=
 =?utf-8?B?TlB4SFZZbzJscHZEYlVhWHJZbUx1bVBRVHpuVG8wL0RmVGNnTzQ5MVB4Tk04?=
 =?utf-8?B?bXpkNUhTcUM5eUNXZ2dxU1NNVmdJcTVjblhlbHN0aWMvSys1Tm8yMGxvbWR6?=
 =?utf-8?B?dzYvbGJwbTBGYXZuYXY2cklKQkhVZW9kSnFDSmR3N29SbjhHQUVzeVJPWWR3?=
 =?utf-8?B?ZWNBZThJQm5Kem12Y0pzK2tHMFBZOU9KM2psTmpNOFBtZEFxZ2lIbXBIVFUz?=
 =?utf-8?B?YUhwUFlEVDFBbTNiTTMxUW1VdzREUkc4OUI2ZWRHMElYNFlmUHdZME5TSHd2?=
 =?utf-8?B?SXIrai9qY29mK2RzT01oVTlibFVndHVhRHpJckNDWjdZY1c0dytTd0xhbURw?=
 =?utf-8?B?cWZ0TmY0YWxQSit3YktmUk4xcnFNelM5VWI5M0w5QWFKL0xMMWc5aSsrdWtw?=
 =?utf-8?B?eStKbnd1ZDA0Rm9aMG9VMTlFYjdjOWF4VklJWXNVelNPNHpFN3J6bk43WVp6?=
 =?utf-8?B?c0Yyb1NDei9XQTllV01ZOElzVXl6dzgxVFBSV052VUJLdFNhTlF0VHozYnVL?=
 =?utf-8?B?M1B3MFF6eVNTSURScmdSMmppRVpvR2lkMWtYeGNEY1ZBSXQvUUxYNjNVSHhp?=
 =?utf-8?B?d1JJNWtMNE9RSHZkeXZ6T3cvT3J5aEpVQ25UaDJnVzJoakJaaHFJWnk0aWU5?=
 =?utf-8?B?VVpCVjVNdXdsY3pnSzN2NS9yTkJFZkdEd1hqcXJ3ZjZBU0JiTEhhQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08883dd-a844-4034-f57e-08df14d914ef
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 16:31:10.4057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvKk9Xln9D4j3MYJ5VOS/GgVZfz37H3f1HATEvWgSQGoSMXB1S/+xrnNOifBQGP7SdT9FbKlqGVQoF7QsxuBHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7753

Hello Boris,

On 9/16/2026 9:19 PM, Borislav Petkov wrote:
> On Wed, Sep 16, 2026 at 10:36:30PM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [High] x86/sev: CPU hotplug disablement bypassed on early kexec errors
>> --
>>
>> commit ac084f2d7188c520f2ee3ced2ab76e4c068df91f
>> Author: Ashish Kalra <ashish.kalra@amd.com>
>>
>> x86/sev: Disable CPU hotplug while SNP is active
>>
>> This commit disables CPU hotplug when SNP is enabled to prevent SNP guest
>> memory from being broken by CPUs coming online without the SnpEn bit set.
>> It ties CPU hotplug to the SNP-enable bit, disabling it in snp_prepare()
>> and re-enabling it in snp_shutdown() when SNP is disabled. It also
>> explicitly disables CPU hotplug during kexec if SNP is already enabled.
>>
>>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>>> index cff285d8ad8e3..558f7924a3f85 100644
>>> --- a/arch/x86/virt/svm/sev.c
>>> +++ b/arch/x86/virt/svm/sev.c
>>
>> [ ... ]
>>
>>> @@ -577,6 +582,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>>>   */
>>>  int __init snp_rmptable_init(void)
>>>  {
>>> +	u64 val;
>>> +
>>>  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>>>  		return -ENOSYS;
>>>  
>>> @@ -586,6 +593,15 @@ int __init snp_rmptable_init(void)
>>>  	if (!setup_rmptable())
>>>  		return -ENOSYS;
>>>  
>>> +	/*
>>> +	 * On a kexec boot SNP may already be enabled (legacy firmware leaves
>>> +	 * SnpEn set across shutdown), in which case snp_prepare() bails without
>>> +	 * disabling CPU hotplug, so disable it here.
>>> +	 */
>>> +	rdmsrq(MSR_AMD64_SYSCFG, val);
>>> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
>>> +		cpu_hotplug_disable();
>>
>> [Severity: High]
>> If a kexec kernel boots into a system where the previous kernel left
>> MSR_AMD64_SYSCFG_SNP_EN active, and an early initialization step fails
>> (such as passing amd_iommu=off
> 
> amd_iommu=off means no SNP.
> 
>> on the kernel command line resulting in !amd_iommu_snp_en, or
>> setup_rmptable() failing),
> 
> The same happens in that case:
> 
>         if (snp_rmptable_init()) {
>                 pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
>                 goto disable_snp;
> 		     ^^^^^^^^^^^
> 
> Does Sashiko not see that or somehow it ate a lot of credits so it cannot use
> enough now to "swap in" the whole context... if that is the AI that is going
> to destroy the world, then I'm not too worried. :)
> 
> Or is my AI failing me right now?
> 
> :-P
> 
> Leaving in the rest.

Right, agreed — 

As you have pointed out, on any snp_rmptable_init() failure — setup_rmptable() failing,
!amd_iommu_snp_en (amd_iommu=off), etc. — the caller does goto disable_snp and SNP is
disabled entirely. 

Thanks,
Ashish

> 
>> snp_rmptable_init() will
>> return -ENOSYS before checking the physical MSR hardware state and
>> disabling CPU hotplug.
>>
>> Because hotplug remains enabled and the CCP driver skips initialization on
>> failure (bypassing snp_prepare()), could a subsequently hotplugged CPU come
>> online without the SNP_EN bit set?
> 
> Yes, but the above disabled all our intention of running SNP in the first
> place...
>  
>> If this results in a mixed hardware state, does it violate firmware
>> constraints and cause fatal RMP faults when the new CPU accesses memory?
>>
>> Should the hardware state be checked and hotplug disabled unconditionally
>> before the software configuration checks?
>>
>> -- 
>> Sashiko AI review · https://sashiko.dev/#/patchset/cover.1789594774.git.ashish.kalra@amd.com?part=2
> 
