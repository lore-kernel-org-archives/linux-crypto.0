Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013052.outbound.protection.outlook.com [40.93.196.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DC132E12E;
	Fri, 31 Jul 2026 19:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785526566; cv=fail; b=KovmFcl3yyTIX98LcrYWNbLVB24xTO1cWUCPkVflXRaSAkO15nJK0Q2dWf+leJSc1tAO4lAJjFN0cuU9Idejx9tjV4MmB0lBNI96e1BfvEwS9ME2ov5F541GwaKtnOYx3llsuNON+3lOQlH18VAYkhXTPTTel9qTHHo1qGtiRro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785526566; c=relaxed/simple;
	bh=/skod2vwIwhgHpwBlKLOUKfnvsHeBqhLcH+q1nNzFwc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YjkeHUKGFPV+Wub+dabTbsbu6YnoWKJU4P/dISKJ1Ovg7jzim2RrWhER5MWSDCdpx7idvueiGPoNK8AS0MWbr/y2WmpTyn28pFkA9/coKPNFh1B+bKmkBZaTMWvJqcCzgTeiWDqIKSXMIsJ5xKFYyFaTKhUEUtRhwG1vjbJC7QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PXUF/i2P; arc=fail smtp.client-ip=40.93.196.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PXUF/i2P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OBt6pyPI+g4IS40HCawphKcbv6uOgqoAhjM/NdChp70Yt5GS/MLEjqkxvuHDFKVVVFndfiaGLPL64r1MV6/w3VFZNznUDrle08TY9B68GL0Dk0zZtws5JX5Ipaajr3mnraAz9iWlucM9ynrqstpe2w495TWQmAtbS37JrnZ7uFdJuEIRSTcfu3uSilPPT9S7KYP1pmX+U8UxA1luETgrg3XpzpPFI4E0BOtBndFEzsq9QfL85x+fkUvgRJg/haqrcZZ/5ZC0K1IkESv1SkasqauuANg2VG3SiNVRFylmRtYzRDRX1qbnpVH73Bxq+GPF0OMaucqQ4O0NCA+LwLWX2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7j0Ot/xqPlGQpdZLkeXeqVnH5+5dXMY/ssYfhEc0vLA=;
 b=MLglCvpk+LrAJTIzJRYNArl+o/sIXT+i5ZJdLSLEfXxHgt5j9Mg+YSLMesQiKPppqWomflhS3PwRYho0LIkm/Fq35O3YasXdw9BxRrx8Zrbdw7kakRvLaUCj1BIj58Z3/maDymlMwhT4pTChAolajjDCVUA2JOrAiOxPFWM9D4p/iyGSqmj00X1KeDImvxmHkqQ5Uv1DhY8A/LrnGAdkX5MlpdUIrfOieS+gcTnb9PHM7cGzs61tfXCgTrDVexDIVFtfIRge4YeajaaAuSPjjU1MQ8cUmACytlYQJqIRVeom+gM5Z0EOk6Ase0DuWPDBgpH3xjKBEiPsUegXQdlJUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7j0Ot/xqPlGQpdZLkeXeqVnH5+5dXMY/ssYfhEc0vLA=;
 b=PXUF/i2P8U2KZO+Cd1avP+5p2Y9Zd0CQpH7uS/a4iEY8UaSYBUBtVva9wJ8Pvqkb3ugIO9ZQBmln1xHNdJeagvt+G5+pHNCcB0hHPpc7HeNhsVst7CxPn47t1UbLsCS42AfTDSVouI4Svpj/xLtolrzsttzZjRIDErvl8YXSrpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH7PR12MB8793.namprd12.prod.outlook.com (2603:10b6:510:27a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 19:36:00 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 19:36:00 +0000
Message-ID: <bd67f2e0-312d-4eea-a5ad-009554e3ea93@amd.com>
Date: Fri, 31 Jul 2026 14:35:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/6] x86/sev: Disable CPU hotplug while SNP is active
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
 <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::20) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH7PR12MB8793:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b18091-f2fe-4119-be0d-08deef3af378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|6133799003|4143699003|56012099006|11063799006|5023799004|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	l9cIyHRYShwf7MU5ryfJp+tw6ai4q4zF1y/XUozT79F2aLcMQ0TTzisXY9wPM09/wMZtTewuGX9g3AbKCpozbpD2mTQdPeCTHlvpY7OLitkLdzD9XskMIQtjy5UrkUzMAIdZWVMQ41wAtg1wi01wGVKrSke39niKLB8TimL7ufcdNFafWBsYY5Iw60lkYRJ213X77TJNkfteYA63SkMWZ4MlmP4LWEUst8ZA99aK13Y+5afNpl76d55HdCSIhXRHqDdWoda4h3iBsojXO3efERUdWMD/euzdsv8xgg+pGN9uMf0VvtbrXl++bsVWxYm0UGhlqb7jsJCgRdq7YBebiF2iEM4ZxRnVqBn2LXFFb71wMS2FOfOr6oSMv/Ysj9CwUUMDQxZ6VClOXopcsJxPJ9dZlyZ65CIAhgqC6yVUcGq98QcpL4wAACPZqFMom6hE513OtJOFS1++jCEBwQtTpYMLUWc/SYHnoR96z3r8VpTauhoZajltdDptqUbWrD6gpAwfsrTlNbdUoh5yn7dD1u8ngDPBPi1RGGIePwD20w3c8s2y1FRXO84tma66EuPQ/hKVPgQasgvyGenZ5e/2HNu84WU7QtC8gISp0Imi9Olr3w3JzqzAjj7J96OMCYXpf9bqLMZO+GHJe8I+DhRpbs/opbo4xJQBBNRLPP7Q4WxsY8Offt2MZ+SSe8vOriyLQamrveDKpCYNKOhZemgEjQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(6133799003)(4143699003)(56012099006)(11063799006)(5023799004)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGhmRFl1SGtwcUx4S3UrTU1CNjN0WDlEWlQxVWI0WkJrT043aEhCUW51Yjlz?=
 =?utf-8?B?bnJwekhJOW9uVGliSEROMEtnd09GWW1vSnlYb3pnT1NOWGFCcW9YQWhwend4?=
 =?utf-8?B?UGNreWVydlZGK2Nzc295eFFTam9hNkh0dmVMMGNUOXNFbE8rb1pheFVpa0J2?=
 =?utf-8?B?bDZLOXJuRldLelNvN2RZL3dLMXg1S1RlekV3d3Q2a1dya0hqTlNLQlRoV1FW?=
 =?utf-8?B?SE1BdGJhdnJhUXhlcEdnMEU3M29KeERyR21pdTZndE5rSFNWVTlZUmZuM3V3?=
 =?utf-8?B?STk3MXJheWtCTU84M2w5NGt1Z1pRc2NQaU5tb005anVmM2JwYXh4NmlURThs?=
 =?utf-8?B?SG4vMDBKYy9IYkZuM0FCUlVxL0hKRkdud05SZEtVZEhGNzh4VXhSUHA0ZGo4?=
 =?utf-8?B?OHR6cFBEdWM3djQvcHpGbCsxK2U5dTc0OE5BRHJna3BLTVRFZmUzRkR5WVEv?=
 =?utf-8?B?WHptRDMwT2tXSVdaa1M3R3RPdFZJYnRTN2RSa0phdHBKMUNQRTlPTDZFd1VD?=
 =?utf-8?B?WTVGbGtpQWdGYW1XWSt5Rlh0Tzd6b0hxbXlmUnJncForT3Ruam9FQ0FyaVkv?=
 =?utf-8?B?OUhiRjl1OVBrc1A3U0Fta1k1YnczRUtjbWwrOGRvaEZtakI0ZGllTWVUVUxz?=
 =?utf-8?B?V3VMdjExMlkwWXRVWlhFeUJqeGlKWmxoRTJQT0lPVEREMGlLYXRLYUx3R01u?=
 =?utf-8?B?QkN2UFdMTHQ1eFVjTEJUVjVteEp6a2Y5WXpOVTRYQVJkd3kzaUJMaVFoZ1kx?=
 =?utf-8?B?TmJrQXpicFdBVzVGdk4xWG9mZTZDZUwrTWtud0NUUXFjb1VFa0dab0k2UmNN?=
 =?utf-8?B?eVJzQzdNczUreGptRlRFd1BNTkYxdHVCTm1LWkE5b2dpd0poWUVmQTF0bFV4?=
 =?utf-8?B?aWIyZUQ2RHBtTEtvaCs3ZkNOQ0NvY0pHaURMdElsaE5BOTQ3aEhOS1lNT1Ju?=
 =?utf-8?B?SFhQNnFtbEZJOElxbVBwL2JBNVg3ak5YZ1hPVHZjL1J6cjZzbTRyd1hXRlI2?=
 =?utf-8?B?cXpaUG1iajJDY0hZc3kvamlEMi9wTmNiU2dONTRxeVo5VVd5RzhVMXd5cXJH?=
 =?utf-8?B?THlGcWtkYlAvZ1FpOWxyam1OUnJ0OSt2ZXdsaHJUOU8ySityZDhvaDBxeFFs?=
 =?utf-8?B?T2wrMXdtWFZqcTFJNlVNcmNmL2p6MHJDUWxWZFlsMVBDMUpGTkxSZmI3K05V?=
 =?utf-8?B?dVBsdTVROXgrTkZ6SWxNN0FPazdoRHlaOHpHbnlPMnNyQ0l5YWN5cUZMWnRt?=
 =?utf-8?B?bm5peGFHYXNOeXJ6OW1UZ1pMSnVyelNtK3VMOXZyaWtXbEdCbDliZzhGSWd3?=
 =?utf-8?B?Mkc0elMyY3VsTVBlK2NXSVBXTC9leFlBRkRBSXJhSmxXbXZaL3UwcmtlSC90?=
 =?utf-8?B?QythTmF6aVl5S1BRR20rRm1jTEZhWXlaRDlqZWNtUDM4ZFhuTXBzcVRZbEo1?=
 =?utf-8?B?T1dxd3JjdENCTmFVZ2VlTm4yUExHMTZqM0RXbStEYk52My9PSEJtMFo1a3pV?=
 =?utf-8?B?SFVOcDltNTEwVitBdWNMMzhUbFUwZURUc051YTVhcTlZMDh6emVKb20xNzJz?=
 =?utf-8?B?VFl2UzRtZjZVWEtieUsxUE5kT3NGSk1YMitOTVUwczN0M1pELzJxMENBS3Z4?=
 =?utf-8?B?eHZVK1NGdW55c2dzN1dqeFhMT0F2dWdhL1N6OGIzREN6UkpFTGZnbmp4NEww?=
 =?utf-8?B?bkpjbm84Z2RXVmtBcmd6SDY5bkE4ZWx5MVBkVFkvSHF5bHA0QWJwbkJHNnZR?=
 =?utf-8?B?b2tNSnRXeXl2VDR3Z2xUYlJ2TXlMNUtxYkhxaVZoTjBmZDBoSnAxUi9GbHlV?=
 =?utf-8?B?L1EwQmw3V0xNOTdrR3RJSThwK0dlSkpsNkZ6RlZHVG44bEVNZXJYQktwbUJt?=
 =?utf-8?B?bjk2ZWN5aGY1RW5ZVU0yTERra1p1TEJ4OWo4ck04Ky9WZmNhTXJja3RFVVRD?=
 =?utf-8?B?bmtRNzhRMHF2TS9UWEJvc0gvK2k4ejludFk3aWNBaG9kbkExKzNvTVRXMmRF?=
 =?utf-8?B?RmFQbW05b0prZjh3b01xRitod0JuTFRsaE1LOTlZcnBJeWRyOVpYdlQ0NEJl?=
 =?utf-8?B?UEttSjZOV2xEVHZZVUVuQVQrNVU2emY0YmRkTlpGaEYrZlQ5MkNmTlJPcXZZ?=
 =?utf-8?B?Nmo4aHF5LzBENThaODNiQ25yUFZZTDVVd2UrT2twS3B6OTQzUjhOVUlOeVIr?=
 =?utf-8?B?YWxtbUw0Y3F1KzBwSXdoa2VTbDFETWREdWtTS2NadjE0TXFVdGhMOExGU3ZD?=
 =?utf-8?B?TGZ4WjBIbTh5VXVlbENhTjdRUUoyNkNKVXRqS2pxTmpZdi8xemgraHJhb256?=
 =?utf-8?Q?7vzoDMJiB4HqK8bh3R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b18091-f2fe-4119-be0d-08deef3af378
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 19:36:00.6482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+0yP7s1UJZJYnR/RR1ySxrGn0h/jtLnw/2ZMy6xne3eGEXr/gmNTXotec3zQxLWiYoif0GM4qwDcnRXj0tWMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8793

