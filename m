Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81995502795
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985038; cv=fail; b=Ijg6SU7NdAe+AnHylBBzO5mQx2/0X4ZHxx37u7EniMYqPCe3qRco9JyodhZVFghZ+3PzlOD3JOsmuuInNErTWETmr3doVYJZMKAxLzIHfjrBEMRaN8H7Z3IPN5qwIY+lLO/bBHmoX5JB5WCE8UAS7/n3ZrojMXrYOlzvG7fhMEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985038; c=relaxed/simple;
	bh=ImQLBKetpFG9k75nOzpf6wNVlpFmueamiolve0qNxvs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kk2iQz7LNAezX65znqdXlrF9Nb9dF4aTgUv+TVZc+Y/cxM8LADf9TfWaZh+M3QDnWeE/Pb8fJKJLkgw+MdBSsVxcynlztYkkpYDqFljyd4/gI8hzWDZOSeohMalXigb0sJSPfO4nZH7nnm92ixxRgAvo7uOn8jXZy4mzGzlNnmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T96pT8mY; arc=fail smtp.client-ip=52.101.53.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T96pT8mY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ixOLOU9w+MdHjIndet1EmofTOe3V1AoVUGwQwO7gFcck/Pyot8pYxG1ctBmWvE7QL4nK+EKyvjddrHcX2HMqUN4AcfoEmxnlbXNaRWmd5cNvyASC4+QNWb0IaZvHu29TUffQT27bRWasVcqSCr0F6b6RhzaI2CLnB+062TE8uoUhekMMqAgufVd5zerzGmTHrhPRJuOQ4e3gVXCFPwk81UrIIYzDrceKlbXofZpII4mc0+821XIPxphK/N+aRRQhrz7yNqeGeoO6mVlbXlBpS0MgVVbB9CKf5XSuhVlj7QWjPkcM3gzeC6WGIYX+badZcUIied8pyc3EZ+HKHisGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHCL3Efzn4GOJB1kqyqYvoGWrMzr+Dfj581KyXZG/80=;
 b=VQTs8QPWbmM3q8zt7KcVpRx/nTyk/yZMrWMJtpLiCRQUVfmdzNWNl76ThctKz7xH1HkCY2m7iU1hoTViLw43nQp0aXYni3EvmaEduhsqj1fMnYpHW8dPeVELfM2K0Q21sXkbb/kkYcnG02qlVWjKy02yXKTxVYwLyNizEP8pUeGLf5USQRrm+vhKea7dGM6EGalRokvcG7OJ2J2znCQK7G74b6Xbnvon9zOaWMTWv8NqaUL1jb5bga6SDvIdXDuX1Rcvbb75bN7gvHKZeVTDHlANq0dMeYH0OWe0s+6SjP4hoib0L00KL75E1PJHWolVHsLMmFMF1p051dNg2Ui/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHCL3Efzn4GOJB1kqyqYvoGWrMzr+Dfj581KyXZG/80=;
 b=T96pT8mYfO1CxKmofYijYyORk41bsXG2Z7ZbsndOCCRJ2073u5NAUD5IRy5jbzrB4qF6G7mdWptXF63YJpYaoPDaHnOfhHXAAzykeCqNbK7iD/oT7Q62LeE6gM8vMB5tqSpZ2sP9jQPWj4Ix/g/IT9ysFDNimEd7oa457SH7PdU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by IA1PR12MB6354.namprd12.prod.outlook.com (2603:10b6:208:3e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 13:37:12 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 13:37:11 +0000
Message-ID: <6ff1ff1f-6849-4d1c-9232-ea8af465c606@amd.com>
Date: Wed, 14 Oct 2026 08:37:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] crypto: ccp - Shut down SEV firmware before copying
 to user
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261014132145.1726322-1-michael.roth@amd.com>
 <20261014132145.1726322-2-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261014132145.1726322-2-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:610:60::20) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|IA1PR12MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e7ac6d-0d54-42d1-b34c-08df29f84019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|56012099006|11063799006|4143699003|261009223027099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	LgN4No2YTzDwcgBchX6Gjm4jdsonoHWFKk0xdSq/vM8EbFeOvCSmms2cdyHxh9c+ugBQdsSfFkglT2kVRWXadSBHxiyCH0mvXZXe/jV0grOdhU4u3vLA1OH3i3gGRRV3Pcbs8yyh/bIvZEXGrBCwmEqL/dbk/tF/B83eduKbbIeS5CslRCbbcSmDhwexUZfxwHFh6I9023MsO+00XTBk04/3LYhmunziTYhqe3fBjij5Q8s9ZV2CaZ+q3YwVQLZLik6EFcGlG8gtwijh8dpz3r6rrOnAJZ3L3ICPXQ1BQWTO3oDCqPHeKzpkPm1ktBlUeQFwHXXMeOtT4QAffSR5Ijm06MWfNYGn4R8IVCTyBsXkSJQng4H2GMoudxCQxkZabr430iS37iMJj4NL+6VP/k18NXzcDUagSoOUOUguNZ9iDaAkXnvBbMJbo2RhKIaaFQUqUBprlLh3EYhqS9I+ZcVwrXrJS2aRhbqtVGV2qeGmHCnt+w/pxBtabg4k0ljxfSHmhBT5uiY4AgX3EGi6Le1yshzprneBDFR8o9JLuW5SnPWwlUjWsKSizTxsAzj9wcQjxoga+HmxhtW188ybJTw1R3mOnoP9JSoIvIt4017umKF5xgZDB1Iizl5T9Jsleq4giSPF2cFwnHKmQ4oy0yPQkyYnZs3DEy9ouZpi0lE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZSsvTVlGaWJzYkgwZWRuQUxmSlRiYWNMcjdZVG9NUG1IcTFjejhqTEE1VUpS?=
 =?utf-8?B?emNRK25CelFvUVh2NHZtNU1OdnN2Y2pZQ2JvckY3VHNtWFUwdHlPWGNBaGV0?=
 =?utf-8?B?SkNHRS9VMTdUdnMwWk1xMkhUTEZUUGZDUEJjVk8xREV0RWtlUFNJV29SWElG?=
 =?utf-8?B?N1hXcVFKOCtYQnVxVEtaMDkxYUFyM2pxRWRrWTRxUVF3RmhvYUtnZEFZM3Z4?=
 =?utf-8?B?TlBqOVVWU3FaRWM4MkdpcWZsYStkckpNTjM4U1MrQi92dWUwY2Zrakd3Sllv?=
 =?utf-8?B?UFdEUDZaVVNocUpVUnFrRG1tSjBPQVlrYm5UZDFFSXM0WmVTU0VJYTE1UURa?=
 =?utf-8?B?Tk90bTJvcE5aYys4OWNKUW41Q0tZTm83eXFQMGY5dTM5OHNCQ09GNFQ2eXhY?=
 =?utf-8?B?ajhxamdubllCdHdQWG1xdmhZcVJMT3o3cTRTMVVQRVgxeG1kd2xjOE9mSlVU?=
 =?utf-8?B?NitjbmtiWmJZSjR0RGp2WG0rVmQ4N1dQYXRHbDZPN0MyMTJaYUxKNjZsVmxh?=
 =?utf-8?B?MXBwakh0U2F6WEhzendmNHVvcjFrVkw4Rm4rdFJiRUh1dEQzcll6MER4RXp6?=
 =?utf-8?B?ZHl3TGpyUGdUYXhFMXJ2TS9xQVB0RmNqM0lWeGxVZ0hpV3FoUVJUUExFekgv?=
 =?utf-8?B?Qzl2UTJwcXhCMThKUzZ4cmhpN1kvaUJxZnNiVDQ3em9aNEtyaWdSMHJzeHFz?=
 =?utf-8?B?NGg4OHpBTmxjd1VCalFoR2doVHkwZUFaUzNVdEZ1WVBvbFRibmhJaE4wWmxz?=
 =?utf-8?B?aWhOdVNYV1hVM2M5aW5MVUwxZnhYREFlZVNIWDgzMEtKeFBsSFVnbVlCMG9J?=
 =?utf-8?B?NWZQbk81NHNZT09wYlhueGJHVnRZTWhXdkl2ZXlBdFZ2UlYzNEc4RnpEUUIx?=
 =?utf-8?B?S3RkeHdFd1MwTVArTjhNdzFoRlJUZ3h0QVRJUWxKWVJtNUtWa2pEYUZWSTdZ?=
 =?utf-8?B?UDYya21yQUJ0QTFIRGJoZHZvMnpDMTZuYVRDQXZUUDlzR2xvcjd0dHp4TEVm?=
 =?utf-8?B?SEg5NmtmdHhKRHh6dGdvSHlYZlBhQnp5L0g1dkR2UG1RVm95d002UTNRT09n?=
 =?utf-8?B?VSs2ZXh3dXBxaGVFdmxGeCtpK3VUakxQRTBsQjd5ZFk2SG9XN0J4YlF1Z25C?=
 =?utf-8?B?WTBBR0crQnZqRVVGVVNmaEdmdzd4dGdMWmd3VFBBUEJnT0p0a0dIbVhCRHlk?=
 =?utf-8?B?RzhIaVVTRDE0VERWcTdHdVRVeFFjTDlUQ0JsRGFMWFphc243TTFTc2JwTkRu?=
 =?utf-8?B?QTZNcmNmMERCRjZNNXgrMmx1Z09jTmNYOUNteWxCQWF0MC9HL3FXdkZrVjVr?=
 =?utf-8?B?SkZ5WE8xdCtVOFlJQVZxTmNqSXE4RnpEaWM5MmlONHBUWjdGbllUT0hBUThn?=
 =?utf-8?B?SDZnNDQ1VWdkcjYwQnFVSDVOcnlBZXV2MHB1UkVZSGtnWlk5UFJ1T3NXbUVX?=
 =?utf-8?B?a05QRlRNTkRvZ0FWd1d1K2ljZDRTNmNYaGgxTHlLMlNxVDR5VWVWaWJLZmRs?=
 =?utf-8?B?Q2RTejcwZWwzZVhHSllMbk1NRkh3ZHNkOVZtQ3A5Z3lOWUxpRE9BUzl6ZlpC?=
 =?utf-8?B?V2NEVTYrZ3ZWdzIwaGZWMFlRd2wrQys5cjE3SThhaTJyUHhoQlBENm9STUpP?=
 =?utf-8?B?eWNoUUJqNXBrZm1yZ09ienYzQ0tKTXY5dkhUdElHbjlmbGVpUDAvWmZOT1Vq?=
 =?utf-8?B?QjliZ3VSZlBxSGpweG1KU0QrcFZHT3hMQnIwMkp2bEtYWWp6STBqZlRQOGp6?=
 =?utf-8?B?UGRja3BtNi9YcXpNd3M5ck8zWlNwUCtoK3FJbHFlUU1Fc3MvWHF5akJHaHAr?=
 =?utf-8?B?S1Vwa0ZRTHVHNU92djV2Mmc0QTN5N0VvYzhmcmtMcWt1dUJKQ0kxWDhhY2lC?=
 =?utf-8?B?TTQ3VHVMK0tBakZuMjdoSDhoRlQrM3ppQ25ORjd6MU5HTXNqRW1nQTh2cGN6?=
 =?utf-8?B?U0FybUV6Ynd1MTJRdFFpTHVrWlpoQURJbS91WS9FdU9XYWdvYUNuVkxoSjlN?=
 =?utf-8?B?bG5UZi9GbzZaSmRmcVcxUWxWcHpiak0vaWlGNklHN0VKdUNBVWRLVEtUUDB0?=
 =?utf-8?B?VGlYaUFkbFEzQWFvUjlLTVpBOXBLUHl0eTdBSmdLMC8yVFkzbTl6NDJBbWIy?=
 =?utf-8?B?WU92VlQrRGZYM1J6NzF2cDZ5UEJkVE54OFcxbytTVlVyNVlqczRaWnNCYm5M?=
 =?utf-8?B?Ump0Z2tTNUprMjV4MEl6N08zTnRyQ1hUSUgrQ2dPSFEzQXlNcTN0OW91VHJr?=
 =?utf-8?B?UHlKN2svQzhpendmWjhzZ1VYdnFNODhEMXJnN1g3UlhQaUlDY2NrUG5SQnpt?=
 =?utf-8?Q?takanL1XLd7BlA7cVM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e7ac6d-0d54-42d1-b34c-08df29f84019
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:37:11.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u4dYkhgJlk5PuptCRIr6pKKlD9tIg2HUBn2jPuJBOw8BPPz31fJwVB5MEkybtMKpbQEpUMiAkLstNomEO4WyHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6354

