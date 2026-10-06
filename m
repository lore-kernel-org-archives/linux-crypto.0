Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013039.outbound.protection.outlook.com [40.107.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47658481247;
	Tue,  6 Oct 2026 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791298244; cv=fail; b=B7nIhFaNlnrxJMTgHdNcrtUPNkhTAQgHEwS5pCh7w5xUYFen59mqUhU6YNSrime5vcZtyOPra0EZhD0+ZT3xNNLJbU4a8kUeEOITkTeGsKrYzxiJBj5MzmxiXg7+EdHe4W9xlBuv2bwxpCulOetR0lLT7bhxcfpAFjK//HlMcu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791298244; c=relaxed/simple;
	bh=qqNnxCwFlGnJ2DqLqkOkYSs67H5Rf/oVvdyCL6ViQHw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L0R594HyT2iqlDFC54bKMvZc0GHgBu99Nw4R7mDrZ55cgdghs2StzP19EpJMiTWxqTVGKPvCJrAck0xkQmekA7CFbYn3rB2CJXFZDxXTeUxYaqUaqmYx0JvmsduR0cxVVdRT5X5BndjKK50v7qPPx6HiOlbV394pGGJxFl8F7OI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zZnPNyii; arc=fail smtp.client-ip=40.107.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zZnPNyii"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qETygrKtJn9lpOJt9XA0afkFo7Qzz8Gs0bGp9/zAkOiu9N4E/ciJKYz04eK3rf8FOugDez1p6Y9pzh7Vyy+VYvvExL24T6y2OKt1XyYey0nZrtnXakrN9G9DMwzP0TNdYRkY4F1rO+eTgKs/4jx2I/aozgCLCbcU1nKzI5C6HClQTiTsXz/pyWEDnzA4GV2e0DY9LhaQgscdrwq8Q0MqKwpHBH+gN3OfTCDkpK8ff5SXRs1AJ8ih9O8Rwi7FBrUU+XL3qlmQ5LgUCDS6IYyGVnfOANMqnoJO50Y2aYMAdB6TvS6runOuvwLtQsDfdQc7MA204G5JZQfqMj1WyKunjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIkUIt7omJdEduJmoL/s5nVod2qh+pNAAJvMdMHcadU=;
 b=BooNsBJdxO6AmefHZiClttSYCmhR7h5PoP3I6zOcmQ9TtgXHXD16iuxGaN4M3BsDoIPZk8Ryzs0M/Qfscs8wTkPN4dy7+QzOqJ4Dl3famsWyKaFFMrqiGZ76ehqxPWgeahFWo/dAvY3qrCbOVh2Gh00Kp2QRe5G+C0z5ldfDha1X1uZvxEyF6t0oikeEPZC8waQ00RzakLOQVFsX4jHdiVQ0Q/TJaPE8dn+jONpllGJJHDwV/dSAYV1wIQz44zJ7MmofenHjmMA8X2+zgf9AJF0aJmQAM5L7gVOeUp6itsVUDIYegnngLdzl+oW6apYLJxZkVbRB7TOE9xSE/j0PtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIkUIt7omJdEduJmoL/s5nVod2qh+pNAAJvMdMHcadU=;
 b=zZnPNyii4NrrMF7U6Fh5YszbVsC9agOY2imy7R/wL86rS960H9sSk8lWnVtdGOuJE04Rl5qeSlo1XtA3Elq5b6oigT89ZtdTRWpRePFsir8z+X04UtyMR/lClNboO0HrX0VdggdeH2Y3lRMtkOry1b0wAE7JoD99zJwjNW+C21A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6)
 by DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 6 Oct
 2026 14:50:28 +0000
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5]) by SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5%6]) with mapi id 15.21.0451.022; Tue, 6 Oct 2026
 14:50:27 +0000
Message-ID: <54615f00-c14b-4533-8560-dd4d3d315fc7@amd.com>
Date: Tue, 6 Oct 2026 09:50:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 5/7] crypto: ccp - Allow SNP platform data to be
 queried after SNP INIT
