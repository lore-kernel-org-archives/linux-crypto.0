Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D735A480DEB;
	Wed,  7 Oct 2026 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381356; cv=fail; b=SbQ3Y/1/cA3hvbVkPap1UTcXYGZaKQ5bOf9Gp1Pni0UfWWyCHv+0qCbkwYiqWFs9cVvxGtmakvbbWJIBMdB9cK5BSvS1DlRUYaEF85qqS/Ku2R53/tZou+vo/37hUs13oGVBCvDFTO0/K0Rz6z5pc/Sfj9N7y2CTwCAt8WuI10k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381356; c=relaxed/simple;
	bh=LXJabrxvUAsQp7qYFTJ1b4kcrHcQ2EwFwAQWLFR0NH8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TN57KuRWA8tT7kMzJdEhchSVjWnao7dqE/2e/MP5cnVZaPk4jZZv73M/WaBSCexSukG6U5Us3cy+6aKL9yR3u1f25EhDM5nVrSQSzdac4QInvmgBZ4enk0gapNxogrFfXC/RYGaxdfdIGiVFAK19T5aHV3+eplmbG+GC00PPagQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LFkwhgAP; arc=fail smtp.client-ip=40.93.195.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LFkwhgAP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=onsv9MkOApb8DJ8eQyJv5MBOAaxcQ6OiwA4Axb8B75YS3h5X2+ji6Tu8nTYMSnLtHQ8VZQECxr05c6MtadmqCDU9n4BBNsNxcBgU9oFRtibu/eLFmI7daczRsFCPSdD+mZsDtgeCszPVXlzLET4wuqYWvaBm7ETXcGlPLg3y4x/BqQxjYArOTFV9dLItCvIf3V99j7IKACjwl7J0REQ9Fh+wCTvnVyG+lDQfTjMJxeHUINco/sNkyWz21y2bn4tBpzt4wpZ2aSJkgRwRR8i48YRQJMVn7nhVhogY9GxVlhhvxmEkt1usvQsaKEY/FWQl2cD5Y07mA4S9hynE2Tm/5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bR20mckKz6zSeFrlvuQ4f+71WY5rivQNXCMI8BM7Pcs=;
 b=K5eGqYwqD1VoUCrEqrO6Ox8bupkUYlMZpmJ4YK2IR46Xqj9i04+nWDPxOVQyhxGyQhPhIeyQ7KJR2+UtqjTWR+DQmkJ/SQcjSGwsRpy03fuHfWDqJ8p/zTfxglarqgJjTfJPH1s+HXXD2foSH5G6le393n5HvdZA7jurB9zOnSBsCcY4VkD+eX5w8v3Uo8UE7qJdSt7ngLEm3jju+LqT5YFAywT3We7mhWQ2NU7tAIInwiFvrMsnVpWw1rpM6Qr2zne0jIruY3MGlbhY8HbDiorQKypHNNPZC3uzCp3SZ8NSLx5jaUQgwAwr5AVhWfQkDt1iEI8qkgi86mRXBJk4mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bR20mckKz6zSeFrlvuQ4f+71WY5rivQNXCMI8BM7Pcs=;
 b=LFkwhgAPawwpJwFLcorAyihnIDMTa4A3sT479lAb5p/HaFiwNnznCipk7HwHYN4A+m46LECCSeEiRE4VAww0P5R/IU6YquljkvuKlt6VfJokWeW+4r+mfA5Ec99Va5HJc50ckkmzGjM2kl7WivSNk/pQ9PXW7Tsnkqi6Zw3LReg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Wed, 7 Oct
 2026 13:55:42 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0472.016; Wed, 7 Oct 2026
 13:55:41 +0000
