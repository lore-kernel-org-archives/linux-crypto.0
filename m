Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792689994;
	b=txCKqRG3oWHzEWQNfBdaYTUjIJWBG9qem+ivlRjYBXSkXBINsPKpYlE0BFXYZIqvaMsq
	 OJmZjYcibh143yD86zIHQ8iAsXdYnvwXrdJFCjg9fAS7zd8t0r0/tQyMabYsSzSX/iNXv
	 dINxLwAP3nBc4YhcS/F61gz/mjDWF45nVWP9Fokf3hkdMV8TTlpHVQEVkFHkeZwnoEVBL
	 CJnCAid3BxqkiOPstrF1WOAZ5KkAkQKBQIDe/jMkwmmdNj2vywEWa62yhC5HbhfXiUML4
	 bJhGUAzEHGjddtN/5KWWtK7KY8rUzmNO++y+H0YPHJT4OZ7dV9TSW5Q6biLnSOwAjuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689994;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Ibmvayihy6xl3Tz7teqJDQg35S/kntBeRF6CQsL4rxs=;
	b=FGEi964YSz3dlWp1KrWxkMOaVR0DEMh9CBq3AKATz7IMQAmctNvGWSYuKG+irsrP0W3t
	 izZZq1Pzbodfvx1Z66d3IClqKLg4roUOMJod60nRrXHLjbrXt2nGziHiPPoy0J4hFbjq0
	 IDq4mB1Lri9nqqg3tizRIC8Lmu7qhuQXrJNEtIkOoy3W5KcB+LlIRsxpPOykzzNUX6s2o
	 0R3m1GdPptCw71TMrmh+BXw6j68Han/GjzBIukMUVSNHVn1VOk+HsM21wdK5OBCHzJJgF
	 XX9WEEfOncULD40EGKhESJlhZo2rd/2TebAMzs2nTkdsUULYTINocxvZrDubFoHSkPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5MKfd+NF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.39
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013039.outbound.protection.outlook.com [40.93.201.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CDB606A319;
	Thu, 22 Oct 2026 17:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25CDB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5MKfd+NF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWDJqT2abLC5qRP+WocUF+dmYfHKhVEo6Nuh+JumuVcgEFTOb/GQWYz1Whz6yq0hNID/a9X3b9ep0M5vCU/nkArAIZ/t+Fra3EjMpEDMGWaexYv1FYSyKihYFoH7Q8IaY9wByb1ArZTtG7jJV++2lsgKbKauw5tAPyyizFzPuKNKSl3a3KkmyKuU6CpE6XBCvkjK+iaxXEHM7mYYwmDfazaTxQ+5lVGgxPpUsN8tT4JgPlx+inwUW4PP8KAjJhFn4i7De2IbD59LIaAhGzoyvn2sVZ+RkqbytOZPNl9hW9XP71EmGFZtcV2jG7WGPfQtqMhysK61hhWET8NFa/cbrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ibmvayihy6xl3Tz7teqJDQg35S/kntBeRF6CQsL4rxs=;
 b=gfxXsAKeB1V93GDeOAjjLeB9G60yLQSKQFSoeoEU1/Bc9opGB2uKnTDB8gtVicbduLjRasXqiJonMeO4UFyyrRnT6KJwSDnr20BHvG7hnvB3jxk657Px9P8lkZWpcoW05ftwBU+kBCCH5VTHLZ8CresB6veQ8lO6Ki/kswpASYs/OOTJDwC7nB0AHVLOL3puQGPL+juc7qfzjlxwK1a0lBhCc+QTpKV2bMIFS5YqLTHA8wWkEAlQ/SUD47/oCL0XZWNqTISmRQjdNTW8FLXOI91lXNfnx44dOFgONG199S0NUG5HHznWyDIFrd0mahE6eJ3tMXzwLf+4SInaX9ICYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ibmvayihy6xl3Tz7teqJDQg35S/kntBeRF6CQsL4rxs=;
 b=5MKfd+NFHmvdL7vyxLUK0dvuGn9r+UwMmoWsK6n8KaARDouQ3tGdk3nSNC9ljVQr2xOhQYR3wD27MDgCNYo6Aqe3r+IWpEXp/vxJ8074F6bsdSt6s1v89CpUE2TJJvP0/Wl1gm3kTKO+Z0vq2eNaBUl92P+MOnF9ESMpxrnm5ok=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) by
 SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.23; Thu, 22 Oct 2026 17:26:30 +0000
