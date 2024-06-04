Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E2135A46;
	Tue,  4 Jun 2024 01:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717464179; cv=fail; b=o7XRGDnsWCkwqeglXC+6Ly/iwPcMJhcBm/uB/r/nLtY+I4FWj4HXkVyh/TZE5Wz6/mW61AiQq41eETV41CEYmqcR2gwnT+D0DJKxyWVwwG3gTmuuqVM8LiSYCIALDvi0DjoNiLLMtJkyvSGkz1BvY2og2r5gOI7ORc9ZeX5WkYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717464179; c=relaxed/simple;
	bh=HK6Za52PJYeXjyFicfsa+3WfcQ5fY5746bx6uZCoLVY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OrjTGiXKghQ2nIVx/Y7AeWo0GI0IDrP9F+sVqoy1Kh/3VoiafY/GXIveliAph84YpQuiTPNd9KcoGvTLJaUKuBfOArWqX+P1ywMltOsHhi+DGwwpN9Pry5lXF5kVUuLG3vMzD0xefzNjKODWLXhsih1CdDh9Ia7V9KrPOC/pLrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tTD40XX6; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tTD40XX6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbgQsY3mvS6mQcQLfHgqQdHGIdyCZ3wbxzX97GUSLZ5i6fFchAJNlooeLs5qF6mIALfL53UYom3x4T23UBlQuXa7suskF4m2apDfSEJMWBrX4JIoubOQzWFntpuNBYcyaHJ/UZescx68MM3BZVx9fSoH7QleqTiFZc16o7RjwfoAMHLJrqmRdWIe0zzc6LjJ27sIYid8nOSBJzNRxfoJyYY2VQ/m1lZNgPQBohUhbBopBn7XMhcmKb8jc8DiEYzX91sR66N9AXSWDqcN+qexuJDXuQhPtpmc0O/4zzCghAuHWmL7ebknMpz4meO6OGaWzaSsJp/cFA7rSTs6oMLJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdP6xBlJghLKZpeP8R+dfAIib3ttrBaH7UY90QGk0xw=;
 b=hXDFMg0Sk9XZ4oWvpypDqE61IGuKKiW7BZ3YjY/dxcyhGW99bk5ILqH8X0YTQsn7O6WCiRJ2/RFA/vUTTjvOaA/95T5AOnbH92dZcomHUMuBG7Ei3iwbTDnUfgyTM1CK5G87s3N7SGA2/MiKSsbGIhLebC41OdVA2PZryoP1ypO+orL08vvBdh8z1W2ahwia+Pa/jG4GHgbSG7JREoCmr2ei81+Jvu6S0HVu6Qn/zqnDU6e4Jz3oQOmynKA5b9MFTgfh3gQi32IWMzxf2Ku3HUVJNwC87KOpca5qwEEuvPi3G4PrU6emunYn5fsWF4G78k13ie+dOEAIxGY9c4+7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdP6xBlJghLKZpeP8R+dfAIib3ttrBaH7UY90QGk0xw=;
 b=tTD40XX6U8f/crPL7DdmI7NnHfCCk1y0RBDZwAeFksUuPLrTCgqGmBi2OpCOr58yO8gefPaWEduGRmi4/KsGkP3GjMofZaGuRmW/siq+gBAdIoW4r/uEmachg0LXPXYDZ84xx8znb0XJ54wRzl/O95dxVnNu0zhZI5pBp5aEJy4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY8PR12MB8214.namprd12.prod.outlook.com (2603:10b6:930:76::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Tue, 4 Jun
 2024 01:22:54 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.7633.018; Tue, 4 Jun 2024
 01:22:54 +0000
Message-ID: <fa2104c7-53dc-45ed-be62-72f07a7c43db@amd.com>
Date: Mon, 3 Jun 2024 20:22:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
To: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20240603151212.18342-1-kim.phillips@amd.com>
Content-Language: en-US
From: "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20240603151212.18342-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR15CA0122.namprd15.prod.outlook.com
 (2603:10b6:930:68::6) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|CY8PR12MB8214:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d592694-2141-4a95-bb8e-08dc8434dc03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGV4bU1kU3UwNW5aZUErTlpKVXN3aWhBMlhZWkpwbFUyVDdDd0JrejlyNzY3?=
 =?utf-8?B?SW5MRGo3RmR3RXBpUlplVHNObnpjemhZUlJ1bjhOalhrL0ZMVmk1Y2dwOU1E?=
 =?utf-8?B?ZHdmbTVoWnV3MVc5KzBMSWRZYnJrM1QzbXQwb3YyNitYbDgyeGYwdithcTFz?=
 =?utf-8?B?TGZGM2xGNXNVNDRmK1EvQ2U4VFJQNjErZmk2d3N6SzZUR2FsNk1SaWFlNVV2?=
 =?utf-8?B?b0ZSZ0FOdDJSS2FwVmVlSHBIUVFSbnJ4YWxUSUNwMDRDa2F1dWk1THhNL3JO?=
 =?utf-8?B?RldHa2lUb0ZTcGlOWWo2enIyVmEvN0t6VjJBSlFVSnBZYTdUN0NDNkJzaXZB?=
 =?utf-8?B?WHA1NDh6NG1aZmIxMGpBTTA2RTU2KzRiREVzRk9MdElWZURJdGQvUTNhL3VV?=
 =?utf-8?B?d25FMWlHbHVBZUQxbVRKUTd3eG9RMlcwTzQzRkNPdWNCSzE4clRGSHlxWjVP?=
 =?utf-8?B?WVpkd0JyeHRSL2lEeVk3LzJtTHpleEJ6N0ZpaWhHUDFHSnE1d3NpbUdxWUFk?=
 =?utf-8?B?bERCb3pPcUNndklwY3pnbW5JZDRpS3FPVzREcjBoSFY2UDhlV0hLc0NKdkNF?=
 =?utf-8?B?OHcyazhhU0Z6RVFJR01WTXhaeVZrdTMyaHVkYzYzVnJCUGVCcDIvTXlBOVNj?=
 =?utf-8?B?N3UvQkEya0xDMC9WWWE3ck5SN0lIUjFUNlRNQmpDWkpKQTFnOXBYZGFuNEZo?=
 =?utf-8?B?N0dSUC82VU9Nbk05NDZLUTlINnhSWjhkNXR5YXdCa0lBUWJzWStkS0tXVGg5?=
 =?utf-8?B?OVBxdVVlTlhhMkRBY0o1cWNFSmxqVWlTVU1TZE5hZGVKNUk1NDh1eEhmYkk4?=
 =?utf-8?B?KzlPN0dlYkM2V1VSV0hXREYvT2hDZGU0SERRWkVOL3JHVGJONXh0Q2RLUFBV?=
 =?utf-8?B?bFJwanNDT3dGcERTWnZvOUV5Z0lSK0FuVE9kQi9pLzdXaWZMcUZFZTdvdm1G?=
 =?utf-8?B?aUxBb1BEVVNiTXdNVWtzTFg1YURFQmY0WU54cnRKb1ByR2h0RmlnaXNxVGxZ?=
 =?utf-8?B?dy9hcmMzMFFvNWVxQkxLc2EyekgxVmk0KyttS2xNbTRYM1hHT0JldWxYYVM4?=
 =?utf-8?B?U05yU2w5S0JLYUE3UkFmOFJ5RllsRnJFbGJLR1dFclJWSmN2alYxb3Q0N0Fq?=
 =?utf-8?B?RFdkUTdDb3VMTC9SS3gxNmp6TUhhNmxVVXNMVjJ5cWJ5Uzl4bytqemtSYy8r?=
 =?utf-8?B?SWVKcXlrT1R2UVA3cFVGS0ttY29nQU5ibG5nSE5Ed0YzcjhpaDZnQVpJbjVB?=
 =?utf-8?B?R21QQkRHTkJqUVJtMnBCa3UrTU5UdUNQOUtHSE94eVR0OEtPYU9yRkx1VFVj?=
 =?utf-8?B?SUI4Wk5zYUtSbWZoUXZiU09TYVRrbVZWenNrVm81K3JXL0FDSVlmZFZuVENW?=
 =?utf-8?B?SjZCUDBBY2FSb3E1c1NEN0VidlFXalhBR2ZPN1pjbE1wcDc3ZDczbCtCVTVR?=
 =?utf-8?B?L3J5aHNuZ3lObGxJYWc5ZEhyRUdNWjdrSVorZmNiWll1SFFsektuZ25uSUg0?=
 =?utf-8?B?SnhTMEp3M2pGaGlpZUZLcmwzcXNOUytSR050UHlzYkpaUzlFYUFud3BWTzRL?=
 =?utf-8?B?SmwxWEpNYWtHMU9rVkN1WTI5aE5hODlSaUJOS3lsSUszTE91d21wSzBzZGF1?=
 =?utf-8?B?OTAxQTFHK2VNUU9jb3p0cmxRc2VCSjNyTSt4RnZmYnBjWTVSUnRjSEwzZmho?=
 =?utf-8?B?SGtpWUloRVBSaENEWU1sUDFBcFpCOHFCRjMvTUxlT0FweU1UMGxidmZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXJYdmpqSWorcmZUbWRQSlM4alhJZ2R0SndFY3VYcEtTbmFNVnFhUG4rOFNL?=
 =?utf-8?B?MjUrbzN3QTluLytiRkpKbkFXaGY4dkZ0R1RGNEZiNjBvZFRZUnVGbU03UkFS?=
 =?utf-8?B?a1hCTThFUkIzbGZLd21XQmlrc2pTZ3NxdEZjVjJrVnVteEpqQUNBUUxBTFg3?=
 =?utf-8?B?QXVobjJkb0IwamtYQks4bjZCNTBFR3UxVUE4QWNFVVZUOGVmbjFVZUQrTEI3?=
 =?utf-8?B?NG9qZmtlMVBHa0J5a2hLNG5QTnNmem1udTNuV080ak1BdUZ1bDdHNXppNTRo?=
 =?utf-8?B?NkZjdEVvUVNZeEFEd0F4ZFY1UnVjd3RpaXRSdmNWcHhPK3hNVHU4c3VQOVBN?=
 =?utf-8?B?MXRIZkRLWnFUeDJwSThyVE1lSk1RZXNIZXFmZ216UWVMMWk0cndod3pxc2xw?=
 =?utf-8?B?aTZjcGt6TWp6WGUyeDFqTU00Vk55RGc4Q3ZqWG5TY2QvM2J5cStUaVNRT1JE?=
 =?utf-8?B?Mms2NEhTM2ttNmJVOTNVN081V2ZiSklSWHM3VkYxT1d6T09yeVRvNjFxcDBw?=
 =?utf-8?B?YWhZcFJwQ2lpeVA4WTFzRHZyeTlUSzFPMFVuOE1xcXY5eDhJaWRQUGZYOXc2?=
 =?utf-8?B?ZXdkelNQeXJuTVRaTStwNDRsRGVGOTcxZVNWMGlMOXBOcFRNY1NFbjZpYmtM?=
 =?utf-8?B?bEdKbUlxTWw3dUlwSnEweC91OXF6WVA5NHBGamIyd3VJRTNPQnRXQzhqMUFC?=
 =?utf-8?B?NlIzWXYvWnlzMC9LYmszdUxvMkJpQXdXcFVoWEpBdDFTZUViZ2FOU216QWdB?=
 =?utf-8?B?M29OcjEwSEdzZWpSRUdqeGlYazRqbytZS25YcWp4QkcyMVdrWTRCbVo4YmNU?=
 =?utf-8?B?cTYvR0RwWVdjaVhBcXAxUDlDMXlWOEs5VlA2QzM3MndoYklBZTAvUU5ETlRk?=
 =?utf-8?B?SEtyZzBHSTMxM1BNdmRNbTJNeTZBcFVkNFRkNXpNeWg2ZmJuQ2s1VWloMmRl?=
 =?utf-8?B?bnBDRmVEWVlYV3E5QWdRNkJXVjZUQjBldW1RdEZYb1doMW5kQVlOSjVtUFdY?=
 =?utf-8?B?Z1g1d0g3NmFnRmhnR1RQczR6YnJnR1FtUmRRWkRacjB6QUJhdW9vWEp3MlJQ?=
 =?utf-8?B?YldBK2ZTWHQ3TXl1eEE2dS8xYVB6WEw3YW5vaHI5SFVRRnN6TzVMUFYyaUxl?=
 =?utf-8?B?SmpOVGZ1MFBjYld2SUxWVHVjaU1Eb0Q5MFZTTW5BVk52ckRWbldGWUo0VzRH?=
 =?utf-8?B?eHFlcTI1U01FVVgyWU05c3JuZVZjSzVtK2NZM2QydTVQeFl0R2ZQdDJQRVh5?=
 =?utf-8?B?RXJvSVhLajFTTXgrMWg3dmZybjhlQlAvTktiMmJYVGNJUTk2RVJDRXJVWm5L?=
 =?utf-8?B?V1lERUdjcHpKVWhjNUhzTXBIYTVMZjVXYytBUldMTXVaYVg0Mlp4dHZlWVNa?=
 =?utf-8?B?TWpKUitNUUpvVm1TWUdVVUl4VXU4eUVWR1A4RXoyM2U2SHN5R0xjZUR4NXpQ?=
 =?utf-8?B?MzlFNk1SYjkzTXdZQy9LeER2dm5RaGRLbFpTYklRTndCNHE5L1FLNzdSRVdr?=
 =?utf-8?B?S0UwZ3NXcTJlc1F2ZCt1bzc1aHBIK2luNnBmT3pYK3g2S2xOWHpWSVNYdTFz?=
 =?utf-8?B?VWlhRnIzVWdzT2pSRlI4ZmF3MzlSVEdYMkpQWGtMK3owZHZDWHc4MlFEMHc0?=
 =?utf-8?B?VnJyMW1tWHZDWEJMYS9qckNNSm1MRU1PTnFmcyt2UEkyR1pJbU5zcDJjUGtO?=
 =?utf-8?B?d2dqd0laRWlvRDFMdlR2RkFwOVFJVEViM0JjbXdHS2RMQ2NIa2tRRUtMbVRJ?=
 =?utf-8?B?Y05TYzNXMGtwVEFGeG9KcVp3Nm9TWk9wRndlU0JrUmpNdjJsN3VvaVRCbG1N?=
 =?utf-8?B?K1kwS05IcVQxTGhmeVpUNERIcWkrSHIzMlZqL0NDQUh6M2YrQ0pzSHYvQkov?=
 =?utf-8?B?UUxURzhCcnV3R1ZmK1BJSytVakpWQjY1U01hWTYvbjBmMjJMVGsxZ2ZUUjFw?=
 =?utf-8?B?QXZjODhqdnNaWFcwMGUxT2cxM2ZOMEszWGtuUi9vMExjekNOOCtFcGlWWElz?=
 =?utf-8?B?UFJQMTdBUEVaRWRvWjZwa3VrRzY4Q21BNzJ3aE5NMGZ6dE85UEs2dGo1ZlMw?=
 =?utf-8?B?V2FFN1RoV1pkcmhTbE5WWm84ZURxU01PTW5LL0RlL01aM0RQSHd0K2FQek8w?=
 =?utf-8?Q?X/NIkKi+fJqysJunem73BGMCP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d592694-2141-4a95-bb8e-08dc8434dc03
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 01:22:54.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxtVdeZ6bfY3QmTpPPV1xdF6e1F+iga7F2eLPi1JMcvw32CoxHVQF4kLCqoUwCqZXqQj0KGKsLy6NIvx7P/vJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8214



On 6/3/2024 10:12 AM, Kim Phillips wrote:
> Another DEBUG_TEST_DRIVER_REMOVE induced splat found, this time
> in __sev_snp_shutdown_locked().
> 
> [   38.625613] ccp 0000:55:00.5: enabling device (0000 -> 0002)
> [   38.633022] ccp 0000:55:00.5: sev enabled
> [   38.637498] ccp 0000:55:00.5: psp enabled
> [   38.642011] BUG: kernel NULL pointer dereference, address: 00000000000000f0
> [   38.645963] #PF: supervisor read access in kernel mode
> [   38.645963] #PF: error_code(0x0000) - not-present page
> [   38.645963] PGD 0 P4D 0
> [   38.645963] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
> [   38.645963] CPU: 262 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1+ #29
> [   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
> [   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
> [   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
> [   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
> [   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
> [   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
> [   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
> [   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
> [   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
> [   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
> [   38.645963] PKRU: 55555554
> [   38.645963] Call Trace:
> [   38.645963]  <TASK>
> [   38.645963]  ? __die_body+0x6f/0xb0
> [   38.645963]  ? __die+0xcc/0xf0
> [   38.645963]  ? page_fault_oops+0x330/0x3a0
> [   38.645963]  ? save_trace+0x2a5/0x360
> [   38.645963]  ? do_user_addr_fault+0x583/0x630
> [   38.645963]  ? exc_page_fault+0x81/0x120
> [   38.645963]  ? asm_exc_page_fault+0x2b/0x30
> [   38.645963]  ? __sev_snp_shutdown_locked+0x2e/0x150
> [   38.645963]  __sev_firmware_shutdown+0x349/0x5b0
> [   38.645963]  ? pm_runtime_barrier+0x66/0xe0
> [   38.645963]  sev_dev_destroy+0x34/0xb0
> [   38.645963]  psp_dev_destroy+0x27/0x60
> [   38.645963]  sp_destroy+0x39/0x90
> [   38.645963]  sp_pci_remove+0x22/0x60
> [   38.645963]  pci_device_remove+0x4e/0x110
> [   38.645963]  really_probe+0x271/0x4e0
> [   38.645963]  __driver_probe_device+0x8f/0x160
> [   38.645963]  driver_probe_device+0x24/0x120
> [   38.645963]  __driver_attach+0xc7/0x280
> [   38.645963]  ? driver_attach+0x30/0x30
> [   38.645963]  bus_for_each_dev+0x10d/0x130
> [   38.645963]  driver_attach+0x22/0x30
> [   38.645963]  bus_add_driver+0x171/0x2b0
> [   38.645963]  ? unaccepted_memory_init_kdump+0x20/0x20
> [   38.645963]  driver_register+0x67/0x100
> [   38.645963]  __pci_register_driver+0x83/0x90
> [   38.645963]  sp_pci_init+0x22/0x30
> [   38.645963]  sp_mod_init+0x13/0x30
> [   38.645963]  do_one_initcall+0xb8/0x290
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100
> [   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0
> [   38.645963]  ? local_clock+0x1c/0x60
> [   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100
> [   38.645963]  ? __lock_acquire+0xd90/0xe30
> [   38.645963]  ? sched_clock_noinstr+0xd/0x10
> [   38.645963]  ? local_clock_noinstr+0x3e/0x100
> [   38.645963]  ? __create_object+0x66/0x100
> [   38.645963]  ? local_clock+0x1c/0x60
> [   38.645963]  ? __create_object+0x66/0x100
> [   38.645963]  ? parameq+0x1b/0x90
> [   38.645963]  ? parse_one+0x6d/0x1d0
> [   38.645963]  ? parse_args+0xd7/0x1f0
> [   38.645963]  ? do_initcall_level+0x180/0x180
> [   38.645963]  do_initcall_level+0xb0/0x180
> [   38.645963]  do_initcalls+0x60/0xa0
> [   38.645963]  ? kernel_init+0x1f/0x1d0
> [   38.645963]  do_basic_setup+0x41/0x50
> [   38.645963]  kernel_init_freeable+0x1ac/0x230
> [   38.645963]  ? rest_init+0x1f0/0x1f0
> [   38.645963]  kernel_init+0x1f/0x1d0
> [   38.645963]  ? rest_init+0x1f0/0x1f0
> [   38.645963]  ret_from_fork+0x3d/0x50
> [   38.645963]  ? rest_init+0x1f0/0x1f0
> [   38.645963]  ret_from_fork_asm+0x11/0x20
> [   38.645963]  </TASK>
> [   38.645963] Modules linked in:
> [   38.645963] CR2: 00000000000000f0
> [   38.645963] ---[ end trace 0000000000000000 ]---
> [   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
> [   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
> [   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
> [   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
> [   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
> [   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
> [   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
> [   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
> [   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
> [   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
> [   38.645963] PKRU: 55555554
> [   38.645963] Kernel panic - not syncing: Fatal exception
> [   38.645963] Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Fixes: ccb88e9549e7 ("crypto: ccp - Fix null pointer dereference in __sev_platform_shutdown_locked")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>

> ---
>   drivers/crypto/ccp/sev-dev.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2102377f727b..1912bee22dd4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1642,10 +1642,16 @@ static int sev_update_firmware(struct device *dev)
>   
>   static int __sev_snp_shutdown_locked(int *error, bool panic)
>   {
> -	struct sev_device *sev = psp_master->sev_data;
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
>   	struct sev_data_snp_shutdown_ex data;
>   	int ret;
>   
> +	if (!psp || !psp->sev_data)
> +		return 0;
> +
> +	sev = psp->sev_data;
> +
>   	if (!sev->snp_initialized)
>   		return 0;
>   
