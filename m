Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010039.outbound.protection.outlook.com [52.101.85.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D3A2DEA93;
	Fri, 17 Apr 2026 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776436806; cv=fail; b=ikeBwn4R9C7YhRhxaezaz6jWPUnAHuwsZVPz1/IOMDjXnYy/CWiqqk3nVJTLEF7/jWuL4E4JapwcBzxaAarcaLoeQD9uxvvZpVup0WentrvdcMhNysUvFepceN6Ps01DIad5bbBemz+NAxhienBOaPOX0ydEZ5Hp0N6dJ8ViD3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776436806; c=relaxed/simple;
	bh=r7dIFzu24J/rsX+CI0WK6FW0qzGnPJ5ZnlWGrq6w86Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Usnpkue9nhRPds6ZW4PlrfrMF9g9mUv/qJSWTT8V2BjANFJoHOHFGoQF9VTwuwTxDEZK0JpweEV3/oVSCTqxWic3sbd8RINSQCLT4+iThqhDrylusRr9CiVTVfzb3uvlkAjn02ur8KVQLIrHTYT/i+FYrJbo13C/fPGztvrlAK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uZM2VcvL; arc=fail smtp.client-ip=52.101.85.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uZM2VcvL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2oz3fw6nex7ADnivTL4md3EiDZFRMkTHPDDmt9o1oEFwF7iWAIfNAOrbJghW3+uPwDQvmC6gh8034PUd8Sj7Xy2iuld06VfmFPBSqOSF/rSZhEoPUVBv5WJZBpAT8DCfZykuHj/i3A8IDmXJCu1kCRXZ5LvE68kPT637HiOGQaSedsrH4b+lYKkbaD88Ipn+xO93RW5RrprbHwSgT7/tyH14cbXrgOTFCJE8kz2R7TWqle0cjKwe3mXEw723XGaEmQ1hBKWMP4jV9EBd2W9r8C+r8oX+uFDCK1lbEDSI6vSA1I9Z/IZ3dBYDqL2/1vM9DhjkT2fBEW7K4gVX+z8kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaNCtUw/oUuo5P/UcvZ+X0zRA7KoEKDc3Qd3F1o3uZE=;
 b=a/4s+vygkM4TUDeIkxOVpvTeqixBwg6siAqVHLdWGibPbbMFdw5995gJSW4A8GZ/cZ5g2Ils3LDbUfliKOoN91Mccz3M/QxW5i5dOdODH+HRAuBXgpAQY5UNjKWrdfSdr9/00MbKmlAg++mgDAOVzVr8XnJpLOPQXCm/Mz8jWDWBAcLtxFOszP+IUKyWaKLIj7C49TCfD2oJBSO/sOXo5pJPgNsEu9LLbP8vQeObUGI8pb+j2N0FYBnZq1DFDaCh7TKx5W9+67Wo0jcdnZo8jygEu+pLrsfOM6VjKZmFuRB8bWVipD31oZ2LmDaWlV9X/Igk4bOaGWJeA0gI4lq3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaNCtUw/oUuo5P/UcvZ+X0zRA7KoEKDc3Qd3F1o3uZE=;
 b=uZM2VcvLezbZ6/UOEA3BHLNcAnno9XhUkTPfiO7PVCZlfCRWqboa6KAK5bKvIRp5O6/tkypZFCxFpbUF0wmCzNQGl5Abub2i0D6b80OgPnsLEAb99j9kPqeKRxjVmvkMpuMgo/py2/efvEfU1f7dAmuXBQ258wkQCAxH2zrH1ro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9403.namprd12.prod.outlook.com (2603:10b6:408:217::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 14:40:01 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 14:40:01 +0000
Message-ID: <d9bdfc50-d268-4ebd-b861-169707d194f3@amd.com>
Date: Fri, 17 Apr 2026 09:39:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SEV: Don't advertise VM types that are
 disabled by firmware
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Tycho Andersen <tycho@kernel.org>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-7-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260416232329.3408497-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:805:ca::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9403:EE_
X-MS-Office365-Filtering-Correlation-Id: b7a4166e-28e5-4a7d-269b-08de9c8f3481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Z4DGmdAbxDPOv2Yz46X9WvReHW0usLexSh+RD0D/RXSKSN4Msps6FnSiWX5NjWI9kzvVeWPRo5VCwXmOYYxaYJhrPbax+vRv4/SUKExzViPMpOsc2ZXkGg17cT1ZWLb07cPsFSF6T08S7hGvG8hT0x27EFerie0mLLNVBHJMIhc0frLvddpOLkrDSFNCKyJPHFHWwE2P0WRPfAHVCNgIQTlyrL5N2eC91QHb95TfOJq1lfuBPjWP64iGANjYzzk5jlqnkQRNjTpVmVTM6QPqLOtqvb+mMfDM4qXm6w42iTKb8eNN28cKHzvO7xjbiHmNFJG5vz0N+0lvG9bRRwn89S4+JSSGM/a7nrI3k8f6MCxVCT0rVFck6vj4lNqvXYLkpWO0W49M6ZJhQMXWCvShMOTol7ZQWml+wXw5IsiS/ubPvCNnlpmMG6UGh60IolHahxrfRlhAwQ//yeG+PuKQo2CwLR6s+a8r6wSTk4EKYurgHb23IlhEue0FByFoPIAQkEXErfOlBDGj86Sl40P4yvu3azTMjboaASfqZqHE/ntKDK94M3DOT7XQetS3bYBxZtZtUi2JILBfREfwRmaHZeb8/yWtbqccU2mmIWA7HJHSk8+JotLoBSx/5dVM3B0EywYX+1tpN+eqNzVejvZbtLm8sLqN4SjGLUi9iwp6S21tbqc2LUon5r6wwa41G3gpLXNMYVRWJFvLkIcxWB81SCfEtyLQ6QbccEag9mQXATCFBTW3e+k3hoJP5p/7HVvL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3FTYWsxeS9vdXdwcVN3ZDVEeGcrNy81dEVzK0ZRNThBV1U0Z29wVmpxRTMw?=
 =?utf-8?B?VVlaNGNzUFBMOWhJR09GcUhOWk1RSWhwN05UV1gyNjNRYUYwYjFjZVExOVps?=
 =?utf-8?B?QkFYemlJc0hHWEt0eUxFUmYxcmJwbTdqNVdmdE11UDFsenhNNHpJdjc0dUVh?=
 =?utf-8?B?VStDTnVHcXIxazJpRmN5L3ZqNjJrMk85QWQ1ZWFqYUhCN1U3K3NPWWpUcHRX?=
 =?utf-8?B?V0k0MUc3L2k0K0lsVU1VTTRrYURiUDVHcHZUWkYzeUdxYlk0clVXdnBtMUNH?=
 =?utf-8?B?RndFT0dIUWJIVEdjc2xtZEhpc2lpeEx3dEt3Qkh6ak5XNGl2WGRKZkZqQWlY?=
 =?utf-8?B?SHY1bkVSSWVFZFcwMGliUFk1dmU1NUVnTEE5T0prekw2OXptN0hUemo4ZkxT?=
 =?utf-8?B?SGo2a2t2ZUtzdkw2cUZWMnY1akkxS21pMjl5K2JWaXhxUlFsT1I1TVI5RzZF?=
 =?utf-8?B?S0NXS2lnTVpJRnNNTFVhaEhUekUzV3VyNEppaXNtRHh4ZUhhellIalRqVjRk?=
 =?utf-8?B?clRZNDZQcnMxZExvME4yQUFrUXVFUE05SFdqS2NqdGxKZlFGQnNvMWVmUnNm?=
 =?utf-8?B?NEJCeHBSVmZvZGdhQjRKNG5FaUYzdVlvYUVIek9ZenZWZjVwc0ZKNVNoNjFG?=
 =?utf-8?B?bGI0eWZWNFVGYnkveDBqTG41WVpDMGxnQzB2ajRSQXczNnV6cy9ybnc2dFRQ?=
 =?utf-8?B?THlYMXh6ZXRDNEdjV2lFK0JiRXppZnFqOGZnUG10RzduSTFVVjJRUlFIa3NY?=
 =?utf-8?B?YUdMNnNOQW5FMzV5c2Y3bnpkbnFkdnJhSU5BcUY0MGkvNlkvZ2dKcHhNQVBi?=
 =?utf-8?B?c0R5ZUJWVUduUTNhOUtlZytRdHdDZzhPRjg2MzVYczk4S3pFOU9BdnJXcDBv?=
 =?utf-8?B?Qm4ya2U4YTRLZEM5NjdjMm05bW1EaUJrRUxKbEV5aExBQ3BIYTQwdVBPM21T?=
 =?utf-8?B?SjcvdXdlRG9FS1FnQlBpWVM3WWZvZkIwQjdEaTBrN1F4TEFDVnY4T2NCQUQ3?=
 =?utf-8?B?b1QyL291QzFyWk9OL2YzbTV2alJ4Y1JUMUhyZzNESHBFNFdQclc5MFlmeTFL?=
 =?utf-8?B?U0cxeFkzeFRncjY1TnV4K1VVb01LL1pUcmZVMDhhZTJWcDFxT0VtYTB4b1Jm?=
 =?utf-8?B?MWxmU1lFM0tSd002Z0lmQXBHMUJhQ2NrNDY5TEZGNmNrK20waEpzQ1NwaTls?=
 =?utf-8?B?SHFoU0VuaE83L0hhM2VDTFMwdXc2MjJGaXk1elIxbk53YkJubEViVnBnUnZD?=
 =?utf-8?B?SlZyNjRzUUgzUHNPQlBWd01xWC9WM3RNbHBzZHY0dlZmbGY0MGEyUVlIRE9i?=
 =?utf-8?B?NHJyY1E2UDQ0cURzc2EzMFJWL0l2bXF4VS8zdHNGVXpKaTg2T0VVRmVPQlJ1?=
 =?utf-8?B?VW1lOW84MkE5aW1vRDNsMXZlOHhLZS8wQjhUV3lDM3dUQmVFbkt0MVJJMHJK?=
 =?utf-8?B?TzlHd2xMZVg5Ni9WMGUwWDhsNVNSS3h0Z1pMQnRWVmRVclE5bEF5TWpXUzVV?=
 =?utf-8?B?WWhkY2ZhcTRjZDM4WjJyN1Z4M3JhRHh3SGVOb0JibDFZU21PWEpveW41czBr?=
 =?utf-8?B?ZEh0ZW1zYWZuSGgyN2V4V21YMW1kWXIrN2kwR0gwc21FcTY1c0dJblB1S3N3?=
 =?utf-8?B?M1YrV28yQmZZTDM4b2sxZ05LMjhVWEhiK0VRTnc4VlNOdnEwd0Q1SUZSN2RT?=
 =?utf-8?B?S2hXSjQ3RlB6eFhGUWtHWHAvMmlsV3I0UjRVQ1puN2RkMVk0ZmMzdk1FM2tv?=
 =?utf-8?B?dDBHNHRuVjVDTjVMeURnVzllbU1QNnIxRDhtZWN1MCt0K1F6K3RPMHJNM05w?=
 =?utf-8?B?WUc3c1YyUVZacW0xUHRmc296UDZRUnY4Z05PWll6bVhQVG5oenh5RVE4K1A3?=
 =?utf-8?B?MDBZaTNCNzhQOVdVV2drdFRjZ001L2tGNUdpT0RZUkVwekZoVnN3UmY1RjB5?=
 =?utf-8?B?SGVQSHM4SUlNOTB1L0wrL0tINmltckVFdDBMeWUwOWc2NUM0dkdaOUthYk5M?=
 =?utf-8?B?QkswNXpHYUFHOUY4b0ZCdXVYcWFnZTVreFBkSEZGc2ltWE54ZG5DNG51VkVS?=
 =?utf-8?B?WUgyYU96RHloYnhjd2VnU0hpUktEZm9iempIY2NSbVdSekQycXEvT0RHMGs1?=
 =?utf-8?B?aTBiTTNobWFnUkowa1pqZThyMXF6OWVCek9PVGhaQi9xODc2d2k3MTdoeWJW?=
 =?utf-8?B?dFdhQmNyOGE2MENBRW4rM3lnQ0JYSURIN3RqQVNoZnU0VkljRzQvYlhNc0lY?=
 =?utf-8?B?cEw1L2pmbDU0QWRvcEgzVmhJQ29TSjk4QTdaa1NaZThVSDRUdHd2ZE9lZnVC?=
 =?utf-8?Q?d2/dtZGLxiMP3qZbzj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a4166e-28e5-4a7d-269b-08de9c8f3481
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 14:40:01.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sz1qtPdAF5KBDEBD/9MX/p3qD0rsSWCUKDvrcwe71ybfs+Dni08KPoJ9+W3XPhMYL9JV5/aqzA41gaYxuQ37Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9403

On 4/16/26 18:23, Sean Christopherson wrote:
> From: Tycho Andersen <tycho@kernel.org>
> 
> As called out in a footnote for a recent SNP vulnerability[1], it is
> possible for a specific flavor of SEV+ to be disabled by the firmware even
> when the flavor is fully supported by the CPU and platform:
> 
>   Applying mitigation CVE-2025-48514 will result in disabling SEV-ES when
>   SEV-SNP is enabled.
> 
> Restrict KVM's set of supported VM types based on the VM types that are
> fully supported by firmware to avoid over-reporting what KVM can actually
> support.  Like KVM's handling of ASID space exhaustion, don't modify KVM's
> CPUID capabilities, as the CPU/platform still supports the underlying
> technology and clearing e.g. SEV_ES while advertising SEV_SNP would confuse
> KVM and userspace.
> 
> Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html [1]
> Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> [sean: rewrite changelog to provide details on why/how this can happen]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

That added line gets a little lost to my eyes by not having a blank line
in between, but that's just me :)

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0971cf652b0b..ab386aa0c284 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3202,6 +3202,7 @@ void __init sev_hardware_setup(void)
>  		vm_types |= BIT(KVM_X86_SEV_ES_VM);
>  	if (sev_snp_supported)
>  		vm_types |= BIT(KVM_X86_SNP_VM);
> +	vm_types &= sev_firmware_supported_vm_types();
>  
>  	kvm_caps.supported_vm_types |= vm_types;
>  

