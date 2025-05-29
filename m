Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AAB647;
	Thu, 29 May 2025 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748548102; cv=fail; b=pZpeMO7tQ0d8B1X2G7ArjUSlpAwDmNygztZEVwaefRm/LduKjEvLCePIc3T69B2/Gezwxfzy930uwYU9Aj9USlusQWMLwMESMRKlkYvzBrlzHEzOv5XGEP9bsij0ElkXkBme6W0cWGHrYyYapm3D+UcEyG1ymkgdtU57f9MsT8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748548102; c=relaxed/simple;
	bh=46EFyIniraNjO5S3JT2YATTUH9+fWLniOvCCLj89NVw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WlrJFC8ne5RX/kjzeMbct5DXEWkyfBD6CNsPKGHIBxAvBbb4l/SrbrTxHyeJeqC8ji7g6dYl6tHB/VnM988hGUpG1fOoTTDd+vna0oM4oI0tcSpX/bQeb4sjqGb6asJKpmodttUVM+6RM85VtNb6R0IG/tHUsqBjMDA6zmm/jn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fgRFv6qP; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fgRFv6qP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qzk4b8OfATkVtB8Vi3PT5KmMtsURjoEkylVgQSNiT3QPeGtaoDFKrGPBefNeIYuXqTv7mUxbA/LGYSZrSj7UMtlSgFNX66npAnL/NkjPOgyz0elvUVgROyz3fQn1mGO07XW0QT8ocrzv/bTO7s64bveMu2BdclEfkONhQa6sfL2rIgMRgzVXPAxs77X+jgufB3HpWaWk28TjDryTgZGwAXk5Wv2+3mxNn8V8xPCD62CDBRlphby3A2Ct8OVR5Z+V/BRRll6G9JorZ+F3XktUtAoq10XdAfXSk9DHE9ageBn1UfYAdPcTiIbABEI3XGpR5nTSzuueX48QBswm+xiugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWvjR9zrXwhSU9byVnHb0NzlTOOgplHyLRUAEc8RT7I=;
 b=W81GGJ/+/zO2xUuYUORC+zcB105dwF2MJkHL5VRZsg6OSboJKJY3pMHM80Yzwxng6TyqKPG/JhOtSxL3KTJlBayuktAAaeqxPpGTWjsNC0lymtcj/1TViYrtNAi1hZUzLRN7abNDvPXPIcCfUzzfj6mQLv+cAXvnP3i86qlvbo5ogFKKXbHhJN1KHeM5/pzLKXPn/NSyWP3mdLR/44At/NUng2ZRr3V+OuWSeWJqsZcyKJuchf/6FrHihDjvJlSifS6BwG12Xc9Gghk8Y9epVT50Yulr5mjufJ5wZ73aRBy/rsYY+qyPEOw48SwOI9ERdjxG2VHS4UH/7EQ8mkkxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWvjR9zrXwhSU9byVnHb0NzlTOOgplHyLRUAEc8RT7I=;
 b=fgRFv6qPVrx4XD58CVjHuRb8P/dutsf7L/hhXSwH/UJy/afVp19NE6ETpo4JnikY5n9pN/Oy+z6EALJ5uKyYyEEwAeklSaOa1BmoYlCO5Zw9nJNFXpkKDOR1TErfclr4x/DNvfmnV5zKg72yWNmXwyoB+RSQxX83nWzKnH+exhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB8948.namprd12.prod.outlook.com (2603:10b6:806:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Thu, 29 May
 2025 19:48:15 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 19:48:15 +0000
Message-ID: <41273296-9b5d-5e2b-e51b-3b94c4cfd606@amd.com>
Date: Thu, 29 May 2025 14:48:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Fix dereferencing uninitialized error
 pointer
To: Ashish Kalra <Ashish.Kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, dan.carpenter@linaro.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250528202018.78192-1-Ashish.Kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250528202018.78192-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0162.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB8948:EE_
X-MS-Office365-Filtering-Correlation-Id: 0da23997-7ad2-4d0b-3d3d-08dd9ee9c08c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEJSRk5naTBqMlNwMVRISWlqQUt4L1ZRQ01SeHZRdWlwblJuN2NaODlOWmU4?=
 =?utf-8?B?cFpXMnR3SGJTZHNRcHRtNjJSN0RGRVUvU0xMMENYZHVma2huWDBpM2J0VTVa?=
 =?utf-8?B?eDRVYzFRYXBJd285elJhMDF2RndvUEJxZVpMUkpvTFpmR2lIa2YzeC9HQkJ3?=
 =?utf-8?B?cHpSUWg4UU5VdVJiUktYblo1aWtFQmlOTkpvdkQrYnpVVGp5VitKdzNmU2pX?=
 =?utf-8?B?eUQ1aXFUMVV2UVF3QWhhaWwwNzh2Z1hKbzcxQmtiajdPM1pHeWd3azhpTHdK?=
 =?utf-8?B?WjNsbG1zMjR0eHp1M2xjZjFBUW00V2N5NGZucDhEY252a1dHMitIU0NzdjBO?=
 =?utf-8?B?RkRqdmdwbGdzbDNSVjZGdndnLzJHYUlpTHVoZHlXUzduTGlIdXpQdnl2cDgz?=
 =?utf-8?B?VGpwR09lN2dFRlFmaGVrVzRIRXduaG5lalp1UkFCZGZlUUMrdm1VSEtIZ0ps?=
 =?utf-8?B?WWN6VXlnZmwxaE96YTNaZW54azRJanRlNU42TlBUQ2l5V2J2c1ZTeDhQV1Rq?=
 =?utf-8?B?M1VFQWVBNlgvUXJBWFpVVXhmRStnWjlITnNEVytHMCtQMHJiaTBYWDh5a3BR?=
 =?utf-8?B?blE0VlladW5mRWFPbnEwelk4bTlZUytEMHhPbTlpVzJwTTVHaE5rM01WWklw?=
 =?utf-8?B?enZBSnV5Q2F0YlZwYnFWeEtCS1NONlQ1d2hCRTlKOFpwbW42clY0bjM0V25p?=
 =?utf-8?B?SE10SGhjWDZiYnBuc0xBUWw1Y0ZGUWlTdHFyTXhYSmFWMzJsSkIvaWdrWTVZ?=
 =?utf-8?B?MzNRU093MHpaUmwyZ1dCK1VibHk4aERSSUpwTmt3ajVLblZaWkJMMFVYZmNa?=
 =?utf-8?B?NmwzZ05rdUpLMVpXakN3dUk1SFljUUxOWk4zNGpnaTFvaE51Ynczc1ova3U1?=
 =?utf-8?B?TlJnWjEzZUpmbVRjVzRnTUFsZ1NhNVBMZ1ZocWNLMUhPbTRWWVhxcU9jTm0y?=
 =?utf-8?B?NVkxNFNxYWo2a0hQQk5aZElWS0l5TE85RWJ0bjdWZCs4NEpCcHZ3Zy9WYnJv?=
 =?utf-8?B?ckJ0OFpIbS9FTUV1UHZpQXBvMHkvV0hnQWRuSHZaWjM1d3hWOExBZG5Ya2hQ?=
 =?utf-8?B?aVg3YTF0K201MWRIekprRFNUeTR6c1JhSndqYnNibDFDTmZyQmJyTmVWYklY?=
 =?utf-8?B?bnErR2FWQXh2Uk9MRHFObHpvSHAvcGtQY2RTcmxiVzV5TFcrTW5tSVpGYlFn?=
 =?utf-8?B?K3cwVC9zbHpGM3J1VnpORm9rbFZkTkZsRWxUeVpQd2E0eXRzWDV0VHVEL0Na?=
 =?utf-8?B?c0ozMHBBblAyK1BxcmFGWUhZRUllUkZzVEo1enh3aWxjc0laS2Z5SGdIdlZZ?=
 =?utf-8?B?RGkwa083OEFIM1IyTG13RXQwVXBYc1I0L2FUNjZGZStGdnQ0WTNzWkI1QzRH?=
 =?utf-8?B?dWpLYmRhTVlmQVVLSGtaUUtIUnFlOEplbUFESFNOb1BrMDVTVkd5SFVkY0hL?=
 =?utf-8?B?Mm5ULzlpNXo5NHBzaWNZR21MaE53N3dLYWhxU2JVeFAxZVRobWFNTjZtbkVB?=
 =?utf-8?B?UWwzVXFqN1ZOVGRmc2xMRWtWUlYydHluSGFYZzNlZzY2aCtzMUNjVmhjK2Zj?=
 =?utf-8?B?VHVMOHEyOFk3ZUNZWXgzKzdPc2FQZ1lmTlpaeHBuYStlRXF4dGR0ZWcxVUll?=
 =?utf-8?B?N0FFU0NnRFFRNG9zTFFkVXYxVTZnOGZvTkZwZkpFY0E4R1ZkdDRNUjlkVU5a?=
 =?utf-8?B?YSs3ZlpOektJbXllTlRnZVRaUGFEUVF2V1cyQ1ZveG1RSkZ2YVhvU0FMRkww?=
 =?utf-8?B?RnRmZzRLZjc3NW5CczhUM3pzWE1NRmlCVkhQd1l6ZnAzWnY3allBMlY4ZTFj?=
 =?utf-8?B?RXFtOUdyaDRiVHdQQjFLcm1pbEc2dEtXbkV0Y3hzdnJ1UDBEK00vQkRBa3l4?=
 =?utf-8?B?RDQ0Rkl1Y0xaVmNPOFVzVDgvWktwZTFpcE1mOWRJT2pLUzFjdVY3NG9kQ25T?=
 =?utf-8?Q?KwXH8BSA1oM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEtPaWJ0cXZSYnowdDRmalp6cUp2ZktqSmtFVm9LLys3TGR6VnNlMjFYcVQ3?=
 =?utf-8?B?d3hjOFB5cWNodEl6WUNiL1VWbGpSZVRIZnN0MEdQZXQ0dEFoNHc3ODk5OTFk?=
 =?utf-8?B?Y2NiUUo2bWcwNFI2OFRoQ0FuWHIrbmExNFNmVzllOEdqdWgraWtTZDlGK2pl?=
 =?utf-8?B?cVFDbHJ0dytRenNoVjdyNzcvMUMwUWlJTFNIL25PSUhKelExbUFNWGdjbHNQ?=
 =?utf-8?B?Sis2bGdvVXp1L3F4MkVTSVBpWm5NcGlVeG1UeGdZT0R4L0sxUURYOVhoOEpS?=
 =?utf-8?B?UUNzaXlTUUkvN1dzU3gxL1FaTzRJZ0hBd3lwcTlvdUk3ZmRNMjEyU3loRVFu?=
 =?utf-8?B?YU11dUN3VnZXNDBZSmVPUTczSW85NkVtQ2xWZHoxVU5pR1RuZ3VkUS9KTnp1?=
 =?utf-8?B?RkNKYndlZ1ZKMEdybm0xakJXWWFSVUtnSVFMUTJaaHlZY2QrN3dNMS9GWExa?=
 =?utf-8?B?UVdBUXQ3T21ybHF2MS95cXpJaXIrckg2YmVzTmphbmlyeEJJZDNleTlRcFBt?=
 =?utf-8?B?YUNYbk9sMWNyUkpxN0V6Y1RoY05TOTFCczFRNzdYNXdGTDhTaXI3a3UyT0FO?=
 =?utf-8?B?bHVRbGk4bXhEWnQvSzZmeTFmVGJFU2JWcDl0S0UzQWZuWStiTE9XY2J4SXhX?=
 =?utf-8?B?SWxZWXJ4dG9qV3VFcTlhaE9kTlVhNjAvY1JlR0QyckplUHZaRndPTnRad3JQ?=
 =?utf-8?B?bHpBQWZZMWQxRWJRK3BDcXV5SVRiZlhSTytZZDhrZmE2N0tIaldJTHB6b1Fa?=
 =?utf-8?B?bndDZkVkcjBuREtDYlFVUnFiWnczSVVYYkhxZ2hvMkZRaHNDUWhnVThoOUxo?=
 =?utf-8?B?ekMwMGF5Vk1QdHRhWmV2UzVIUFN3bllrSXFmV09QMkVTRWtrZ3ZxWGx4SWJZ?=
 =?utf-8?B?WWpLN1p0czZQNGxqdWxCRGZhaEE2UzBsdVNXWGVoYlBGUWxUQ0R5aWxSclV4?=
 =?utf-8?B?TGdIaEhYNS9Wa2VXMEVSUTlMRG45ek0vdG5jWmdCOGY5LzBlV29SYk9HdVRY?=
 =?utf-8?B?RjNsSVpsSy9HRldzRnppZWViUGh5MGFrQ1RhZGhHd25ock1Kck9LZ0NsUmNu?=
 =?utf-8?B?V0l1WnNPL1ExdVZpQkJXVnYzN09SajJxQ1oveW1YUkRVY29kOEtIZTlIUmdE?=
 =?utf-8?B?a1NidHNYNE1sNk45NVMzUC95eHE5K3ErNW9WVExzRjVzU1VBVDgyL1YxeHgx?=
 =?utf-8?B?VFEycURuQ0xjQUt2MUZIWWh6Ly93UUNVSC84MXpDVTdkRndwR0lpZ0IzUUVm?=
 =?utf-8?B?Tjh2OFF6MVFta2xuWkdqenJPby9kRjZzS0s1RHE4a2ZMYkt1akl4SXplSE9W?=
 =?utf-8?B?UXNCcHc4TlhrYkU3dnlKNk1wVkFtaWU4UzEzWVhhWmJIdFpKaXRYOWpOYVlM?=
 =?utf-8?B?bjMzVmE2bUNTRFNmQmNWVms5UTFVZVRHS0wwNUhIeUpOMzJkNDljU2tNUU8x?=
 =?utf-8?B?THY1UjhQK0NqbDFNWEgyVUhwRDRJS09kV1NTV210Y3BSdHdSV3RLZlBNT21v?=
 =?utf-8?B?L2xaUHhaSDZOUzRLTFVsZzdXZW5PaDVkZnZoRXlBN1kwVDczdE53Y0JJbHkv?=
 =?utf-8?B?VDFyeUI1YmF1VXR6dnVqZHBBRHF0WkZMLzRJeWx6ajZKMmFyY0tBRS9ZVC9l?=
 =?utf-8?B?MExZRmdLNzZBYkc5Zkl5YWQxbEdQellNTUkzeU5NSEhvalVMWGpzOU9YRXNN?=
 =?utf-8?B?U0dzR0pXYWFWVDkxcklFcHppWGwzQ09OSkJGZ3VDbFY2dG5CUE9GRm1HVjlz?=
 =?utf-8?B?ZnhTY1VVYTBsc2lUWVZOeGlzbHh0VWdKVC9kaTZsbElibEtzbmxhRzh4Ukxm?=
 =?utf-8?B?T2R2cEs0RFRGMWF5blFlRlAvTk5FNjFLMWxvL3NWS3pPT1VMdFUxcndaTjUy?=
 =?utf-8?B?b3Y4MzVtbnhXdDd6cmliWGZaa0VsVVcyTXBjRW5JRm0yRVh0STJvL2dmeng4?=
 =?utf-8?B?aXFGM3dxa2w5WEN0RWdCT0h5eVJPVXljTTFKMWRSN2ZXRkx0TC80bmpLMmsw?=
 =?utf-8?B?bEU1VW1xTGt4dXUxSTNHbCt5aTlDZjVYejg1TnVMWEtjRE5tbE5ULzFsa1VC?=
 =?utf-8?B?K2JWK2VIT2FKQk43bGFwc2FaaHNSTGtrcXdXeXJjcm5HSFhsb0pPWmVnTktC?=
 =?utf-8?Q?4Acx0n8zrBjtFM+Cws+qTz2+Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da23997-7ad2-4d0b-3d3d-08dd9ee9c08c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 19:48:15.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UHZYVFGQ2U+nrnHSlkuen9EwisZaLMgBDQm3ibvG6ftFnQkkfUskEmFjrkCYeLhs0wrHYdu2Z3QWPElo+R9IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8948

On 5/28/25 15:20, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix below smatch warnings:
> drivers/crypto/ccp/sev-dev.c:1312 __sev_platform_init_locked()
> error: we previously assumed 'error' could be null
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202505071746.eWOx5QgC-lkp@intel.com/
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3451bada884e..8fb94c5f006a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1276,9 +1276,11 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>  
>  static int __sev_platform_init_locked(int *error)
>  {
> -	int rc, psp_ret = SEV_RET_NO_FW_CALL;
> +	int rc, psp_ret, dfflush_error;
>  	struct sev_device *sev;
>  
> +	psp_ret = dfflush_error = SEV_RET_NO_FW_CALL;
> +
>  	if (!psp_master || !psp_master->sev_data)
>  		return -ENODEV;
>  
> @@ -1320,10 +1322,10 @@ static int __sev_platform_init_locked(int *error)
>  
>  	/* Prepare for first SEV guest launch after INIT */
>  	wbinvd_on_all_cpus();
> -	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
> +	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &dfflush_error);
>  	if (rc) {
>  		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
> -			*error, rc);
> +			dfflush_error, rc);
>  		return rc;
>  	}
>  
