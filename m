Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9FE3F823D
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416843; cv=fail; b=LiRjrijsWT4/wj+644t9saL6OuSiPPQyx7JTWCM/zEnuAIzDFe9Uopz3nVYqw7eyOxUJDtt+sYawZqyDxFib+f8eXs1dIjvhe91lMjYl2gaB7Thh4Cd82swfGj/7LSuzr63m5oubASy2etI+77tKfa26cFTE25kptdgR2rONhaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416843; c=relaxed/simple;
	bh=Enc+B2Y+5WjXmmc9Gy3QEyr2f/6YkUv1JV9/R5KQzBc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XoRXNJas3IxO+XiNPwCxoPCYkv03xjujosvtVAPWDoR4ljkXHheiUdMYG5imWQKhctDIpxT7GHeERDblle2EFGKhDKhJZ2sSWH+yM3PaSMbdqeJ7j4RTosEiZwcDxzPNhZl3IB3YtX34ATtNCBVxjcaECsUxahezcoEy/Vcf4Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R4VSaUix; arc=fail smtp.client-ip=52.101.56.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R4VSaUix"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/DBjKMlFUPgiznn4thpVGJwa7lrryN95BX+dfntK65/lU2TfqqFWgosllTmzZflceEnVu7ofJZKx/enOerTQq7+2dpl7XRhyTouxrAQfADRLXSOEBkob+UzgCWuD4i8prvNml5f2H9m8q+3x9aFAcEeQuAUm9KKaeP3KrSqrfcxibQ9BbvCSp1AttG50GzmX2DAceHhT+3fHWANQ8tW7u6DxLNKSTcyTHjYyJkqDf22D0x1tS/6xALLYwSmKm3nqVezOPLVmPVDIVqMsTbg4UrVv4D5zD7xSh9Noj2L4lcnp3rJE50O2K7wmDuDCtAtetTewoAsvcPTbbtP05ipuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXO0J6twC3Z8K8N5pXhOTZU9siwXxOTEID6NdIwQ4VM=;
 b=swGgqvs75pQubyjigZ6Uk20Oe2PKT8HpYe6l7T0JD1W8XxVJIOKcz8v3U3z8cGY6PxGIJYxYx8FaJWmeSc+401JRFcRlG9SXBrL2E9gvmiGa5aNlfKpoLANOzPlSiABRE3jRktwmogy0WJqJUb1g2NGBo65rLku/rAHDjiSfdd0+FTP4bPIn183YNEaUWc+pTLpcm7DCnEy/3cUu0zndN78PSAPV3NhFj23TwImn0uNC0bNAMmo6ui4+DCu1CE6Riu9dWC+IQ73RHUinaeQnJugrYU9WCtxzt2YfBcuRAseUUoGYhffHWLQsq8JlwVp4i+Yhub5gkXjZXhWJahRA4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXO0J6twC3Z8K8N5pXhOTZU9siwXxOTEID6NdIwQ4VM=;
 b=R4VSaUixiiDTzEOn7ZcfwJIEayAi2XeotLgkIYvwLOP/I/nU88wd4oI/1L7Kx2fFXb7oykxy4Ys+XSO7RbyMkAscOz4UsuIfuuZfR1QUk/4e2hs8ftAPCfYje0IPTYIIKOMblsnKSya/m6uYrSwuAQq9QBIG+u3J52CtMPKHkcE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DS4PR12MB077728.namprd12.prod.outlook.com (2603:10b6:8:506::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 13:33:58 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 13:33:58 +0000
Message-ID: <dd27e24f-464c-449d-a940-6b92f4d2fbb5@amd.com>
Date: Mon, 19 Oct 2026 08:33:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] crypto: ccp - Use __free() handlers for
 sev_ioctl_do_pek_csr() allocations
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <20261016041109.1778673-4-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261016041109.1778673-4-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::27) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DS4PR12MB077728:EE_
X-MS-Office365-Filtering-Correlation-Id: 468c5cf8-65d2-42e2-1d6b-08df2de5a118
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|10067099003|22082099003|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	VH4SHLbMgI7QPlo23U3WMNck4oTw8DRVu56zI+lk9tCpxJnQnkvEyBaLBX4ICipm+dlN97RAnFT0SjKxcBW9WsZLAJC8Asx0RAEAYFewSQE0/OQfMpXn21NyF2LTO4wCfts/AfKCswyNX3elEFj55Gvwtq2cYK9utcLfjEbGuR9z3W8M4A5RTNCiL6iRdAsz5lpSMyiI0+xirY09s+vZLcH7iGgjgW8YKvW12Bc6i1W92nsJYZg6EaI6rvKNY1ZA/Ef3KGiT/r6e/kpkZkRNQ0dT5CVszurQ6VwlK0+HbUfY3GFC/da4LBwwvCEb8Vo0VWGEfONM2spZYeO4lP2jkcHNt6u3kqGeiZRe02FpJtfM7jIkPBATxdhhdlMusj4ksx7T9Xhpr57EkSZ5eBgqN8WDpS3+KfxMf1mDCAqg5LNW1ohwZGhf0qrXBw5zyT0lCsnXrxMSRwi9jGc9WEmBfnA5kBk+KHrnirwzZQr6LxPMlWDmQvT0J4bn0lLbCrkNoRBPtLN69ieuzySQP3EipzPQ6g8EtxG0DX/pAxxYEOqW/8kaDD+EslclSePPq3hLvojl+LAk0Cgd/DglQnLCIGmhf5RLqsJMaMeni/TM8Ojn6qZo5wM3hG1zGzV5eXZIS114r1oQN3o01DrWpNibym7X4++CfXxvm/4tAFZEwrU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(10067099003)(22082099003)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDlaazdISExzUHg0VEx5aXIxVm1la2RTUkpKZVRZZXk1NFJ0eEpRUWVjUDRB?=
 =?utf-8?B?Rk1kNDV2dEdTWTgyTkZWdU12ZzZGbmUyNWtxa0dWdU1mL1ByWGFCR1BKQlh3?=
 =?utf-8?B?ZnpqelFaeTJNTWtQemRUdTFFS2lGaERJczd2SVg4L1FvQmtrbnR1blQ3VWE1?=
 =?utf-8?B?QWt6R05VT0Nhbld4ZEtIcitWckNTOXZnbzlSOVB6KzFLVkdyalI1NEF5SERy?=
 =?utf-8?B?aGlacWNlaEUxOGM1VTY0SmVQWTJXK3VDczBlT2JYSld3VFgzK1MxYUFuWmlD?=
 =?utf-8?B?d0lPV3FpK05RTHJRMVovQ2oyaHdlRExZMCswcGFla3VBSEZPWXFlcm9NaFRW?=
 =?utf-8?B?SmJmNm1oMWJ5TExVQlR0TzNqdW9hUlZ3SVJyOGlwTmZvd20xTytZV3Z2Vm1F?=
 =?utf-8?B?NVVIM2syUklJelFtSmtURDlDbkJySDZxOFIrTytTbFMva3k4b1BZdUlFOTgr?=
 =?utf-8?B?STBNeEc0MmlZTnFxWG9SbEpHdHp2QW5kNlJ4dDFERStuWjBsYWlnWWNIMmZj?=
 =?utf-8?B?YzMvRlB4ZmdxOEpvbFpFR2g0eXI0SXRQWGpFaXhWVE95VXVPZnRsUXVUc3BI?=
 =?utf-8?B?djJ3NTBOVFpsQjdhU1lkTFI1WVZpTnNYU3RwcWF0ZmY2azQ3ZVdZRTY0bEFQ?=
 =?utf-8?B?YzBLUVlHTnFXOTk0VXRValBzRjMzMFJ4R2Z4bnRzV2N3cGtVVjRVSmdUNE83?=
 =?utf-8?B?OFkyYTF0cnZEaGtUVnViWUU1SHRIT3hDUnplcXQxcUw3ekN1ZW90QS9JMndO?=
 =?utf-8?B?N3FuTE1QV1NxUTg5a1Y2SEVNc0ZwTmFWdjZUZXBqeGRoWkdJOHdqNjlPaEdo?=
 =?utf-8?B?cXlialNzeFFvTWI4aHhSSnM0aU4vK0VyZ0RoY2ZkRTVKcm5PODJySjdGNmxw?=
 =?utf-8?B?S0QrY3ZoU3pycmY5bXZmRXZuRUt1WTh2MkIzV1BXSU9hMXJXWDk3cUM3WmE1?=
 =?utf-8?B?YTAvWTNidFZWa3BJK2l2L1FoRkhPaXhvS1NCeUlVVmsyU0dRd2syQm8xaE1G?=
 =?utf-8?B?UFJ3c0hOcElLUHE2Qzc5NjJqYVFxRVZBOHBBU1FIY1Zkbks1eXdmc1FRaEdX?=
 =?utf-8?B?UkdnYnlkdkc2dHNFUFFZSUtoWkdvVmx3K1V4dWUvZzNTT0ZISyt2V3ExSWVp?=
 =?utf-8?B?ODdSZkpJbHIxM3UyZE9BM1U3R2x0cE51MjNLUWd3UzFla2NrbWROYWZ2NC90?=
 =?utf-8?B?RHRmOVc1NFhWQ2pXajVySnRuQlJhcHBHaElUTk55aDRGbFJRZ3VrQWp3dGlt?=
 =?utf-8?B?V1gvbnZ1TWhDUEZBa0t3eFpGWmxLcnk0WkIwVWxHekN3NW1FWXRFSUlQd3FK?=
 =?utf-8?B?ZXpBYjVZaTNOam9EV0V4ZW1CenBvdnBSUWdqNzJTRlBCYmhKcjBkMExsYTJU?=
 =?utf-8?B?b2s2a1B4STA1M0htUDdDUVlEdXlyZWl6TnU2YjRySlhyRGo0Vk9xcWRmbmFu?=
 =?utf-8?B?VlZhWlRZa2JrcEhRUWowaGFsaUU1VkRQTmZOZlVQeDRhaS9jOFVnNVdGY2wv?=
 =?utf-8?B?eVF5a3ArclBPRDNSajdOendjMnpKZmQ4OXhzU2p6ZUtxbG8rbGxNMndEUUt6?=
 =?utf-8?B?NnpiMm1PV1MxM3RXRmwwK0hvTG5WVmdEczRFWHpLY0ZuOGExRVoyR0RKV00v?=
 =?utf-8?B?dEFQNUQ3OXZXdWxGRDVaVGVEUUJ3MFpsVTJhYW55SXVVVUNCWXh3NytQWlI4?=
 =?utf-8?B?aHpLOHh4d0V6dHY2Tmo1Vk5sYTJ0eTU0bkd1QjJkVmdCTjdQM29tYkZuZEo2?=
 =?utf-8?B?YUE0SHdMaEtuQkI4U05vR3dLUnNCY2lvcndGVUJ0czI3R0NVM3FpYzM1VlJV?=
 =?utf-8?B?Sm1ueFdXL0NpOUJSZjdENjZ2dkdPMVNhRjZubEZGdm8xUlFtQ3Z6Qmt6YzY1?=
 =?utf-8?B?MzhmTjdlMjF6ajdMMTVlSDVSWitMaXpQM1BoQTJRS1diZnpwYnRlcnR6NXl1?=
 =?utf-8?B?L0J3WFNrM2xmWjlwT1BGRmhVcjZtSDk3bVBaUWVicnplTVpWbG9GWm4vL0FY?=
 =?utf-8?B?WkljaGZWNWtlSjA5UmY0L0VSSEtuQXZSLzQ3VUt0Z2UxZ2h1b2ZsYVRlQWpY?=
 =?utf-8?B?S0hXbnczSGJiY1M3N1YyODZCTERmMm1RbnQycC9JVXZoRm9zT0xidUNWdjg1?=
 =?utf-8?B?ZjRCUXpHT0p6UlBIZlFyTFVVZ0tLV2tnejhCVWgyMHpLeXhnck1KYWRyZXRp?=
 =?utf-8?B?eVZLUkNjcGNnYnpnNFBySkg1dWZwaDd5Z2dtRzBzODRKeEYzOEtpR08vUEdD?=
 =?utf-8?B?T1MwdzhXUTRSZEFQaUg3MDlIMkR2cEhJYmFqVXZrRmF2MjJPdkNuNy9iK3ZG?=
 =?utf-8?Q?UZsnP9XeGkch5vnMgj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 468c5cf8-65d2-42e2-1d6b-08df2de5a118
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 13:33:58.5091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIAWrleVvMyD+FDTS45hp/LySgyNW9JLnmtoWl/hvc3sRfnzQUJIE20D/EDN0OlDdgBH5NHvhKA7f+qqvsIoEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB077728

On 10/15/26 23:09, Michael Roth wrote:
> Make use of __free() handlers so that the related goto statements can be
> dropped. This is in preparation for switching over to using mutex
> guard()'s.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ed60f3db391c..f6d06242184e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1986,7 +1986,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	bool shutdown_required = false;
>  	struct sev_data_pek_csr data;
>  	void __user *input_address;
> -	void *blob = NULL;
> +	void *blob __free(kfree) = NULL;
>  	int ret;
>  
>  	if (!writable)
> @@ -2017,7 +2017,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
>  		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
> -			goto e_free_blob;
> +			return ret;
>  	}
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
> @@ -2031,21 +2031,17 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	 */
>  	input.length = data.len;
>  
> -	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
> -		ret = -EFAULT;
> -		goto e_free_blob;
> -	}
> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
> +		return -EFAULT;
>  
>  	if (ret || WARN_ON_ONCE(argp->error))
> -		goto e_free_blob;
> +		return ret;
>  
>  	if (blob) {
>  		if (copy_to_user(input_address, blob, input.length))
>  			ret = -EFAULT;
>  	}
>  
> -e_free_blob:
> -	kfree(blob);
>  	return ret;
>  }
>  