Message-ID: <bf2e64d8-3ba5-4310-a048-7dafc6699512@amd.com>
Date: Wed, 7 Oct 2026 08:55:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 6/7] crypto/ccp: Register with fw_uploader and always
 fail
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <35ce536c154380a2f8f3af9b2b50069ce16804d0.1791212077.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <35ce536c154380a2f8f3af9b2b50069ce16804d0.1791212077.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:610:4c::15) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|BY5PR12MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 19178ed0-0898-4624-980d-08df247aad05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|4143699003|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hQ0EO4MJiS3NEa/PLkL7MqXJ93uf//PKe/GoQkXis+SBgdBklEvlCD4WCa1ta6YOeestc3LwLPLUa2iOHgAZpLLaBKNNeut0xaS4tkOARP/n2f8/LK7zXZyR0gk9dyCVVv17Nsj3CafTCBXtRGtormK2/SdEpcMVDRRiWRZMFvOkrstEqce9uYMsPfE5HRbo5QoxcB2uiOVdQvazN36lp9Fpck8/l4ul+SaobiO5sqopngq5WAHFfqiveY5KbRwYO/KmjHxzDM5HsF7IiTiFGUU2RodphP29hTud8y73v9Tv4+i8Eu9ui/GWdcVxnpDRtXofnYW6mXQAK3axfetz7bY4AoucrHRbb5/+fWnAyTA4JJLGKb80hfPqVAOP5OBFSMhUnmyCvNL8KLcgr4puV4yNjhhHQLKupppwgVHpBRtkCvmaJvtLXbroFW6Bm9Okd9EMvBlMCnx74+repSD8ubuOMHrzGs1ZDp/6dcIP9oHhbAAZrDvXLLJnAZ25KZKOD5QoeSLfwD4aK5ZK5PoV4CE+CFZ09N2Rsjm24Qk6yYdLG8RsU0DW7GhzdT1ERacQIjQZpPmuP9xtW/wVcbUGCM6rp8s3QxHAWsoHsQOjAM0Ayq2bz7T3z7+tABqQtbE+PKZE8qBxBCB8N4Gn9rL0JOPFYFyCzoefLpMBNwhfvp0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(4143699003)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0cyQ2JvbDJuODFQdm1yRGVQUklkUDlDWTgxZWVqY0NXVGhORGFXbFZSSGJx?=
 =?utf-8?B?aVFJelgxbnhRY3l3d1pNWm1TNXBtMGs5V2ZCTUdMWW5uQVNJd3gxYzdIbmkr?=
 =?utf-8?B?eVV2Z1RhNHh1bDRhcFVZRTRNV2VneUpwODRnQlovVnQ3ZFZ0Sk4xZm16Q0NB?=
 =?utf-8?B?ZDAvc205d054MmcweTF4L3paNDdZdEFTbHdhUy9yZUxVS2hkTTBVd21iTERC?=
 =?utf-8?B?bmd2ZVZrcnlWNGJOTklxbGo1NmdKN0JOckV2SnNGS2lRQUlDQWJvWVFxdzUw?=
 =?utf-8?B?MXR0UVppVnBvZ2owWHQ1a1Jmc24xSGs5N2Jodm8rRUo3YnJyaTFNcFlsREVL?=
 =?utf-8?B?WlZseVUwNUxBRVN1dEc5STlsakJTeFBaVDQ3QXVzTnloejEvTEpKa0NLcDEx?=
 =?utf-8?B?c1pDbFNXaXFGbDh4Q2lSOWh6TC9MKzlBNmxIRUpTNDZ0UjhielNFWUlMYkpz?=
 =?utf-8?B?ZWw5L1ZyVTZmVUIwMW1TQmpwZzZzV3hEQm1MQU9vQkxDMVZ6enJOL0ZkOHNW?=
 =?utf-8?B?MHNxQmJBendCK0JndTJoNUNjLzBYNjRRQndLTDd6ZVI4R0c5T2FyUVNFSVFY?=
 =?utf-8?B?aU1zL1FuYTNudzNzV0dZak55Y3RZN0gya3RFc0F5b2tDQmFPMWtxZWtPc2tB?=
 =?utf-8?B?dURWalRDN3AveFBnWG95SWVCS2V3YTJYNXVMeTFBdjlRTUNzMzBoVXlBSTZZ?=
 =?utf-8?B?b0pjbGRXUUs4WDQvbVZRd0hoTjVLb3dBR0hocDFsMlRhWStmZmtzUzQzUy8r?=
 =?utf-8?B?SXRNaGMyKytHRlRhVUhvZnhsOEdUVmhlRkYvSnFEZ3NIVGpwcUVYTlVRT0tF?=
 =?utf-8?B?S3pFZG5HMW8zeUFDaURhSmJ1N0JDYjRFRUhYMU50TllrY3lFbkFsUGZkdFI2?=
 =?utf-8?B?czYzNDU4TGtjbFU1SFY5T0VvODl3dkdsNTNqOStjR3JzN0xpMW00OStxWVQ4?=
 =?utf-8?B?RVBlcW44NGExOCt3ZG93c3FUOTFaWklhZzl3VEY5YldYZyt3RUpDRFJSeHlL?=
 =?utf-8?B?bmZyR0o4U1c2VmtlQ3hibmMwb1JSSkliSjFxYUpiTTVQWDFrV1hsR0VYTFgz?=
 =?utf-8?B?SE1ZdGlrYXY4UmpTZnV3TythWnlld2plMUV2b0NnZzNwbERyYVB2b0laK1VZ?=
 =?utf-8?B?cldmZXRUTDZ3Uy80bDV4YndiVjBDS0ZPdDJmamZlM3NBMGQydEE3eDlDNzNr?=
 =?utf-8?B?cVhRbWRqT3gydTNmc1dWLy80eEJoV0V4OUlxalNYeERNRWI5TSt1dzBxVTVL?=
 =?utf-8?B?SXkxUVovUHBLQkxOOFRla1dud09mNzVWZ0M4UHhWczhLUDhuM2l0SXZFak9Z?=
 =?utf-8?B?TnVkS3hrVGdMdkJnb1hRbjlJOExwb2VEbkVSSnQ3Z250YXY3Y0VzejJ3bTdS?=
 =?utf-8?B?WHo1UE92a0JFdnVvWnRZNHB1WUdDWXlmcU8vU3ZKUXEwZ0JwUlVxQWFuWGdi?=
 =?utf-8?B?cm9hL2RRSGFqeGJMMnhFQ2I0TEVySXZBTjZ0a3AwSXoxbm9DOWRXN1o2bFcv?=
 =?utf-8?B?TTJPT3NvVTlpdFcwRE9hYUNsVVgwYURnVXlhenZtM01mRFQydlhPTTBEUHc4?=
 =?utf-8?B?SnNsb0tQOVBCOFBnMVovaWlhblY1Y0pNYjc5WVY4WXZOTkFybHhOQXMyWFdY?=
 =?utf-8?B?T2JnR1Fobm1Oa0MxQXpMOEpXc25xVUhvWktsWUt3dnBsYTlGalBxN21YS0ZT?=
 =?utf-8?B?NGpjTUgxT3JrSERISGZVQXR5SG04Qnp2MnR6NCtjaE5OT1ptaWwvV0cvdUMy?=
 =?utf-8?B?aHRRbXlqdExKcThWczBBR0s1NzdkSWlxRXdibGNIUDY4dWNNeDhVclpqcVhT?=
 =?utf-8?B?SWJIVUNDa3htRllvcnVSeFp6LzFOdEdBcEpTT3c0ZTNCMTJEZTRyU1MrV1JP?=
 =?utf-8?B?VFllVEVzVFN3d3MyTVJmVXR3WGJDRzZtWDAyMnhyTitYU1ZxU2ZQVy9MVnQ4?=
 =?utf-8?B?Y1Q5RnZkM3ZxMzRwRXgrcDhPbUlFUmZTK3kzTlJEZHE0WHVLZzZyZi83VU9j?=
 =?utf-8?B?Z1dFUkROeU1rVmRTdVZJc0JxS1BTa2dSNGdSZjlsRXo1akkycWJLb0FjeDBo?=
 =?utf-8?B?WW4va3BJNEtDYW5oSTl4Nzg5OTZEVlRqSXlUWWJvdnlGNUl5RkdwaWFwWHpH?=
 =?utf-8?B?aXFOUXhqYmNieS9WdEVWQTlJb3pkR3hBaEZscnd5SEJmZEx5YWIzeVAvWm9I?=
 =?utf-8?B?ZEtLQ05rSkNOZmdCb2NUdDVVWmFkRUd5QUMxMnlTRk9XS2tmTks5VnhnNXpX?=
 =?utf-8?B?NGhudSszNE9OMUtsaEpjaGFtSlJ0cG1YalF6TitqVHFpRFB0VDZQa0hRakl6?=
 =?utf-8?Q?8ub5D7W8ZOoyv8H0C/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19178ed0-0898-4624-980d-08df247aad05
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 13:55:41.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LRfMMpgnQn/cnWfT28psYmcSv3LPiXwaqUl84u8R36QXdmP92/pChBlfpoR+YUjFTC2h0qmVx48PyZFDyScgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049