To: Tom Lendacky <thomas.lendacky@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <c09108e28dbf9f54cbf63f8c912fd5815b564f33.1791212077.git.prsampat@amd.com>
 <134b622e-fb3d-41eb-82ac-b5c73b871ff0@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <134b622e-fb3d-41eb-82ac-b5c73b871ff0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0438.namprd03.prod.outlook.com
 (2603:10b6:610:10e::14) To SJ1PR12MB6217.namprd12.prod.outlook.com
 (2603:10b6:a03:458::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6217:EE_|DS7PR12MB5766:EE_
X-MS-Office365-Filtering-Correlation-Id: 35006d21-bd27-4014-0ae4-08df23b92908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|11063799006|22082099003|18002099003|4143699003|56012099006|6133799003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	8HXKGGHRekDafat0hxXhqygXbNZgZoQsx4drfvGaFBxSz0QTbXjE6csoubPZsFTfXOxgETmSOO7c3kYwSu9RHFHs6S3d9A463Rk6QAsbEwb6DV2cY6OdGSdHFnX44Tjh5VY+HdJZIj8jRqe6WN8gO8qI1nHFWj5LIQO8ZRQ3Ntn7Y4Au5xJoSvEyoipVzpRMvmJYIySohEZ++4Sw1ciDAy8Hib3kUZG6AQVcgSQqS427qTmZ3lBs3P28QyrQyqe8efm5+K0goXbOgMKf7LLJh8TOIG74zVs0DAu/fQY0NS6thB+OhN6SYnIoXb3x0wjhAyajTMZI0bFCDeEUQEu+9/udXI4nvhJus/WN9gWifcty8GEmm5vsUw9yER2hgsmPrPqDu9FN5YVawkEP5xODaZOw6EdmUuGOtHU3vFcd1eAYRSNyMVGjoQ6rUjH0/7eY22tHE7o1ZGpP4Pr4WTnEXJKfzAo42g/Cv/9z48etuE8GbL1a/difrEzq2PxCuEowNlR8jY+Z+uQiEtaa5vA0w+i409m54keN3Ba0S+BQvmBL9Bilfjb+G97wjL4IWjuOVGHfbQgMCaJLt/GufMEJiGbyA+aQpHl9CCW15hNi+Sg3rY8e/w1VTA9asLxqV98+cfFILAwjTs0DH1W2ZeOY8v2OH4DtB0V6SXBtauW7QGw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6217.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(11063799006)(22082099003)(18002099003)(4143699003)(56012099006)(6133799003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dy9nUW84ajlQYXBmZ0xyZ2huTWVjMGk0TDdwWDNBTEVKbUU0ZTVyRC9MUkVi?=
 =?utf-8?B?S3dWbEg4TkxHRWtlaGZjNU5RVlVhZXJqMXlkMXlmVHlhNFZjdkxDYlNvandB?=
 =?utf-8?B?RmpBZU15aUN3VmtLWnV4dUpVRENlTHp6ZWdXSG9nd1pCa3ovRkFCS0pWVFRS?=
 =?utf-8?B?VmxESnhxalJJSDlHL2ZxMmRPci8vdEJJaFRHQW9RelNTclJpTm5DVkhUNnBW?=
 =?utf-8?B?WEZFYTh6cWdWN3JuT0dnc2JQZDZRQ0xxQUhaQVh1S1QvNFpzUnNpUk96NThN?=
 =?utf-8?B?Q0RFemswY0E2OVZNbnRSbjNpSDBBelJQMkNGOWhqa1lJbUV5NXhqRWFmemJm?=
 =?utf-8?B?L29McUZ3VXN5Y2kxVjNtTCs5NjNRcDFnQUNjYjIzOG90eVkrbVprbHlMc1c3?=
 =?utf-8?B?dmVFVHFpTUs2MVFBK05Pc0U4QzdvTzJ1RnN3Y2I5bFZiUy9rRHd1czlnRkZn?=
 =?utf-8?B?N3ZzWWhhdmNsWnhIRmNob0FhSU1iUTc3R1VXSDZsWjFHL3hBZE45SHRRdXND?=
 =?utf-8?B?UG9ORkdOMkJoaG0wU2JrNnJJUWNRMmYxUWFmZXQvbDlSOGlJYUFGcTA0RktX?=
 =?utf-8?B?UW9hbVlNL2Z6bXZRYStPMndSNjJnRDlXV1BRT3dCbkd2Z3JiM3RwS0lGcUt2?=
 =?utf-8?B?SmF6Ly9vbkJVRG5oZFBLMzU1cWkvVGZSNll6NEY0MTlVeGZmUWlkWWtURkh6?=
 =?utf-8?B?bjAwaE5ERE1BVDgwL0RuU245L2xqWDNsSkk3M3lndUFCd3gzOEsxM0VkYjZQ?=
 =?utf-8?B?VTNRWk8xZXZ4SGdqMndIWEh6dk14SmlYVVFscWt2aTZyeUpDeEtqc2NxZGZw?=
 =?utf-8?B?YWVuU0pyZXp1d3pqODJ2bHJsQmxFWlpYV2swR0tkRVU0TnFCR0cvbmNwZmFN?=
 =?utf-8?B?MWk1Z1dvTzlZVVIxSWs0UDJVellUWHowblVLdHJ4bUxYMk5id093ZDY3WVNQ?=
 =?utf-8?B?bmRiK2hLK0dTNXllTUNsS3dxNmdVWnp4aXZhRm1mdjJBZW53M0dRZklGWDFq?=
 =?utf-8?B?RUpndGtJUWYvKzh5Z0tjTG5iZlJXdGx3YzNBbnNPM0lmektLaG1RT25oUDdB?=
 =?utf-8?B?TklqT1RuZHhDYTgvMkxteGhua09rZVJUaGt0ekxVOG9HWjdiazI0Y0RneVVE?=
 =?utf-8?B?cWZGYnNQWWhJOGtXWGk1c2c4WE9sdUJEYVRoZ0Vwc2xtbFdqMVB2WGQ3WXBW?=
 =?utf-8?B?clJ4OEdna24vUTg3emlJM1JxbTJOUHZYQnJnYmQyRjNydVlBMWcydllqUXVn?=
 =?utf-8?B?MmFGdTA1TG5lcnhVQS9iSHpqT2dRWHNwUFBEcmwwS2dqa3hheHNneWNNdDNG?=
 =?utf-8?B?V1Z2NFRlSnAxaDRGV3pFTlJReEhiZUJMaWkyeWpYcGZVN0xOUEhaa1RzWTFN?=
 =?utf-8?B?MVlhZGpiNThBcUpmVE5IeFd6ckNsZFdKT2I5STFNT2R0VDI2U3oxSm45RVcr?=
 =?utf-8?B?aHFYQklmQUNMcEJDTHI3dEJBUHYxcVdNVEhQNzZmR2dGYXVFWTlWRmtRek4y?=
 =?utf-8?B?TnFrOWxpeTFsWHgvTldTeS9abjRtdmNBbEFvT3R3NDFmemRKcUNzTHNLRktu?=
 =?utf-8?B?K1VxYTBCRVlYMmYvc25IYWZZME9veFNBNjZPZkd0QVJWNkhuMEdXN21Bdnhv?=
 =?utf-8?B?a05PUFV3WVIzZUtndGFjR3h5ZFVyZDRVby9taU9uK08xaWk2NlgzcGRhcDVv?=
 =?utf-8?B?RkJTQXB4ODhnN1lDVDdUQllPS2RDVjRybHVwTXc3K1B4NFlrR29PNlZVMy9w?=
 =?utf-8?B?VnRvNDVYVkVRZnNjUGd0TFAwTi9mSFFVTlNhUGtjbDhOdk13SW9yc1dsamtT?=
 =?utf-8?B?a1JmT3dZSGJBWVM5SUpZOEJLbXRHVG54OWZhdkZ3SkFDSkRsb3ZxNFhvaExz?=
 =?utf-8?B?TzkrSzNPMWVoTUNhVy9wSDV1TCsyUTNHTnYwQVBibmswbVRIaUhsK3RjTkt2?=
 =?utf-8?B?U1VMVi9HaktwUkU5ZjBOLzRGbU5ONG5IMlFEd0I5OHI3QWhRYlNyV2d1Q3Fv?=
 =?utf-8?B?Z0p1SXlCUXpZeVRhdlNVOGNuZTVEV3Z3eExLaEdTMTR3TWMzbUVNTmlMUWpj?=
 =?utf-8?B?b0ZrNEtzd0xzOVNteWdvS3FKY0hXVzJTSU0wY3FEaVhZZzJmUjNtcGNqZ3Ix?=
 =?utf-8?B?aWNaSzlqdjJ2VEp2UU1nbnhuQUcvUGk1WXFSSDJ1dS9BbGo5YlZTKzJpVm4w?=
 =?utf-8?B?S2k3OTdvUVdMa2w2RXZkc0poaGNqU1hpZEUvSHQxc1NIRkhsdzB4QWU0RE1s?=
 =?utf-8?B?cnMrODVadkZuSWJwTmY5d2FyM1MrTWpJRFJJWnBmQnRRWi9oOEp0YmlvcVgy?=
 =?utf-8?Q?YCRZHUaVM4x/VV1KTg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35006d21-bd27-4014-0ae4-08df23b92908
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6217.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 14:50:27.6595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBpqCMSdlfamHnWtG7vppjOEEnDFuEFhHxpm7eCYhI4K4GVjXePYIxCcE0dI52Wo35EKnFxm1TTeZr/q2p30jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5766



On 10/6/26 9:45 AM, Tom Lendacky wrote:
> On 10/5/26 11:15, Pratik R. Sampat wrote:
>> In preparation for refreshing the cached SNP platform status and feature
>> information after a successful firmware live update from
>> DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
>> the SNP firmware is in the INIT state.
>>
>> Once SNP is initialized the firmware requires the output page of both
>> commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
>> as it is embedded in struct sev_device, so use
>> __sev_do_snp_platform_status(), which stages the output through a
>> dedicated page. Allocate the SNP_FEATURE_INFO output page with
>> __snp_alloc_firmware_pages(), which transitions the page to
>> firmware-owned when SNP is initialized, and release it with
>> __snp_free_firmware_pages(), which reclaims it before freeing.
>>
>> Typically this was only ever exercised during initialization. However
>> DOWNLOAD_FIRMWARE_EX can change that. Live firmware update can race with
>> IOCTLs such as SEV_FACTORY_RESET which could cause operations performed
>> on incorrect cached platform states. Avoid this race by wrapping the
>> function under the sev_cmd_mutex.
>>
>> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> 
> Just a minor comment below.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 27 ++++++++++++---------------
>>  1 file changed, 12 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 1ed9e61a95cc..c40401c861d3 100644
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
>> +	lockdep_assert_held(&sev_cmd_mutex);
>>  
>> -	buf.address = __psp_pa(&sev->snp_plat_status);
>> -	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
>> +	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
>>  	if (rc) {
>>  		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
>>  			rc, *error);
>> @@ -1297,23 +1292,23 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>>  	 * command to ensure structure is 8-byte aligned, and does not
>>  	 * cross a page boundary.
>>  	 */
>> -	page = alloc_page(GFP_KERNEL);
>> -	if (!page)
>> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
>> +	feat_info =  page ? page_address(page) : NULL;
>> +	if (!feat_info)
>>  		return -ENOMEM;
>>  
>> -	feat_info = page_address(page);
> 
> This is a bit of churn when all you have to do is replace alloc_page()
> with __snp_alloc_firmware_pages(), right?
> 

I'll clean that right up!

Thanks,
--Pratik

> Thanks,
> Tom
> 
>>  	snp_feat_info.length = sizeof(snp_feat_info);
>>  	snp_feat_info.ecx_in = 0;
>>  	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>>  
>> -	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
>>  	if (!rc)
>>  		sev->snp_feat_info_0 = *feat_info;
>>  	else
>>  		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
>>  			rc, *error);
>>  
>> -	__free_page(page);
>> +	__snp_free_firmware_pages(page, 0, true);
>>  
>>  	return rc;
>>  }
>> @@ -2097,6 +2092,8 @@ static int sev_get_api_version(void)
>>  	struct sev_user_data_status status;
>>  	int error = 0, ret;
>>  
>> +	guard(mutex)(&sev_cmd_mutex);
>> +
>>  	/*
>>  	 * Cache SNP platform status and SNP feature information
>>  	 * if SNP is available.
>> @@ -2107,7 +2104,7 @@ static int sev_get_api_version(void)
>>  			return 1;
>>  	}
>>  
>> -	ret = sev_platform_status(&status, &error);
>> +	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &status, &error);
>>  	if (ret) {
>>  		dev_err(sev->dev,
>>  			"SEV: failed to get status. Error: %#x\n", error);
> 

