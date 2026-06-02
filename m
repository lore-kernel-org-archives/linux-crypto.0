Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760B91B87C9;
	Tue,  2 Jun 2026 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780412054; cv=fail; b=KQBdLl2Uw6YU7bPXxFaSQQhxDgOP8juqd1qJ2WFMgl9elW1dlQAGBxtjf9Zu3ZPiJ+otMDCq+jiTGshq4pKy3+ETSL5UB2jliSEDi2I8jBfrFek2q7Uyi1BsTNchAVjg+sFUcymniTInimyUgKLXCc9t61KjfKHlsxVDx4toDR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780412054; c=relaxed/simple;
	bh=2SEo9naYCZY+7KpBxnB1g8YsxhwUdLSybIiDd9wkUJw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lzY+OKMvGTK6cMHMZ0CO/N2uVSfbKY1cDIMZCxOCFmvuRb8ZIyGedOhMejiJ614uSgBtuSEjwh4jIoUtFf0OgIX0Hb91PxZQlGy8qXltTl/K/2sIdmdoCMnJuOzdlbvHD2U7ANL/CKyik8wTHo7o6irikOoAk2naeNN0GXW88QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AxWpYtT1; arc=fail smtp.client-ip=40.93.198.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AxWpYtT1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lB9MtkZjG3oDlYH0IUunH+YkwmPRDJq46iqg41JByRvIdktco19mbBawVi3KWdiGZgpltZkpLo2jlznLoQjxTqN/qEp0nX8kkZkUqQLCJBAapzJJeVLcOTAJXT295wK/UMhq7dkzRV77bDbn2d3mV72LJdJzpy0Ju6yViidtD5+Y2P/zXL0FTPORLHP05vCWXOJ0SXdcdhZtZtigGbex2Nd+nZN16esEIlqbsrCeHxVT4bWcdHQRxAdYW5Pi1xa4d9ObTgJOO/pG6pGxR+yFe/MlMsoB4+ElM/3ynTeKG82Wysfsh3j4eoegTHEbzBp43BksFUAC5G2VkynQ+ksUdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbTkoSrJZLALYGZyc83Gb1x3aQraBz09YBPqMlK9BxY=;
 b=xP0GY0IT6jgut9JYU/S/B2gUR4I5gLTqn34YD+KiuQXGQHw5uKXhosVoiVaYEOrr5MLEYAX+bZ6YGCWnPi4VmIgG7KoQQ3QGxYeF9pH7VeesTjnSwdnT+FP/qtmu4oisRAcClG+Ua+O1GC1a62WIB44/cGEmvozs8DqAM3hVHy0ZqKeVTnIO3wm+K9nUhPzfGkkX3zyH4exhYmS/iefyyc9p9IDaeyFeWScJaIy7CisIfJsfOrQkRHUe8UBgctSAKTphJhTvFEbShd5iNfIwC/VNSYOYE0EdHDq4Cjoap7CZG/9EG3tsYDCPa4YVE2EfowTNvyd1yc1jt5As4yvwMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbTkoSrJZLALYGZyc83Gb1x3aQraBz09YBPqMlK9BxY=;
 b=AxWpYtT1phk4Fc6XN9FjrCKOnLiuwUjT+ld6kUOBIn6kOUpRRovVN8IhgdeIgMknOcV8bRWM4atykgWI6HSdL72aN9ZS06keX1IUQBBLhQjKhkuHlAuUReZSCepTplGzYzJMVqT8QC2aQWF7K8qaRIsyCqu1LTwLdVhV3K15QBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB4165.namprd12.prod.outlook.com (2603:10b6:610:a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 14:54:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%6]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 14:54:07 +0000
