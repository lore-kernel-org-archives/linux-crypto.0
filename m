Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013044.outbound.protection.outlook.com [40.93.196.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECC054EEAA;
	Thu, 15 Oct 2026 21:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098588; cv=fail; b=lgZ1nzP3dSXByVzst4mixpkuTI6x8vtmVfFPpUMLamsp/FDPM7B1inA5P0DMPD6Qhp6zPUaeYIR6gHms8ONFklgjACjKtEzbAyfZt0ccgXZL0XPwMDoOK/x2Bes9Wp3NOZkssoGZhkWh/0ulqs9dXprCR5ufINF+lfvsoarFnI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098588; c=relaxed/simple;
	bh=oCArmnS8qhiIFABPwj7/YJ/QsRHGESf8P1YaD4ctkZg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f783qt7qyaZKhYOFGQX3wLHeLxgWVly7oDGVrhO+jNTgdSaBLYKsXQ5p2XytWU7iR3X3xFigljG6hXxrQThbrhtQakY/FFtMPvN5GFLp0n017u0bAzDRTPiQSLA/a93L7vwieW9j8ZdIQHhCePctWTVZ23xVJxmwcyabHwCSyEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t2NpByRR; arc=fail smtp.client-ip=40.93.196.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t2NpByRR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+mRrjGfpJbC8WXj+Apsc7lwoYPrrdVv66FOOEOOmJkCN6xLsIeT3DPhonIFUWVyDdwrsGOauOrwJ3WvdFR/vIDco6dADOkCiG849K7HAf43tWb7Z8i/8Y+4Dhy+yU5R2+ReuoL/0MXOqPyeWIvkngIIZbJa779j7XGnPN5WscxIvIeZl+JSJyN1rgLpBs9m0srLEFRTKA4wCIiXnkiPjGSUdDS05XlwiCXCVOdGtUs0K2ePT1HW1Ry6GszSpatI8/Eiff3yrGK+RTBedZMb38M2tW3r10VvL4KzvWXnj3Rd1HFnEOEMKDwyksYaTqJXM6CDWawgHHgxQKqlMB0ozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3J5bM91/85C+jFkhxkKgvgOe5sMjkd4ruR5iZ9J3a4=;
 b=D7cXR0A2/GrVRYQYDpOnyFdK6nTqAjyKKFz9moVbEXqkUhewqeO6Qt40ypVVHEMe/GE+x5aksMZ2d29sSUUCnMuwqlFF1FBFjd6FTjqcsu9IMX9o+JjY0PINDub5cz6Vf7XKXBow6TVtEozdQln2h355RAq5GQ4mcrrbHnJz1th3Kl6CT7rTy28cpFNW7f96FZ3AV3hsVXoJMu0gEF2GZIfn7gJ1INdEk9sCaTDstAY5UJuTxBl7ALTMB7/La0gF2AhkFjjRkvYMTEHuLdTsZrdmuVVRPhJY/C40vZPuqlf3UrR4l3pwWnk3uonWjCYG/m+J9zjQ3rdWNpdnxx2Oiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3J5bM91/85C+jFkhxkKgvgOe5sMjkd4ruR5iZ9J3a4=;
 b=t2NpByRR953RRd3IxCc4UCRwCiJC3Fx7Yowsyv3mRi1pFFsNp8l3hvYJKqUXaySd9rqwrSrCaWRoOHW03CcRs5PSxG1JiOPuKhK5jCxtneD1W0UTFwjCLnhBzH3sqXvnrIfCwNZjXzDhnNEtSFOd45kPJ5cxgaxsNDjsokVKyaE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 21:09:42 +0000
Received: from DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5]) by DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 21:09:42 +0000
Message-ID: <267f5e92-651a-4874-936e-70f3fbfe1e16@amd.com>
Date: Thu, 15 Oct 2026 17:09:38 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: Tycho Andersen <tycho@kernel.org>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
 ashish.kalra@amd.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org,
 chao.gao@intel.com, aik@amd.com, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1792014060.git.prsampat@amd.com>
 <55c189e9130a7d22c0b756440f10a056415404e5.1792014060.git.prsampat@amd.com>
 <atElnAcDQFTnmdVr@tycho.pizza>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <atElnAcDQFTnmdVr@tycho.pizza>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:610:52::36) To DM4PR12MB5310.namprd12.prod.outlook.com
 (2603:10b6:5:39e::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:EE_|DM6PR12MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: a9b2b4f9-16df-463c-c667-08df2b00a1a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|11063799006|4143699003|261009223027099003|10067099003|22082099003|18002099003|11146099003|32116099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	/s2HvEKeHcAnvO4M9mjJnHcWgFG9GIIzPpZBWCRFSmIwnUChTpePGu2bIH3+pnmEsrW2ZUvzryHLQFbJcNmlxwVYAzLDf1Cr/t44Hak5JFX4MzdfwD2G/UtJMxKTISayDrmu0kCU3QxDXRE2kjipGSK4uz8DnrYMr55cHZxHmVbXnUrnZrmv0VSrzn2giLIAVDSm1qrTc7XOHsj2OroR7cwvGWH3xX8wiD0kKb2CYOKsQyc76+xYeDF9EZfuxHRo/Pcj581TGy2xmqMw8wjmqL16paBDPGZLmNP8fA41u0oHssBUUtutWQTI11kCBaX/0iRfYxsHk8gouRPCVr54XS9YLumqFD6PH3eNM9S4Lxw67q2s5oh14Ra/bq0WeFul720t/j3EcBNt1yFMKy78suCui2aCEm6AUoDcPa5iUWqD5gUiAaqZsPSNIJGasrjd9cWzxJe7JwUEchsblbG7Avjs3CsKDDsk0M2vvtcOLOKz/3QgW3y+3haeGzknTPDCUZ1dETBERoedV7XePOb6h2JG1T8aHAveKQW9Bo2UkDFS739mp2g5qTZ4ohwIMWbZwXeHUokQhvAJo/KUezWpQOSUXuWcTRqNMJkT9MLg7zRth8dGE7y2Q3r6GOqsV1iC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(11146099003)(32116099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnkvNERhQ2ozdUNKdlZCak11R2VGcXhHK3Y1L2FhQWFvalhxejJ2azFzb1pR?=
 =?utf-8?B?TjNpck1IZzNaN2UyWGRoZWk4c0F5OHZxNFFGRVZ4Z21EZy9nd1oxWU1yL0VT?=
 =?utf-8?B?amh6QjAvQmVQKzR5K0pIS2ExUS9ES2FZdFBhajVoV3I4cmsrSS9oUTVxanU4?=
 =?utf-8?B?SWh6Q1k1RU9EVXg2UnJxRXpaRWpQblZZbHNQL3F5bERhcFpaVWNLdGFnUDNZ?=
 =?utf-8?B?ZWFobWw1Yll5MTdNQzF5Rkx0cWJRcy9BbmNJcHArMGM5L05lTnJSRjZ6R0JN?=
 =?utf-8?B?aWcrZVlVWVVHaEhLSk04NXVhOUozYUl0OUJZMngxc3Y4a1JBYlVaK1dnRUoy?=
 =?utf-8?B?UDlIYk1tYzNCMjB0OWJjbC8xWWJjNFlNVFJpbXNoNXNhREF0QnZmZ3NPWGhq?=
 =?utf-8?B?dlNsclJLQW9mSlZEZ0dqUFNqNWNrOTI0aVIvMno1cHBjV1BaUlRURnlCUHp5?=
 =?utf-8?B?cE5WNjNjWDAwK21zWVNtcDBzRE1PUjljYTdTT1FTdDh4ZmVDeEd3Y3hnenM1?=
 =?utf-8?B?a0VvVmVXNlNBbGRRNEwyVkRScHhKbUphWTJOT3JxOW5UWWJSWkVLMjRMT2Iw?=
 =?utf-8?B?bWc2aU1vRWFFZ3RBemJCTjQxbDBYTFJjVTl6b1BzVDdEQVRYZXJ2L2NObXQ4?=
 =?utf-8?B?MUxuNmlvZWpzcGlMMURoTWxaWnVyL1Z2WE1CNEoyUUNycnZSTWJiaDFvejlN?=
 =?utf-8?B?c09PNDBSMnlXaHc5NStGaDAyVmczRFZSR1RTaC9YMkZIcXlJaURpZ1YvRENw?=
 =?utf-8?B?blpJLzhVYkhYRTU2TkVQdEQ1MldZdzZiUmJGM1RQWlZkenp1R09VVnhtRkdy?=
 =?utf-8?B?eXVlL0hxN2htc1UxK0VibzY5bVFoWUNGVkd4OEh3T2k3MFdKTS8reGI1Tlla?=
 =?utf-8?B?OEFOR2hVNmcyeHpvN0RheTg1S3htOG56aFNRYkp2eGg0Y0FaLzRlSnd1a3pu?=
 =?utf-8?B?OTQzZGRFamtPYm5zblI4NlpYWC9FVTdTWTlHa0JTOHd5OENoek1meWk4eW1a?=
 =?utf-8?B?MnJWZGpCVDlLV3g4WHBhMUFvREtzYUx1UTJWZURLSTZLQStGbzB2YWtXbndZ?=
 =?utf-8?B?VmxSeGRGbEtyVlRlUkZGZldURjR2MXpBK1NDenZsaUo1bWFuY0J1Rk12dHFx?=
 =?utf-8?B?d0EzazNmd2NpL0s1Q3VZMkhUQ1Y3RWlTL0FaVVhpajNsZWp1bnp2b3NvNHZX?=
 =?utf-8?B?S1hpZGJBTTgyemdyOVFNdllPb2lzeTg3ZkhrUGhCM1FkYytvRGxGeWkxcmF6?=
 =?utf-8?B?ZmJWRzF0dm5xM0IwbFBaM2FOd3NscFZCN1dPblpVWUpkOXFURHZEenFOWEtJ?=
 =?utf-8?B?QmZvREMzRW84NTc2Uk5xa0dvUkV4b0FiZWZtOVB5N256ZTh3RFgyOW9NNmIw?=
 =?utf-8?B?QjFDbW9LQ2kyRXA5SW1NaDBWeGpUeVk1SXBjMkt1c09tRjJxOXNkS3lBZERD?=
 =?utf-8?B?N0FjdlFWTXMzbkMrMjdZRFpQNER0SC9TT0tDd3FDNmNibWN1cU5tdUhJdTlW?=
 =?utf-8?B?UTBvWHlsNmlTT1NNTWxrcm81K01hcThlWUR4WVhCQTJiWHNMTkdreEdKZ1ls?=
 =?utf-8?B?d3lRSWhIdFNheDVub1cyV0xjM2FtL3NZL2t0eUtKTW4wR3hidWRRRTdhTkIy?=
 =?utf-8?B?SVV6Vml3WDRIZ1gzR2RWRlN1QWE5YzA5emZCTWxzRjlxRmFqdHZBa3RxR25Z?=
 =?utf-8?B?dW5VV0JjNzlGWVFYVXRtRytFZDl1SFY3SnBxMmdqLzdhdGVtYmFsTkxLSTJo?=
 =?utf-8?B?b21URTdseTdVMmt6dm1HV1pTelFDQjZrV1dwNHlvZTdPN1dBR1QxWWFiL1hq?=
 =?utf-8?B?WGRzYTFrZWg5c3BzN05YRDNidmJJMTlaaFI0d3luRG4ya2lsTmFNSjlnYThs?=
 =?utf-8?B?Y0ZyNE9HYk9OT0haR0c5NFVtUjk2bS9wazJ0Wk92L1NFMENzYzFhaFFib3R4?=
 =?utf-8?B?S21RWTBjdm4xcVRlanFYRFJVbFhyeW4xUjc2Vzcrd1FnbDBxKy9ZWVVlMXZW?=
 =?utf-8?B?V1c5clZBUHAyVmp2VlZLeXZKcm1ORnUrSXcwMUFpWk1UZXdQd0dmeXk4c3Iw?=
 =?utf-8?B?U2ErUUYxNFF6anJ3VEJ4UGdKR2IvWWpyeXNVTkFhbmJSMkFuc01OYyt1eU1T?=
 =?utf-8?B?anNmTnY5VmpnWTlMN0swWEJwOFdVWnZKRzljcFNKaFpDUUxXZWkxVk5BQ29V?=
 =?utf-8?B?Zi9KSFdNdm1NYXoydVRLdjJ1KzJDOS9CVU1UQ242Q2ZCTzd6UmJWblJ3eWo4?=
 =?utf-8?B?ei9VWDZMV1hUb0Uva0RtUnFHSFlhaUthWHJ5dXpvWUZvZUNvd0F1eFhNWmlu?=
 =?utf-8?Q?t568X4+sxvyBO+7hmG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b2b4f9-16df-463c-c667-08df2b00a1a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 21:09:42.3552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmJXIoWmhBYiM6cIfg5k/1ncGlrK+ScGDfEIT32TCtcpxFjSeSedUVVA2YEyM8TJF3r5AYQzOLRBmisNSCBRCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057

Hi Tycho

On 10/15/26 3:38 PM, Tycho Andersen wrote:
> Hi Pratik,
> 
> Two small comments if you happen to respin this one, no worries if
> not.
> 
> On Thu, Oct 15, 2026 at 02:14:09AM +0000, Pratik R. Sampat wrote:
>> +static int sev_download_firmware_ex(const u8 *data, u32 size, int *psp_ret)
>> +{
>> +	struct sev_data_download_firmware_ex sev_data = {0};
>> +	int ret, order;
>> +	struct page *p;
>> +	void *fw_blob;
>> +
>> +	order = get_order(size);
>> +	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
>> +	if (!p)
>> +		return -ENOMEM;
>> +
>> +	fw_blob = page_address(p);
>> +	memcpy(fw_blob, data, size);
>> +
>> +	sev_data.len = sizeof(sev_data);
>> +	sev_data.fw_paddr = __psp_pa(fw_blob);
>> +	sev_data.fw_len = size;
>> +	/*
>> +	 * Don't commit the new firmware, an explicit SNP_COMMIT is required
>> +	 * after update.
>> +	 */
>> +	sev_data.commit = 0;
>> +
>> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data, psp_ret);
> 
> I guess this function could use a lockdep_assert_held(&sev_cmd_mutex),
> but maybe we should not do that and instead put it in
> __sev_do_cmd_locked()...

Yeah doing the latter seems like a better idea for quite a few calls that use this.
And I think maybe better so in a separate cleanup patch.

> 
>> +static enum fw_upload_err sev_fw_upload_update(struct sev_device *sev,
>> +					       const u8 *data, u32 size,
>> +					       u32 *written)
>> +{
>> +	int cmd_ret, psp_ret = SEV_RET_NO_FW_CALL;
>> +	enum fw_upload_err fwl_ret;
>> +
>> +	guard(mutex)(&sev_cmd_mutex);
>> +
>> +	/*
>> +	 * SEV firmware will only successfully execute the DLFW_EX command if a
>> +	 * firmware rollback is required. Other commands may be processed, but
>> +	 * may not execute properly. Use the psp_dead boolean to restrict
>> +	 * execution to this path.
>> +	 */
>> +	if (psp_dead && !sev->fwl_rollback_required) {
>> +		dev_err_ratelimited(sev->dev, "DLFW_EX: PSP is not responding\n");
>> +		return FW_UPLOAD_ERR_HW_ERROR;
>> +	}
>> +
>> +	/*
>> +	 * If the last firmware update returned RESTORE_REQUIRED, retry DLFW_EX.
>> +	 * Being in this state means that the legacy firmware has previously
>> +	 * been shut down, so no need to do it again.
>> +	 */
>> +	if (sev->fwl_rollback_required) {
>> +		psp_dead = false;
>> +	} else {
>> +		cmd_ret = sev_fw_upload_shutdown_platform(sev);
>> +		if (cmd_ret)
>> +			return psp_dead ? FW_UPLOAD_ERR_HW_ERROR : FW_UPLOAD_ERR_BUSY;
>> +	}
>> +
>> +	cmd_ret = sev_download_firmware_ex(data, size, &psp_ret);
>> +	fwl_ret = sev_fw_upload_handle_err(sev, cmd_ret, psp_ret);
>> +	if (fwl_ret == FW_UPLOAD_ERR_NONE) {
>> +		*written = size;
>> +		sev->fwl_rollback_required = false;
>> +	}
>> +
>> +	/*
>> +	 * Firmware either just requested a rollback or a rollback attempt
>> +	 * failed. Keep the PSP dead for all other commands, only another
>> +	 * DLFW_EX attempt is allowed through.
>> +	 */
>> +	if (sev->fwl_rollback_required) {
>> +		psp_dead = true;
>> +		if (fwl_ret != FW_UPLOAD_ERR_HW_ERROR)
>> +			fwl_ret = FW_UPLOAD_ERR_RW_ERROR;
> 
> I think this error switcharoo could use a comment (or maybe just be
> dropped?). e.g. if the user does something to set
> ->fwl_rollback_required and then tries another firmware upload that is
> the wrong size, ERR_INVALID_SIZE -> ERR_RW_ERROR, which seems
> misleading to me.
> 
> I saw some discussion about all this:
> https://lore.kernel.org/lkml/20260924213737.3833625-1-shansinha@google.com/
> 
> but it's not clear to me why you need to reset the error code here.
> 

My understanding from that discussion was that userspace errors should
fall into clean buckets. read-write-error would mean "roll back",
whether it came from the first failure or a later rollback attempt,
since a failed rollback still leaves the PSP dead and needing a
rollback. dmesg would still log the exact reason for the failure.

That said, I see how it can be misleading, and I'm fine with dropping
the override or putting a comment and re-spinning this.

Thanks
--Pratik

> Thanks,
> 
> Tycho

