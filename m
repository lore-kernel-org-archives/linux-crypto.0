Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032AC560AC8;
	Thu, 15 Oct 2026 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792087346; cv=fail; b=d/1uzers9ySfa7De0taVrgL6We0xowxPpt2uatnv17siffti1lZtn5JGtqyhqawQWzR1Gzz4j5bMG19c68q8ZFgGcei+2U4T2Vnx2PM4jP7xtEQOu+WU3BIrUUzTkhi/u/B6GLuC9woZeQ3WJNMBKjJMwCwR5Oy3Maz3u0JvGi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792087346; c=relaxed/simple;
	bh=7l3aiwHqw760Mxl0+Q/Q3dc3Llf1GVnL5oegkaY6RXI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=femqs7ChBFgeGJw48rl8pkfg82+aVTqGOVkxJ7QDwRZx2TDfs9zNrI64rJvau1TW+3e8jPV9nK/nGZQ8Nd2aMir3SANH+hhqcse/3XbipkDXFUyU712l/zzFVNfKQBK2AfcM+0kBPiunr1yOiNENDiuyei9ziS2zl2/W6TOkgoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ChOT7fvm; arc=fail smtp.client-ip=40.93.196.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ChOT7fvm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6g1+8cKcoZEKamrwrrq95aoSt47k0bJvcPKqn7ayTKRVROKE8R/7HJWyDszJSC1Ar+3tG9xBCOeAM35Dh45kK1e3DlwcV5ikZuJDaoNXiBMg3Ck0NYe8pWpWyLSswB+Wfe9OJF/5Ov88V/EqJXN2/j8Z4VQsErUxk4ylbjn8Set1hQUPN8CjbUe0mvC+LNklIAII47fgraXCUiOMg0X3It852cfF6C3CpWSqXimucnTlhCDVwtzYRB0DqSchNd/uUSA1tt2dlefO2QLjfEWUT29du85VuZFmIGzNogkJIGOSLACvCRr3tzgkiB9/2KJTm9uTR7Ef/pWttU5UZDZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5eQbLKf2finSGVEPQU2SO6NOiJhtArQ/G+8BgE34YY=;
 b=WEG8tUw6EYChR3RRWA0CRNwSYfTQiUpL7Vj3//tQ/fatPBu4jTaQYMkzq9M234AwZfCvZAzzboWXjKdswLheLoM+TEbq/y9Ed1JyCB+qrdOGKTuYWXlEhcU8mXD4jfWoYU4tyoSRp5hpNMestow/CBC0C+GoPnNwbQ8LuMapmjKb5vtt5rFI73jd1mqQ8KzP4s6Z2vKn8YLKsjmk2lsWUKvuOp0fAnImQZ5Dm/aorPbR4tf9gKG5fS53Dr79WKccBa+ejUVNtqATjjoqYz7zm8hM1a6HgbS4/86YO/UJsywWElQjKwbgmSFbqgPbiB01hSKf3DTChLpKg7aAg8OGYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5eQbLKf2finSGVEPQU2SO6NOiJhtArQ/G+8BgE34YY=;
 b=ChOT7fvmcZV5iEiRdkj+uQzCT4f/3FZ+PSLMEUwsdM45QID5EyuNK2QEf2H8ByIdhDn4V5AINv9gRY3iywGrKl0SJtSZ3TFDWg0QP5o4iyBBwC75PFXoaP8HHg4hxVLRpjGXogxKAn6HxRTR3wQCQ9IGqmMOOvJ25SqmcnucvsM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by CY8PR12MB8067.namprd12.prod.outlook.com (2603:10b6:930:74::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:02:12 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 18:02:11 +0000
Message-ID: <059a336b-adc4-42c5-992d-ff05b8fcc275@amd.com>
Date: Thu, 15 Oct 2026 13:02:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 5/7] crypto: ccp - Allow SNP platform data to be
 queried after SNP INIT
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1792014060.git.prsampat@amd.com>
 <d79a84d4fa9da4c02d21a6a88f0651c66b0e2ef3.1792014060.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <d79a84d4fa9da4c02d21a6a88f0651c66b0e2ef3.1792014060.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DSZP220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:5:280::11) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|CY8PR12MB8067:EE_
