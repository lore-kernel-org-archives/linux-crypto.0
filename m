Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E150630DED1;
	Mon,  1 Dec 2025 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764599518; cv=fail; b=QjN5hQGjkCKMP1xDZGrGoMfNbVjDhyUJFx10+rApoDxhJlT54BElHoP1PN5ogKjtblH7Dox9IogiVWQEKx5ptgCtBODfPolLz40cViFu1NWoNTriimgPlbTqTt4g3OcC1IODoViuAoo4jbQh3E0m1bWcpRO4YpuvCEuvW1HpJeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764599518; c=relaxed/simple;
	bh=sOxd5AOkcpzMzkPDhRypngGYEir6uTBcjPRC9VYKKV8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c62tzKRswE4PAU00UTHLsQvf4VDdOwOXd1UDvqNxd2d/NYezQjJPlo0jSzx2dZNxcqYvrZR83eMU2L3omMvhE+dlqGW3djUTSxjRqrdLvHkVwNoFGOQUy6DSLk/xy4EEE3V4ty9pL87AsNFILzM1lBxR1i/PMjwn0w/goi1fz08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gHhBPLQP; arc=fail smtp.client-ip=40.107.209.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gHhBPLQP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvjYDafPxrPgRV2G8oQjN/MlsnQCv6zhxiUJ/w1H/bF2I1y+sGpkV+rCIIaT1Z7/zoF9bwO0pfe/+TgexgswYTVfTnejsD2EIYjly2JfYLfqQ/qtjHR/ouGCktYcl7rRWKU7kUaOR99mSSWCwPxa3HSKvddGxnJzvbYI5mxyR4i/VGzoGrJcZKP36EsZTehp8bFVAioobhKAZdAtsLTbKr8ui5a/3NGRhKKjrbt0o1ksXhodAC0tt6oMUQMoX8E7OmD5w7kAIDbYYiwRIaTHOBM5e2wtxYSjtq265NrNdfsoZjB5nj5AQpWWOuq1ABYPfE4KqzaUgTfybJkJayuSiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PahIqkqZzM7Mphh1WlLxVoJm88Ct2bEOlFCV+FIiudg=;
 b=nnAvMYJNODKVDD+lD2XYlysOLPirFs4rS5CCs3EZUZXPtcr1Vgt5g2lJBKxeBelXdoMDZVPJ/2EgLCPSOqtocV4wg751rosyVrPJ3geLDcN+z1hXKIFRbQAcZV+XMSP8AzFQLD9+sVxrKh3PrwT4rxD30QG/+AdNICZ8c3ca3/v7yCrGEKvef5guiY+yji1Ywodl0jr30yN6UlEr8oBsM+1OEvdP5HY1cA+elFTM5BmaFvUkUtl5Y0C7zgoSucmuQjfPeBaJCiUU9Zk05EikCNcET2q0j9unCC9b49Gwyk7Zj+LQIlwOwz+//2ZQ+cKmgCdk2ocXWSwVCsJcbo0mig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PahIqkqZzM7Mphh1WlLxVoJm88Ct2bEOlFCV+FIiudg=;
 b=gHhBPLQP0zusiu2IRljSlcNUcbnwyHlJDxJv9EmGXvnH4FGSnf6G5xAY2Z/oHPdcdyBO3C3Em6ZzFz2zmPYW7c9kzAsAvGnxkeoICOrkQkt1ACTpciknE/nhOe+5TXVwHAjq6z6WjOdv10FKOjFBjpECXJ9XsdqL0jpThBcMYj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB9114.namprd12.prod.outlook.com (2603:10b6:a03:567::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 14:31:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 14:31:53 +0000
Message-ID: <b5d1dd97-4e76-461f-91b5-864de2157b3f@amd.com>
Date: Mon, 1 Dec 2025 08:31:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v2 4/5] crypto: ccp: Enable SEV-TIO feature in the
 PSP when supported
To: Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan <gaoshiyuan@baidu.com>,
 Sean Christopherson <seanjc@google.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Amit Shah <amit.shah@amd.com>,
 Peter Gonda <pgonda@google.com>, iommu@lists.linux.dev
