Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0056D17BB17;
	Wed, 29 May 2024 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716996127; cv=fail; b=eV6EgbC2p4SCcAh7FUlBZTTrXt3nU8KugY+Tzy0McHNvUtaF22yDIMHuKPgQwqdfVNp2os4NWbjIOOnqqSI9AnBh+lNsgXCTkCU2i7aBXm/rR/OPWgoAjwd4b6GxC7yfdvUZqBpYF0UXGu9U9RaIHl9C0tddGrV0Tkx4MD7D/JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716996127; c=relaxed/simple;
	bh=IZEBq2SPjCbHaSMZjwQmslAMGGKgFC9zOyMZndddVy8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dgjHfG6NmXMehuns2OARVBVM5Br7Ot5N9JZpthBcP2HQdOjzdz4gHY/Vl4FgrC1m/mDfU/O4yKwl2Bg0xalI9HspPiPX1pLYRGK6+YKfb6+UBZphTmITQldt9jhHkSXNmu891Q1ci3s47JIE4ESZ9j+5+CMKMgEXpBOQbuB98Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WTvN2d5J; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WTvN2d5J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWajU+rTxrcQ49JmNungzztrpdWJVsqBRMrWFooTXpHoN/SmHQCIarJGPwEwUBUNasOpM1wHmKoOtWSPGWT9fPGRBzOEpM8gEjUutCxFk47yL4PnadI9S04PKCAqeotAUQijRE7Pj66CkRl2MKGaIz9R4uF9B3osV3IrYjP6hZbNZ0cg8rJKgPbN8VxFPlbTlSfM+S76whATZqYo8FOL3s5HWmmXXA7KMm0d0nxG6AoWCF0aDO0iJGZ+7Mym7gspbUPJ90rloHkcA2H31M99ep/bXkKSu9Ky3+j+ALvuTXYcm8Y22SzDLQtAltz9pENA+BdR/3qveSzs0b4xr+1sIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHAkm8TaS44OJ4gA/XfrnsZpwLTJAn5G8zvhpOjvW8Y=;
 b=LkOliEgznrOcxQ+RgeBduRt15Pc8YM3KGLNzqMUe/b4WUPL3ycHnCfToW0JySUfT4kGXutlcKw/a3ENqP1r8zvvnWMEL+7wabTN+xhjayWZBGx40D92IhOJrqWiPyG4EyBJIfQLD6lgFr5MxDlkGlndh6YU5wvR030AyMIcEN7ABICYWiny8v/hFbSALOdmcz0KNF78TTvvY7izbLF+MCNJ+3Ay/RprsyDdiW8ImFYM1kh7MDU74bYcBMoD+GeKlrxBy5zK1vtrGPXms9Q3RPvZFGnW2ZK1q2ZRLiOM5ISKucs4YZ7/q/3zKvC3+BUZSKBV5Q9PSBYPMM2E6evtajg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHAkm8TaS44OJ4gA/XfrnsZpwLTJAn5G8zvhpOjvW8Y=;
 b=WTvN2d5JUQiPENEETNPPMz8XEf+UUwDnazvw8b40J+HyCLliv8jwUeeeetugEaxH2zDAY5agUS7xpH5qI3EHUwBLW9xZuFY2Lpg0bG9pzK7Ilnn3z1qTK9h59AK838usuOmupiLqoE6RgRGbpeOYUsqSefcITDgjOQ23bAwkc+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CYXPR12MB9337.namprd12.prod.outlook.com (2603:10b6:930:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 15:22:03 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 15:22:03 +0000
Message-ID: <82c1d98d-0bf7-b65f-2ca8-7b19e3229461@amd.com>
Date: Wed, 29 May 2024 10:22:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 5/5] crypto: ccp: Move message about TSME being enabled
 later in init
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
 <20240528210712.1268-6-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240528210712.1268-6-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:806:130::22) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CYXPR12MB9337:EE_
