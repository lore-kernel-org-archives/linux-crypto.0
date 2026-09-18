Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012039.outbound.protection.outlook.com [40.107.200.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61282547045;
	Fri, 18 Sep 2026 22:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789771572; cv=fail; b=Wa2W0rrRHL5pBvKnLETuMCZ8b7bM1/AqzdfZRsGX3ce/mZa6TMORMEzdhLA1ofcvmuEefVTej1gTh5WSWkI62C5+PlcT43j6TvgjDSwIFJkRVINe1P+pNo7gCp0SxfdluL76aNDGp1qxuLKp+h99wf4pp+++TuZAEfxQYgW3Z1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789771572; c=relaxed/simple;
	bh=qxCSN4wNkCjrF0kDPN/W6KoTlX/CpAdfMMJIgn2GNc4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HUAqapL9gzJnMny2GfFkCKrr3JcK5PxbxdFhhaJm6/6csWMGVhaV045buv0p5wIi8k8HxpOQkn4SBTaF78Wy53oim1JZLY0s5Ir+IieEaYmNnBmAEKsgQSBIxq9QvPHEa27Bp1drHByP4bx8slQSv1sIl6CeY3GvBHvUXB2v9rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V7Lt8tJK; arc=fail smtp.client-ip=40.107.200.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V7Lt8tJK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x1vLgM76sT1OrW08QBEwrt+9MsfZz856tnEKVBpKw2jswt9A0rvOj75B4iUgfeplma4uB0IqqJ8TzGEtKiGn+KwSLT6xKpy5fucPTb3tCr3lT2+pF9CBeF2Z7zGq/YnWFPOcr0KBe43Y9rs4dpQWlW9gQjYSLzKhIu7XYeE121Rse7f92PBdZszaewJrWX0Z4rMp7cbnIVMrzZ5YJgrVy7AFarXCFdjKX3wQh20FBsSuLDhRVuIQEETMXtIfbNqbQDO7siRWbi2DqjnP7zqexpKKuM8EedTtKmcWsM+2nqy5P00EZQlaBhWNeu/rVRo1YpbXrjO5sUL3YJcB87gX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQT4spnfi8wwnwhTH+Bu8XuYkirwIl4C3XKb8PW/o5M=;
 b=HmUFIuMGvgWLWX2IcW5mVtkgN5lYF2gSUZ3HTzTyLOJAJ7GhqZ6Qb56b41rTq9GU7eIulJhtsMf0LEl0B8JJd15zzpniIIMSBIW+MpxWPzsCxyXtUYan9MdJY89Z3GYcHwZcMj4axZ9HwC2oYifj2lZ5rSthYj6htEoMMnSvHsTW74HBnMf553eO5UXSN8Ddc9/DRTkahPr/nxOv58wuipGLKY4tvyqNj/bJrNAJwAXlB46zRttC5wpWQ27GB6NGZ0UPJ9A5t/JohQVDU5LQGlz5wCuT0vanYVNGkxq5cYoH01nwgZD+FZauiD/yx+KO5VJ0nSKhR7H8PRWM9Bqgmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQT4spnfi8wwnwhTH+Bu8XuYkirwIl4C3XKb8PW/o5M=;
 b=V7Lt8tJKvQ1kvr3njWRd8NUDlVeKYKcWITbg4CnRt33NhSN4lIpNcn5/Ex2Rzakl5xACBkTu5M1PkrLrH61hx3gzn2y2C00DKJwTe/XmNPlU17xRSwNtJaO5weZfA4x4UK/IR3HKewp/grLbWAl4KWVwtnSaI4wOpWmjlQYg7uY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB7426.namprd12.prod.outlook.com (2603:10b6:510:201::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 22:46:03 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 22:46:03 +0000
Message-ID: <49aa3713-d8af-4c9d-a67e-81c1f776a876@amd.com>
Date: Fri, 18 Sep 2026 17:46:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 4/5] x86/sev: Perform RMP optimizations asynchronously
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1789594774.git.ashish.kalra@amd.com>
 <daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com>
 <20260918222326.GBaq253l7rsV04EUpy@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260918222326.GBaq253l7rsV04EUpy@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:806:20::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8510d1-ba04-44a1-0824-08df15d69e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|6133799003|3023799007|10067099003|4143699003|5023799004|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qQsJGt+NUmJGmcm3RsCMiZTm5Yyv8LmnR4StHYCyCD/PEZq1DLaTyS4/mxomF962ugGxr+aVL67uiGKhqelS/ptQAPklkTZsFPgTzqWQ6DFmhRMfgdyWZIa4EcNt3hZakc8Okqb4pRHqM06xFQ+3LZGgeZMZ8oRdrX70ylNaxQ/FNDW4eyHs0PQyPHGotf8KPnPqpeVb4J7FKUOKWhH4NkoJQVwxH+Awmq+TK2g54x4lXOlXI70uGWK3K7jxaEQ5k3cuDEYOdISpKfT/X5xwEoWc38F7l1hfQSLu9fBwp9DYWfeg88k+gURD97cUcQus+qTgkKWB1V0vkKRwAOAzTUnvmwKWTLQVUx/VyRL6a+BnqqvcGcb4Td4Ja5OyMrVcpio/5aFTiAB2G06VjmDGFOgRj9DrPPaDbShT1whg8irmi7Tk+nAWHPWC3/U95K2QoJ2UdWi4kiQ5Gir9zj0u4YCdTsz8wsmxQ69tm3OTbnfg6/+WOHWETBmjP2aUVgs99lxZ4vujbXuAu+jLSqrUfvDRHFwxAUaCrPOTkv+JYxq3OjpYvBNCr3Rb0f5tbYI3841f8op1e+Ql6U/LlVaWWf/ZWGhEaTl5B5YEJf+YLQdF0r0SBUGs63jvrYlubItB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(6133799003)(3023799007)(10067099003)(4143699003)(5023799004)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1V2Z2wzRHUwMnZjVFM1MkE4MEdFTXU4RjMxK2UrTDZ1QlFzVzVLUWVkaXNK?=
 =?utf-8?B?Z0RwdmRzVjQzNGhxUzF5VmxCckl4NEVOOFFHLythS1RsRHFvcE5yVFlDN3Vw?=
 =?utf-8?B?QXJOUXk1UUhoelpEdUxDQ3lvNnJnamZ1SjZGL2djb2huTTBKN0JzVWRobHBI?=
 =?utf-8?B?d1RKRmxoVnRBRG9OZzF6eVBvNU92OENKemRBVFRHeXdMRXhJY2xWdWhQZDB5?=
 =?utf-8?B?WnlyeHdpZzh2dE9Sbk91WXpzakxVR3lqOUtEUlg5VG5Wd0RucmczQklJUE0x?=
 =?utf-8?B?b0V2Y3I5bFNFT1hPSEk0cTd3U284ZzhEVDIvL0pvTXV0dHM1WmlzMmpRQ3Va?=
 =?utf-8?B?ZC9aeGVkaDlldytHRDEzMDZiT1ppbTUrVTMrRmRBVUNETE0yK3JVR1ZwWnhI?=
 =?utf-8?B?WldmN3NleFB0SG0yRFplOWZFOUVVK2cwSG5vOHVwekNIanhpSzQ5aTZlTkdN?=
 =?utf-8?B?MGRudnFETTlBSFBDczd4OXBsVzA4a21KNXVKK2luY0t6aytpT0dsZ2o4VWMv?=
 =?utf-8?B?K1VUOTZ2RDdjYzRhYUY1MXAvTVFVS2d3U0xrS1pqUDZTbWdxWjU3Zmx5SXgr?=
 =?utf-8?B?ZTE4N25nU2QzR0RBdTRqVlYyZjJFMXdCMUY2TUdDMmxKZitsVTlmWmx0TU5W?=
 =?utf-8?B?UXoxa1FGVWtQd1RJZEVTb0g1Q3owaWZqbllPRXlNVG9NSlVtQlVvUTNKb3k3?=
 =?utf-8?B?aVVDaG5RYW1xZno3MWtna1dHQXNueXc2R3E0REtUV240a3BldTlxWFdYZ2Ja?=
 =?utf-8?B?b1A2bUt0OFU4YnExQ3VlMlVZbWlxZ0VJUlU4Q0V3d0Q3YkJxK2g4WFNpajVr?=
 =?utf-8?B?NklqbW44Rm44aVpvZGZHVWF3Wnl2STdTcEFnSHA3RzNoTCtMQlE2NUowb1ln?=
 =?utf-8?B?MkViNnJxMGVDdnI5TVdsbHBka0FlSVNuQlJlMHRNNzV1ck83cWxMVXZkQmR3?=
 =?utf-8?B?enpycHdTbS9pU1YrN2FpbWVvaWJyd0dKNjlwRTAzZmZIMXVkdGRlSzJmcDRI?=
 =?utf-8?B?d21GVWFyWGRqOGxWanhyMDlHWC9RcTgrdGF5UW5MZVl1QUI2ZE9XWjlabCtM?=
 =?utf-8?B?VGJtdHRxZHFGcTJBblQwVjhHUEltY29iQXJqSG5PeGRhN3Y2elVHM1R6UVBG?=
 =?utf-8?B?by83QnVnNytpdlgra3VGTFV1OGZ6ZlVCNytVeTJzNWRjaXRTVFptaWp2U3Fp?=
 =?utf-8?B?UTVZQ1U5WTFRZTBaSWRmazdaZDFyWmlJUFZicHB6eUNrUDRIWjY0dWYwQzkr?=
 =?utf-8?B?N1BEQkFtYlkyK1hLS2dkdWtuQmVIVk9qSHdjRG50dkRsb1NwN3g2WGpDRTRX?=
 =?utf-8?B?eU1JclBldXBvcHZaVFVKdjZ0M3VSRXFVeTNIVXBqV1ZlR0U3Z1Noa0VhN2VV?=
 =?utf-8?B?eG9iRVJuQUt4OVNSV3lidlI1Y3VFUGtNTjJnQ0h1aDc0Q3cxMjdrWmVzNmdl?=
 =?utf-8?B?OG9leFRvc0lsQWlQVHd0TEJIWlVFc2VCR3ZyanR3aVQyclVZZnFXNU9GZkJv?=
 =?utf-8?B?SWhiUURSRndpRTltS2pFZWVlQVo3RjdObjMvNC9HSFlHS3NKZE5rd1RoYzB1?=
 =?utf-8?B?YWZFeDZYaGZxK1hacTF6VEdnN0ZSRTY5WXNIT05uN0V6Q3lPdTBubHFpZVhD?=
 =?utf-8?B?VXVJZXhBRGFHbkwxeHZoNHFXbnVRM2hCZlllajFKelJSMWJISWxYN3orSWM3?=
 =?utf-8?B?YWh4dVNEQWFWdXU3TnI4YW9LUGowS1FISlcvcFR1c1JmQUQ0OTNocFlnM1Ir?=
 =?utf-8?B?RTM5VHkvS2tyVzQwTkZrWm9qTlk2WFZSb2lNQ1dSSzFVQy9ZZjRMNER0NTBM?=
 =?utf-8?B?RUJOV2xmWS9WSGVOR2dJSzU1ZFUyVGwwY0JBbWluUHpFWWZSMy9ubk16V3pP?=
 =?utf-8?B?TjdMTHkvbDRXZEZML1RxSWJya1RFemVwTWRVR0I1N1pGVC9qNzFBTlplOGNw?=
 =?utf-8?B?eURrZ3pRY3Nac3doMmVtMkRBTTBFcnF0ZHU3bDh3VDdwMm9Tb2ZycWM0TXNC?=
 =?utf-8?B?QXVtUVFQUlNLNEN6V2tSNFFyTmg0N2tQc0ZGMXQ0b3ZjdU1ucFArNG80SWZU?=
 =?utf-8?B?aWVpcTQzNExjbWtZTnRsam8xZUFaY3J1ZGxoRUI1UVhQbXVyeXlGTnhTb0xL?=
 =?utf-8?B?clJRbjBBOGVnZEl1MnVDUWpBSnJCZG0rYnloTnZKMnRHeDdhWURaTy9XenFR?=
 =?utf-8?B?Nmo1M2V5Q3paYWpiUWNqSFJCdHpVNXY5VC9KbTRib3hDUFFCdm9GZDBRa04w?=
 =?utf-8?B?UHVWVklhK2ZwdW00OUhZdExYZzhLTnlpY1dhY0c4aWNDNDkyRHVBbHBFbisx?=
 =?utf-8?B?ajU5UjRjVlJ0cmVHUWduYnR2a1VKVjl2cjQ1b1RpcEJDUTd1TGdEQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8510d1-ba04-44a1-0824-08df15d69e46
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 22:46:03.4205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zg2ExwkFhmO3rTnaXvXMc6db2m11VA7A75RKG3l86crMhX8nlSV1ylKI0rolauQ9AfZ/V3AzllwmwU6HwSRiwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7426

Hello Boris,

On 9/18/2026 5:23 PM, Borislav Petkov wrote:
> On Wed, Sep 16, 2026 at 10:15:14PM +0000, Ashish Kalra wrote:
>> Changes in v15:
>> - Move the workqueue allocation and the (fixed) optimization range
>>   computation to an initcall; snp_enable_rmpopt() now only programs the
>>   RMPOPT_BASE MSRs and queues the optimization pass.
>> - Gate rmpopt_capable() on a static rmpopt_enabled bool set when the
>>   workqueue is allocated, instead of an if (rmpopt_wq) check, and drop
>>   rmpopt_wq_mutex.
>> - Queue both the initial and the teardown pass with mod_delayed_work().
>>  arch/x86/virt/svm/sev.c | 99 +++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 95 insertions(+), 4 deletions(-)
> 
> Some scrubbing to this one too:
> 
> Author: Ashish Kalra <ashish.kalra@amd.com>
> Date:   Wed Sep 16 22:15:14 2026 +0000
> 
>     x86/sev: Perform RMP optimizations asynchronously
>     
>     When SNP is enabled, all writes to memory are checked to ensure memory
>     integrity. This imposes performance overhead on the whole system.
>     
>     RMPOPT is a new instruction that minimizes the performance overhead of
>     RMP checks on the hypervisor and on non-SNP guests by allowing such checks to
>     be skipped for 1GB regions of memory that are known not to contain any SNP
>     guest memory.
>     
>     Add support for performing RMP optimizations asynchronously using a dedicated
>     per-CPU workqueue.  Shortly after SNP initialization, run an optimization pass
>     over all physical memory.
>     
>     As SNP guests are launched, RMPUPDATE assigns their private pages to
>     guest-owned state; when such a page falls within an optimized 1GB region, the
>     hardware clears that region's RMPOPT optimization and RMP checks resume there
>     to protect the guest memory.
>     
>     Since launching SNP guests clears these optimizations, perform them again
>     asynchronously using the dedicated workqueue.
>     
>       [ bp:
>        - Massage commit message and comments
>        - simplify code
>        - redo some of the logic ]
>     
>     Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>     Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>     Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>     Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
>     Link: https://patch.msgid.link/daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 1fecd246ce5f..94754f2986d3 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -19,6 +19,7 @@
>  #include <linux/iommu.h>
>  #include <linux/amd-iommu.h>
>  #include <linux/nospec.h>
> +#include <linux/workqueue.h>
>  
>  #include <asm/sev.h>
>  #include <asm/processor.h>
> @@ -124,7 +125,27 @@ static void *rmp_bookkeeping __ro_after_init;
>  
>  static u64 probed_rmp_base, probed_rmp_size;
>  
> -static phys_addr_t rmpopt_pa_start;
> +static u64 rmpopt_pa_start, rmpopt_pa_end;
> +
> +enum rmpopt_op_type {
> +	RMPOPT_OP_VERIFY_AND_REPORT_STATUS,
> +	RMPOPT_OP_REPORT_STATUS
> +};
> +
> +static struct workqueue_struct *rmpopt_wq;
> +static struct delayed_work rmpopt_delayed_work;
> +
> +/* Software RMPOPT facilities initialized */
> +static bool rmpopt_soft_init;
> +
> +/*
> + * Delay, in milliseconds, before the RMP re-optimization pass runs after an
> + * SNP guest is torn down. This coalesces a burst of teardowns into a single
> + * scan and gives each guest's pages time to be converted back to the shared,
> + * hypervisor-owned state.  The 10 second value is a heuristic trading
> + * re-optimization latency against scanning too eagerly.
> + */
> +#define RMPOPT_WORK_TIMEOUT	(10 * MSEC_PER_SEC)
>  
>  static LIST_HEAD(snp_leaked_pages_list);
>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> @@ -565,6 +586,9 @@ void snp_shutdown(void)
>  	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
>  		return;
>  
> +	if (rmpopt_soft_init)
> +		cancel_delayed_work_sync(&rmpopt_delayed_work);
> +
>  	clear_rmp();
>  	on_each_cpu(mfd_reconfigure, NULL, 1);
>  
> @@ -577,21 +601,80 @@ void snp_shutdown(void)
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>  
> -static bool rmpopt_capable(void)
> +/*
> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
> + * memory does not contain any SNP guest memory.
> + *
> + * @pa is a system physical address; RMPOPT operates on the containing 1GB.
> + */
> +static void rmpopt(u64 pa)
>  {
> -	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
> -	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
> +	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
> +
> +	/* Supported by binutils 2.48+ */
> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
> +		     :: "a" (pa_start), "c" (op)
> +		     : "memory", "cc");
> +}
> +
> +static void rmpopt_scan_range(void *arg)
> +{
> +	u64 pa;
> +
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		rmpopt(pa);
>  }
>  
> +static void do_rmpopt_work(struct work_struct *work)
> +{
> +	/*
> +	 * Warm up the RMPOPT cache on this pinned per-CPU worker with interrupts
> +	 * enabled, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
> +	 */
> +	rmpopt_scan_range(NULL);
> +
> +	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
> +}
> +
> +static int __init rmpopt_init(void)
> +{
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
> +		return -ENODEV;
> +
> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
> +	if (!rmpopt_wq) {
> +		pr_err("Failed to allocate RMPOPT workqueue\n");
> +		return -ENOMEM;
> +	}
> +
> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
> +
> +	/* The optimization range is fixed at boot; compute it once. */
> +	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
> +
> +	rmpopt_soft_init = true;
> +
> +	return 0;
> +}
> +device_initcall(rmpopt_init);
> +
>  void snp_enable_rmpopt(void)
>  {
>  	u64 base;
>  	int cpu;
>  
> -	if (!rmpopt_capable())
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>  		return;
>  
> -	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +		return;
> +
> +	if (!rmpopt_soft_init)
> +		return;
>  
>  	/*
>  	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
> @@ -602,6 +685,11 @@ void snp_enable_rmpopt(void)
>  		for_each_cpu(cpu, cpu_primary_thread_mask)
>  			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE,
>  				      rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE);
> +
> +	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
> +			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
> +
> +	pr_info("RMPOPT optimizations enabled\n");

Looks good.

One comment here, i originally had pr_info_once() for printing this once during SNP init, 
if you change it to pr_info(), it will get printed again at every SNP guest teardown too,
i am fine with it and actually it keeps the user aware that RMPOPT optimizations are
being re-applied/re-enabled, but there may be just too many kernel messages dumped.


Thanks,
Ashish

>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp");
>  
> 
> 
