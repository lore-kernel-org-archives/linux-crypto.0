Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8E3387355;
	Mon,  2 Mar 2026 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483431; cv=fail; b=fzTWeOeM6TE//XzeEJNEyFiOGVogFdWhfdRlWjnGYLdsphghtOd2o8y+bqwHYGhZs0S4cwc2x40z6gldUcqc0YjijASYgXwcT3qFqTH9nSi9Nq1MSs6T0alEYnxAQ5Zp9QlGCeEcO3WS/99OhZqZhvu0ixdsfJpz/+8SmO494kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483431; c=relaxed/simple;
	bh=VUWwU/ZU/qCO9OACGRnxK2fyjY+2j5n4xGUW3RJq3CA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S36FOxjXXhdBdhi7a4fwdv6tMXgLPo45l1Vf3f6PCEYiBCnOqLz1ocSaEVmndVANkn7S6+1M+9E/2D+MoFeG9dQzeWfxTMvVr2/Z0lJVENWw1v+5NZbUbrppf70yB07ECsODhANYgFFBmbaBBwNWlAPnEcTtiVaIkdfS1oCB19w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QQMzNFc5; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QQMzNFc5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=grjuZ8tEL/xqsHIaCEkMyWrDLA5qjZVUzSqgL/nZDAeEFnHRSRjzRQeAiXlaUJLRaZ+lUnd3/MRB11sDq3QPUdHk8a1OY9Si9VbIdnSzkru3nsT9hBfia78nxxlNfqH0Ya8Fsc0cyT/N0cFY8FdfAk48YuVuIDkESLb9G3pJSAURO2JLbQRYmmT7+0Yk5/Ml+JdjHcW9KGez0me9Ia8luZKOLeX8ASIxhiBsfsEM8R6bAeY7hmD5YGApRyDZLbGtT5ba2XtY/Q+g3yMNLOJ8TZ8rJS+6uPkuR/QA8ilYuapyqX0nxvwYYmhkjvDcQaU+EijcR9qfHKqcVkgZpI2ygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWqac/a2n1uQD/syUyH8o7W8TphDKDlm1h+N3w0wQ7Y=;
 b=J4XsJ7STEnr33hXHmoTeGxZiNN7C5CP7yMs8Bn1iTOVgdo8zg2zYwuv1ZartyKDjKIomdPl/ts3n0qFrXrcSCnasvw7EQiJ9NX/c3pJc0ZG6O1j7lBeyWDetLx4rP/kFjSnaOuqe44A4XKrgw29Cz/fy47xUboluGkwdWbAqwkf9584AACdG6jrLJJ0M7hfe69xEGWX4VmthYp6OHv+LnuKfAyG/S1yiX6Om9ttlNXjO4z+i41r8Gl0lGipnesqyVHYSabIhdvycgNXKFBnoqWpkWq3dMljfuVnsnNE82MQ5JsIGA3L53/Br/Nvy14yFBfdoKvzHmZbT5NoiKOoFWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWqac/a2n1uQD/syUyH8o7W8TphDKDlm1h+N3w0wQ7Y=;
 b=QQMzNFc56wQMlRF6zFXQgUtSwhW1lxh/bbOUDBEzog1pttwI7spYTY/KSYQG2uDssefG5AVy3VlfYjKQf18ie1jZkCl0lJIVjge3xzCkulGBJveArUnNvO6cZi0IWXjbIWWBePIPVdt+WB9R0BTj6Ypj/DDOWeX0Qv0SYBaPBuI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 20:30:25 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:30:24 +0000
