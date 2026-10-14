Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A8457E4A
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986692; cv=fail; b=MPlTAgoGLTGeFslDIJjCTjGrLU/RZ2G8GbJ8ckY6ct74vC6KbwKnqejpQumBVaqJf4Ikf7Xs7kuQRujFMla0MDEviKI38htbJmRrlR/c/gx8bW72W13CrOyjoTgamqPsv24Xy5fVAjUyKu27D9IDFKnkA5oMfVhEZZP0hRgz9Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986692; c=relaxed/simple;
	bh=2JPxk/OWHaDqkmjmnUXl5R3XtRZ1jKwvz6vSd6O6Tjs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NL48Ms1sJySYRRZHlxhhXFBEgYFDGyUSA2NLKU9ECR1BKuSU4k5EtdmO3XL7zOxvrKq/8/jcbOzaX3pyph4UzIfiKv8y3+DopJvDyXTXmK3OgFN/Qx2PzyTvBI+PABLIsSaq8hVYhg1cOR0RUGQ1h2bOqa3ljWIK3e7X+euK6Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jUaTFDIO; arc=fail smtp.client-ip=40.93.194.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jUaTFDIO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQ5rXTnNRYFWi+yvoTAmn4AQFmbUTlWNo5gXJtx1AWvzFXCq813r51bhM7QSV9d8kFkizSImMoWRzElXhgti0hgDwDnB6zAtUegc8b3XcQLBgjxXT08+4k6BjQCxUrxz/b5kZ1doiLFBauwJxhwpoHZFVirWl+1QsTEmSt+PCqSYcB/B8IaehgkI9wN7LxPVdTyNjUGOIxSHCKy5G0DR++Y4BKMUYXfZ9DDamXz7WrYGBT+IIstOshaEOBHLHCBXZZXNJ4tn7xRu4/Qh9ON2hgf3nznevQu9FwlXLrZCmGYL7jC1rmJjPET84frceDdjcQ4/9eFGQF9KxxewcsFUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qFgMUGoEGk71DiMiS7V4/tzksCjiMnDFYgnK8iL/cE=;
 b=dMN2wFqu+D7ZcXygubTPQwEcLTZJRxbCdsTwelVFUALwWyPsEcIVhk23yDxfXTgECSS4UrwjoaANfT+uQR5aDBTvcDfAIk+gjmBW9d121FUmbhXSc3CMVxntU34jqaEXfDAVwqGn6o+bYa97wjv3zQ3/IfExCMju6MIxHhO+163VthP6aawKHv+AZxoWeXHhv7nju9x9fGVlS3WImBN+ohnnwi155naceiX/6DQc15PW/4jL6WJsJzEjDt1uCRWbnit4aL0P+DXd27ECpkd9ZHxPS/RXK6GfcyLhnkVdCVxsc7zIHX92McsQ1SEZfsYdGpSl++zB6i8Cmsc+k0vGyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qFgMUGoEGk71DiMiS7V4/tzksCjiMnDFYgnK8iL/cE=;
 b=jUaTFDIOOvyKwgMhC/uJbu/4RPOQ5VjjiuQlFoJSp0DMLxwAWbjQBC90HiTguzW5LsCW48g5xUOz65YwDdbs9aDBRH1uu4sVDnfZ6GCHfXDT7DZPVaBH+lMxPz1wLsAHhLYydWEFCT7bMYOiRdrf2GL+pFn0Zh5QrEKPXXWOysw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SJ5PPFFA661D690.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9ab) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 14:04:41 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 14:04:41 +0000
Message-ID: <552abfdd-fc3c-4a46-9595-bcc05146f3c6@amd.com>
Date: Wed, 14 Oct 2026 09:04:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] crypto: ccp - Allocate status page outside
 sev_cmd_mutex in SNP_PLATFORM_STATUS
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261014132145.1726322-1-michael.roth@amd.com>
 <20261014132145.1726322-5-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261014132145.1726322-5-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0145.namprd04.prod.outlook.com
 (2603:10b6:408:ed::30) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SJ5PPFFA661D690:EE_
