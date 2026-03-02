Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F16F3859D8;
	Mon,  2 Mar 2026 19:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481512; cv=fail; b=UKJINQH05+a7aqPwpgEgAqjBZRd3uALFcZ+kdrg90naeIUPg9oYcEYyH4UO8ftq1ddcyAfsPGExFbXApFRysPKWF+F4aOudHUsEHDDFw6g+TfJPWm1LUNsVoiulcIXQiPT5El25OQVnioSsurR6wonwez8ro8yoPSbZlCuDSHMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481512; c=relaxed/simple;
	bh=gRXLNfY+g9SBpmPbG30Txn8oBAC5WzIHg5KkY0SR7xo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mm1OfI/O7hNaxl1/7FDDV2OVN5PNJBQEvgfl06dyKeaHYtRfpuLEDoFDI67LOFxG1WuqyLuHTmbXlM4I5hEmLbXfT1Ne3ZV8OQba5TK9i1A252YIewfLi8QopjMfq2HS9bfZVxA1vpqd5ghTX9e1J/6gNTfTsx/GlxrI7gUa+JQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2hg/4FPx; arc=fail smtp.client-ip=40.107.209.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2hg/4FPx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDcoJ80fS+ILTXK7ppMyr8udlmbEdPtG2jdDO2g3hTc7pDxD5GAqN5A796IU24o0RjXMtQPRyr1+PHpwGmG1m6pJXR5yPyU8gVOn//Yd+nl2OzbzFmMbglv9KFXGWy7KDIl30nBBf/2lkpyNVFG8Dk5yEtrEt/Lcr/Ma5ZA4vGIGCt6Iq2gTLoo8ziOk1G3vXM0c25L/06SmLC43plNhkeIj/2Zs0Xz56slD1PtQ/L1xICbH2tGUV3MYxpthnIUPwlGI79K9xrFKtW1xEcxVAg9jhcNMP5gNKj1doLBHOXI/wvRiiIU60lTTYHvDTr4Q5OAi5QE+7ZKYeCfl1H8qQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lM1kFMxzXwgWiuR/k1JMffO0j29UiDwwUqfjc9DVByg=;
 b=fubZFfTBegGOtqE+QzlsJyhxUb+dnwzDovp+MdOyt+Ej1zEf3ZtMbSuYhbGE8UnxxscIMhDBzU+e9qy95irDiZ4OcwQQJ+DGVY4wdPFHguyIJjZFQypLvc164Lwm0kHaPpv43RUdydgXDGfHsrqG+Ta9iAD+43Rz5qwf9JhCYLlWsfuafiWHYdR4J0i9FUKIZZhoxGByB7UKesq5N5B1Rn0XYhQ6dvPnEwA4oeIdJj156eDd52fHF6tPrdXFaeJXxfj+VCYU/PcIcmOzal8DfVZpoimOuFTVhwNAsw/xciFsH1xwRTtYYRYwAv0t4VL/itYz6lnkEqKYOIp9WEj+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM1kFMxzXwgWiuR/k1JMffO0j29UiDwwUqfjc9DVByg=;
 b=2hg/4FPxZspr3XW4xCD2XHJLbh0IpRvkg5Crf3mEmtzQXlG1m+3eiA1ai5reZCxzK1HEK2N3fLbgNX/WSaHtYVsYGN2qxc8K976F7xlnY27yUJPHlmz6lTgZJBZBXBtQrZz+8ZfQayq44yd6CPYcbwK9mOZlqeCcC5BCnDeFqOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB8427.namprd12.prod.outlook.com (2603:10b6:510:242::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 19:57:14 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 19:57:14 +0000
Message-ID: <112525a7-b8f4-46d9-a351-cdb4d9bfff2c@amd.com>
Date: Mon, 2 Mar 2026 13:56:56 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] x86/snp: drop support for SNP hotplug
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
 <20260302191334.937981-2-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-2-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:610:b1::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: db7f58bd-16ef-4d38-ec85-08de7895e668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	skjZsxJUfcyw1mQRAzx7XqdyDY57TBTqHEml0WlED/JNrFUc0LeyJ85Kg/wJHd/opqx3UYBTCBsPCzgJ3kUNwRB66elihp+3ehvaoch0UsWeUVcpuBkts7X2kPxH0p/jJrSKr+e3bLv+SrA58zr9oHgReiuVh+W4XZH5PZXN7OGf7/WCWGw3WuBbxdyQRZzyOPBU7wOKCHFtYNZ/3NnUnZLsr13XxnSAlS1Lnx4c7DQdLyNFCy7YgmoDpILZkv1w7bASJ3bEkKu3t2H6rqguNt1cGQMp095J1aMPwms22nyC7xOsExx0+VQC5NEvsprAtdnsbh1YqU/wK8eaWGmP9UqQsZk95tx6nf+mykHpVoU/7tuYK2EEud33kX+5lgC+ot18gfQ+5/+sLUm2IUptiRrYPc4AOm70I6jMf4DWYYc+ySRejRGqCmiDMjTkTm/vBCGxVO2mn8vlzvb+e9Hb4/XM9/BRmrxt7wgTHjjNnjLCxFl1zyReIu85Fe0dk8AgCE5/Wm+4Ilc6bTGlAlSh6xeBN5crmFsk1t3Ioca7Rf9gZMnRbY5gpw4GlLYQPBR9V7V72UEca0klrYaQPfsDSTxcBByTPOx4d7X0M3F309g9MGeM0u8bWtCS5bnkdLyyOC2A/TOf3zXdUi8dgnpwYM4mz5F7Yujed/esZeyCCWWa0EwK57LKwT5RjOsYEfu8GLO3tZSPPCHfnfVLAk6W6cJvmu2YyJ8y3IBhYvjriiLqubQMYkPqw31tGM75KKEDJYTZeUbPpTs5vHOTUKqx4A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGRWcUFJV0Q3c2w2aTNaeUNvVzFJUjZ3WG93NDZidk1ZYWJiand3bWlIb2ZY?=
 =?utf-8?B?VVR1Ujd2UXg2anhGVDl0Wmd1dDE5anErQ2N0WHpXN2J0bUtPMkk0dWlra3FE?=
 =?utf-8?B?Y1o3UHZlemUrbDVWVWlLRVJzN3MwRW4rTXh6MS81NDlUdHFtUFFLdkw3ZGdZ?=
 =?utf-8?B?RHJwYkw3UWNhb0dxaC9OL0FjNXZFRGlrUWhMWi9JeWJGRWdWcFYxNFYyc2Uv?=
 =?utf-8?B?MDM0aTJlMTRWaDZpNUhNeW9tOW9Od0E3OWpKWnFHMHB4NTg0bnpjOEhOVWJs?=
 =?utf-8?B?M3RPaWNwdzBXdmo1ZTRSNDZqY1BGdmJSU2pmT2lpYllnSEJIMFBKSG1WelFV?=
 =?utf-8?B?elVTSTdpMVl4M1BOb3NaeXFOT2hrTmNkVXBXaGNnZ0xIcERyMGRlU1ZPOUYy?=
 =?utf-8?B?YTRSNXVHQ2pYbitacU1iZmFOckx1ekxZdDNCdVBqbEp6RFNESWpsdGp0S3Nr?=
 =?utf-8?B?ZGt2Zmc4eHhRVHkzRTFCaDJVMUFTSUJPQ0VQTWw1bS90dnNLL2VQQkJXUTVU?=
 =?utf-8?B?aWdwb2JPMDBTME53UVZuL3p5WE9ERDBnbmRURmZ4cW9KMlJNV1hkd0Q5RXpN?=
 =?utf-8?B?Zkt6VTJIN3NraG5BVGJ0SmNpY2l1c3ZpOUkxbW8vN0NDSXljOC9jQko1dHRT?=
 =?utf-8?B?Nk5Qc2VUYU9TNEoxZWxWRXV5SmcxODdESDQwdzB0clhnR3VPTmZPeThqZUw0?=
 =?utf-8?B?S2dOR1o0dkFSdTRyOWNTVnRkQWlkU1hSOGJRWjdJdDliZ1NNa09ZMUN4N2xO?=
 =?utf-8?B?T1lDL0ZnZDNTSENYUFVPT2hIbTI0Q2Y0cGdsaDVWUzNMUUdQOHNyNHEvWjBt?=
 =?utf-8?B?MHRWYm1RS2hEOWErMmJKSnFoSk5rZHp2bWZnMU1wMmt5S0dPNXYvRjNOUmt3?=
 =?utf-8?B?cHVsUjIzSHpUYzlJMFdrU3VPYU5Bc0tXWjFnSDl3SW90bzdtSnBDaUdQL1R5?=
 =?utf-8?B?QjhldkVSZFV3OHVCQmRpanA3UkEyVngwUjFSZmdFZUFkZUVDUjBRWmZFdFZj?=
 =?utf-8?B?QTljWWpORm5yMUJGN2dVSXEyUnJsTlYydERSN0FIVmE0R2pmWEM3c3FFTUFn?=
 =?utf-8?B?amhqQmlrNlZwWHJ0aUN5SkNJNk9rK1dWVmQ0UVZXazVhRGZSYWYxYVlGd2xR?=
 =?utf-8?B?MW9FU0EyQlQ0cEhTTVhJYmxMNGdialBwY2hnbHBrTkhaSUkrcFJFd3ZqZUhU?=
 =?utf-8?B?RDBTeVo4TGRmUVVQYjlDMTJ5V00yM2JQWk5aWFl3RmJoUzdTSzRlY1lpQXlN?=
 =?utf-8?B?QW1zWi9LL0xpYUI5MC9uNTdJVjRvSWZaU3VmUjY2TXFwdzNIM1FjeitkbVlm?=
 =?utf-8?B?U2VMdkV2YnlIUGdoWEY2ZVVoVjRRaFpyZU5XSmFqOEZaejdsRmFEN0puVW9X?=
 =?utf-8?B?VWtZLzZRRXBIVTRmeCtRUkd1QWpYN2NCU1FYQ0MrR3MrMWszQjE5N0lDa2RI?=
 =?utf-8?B?N1VnY0d0Q28wTklQUGVyTlRIWVV2SFFTeUE1Yk95b3RnL0FKVy8zZTNIM0ls?=
 =?utf-8?B?ZGJaemxBZUpNOE12NGVhWmM1aHdVTzdYdm1TUm0xTHlaZUwyQnc4L1UzK1hp?=
 =?utf-8?B?Mk9McTBsQmY3cjJRL3JEUTc3N1FxNXpKaWcxb2ZqQ2FHVkNkRStZV25ka21Q?=
 =?utf-8?B?WDErU2pDbGlhOEtGZmI5ODVwMjJNcmxpcHdSTWtjSEYvY0hYcG9WbDBVYXRV?=
 =?utf-8?B?TXZHVkt0ZXBQaUhZQjdub3h0SDhnNW9jTFJINGxZYmh1ZTRJellHbG9mR1pu?=
 =?utf-8?B?cC9QT09OaUxiRnRQY0NtZldpS0hTUzBzNXBHajBtVTh3c05kNTBZSzVkL0Zn?=
 =?utf-8?B?S2ZqQk9CaGFmQVlIYUpQYzBDQWlYb0d4Ulo1cGlGeWpNUlFtNUszeEplTzNE?=
 =?utf-8?B?Ri9vMjlxZTZvYldHRUZSVzU2cG0rRm8vUHpoWk9IL0FRV0VCZ2t2WlVVaEpI?=
 =?utf-8?B?dUF2eGtFTnZ6VzBJd0JNWVlSQUZjMTBHNFV2TXBmWkx3bFVqYW5jV0NlSmpL?=
 =?utf-8?B?bFdMRCtqcGNEcmhVYUVPTXBPUEdqZmVibno3K25kYytkc3ltTEFqcGc0TGZL?=
 =?utf-8?B?eDFMTmxFSVFWZGxHU1BlZ25aU2lUZ2hPUHB1ak9jTGFXRE9IVklVV0I0M2RF?=
 =?utf-8?B?QkF5eCs2V1hacDhqNG83REF0TEppakRkZXVBY3NvWE9ncEJjVWdnZmExWU40?=
 =?utf-8?B?M2M1NHVzY3VYVHQycTl4UW1vWDlXVjk0SC9hb0xua1pramhGYWpCb3NHZ0hh?=
 =?utf-8?B?Vzgxa3VvRWUxOFRnNnFvQUE5cmlRVlhVUExha3JNTWU1djg2WVI1VGF5VTRt?=
 =?utf-8?Q?Qt9LB5yi7ZCHNB2b7z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db7f58bd-16ef-4d38-ec85-08de7895e668
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 19:57:14.6048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVQr7PxbF9/VkVcjUIedd9UXS5+0Tv7ccMdFZpEbceMz0ZzBn/ncpvzXJKGerWxunZpNoF/Wn6WAzWXo+nvwnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8427

