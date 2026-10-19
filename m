Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96874310784
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417242; cv=fail; b=TtiRlAC8ade8peFjuDinytv+WxrHhK7MM0yTY7RCnyK4QS/oE2EX2bQDrAvGpsOe/lkjnAxOvSyvBSXoE31xQHxW2dk1xKZP2HUt35LXVK6lPNFjAbmnpW+qM0WsomNePZI564m8WF1ycZK1Nxxl/yZ8mA35L9b/MJK/Qx7qPPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417242; c=relaxed/simple;
	bh=yND4ugS4uON2ABOh/DJgqKOi2CNH3GBpmgOwyO0xUQE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZOXKhQ5e3aCMZsNaFuIXO8pJTaOuPkl8HjahlZ+RZqRjO0UDjNhU4Ccv0lCp7VwMS24g+MSHRhw2Nu/8JHUIMLRwJ+pZrwFXYIoYmbOOG7raEoxkMpBPp1zH/Upon92uXF+32rHn4k5r5ekw06bc0FLMNtWwQnvmtqQspoMIidM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MdiAc7rd; arc=fail smtp.client-ip=52.101.52.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MdiAc7rd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtiAHIIxUuYxvf/VUY/oa42XcrtNDaNCKT1tXz4MrsVcf9GRKbtif9DfsD/jgWcN7qubR7fOgoG/IiZjHimvisSw2DXwa0NYa5Dzldt+BZ79x8EqSPi7qmobxwfsDCRbMqMIRiP5aADdq0ddnIsV4P1V7GFaFpk9KkQwGp+rmAONlObyn3AU9uGZOgUuf/oJ60QyHZXo6THb1ye+GOKPioVWDJb7LHGYOmUym1m4Ufac71hzQo13oxxFjV19mB8BATHq2O12cIfeQcSEeoG/mwHhkCDNqIhSQcyJSGzIpDEOaHwJd6LNDYOVxFCEkEZ3kLT9pyk9AsVEIFzVGxEZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2283xINtielyn4cRUm/r/lfbGXTrTeW1FMdEFgmDP0=;
 b=SHZ8nhg5ikJyflHXEYqhzpNzCYz4R5hu40h/+gl5YIhMVaobfkEgivuPB8imjT2DllxYkG/Er4e0puukG2Y8vReRYTlkvhyMW0QTcj6Oerr1KeroWeYotrAIMcmTNI2nbyQkOUW7tR01olqSp4cI/f5yGtDzLvM/wZttE0scDwvjWaxELiXE+Kvx8+FbEC3GONFNPMSW8JW8REt7xwwkeBCHKVSvGJtN5Bcb6mfgqyoJ0ejb95nRH0Fy+Y8gYCWwDGR6Qu1CO1LqTGiZ/nMjtIJ/alFbFBg7HryJYiRYs5j/SHKizutj6fk62TJzpb/wMaRoVnD7nKFASt/D8GaSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2283xINtielyn4cRUm/r/lfbGXTrTeW1FMdEFgmDP0=;
 b=MdiAc7rdN7O6MtIaFFOktCwy2lC+9DIUXs6UUxmPc+w8Oc0k3UmwCnoyDBIa0zbjUa3u2PG0lrMVCry1iI1mIYAf5BLBzEAWRxZ+FlLfWaD+UTLJ0qG+DLTeXR1tQlE6j119GW/9KOc0e8QG3a6p/3fWCVI07FKblPfOub25K3c=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH0PR12MB5677.namprd12.prod.outlook.com (2603:10b6:510:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 13:40:38 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 13:40:38 +0000
Message-ID: <cdecbc99-9ae6-4f0b-999b-8e01d6925f1d@amd.com>
Date: Mon, 19 Oct 2026 08:40:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] crypto: ccp - Use __free() handlers for
 sev_ioctl_do_pdh_export() allocations
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <20261016041109.1778673-6-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261016041109.1778673-6-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0441.namprd03.prod.outlook.com
 (2603:10b6:610:10e::34) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH0PR12MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f7cf27f-a9be-434e-ef84-08df2de68f39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|22082099003|18002099003|4143699003|11063799006|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	dmubTvsFiKJcdQyD3DGozzYCaWLCC+PEeqPuUyWJmGiphgUUP8T5tDNuRg3AViEmXzPQ5FQPaCwNSVjDUw/JenWd15vqX0VuVIx414Rntu9FnkeWBOtdl9TKoT93A2SWu0MZH5zbtIXfSHvZzynUUPisshSCat2WJgmLv5AGpUMdq+6FKs1JG2dEvanZnRZzAnZWS6vTQXGzhfzLZB/s99ezsIBqyQu/zzZmNEcZbnuCEntfWxb1re/1S3jwOUbenvz5ZnUhs/uuqGVFyPa0msyIncEAfEgyH4Wl7WGopnnbV0u6RjTOLj4Q4a22ptbzw+UxYVJmL3gPexyzzZ4//PJw8FBsyjwHOqxjRDpgJToUG9C56ZdtjYD32Ec5F14fWSbujeCxLCMod3H95evnYlAiFXuTFRPPFwsGjDDampLi4JWBbUD0Ddpj6QywZFlmRq+/s9W0HgVR624fhemG2mNFnagWl1IbLSLQ654XIiKsRGbFPJ4qLC/hvT/YZknh42EYq03vbtAN2v369oqfD0U3d9H/y9dXdoPTdLJ7FjHH1c8V9dOY5dWAjka260N3/BM4dsCBMIQGLYfP8Qx9T17FK/uqR+8VmUtoAKryjNgrf52L2rhgGHxaBsMoCKFeHoPhxDKFq4BsV5MLiWfVqp/LndN2VxoDTomz9jMRrhA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmlxL3NOYnFhdWQrSVJvN2ZiVENXM0IxYU03cjg1bmx0SFV2aTRYZlVtUjl5?=
 =?utf-8?B?emJPQjY4V0VPL0JqeWc4SENGRHFIT3BINk1VRjRyaWRjOURPS0dWSTE1ZjFu?=
 =?utf-8?B?K1pDNHJFbm1mWlkrWDNqZndoQ01yK2I1OGl6aWJXRXQyczZQbEdpa3czbGdV?=
 =?utf-8?B?bk9nT3NsVnJpODYvNmJCMzhUMU5ja0lyV3ZDRWF4SEY1d2FDcm5naE1meWdu?=
 =?utf-8?B?dzBCdWhVeC91WGJmTlBVRkFSQi9BMS9tcEdJb29OYmh6OCt6T0lSSDk5RWJn?=
 =?utf-8?B?aGZkS3FGN0FSWS9GZ0lrS2RXMXorK2dFNDIrUmVyUEEycXUvZVlBZkFoMGdM?=
 =?utf-8?B?SnR4cTlpZ0hDNmlpeHdNd3c5NkJZMUtqR2VJOTdGeUZYMXkyeVRtQmc0MldV?=
 =?utf-8?B?L0dqbXY4dmtlTGc5QmYxbmVYR3RKcXdoM21uOHZvQ2x6MzNQVlVzeVNYVUsx?=
 =?utf-8?B?M1ZMK3J0RWhwcUI4b3pIaExzdHU1Z2NLTFlFTjV1REhTS3VITVAvVzlHZ3RM?=
 =?utf-8?B?akpORGV1T1l4VXJIRVppR21hWitENTh0ZmFYdTVHRjd0VktnanZaT2RZMnMy?=
 =?utf-8?B?T1dyeUJRL3o4Q0FiYmRURkx3anZacTkrTUs2SHZvNGVwbk5DVm9mWlBKMjVE?=
 =?utf-8?B?dGJPd0VnNFRZcVVKb3h1ZTRWYjhUQzkzTEQ4cGUweVo3amp0MDg4TVFtSjQv?=
 =?utf-8?B?OE1tWUVYVlRLODVUVjhJL3FVd1lTNUloakdCVDZmUW1iaEF6eDFNbzIvZnVF?=
 =?utf-8?B?ek1nK3NVZUxldmNhLy9OUW1pYlpmWVczODAyUGJNc0IyRk1MMGNaTVhUd2VN?=
 =?utf-8?B?NUdaMGxiY3A4d2YwVS9WdFFtQy9xL2xZZ1BENU93NHMxTXF0V2hTUlFPRm9L?=
 =?utf-8?B?SzJtT3pEci8wTGV3UFRDS0hHMmpEcDRoNlZwR2w4dUFtVzBUaGppdG1mYjQ1?=
 =?utf-8?B?WWJaZlBidnNlcTVsYWhJQlZGcWk0bnl2d3dvZzZtWktlemRqSmpiOW5LSDJD?=
 =?utf-8?B?TjlFZ2VaOFRDNGovc1BmY21IOVdnZWRFSVRtaTQ3RjBtZkVsZ240MUZZMDRD?=
 =?utf-8?B?bktrditxT0xCVGZHL080UjhKcUVRRkFKTHR6RXl3OW1kM3Nnb2VYMU1WMzk4?=
 =?utf-8?B?UTlnbVJKWVdnOVl5ZEIrSmdGcVcwMkxITVJ5L2xMcHd4Rmc4SzBkSzNmc1JL?=
 =?utf-8?B?Q25NeU5OemptTmw0RGxQTUhjWmEvZVhsN2NXV3QrUkNlaFp3VE9WNy9oelYy?=
 =?utf-8?B?bFNsMndtR2FLRy9BMWhOa2w0WFpZb2lkU3dFM2lpZkdPWVZIdDZLZ0FhenRM?=
 =?utf-8?B?NTZDSklLOHVvWEg2VGgwc00yTVVwNGwwSG10RWU0MkQybUY0ZGEydUs4YWVo?=
 =?utf-8?B?RnJ3OFYrbVVGZU9JMUFHdFhLU2thNE54NnpJMFZ3WkxQOW1CcFlWS2w5TExT?=
 =?utf-8?B?dGEvNDlTUXlwb2x6Y1M1cmNGZ0tCWmFJR0s3WnFtMmVJSk5FQndtZG9FcWRZ?=
 =?utf-8?B?aEF1YldoQkVkekttMHp4QkdzV3RjWU1idk1Oc0ZwU0lLQUc3SmRzNm1FNVlw?=
 =?utf-8?B?WTFFc09HWHlFdGpmZkNCOE4zcHZvb0RFamVYQUJnOGlMTkNVUkMrQlBRY2VT?=
 =?utf-8?B?KzRJRVRoTjhYRFVzNktyeEdocFRmeTFTVGFjMVFSSENpaWhPaDhIRjZYZ3hE?=
 =?utf-8?B?Y1JndzZ5ZFBrRDdXZHpxTHJ1bmo3M3JMc1pXN25DZW5BRnEyVGpRU2p5QUNB?=
 =?utf-8?B?R0hMQTNGQVU0OFovcnRhZmR4bzdtNE5XOVRMTTNJYmtiRnlrU0tHMW5oZU5T?=
 =?utf-8?B?NXV0YmdkTWhTYXJRWER6QkNmcW9pcVJ0SVZpUDBGc1h2bW5ia2taS3NaVTAr?=
 =?utf-8?B?eEg4RFBJKzdGOFY3UkFPOXJ2WmRybVc2S3dmN1pjOTVwTlVJaXVMRGJkWlI1?=
 =?utf-8?B?WjRVTHNxM1U1Mi9WbDlqVytBYTVRYTEzcTU4L2dqalNIMHhhV3FhYXRYMExj?=
 =?utf-8?B?OTJVdzFTVUk5MHBXRzNCYlJ0UkYzOUhUYTZRYm1lYlBKR0dVUmVFRjVqRFhl?=
 =?utf-8?B?V05IOFhCNlJVZXZQZFQwQVhCeXNUSmhobU54OENUMWRwNFRkUEgrMGcwcjE0?=
 =?utf-8?B?Nmprc0hnSVo4bW1OVk5nSGlCeUJjVjBQdlo3d0IzMFFQN25GNm9YUWpOdzY3?=
 =?utf-8?B?N2pJRVBueWpOTi9TbkhqcmNrVWVKRFJJQXBHaFl4TlN3SWhhZnljU2VTcHhG?=
 =?utf-8?B?ckVWdFBEeFZwSFJiM24vbGtPV3o4VXlITVJGc2M4ZEhRUTFFVEdySE1icVl4?=
 =?utf-8?Q?dpSCoBBK5z3JeGFUF6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7cf27f-a9be-434e-ef84-08df2de68f39
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 13:40:37.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4jl18SStiy7rGKDB8JLAU35SYdRoM7rfEJn4+YGpNAckYjB+rAO523qn4Mx2V9K3up+lSubKDBYlHTMFDWLtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5677

