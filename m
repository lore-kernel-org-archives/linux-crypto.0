Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CB23FE7;
	Tue, 24 Jun 2025 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750729312; cv=fail; b=p85DgRkbfix3XusEQrpBkZ77FlcLxUxORjCKS7dJO1AggVCXrchtMdyqkSVvGh1rjKOhP+a5FtO/42FtkXcMxydShRqcgMvLA+hDgfuCiNRmj87TzGzTYWfn5e9KtJUQ+jnZsMfTSEfROFDPrTMGda++A2xB+Lj98XiM+e7snBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750729312; c=relaxed/simple;
	bh=sA3gSQWptIoDazZKSFF7glXJDKOd7cdkWK5FKMVrFXQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sWvJdm8DtNlG8+tygKqqctkAAq/BN6oXRtMohkjXKt8m0m+7i5T9xrjEA3KPE4TrXE6U5yiIDplpRzASMPHpTFziAJ7xi9ybkRqCIy4L/HupLP5+XG5wjIeGaSCjVvOucoxvlyT1arFOkqzBggS3xQH/m9ty/F0UChpEXCuYFfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OXCvXtRK; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OXCvXtRK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=piu0EaON7LZ8QTNsHuOz79V9fMlZhPDH0s01IBTWcfHFnZG1rMpK3pIriIqYVYRtlfDz4384ICf5csA2R4B58J17ey54XsK4UQhaMdt6Viif1eCgk8FnP/islD5gySs2hbi5vHWx/ORwj0/t3yslaq4RtW+a5zJNh9hpHIHiwtM0hGuvW0TG9+M0Qgn2u/dkUPrObKx/720iGfP32hHFjGGSP8w8uIgbBcVebOQV+6EvmyzRR5ZcCJaw37Zd4VJnwJ1BT1lieX7k8fskQ+TVFycKqN7qFAF8v2BFAh/RJp3HDncON7ypM5u6PCWrBUO5sJuRV/Bz0/HR8vsCN9ssoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iAiF8Zu9rXLyzw6XGAROwfbPfope7pjV8NeaSEV0To=;
 b=AcOcOehi9yIZdmR+YmaegEKpvHrDa4014e3jgpqy5YlwPegwMGIA7e6EJxzHLhJh4xgbXESPyJQjqJavoCuNDEJQXLc24ozG+KIvw3OL9L4OmBQFS/QCWryr3rTS05agmHTFjlJRRvB+PU3BYr4JnY6S85qKBjUCkiVtjciBQmKdH1b/EXpbAVKnywIsrW6L37BxpQ2Zql0EHihrLM+Ojkg6otkmkRMexyn1YucHQZHPYL9N3C14bmtB5iV1IEkfPBP8fvZD2pPV+8i4KBo5uaBddALYmjc+xPbhJrDPU+sPUul9Hbjofhy0DAdMSFi3qFaU7HF8FJEGhw+FjuKAcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iAiF8Zu9rXLyzw6XGAROwfbPfope7pjV8NeaSEV0To=;
 b=OXCvXtRKyHuehOAoTLievqH7KhciBAjYBtdFsWhsOzWIK+Ff8AlsN4mvU+z84bH5yt/bGzF/k51TDLL1+Irmhg6MqyjXC8yno+8cX03a5Mb4fKcHKRnN0Xys0dJ1mLMZwwRag1iLzaLQTSk0vXYSq4wODicQOUS3nYAgXpYe1x0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Tue, 24 Jun
 2025 01:41:47 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%7]) with mapi id 15.20.8857.019; Tue, 24 Jun 2025
 01:41:47 +0000
Message-ID: <7d4bde18-bbb7-4177-8577-b96c16f80d1d@amd.com>
Date: Tue, 24 Jun 2025 11:41:41 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] crypto/ccp: Fix locking on alloc failure handling
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
References: <20250617094354.1357771-1-aik@amd.com>
 <a0ce9850-cde4-4e17-997b-ad06a76a23d6@amd.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <a0ce9850-cde4-4e17-997b-ad06a76a23d6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P282CA0027.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:29b::25) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM3PR12MB9287:EE_
