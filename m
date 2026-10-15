Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0CC3A9619;
	Thu, 15 Oct 2026 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086808; cv=fail; b=RXaiBqfykMa/u/CSzjfDyHwqTxPezyZWBwkzF0EchRZ8kqybHix8ouhxmBEBRlnFsV1a8oZiPB6WbL9+1HQ6egtxbS3/a2wHYG5yx3HPmO+JeAKNjW+u9utLBC/p9KQ4VYz8DiIIacG3XB3uBXEkl/67BoLHFEUreSnz/53BvZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086808; c=relaxed/simple;
	bh=ZUL57uXVJkWb/oUDbVH91rRVHij4PfUQa6GGlDfP7SU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OhVbbsiauYRGuXrDcJ+bmZKuIo/DNkcVYNbUR2cBfgkrdghT5aDWZadu4rpdcrPn0jqYLRww7gFfvMOlFZlX5GF4TyT5ZktbeBOYsAwpZGuXMEIF8Swef19x5SYW1KjyWZUbwZDhcnO5ONrFYkUOkxZAjgUNDZJDI2sU7h+JI4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WqU1l4v0; arc=fail smtp.client-ip=52.101.57.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WqU1l4v0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJv4XnYZu4gYHE63WQTHmZxpIsgHjZYzYvGPMO4SZ6gNPq6l/amSXRW1L0Hi//6g6d9mq2Ror/ONNgcoH5MnMUSTa3/fZK+ksp142j8Y86BN4rH2gALZuQaSk5oYru1iPZKhaTwnV6TjC7dAEqem2i5akDNVYnB1TVFaBc+TKDrv8k5s98xA7+NpCmkyJ8qUNS3dhqRpcf5Mbx7DP95FXpTi79rVTvDBQgh9+GKpiSOU39wNZ+RhtZWxdNsV1u81fWYTDMnsNlAB0wOFDuQ+aJxPyOOBRubgbblK2m+72S085XAsmdTmXWVk4hoddjVWVBraK8BX5UisE7XQ8hBNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPBq+ZnUwAyW4uWHn60qsP3PT5rba+OAdxQNFIRZJCs=;
 b=RxYgC0mDKPJLq0L4P2iokxcODa31Wgjb3NoIewP+5MgTlo1PAjTgCV/GcXU6Sc7eGTVRAvbuQhSVFqRAmo/+DSa1FOFrDabkdD6mTZxE7cHSFj5ezMFqAUB4XtQnsAqjWiNw5lVhJ2Tc9s3pafX5+G5AcdgliUACKs6MwY4RvTfMVe1XNgCsABCx8gW7vNMhr3loVkKKTlc71/zfajVDnhfCG0K/I3e33MAP2s7CpdKC7e/ALgdStjy/xeki2aZ0XwWDM63cakavqtjm+2PFRkVV1L0An+kMdpDsLwAQXIpYokxRUKFfVsXH1wQZr5Wt5o7vGTQDsY+U8hHAeGCp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPBq+ZnUwAyW4uWHn60qsP3PT5rba+OAdxQNFIRZJCs=;
 b=WqU1l4v0/V+Ww3J75YrpYx/hjrTO9AutTFApg8T1Ja3NveW6oSdrTmk5wzqzMz76yTs6V9WrmCuAG0NMqMWPQWCETaQM7tLieoDmpciRyZnIYP5MoYZYYiupwv/y6E85gVa9AM9En99cKkZyEG851wCLxn0JpBfVqd7LGzmbpP0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by MN0PR12MB5860.namprd12.prod.outlook.com (2603:10b6:208:37b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 17:53:17 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 17:53:16 +0000
Message-ID: <e409b256-4df6-4d16-bdb0-e9a4479912cf@amd.com>
Date: Thu, 15 Oct 2026 12:53:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 4/7] crypto: ccp - Factor out the release of the SEV
 firmware buffers
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1792014060.git.prsampat@amd.com>
 <d7eb100a9d91641e24f3a03a01f746d20204983f.1792014060.git.prsampat@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <d7eb100a9d91641e24f3a03a01f746d20204983f.1792014060.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:610:e5::6) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|MN0PR12MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: cb953ce9-76fb-453a-0ccb-08df2ae530fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|6133799003|10067099003|18002099003|22082099003|4143699003|11063799006|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xgphAor/+Z8N/cpOvUsKXVzm7tuLY5FCKSQPCx24Mpv/+mFKyz5gdAT0zKp8ROnNr44SrQF57E+sKmUfwDDfAva8SwdqUohMZgXnlso1JBua117v55FOdOpmcWqtycYYLiUSAjbFSE/+6IpmCG3kBVm1tYU25V14vLqAENi2TK0RWXM254nNSP0eQzilwfHifivfLZdKzcDxxPPqccmUMNexb9qUMHShDn5XkPngi+uyUFyTbm+DtI4cNUw3ZWDVyaHgh4YOS+3YVD5jP0HaNP5wR5zv9MmqoRH8XCopBjddT2Ztot7zvl19U+quFjziy/M/CI5ncKMg/UkGq4tfqJXP6MlTRDBZZc2Ep1FIRlOXTSxikv/o/1vpHuzZNaLUl76X9L7lOsk06oAZZsHWkLXvaDST1CAxLiOdV2LINsorcPQ/akZVp3ZKfEDctPZyttAOoxAOe1jo6SE1TS4VehRkp4j+nfVcYkSn8DPUFd3c3PYmpEdoryFYLc55f+bM+RbR2yGR9SDdJLWRmfL+cluDrH0mwrAV0bj5oVKz67AHotoO7ftwAEYk/RGBQlwrbNTf+J607I0au2iKayNXFP8bXdNUd66fVKp82dsJ6gVFUqP2OVofn0Y9k1Ram7a1BpHq5oMdirSWqbwKHOcLVLPnmzQS1Qm0XQe3EI3T7pQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(6133799003)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnYvdTA0azRsT1hESDNkaUd2VGVpNTBVbnhCRk5CbjZ2WFI4N0x4bTB6cG5N?=
 =?utf-8?B?TXZuRUVjbGQ1cGpCZ2N5RGRyQVRJdkwrd0h3V1ZwSHIrdzc3VGs0VUhrWUZi?=
 =?utf-8?B?dUFUN21Xb2psSXh6bE50ZjVnZjJJRTEwdzNmcDRCWldBSXd6ZTBFNHNQdnAr?=
 =?utf-8?B?OFd2VUFMVEtOTzQ2dTQxVTRraFRjVEhiMzRSaTI4TmJsWHg5M2NYa2tleUZo?=
 =?utf-8?B?dFBSOElsRkQwMU45VkNqdGVOVmU1U2l3NmdGY0NRNWN3QWozVVFpeWhISXYr?=
 =?utf-8?B?cTNEcnp2VzZ5SmgrRitpbFRURVluUlJJSG5QTWFoMXpGNGJ5VGFNSW5tQXZS?=
 =?utf-8?B?dTZ5Z2lXUCtoTURBRDl5WFBoc28vWC9hYXBQb0JKSlNKVHU0NE5kUEFQUnM5?=
 =?utf-8?B?ZmFORkFFdnhEcDZuL2E3U0Z1aDFGeXNjVllCYStIWEt2T05pbzBXSWprZjNj?=
 =?utf-8?B?Z2UxM3ViOEhqQVh4RG1tbGIwU0NjUUtwazduV2wyWjdvNVBEM1lLMnd5N2Nh?=
 =?utf-8?B?R1phKzFlUGdVdlBUcEoxWm5Ec0FOeDFDeit6SDc0NTlYbFdTaWwzS3NROVlL?=
 =?utf-8?B?YTQ3bm9zOVpLRmZDRDRqWnp1em9lMlljNWxuRjBFay9Rd3ZFTE9iU3U3dXNy?=
 =?utf-8?B?eWJZRjZCUzJaSGhiSm04c1FHaFFHS1BxdXh1UTFaVGN4MjJGU0dlMit4akhL?=
 =?utf-8?B?eldvY2doR01od0Z3U21ocFF3RkJlUWdWRFkxdy9LMmhWRWZBZGErQnZNbTJK?=
 =?utf-8?B?bXIybmwvQnd2RXhnMkdzMjgvdll4ZnYrQitRbEJIOVdxSnMxb0ludVpZTEtt?=
 =?utf-8?B?d2lZUnY4VzNCYzh4Zzc5VmZ2NkUwbzJJSmFwdlBmZmIzSFB2NXVWb2JUd3Vv?=
 =?utf-8?B?THBUSHFtWkhwRVBzWHpOUkJudlJWOWxHUG00a2JpbGdMRFI4bVhUUE9vWjdW?=
 =?utf-8?B?RGltQWszUE1uZldRUW0vRmxJZWw0RDFhWXh4dG1zZWl1cU5hVDVuRXlab0hM?=
 =?utf-8?B?NnRsRzlkMlBKVExiekl3T1VObnZGUHJNTXk0S25GZlJlTVlCWHF5RUFQNDJQ?=
 =?utf-8?B?UmtMUmFqK2d5ZWFnbDNDamdib0xSMzRQM1o5Uit0UzlySzJqbDF0Um9PQll4?=
 =?utf-8?B?KzBTSThzeXhleWxjeFA5Mm5zUXhrR1hmZ0E4aEJtVFVnRkVtdC9ZcnZaYXpa?=
 =?utf-8?B?YVJlaFAxb0djY2pwTjJSS0FHeHZWRHF1QnNlTFVFSm93SkU1UFFFVDVIYXRV?=
 =?utf-8?B?aFZvamZNMS9zQ3J4MUdZbUZYQzBsemd5Rzl3aXhJbXB1ZjIxdEhVUnplcEpZ?=
 =?utf-8?B?SFBYYmJuQjgvZ0pRQmFWYTF2bmh6SVlBY1hOL0puUjZvNWVBVElac01odzNM?=
 =?utf-8?B?dG43djdXOE1ONWZ2NnVrYWtlYlNPYXFGb0RmZzdHWFhlelFKbjVsdHg5NDFS?=
 =?utf-8?B?M21aRnR4TUZzc2lqTnBiYnNycnNqYU1LcG1SS0Z5TDBEbFJrUk9aZkFJYUMy?=
 =?utf-8?B?cjh2dWpQQkVWQ0E3b1lJTW4xbGVpMXdkNHdMZ0s1WHZPNGRvSjVDc2UvMVQ1?=
 =?utf-8?B?cHF4RDFYSGVvNmpIaGZpbjRKR1ZXVTN1bVdKOGVldExkYXZTdkdaUE8xTzQz?=
 =?utf-8?B?YVI4UllpbmFXNWlmay9qWlBhTW9tSUtpSjIxRDZlVHpFTXhkMk5RM1NqWndp?=
 =?utf-8?B?Y2h0S0Z3UkhXMUphcUY1VjNxeWZGSUFvUDZOL1UvU2FYQ043U1ROWGFCWXVk?=
 =?utf-8?B?bVg2WVV2bFFKT0liNUptVURDbHBwa1JmU2NMTWtYNDI2K0dHL3d6UEVQRTJk?=
 =?utf-8?B?bHEvYTQrYm5ySmNhMDVHUkJCTGViNTA3Q09JVm5yOE9keiszM0JvM21ySlpT?=
 =?utf-8?B?SEJHdGpGVnBtNzZWckVybnNmbGl4QXV4L29nMExYd2djaGgvRVJZMy9MQldw?=
 =?utf-8?B?RDRaZjhuQkIyblA2UTR5QXVpZWpDcmF2VTBnZ3FDK21tR003QjhCNXphM09T?=
 =?utf-8?B?VU9Dem10RnN2b0NYSGcrdXd6b1luLzhXY3R2ZmYzcGl0azRBSTlGWnMvWDV0?=
 =?utf-8?B?UUxvcHJoU1Fkc3lKTCtnNm1weXlCNU5BbEphSHV3dCtWSmZ0dkQ0MHRwQ3ky?=
 =?utf-8?B?WG41ckVYYWNuQXQrRnBTcEEvTFBHWHNOQytmdEJYZVlGYmorZHlkZjdMMVJz?=
 =?utf-8?B?N3ZZODZkQ2NPdGpheE9yYU8velVvRTMwcjV4b01kbEduaEY4cW9tWEprMy9m?=
 =?utf-8?B?WGFKYXBDRTFtQVpGSmRJdnBUbkFKL3RPdVVKR01hUC90WUJSMFV1NmxLdUha?=
 =?utf-8?Q?RX+u1emruww2HuGGaP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb953ce9-76fb-453a-0ccb-08df2ae530fa
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 17:53:16.9146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxtRrWZsW6P3tcxe666JtgQiO97Dpzdxgtagg5dBNqRoQpgQdGhWk0+p5EVQQVis0wuUIRZ8ZxfpS//nWMbwlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5860