On 10/5/26 11:15, Pratik R. Sampat wrote:
> In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
> support, add an 'sev' firmware loader that always fails with EBUSY.
> 
> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

Just some minor comments below.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 80 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  2 +
>  2 files changed, 82 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index c40401c861d3..88cf60a9640e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2212,6 +2212,80 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_FW_UPLOAD
> +static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
> +						const u8 *data, u32 size)
> +{
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
> +					      const u8 *data, u32 offset,
> +					      u32 size, u32 *written)
> +{
> +	return FW_UPLOAD_ERR_BUSY;
> +}
> +
> +static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
> +{
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static void sev_fw_upload_cancel(struct fw_upload *fw_upload)
> +{
> +	/* intentional no-op */
> +}
> +
> +static const struct fw_upload_ops sev_fw_upload_ops = {
> +	.prepare = sev_fw_upload_prepare,
> +	.write = sev_fw_upload_write,
> +	.poll_complete = sev_fw_upload_poll_complete,
> +	.cancel = sev_fw_upload_cancel,
> +};
> +
> +/* Serializes registration and unregistration of sev->fwl */
> +static DEFINE_MUTEX(sev_fwl_lock);
> +
> +static void register_sev_fw_uploader(struct sev_device *sev)
> +{
> +	struct fw_upload *fwl;
> +
> +	guard(mutex)(&sev_fwl_lock);
> +
> +	/*
> +	 * The interface only drives DOWNLOAD_FIRMWARE_EX, which is an SNP
> +	 * command, so do not advertise it where SNP is unavailable or the
> +	 * interface already exists.
> +	 */
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP) || sev->fwl)
> +		return;
> +
> +	fwl = firmware_upload_register(sev->dev, "sev", &sev_fw_upload_ops,
> +				       sev);

