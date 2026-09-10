Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010055.outbound.protection.outlook.com [52.101.193.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BBF3BED18;
	Thu, 10 Sep 2026 21:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789074353; cv=fail; b=rIbAXchACk4J9hlHbk2viXx4Gh3mekOGx1P1qjmkgIWqLuB8+CL+QS9saUZpoAbrpJO8S7KT3neKepBKyYsVkLaDI24ohbdM6Xr1f9kU5Tyhv49aXSphqvJlqNKCrQm36x3djuXHr+LU98OCEIwb1j+X+n25a9xeBURBSUG10IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789074353; c=relaxed/simple;
	bh=xLc4isSOfOfKBEA4fxgJzozNGuUvEFnErhlKuosp1Ww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=daFTTbGrfpC0LkTDzVLAxXQZcNbYYD39jOMkUqw5EtfBdoNPLvMqxrpLBf9f45EqzdQf6+iiQdsMwKWgneehNoxamoJNNotP549/SdAQeg+sKNitdOIExddxrr8wxQI/TLKx1gehUIPuRTh6ZL5zlNocnhj8fBfVE3nYRMy4wU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o3HRdJfK; arc=fail smtp.client-ip=52.101.193.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o3HRdJfK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H9fC4mSLSqgDlYse2Y1EvWx2kFQzwRCbV/kNrRivKzvyCc231s8RjTEtwHQl32tamHLw0eijCwBSNATBRNaPkUuB2rykS3iyw1SJSwfnFXldExMa6+ykbaofgxjju17fs6bmGXaHdD2uonbaRLtdhNlWoaFOxfLS99MaYUlVJ9YWjGjxOSs9Luvr87tmSHEfJHTKk2TAmgL3OweJp4iEu7s122Ok6ArI68uBqdH4r2pB+KiovkuQd5/rP17Z2Cf/EWbJaEmoQ7QxaoRVBxRDXkCGaZIUpf+7JU9yB1tDLDDTAhrFSRxP8mrQkvhKJDCnR7APjAGUV8EKX4vm9gohcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tF2w4q2WLGo671HDKWYir4oRn5XS2cGAKa9wsh/eLVg=;
 b=YFk9/8at0lNfXHCtd6GuBIvIhAElgSzE9/48bSk9gmI9eLUNZrMu7UGGj9usK3KewQZ4ny8+arHEDMlRkVOSbih3tVBWj4/GMuSC5xkxv4f23QGAcVf0lAn+SjG7l57f41Zjse05TNiL77FumGHJwM7clnMqGavwNztaQ1KaWdGvZvSfnvCSYXx1Vq53lChnRkf08WDyYQAHa7yohGC4KjbVLlZm7QAPe8ps0AMHvA60XEOhoYrYCkQRTLAcGjQaRBaRMwlvBhM7uN5aWA+nSZPue/tvDZjf0iwmkgDbEfcG/aXAyHZT8f8ORWnBtPMn40NggW4i4sDBtDbzYDOlnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tF2w4q2WLGo671HDKWYir4oRn5XS2cGAKa9wsh/eLVg=;
 b=o3HRdJfK6GM1DT87vLzwGuRCVHukQA98R6Xgl52nEk51ZQ9Gl6BRR/4PaR9o6IuJ3B7qrYKEOc6Y2QGEzf6vltcbadcHC5MSbSTVoxFCmXwKEAxCqGaDEcMt9GgbZUyxdDr2VQkg58DoJBeG8yQ9cuV/2RltGUL2jg/8CNu0OqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by CH9PR12MB388294.namprd12.prod.outlook.com (2603:10b6:610:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 21:05:48 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%5]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 21:05:48 +0000
Message-ID: <ca2dcdd2-1c4c-498d-beb5-13efefcb67f2@amd.com>
Date: Thu, 10 Sep 2026 17:05:45 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] crypto: ccp - Allow SNP platform data to be queried
 after SNP INIT
To: Tom Lendacky <thomas.lendacky@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1789059391.git.prsampat@amd.com>
 <acb69b69796f5324c41dfd7a1f207044f1f18069.1789059392.git.prsampat@amd.com>
 <e3040c1e-1928-4552-a775-aa9d9925fa9e@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <e3040c1e-1928-4552-a775-aa9d9925fa9e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:610:b3::35) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|CH9PR12MB388294:EE_