X-MS-Office365-Filtering-Correlation-Id: 891b7607-c0ee-4418-08bf-08df29fc1747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|11063799006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	L09IaVa/DSR2aW4ccYKB6+Vbcaog7qfKzV3Xsw1PlyIOMgayJxJS94FZmvvowaHcTNJ1ffLS7iFae9LTpEwUTaJBSL1jAyRCOcdfb3LgG8KeIu8Pv2H3k2N8/XHwZAPLr5NA331E8gAXziZadq8VUzRU7UNz1jugr2Rz9oQoe0LUIm67a+bJ4sCwXtTHRJzTfijjmCsjYLdofI9Uh5kyRsKSDptMy7dxPw2bGKIG8IJSi0eJ3nlEY+3AHnWMDMUF4fqLFxGUvb1Au8o/X6dWKSvaY51JCRAvr4uQoz6lIUEyYivptdXJZhfHgRlN3C5aXm52cVdveRySjwnlQggs2ErLQDym80kyWhU7vnV1JAw4NjmOueEeL8RgnIH8lKZ5L9eFx0nuqMRYnI5UvfBDDBTP6rdusx5dx55AeLber9hBiw7ndmQOT/Yrkh7vjzQd26hAry7p+eCpiaqQPpSkO7GW+AUQ9lCKEsrBxohoGkLqKYHLRan5awXtPQCPU90Qj+kqqa9CG4J2GmTuQA97q756/rTgKvrJYeaf+ozHSwoa0cJqaQmMatZV4BHt12qcoj7Jbly8avckGDc0qKbk9vVv5QI4tuxkz72RcfXIeN7poty/upCflS5d4aqDcAecbBRauFQzd85fNzP5gDGQoVA9b1o/bYS8/6cm4vFrxuk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTRuNm52VnBQZ0I4amozY3BDazgzOC9yMjlpU3oxYk4rSmlQY2VIZ3p1SGtv?=
 =?utf-8?B?TUFIeXpWUkZUcDliUFJkU2QvY3YxY2lOUGI2eDdRc3NMejFEZUw3cHhSTExF?=
 =?utf-8?B?S3RlS1dSalpiSVBJRWp0NWJwSDFITy9iSFhqSFNzcXJpWElpU080NlZYSGhB?=
 =?utf-8?B?UHhOR2VZTUU0ZGxaazdGd3kyT0gvT1h1YlhhTnI4T3doNW9COGo5UHRKQkUr?=
 =?utf-8?B?emNRVWR1ZFcyTlVwQXNZL25kRHBLaDZ3MDhxb0hPNzZJN1pINnpqN1dtUXN6?=
 =?utf-8?B?dG9wUU01Rk5EWXdiWjhGSHF0VktDblJ1UTVpWGhJNno5ZEwrN0hCZFpTdklH?=
 =?utf-8?B?bGxDaDdxZjVBdzd0UDlCNWZ6TmgzcUdueDJLdVI5VU9jTXdldWlxbnlCUHYz?=
 =?utf-8?B?dlkzSnFXVUhVUDhlRUtBR3dTaWpNMll3aWR6c29PZzRsTUkrRVVvTzJWcERF?=
 =?utf-8?B?OUFqN0JPQ1dMZkdQMWVoS0x1aDY5SHg3YU5NWG8zMC83L3QrOTNLWkFNd3My?=
 =?utf-8?B?aVlXd09xeHFWVy9NT21sOGZkeG5vbEliUW43VzF1TGNYdnJmZGd2SklZdjlF?=
 =?utf-8?B?M0wrdlJnYS9zNklWWEtuaWhEL2FNMlQrM2pHa0FLSHNQY2xUbTBnakE2eTky?=
 =?utf-8?B?VHQ3SHJwbGtyYWdFU3pPNm5TTUFaV3B3UnIvc0VjTTFOSnV6Q2dwdFlZTVBz?=
 =?utf-8?B?blBDZmV0RDA2THZDcVFCbXJ2MWZLNys0M3VRVDE4YkFWaUFWajVSWE5XUEhn?=
 =?utf-8?B?T05EM3lBZHdSUThtTWlHaytPQTY3WlVRV0xFdG5remk5TGRyK3hSeGZwbG5F?=
 =?utf-8?B?aGxIbFNjMExMWWhkRnRJNmtkcnRHeFhyenVXOHh0b0RUTndqSUlObUxYR2Zk?=
 =?utf-8?B?c0Fya1RXWUxTVVd5TFk0bHRRdkZuS1NMQ2dnUlBMbnNoVEt3RnFFTExDdEor?=
 =?utf-8?B?Y2h0U3JpZnpDQWRCaUdFZzZYaU5nMURGMmVkanB4OGZhdU1PTGVMRlF4b3VM?=
 =?utf-8?B?Q09YdUJOOE55TlBVOEF0ZStaOU5lMHlWaVdxMTdKUEhENHlhbE03UzZGM2pi?=
 =?utf-8?B?d1BEbU9UZ2EyYUpDbWptVzJDYVhpQnpFeHl1RUt5TytlTnpHZ3NJSDRwNUMx?=
 =?utf-8?B?M0tCOTl2N1RwV0FCSjYwMVNoZUVtd212dmp5R1k1RmM2MW1HWmRmcG4wcmww?=
 =?utf-8?B?M0NXSjV5NlVWMzlGdm1hUUNVdzFtTHAxN0Ywc1dNZmxySnlBTXlUcXNRbzF4?=
 =?utf-8?B?bnR6Ly9xaS9OWm82SFBYRlFKL2EzaWUrWHNYcG5nTVd1RHpxaFJkcitKWFhQ?=
 =?utf-8?B?NEpoMjN6ZW1UdkxoRG8zVS9uWWlwVnkzMEQzYnVHMTZraWVXWTltS1lFL2Qz?=
 =?utf-8?B?WjNtQ292b3JvbmtzWmRtYm16Y203YlIzbUN3bmw4MUZvWFR2WlIvb0cySkwy?=
 =?utf-8?B?WG9LRXltZ0c0SWVCajYvUnhGZGtkeUNHUlYwUjdxK3Nkb2NpZG1CYTJyT1hn?=
 =?utf-8?B?K1RJQlFpUGRSa2RiNkRQV2pYUzRncHEwZmEwNjIvRTVMbFRsTmg3eHQ2aXFl?=
 =?utf-8?B?eGdITThlSEU4MGg2VUZNb095N0NaZk5VYi8zNnVVVXBIVHd6bXlpeUVMZDJI?=
 =?utf-8?B?cStScEFvQWN4blFCUHFydWwvc3hSNDJGUHFpSlZGSDdPZkJEY0htWDkxY1JV?=
 =?utf-8?B?SDUyRWlXemxCRHJDcnVZSHNEV2ZhcWlpejFmYUcxUzJtM2lGQnIvZGVTdXdy?=
 =?utf-8?B?M3ZhK3VoSkdDdkFEcG1lZ0RaNGNFT1RhMnlnUXh6SEJCK0pLejBCQU8rdzlo?=
 =?utf-8?B?S3R2WnYycEg5VEZrNlVMUVAzMEx5bGFBRXJqanZsZy96T04rZGFDNW5ML0tQ?=
 =?utf-8?B?aDQzZWMrNzRvQVZJdWREb1N3RjZlNWduM2w2Q2oyazR3KzQ1MTJWOURjS3hG?=
 =?utf-8?B?eVBIV0F1SWppdnVkeUlDejhpdUduZm5vclJqVlBLYUFVUFMvMzI1OEFPWnpT?=
 =?utf-8?B?SVVVNUQ0bWVUM1BSb0FPRWpVMVpBSjFjbm9lQ20yRUh5bXUzelFoT1c5bVcy?=
 =?utf-8?B?SVZaT1o1WkJzUXJ4a2lxQ01jcTdabEkxbFJINmhiY0ozcDJqMnA0VGhkdnEz?=
 =?utf-8?B?MjFTUTJwdWdQeWdSU2czejE4M09LYmMzRm1Nb3ZSTlhOSjhyczFmMmxrV2lV?=
 =?utf-8?B?Z2E3Z2s4VUhPQisyblhwaFVON29zUGpLVENSY1p4anVGTW9NZUNSTS81c25F?=
 =?utf-8?B?WFI1d1BVU25IZlpQbEFoT0tIS2VJY1FHY3VaTjNlMXR6VENLM2FXaXpDNkxk?=
 =?utf-8?Q?Zc5Jgd4Gpqt5hmYa1L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 891b7607-c0ee-4418-08bf-08df29fc1747
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 14:04:41.3462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dItU2zbqlqB6A7PC8qkpEakEykJC13bJ4/l/OQConwHdsEWGpyK2QEfZuUwpBoNZwchhXcoNMl70rTHFJbabZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFFA661D690

