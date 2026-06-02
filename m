Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011045.outbound.protection.outlook.com [52.101.52.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AECC3ED125;
	Tue,  2 Jun 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780411423; cv=fail; b=sfJDs1kC9dSCGL+Y25xRQhoNo6ZjMk84WW3arqPQ2XR+vgF6mX3l3uE1GwtXqfELRIHWdzseSt2NsSdHg1aNdnZalJGtQEBoW7xbZ7SNGz+JWKRanXfjB0ryBDgTHAqvkr1t2LFhdfWc6pZJFaLwXoxXdQeuEnsDL/BszdoiI/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780411423; c=relaxed/simple;
	bh=PF/jik1N9zEMFnpeIi7191p9WPAqLy+TqIYaJNzlTKE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tOn9RhBxFkQ3I2uanO9qWgpvD8JV+5h7ueJJaYRT+5SfVJS3fx+ZXrwNj/HW3ArQoKzuTanDHV9k/Fr++6mzlJRjrzGC3HV1s3PTv+20rn/a7BRoq3P+YxiCMaCgQAI3mef17vHviqSBlhNNZ+NpePTuH8JMV4fUZRamrVEvbFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1xYtRCcZ; arc=fail smtp.client-ip=52.101.52.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1xYtRCcZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RywJvLAS0S5iEk9HHsby4eL+cIhogD/O276rrGexxraYLvmcJdTvuW999I8SV1kAFL3gJiEShx5S5KWadX6MXTRKfrQZDKrzC3pfNA3qznmEzpYp7Ti7UTr5jXgh+MsiwtmAoETyFRKLp2N9cvYzi9wKtYa5SrEIER2sPNOhvMJVku7DWrXoZ6aniQma+e59exw+g0kHZcMCDoiJasr6eYvMqfEYSRXCVHf+25QodrqwO2/7PPVGtEQHT48b+iE5qZimB8Quc/93zklFS+cA2T+Jt2P4GY2eFsVHr/jd5aHQ7CcRapX8hFnaGXrlFAOOQly6GLMxxtTLYbipz9oNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/PrYMJEdodYvJ/W5v2U8+GjwXnlVbzUJyX7wUt24VE=;
 b=UNrpOiBlmt0VndgcjyFLsNYqn9x9vH3R2zR6IBCpF+av0BwBSnCaADek0S5r/10RMoD5M6L2EFmeSoQ7FxgkhLQtAtJVOm8RgkLhJBdDkzrxW3bgUsci9RitiqyJvNSfk4ns7Vl+7Q/gko12k9d7kfF9DWIZyKU50ZBzbR3eTXzYRvNRhFBfIsvYSjbEsO6DUA48DIJUvxNJdKqpc6VIK9mKtchTIefBahVMHqrkY7s5eRxreJ7ADYZyyMR+nbatalqBQ/YhG8oETdBwnWH2AGfGl4WCErnyIFVlEhLpMRJik91O8j1siFsjP3pJnnRlK2M78sNh95cMdgqSVMJAlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/PrYMJEdodYvJ/W5v2U8+GjwXnlVbzUJyX7wUt24VE=;
 b=1xYtRCcZswIUhQoKpTALFS6851/JImMbgsYtxBrDzl6gGb+p74jhfx25HfMISo91xyOO/To578H807RjOJhNOdDzE0HcdmmTbJa/OLs4G2rOtfwht3RNzmkkC15734kDXyYXYkTTdFjGzg9CWPq7IaCoFgMaWj7lQfkpYHqeHMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB9472.namprd12.prod.outlook.com (2603:10b6:806:45b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 14:43:38 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%6]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 14:43:38 +0000
Message-ID: <379e45d2-1765-4043-8ad0-ce013da8683f@amd.com>
Date: Tue, 2 Jun 2026 09:43:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] crypto: ccp: Fix possible deadlock in SEV init
 failure path
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
 Atish Patra <atishp@meta.com>
