Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58918FDD0;
	Tue, 20 Aug 2024 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724162150; cv=fail; b=E09KX1oNPhs7pEKOCkQN9qw/EZ3U03cI22vHrvPHRzsyhr1Y57rJ2jqG3sttVasJJZw9seNkgWKnPDdobqDYiy8iNnYRJROukL8uqE4STBBfnY6c2oJnSBqrnJxw/rTBZX7J4RwZbFAiOXHomOqdDTLII7ULo8NFPlu+OVnSNqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724162150; c=relaxed/simple;
	bh=bqkMap74We7uI/IpIad49xm8xw9pQ/Pi+wH5sXP6ylE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xwps8VBag7coTFJrtAigU8kYuBvuUWUy1c5jZlKp1hWKJdcmlEWYvQ040I0a6ehDjOplSpknd0vdrSfuhEqhHIa3TS3iwqfFjBgieaUFRQQUi50M8VLk8OoUZ+6dvf/aKIhTuA+85syY46ztwY+RkmJLp9B4o2gZgmjjrv8Uah8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K5XKoPbn; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K5XKoPbn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QwI4XJv3o5s5rANQn+HQXizoJ4LOjGRqFyhQzzj/Woa0erm70XcjYfSMIphXzGiO1/cWid57QNw7vJOu+yRVD5yGRbSq0Je6u65GMeRkCW2260lJ2yqHfUe/H7KPQERWmsWhWEMs46sWMgKR7SkTfTZDHqbyHNzuNnlAQ32LuznkW7UO6Cv3Qve5TNWAd1Up7P6RxyCxSYjtLmbzKWYSfSnb4Vt/vhjwutyRpi4P4UWF/HfJ568jEKrIX/rbT729DvTdOgxytRXdPlK4KXtDz/nBgJRmi7ub2kGGu/fKsVZHy1zVk3j+I26PJVR7LIViOxDPYf1H0Mg87gTVuE04JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DE1QFjYeV7NDyUrhmpnbj+0wc9Ryqe4oYj5N4IeGTOI=;
 b=wE7IFXWZPf02ozfF3OlnzffLMDBiK2E2vmR/hEk2cKDFHJ9saG+oHSjp/9W3ypqRE04gra5HiCMC7EtHV4YuBMnInOYhI/0KqGTcA1ftdeLBT2mukUlOBusp/MzL3cJGEwZED3HOjb22ekohDscIWyIUZht224+aCDrKmRTnRmBER4KDkzJz6iYZlPIBfMGRWkdEZx2anQZQSKqkgm6Ry8/9eqPho4LdTpF12ZgsrVZXlp5iX9wVot8EF2AjIsxu+DPGg/UiQoeu1d/2FOyVGroK7kmeU/xVnWwbJ18Ecs+mHNEjhR2AyPZr0nUV2vfDENx1SjjTs/rZYaz2gWav5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE1QFjYeV7NDyUrhmpnbj+0wc9Ryqe4oYj5N4IeGTOI=;
 b=K5XKoPbncwzI1L1HVK80OmwpLzzgwqJp7L6Fhv9XMUS3mXHOhlR0PHdQNQsl3DDIGuRSh/dVYCBAuUqPiylgnRAWAKO5d5dwfgQ3LcLMoz1jjIJGOlT3DrvFfVq1vzybccbtEc0EN3f/Tum5eDJLGZvYJYf3v0z0H8YIWVQQauc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 13:55:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 13:55:45 +0000
Message-ID: <28cf0695-daf3-59b1-29de-ae6b60156513@amd.com>
Date: Tue, 20 Aug 2024 08:55:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH -next 4/6] crypto: ccp - Remove unused declaration
 sp_get_master()
Content-Language: en-US
To: Yue Haibing <yuehaibing@huawei.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net, clabbe@baylibre.com, linus.walleij@linaro.org,
 atenart@kernel.org, arno@natisbad.org, bbrezillon@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-amlogic@lists.infradead.org, linux-arm-kernel@lists.infradead.org
