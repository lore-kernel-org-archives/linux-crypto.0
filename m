Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4637366FDD
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761844135; cv=fail; b=Vb5rWEJsbA8MCktriB52T5lYVgVijK9v19sXPvtt/guY5Yx/NCmjIaE/b6E/UUvYm2B8s5G64B9Z321/jC5+/3aDFxj1XLohQQLekRG1kw2+bEf0Y0jbhzdjX5RWGsEg4aQ0JIaAWiYueQDiVSjuhv2E8HfEXPZPELTvPSoLsp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761844135; c=relaxed/simple;
	bh=1Z26REUbVqi9PeYMEUDfwwqqVm1hWk1e6qjLbI0P3fA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O81fk/k1K5IhXIKZVYszN+YFf1GM0HNRXdn2hFqIw27P6K1yubwni71L7BvQp59pMe6sx6HpfjIBUzDT1xU4VN5HHRG7eFORGHgzXm20TLrUm9xL/04O/6qWuzct88DdjVXhiC0eHkRmRfHtk2zVt0lNaS1uMJQReuHiaKV6uu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g0rW26pL; arc=fail smtp.client-ip=52.101.52.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g0rW26pL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oInSnJ12OPtTF2qAgTf28DCDr0/im38Qv42HVymWfFnC/FZHrFQyCYfI2HrIkoJ7fjMPMYQEcITq7C5hclPSasnOB6g5t9I6vyr3ZBC98F8oblFA4hzH5VQDG648GKzTQjTAlIECESaKxqX62sYlwfrYA/NpK6hd6FstKBEAQwfQfdG/iMA5bzYHCcNh/182tdfl6HyAGtk7PU0Xu/eYmY/HGBvGMZQ0+TIfDMJO3luwjCb50UM9HdE3NyM4Ci9DKuVLtgU7ArxV1gManBC+N8QFKl2eX2pDAW9Pd3PmKKsUxuCskHkz4log0hNuJn6SRfaymUEyjwK/UrIDpMcenw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5SG5g/vWLevwX5t2dhdwxvMinrLuEWH4kBodOjGTCw=;
 b=D6p0OTcS3TOEEJ8XWJWMGXlamwpNNdyenCe1hY+wPdoiVZ3gk4m8qv2tBC3ZOvmpwI8uYCsVgJeOtkeTgRvcKCsIdM5totvj20jMw/7rFT5mEO7nqFe5gNhoRwaOcWAGkgfnjELJDwdpCJ6HAqbzZsVKpI8+qZTYKhQxBr3YheFky+vEKzeFScOqz7Avdvjb7ZIRqKE3MlADxIkCRZSly3lCF8KGUAAyR2D/tEN3wfQ8GP+DiYdsPIeh8357ijzjpZAtANsm5REJm4Z7xSMvl/Dxp6I+psSmNCNPbFbpqBAbzcAyFIIdkHhLXK4ziRz+gx6EDnxk2iaHqLD4WHTgVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5SG5g/vWLevwX5t2dhdwxvMinrLuEWH4kBodOjGTCw=;
 b=g0rW26pLZ0RQ+D8LcPu1098LoYCHpg73AASbrwC9Nhy8Y7COH7LjWzXIFEzfzME10xNYRuEOH7mxJ8U53xTO6QVSOM0D+4r7ZZbowMSb9dEncgI7Bi4ANWg/9LKtUDQPUcd/xH/a9oMEhQ6YlzEDLW3WPfqWVz4DyEg6H0gR/cU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by SJ1PR12MB6145.namprd12.prod.outlook.com (2603:10b6:a03:45c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 17:08:48 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9253.013; Thu, 30 Oct 2025
 17:08:48 +0000
Message-ID: <f40e1aeb-fa50-421c-974f-b8f4c0d129e1@amd.com>
Date: Thu, 30 Oct 2025 12:08:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Add support for PCI device 0x115A
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 mario.limonciello@amd.com, john.allen@amd.com,
 Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org
References: <20251029161502.2286541-1-superm1@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20251029161502.2286541-1-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0176.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::12) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|SJ1PR12MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 1655ae63-3d0a-471c-9523-08de17d6fd9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFJ0SWdGcmFIZFZtdjU5bllVMEwxNGFWRXkxSm1Rc2h3bTQvYXZwWHljU3hJ?=
 =?utf-8?B?elZ5bnRZMXkzWk9PcmxycWR0MkNFamFNQnl1eXB0UVdqQXFZRVkyMjFHNjRB?=
 =?utf-8?B?WHlXMHcvMzhHUzZ6Rm1yUTBPb29RUmYrbGhDcFJmWlRpQk4rZllWeDdqMzBt?=
 =?utf-8?B?UTVpYngxQm1mWmxxVWVtS01rUzY4UStyU1NsMS81V2IrMXNjTytQZzlKWGVy?=
 =?utf-8?B?bStVYzIvLzVVZGNJVjk4R2Qxd1hpS2NhYmlsdUMzRE1NdUVjT0JyaE9ZY1pi?=
 =?utf-8?B?ZzJObitTVnVYa2IxTnJtZmR0bFIvaHNvODZFQ25JTjhWTHV4dlNOODdVd3pv?=
 =?utf-8?B?Q1RqT2lsamhkS0REUDNwS0Fuc2tCdjFadXFCamdVa3g4dldrRS9KZ3lrdzZQ?=
 =?utf-8?B?M01OVUtiNCtPVUYrUmxUdEgraVdpbFozR3hHMlM4YkJnVnVPZ2pzSXVna2g3?=
 =?utf-8?B?bmxwb2YrbDV3Y2ZIaFBWeHY1WGg1UUxxQmJBZTE0ZDZMTHFicnlMUEU0Rnd3?=
 =?utf-8?B?ZkI1aDFzS1VBNVhhM09COHQwRTVsckE1Z1h2dm5Pek1oNnpOSzk1QmU0RERL?=
 =?utf-8?B?eFFYa0VEMUJRSVY0RGVWRmhsU3hVU3l3c2Mza2M4RDF5TitjQlhzeXRHTVNz?=
 =?utf-8?B?V2VGbWZ2Q2VGQlBNZ3Z3b05uVGtBelI0aEZKeUVjd0g1RGxQVUNrSm5SdEMv?=
 =?utf-8?B?S2E0UkxMQUFpdXF4RVFNdVRZQ2Zub21qcWhUNzhLT0JId0JTWUZnYnF6Y0Zs?=
 =?utf-8?B?M0JPR3lHWGZraUNWQzhvdnloTExYa0s1emNQRXFsZnA4TC96M3hGT2tTc3o2?=
 =?utf-8?B?M3EvbEQ1VXppcG8rWU9nckpHb2RSR2dBQ2tlNSs1RElIbmtvMlJYa21pQjNq?=
 =?utf-8?B?T05WWmJlcmV0ZVdjUEtFUHViN21ISjJtR2xYSFp1a1RicEQ3clpQQThFSnYr?=
 =?utf-8?B?NTVWZ1FoN25nR0Vra2d4V29YblBMRDJGcTc0ZEtxajVwUk43NWFTZEw5cUhP?=
 =?utf-8?B?bDJzWjduOWNqS0lOcEU5TkRzaGZsaDVLdzJTWk9WU1BaL1lpdUxzRTBZRm9G?=
 =?utf-8?B?Z3NSQTdKcWVHbjRUaGg3bVJpWUhaalhDUXdMaW1hWE1adTYrZFhaODRHRXFp?=
 =?utf-8?B?WmhmbXlWak5YbUl5UnQxTXhPc3dJQytSTmNRUVNQenI1VnM0SnZaSEFSQVN6?=
 =?utf-8?B?QUNQTHUvM1JDS2NqMEUxWjRHdEl2SEk1dGhGVW52YW5vVmxYNVYrTmxaak1I?=
 =?utf-8?B?Z3NCUVlvOWRFcHQzWXFYeXNsSWNwT0RoWXFGTGFDY1kyUy93ZzRBN2psdU9w?=
 =?utf-8?B?Tkxma1Aza3AvOElIcmpadUl3ZzVYV0RmQll0bVh0TlRneXNOSjB3S3o3L3gx?=
 =?utf-8?B?VE1XK2FUMHVKREdVeC9JYlp6b0dqRHh2RU5kWG95ZVJUZ2ZJaHBCcjFjME9M?=
 =?utf-8?B?NS9sN0FaTm12WkV3TGpqYmExQ3VhTmRpUWlyTFdvYnpmOEZtWXhsZjAwdHFT?=
 =?utf-8?B?VExuZFB4ZlJyZmtEc20zV2UrWEFtVFhjY2pQOWFadUFNNUFFY25TYkRFNDJD?=
 =?utf-8?B?R1NIcTRPVTkrU2NkUklvSk8zMGJqRHV3Tk9ZUEY4ZGRTOFp5YUF6dTY2UTdV?=
 =?utf-8?B?MjJUV2lJdE9VVjZmNmlFV2FtMGdyU0FFOE1aQUNzQjJFRHpJYXV4L2RjeUMy?=
 =?utf-8?B?WjgrMHM4dzNqaFVROWs1OGMvWkMwaW1xbHE2NitSNWZEMFNFVzBiRnhCWlEv?=
 =?utf-8?B?UmtJWVV1NTVUT3pneVBLL2RCZFlwbVBXdDFSbkRJMkFVd0kzN3J0V3FMQ2ZT?=
 =?utf-8?B?SmZRem44K2MranRJK0ZzdFBuakc2Z1luNkE4bHZFYUo0Vy9MWmdtenI3aTQ5?=
 =?utf-8?B?R2RiVGI3d2pwb1lBR09TQy83OG4yU01mTjVJcU9YWHU4eDBkZ1ppWDh3Uzhz?=
 =?utf-8?Q?P2+CvaltcoXIiEt6Cfgj/52oqA0MyOv/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVE3RmhZbFpOOVdmbUFLZ3M2dVdUK2J0Y3lKek56TG8rd1dZb0VBajVSSjQw?=
 =?utf-8?B?NmlVVUdQMjYrWGZ1VmozbVNPbjRRYzRvMWZtOUViT0RwU2Q2aWE1RTJiZ01H?=
 =?utf-8?B?aElobWZVZXNKeVNaTFBDUlpJZlMzUFRoQVA1ZWsySm9QdkRtNEVYSkltRVFE?=
 =?utf-8?B?M1UvVDRDZG80L3VaS25FazRCL2VBMVI4OVVlWTNsdTFuZ1pJdkxKZTJ5dWha?=
 =?utf-8?B?RkZRU3hielFWSm82SyszUm1IdytPTFE1UDhUb1daV0xCTVFTRnpsTkVEOWY5?=
 =?utf-8?B?KzEzQmp1bDZpU05sQ0plc2Irb0dYaXdCUEVjRmJFcGZKTHg1OHR4dVEvV05o?=
 =?utf-8?B?ZVRTTHo0WFlraHhJQ0V3SG9mSnJPSWtKR1FNeXFNWGdCcGRvcTFTYzlRTkFO?=
 =?utf-8?B?UGlmSkZPaVFwZnRsVk1TRlBWU014bDZkSDV0VUt4NUVoVVhtYnkwcHJadWpX?=
 =?utf-8?B?aG9ZcTVzcUNabXB4cWRVSkdZQnZlenNRTFlCRllZZjhPcWhrYnJrb3JxWksy?=
 =?utf-8?B?VXhETkRuUWpSUE5qNS9RZlRtMUtGR3dUaVRwZlMvRDFUR04rYTdqNWRXbW9T?=
 =?utf-8?B?SE5HNkxweERyZ21GUW55K25mdTRtYTRRa2F5MWpIU1U4SVhudi85ay9vaUxM?=
 =?utf-8?B?Q2hZMlY0TmJ4TGkrUXFuOEkrZE1lTkwwTXN3TVdOYWVsMG9DY294dGVObjhO?=
 =?utf-8?B?a055RjJBdnUyLzNKK3lCZW1zSGk0UFlkNitORTVXNWtWWWo3b0V1elVBKy83?=
 =?utf-8?B?M1RQWDNQSmV1NEtNcFFhc29wSVdLelNxVjVTL0QrSTFqS0NSaGxrYmF1Y0hH?=
 =?utf-8?B?RXdTNG9FYnBDZUlYT2RoOWJuNXEzdmkxUzBUMHlCN0RQb3FVV2U5RU1qMnhN?=
 =?utf-8?B?bU9rM3VpdndQVVp1Y2NGcytacXQ0SVNYa05mZmRvQS92b3JMQ0lBbk93WWhB?=
 =?utf-8?B?M1N1WExlNkF0dFM2N21QYldMRWt6R2hDcjR2M1lmY2t5N0o4MWlEU0d3d1JI?=
 =?utf-8?B?MHJIWk1QZXlkT2tLMzhueVNpdTMwUHQ0OFpZdEZlZTRIcHFHVWh5ZStzUXJy?=
 =?utf-8?B?K0pVNi9HaVg0QnMzdGRKdDdnbGRwVmdQa3pjeFFXY0hRcnZpellSTVk1U3c3?=
 =?utf-8?B?bFV4WXhNREpzRjJ2dlU1TUFxeDN0dWI3cHhjYVhQNURpd25RZ0Y0UEpkNitt?=
 =?utf-8?B?dFJQa0FXRms0NTZ2K2YyOWIxWFUwQ3AwS1hKSWo5dGFQNzFVNHVUbG5XSktG?=
 =?utf-8?B?a1MwUEtXYW5EOUdvNDh4cGp4RHJuZU42RjNxdDJIWlkxdkYvT1pjSHhUeG4w?=
 =?utf-8?B?dzYzZEZHZVdBMkJSeFZMSWw3VmVUN0V5dUJJYzhPN0l6NXJUWUdLVFVBYlNx?=
 =?utf-8?B?czNWZjVoTmxSYVRtRXBXVnBMc2pLY0hHWVovQko4N0s4Tlg3MVFYbzBiVDQy?=
 =?utf-8?B?WG9UY0V4bUxxcGFQaEVPT2RIbXNmbXFmcnNtZGZCeGJWUmZaQW9tY0NUZ3M2?=
 =?utf-8?B?MnF3cXJvZ3RqZ25pKzhRY2FnU3EvTnk4YkhtdFUvTUIxWTJuOERVd1FnaHVv?=
 =?utf-8?B?RkxGaDVlT0V4SnNzNHpNR2xpRzFKbE1aRGVMM2daM2c2cXBaK0RNUGhYcG1D?=
 =?utf-8?B?ZnBIbEpTWjdhemJuVWpNSGJnMVQvTHZINXE5SldMSG11cnNoalNnRWFScXFS?=
 =?utf-8?B?VGpFN3Jjeitud0RaWVIvcXYvakxDaG95MlhIWDloaXVMYlJuNlMxK3JPSU9m?=
 =?utf-8?B?YkFuM1NyUGJpUTVERUZvMzNvdUkyeFdxZGd2c09LSzdXeHh6RHFFRXhCTE1F?=
 =?utf-8?B?MlZMVmt3L0FubDJkc1NnTXAzb3BZZWxLWUNwazFlNnp6VlMyRjlrRDBkSnZR?=
 =?utf-8?B?MjFSSXFZaXRFdHNYVXQ2TEY2aHJGbGhHdldYR1BJcU9uRlU2U3podU9tVGxH?=
 =?utf-8?B?ZXNTWFJEQy8vbXl0aGRaMkxPRTlqZE5UUnlwZkE4eG02NG10ekFoNzVWSGNu?=
 =?utf-8?B?bjFnME1GeW5MVDk4WjR5YnRhN0NGYjRSK1NzT0ZSbGQwekcxSGJETDJrRjU0?=
 =?utf-8?B?MkNoSXdOd3NFTzhpejdWZGU5eG82REpZN25uZ3J6aHp4WlVWZUJMRVhZZnJY?=
 =?utf-8?Q?IzM3tIx8iJ5V/a+PGyZXbpdxD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1655ae63-3d0a-471c-9523-08de17d6fd9f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 17:08:48.2646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KgXdVDQKlESr4YbSuaV4hXTXOzNSyiuGFxyGF94YF100nQVtyXFog0Qa7ZfgIJlvBZGk+0c8YJvwr+TkIG/E+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6145

