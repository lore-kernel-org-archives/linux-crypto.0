Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DA01E867;
	Tue, 28 May 2024 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910227; cv=fail; b=feKy6jFKpWDY6PLKaXKi/0xGaFU6IsDpOpkqEAMv7x0R2P+6QiZ5pDb84QOpuAljm4izv18rnD5qhSAr3tscu5TC++UVVW80ruTZykB7sQl8yYr103n097lXfqklazcb76GS4sSHhzaDyUStvY9DWB3hnOSRB0x53X/aaquSjN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910227; c=relaxed/simple;
	bh=oNxCDjwO/fZ3Vuz+hfnt/jnbeZ18+zdcZfVb33+MA4U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=stHT3Hr+aj8Z9BImHnZJjNhcTTELDA3Vz9pwaCZa3G/9D4WJdNwhNzA//uE9nxZWElCx2T6jVzE6dOQueJEwdYR2Wu8Exwre74B0qH9VjI3lofqaIX4atfN5l3AX3doc7uj+wQtDwAw+CYAtxW343oVamrwNiEjXMuXN7HnBIXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CT1tqopb; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CT1tqopb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYTwjuBJA5rjw2lFdSELj4eqZPfPEEddoATGxwhIh32dgRtXR2ZyyP0h20OO6Z+F3imBLasw65aCLViAD9LcAe+1j/ZJ6iAFrDrdCOD7xs7ZONYXP745ZtM7fFfNmr8rCjCYVo5obxURuWf3+whn58jbgJMTqHanLjwQNQdhTfiKJfETBGM0gW/O+p8LFPTGKzG2S/V/suITk004MTBMkiP/seOhrUPaAbLFx1W5Uwm/AOcRJ6d67pTB0JbJgIEsopzYmEiQV/ZnPUNtDLoxgBM/ruetfOhYnn6Yvx9u2fRt85gHW9OuSURMtSTOjv/aKBQfsFtyjuvbaUJh1gXBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeTXkFIvi5TnFsOsziF3vLJIW+W0VCmjiHhlr+MKWo8=;
 b=Yp6IN6JNAeUtLjqo/FWD8VdqFWeD6hF5zJokxR4iUSZE+AKNVph/utXShsLJhNcgqzkElDTolwnCcQl9t0KIPeOjFXrT/EQRjc5vgzEiSt8mwG7hSn40pJlEKdbnk2+f4JV7qhVjhDd+Mhk29FKX7oBHDlqMKxep/d7kT29TaKqmkvONfOAIJYAMsH9ALFTXLkjx7S+j9T5v4fXGT4GEGKREagzFa5eWJROGmL+m3M+OBkaDD4ZEXRr+yE3IHxWZCaNQRQpdL09yI4U4ojjGlaRqFlr2+lELJI8Ds4ynQsqwualSrZghf61/cwiOaudOApFOAjgGI1QZjLuMzQUMlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeTXkFIvi5TnFsOsziF3vLJIW+W0VCmjiHhlr+MKWo8=;
 b=CT1tqopbnJm+VQe+B3FJcDAz14PDI23rd3+hqTYaZWuCVElqWUjxvh5XABW/vxjL5MF04FmTi6J6w4aJtyY0JF9aM6euPJI7b8yKwXV/rtxUThEivQKAVN55285nO0W9yneRK99+VqK7n1+Tuq3pWGihuGKb43nuUAhHu8Oh6BI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 15:30:23 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 15:30:23 +0000