References: <20251121080629.444992-1-aik@amd.com>
 <20251121080629.444992-5-aik@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251121080629.444992-5-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0197.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB9114:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d66c986-2799-4a77-deca-08de30e65f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnI1ckpvbEFIcXZrYzlGZTF2RU1hVTJxNjQvTkpkbUVaQlM0M1ZueExSeTRQ?=
 =?utf-8?B?aVBlaE45TWk0UGhwWmc4UEVHNXJIdHZNUkNFeFYzbk55Q0pzaE5zQmxwY3g3?=
 =?utf-8?B?M0llYThHamdCNzc2VFg5Uk9GZHppUVhJcEdCc2g3MXRkRmszeXdWTThDZXpk?=
 =?utf-8?B?U3AxazdpLyt6NlA2aEpDWkZ2bCtLbUtTWUlGZUNLOXhIV3lkYU9PelgrK3d0?=
 =?utf-8?B?akxHc05DZHE1dHczMDk1OVVNM1lOOGxsRzZTZ096WGMrY1h6aGFMdk5RMi9y?=
 =?utf-8?B?RmhoNG40VU8yYzlrWldiWFp4T3dKRjVuODh0TVZ3dk1pUDFBbnhOZDY0T1Q5?=
 =?utf-8?B?a3VwV0ZCRWZZV1VJYW5zUnpxWEl4RFVUNlU1NVhjWDRzS3hTZmxjUVJuUG9J?=
 =?utf-8?B?Y0kyUytpVUluS3d0V2xYZ0dkZE1NSjMwdnFZL2ZkQXJMY05YeUNoVlVDaUh2?=
 =?utf-8?B?WnpsU0tIZStoNmhtTXcyOUZVQVlsMFY5c1FYcCtMaU5FMjZOZ1M2dDZtTTdi?=
 =?utf-8?B?dGZJR0dlTzN0Yk83eVVRVHB3bDIwTDhvZy9lU0hGZG9semhTUUFwQVpyRC9S?=
 =?utf-8?B?R1RsRXRRWlVDZkVuSHUwN3dJSlA2NWtESTZwbVlQUGRqbEVTaEJjVG1xVHJu?=
 =?utf-8?B?d0VZajdIVDNvd3Jzc0NVczRMejYybHhJemFxUkk1eC83b0wyNEYyem96bGxB?=
 =?utf-8?B?SWhRZTA5UkpsMW1tWW1yaGgzTkd1eHdHR0JWUk1KeUdnK3J6WjVrV0NpWTZ0?=
 =?utf-8?B?eHNQaHRJQlFrSEw0NHplNGhGa09iUExlT08rV2VQM0ZSTm15ak44ZUFwQ2gw?=
 =?utf-8?B?SGhUT3JhQWFtaSthaFZDTkgwMWtlZUJXcEVOTS9tRW1YYklVWm9uK3RHUGIr?=
 =?utf-8?B?dmptUHpMTGlxbjViRmQrcmJkSTNxYktDeFRHd25tejk3WHZadCtTZlNxZTN3?=
 =?utf-8?B?a0hubmJGTlQwVGZURSt1a0RpYVVCb3h6d2oyVUhvK0RZeUxxS3AvU01NU05i?=
 =?utf-8?B?b1RUSjFCVytHV25kT1FsNk1JUFBiRUhnUktJUVl1a2tuQWJtempFL1o3YVIw?=
 =?utf-8?B?TDhVdUJFMWNCUHBra2psQ1NOME8wZ3EzbDdMNUZLcXdZVTNtQXJ6MkhWb1NT?=
 =?utf-8?B?QjhzWUhWanZVdkNERm00SHVCTDBWdllvcnpoV09PTjNYYzc4ZG1VV29EdTJa?=
 =?utf-8?B?cktXQzRoRUc1eGVOWnR6RkY5aFFUL1E3cU5aSkNWcWRTblJ5TVdHZlpLckdr?=
 =?utf-8?B?MmxHMEJFNXlXZWRabllMMnBPYlBweVlIVFgwTTF3SmQwclJ0cUhCcldlZTVS?=
 =?utf-8?B?ZTZ4NVgvdnRGaGJvbEsxK3JBUXdlRHpCSUF2UkJjYzRwbFNKckt6NGw4MkU1?=
 =?utf-8?B?V3J1dEhyVHZ5c01VY3Z5VEhadFpvc1FUNDNDdnVxTUFoaHkrakNMcHQ3R1d3?=
 =?utf-8?B?Z2tKSml4WDc0MlNYRmtqbVphQno3clJ6ME9JMUN0MTA4dHdHRno0bEMwUjM2?=
 =?utf-8?B?N2NNNE1xWEhURVdXcDZ5V0pCY01GbFU4eWZQSWR1VCtsc3E2eDBqdEdiRy9T?=
 =?utf-8?B?b0l2Z1VXNjBGS1RsVVFBZmdReHRYNENPbjhuRUl2LzJJMUx6ZDZjUHJ0ZEZj?=
 =?utf-8?B?VEdrbDUwMHVEaXN2Zk1KNGs2bUdPVk5vQUVsVngwb1JHNks1b2JHdDQ3SjZ2?=
 =?utf-8?B?RnhPRnNhTE5ZVWptekZTQUFodXJyRDl2TkZYbzR6VVV0bXZ6OVhYSmE5U2U4?=
 =?utf-8?B?dkhwclpscGp5bXBoTG9BdGVVSmdVRjl6Q3cvbHJyUkNGL210c1l2SmdOWUdp?=
 =?utf-8?B?OGxCY2tlQkNYdlkwaVRJSlRtOWNSSWp1c1ErMTJEVlRCM0VuZ3NWaEpxWG1q?=
 =?utf-8?B?dFBaMHBOQ3RrWkhFWjJiWi9HWDZ1Z2dKakZsQnNjbHBLZWx6QnpmdTRBa3Fl?=
 =?utf-8?Q?XvUtEQyrROPxwwmyhfCfb83xBiAnUsIr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3BCcS9UODlkZk9aK2wzaHkyY0FEUStBd0NsMmFpbVI5NHczUi9GYm04ZFBF?=
 =?utf-8?B?bTZKSi85WnZGMDZXZXJLdkNwTXFrdGdrbUVyY2d6bTN6U0pzU1RpdFYvVTF1?=
 =?utf-8?B?dzNBZ01QK0tEckRhTUJNeE1hRHB1YTdtODVRVmo1NWFCdTBIU0J2RzhZTFA3?=
 =?utf-8?B?WEVUNVg1ZVd0dXcxYXdFM0dwa3gvUHJhcDViSExTVXZFVlRHMDViTFhBZHFO?=
 =?utf-8?B?cldUNDF0V2t5Zm5DSjNPaWE5ZXNQRGZheTBXNUVTNjE0ZCsyajVxcTNuT3Vu?=
 =?utf-8?B?NlBiRTdHakdkTlVZdmkyMHpPcTI1Qm92K3ZPdHk0dnBUTXZCWElZNzlwWWhz?=
 =?utf-8?B?TVp5cTRLTUdCMWdpTFQyazduS0ZqQU5JNStiNHU2ZWRUYStXNUxqdFdGTGlm?=
 =?utf-8?B?Zm9WOU42TDM3bGd2Um14KzhEZ29vd0F4RHJXL0VldExHSmdvRUJDaWdFbHBz?=
 =?utf-8?B?ZlN0OXBrZE9EYTZYK1V5b1hWcmdRWU4yeVYzblFUVStVSGh0eUZYOXNaaGlk?=
 =?utf-8?B?blRSdGRzUld4YnBnM0VVK1pKbHhuVG82RWw3YjY1aW1yZ1RQbUtBbjdGRDQ4?=
 =?utf-8?B?TExDOXZYYlR3ZGRJVmgwd0tTbmVEMEJhbXQwczg0dys0UEdPQjFBOENFNVNx?=
 =?utf-8?B?eWtOdXh4bGthVWFlSW5nYytJbTZtWkN5bTltdGRwdDhwS2kxOHIva0ZrODE4?=
 =?utf-8?B?Q0dqWjJoSlNBd0R5dlFybGhzWWpISHBnNTJSdTVXWDByeTh2cVgwSVZkemEr?=
 =?utf-8?B?czNYMkcyLzFZN0lvTEFvdUhDUUsyQ0U2VVhMWlVSTVl0WXMzNHNIcTkxcWZ2?=
 =?utf-8?B?RFZ0S1E5dUkrRDZDYWdxN0ZhRU03ZmZNQkQvR3hqOFNFUXRwajlJK09sejRR?=
 =?utf-8?B?aVl2SG1UZndOczNCOW1qMXp6VnpYSjg3RnUwYUJjcW5PVnJ0ZVI2RXNnbVhV?=
 =?utf-8?B?a2ZNdGkvaTJEVmM5eXhEQTVISElLWk9sMVZQWCs1aXFHdzBDQ1RGVFplbFVF?=
 =?utf-8?B?UlE2eGNsTGVjSGwzajZyQkJhc2RodjVsOTRLTDFCeFIwc1VISWdNSnpEUkxC?=
 =?utf-8?B?RllBRThVWkVnWTcyV1FoWW5MdlZGUHZxQm5sbWxkcU5GQXNWQ2E4Wm0vMC9B?=
 =?utf-8?B?MWE1dzZlTE9tQTRwbTVUclpTUHpkSGJ0VVV2c3dPb1p3VUNGR1dkV2cwc0h3?=
 =?utf-8?B?aWNUWjNVcDNlb3A2bHRQSWpEaWNhZXpMclFxb3NtT3NSWVVhd3hvakNYSklR?=
 =?utf-8?B?ZzBKdE9FZHhZbEtMT0FLVWs2cWpkcWx3NDQ5QnJ4cWVDZjk1clAvN29rb1U5?=
 =?utf-8?B?UHdFTFAxM2tmMmVWQ21Rbjhyb0FEV3YrU0pCVVlSdnJQZWpTajZIVVlEUmNh?=
 =?utf-8?B?ZGxyMnRjbitHYkpEK1JVVHF3N1pUSWxJZ1IzWmF1Q2RDQWFZQjFLLzhod1o0?=
 =?utf-8?B?eGxWQVJVL2tHMDh0SlVqVUlNTjlPZTFsZ1hZc1V1VDhzRk93VDNXQ0dsVmhS?=
 =?utf-8?B?Sks1bjNKenlWMzJuZG15SjRuYWpiOUxjZVZlQUJOZ1ZhYXRZV2lQQ3RXRmpz?=
 =?utf-8?B?eE5va0xQK1dtRkZzYUdWSERaZDd3ZHl3MXRDUVpvVEorSldlbG5lN0VvUzUw?=
 =?utf-8?B?WVIrUFBGTWxzc3VWUy9QWlNGTWhoMFozZWFWYSthVzhsa2tVVnhXOWtmYkEz?=
 =?utf-8?B?VEdYdHkzM0VucHEwWjdRa2l3NEFBa3RRd3I4enVpV2VndUp0TGNHalZnbjZT?=
 =?utf-8?B?c2VYejRFTi9zYmJ0UGlyL2ROWG9TQXFxVTdsWmRRL3Bkak9PWDQzR3V3a001?=
 =?utf-8?B?cEtpdUo5WFJ2RFJxTmJJeTIyc0RqU3JJdHV6VE1qTmJ1cUpFNnJXdDBGMmNE?=
 =?utf-8?B?RlJlWk4vbzk4MzVuMkJka0xyY0RxYUFzc3MvdXJCb1YzTWFQOXdUNDc5aVZR?=
 =?utf-8?B?ZEtxVEgxeEQyTllvdjJ6MGxHeW1KOXZSWEFVSjVkYkRBM0RoV0ZHWTVzM0Nw?=
 =?utf-8?B?Y0o4RjUvY0ZlREFEeU1Sa1FjTlcvOVJWaEFlNGs1dytHZ0JQamhxYVkxTStI?=
 =?utf-8?B?eUZsY1dlVC9yb2FTK3JsSGUxZ2dQQ29aY2NZY3Jra3pJWjI1M2FyTjZydlNP?=
 =?utf-8?Q?SJ8PEltfSq3wmK7qSqA/Ye9a2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d66c986-2799-4a77-deca-08de30e65f45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 14:31:53.7512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL0yl9WX/0f7OObLlSrOypCQlOW6RE6jMHg4s+g0tVm/JGrmVtxjsYkSX2bNZ9+TLafjD943QBUrIC5c18xTBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9114

