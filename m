Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F0247DD40;
	Mon,  2 Mar 2026 20:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481647; cv=fail; b=puH/jk6sK9jb1kNvV8Tv+mjqgfj1CVKvns+Dqb4IAd3WJkWvem8YXxDYjNMyr+lVJTt0JvzT5rvv/AwZgvHZwuy16u5tL5TvrxNsnkb2Kz6PVPX+A2L0hp79bVdl4FU+K0gNxMLyajH6x+p1N+oQur5SL7TW1jXgY99PcSHJTuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481647; c=relaxed/simple;
	bh=Og7Xi4DTq+/DWhCfbYJzprIvKpj9ubHFTtlN8GUhvhM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DDTr9prQN2CoqcsSqaFg7YHKR7oEpdJQWJ0amV/ewlEABDrg6hSGBRvR3ypp8SAGzyO79CwbtHECbnJRJebEreeuTcIng1Z94X310mHXEVZ0HwKvFZNHMsT/7kS3pH4VF9itKhZnWOI7F2AN+D27Hf6PmJ5U8jzJAPaxD5817J0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XmyA/FYZ; arc=fail smtp.client-ip=52.101.85.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XmyA/FYZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5oC6Mf4NeBnma4NAdYnatyHLyzCFEEO3lWhFJTdFVcOfehlOn5uuyFMT1uAEX+0nZRQsblvyt/mQ6Q10DmnMkD39yiOAxWxC4EJKp+Y8SQDT1LK8YV5pm15PIt84fq5Vj7ORQtwSvpbFtb3k7vZLUAxq/DmyffLpi2peD41kljGkbqllwyHMPEtJ0MWYqkR/U8V06VSPCRm7CV6xObFTmL4PQSDIHpAh4qHYcGe4nHjXHf7dTpaJetGF3BtrsPxES+9HPjs0/QSAvbEb9PLXbIXwllK1kIiSjWsBxLKUasg5wl56m6y1MpiLseCVi6vixbrAJXBRiSOUmKlxlV6pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8PKdjY+rSzy9ge3c4IWC4DQSZsF3HNAweKWxPkE6dY=;
 b=fBQAYhFNAaAz+V9+6I5gFQNJYJSmHE2DOHtb3G4zyPBRAfCuijixK5+lCgvm/WfBJqT582zQ7maHL8TyXq8w7jmsKuoT7U0ebkOcZhjQjr351kyBF5NdggZDtOzL0Qp6HtSggFqlEZjUyrhyCkLAXDC2EAEwHTcIK7DwBb0THdQHiXn0KLPZQBtJA4sO9Be/qK6XlH1mn4+OKnKUQ2E2kTuuVHsKWnxYCq+WT5uJH8332B4EteE0W7cRswKTt6do8OANH7iO63f/EZAMoBBDIEKW/1YzeWPCPFja8D5rPH27EIO95rcIxyi/TxsIR4hQ3szzfy+a/h8RST2b7lsKeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8PKdjY+rSzy9ge3c4IWC4DQSZsF3HNAweKWxPkE6dY=;
 b=XmyA/FYZ38w1fbPf1YZFJtkYhnClqboi/LCQav7uUfdP30lymoXoM1GjuUpWizcwkrDkC3kxHDwK2iD/MFQoeJfGY8vhD0BhDcFPRSCGZi/8tQ73IvDivthTebmF3kKlFOng17Fgq9ppm6CSnYVnu0MAxy6R9LluZZyvYpgabC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 20:00:42 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:00:42 +0000
Message-ID: <c7fc7fb7-4c29-4f4c-809e-8e62256af9c6@amd.com>
Date: Mon, 2 Mar 2026 14:00:24 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] x86/snp: drop WBINVD before setting SNPEn
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
 <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-5-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-5-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:610:cd::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4044:EE_
