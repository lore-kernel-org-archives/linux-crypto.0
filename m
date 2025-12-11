Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012013.outbound.protection.outlook.com [52.101.48.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C1A937;
	Thu, 11 Dec 2025 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765491786; cv=fail; b=rw46IPDPsN9z10MtPovWDNaQzdb1pb289OKeXOhOLnzMziHap/rljNTkbnxGtUJ5ZSx1+hUDD2R3Nf91gV25TuwQiWzQKmF28NM8Sz3wsXfCxLG587m0Qzok2iYmBGM5w2glA2vExAComRhLdOoVVbMvBypnOm0H3xXckrQhsnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765491786; c=relaxed/simple;
	bh=Iws6x/DGoVTggRdjEOBs2dyZkmYW54ylz5PBr4wmRa4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W5lTK4FlwPUhy4DUd1/Di0pzchAspomrXvJr/kyjPrHR8kTk+Eiexjbqq5k6c7hqn3OLOZU8KXwK0ehRn7l8I3CmG4SgXUhj9Kpv/JnGaOdH3T1+fKCy3wbncOLJHnPWB6rBhYT4PWgY4U3tv6fVbDRi3RVRZk7dz5OQDz9mXyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XXS9SnRP; arc=fail smtp.client-ip=52.101.48.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XXS9SnRP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nd9KGxsETlSTQanMP0nnmkdZvnpqG1n2ScPTtlyyttJN82hh/mp5v38jIC9oWenkIBW6DjEiiM6BXWnQS8ENhZKgbGOKmymC+i3/voUzaNalRxi8w//f2bBqLgiRkv583Gvbh0ysYkLO7inxr4nv6nQDCKB3azPe6tNENIGLJmy9cfxfMj08RdkSap5DyqnHwEmosuyqL4cLYsdY8amQGEtUPp7HwTqDHZNdM4JUrjvvzzt3fsMj/acYH5MBsMLM+JmKe8HESGlXTQKrrvgtfCcx3lmT7ZtOG8yccvDdHgwbviPvXiVRmAQE0Bz/v22GhtsWawAr/yUVm3++DI2BOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLCQ/O1M9/gE8KMsWycf1RCUzGfTz/3mb2/REnZ6sls=;
 b=onpCI1tMDYszDfeDjkgF8zVnALWIHoKvU47dFRO/fRZ/wGrvMQHRNT+OQ4P3TJZlkxtkxB7yudhrnN+B1zZjMuC5MZiDH5NN3MIoTMZDL4+c+qkPYnUKSV819zcZHA+n0F2OAVP6eluOvvxM/wYfi8OEZYT3h9vtON+Syce7xyjCBoWNpOJJe1Ss9dwEmH/lZRfrmD8WaxBf2sVQc3OzwHdq/K8X7s+6d9UgJnlW18nLPWkZOLMlWySKW4Qoj/0FJeffMXOgXS9VQyWN4sR+gEyYyJod59XCacXgCsyLREOX5+3tGpVoxxMfkSwgzg9FVMBXKpM6cNbOkuzK97sdiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLCQ/O1M9/gE8KMsWycf1RCUzGfTz/3mb2/REnZ6sls=;
 b=XXS9SnRPS/TRyc0xwuWMCuEqHK5fij5IFGGO0CN65OzBRcsgNmQx+ADt7TuLy7zS8RwhaIUVvscWbOX+Cm0aEvzHi2Ij631DAYnzh2Xy5JVSoZvnTdXtrXCbvIiJ0FkzYGMfV29QWJuAPqzCS/1ZVJgheMDLtsTfjBB373vvjbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB9104.namprd12.prod.outlook.com (2603:10b6:510:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 22:23:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 22:23:00 +0000
Message-ID: <13999bc2-db83-4a4f-9ece-6b809191e8e1@amd.com>
Date: Thu, 11 Dec 2025 16:21:47 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>
References: <20251211212847.11980-1-superm1@kernel.org>
 <20251211212847.11980-5-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251211212847.11980-5-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a148d8-706f-4b41-4dc5-08de3903d79b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUVQdCsvaVZJSG5acjZIYjE1TGxrMHQyUkFNQTJ0VXFkdDNkRnVzamtDZFpW?=
 =?utf-8?B?L2h6WTd2aWdWOHFzQXVJSUVnWDZjUzFIU21JM3FHdmh5Q1dpVXpGcVJPaFkz?=
 =?utf-8?B?cHdrSlJFS1BXTGxET205TlNRM3phMVZIL2VKbW8rV0d0ak1wOHdoYzZRVU43?=
 =?utf-8?B?eS9RS1JXWDJRZ1lQQVYzQWFKeVg3ZzV2dDJHQlMxY2pidDdWdEhOTU1kV1pW?=
 =?utf-8?B?aW51SFNBZWtwVkp0WmlYQkJWM2tkakNyVWxXa2FTUFIzOFNrLzhuakl0OHRH?=
 =?utf-8?B?dWEyejVCVytJUStLcCtwaVhzZHFZSzBGZ0N5YWZxSmdZelZVTjJ1NVlPSTQy?=
 =?utf-8?B?RjhyR1JqeWZ1Y3V5eTYrNmRQNG9wdGZzLzhiZnJNT1J3ZGtvOGdwbFRoclpU?=
 =?utf-8?B?SzhwcmNIa2xxVi9wQ1dndCtJZHAvY2RwV25XRno2SzJPRm51Mncwd1EzczQw?=
 =?utf-8?B?RmhUb0lyWXByLy8xN3lRbWZaNVJRNWJBblZUZ3hXODdqamhZZXM4QWlpT3Fy?=
 =?utf-8?B?Q1ZuV1J1cTNlTmMyTjZ0Yk9SVzFnaVAwYktvaCs2S01yRERLZWt4d2pHQWNO?=
 =?utf-8?B?c3FtM0RJenRqTU5RUlpmWC82VzZHNG9yei8zdDd2d2xsdytJNHBBNkQ1bmdl?=
 =?utf-8?B?Qktjdjk4d3dTL2pRYUI5NVFCdWszdFp6UGpYV25EMk9VSzdOTHdOWEhuV2w1?=
 =?utf-8?B?YjNPMnZEbERqblNDQUZ6ZW1CVXdNZHI4Yk9wR0dVUk8rRlExSzc5UnlsZnBF?=
 =?utf-8?B?b1IzY3hNNi9GZGo3d1kzaEVxSDFjOFN1VDUyM1Nxa2NFeGdKWEkzRnYzV05M?=
 =?utf-8?B?cnh3eVFEUTlkRnhNYncvQUphZlk1eUo5WjBNekRReFZMYjdnSGt2K0xIY3NX?=
 =?utf-8?B?eWQrMGgxWGxwNndSWGFkNCtvK1plNVUvTExBdGc1RmxlaVZ2WmdtSlY0Vkc2?=
 =?utf-8?B?Z3lrRktnN0pSUHBBV0NCTTZEZytwUWVtMnFZQjB6UkNaSmpHM1RORVhCMTQ3?=
 =?utf-8?B?aksrUDZzNlFsTENoZzhWWkpJeGlFbUZzUnNJajVjUDZobWt4N3N2NElTVys1?=
 =?utf-8?B?MUViSUgxTG1UV1A3aWZQenErYXM2Mnp6UFFwbEIyZzI3SVB6TmZOZzFqVkwx?=
 =?utf-8?B?YTNld0tPcW9ITjFFM0dlOVRUWUJIU3V3b2dvSi9JaDFVWlR2MTc3cTExZE1D?=
 =?utf-8?B?cDJqalI4QTZJZy96dmt4a08rZTRSTTZuVVc3MTJQMEJIKzlFaHRjQ2Q1K3lI?=
 =?utf-8?B?V0VibHlLdFkwVzFlNVlRUS9XQ003TXRVc1lqeS80WGl0NUxFbjNsSE82bm9m?=
 =?utf-8?B?WHErS3F2ZXdPVThWZ3lVQmNvMnE0T1ZiQmdZY2Y3K1FMd1Jzdy9rOWpyTzl1?=
 =?utf-8?B?THJNRllaWHF4S3JVYk5Da2c4TjQzY0U1YXVPSFVJRVExS0Z2bUpaUVdKV09z?=
 =?utf-8?B?c2Z1QU5QSGJhVW1haCszWjRoZDZrVkRaZ082WTlyVkdyOU5kRjN3SS9YVmMy?=
 =?utf-8?B?elV3MnEzbmlzSGpNdGZjTjZCK0tFL3N2eStZei96c0VjUHBnSkVpTGE4WGhE?=
 =?utf-8?B?OTJJTVlaRDRFb2p1QnVUOTU3eGp2eWZ0d1loWllJK3FhaDVpZENnMndvT0NK?=
 =?utf-8?B?NkFhM3g3T1R6bzNGcE1iU1Rxc3pQbzdwRGNnNVFZTXRPNEpIejdLeUZzSkpS?=
 =?utf-8?B?RlRjQlRZUXhyalN3Q3dJMG5wVldwVi9aZGNxRGpGdGYvTkpuejB2RWZtUDVq?=
 =?utf-8?B?ZmZNeW80VmFBcExoZzd3R0ExYW05dTVtdHBPcmxraS8wYnN3Zzl4b1gzdlVp?=
 =?utf-8?B?OU9yLzdhWHB2K05oN2s1WWpUaDd4WDBDY2Y3NUFLM2RHWmUwSUJHejlrQnRa?=
 =?utf-8?B?NDkxV1dSRjNuUGM4SkhqV2lZUGpMVVkvN2tacHhxQmw2NUw5ZWZwR0wxaHow?=
 =?utf-8?Q?RALbtl+Dfy+En+j4QPEyspNW7Y4v5iJ0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFZvZkhkK1RsNW8yQWNqcG9KR2dDcUt6UTA5TmJMZU94Q2JoN0ZtbkpReHhJ?=
 =?utf-8?B?ZWZsV0x3RHpzOURaa3lhMGlEdGpmcHE2cytoQVlIMVYwMjNyTThOMlBiLzVB?=
 =?utf-8?B?QmI1UHhQd3dDeW5HVHYyOXlGUHhmRmN6U0gvbVhIbkVhdnhTVkpIdU9RaTNJ?=
 =?utf-8?B?eHJMVEYyZXlZNWJGOHlLT2krd1pSVHpTTEhUS25vdStFSG1UcDNzV3k0Q2N4?=
 =?utf-8?B?TWJzcGFKMWJrTEQzbHBMZlBiL3JpMXV5L25xYnNObWtLWENVc1J0NDFRenRr?=
 =?utf-8?B?ZlBhSG5JYUY0dDJlSmF6eHBTU0l4N1ZoKzMvMEl6T0RsdWduZVFTZE52aU1X?=
 =?utf-8?B?YXB3Yi9ZM3dVN3FrTE5GcGdOWkRUazNmU0JTZCtYaUI5T1pRbThCb3F2YUJs?=
 =?utf-8?B?blV0aXhPaTVUV00wNytaRlAvNWltSlRmVS9lUnFPYTdVYi9NY2ZmQU8vejVq?=
 =?utf-8?B?ZzdzVW5qcG1BamkwRHFCSmo1R1JhOUs0T21zSmRvN1dSS2poU0E4NUYwRDNI?=
 =?utf-8?B?cmxFelp3WDhVYmpWR0k0cWxuZHBjRjdQVTVMeEN6bWpCUnQ0WUVNWkxRMkNu?=
 =?utf-8?B?anFKcWlKdDJtVk4rNzY0Q3NuSWZnZjVhWEVMazQwd0NGMS9BaGZiWDlRL29k?=
 =?utf-8?B?TVdQb3VQVkFHMHFhS1FtS0d5S3hOZWpOTUlnVGl3bFBiOW1iSnc3OEk0NlZn?=
 =?utf-8?B?UmFkV3NZeVBGSW1lNENQTUlSWEtnN0RxUEhDSTJsVVVwbTlUNFVpMmJDRnls?=
 =?utf-8?B?a0NzaHgwcFhVN0d2SjE3eGRRZ2w0ME1HVEwzaVVtZW4vRzEwa3RVNTRJRWdC?=
 =?utf-8?B?bFVPU2lXRjFBbHZJNHdmcXdnSTZkZHM4d3FuTXpVSDNscFQzOWhvY1ZpZ0Rr?=
 =?utf-8?B?TFh0eXV1ZXlIMEMwRWE3bndPZ0VmbkRTSGI1cm5EdWlUczM2ZGNUbGZPNWY4?=
 =?utf-8?B?b3NsVTZxelhUSXExNzlPcXFIdk0zY0FTZVVFcUkvVUtvUnBTMTFlZ1FZMTlt?=
 =?utf-8?B?REVIdVZoTGFoNnpsdUdvc3BXYXNPTjhoQ0ROaGlZam5GWkNMeFc1aU5VOFNa?=
 =?utf-8?B?WEw5OGcwTDRka3hhNEJPb0tFYnZCSUg0blRMcjFza28zdS9BZVJsY0gwNGgx?=
 =?utf-8?B?c2l5UzdvdEpHU05XY0ZIWE9uSmw4L3lkNnlBUi95QXZsWlBwQWs4TzR6bER3?=
 =?utf-8?B?QjE2bmRtSTAzaUpoVURWU09BaTluOTVjc28xWXNLSnVjMUtKNWdrbk9VTDUr?=
 =?utf-8?B?ZDRYYjArdlFVeGRNRU84eGJjN01yVEw2SjNMMUUzWTV4M3hNUEN5UktNYUxT?=
 =?utf-8?B?S0tnbk1uSFJ2NmZuQ0tlLzZ2WFZabHh5bDRBMVdLZlJ0cFNma0x5V2NTZmgv?=
 =?utf-8?B?YVFTcENQdWx6MkNsWlp2UWdHWGNqUE5SYmhHdEc1bUdzc0dLNllRZnRQUEdC?=
 =?utf-8?B?bkJKYlh5RklReGRpZzE5VElJR0VueVhVRmpscytsK1R3dERNVGNSTzBGTFd5?=
 =?utf-8?B?cVZ6TldZcHgrSHFPclVXSTdkbkUwclRUN2EyZVdpYWtFbUFScFQrb1NYaXZq?=
 =?utf-8?B?NXprNk5zdDVWWkhBOVVGdzBSUkNWMDRNRGI5WitQaXM5d1BlMjNyc055dHlr?=
 =?utf-8?B?OTBZVy90QU9CR25BVm42WjhhVXhHTTdtOTcvTS8rV3RPdkNSbkMvVkJKRitp?=
 =?utf-8?B?ZVc1SjZrN3E0bGhGeDJhK3UvQ2VtNjZpZmVxd1N0cE5iMzB0dkdYYmhwYUdP?=
 =?utf-8?B?Z2NJbE5SQ2hxaGNOcGhNdU96OE9uNko0bSt0TWNTM0RrcEhZRWVTcVRXd242?=
 =?utf-8?B?Wlc0NW42YXpMV0M5OFhDUTZOWlJhdnYzY3B4ZzAzUlRmcTRxYmhpQWVsZ0Vv?=
 =?utf-8?B?VGVNa1Y2VFlKbVFrUGV4dUpBNmx4YTdpOWcyaUlFV3BBdG1lc2pJTWtUeVZW?=
 =?utf-8?B?K0FIMUJYUHovZmZxRWd0M2VKZm95VzlhUXhnY3NJQWVIK0RCeWcyRnpoR0ZT?=
 =?utf-8?B?dkV2ZVAzZlEvZWxoM1g3eVRkVkwrVkNoVloxM25DWmVWNDF2Q2hjMFpJdHVv?=
 =?utf-8?B?ZmVoOTBReGZTeStBMXptTEUyVmxnaUlTMW84d0RkaCt2bGEzdlZucCtnaEhE?=
 =?utf-8?Q?jBGXvHoTYa2EFWqhnR3yNdIzK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a148d8-706f-4b41-4dc5-08de3903d79b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 22:23:00.1274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4F5gX9vJrEWbvj5C9TfVyte5xhbESiV8qos1Crg805nGwSIQo3w40N77WROJo7xcoNCWV3NEzjyq4fSZ7/Tyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104

On 12/11/25 15:28, Mario Limonciello (AMD) wrote:
> The hibernate resume sequence involves loading a resume kernel that is
> just used for loading the hibernate image before shifting back to the
> existing kernel.
> 
> During that hibernate resume sequence the resume kernel may have loaded
> the ccp driver.  If this happens the resume kernel will also have called
> PSP_CMD_TEE_RING_INIT but it will never have called
> PSP_CMD_TEE_RING_DESTROY.
> 
> This is problematic because the existing kernel needs to re-initialize the
> ring.  One could argue that the existing kernel should call destroy
> as part of restore() but there is no guarantee that the resume kernel did
> or didn't load the ccp driver.  There is also no callback opportunity for
> the resume kernel to destroy before handing back control to the existing
> kernel.
> 
> Similar problems could potentially exist with the use of kdump and
> crash handling. I actually reproduced this issue like this:
> 
> 1) rmmod ccp
> 2) hibernate the system
> 3) resume the system
> 4) modprobe ccp
> 
> The resume kernel will have loaded ccp but never destroyed and then when
> I try to modprobe it fails.
> 
> Because of these possible cases add a flow that checks the error code from
> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
> 
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
>  drivers/crypto/ccp/tee-dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 11c4b05e2f3a..34096cb6ebdc 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -90,6 +90,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>  	struct tee_init_ring_cmd *cmd;
> +	bool retry = false;
>  	unsigned int reg;
>  	int ret;
>  
> @@ -112,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	/* Send command buffer details to Trusted OS by writing to
>  	 * CPU-PSP message registers
>  	 */
> +init:
>  	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>  				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>  	if (ret) {
> @@ -122,6 +124,15 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	}
>  
>  	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == 0x0000000d) {
> +			dev_dbg(tee->dev, "tee: ring init command failed with busy status, retrying\n");

Add a comment here about hibernate/resume and what could be occurring
and why you are issuing PSP_CMD_TEE_RING_DESTROY would be good to have.

> +			ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
> +						TEE_DEFAULT_CMD_TIMEOUT, &reg);

Alignment.

Thanks,
Tom

> +			if (!ret) {
> +				retry = true;
> +				goto init;
> +			}
> +		}
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);

