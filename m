Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011070.outbound.protection.outlook.com [52.101.57.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A11361955;
	Fri, 31 Jul 2026 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527047; cv=fail; b=fNF4Fde/Wqj99Sw6PfH4dPrlf6mA24+LG2TAv8X9dOHg5gA84QmkxKW+kzjvJceThzFBlXfBj6wBHqyGwXbhGe0Jnifod6ny3Ugn3dU8MyGmJ7pLcNQY43wUt+r9s4lxsb+Y2iDHxN7v+YDB6ehu7/wcMBFFeYZssQK3rMgvosU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527047; c=relaxed/simple;
	bh=CvNTBYrHRzQgMdKuPHDdcZrXirfj3ThhJrmmYIcHNyQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b9da905DI2ZxGmeRS/sr/66hlDcCGuMgsJFi6UiFspIr5gpUsyus1481y9QBXkA+VIOJ+pl3qnAFcWJs9usJb/ElNWoNm5jQbFtVacnpWvU0X9AWVlcbAdc8LbISHR4xK60eYfNxFIZYsqDiFQ/9DIIhpFEhc8ki9p9KWkLl/5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hLvrGZ1Q; arc=fail smtp.client-ip=52.101.57.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hLvrGZ1Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1kJYTi5Y86xfN7Jyd1mJezgAH0jFFWY+fu0yFdVOGgZdRFddDS4xj5vjDPTTw6WQxqE9eO/paFx0trcYgtBrz3OkfbP1I0PEUh8PfPPrQYbhEhGS6B2tNQOt8D+Bf43k78C61J/4IY7adngxL+UIjKIAhZ2eVhyWoOt16DRRyaifuHXP1HaeOS2+e0VxhalLhEDpbvicOSdtUp7lec09B/dxNGlRMSqxyE+1B7afQbWvpEzUZ4m4+ZGK89KYi2nbx/zv4mbEiHHVTQEmdtG6rqsBNHUmVgeh+N8AKbco48NAKjiyznO1zAF4GwcKJMTDZmLLOSWd7LYfWBUSJnqDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFHH8PhHjPPu1dHz1e/jScF3joCUMZsKMNMUoGdJG9I=;
 b=Hqw7BniM4N5F6YaLHMjIA6pSJczpORa5cVXeePr+7+gazaSihlU9neKVOqU/XElvFitqL09dogOnMsCeuSr10usxg6zlTtpFWkdJ1GlgFKpucynItIXfuSQWpLhT1Rcn5MVVW8Y0H9N0COHG6YSAWpL9lW67JmI5hsnxad7RC2dMLmqe2r3+BY3b3BZgG1A+0WRTu9AITJ3nJVzMPneRih7veetVCyr1/5+zn8aH/En4ElBTpjZqKiBOAv+NxXTt36Xzu6gdMb/MZfdpGDcaZEyY1i13122xLRO7OEVFRqg9aA3pNKGe9twWS3FymPg454AFQ/VcMpEac2aOxCxd2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFHH8PhHjPPu1dHz1e/jScF3joCUMZsKMNMUoGdJG9I=;
 b=hLvrGZ1QXzlQJoVNfIZBPQaMvXQYT69xEn5ntVDRKroz7JG3fjZJQzYmnQd6uulXWeIcHEMOqJ33301Qfs/1UQo1c4IUGx9vGMf2VV+8Xb4ERaQ0fEKClRykNY6bCgJTYkkQSEPCj+9P944KHaQfSFdkoR5geGQQWO0SZNQG4c0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 19:44:01 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 19:44:01 +0000
Message-ID: <b4dcb5f0-91a7-4253-adf3-8f1ac0e113b8@amd.com>
Date: Fri, 31 Jul 2026 14:43:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::27) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|MN2PR12MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 68026578-81b8-4b85-23f5-08deef3c11f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|921020|6133799003|3023799007|56012099006|5023799004|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+TMgp2Ncjo0Uxq3+KkopxHPynd096FSag1r4DfDUGx0fsOb5vKHMN79Bp+Fw88hr937mhr/5i/px/pNhgDSsnhHUqaTWYcI9zU7AjWe6Nd1uhTLQGaE5FzMYOCk6igb+m7YgpntQBqdGDkDTNQRODWRuiRIj48vas5OAF2EnWYsDoY3rHUKmm2mSUr1RHlzjV973n4DCNvWpwJ/pZvvBZd8eDwIjVfrEcTIvSxGiJ5T2JeDvszFA04dfhi3GEeT+1K5kGQvm2ouSynpz1Pd9darC4kd8aRht9gQBn+u6Gz/xnM6OImMhZPor55/9N/ya+s+0Sx/3zB8S9QLmonhrN+4RhAR6HZ5bmAwTe6odC0F2aVpor/NW9C0l1MzEqXwq63Ty81ZFzE5cQrfBt//VRT4o5A5xhG0PIF1c5rzLcVJTx1oGqRtsEOBEprSieGZtWEVoGi8vR5HYRxIOdKyj5EcS06AyFI8bTL3+Bqvey8LOtWcdLFCf4/QB/IrchSR27PbDftME87RWSvJnaTC+8NTgGQDt+TpMdF0L91QswJU5CElbkqzAuNZK3FaJZxVu+vu7JZs/M3mcwv7XIbZfK9IfBXi3yEH0vl7MBDJy1p/i0oYL7Fj6TRske0A1xcjY1aK6oPhHYECA5I3Q+1+fPFsJlc56dufilci5FLFyYM/dhtnb5+n5gdjRT+oYh6mDUs1pSQAVN0qkNWWKnHEDMQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(921020)(6133799003)(3023799007)(56012099006)(5023799004)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEM4blNQVHRiOHNiQ0I1Q3BXRUN0cU0wQ1pWam9EV21WMUhXc3NLT05zNG5t?=
 =?utf-8?B?MHppYVdzcnJ3cm0rQ1I1R0owMkFKM1BkcE5jM1E3Vzk0Z0NxTlA3Sng2OW5U?=
 =?utf-8?B?VDFCQ3M3TXYvbzhpd3A4elhGeG4yanE1L0hEdFlJaHJaUlFmd24vK0FkZm5D?=
 =?utf-8?B?RGtFdUJ3Rm5ZVU5iUnpFdzcwdnFxVkx5Q0NRZHpxMHo3RnNScDY3K3VYOWxv?=
 =?utf-8?B?QTFaQUlYZitWVjE3Wnlrb2pFUkh6eUpuTHpRbUJRQVNReXFkTTMrSk16Mi80?=
 =?utf-8?B?L2pBQUhOK3cySTllYjhueGJneThSTFY4OXlubXBPY29zdCtUTXVqcEM2WEZT?=
 =?utf-8?B?eDFnWm5kb2hWd2tkd3Y4T25CNSs3ZlpFdXVha1d2Q3dmaW1jWEJKT0lhTGpJ?=
 =?utf-8?B?K3c5WURQKzl0Zm83SzF4T2Y0bDdOMkRTR1k5OG50K3JpckhqS0Y0eEVDVTls?=
 =?utf-8?B?Z2E5cXAxOVdqNVNqYkxvWGdwVlQ5SEh2MGpnaWtBWjhpMzBWNHFHRVZiNE5J?=
 =?utf-8?B?V1JaTFNKV2M1cWVRSjArckxVYkFsZ1h0V1dCVlJmY2hiK3poR2JlNG1BWlJE?=
 =?utf-8?B?RTRVbnd0VUxReEx1TlJXN0g4czdTbUptaHN3b3I3emhyNkdvS0ErWHRQMHNj?=
 =?utf-8?B?L21aQk1CMWRBM0NFVDNjV1JoYjJjWElJRzhOY0lDNFdUR1dhTEFBR1dJRmFk?=
 =?utf-8?B?UTQrdkx6alc4MG44ems5K0h1dFRDQk91L2tDT0oxb21JMDRodnhGOGptKzhO?=
 =?utf-8?B?aFp5RU1xamV2dFlvUjlzUTA3MFJIbG9VMFFxRm8rOEV4S3hJV3FBSjAzSGcz?=
 =?utf-8?B?OHpBa3IwYjBwTmh0aEFrd3hFNjN4YmZ2UTJNQ0hoSnU1eHU0aTd2L2FxZWJl?=
 =?utf-8?B?TGNScWRJdVNwVm9qaHBjU2dmb1MvQ2tIUStuaFdZa1c4L3ZwWUE1NnczQ2xY?=
 =?utf-8?B?WUFCL1N3WEJKcGp3dlljdGNhWWRkcXROaGhITlZBMkFZQUE2NzZVUTRLcnpO?=
 =?utf-8?B?aXlOL0V2Q2FTU3R5ZEZiVXZ2ZDhDRzg0UVBTSWtjNXFqd2ExUy9zTEUyMUJj?=
 =?utf-8?B?Qzk5U0RYcUhNU2grMzAzSEJxeGVHNStSZmY2WmJxUEk1bDhuSythbXhxemV5?=
 =?utf-8?B?WGNkc0dxQUFMNitCamFvUGhVU0dLQWZtNkZFWEZFWXlsNmxER0gvUEtDV2RB?=
 =?utf-8?B?MWYxanNTeVlrMDBGNEp4L2YyUDdaUE9PL2xUM3E1b0x6alVMbXFXQnk1RUZz?=
 =?utf-8?B?RGt5cnFRUEFqVEJIY0dpby9Bb3dKK2dKUmZ5WnpjWkdPRjR3RE40aWdXOUFO?=
 =?utf-8?B?V1plRG1BaGJ5akxYYUVQWnB2SlpUNGgra0JXL3VlV0crRGkxZGNtQy9VRm5x?=
 =?utf-8?B?S0FDQklhK0p5aVZvOTNGTXZXNUZ1bzhXVDNkbzFYVnFYT3QreTBFRElmTlBI?=
 =?utf-8?B?REczSnZMM2FmTjE0Z1Q2MTZlYTB0K2x4T1lGeE5QT2R1aFRsVWlOSmlLalEw?=
 =?utf-8?B?OGJISmRYdjd1SHdOZ09KVENOM2pSelV2cXkwZU4zSHdaQUl2bmJSUWFQVnB4?=
 =?utf-8?B?bjgyUnBMWnRvYWZHMmltNFRFWXdQU3VXQVdLWklNQmtMZWljWWdGMTJZSVpH?=
 =?utf-8?B?VnJFbEJZNUt1MjNNRHQ5dTM3bkpUSGhhVy9Sb2pJb0dqU2JyY3NnZzQrQWdT?=
 =?utf-8?B?eEVDNGdxU1VOM3A4OVBmYlJVaEZITzRGTnVqMytjOWNYZzdXSCtTVVZ2aTNy?=
 =?utf-8?B?eFJBN2JmdkwwbFdvYWwxanptY3lobS9sQ2hpQ3Y1cmhWa2ZQbjNwTllaWFZG?=
 =?utf-8?B?ZElsUGlNSjFLS0tYQWZwWFJmc3diRnc2b0Q5Z0EwcGgzN284VkxKSVJyRnV2?=
 =?utf-8?B?SUZ1SDJWb2VzWnVLU0JFVWd6WGRoT2VWeGh4cGdrZUhacTYrNU9nNWZrS0tC?=
 =?utf-8?B?TWV5MnZDWDZjUWZ4eS9IR1Q2OEZ6N1VEanhwMzA3OFF6dzNBUEtmSkJCUG9T?=
 =?utf-8?B?OFNDZzZrSUl0a3FVdFZodUFkWkFGYW9vSFpydi9NNVZ4OXQzdWthZ3g0ZVEy?=
 =?utf-8?B?T1BReWdseTZpUDMvYWRTenQvUDdlMDhFd0h5cXlTcWNFUkRCOStSNDcxdHNl?=
 =?utf-8?B?ZytTc0JuTHNVMzhBb3hQNXdVZ2RXVnoyMlF4a1A3ODlkdk1FUE9qK1JqVTEr?=
 =?utf-8?B?OVEraFBEcSt1c0RXVlRET3NOeFBBUS9QbXNhUXF4TVVCeEY4eGFaSDl5d0dm?=
 =?utf-8?B?UGJpSlc5QzhBVU44RElZWmkra1diM1hrYkJuc0grazlZMHVMK3hPZ1d1cXAz?=
 =?utf-8?Q?zt7VgXnqGO1WYR6vDk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68026578-81b8-4b85-23f5-08deef3c11f6
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 19:44:01.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mupq1K6wAGC+JTiMmE1+SWU+Ui5NjQMZDK7JDLeAjdNR27rZd55ORuCP5lsygQftaTN7UlvBwbBxWXqJciRXDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159