On 10/15/26 23:09, Michael Roth wrote:
> Make use of __free() handlers so that the related goto statements can be
> dropped. This is in preparation for switching over to using mutex
> guard()'s.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6b483bdf0f0f..bea3c30f00b0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2434,9 +2434,9 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>  
>  static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  {
> +	void *pdh_blob __free(kfree) = NULL, *cert_blob __free(kfree) = NULL;
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pdh_cert_export input;
> -	void *pdh_blob = NULL, *cert_blob = NULL;
>  	struct sev_data_pdh_cert_export data;
>  	void __user *input_cert_chain_address;
>  	void __user *input_pdh_cert_address;
> @@ -2474,10 +2474,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	data.pdh_cert_len = input.pdh_cert_len;
>  
>  	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
> -	if (!cert_blob) {
> -		ret = -ENOMEM;
> -		goto e_free_pdh;
> -	}
> +	if (!cert_blob)
> +		return -ENOMEM;
>  
>  	data.cert_chain_address = __psp_pa(cert_blob);
>  	data.cert_chain_len = input.cert_chain_len;
> @@ -2486,12 +2484,11 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	/* If platform is not in INIT state then transition it to INIT. */
>  	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
>  		if (!writable) {
> -			ret = -EPERM;
> -			goto e_free_cert;
> +			return -EPERM;
>  		}
>  		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
> -			goto e_free_cert;
> +			return ret;
>  	}
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
> @@ -2506,32 +2503,24 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	input.cert_chain_len = data.cert_chain_len;
>  	input.pdh_cert_len = data.pdh_cert_len;
>  
> -	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
> -		ret = -EFAULT;
> -		goto e_free_cert;
> -	}
> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
> +		return -EFAULT;
>  
>  	if (ret || WARN_ON_ONCE(argp->error))
> -		goto e_free_cert;
> +		return ret;
>  
>  	if (pdh_blob) {
>  		if (copy_to_user(input_pdh_cert_address,
> -				 pdh_blob, input.pdh_cert_len)) {
> -			ret = -EFAULT;
> -			goto e_free_cert;
> -		}
> +				 pdh_blob, input.pdh_cert_len))
> +			return -EFAULT;
>  	}
>  
>  	if (cert_blob) {
>  		if (copy_to_user(input_cert_chain_address,
>  				 cert_blob, input.cert_chain_len))
> -			ret = -EFAULT;
> +			return -EFAULT;
>  	}
>  
> -e_free_cert:
> -	kfree(cert_blob);
> -e_free_pdh:
> -	kfree(pdh_blob);
>  	return ret;
>  }
>  