On 10/14/26 08:20, Michael Roth wrote:
> Allocating memory while holding the global SEV command mutex
> (sev_cmd_mutex) unnecessarily blocks concurrent SEV and SNP operations
> across the system if page allocation stalls or triggers memory reclaim.
> 
> Rename __sev_do_snp_platform_status() to sev_do_snp_platform_status()
> and push the sev_cmd_mutex and firmware call down into a new routine so
> that allocation/freeing of the status page can be done outside of the
> mutex.

Seems a bit complex. Can you rename __sev_do_snp_platform_status() to
sev_do_snp_platform_status() and just put a scoped guard in after the
allocation up to just before the "if (ret) goto cleanup"?

Thanks,
Tom

> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 60 +++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index c8c229a6757c..37b948a81bc9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2554,20 +2554,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> -static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> -					int *error)
> +static int __sev_do_snp_platform_status(void *data, int *error, bool *free)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_data_snp_addr buf;
> -	struct page *status_page;
> -	void *data;
>  	int ret;
>  
> -	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> -	if (!status_page)
> -		return -ENOMEM;
> -
> -	data = page_address(status_page);
> +	*free = true;
>  
>  	/*
>  	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
> @@ -2578,10 +2571,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>  		 * Firmware expects the status page to be in Firmware state,
>  		 * otherwise it will report an error INVALID_PAGE_STATE.
>  		 */
> -		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
> -			ret = -EFAULT;
> -			goto cleanup;
> -		}
> +		if (rmp_mark_pages_firmware(__pa(data), 1, true))
> +			return -EFAULT;
>  	}
>  
>  	buf.address = __psp_pa(data);
> @@ -2591,19 +2582,45 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>  		/*
>  		 * The status page will be in Reclaim state on success, or left
>  		 * in Firmware state on failure. Use snp_reclaim_pages() to
> -		 * transition either case back to Hypervisor-owned state.
> +		 * transition either case back to Hypervisor-owned state. If
> +		 * for some reason that fails, it will have been added to the
> +		 * leaked pages list, so indicate to the caller to not free
> +		 * the page.
>  		 */
> -		if (snp_reclaim_pages(__pa(data), 1, true))
> +		if (snp_reclaim_pages(__pa(data), 1, true)) {
> +			*free = false;
>  			return -EFAULT;
> +		}
>  	}
>  
> +	return ret;
> +}
> +
> +static int sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> +				      int *error)
> +{
> +	struct page *status_page;
> +	void *data;
> +	bool free;
> +	int ret;
> +
> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> +	if (!status_page)
> +		return -ENOMEM;
> +
> +	data = page_address(status_page);
> +
> +	scoped_guard(mutex, &sev_cmd_mutex)
> +		ret = __sev_do_snp_platform_status(data, error, &free);
> +
>  	if (ret)
>  		goto cleanup;
>  
>  	memcpy(status, data, sizeof(*status));
>  
>  cleanup:
> -	__free_pages(status_page, 0);
> +	if (free)
> +		__free_pages(status_page, 0);
>  	return ret;
>  }
>  
> @@ -2615,8 +2632,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	if (!argp->data)
>  		return -EINVAL;
>  
> -	scoped_guard(mutex, &sev_cmd_mutex)
> -		ret = __sev_do_snp_platform_status(&status, &argp->error);
> +	ret = sev_do_snp_platform_status(&status, &argp->error);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3114,9 +3130,7 @@ static int get_v1_svn(struct sev_device *sev)
>  	struct sev_user_data_snp_status status;
>  	int ret, error = 0;
>  
> -	mutex_lock(&sev_cmd_mutex);
> -	ret = __sev_do_snp_platform_status(&status, &error);
> -	mutex_unlock(&sev_cmd_mutex);
> +	ret = sev_do_snp_platform_status(&status, &error);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3131,9 +3145,7 @@ static int get_v2_svn(struct sev_device *sev)
>  	struct sev_snp_tcb_version_turin *tcb;
>  	int ret, error = 0;
>  
> -	mutex_lock(&sev_cmd_mutex);
> -	ret = __sev_do_snp_platform_status(&status, &error);
> -	mutex_unlock(&sev_cmd_mutex);
> +	ret = sev_do_snp_platform_status(&status, &error);
>  	if (ret < 0)
>  		return ret;
>  