Message-ID: <f64b1dc0-a2a3-3df6-b1aa-d98452a5996d@amd.com>
Date: Tue, 28 May 2024 10:30:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/5] crypto: ccp: Move security attributes to their own
 file
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
 <20240527152649.3722-3-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240527152649.3722-3-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0116.namprd11.prod.outlook.com
 (2603:10b6:806:d1::31) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: fe893a88-93ac-4791-1cb2-08dc7f2b173e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXBtTUN1SDJPaTdkNnhEZ085eDNpLzdldDJvU2pZaU5vS2N6Sk1Yc0lkSXFI?=
 =?utf-8?B?M0hVOExyYTlTcjJlb00wTnhPMXZ3SG9KNmhobDV4OUh0M1YwYXl0ME44UmM5?=
 =?utf-8?B?N1FKb1BGdFcvbUYzeWxwbzV6WDhVRm00L05nYkU1MWVqNE1IenpoT3pja1cx?=
 =?utf-8?B?TGFha3FyN3VCdzU5MjNwbnZlNDF6dTJTN2VKWjRQQm8xK1NHTEx6SXZkVkps?=
 =?utf-8?B?bTVyWVk0M3NBVFp0TDFXdVlKQnE0OHRia1dEZUlmVUxxcDJCMFFDeGJ6Mkxs?=
 =?utf-8?B?QzQ0ZWdxYlZyNHFCNlgydmF6Nkg3MU5laW9iZ3RWQXg1SnFwWXMxS045dWYr?=
 =?utf-8?B?a1lPNTEvR1FhWFVoaXJwb0F2N0YzMUErdit6NVJ0WnUrQVREcGp0NnQrQy8z?=
 =?utf-8?B?RHRHYmhRVWZyVCs3TVE5TjBYbFltaVRzTUtPTnZvb1JHSHZzSWFwbTFPaWtU?=
 =?utf-8?B?WnlGaVVzT3lCSUErRlM0M3hYRHk3UjlyWXlMcXladDVEVTljUHFjd0pBMzky?=
 =?utf-8?B?VlBBNDBrcXZmQVYwWlgveUlWRFNrZTBIbi9RNUVWdDFUMjhydHQvczl6dnVC?=
 =?utf-8?B?TmhLS053cWNmU1pEZUlsWTBDZlhrSXZrTFd4SjdJKzlGcjB5QWYrUmZXbjlx?=
 =?utf-8?B?WmFvd1llT1BoSDlPc21UUzZjRWlLVlVVUjFiQW5GMjNvM1kyS3Y2L0tVQWNw?=
 =?utf-8?B?dDFRYkwyQTBENnNzOU9lY2UwM0tXME1qUmdEMlZOaFEyL2E0UDlqZVlQL2l3?=
 =?utf-8?B?aG55dzR1dnJEcnRSZVNMRGwzdzQyVkZpcnE2bUhVcTB4YjJub3MrMVdmYUVW?=
 =?utf-8?B?UzIrdzJraFFSbW1BeUl0ZUR4SWVmalpEdnBHejl4WU43UlkwS00wcFJ3N0pk?=
 =?utf-8?B?YTVFNGZvRVNtVkgrREp2cm9jUkNDY3ZBazRvQ09TRm5RckpTQ25yNDFaZGx0?=
 =?utf-8?B?Mk9XY1hxQU5jZlJ0elJqQk9ZLytCYWhxbHpRUkNrbnBVN3FydFBacjJVMGsx?=
 =?utf-8?B?RzdBV3d1SmtpNzBmOUtzVGZ4UzhGWUhjTFhSSU1iRFFucDRuaHlRVmNwYXFw?=
 =?utf-8?B?ZlBmaFB6VGp6OTVxNWRScXZMcDJZaHF1enBYRERjN29KWDAwejVVRmMyN2RT?=
 =?utf-8?B?RkFtVlhpZHhoL0VEZ0lxUTF2OWcxL0h1YlgvZ1hUTkp6TllYeGFBczZ6a2ZR?=
 =?utf-8?B?OGF2d1N2WHdJT3BXZnFEclV2N3VmaWZ5Y090NzBHUHIxcHljUEZnSXZpZlFt?=
 =?utf-8?B?eUdNcmFmMlRyVW1tRjVhSU9iSVl5NHNHaEVZcitzMmFOT3dkMzI5MHJNbWxM?=
 =?utf-8?B?SEkvK1Nhdmp6WUtST0hzUHRDNWhRU1d1QUw2a3gzTFg4bFoxZVYwVU13KzNN?=
 =?utf-8?B?d3p0NmFBQnNNaUFDTnYwZjdhY0JFdWJNeVFkc3lhUjlUNThZaW1ua3VyM0ZE?=
 =?utf-8?B?R2QwS3dvNW96QTNqWUZ0NFBXckw4VGgwcjVsK3I0NzFiVHczUWV5MGs3Wkcr?=
 =?utf-8?B?eEtBOVJ5VWJRMEtvekdnNWI1ZDg1Mi9VbDBKOWJZeUJuaVZWcE9PbTVyMURz?=
 =?utf-8?B?SHF1VWlDVkNFTCtTTldrVXJjWTQwc3oyZ2Q2OUhGYWRyS0NUeGcrNkJnWE9j?=
 =?utf-8?B?VGMzejNuT1hYUHh0QzVjL2xxcVVuMmtiZm9QcThTZVZQVGxENTgxNXR4MFJE?=
 =?utf-8?B?c0FHaytQdWFDNzJKUmlHSVdjVFZxTnNYSy9keHFpNm96cXBSMmNLVlp3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1NKdkFEcVl5a1NKdktobjA4ZnA2QUFZNWtLMUExRm9CNU5EWmJQOUdvb1Nk?=
 =?utf-8?B?MWF0SXF5OHk2ZXA1eWNoSTFyMytpTWVIbDlwdENjdTlpbk9GVVVSTjVkZlFT?=
 =?utf-8?B?NVVIcllaSTBNMGpCZThtUXdMOEtLOE9LV2dOUmJQNnY0eWRoQkpZUlFjK3FN?=
 =?utf-8?B?Zk9MQUZDUDdxOTBYdjhtT3VQREcxaC80STk0eStJNzkwcEpGK283RTM1c3dF?=
 =?utf-8?B?UDBPQ2lZay9qWUxDT3R2WGttQXFGMVovWmhXWEkzemFJeEVGZ3JPbXFWRWFQ?=
 =?utf-8?B?NlBxZmpLMS9QVUFuY3pqVFhGMXFXUzdZZGg1RG1hazk3ZnVPT2t1RVB6LzFp?=
 =?utf-8?B?ZG5UQkdrTUtkTTlHdzdLR2FDa09qOHVpdjloWEY2Q3BuQ0dHbXNBM1dFM3JO?=
 =?utf-8?B?dmE5SVhuaUZ2NzFzalF4alVpblk0RjlzanNGWVVFalltd2lnWDJzMStTa2c1?=
 =?utf-8?B?NVBBMlVZNytvaCtlSFlhVCtzLzAzdld0MTU5ZWRsZHpnYTFZdEJXUStDaUZF?=
 =?utf-8?B?Sk5KaEN1UGVENnNKY3RoSStOdnovOXJHQ0traWtxeTJLVUZ2OE52K3ZMcWZu?=
 =?utf-8?B?bUVLc3lUTUMzYkFZdFcwOGExSUFub2Fwak1YNWs5YXZrK3g0bXVxT1c5MjJG?=
 =?utf-8?B?ZmdtR1VsYTFSQSs2UDZYK28rUlFHeEkrd0NmOXVRS1piUjV3eUI2ak50Nkdo?=
 =?utf-8?B?QmtsUmkwWXl0aWVRK0dDNzVPRXNQQUtTWDVGYVRlYWlZOWtGUk02K3pIS1dY?=
 =?utf-8?B?VTcrd3VRY3pVZ0pWbDlyRHJ6TFNyZExXL0U4MUxMZ0ZrWGVFKzgva0RFWmp0?=
 =?utf-8?B?ZDRYaTRtL1ZPL3ZpRGlSc3VEK1pYZ2xidEwzeFFybTNBeTYrTWw3bC9sdVR1?=
 =?utf-8?B?Q3dlUzY1Q2ZKdnJGYksxWTBTVnE1YlZReFNRcURpaHBKQVhONkc5L0dVUVRm?=
 =?utf-8?B?WUQ2cmpDM09ZRFpqVjBGekV2d0FBZFlTNDFhWUx4T1VZa1MvY2tqNlA5SzhZ?=
 =?utf-8?B?OFNYVEUzc1hrakRuTGRzWUNlaW5pRkxtOUw5aVQveTJkbnFGZTUvZHd6MG1L?=
 =?utf-8?B?clp4UnF2TWxIVlBBVmNobTFMMWZocHFhZk5PaHBGSDRPaGcxK0NOa29tK0FL?=
 =?utf-8?B?WHFIaGdkNVozYWViMnVLVEV3WXBCSmg2TzBSS0s1eUlKUmxQS2wxTFAwMUFM?=
 =?utf-8?B?VXZSMXRVTUljck9ORHZhTmQraDA5dnpldit5SmUzUlpMdUVZcktQTWM3ZlJP?=
 =?utf-8?B?RGZPOGVTM3F0MGJzeEt4K0NTUmRKQ0lqSXY2MUZKcU9lU0UwVDZJMXp4TndU?=
 =?utf-8?B?ekNLNVhsSmhBWFUrYnd5bnFCNG5yaEdkaTAyQmRoQjdzNlRCWjhyazhMOWNF?=
 =?utf-8?B?NHJxM09sbDJQYythWlhUbThBMVVOZjZ2eWM5aTJ2alQ5VHBobjlrK0JBZjBn?=
 =?utf-8?B?VzVBK0RwK0JycFdKR3U4WURkLytqMkpuY2ozeDZveU1vMDd6VkNUdmFkYXZU?=
 =?utf-8?B?eWp4ck1oaGRIRXFwRXc2L0hmN0tMN2ZEanJpUFlieVRPNTZ6MnBVVmxmSmYw?=
 =?utf-8?B?UVJ4RkZ6NTJxWlgwVzJ0NUFXeC9qcGhDN1luczFhRkpRdHhyTUl6Q1NaS3cw?=
 =?utf-8?B?TTJJSnZRTWk0SnFoYlRMYUFMNERVeC9GUDhIaDdFbklsSTlBdlBLZ0F3d3dh?=
 =?utf-8?B?SFg4emxFZ21nNVhSNDVVQjVuWXVRTXcrMWJGdm4yVGJZV0VDNkVlTVk0VUd0?=
 =?utf-8?B?dStFTXppZEt0S2VibGxqNnE5bHV3K1JOZlFHRy8vQm5mQW13WE50bE9nVSt6?=
 =?utf-8?B?KzlOWlJpcHhwVC92eUprV3B3Rmg3V3lFb2JBMm40aVFzSmwyMEVmbWZCa00v?=
 =?utf-8?B?MnRrV3ZFb2FzNFJwUHloR3Yzb2o1RnhkZ2xNdTE2VUkzTDZYM1pCU3RIbDNX?=
 =?utf-8?B?UzBySVNGUDJQTDJuSzFVNmlLem1DMVVmSGpFRk5LUnNCUnAwbHdmV2VTblor?=
 =?utf-8?B?MHVIWjM1aWhWTWdueGczbHBhckpPRW4zSjBVc2NScndSUjRDZEZLbURzRjkr?=
 =?utf-8?B?amxkK1Rvb1RrYzR2TmpXUzVWWGpOSUxQVjNmZlBiLzNZVkRUTW43VndGU1VR?=
 =?utf-8?Q?CHEkthNewBqvIe3obLopyFpAd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe893a88-93ac-4791-1cb2-08dc7f2b173e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 15:30:23.2165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hlx69YvSQjKglCnmtiW4lVGu0/ewZBHehuG4imgweNl9fbKRpXDPNQG0Zkiz3+/47MOljAYZ3jOGd7TBjuckkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768



On 5/27/24 10:26, Mario Limonciello wrote:
> To prepare for other code that will manipulate security attributes
> move the handling code out of sp-pci.c. No intended functional changes.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
