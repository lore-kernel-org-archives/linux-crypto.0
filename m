Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72B7EEB3;
	Wed,  1 Jul 2026 21:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782940141; cv=fail; b=Rh9qw5vpiuDU4R/hwpMgs9Q6HaD/KqcqcDFMnMWRYRPawtZQi4+aGAI3LoX6Fhrdjbt+EBJKigJrft9TadaGH1ei/jlhTTBpnFP2wh8tKh6rhi3usaCqyOiNaMlrQ2pg0ZogbN3etqWcOD0uAwx1oU2Nr1d1S1zIIVCYw5srKpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782940141; c=relaxed/simple;
	bh=n3JUXBG4A68LgXBxOyUFhGGnpy6DUeZUDhATR3J7NAM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K3WoymLBfLEE16lOdYvv6WKGwNILOPRFHVzE7Ixckn+U2Kzk78mlKGQreXYuv+iE0hz+EpN3NAQJ3p5aXChqavxf8312+s4nWnsZsx+z0RZh/9zaYXaL1D5Mq7uzAxUmaaQ7d5hpyqjWmvqqjjKArnFqAcZr0dj2I3VPbijMVbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ET717Mdn; arc=fail smtp.client-ip=40.93.195.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ET717Mdn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x1pDNm5J6DTohoEC9ORzTbGrMg6WlzYkP8CrEF6AhyI4OYRGTzHcY0r8fmj+knnn5JB/Ot4BX4lU6vYzKS87037utLIp+uYH9yxJlkVE7JiUROSqBktrm8+kYYz283nDPETLTEYeyzv8IsuOHfmcm64cgMp9ZOK2cS53k92yFrVToyi+c+/8BHt38OK+0XMrVXPg3fdvuDH3ByUaMeqH4tApTsgdaI+TfrUJXWMUfeUHNiGDErgY4Pr9+14+U01C9sWkUJlomopcR1hdV6t3rZKpP1rALFsX29vtxqE5R6tzzUXorYcrhIjYQvNiSuEo74RZB+3u/4QOOQiPKRImAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVaqCTXx11L1BeriE99pRgL/jN/1xJALsItqZahAjaM=;
 b=S9ZzDsCe64piZXzDRXVSOiDIY/vVp5XWLk3+7ccCttdIZvAsUGyhRhDtxcMgOwNj/9xeBDizfV6qhdReQp3Tg5Yljha4M3x96dZbdXXE++2OKcy8B9cangUBjGseW+HZQuwi4VaKzP1h4+knRCGsuU3Hm4hQsU0LEGHaOERkoHIdFydS3GqCE2Xxc8HS4FPLQjrQUgz0P6Tshto9HrZVOhFJ1CwJaKJPk3GWvfFLLM1eEuOBjgXndZqH84X4bz/pqBbgUVlmts/2FgRKR0HbmiXUnWi4kpJMoOyzhnIYoXjE3xw3g3VrbJBbw1NgaLo2HW23E9fIgE+euetWOoH9nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVaqCTXx11L1BeriE99pRgL/jN/1xJALsItqZahAjaM=;
 b=ET717MdnuDAbCnaTVNJpDYzgrnKld4MuE9dsW8GwDs3HclD0FDrLMeSgcB9u43zyCu1pw63iAk9s1y1ba19ICp+5zjGXgNx65K7NWBd+b+htaHdYPQf8FygfSlSvNdBgp18IEyLhTg9Dob+xwUXQAQNOoKieebQyRkSPXcgdzVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB8003.namprd12.prod.outlook.com (2603:10b6:806:32a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 21:08:55 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Wed, 1 Jul 2026
 21:08:54 +0000
Message-ID: <d93861b1-9acf-4d9a-a17c-84cc146c3f5d@amd.com>
Date: Wed, 1 Jul 2026 16:08:50 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: K Prateek Nayak <kprateek.nayak@amd.com>,
 Jethro Beekman <jethro@fortanix.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
 <8477525d-55ad-4fc4-b7c6-05bab3d7a861@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <8477525d-55ad-4fc4-b7c6-05bab3d7a861@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::23) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB8003:EE_
