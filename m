Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012003.outbound.protection.outlook.com [52.101.43.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E10A47DF8C;
	Mon,  2 Mar 2026 20:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481836; cv=fail; b=n/hzNwOkQCXGpJzIDRQZGKvcS/QM2zni6jR/zLA0RPIazi8ziIXL0fHwkbjzbi9I6zUlz/+G2F0l7M66oClKq9Zl4AtITPGVReuW+XpSajvfNTgszCs8L7BPfWml8sfgf/jKkxe7EQ768Cntu9JIzBpu29OLwyOWztwf+eH2T0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481836; c=relaxed/simple;
	bh=Dj/aSh1rCoz7+dGj4CCBAYdYcqwNS+2lua+r1zEoS98=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cGm23jZqMKy1BjDDD2n9qsyj4IH3hQAkH4xqUIQjICrcV3lH4n9dKsZEBUgehsskjgAW2inYPeoFVu5IcsAlZt06KIxwjY5NU+nnHlQ0hsFwGNAyqsbNklR9gJmZoAow81YTjnbdmxKfSZD3RS/pD8d5p/Q7HVZtfmFsbhdG75U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z7UgYbcy; arc=fail smtp.client-ip=52.101.43.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z7UgYbcy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aERFHLFCu0Z/AniCxLbL0ZdGstwgCsBjDyybnDzH3nvhJzOBMa4S3w8AmzfW0ZIILrrk2YF9T5BEeoTiVP1fR9R6RNyteMdcvfm4BQbvXXecWT8HXRUvIpySOAVuEQR/N1yWSZoJLhX6fGmCWk5whsPXDAbsL3dyvpn8vYkF0qzdcspmyMXs8KPEa1FiW+Y9xy9AfYb8SKM93dps9NZ9wfOj8NaqEhGTPSAqY5+bZpo2M95XX/QeK08T0C07rR4j7vj2W7qlMJTzAnyffU9b9JtBzCbiCrfns0frOcEwSn23jloa1osMS5eIFmt4gd6x6rqpbpqTDXsrs4kFLYWzvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2B+ukVqAHC+sSelTuIEaMhfpZ98DaWMI133vkRydIHk=;
 b=n4nZG7jrFEMB8/YGfcohrVqWXvik7ceOuxXJWK4Y2eBzQZxtSOqlxfdwK0hrYa/Oz008Ot1icpinrm/CxAUzvbLUWJFFsAkCsNJToU9h1Y4zRc1tacKnd/crQoq5prz2vqkRhzMcUSXr5RpqlqehfiA0gGnGoKaL5u6fICXsgZvQpmhQtgQRxRg2eHXQBtgVyUTVj9Jd7reFB+ZLkS8oL5nXiwnFE8RavTg0MSVkB1FtBafShnxGRsIZKyju2bM3xIF48nLcmeNrvYR5nLtCu3bHSSPqyK53gKb030Qf0SIfzOPrkDcgblPk7v560q3cruwTVFO8Htlbn0vtaOWbaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2B+ukVqAHC+sSelTuIEaMhfpZ98DaWMI133vkRydIHk=;
 b=z7UgYbcySxv8mnHOZiunKai7whsIw0Q/pw8Gc3G610IooX43KtRCzmQHu+4Y0XDelSWCIBextkvFxz6+xIn96BOMPs67fTklLerRKXFzEkrcI47qvPWizxqXiosAWyQx9aLI7HHWFKmtgrvXTgfdY6sHkDuYkdq/aZ4pMACk9EM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PPF0316D269B.namprd12.prod.outlook.com (2603:10b6:61f:fc00::604) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 2 Mar
 2026 20:03:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:03:48 +0000
Message-ID: <8199b213-4166-4154-ad63-61efed33fdd4@amd.com>
Date: Mon, 2 Mar 2026 14:03:12 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] x86/snp: create snp_prepare_for_snp_init()
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
 <20260302191334.937981-6-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-6-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:805:66::40) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PPF0316D269B:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f5e44c-0b70-4814-242f-08de7896d0da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	e5+wzpA8U7ZzJiNNgWYNi9rNtiQpUhDQdLDy3PsS2F2W9TKgDl7KOceoh908w69W7kggWDLpwKz2wUnXLKOE3/TG3u+eGYPU+IoAVI9fNCvxYf8VR0YvMKQv90dzpkwPaTWHMpy8Hj+LIOAbZH5PiVcgwK7vIzGlTx/q8U80/ilfbdwUkcVUAX+/ajR9BrioTm0tch37J7SJmLuiMqlOcrlv9zp5N+Y1qLwD1FyOkNVZCa/dHlR7wMTYkS0TvyjXk0+RO2u2MZ31Xu//eNrXkBQuJk5QuvdUZtDPfhy09o3IoCioyuxxGiRD8w44LQIHXgTpv0MTjiugXykyEW1SiXIF0abjaefMZrhibf8Vnlb1ji6wI1Woil+T3Hni8CTbJ9wL7XL89qPJyualOT2bpYbAkZQ1Kr7/39OuI4m0tFHiAYjeAkOAATcRiV2r7F6VGRBjtEsiHNukI3KSQOO/p+VyQsc512eMw3MkuubcbCq2SqPmQvmvyACxycwp7kLG/EpFbN41R6As6kl28+C8ydQXO8SesaZcksWacBZnowQ3FtZYB3MAtwSXg6P7EWkiqc+P5y4P71ZzUjeOoe+sMTmsCgggY07yUWYkdtihSu9DfoD6BFMNyRpWJx/IIhA2r7Zv/7WsQmqDqg0HW4exrtTTWpZHt4ZY39LvGg6ySApuNTUc99IWus2N2D4Z48F18ZMa/0mABa9xSPgZngZ6KUWUzIZlgpkTGjM0Wdn16fl+KAIA1XDtQ1VDqSAm9hI8K46J3l1JOKTQ1CvPW4+Q9g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDgyZ2RhMnZqdjc0a2paZkxTTGdtdE5jV3pCNkI4bEVoWjhyYVVzNDV0OTM5?=
 =?utf-8?B?dlRsRGlXZU5sb3Z4cDE2Q3ZUZXlvLzVDdGx2Wk1seG9TTHZ1QkhIZlQwRCtT?=
 =?utf-8?B?aHdmYlBJQjAyQ3Z6UFdDVWFBUWZQKzJyQnZZbFpUczFNVnBTQ21Ob1R1WWF6?=
 =?utf-8?B?NExZSytOc2MwcXhtWkR1NEs3MmJxUy85dktjNzF1eXFOY2UvenRPQWliWXo1?=
 =?utf-8?B?aDF0aTdWdXFvVlpoVnh0NE1hYWlaZmZ5YzRyQk9ERVo0MnhxUTVGcmFhZmZL?=
 =?utf-8?B?OXc1NzBtS0ZOZUFvVmlJRjY0NUt4SE5abDVXU3ZveG1iYlIzL2VMcDdVU21E?=
 =?utf-8?B?eGxlVzB6Zm9aekUyM3AvTVlXUEhsV1hSZE52dC9ucnlmTkpOOGlncmkzZHV2?=
 =?utf-8?B?WHI4akJSa0pJRzlreGZpdTE2d29XWXJxSHUvNHNnTStCd0VIZzVJL0V1Q1F4?=
 =?utf-8?B?aFJLcS9OR3R3WEtYOEREV29QcVNDTjBWK3lBcGl2ODBMSWlldU03SkN4V0dP?=
 =?utf-8?B?UW9ROXRIcWlKTlVQc1ZaeWZ3YXM5dEs2NnNOUjk3TU1KQ0hsVVZKSEVuTVBV?=
 =?utf-8?B?NHBRQVg5S2Y2Z3FJVXc5ajlUYktqN25iV2U3dWk0bVpCWlNXNGd1eHNNWWtH?=
 =?utf-8?B?azBtMThwWjRBbkU0UHBRWmVjaExsRC9aTzhjUG83ZUQvM2xMdmU1ekVhTDdB?=
 =?utf-8?B?cWNjMlZuSlk2UHRGTmdwa0Z0dmlsVzg2aEdFYTgyRlBRL2o0WUJFNlpPZEVV?=
 =?utf-8?B?bEk4ZUtnM1RZT0g3eDE3bnljbzFLVUJEeCtsd1Zyd1VQSUtOK1dQcG44Z0c0?=
 =?utf-8?B?L05KYmVSTHVmSVRmT2NBSE1zZG03VlE5VVcxdnEyWUpzZjRkaGtIQS9lQytn?=
 =?utf-8?B?Z05jY2VORGVNbUZCU1U1Y3RmelJvcWh4b2I1S0REcytqWWlSNll6REt5cS9X?=
 =?utf-8?B?Tmk1MlEvaGdKSFZ4eWhQUC9KdktqQ0ZMVGQvZ3lmWnNDbmJhYXhrVDU3aHJS?=
 =?utf-8?B?Mm9iNjVaQTQzY0pRQzNtQThvNEJkRENoWVMwell1NmJ2N2RJd0JuVWJnS1lu?=
 =?utf-8?B?VkVFOHhYVkljY0ZQKy83UCtXTkhBNHhmWDhtaGRmVW0ya0NSNjdDL3poSThH?=
 =?utf-8?B?R0w4bHU2TE15T21SZGZ1RHowRG5kek1zbkRVOVhtZVlFQ0thM2cxY1VJQlB5?=
 =?utf-8?B?d1htU3p5UUpQbDdCb09CSTNnZzJocWc5L1dmQ2d6ZDFEREpQR3JnempDditw?=
 =?utf-8?B?RE9XNnlISnZENU1Ea0ZCSWZnU0dTbnEyRXp0RFRPTys2cTN0SVR1NytxelBY?=
 =?utf-8?B?eGtYVURIZytGY0JXSUFlQk92YWpONHcrNTYxQ2hONGpxdThqbnRBcU8yelJp?=
 =?utf-8?B?VEdlZXNmdWthTU9HSXZ2K1dXN0Q5WkFxVG1SdXJQOVAzSUh2TFZpUEpXVDJ5?=
 =?utf-8?B?S3hxd1daSGtFajBtZmxMalJQN2QxZmUvMmh4cHBBRXJJcU5ndXVzeW55VnlD?=
 =?utf-8?B?UFlia1NucVNXTzhBNWFSNEhSL3VQWTAzTG1hL1QvNmE5dElvRlVxNmpURWZB?=
 =?utf-8?B?SEZVVHZWaUdpaVgzWk9WVG1LM3cwNXR4bkF1MFVsa0hMYW9UOXdsVnZ3RG9J?=
 =?utf-8?B?RVJNalRscmgvUmVqUkVuMGxkVHJIeXdGREVORVMzV0xsMVZtSWYxV1h4RVJI?=
 =?utf-8?B?ZjFpb2RoYUh5Q2RuTFZsZVNIRkZNNVVsYS9EVHZFUW84dEpBU1I4V0NFZ3V4?=
 =?utf-8?B?TFlMeHZHWjVZWkp2N0JTSFNuRTgwbVpVYXFrWFMwbXJmVzQ1c3g5QXNveGxk?=
 =?utf-8?B?STRialMrelIwQUs3SnZKN3hPMDg4TjhCODM4K0w5MDJUQjJXVHBWcTk2cGhs?=
 =?utf-8?B?a2pzRDRKdnhFS3FnNjFndG0xWUk0dXNzMy9KMXRYdmxPamRmYTNMM25zZVhW?=
 =?utf-8?B?UWFFMjh6R0w0enV1WmNkZlBUUlZXOVp6VmhrQWJTWkNoWEdITU4zUFhIdHZY?=
 =?utf-8?B?MXkxTTNpSmJBTnErY2k2MC8zWEhVNVBKNnFKRjlCZVVZMHRBOVY2ZnMrM25i?=
 =?utf-8?B?bXJFcFpEQUtzQWc2eHdHbzBPZ2JaVUU0NVdOSWdWWHQwWks1TjRGVE1Pdm1Y?=
 =?utf-8?B?bDFHVERwMzJ1Ynk4TnVWTG9vUTNNeHM3RittNGRQT012MVhUVm5UVTRUTng1?=
 =?utf-8?B?djVjMVNHa1dzbFJTUGN1U1VyUUNOQmZvVS9nOWJPdW9IVWFJMjlVM2pzYVMy?=
 =?utf-8?B?dDB1WXNhL2l6QmVFOW9XbkxYYXQvdW1mVzM0QzNpc2MrdDJESDVpWk5MSG1O?=
 =?utf-8?Q?satvdpr/pZFEwauDUI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f5e44c-0b70-4814-242f-08de7896d0da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:03:47.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtghGUcRKG1yJKrj0/yLqE+j8D1P/ySQcb4xcwCCLrb+mKn+5Y4Ffre7e5fhkXHMxC7LEWocZPlvuhmtwUzKug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF0316D269B

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> In preparation for delayed SNP initialization, create a function
> snp_prepare_for_snp_init() that does the necessary architecture setup.
> Export this function for the ccp module to allow it to do the setup as
> necessary.
> 
> Also move {mfd,snp}_enable out of the __init section, since these will be
> called later.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/virt/svm/sev.c    | 46 ++++++++++++++++++++++----------------
>  2 files changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 0e6c0940100f..0bcd89d4fe90 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -661,6 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  {
>  	__snp_leak_pages(pfn, pages, true);
>  }
> +void snp_prepare_for_snp_init(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
>  static inline int snp_rmptable_init(void) { return -ENOSYS; }
> @@ -677,6 +678,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
> +static inline void snp_prepare_for_snp_init(void) {}
>  #endif
>  
>  #endif
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 258e67ba7415..8f50538baf7b 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -132,7 +132,7 @@ static unsigned long snp_nr_leaked_pages;
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"SEV-SNP: " fmt
>  
> -static __init void mfd_enable(void *arg)
> +static void mfd_enable(void *arg)
>  {
>  	u64 val;
>  
> @@ -146,7 +146,7 @@ static __init void mfd_enable(void *arg)
>  	wrmsrq(MSR_AMD64_SYSCFG, val);
>  }
>  
> -static __init void snp_enable(void *arg)
> +static void snp_enable(void *arg)
>  {
>  	u64 val;
>  
> @@ -509,6 +509,30 @@ static bool __init setup_rmptable(void)
>  	return true;
>  }
>  
> +void snp_prepare_for_snp_init(void)
> +{
> +	u64 val;
> +
> +	/*
> +	 * Check if SEV-SNP is already enabled, this can happen in case of
> +	 * kexec boot.
> +	 */
> +	rdmsrq(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		return;
> +
> +	snp_clear_rmp();
> +
> +	/*
> +	 * MtrrFixDramModEn is not shared between threads on a core,
> +	 * therefore it must be set on all CPUs prior to enabling SNP.
> +	 */
> +	on_each_cpu(mfd_enable, NULL, 1);
> +
> +	on_each_cpu(snp_enable, NULL, 1);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
> +
>  /*
>   * Do the necessary preparations which are verified by the firmware as
>   * described in the SNP_INIT_EX firmware command description in the SNP
> @@ -516,8 +540,6 @@ static bool __init setup_rmptable(void)
>   */
>  int __init snp_rmptable_init(void)
>  {
> -	u64 val;
> -
>  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>  		return -ENOSYS;
>  
> @@ -527,22 +549,8 @@ int __init snp_rmptable_init(void)
>  	if (!setup_rmptable())
>  		return -ENOSYS;
>  
> -	/*
> -	 * Check if SEV-SNP is already enabled, this can happen in case of
> -	 * kexec boot.
> -	 */
> -	rdmsrq(MSR_AMD64_SYSCFG, val);
> -	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> -		goto skip_enable;
> -
> -	snp_clear_rmp();
> -
> -	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
> -	on_each_cpu(mfd_enable, NULL, 1);
> -
> -	on_each_cpu(snp_enable, NULL, 1);
> +	snp_prepare_for_snp_init();
>  
> -skip_enable:
>  	/*
>  	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
>  	 * notifier is invoked to do SNP IOMMU shutdown before kdump.