X-MS-Office365-Filtering-Correlation-Id: c8208b1d-e569-4d12-91e6-08df0f7f49a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|5023799004|11063799006|4143699003|56012099006|3023799007|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KQSF+x7xQKMBkuM9JqTVapTqbpmv5OJ7uEnpqjrWu91nQ1zo9NGhXcfgapUmm7az4A+jokDqOXhI5L//XEWseCuueu6g/naaVldLEunqVZg3HPPS94wJ426OiXFWzgbSVeLuxHGGP4oof4dYWbt07FrkJjTO8Uu8LCAk1HnOh13oG+6QoiCOYw4MXDiQeZ6cmgzV/H2PA3/UKcrklYQTHQjnWcmesPPCVKvCICDoq1qPhI5H78ovpLQ7vfghmaYCt0nIwlvASQos7TC7OHhCD5euF7w0VTuvM/ZFfuV7iZAuHTb2wheHiG2ly/v5jlhkqyDczucMkvF8GoR4jD1zbMK1m0I/sc5hzXwwR3WzwqNnEBEudIepzp2Jt7syf51Ww5jE1LddiXsofJf6jaRbCjQhuzL2WuujVLg6wQldXpH3CUczMyOluint0F0yvab2vsmfD9PkBzIPH7SwcxEZISrizvULutVdpr2lzBb8YtmA1oDMGdZCCJKvRelSNf/UnNte+mzbOAlv+EWYqh8y6Fn5es68i3mI7TmD3t9GveUcD2Ny6Lv4WdZl+0UaEZ6rugR6Y18ot8fU0cWeF/Wfedm3P1g/4bc/YckP2evgXUmxroNjWy8rWDhf8TVHbsJkVBWmHDi5V1tRw9AJi2G3JRtPPygIfYzwep4saxcMUIM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(5023799004)(11063799006)(4143699003)(56012099006)(3023799007)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckZwOEtuOVVpWnN1d2xiVjdrbXg4MTZPT2Nhdi9iVW5zK09SWUVqTGtsUHBn?=
 =?utf-8?B?bFFkNlM3MHpFcWgvVU9hS0p1UmJkVkFEK3JobzZCWVBqbjd6amRrbkNRSUlW?=
 =?utf-8?B?eUdnRGZKSDVhNWNHMWw2VkR6a3F5bytlK1BSRzR0b0JoTE1uRTVaU2I3OC9L?=
 =?utf-8?B?UG9NYjNuRlQydFhhbGsva3dkZ3ZLdVNqaDhtcWtCSEtXNDRxQnRFblJ5VmQ0?=
 =?utf-8?B?YnNpRWxSbXdvbTJ6WDhuR004YVlMSml1d2tMM0dnT3Q2OEEwZEpNYlZGa3VN?=
 =?utf-8?B?eHZXU2ZGeUFOcWFBQWZKZnYyMXpGVU5CaXg2SUVRdVRzV2hFY3lBOWd2NjNP?=
 =?utf-8?B?OHo1YjNacnl1dUdsdDJEQ3I0VFFwc3lPRi9GSUpmcmFIMTJ0OTMwb25KbUtX?=
 =?utf-8?B?VnorUzVWSjlSL0pRcnFTN0ZPT3dERWJnWlVkMEN2Wjluc211bEZQdlJDbWtL?=
 =?utf-8?B?ak9JbFVjOWtNbVVmUnJ3cHhVVndQclVXaHF4UFlRaE9UaVVWY0gxNUlvaXNF?=
 =?utf-8?B?OWJSdXA4dUNpbzJobDc4dzZjcno5ZXJ5aUNxNU05dTYwWDRDN05aR2NFWjBC?=
 =?utf-8?B?alJrZEZCbnlvSlU2N082WmtkRDhoQThtN0xSa2g5eDFQVHkxUjNHUTA1VVpR?=
 =?utf-8?B?aTdtMGozVHJuK1R5cXVDYTV1WHR6RUJYK3doSW9tNjRrQmlFaW9qM0JaWVJU?=
 =?utf-8?B?MFF4ZHFaS245NlAvWWQ0Sjg4M3dSZ1lSbk03SHJzeDNwbXVRWEl4V29PdDZL?=
 =?utf-8?B?TlVNVXVQSkdJazYyQk5FdlZxWnlzdDIxcnB2OXd6TCtlVi91c1hlSmJQendn?=
 =?utf-8?B?d1hoZkhjV0ZoOEE1cFltYUZrc2R3S1lVaXlyQWcxVmVjSW8yOWNyTzlhdkRp?=
 =?utf-8?B?dFIyTzA4bXArbGE4OWd0UmtjSU51TytEWVZ1SWViNkpYdFE2eGw3TThJR3BP?=
 =?utf-8?B?QXNVYjJWeXppN29lSjFhbXQxUWhWNFErMFc5T1FtQjE1WTVaN216YUx1NCtm?=
 =?utf-8?B?R3hpQk51aXlVWnBacjVhLzZRek0vWEVxb1o0cEVwUzlaYWlxdWlKVk5WYThz?=
 =?utf-8?B?blpvZlB4MzZ2OXRCWGpKSVdGMWNxSEVwNVhmRytHNEpia3ROK2dFTFRzTDNq?=
 =?utf-8?B?bDhrbUozR1daNEEvb04wTVQvMnhSVmxFUG5qOGM1OExlRk4rZCtBVUxLMEVV?=
 =?utf-8?B?VlR5dG5DN3ZiNXVVdnViMjIwaDg0SFNzYi9sQ0E0Q094NktvRFNDcE1mZzF0?=
 =?utf-8?B?Wm9Jb2p1ZGtIbU5IUldNYWhmZG1BSkdmYUZZYnlHTURvS2FJT2ZuVUNvcGcz?=
 =?utf-8?B?OS9qdmFjZ0JPOTBiTGJIY3VrOFJKNm9Ma090eFJpYklMdjdVdVZOdlVqdStu?=
 =?utf-8?B?c3o4cEtKNU9YMWdTdmlveVZKTUxDZjUrMzBobzBCTldwdjVrbzdPZUU2SHFQ?=
 =?utf-8?B?empTWXFHV0lqMHZSM1FaZ2pteHVKMEwvMk1HaUhVK0NMdVdiWmpJdmJzNDVH?=
 =?utf-8?B?M2pUMEMvcXg0K1JCbkJmTTQvRmFjQkRwZk1lQ1MyZC9EUHhyaDNXdmJFaC9t?=
 =?utf-8?B?WGhoR2c3SUFrQmREWXpjUWtaa0o0YXkxeldnbm9MRHZIOHVlb1BiWTV6aGRD?=
 =?utf-8?B?V0orYU1JY1JzcnppMzdnbHVrZTlLT2J3VWFGK0NpTmd1dnJsaXVRUUpDVU9P?=
 =?utf-8?B?eGkydkVIckxNUWtNeS9HUHg1czB4RWtCMDVKYzRaeUh1bFE4dDl2cWhYekhI?=
 =?utf-8?B?TW9FdzBuT21XeFd0d2RMY3F2TjVrR2Jhd0JWYWVyelVNOXRXQUJUU3pxYXdu?=
 =?utf-8?B?azkvejNtNGNzYlg4ZDVuR01PL0dXNDBPVGFSUDRyVmtqNG40c3NqSXhhWG9R?=
 =?utf-8?B?ZXpyeTdvY2F0cEduQTZxYUtKSGVqOUoyMVhkR2N2NlVlUThyUnRwdkRuL1dD?=
 =?utf-8?B?ejhiSFF3cEdpS3lUL1NIVThNNUVvZzFGVmpUWFZMTHNGL1pNVzVUd05WTjRs?=
 =?utf-8?B?aGhnVlo0RzVXN0FWWE1GcGl4eTVFYUpEMVpRYWI3cDJzdlFBQ00wcElibVVZ?=
 =?utf-8?B?cDBEQktydmNmZ21YWTdHUVpoWHVFZkN3aUd0UU9kTlF6Q1F4aHRiTnpoYm9O?=
 =?utf-8?B?Nms3ZXV2ZW53YTFCcnh4OE1zcHFFWTNFTGduZVV1eThpMmxZdUlLNWcrRVhR?=
 =?utf-8?B?YzlhdDFVZGMveGFGcFJ6MDRvWDE2Uis0U2d4NE93bjlIYVBDRVlBZ05wR0lh?=
 =?utf-8?B?TWM3K2xuMWdxY0dDK1dTVXBIYUptSXlPbk1KTGEyYVZURVk0alZzMk4zWEVu?=
 =?utf-8?Q?TGJZlVFyHXoa4+hb9W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8208b1d-e569-4d12-91e6-08df0f7f49a5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 21:05:48.3716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFtFNN8mH0Y+WolYGhoM51izlLZNwtCPUQ1rvb8pZ77CubFnNwekU8ZGox64aTTknjFLNYUpjj5HhW/fxSgeyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR12MB388294