Make this all one line.

> +	if (IS_ERR(fwl)) {
> +		dev_err(sev->dev, "SEV firmware upload registration failure: %ld\n",
> +			PTR_ERR(fwl));

and this one.

Thanks,
Tom

> +		return;
> +	}
> +
> +	sev->fwl = fwl;
> +}
> +
> +static void unregister_sev_fw_uploader(struct sev_device *sev)
> +{
> +	guard(mutex)(&sev_fwl_lock);
> +
> +	if (!sev->fwl)
> +		return;
> +
> +	firmware_upload_unregister(sev->fwl);
> +	sev->fwl = NULL;
> +}
> +#else	/* CONFIG_FW_UPLOAD */
> +static void register_sev_fw_uploader(struct sev_device *sev) { }
> +static void unregister_sev_fw_uploader(struct sev_device *sev) { }
> +#endif	/* CONFIG_FW_UPLOAD */
> +
>  static int __sev_snp_shutdown_locked(int *error, bool panic)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -3018,6 +3092,8 @@ void sev_dev_destroy(struct psp_device *psp)
>  	if (!sev)
>  		return;
>  
> +	unregister_sev_fw_uploader(sev);
> +
>  	sev_firmware_shutdown(sev);
>  
>  	if (sev->misc)
> @@ -3081,6 +3157,8 @@ void sev_pci_init(void)
>  			 api_major, api_minor, build,
>  			 sev->api_major, sev->api_minor, sev->build);
>  
> +	register_sev_fw_uploader(sev);
> +
>  	return;
>  
>  err:
> @@ -3096,6 +3174,8 @@ void sev_pci_exit(void)
>  	if (!sev)
>  		return;
>  
> +	unregister_sev_fw_uploader(sev);
> +
>  	sev_firmware_shutdown(sev);
>  }
>  
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index d5e596606def..7ec692e2147e 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -69,6 +69,8 @@ struct sev_device {
>  
>  	struct tsm_dev *tsmdev;
>  	struct sev_tio_status *tio_status;
> +
> +	struct fw_upload *fwl;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);