On 11/21/25 02:06, Alexey Kardashevskiy wrote:
> The PSP advertises the SEV-TIO support via the FEATURE_INFO command
> advertised via SNP_PLATFORM_STATUS.
> 
> The BIOS advertises the SEV-TIO enablement via the IOMMU EFR2 register
> (added in an earlier patch).
> 
> Enable SEV-TIO during the SNP_INIT_EX call if both the PSP and the BIOS
> advertise support for it.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  include/linux/psp-sev.h      |  4 +++-
>  drivers/crypto/ccp/sev-dev.c | 10 +++++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 34a25209f909..c0c817ca3615 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -750,7 +750,8 @@ struct sev_data_snp_init_ex {
>  	u32 list_paddr_en:1;
>  	u32 rapl_dis:1;
>  	u32 ciphertext_hiding_en:1;
> -	u32 rsvd:28;
> +	u32 tio_en:1;
> +	u32 rsvd:27;
>  	u32 rsvd1;
>  	u64 list_paddr;
>  	u16 max_snp_asid;
> @@ -850,6 +851,7 @@ struct snp_feature_info {
>  } __packed;
>  
>  #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
> +#define SNP_SEV_TIO_SUPPORTED			BIT(1) /* EBX */
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9e0c16b36f9c..2f1c9614d359 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1358,6 +1358,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +static bool sev_tio_present(struct sev_device *sev)
> +{
> +	return (sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED) != 0;
> +}
> +
>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -1434,6 +1439,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> +		data.tio_en = sev_tio_present(sev) &&
> +			amd_iommu_sev_tio_supported();

Align amd_iommu_sev_tio_supported() with sev_tio_present() or just make
a single line. But...

I would move the IOMMU check into the sev_tio_present() function and
then rename sev_tio_present() to sev_tio_supported() unless
sev_tio_present() is going to be used more somewhere else?

Those can be follow-up patches, though, if this needs to get into 6.19.

Thanks,
Tom

>  		cmd = SEV_CMD_SNP_INIT_EX;
>  	} else {
>  		cmd = SEV_CMD_SNP_INIT;
> @@ -1471,7 +1478,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>  	sev->snp_initialized = true;
> -	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
> +	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
> +		data.tio_en ? "enabled" : "disabled");
>  
>  	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>  		 sev->api_minor, sev->build);

