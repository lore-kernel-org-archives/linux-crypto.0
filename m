Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011008.outbound.protection.outlook.com [52.101.62.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBB9339853;
	Tue,  6 Oct 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791297951; cv=fail; b=ZY6SsvCo3ehayPCKTOX41bTbKI/c5OxgDUPKMCrZweOFQTvPLUgFxtZd/AxKXBC0b7QDFVJbucSdz4bFMTWKeHLEAnzA5PIDW3qE503lDt2y0NrZpiG3sRUHFZ4WBjNlQFx03akEpfjZvnhhkP6dMApISCXx02NCkkbdpqJoQt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791297951; c=relaxed/simple;
	bh=99Ju3fXVXpeYlsUikz0WtbQqP0W+MOMC1YUL5i9KSOI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HAaffN8A3oK9XD6/oYQ94IQb7PBZWbTGb6wCW9cnGcq8OhQ1B6XLq+q50+HyvTBbFFCCxplZjXCBrP/W53wUQkLVpfsymj+N299DcQ/klelop5ORp6j8fz2CNmBVc1b4uPO6l53tO5QDBAFAARty8BGo7ac0eyrCCYo5zMIuhec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g2yUBcCs; arc=fail smtp.client-ip=52.101.62.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g2yUBcCs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOZmH+S3k0amrKOIyhXU81Vo9eA941Qgklmk6MxnoQg9o0qFQotKdC6eiDsJ1yWE5R28sZoUeec7uMDcF9dpz31dJb6nl+nUR/bBbo248EKY95C8Go5nRPsqGou4O/5fo6SyN5bV5QgdX8lRdPS0i6EUz2HTmVmFQbLwFt0EF8O1Y2YHxYqUqGwIHPwZl+wFM2eed3T6jSDAsCVVrdDqEdZsA9g6F4Q7epJcuNlI58ESoo2H3z6MHVrYDKqYSwcPZLKgBEmq8/0/FIDwbFh/OADFGHROrslWZh1qKJ9X875wAm1JwiVNuUqJwQsjZ3Olduknfw1v6UfN1RbrF842AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Guc56PRx09CNyJjvvz7AipcemLCAWRCA83cj0LX2RKw=;
 b=dpPjvsdhW0Lz5SjoIIBE0TUlV3i6DSTaJqbNFg4kDxDWaRRimT4XluhaNItaZtuLuBIdvXp0us8SEEpZecYU+RmRAr4tX5ok/O5h1ZJbl6+VI1slQOsFxx1K5+gGkm6AUV9a2elRbRl/khM0RuSIBz/P4v717APDy6HG3DqZrcJZMFv4001z0DsOUS6NDSPuqMZlnHNq2FYZGfFT2UvBcxTXv9lOIvA7stIo5YDTHk0+G0wKSIu5E4GVEcbzt8+TpGq4kRyCZFks/xJaMfWk3tL/G4ZDfrDF8i0oX3s2X2M+SC3rTpPkWZDymeSLo8P4YSxlm31+I2cLfIwJBUw4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Guc56PRx09CNyJjvvz7AipcemLCAWRCA83cj0LX2RKw=;
 b=g2yUBcCsGNHsaZ/vhEeFutO+vD7M3BUl7Vi8N1c0siUABMdfJXo7aXcWTjBJwPyp/rUSUaVJNkBkiVjEE2u0zuX1ZbKSdIYYqbic4bLVFglbP8CeTXXgTXf36EsQUA3VM6ZDGgGHOVtYjdYpB+CjBrXlmMnFVA/9gubqUjWFMzU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by LV0PR12MB999067.namprd12.prod.outlook.com (2603:10b6:408:32d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 14:45:15 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 14:45:15 +0000
Message-ID: <134b622e-fb3d-41eb-82ac-b5c73b871ff0@amd.com>
Date: Tue, 6 Oct 2026 09:45:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 5/7] crypto: ccp - Allow SNP platform data to be
 queried after SNP INIT
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <c09108e28dbf9f54cbf63f8c912fd5815b564f33.1791212077.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <c09108e28dbf9f54cbf63f8c912fd5815b564f33.1791212077.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0431.namprd03.prod.outlook.com
 (2603:10b6:610:10e::22) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|LV0PR12MB999067:EE_
X-MS-Office365-Filtering-Correlation-Id: a18a61f2-e7d4-4b57-3315-08df23b86eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	42fYHjdJaes5MfPlgEP0/uz2ZtWfF/eOoaUJJbYYI90hKFIeJg6yVZS+nn6fq2j3NeVMaOSH1iCgKuOmx/F5WIb73pibJ4ZTHHl2zbi/cfsxMp7cfhALDnLMeBI37SdkZbJ13SnyTxHWpYuFiR4MTOTLHZaGVEAkA2wERtRD+51TowGg0VSfPtCnBmvm8vyO6Jn7fqr1BHbxqhIsYfYQFSgB2h4oCC2zuq84jVwf7PrjkCa37yAnve6YqxCaCT3fQNw+Evx7Btj+LeKmFZrcManMvv+iYoJosXcajGVUZAUmoTaRcDA8tVNTXyK81nboE5wukWLXcPsVRPo0wuRmWF+08FlM637+U10atG7Ey0qNVrzn0sD42dDSyTiudWNBVkXBvMzZe0Ppo6EzEcYfn5TKlND0ACU1sQCYiYdBIyoquaeBsvl9M33WKG6K/Ul+UmrTVWovJ8qKsfwVoclBUmDGMk+0O0DhAXZR5LBHA9TnUKWHvdg53Bvhpf/YAj8xZB7LGjkGG807/KGJWsfNXK0w1C12rhRQgxrieFI4UWZSc8sb2xmMzOY1W/dDwuGmtkFbNPZ9H0wqg4HhEf52xxAnResMdDGM26u1HdCIlYatnNoRdEOwDlu0uXQzDOmO1FR4VzZfVh/vdf9cg0yd8MyGgPzqAoEHkZN4g356Jvg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0kzRjg4aHpKVVROQjRqQjBjOGZwU1pmbnB2MGdEeTJnMmpqR2I5a3o2bExr?=
 =?utf-8?B?aFNwbjRrUzFSam9jV0pQK1dESWtBN3g2RmtjWlNReWcrdDBKY0dXWUozcjJk?=
 =?utf-8?B?Q0RJU3BsbEJRZUVHREtWdzFTMi85ODg1QXJsNnF2TFRPaURqcTg1WWw3YWRr?=
 =?utf-8?B?LytJVGRjRm15NVdvTUVsWEdEV1hDbkI3blJ3bEwzWXNBZGx3NURLVnhKUkU1?=
 =?utf-8?B?bTg0Z3pMaENxTmVRLzc0WkVnSWNvbnoxRWZTeGxpYTIvSHhRWkRvU3ZHelhl?=
 =?utf-8?B?Vy9ibklpU0FUcmVCQ1QvOUVIblFyN1NyV3NQLzFJTlNOdmJvMTJBRjJaWkxa?=
 =?utf-8?B?YVlTZ0ttS2tNWjJ3T2IwNVRCMUp3WC93OWJISHpkeXgwSGN3L2VyVm1iSldG?=
 =?utf-8?B?QXFOaWVycDJoQXZjR0MvTk9qcVdVWk1HYWc1V0FtbFk4YWRtQzBJTktVSEVr?=
 =?utf-8?B?NTFieG9VSGllU0VQN0Q4bUk5REJCVEplOERTYkNqUjFNMmlyWGppZUxBZnRw?=
 =?utf-8?B?Z0I5WEM3aFhMWWhlNUh1UU5wMVA4ZUZxOVBwSWlJaGcvNnBPZ3UrQmJyWlIx?=
 =?utf-8?B?eVRRa2xUSzFSWlJBQXM3Zlp2azY5bXRKb2JWTTJ5eWlmY3FBNTJuVVlkUFdv?=
 =?utf-8?B?WkJWbnI3REVxNk10TFA0VDhtMlNHeFpERDRpREFmaEU1ZHc0YWFvN01hVkJ6?=
 =?utf-8?B?YVUrRTJkUGgxSkd5cXNLWjVDSjBXUkpzVlI4U1NGdENTcjZTelVFRUszZTdS?=
 =?utf-8?B?ZG54NEM2U0FFNEdlYlBuMTlWdy9tRU02a2dGRWcrT1RtbmZCRjY5UncydHdX?=
 =?utf-8?B?N1BUbE1icEtMaGZxd3ZBZU01QUVFRHh6cnNjYkZvODVUTC8zdGYrQUNHakhx?=
 =?utf-8?B?bnJLNFRNQit2ZytjSHhIM2FMeGpaQUxSY0tTdURXOVd3N2tlTk1NWi9vdVJK?=
 =?utf-8?B?aXNIbCttQ1cxWjV1NzdtRkt4eUU1bHNOVWFYTk5Xb1UwOXZ4NHl3ajI2RmEz?=
 =?utf-8?B?Yjd4cUhhOG9mR2RBTXpTZWUyTUFIa21uOGlSSW9MdFFQTUdjblZxZEFIR0xQ?=
 =?utf-8?B?c3dzTUVwWG5LV2JxM2h6SjZ1eU5rayszMDNrZzk0elBuVkFjMFFzaDlxWXdH?=
 =?utf-8?B?SzZaaVRhVTl0a1p0V2FJREdNeWtTSXpOd3VHTGN1c3hQMUF5anpSTUpQNDFp?=
 =?utf-8?B?VGRDK0w5TDZ6UFBva0hjZmErTXRrL3R3R1pzS0EvakFWZ0RUNmFxNmEvQmk2?=
 =?utf-8?B?SlFyc0lCZmxmL3AwZ2lSRHliNytzTEZBNnRjeTNYWTd6SGxSNTBWWHhNU0dF?=
 =?utf-8?B?ejNHaHQvTmI5NzlsWm40N1E1alB6aHg3UE8wckN3enpkZnBTRUxyUmZTUnZP?=
 =?utf-8?B?d2Z0NXJqempNK0lWVXlEYlNNOGZ4MHdLM1c3cGJ1VDdZYzRvdVJGcVJSYkpu?=
 =?utf-8?B?RTJFWmtBRmNwRW9Tb3JtTFo0ZFJuNVhVY0ZmZ25vK1pnUWJkVHI5NUJLYkNE?=
 =?utf-8?B?ci9IMUh1WXU1aUN2QStqaG5ZYUZjM1hDSWtScU5TN3U1blFyczFwcDJKMHhU?=
 =?utf-8?B?dkNEK0FUZEx4MHhreXVudHlyMGYwUUtWNWFHN0IyRGJOcUJEMlJ0d25DR2lZ?=
 =?utf-8?B?Snd6MVJNVk5nektDTmg4cXRsNENtS2dTOXlIS0lqRDJ3a3RFem5oYzRqV2I4?=
 =?utf-8?B?VDd6bW9ZVnlRdU0waFVTcnNDQUZvMHBaSGRWVmRkZmRySDhoVlFtdGhnNXFy?=
 =?utf-8?B?OWF1eHBXbStqQnBhQVZWVExWUWtKS3VkbU1SQ2diSnhxdi9nZElnZ09iY3hG?=
 =?utf-8?B?RWFNRCtRK1RtY3Y4ZUd1bThYQi8vZkxHRHl3aVhLb1dncDRyMmUxNDdYSWVG?=
 =?utf-8?B?a1hOM1k5Q0xzZ2VhWDlmRHg2ZjZ6RGlScGZNcUpKK1RYNmpuK1A5MXZaWjFB?=
 =?utf-8?B?K0FqdStLYXIybVNYT0thdVFBNXlRMXlBSWI3aDlidVNvNmcyMC9QWEtwcnZ1?=
 =?utf-8?B?MTZML0wvTjErOWx0WHJtTGJMVFdVZGVSK0dGaHRKQlJEbktPZW50THZDamw1?=
 =?utf-8?B?OW5PS3F6bzZYNlg0TkJrNlprZnRhaG1UYmpSZ1U5YUlmMjR2U1hmblJlWnJH?=
 =?utf-8?B?b0w2RkI0NDJOVDVhcDJ2SmJGa21VeTF4SlRjalpBanB5cnIwN2pCTnc5RkZx?=
 =?utf-8?B?Ty9ITDAxVVlpUldVQVBJME1zWU96OFg4bnJLeDZEQjM1SGRoUWdoVHhZQ0J6?=
 =?utf-8?B?eWd0ZzBqNUJSdGp2OXF1b2JQejJWUVdFZjBEb1lmUVFvNGpwd0NOVDFYSzJ1?=
 =?utf-8?Q?RTMmRhzn6R3A/eUjMc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18a61f2-e7d4-4b57-3315-08df23b86eeb
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 14:45:15.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqSW+mdsVnk/3PaJHnKHkTaGQC2M3psMh9RW4ftd98S2DHb1+xxm2Zf9gHFFExmjrXlKiSGQkJPqWsjIagszjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB999067

On 10/5/26 11:15, Pratik R. Sampat wrote:
> In preparation for refreshing the cached SNP platform status and feature
> information after a successful firmware live update from
> DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
> the SNP firmware is in the INIT state.
> 
> Once SNP is initialized the firmware requires the output page of both
> commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
> as it is embedded in struct sev_device, so use
> __sev_do_snp_platform_status(), which stages the output through a
> dedicated page. Allocate the SNP_FEATURE_INFO output page with
> __snp_alloc_firmware_pages(), which transitions the page to
> firmware-owned when SNP is initialized, and release it with
> __snp_free_firmware_pages(), which reclaims it before freeing.
> 
> Typically this was only ever exercised during initialization. However
> DOWNLOAD_FIRMWARE_EX can change that. Live firmware update can race with
> IOCTLs such as SEV_FACTORY_RESET which could cause operations performed
> on incorrect cached platform states. Avoid this race by wrapping the
> function under the sev_cmd_mutex.
> 
> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

Just a minor comment below.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1ed9e61a95cc..c40401c861d3 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -131,6 +131,8 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
>  
>  static int snp_shutdown_on_panic(struct notifier_block *nb,
>  				 unsigned long reason, void *arg);
> +static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> +					int *error);
>  
>  static struct notifier_block snp_panic_notifier = {
>  	.notifier_call = snp_shutdown_on_panic,
> @@ -1261,19 +1263,12 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  {
>  	struct sev_data_snp_feature_info snp_feat_info;
>  	struct snp_feature_info *feat_info;
> -	struct sev_data_snp_addr buf;
>  	struct page *page;
>  	int rc;
>  
> -	/*
> -	 * This function is expected to be called before SNP is
> -	 * initialized.
> -	 */
> -	if (sev->snp_initialized)
> -		return -EINVAL;
> +	lockdep_assert_held(&sev_cmd_mutex);
>  
> -	buf.address = __psp_pa(&sev->snp_plat_status);
> -	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
>  	if (rc) {
>  		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
>  			rc, *error);
> @@ -1297,23 +1292,23 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  	 * command to ensure structure is 8-byte aligned, and does not
>  	 * cross a page boundary.
>  	 */
> -	page = alloc_page(GFP_KERNEL);
> -	if (!page)
> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
> +	feat_info =  page ? page_address(page) : NULL;
> +	if (!feat_info)
>  		return -ENOMEM;
>  
> -	feat_info = page_address(page);

This is a bit of churn when all you have to do is replace alloc_page()
with __snp_alloc_firmware_pages(), right?

Thanks,
Tom

>  	snp_feat_info.length = sizeof(snp_feat_info);
>  	snp_feat_info.ecx_in = 0;
>  	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>  
> -	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
>  	if (!rc)
>  		sev->snp_feat_info_0 = *feat_info;
>  	else
>  		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
>  			rc, *error);
>  
> -	__free_page(page);
> +	__snp_free_firmware_pages(page, 0, true);
>  
>  	return rc;
>  }
> @@ -2097,6 +2092,8 @@ static int sev_get_api_version(void)
>  	struct sev_user_data_status status;
>  	int error = 0, ret;
>  
> +	guard(mutex)(&sev_cmd_mutex);
> +
>  	/*
>  	 * Cache SNP platform status and SNP feature information
>  	 * if SNP is available.
> @@ -2107,7 +2104,7 @@ static int sev_get_api_version(void)
>  			return 1;
>  	}
>  
> -	ret = sev_platform_status(&status, &error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &status, &error);
>  	if (ret) {
>  		dev_err(sev->dev,
>  			"SEV: failed to get status. Error: %#x\n", error);