X-MS-Office365-Filtering-Correlation-Id: e5aef066-e868-4fc8-57cf-08dc7ff317b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RENmNFZLNE1VdXhhQ2NzRnE3MnhqMlVYWlk0QkxRdkYrdmdCUFNPNlVGRnJU?=
 =?utf-8?B?QTFJSzRWUTBreGt6Z0lvaGxMcEsyd0xJZElMTnlRUGN2R1R3T0FIM2dvaG1N?=
 =?utf-8?B?cm9NOTQ2OGt4SmxzcnRHZ0JPMW03ZEJBTDdhZWk0RGZBYlpLYVlhTWhRV0d4?=
 =?utf-8?B?ZVUvVGhtNEZnejRJMHp5Q1hVRHF1ZEoxUFFiUDYwWnFnNVhmcHlPKzF3dXlQ?=
 =?utf-8?B?KzB5RDgrMzdJVHBoZ2YrY3FYNUR2RExRUnJKS3RFeCtOd0tGMk5pNVQ3UTNY?=
 =?utf-8?B?MFFkWmN1UVVSa2x6UEVkOUhzWUlzbTR6Qmw3emx2UHNBdENNQUVRVlZkWWh5?=
 =?utf-8?B?ZmN0NEFUNjRhWlduaEVmdG9OYzRHZWc3S2N4SlNkZUxOM2NuUTIrVFNLcVNH?=
 =?utf-8?B?WWdMWmVUQkJheVU3b2tHVmQ1alFLQ2R6aDJlUUhpaS9Tb2Y0WG5ZcFkwUTNE?=
 =?utf-8?B?aTNqNW5PcnY2UlZQZzVxT0dhbm9MRUIwZUpHK3owM2NQazhaeXFBeGovZ0hU?=
 =?utf-8?B?QzdIakk2NDNjVHJ0RG5WZElSYlVGR2FUelljT2YyYmtaT09sN3FZZGpXL3dn?=
 =?utf-8?B?Tk5scStNZGNNWjJsdENIcGVmdFJDUmg0V1NVMmR3c0Rsd1ExL3VQU283K1pF?=
 =?utf-8?B?NS9KUVphOGhoNHNHbjdSRWJyazJaU2NnM2VQc21zdVVKd3cxN29sTEU4eHZj?=
 =?utf-8?B?TDVBbEpYb0NzSm03c3BIaS9iN25TUHprZENFcWd4eGlGRFo2TTY1NVJyN1JI?=
 =?utf-8?B?ZFQzUks0STkxb3hSdDJZOEtEMTdodWtzZ3N2emJzSzBpNzZNczl1U1VBb3pW?=
 =?utf-8?B?RnljRFpwMmZscTR0ekJXVEZDbUNacERWVkR3alZGQnNZVTc4M2Q5U0w2d0Vz?=
 =?utf-8?B?K0NkRHhEbi8vRHZlQ2FyczN5UFlNZHZhN1A4SHJVTGMrMkFpS0w1MCtSQ2kr?=
 =?utf-8?B?SWdSaWRUMTRhZnhQVnFOZU9qZUJTL1hMenlXZmQzQm0vMkkzQzhkNHFMQkhk?=
 =?utf-8?B?TUJHQzFNakF2Z0dRbXRXYXIzY2ZKcEhYNi8rSlVpWW5QMTFNeGpXc21HS3Ey?=
 =?utf-8?B?MGNML0VMVXFSS3dnV284a24yUTIwaVlxbUNwOEpwU090R0wxbTJPR2tmTHoy?=
 =?utf-8?B?UmM5dkpkSWltaEFjbFlkS2xwdDhzSUV5QlhKYzNuQTVpUDM4ZmR2TytyOHYx?=
 =?utf-8?B?RnB2THhuQ3VsaHNFek1SVGQ1SnZlcTRwTk1Ha2lVZ1Y4L2MyTkFHUTRSc2ZO?=
 =?utf-8?B?YmV6b2JsRDRDQzY1bU50c1Y4bXgwRWZLMnYyOWZIMzFoQWMzMU1UWGNxS0Y5?=
 =?utf-8?B?V0k2OFdjYTc1b3pNVE9VMDN2VzlEZndUT3JSSXVtcklTWDBFOU5aR0tRNGY4?=
 =?utf-8?B?UnVnRzFtNndQSDRhSGFYZGFUSldiUmNWcThTckhUcWc3OEpKaCtjUHNOOFl1?=
 =?utf-8?B?cndnUlZwcFFuMU95NGpDUXdmYlhyMlc5Y28zU3ZvMlRuRityaE1DY2hyWndq?=
 =?utf-8?B?d0g0djF2a3p0ODRqaiswcXVKU0RuVVVWMnRtL2xiZkMxZVhyRXVSaXQ0cmYx?=
 =?utf-8?B?MzJxQ3NLM3ZxRGJ3azhkUVR6SjFRZHRSaU0xeWNmMHI0cmJBYUtSYWxTVUJi?=
 =?utf-8?B?MjkvWXM0Tm9FQXk3M096dEZ0WDFxTFppMVVlNDZ1Tk80UkdaYnNVWDRqbWRt?=
 =?utf-8?B?T09BdE5nWEFsdjA5TGN4SDlWWFZmWVhjc2Z3eE4vK2FVWitEeE9MZ2pBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDRlTmc3cGZjaXJFeFE1Wk5Ud2lPeVY3VmFBUElqdDNNV3ZYc1lFcHRsTldW?=
 =?utf-8?B?MUo2TkZJQmI1TzRnSkpha3NVZ0pLVS9hRjFiMUc4T09nNjh0YVBtbU90V2gr?=
 =?utf-8?B?N3lEVGZyMllDdU92Z3BhT3JBQVNURmZYazZHN0hNbUdqVDE5VzQ1bDVlV1dm?=
 =?utf-8?B?ZENYT2s0aTFSblBIRHkzQXdsL1MxelBuSE0zUVhCOW55TjBtM2NvMGtWVWtK?=
 =?utf-8?B?VXN5Z3FIRkV5TU9Eak5VTzRMV1pKRVc3MFBydWlBMyswczZ1dGFwOVRxRk5Q?=
 =?utf-8?B?SHZGaCtLMzdzRFBtczBqdHhoNlo2M3AyQXdZb05yQXBnN1Z2YnQxWmtpVExo?=
 =?utf-8?B?T1pvZnE0NFJXVzRFQlM1RkRjU3ZGaFRTVGs5NGY2b3EyMmpjbnVVRVpQcU9m?=
 =?utf-8?B?WTZ3RnpJRk15aFkzNGx4cFpRUlFNM2Y2dE40eGdwNVByNUY2ZW00eDRId0c5?=
 =?utf-8?B?ZVhmV2RNcDU0UFBLOUQrYWhzNmxvNi95MHEyOHQ5MVZKMzhTTitMZnF4MnZN?=
 =?utf-8?B?V1J4SElEdmNOc1N3RGxMdDRiN2Flc3FnV2dLMTZ6T0NTWk1QQlZUZCtVc2N2?=
 =?utf-8?B?RkdTL0MxUFVZaG9qZWxlVjhIQUZaYVVPajJtR3orZkZlMVMycEd6b3d2VGg2?=
 =?utf-8?B?ZElaMW5pRXlmNWs3cCtDeVRiUDRHRVRxdXhETzZRRVN5ZzFKUVZrRXFtaGFt?=
 =?utf-8?B?YWVoOXZqNE1IVHZCQUlzQ2QrWVRQUDJDMXZPb3lZKzl5cDI5U2ZwZ29QM2dM?=
 =?utf-8?B?dnBCdzJiUmk3Wnl1VHVWSEdQYy8vQkhkaXhNdEFYck9kbjlXdGluR0pwbHpa?=
 =?utf-8?B?ejR4eXVZSmt6dHJxeFUvNUtRSEFwdyt3b3JtTmFBamQyRldaMEpyYUJVUmpR?=
 =?utf-8?B?dHpTb0pycmg2bDEvMTVtemlNd1lyanVGb0VFTTJDbThZdUxvRmhScXZFd2RL?=
 =?utf-8?B?NGdwRWtXU2pyRWlIb0FVeXJSYitxcXJUb1d1N0NFUVhJSmJhTzZrQzFZelZr?=
 =?utf-8?B?VVhzK051WjhraUZoanhINkJtNUVGSWhCRzdsd3h0SGljN2ROWUxqcjhmSU5O?=
 =?utf-8?B?U1FEaEluaFhKTU5iNVF3WlZEdDQ4MDZhZ1lSck1zMVdMMTRKMXBJS0ZaYlpR?=
 =?utf-8?B?dSt3MjdRUTJSUUVHNXZMM3V6eW5NWFdWZlVoTzVhdXVzekMvRGNmeVR0NXhS?=
 =?utf-8?B?SGxnaVloMWJPTW5CNk9ESk5lMUVWUDBSS0hSbERnTkxoS3hLWXNFQTlBNlNy?=
 =?utf-8?B?RzYrTVdWWTdRZHUvZWNrR2EyVjhaeWxxeFQ5R1lhTFVXVTZDdDJLbHJzVWFE?=
 =?utf-8?B?ZUZxMjZ1K09ZWkRjcGhraW84L2dWSUw3WlhrNm9YYm9yd1lCTUxHRDFwdWFU?=
 =?utf-8?B?OXE1MURoRE52SVREZ29ocGROVGg5ZlpSWUZPTlBuc2Q0TkZvcTlSdXNDM3F1?=
 =?utf-8?B?Rkd1dFN2ajNQR3NrTlNUTW5tZVU5ZS9aQXhGNVhFL1VsTmhDeC9IRHNwQ0h3?=
 =?utf-8?B?bEJsUGFzcHJkSmwzQTN1RjRKT2ZFK3FnSmJQdWVBWlowTlJrOVFxSmVVa0F0?=
 =?utf-8?B?aUNLN0FmeW53TGoxL2F2OFdlWFhKYXhkQnhrL3RlN2lpb1F6dXpXRk96VmhZ?=
 =?utf-8?B?UXJ2dVpnTjZyemdvTUxSamJFc3lUS3l0T1VZZlZ6UUxrRFF0L2Q5N2JzZjJ4?=
 =?utf-8?B?RGFJd2RjemxqV1hlWlhHV25OUFdSeUNmSklPbk9iUGQxVXBoTjNDdGxIaHl3?=
 =?utf-8?B?NjVzTHVmdmIyeWNLNUo3N0t2T3BjYi9qZzVHTW96VU03cjNaVVV1Z0g0aHRx?=
 =?utf-8?B?T1FQSHc3bzA2U3NNTGxhRi9VQVlFb0Iyc1ExbVdHZFpKVWdrbG4ycUtmYkhv?=
 =?utf-8?B?SlBXOG0vLzNTaGtWaitmVlVEMkVBMnB5SEpiazBNL0VlNXpHdE9IQjZPZytY?=
 =?utf-8?B?R2xla211RUtZRWNjSEgwY2lJQTdDTU1RcWRvWHd1Q1E1UG0rUkx4ejFuYTRC?=
 =?utf-8?B?ZXcvQWEwZENvY01oclFUZ3hyTlpMb0V6WDJ2NVRZVnpsMEpEckwyd2hjanB1?=
 =?utf-8?B?Vk5mRGRNTzVxVGxDZ0FiQk1ubmtjclFYUHJNNVptTm1kY1lWakRYTmJvaXlP?=
 =?utf-8?Q?owwJnqqQw1PJT1RHwAPlahlg8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5aef066-e868-4fc8-57cf-08dc7ff317b5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 15:22:03.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KJzr9zBQcgt20lpv73blYzFRzBL8GEJy1ZZ2hGK2ls8ihWFWzudtYqndQOMRTYaLaCSfS6GDopQ1llmDhduyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9337

On 5/28/24 16:07, Mario Limonciello wrote:
> Some of the security attributes data is now populated from an HSTI
> command on some processors, so show the message after it has been
> populated.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v1->v2:
>   * Move code from patch 4
> ---
>   drivers/crypto/ccp/hsti.c    | 15 +++++++++++++++
>   drivers/crypto/ccp/psp-dev.c |  8 --------
>   2 files changed, 15 insertions(+), 8 deletions(-)
> 
