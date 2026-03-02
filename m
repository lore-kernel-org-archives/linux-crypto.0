Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010070.outbound.protection.outlook.com [52.101.85.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8DC48B38C;
	Mon,  2 Mar 2026 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483750; cv=fail; b=cF1M4iy14zqoD1PDz+hHPt2sbqrSC3JDHByqyy2hdA109yncj3OSo827ZZkIpHSQUruGsWzr+ctjtuMQEvU3qrr9Qvnm+MekW23MxBGM/RUZX5QnyEAo3JVUx/XD5I7oaGgQ1UVsNW4tqN6Vq9gnL6Dg6dvZvJHFBYHmh3poAhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483750; c=relaxed/simple;
	bh=TIcxCc7VFS+qsWRm1FPJA+DuNh8J8xMk2DakXNgnnkE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pU8tSqgsksIgRZZhSpoAfjpxqviLdKVawLpYqCTH/VsGHuNmWPvlWh0ayxd2Vq5viN8dAa3xyv+6/5rBQR4xj9emqWLVKfm7MEh/EVIiurH1aXPwckJIUN3EPYqlizl/oDS9mZx+Da9lj9X1KIZSuEdiTyDsMTUKSicFhOpWSIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PuZZD2Dd; arc=fail smtp.client-ip=52.101.85.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PuZZD2Dd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d714b8R6H/RZaRsO0Mi7QhFEVzJ9Zx7f7Kgsr+2GEvi9mZZvV4ayWh0onPlcrsEKqLllnbaQ9iqDggFK0G6daV4soUp6ZofM0i6anoBM6mGkeS8Sh2WxzgMfi27AVnOHr2Ta/n0Aha1hsmZYmVso1xEOcCSy2T9ioHlEIB2LDylvKOHDJGYmufwbEbVZc3SmAQP1zxh8HRfd6UDwVVI5tuKN0eDbmgjmYDmv1guAVNGPpBtNahMeAqpFe1Y0iAL+7GGfbYIrDE+7cNE4jAyo5IPGUpubQ1DFqBWQztujNtXRnMMQ/GtWtxcw0jhzN2Fpf39f919/4WynjxUTyzi9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3GBoeZiBfQx2jdnPkECkAZ5tDIMcGT6ge2ksxmoPgM=;
 b=aRU2lB4FgVohSdcqiHJJke2arAl0WjveTqi55uvK8jHSSSAZeT9kw5dh3DmeLNbhrufhuI18CcO7krw5nt5pI+65tR8LB5F0HrGeP59uZdl4Rw1BySt1EyrdMzybV0+rC+oAyPray/+DvkUcAEVrytAgBCFgKtTHPlDTkT0h3x0jJ9lhAAi2sDUnGfXqgzGi0ttoBfrclRu387foBXuVM02zpvmz5Li+OfkbSu2qP59i+UUFJWrVltkvy7Wqxlhx17i1mbcM/RJzPnZmVmIVdlUcz53ga7X6AhLAMuHYsI9fcAamnF02CpATy/NN5WWmOGvgPuvwUbhKHDN+x/WaOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3GBoeZiBfQx2jdnPkECkAZ5tDIMcGT6ge2ksxmoPgM=;
 b=PuZZD2Ddx8c7RJdyKc8uFrF1W6d4Uk+0bH0jWJadvQwxTg36gQRVsks/a5qmGajCi8N56c5klTYpLkzxckEs6fzRy/wc8tlUDvXVPn9Kcs6yPWWqNCqYsV35y11sc4JIhbaKDooRtpv8zQ7/1PMqqP/xE9qxzshBD4lF7Vtbmnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 20:35:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:35:45 +0000
Message-ID: <b3beeb84-51e3-46df-8b9b-8808f478c408@amd.com>
Date: Mon, 2 Mar 2026 14:35:38 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/11] x86/snp: create snp_x86_shutdown()
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-10-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-10-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0137.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: d16c5109-e3e5-4dab-1542-08de789b47d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	aAnXM3CilPydjLzGE7CiQ/4smfd/cKNGLsh2sHL0LsGHxauwbl8idUsz/RhUmpSn+E5c2Yx9Hd4jchqvL20bLBeemVO4kBqih/tfcVdJqa+sHYqtZ7XqtiV35XGMjLc7XydAmDJo3DpLlBksrXJHql9c3roJQzw2DJVAjlsJqh4oYSK7nhVm2hKufmJadRWZaUNKM901+6pFompwPShYPfCuUFlsdKyRcbxhJ47T0drNVqVlSXdslhXUKPbFUE1mtFfh8X43MY8GrU1nX14ej1jBWGRKXgF0QCbi6JcSEoShLzOXkc6BU5Xj0s9wYu8f6haNtDlVy8kjouN3zz7I3mKy6WoAof4YKkfQqP/62diKHA4fVLeYxxtSkMI/T7TlJC5/hfrBSjBU36LUFKBQ1X9yZjsdgJjBFpt/pEj6OJsP3Ti9dJ/4FgrciDxf2zYo1fhizzNS+1W4ZypgC2XLZau/l0obHJlMUmRffV5Ucac0GqGwJTQFZZNgMxjQ1QpdiPUnylNdvFz2BC2CwzR4eVNGdlCa4gF3M0gZyBEsrGOet16yduKdcEA41bvCN5zWbRF7cFKH0B/ToEa06KOkyMKSn0K9+feTDy5choTd4eJwM02ziH/erKlW7vfI4hZ8IEj8k2CG9vM5xRz731K/PrCb6L1e4Vu11yXSa/EXPWS0aXgIrvtcfNQ0SHHTyf8xA28TWipkEB/vovJj8Qfw4f16AhM5/fVW8C+Zc7lb5TcZqjcv6dNC+Mhu8nlr64EKSaXZGhCcy8okFQeCuCxSYw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2NYYVc1QWNlZ2RKNlV3THFsSFBxdXJpRzZXWmNJVEpCSk83L0hZZDBnM1pl?=
 =?utf-8?B?ckI2LzhRTDZ4UFc4Z1ErQUpiYi8yVmpyd0Q1aUlSOFpFbldQSlJSdTlkL3l2?=
 =?utf-8?B?RXp3dEp5R0U5S0p3L0FEWFBlcFU3anpMQ3psZktwRjdJNWJoYlJuWlRCalkx?=
 =?utf-8?B?R1VPS3V4UVhqMm1rRXJuS0VqRzdNaTRuOUF5ZnY1TG1wekRmRXU1dzZneE5H?=
 =?utf-8?B?STV4YXBiaUFrMUJHSXl4ai9kMWkzdWxYWURMYk9wWHZTVm9RY2x6WjNBSTFJ?=
 =?utf-8?B?VEkxWllEcE9vNVdxWlJBYmxUdzhkcVdXQzR6OHY0Z1VsNlY2OHFpampYOHRY?=
 =?utf-8?B?RHNoWDdEQ1lEQmZDdDZTWHREMEpHNEUwNit3Rlg0R0VLWDluekVvcFZLVW5R?=
 =?utf-8?B?azdWaEdsdk8wZlYzQVM5Vjk0Q2hmLzFMMFcxSEdHMWowOWppMjJwT0JqNkpN?=
 =?utf-8?B?OWFFY1NRTWxWZDNBVVhaWnh6WDVkK3E3SC9pcXkzaC9vWXFuN015R0twSjdU?=
 =?utf-8?B?NXBNS3BwVEF2aXZtMUpOQ3d0K3dPaWQrdVkyN3VXUVh2bFc5QmprVEpXbXZS?=
 =?utf-8?B?SXI0OG9Kckx0Y2MzTEN2bjkrQVc4NkYvM2xtV1pYV1o2R0tSMUgyYlp3b2M5?=
 =?utf-8?B?TysvcDFNM2ptT1lBWjlzTmhPNVFwTTRBVVB4Wi9JWUZqcWxlbG1EblhCS0tr?=
 =?utf-8?B?ck5QZWJEOU92T0s1QmhHZ3FyaFJrZ3RuRDRocThnRlhIc1hhdGIya2c4Y1NO?=
 =?utf-8?B?ano1MFpZQzRxRnRTQ2c0RFNrS2dJallqbGNVZytuUmNzQ3ptaGN4VWNWUXJD?=
 =?utf-8?B?a3k1WGZ1QkRRYzEySjB5cmd1UlFTdjVqR2xZQzJsVEE3RUpDbFd6TnB3Nllu?=
 =?utf-8?B?RW1JL25UdmVDUjZUN2RCa2tVRFdEdXFjWWpoVmlQZm1keXBWdUN3WGYwaW9N?=
 =?utf-8?B?VWJuR1NCZUVRRW9SVG1IR0pHU0RKR1lpeGZXb0dmckI4dzBBNXVyRTNYQzhv?=
 =?utf-8?B?aUN4Wlg3S3A5Q245d0FyRUdmT21nMjk4dW4xMEllUUJBbm9CSklLckxHM0hM?=
 =?utf-8?B?UlQ0allCTkhIL2FjdjYvTGVScnhCSjdCb2RCcE9wZ0l1cGZLVENFZDBnTm9P?=
 =?utf-8?B?bWRYbDhHUjVqVnVUWURTQnVzYUoyOG1yc2RSeUdVQzV5R0ZHZlI0aktUSElX?=
 =?utf-8?B?SmZCMXdWYzN5b1Y0VmRVL3ZjRi9YOGxncHFoNXd6ZERkVS9FejdaN0s4UWho?=
 =?utf-8?B?eFdzczlWbEQzVkxUWXRUQmcxeGlHYXNHREttcTRsTVQ0N1BtWnM2a0YxRGtH?=
 =?utf-8?B?bWtPWXJIYkRHQVcyZ3Bzd0xvbTZvZER3ZFRTd0pKallKclhZUisranJsS3Zk?=
 =?utf-8?B?N1hYU3lhMEkrZUI0VnlEVUdpNWI1NnpQRDVoZzNvZGozR2lXQUZ4blNmV1Bj?=
 =?utf-8?B?NHZnYzlWWWZxV1hQUHgzVjJPaTBjS0NPbFI5VDZHMUdhQkw2cFdKbDRQZ1M5?=
 =?utf-8?B?cVlqT0pOUFJOLzdpNVRoUXZTNHcvZzBSUUR3M3RzNlF4K3VjQzU2V1JuekNa?=
 =?utf-8?B?REFNUnJzR3JtMm5FVjBCSlpnZEZvbVBFTzhGelJ0ZEVsVWFxaUlQZW1oYlpY?=
 =?utf-8?B?akd6KzI3TnVhZyt0blFJUGVJeTVPNHNBbW1SU1JtbnF6Tk1oSFVKY25VVFVs?=
 =?utf-8?B?ZzJ1dUQ4bjBJOFUvelA1WjE0WW8yQ25aU0xKT1VxZmZIYkR2M3E3S2F5M2lN?=
 =?utf-8?B?SDlPZkw1S1UwdnR0d0FpYWdnUllSOVAzaklMV09IVWNTZFZLNXU3YzN3ZEVX?=
 =?utf-8?B?MndTb21mM2JzUnZaTzJhdm9iQkRzSTUvQU5aZjhKSmdJU0RDcHd0MHlpMkRI?=
 =?utf-8?B?ZWF6ZnQ3dWpsVTU5OEFBdkdMbktTS0cyYysyMTJ5R08xcExMcTMvSGtORUp1?=
 =?utf-8?B?NjBxcTRId1FGT0ZDL1V4Q05SNnE5MVZES2pTRGNWZnhOakdnTWNudktPQlY1?=
 =?utf-8?B?SlJBQ1FhYnczMW92Y3NsWm9iaERkQXBHWC8vSDdhTUpzOU1aUW0xR2swemZO?=
 =?utf-8?B?OTNCbzl1azd5c0w1eURJeEE5VmRNTkR0MEkzY0pSMDRMUHJ2cENrRloyQTJK?=
 =?utf-8?B?YWR2ZTk0RmU0b0xLdjMrYzVDbGpuZ3pIS0haNkVlWFZXdEsrQXVFK2ZCUzdx?=
 =?utf-8?B?OWJncjNNaTgybVhCbjZYM1NLa2xWSCsrYUY2SnRmSFZsOGs0Mi9kdnMzeVVn?=
 =?utf-8?B?L3lGNWhxeUE2K1U4b1hCZEp5VjV5TXJRTk4yMWxGMktqbnBUUng5cmdRSUwv?=
 =?utf-8?B?UTRXMTZZVWlEZUl6STdTZHFPdGh6YXNFMXIvWG9yTmt1SExQemhvZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d16c5109-e3e5-4dab-1542-08de789b47d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:35:45.5557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lpFJQFVtpLHoGv5XFNdeG6HPorAXS8GZahPXJaWLMBDaU8LMXH43i1M0OufR/WzuJp0wW5MxGafsCo6/3ITpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> After SNP_SHUTDOWN, two architecture-level things should be done:
