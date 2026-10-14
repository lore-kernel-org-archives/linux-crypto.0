Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013036.outbound.protection.outlook.com [40.93.196.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D924E36D4;
	Wed, 14 Oct 2026 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984305; cv=fail; b=RsyEaqX2YNITM4uGLvJnv0dbnfP2QTUIIaJb+aDPMiqNUis4VicBM3SQD+O0ySvnxJkyQXBpF3CAshwT/YD+51OGZyVtREZPrq2cBgkZFUoBuNDaTU1rXEDUE1UKMS7Kxx/s2YJtsZ0bih1Hmu4wfrbPikZVY7A867mJbCLmztw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984305; c=relaxed/simple;
	bh=12k+oXNGAslEF+Jml8B0ndbpCLEJArYU69TYQDVcbJw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OAf1Anpfa4XJ7nzAHhB1o/Tj0nxlTIwlS17IpuWoIMY6Vs2AYEvATRqTC/YA9GIozBz6kFaDiPNMUjvmU3mvgeiToVFfN8WNPMRqI+zcPzR1yBhwKQZezN/LPvRiLpR2P4ufpDzMdFslUCJnRWsw1gSYo1iMj3Nbl2cdxuU1p+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AJNNuqwF; arc=fail smtp.client-ip=40.93.196.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AJNNuqwF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnn9otQJPb/NJLhNN26kdNAIBoYkM9Hb+uiBpWtbzNfoYyk+rIIPztBvntvCH71JrRpyybzzbh2DYSpbdOMEpi6auefssImX/GQ/ve4VgyaGw64HGbHhajcZ+9POCch2mwYwYmNj5m9J8XCIU1h4ymtFyJwM3cYyOlCdUH36NRuEdURvs+f70biqE7bfE77XSl6P48AvAnkrJLm45wFclU55l1Jmu/ERJsswgyOkuS2wRWPMDyhNTOrHXZ/IWAUU2dB0GBEeF5Q8V0aEPvfjJotP5Gc045LsygTn3cMjW769YRmFYptF02GmQWCCLHmtVxeWoEm0OXRP4iF8O7vx1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdXd7meBIaflM3AHymoTh0TSnLaTIq5ZPDrBoNP2Jqk=;
 b=cNMu8pqqLgFwLMucLRZiS/YGcTR/YA61JE0tvmUvW3Hjqrrff7ZOplLBN443OEPx1MULQjyYurWj69XN/rygdTjrhH7mkShT8Y29rfK4nTQhqmLvO/seYm4p2TS2bLcrZk8x6tAc4ZlSnQ6FKOqq8ak1HHJ1opRLJO9Pv50IejMwSEBDLOJaO5vEJJjzKJb6yV37qJ7oSikFofDKI1j+L5S4AXHvuqHkNpXgbElE2knrjLZphhLuou5uDVpbqinYjc4xTYTpzpMh5DNWHty0Q8PsQV65SotCX2ivQk57DRFYbfALd+dSb8UQvZe3k7w6DmkcK4DjN+sBQZDq/sm9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdXd7meBIaflM3AHymoTh0TSnLaTIq5ZPDrBoNP2Jqk=;
 b=AJNNuqwF/2yJjgy1xgORzezpDQ9Jo81ZTw+m+B4qCjOWkpHYC195PdpU+wmg0RmuCjIgEjAktP0cUBnZ9LRcsGznN9P9Y2f5JqDhStovS7iyISzTIEPFh8pzpfNC3smhjCZzj7Od1RDmRtcqYp/ZC/XjUHf/NHnYoW8IECXa4gI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:24:58 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 13:24:58 +0000
Message-ID: <a66f932d-4ca2-402d-9f76-628ef53a1107@amd.com>
Date: Wed, 14 Oct 2026 08:24:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] x86/sev: Only announce RMPOPT optimizations when SNP
 is enabled
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1791905953.git.ashish.kalra@amd.com>
 <11df35266257afcad3825a8e89c965bb0cf7cf34.1791905953.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <11df35266257afcad3825a8e89c965bb0cf7cf34.1791905953.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:335::6) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e129116-5173-43eb-4905-08df29f68b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|10067099003|22082099003|18002099003|921020|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	F7++9uchBS6B12bH25wwN00KtWZGi8IWFCZizbzlnMGGyXJ8tLtVz/HpQSPKxs2oXyoBCvrFNYrZ2Zf4UhiGLzbN7Rfe9nuebQyVOPXuB4eFrNFBwF46zvkz/OCa2yIdKyOejOjOs5TCL6MjUb3RwSn1kkQc3Pc98r2H1EOYOzS5NVO1uWeTeSMiVmj/YO6qM0Fitac5v7UI04/B9XNABFKJ57+UXcukeNCRp211PjdXWEI6exOfSRbnM62mx85h7kZUaGMhb8F4g8YUafVvfmYaTQr3TZ+pFDvzhciRCdSJdMI5rPXWi3BSueDPQ+reDL3qKdbRDDb5btklGwFEWv7Xe88UgBRClIjuFkUPw7iWIcalFxJmvUzrl5InFKXCi9wJi7AsMDhJBURYKV1q+IpmfTdmHoT3uiGwFD0YsJM83mSp+oFKj320QIUyL5IFB0omCdq3pkwZMJYSyxeb0KmPuMC3/I8jAL3MUrMcw18c8k5QFEx44X7/HF2yvA1nj44W/sU4p0RmaNfsxXWAqJnj28khg76P6aU3RLUWLriYtU/jySuQmtLX2irj0+q9Zcn95EkUyO9ShE5TcjYZevngUOofQwuYI/YplMfxbNgwRSdTghV1hcbFUos6h5dQFeX9UQi1aY5tS/1els7599fxyfoso5nDyEhN8bQH32hcZjL45N6ofz2UD6yVMpSFsaS4iNWNgymcRp7sjlberw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(10067099003)(22082099003)(18002099003)(921020)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVpNM1A0NFZpeTEwaXQ2QkZXMWhxNTR5TVNhakc5dEJ2TzJSOHN2OE5ZRlNx?=
 =?utf-8?B?dCtDMUd2TWVIc05iYlkvSTk5U0pwUDhIQUVXdk9NT2tWTEhib29DZnlHSWNG?=
 =?utf-8?B?V0dMREpqc2tNaFNOSzFGeXRxdDVWcm1IN3pqS0FqUmhZSktMbzF1eUdsTTdU?=
 =?utf-8?B?L29XM2x6N2s2VVRKbDhBOGxIUFg5UEFhOWFCdVNuUGV6alQrVjJ3K3hmNVpZ?=
 =?utf-8?B?dFZBWFdrSDFJTzhBOTlLQktkaDdIM3BhbXhVb2xXRzBhYkF0OEFQL0xhb1Yr?=
 =?utf-8?B?b2VuR0lsN1NlRVgvdDR4RStOOFU1TzJ2dEViYjNNYU4yTlg5dzFEZU1rcmNN?=
 =?utf-8?B?dFZGeVdaKytybU5xSGMxTUZTakErc3QyVk9oL3l5dkFKZk9aMU9PQ0lEckF2?=
 =?utf-8?B?ejg1VUxlQzEzK1R5dS9oUnYwczlYSjJ6RUE5dWpQUG1yWjhiMUVaY1orOFh4?=
 =?utf-8?B?dEN6NGdBdnJsVDltQXo0bGRmL3FpZUJaNzFvMHVLb25PSmNHcXVzbERxaWdv?=
 =?utf-8?B?T3l2Y2dGREdLQTFZUng1ZFhCZnRyVWtjN0ZVTjdPQXRRQ0lQOEUwWXF1aUFW?=
 =?utf-8?B?MFJIc1NFMk9qT0FmUVkveGZBTGVqbXIrTHAwdXFuYzdEMFRYcDhTV0h4ZzFC?=
 =?utf-8?B?OTh2RktPdDRnNlV2bi9VTStpZlVtaGJ0cTJSanY2OFN1aWZwOUV1dml0d0Vk?=
 =?utf-8?B?WjlmdHNCQVdZeDRwUFhlVWtxTmhPa0VZQU5ZZ29FSk1NMHFuWExTUjBoR29i?=
 =?utf-8?B?ekd0Y1JXRnlQUnNIZmYxKzdpdjVxbHlTbkFXYXREYS9NbnVINFJyd3BuYURX?=
 =?utf-8?B?dG9uT2kxdklIQ0xMcG13L2pnYlRpSjA3TTRFNnRPcU5kTzVGUFVQejhkTUF4?=
 =?utf-8?B?dEJIRjlGb2hpYnYrZ1F5eDhJYnlPZVhrekpOTEhQOEY4UFNVYlZoTUpNTlZT?=
 =?utf-8?B?OUduZ3dRS2JCSVBhc2xIcjgrMzROQ0YwV29pYng2Vk42NEtVUDhROFY5YkJK?=
 =?utf-8?B?R2xSaFJodXl5T054VkFDaXdxSG1pMjNFcWpCZG1qRldod3oxbTdIdUwrMVQv?=
 =?utf-8?B?bXZuTmp5N2JoTFg3enByb3dJV3pTcEpvTk51bUxhcjZQS1ppVkJ0bDkrOFlC?=
 =?utf-8?B?QTNZSUQrb1ZDcUQyTmNrcFBQZzE3RnlWM284MDkyTS9LNGJhVmhXU0Q4YWtt?=
 =?utf-8?B?SVRLUWVLYjcyUHo3RWhsUE04Y0hBaVdSb3BZeXFuMVBVQXd5R214ZEIwUGJH?=
 =?utf-8?B?Y2ZXQWhtTEx4T2FIZWErU3JoTEZMZEtpaEM3RTB2NGRhY09XdTJ6SVMwQkpY?=
 =?utf-8?B?SHNvWmZzT1FMckRxckUzSnRDK1FEOVJoYzZJdlhKQkpvMHNyeld5bEQ2MmUw?=
 =?utf-8?B?RVozOGVmU01KQ0EydU5QeE1Oa3dGS1dBM3Z4MzFFTW14cktSdnk1aVBKS28r?=
 =?utf-8?B?bnArVGQzYmdrY2ZmSUNYd0d5ZkM4K3dkb2pLWnMvcUZFL0ZsVGhicXFZTEdv?=
 =?utf-8?B?Z2FqWVlFQWN4c0sxUGxDY09NQmlYc3JaL3VITkhXZ25EeXBiYmxNdHJLcUJj?=
 =?utf-8?B?WU9xY2RVQVZwcTFKMEZ6NjcxTTZjOThTSnhqQ1lWZGkwN0dWTHRZbVluN1Bk?=
 =?utf-8?B?SGI1RmpiN0VMQXFhRGJLM3RKWWdKdkcxQ3lYVHNCak9haXBVc2ZNRXBaRXky?=
 =?utf-8?B?UXMwNGRiUjc2NXZBRHI5YWlOZkF4NmN4YkhJVzRGcTVRY2N3VTBtUTlQMHBz?=
 =?utf-8?B?czZWb050eEF6T0lIbnpHRkRsQVZOY3ZRaERnL1Y1TGhPaWlONDBQK21tUEtG?=
 =?utf-8?B?ZGhrdzFkSmRiT1NKU0tKNTVhSkRsN2oxTGRqVk5UdnluTTlna0xaODl2Q2RL?=
 =?utf-8?B?V2NUVm9iVGhpKzVLYTZvVDROMUVJamJiMEw0MGRDZEx1RGZxSUZaMDJqOFgv?=
 =?utf-8?B?dGdKVDFUaTJGNGtSbG9RSkFIQVlhUkMrcVpGcE9FL3VNM1YyZExFUGhKdGhz?=
 =?utf-8?B?Q0NSbHNtRnFRVEtUK1lCTkpKVkZlMWZyK1BwaUpta3V1QUowNU85VzRpN015?=
 =?utf-8?B?L25ob3ZRdlN2eEJBcG9wMExRVjJsMis1R1VIcWpmL2ZYdm14QjVKSzdudHk1?=
 =?utf-8?B?S2VLRlgvcTRIcXAwTnRoY0FFZ0w3VU1kZnZXVnpXRVJzNmUweDdmMXpBVlk5?=
 =?utf-8?B?OVNHK2dqSGhKclhKMWNaRitmSldaUHQ1RDhVamhycU1QR2phaW1SQXJZMElM?=
 =?utf-8?B?ZUdpSGhWNXY1VjltbG5PNTl3dXZiVmhwbGlwN1JaYldnUDRHTjNoelJvRnZN?=
 =?utf-8?Q?2sC54dGS+7FXaTOsl3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e129116-5173-43eb-4905-08df29f68b01
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:24:58.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrlH9BvbK7GS674B5RTnakRxEejMtxE/g62H/K5WpkK6VorPjPbMa5biX6a5uJL6cmLsKchRf0wx8lof+D2J9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