X-MS-Office365-Filtering-Correlation-Id: ef017519-fc08-4c4e-80f2-08de78966202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	n9+L1mX0SsXsbdTyokhtRogs07Qv51r8wkq4lbm1wJKPU2sGgLwVuur+xQ5zo16a5omxY/xVNqFLtyPEAaLO6NvnhkcgA+y7UrV9YZzhV8AStJJGKhywnzIto7u/HWh5KRADlXXHH0OBu5KqohHXlXI51wH4iBtQfpqVep8BlAWwG3oIHFGTWG5uC7YZi80IzpJ6LyPirpPUWyuZGkdU7PioHgghuPkOrRqTxzly6twttyBKc8Ux2rJu+6zrcT+E5cwqLXGwJlrz+ZXxv9PwElk/tPKvvLhvyMYjUiOKXkm9UbJN7F8THt1SOKTxmVQO71I9undJznuHE+ut5NxC6MRvirVI/uTA5z3vfTH6EtC5locnsOgOn3vqPF4l3mhkc353LnpFteJEXKgHK8enWPA0TVlTAvRUHekKzYH7c8ZOUYyzXCx04YxBnEqE+CBSSmuWvRyuFLMfquuhHtYVgKpvFL6Dc2TWDOwlDBp9Zx8nwXSQgNPdCFDTzrVo/o/X9rNxZI9sTWq8aBo5VMlgYd4hXBA47XGKaMgMqGgFX1+UFLaOsDlmHvPsfXWAAvnVHY4SNcV9TjlASWg1QzodQ6LaYMDA6iGPE9mtqlo60fyjBrqVZ1Vd8QOvH+zxNHbZiCZiBGfuLE6qRWOrUU5NIwt5N0U5CwpJ6FKs+fkVnh98t8/PzYBMtGquovCy4XToVjoBO1xMBxvTG4Q9yhCddclYJpZT13x9ga/2F/fwFXtnNjnyo8xXZRiKacfvC+ORTFcKa0J1yGyWHSS9N6J1UA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ky9ycVpXOXBGVEM0bkFNN01wQkQ4Y0M4c3RUdWZXa1NtQVNaZWZCMll0ZHox?=
 =?utf-8?B?VmZEU2JFOWhXSGUvd2FhOTBlOE9EYnQxc1o1SEdNNEhHNHNDVzliRE9LK1NP?=
 =?utf-8?B?Q2treE40SVdwc3dJMVVGcEdTSWFXY0ZOTGZpSjlUTGZrS2d3SU5IZ2Y0Z1Bu?=
 =?utf-8?B?ck11UU04N05hNnNPZDhlNERqeU5CZzhac2lsV2owNHhSY3B4QnlRR2l5WWQv?=
 =?utf-8?B?SkJwVEtBQ3h2cm12RWNHcEJhbyt3N0M0SjhRRktZQzh5OTJhMUJsZEw0TEYz?=
 =?utf-8?B?Kzh1aTVKUU42U2RzbnRMVXpINmNRYUVQWWxyV2tFZGUwd0hHQ3owTmZLZnlR?=
 =?utf-8?B?dlZNK2dsWDVPbE9YbDNNQ3U4dTFyWmRrR2lLeG5KUXVDcno4dnBObHIyY1Zv?=
 =?utf-8?B?aWp4R0x2QUsxaHFCNzh4UWRsZ3VqaHZoNWZBQ2tLUVhlQ01VV1NwMWVkREJl?=
 =?utf-8?B?MmVEb1lyZTRadUVvZ2ZlVmxFZG51QmVySlVTRFNsOGlLVlA0ek5tVnNWTVQr?=
 =?utf-8?B?WVdCMk5LdjVTblBGdlZsNHgxYU45NjhtRm9FMDQ5YjRUZTRJamdIaENQNGdU?=
 =?utf-8?B?UkRXNHN3U3VmTnlMaXRtS1FrV1VFVlJMWnpDcm8vY2hUbnRscWxybHJoWnhk?=
 =?utf-8?B?NVJNKy9tVUxPWVNiN0lwZHRGWU0wZUEva01ZWkhST0Jwd2hIMGZvbFBvMDhN?=
 =?utf-8?B?NFcxMXlTK0t2ZElDZWZZY1pDemNiQ3Z0YlV5eTM0Yjc2L3Y1dmF1b2k2VG92?=
 =?utf-8?B?R0ZnOGxneTNvUHVGL00vbnYxNkJSSzFtZENJd2VPOFBBVXlwcW52VGlGVG1G?=
 =?utf-8?B?VXp0QThHK20vL3E4NTNaUnR4REk5LzRwMEZQSWp2bENsSjRBQVVLS1dzeTlz?=
 =?utf-8?B?SEgwR2dMMS8vOUhlSEdjQ1dMSUlZWlNhZW5UNlYyaHFTVXZRYStpR3NiY2VY?=
 =?utf-8?B?alNpNk4rbGJGYXE0aXprSThVM01HYVU0dnE3dUFqWTRqM3RBdktLOVh6Nndr?=
 =?utf-8?B?ZFg5akZ2NXIxMldPRlFVQi9SUXppV2tmVzNWN25qOFd2Q1JoVC9nOTFHRFBB?=
 =?utf-8?B?UEVjeGNaMXNPR0VuQndoMktZM0hOd0oyTEsvNElnd0hjamRMaDJtc1FUeCs3?=
 =?utf-8?B?VXJCRUY1TTZPeFRabWlzTVRtVFI5am5VS044Wk9FZnh3TFN5eTVSU0liVGNp?=
 =?utf-8?B?ckpCVVhuS29SOHBadXpvVXVEay80bkFyclM1MWw3dnB2WkhSQzlha1ltaGxp?=
 =?utf-8?B?VXE3NUV2VWc1eHI3ODBLc3ZZanYwK3J5R1ZGVitJNklpWUFpN3diUnhzSklM?=
 =?utf-8?B?TCtobjJoVDVISGhaMXROVUNGUFJiOWpscmZZWlljTEtyVzZwcVo0dTRGUUx3?=
 =?utf-8?B?L1BuaS9TSyszdjBUNzRzcElWclgwVnl2Sk4weER3WmpDREdScXM0ZFlaSTNN?=
 =?utf-8?B?Rkt5SC8rL0lpaDBvUldOdmtvcFBtdG0rWi9adW8rWXJzR2tqelNOSWVSSlJi?=
 =?utf-8?B?ditrY1N0MEliQUVYNGF0T2FpUFBuU0psZ3NtV3JnWGljdUtZTkpkL0c1REV6?=
 =?utf-8?B?N3diNnBVL1dpcVpEQVBxUFFGdVFVbGJDWmUwL3dPSmVFMk1BOWszamJXS240?=
 =?utf-8?B?MGFFcVhVUmIxYTdmV25Ia1BnOVdrdFNiS3NJMElQZnpvNFhTdzJobXJ2cmg0?=
 =?utf-8?B?azUvdkZFUWlKbC9veWhta1ZkZWFGakd6VnBDcWpnNlBUdGlRc05tdnZYdU03?=
 =?utf-8?B?d1J6dExVSHY1dWdHSjRDSWhua0UxOUU5TjVZeElYUmY1K2tDcVRPUVh0ZHVY?=
 =?utf-8?B?aVVTMFFuSmdNRXFyMVVsV3JsMkdjTEt5bEFuaUhmRExDS2doMnh0cW5iQzFs?=
 =?utf-8?B?WXNGNG9YSWFpNVdLTzdRdTZaaDZmeUJ0ZHoxb1FoTzBkMVpDZlJ3RERLYVhH?=
 =?utf-8?B?VUxHWmJmblN1ZDV3SEJLckdFaFJZeGY0aWRYbkZobU92OGZmMTZvQnN5LzVI?=
 =?utf-8?B?M3ppRzdNSG1GOHBheVFlcm16Q3l3dGxMa3dHQmpWMEtGM0tLR0U1blpOMkNX?=
 =?utf-8?B?WmtUMFl5SmRud1FJajYrcTB5Y1NHNDhpRzYyMVpraDZkTHAzVVhZRDZHMHdN?=
 =?utf-8?B?M0lkWjZHTjZQVGRDS0VJN2xsUnNHbEVidXg1L0xLQ0phQWtrV3FwOHl4TDZ1?=
 =?utf-8?B?NU5wZ1Z1TmRJNjBsckdub0pXTGpaeG1KNlJLaUhvY3NlZ1ppK2JvbU5uSy9s?=
 =?utf-8?B?NjFsaUJFVG9XYTI5bjJTTE0vMC9QOG5kcGEwbnFTQVAwaHMwUjRZR2RyZjBi?=
 =?utf-8?Q?udlweTHv+/UqItb3cY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef017519-fc08-4c4e-80f2-08de78966202
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:00:41.9416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGdamLRASK529zD9Ptqtu2XFZVyRLiTwc5Jujhheks2ZEweac6BhsuJ/VtYgH1ViyvdJRVBZcRvoT2lrLFsKlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> WBINVD is required before SNP_INIT(_EX), but not before setting SNPEn,
> since the ccp driver already does its own WBINVD before SNP_INIT (and this
> one would be too early for that anyway...).
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/virt/svm/sev.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index e7fbbf1cdf8e..258e67ba7415 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -537,9 +537,6 @@ int __init snp_rmptable_init(void)
>  
>  	snp_clear_rmp();
>  
> -	/* Flush the caches to ensure that data is written before SNP is enabled. */
> -	wbinvd_on_all_cpus();
> -
>  	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
>  	on_each_cpu(mfd_enable, NULL, 1);
>  

