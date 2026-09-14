Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010002.outbound.protection.outlook.com [52.101.84.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5B331200;
	Mon, 14 Sep 2026 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789372957; cv=fail; b=I0Q0X+ginmRW0TsCeTm64y+yzzJpvSZzkM1QMhtSmGWt7IwomQR4lnrrxdSy3PWJhoRDt7G5ZLYC52j3VicSUQh7khHUKkbCVjlFxSIzVsXNQ9hsWUZNWKu3jns9uLyeu6NRGPLrDwZkI+39zDwloD5stsYIQBH5C0ojrdMB10A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789372957; c=relaxed/simple;
	bh=GzylQFv5pLsK4puaOJLInUWOHj+tPdSvv114QGgb9AI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h6r+5uZx+kliVMAjcDfGSM/iqYbYA7BQKjNyMXk+1hVAU7G4UTWU0b/P+TOjX722y2H8VR4Lxb771P8tvme9LhKI/C2kNrP3fHoTc4MlkPDCAXF4Pipe7WJNjrAG1lsUv6LsYH9Lbm7A5p80Mzg5RwPMjrjmjdGZR9Cvn+WdXlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=i7YSyS1U; arc=fail smtp.client-ip=52.101.84.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="i7YSyS1U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4dEnOa8RIcU8OojtabROFdlHCBnADMtAenwg9pzr+zWAcS/IdG9dFeLAf4nAWcYk2fCXOvwFvog8EWUkwd5PDz9lmI2bpHOkfy/NmaRsPhTvHE5ejyY3glhs4+wzHxQ2BX5LBFrdCZFSzoZ9mVKnJIxcCDvWcq5b+wPjShYvjImLv8e7FZV+H5hiM43KpZwssrXttCYgPz9KosijXgbaUJjcmhpT00zifKNlpN1an+HYfQoN/OH0j6ZM8f+47k/K+CC1nQVbBfxUDBcrJfRJGk6cPETK1xvN648jNeyzbahGwiVnUN/rR65uoHx2djMg9C1YxejhdYpJmjSbYpb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpqisjkiQr6Ut2SDxiSjbgReryHC4o7Gw2qOy3ajwKo=;
 b=JWBrYFdlIyayborIZMD5bnu7xBmyR1JSHirOvpgdhzLWpzBvDmFMFoEmAYrt7yg2zxMVnmGbOuJLtu52pTienabwkogKeyjs8Sxd4V/udbaqn75wdZA9+AKqshv2zwdy4fTE+RuHHvQV7WqPtHYN+nMr7H7mpMLgQc2kJsgIlBBnc/pC86SeXQLz6XVaq+PBYYlR1XW3KznSdNdtlPN0Py6Eh9uW1e4C2qADa45u82d2ZnPLWLwiCjcJ4JA5rDuHJ+gkl53NG4Ms3iKB8scenflTHu6IxJ0sPUAa3BJQpVRycm42Q+K5S8YLzIi53V9Dqugd6tiCsfBLwYmalhWl6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpqisjkiQr6Ut2SDxiSjbgReryHC4o7Gw2qOy3ajwKo=;
 b=i7YSyS1UbuyxlzxN1Rzmh8IhFW+F8ksGPNY2vyzOXD9fkc0MPiKvKRCjShrftkeFjdKnYGCQC6NwKhJ4e9CSeRTiO8ndhXWfiMPYB7NFbTUdE3x2WtX6H2YHBIUcwOOjjccG+DTwawIZGBjmB+KJNm1tvenvITOo9fHrHIcXz4x7M/4+Jf7e+zhE4gh+9yV6BQnJcDsDOd+LTHxyZbIpTgAg3JieZqmJDHNzXhAEnliCTyfyPf2Be6yNvVjfTbzFWeckF9M7kHTEujidbFec0wCI+JTvWlkOOS/N/w+f5gVWEgYgQCZ2Z32+2aEnWqow6sOfXFPGnjwmQ2zo8iIigw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI0PR04MB11990.eurprd04.prod.outlook.com
 (2603:10a6:800:31e::10) by VI0PR04MB10926.eurprd04.prod.outlook.com
 (2603:10a6:800:259::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:02:28 +0000
Received: from VI0PR04MB11990.eurprd04.prod.outlook.com
 ([fe80::4e7a:8f03:1bfc:28dd]) by VI0PR04MB11990.eurprd04.prod.outlook.com
 ([fe80::4e7a:8f03:1bfc:28dd%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:02:26 +0000
Message-ID: <2a3bc894-886b-4557-9051-f9d3afec6ab5@nxp.com>
Date: Mon, 14 Sep 2026 11:02:23 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
To: sahil.malhotra@oss.nxp.com, Pankaj Gupta <pankaj.gupta@nxp.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Varun Sethi <v.sethi@nxp.com>, Sahil Malhotra <sahil.malhotra@nxp.com>
References: <20260914041436.3910000-1-sahil.malhotra@oss.nxp.com>
Content-Language: en-US
From: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20260914041436.3910000-1-sahil.malhotra@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0129.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::7) To VI0PR04MB11990.eurprd04.prod.outlook.com
 (2603:10a6:800:31e::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI0PR04MB11990:EE_|VI0PR04MB10926:EE_
X-MS-Office365-Filtering-Correlation-Id: b7c0ed0c-99a4-4e34-0eb8-08df123683ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|19092799006|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I/yvsGUIuVm5tE1dpYG1F0sXSK+XRFt4HbzJ09kQFbUGs/MizbdqzZcvr4eH+HHw0LnyTwNZIt6xWU6jH3cxXwCoZmo8iFFkMMAyy5pgeuj0VzqBaAVGl0EzD0lok0m/8q1OyI/r6nMWsM9afn02aGlG1yam/MrntSH/fHDF7yYMojWY48xekVsnR+8JqZQqEqSTAsNcxw3L3M7nGqahpN+0aC/jf4yg2gc7fm2zJGOxs3DtYPC7ologCc/cy08LVGiXmge+3cJToE/KSz/8L7buKhJNircrlTidl99hK2oDFhD7dwz+5ExYCQSA6sYlUZwmJG05Ir+oVGGkSy6+l2OjkrdfNmkJUn2Gp2ksNVMn5p0XVUgk3JkGDP/vCfbhsAQYQzWGyRFtAKcyj1j9whcceVRc4aevAjrMQhRLckDJa6Ylk/sE6whci9ziXCsabN1a+3v/2mLW1Mc1eikVGZaIu9t/QVFQn9XmL3C9o+gBWZ5U4xwLvddF8F9suYb3adbtQhjfpddFTdYBrRwfoEW6g6e+tWs92I3TMDK5R4fvJaWfii3VQAjadP1x2CQWlaxjg6jIKS2fERO5mrKkeGQ0GShfazl47r+Hc4Hp6upuGJD3XVkgHZBmRdTR2SUroOKA90H6yiPNoSjpIc8OPFYvgCs+r/Po7o/fOvOXsfY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI0PR04MB11990.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(19092799006)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bk1QL3MrdEpTMjR2NkdRUStIQWlZdjU2Zjk3ZWpXT1BjVzhVekFNNmIwcVVh?=
 =?utf-8?B?QjZvNVl0bml3WVM2TTMzUTJtYVJpaFpJNkZEd3RuZlBvRGFMakgySWhLVjFs?=
 =?utf-8?B?Z2ZYdi9yYnV3Kzl0YlNYWGJrRzdRckQwTlBYa1NseS9PbFY2TzI2RzI3WUZa?=
 =?utf-8?B?THNVWGV0U1JmNndGSDR1T3dMS1hNSlpPSEFGamNNdVdjYlhGcDNDVHJFK2Ix?=
 =?utf-8?B?WW5xV2l5dVYrWS9YeXI5cGpRWWpxaU1zamFTUW5QcGZRalRuQ0JIMkp1cXN4?=
 =?utf-8?B?bk9vNG9uQjVvL1czdUUyc3grSW5TdWNubHdSS1ljVkVYT2RoS2o2bGFreUF5?=
 =?utf-8?B?cW5GZEFvL3duVEM2ek9uU2l5SHRSbzRyY3lyNjJKL0hoRjlDVnJKSXVRanVC?=
 =?utf-8?B?UWowWHBqZzdxTWJnaDNVUDJaYUpoaEVVRjNocDhJcHFGby9mZUFHejRpMkFm?=
 =?utf-8?B?cHZxZUFMb3h5UmNwaThkQ1d2dmxaYTdaM2JKTU9ZZUVHZ28wYTBYRWZYU09G?=
 =?utf-8?B?SEIxTXc2L1pWZnZNdU4weWIwNkJwRFQxbHVRQS9vME1EdGNscEhYY1Yrallq?=
 =?utf-8?B?Qzd5dWRzcHI3R2RhTCtuaDdSb0YvQ3lLK2p1ZEdHN1RJcEtCTXpsT254cGtv?=
 =?utf-8?B?SW83aWQvcFNrZHdxMWk4Rm1pcVdlRkhjUGRXbUJMWnY1OVhtQmpkT1hkVVF5?=
 =?utf-8?B?ZFZBNzRKaWp0VjFZMytzS240Z2x6cHZuUEt3K1VSQndaS0kwclFBbGNVYkdY?=
 =?utf-8?B?b2RmMXlQSEppc1RNQjQwYXpQd21WTXQ0YmpXZHdaVDI0clZsc3ZjeEc2RGlX?=
 =?utf-8?B?RWV5OHl3WDlPUlExZURZU1FiY0Y5RDlpMXJxbE1SNmNJSTl3cFN2aDFGRWsv?=
 =?utf-8?B?VkhXR2tyTzFPKzM3YUdPcWNIY2lFYkFvbHVoaCt1ZzlYWXBVR0xuaSt3em53?=
 =?utf-8?B?UnFmUnNwOHdYdDV2Nmh5TkJ0Z3Z3VjJkVFJXeVEyanJFLysrNjJ2WEppSURK?=
 =?utf-8?B?TjRUS3RuNGNqMm5GcDZnMU5pc0N0cjhZdFZlckZLZzdSV3QzMU9yWGpVVGRW?=
 =?utf-8?B?VVZUVEFBbEZYcnFpMHZNdW1FbkhoeHFGbTBveEFVQVRJWGlvT3hkam5DZTEw?=
 =?utf-8?B?YnpCWkI3bCs5cnkvQzQ2TTlCajlqd0Z1Zlg4SFQ5Ui8rOE0vTmI0R3M0VFhk?=
 =?utf-8?B?aWlYUUVrc1BVK2c5NmhzYU1CR1crbWorc2tLS1dYR0syMUZkZUs4cUtLaE4r?=
 =?utf-8?B?NzlmTXg1M0hRSUVObW5BZlRoNnQ3NWVNMGloc1UwV3k5aXJSVHZjUGR4R0cv?=
 =?utf-8?B?c1MweGZ2SWxQTTh4MDR5NnNQWitocjZ4N0ErTmFad2J4TVRFcTRZMEV2RlhV?=
 =?utf-8?B?azZ2Ky9Ya3BhWERaYTgwV3NyVW5LZkt6SW9xMk84S3FGWGluRlMyVzcrRUpw?=
 =?utf-8?B?UWowME5jZWFzU2hMOXBMWXEvUlExMGo0ZGdkN1BuZ1g3TWplV29iTmlKODNv?=
 =?utf-8?B?VXJNeWVVVk9CeFU1SDJpTFhVRE5pdWtoRU42TVAvOFJqbHBYaUFURHVVa0c2?=
 =?utf-8?B?b0NZcFZlN3AyaC8waWE3N0hPU3Q5QTlCOGcvRUVhUk1iT0ZZaldCVW1LT2Vu?=
 =?utf-8?B?eGNYTnVRVE93OEppZEVHWHlUN0hPRk5LSFZxelJYZHg0R2o2ZUJadUhKSmEz?=
 =?utf-8?B?YURsM21ITUZTbUtMM1BaWlUxbkV6QldQUmVyanZuSVZ6enpJZHFWdmo4eEt6?=
 =?utf-8?B?NWthK2Z5YVdmNXNYMmlPZmlydTl5U01sb01VdzB6MTdsOCtjUVdiNS8yeG9X?=
 =?utf-8?B?M3EwN2x3dTVxVzIxd3htQnpoM1daQkFrdngrVmlhaS9LSGlSUjNYa3ZpTzEy?=
 =?utf-8?B?bnh0SWpUSjZSbHFYRytRVzN5bEd5NjE3a2N5bVFaME43cy9ab1ZOenhVcjIy?=
 =?utf-8?B?WTJBLytzTE9mcjN4MXhGdjM0T1pPM3R0N3lqWHg1dWRoVVdhSncyWG84dmhF?=
 =?utf-8?B?amovMktCaFNSNDRQT2xMRkdhRTl5MStZZWJ3azNNaWVXT0xRUTI4M29NcFFS?=
 =?utf-8?B?bTRZREt2UzVCN0VGVjdsZFc1ZERlU0Z3MVN2cUFXYXNOMm1jS2xkZFkvWmVz?=
 =?utf-8?B?N2lNT0crdW9ZY0RvZDFhcHc4MFZrOU81U2VweXpGNDdHNmRBdkNpb2puRFY4?=
 =?utf-8?B?eElVdFZwU2RzTmljeVN6US9waTZLS0xSREZmcjRuUnh2NHArMzlGVmJHUUV1?=
 =?utf-8?B?anpBcVZTeWFZb2hkODZrTE5MbkR2bEpDOGRHazdUcmlVU21CM2UyOHZvcGtm?=
 =?utf-8?B?UzQxVmVhMTluSE1Gb21QaHB6NS9EMXQwUDI2Zm1IRDY2ZDRBK2dqQT09?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c0ed0c-99a4-4e34-0eb8-08df123683ee
X-MS-Exchange-CrossTenant-AuthSource: VI0PR04MB11990.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:02:26.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHNzUSs8QrDNeIgvJoAnWVSCgBjUX4U17OMpYa67cl+OwwYpwW/NJLhMNwTnuM0t0U+HcCU+8nOJsDPE4GIVcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB10926

On 9/14/2026 7:14 AM, sahil.malhotra@oss.nxp.com wrote:
> From: Sahil Malhotra <sahil.malhotra@nxp.com>
> 
> Adding Sahil Malhotra as caam maintainer and removing Gaurav Jain.
> 
> Signed-off-by: Sahil Malhotra <sahil.malhotra@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia

