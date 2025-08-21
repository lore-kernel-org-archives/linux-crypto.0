Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012022.outbound.protection.outlook.com [52.101.126.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ADF36CDE1;
	Thu, 21 Aug 2025 13:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755781520; cv=fail; b=IdVRrUjoldl/oNw26vhaNS2TQ1BvDKaOlsXP58eP/iODh0NiuWqO+Uni5wAyngaF6fpM2l6/h51jf2p1lDpNHsNSPnf5wcZsbKdItFLGfhIXtK+pMwsa040NjhQxI+QBFd4r5RpxrNYScqMoFJO88bNAeC+bohxwmu7V6HFxLjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755781520; c=relaxed/simple;
	bh=QJ2YigpM8hbH/Gjy31O+Lo7Wseuh7YKXBOfZ3PJe1ww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IOYM8XX8cNrc/pkLDltP50F1JtTKG5XLlmgP9ztKZC5Pi/TkiqzYZ5OgPvofpHMJWm8mYIpYqi99Wyg7lerm/wwGVXMoMEtR2j68vDAmrV3/YZfMZEzg3ZjBXlxr+pNV0EvdoW4oKEBHWsnKG8GoQ4Fqkh1JMde0OJ4E5AKsnlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UXzrACgp; arc=fail smtp.client-ip=52.101.126.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UXzrACgp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEABpnKZuE09ZUq4fIMQwhDUX9foTjWWWiQMx1W/SJfPz/me2w3Ljfsj0mGbJaW7AdojJ5s3DxWC6r4dtkUUlUUILxtoeAD6Zvjg5ntRmWdrTKDUe0uvUThdScqHt5zm8Jk0hBwxQ1MG/u74LLaOlsoFYv0mNgZYT49hEw74qhnDG1bKsFXv6XNrt38aivWbbglt7VRO3PAq2WS0leuYjmo5l//wbNVrl1guVA8ZDEtGbduWqQCwjqN5s2G/w5yl/ceEXTTOyItcztHhQIFlSxX3YV34s5XawV+w5bgqgzhDh2pU/OXpApRWk9Ds1kSXbeSu9w7MFlOo+mpg/i9ppA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daTSELjxk+NcbSGa7TzCH4O/ail9ruPFuOfV0RW4HNw=;
 b=R6+huP6B/Q4Cod4vzhRzy6P6RMgUg46c9y0Krqxn0Uhrs54ybBa6WW91Qd+27oapabg7fhLWJr6Hi1seO8QKJVFVIxtTQ4u2rmLamHEQ5TisHVy94ViEQw9a9OxHDyFjLhsAi8Q1vrW+TriSUPz3jAK92HEhZ3Z3dBZstPLgTmAQ1xB6MRIkLjj1G1iM3mZp6A/PafPtR/Ith/JNKYrrlX37YutI1FjFFoED2gALbjqnoj3WqupZa17nYxPSt1DKx35g4Celf13yxgwUZKXp/gMNJvib8KRmV+f9wovZ25iAYzhaKGLgerIY6VJfB0H2UpIwlUPmKjJdEZoollqqTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daTSELjxk+NcbSGa7TzCH4O/ail9ruPFuOfV0RW4HNw=;
 b=UXzrACgp9oTu6z8hLgmTEYYLIrwL3GPKYI2meDpAfIuqz60nmXakGJCqudGwpzyj+qFwnLFvE2OTF+E9Q/2wuf/yWEq9TrNZIyEPrP12v9jefVHw4xFd52Pu9hb5Sf1/pwHBpJx9UVXxqrZ8oWGwMMiP6MhQEp2GoqZSKUhhnNdoOjClGbeNiHglBtKyleP9C09lTNz3UC2Uo9DT0tx/qb8l6bvXh313/yc4+DPh1rMpktt9hKPxl2/Cf4VA22Ucm+gF6/BDPzzNE/pNkUTuxegHT8jGgioQt11ts4fLGD0G/Yy1P20P1up418tcw7mtaXWrrGpsQEoQBYV/q0TncA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7061.apcprd06.prod.outlook.com (2603:1096:405:3f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Thu, 21 Aug 2025 13:05:14 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 13:05:14 +0000
Message-ID: <ce7c2b7e-eb7c-4087-aac2-697fd8f587a5@vivo.com>
Date: Thu, 21 Aug 2025 21:05:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - use kcalloc() in
 qat_uclo_map_objs_from_mof()
Content-Language: en-US
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jack Xu <jack.xu@intel.com>,
 Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
 Colin Ian King <colin.i.king@gmail.com>, qat-linux@intel.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250821123544.629821-1-rongqianfeng@vivo.com>
 <aKcXlxNRDr5IQYwh@smile.fi.intel.com>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <aKcXlxNRDr5IQYwh@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7061:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d0af8d-e750-4198-42e9-08dde0b35e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXFzOU5oR3k0RDBZTmtXd3A1YTJ3T05hanF6ck81b3BETXVjN0dEUU1WdWFJ?=
 =?utf-8?B?YnpqTEpiN2JnZm51Uzk2elA4ZmpqUzBGb2cxTDFZKzA0aU1jS3NTUXU4UTZ3?=
 =?utf-8?B?UlFEKys1ck1zZFlJOG80RFB0RXFMOGR6VElNVE9raFp6RzgzU3BFM3F2ak0w?=
 =?utf-8?B?V3RiTEc0UXFDbmM4V0Z6Q2NIVStlZ2t1QnpzNEpibVhOeEJWM25TdlhOZldz?=
 =?utf-8?B?Vmp0K05tc1R6S1h6UVMraHhoZ284ZEwwZzNJdkZLNk01dFBSaTZxZ0diK0VD?=
 =?utf-8?B?TWZTM0pvaTVJQnNBVkdBcWx6Q0xJK2s3TWZybnV3QmlSN3lCblBEQVNjMUpE?=
 =?utf-8?B?Tm53WVI2UXdoMEdjV3BMUERpWlJBaFBkUm1zTXpIT21TM3JuNG4zbTBvZE5B?=
 =?utf-8?B?SzRLVFBVRFFzTHB1VGc3ajBYWGs1SjBBMXNERVE2YnhyNkVEcUFiUUppYzIv?=
 =?utf-8?B?Unl0dGVyN3I4V3pzMWowTE5YOVAxSEVoeTFsS21uMHUwM0ZNTDZaalV0dmRl?=
 =?utf-8?B?VkJKOTZISjdaZVd3MlBpVy9UWU5QTDZBQmNRN05aaG5vbGlpb3k1ZEY0T21R?=
 =?utf-8?B?bzYyeUM5cHNRUzVEMmc0VytiYnNycUNjTi9HNjA3eVdjeENkMjAvdnhia3dy?=
 =?utf-8?B?am9TcmxvSkdqN1U1aEJWVjNJemx3SXIrK2txWStwdWJmczVXWjA1Ym9SZVV4?=
 =?utf-8?B?MnZjb1B5dlBRS0lEZ3c0U1o4YmFwQUkzSUZnaEpUZzRLSGdQRklNYm9tcytK?=
 =?utf-8?B?NjI4VkpIVjRwdy84NVNmMXEwS2hzdEJuOWwwSzVwcEs0Nm9ITG5ZYlltZjlk?=
 =?utf-8?B?YjROMzJYYU9ac3lLS25vWVhQSXk1L2ZxL2pSQU9rSEpVY0RGWGxUaURMTFZw?=
 =?utf-8?B?SFZ6MFY3NVkwMTFyNWhwS3RwK3BpMHUrb2wyTUZYeGZUcTMybm9VSVd0MUZH?=
 =?utf-8?B?UTc2WG9kS2JPaTBqeUNXSDV5MDdCNitQSThUeS9GOXJZWkVERGVsampFQ2x5?=
 =?utf-8?B?dUpDVkZsQ3ZnRGQ0Tmh6ZDZZUGQ3enk2V2ZVdTF4NCtJRDIrZHJ4M3ptNzlT?=
 =?utf-8?B?YkNCMmpDSVhuNjBHWmRxVk1PUG1wNTcwajg3UmkrWjlMekFheWtaYm82ZVRj?=
 =?utf-8?B?TVdseTBKeWVDRzk2MzNkT3JxV25hcmJkU2xCLzBoQnh0eVRvVEFoandZTkhC?=
 =?utf-8?B?Zk9HTmdpT2RLTVZ5UFVwVGsyZSs0RytXajNxUVNibVdZbGZMcVdLcjRrSmtP?=
 =?utf-8?B?MjdPQWJIeW8yd21XVGcwbTM3c1Bnc0ZjaXFkUHMvbXlSME50QlBlR3MrRGVx?=
 =?utf-8?B?QUo3NmVMT1U0d3UzMEFTWVErQUpLVFJ0d0tFL2RZYlp4Z2NyNkNla2RJbUli?=
 =?utf-8?B?bGNhWVZYaER1MXhLVC9kRDZlazdkRVJCUFdkMEtpT2dINHp3K2Rzb3V1SU0x?=
 =?utf-8?B?VGJTeHA0N1F6RWdFV2FCeHBJTjVaNzB4ekJIQldaSUE1LzlXWGlwQ2Z1NDBD?=
 =?utf-8?B?a0tWV3Byd05xcmxRRmU0TkJicURJS21FNXl6dDFabjd2V2czMEsrRytPc3Q1?=
 =?utf-8?B?UkR2aFZ5WnlCdktwanlrcDNyNkFvaEx3RnhuSGsxVlgzZUNOTHYzTUNxVjJ4?=
 =?utf-8?B?ajNqU3JaY3U4RUhUUGxWUTVmSkhvdi9zOEFtcXdMZGFFKzNHRzVVZnA0Szhl?=
 =?utf-8?B?bnVGZm4yeFJvNC9YaS9UZUtXd2tCb1U4T1VPUm1MdTc4R2NRSnBpSmYxVUht?=
 =?utf-8?B?OG03NVJXTXV6VTNaQmkrY0tveDcyL3FCUlgzUGdWbFRuWDBnZ3NIbnlTZXF3?=
 =?utf-8?B?cU1PV3BRd1dyVjFvRCtFVG9iQ3Fpcm92ZFYrMDlueDYyYjJ5Yk5hMVV3clpI?=
 =?utf-8?B?S0EwWG9lUGJlNUJYdXZvRVJzSHNCSDlqdVpHS1BlajZmYVdKWko3OHpySnd5?=
 =?utf-8?Q?Nh6Fffeq6bQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWU2UXpzRUEwQTRVQTlRYzk4RFo1MkJTeEhuWjBadlNKZWZBN0s2VEJBbE8y?=
 =?utf-8?B?TDAyZ0JtTTB5RTJXZTlQRXNBU1NHeisrM2NGV1lLVmFwcWROSVhoTFR5VTFX?=
 =?utf-8?B?a2FTem0vWUlDbUZFdExOZHBDc0RQOE5uUUl3TDM4cmIrVTJWNWNYdjdhZCta?=
 =?utf-8?B?SkEraWp6dy84Wk1SMlVDNlVIS0ZWbGhiUkZCdmw4ZXJ5cHlPdGVQUjFRZDhh?=
 =?utf-8?B?Y2xYVC84cEpiREwvL21BRXpITEIrMTNJeDFQbG93WEdReHE1bTUxWmhkZ1BS?=
 =?utf-8?B?UmZXeFp3WVFuSDlxS0dtL0lGMUpEdk1RaWdNL1FsY1Q1bjlVa2JkUU9FeDhF?=
 =?utf-8?B?cTF2cjJ5OWFPeS9ob0pyQy9UZlJ1R3ViVm5ocnRMQ2x0ajdHUHl4aSs0SnpQ?=
 =?utf-8?B?Z052UlhtN0VoSERLVGVsQmV6dHM5WVRUY1oyTjgxMlZkZFBqYm9Ib3A4K1JQ?=
 =?utf-8?B?L1FpZG8vUHdKVDRZLzZKVE1yQ3dsYkpaSFFEbGNNQnR0WERhUlM0Uko1WmRS?=
 =?utf-8?B?QkNPZzVWN3JxOGZyYWxyby85Ujd2YkRqWEVHRjBKYWowRnR4dUcrOGIzTEVj?=
 =?utf-8?B?SDZyNXI0U2FJVDJORGVtWXlTWXhhYVJETFZHVW9EOEZLZXIxNktGbE10bld3?=
 =?utf-8?B?MlEraGpyUngvZGRhZkR4UktrZ0RUNERNUTNCcnQ1NzRVRkNLcGFHaTdtb0dI?=
 =?utf-8?B?WDUwZUdGZ0NrNWhLdEJhdkdTaGRScnEza29NS3A3QlBRbWEyTzJzMGRyTDY1?=
 =?utf-8?B?SWtVdXc3S0NSYWc1NzEzbTRpb0RqTG1hQk0vaUZiUk9sZFhFYUJIbE9TdERM?=
 =?utf-8?B?ZHBBWFM1cGxIT3J6ZXUwS2NjZWovSno3N1BwRWp2Tmt2R2hWcDFrTkF4bHEw?=
 =?utf-8?B?WDJHZGVwUGEyRi9IckRjdGFwTXNvZUltQXpNNllPOEdUL3Z6Y0NkSjJ0ekZ5?=
 =?utf-8?B?V0ZtL0p6c1hPWTlXamlGVXVNQm9lYXdrcEN2N1A0NjFtQ2xkS3VCdDJuRjFu?=
 =?utf-8?B?dzFhc2xFYm1BQlJxOUtMV1pEdTBGUk54WHZsM21sU0g5UkVPYi9BY2dYK1lx?=
 =?utf-8?B?S1pEZVFheWVJZ25wdHcyS2o5NHZTS3A5UmcySDJ0MlBkS00wamVsNkxtMjR5?=
 =?utf-8?B?QUJRanA2d0NQbDd5dUlQTEFuZFBTZEh4cWxWNTFzNHhpOHF0ZUROZWUxTnJ4?=
 =?utf-8?B?L2FaekhIZFRtb0RXcno3cTJzTUxIWXVPOGlXbkhtc1pWT1JiUVF4SVU3RmN3?=
 =?utf-8?B?aVJtSTlyYVF1R2RocnhPZVFMS0VOWU1Wa1hJaTZqSVJ3RWlHdW1XL1h3bmxw?=
 =?utf-8?B?ZXNOekxjdjR1cUZCdzBxaThack1YTVltYlJRR2VKVjZNOWkybUhwUEdldWZu?=
 =?utf-8?B?ZmQ1ck9POWZVUlJDdzJDK0hlMWxIRTlvakI0clRHbyt6ZEkxK1hyQVZzNlRV?=
 =?utf-8?B?QkttRGJQVEhQaGY1RytaaXNZc1NTTE05V2tubTB6TTRWbXVYakpoa1hVUHcy?=
 =?utf-8?B?cjNLckk2QWJLMHpidmpMRnpYM0V0b0NuQ0hSd0s5OUZMcmdsRWp6clFoR1Zz?=
 =?utf-8?B?M2s3NDlIbU9XZ3hyU1VSNG8vMEhkZitYeEVjSkhFODhIbFBRKzNvSEc4OU9J?=
 =?utf-8?B?dG5YNElKRGM2UHp6cWNpY2lTaGYzNXFTd05yd1phSWp5MXAvZWhKbUxacThG?=
 =?utf-8?B?REZCTXhxOUcxaTdTdnliYmo5V0ZVSldIRE1YdmI1UFA1d1RVeVBmQld2THpH?=
 =?utf-8?B?RkNLWUVDR2ZCYnR5OHZxRWxwakgwZUREejdyc2VxMlc4ZEFWLzdMRmJJZTc0?=
 =?utf-8?B?L2syNDczT1FPUnRHdi9BYU1MdFZkbFowMFFsRWRsL0t3amtrN3V1OHRWV244?=
 =?utf-8?B?T0srdjNTYzIvODZoRWtSZWN5MVJ3ckp3Y1MwZU41M0ZzeWM0aURyQ0F4TnNv?=
 =?utf-8?B?OEczYUNUL2Y4YzBkZU4rbmtUak82QkMwNk1EdkJqSzJYbWg3NFlzM2JmV3ZK?=
 =?utf-8?B?Z055NjU1RGJvR210ZHlzb1F0ZkJ1TmhRZlhuZVdzekxETEhOMjFGL3UxRzF4?=
 =?utf-8?B?ak1TMmNuTFFnMmQ0aE9WQ0hiRVkrV1hQVmpWU0VrYWNjaDlBeStQYTlXdERk?=
 =?utf-8?Q?P91ooaHl6L1FnxYYPLsXBZ93Y?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d0af8d-e750-4198-42e9-08dde0b35e67
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 13:05:14.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FC/0Ahsd+3iD3G8qOpQYBF2ULsNRgnyWylHxvsZcPlaS25tVwuy2vVlH0RArgTYQug8ypSnnliamHccKqWz+Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7061


在 2025/8/21 20:56, Andy Shevchenko 写道:
> [You don't often get email from andriy.shevchenko@linux.intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> On Thu, Aug 21, 2025 at 08:35:42PM +0800, Qianfeng Rong wrote:
>> As noted in the kernel documentation [1], open-coded multiplication in
>> allocator arguments is discouraged because it can lead to integer overflow.
>>
>> Use kcalloc() to gain built-in overflow protection, making memory
>> allocation safer when calculating allocation size compared to explicit
>> multiplication.
>> [1]: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
>>
>> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> Make it a Link tag.
>
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
>
> (also note no blank lines in tag block)
Thank you, Andy—I've learned another useful detail.
>
> ...
>
>> -     mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
>> +     mobj_hdr = kcalloc(uobj_chunk_num + sobj_chunk_num,
> size_add() ?
Yes, similar to array_size(), using size_add() here is safer.  I will 
post v2 later.
>
>>                           sizeof(*mobj_hdr), GFP_KERNEL);
>>        if (!mobj_hdr)
>>                return -ENOMEM;
> --
> With Best Regards,
> Andy Shevchenko
Best regards,
Qianfeng