> 
> 1. clear the RMP table
> 2. disable MFDM to prevent the FW_WARN in k8_check_syscfg_dram_mod_en() in
>    the event of a kexec
> 
> Create and export to the CCP driver a function that does them.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/include/asm/sev.h | 2 ++
>  arch/x86/virt/svm/sev.c    | 7 +++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 0bcd89d4fe90..36d2b1ea19c0 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  	__snp_leak_pages(pfn, pages, true);
>  }
>  void snp_prepare_for_snp_init(void);
> +void snp_x86_shutdown(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
>  static inline int snp_rmptable_init(void) { return -ENOSYS; }
> @@ -679,6 +680,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
>  static inline void snp_prepare_for_snp_init(void) {}
> +static inline void snp_x86_shutdown(void) {}
>  #endif
>  
>  #endif
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index cf984b8f4493..0524fc77b44d 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -544,6 +544,13 @@ void snp_prepare_for_snp_init(void)
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
>  
> +void snp_x86_shutdown(void)
> +{

Would it make sense to check for SNP being enabled before calling the
functions below? I realize each of the functions in question will do
that, but it could save a bunch of IPI's with the on_each_cpu() if SNP
is still enabled. Not a big deal either way, so:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

> +	snp_clear_rmp();
> +	on_each_cpu(mfd_reconfigure, 0, 1);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(snp_x86_shutdown, "ccp");
> +
>  /*
>   * Do the necessary preparations which are verified by the firmware as
>   * described in the SNP_INIT_EX firmware command description in the SNP

