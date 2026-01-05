Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00C330ACF0;
	Mon,  5 Jan 2026 17:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635036; cv=fail; b=IF6TSV4zmoLDrHd1WmQ6IAmg2x2C+FUqj9RPrLYQUTAAth5hvJZVBWblBUD2yGRC4h1dxdkHnzDGIldId+FMp0amzAmsEHEssuUDibrYgdUZNXseWSiI9Fv+X0hOYL1bd1viosuNlJaCdgV2nxj1R/v3SWfohpIphEW6yH7wFzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635036; c=relaxed/simple;
	bh=cYRILVU5nJmaiwaYkXGmJfpQ95nRpDq/T9KzFb+8+fY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nxiCtX9UYwoEnHHvqXTQyhKzu6xnmR10TINNn3Ufsu1MorqY4/90R6/Av7P/YdNWqZChuWOY6ajv7N20PEM+mkPUMLFQYEoSM5hJFXYY97j197FySWqfMrxdR/rmHJ6ubwBv2zDhiGPVoI2Sm/vCVfZwhwSHfdncGvqi54Mp2Fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zp/gRGKM; arc=fail smtp.client-ip=40.93.196.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zp/gRGKM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F91N8O/aV1MoXf8oPjso5O9A6m+/wjKmKqLfQTTQ9V/G4LrJqn/3IF7MJL6x8xQ2LEYp+FVEd9+kXewuL3xRk5WybbLWVB0SEhVEnY2UhjIXeGRzpFsKFG1oKUI8ZlAV+RcbKk5pDuWPdw9O0K2oq3gxGo/iQQPMHeVQCEoV7XeVWtT89WeFZxBqtqECsseimONbehlCilajdcrijlaQQLB3ujB2vJ3tirHHiXaIaeDh8WMkcu01Cdli9I2FYdDbJ0eaE9dRFFDNKdkjuKjS1/tM2t8lSKix4y62XNva/Fv19dId1kGtKhVXGcLSgJKrTV8H3SfYJrz9C1oVVf2SaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvIzQ9XTucLn0mz0mmOqyMHVbWCYk098F4u9XG1UPnQ=;
 b=aRnquFcpykRuT89OKyhQy3jYzf+E4d7/BLlwbCy5d9dkuMcsyCy1+cTptf6G2/o2mZCWDm3LB8Mbnn7gyTXx7NCMNmPw1pWyqAd+jf+B6+pzRdaG3cLtHbsmrzpcPUdT29QCUjvZJz3nI984yTNUsjXMyMpqYc0dXUkCWfqHhbYzZ+BE6p/lof3KU6+1HjoFbTzzRgaeCnofifQFiY8aibOoxvuDOoKiL3dvFM5urnoEi+/Gqih8z993bS6pwYMybD6JZssrDehcPXZrX+yIIQ7UZCHQNOyWOvu3Bm5Hp0bKvcNeLm4FlMYiaJoQ6y17QN7g1vH9wgKpHmyPAoW86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvIzQ9XTucLn0mz0mmOqyMHVbWCYk098F4u9XG1UPnQ=;
 b=Zp/gRGKM47727zgHZCe2FELsgTKvJI0dhkzD5MMenwz80KsXA1k1rt68amA96XUHO+N4C4GMPEgVK3RCztkR9sJgKHLsjyfT76FvO1ISt8mPbEH0Jv3D6kP2Izu6Hvs9QnGowGkrOh0QPNVYPAn8as/hpzRbo0JmTU/FohsXRkA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB6722.namprd12.prod.outlook.com (2603:10b6:510:1cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 17:43:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 17:43:51 +0000
Message-ID: <620951cd-af90-46ca-83e8-5d9f625ecfbf@amd.com>
Date: Mon, 5 Jan 2026 11:43:17 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto/ccp: narrow scope of snp_range_list
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alexey Kardashevskiy <aik@amd.com>
References: <20260105172218.39993-1-tycho@kernel.org>
 <20260105172218.39993-2-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260105172218.39993-2-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:d3::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 90cf621d-dba5-44ce-9f04-08de4c81fd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUltVHhKMmxQMi9MV09LbE4rcFI3dnBianFiMjh4SmhFdTJzb0FVNUFDZEVm?=
 =?utf-8?B?Slp4R3NLMkpXMm9zSVRzYy83eGNvOUZEeEhGbUE2RTVnbitwUkRydjA0Zm1q?=
 =?utf-8?B?UDhKcG5MUFM5L2l2QXNFQ3BwK2oxUkkrbk5LMGNOMTB3OUVudTZBRm9QckV6?=
 =?utf-8?B?eHNxenNsR1ZMMGx6OU1hUFFxRllMWlladEJFZGpuK2RyQ2w1UUtVOEJuNWx5?=
 =?utf-8?B?bkVJeHJDdTdueW9OaENMSTFISnFZTlRkMHpxalBXMW9uK2R3bzYzTmJQQTF6?=
 =?utf-8?B?TVdBRWRHbTYvSkVOOUhhditvOGJUNWdrS2FuczdkYWVSR2lBR0N6S3BJVk83?=
 =?utf-8?B?bWhINGo5UlZBNWFmSkhDZGJpZ0pwVk1kTXJnK0NxalA0SFJmaDBsQzkweW5m?=
 =?utf-8?B?Wi9aV1BTRDBUZ0oxeUhnVCtCTFExSGR1UFNqSlpuWnBhSCtHRDJjMHZJRElq?=
 =?utf-8?B?NFFWWGsxM0VGdWZ0TmNJMnE5U2NNd3d5K1pHSjR3aUlaMVhzZHNsRzVEVnBM?=
 =?utf-8?B?Sk5LUzIxczl4QzFXUlNzNjByb0RXWklNckx3WjF2VzkwYzU4b0R0YmFNZDVK?=
 =?utf-8?B?WVU1dUd0d0FwY2J1b3BHWnJReTlTM3ZkemJ5elplUDRBQ0RSYnRDSlFmZkdO?=
 =?utf-8?B?eElkbitkUStaWXRNa2ViOFhlTHl6Q1RMdVUzbXdwdnA2cTJvdk91SldLNUdt?=
 =?utf-8?B?eUhzNEtkZHExQisyZ0ovOTdnWFBVVStWenJNYVZHaHpkMnhaRkhIbTF4T0Zq?=
 =?utf-8?B?ZUxRVkxTRjJteDlxbkpxVTkzUCtPQ3ByOXF4TjdJVXZEbUVsYTNwVG9XLzhi?=
 =?utf-8?B?VVhrbU1tRG10MnJtaFF0VUpNK29kN25kTTF2ZGN3UXFWTjlVYmUycFE3QVM2?=
 =?utf-8?B?OVhhUElIUUhqZXBWL3N5aFV0Z3c2VzducExkS3piYlRnYTZuYWZySUdob2J5?=
 =?utf-8?B?bng2VlRqV1p6eUc2c0NoZlJERzFhQXEwQnZnNUZsT0c1SEREZnVoV0c3U2ZZ?=
 =?utf-8?B?SnFVWTJNK1pwWWNkT1kxM2xVU0NONHcxcG0yRkdNc016aEJ0dTFyQ1NSakkw?=
 =?utf-8?B?NlNieHFSemZEdDlRVGFnbEZHUU5ySGE3ZDl2cUo2TUlqMkx2cU1wV3Y5Rzhh?=
 =?utf-8?B?WW94QlhXOXUxOUg4dm5Mak9BYnY0R2dDSzdwWWpHNWMxVGFBdStlUnppY0JY?=
 =?utf-8?B?V1p0eWY4NzhqeDZuVnhNTmJ1VTBROUsxSU9rVTVQNmhnYVhPL294b3p4MkxI?=
 =?utf-8?B?UFVKcnhEbjJGSVZaRVlmR3pybExhdzNVUUlnV201c1pNMVNXZFJqdk1qSE11?=
 =?utf-8?B?cTVaQXNYZDhvTWxEbzJsVEpMUVBWZmdSMXZhcTZIOG45ZDhxK1g3UWJCY2VQ?=
 =?utf-8?B?ZzR6OThxMU83bEhPaFgzK05uWlZrOHNkUHErMmpBUytxV2J5Sm4vL083NlB4?=
 =?utf-8?B?NUc1cklleHRJUGhlUmJFbGhYRXhZOHd4Ty85bkliMEZ3bCtmMlJJL0M0cm9T?=
 =?utf-8?B?djkrekRDTmdJUUlqcE91alk2WEFzYVZCKzRSY1Zjb3pWZGY4ZGRqMVRTU2Jn?=
 =?utf-8?B?bmtGT0R3S1pNSldvbkhVZ3M2YjFlTWYrVENBWXgwVE9MQ0N6SzJ5M2g0eHJX?=
 =?utf-8?B?VlBvVFFWUlJiSWM3anovaEUyb2w0UDlWd0VYbVYrUlNhV21VMHg4cXBJL0xu?=
 =?utf-8?B?LzdxOUJSQStVYmJ5YWdreHlBNU4rRm9lR3lBM3dyc1B5WWh5UmF2emJiK09s?=
 =?utf-8?B?ajlWbVRqdzJCRDgvYnRZbDMvUjA2QW9TTDE1Ukg0YnFxUy80dDRpb0RvK0ZZ?=
 =?utf-8?B?MDhyN3hZK2RGOGlzMEdjK3ZSeWcwYWNQS1RQWmdTc2daS0M4cXRodkp3S0lV?=
 =?utf-8?B?dktUQnpoTEZ3ZmRCcnQ4SVppRUxHY3RBRHFtUlQzSHVCQXp0eXJCM29oblBQ?=
 =?utf-8?Q?pxefGZBToSr1XMZsWF8o/DcaprJVWU8Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2RjYnpQYnVlaWlCY09TTkgwK040THUvQWNhaWJneis5Zk1MTyt0MXZmSmQ2?=
 =?utf-8?B?TXI0eDBYdlR6SnE1bWN4ZE1ZT05PZGxwaEY4ZW5oZlZTYi9Ba3pONkh3UHo0?=
 =?utf-8?B?R0RUaGFDUzRHSzhGRUFaZVJlRW5DWXlnWkVRemNLY0JhRUhjSmN1NDNqbHZu?=
 =?utf-8?B?cmltK3RDdVF2bEdycnVvMElDMTl6K0g0VlYyRzZybzNTZ2N3WnM5ZGRsRjRv?=
 =?utf-8?B?bS9LNDdxSGtvQzhGWHhQZ2tlZ1JwUjZ4SU1BRkE2SDVoV0kycktqZXNTQmdP?=
 =?utf-8?B?T2ZBMUhVTDFUa080TFhSWXhtOVdiS0xRbEtMc0I0dTV6WVdaYlJhbXo2czEz?=
 =?utf-8?B?TEFmNWVqclVLbFVXTEM4QlhXWGFDc3Z5L2tDdFQrZDZrOFErU0Z0ejJreXZP?=
 =?utf-8?B?dXcvdllTWjhSclMwb09VVm0wVmhRTHRHSlBzOUpSOTBCaTRoc1NOS1UzemxI?=
 =?utf-8?B?ZUIvUDhOZE15anBlUDExME9GTDBFbGZZbFAvWm5LWmZyOUc1TElSZXd3MEJM?=
 =?utf-8?B?QzQ1WlNyWGY3Nk1BTXZHNW9QRk1PVk5IQXFkenlubklWSVYyY3ZtdnYzQmo5?=
 =?utf-8?B?aVVYZkNsUDB1ajIxNm5VZEZuVmxSWHBOVFFnOUxES2Z3eVlxVTNTSEFYeEc5?=
 =?utf-8?B?clNTL0VVbDZueEFwcGpDUm5aa1ZoYU1RakF1SHkvWDBKRVd2TE1mT3hZWEp3?=
 =?utf-8?B?RXd4QWVvTWYzYTlRU1ptMFFhVGw0QlN0QmwvMGZPWEdmVHIrK1FQZ2VjV1hu?=
 =?utf-8?B?eEh2Ym5vNHFYZTlMTXVrczFVdVkxR0s2N0UyWlNuZmcxeHFCbzBzaGFPYkU1?=
 =?utf-8?B?SDN3dUM4aVkzaHRLY0k0d0htK2ZIdHVLWGY4OStIR2I1NENPQjRSRzFoMEVY?=
 =?utf-8?B?RE9UbHB6dWp4MU8wRW5BeC9kNmhjU3EvbjRaZ1FaV004SFd1b2ZVWWQ4NFVy?=
 =?utf-8?B?RnZrSTFjSDZDbG1jTHl1VXorR0l2b2loclhkRG1VWVIwdmRuR0JXVEwwTkdJ?=
 =?utf-8?B?UnJkUHNUZDFvZno3Nmx3UTRxd2lBLzlmRDk4Ulp1TXhFMnRzZ0xmNzZIL0R6?=
 =?utf-8?B?WHQzV2MvNngzS1d2OU1YOTdYR3QxVzJQMVFkaWNtRE5jZjNQbVJDbWZOVmQ3?=
 =?utf-8?B?UjJTQXNLRnBtalVYWWMwVUJiQjUxN1JqM00yOWl6alRkZ2tsYytWdC8ydkFR?=
 =?utf-8?B?K255S2ppVFcrY1RMWXRnWHNVMnZkY2s1ODRFa3BEMlp5ek9RTVYwd1NEVHBT?=
 =?utf-8?B?UmpWRGFTRnpTMThXbTVUZ3dQRHgvelBaQ1FCQVNVZ2c3bENzTnk1cG1rT0tX?=
 =?utf-8?B?OSswQXNwMXcvYU00ZDlTc3FvTHhkb1BCTFR6YXlnTk1mdWtxdzg5L2pVZVNG?=
 =?utf-8?B?YU1VVmFwMGN4bk1mRVBlWGdOWkhTR3VGVml0cXRxaENRUS9xbGlma2tvMnB2?=
 =?utf-8?B?R3RUckZRY2xHRjBkUkxqUmE5WTk4NjJseDlTOEJGWnhyWSsxV3F0ZG1PZVdV?=
 =?utf-8?B?WlVmNjlJbVlZS1g3MThoNEhVT0E1RC9Wai9nNS9yWndPQThIaGNrSXllSzNl?=
 =?utf-8?B?U201cDRrMUs0SThkTTlIclVQSU5zZjBESktzWEZVTzJNOEdVZEpKaVl6WWhE?=
 =?utf-8?B?RzNuRzN4enYreTFzK2lmNFhzL0dRZUo4V2dTVi9YMkVGNTZ5V2czM0NlQnV0?=
 =?utf-8?B?MTM3VFBWWi9ZWVNTWEpKVWFiSEJkRFMwWG5ERE5kSVZXblhVVVB4T0lDMXFT?=
 =?utf-8?B?N2ZzMlQrTk1uUCtLaDBOUk9Oa05GRFBJQzJ2TjlLdytucDlLUE4ybm00OGRH?=
 =?utf-8?B?RnRFTGdqd0JLZXgwOUIzVHV4QUNkbVNIa1VvUmZobXJpQXloL1VPTDZDL004?=
 =?utf-8?B?c3FNYmVTcFRMTG0vVFR2TUMzUWl2dFBDMW9Lb3ZIWnc4Um0xbFcra2YrVXkr?=
 =?utf-8?B?cVNBc250TGRFV2dYZFRVWFkvWkxkVTFUWlovZUhXd293WDlITC9id2RrZ0gy?=
 =?utf-8?B?MGFnVElJNURwaTI4VksrT3lTdUxCTUJjakMxclQrQzBsK3gyL2p0ZmY0WnhI?=
 =?utf-8?B?SUM4L1FIOTV1V2NQWnJOSkpYdTN1TTFuQUl3Y0paY3REUWtZMzE3Qm44NFdW?=
 =?utf-8?B?cmhMVUxNZjJLK2xpajZoczZjemlJTHFrWitxdFhzUDZxWmF0Y2FNUkdFVlZM?=
 =?utf-8?B?MWMxVmc5bEZzbWNvV29vUnBhY3pmR0xLQmZLQlp5OWRDSmQ3ZVErQlk5SzRE?=
 =?utf-8?B?T1A3T0U5b3hISFdWUmdGZkcyRWFHUC8yQjJ6UWJIbXRaSkU2ZFJiK3pJeVoz?=
 =?utf-8?Q?Rp36v/zB3tYpnVXP5N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cf621d-dba5-44ce-9f04-08de4c81fd57
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 17:43:51.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSSmu9ababkiOzSIFwscz6v9/Wc99ivJYVjU5WPaONhjQpGbKNocMa3nD55ejYfgC6we70ouErRxWQ0s1XmphA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6722

On 1/5/26 11:22, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> snp_range_list is only used in __sev_snp_init_locked() in the SNP_INIT_EX
> case, move the declaration there and add a __free() cleanup helper for it
> instead of waiting until shutdown.
> 
> Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6e6011e363e3..1cdadddb744e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -127,13 +127,6 @@ static size_t sev_es_tmr_size = SEV_TMR_SIZE;
>  #define NV_LENGTH (32 * 1024)
>  static void *sev_init_ex_buffer;
>  
> -/*
> - * SEV_DATA_RANGE_LIST:
> - *   Array containing range of pages that firmware transitions to HV-fixed
> - *   page state.
> - */
> -static struct sev_data_range_list *snp_range_list;
> -
>  static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
>  
>  static int snp_shutdown_on_panic(struct notifier_block *nb,
> @@ -1361,6 +1354,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  
>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  {
> +	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
>  	struct psp_device *psp = psp_master;
>  	struct sev_data_snp_init_ex data;
>  	struct sev_device *sev;
> @@ -2780,11 +2774,6 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  		sev_init_ex_buffer = NULL;
>  	}
>  
> -	if (snp_range_list) {
> -		kfree(snp_range_list);
> -		snp_range_list = NULL;
> -	}
> -
>  	__sev_snp_shutdown_locked(&error, panic);
>  }
>  