References: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
 <20260601-sev_snp_fixes-v2-3-611891b28a86@meta.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260601-sev_snp_fixes-v2-3-611891b28a86@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0102.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:25d::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB9472:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e999867-bb09-4421-0a65-08dec0b55496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|921020|5023799004|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	3VveaTEeGqopM3OX8A6PzFjl90IUh7U+gkbVI7HqiUmyJlkmHYAbLcm2Cd6ZwWMM5rKpx2SOJ7K2lALVR0mJv22sK7nLa2h0rCH4vByLO5RBphqjqFal7IzczNnwWdP73jnNffsXYJQcWrXjVHnYc8TdOYh+bZqq3X4sAIB2g3sKKF4LPL1FqShn2FbC3x2JrxLpgtMCBnxbpluDN8ilULZWQBhjnb9D0cn4cnLWXcgmSWRl3ByBksWEVGnZOgYBw+0sHfQjtnHmhcUV9mkYrIf4dgZlWdIByWqgum3DECAt6nCbKa/GG0B1EzXJauy4ciANyFXP5p3K/AI8xFQOPvXg6ZTIxdWJsjejymKeGIH0FxyZnlp5486p5i8eTGEBy1cZdZYLuI4NvVI8YswHxar9jtAbR7RdKqBH2XCLXKjW6sCZChr8155RCHTtBn2DQ/ijZkAzSxWBn07RTfy/X0moTNQbTLKqdHMyvJUMuBvFZEp2m8EIXS4tFpEXU6TpTikwUSGv+a/jVZGT+e6dSUi2makL9gUvJweEqBj5eNyd8sDYoau7TxYcpvH4nY5tAnDAIy1bSE5buYOjBfoQ6dsJnbiFa7cAlkIs95c0SYA0noku/9x3gylRcTDELPskpCPW+mBvvhkKGDorfn1j1xH/f6gl2TcBc6okb4XONB8HhYjKSEMa5Ngp4mJx9g5o5B5bjJOLffUgTe/y26pfZ56YTpYgzrxEcrCvKDsl5ZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(921020)(5023799004)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE5LcjZ1blpETmp3aFNjRWdYbFFIN3FKOS8ycGJzTVhpbnF0eURHQ2MzWWJ0?=
 =?utf-8?B?VTdGblhWR1ZLN3hSZTU0L2tVRmJMMjJORFRrcXoxaFFNZGsrVEl1Y3E2c0Zo?=
 =?utf-8?B?c3pWa1lWbzFObGUwZ0VSTWtIUWJ4U1BUYncvRlE0ZGw2djNFN3J0cjE3bDBS?=
 =?utf-8?B?WVNjbzJTWldqakZsVzgzS2NNaTFpeEttaHVSVU5Eb3E1THNJak5hMitOWUN1?=
 =?utf-8?B?ZzdkbFh1VEJDcTAvbXc2UGMyYis1VDJ6MlZvSE5MbFBZMFF2VWx6VVArVmRP?=
 =?utf-8?B?OWwwVCtORm4xRXcraWNDbWhZVjF5MWdpak1GUStjUC9jUWI2YlRwaDZGSEZx?=
 =?utf-8?B?ZmVwbU5ucVY3dlhKU2lDUmxHbHpld1A4SnMrSmxqMVhUU0pIVldWUFBhVkR6?=
 =?utf-8?B?b1JVM3ZJZjBBSGc4Q1N2d2RvaEh1Y2pJZThCaGdkTmY2ejdFTWtISkZxd1Ny?=
 =?utf-8?B?T3JiQlRrdkpYeitMNmcwRklOb3BzdUN5TVh4blpDenNYYUVjbXVOVFNud2Ro?=
 =?utf-8?B?ZkNvRmFhSGJtckZwL2w2OWF4UDZLdTJMQTdoOEJvVkUxQ0lMdTRJeGd4cXRX?=
 =?utf-8?B?NkVIYlNmcmxBK3UvYjNoNzVYYWZWMENwRGEvSTR6OGVXRm5DK0pPTm4zc1cv?=
 =?utf-8?B?RWltbkxBVXhFMEEydWY5OUlqbmFXNENWcVVpVHZWbWhGTzFsMmtrdDdiMC9W?=
 =?utf-8?B?NkM5QVcvTWhEUVlKdG56Y2lNdFlVRU01eEF0djluOVBsTXFWcTBGOHhtOWhK?=
 =?utf-8?B?a0U2WStnandnRGZXdURHZ3YwZEtVNW9VY2xDL2xRcWpvcU1HeGkyT2x4eTRw?=
 =?utf-8?B?ai81K0F1ZGpmS1pscVRqRFRSNlNvY2VIMU5YV1VybFNEbHN0MkZGUzRtcVNB?=
 =?utf-8?B?WGFFSzd4ZUxCUEdVZUptTGUzSWwrK3E0Qko1YUlIcXIxVFFleDlsNmIwcCtw?=
 =?utf-8?B?b3huSFRhL1hMQThoN1R5OUprNy9lUm8vRnEwSXZNRzhMQkJnMmdtWTBaTE1v?=
 =?utf-8?B?TjlWdWFjbjRvdTdPMUE0R01OanJWK0sveXdnTnBpY3E3Mlg3UEdiV09tTytN?=
 =?utf-8?B?a0dDUHd3akVhc25veWtCU0JLcXh6b2hrYnkxTXlUZFltaDQvN0I4YTlaNzhN?=
 =?utf-8?B?VUtKZ2dXcGpzVGd5azdyeHRDNXpCMFplRnJHOFVwYmxSektINGRBUVArS2Vj?=
 =?utf-8?B?ZVhjNkVkVkxGWXRscENYSlNoTEUrY2JQNDFNMnBMR241UE5SY0thdzkwNWpM?=
 =?utf-8?B?dnVvZ3liNnVNQ3RVOUd6TGhQOWJvcFZpK0tMNEk4Q2ZDdDZGUHhuM2ZzOUw1?=
 =?utf-8?B?OFFjTFRJYWpVNjF6Wkx2VWlSQkphaE1nQUg4WXBWcVdkL3c4MDJLWTQrU29u?=
 =?utf-8?B?cEl6bE9nTFpYK0gzZnE3T0dXRW9nN2psSnQ4UkZPR1VxRlRQR1I3c1RLQmh3?=
 =?utf-8?B?ZlAyZVBKdk9YczY0S0Qvbm9oU3VsWUcxRkJSSjhQalEwcUFraGxteEd0aWhT?=
 =?utf-8?B?ckY0V3h5bm1SOENDSStxcXN3bG1HTFFiUjFRS1czZ2pyUldKTElkbTFYZHA0?=
 =?utf-8?B?RW9NcE53UVUxdXNiU2hXTmFKbEszRXJiTzlZS1IraDJhYmFTajhnZmNpQ3gy?=
 =?utf-8?B?c1pEeFJGK09WREE2cVZsV1VjYWVvbERCd08vaFdQTVVweFVvOUM2aldXUXNp?=
 =?utf-8?B?RlJGUnVDK09HMytpRy95YmpWK0gyYWlBWnFjQ2h3MWRmZ2dtaG9HSFVUTVdN?=
 =?utf-8?B?UkpGQ0R6Zk1ad0czS2w3NkVmZUplMUtISjhuQnFudHdJbXl4SWdrRzhjT2N2?=
 =?utf-8?B?YVpVVUlXdVBSWTB5Q3lJeExiY2hHM2dBd3o4SlZFdXBUUWZ3YmZtdEQ2Ky9G?=
 =?utf-8?B?MHdlbGFibUVnTHNqYTRIUjFzcjlKVDMxeW5mbDllN3J1WTRuSnUrKy9iL0d1?=
 =?utf-8?B?c0RuSThJMXhVTmtWMCs4UnRJU3dNWEtYOGFxdHcxTUFCVjBkYUtsL2xIZEMr?=
 =?utf-8?B?V3lCY0VDdGdSRUdkcGRzVENWc3FuekxkK0U4MWI2ZkFlZDVZdko3bUtveWtu?=
 =?utf-8?B?RnVqZEVoWkNZdmJ6bzJDRnloMG5meS9ReVZXNDZCU1lrdVRCMlhxOCtNMjkw?=
 =?utf-8?B?MXRuNHErT2sxWDV4RitqZWVpS0x3SVltYnNYYmVNTnkyV1UvOWZWUEtHWldr?=
 =?utf-8?B?U3FYWU1wUTlGdFJ4U0M5OGtZZ1M4L3FPTlJ1amNXcUIwU0Jub2NROFZWNTV3?=
 =?utf-8?B?YVZITkYvWTJLY2RCb0tzQ1BaZWtUcUFQbHV3aWVrWGF3STA1eW1vUHQ5M2xF?=
 =?utf-8?Q?X1db9N54y/TfwE+/qG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e999867-bb09-4421-0a65-08dec0b55496
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 14:43:38.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TZXIif0ZCGkM5tVPBUMfJjaUP7OjNzJ8HaGUdWsnIhEYSGeAahdLwK09sl8dVX/v+NXxadp6nuZgCUXecy/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9472

On 6/1/26 18:04, Atish Patra wrote:
> From: Atish Patra <atishp@meta.com>
> 
> __sev_platform_init_handle_init_ex_path() called

s/called/calls/

> rmp_mark_pages_firmware() with locked=false but while the parent

s/but//

> function of init_ex_path already acquired the sev_cmd_mutex.
> In case of a rmpupdate failure for any page after the first, the cleanup

s/In case/In the case/
s/a rmpupdate/an RMPUPDATE/

> path would invoke reclaim pages which would result in a deadlock in
> sev_do_cmd.
> 
> Pass locked=true to honor the lock status of the parent function.
> 
> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> 
> Reported-by: Chris Mason <clm@meta.com>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Atish Patra <atishp@meta.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d1e9e0ac63b6..3d4793e8e34b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1557,7 +1557,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>  		unsigned long npages;
>  
>  		npages = 1UL << get_order(NV_LENGTH);
> -		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
> +		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
>  			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
>  			return -ENOMEM;
>  		}
> 

