Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013071.outbound.protection.outlook.com [40.93.196.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9F0384CEA;
	Fri, 12 Jun 2026 13:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269557; cv=fail; b=KU6TViH2hP1MVpKzrr9UxI80ONWHy7hSM8za5FlNN1KiQz6bOe14pUqXrQ9nlrmN7GfItWxXsNX5rrT+WVI9LAUKmpzvR3hnZl+/WJchHGgYxehCXq8IlQyfXxHBu6XojTxrZe05cu7TZ9qVJZwpOuClzDSs7owndBNNn3u5kys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269557; c=relaxed/simple;
	bh=W0caUcqxL7/QYr9Ug/UGY4yhg1JMJjG/cmTOgxdgqWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PBQQjnVddtQo7QS5qTLzggeIAoqqarntSKmNV7GCgIH7EqHNDBXB24svtF8xPS2VLnT6KSOPbW6vcWg0A+y3eXCkWSaM3Dqpa+osMIalkdCd3qSJdMs5zgySR4lnYuJFhPfR2LIz22z8vwoHmmhDTwqxPmWrJV+zTagoF6BxoZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZhRemTFw; arc=fail smtp.client-ip=40.93.196.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZhRemTFw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uILgr91hM9J1TUJSim8rDVe9lo6AzbY+tPq4B0H7K/hShIZkSVQTX3bFsvSTrJkhPwRI1EL251sBeXVKa4i4zxiy/L0CFcJzNas8oL7Drf4f051qigHfdSo9iL+q1Si6BrBKRu3tT/VPm094/VM6N0GrhrHunmzJxzh/aXwGnrM7N8YWynA1qAcaNi8+rN8XOz46ok1vmr1mEqqlcFZlALHgWuuicj0aN9n4mjEwBOCWtdEmAFHujQkOZbVVcf1T2MRapQrIvRBVe1tMZruHFzols06tT7CxjJuk0vZVRGBoV/0PLcI1CF+2Y/+iNPdHe4nR4+6LSFtLcie1/G5zRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QH2RpaSv+qHEF6p3820FRThLNvacGaw1B+hKqwFigRY=;
 b=isiTUwoUpXQQuc19fkCqot3RYvW5C4gqH3ZJF84QNqCDiFyXNr9cvK/ce2Bnr3FOPevhv2p2IHwIdz9xP4SYR+5i0gZcaq1gfPtGPZGsGNp+LWzSmdnbPkS1EW5TDblfQJl5M577nGZRS2jNue6w9cgE+jZNq8FXVnVrZ5ja+zc/AVetTrtjeQpWaFFKQSWMAHsygDGVaYJI+vCQFxt+NyKWkDXnkwwLlJ8oNLXGNJn/YKu0PqjsuyQS8spemIZS7EJdjB4NL80ADXCV8rDyD7JTnAQnT8vgqIa/BaT6EMh5CZ4cGHBvahO2PoNAN8TAivfsRJt6DCyudYSxwtXkvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QH2RpaSv+qHEF6p3820FRThLNvacGaw1B+hKqwFigRY=;
 b=ZhRemTFwO3/mW/QfhRWaR7c39bbSu61k2LCYswWZPJMTVIVKJsW/9dHTQdMADfodJ62028iuAeK4GCkAFvgyrzGKj7anI98iZXbi/FLPd9rzyaJd39Y63ugVQDkyw+AD9O7DXsJWic3yb2+iA0Qx9nHHoaOveBNoIegxCdMZjwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by MN6PR12MB8469.namprd12.prod.outlook.com (2603:10b6:208:46e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 13:05:51 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0092.016; Fri, 12 Jun 2026
 13:05:50 +0000
Message-ID: <bdad47f1-8c70-4847-8ee1-4fba180d1f58@amd.com>
Date: Fri, 12 Jun 2026 08:05:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Fix SNP range list bounds check
To: ZongYao.Chen@linux.alibaba.com, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Michael Roth <michael.roth@amd.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Brijesh Singh
 <brijesh.singh@amd.com>, Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260612092525.1203150-1-ZongYao.Chen@linux.alibaba.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260612092525.1203150-1-ZongYao.Chen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::8) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|MN6PR12MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f27902-2a4f-4235-2752-08dec88353be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wuTfJUR4mm8awLP/83m42qGGSkhUeqYF2CT7DoCzb5yaLoWTeorghH2dyLb/JmG5lUICWr0PV6HeWUVYAV2TirPH837dU5gvrsrYFwnznHu7q5RZhVj9Cz+k/RdihioAEro2zd3E7dfHY+DvTH16jvqBVKHljdMYXMl0JDZbTSR5IAPcCFPdwldkDbOsgOpjxeBa46cm1wiZR/ma8oXfKzB0DfzGbf7C508yxNAGm2jIAqrf6NIblLwtDrujK0xKN468udhPk+crGLI/NwM1lLCT3kfdIUe7yoC3RNf8UQtSsvMYXzQCgp3MyosD3u0q8U3T+XYwDC01bNvulLYnF5mcWZqjHZNQK/a6CybbCicm5h0jwhh4kPl++Vj9yrPn9VvMZ8HL8FtlF77Ky42YK5nuDGMpdwYU72seCw8IYUpgvJ8QGKL8pCfimOJOuvSXJ6nRWYxKUKM+zu4Eehcljxg+e7JIVZXYV99wCS9eOyHaX/bmKIbK1KvSGrZhM4RYVZ5o6evtv2RSMb70/95wxhDfhjwj5Hbe9kGq79rpDIMrUfOxFqVqEXTCt7nWhsjwxcPqs+KSbzMeqPoUqqe+BBN/db2xQojGfUR4JYd3V2S5afLNg4aXBxd/y6pHrq1JBQ8BQVbW7JsWc5Omp5FZT0E0ArdHpr970uxY1CSZk7rOzo8h1zhPm0OFEyZinGri
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDIzc3IwN1kwbGxkQXBsVTBzSUtDa3ZyaXUxcThiWkRwaUVLenZtcVBGSXhC?=
 =?utf-8?B?Z0xvT2pxUVBXSFlDTHhmUE9nRm9VcWRvY3UxV2lLd0kxTFJCZDdsdm5SSVhv?=
 =?utf-8?B?YzlVdmJQbkNEQ3lyWktSMG5PL01sTmZrR2RlM3dKT2hacXJLY3gzeTVsd0Fn?=
 =?utf-8?B?L3YvNWI5V3ErQU92U2Mzd1h4bkMrWkEwOS9EdGxiVDAvWCtCM2tNYm03dlNC?=
 =?utf-8?B?Y3o2Y3dpTlIyeS8rb3hRNk9YQWNIRkE0WGE3NzVSckJtdkttSUE5ckUwNlgv?=
 =?utf-8?B?dndvOGloekEycFEzdUlpWHUydVBBSE42MHA1WUJ1M1RxNWxHOXBadG1IeHFa?=
 =?utf-8?B?bjAxWHErV1J6eHRJQkpudmxjeC9tUXlodFpTUENuWS9YNWVBd0RFV1dmMnRH?=
 =?utf-8?B?em5rZHFnY1pRSUdDUnFJaWFXbi93OVd4TmFqMlJnMEtXa1o5Q1JoYm8vOGlR?=
 =?utf-8?B?WVZvelNPTlJtcEJTZEdOa2dRSUEvWThYQm9IcDU2U2t5R21xQjNHbXo2QkFt?=
 =?utf-8?B?bmt5SEdXOU5yWUxNTVd0QUlFV0dtaFFhRHJmZ2lENkNzNkd6cDkxc3UwTW5v?=
 =?utf-8?B?SmR4cENtOTNweU9PRHA2T0lKT2JRL1B0bHBsdDZWNW9hK1RydUhaNG9ldDFW?=
 =?utf-8?B?ekZ0UVVBWVJOUVFxYkhkQmVNb1ZCODUrVHVsZ1RyZzVWOWJsZFNvL3BodFZQ?=
 =?utf-8?B?TXd4SFhGd0FNMy90bVYyUStJU1g0Y2hnK2RKQzZsYkttUjJWSGFNVk0zVjhs?=
 =?utf-8?B?UXgvS3padUtKRHFhNiszRGpDL3V0Q0k4Ry80RkllNWFma2lMd2NiUlh2N0t1?=
 =?utf-8?B?NFFabllCV21UZ3hBMTJobEtDc2xHSTkvSG9VRWRidmVvQlRrUGU1TDdMbnpV?=
 =?utf-8?B?THlkT0RWajA0R3ArY3FVWGh4UitFa1lrTE92YjRYakdVWDRhY1FUa1pGSmpY?=
 =?utf-8?B?K1FVeDZKSXNIV0RSQ0ozYVB2aFhxdG1acENISDh2cU5tY2M4REZUdGdhMkdr?=
 =?utf-8?B?OTFCRS9DMGkwYzRmWUU2VEdMNDc2eC9sRmtZYmRob21lcGhDMkxxQ3NJekxF?=
 =?utf-8?B?Njk3ZFFJUlBCU2xsOCtMRnp1SjNjV3BqWGY3ZU40bWF1OHdXMnhGcWl5Qmti?=
 =?utf-8?B?cG9BNm1LckxhbmRqaXZwbjhYQWkwOFZNTXhJaUFmZmovRDVVS3Ayb0lSa0M4?=
 =?utf-8?B?SjZLK3RMY3d1eHQxTG93bW1veVFmWGV0NlY2YlVHMVVZd042ejdxQUEya3dV?=
 =?utf-8?B?R2hPWllqUVMwUDJocjJLTVdmMWprMUIrc2piUVRrdmJsd2NpVzl6VmdLdTF5?=
 =?utf-8?B?OTdyQVVoMHdHK1dZck45UTJaKzEvNEYvMDZRRXpSZHpZMXRlQVF4RUpzU3NY?=
 =?utf-8?B?Zk53bGJPTGFzc1BTSnA0WTJvT0x0QjR2blU0ekFsaXlIZjR4d2d6WWhtUXdR?=
 =?utf-8?B?Vk41TVpjb00rOWdzTURtNTF5ZzhIdzFIM0pUalRTUnhYMmNtb1pDVTczRkJT?=
 =?utf-8?B?aXRET1JsZWFpUEh2cU1BWFRwUG1IL2J3MVNkYjBDemVqTGtkeG1hOVV0bWhq?=
 =?utf-8?B?TVFjWDVWWTFaeUJUa1hKR05OTW9YSk5XQ0FLNCtUQXgwZ0Z0TGx4eUR5QTZX?=
 =?utf-8?B?OGNXMmtrbDFNMVN5NVVyeVNNSVpuSXJhV1MzaXNTWURaRTJmZkJyeFNJUERL?=
 =?utf-8?B?QWxta2djWDF1aVVOYUgxMUZmSjBVYklJWU1xYkp1UW90d3NFQS94aTdjeERE?=
 =?utf-8?B?OGkwNjFaNlJ0cE1YUnZqUTZ4dWQ2a2FiaVRKZW9nazBpZE5kSDFWWXd3OWM5?=
 =?utf-8?B?RXJ1cDhBWDI2TDhjV2VwSFhqWExqOXNPREgybFVab1lBaTFWejNaSnhEbnYw?=
 =?utf-8?B?SkUxd1BSYjhaSU5jYnFTc3htUDIyRVgyZ2QvT25nLytZQnFFZ1Vua003Zzkw?=
 =?utf-8?B?eUE4STRZVU9QM1J2ZGI2dnozQnZSaFBvV2dhTkE0eTdva0JoN0U3YnlZUU9D?=
 =?utf-8?B?NEt5NHZ3bE1uS1lKRVhEWE5IRWRsQUIyampVekNaQVZZZy9Qd3RFWUJReUlN?=
 =?utf-8?B?ZHJIZEZnRmdnbTVLaUZjYk1ieEZhMTk1R09WMjhIcTFwU3E5cnZiVTFLTmZo?=
 =?utf-8?B?SUJKZkZjVFpUYkIyT2tLb0xlTDFtQ1RkL1hydCtKdkp4bTVwWTZNbVBrRTlu?=
 =?utf-8?B?bFFCdnhiSGkxOCtzU0JjY25PdUYvdTRrWFNhMTMxcTRHYzk0TUUyRTJPTG5F?=
 =?utf-8?B?cWw1bXNDM0pwWDhmdSs4NHU4U0MzUlN6QkZLVVV6TVR4dVhZWEtIQmlUT3V3?=
 =?utf-8?Q?hc16FfhWvgU/cDMXoz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f27902-2a4f-4235-2752-08dec88353be
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 13:05:50.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JMLCFRNllTALRttzuQcceXcw4ufD7Jyr7rOrwmYgTtCqCZAV1SmZdvRZT0X8jmDiSmBdr9GHhkkjcrvAwYsDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8469

On 6/12/26 04:25, ZongYao.Chen@linux.alibaba.com wrote:
> [Some people who received this message don't often get email from zongyao.chen@linux.alibaba.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> From: Zongyao Chen <ZongYao.Chen@linux.alibaba.com>
> 
> snp_filter_reserved_mem_regions() checks the range list size before
> adding a new entry. If the page-sized SNP_INIT_EX buffer is already
> full, the next matching resource can still write one entry past the end
> of the buffer.
> 
> Check that there is room for the next entry before appending it, and
> compute the next entry pointer only after the bounds check.
> 
> Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zongyao Chen <ZongYao.Chen@linux.alibaba.com>

Thanks for the submission, but this has already been fixed with
1b864b6cb213 ("crypto: ccp - Fix snp_filter_reserved_mem_regions()
off-by-one")

Thanks,
Tom

> ---
>  drivers/crypto/ccp/sev-dev.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d1e9e0ac63b6..9e6efb3ec175 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1324,17 +1324,19 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>         struct sev_data_range_list *range_list = arg;
> -       struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
> +       struct sev_data_range *range;
>         size_t size;
> 
>         /*
>          * Ensure the list of HV_FIXED pages that will be passed to firmware
>          * do not exceed the page-sized argument buffer.
>          */
> -       if ((range_list->num_elements * sizeof(struct sev_data_range) +
> +       if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
>              sizeof(struct sev_data_range_list)) > PAGE_SIZE)
>                 return -E2BIG;
> 
> +       range = &range_list->ranges[range_list->num_elements];
> +
>         switch (rs->desc) {
>         case E820_TYPE_RESERVED:
>         case E820_TYPE_PMEM:
> --
> 2.47.3
> 

