Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353130EF89;
	Mon,  8 Sep 2025 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757351249; cv=fail; b=t2vGhIXMl+8qniFBe8YrM4/SKBVSaLlFJgOaLc2rlP2BxWyyrEnSwS90Wo5d9dt0GlCE0rHvnav/RAWgGSugIwSm3jm5Avkr7TgyEP1AZLPepEOzYSR+3wuZG6IveHMcjGCXIGakJM2b4oFAfr6pdCWsWKuAeZTx8DM99m60QS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757351249; c=relaxed/simple;
	bh=r2JT/cbyw0iW6To9ZRRCx5W4dHdFXNxDZ4DKtoYPaBo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u958VVjkqcT2X3i4+NnpQgBxZy58FnY+Ht/v95aH3s+Ge63j+0oaFjyMpu3Lo55oct/tQsRUY2Pl+BNzEoLw0Rj0J1+7fcVLDC6GZG+p7t5E8IYz5nopJ//Kzj+BmsthNIEhKXTDM6BeM2rIMn2WL14Qc4iosDv4x36WzUjJdkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RpENdc9M; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RpENdc9M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ng6aB9LJmztcM85TdRvh0F5L6+jKqT37dFh0FnF/dkeJ74qDtNVEFpOSypfFCoPECHSMLixlz/WFgXoTwb6tvytEcj6WsWAL6W14pRX/+fpotA9w3Xx2EIdSHfCe+0WpcLdyQDdJQ2xeDzGdZMHj/34lQ+1obBm/THhodhcFYw3rTNCTEAPghjy3xzj7dIiJhIaA6ZAiSDMkbalWlSm1ZBF0krBdwcIH4xacxLQqufYVFqh10cPCIjQ6nVca95xElAlUCaVwIiZ2PJ8AwSLwVJl1nJDeIJCDb6o2k2ZfT2Q4mo+yj0EcyXLSJqcIgXd10L7OnAt7OOcyF6QXVpa6fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAnHGn3t2xCEX/AUmPgRG9hOdl0DCLQNpfBQ1cBjuRw=;
 b=Nx1HEpWoQ+bNDAzVqVwe65AUIAPq6fBHUP3I5szj+xNfhWxlVuKXD5MObEcH/pSG8wHapbflndEsamwzoptthtGSHOZ6Eclh19rTOXGcFpuQb/E5HF0f+ZSKGXT3n0d40EtWP8oaIS6Zor+0Oz/NAHTk01emSgKEhXDFVM3NfExgrcXtXcm/iFSWFau3Vgx1PZfnNCOCIGxn3CF84mv3+RqWgp1gqQrabjAap+2w42lvms7Q+bzGFrVVkgsqmRUdibMrjOKDB5BnLZoXThYaaKWriol7xRW1/TM8yksX/rS7zwNRfeLOGL6Lq5DLvrsj0Tr8ILYQk+lYkeotWrofWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAnHGn3t2xCEX/AUmPgRG9hOdl0DCLQNpfBQ1cBjuRw=;
 b=RpENdc9M77hSGpYzfJ16kWddLbZ1WE6PLUU0aLaKRLG3p2abCBE9iQbRGG82T1r7XGseyCH1+p/sVv0LO6wobX4OXjbS7cmXcKLmHp5OmXZCzAFB+OOItXFq6AU2XOyWJ9Qy6zD0pxfN/B2DN1FIeRS1yFFoVl/JL/DORcEJpoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6553.namprd12.prod.outlook.com (2603:10b6:208:3a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 17:07:24 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 17:07:24 +0000
Message-ID: <7bcb1ba5-e655-438e-faab-a1c99637f78a@amd.com>
Date: Mon, 8 Sep 2025 12:07:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp - Always pass in an error pointer to
 __sev_platform_shutdown_locked()
Content-Language: en-US
To: Borislav Petkov <bp@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 stable@kernel.org
References: <20250906122145.29784-1-bp@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250906122145.29784-1-bp@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0155.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3678ef-57c9-4d50-ea01-08ddeefa2e5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OG56LzNVSnBQbm9jU3BQSXpOb0ZUUlVrMFlTaVhYTFVpWVRZcEpZWFZLL2hB?=
 =?utf-8?B?U0EvazVRWmh2Rm8ySEFPMFlTQnZKdTgwUlNaWkxTYUJOdFJJNkZzbFZJRXJJ?=
 =?utf-8?B?aEpBaDJxR2lLQXhoWDJaeVM4SHh2RGhQRjRDazRMNDFnWlozWTQzcHZlOVgy?=
 =?utf-8?B?RUFzWjV4dnA0MzRKdVhqQWwyNUN3T1VRSy9CRVJCMEFMSEdkdllXKzRSbUR4?=
 =?utf-8?B?MlpHYklnajBVdWpJZTZ2TjZleEFZYk1Fa3VuRnp6c2VTZTROR2tSeUMzdVcr?=
 =?utf-8?B?L2VOTHBXVWZCUTQ4c1kvQ1NqWjJCenNPZ3FWM3g1WCtXdlE3ODdqRVpPWmUv?=
 =?utf-8?B?WGlhYTVzNVM2ZlgzcGR2WU5JemprZWJJMWNqdU13ZGdyMXhKMDJHY1BOM04z?=
 =?utf-8?B?bGtaY2JNWnhhVzRhNEJPWFFNbEVrYWtaQzZvcnM5TnVIdnEvbHdWT1laUHVO?=
 =?utf-8?B?V2VwOGowWHJFNGVOYlJua0VJems4NWZaZmpSOU13S3hsMjdKd3JPVVdNQ1d0?=
 =?utf-8?B?YmdXQnRabXRuc2V0T1VOaGFIM0VmRHVURlRpbnJFTU5obkovT2p5eW5QUmRi?=
 =?utf-8?B?VCtJN1E3RlpVZXVRQ2JRWG5nbytua294TkxKNlAzOEpLelBRUi9hUWorWWRS?=
 =?utf-8?B?RFFwU25XY0dFZkU3WkJYWjVtMmYvMHBuUjJGL2tzWHE3SXFFZWVFdm5WanhM?=
 =?utf-8?B?MHBWSmpHaGhZb2ZYSzdoaGczSGkyV1ExVW5vMk5UblJXNSt2UGlkK0VDMDZk?=
 =?utf-8?B?aHVBNnIxVUZUcmU1eUc0Ym4xcVRrdWlIWFc0MjJQbyt2QXQ2M1hMdnd5dktp?=
 =?utf-8?B?MjJwV0dyYlJ2a1crUVRVZ08reUZhUHRGeklvQkErbE03Tkl2Snh4UG14bHd6?=
 =?utf-8?B?YzBMVjRPUE9XTGtCcUg5cnl2NS82c0w5RTRmTzFic1R4ODR3Q25GNDJ4cmdG?=
 =?utf-8?B?SnU2L05hNVN3YnZQWUpzMWpaWXBhVERhSUEzWE9RZzZLR21ZQUE4dmZWMXB6?=
 =?utf-8?B?T1ZZbHhERzd5YTF5Z0d0ZEgxOUdrK09jeHNHUHBVV3plcTlJRFhKblZISndY?=
 =?utf-8?B?WVFWV3F6Qm5KTDBBcFVyaDhDT1BJaG92emdiOE5vR21YdUY1OExESjE1c1FZ?=
 =?utf-8?B?QVJqT29NYWZNdkowMjlRTDgwUEExankyNjVnYXRXSnpNUGdpblROMXZ5NTF4?=
 =?utf-8?B?YSttbm1VQUxtckVON0F3NFU0SnBFQkx0TUNMaC9XWFJiSjVlRWNPdnE2cm91?=
 =?utf-8?B?eFRWM2tQMCt6dlFla2pCc3JLWDFoUFdjVHVYeVBQeGpFS1ZnLzlZcFpXRHZR?=
 =?utf-8?B?NzdtZTV6citNbzhjb2hObjJnUGZkUHIzazlVSnBHNmlkTnN0cmtDM2d2akRP?=
 =?utf-8?B?SjBGaEs3Zm1MTGt0WlJaQjJrcHE5dlA4NXFFZGtVVEx5RlluNWxhRmRpQjVY?=
 =?utf-8?B?aTFwYmwxY2IrOTVSdmpCa0pYM3hsNTVKTC9qWGc3MHltZGlzNUZJL0JUWEdk?=
 =?utf-8?B?WXNyaUM3UDBuQUIzTEZ5bEpIM0hmZ1pNN1JTbmE0d1lVMUVaV1I5TDZWUmM0?=
 =?utf-8?B?VjRvQmlWQ2hRMXgxMzRtaEZtMnZCbTdRdEFLOGIxSEU2bmEzemFpL0U5d2R1?=
 =?utf-8?B?UVplV3E5RS9zZTkra2Z5NndPMFp3U2ROb0hybXF3Slltbk5ydVJrMHFRSzhU?=
 =?utf-8?B?cGlMcDNtRnlDOTBDNVF6RDZmdkNUV2t4ZlUwZlFVV2M3SFRyZ0t1Y1ZTWUlK?=
 =?utf-8?B?MjlsMiszZjlMdU9XdE9OVzNxNGx0UUMwUWVuLzAxMTlBZGx3eEFvNzJ6T0Nv?=
 =?utf-8?B?U3BYbENDMVhleHVOZWpwbzZqU2xCbUJQUFUzaUUrQ2phWkJFY1pwMk1YV3Qw?=
 =?utf-8?B?MTQ3QWEzVStPUUJudFltM2h2dHlYWUlOM3EzQlBoTGR6RE56SUpTY0MxWVRZ?=
 =?utf-8?Q?wl8WKE4yOGE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHMyYkc4MWRvUUJ3VEFUbzkwQlNOVW1pejMyWjB4WS84N3BzL292bmljdnZV?=
 =?utf-8?B?RG9MckdZT0doZHJJeFd2MS93YklCVkRGY3dPZUpDbVdjQVdFbUt6WEpGQlQw?=
 =?utf-8?B?djY5Z0pzbDNSTU9ETll5cEZ0Zy9aRGUzbmg4NG5DaEk4UzRzcmVZTHNMYjMy?=
 =?utf-8?B?NE5YdUI3ZWswc2xFKzMzdE9qODFDVnJPNjd4N3g4RGx6anIzSWhjQ2tOdGxp?=
 =?utf-8?B?OWUyd3FZSXUyemtVUm5uN3Z4Tko5QklHb3VqcDRmQ0hFVWZLYXV5RUNYYTBG?=
 =?utf-8?B?MmxTa3pzQlNQaVJnbkFOMlREMFQvTDBFd2orM0FCaFh0NGZjN29veGJNQTNU?=
 =?utf-8?B?cGNhNzJWK0pxOU04aTgyK3llZ0xmUDh1ZDVnYlJhczJiV1IwRVFiVkdWS05I?=
 =?utf-8?B?TUxDTFo4UjIyWmFMeUpuSUlsWGVyZGlORE1ZbG01VzJMbEh0eGRReUEzcXRz?=
 =?utf-8?B?Uks5OENLMEp5WFFRUWY5aTYwN0t1SEs2RURDU2twNmlDR05odGQ0dm95N0dB?=
 =?utf-8?B?NG9PaGlGR2NJU3ljWFkxUUZnaU83ZCtGZTYzWk11R3puVWRjLzllWmVGMnJ6?=
 =?utf-8?B?S2lBQXpWcjFDTEh2OXJOcWtmUllMczFrQ2h4UFFoL1ZXRjFvMFh1Z2pnNXJN?=
 =?utf-8?B?Wjg1OXNicFQ5M1ZSNjN6MytxQklIdDlydUVJMGZZQmwwLzZJdktTdEx2cEpK?=
 =?utf-8?B?bElOaDVENXdaTzNrT0JsSmE3a0x3M1BQWmhtVThreUUraFo5YnYzbDVtQnhH?=
 =?utf-8?B?UkxDdGR5b2ZEajN1endEa0VwQ1pBMG00Vlc1S1BBM2dmQzg0bk5xM0E3NE9T?=
 =?utf-8?B?ajZsVEo0WXpveUpGNEtwS203ZXorR0VGV09tZGJhTzZndjNEMmQ1Ny9tVkFO?=
 =?utf-8?B?N1ZzOWJjeXhqOUs1ekFKbEgxM0FxY1NPcllFSkdHUUxPM2hTMUhYcXFLTTM4?=
 =?utf-8?B?Y3p6V1dObkFWTXZxYzF2Y2xxSWZIRnhHaThuQUFLNVdQaThCb3M5YlJ4UzBk?=
 =?utf-8?B?VlZ4OUoyL0ZOUnJYek8xbHJMd3dDOFQ5MWxlUm44OUh3TG5VSE4yMUh3RzNI?=
 =?utf-8?B?Ylo1VjdIYllHY0YwekZSRWNVZzhXOE1yVS9paW5YTEZZcjVmOUdTbFNhekx6?=
 =?utf-8?B?ZVJmNzhvdUYrRFRuNnZTRjFhNjlGU3VrblNYV3VaUmlmWlVXUEVWVFlCTTBO?=
 =?utf-8?B?Vm1xRGdGN1NlUUJ5MWZtMjk2dFdUTjR5cFJmVW90MUJYaEsvWTJuRitWWjRV?=
 =?utf-8?B?YWEwY3ZKaXlyUTQzSHlXV0RaMUJTOTB3RmlUUzZwNGllcFRNb1VkdllORWF5?=
 =?utf-8?B?c1dKQU10aDM4S0xCME5oM011bTJwV0J3eFpNOWp6TEdRQXFiZCtYaDQvckR4?=
 =?utf-8?B?eDJReit4UXBZNk41V09kRGZXMXZpUk80RU03S09vY08rZXRIQWtaVkZDTmpU?=
 =?utf-8?B?d1NjRzB3TDNIRXRSZmE5TElUMUhJbEdsTWFYajg4eHRFVGRqbnNONk0yYTZO?=
 =?utf-8?B?VkxhYnFEV210b2ZENmhnWHVsQ2FvS21zS0xoQ1IzY3IzOVNOS2RHN1l2dS9V?=
 =?utf-8?B?eWxLRGp3d3JtM054YjZFalVaWVVqQVJrZ21yRm5KVC9LaDJhYlRSaTFZalFk?=
 =?utf-8?B?NzEvWWdjV2t5T3JKcnR6MWk0ZW4rYlpSVElOUVBvcy9uY1g3Z0g2SGRhaEdT?=
 =?utf-8?B?UDBmYjVWTlJNc3N6T2Y0RC9nSW1oM2xGZzdRY1dtNm91aktRekVmaWVmckd6?=
 =?utf-8?B?ZG42SXpMbGFrQXk0dWl0cDhVbUlXN2YzVFJPaFNHa2I1UGI2Ky91aitXaVcr?=
 =?utf-8?B?ZHhuNnl1VThUdDJjZ2xXZlFoOEtBZjNqYVRSSGFOSDZEd3BzVzdRUHN6QTZo?=
 =?utf-8?B?SHBYQVdKS09KQXBSNzAyNXkwZWFtdHR1VnlLWnpZd1VQY3NsYWJ6dW9pa3V5?=
 =?utf-8?B?aFdvM3BKRWpUWFZIOGp1RXFWK2o1VlJJV2RtT1N1ckltd0Exa0NQRDhmVmZp?=
 =?utf-8?B?NkJocEpXY3pFOHI1am1qRmRTM1JPSXNRY3I5MEhERDMwcGNCanVod1NDTmkr?=
 =?utf-8?B?MW96NFdHT2dlYzhkaFZpNndZSGw1dDhyL25tcS80ejVJNkZkMmM0SnlZek1M?=
 =?utf-8?Q?1U6WEMhUZXMUCj9KMt4wpKMcA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3678ef-57c9-4d50-ea01-08ddeefa2e5f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 17:07:24.5658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UO31/Dlc6jDcTznc/uy+QIYqfh4fLukkoDzyOS0w63C84dwHfbxXC2jF/k1uqeBjKUwsc5wJXRZqLOGPxwnp4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6553

On 9/6/25 07:21, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> When
> 
>   9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> 
> moved the error messages dumping so that they don't need to be issued by
> the callers, it missed the case where __sev_firmware_shutdown() calls
> __sev_platform_shutdown_locked() with a NULL argument which leads to
> a NULL ptr deref on the shutdown path, during suspend to disk:
> 
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP NOPTI
>   CPU: 0 UID: 0 PID: 983 Comm: hib.sh Not tainted 6.17.0-rc4+ #1 PREEMPT(voluntary)
>   Hardware name: Supermicro Super Server/H12SSL-i, BIOS 2.5 09/08/2022
>   RIP: 0010:__sev_platform_shutdown_locked.cold+0x0/0x21 [ccp]
> 
> That rIP is:
> 
>   00000000000006fd <__sev_platform_shutdown_locked.cold>:
>    6fd:   8b 13                   mov    (%rbx),%edx
>    6ff:   48 8b 7d 00             mov    0x0(%rbp),%rdi
>    703:   89 c1                   mov    %eax,%ecx
> 
>   Code: 74 05 31 ff 41 89 3f 49 8b 3e 89 ea 48 c7 c6 a0 8e 54 a0 41 bf 92 ff ff ff e8 e5 2e 09 e1 c6 05 2a d4 38 00 01 e9 26 af ff ff <8b> 13 48 8b 7d 00 89 c1 48 c7 c6 18 90 54 a0 89 44 24 04 e8 c1 2e
>   RSP: 0018:ffffc90005467d00 EFLAGS: 00010282
>   RAX: 00000000ffffff92 RBX: 0000000000000000 RCX: 0000000000000000
>   			     ^^^^^^^^^^^^^^^^
> and %rbx is nice and clean.
> 
>   Call Trace:
>    <TASK>
>    __sev_firmware_shutdown.isra.0
>    sev_dev_destroy
>    psp_dev_destroy
>    sp_destroy
>    pci_device_shutdown
>    device_shutdown
>    kernel_power_off
>    hibernate.cold
>    state_store
>    kernfs_fop_write_iter
>    vfs_write
>    ksys_write
>    do_syscall_64
>    entry_SYSCALL_64_after_hwframe
> 
> Pass in a pointer to the function-local error var in the caller.
> 
> With that addressed, suspending the ccp shows the error properly at
> least:
> 
>   ccp 0000:47:00.1: sev command 0x2 timed out, disabling PSP
>   ccp 0000:47:00.1: SEV: failed to SHUTDOWN error 0x0, rc -110
>   SEV-SNP: Leaking PFN range 0x146800-0x146a00
>   SEV-SNP: PFN 0x146800 unassigned, dumping non-zero entries in 2M PFN region: [0x146800 - 0x146a00]
>   ...
>   ccp 0000:47:00.1: SEV-SNP firmware shutdown failed, rc -16, error 0x0
>   ACPI: PM: Preparing to enter system sleep state S5
>   kvm: exiting hardware virtualization
>   reboot: Power down
> 
> Btw, this driver is crying to be cleaned up to pass in a proper I/O
> struct which can be used to store information between the different
> functions, otherwise stuff like that will happen in the future again.
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: <stable@kernel.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e058ba027792..9f5ccc1720cb 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2430,7 +2430,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  {
>  	int error;
>  
> -	__sev_platform_shutdown_locked(NULL);
> +	__sev_platform_shutdown_locked(&error);
>  
>  	if (sev_es_tmr) {
>  		/*