Received: from DS0PR12MB7851.namprd12.prod.outlook.com
 ([fe80::2c07:7091:41c7:c0c9]) by DS0PR12MB7851.namprd12.prod.outlook.com
 ([fe80::2c07:7091:41c7:c0c9%4]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 17:26:30 +0000
Message-ID: <732791ab-378b-4889-9277-fe361fcb7cf7@amd.com>
Date: Thu, 22 Oct 2026 12:26:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Run the destroy callbacks when psp_init()
 fails
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: Mario Limonciello <mario.limonciello@amd.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261021215716.1076732-1-kim.phillips@amd.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
In-Reply-To: <20261021215716.1076732-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0907.namprd03.prod.outlook.com
 (2603:10b6:408:107::12) To DS0PR12MB7851.namprd12.prod.outlook.com
 (2603:10b6:8:14a::8)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7851:EE_|SA1PR12MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 3058214c-00d2-43b6-bfb2-08df30619c44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|261021123027099003|261022105027099002|22082099003|18002099003|261009221227099003|261009223027099003|261021121427099003|261022075727099002|10067099003;
X-Microsoft-Antispam-Message-Info:
	0bsuCQKeagEAVN8A0kab+KIW8hDu2JusX0+PCQ5mr5l04B1SjJyZWnTtNhECZFN7KtmOw2Ov7CEVTy+M45Y7cSMU0MxtZpLN6HynUYnfFSBQ21Pe981UiioZpkOexFuYwAtGfzhinyVj2+uSQXxCUjGpPMsAcWlDLZqoKhAovDoCPlDHf/Gcda72kkff6QP3jNRxNa4/RiW3e9lsvguj4gjvQY5rafuPdJeaRrq5nLSM1nvXATxVKrkfxLthMDTTUD3/Y6TZ20tM3gnXdo7i5Ods/7g5EUl2rRZHo114LW4ujS7QciQCz/KskX6ZLh2jzh4AdltYKPvmwFbBXVHd7YXHt341XIIQqtfL3ZNoj4mFEKWZU7ScScSXJei6NBCTJsRyidLnew+BDnL25TMU0pzQ2YE+Sns3qcSdh7j0N42AT+8DHHJ7m0w+Kn9h7NhEnqFaIXpv84ok2FT+kgov1JZIGpCpPcpgV77lQuubVnNzlT5tQB0AGazUEGDjZpz5DRTOhh0Z1O70cEeimiYh/qQdr/fwiCHsFysa7QAPxJ3rG3e74+/Iee5TXo4EMQoTcVF6ztcNVViKGkO5vpJQIHlRWsgAnuvboWS8zhHUHcqv/8V50A7WxRvyxNpcGXYzpb/ZRc+hYZh/xvoc9p7ZtsVeK0TQIw1bJiXno5WnJ/g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7851.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(261021123027099003)(261022105027099002)(22082099003)(18002099003)(261009221227099003)(261009223027099003)(261021121427099003)(261022075727099002)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VmJyeXFsdlVxTVdCOW9IZU5Vdm9vYStkNjU3ci9sZXFMTnVnWFRhYzlCTWdW?=
 =?utf-8?B?c3dkdHZlN0ZhcERNc2JHL0hOaXNBZ3JDNHhLbUZqZU9BQWl4SjZMUWk1NmtJ?=
 =?utf-8?B?eDZibTN4M0wzWnh1ZTBGRm5oWGFWZm42MnVZaTNyaEZBV3ZieVZ3Qm9FSHF5?=
 =?utf-8?B?NGJuUFY0cWxScXk1MjY0blBwVjN1dkFaQzFaMG9xWTBjUVJEdW1XbVlUVEVP?=
 =?utf-8?B?NlNQTFZOZEZpV2htQ20vZkYzcEE5UWN0QkNIWVNIN1IwWDJZY1ZsczJJZHJv?=
 =?utf-8?B?RDBSelFFbzNzaXVYK2c5dmRyMzFLcllBeTlIWEFUd1dnNHJWZ2xMRCs0bWdZ?=
 =?utf-8?B?RUlmdmlRRVptU3hJUXRibTlyODBWRXpNQkMyZjV6dTVFM0FXbE1Ub2hXczFK?=
 =?utf-8?B?b0owZFphT0tQREQrSzNRZG5KQlZBV1RDTlNhb3F5anBhUEQwTHNjVEZCdnkv?=
 =?utf-8?B?K25lRXZ2WGg0c1cxOWpFaGZucUR0YTFYK1ZhYmxidlppNmJBNEFrbjYrMGYy?=
 =?utf-8?B?STlSSTY2VU90ZEQ1RGxDek9oZUdWTDR6T21NT2xvZmFNeXg2OEx6L0p0Mm1r?=
 =?utf-8?B?d3BPcXV2MzVUMGZpblFMejVhM1ZhOGZlbXluZHVlKzJFRGJaUkFjUis1K281?=
 =?utf-8?B?QnNiZEw1dTkwMGpXZXhac0cxRnByOEFFQW9NUkFzT2R2anhwblFnVTBJQTAy?=
 =?utf-8?B?SktCM2dyOGxJVXJjV054T3hWekdVNnZRNXpDV3lMYm5IN0RXdDQ3MzFGNysz?=
 =?utf-8?B?VGl4YiszN01XNTU1aHBCYXNzVzc0YkJSWFRnVVZ4WkM2bjRUVzZzd1E3OGNM?=
 =?utf-8?B?anA3OW5NbEE2dHd2dURMbUEwaEtsWnJTQmQvNFZwVkgvVmZLei9QNldJOUxC?=
 =?utf-8?B?Smp0N0FlTW5XSVlPRWpPWnBsZURmbkd1eFZaYURLSVZTYVMydmIzR2JjdmJv?=
 =?utf-8?B?UnMvTEsvQnZCaUdjN0x2bGhSeWpZcDVYYW1vYzJIUG5OWHlyZ2hjTDBzaGpl?=
 =?utf-8?B?NnBlUFdsY01BdXhGenBOd1FRc2REOTNSRk9Tc01sbXBQa0RNaGxVV3J2SXd6?=
 =?utf-8?B?VFZDQ2FCaE4wVnk0eUV2OFhTempzTjl1VkJIdThLaEFEQTlxWkdrakMwYjF3?=
 =?utf-8?B?bUhVWks2N1Y2UVBnZmNVc0REUmFpTmtNZHdyRU4xb0d2WC9pZklYZDdZOWV0?=
 =?utf-8?B?WFZ0SkxVU3crVEorTEZpQVNXSVM0djYrVkN6NTVIUnoyOEZFSlhsUXNRRDRJ?=
 =?utf-8?B?Q0lSS0pBZVNUdkRCVUxzOHppQ3hOM3A1RWhMdUxJSGt1TGVTUW1uak91dzV4?=
 =?utf-8?B?dW1rbWtRNkROS2NIakNmUmtJOFl5SDVzRlZpQ1ZCbVJuRk5CNEpmM0lSbUN3?=
 =?utf-8?B?aFB6Z1JwN3RsSXBMZ2lBaGE1eHZnT0hrTVVHdmxHM0xUV21xVXZBOXNHNkQ0?=
 =?utf-8?B?V1YxZ1FySm8zRlZKaVpXVk1yNENHR1lNVXAzY2lkVXF6Rmh0TXdEcWJkTTg4?=
 =?utf-8?B?UGk1QXkrRXJsLzJaZnVjYjlOazUyZVJHcFRwU1M2dFR2eHdlVEw3MDZPeUVR?=
 =?utf-8?B?V2lyZG15cTN3ajh0SVQzbGhzR0c3ci9sb3hEd0wrcWxQYmZJVWJYb3k0RnY3?=
 =?utf-8?B?TGo2M3RmNkF4emQxdU0wWElXTG9OQjh6Q1dNcVRDdEFVVTE4WVdqajNKRHRN?=
 =?utf-8?B?NHlnS2xxZW5rN2VBZW1FZVBTeXhTeFlTS2VUV2p2U2J2R3M4aWx4YUgvZitw?=
 =?utf-8?B?MUNyZmhaM1RRYXJaaWw5dU0xaTVFQzhLQVZHc0VJbC9rWEFUT0pOaUNvQnI2?=
 =?utf-8?B?ZDIwVDcrQ3RoekZrM2I2ZHRIcmFmQTZjL1lJYUt1ZkJsUlRSREFQNFlnVDZO?=
 =?utf-8?B?NHJsSTVUaERzMjlISlgzSHVtdm1zbktWWDhmaENiaEhaTE5ZRjBxK1JDQ1Nu?=
 =?utf-8?B?cC9ZeVJqQVRrbFhBNEdQVkNKUnVtcklkc1BiVGUyQ0ZiMHUreDhhRE9LYXVY?=
 =?utf-8?B?L1dJNHBnakd2NU8xeEI1YkxrdWR6Wi9Md2tBOWtEV3kxc01pNG5YYjVhTC9Y?=
 =?utf-8?B?N001djBwb2JTb3JXY3RCMDRaM3A5cnlUODg2T3R3K2JnRllHV0xnWUsxaTBv?=
 =?utf-8?B?bVZQZzFXdFdZSy9laXl3VXpJdjB6a2ZPQUVocXJjcVJRRWdMR285R0dWbElU?=
 =?utf-8?B?MWpJczZIRVNnTmVucEdNLzJkRmZDQXllQ2dvczB6YU9HK3VocHlvcVB1R2hl?=
 =?utf-8?B?bE1DUTJ0NTZXZEo4ODFUMnB2TG0yU1Y5eDFoNitzR2ptMjlRV3BOeUViUzFS?=
 =?utf-8?B?bmNuamMxT3FWOEJUWnBtU09OODMrNjVWSXBwZmJDU3V2QW1jc3RNZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3058214c-00d2-43b6-bfb2-08df30619c44
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7851.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 17:26:30.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3bdgtcTSxGbKLib8bl6DG00YNCbbOkNUGS4PAIjtVjAZHslQ1F/WSj4jxEvNW/kYdDXMB7ufWTAjlJJ60QQNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7272

Hi all,

Please ignore this patch.

Thank you,

Kim

On 10/21/26 4:57 PM, Kim Phillips wrote:
> psp_init() brings up SEV, TEE, SFS, platform access, DBC and HSTI in
> turn, returning on the first failure.  psp_dev_init() then clears
> sp->psp_data, and sp_init() ignores its return value, so the device stays
> bound.  At unbind, sp_destroy() calls psp_dev_destroy(), which returns
> early on the now NULL psp_data, and no subsystem destroy callback ever
> runs.
> 
> Whatever came up before the failing subsystem is therefore abandoned.  Not
> everything it owns is devres-managed: tee_dev_init() allocates its ring
> with __get_free_pages() and it is freed only by tee_destroy_ring(), so a
> failure anywhere after TEE leaks the ring.  DBC and SFS are worse than a
> leak.  Both register a misc device during init, and both deregister it
> from their destroy callback, so a psp_init_hsti() failure leaves a live
> /dev node whose backing state devres frees at unbind.
> 
> Call psp_dev_destroy() on that path instead of open-coding the IRQ and
> master device teardown.  Every destroy callback returns early when its
> subsystem pointer is NULL, and psp is devm_kzalloc()'d, so unwinding a
> partial init is safe.  This also fixes the teardown order: the callbacks
> now run before the master device is cleared, which matters because
> __sev_platform_shutdown_locked() reaches the device through psp_master.
> 
> sev_dev_destroy() is reachable here without interrupts having been enabled
> yet, but it does not issue a command: firmware INIT happens later in
> sev_pci_init(), so the state is still SEV_STATE_UNINIT and
> __sev_platform_shutdown_locked() returns without touching the mailbox.
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>   drivers/crypto/ccp/psp-dev.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b14ce51065d5..4eb49eff9590 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -282,7 +282,7 @@ int psp_dev_init(struct sp_device *sp)
>   
>   	ret = psp_init(psp);
>   	if (ret)
> -		goto e_irq;
> +		goto e_destroy;
>   
>   	/* Enable interrupt */
>   	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
> @@ -291,11 +291,15 @@ int psp_dev_init(struct sp_device *sp)
>   
>   	return 0;
>   
> -e_irq:
> -	if (sp->clear_psp_master_device)
> -		sp->clear_psp_master_device(sp);
> -
> -	sp_free_psp_irq(psp->sp, psp);
> +e_destroy:
> +	/*
> +	 * Subsystems that came up before the failure own resources devres
> +	 * cannot reclaim - TEE's ring pages, the DBC and SFS misc devices -
> +	 * and psp_data is cleared below, which puts them out of reach of
> +	 * sp_destroy(). Each destroy no-ops on a subsystem that never
> +	 * initialized, and this also drops the IRQ and master device.
> +	 */
> +	psp_dev_destroy(sp);
>   e_err:
>   	sp->psp_data = NULL;
>   