Hi Tom,

Thanks for the review.

On 9/10/26 4:09 PM, Tom Lendacky wrote:
> On 9/10/26 12:02, Pratik R. Sampat wrote:
>> In preparation for refreshing the cached SNP platform status and feature
>> information after a successful firmware live update from
>> DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
>> the SNP firmware is in the INIT state.
>>
>> Once SNP is initialized the firmware requires the output page of both
>> commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
>> as it is embedded in struct sev_device, so use
>> __sev_do_snp_platform_status(), which stages the output through a
>> dedicated page, and mark/reclaim the SNP_FEATURE_INFO page around the
>> command.
>>
>> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++++++++--------
>>  1 file changed, 34 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 1ed9e61a95cc..e891d6d1c6f0 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -131,6 +131,8 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
>>  
>>  static int snp_shutdown_on_panic(struct notifier_block *nb,
>>  				 unsigned long reason, void *arg);
>> +static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>> +					int *error);
>>  
>>  static struct notifier_block snp_panic_notifier = {
>>  	.notifier_call = snp_shutdown_on_panic,
>> @@ -1261,19 +1263,12 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>>  {
>>  	struct sev_data_snp_feature_info snp_feat_info;
>>  	struct snp_feature_info *feat_info;
>> -	struct sev_data_snp_addr buf;
>>  	struct page *page;
>>  	int rc;
>>  
>> -	/*
>> -	 * This function is expected to be called before SNP is
>> -	 * initialized.
>> -	 */
>> -	if (sev->snp_initialized)
>> -		return -EINVAL;
>> -
>> -	buf.address = __psp_pa(&sev->snp_plat_status);
>> -	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
>> +	mutex_lock(&sev_cmd_mutex);
>> +	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
>> +	mutex_unlock(&sev_cmd_mutex);
>>  	if (rc) {
>>  		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
>>  			rc, *error);
>> @@ -1302,17 +1297,46 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>>  		return -ENOMEM;
>>  
>>  	feat_info = page_address(page);
>> +
>> +	/* If SNP is initialized, transition to use a firmware-owned page */
>> +	if (sev->snp_initialized) {
>> +		if (rmp_mark_pages_firmware(__pa(feat_info), 1, false)) {
>> +			*error = SEV_RET_NO_FW_CALL;
>> +			rc = -EFAULT;
>> +			goto free_page;
>> +		}
>> +	}
>> +
> 
> You could change to use snp_alloc_firmware_page() which will allocate
> the page and place it in the proper state for you.
> 
>>  	snp_feat_info.length = sizeof(snp_feat_info);
>>  	snp_feat_info.ecx_in = 0;
>>  	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>>  
>>  	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
>> +
>> +	/*
>> +	 * The feature_info page will be in reclaim state on success, or left
>> +	 * in firmware state on failure. Transition the pages back to
>> +	 * Hypervisor-owned state.
>> +	 *
>> +	 * snp_reclaim_pages() has already pinned the page via snp_leak_pages()
>> +	 * if it could not do so, which keeps it away from the allocator. The
>> +	 * reference taken here is dropped either way.
>> +	 */
>> +	if (sev->snp_initialized) {
>> +		if (snp_reclaim_pages(__pa(feat_info), 1, false)) {
>> +			*error = SEV_RET_NO_FW_CALL;
>> +			rc = -EFAULT;
>> +			goto free_page;
>> +		}
>> +	}
> 
> And then snp_free_firmware_page() here (after you copy the data -
> similar to what you did in snp_verify_mitigation()).
> 

Sure, I'll use snp_alloc_firmware_page + snp_free_firmware_page() and make
things cleaner.

> (I think the same changes apply to __sev_do_snp_platform_status(), but
> don't worry about it for this series)
> 

Right. The only difference I believe would be to use
__snp_alloc_firmware_pages() and __snp_free_firmware_pages() with locked=true
since that is always called with the sev_cmd_mutex held.

I could send that as a separate clean up patch.

Thanks!
--Pratik

> Thanks,
> Tom
> 
>> +
>>  	if (!rc)
>>  		sev->snp_feat_info_0 = *feat_info;
>>  	else
>>  		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
>>  			rc, *error);
>>  
>> +free_page:
>>  	__free_page(page);
>>  
>>  	return rc;
> 