References: <20240820082525.259337-1-yuehaibing@huawei.com>
 <20240820082525.259337-5-yuehaibing@huawei.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240820082525.259337-5-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0024.namprd05.prod.outlook.com
 (2603:10b6:803:40::37) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: fa5bab59-bffb-4f8d-dd08-08dcc11fc992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tkg0SE1wUVlGNUFqWDZnNGNzWkE0a1RyZ0IzVDZTa2htNmVDMzc4QTBuSWxl?=
 =?utf-8?B?bURMejBueWEveExsVE9UcXB5U3c2YTRDRk9kVW52cHFzbUxmeXYwQnJvd3l6?=
 =?utf-8?B?emxuNVJMdHJUakJtZGFaRHN5K1BTeGlWN3hmL1FhY2NqcWhHL2tUWC95SENC?=
 =?utf-8?B?UjlyTGMzQ2NseDdzQnVzbVV1S3lSSDJhQXY5Z0VPbWF0OHJkVGE0YXR1R29o?=
 =?utf-8?B?VHhMTzN4K2VWUXFaa2ZHMUhUNnhqYWw2MlRqR21Bbi84bE84WlpNYmtvMGw1?=
 =?utf-8?B?cUNPTXRRTkRWUy9wZjRkWEhnUVpCWmNuaTdYdWI3ZUpodW1Hb3M5NWFvcTJw?=
 =?utf-8?B?a2dVNzVuaVF4M2oySTNXODk1SVRIR3hsQUQyMW1NRHEzUTZNWDc3dzBsamJr?=
 =?utf-8?B?RjAwc3lHL3Z5YTZHSlBzbkVzV0tESUVZN3M1RkpzWndrUG9lY1lJeVBQK3Q1?=
 =?utf-8?B?Mm8vQWpOVkVsNDJJYVArTGh3dHRka25JcXUwaGE2NzhvK1FqZnVLS3h0UWxO?=
 =?utf-8?B?ZGVnR2o1RnJmc0NwdFgxb2pTNnl3TjAyT2k0NEx1M1M0YmF0d2poT1hMNVor?=
 =?utf-8?B?cTlzcXZCN3Y1OEJMdGhWazU3cm1pNDlJZFk0bzBIcGhUSVVLMnk5VU1LVHlJ?=
 =?utf-8?B?Y0N5aFlSekhYSldlUnRwRUFZOWMwamR3VTRvOWU5RVN4dkRITmVpV3E2V0Jq?=
 =?utf-8?B?dk5RVklsVWdqKzV6UE1xMTNEVjRCbGtqMy9WOHdHOElJcW5McVgzWEdmYXVG?=
 =?utf-8?B?dDdLUG44R0xvZm5OYkM2NlFnQXk0czcvalBZeUV4MTNDemtxR2RHVWl5STZk?=
 =?utf-8?B?S0wzUGVFMG8wYlEweGxDUDhYRGJMMUhGb24xcmhlV0pLMURuSFNyTkt6WHNm?=
 =?utf-8?B?bHE2VTJKMXl6QlRHaUVsVFF0bnhJam9EdWllUXNtaXpZRnRUM2RuZnNlUyt6?=
 =?utf-8?B?NGx2cUM4Yzk4d0xvU1l5N21Vc1RyQ1JXR2FUVGxTeXFMei9xSTMzWkdxblQw?=
 =?utf-8?B?L2RXUkw2UDB5QlFYYjV3ZVh3MEd6UmVaaGMzT2R5OTJzME93allWeGNYbUho?=
 =?utf-8?B?RVc4YkJDUzB3ck04SFZ3dW5NSnpGcnNtS3FVMnNpTmhFMG9PbmVTVkF1OWZH?=
 =?utf-8?B?SmZ2c200d0U4ZlhKSHRIbmx3QlVKWkJOWGJEbnBBRFJ5ZHJ6OVl4QTNURk1y?=
 =?utf-8?B?SUJwUTFiNnZySzV0VDhrT0taQWE2NzdvY3N5MEhPc2ltRHVmUWhNV21EZzZX?=
 =?utf-8?B?UHBPTnIzSTVNLzI3R0xRVS81VWM0QjVLZGJHeC9tc2tRU0djVU9SZU8vWVF0?=
 =?utf-8?B?TTcwTkdoSjIycndxWWpNeGovZERPUG1BZ2JDRlYya09mYWhxem1TR0NXWkVT?=
 =?utf-8?B?TTlUeWExbnl2bXNEZ0R6cTZzSVRYTXM2czE2Tk5PNFM0LzdmLzUwQXc4QXFm?=
 =?utf-8?B?aStvTFBJenFOMEt5NERVUE9rU1hyRFNFNExyWUlQQ0hwNEJtQW5PbmpqSEpU?=
 =?utf-8?B?ZUFVczFZUUFSQmlhU01rMzRGVzh2WlNBWTFqUmdFR29ra2tDbnNPZTdwOVg4?=
 =?utf-8?B?QURHcmNBUkhicDdKOTd0U2dTcTNzTkZjTEtDeDYzeG5Vc3gzNXorYURxbmdm?=
 =?utf-8?B?TnBjY0hSWjZRREFwcURQNmZBME8yelptOCtOTU9VaTBNNjFqNXFkV3piU3U0?=
 =?utf-8?B?eWVoUXNHeHZ0cTJQbFVLM1VBRHBYY0x5ZXdEWXZNTkRIYmp1am9QTTk5cm9D?=
 =?utf-8?B?ZXpjbUJvejRjeXVYYVlXRmJoQUNwYmlGanRtK0hZU1FpTThpb2R3ZUk4ek8y?=
 =?utf-8?B?d0VNbkc0SVhqUHdneU1udz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWNRRkFjN0pvcmFnRExFMDhVck5ua09uV3lSWlp6S0p0QXpxWFVSc21uTGtG?=
 =?utf-8?B?REdzRFNPTmtjZ21idnFrU0Y1LzdVcjBSUU92RC9pR1N0aGdQVENnbVNBK3hT?=
 =?utf-8?B?dGFCay80QXR4Q0hMTW8xc0FRS3hRVlVId2ZGdCs2YXVBY1JmR21peVRZYUNM?=
 =?utf-8?B?VU85QktSN2Nsei94bXNEbVhZQUdLNGNBaXZPSUM3TUZsbjFlVEZQcUlZVHZh?=
 =?utf-8?B?N2VOTGY2dnVjUTloMWozbUllSEd2dGlqR29NZDNoZ1JtMjFjMGxiS2JOMTVK?=
 =?utf-8?B?ZFpvK0IzU0ZjL05QRkpwMnhmVkxHeTRNU3M3b3I4N1d3Nm15QTQveHY0K1lv?=
 =?utf-8?B?WFJINTkrbTc5ZUdFZzNwMHBOcGVUUzRGaS9vZTZvTjBLRHYrc0xYRm9aVkpQ?=
 =?utf-8?B?OElCTVdjbGs4NUFwVWlGdUJIdDlYNjN3bXF6bWN2OXhWTWVCSU1ObVp6M1Ju?=
 =?utf-8?B?eGdSS0FyUTZKaGZnRzhwUTBLRG1GcWtrNThPekNEUVVKNlVkQ2Vzc2hqelMy?=
 =?utf-8?B?ZFRFTFhNNmkyTTZHQjJETDhvWERuMHpZSjVTUUw0c1F0cWVLYkpobCtEaGxS?=
 =?utf-8?B?MUpWYXV5QVQ2ZDN2d3FOTHJNSUdVSnJYeHV5dVFacU51YXV4YThuQVRYc0Nj?=
 =?utf-8?B?eGtDbkxXNmxqdFBxNTk4akVWUXF5dXNaRHo3bjZLUzFaR09pYUJLUzlobXVj?=
 =?utf-8?B?REtyNXI0dnhYckRtL2F4clM5dUxyWU04ZlUvWnhSSllaVFpXYWl1bkFxekF2?=
 =?utf-8?B?Z1NjRWtvWnFZTmJuKzZKVlY0dUJ0aFJjbFRFUHpOOHExTEQ2N0FTQnZIWmhM?=
 =?utf-8?B?VEQ5WHNFQTg5NDJjRFFpRFhUVVFPdnFiK051U3FWUzAyeU9YbWxBbTRTa20r?=
 =?utf-8?B?cWdrTjNjV1pobHVzN3FZcjV4MEdJdC9WaWNpOVlTQXNZdFdHcStvTkZYbGJK?=
 =?utf-8?B?c0g5TGg5TXNSdWlFdUE5azEwYmx1eDh6bEJJcHdSVjgvaG9PcHo5YmU2RmF0?=
 =?utf-8?B?aGZKWWVSaXU5NDg5TTk4SmxLL1J5VjU2c1I0dm8wSjlQMk9IRkg4V3lmUVJh?=
 =?utf-8?B?ZmVWZzZZNGFlUXF3d0greW10UVBXbnJ5VEtyMGE2enRHUXI0TU81WmVBU3pa?=
 =?utf-8?B?MjBMUnpmaTdEWFF0dGpKSnVEdFoxVmM2cGNsYWpRMVFESHJ5c2d0NEJmRXBp?=
 =?utf-8?B?K3FUb29GemViU3J4MkVnNVk0ak1aSCt1d1lyY0RMbkpJcWVWUmxOeElZNzlq?=
 =?utf-8?B?UEJTTmZwS0V6UHBLbml1R2VWa0dIaERHQ3NYa0pqdEg0TlJ5VDFwK3h6UXVq?=
 =?utf-8?B?T1JBMkNKSDVZU00rMjdRdCtmbzNnUXN5MWJtZkJ2dTcrWDloUzY0a2piSmUr?=
 =?utf-8?B?eXN5U3QvR3RDalczc2tROE9lN29NQlJWODg3R0lKQzlkd2M2d0xQZ3Y4SmEz?=
 =?utf-8?B?L1VaY0ZxWmF5K0N2MnlhTTkwS1E1MndUcGFGakNPcXlHUlhoN0RhcUcyRUpz?=
 =?utf-8?B?cHZqcHd1bDhuOVBWSlk1eEFlMzhVNzlUcXRiTTAycHZzei95M2RkZ3BzWGFq?=
 =?utf-8?B?VVFYVjJHejNUNnBOZ0tSVXp2RkxabkdIeHBpNmRqSVZkQzh2VVJ2a1czTjVX?=
 =?utf-8?B?d1hEVlRuL3lGMFNiMmNtYklQZUFxenRzSXJFYUswdDJubExONUoxK0I5dU56?=
 =?utf-8?B?Nk5EczBmOHhqc2grVnVMTDEvVS9nbkZXM3dGakpoN25KdExnVDE0djdZTG1s?=
 =?utf-8?B?bXJtN0UwTkUxNE4xYUJsOEdFQjJGUDRYck12MVpaTzFnQXJOd09IQXRyVTdp?=
 =?utf-8?B?TDVYNmNUdzVXeStpZzROZHZxUjZGK3lBQjV4THdmRzZkWE0ycXhhZGxKUVRq?=
 =?utf-8?B?MzFiaHVGZWI3ZnJVeEExbzFoMjZrNE9jY0VaRWNCdlIzbFAwNUpFbXZNblpa?=
 =?utf-8?B?R1htdTlIeGJMcFptcEVjUWcra1pQdmd3ZHZzVUNyY25mTFNMc2RRSzlobnQ3?=
 =?utf-8?B?MVFVSHpydUhvZjhZT2htVXphVlI5OWx4dnNiT3lBU25xRCtybUQ3OER5VDRa?=
 =?utf-8?B?R0I5ckxvM3MrbzM5YzVuUTBKU1UyenRlMEptTXNwYVVDWDgrNW5IZG0yY3g0?=
 =?utf-8?Q?LoNpiNAA1ywHjC7ddLuUO2JDL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5bab59-bffb-4f8d-dd08-08dcc11fc992
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 13:55:45.1499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ca0N5I1BjwlewMbL3KCY7f/rIQYi92aKo1ltAhHx8z7JIE4k66dsBaSV+V0QtsddElIrHL8rhbJX4cCANwzljQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

On 8/20/24 03:25, Yue Haibing wrote:
> This function is never implemented and used since introduction in
> commit 720419f01832 ("crypto: ccp - Introduce the AMD Secure Processor
> device").
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sp-dev.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 0895de823674..6f9d7063257d 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -138,7 +138,6 @@ struct sp_device *sp_alloc_struct(struct device *dev);
>  
>  int sp_init(struct sp_device *sp);
>  void sp_destroy(struct sp_device *sp);
> -struct sp_device *sp_get_master(void);
>  
>  int sp_suspend(struct sp_device *sp);
>  int sp_resume(struct sp_device *sp);