X-MS-Office365-Filtering-Correlation-Id: f594563f-bc55-45cb-d348-08df2ae66fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|18002099003|56012099006|4143699003|261009223027099003|11063799006|22082099003|10067099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	gs2astLc8yhP5AuA0ekuCMIXUX0MSA4Rj80HQ8QP7j4jXunIV2K148bYiOtWYMK2BPy/vYbbQpqB/YtTw1m3dBeHu+g1VVz7s+5pxWLfnCYasXnHA8pMEpgOSOm7WWv2tXa2319D9YNFEQ8FMQYtLczEkxhkwFG4QsH6u8xco8Cp6pcKbLUMRaRALR9fiftFAj4pH9ydiM7Yu1hIOgChQY6UFC0j8b3wDvku1BGHhsnZdHfq9PfALmAjhDMSF3zAqs8JF9MIid1nw30oYf+pbiz/kXo1sDAuanrSj/mtx4TV2hh66ociih9lJrZKuohKa9njScz+0m7QejUSSWlmNVDpwmv3l+fl1eCqe/IweLnrl05JN1H42SAlf3puYeMDEH5ZxG1ArbzVV9wq+gaBmQi0QnKA93ZsU1zoV2mCJoDuqv49VS8pdQT4FP9YvOiQUcYEC60Jp227TBBpwEaVV0Y7UKu4T4B9pLAOllxljVaRyyPXivazVd/t3CjKaERxoxaw1M+x1BNT50M44rSHAIc3BKwEYt3GqX/r7Vv3i66FfBuX3h4Ok0uQW85m8/CLASxBt7C7ANujKAltiXpIoO44e+qYlim0oGWIXjCmJzDHjbzzU/u3f90QXWKg+qq5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099006)(4143699003)(261009223027099003)(11063799006)(22082099003)(10067099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXJCMk1TY3V3VWY1MXQ5dlZqczNjSEZsRVhGa3pSdGNBaFA1TXRIaGt3M3N2?=
 =?utf-8?B?Z0s3L3Nra3R6YXBjOU9ESEJZOGJ3c2VPY2JZdUw4UjdnTVhaRHlnbFpVYmh5?=
 =?utf-8?B?cVFWWmZnZEh1S0ZRNDBJTUVTVnFzZjZtUmRSS29mbWY2N3V4b29QSUNvOGxT?=
 =?utf-8?B?S21UZzRLdDlxeTg0MkxFL3Z1M1ZjVlQvM0RjeHZRVzZJSnpiY2RxOFAvR1dG?=
 =?utf-8?B?RmRIRUF6WHFyQVZ6cm5mK2pvbUNNRW1pemlJdTkraVRsZE53T0VXMTNpYTVn?=
 =?utf-8?B?ZnRtTklWTThZMk1iMEowc2ZaSlN1RzlDNStwUFIyTkdTU1VCRnJVaE9tWDRt?=
 =?utf-8?B?MXF3WW95Q3oyVWtUQ3VQTzZSQm0zdHEvaGxlcmJFRUtzQWpMWFpaNlkzT2o2?=
 =?utf-8?B?enJmblpzVlBTeDZDUDBRZ2ZjMlJ4aCtSbHovTjBWVHAweU42MWhCQVRmUUFk?=
 =?utf-8?B?d0dmMmUzYjdndDJzSUhSdExyYnhLTHVOeHNLUTR6bUFtbVVwdlhsMDI5Z0E0?=
 =?utf-8?B?Tk4zMEJ6cDJBdmNxaW85Y3l4VmRQTUI0NHNhdm1UOVN6SGxwVEhmSndJRUFa?=
 =?utf-8?B?M0NDYkZOZVVlaGtJdDFhdWNvdE9Ma0xvekI2SkFFTXAyUnBBMG5SQXpiY2Qv?=
 =?utf-8?B?N1ZZbWF2UGc4L0J4NEtXM2dpbC9FZGZDSXpoem0yTitjS201TU9xSWM3NnBQ?=
 =?utf-8?B?UmtOeWNyOW1jamR2YmV5V2lHZUNRRWUzMFd3NnhyY3dNV2xWVEhiRXBOcCt5?=
 =?utf-8?B?QVAyd0hodUVTb2tyTlN0bnd4emZhdXFMa0toM1l3dmZOTDN6VnpoVEkrbjQ2?=
 =?utf-8?B?amFuMzlzamlYVGMvNFZvN3UwUnNlMitkakpQakozcks2Z0dSenY3Zk0vaWdD?=
 =?utf-8?B?N2o2N2FYZnRUa2I2cnZETUsrd1VyRjBBVnZPUm1wZnk1Q2FyZFp4RnRFUFBo?=
 =?utf-8?B?c3NCWWNYcy95V1hMZnlmWFJpcXpqNnUrczM3Q0VUYjFzZnUyS3BicU8xRmxk?=
 =?utf-8?B?dXVqTzNHbnF3ckVWM0VNaXFhQVJYdlZNVkw2UDhjYVI1MTFOaHRqWklHcFBy?=
 =?utf-8?B?OTB6S1hBZjVSdVZmWXowcWZxSmVldTNYdzVSN3BRdTBFdzl6QklVNjBIUkZ0?=
 =?utf-8?B?LzRkN0c4b09qdzJFbytZMWgyQmZKblNzODJBbWpIdk1lNVMvZ0YxanREbk9n?=
 =?utf-8?B?WEdjc3pGLytoZWhJUEsvZUp3cnBrZElNOWQ4MkxFbmF2dXZOK01ibW1DWjBh?=
 =?utf-8?B?NnJrZVRpU2cwTEl6VW95VHltOUNZdjEwbllTeDM1TFhtOTdUOE5DOWJJcHBj?=
 =?utf-8?B?TUtMNXo0dTVHTDJjSDFtcDNwUUpYU3VNTkFnY1drREN2VzJpNDgvRHlIMlZ4?=
 =?utf-8?B?aTFXZEVhZGx1cUlyeTM2TXBZVWRFSWRBQkZCSTRYb1Z5NlBhVGk0alZGdTFu?=
 =?utf-8?B?N294RE1KdHBnREhIWWFrNS9ETUlRaGI0YkZjc2RHalVpTGprYk5GTlFIMjIy?=
 =?utf-8?B?UUNPalVtOEoyRkxtL2REMTliVlVXWHIxYjFoaGc0SUN2SjBQSk53KzNEZzhn?=
 =?utf-8?B?dzBRemdzdzVzYU54UGZvOFBIcFJKRU5mRmREMEN5ZE40bGlvRWE5N3hPdDIy?=
 =?utf-8?B?OUQxWXJvOUFNVWhTZjRCcmd4QWZtQ0l2bnNUa1Q3UnBjanpGUitDQWhUTWx4?=
 =?utf-8?B?dmFFMEtqOFFvS1UraGJ5UEx4TXZqRWFzdHBWR0ptT3R2N2hWK3pVQ0VxNk0z?=
 =?utf-8?B?NG4rV0tuUVBVdk1Uem9hTGJVWExoTWo3aFN4Q3RqSlNuMW1EZkFaajNmdmp1?=
 =?utf-8?B?bjRpdlBZRnF5ajBwcnBSQUZoQ0RBRWVvVSt3SUJvakpMSG5LOEFNSGRRR2Nq?=
 =?utf-8?B?aXBJWHlPQm1rT1N4QnVhTDFRbnNoZWJ4aFJWQXlJL3N4Yk9PUy80SHRhbjkv?=
 =?utf-8?B?bGxWMlNKR2dUbWs1OXNzY294OFF3aGRRNnQ1STJYa29uSG53OUJHU25HdEpz?=
 =?utf-8?B?UU9mNGZIM1NMRUh3TjVLR0lEY2NCWDlNVzZrTmR5dEZ5N0gyVGhXdGdVdkQv?=
 =?utf-8?B?L09CMmVqYjNLZjRMcTlPOG1NTkdTOFpTK1daM3dxQWd6T1dCQjhyTVhxY0ll?=
 =?utf-8?B?cGhmV3Mvd3c4WkVhV2x5QW5KdzRzeU1OcWtWK0dDZ3k0VG1BMmcxSCtuVXNh?=
 =?utf-8?B?bVJydWx4emROVUxpWkJ0cFk3c3NGenl1TGVxVTBwMXpIeU4vbjl3R1JnbElL?=
 =?utf-8?B?WmFid2VoT05CRUdPMktUVjJ6RnlCYmRRbXliaWg2dkNHQVpvRno5MVc0OWVx?=
 =?utf-8?Q?OjIGT0a/gVqcOmZLpg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f594563f-bc55-45cb-d348-08df2ae66fd5
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:02:11.8240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiLXTsZAvdMKbHhZlp8W0g0VTsu4dNsV+hYH6nznwIjTCbG0NCe/sPw2DELrOr7NYrmHa8b1c8Zo/uqdaQRouA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8067

On 10/14/26 21:14, Pratik R. Sampat wrote:
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
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

In light of this series:

https://lore.kernel.org/linux-crypto/20261014132145.1726322-1-michael.roth@amd.com/T/#m43170233cc3ba3c53b319427b404564e2c8fe70c

you may want to verify that the guard() that has been added to
sev_get_api_version() is ok. Just a quick reply if everything looks ok.

Thanks,
Tom

> ---
> v3..v4:
> 
> * Collected reviewed-by tags
> * Simplify snp_alloc_firmware_pages() error handing - Tom
> ---
>  drivers/crypto/ccp/sev-dev.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1ed9e61a95cc..76698a7a1a3c 100644
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
> @@ -1297,7 +1292,7 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  	 * command to ensure structure is 8-byte aligned, and does not
>  	 * cross a page boundary.
>  	 */
> -	page = alloc_page(GFP_KERNEL);
> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
>  	if (!page)
>  		return -ENOMEM;
>  
> @@ -1306,14 +1301,14 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
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