X-MS-Office365-Filtering-Correlation-Id: a648c5d3-a19f-4a40-15d1-08ddb2c04836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDdCdXpKd2xpTGl6RXU2YnEyV1ppTEwxV0I0QU1WZFh3MnkyL2N3NUlSVmZs?=
 =?utf-8?B?NGtTNDN5N3RaMnkxRnpDSkoyZTk1ekhnYk5zL3Q2Y0JwcCtGQjdKVllRS3Y2?=
 =?utf-8?B?MFpaUGhVQTZQMjJ5eVJodGRoWlRiR3l3NktMQ2hmM0ZlbUhzU1hhUXJjSGZ1?=
 =?utf-8?B?TFB3RkVTei85Wk9MbzJEVVd3b2pxaGkwYkVQU1R0bFYrMXRBZW1HK3ZGSHRp?=
 =?utf-8?B?RjlIK285UDVQVlhPaGdDMkRMLzAwS3BoOVIxSTNhR2pOMG9IVGhpQU9SS2hP?=
 =?utf-8?B?T081ZGdzVEdIRTRXTVE4aG81KzBkRVFrWXlDMUtRZUtTeDZ3Z3drbEhsNU1V?=
 =?utf-8?B?WGd5RGZxZkxrblViRGJlZGFvUmNROTh4eWdjZFpjWFhMR2VhcHN2WnRDMGNY?=
 =?utf-8?B?bWExUzlRU0VCc3RtVUpRMDNOSDVMaTMxTVc3Y0F0cVcxMmpsM0VUYjd4N2w5?=
 =?utf-8?B?NkxyV2lidEdieUdkQmJpYktnY3ZPNk81WndkY2NTVlg2T09iTGFTSzFLelBu?=
 =?utf-8?B?T1dBaVVQL1hTdGNIdjV0QURjaFBJYko4enZuTUJOSWVQU2Mrb09zMUViZE5x?=
 =?utf-8?B?ZUpSSEhwbnBtV3lld2xtTzNUVUN1eHQ1WTBQV3NjUFJIcTRDUVJBSjhVK1Rv?=
 =?utf-8?B?NXllUXpXWXlWR0dJNnMzWEVKRWptUk1ZRDE3S0lRNzJqYXdtZnNRejdsM1ZX?=
 =?utf-8?B?L1ZCVTQyRTBwN2xMR2RWZW9DdjhZbGJEUTdWdHB0T3dQUmdzZW92clMrV3lT?=
 =?utf-8?B?c2xvaEZ4RVlrUHRDTUFYUzhaUTVnSE9SM0xLUFFrMDRxd3dwYXU3eDdqdkc2?=
 =?utf-8?B?SXpTSU4xdkNrdVFqd3RjSU1BRmdaU05kTm5KMmVIQTN3bjVxd1JwM0phbmZ6?=
 =?utf-8?B?VU1OZVBib2pJQk9jRWdTWDFoNEJKUDlSZVQ1dTJicnZBb1RGWHVPcE1LbkQr?=
 =?utf-8?B?ZmNnU2pUbDhGSHlPVUdZOGpPcjRnRno3ZzJmOTRUbjBPbHBaWWgvaDcvZ0lB?=
 =?utf-8?B?WmRXLzdmVDNHaHNBbUFKTGxOZUNlU1o2UURkQ0xGWS9MSlB2RFA1YjhXQ25F?=
 =?utf-8?B?TnF5Qi9ZbkJrVTVPTDdWL2UrK1pHMGhQald6cnpXV2FGaUlwZW4rdU5jZlJV?=
 =?utf-8?B?ZDFNV28zbkNQcGVrWGxROVZMaTBLZnhQMGhyTkZZWUlhcjFpWFdzVzh2Q2JQ?=
 =?utf-8?B?UGFKOXBBK05sWkk1NnllOUVlNEpMVTJJVENLSERRMWc5Zk9wMXhUMmJUNkRS?=
 =?utf-8?B?eDVNL2g2NHV5eEtGWm15SDY5cCs4SWl5MGtLZTZkQUo1Y1lVdGpBcDk1ekpz?=
 =?utf-8?B?bXJic3pESzhGK3dMN0s2b3hJM0gzVHNkS0JJL0xkd1hQVG1KWlU1OU9ueWY5?=
 =?utf-8?B?NU5UU09QUmJJa0YzTitYWi9IMmpqUmc4UjdBZUZZSVpIdmRocVEvMkoyblVK?=
 =?utf-8?B?K0V3bHlHRGtxeE9xMnhxYU1uR1dWSHc3bGppQVpBZk5mYTliYy8wUFlxMmgv?=
 =?utf-8?B?MjdvUXBGeDNYTS9QOXcyU2tJb0JXUXJ0NDkvY2dlUmFWbUFQcVVjelYxL3FR?=
 =?utf-8?B?elk2Tm04TnUxZ3hZOTh3ajg0STFYZWhTL2NxVkVKZlAvUXBRS1N1clEvRDFI?=
 =?utf-8?B?b0xmS0NoZE13NlBwbkF3TFNrakRnVXJ2S1Y0aU54R3NRUVpIci82bEl5Q0tP?=
 =?utf-8?B?NzZRMnF0UjdLZ2JobGFINER0UnE5K0xaU1JjWWtZQU5aalVkRWpXY1oxZmor?=
 =?utf-8?B?Y1d0NXZaS3U2TVI0NzVac1hLRDVpeGlra3dHa044OGc5R2p0dzFFeGw5TDlX?=
 =?utf-8?B?SkZDaGJ0anVFSW8yZDFKY2Q2OUpqd3Fhc1B6eHkxUDdiNFMyN0ZuNitRTnNr?=
 =?utf-8?B?djZQb1ljWm9KTTJ0OVJSVURCWjRxWGpzMWYrNWVrV0NRbnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2pPbmZYV1FxcDIwNkRFUnp3cjdwRFV1WEhYeXVTY3pacXhxQVE3MFVrZnpJ?=
 =?utf-8?B?TDZLLy9YRXNkWmxzQVFGYzZpUTlEVWY2V2ZOeGdaSnl4NlhLRlRwQnFWZUZo?=
 =?utf-8?B?Z3RlMmpnTTNWZVRwTlZmeGM1cWJENDU3T0hYSnBDdXArYW5VMVpCaFE2TWkw?=
 =?utf-8?B?YmZDUFpuQmowYTRyOEpzUVJ4MVlRR2ovK3pEeUMyajhqQkFrU2NHdi9rNUVL?=
 =?utf-8?B?d3Jac08yYjk1b0dVVkhJdWkrcnBsVDZSY0xkbWtQVmJubm9ZRUZkRjN6ODBC?=
 =?utf-8?B?QVBWdXozb0dTL2k1TG1ETzFVaFd5Z0NaUFdLd0RiUGgyazE3eVpYMFpqbGRy?=
 =?utf-8?B?a01SSXovK0RYNjZUTjhPNUZDTFBPV3RXd093MUVIb0xUVlJEbktpb0lPV1Vj?=
 =?utf-8?B?QVF3Vm91d2xES1ZlaHU0M2VWTFB0bGZzNnIxVTYvV3FjWGdWS05ZZ0U0dHI5?=
 =?utf-8?B?aUQrTnp4WHZ3SCs2UGVjc1k1ZEhSYlJicG5XNlNTdVRnVURoUHZCa244TjBG?=
 =?utf-8?B?VlNTRjc4NkRGQ0ZBZThJbldzSG82TlNPT0F2L2JNVTI5Z2JIZGJZMlAyTE1o?=
 =?utf-8?B?VzlQaWpKWUM0dWxBODllVzBWMUVzRGVWanpVd0VyQVZ3SjhwajE5dEdQMkli?=
 =?utf-8?B?bDZDL2JhOFB6eEY5cmVjTjlITWNpOC9HVHQwM1I4Mk5ZQmZ5Qmx1QVBXMDVU?=
 =?utf-8?B?Y2xVMFpUeGx4M3NRc1loeE5SWUpyaXdYQTlidGRLN1lncUdiR0hLRHg0S1VK?=
 =?utf-8?B?RjJjWWhtRmNPelRnTC9rMTk4aklvTWRmV2ZMSllLZnR1YWw0bGFkNEpFSHJH?=
 =?utf-8?B?akxhcVJwaWNYOXRpdlNYU3lGYTRaKzNJd2UyUkRSV2NRZzJvcmJEQjRiem05?=
 =?utf-8?B?R0loTkZlWlF5eDA0a2VSamNpMlBGUzBKUXlLenFiWlJYbWJPRWtLVDR1N2tE?=
 =?utf-8?B?czZicytRNENGK21KSDFuZGNaZWxPd0tEdW8yKytCbk56YUpsTlNidlVHazFS?=
 =?utf-8?B?Mjh4Q3QrYkVFT29BNVg4d3VvM1V2dW5WNnpkRVpreTBBdzlYaUt2ekd0akty?=
 =?utf-8?B?Q1ZtRkxheGRGNzRiQW5QQk05Y1pRemtMbksrUjhnR0RGZGNWN05zUzlpWVJn?=
 =?utf-8?B?Ry81TWJqQ0lrMTg3TXNraDA0M0RnOWJMTWlPT1FtQWlpcldwbUNKK2lvS1NN?=
 =?utf-8?B?UkhLVGVCSUNmYlhNUHhEV2VvSnlYQjlKWTJ2SVo2VksyNnRjUlFOZWtsdGZp?=
 =?utf-8?B?NlZuZDFqeURRdCsvVzB3RU1iMHdzZWh6VkFFcWFSdDFRaFZIeUgzcUNTUldx?=
 =?utf-8?B?dmk0S2dpRVF5Z05XazNrbUxTamxRL1lVa2N5RXYrWFY5aUgrUkpvM1ZCRUY5?=
 =?utf-8?B?aDhkMUdnQ2wyTG1CRHd6WHVPOVZHdlUxNzV1WW5iUEk4QXhiamtCMTBmZENL?=
 =?utf-8?B?TXVoaU9QZlMrZklKdEovMDNENXd1dFRzUEg0M2pKdWVncmFkTjVtYlJSZWdQ?=
 =?utf-8?B?S0tmQ2s0ZDh5QzBMcXBCZ2t1TmZ4UUVkNkJHelFEd1BLWjVOb1RieUNNckVq?=
 =?utf-8?B?REJMclR0ay9KWVl1ME5HaUlxazkyRXJFQWlZQ0lsL0tjL0x4aThQdXZ4RTdx?=
 =?utf-8?B?SUt3dUxralJycllxQ3VZZ2NldTl0bEpsNTNKTmQyM0l4aG1hMHJFYkplRWl5?=
 =?utf-8?B?OWRxVlNsMUo3V3ZHZi9YOWw0MDJDYndlQlcwbWtOb0hYQnNzOXd5L1FmSWxF?=
 =?utf-8?B?MExyamlSYlRpRjRFakNqTTBkWWpXQ2lLbWxsNWJ5MjBsMEpFV2wzeEFvRDRu?=
 =?utf-8?B?dHpNcHpmZ3ZYZHoxM3FnV2x3OXg5OTdxajhScWJIZE01K1U2SjhPbXNOV0t1?=
 =?utf-8?B?aTBvMWxaZzh5K2VKTkxTbnN2WWpkUitnaTArbFZkYjQ5eWdZZTI4OHJ4eXRT?=
 =?utf-8?B?MkFRVm9rTWRjVlZIVnBocmEwKytjSExFQVZoL1RKZzlPcVpmVlNiZ3FUUlho?=
 =?utf-8?B?LzBkL0dMczNWVm90WlZoZjJ5WUdrWDFGWGI4WDZ1UjdocEs4U2w3MDRTTHpy?=
 =?utf-8?B?ZDdMT2tyZnlVeEJnaFhwN1hBeThjbis4L0xidTdBWklCYkNGc01OQkROQ3lj?=
 =?utf-8?Q?2yfKS47qLyOgAmSlUDD58+fC1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a648c5d3-a19f-4a40-15d1-08ddb2c04836
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 01:41:47.5452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+N58b+oWKrgpGbcZO3sGMHzjRQOQT12vmCUKok7BH6hLqvygmrlxYWOF23LQ8tGel8IQ9Xntpmxw9h2AU+gvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9287