On 10/14/26 21:14, Pratik R. Sampat wrote:
> __sev_firmware_shutdown() reclaims and frees the TMR and the INIT_EX NV
> area once the platform has been taken down. Move that into a helper so
> that other paths which de-initialize the platform can reuse the same
> path.
> 
> No functional change intended.
> 
> Suggested-by: Shantanu Sinha <shansinha@google.com>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v3..v4:
> No change
> ---
>  drivers/crypto/ccp/sev-dev.c | 55 ++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f833cb7e4da3..1ed9e61a95cc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1881,6 +1881,35 @@ static int __sev_platform_shutdown_locked(int *error)
>  	return ret;
>  }
>  
> +static void __sev_release_firmware_buffers(bool panic)
> +{
> +	if (sev_es_tmr) {
> +		/*
> +		 * The TMR area was encrypted, flush it from the cache.
> +		 *
> +		 * If invoked during panic handling, local interrupts are
> +		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
> +		 * can't be used. In that case, wbinvd() is done on remote CPUs
> +		 * via the NMI callback, and done for this CPU later during
> +		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
> +		 */
> +		if (!panic)
> +			wbinvd_on_all_cpus();
> +
> +		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +					  get_order(sev_es_tmr_size),
> +					  true);
> +		sev_es_tmr = NULL;
> +	}
> +
> +	if (sev_init_ex_buffer) {
> +		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
> +					  get_order(NV_LENGTH),
> +					  true);
> +		sev_init_ex_buffer = NULL;
> +	}
> +}
> +
>  static int sev_get_platform_state(int *state, int *error)
>  {
>  	struct sev_user_data_status data;
> @@ -2906,31 +2935,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  
>  	__sev_platform_shutdown_locked(&error);
>  
> -	if (sev_es_tmr) {
> -		/*
> -		 * The TMR area was encrypted, flush it from the cache.
> -		 *
> -		 * If invoked during panic handling, local interrupts are
> -		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
> -		 * can't be used. In that case, wbinvd() is done on remote CPUs
> -		 * via the NMI callback, and done for this CPU later during
> -		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
> -		 */
> -		if (!panic)
> -			wbinvd_on_all_cpus();
> -
> -		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> -					  get_order(sev_es_tmr_size),
> -					  true);
> -		sev_es_tmr = NULL;
> -	}
> -
> -	if (sev_init_ex_buffer) {
> -		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
> -					  get_order(NV_LENGTH),
> -					  true);
> -		sev_init_ex_buffer = NULL;
> -	}
> +	__sev_release_firmware_buffers(panic);
>  
>  	__sev_snp_shutdown_locked(&error, panic);
>  }