On 7/27/26 14:04, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The new RMPOPT instruction helps manage per-CPU RMP optimization
> structures inside the CPU. It takes a 1GB-aligned physical address
> and either returns the status of the optimizations or tries to enable
> the optimizations.
> 
> Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
> RMP optimizations.
> 
> Initialize the per-CPU RMPOPT table base to the starting physical
> address. This enables RMP optimization for up to 2 TB of system RAM on
> all CPUs.
> 
> Additionally, add support to setup and enable RMPOPT once SNP is
> enabled and initialized.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/msr-index.h |  3 ++
>  arch/x86/include/asm/sev.h       |  2 +
>  arch/x86/virt/svm/sev.c          | 67 +++++++++++++++++++++++++++++---
>  drivers/crypto/ccp/sev-dev.c     |  3 ++
>  4 files changed, 70 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 18c4be75e927..d2cb0a7cd0a2 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -761,6 +761,9 @@
>  #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
>  #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
>  #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
> +#define MSR_AMD64_RMPOPT_BASE		0xc0010139
> +#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
> +#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
>  
>  #define MSR_SVSM_CAA			0xc001f000
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 594cfa19cbd4..6fd72a44a51e 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  	__snp_leak_pages(pfn, pages, true);
>  }
>  int snp_prepare(void);
> +void snp_setup_rmpopt(void);
>  void snp_shutdown(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
> @@ -680,6 +681,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
>  static inline int snp_prepare(void) { return -ENODEV; }
> +static inline void snp_setup_rmpopt(void) {}
>  static inline void snp_shutdown(void) {}
>  #endif
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index e2f69fba0938..8bfd80284836 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -124,6 +124,9 @@ static void *rmp_bookkeeping __ro_after_init;
>  
>  static u64 probed_rmp_base, probed_rmp_size;
>  
> +static cpumask_var_t rmpopt_cpumask;
> +static phys_addr_t rmpopt_pa_start;
> +
>  static LIST_HEAD(snp_leaked_pages_list);
>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
>  
> @@ -558,6 +561,17 @@ int snp_prepare(void)
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  
> +static void snp_cleanup_rmpopt(void)
> +{
> +	int cpu;
> +
> +	for_each_cpu(cpu, rmpopt_cpumask)
> +		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
> +
> +	free_cpumask_var(rmpopt_cpumask);
> +	rmpopt_pa_start = 0;
> +}
> +
>  void snp_shutdown(void)
>  {
>  	u64 syscfg;
> @@ -567,10 +581,11 @@ void snp_shutdown(void)
>  		return;
>  
>  	/*
> -	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
> -	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
> -	 * leaves hotplug disabled.
> +	 * Clear the RMPOPT_BASE MSRs while CPU hotplug is still disabled, then
> +	 * re-enable hotplug now that the firmware has disabled SNP.  A legacy SNP
> +	 * shutdown returns above with SnpEn still set and leaves hotplug disabled.
>  	 */
> +	snp_cleanup_rmpopt();

Why not leave everything unchanged comment wise and just add the
snp_cleanup_rmpopt() before the comment with a simple comment above the
call to snp_cleanup_rmpopt(), e.g.:

	/* Disable RMPOPT while CPU hotplug is disabled */
	snp_cleanup_rmpopt();

	/*
	 * Original comment block
	 */
	cpu_hotplug_enable();

Thanks,
Tom

>  	cpu_hotplug_enable();
>  
>  	clear_rmp();
> @@ -578,6 +593,46 @@ void snp_shutdown(void)
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>  
> +static bool rmpopt_capable(void)
> +{
> +	return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
> +	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
> +}
> +
> +void snp_setup_rmpopt(void)
> +{
> +	u64 rmpopt_base;
> +	int cpu;
> +
> +	if (!rmpopt_capable())
> +		return;
> +
> +	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
> +		pr_err("Failed to allocate RMPOPT cpumask\n");
> +		return;
> +	}
> +
> +	/*
> +	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
> +	 * to set up the RMPOPT_BASE MSR.  All primary threads are online,
> +	 * otherwise SNP would not have been enabled.
> +	 */
> +	for_each_online_cpu(cpu)
> +		if (topology_is_primary_thread(cpu))
> +			cpumask_set_cpu(cpu, rmpopt_cpumask);
> +
> +	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> +	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
> +
> +	/*
> +	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
> +	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
> +	 */
> +	for_each_cpu(cpu, rmpopt_cpumask)
> +		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
> +
>  /*
>   * Do the necessary preparations which are verified by the firmware as
>   * described in the SNP_INIT_EX firmware command description in the SNP
> @@ -705,10 +760,12 @@ bool snp_probe_rmptable_info(void)
>  	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
>  		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>  
> -	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>  		return probe_segmented_rmptable_info();
> -	else
> +	} else {
> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  		return probe_contiguous_rmptable_info();
> +	}
>  }
>  
>  /*
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ca473ca198b8..c002a7ca26a8 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1477,6 +1477,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  	}
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
> +
> +	snp_setup_rmpopt();
> +
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
>  		data.tio_en ? "enabled" : "disabled");