X-MS-Office365-Filtering-Correlation-Id: 43cdc9bb-da1e-4f52-96c7-08ded7b4f559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|6133799003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xXbZEfxaeZm2qonn9hi63IGmxY8CADgoNKF5uNWId/pvWKzr022DBMCUP/f0dtRAp7L1FWWzM2UfwrdPE2ZgYg23BhC4CmNRyx2KH92QPdUTGfrgE2kS2vHfvpN7BV2Ze2QHBRnpefG6zeAS50j/WqZerPnw/l7suK+8/Dy2YfxbcX7TEA4yGhL/xXP/D4bJhf4u8PwK0dCz668KNploruzOHQZ2HJ5/4v25El5MzYum6JGT7khmtgSMB+aLAh2kkWkSta72b8rSSCVtD+aZnylv0ZtPgBqrU+DcJAy7o0GY47TTX3cTyCB1c+A12RtFZyx2yZjuKEb/zmiJjpJrnVRfDbDVA5O/FQifLjB7VfopuZarMFAhN/2K05hnYhAsu221vqz2JjzFnac5HVwFxzgaY1OYca08Qzrm5jdNoF8IMamLnG8bIZ6VnCoZ423RnepsGHrSUDSEsgzDJVqD3v1BL1A6Zn6cwWvNYoOUdZp7cXA7a0cIYSVyA94PcOKyhRVHkCEVGy1luE3deNJo9CEbD9s1mfDFzFqMVHNGk/Wrl9OZCvlcSXvYGg1GfrF9TLDOuBTDvC4Z5RD6zNvauFWu08myzDbWUW5b69ThlnYY21bpRLF8IGfQrHu2dmbKBf6TmEVynachhFSOJKgAdQljppiRWO3KArnn/d2nMePTEtdepU6qjzVeUsKQwdVv58Fb9cERYAeLBlOQQ6MJsA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXRRVXFaeTRUQ2JodFNqUzl5SU9NbkRTSXBYYkNTVEtwRTFORU5lYlBtTXJE?=
 =?utf-8?B?d1FhZWlaTGczd0w3NXZEUW1nVms2bGRaZlpuK0pnYll4eWk0WTVWRkMybnFL?=
 =?utf-8?B?eGt3UHdLM3RKZDB2TXBNeFRzVm00NVA4V01GeSsyUkpLaGNVbGZWUlpzLytJ?=
 =?utf-8?B?UG5wd1R4L01aTUxTbGgzTVJOeFZydEJMUGNZTWN2M3pkcHkyTjI0RlRxK1Bh?=
 =?utf-8?B?dlB2aXFGMHBaMkk1bTIvd0hhYzhxNFdUMklIM0hUc1pPMzlycW4zOXV4SHp6?=
 =?utf-8?B?UEFOWmFGYUtNT3NrTFQ3OTBVQXRpRE9lMDU4TDcwdTZ3M25NTVBid3NnM0ZM?=
 =?utf-8?B?VEhmRWlCeUFReGdJZVV5T2ZTSENDVDhHU054ZFg2dGZiamkwdzQyT0JESEhp?=
 =?utf-8?B?Qk45T0Uyd04zUVdGcU4zYTNnZ3JoU2ZPdkhod2pWdkNHa3YwVmlhRGp3TzBU?=
 =?utf-8?B?R1owY1hKOTk2Y1VqaU4rNWk2UGM2SmpGQVFkbTQ3TEhJMUFqS0s2bjVYc1pV?=
 =?utf-8?B?THdOZGxPaHQydG9YZGFpNUpQb2s0Smx1N3ZybFp1R29nU2p3L0pyRzgxajZV?=
 =?utf-8?B?VEl0ZkgzZWtLbVBweFhpRVFLWnYvK2pGZUxKY3pHVVo0eU9kOVVQTmJMa253?=
 =?utf-8?B?VWpNZ0FaOWh0c3pFSGdsSHJQYzA1eFpEc0JkcVk5aGpjbHBpR280dHROQVhP?=
 =?utf-8?B?K0N0Z21oc0o2WGViUWJmZW9TMndmTW9SVUxta2U2L0F1em0wRlZrQ2ZydUZE?=
 =?utf-8?B?S29VUDZ1VCtZREdJTlFFUDJFZDFIMXdJOHk0RDBVR3lqT1A5RDdBaFB6Ynh1?=
 =?utf-8?B?czNpSDQ0UFVGdW92b24xZzVGSE9qL2RnWXdRY2tFY3djdWphZHBFNkR4T1k0?=
 =?utf-8?B?K25WTndtL0ZTTXdGWUNkNHFmQ3NwREtZcUxUcGlWRUNpRlgzU2huUWRPTnlW?=
 =?utf-8?B?Z21STG4vb2tlaENTRS9tbERaVXJHQWk4WnlnZGdvRWFsd1VCR2hWN2FLMnZO?=
 =?utf-8?B?WTJUb1ZOYnVYNmo4TTlHMVFteENvRFVVQ2JxcVdZelo3ajNXWFZCVUZab0k2?=
 =?utf-8?B?RENIWWNwbjU1cEd4YnI4NmdmVDVyNjU1MnNRYzBYODE0cEdoRnVaa3c5cjRr?=
 =?utf-8?B?NW9ZMUIwQjNobC9aWjJPeW1DTjc2OFRveXg5YklqU0ptdmQ0SG1FVzd4blMw?=
 =?utf-8?B?MUN5MWJaTDAyK3g2Q3pRSlhmckIwS2k4bnZUOTJocWQwaE1Lc3IrMS9la1B6?=
 =?utf-8?B?YkVta2dxdlJpSW5tekhXWG80VkhhVmlKdHE1dDhVVDZiMUdlMVR2S1VpbXFM?=
 =?utf-8?B?OWNxWXgzeU5DY1JSSllmY0h3Si9IMkVvUk1QY0NJVDhOZ2ZoSkVyOTA0RkJa?=
 =?utf-8?B?aDdOVTdBM3ZaUWkvUFB1NjNDYStEUFVaVjNpU3VEN3d6NXVQaFZ3S0JTYmZz?=
 =?utf-8?B?RUVHdFhlckJBWERHUnFVQjFwVVlEY0tzbll3aHo5SktGZGozaGFzZ2t4ckVR?=
 =?utf-8?B?cGg3ZFl2eDBQNkRHRUo3Mkc0Q3VBM0ZoQnZrWWRJSDJiRUdBdlAvNVkra3lO?=
 =?utf-8?B?ZUY2YkErcWVvdUhmQ1R4RXEwRStTNFdMNCtFSkJHaldGSEtqNTlOaS8yQUp0?=
 =?utf-8?B?OW54alhJbkFDaEhzWkN5VzhWclZkN2lRQml5elU3Q0pzQ21kS29CRmVXRHJu?=
 =?utf-8?B?TnlJZVhQMnJBRHl4VU9XRWc5ZyttM2k5b3VYcEVJS1QzNEMwcmowcGw0Z0NN?=
 =?utf-8?B?Z3VUSkY1REdZQlZDZWlDVzVySzlZeVRyY01BYjFHOFR4Q1Z1WTZKejMxUkR1?=
 =?utf-8?B?NDF4V090NFpyL1JNNVlYZWswNi9Ja0JwdmlTSXU0Y0VRd0JtS1d3OTdkY3NI?=
 =?utf-8?B?aTErRVk3bklFcURuRGdsak1Xd2lpR2c0aUJyY0xHVk5oMW5lT0g4bWJ4THNP?=
 =?utf-8?B?U1BhUitkUlo5UVFJVGdFTmliMXMwUnJFM1NMdnN5NFV2MWludWk4dy9NSlNX?=
 =?utf-8?B?czJ6WGNCMmJaUGJISHFhdVIrZ21PNm1HRTduRVQrWHhwYVcxb2FkWVhMS04z?=
 =?utf-8?B?VFUxZ21jUWl1WDdwTEJlY1pVc214bE0zZHE0WkxheVRXYTFTc0pvbVNxZUpj?=
 =?utf-8?B?VnhxZVk1M0lmTm8zY2l4bzJUMWtONmlhQUFzNy9FOC9YL2JvdGJIVFZPVnhK?=
 =?utf-8?B?RmRrVkhGT1hHTkx2WE56cjlkQW9WRVBZMmRkV05iMUxjeEMwZW9HeW1ZS0Ev?=
 =?utf-8?B?WTFtSkQvY0ZLWnNDRm1taGpwZ2JzUjdaYW9YcXBtN2pGZUdlWUZQeUx3b3dU?=
 =?utf-8?Q?57r2U8dYg+GKWlGN8D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cdc9bb-da1e-4f52-96c7-08ded7b4f559
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 21:08:54.5964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Y326bqOtUunSgKqgseD0lRcQ0VfS0pEmw9sla0oYZoF5QFvwvlPxkf1SIxsUiNZlCsIxOe9lrexU4jaX4sQIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8003