On 10/29/25 11:15, Mario Limonciello (AMD) wrote:
> PCI device 0x115A is similar to pspv5, except it doesn't have platform
> access mailbox support.
> 
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sp-pci.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index e7bb803912a6d..8891ceee1d7d0 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -459,6 +459,17 @@ static const struct psp_vdata pspv6 = {
>  	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
>  };
>  
> +static const struct psp_vdata pspv7 = {
> +	.tee			= &teev2,
> +	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
> +	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
> +	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
> +	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
> +	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
> +	.inten_reg		= 0x10510,	/* P2CMSG_INTEN */
> +	.intsts_reg		= 0x10514,	/* P2CMSG_INTSTS */
> +};
> +
>  #endif
>  
>  static const struct sp_dev_vdata dev_vdata[] = {
> @@ -525,6 +536,13 @@ static const struct sp_dev_vdata dev_vdata[] = {
>  		.psp_vdata = &pspv6,
>  #endif
>  	},
> +	{	/* 9 */
> +		.bar = 2,
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +		.psp_vdata = &pspv7,
> +#endif
> +	},
> +
>  };
>  static const struct pci_device_id sp_pci_table[] = {
>  	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
> @@ -539,6 +557,7 @@ static const struct pci_device_id sp_pci_table[] = {
>  	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
>  	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
>  	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
> +	{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
>  	/* Last entry must be zero */
>  	{ 0, }
>  };