Message-ID: <d976374d-db95-4f86-9b86-3ac6d7436489@amd.com>
Date: Mon, 2 Mar 2026 14:29:58 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] x86/snp: allow disabling MFDM
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
 <20260302191334.937981-9-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-9-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0237.namprd04.prod.outlook.com
 (2603:10b6:806:127::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f47e7a1-5204-4536-58da-08de789a88b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	Na4Bb12uotqO5VcV6MLxXzP0iCdtXtJDeJA8qJDltjfRM2uURj3zQTF7JVwHIYiLiv6Lb5dg0ZLzQLSuchF6IGGnIzdzM+3/f0HUFN9W3/77TXJEFRMLVI3xrL9K6hxM9C+Pky0saZCE0mX826QAwfmskau2u1xL4p5yOF6uf5DiD92VP9uQTGc0GjwCCvDp81bZn9WZLinSCooU1tltruMOIMFGQpvj7vnvyy/ce3e9caURw/cQ4VhTJp+PSs3MG6jx8XHKaz6XaZYsVMd2fMlmtMyUs6AFItu7QxrzikgOT20T7TzmZzp8PoAaqLhTR/2TfYENtlNP4ypnaSpnNUW2ZBr37MWgxB9lMWEMUIFO9rVwOBBB19JPW4kDnjTK0qJvuoJJROm/9t5PBaX8S1r289hiTl2Eyo9OzJEHDxBQ4nrlrPh4TBO4r0ncyevfRYFWvhmWtazxgIFiFGA0iDSAX5FlKFQmdHqb0nza1SfzAQI3RRB2qViuiOmT8Gbr+tjjljjZjAwpUowF+rrMnTUOp2+ITWZjexaU4uW+633Doj27FHylKIikaU9VISGeGE6siIavpDlvdSM9EZGn9yKC+JWwMBG4RAl6i/ANuNGjNcb3BwmJWHmfPHHG9MTM4hpYDOCaanZLWlN5tLPm4FSpa8jAcrur2u7dUauzf/bRborOkk/VPhCNp0UoXXwUP45csjqRTOoguscI0nuWl1one1hc83Rz/ieYISY9f7vOxHyz0pOK4eTp1fPpJhewF74+aSiRveEAlq3yP+uMMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVVTcjZ5WkNwc054TUFTRGpFWGNrTlZ4RVJHK2MyU2JVdFc3SlpqY2NIeVFH?=
 =?utf-8?B?NURYc2R1a1lPcWdTNDA5SEJ1S0J4anA4U0hiSmpCWHJFWElFMFFNK0J5RWNX?=
 =?utf-8?B?UEhWWUdpVHFOYXY1elZFQWY5QWJwUTY2TVZER2R3TkNIeU1UazVNT2c3YXJa?=
 =?utf-8?B?UGE3bUJ0M0JGdkp1ME5TYy9GYnBYVTBtdHEyWEZBRzEveVdaZWdtMkpqWUpR?=
 =?utf-8?B?alJLY0dNRVBOd1c4WitiMC9zOGhwLzRqOGppcUJXckx6eVFmY0p2RFk1djlx?=
 =?utf-8?B?NDRpdThhYkU1RzQ2bVhxbnRKUlEyVUJGY0dGRVNrTzV0ZFE3dHhCd2Z5elFr?=
 =?utf-8?B?dmwyWFRybllhS0cwZVM0U2pPOERwalBETG50c1daMUVrN3pVbHFaWDlyK243?=
 =?utf-8?B?b0NKNDV3Ym8xdTZDZ0p6NGdkbkIybmU5VWxka2xaeXlVQkVHekd0Ni8zZ1lo?=
 =?utf-8?B?c0lYd2NMNi9kSFRBQU5YNmpsQTBEcHk4SjhrSE1OTFZVOWpuVmVUYXRxay9I?=
 =?utf-8?B?NHJsa3JRd1RoZkFrK0Y4M2tFUHQxNnhsR084R1ZPWmd0VENWSldkbFpCS2Fh?=
 =?utf-8?B?Uys2V042TVl5QWFRK3gwTW9rdFFuVFJ3UllRSTQ4M0RFZnVvVVBCVnJSOVlj?=
 =?utf-8?B?T3pBek1ab3JZRy9HT1JUMXp2bzYzd1VoWitPTWRDdVZmNFVHZElwWUpTWFQ2?=
 =?utf-8?B?Z2Jja04vVEd6dGRRVUZZSkJrSkJEQmZudGhqTXpmKzdYdU14VzdjdnVpT2N2?=
 =?utf-8?B?eEpGSEpDd3Z2NDlCeUdKaklaYzhyR2FyeE1ZYVJjL0lNR1RCSURHUTlCRlNO?=
 =?utf-8?B?aWxjWGczNVhkNU91WXFXM2FUcTlJNUZ3NUFIU044ZmgraGpEL2dGNGRoV3Uz?=
 =?utf-8?B?Z3FGM3QzZDBiUWduV09nNWdtRTJuSkViODV3ZzArMTFnanF0dGVyYXRobEp6?=
 =?utf-8?B?NytRb3JqVTZ5TDM5ZVlGc0NaUTYzbU5KeFZGdWNQTkV3UGd3UUxXeTR3a0o2?=
 =?utf-8?B?US92Vkc0R0hFamxhazNZYUJqcEpTZDcxQjRNNEkzaVZCSHdYWFVKanJ0NURn?=
 =?utf-8?B?d3FaUVA4cFFXdUR1eno2a1JSVDk0TUtVL1ZnbFVwNGV5eXJ4SHVsRkRHQVhO?=
 =?utf-8?B?dlF3K1RpSlRKc0RqVS95ZGNqTWNvYmxkcER1enN0QTQ2Ui82aE9ZWEhReUJO?=
 =?utf-8?B?dmdEcnVZOExMQWJIM3hTS3RuNVZxL2IrR0c1TUc2VEJoUGNybm4zWDFxNE9l?=
 =?utf-8?B?T1FOMUEvRzJ5NXBiWngvUVYzYzIxd21JdjNkNUxtWlMzTVBKaVNlcGUzVkxS?=
 =?utf-8?B?bU9VOG1Keng0dHh4VDMzUEtFOXl4VW5ETldIZVEramZVd2lrZlRKSnJ6dzh6?=
 =?utf-8?B?ZkRCemFkNGtHUzJHeUdnOVRRRVNWWkFSTERwNHlmeUNkUFllNXkyWm1ZQWc1?=
 =?utf-8?B?M1M3cWVBRHdHa1hKNzJZWHVrTVVIMVVOUFB6L1Q1WHUvWnI0a0I2YmV3emlQ?=
 =?utf-8?B?MUdCOW9FRnQ3MWpvaFZxNU1maWxpUGR6TkY2QnI1Ymt4K2VNZmU1WXBncDJV?=
 =?utf-8?B?R0kxVDFkSmE5SkxVb3BHNGs3eERCZEdXdXlNWGk2Um90eGJiWWExcFBUeG9H?=
 =?utf-8?B?elN1QWJpYXQ5UUZ6ZUNsNk5WWFJTeW5ESnp1dzZKS0psZkZSakJqdnFES2ww?=
 =?utf-8?B?SjJFUVd1T0ZlajVidXNvZjBOZWltb2ZUeS9zVGJCazlxVmpHczlYZElBVWxO?=
 =?utf-8?B?eW14WEZZcUY5WUd0WlVUc2pLb3pMSkJDdHYwZ0xVQUJUM05HS1dKWGlzRFNm?=
 =?utf-8?B?dkJhd1pOY3ZtOG5VZ01nOWVDT3IycXl2Y0FOb2QyeDB4TFBSNTlmOTIzRlVI?=
 =?utf-8?B?cGJkVFU1K2MvcnRuaERtYk56MUY5RTM4eWp5Z2hma041ZkRPY1loL05rTk5H?=
 =?utf-8?B?Y2MxbzFzOVAxOGlOK0hBcjh1UmZoOXpMazh3Y0JaTEVqNlgvdjg4T0NGMU43?=
 =?utf-8?B?YnV2b3gwRTdvV0FINTJwWlpTa2Rhckt4ZHVjK1c5WEo5RzB0c2FLM0h5S2R1?=
 =?utf-8?B?YkJERDVSUG9FTHhZS3JoSmVVTWJVSVk1MkFVRHpybHdhMzNHbC80NFgvaEVE?=
 =?utf-8?B?elIxcHFNdjhoaG9tTmdWS1VlaTNjY2FDMVU0LzYvTmZXNU1ONkkrMjUwUmxz?=
 =?utf-8?B?aEU5TXFGb3ZoVitteWxOVlhiQU13NUkxR1BsR3NOV2RMcWtiMVpJQnc4VVRx?=
 =?utf-8?B?ZHhRNGNlTWtSUDVWSXI1Z3Z0TzZteDRDbEFtelRTT3EwYzZDd2pSejcwRE05?=
 =?utf-8?B?bnR0b3J2TXAvU2lFRThMRnVHMklRRzY2WDlmVFljUzlDRzNrOFFsZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f47e7a1-5204-4536-58da-08de789a88b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:30:24.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ViPAzhK+UmzLm8AeNlZ57Xms4FuFKR7I/9Z0VUKLKJGzpknP1vMBvikxdkvEH4ZwxxzWF7cVbRTBjjTM99QMUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SNP x86 shutdown path needs to disable MFDM, since as the comment for
> k8_check_syscfg_dram_mod_en(), the "BIOS" is supposed clear it, or the
> kernel in the case of module unload and shutdown followed by kexec.
> 
> Change this helper to allow for disabling it.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

This could be squashed with the next patch, but either way:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/virt/svm/sev.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 53bc0c7f2c50..cf984b8f4493 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -132,7 +132,7 @@ static unsigned long snp_nr_leaked_pages;
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"SEV-SNP: " fmt
>  
> -static void mfd_enable(void *arg)
> +static void mfd_reconfigure(void *arg)
>  {
>  	u64 val;
>  
> @@ -141,7 +141,10 @@ static void mfd_enable(void *arg)
>  
>  	rdmsrq(MSR_AMD64_SYSCFG, val);
>  
> -	val |= MSR_AMD64_SYSCFG_MFDM;
> +	if (arg)
> +		val |= MSR_AMD64_SYSCFG_MFDM;
> +	else
> +		val &= ~MSR_AMD64_SYSCFG_MFDM;
>  
>  	wrmsrq(MSR_AMD64_SYSCFG, val);
>  }
> @@ -532,7 +535,7 @@ void snp_prepare_for_snp_init(void)
>  	 * MtrrFixDramModEn is not shared between threads on a core,
>  	 * therefore it must be set on all CPUs prior to enabling SNP.
>  	 */
> -	on_each_cpu(mfd_enable, NULL, 1);
> +	on_each_cpu(mfd_reconfigure, (void *)1, 1);
>  
>  	on_each_cpu(snp_enable, NULL, 1);
>  