On 21/6/25 05:20, Tom Lendacky wrote:
> On 6/17/25 04:43, Alexey Kardashevskiy wrote:
>> The __snp_alloc_firmware_pages() helper allocates pages in the firmware
>> state (alloc + rmpupdate). In case of failed rmpupdate, it tries
>> reclaiming pages with already changed state. This requires calling
>> the PSP firmware and since there is sev_cmd_mutex to guard such calls,
>> the helper takes a "locked" parameter so specify if the lock needs to
>> be held.
>>
>> Most calls happen from snp_alloc_firmware_page() which executes without
>> the lock. However
>>
>> commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
>>
>> switched sev_fw_alloc() from alloc_pages() (which does not call the PSP) to
>> __snp_alloc_firmware_pages() (which does) but did not account for the fact
>> that sev_fw_alloc() is called from __sev_platform_init_locked()
>> (via __sev_platform_init_handle_tmr()) and executes with the lock held.
>>
>> Add a "locked" parameter to __snp_alloc_firmware_pages().
>> Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
>> rmp_mark_pages_firmware() if rmpupdate() failed.
> 
> Would it make sense to add the locked parameter to sev_fw_alloc(), too?

That would be another patch then, this one is a fix ;)

and I'd probably just ditch both snp_alloc_firmware_page() and sev_fw_alloc(), rename __snp_alloc_firmware_pages() to snp_alloc_firmware_page() and just use this one everywhere. Nobody needs page struct anyway, and the locking will be clear everywhere. Also do the same for snp_free_firmware_page().