On 7/27/26 14:04, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> While SNP is active, every memory write is checked against the RMP to
> protect SEV-SNP guest memory.  A core performs these RMP checks only once
> SNP has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is
> set on that core; the firmware requires the SNP-enable bit to be set on
> every present CPU before SNP initialization.
> 
> A core that is not SNP-enabled and not SNP-initialized performs no RMP
> checks at all, so there is no valid configuration with SNP active and any
> CPU exempt from RMP checks.
> 
> The firmware determines which CPUs are present from the processor and the
> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
> them at SNP init; it is not aware of the OS bringing CPUs online or
> offline afterwards.
> 
> SNP_INIT fails unless SnpEn is set on all CPUs, so a CPU that is offline
> when SNP_INIT is issued, does not have SnpEn set, SNP_INIT fails, and
> there can be no SNP guest memory.  OS CPU hotplug can thus diverge from
> the firmware's expectations and break SNP.
> 
> Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
> SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
> disabled SNP.
> 
> If snp_prepare() fails before enabling SNP it re-enables hotplug itself;
> once SNP is enabled hotplug stays disabled, including across a failed
> SNP_INIT and across the legacy SNP_SHUTDOWN_EX path, both of which leave
> SNP enabled.
> 
> A kexec target that boots with SNP already enabled, disables hotplug once
> in snp_rmptable_init(), since snp_prepare() bails when SNP is already
> enabled.
> 
> With CPU hotplug now disabled while SNP is active, the online CPU mask is
> stable, so the cpus_read_lock() previously taken in snp_prepare() to
> iterate it is redundant.  Drop cpus_read_lock()/cpus_read_unlock() here.
> The RMPOPT setup and cleanup added later are introduced after this patch
> and never take the lock for the same reason.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 39 +++++++++++++++++++++++++++++----------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index cff285d8ad8e..e2f69fba0938 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -513,7 +513,6 @@ static void clear_hsave_pa(void *arg)
>  
>  int snp_prepare(void)
>  {
> -	int ret;
>  	u64 val;
>  
>  	/*
> @@ -526,14 +525,21 @@ int snp_prepare(void)
>  
>  	clear_rmp();
>  
> -	cpus_read_lock();
> +	/*
> +	 * Disable CPU hotplug before enabling SNP: no CPU may come online
> +	 * without SnpEn while SNP is active, and none may go offline during
> +	 * enable.  This keeps cpu_online_mask stable for the check and the
> +	 * on_each_cpu() calls below, so cpus_read_lock() is not needed.  It is
> +	 * re-enabled in snp_shutdown() once the firmware disables SNP.
> +	 */
> +	cpu_hotplug_disable();
>  
>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> -		ret = -EOPNOTSUPP;
> +		cpu_hotplug_enable();
>  		pr_warn("SNP init failed: not all CPUs online. (%*pbl online <-> %*pbl present masks).\n",
>  			cpumask_pr_args(cpu_online_mask),
>  			cpumask_pr_args(cpu_present_mask));
> -		goto unlock;
> +		return -EOPNOTSUPP;
>  	}
>  
>  	wbinvd_on_all_cpus();
> @@ -548,12 +554,7 @@ int snp_prepare(void)
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(clear_hsave_pa, NULL, 1);
>  
> -	ret = 0;
> -
> -unlock:
> -	cpus_read_unlock();
> -
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  
> @@ -565,6 +566,13 @@ void snp_shutdown(void)
>  	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
>  		return;
>  
> +	/*
> +	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
> +	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
> +	 * leaves hotplug disabled.
> +	 */
> +	cpu_hotplug_enable();
> +
>  	clear_rmp();
>  	on_each_cpu(mfd_reconfigure, NULL, 1);
>  }
> @@ -577,6 +585,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>   */
>  int __init snp_rmptable_init(void)
>  {
> +	u64 val;
> +
>  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>  		return -ENOSYS;
>  
> @@ -586,6 +596,15 @@ int __init snp_rmptable_init(void)
>  	if (!setup_rmptable())
>  		return -ENOSYS;
>  
> +	/*
> +	 * On a kexec boot SNP may already be enabled (legacy firmware leaves
> +	 * SnpEn set across shutdown), in which case snp_prepare() bails without
> +	 * disabling CPU hotplug, so disable it here.
> +	 */
> +	rdmsrq(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		cpu_hotplug_disable();
> +

Why not just put the cpu_hotplug_disable() at the start of snp_prepare()
then? Wouldn't that take care of both situations and only end up with a
single disable point?

Thanks,
Tom

>  	/*
>  	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
>  	 * notifier is invoked to do SNP IOMMU shutdown before kdump.