On 3/2/26 13:13, Tycho Andersen wrote:
> [Some people who received this message don't often get email from tycho@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> During an SNP_INIT(_EX), the SEV firmware checks that all CPUs have SNPEn
> set, and fails if they do not. As such, it does not make sense to have
> offline CPUs: the firmware will fail initialization because of the offlined
> ones that the kernel did not initialize.
> 
> Futher, there is a bug: SNP_INIT(_EX) require MFDM to be set in addition to
> SNPEn which the previous hotplug code did not do. Since
> k8_check_syscfg_dram_mod_en() enforces this be cleared, hotplug wouldn't
> work.
> 
> Drop the hotplug code. Collapse the __{mfd,snp}__enable() wrappers into
> their non-__ versions, since the cpu number argument is no longer needed.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/virt/svm/sev.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index a4f3a364fb65..1446011c6337 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -130,33 +130,26 @@ static unsigned long snp_nr_leaked_pages;
>  #undef pr_fmt
>  #define pr_fmt(fmt)    "SEV-SNP: " fmt
> 
> -static int __mfd_enable(unsigned int cpu)
> +static __init void mfd_enable(void *arg)
>  {
>         u64 val;
> 
>         if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> -               return 0;
> +               return;
> 
>         rdmsrq(MSR_AMD64_SYSCFG, val);
> 
>         val |= MSR_AMD64_SYSCFG_MFDM;
> 
>         wrmsrq(MSR_AMD64_SYSCFG, val);
> -
> -       return 0;
>  }
> 
> -static __init void mfd_enable(void *arg)
> -{
> -       __mfd_enable(smp_processor_id());
> -}
> -
> -static int __snp_enable(unsigned int cpu)
> +static __init void snp_enable(void *arg)
>  {
>         u64 val;
> 
>         if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> -               return 0;
> +               return;
> 
>         rdmsrq(MSR_AMD64_SYSCFG, val);
> 
> @@ -164,13 +157,6 @@ static int __snp_enable(unsigned int cpu)
>         val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
> 
>         wrmsrq(MSR_AMD64_SYSCFG, val);
> -
> -       return 0;
> -}
> -
> -static __init void snp_enable(void *arg)
> -{
> -       __snp_enable(smp_processor_id());
>  }
> 
>  static void __init __snp_fixup_e820_tables(u64 pa)
> @@ -553,8 +539,6 @@ int __init snp_rmptable_init(void)
>         on_each_cpu(snp_enable, NULL, 1);
> 
>  skip_enable:
> -       cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
> -
>         /*
>          * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
>          * notifier is invoked to do SNP IOMMU shutdown before kdump.
> --
> 2.53.0
> 