Hi Prateek,

On 7/1/2026 11:39 AM, K Prateek Nayak wrote:
> Hello Jethro,
> 
> On 7/1/2026 3:10 PM, Jethro Beekman wrote:
>> I don't believe my concern has been addressed
>>
>> https://lore.kernel.org/lkml/0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com/
> 
> Quoting your question:
> 
>> I think this is too broad. If I have a hypervisor that supports SNP
>> virtualization, a (non-confidential) L1 guest running Linux should
>> still support CPU hotplug while also running confidential L2 guests.
> 
> Ashish, Tom, correct me if I'm wrong, but I don't think KVM exposes SNP
> support to L1, at least as per
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/cpuid.c?h=v7.2-rc1#n1221
> and only SNP initialization disables hotplug - not the other variants.
> 
> L1, running a confidential guest (SEV/SEV-ES) should still be able to
> support hotplug since it doesn't go through SNP init. Only the base
> hypervisor can setup the RMP tables and go through snp_prepare().
> 
> Also bsp_determine_snp() should clear CC_ATTR_HOST_SEV_SNP if it
> detects X86_FEATURE_HYPERVISOR so I don't see how this can be a
> problem for hotplug in L1.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/cpu/amd.c?h=v7.2-rc1#n368
> 

bsp_determine_snp() only sets CC_ATTR_HOST_SEV_SNP when X86_FEATURE_HYPERVISOR is clear:

  if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
      (ZEN3 || ZEN4 || RMPREAD) && snp_probe_rmptable_info())
          cc_platform_set(CC_ATTR_HOST_SEV_SNP);
  else {
          setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
          cc_platform_clear(CC_ATTR_HOST_SEV_SNP);  
  }

So Linux running as an L1 guest (HYPERVISOR set) never has CC_ATTR_HOST_SEV_SNP.

And both hotplug-disable sites sit behind that flag:
  - snp_prepare() is only called from __sev_snp_init_locked(), which returns -ENODEV early if !cc_platform_has(CC_ATTR_HOST_SEV_SNP).
  - snp_rmptable_init() bails (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP))) before its kexec one-shot disable.

So an L1 guest can't reach the disable at all; only the bare-metal host that programs the RMP does.

An L1 running SEV/SEV-ES guests never goes through SNP host init, so it's hotplug is unaffected and KVM doesn't expose SNP to L1.

So there's no impact on L1 hotplug currently.

Thanks,
Ashish
