Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011014.outbound.protection.outlook.com [52.101.57.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8746638F65D;
	Tue,  5 May 2026 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777991847; cv=fail; b=Q2/O+j3tU0P4SfO6q34zZhqB5VHOC45J/G1o6gnO8989PyuJncZSooS6xnudxgw9J4V7srTzrWIHNQioHjUeoZ1H2+ASGqqawVXIlSB2yYMT6YxKaCpepATGuCWaITu4YWo6cnSnEKXAhowBiglyY6zj1Z2RvgSseYQ7bQkBzSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777991847; c=relaxed/simple;
	bh=3XEXObSrweUbJ+o2mMNVMDT18JpJM05CZzEFWbiYpKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vEmjZHA6AFm17NC3MflnITcwaNColdFTCj5Nik4KIfIsg0XDchdvPyosAE0ie0qKNiAs0lvkgov0V2zKFEfEz1Olx96X0AZohI1zRIK2Ub+9rd6ZqNKxSV+WG0uOMVZ7sxcjPcx2+KR4WRxetKFS7V7mMDo2RkRg3KE3p81i4u4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UuuU5+zK; arc=fail smtp.client-ip=52.101.57.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UuuU5+zK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=naHSy3idXXGlRluXD4GuOe2LKxwrP5INwfyHj4y5oLIaevqljshZevpfk4EH2eMzmbraLXywY+PyNXlQmIEmbVuo6ZvIZR06fotBP+xPAuc3S8g59/AHoYksAO/SjBIYSlCswrLCgorUH2USXNhzWWabvv4wuGz/W63NL3e0sMzry3zDbl7nA73drzI5w9cjGHBNyzCWBLjd1+0eg76qzbVz4+WfnN5tucqS1Fou250ygpBLbOJYiBFts/i3wy2gldlASO/15Ne+2LDYHOi9m+CmnyOnAv4nMF/p5sVrEZEtwOkO2Cg2jOYzyaZbywQ6TWCQ+TgTuxdLXD9POoKhGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIvUynMItvShJrfrDlnSlFATKRVpgqjzA6lhCAAfKIo=;
 b=vUarZ3V4Tf3xeMkc1ne0Oq5WXAVjo+E/kZvLRZECyaa7OIbWXx+n5zDK5kG5YjhgKVY2tlx9kJRwS8wi+v4+1rD/xIOmEEX4Eyb3QomrLPVRewF85abhgnyOr56fYs0b8k93n94zADYmksdpuNh5LnaRArGwTgI90Vy/ohc+5O4d1cxPedXl3+fPFcNYhjJqSCB5tjkZJrgcBcioVCxDpzeBf383Kd8BwYTyFKqDjDQdgtpzzBtHbuyFkdoz8JA5xraaJnL7qgfzpyO7zTlqyj79G3crmngMfEGmTtvmry4X5DlssIP8iQJoQqwzxMLhIC7fuZyvEBceia75HRj3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIvUynMItvShJrfrDlnSlFATKRVpgqjzA6lhCAAfKIo=;
 b=UuuU5+zK45O/hVPCf++mYsduAPCf1njon9VS9SMXL8XYFMMO5xDxIZJykLDBBmEA3h+JvJfcrkNHb5Lnoq3T5gs1cI7nQf6dJpTKglQgHXrq+vOhEnmzbM9CThZRbbUmzjtkspTm+MCZAieDRPHaPm5x9fD+nALOMKR2EBtFGZg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7449.namprd12.prod.outlook.com (2603:10b6:806:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 14:37:15 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 14:37:15 +0000
Message-ID: <16470f65-dd2a-420f-80ca-2b821d8a1f80@amd.com>
Date: Tue, 5 May 2026 09:37:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] crypto/ccp: Do not initialize SNP for
 ioctl(SNP_CONFIG)
To: Tycho Andersen <tycho@kernel.org>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
 Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
 Dan Williams <dan.j.williams@intel.com>, stable@vger.kernel.org
References: <20260504165147.1615643-1-tycho@kernel.org>
 <20260504165147.1615643-5-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260504165147.1615643-5-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: 32e5d6a0-8e7a-4e6b-3ccc-08deaab3cd1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CNJa9jyBTlugdI1acFr5OGHtstbXyhdAVqcLlOMtITuyt/usHkmp0j4d/WG+DrJDV6G9UJVd2JyLUi7+CjvBae1o6/rB9UYD5PMg+jICPS2Ff0jJ/UPtNXmKcJqDOwyWkrEQaATJhBytTXNIKTkloJl7cihERKrRbct5j3rOcPRlyhCf5Uy9tpfQET/hOCZPxA6iUK9mjYbwtgvvxea9lwCgRSHs83UB3ddmR1Ww/QGeMedK9hBouWiCSHENZ+bOS8tJLleUGE4omKk8vL7Wzv1Lb9k2WCfXZiHjNmtcUc7OskVFb9Hwcaj5XqPodugWFJnsC1S8h0983aW5P/Opbr3S1nC8mJpaWrC8tOhm2/6MqHipvoCb1LfuNdQHqrTf5tgcFk06QNFZIor/dRE+xbcHxexIX2rx1begDJ/MsuYduUPNE28i3/CtdOl4URCM03sddfY8LPq9qZkxS7rhbIJAOUR2RzfdViSSarc9X9tyb6BZt8yCExtOUstDmvHgQT0h4kgfRqWDte4t21GrJaHxv57P1j9P4DPiy06c0JdFMDE3myhbseZNrikuRgWqKa7yaHfCOP7zpXlZ2ekNVk8Lyr4cMiLe9ggdKnefBpZP7dJSMeJP0gsGS3ME9Tfjs6rWdpApyCA9S6eEtxmYYg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzlBRVZrV3VOUDBhN1BERkhiZUlTd3hvS3ptRFJqelNhMytzeTBZRWxMWjFH?=
 =?utf-8?B?UXZDaE1tRDdTdWo1MDhqa3ladmtMRnVFcU42MHI5RFUwTlhXVTVrc2RPOUlU?=
 =?utf-8?B?dXVLU053VUpDcmV3MXNKWm5lcDR4SnN6czJLK1hBdUtsUEhoTXFnTVlSdGRS?=
 =?utf-8?B?ZC8yMVlOZ0J5cStHaEZJUnFRQ01LcUxPckwzUWFrQnlSd2haOW5iZldsTWJn?=
 =?utf-8?B?aUtyaTRjUytRdTY3RFFFeS9UTCtBaGRWc3dCVVFFRFFVQ250Mk5mRlZ6YkRO?=
 =?utf-8?B?ZVphR3hES0xtaWxTZjdHMnZPbkNBN0dLa2Y3TmVxSlQ5UGJWejRpQjZ3NEVk?=
 =?utf-8?B?dUlQU1BYcVlJZE1MVWhaM0RvazlzU2JBT0NYVGxGU2o1MkJoRVhYcURCbis2?=
 =?utf-8?B?NFBHVzh6NmhuQ2llQ3I0WXVlSnY4Wkk2VmtocHZmT3Z0SWxUVHkycUQ2SjNR?=
 =?utf-8?B?SUk1U1dSb2drRG5MU1ZDS2cwbkFRaUR6WXBrZVkrdWFMaXpFYUdHanpRcTZR?=
 =?utf-8?B?b0NOR0JGMWhpKzdjdEFxR2JPZUdvZ0MyZXJ2UWNlejJQQXVxanZ5UHFoRFVN?=
 =?utf-8?B?aWhOdHhuS3hndzNPcUxBaFIwMVpRU1BMM1BQTHBYTW9kK0lJUUtJUkpxNWti?=
 =?utf-8?B?VEdsWGdkOHVsTXpjVlErMmR4QTlZR1grYnc2WkI1NXJmNXlsUXZ6TkpHejdN?=
 =?utf-8?B?eHE4a24yK05jME93bHlXL0kvcEJCaFN1a04rUysyN0Zwd2E5NTE0RVVtYXFL?=
 =?utf-8?B?eHdJNUVyTXFEaEM2QlFFMWhzNFpMY0hrckpteElVbEdQZDJ3dG5hZEROS3J0?=
 =?utf-8?B?V0xXb1cxbnUrT0pYNEFqWHpWNGJNUklLclRYQWxaamFsMFB0UmhYd1Z6ekNY?=
 =?utf-8?B?WjJoQ1g4b1JDSTJTdWNSOGFIdHg3NTN4TUJsSVlJSU9HUC9PS2Z4K1NNSFBq?=
 =?utf-8?B?MlIyU0RsWHNwQWR4TXdtQVVFZ3dianpPelJHUnN0VXZtOG4yUzhIRWVpVGtp?=
 =?utf-8?B?eTU0N0Uvb1dKVWhhV3ZVaTcrcnRleGhvanB0RU5uOWo5YXl2YytwdzhWK3Iy?=
 =?utf-8?B?OFNnUVhJc1RZQnBhZFNmdk0wbG5kV3hYdHlSb2dxSUQyeFExelpmRk40TUh2?=
 =?utf-8?B?UTVyZFhRNUxOSDU0em85dVBzZFQ5cTNKTldZZnZUQmlkaFNTOFUzd2xja3Nt?=
 =?utf-8?B?Sm5aYVB0amVEVk9Jc2YyRnpzU3NtMzhXQkh4b3pudm5vTFBLQnlCdEw1NnNl?=
 =?utf-8?B?ZFJHeXJmb0F4eVFNdUoxYkhTUmdBS2xSWmcyczBUQ0tCWHZhbXZDNjRKWFlK?=
 =?utf-8?B?N2h2ZWJYUFY2RUZvYVlYWkt3RnN0bzg5ekl6ZHYrNU1kbDlkVEcwZDhqbTZ5?=
 =?utf-8?B?cjhNYUFDQjZPdUVLdWZIS21lTWxXcjEwT3d0UlhEMGlMMjBmcWxueWN4VHZ5?=
 =?utf-8?B?V3FERUZoUCtRdnd5YVhrWU1HelBuS1RCdGtuTXozTmNSOEdnNU9OZjRFb3By?=
 =?utf-8?B?U0g3d1p6c2tZcWk4enhYR0NldDhJenpFbUNvVjFBRE9CWmdSS0xJbC9VaUtF?=
 =?utf-8?B?M01NOTBzYlZlclhUSjBab04xQjNyc2hZM1dpU3FpdlBwcG8rUTZNSDQ4dGpj?=
 =?utf-8?B?a1JkZXRvMTBURkFqTk5XNmJ5UEkyNzhmN1RYRm9qZVQvYzJqdzA3Vm5wekpv?=
 =?utf-8?B?NkYyS3FOM1R0UWpxVmp5NlNSSllBNElNNmpCSTNMYTFRS0tJTmp4QWJRek5i?=
 =?utf-8?B?VUJwL09Qam5GUCtncHptR0ljamw5aWZpNjVRNlhsMVY5bGI4NHdzRjgzOHZu?=
 =?utf-8?B?WlZjMkVVaU9tR3lMbXJKNVdBS0pmSTY3M29xcTdnZWpTR2pQcjk1ekd6NHVG?=
 =?utf-8?B?V24wc29lZDNsN0ZpdVhaVjVVbFBjTDd5ZnBtY01Ldll2dWppVWlTNVZLYmgr?=
 =?utf-8?B?M1JQVWU0YnJtUStpQW5KRWdIcFNCTlJZbHg0WWRYUzB6OW1xTmJLZ2ZvZlRF?=
 =?utf-8?B?ek5sL2JKNkdNbjNyaFBUbEFTK3d0R2pkWG1VMzJhOWRCVGhYVjI2VkszVlZW?=
 =?utf-8?B?VW1nV2w5Um9xakJML3RzSlo3eHJrNEFYZ0s5RjcyQ3FEbnZOQ09OYXcvREZi?=
 =?utf-8?B?OStKTTM1WnRRZlE1R2E3d1RxTkplb2VPRndiV0pnd2FyYkdyM3M3VThLTjNn?=
 =?utf-8?B?M0RsSDF1MzlUbEFCbmxRbXZEY2VoeW92QXIzYUg0azVJaEZvcUFwdFJHNGZL?=
 =?utf-8?B?UC8rNC9pZDgvb2xXZTlGZjhGU0pZaGFIbkUzbEFmRXBndVVNU0VxbzBGbldh?=
 =?utf-8?B?S2R2MGRWYXlWc3RybmM2MVRzWVY5U0VUUXh4b0YrMkF5c3EyNmVTdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e5d6a0-8e7a-4e6b-3ccc-08deaab3cd1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 14:37:15.1751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAP9icTM1YrBYMrYoaRMVTDABJEg38/RQUTV3GNwi+GoUkp/87r0rJLOiFLgoA+TFgSnmjYZBUFaUq8LNQH+Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449

On 5/4/26 11:51, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Sashiko notes:
> 
>> if SEV initialization fails and KVM is actively running normal VMs, could a
>> userspace process trigger this code path via /dev/sev ioctls (e.g.,
>> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
>> execution for an active VM trigger a general protection fault and crash the
>> host?
> 
> Refuse to re-try initialization if SNP is not already initialized for
> SNP_CONFIG.
> 
> This is technically an ABI break: before if SNP initialization failed it
> could be transparently retriggered by this ioctl, and if no VMs were
> running, everything worked fine. Hopefully this is enough of a corner case
> that nobody will notice, but someone does, there are a few options:
> 
> * do something like symbol_get() for kvm and refuse to initialize if KVM is
>   loaded
> * check each cpu's HSAVE_PA for non-zero data before re-initializing
> * once initialization has failed, continue to refuse to initialize until
>   the ccp module is unloaded
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Reported-by: Sashiko
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> CC: <stable@vger.kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 33 ++++-----------------------------
>  1 file changed, 4 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ad6c2525a305..7c4dd57fabb9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1727,21 +1727,6 @@ static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>  	return 0;
>  }
>  
> -static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
> -{
> -	int error, rc;
> -
> -	rc = __sev_snp_init_locked(&error, 0);
> -	if (rc) {
> -		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> -		return rc;
> -	}
> -
> -	*shutdown_required = true;
> -
> -	return 0;
> -}
> -
>  static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
>  {
>  	int state, rc;
> @@ -2451,8 +2436,6 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_config config;
> -	bool shutdown_required = false;
> -	int ret, error;
>  
>  	if (!argp->data)
>  		return -EINVAL;
> @@ -2460,21 +2443,13 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  	if (!writable)
>  		return -EPERM;
>  
> +	if (!sev->snp_initialized)
> +		return -ENODEV;
> +
>  	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>  		return -EFAULT;
>  
> -	if (!sev->snp_initialized) {
> -		ret = snp_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> -
> -	if (shutdown_required)
> -		__sev_snp_shutdown_locked(&error, false);
> -
> -	return ret;
> +	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>  }
>  
>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)

