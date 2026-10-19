Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B754EA38C
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417773; cv=fail; b=sIiauJcH5aiAqWVoH2dVGJHIK2IK76RxcmCaN3+Rhu46gFxzdKALc9ncOxqJrs2IQtS3xx8Sa1o69IIi46Ba/zLEWfD+ruzf14rIrPv/4hOo36J2cBbmiczFMW0MDzhYdFzRUsRIxcZSjm3rxOLgVOlBZiIieRFEP9U+swMrElE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417773; c=relaxed/simple;
	bh=Ti8EHCWHW1LTz/QJmVdNdt29F+PTTvTZxT+NWuMDGKk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UYyLH9GEsFp5xdjjc0IH9xTaNujEF4MfZ2U5C2UaFo4HoGETja0snGZvhJ03e336ZH5o3ttwO3O4p5xXubbBuPUx4ZaNofIM/1W+OYLr4cs/SQyOQxUfS7fC9VIRPrs/92p9DLQyboayb7ea1vHEh3Ex5ppk2WLgpwERW5JiePY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=08ITJUE3; arc=fail smtp.client-ip=40.93.196.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="08ITJUE3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mqde8hrmYcXGMBJ05NOHWJEStn3GfrMKKSNDP2Hn6dIGWyAQ9tGpvOSBTBthzVxdYyUmlt3+FhuDQTKAPUcbeq8y8Ri7GP5qZbZMjFPQd3ouQbPsXuhJXjiiuzhRa4hMjA8Waoh+h3IR9WFhO4asCbNK4mBt49vgxpeVht4o0EjTZmhRgcvm/skgmVDOq9jt06WP9M2DM5KPHan4Ua7rTKCZ2iCvx4Y7Jx8VBwYUU2d6/f9Q39vHo05lukOZnhmK7Oz6b8jOs9tDazZ3zueIZgm25bLYdknDY7UVqtuWRiYq5UpzoGZlehrkddLbKGlQPhAam3U6042F4N/Q+YawGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC3SnbB8C8Eel7bwQx5hqlWnIEcKihJzSs2l0Bn540A=;
 b=V9SrgE/P/vm2Tv4a1WBnL+aZky//7pi13cD2gzlSzx4xyYKHgyLAqG5+6Zv7iViXWPh1Pnd8FxI8PigTQcTksC/akXn2piV0sYPn2a20YZtrxT0fA+2ucYhPV16k93P/Nn6Fqady6yJcd+hyt+O+3lRVs0IUuYtssJD4BmMxHfStjxelnEyHi56TtnFdhJc2rScfms7Bp0l93hC9mZp3uprm9uwMYNIFkmf6lPykc0+E6jCnyzOe4E3ONhF4q+sueH7ax6a6eKQ/C0ypd9cruyFa2VjXDStFhCCCRiKSyIW4ZjMy3hceGdHw9Ab7HTMtGIOrNrWsoyk6I8Vyqs/mBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC3SnbB8C8Eel7bwQx5hqlWnIEcKihJzSs2l0Bn540A=;
 b=08ITJUE31jWOk9v/MPoOfujOAiv4piDCK0JgMEeITKGCsJE6Ipe7mtKK+ngh1l2qo8qUFt2YvYNsMf5610eakjQyI7jEikWrQK6LQL8D/Vi+SkOGJvnPdwqsCY/Nca9bBn1redYfe4OhfNgDfzIIBHuM6sRbmkomwaHaa1N0qz8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SA1PR12MB8860.namprd12.prod.outlook.com (2603:10b6:806:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 13:49:25 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 13:49:25 +0000
Message-ID: <46ad9e56-e24d-4047-8aff-6708548d9a2e@amd.com>
Date: Mon, 19 Oct 2026 08:49:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] crypto: ccp: - Rework sev_ioctl_do_pdh_export() to
 avoid goto usage
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <20261016041109.1778673-7-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261016041109.1778673-7-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:610:4d::39) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SA1PR12MB8860:EE_
X-MS-Office365-Filtering-Correlation-Id: d27ed9bd-7ead-4d79-3a46-08df2de7c94f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cjywBykHPOSQ2ZzPAA0nOzhKTM1gEyXXaf/TRyljmyNuJxLeWSme7Hx8W54J0nzHdkjaZG/mkvf8PdICtrMmatJUfAWesbpcvk8RZ5r+dCjyp0Wkh4yMXl9mcwzziJWwLiYI8VSOP8k7FhmREiXZZ0n76a6cIp93z4K3Y/o7Xg0D5NPOghpycDxW6E/8gPnaDAImz9+9y+R4ecgkM7R9bGmgZJDb2/j+4pZVxQ13/2x2rOKtfbLFY6tniUwItd7urbZ2y0ZexI5QqjMMHZk2NwmdJ7B0U7eVIjEt8zFZpy65ir13SSacrB00hu7T22Dk9/sfq30X6XImzb8sG8ybaVirx8js4/817rxH0533IU9jRxpSf6nz/Yf/RH2fLwY1n2oSS26xEVJGqcq2N2dj7bjG86dO06Gg2Lb6FH7L0yB4POuxeKDCPhRuTXgtHhMGaWDqAdNeYKCtLHvWeTArYxTktX1ZSKnw9CxYE8T0xx1Y6AjOdpAi3ywSoIxeVaUD7v5Oxhneg25e0wmsQaHQAWlElcCrXhsLEdNB2m49+BBVOq0Ug1FLmRi485SceMo+wDqGz3Bcgs2l7jukl/hTTjxRg7caP/tF/GBcM9HsN9QJZjxONmadzjfG9aRnnxMMj50AaULdWCrvvg4/PrBbhoDOhv/XkR2oeZO1iPWQsDs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkN3NEx2RllQS0dpaWI1Z3VTR21NSTZUMWdwamlaU0h0MFovVkdwQlhIQTNP?=
 =?utf-8?B?NSs5VzhxQ0dvMERiQWJSN2wzdkJhOXIySWNTOTNFcFNVYWJWR3crY2Fjc1ZD?=
 =?utf-8?B?OFdQSXU1MXFVeFZVM3paZS9JaWM2TFA3UVpVN3BValllZ085TzVJS0IwM2FH?=
 =?utf-8?B?L3RUYzR1d2VpSTg0TFBjdUt3Y0JwTWs5dWFmY2FBVlEyTWJ6V2c1RUxGeEl2?=
 =?utf-8?B?dHVXQTJDS1R1L25qU1FJWGtMcEcyMFRzWWQ0WFgrSzU4OS9xYWljZkxIUnpE?=
 =?utf-8?B?cCtXNUw0MnpTUXdjK2tITjlicUdUVDNGQlBzaWVjTEJKaWh2VkNvWi9NSGlz?=
 =?utf-8?B?L3R0MWtGaUZWZXhWM3kvVVFrNHBOZEpBbDNHdWNFN1dZbVIydmQ1VVcrM3Ra?=
 =?utf-8?B?aUU3aUhRcHgyVnBYWjBVZ1ZuZDk5MVhQcWJFeDlHWmhHWmJsTXp3eGZXQXVL?=
 =?utf-8?B?RjNzMmliejQxcEYzbG5WbWxSdExvZmRYZTRnNFhxSUhiTG5ObE1CcnJ1MURz?=
 =?utf-8?B?Z3BmdjdQa3oweGpRT21MZkNpVTRQOUd4a3UyZURUeHZlb0hIVExXTnp6TERm?=
 =?utf-8?B?RWV2dlh1VlhmUjBnSmxPNm41Z0hib2NvWlRyS2xzN2ZGbC9vcjRmVklNV1Fw?=
 =?utf-8?B?QUR0M2RCMzVadlBLOUV1WXZvQ3YyOW1oYXY0OGJlVUlCRFBoTS96VWR4NDYy?=
 =?utf-8?B?S2swU0xzaHc4WUR1aGxrcWhDbWczVDRIdmVSb3hNazcvQk9QQk8xSHpBU0V3?=
 =?utf-8?B?VnlvcnJSbjRLbnBaaCt4dVBPOW80T2pndXVobG9Cd2Z3NHBJMStQSWRCb2l2?=
 =?utf-8?B?d09pc1pudFFyZTNkWERIMlZLdlpRZnFsbnJnR2tlRFlzd3FSM3hYUzNjd0RE?=
 =?utf-8?B?RXh2VU11aHlKOU52TjJadk9EYXBKY21yYzR4S0xHSzEvTHFscTNYb2J3Zy95?=
 =?utf-8?B?U1dmYVh2UGtvZkZYYmZ0Zzk5VVZSZHNvcXpQVHVKNFRncjZKazZ5UUY1YmN0?=
 =?utf-8?B?Z1E0SU1lVVE2RTFKSjhpdWFaV2x2WmtqbEp0MkgvNGRkOURXei9FbW5TelRx?=
 =?utf-8?B?bGE4RVIrL1E4TTQvNHRucFVkZm5JVG10RWpCcTUxMDlFdHJkb0k5T2x6bXhs?=
 =?utf-8?B?dG5YZjUvL3N4ekJPSi9ZRXB1ZkR2M2tZdkVXc0hJYitqS0lnc21JRnNwbTNS?=
 =?utf-8?B?UzlteDFDVEtncVZOd1BIcXFPc2wwR1Y3MTllQk5ReFlRKzFiOEhvbkt4T3lC?=
 =?utf-8?B?TkFLK2pQb1BiemJyTEczWk1JK2VXU2JKN2pLTFMvNEZDYU05RU00UkRYOUlw?=
 =?utf-8?B?QUlRM3dwMnNtTk9MMFFIYWhRZkx5MTZadDRuSkZ2M2tPY2ZFOW5YTUVVeUlk?=
 =?utf-8?B?cjhBRXNRT2t1L0xmWTVnMW9oOGZSUXFlZXcyVitHSU16dEVqSTFDR0dkYllD?=
 =?utf-8?B?WENDNks1blM1aGRyYXhybEJSekFESU1XTExaTVc3Rm4vWEFQWHpONUNmaHRp?=
 =?utf-8?B?UUdMZGNWSHAxWFBNMWswNWJXQUs2akxXRFM1VGZZdVdkeS9pZm9BZVREbjky?=
 =?utf-8?B?aXBjUHpuT2h3ZWVwb011MlhySWFUV00vbHRWQzNGQkV5UkFlTGxXZHczS3hl?=
 =?utf-8?B?dGc2Vmpra01jK29WMnhaQmFDQml6OUx5eEE4aVlZWU9NVGtTeWdMR050ampR?=
 =?utf-8?B?UFdVRHZncGdwU3ZvREh1cHl1WUFXOTFkdnRiNWJJRm0rMTVvSWJJUG5Mek5D?=
 =?utf-8?B?Ujd2RDhVcjVGT01xS1ErSGtDQ1p5VGZoeE9nbWJpb3NOT2NEV3VmN092Ly9M?=
 =?utf-8?B?VEhIdUpab3FEREpuQnBieS92dmo4L2tTaXcwTUJnd0psY01FMEFVZy8wTm1B?=
 =?utf-8?B?ZUNQOXJTNmt2RU9vN0ljcjllTjBCbS9DcFR0TFZMbjZpcFB5Zjl6bUNNMDhq?=
 =?utf-8?B?WDJjMlRNQU80NjZjek5ZZGRhTnN0R2VGREgzd3lBU0FaSDNwVGRqR29YTHhL?=
 =?utf-8?B?L2NRbjZUYlJmOXVWYUJqVW9keldNbXZnbk04UURPOTRCVmZ0L0d4Qm1yaGtv?=
 =?utf-8?B?NUcyY2xLTS9ETVJsTGJ2d1JFSlBNTmE2eEZYbS9tWGxwM0lRZExhSGFHVDVj?=
 =?utf-8?B?aGlUZDBJQW5tZXAyWVBtQUltaGkxS2NNMlRLWENkZTlwM3hCdEtPMkNaRGox?=
 =?utf-8?B?c25NZ0FqblphSllIZDNDL0MrTWVRVzl3TXd1MzByOWt3M3RNZlk4Z3dBUlBk?=
 =?utf-8?B?OVQzNDNpYWFWeWpvY2lFQ3FYQW5KRnFHd3Q2MDNINVNZNlF6bmQvN05tdHRG?=
 =?utf-8?Q?UCWjKf+j+Uy3qglp4K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27ed9bd-7ead-4d79-3a46-08df2de7c94f
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 13:49:24.9346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4pLS9vBu7XH/M3r6Kw67rrsJjGVkyP+aPpctvx6C+Hwc9d1pBayeeHMZE6gYY7zzw1MPNwIDygaO2UPD8hLTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8860