Message-ID: <f57a427b-0fc8-41f6-bc3c-cd86e7812629@amd.com>
Date: Tue, 2 Jun 2026 09:54:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] crypto: ccp: Fix memory leak in SEV INIT_EX path
To: Atish Patra <atish.patra@linux.dev>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Gonda <pgonda@google.com>,
 Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org,
 Atish Patra <atishp@meta.com>, Sashiko <sashiko-bot@kernel.org>
References: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
 <20260601-sev_snp_fixes-v2-4-611891b28a86@meta.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260601-sev_snp_fixes-v2-4-611891b28a86@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0022.namprd18.prod.outlook.com
 (2603:10b6:610:4f::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB4165:EE_
X-MS-Office365-Filtering-Correlation-Id: 91863ed1-03bc-45a3-8651-08dec0b6cbfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|20046099003|921020|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	SAAoE9Lf5NA3qyU/ntsa3zcrCnCha33kDe1D/j8HiV1EomdUE4F5LZKS6V08NJiMKC1HsUH7Nw1dNOkOfo2dR7NHo48lChFrDuW//ELJTIPEObVDRzBo9/Y4/8PXG9b0AfXgW2t0y7hqXb4o6srASKeu1rvf/Nr/XInwE1RTRNHRKUirFOIlMWHRqw85vm6CfboXsDiD2eDBj1Ua7hWMsJqActTzfGlK6CFDK8tlbXITMLELONJRWYF68EtesaPnVaIrsExQtsCtoWoOhmvtaw1g4IoUw+I7hKSod1hq7XmuYNiZb3yGAB98c1qv3wbksQdWgZ7eqDMFvnS67t0kJ+G80VyBTSOxiSPt5YLbeDzaWCNxatYRWNeuGeow1RhoqJi1UxlfjzXH/4R4BhvVDt22Np1YEoPayQzVWVTswgE26qcOAR+QzItA8E9ExHk5RKtLvFABD/L060XiI6FA8cyiI3oEq/+RufLIoAt0Mpy9gQI7j7IiI8ZPbUHECzi8TUKPOUoI641Kyut5qcAfvOsb/hNK1gl4upZyHHMQ5BrvaZssCtX3QAUgZC6Lgqaf+tluQp18Auk98m6bIzFFmWdruWVRWvwIvYsfSiZU1KmCZqaknu1xaACYTjrcEdRv8rw10WYAEHUNgeKwvWUHtaqnaW8QQ+2FgPpUvBEjDPw/hWkHQVO41oh6BgbYdwzMus1JJ+K8R+tVVmiv2L003XaWJp1HfR5DjikHo5k6/S0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(20046099003)(921020)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0V5QUxRSC9lOG5YOG41TElRc3pEQTJoZ2pORkpkMEkyTGZFdW5yM1ptOExk?=
 =?utf-8?B?NWdDV3Q2MUJTbDNoQnRDYUFub1l0QldqMjgxQnZnMms3RWFYclhldUhpbVJy?=
 =?utf-8?B?K01acEJJaXUreEhyUEVCNVJTTGt4OElGUkJvTTdPSDNhU3Q5aS84aXN6MEhP?=
 =?utf-8?B?OHRkTHFHQXE0L0JDTnI0NlUvc0ZXalhZMDJYOHc3WWxZK1Bzc0Z4My9jSm5J?=
 =?utf-8?B?UDUvK2N1Y2syeEJGVmdnTGpWMmw0MERnYkhSazBPOEJmRU5jVllCU21DeUsy?=
 =?utf-8?B?VmtyTkpwOXhnZlVXbHJqMS9pbFJFTzdqZkl3L3luTmkyM0Y0U1VUWDZVbmlj?=
 =?utf-8?B?QWxhMUZ2NXd4U2phTkt4bk40ZkVFemxCeEpXWGpFQnZyV1dydWdEN2Z2bHhn?=
 =?utf-8?B?a09IaFcrN0pMUktRMEJPVVBWem5ueWp2NUpnRktkOHUwVEJFVXRJeVlqQXY5?=
 =?utf-8?B?M1gvUWhRME5jYkd1UVJqVVRqUzArZVEvNk5Ga3NCaWRmQmo0eUZCRm95SlFY?=
 =?utf-8?B?S3FmQm9DUllsQWxkZXFMODVUR1NEeHJDUUI2dHEwYzIzd1kwdDUrS2k2bzJU?=
 =?utf-8?B?NkpmZkgyeVB2SmduMW1CWmIwazV1clg4US8xZGNleTZheDJsd256MWh1QTMx?=
 =?utf-8?B?TStFc0hzbHVQaXk3OWlQbG1Bd3pKbDh6WmtETWlNUWVZUDZJL3hubGNtZWFz?=
 =?utf-8?B?Q1pFSTg4Smwxb2dMSG1DSTNkUkNjZkljTmh2Q1VCdmRHVmd5dDNRdFZKZ0lU?=
 =?utf-8?B?STlacGw1UXk1REhlNlB3SkNUL0ZlL1psQTJ4czkwZk1ycFArTTBvd0psRUFR?=
 =?utf-8?B?OFdNU1hYRUIxYnNPak55V1VpdkJQeW9GYTVpZENYMzhhOTB2ck5Db2RxUkVk?=
 =?utf-8?B?RllpMGllNXgwQ1c2ZVJzbGhsdUNFMUU2UGFsN1hoVXZDb21FYVRsQnlQellr?=
 =?utf-8?B?dTdpbGdST3RNUjVCdEhJM3BxZjRiSDJEMlFybnJEcTRMMkczSUFCTkU2V0ZH?=
 =?utf-8?B?bTBaRnM2akNacXY3S1ViaWxSMUJFZEFLZ3NsNnM5WEFrejZ5Q2E4ZHRKUUIy?=
 =?utf-8?B?amhRUmxTaXZYc0orLzIvdEtTRk1GUDlodWJFZEpSVGtVb2dDQVVVRkRTb2J1?=
 =?utf-8?B?QjFURDJTSnZhVnNSUWIyc0lFUlZlWm9qUVRpd2czWFB2L2ZlWUxiVWtxeUJL?=
 =?utf-8?B?ZXY3L2RneUh6OGl3TnI4Snc3Ti9QZUw4UjFBQjVZZC9vaUlVOXkxQlAvTkxY?=
 =?utf-8?B?am9UYXNEVU5ySWwyRThsS1M4RmxyZUgvZG5pSkswRWx5bU5oVHFaM2pIR1JU?=
 =?utf-8?B?aTlnb1Axb002RDJHblBRYjlvSldieUdOSlRVbWFSUkhmbnJmRkVPeFZQNEc1?=
 =?utf-8?B?MzkyUnFEdE4yWkNrNWJHK2pIOHhwWEdzb2hyS2JSTVUrcnRwWm1Mak5ybkY0?=
 =?utf-8?B?RGZoT0M1U0tnbTlzSFVPWDRyNHhWNTMvb09vRDlad3NmYlZMa0tXeStOWDN2?=
 =?utf-8?B?azlEZTg4eVdOTkltWCswRHQxZFVaSFg3MW8yb3h1OFhRcDRxSUJSdEtFdWFx?=
 =?utf-8?B?b25FbTZEeVdqM043QlpJZHRLaENpZ1B4YWtWNTd5Vm5IVmZPak52Z2d2N1d3?=
 =?utf-8?B?UzFnM0IxQTRqVWptVit6R1hxTktXWGdjZFBJMTVCM1ozV0hiTEw5WmE2RlhG?=
 =?utf-8?B?TytHRzNJeUcxWVlsYTdqUTJhYVVWVXRQUjFObHVZWmJOVnhzRHQ1eTQybE9W?=
 =?utf-8?B?bEI4OWNHMWZCcFEzWmsyUklObDZoT1R1dS9DYnVhVVFzVDRxRjVqVHJsMlhu?=
 =?utf-8?B?Vi9PL2hEbjRBWVkzWWp3cks0U1Q3ZHRoMmtNa0tFTjBpRWlxYk04QzdUQ2lx?=
 =?utf-8?B?R1ByQTVJR1kyZnh5VFVwazhxUHFPZENSTEhQcFh1dTFxZEd1QmlOQThaSisw?=
 =?utf-8?B?MHlKeFh4VXBMOEJjeDVSalhZa2t3Z0FVK01kanNEdjVPL0tGeTV6UWJuOC84?=
 =?utf-8?B?UDVoRTJoQ0loMXFmdnIxMlRSM0s0SHBNYVIvWSs0dSt0SkRYZFFyM1Y0ODV4?=
 =?utf-8?B?QTkrZFlwZm9RYkFwY3dqMGRRenk1aUIySjNqMC9CK0RCZktLZmdCNHRZS1l2?=
 =?utf-8?B?NXlZRDN2U2M5OWp0Qk42UnREWFJhS1V5THQ0V1NKYjY5SUZnM2htbE9WcHZ6?=
 =?utf-8?B?Sm5qQ1VpM1NaOXVsRk1HK21FSVN6dExQMGtTeDVUMlI4MFNHaU1QbDUzR0xN?=
 =?utf-8?B?aW42bGw5aUFZU2VBRTFjU2IwRFNHajRhT2JpL1ZURU82QWxGSURMT2NCZk9p?=
 =?utf-8?Q?75VG+NLu0a5eJrb+cd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91863ed1-03bc-45a3-8651-08dec0b6cbfe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 14:54:07.4609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GjFLuPShazjgHDwxqfVA98oY2yxS7cjMyI4M4c3RaXEl18cskkWzEol637ewqPhFvVN4ny8PZK+5TbEXbx8dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4165

On 6/1/26 18:04, Atish Patra wrote:
> From: Atish Patra <atishp@meta.com>
> 
> allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
> is left pointing at the leaked memory in case of any failures during the
> function..
> 
> Fix by adding an error path that frees the pages and clears
> sev_init_ex_buffer. Make sure we only free the memory if the failure
> happens before the conversion. Otherwise, we may end up trying to free
> up converted pages in case of reclaim failure. rmp_mark_pages_firmware
> failures should be rare enough to avoid more code complexity to track
> down which pages were reclaimed/leaked vs which are not.
> 
> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Atish Patra <atishp@meta.com>

Not sure the goto's are the best, but they do the job - just a personal
preference for me here.

The new comment below is a bit verbose, I would think it is sufficient to
just say something like "Pages can be in an inconsistent state, don't
release them back to the system" or such.

It might be nice in the future if we can identify if the reclaim was
successful and use that for determining whether the pages are safe to
freed... but the failure chance should be practically zero, so I'm not
sure it is worth it.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3d4793e8e34b..8566f164430b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1550,7 +1550,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>  
>  	rc = sev_read_init_ex_file();
>  	if (rc)
> -		return rc;
> +		goto err_free;
>  
>  	/* If SEV-SNP is initialized, transition to firmware page. */
>  	if (sev->snp_initialized) {
> @@ -1559,11 +1559,23 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>  		npages = 1UL << get_order(NV_LENGTH);
>  		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
>  			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
> -			return -ENOMEM;
> +			rc = -ENOMEM;
> +			/*
> +			 * Don't free on conversion failure: the rollback may
> +			 * have left pages firmware-owned, and a high-order
> +			 * block can't be partially freed.
> +			 */
> +			goto err_reset;
>  		}
>  	}
>  
>  	return 0;
> +
> +err_free:
> +	__free_pages(page, get_order(NV_LENGTH));
> +err_reset:
> +	sev_init_ex_buffer = NULL;
> +	return rc;
>  }
>  
>  static int __sev_platform_init_locked(int *error)
> 

