Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010012.outbound.protection.outlook.com [52.103.43.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06FA194098
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 10:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747652136; cv=fail; b=AKwvI8GUyuFZ6ejmlZFcdg+IKlZHmdh9VEOyFzT8yDv8d6B6NH4fV1oW6olOGel/eOBCij/AY9x/IkPV8IwQgI7FiHHsbekrf/yoT4Wfe596LikIvtXI5/KU+jkXCeLmHLb3sECn7UHWQ4onHTXHczYg2PoJm1MpIE/Q9/G/QSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747652136; c=relaxed/simple;
	bh=/YXZaSHnSeDUp3qwQjo/CaAzTXllP2Dx4i7MZEl0vwQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TZmk8w34KLFyIXkgaK018++4j0b1Fp/TjRv3fbgjJlzb1011zJUHgtkZ/LF/HR9DL3ZdXlIgCBm8q/3o2qRwGaZ4D6oI6oXHdOuvEA7HQ3bM04qOpTIydReCEdZDTuL7bXxZglvXeaXUhUVbHqJAZMjidTzLm/8BRKb+Wp+Yy7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=KGoBUnYY; arc=fail smtp.client-ip=52.103.43.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="KGoBUnYY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ov3eD9BDGygd4IkziEUAES8ucwsnWcwIGLTIOe+PLLX6xYtgFss+dkR6/CADPtX4jj8ktGbE+rSqJASF83PKWFx70jRAjXifqfbcbqzb9vm972ioWtsPz5uk9aKCIUn3//iPJfunJq3wII//pNSuhMZ1MIYaYlYWvKJbNsWkJO/0nYaXOkwhPYx/n5AuHGwc03qhnmpBjzObH/7mF54IQ0gtMAhzKMSOsh8SxLPXsQnxzII0GWxrjK9wOPROGZ1CqdmfVT5Q/wZw0lgp/2/CqdxpgIxmucxpqrnAknewQ8v7KUQAenKoN8bFov63hrRU7w622Q+oUt5qv2MkBgOJIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yk5ZU+ibz1DNDn/kiKRAKbnAiDasz3XFLvDRSU+w39c=;
 b=mxTtfJYWNFHbRsxs3us9q5D5RG2VwkKM6SVquXOswNB5KuBNIuaGaaCkxI5pHAHVL/k2S6FCFeY9eCpVYiyyJFPBhy7TbeopWJwi9dbIPdRt5PAqqAzNZoiKRY08V9CrAL/ehxIo6EnAmKqMVcrmvc26J7nEaT74pennEj4FLjSSyB09l07tfYHVLKyPWojvpM/mx/aWce23OH24LPdN2LQNnpRZLEMHmt4Tlu819Xx1uuqLztLtSkTbjjY3k3ISNut3IpX9VjpVgwAH1g9QNPr01VqqradWLMqvBK0NLZ4Th94P0OgAzTubz7Iyrumsqy9hDXVdMB9phFpey/SZNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yk5ZU+ibz1DNDn/kiKRAKbnAiDasz3XFLvDRSU+w39c=;
 b=KGoBUnYY8mHII8j0dM5XBuBuq6WXcr6xiXeWcQITifCPWwLDsgcXP3fs3Jp3O58Wa+wpSjq/ah/TNYqD+FzuTiwn6FLggSRKkwJotn/5i4pS8a5xLQLuI48+sbt9zutLKcUevTtIZdk9sTrWzks//3Us4l1xErBPggym0p4qWxyyYA2dq+nFsdCsofvCMxL8q/cW7fOmQr2PCEle0C8dNzxOKfJK+uIcbD0A6lKN1xY29AEakzqTjkp2A2Ds46NqBJdbVq1FwcaNNBJF2FWpuhQ96XYvjvOJU6pMKy6h7YxIWNrRlWsXdCERSuDvv81Hl3wAfRRdq26s/UUkWvwZ7w==
Received: from TYCPR01MB7577.jpnprd01.prod.outlook.com (2603:1096:400:f6::9)
 by OS3PR01MB10042.jpnprd01.prod.outlook.com (2603:1096:604:1e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.29; Mon, 19 May
 2025 10:55:32 +0000
Received: from TYCPR01MB7577.jpnprd01.prod.outlook.com
 ([fe80::fd42:194f:1f66:7d82]) by TYCPR01MB7577.jpnprd01.prod.outlook.com
 ([fe80::fd42:194f:1f66:7d82%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 10:55:31 +0000
Message-ID:
 <TYCPR01MB7577ED6476DB32B66B8320B9F09CA@TYCPR01MB7577.jpnprd01.prod.outlook.com>
Date: Mon, 19 May 2025 18:55:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: Add a null check in crypto_free_sync_skcipher
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
References: <aCsI_0PR2snafNTR@gondor.apana.org.au>
From: Scott Guo <scott.guo@outlook.com>
In-Reply-To: <aCsI_0PR2snafNTR@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0241.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:456::6) To TYCPR01MB7577.jpnprd01.prod.outlook.com
 (2603:1096:400:f6::9)
X-Microsoft-Original-Message-ID:
 <d205d753-7851-4664-a94e-062a5a0f8224@outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB7577:EE_|OS3PR01MB10042:EE_
X-MS-Office365-Filtering-Correlation-Id: 7525aa5b-7e27-44e3-7915-08dd96c3aca2
X-MS-Exchange-SLBlob-MailProps:
	hQngCdii+CZMtubk+T4alwTMqtSryas8eK4OwmGNG53LXEZNCHkgrC6gg7HhxNVxquXIzostTfG3vT34SlzeIARdyHUKSmv+2YJS469kPfoGyaBG3Iaw8OPkaQ7uq4rF7p3X/f4cMTl0+G4UoHN0EmQAWSS19BTEE6mvAGTndtKEU1RMT1L8x6Pwng+IJBL/bgB+wLQMORlY1z2pP189ae23RDeb3UXF52WWhfPg709ioWe+dcDP8ZCj18cfoSIpivqBiW0I0J0UdAb5sdwq+QynIoXg8UZhVNpABxs/HSKwyF1GlE9p3nODKAYgmGBDetE6neMtfan589F7Xo0GEiFo10eGNHxOpNfMydIfFIzj0BsHDxzuW9HH6Em7fqPgA7pkKbB2pnUYZO3ya+TgZXHDbB+1hB3G0GyKWMbMHmfxWRK3PFD7W0wySWYOp+sxcP817Icx4P8TSMNCR7JMUZRntLy0dxEaaRuJzPQM5EivnH+sj4KJN+kFG7W9+XcvIQtyn22w6h5JlwrMM6jSYkLrWvrJP1jqujX/Dylyj2sIOIA3u/e6STfyVHsZ2O+/t+wibSFXj/e8UC/RBoNcsPBYQTkFbRDw1WTHV37N5ijSWRhhsufEbfq4dj39YOpTCJHtAtYxd1BTh1F0beqkmMLMkn3nlw4+EN82PIKWg45acwelpkTB8g==
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799006|15080799009|8060799009|7092599006|5072599009|6090799003|461199028|440099028|3412199025|11031999003|14041999003|19111999003|12091999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3BaVzJybXdua0pzeFl3cUxZQk81MDNsQjUrRG1XckVSWUxTanFKcEdiM25p?=
 =?utf-8?B?NDQzOW9YVGxKT01Gd1F0TFN1NGR0b0hsM2xBYjlXbXFBL0x5QWcvRlBIVFJ0?=
 =?utf-8?B?cUF6NG5oMHZnS01WcS8vcDJyajZGTm1qcmQrUkFGb3Y4d0xRMEVjb3hQV256?=
 =?utf-8?B?RGIvVjRqZXRGMHZ4MlJ3Y0ZaR1lWaTBqNGJ6VzZLRnozRUxOTG13YzM5bGpq?=
 =?utf-8?B?a0xINXNyWDllbGJmd01USzJZb0M4eU5kVnBoREFQK1NWYzhGR3loaCsvUi9W?=
 =?utf-8?B?VElkYXpLVTZCWVg1bXZGZVU3WVFVOHcwU0N4SnQvZm9GQmJsTEFEaThYd1Zk?=
 =?utf-8?B?aHhPYlBGY0lBS0Uwb2owSHFrVGJvZE1peUZKbDhpMzBKMWFieWRmUmw1ZGRO?=
 =?utf-8?B?THBMeFUyUzZwTGxRTFAyWllMODk5ZUlPd1E4RHpXWDRhZzFFMHA3NGZXUFNL?=
 =?utf-8?B?Ri9wVDM1OHZDQTBoUkxoSHdDRnpZYVJJOS9BWlZDWHpwVlNlM01neVFRZGNQ?=
 =?utf-8?B?MGxaM2pZNkl5OW9uT0R4VnJpbldyc1RaMzIrV3NmT0NFMjhxak9PZklTb0d2?=
 =?utf-8?B?UzNKaGZoZTRyOC9pcXV5cW1JL3NUTFhvOFFWcFlZRlA4TmlCcVdPc09wcGgz?=
 =?utf-8?B?bGhDUzNKZzhUTkc0cEZ3eXozN05mcTVqSkRzS1hiRGNNbUFJb09lcjlCMGdk?=
 =?utf-8?B?dkY0Tm1GdXp0YXA2UDhoaFZNWWs3c1FPWEpkcVBRckJJUHd6NmdMdGowc254?=
 =?utf-8?B?bUdHQVl5Rmd3L21qSXVDaHM0ZWlYdXU1MkVGR0xINFJpcjFpV09DWGtjN2VO?=
 =?utf-8?B?S2VwUFpDa2h0bXpabWZaSzN4cDc3SzVPckF0N09LRmhnbFZBcTVzcHRSUkY4?=
 =?utf-8?B?Y0gxNXRSZGdmcWhIUmJTanpmdktLdndhK21sNTNxK1VRYzZORklVRDNpRmM1?=
 =?utf-8?B?WmtEajZsV3ZiZkFPUDljZlVteTdDbS9YRFFDdVMvSGxCQUpQVXBPdWV3WUlV?=
 =?utf-8?B?TUwvTm9DKzVtZjBMUmxVcDFmTHNwR1RQOWNOM2s1Ni9hWFdnNElJWjkyRzlO?=
 =?utf-8?B?YkhJT1dPOEt4UUFXTUJndDRKclFXalV5LzJmd3BlTUFPOTRxeXlaV0NTY0hN?=
 =?utf-8?B?bW9DMG9DT1Vnam9NV1ZSam54dEk2MUgwYVZjVXViL0tPMDdHZlJTY3l4aWFT?=
 =?utf-8?B?RXlHTUE4K0JwL21EcXFvaFgrNjRnVzVHMVF3VWNMZ1phMnNOSnJnckV6eFRO?=
 =?utf-8?B?K3RZbndybjFEVnZ5dmJFT3BFYW9SNVRaZlpZQWRWRmtJd29kQ0cvOGdXUWls?=
 =?utf-8?B?SS9EV0xvekMzbkFIWmlTYThGcThwYmZaaFo3d1EvQjVVNnY2cGxJOVR3VS9j?=
 =?utf-8?B?V0QyVVhTWHZoR1V2VWlhOWNrcHBtL1g2dTNSZjM1K0tYdkZMaEljR0lyUytE?=
 =?utf-8?B?Mitja0lYL3VXclduWE9IOEJTTGZQbjU0M0xoMzdJc2FHaXRjR1lyOFlnOXdk?=
 =?utf-8?B?UXJTeDUwYUpNNUxER1MxcWJJZUl4NzVKMEpvU1gvdVZiQkFUVXlsK1hZKzZk?=
 =?utf-8?B?V2YxK3BHNVZXVnJpUEpRZkpMbWt2MHBQYzMrbU9vaGtpSzdYa3hMc3U2b25M?=
 =?utf-8?B?dFQrRnF1dmdmZWp5RCsyWXhibFlQcmIvTmdXWFBEdElWekQvczhTRFVqaElE?=
 =?utf-8?B?QWwwd1hVbU44dmo5T1UyMzNkYnFQUjJMUHg5ekdKZ0hDTUJlSjlKOGZnPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUliU1VwaTEzUVdhUENQRHlHbDZHdlNIR0dxQmJScmhGUmdyTXBzYzFrNTJq?=
 =?utf-8?B?VlNUOE1VYzAreHRLa0RYRWtTMm05TjkvSWQvSVRFMnljdXNyNDdZbXZ5dnJ0?=
 =?utf-8?B?Y05McVBzSVVkb29UaCtTQ1RpSTY4RExPZ1hiSkNManlCOHJoLytrNGRMM3I0?=
 =?utf-8?B?K1JKRFpzOU5LdmRORkN0OEVBNnBtdVpZaERxbGZWdjhpV2FKVzBGUFQ0Uiti?=
 =?utf-8?B?NkI1dDJIREd4RXBrSU1nZDNLWHdBWXlDeHM5bmlpanJ6YVk5NHcxeitOUUtn?=
 =?utf-8?B?L2dTcEZwUXNHUmVSZVdTdTdlMGkyQnpBOUJxMnFXVEc2UDQ5N2VVRE43TW1C?=
 =?utf-8?B?VXIzSTBGdFk5ZkxXWjZEa2FNVmhTVmduQ3laclRpeGlncWVmZDVNTUxTb2tp?=
 =?utf-8?B?QzRJME9PZ0M2UXBwY0QvQ1N5aDJPbzZVSFpZRE1yc1JwRXFjeVhsWkxjMC96?=
 =?utf-8?B?TFFRc0FuMHJmVTRvbHMwc1doeHhTd0hTMkIwVTFhWVdJNE5CUGRnVmxYQW1J?=
 =?utf-8?B?MVpSMW96cDRBL3BXQ3d0RkZPbmg4bGxISW5HQkd6ZHNDOFBoVU9Pa1NBeFQw?=
 =?utf-8?B?TGdQRkFqMm1lVC93MTdlSWlUWjB6YzdqTEVFTHFVaTh0bjBFQVR0T04yQTFN?=
 =?utf-8?B?aDlTeEVxY0VrU2tocUpQUXp2bHhESkZOUlIrYjJLc1pwZG1qVVlwSklad3Fn?=
 =?utf-8?B?Q3FTQnA5WThzWXJPeno3ZVUyNTE3RVhobERpUUVCQy9MTTRtTWZqQVpjb2lK?=
 =?utf-8?B?UVUwc3VSOWJTSzg1UCs4VjhrKzlCMm5YYmpWZ3ZWVEptTGJwdWplVHZ0bXZt?=
 =?utf-8?B?SVhSVGZLKzBEdE1RdWc5ellKUStVNzd5a1JJbUxYSEtxaHpCRHdMT1loNkNh?=
 =?utf-8?B?R2dGRkNyRUFOdDFuRmhrUmdFTVlNdk1Tb0N3Mkpzc25lckt5cHljWGYwNVNp?=
 =?utf-8?B?cUttT0lMK2JDeTlOUG1nRTgyRElSTVNISUMyT3hNRFJOQWpzSXdHMGhicDd5?=
 =?utf-8?B?S0owWEFQK0svUjBkcG93end1blIxckhZNnZrcGhKcTBWYTZBQUYyY25FdVlC?=
 =?utf-8?B?M1FTcDQ0SUVMMUdwWjJhMGY0WHhDZWllOVh6aWRlOEFRVVN6Z1I5Uy94Qngw?=
 =?utf-8?B?OUZpVk9Wc3RFblFOUXVYNi9hSUxqQkl3VnFad1ZqekVEY0ZTblJqTlBJUGQz?=
 =?utf-8?B?dVdVbFBaZEE4K01yMXZVUy9adFNrTG1xZ052a0Z4K0xEVUNvQ1l4THdBeUIx?=
 =?utf-8?B?VHhwa2M1RVpUdXVpa2orcGdtVmthb0h4Ymh1WmxSQUxia3VmZ3JtMGYxVFZi?=
 =?utf-8?B?Yy9NUm9TZ1hWWHZWUXYxd0pScVNiVVNnaFBPSGJLbk5DK3R3dE9zVXRFWUNu?=
 =?utf-8?B?Szh5TXJscDkzeUNvN01qVmdpMGZsWFovendCTGlLYUltODF2WVlTb1BwUGVQ?=
 =?utf-8?B?dTk0NHRxQnB6bFREWmxkZWYzY05Db0tzV2ZGckVKTUVVY3JhRVBGQXdNRVpP?=
 =?utf-8?B?Yno1ZEJReGd0QnpuWlh5ZjRwQ0Z6QUNzeFlBWnd4aXkraDdLdXRxN1F6TG1o?=
 =?utf-8?B?aG92djRjNXh5VU9sdkh5UythOG1rMVZVU0pSS1lTTXZ0aUNvcjl6RXhQdmpK?=
 =?utf-8?Q?l1GJRSSnX5e7eaJ1UOghKILTX0RsrqD1dJQ8ThI1op2A=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7525aa5b-7e27-44e3-7915-08dd96c3aca2
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB7577.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 10:55:31.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10042



在 2025/5/19 18:33, Herbert Xu 写道:
> Scott Guo <scott.guo@outlook.com> wrote:
>>
>>   static inline void crypto_free_sync_skcipher(struct
>> crypto_sync_skcipher *tfm)
>>   {
>> -       crypto_free_skcipher(&tfm->base);
>> +       if (tfm)
>> +               crypto_free_skcipher(&tfm->base);
> 
> struct crypto_sync_skcipher is identical to struct skcipher and
> crypto_free_skcipher already has a NULL check.
> 
> Please fix your static checker.
> 
> Cheers,

OK I see, thanks for the clarification.