On 10/15/26 23:09, Michael Roth wrote:
> In preparation for switching the function to use mutex guard()'s, drop
> the goto by relying on an if block instead.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 49 +++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index bea3c30f00b0..4375c0480e81 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2451,41 +2451,38 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
>  	input_cert_chain_address = (void __user *)input.cert_chain_address;
>  
> -	/* Userspace wants to query the certificate length. */
> -	if (!input.pdh_cert_address ||
> -	    !input.pdh_cert_len ||
> -	    !input.cert_chain_address ||
> -	    !input.cert_chain_len)
> -		goto cmd;
> -
> -	/* Allocate a physically contiguous buffer to store the PDH blob. */
> -	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
> -		return -EFAULT;
> +	/* Otherwise, userspace just wants to query the certificate length. */
> +	if (input.pdh_cert_address &&
> +	    input.pdh_cert_len &&
> +	    input.cert_chain_address &&
> +	    input.cert_chain_len) {
> +		/* Allocate a physically contiguous buffer to store the PDH blob. */
> +		if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
> +			return -EFAULT;
>  
> -	/* Allocate a physically contiguous buffer to store the cert chain blob. */
> -	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
> -		return -EFAULT;
> +		/* Allocate a physically contiguous buffer to store the cert chain blob. */
> +		if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
> +			return -EFAULT;
>  
> -	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
> -	if (!pdh_blob)
> -		return -ENOMEM;
> +		pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
> +		if (!pdh_blob)
> +			return -ENOMEM;
>  
> -	data.pdh_cert_address = __psp_pa(pdh_blob);
> -	data.pdh_cert_len = input.pdh_cert_len;
> +		data.pdh_cert_address = __psp_pa(pdh_blob);
> +		data.pdh_cert_len = input.pdh_cert_len;
>  
> -	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
> -	if (!cert_blob)
> -		return -ENOMEM;
> +		cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
> +		if (!cert_blob)
> +			return -ENOMEM;
>  
> -	data.cert_chain_address = __psp_pa(cert_blob);
> -	data.cert_chain_len = input.cert_chain_len;
> +		data.cert_chain_address = __psp_pa(cert_blob);
> +		data.cert_chain_len = input.cert_chain_len;
> +	}
>  
> -cmd:
>  	/* If platform is not in INIT state then transition it to INIT. */
>  	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
> -		if (!writable) {
> +		if (!writable)
>  			return -EPERM;
> -		}
>  		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
>  			return ret;