On 10/13/26 10:44, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> rmpopt_init() prints "RMPOPT optimizations enabled" gated only on
> X86_FEATURE_RMPOPT, which is a CPUID bit advertised independently of
> whether SNP is active.  On a system where SNP is disabled in the BIOS the
> message is still printed at boot even though RMPOPT is never actually used
> (snp_enable_rmpopt() bails out on !CC_ATTR_HOST_SEV_SNP), which is
> misleading.
> 
> rmpopt_init() is only the software setup (workqueue and the delayed work);
> the capability that matters for the message - an active SNP host - is
> checked in snp_enable_rmpopt().  Move the announcement there, as a
> pr_info_once(), so it is emitted only when RMPOPT is actually enabled on an
> SNP host.
> 
> Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
> 
> Note: in the posted series the pr_info_once() lived in
> snp_enable_rmpopt() (SNP-gated); when applied, c6c6f156d192 moved it to
> rmpopt_init() (feature-only-gated) as a plain pr_info().  This restores the
> original placement.
>  arch/x86/virt/svm/sev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 43e4945e6cdf..6f5f4ee821d0 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -656,8 +656,6 @@ static int __init rmpopt_init(void)

Should the check at the start of rmpopt_init() just be

if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP) ||
    !cpu_feature_enabled(X86_FEATURE_RMPOPT))

so that you don't even bother setting up the workqueue, etc.?

Thanks,
Tom

>  	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
>  		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
>  
> -	pr_info("RMPOPT optimizations enabled\n");
> -
>  	rmpopt_soft_init = true;
>  
>  	return 0;
> @@ -690,6 +688,8 @@ void snp_enable_rmpopt(void)
>  
>  	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
>  			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
> +
> +	pr_info_once("RMPOPT optimizations enabled\n");
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp,kvm-amd");
>  