On 10/14/26 08:20, Michael Roth wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> When servicing PEK CSR and PDH certificate export ioctl commands while
> the SEV platform is in the uninitialized state, the driver temporarily
> transitions the firmware to the initialized state, executes the
> firmware command, and shuts the firmware back down.
> 
> Currently, the firmware shutdown is performed in the cleanup path
> after copying the command results back to userspace. To allow
> releasing the global SEV command mutex before copying results to
> userspace in a subsequent change, the temporary firmware state
> transition and shutdown must remain grouped with the firmware command
> execution rather than spanning across userspace memory copies.
> 
> Move the conditional firmware shutdown immediately after executing the
> firmware command, before copying the output buffers to userspace.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f833cb7e4da3..7de3b6bf71e1 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2022,6 +2022,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>  
> +	if (shutdown_required)
> +		__sev_firmware_shutdown(sev, false);
> +
>  	/*
>  	 * Firmware will returns the length of the CSR blob (either the minimum
>  	 * required length or the actual length written), return it to the user.
> @@ -2042,9 +2045,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  e_free_blob:
> -	if (shutdown_required)
> -		__sev_firmware_shutdown(sev, false);
> -
>  	kfree(blob);
>  	return ret;
>  }
> @@ -2505,6 +2505,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>  
> +	if (shutdown_required)
> +		__sev_firmware_shutdown(sev, false);
> +
>  	/*
>  	 * Firmware will return the length of the blobs (either the minimum
>  	 * required length or the actual length written), return 'em to the user.
> @@ -2535,9 +2538,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  e_free_cert:
> -	if (shutdown_required)
> -		__sev_firmware_shutdown(sev, false);
> -
>  	kfree(cert_blob);
>  e_free_pdh:
>  	kfree(pdh_blob);