It is just that snp_alloc_firmware_page() and snp_free_firmware_page() are EXPORT_SYMBOL_GPL,

> Right now there is only one caller of sev_fw_alloc(), but in the future,
> if some other path should call sev_fw_alloc() and that path doesn't have
> the lock, then we'll miss taking it.

I'd rather just ditch sev_fw_alloc(), does not look very useful. Thanks,



> Thanks,
> Tom
> 
>>
>> Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 3451bada884e..16a11d5efe46 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -434,7 +434,7 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
>>   	return rc;
>>   }
>>   
>> -static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
>>   {
>>   	unsigned long npages = 1ul << order, paddr;
>>   	struct sev_device *sev;
>> @@ -453,7 +453,7 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>>   		return page;
>>   
>>   	paddr = __pa((unsigned long)page_address(page));
>> -	if (rmp_mark_pages_firmware(paddr, npages, false))
>> +	if (rmp_mark_pages_firmware(paddr, npages, locked))
>>   		return NULL;
>>   
>>   	return page;
>> @@ -463,7 +463,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
>>   {
>>   	struct page *page;
>>   
>> -	page = __snp_alloc_firmware_pages(gfp_mask, 0);
>> +	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
>>   
>>   	return page ? page_address(page) : NULL;
>>   }
>> @@ -498,7 +498,7 @@ static void *sev_fw_alloc(unsigned long len)
>>   {
>>   	struct page *page;
>>   
>> -	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
>> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
>>   	if (!page)
>>   		return NULL;
>>   

-- 
Alexey

