Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE784CDDF3
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 19:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792091953; cv=fail; b=uN0bp516f1bCl0z+VFklyscCEFtg93kcrpfOUNo6rkWWZXeiaiZtYjLpXRD1WEpQajSrRCdJBmT5vw87fXgoLvm/lh+hac38XsAsOw8On8cT3KDsKFGyzQf+eLzw8NPhQ6GvL1TBR+JYS3SLao3nGALwRYtlQIuHk28s2XprWxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792091953; c=relaxed/simple;
	bh=bkD59+x49jlGOkrgsXF4C96XQg6UqSd1g0isUjLK49U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rCTe50F2nGOPzwzq9+c5t4noPbWugdTOABenatcKsvulN4Ty0oZwpiiba1XkMLzC+GFjsvVZ/+OqL0bPnVhsrOHFdy6xml6/niknyACTrDSetRErUOenZWfoIfY6wo7tOeLeXmYCIIi+KWoo5AjytOxRA1nfc8079iilkBNUI0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cr4Zghqt; arc=fail smtp.client-ip=52.101.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cr4Zghqt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8b1Kqh8YH2OXck4GPyqdLwd3LnpHk27tlWJodmmBVyvH4ZeKsBD9VFnGXJZQeR8BdV1XUeehwvpdDVxrIn5unRD5qsx5WGl6oI3v6NWvrBWl/V6zxV1tTd9r7e3emKJR/2Mg8YZ2l5+GfcgEWrc9gvd+hbrrNIZCZu2jQOegZQG+vBT1KBox9PR1huJERx8JuF9EOaI/sVWxu1bxzmoyA0xsQLijOEszaD3CUxrF29jSnDpXEjFQ+v323+l9XS0xF6Bv8IBRDQH9zgWGU92wNDpfAzWxomqHgClxn17AwMfVPjRYvmDDySshQ4zCTlhzUWVn6tW48hFtbrBf+lByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAz+JcGVHR19B/xkBdpMeAfTYB4I4GO4IlN/hjTqQOo=;
 b=yMvoYsVXS+/ec98jbkgm8YJ+LdbGdxGXZMW10849iMic1pEaBVkvutzaSyidGEUho1c9WSqkmG8upvLOyT3Jn/kri4HARUSwkiiYmPPnkIyLSDXt0peRDkugveQ62edilVbUc4szHxqlK3c24GCWXbk5ZQC0n8S2z4M9Mlxkj/8u6HvJhbazUbdaeDAvO8mnrd8dZPoNCy1xlzp1fU2hFal/y1WBC6e5w38NdQHaODlZO47+dzWAynp8Zh2lOyMNSjLAptxC9ZAV678/hNHdfbumslh2/Ro/2sWYB8kAxf1v5DO+gwbJTdl/iljeBAyo97JtnBZAZ6HYTK83BtEqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAz+JcGVHR19B/xkBdpMeAfTYB4I4GO4IlN/hjTqQOo=;
 b=cr4ZghqtyOyXMXmIArkXBGzIjEjSdmHeg0dWFdtFLcAFrj2797KxupV70EFDMCdv8CG654nfC6F4EgHiGcgZ3RC00MvW3pox4cIksGdEDDG5ISR1ZIuPBaLkxoFi/6hMEb3qYS1trmhQPuRpvcog9jME57MDZZZWJ9XffKZzQVs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10)
 by LV0PR12MB268673.namprd12.prod.outlook.com (2603:10b6:408:60f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 19:19:05 +0000
Received: from DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5]) by DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 19:19:04 +0000
Message-ID: <9d145d0d-7d68-4741-b8c2-3db989889a25@amd.com>
Date: Thu, 15 Oct 2026 15:19:01 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] crypto: ccp - Allocate status page outside
 sev_cmd_mutex in SNP_PLATFORM_STATUS
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261014132145.1726322-1-michael.roth@amd.com>
 <20261014132145.1726322-5-michael.roth@amd.com>
 <552abfdd-fc3c-4a46-9595-bcc05146f3c6@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <552abfdd-fc3c-4a46-9595-bcc05146f3c6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:610:52::12) To DM4PR12MB5310.namprd12.prod.outlook.com
 (2603:10b6:5:39e::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:EE_|LV0PR12MB268673:EE_
X-MS-Office365-Filtering-Correlation-Id: 83810f62-61a7-4859-c461-08df2af12d4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|260925021311599003|260925021911599003|11063799006|4143699003|261009223027099003|260925022911599003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	dvGEjqSav7kXXgtmBdrlS7S+1q79uG2DeNetfoVXUWnKSy8p9O9kJqK+jH7efZDMSv0/1a+Yzv7Yx77oaWCO5y39TvOXuNfs0+1GAEael84wYdNpUm502L9I51tj3kb9q2sOmFiZak/puOKwUu5UJJVF8wIHS67aVUviWj9MfTfgarMA5QOvdnJJNaj1xWXrP+iOI4vT3YBLSKbd883z5ugo6E6wswUiPN3yCCnEhCTdCC8ubE7JimLwi9+xKWex35t3NlXuJ8VPesxxXaATQNIGxYzUn0jAvdHZTlhG6/DzVn6a9te3q51CkmpoQI24hYjNXqO8pRMSYh2TrQGZ37zzzvKAFuTEhJ3D9CBRHaq8n3HFaWImIuEkKCoTuUZhLEkvDB5dBEhYvwkfFL7aoocAKehVMUxd6Jc74BynkNBxSvHniOktAHFqnHP3xASdyW+IGTQQylXuXSi+vAaOpOsx2/rCIDsgwsr5WK5QSurJI9CaoDsElm/k/KCTc/TFH2yV47FWjhYi5GamNKoiNxl/fYAtdV+ZZKtuTKZouE+o+zDf8XeUK9HIzZeC5ikYYRQcA2ZkFyehWl1zx1mhA1Tvlq3EytOtTKrxTyHic0vvvGKaCwcVznfV26olwA4C
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(260925021311599003)(260925021911599003)(11063799006)(4143699003)(261009223027099003)(260925022911599003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkFJMzB1TmtYWmprekdEeEtSaEJSVXB0KzRGYUp0bzRvMUZhdnlDRnRiUzFP?=
 =?utf-8?B?UlZZdTJJMG5xayszWEprdFlUaFhqT2hPTWk0WThtYW9jaDE4K29XczFJQ1J5?=
 =?utf-8?B?WVM3dWhQeUFTb2g2clpQRGpHU2pEWjVJSks0cGxXa3F0UlJ4OGhSd0lxNkhy?=
 =?utf-8?B?RzJoYXFNNnppT0liNUt5T2I1K1VQcEttMzdTVFN3Qk53TDgrRmp1OFFSMGtu?=
 =?utf-8?B?MUpZZlZWT2lkS3hVa1FQZVFhSmk2SXpYdGpiam9SaUM5azRORzlxU3crMnFy?=
 =?utf-8?B?VjIvZ3N6V3JoeFZIN1gxUjJ5UTFSVWJMRzVFNlUwMXoxb2pmMkkzb05ZRkh0?=
 =?utf-8?B?WmlqVThwNmtON0dNQ204bGhZQ0lzK3lTNDFzS1k0eVFDQWFWU0pXU2FodEl4?=
 =?utf-8?B?dThYTUlYUXRaNzBIKzl5b1F3aitFRGJCYjljQSt3SHlLdi9GZnkvU01MdXNV?=
 =?utf-8?B?alhlMDVrWllnYjYxbTFvWmFVbDUxR0lmNEVDK1JPVW03WFNVNkRDSVRIS1cy?=
 =?utf-8?B?S2dvWlMwN1FYU0YzWWh5QnhsaFNHNXJ3TWl5NTFFb1BkLzdNQ0I0RTBxTjBG?=
 =?utf-8?B?WVVacDlPWjZXQUkvRXNLVE9sWDN0M0ZrR1EwdmNFMmd3Z1lYSWJsWHY4S2Zk?=
 =?utf-8?B?ZUF6TWpQZURTV1hoVXZWQWJmSW9ZUFJHYUFKd0lJNEhYYnZwN3dKdEllRm5P?=
 =?utf-8?B?clJ3STlvMHFua1RtOEVOVDd5eTJZZWRvdmZYN245cjFOU01aK0dVbXZHc05C?=
 =?utf-8?B?TFlwbDRBd1JobW04dEswcUNsQWlXKzltekhYM1JCSVpvQnZkSEJmMmMwc1E1?=
 =?utf-8?B?elJOd1krUTcyRjZHeDZWeTV2WHdpOWZOczRUK0k3VGlCbnNmWHhxaXQ3UmNW?=
 =?utf-8?B?TDExWVB4VVFIWE9MTncyVUZIOXJzUXNyN1JRZmRwMEtFc055RDMyS1BMRkE5?=
 =?utf-8?B?K1RHUjRDT2thejZTQmQvdHpyRmxrTzhGUE1aQTU2cy9tYmt2T3lQSmNyVmIv?=
 =?utf-8?B?K1c5QnNzdzJvelg3cmNvZWJTYy9KZGVSS3hHeWRJR3RwV1RobkNZb3FyMGJP?=
 =?utf-8?B?c2NtK1d6RGJhYnZyTFR3S3lLK2NrbFlXQi9EWVBPQ3l2S3RHVGFwYkJxelBI?=
 =?utf-8?B?YVdEMmU4dE1TT25oWVJDQ3dXQjgyZHc4bG5xMHJTNHB5V2lERnYrQUVUM1V1?=
 =?utf-8?B?VDNRMDJNM3JpbHhITVFrck5YNVp6Nms1aTBjU3VoWjlBcXVDSjZSeDIwRVZX?=
 =?utf-8?B?SkNGQ1pNNWwwREZHT0NwejFySWloRHpwU0FueDNZdjFtblc0UUh5QUJVL1Bu?=
 =?utf-8?B?QSt5UlNDT2xZbEJGWjJuanU2MERkeFREN1BaaDVTMHZpNkJTemR4cTZqSllI?=
 =?utf-8?B?UnZuUnNkcVJTZlZsbmFjc0FkZzgwTnltb21LVlRnZTgyV0Y3aFMwQkYycWo4?=
 =?utf-8?B?RW9nUnEwRDBqWFZvZnlGTVYwdFBPVmRDcVdUOUNoYWczRjBQZTZOdm9XczJ4?=
 =?utf-8?B?K2RJYXFQRE5oZVl3eHVLRVpMVitWU3YzaGY5R3laMGVHdU5LMHUyeXNhWDlO?=
 =?utf-8?B?TVpKM04wdS9Zc1kxV0xRYmpHcEQ3SlFXVmtoMk54WklQVmVwaWFoZkVjcFJX?=
 =?utf-8?B?WVRpK1lrWmdiM3piaHQvN056dXFHZm1sQ2o5d000L0NPUzg4Z1R6WGNnSTNN?=
 =?utf-8?B?cTFSUGIzVStGUmtxVHJkTHA2dW1zOHc5dHpVaTlTTFJ1UUZkeHlSSG5ld29t?=
 =?utf-8?B?OUo0Ynk1VkowZXN6VW9sSmdwb1lYNWR0c042TWl6cTYxQUt6K0VvZFdENnA2?=
 =?utf-8?B?TG1QRm5PVWxsalZsRzFndktkbGdXcGUwWmY5NGhOcWplV241YkRzL0EzRzdB?=
 =?utf-8?B?cVVQUE1WdWxQbXhlcXF4NzBiQks3c000NkpMVndsam56Qkl4YWVXVmY4d2E3?=
 =?utf-8?B?TWN4VmZLbGpoOUxwVkdpWUJqS3NEWmtvQWlQZVQxaG9ianNFQ0JWMzNNbnNq?=
 =?utf-8?B?c1lGM3kvaDZ2VGVYQmRqMzJzOWdjQmpISzdxN2NkTmVkS1dmYXgvK0ljdmFJ?=
 =?utf-8?B?MCtMdFhtcWJydWJGanVRcVpLUC9HdHVaRE85cXR1b2p2a09jOUtBN0pQVFMr?=
 =?utf-8?B?ODZZVjJPMENVNWRuLzJOcDFGZDRTYnVBUU1QUUk0NkhRUjBTN0x0MnFLbFQy?=
 =?utf-8?B?VEp3VmlmOEViVjZTRkRONlVURUFQMzBFSDl2MDVNU1NzUkRKUzZUM2QxcC9j?=
 =?utf-8?B?bHdGYXJTbHR0Vkd1NnVRN3kvSmFWUEFQcklHK3RqQTZNalhnMEtxaTl5RGUw?=
 =?utf-8?Q?EKI+XP6Uw2xY1BXdjq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83810f62-61a7-4859-c461-08df2af12d4f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 19:19:04.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwnNHirCcuM3WoyY5dH9TMW8YxbNnV3gA/6b3kY14e75lvi2YE+Ds+6LwKt5hRZ9qMvcunXkVflXSCmXoosh1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB268673


On 10/14/26 10:04 AM, Tom Lendacky wrote:
> On 10/14/26 08:20, Michael Roth wrote:
>> Allocating memory while holding the global SEV command mutex
>> (sev_cmd_mutex) unnecessarily blocks concurrent SEV and SNP operations
>> across the system if page allocation stalls or triggers memory reclaim.
>>
>> Rename __sev_do_snp_platform_status() to sev_do_snp_platform_status()
>> and push the sev_cmd_mutex and firmware call down into a new routine so
>> that allocation/freeing of the status page can be done outside of the
>> mutex.
> 
> Seems a bit complex. Can you rename __sev_do_snp_platform_status() to
> sev_do_snp_platform_status() and just put a scoped guard in after the
> allocation up to just before the "if (ret) goto cleanup"?
> 

The DLFW_EX series [1] calls sev_get_api_version() ->
snp_get_platform_data() -> __sev_do_snp_platform_status() with
sev_cmd_mutex held, so that the cached platform data is refreshed under
a single hold of the lock.

The current split between __sev_do_snp_platform_status() and
sev_do_snp_platform_status() lets that path reuse the helper with the
mutex already held, so I'd prefer to keep it.

If we go with Tom's suggestion instead, the single function takes
sev_cmd_mutex itself. In that case, sev_get_api_version() would have to call
sev_do_snp_platform_status() before taking the mutex, and pass the result to
snp_get_platform_data() as an additional struct sev_user_data_snp_status
parameter. That should be fine, since the cached values only change across a
firmware update and updates are serialized.

Either way, whichever series lands second will need to rework
snp_get_platform_data() for the new helper, and I can help take care of that.

[1]: https://lore.kernel.org/linux-crypto/cover.1792014060.git.prsampat@amd.com/

Thanks
--Pratik

> Thanks,
> Tom
> 
>>
>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 60 +++++++++++++++++++++---------------
>>  1 file changed, 36 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index c8c229a6757c..37b948a81bc9 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -2554,20 +2554,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>  	return ret;
>>  }
>>  
>> -static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>> -					int *error)
>> +static int __sev_do_snp_platform_status(void *data, int *error, bool *free)
>>  {
>>  	struct sev_device *sev = psp_master->sev_data;
>>  	struct sev_data_snp_addr buf;
>> -	struct page *status_page;
>> -	void *data;
>>  	int ret;
>>  
>> -	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> -	if (!status_page)
>> -		return -ENOMEM;
>> -
>> -	data = page_address(status_page);
>> +	*free = true;
>>  
>>  	/*
>>  	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
>> @@ -2578,10 +2571,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>>  		 * Firmware expects the status page to be in Firmware state,
>>  		 * otherwise it will report an error INVALID_PAGE_STATE.
>>  		 */
>> -		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
>> -			ret = -EFAULT;
>> -			goto cleanup;
>> -		}
>> +		if (rmp_mark_pages_firmware(__pa(data), 1, true))
>> +			return -EFAULT;
>>  	}
>>  
>>  	buf.address = __psp_pa(data);
>> @@ -2591,19 +2582,45 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>>  		/*
>>  		 * The status page will be in Reclaim state on success, or left
>>  		 * in Firmware state on failure. Use snp_reclaim_pages() to
>> -		 * transition either case back to Hypervisor-owned state.
>> +		 * transition either case back to Hypervisor-owned state. If
>> +		 * for some reason that fails, it will have been added to the
>> +		 * leaked pages list, so indicate to the caller to not free
>> +		 * the page.
>>  		 */
>> -		if (snp_reclaim_pages(__pa(data), 1, true))
>> +		if (snp_reclaim_pages(__pa(data), 1, true)) {
>> +			*free = false;
>>  			return -EFAULT;
>> +		}
>>  	}
>>  
>> +	return ret;
>> +}
>> +
>> +static int sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>> +				      int *error)
>> +{
>> +	struct page *status_page;
>> +	void *data;
>> +	bool free;
>> +	int ret;
>> +
>> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> +	if (!status_page)
>> +		return -ENOMEM;
>> +
>> +	data = page_address(status_page);
>> +
>> +	scoped_guard(mutex, &sev_cmd_mutex)
>> +		ret = __sev_do_snp_platform_status(data, error, &free);
>> +
>>  	if (ret)
>>  		goto cleanup;
>>  
>>  	memcpy(status, data, sizeof(*status));
>>  
>>  cleanup:
>> -	__free_pages(status_page, 0);
>> +	if (free)
>> +		__free_pages(status_page, 0);
>>  	return ret;
>>  }
>>  
>> @@ -2615,8 +2632,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>  	if (!argp->data)
>>  		return -EINVAL;
>>  
>> -	scoped_guard(mutex, &sev_cmd_mutex)
>> -		ret = __sev_do_snp_platform_status(&status, &argp->error);
>> +	ret = sev_do_snp_platform_status(&status, &argp->error);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> @@ -3114,9 +3130,7 @@ static int get_v1_svn(struct sev_device *sev)
>>  	struct sev_user_data_snp_status status;
>>  	int ret, error = 0;
>>  
>> -	mutex_lock(&sev_cmd_mutex);
>> -	ret = __sev_do_snp_platform_status(&status, &error);
>> -	mutex_unlock(&sev_cmd_mutex);
>> +	ret = sev_do_snp_platform_status(&status, &error);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> @@ -3131,9 +3145,7 @@ static int get_v2_svn(struct sev_device *sev)
>>  	struct sev_snp_tcb_version_turin *tcb;
>>  	int ret, error = 0;
>>  
>> -	mutex_lock(&sev_cmd_mutex);
>> -	ret = __sev_do_snp_platform_status(&status, &error);
>> -	mutex_unlock(&sev_cmd_mutex);
>> +	ret = sev_do_snp_platform_status(&status, &error);
>>  	if (ret < 0)
>>  		return ret;
>>  
> 

