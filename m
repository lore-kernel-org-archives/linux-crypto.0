Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA53932B9BC;
	Mon,  1 Dec 2025 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764602619; cv=fail; b=USXI3CwDsDQN/Qt+FyfXdkRqCTJ5g/t6cSohtHV67jot7Un7qXzKtkHJx/SL8l2ceL3L2X2ASClbnfzsmcPucV74D9quGhnLQGsy3R1YSLzYyRHO8uAVzblTtDKbvvcvVEIQGcOonrGY5LvEHQFlzLPMMHhEtFjsWxY+yIcI5fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764602619; c=relaxed/simple;
	bh=o9CC3j7ROTxSBdqSYmj9VWEJfz5uYxK+5/R7/l+0xJU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IiHKxWBefsHiFuoj/ychZzYrbs78abcDSMJ0mUpuGwpFE8L69oukBq96OZUlL+QAbCTZ22hsIIvWUwgbqWz1AHS5puxebAjxJrp2D2UNffpky+Og4Ze7S+o/Twmk5g6fTqijK1rzGpSPiBih/cLBZhwrQMblAJCHPRudjaQ4UNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vcCFxUEx; arc=fail smtp.client-ip=52.101.52.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vcCFxUEx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D373wxkZrrMnheTPHYZ6kSEGSey9bzgCvgHQXMGJrTmnCjJEaAiLeVOGzv37FLeXjeM11ewieZV30fOzgY2HLBP4dr794OdZJ+m0yMAuhr1dwa6zZauXV9LHLjR29EYGdCsm92OF0j6dA+JgYGwYGmBXryLMDt8gjofnFYt+U2LXgIaIcnY0LsaTix+HFj6K4GTh6BVhYu35ERGXKh1eMz2xlHqpfiuBCejTKKLel4DdMRwtlDqfws5k3jHau0IwvSOXunD7e2xb0rEt6zqAq6dbe1eQfDiX/OTvcw6GUix6yuOjOmhPab4A3K4sr775riHp1M7gUV0N9teKEmlfyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KlC/lANT6OIJp1j0TbLqHV9OYv/eB0gUAQNj0DxqmI=;
 b=aWYtyYAV4D3KpZL1e0cBeNT0bg9nE+53o3KVRI/vb5NQ2HWvrZMTwuPuL51ZQdhtmMCopT4tj7woK3+0I8YbG39mbEnD0p7FKrugqxyaF0lxnKh25N2CeZMHJDTkcblWs9EKKe4lgseo37NxOoiMWKmhAbomYerGU2fewgknIwVWPOCjYPF4SR4Q5LEmvNewg67hNwWC4OJIXb4U6jlI6/CnksI8XNmCfEIJNAH91UktWuCrBkzHi/0acWseYGxTQtSKL0fKRdrcM1RDni9GYtp1jvAX8gpf5UtW6n5Edb+f/4OaUjqTzdRyCOqmK8AsyZVNBApQWJ/18shwfC9Qzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KlC/lANT6OIJp1j0TbLqHV9OYv/eB0gUAQNj0DxqmI=;
 b=vcCFxUExbBxnNmugmvulSk+xylXblHuDrN2v7tTWAbWJmGw5WHIa/12hmS19tWys+U6ODkr8fbHbb6PelN2hHk128TAB6JjMnqSF7WGXhbXbOgAZFkFuH+2UKWcWkd5YW+86F+kxyWw5NtMXzttY/ISr5oVrtG07Tjep4E7BxaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB9347.namprd12.prod.outlook.com (2603:10b6:8:193::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 15:23:32 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 15:23:31 +0000
Message-ID: <fd5bdddc-fd22-4373-a8ff-3933c63cbacc@amd.com>
Date: Mon, 1 Dec 2025 09:23:17 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v2 5/5] crypto/ccp: Implement SEV-TIO PCIe IDE
 (phase1)
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
 <20251121080629.444992-6-aik@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251121080629.444992-6-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DSZP220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:5:280::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB9347:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ea93b6f-99ce-4802-78a8-08de30ed95e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDVTdDdudlRiYXpKT3RCbmFhOGp5OHp6MHpNVUxod2tKOUV1OGJtWXhGR1A5?=
 =?utf-8?B?SVVtREdtV3NMNUtKY1B0VVlzZzdVWEh2NldIRUYvZWdGWW05V1Y4WlBZL0Vt?=
 =?utf-8?B?eFEzU3dpRWRDaVdtYnd1SktHWDhZMXp4c2ZKQUE0Rk5CNVpIcXdVcmFnODln?=
 =?utf-8?B?akFHZ2NaZW5VVFFqR1ppdm5KTk9Xc3lUbEptZWZGL1lJeXJxamNxRWVZSFY2?=
 =?utf-8?B?ZU02Y1MwNmlPeEU0dk1UbjdGc1U2aHlmZ0w4Sk9BZEltSDVCYnd0cHNNdkg4?=
 =?utf-8?B?QmtHZ2w1cGVxR21rT0ZVR2QzQ216TDJkbVlNVnBRMWZlSGFISWFsYmZwaE5B?=
 =?utf-8?B?Z1NlKzBRbVlSOXZJdjd2eEVXak9jNmdzL0NjR29yeVY0MEpKRWxCdWMzd1lW?=
 =?utf-8?B?YUVEa0F1TUtqNTNXT2hzQi9LYnB3QUFVKzZ3dU45aXUxVE1tclFpUHdRcVJY?=
 =?utf-8?B?Y1Q3ZDV1ZlFVL2ZPY1ZVTzBZR1pBTEJIR3ZNMjc0eFZRZHF1bGtQSTgycU5M?=
 =?utf-8?B?clFPTEh1V0NtaGVpbnBJWnYwb1hVeGRibGFaSllvaWFvcTY3VkRCVVBOaHJj?=
 =?utf-8?B?aU03SlJpQWgrTkczMThYQmUydXRVdzV1QkErQ0YyRkExMGtsSkoyK3E5RndZ?=
 =?utf-8?B?NkEwTFQ0Z25ERzI5bWhmR2QxOFdvdkkxNkIrZXArYllha2FkZzJUVVhnYUFm?=
 =?utf-8?B?YllPNHQxMGttbUF1U1FPNzF0TTFZZFpvMjUzVVp3UW85SjRpZ1o1cWYrdTBW?=
 =?utf-8?B?Y0JWbDRlTTJRY2J2ZDc1ckFoZ2g1Q0E0V2d4cjNocCtGK2ZraDZGcklvZ0M5?=
 =?utf-8?B?RnhPZmp3RW5uazg3VDVqWHhCTFBkSzdSV2IvWmpsZU9lT3NFbHJObE01K0ZL?=
 =?utf-8?B?NEJRNlZDZkZKVGtSQ3lxL2c3d0JhT2wzN1A5Q2xZQ2h4ZmRMM3ZWeHh1VjdB?=
 =?utf-8?B?bm5qNjNhUWFvT3BFWTdRTVdsNnZmUUFQcHhIdHVuRk9aZk1PM0ZnVHQxNW9J?=
 =?utf-8?B?cWkvZDNFclhBdFdtRmowLy9JU0xnaTlXUGEwa3RzM01CV1o3cmQ3b1NYVHUv?=
 =?utf-8?B?Rm0xUFVGR2x0aHAzbTBFTFJML3dPZWxoVVZ4dXpENloxTWJBSHhpTzZCQnZE?=
 =?utf-8?B?MmpyS0d2VXJ4bHVtbndYOE52VGxhdE5ZQ2c1eTVraU9BU0QrbWpmYThjT0Vu?=
 =?utf-8?B?dFlDUjRMS0lhYklzMHVWK2FvQjNmVkJQVHJ3bnQ5aVk2OUczOHB4N3VtenA1?=
 =?utf-8?B?R3NtUHA3QUlrWHMzUmtxdmRUSkwyS1lqL2NmTEVZRFJ6WGswQzBSR3RlZisv?=
 =?utf-8?B?TzBxSzV6RkJGZks3VjArRWhIK3JIL1hXSGpUTGpPWndZRzZtd056dDZEcjUr?=
 =?utf-8?B?SWt1SlcyWFRsaGVuMmtiWmJsNGYxRmV6cGNnSE02KzFrejFweDRha0sxQUxP?=
 =?utf-8?B?bkk0VktGZ3hTcTFxM3lQcFk5Uy9HWjZLWThTUkQ5UlBTcG5TbWt5bXdJMHJF?=
 =?utf-8?B?MGJVVzVEb2FnUjJrcS9pR1MrOWY4bnVLOW9KY0VMOXI2dDBHTzBIcFZQUzcr?=
 =?utf-8?B?Ym1ZZDN6eXBIa2Vhck1WZ1lPNW1IaDlTdnYxRlQ3bHpIRElkV1o3TTlQc2NK?=
 =?utf-8?B?WXdYaVVZdzBWRS9tZVYyK2xxY3ZUY3I4TVNXcW9hQlpEYjRMSFNkbnk0WDRw?=
 =?utf-8?B?ZFVUZm0zSHFEQlY5ZnNtYXVUaE16L1FHZGluUjBENjFaUy9kQXV1WWZ1dERB?=
 =?utf-8?B?Z1c4b0J5ckNBaGpONEhzVThPcGdVTllUTnhHNHVEN3VoWDA2NkxSYTRTVS9z?=
 =?utf-8?B?OW5MUjEyZU42R0NwVjdQQWJMeDdnY3FrQXRtMW5xWis4RExWUEFVUFF3dU8x?=
 =?utf-8?B?Y3hUUjFVcVMyQVdaZE0vRy8vZVdSem5jaGI1YkRmTnhDVmRna1JmbkJkU1lQ?=
 =?utf-8?Q?RIoy9lSZGppxXvcm71AVsng06hL8mPJU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGw2WitjSWtJdUZaSlhqRndIa3AwanJIaXB6REtvMXRoeGpzT3BrclRVMVF4?=
 =?utf-8?B?eWdibkJna1loQ1pyT3ZjeTlGZWNPcWpTeTJ0bGV5RG9TbjNxL3dwMDBJWXFz?=
 =?utf-8?B?SnN5OGNGNEZrODBvaDhTN2ZRRW9UTUh4Nnk0M1hVc3hWTWV1ZDFFdlVqc3kx?=
 =?utf-8?B?RkpPTmJVeGwyZUEzSWFPMjBna3JIOUhqREhwaEk2ckpITE5Sa2xRaDZMbGlM?=
 =?utf-8?B?OEVtZC9LQitYK0I0NjlsVVpzcW5HazM5aDNxRHlTWnBCdkFlZ2hMVjBwK0oz?=
 =?utf-8?B?T3p5eWkzYmowM3ViaDJGNWVZNjhmZWxLejRrRFFkV0dmaFBhRm1vYXNMenNG?=
 =?utf-8?B?bENKYUpzeGZsWG1DbTJ3N2xKaEozd2RiUkRDa0J2VHdzallDNWRqWkVtcWJT?=
 =?utf-8?B?cFp6bUl4cFY3L1AzckFPUE5uMjdxMVVrNWtwK1NPeWNIenZTZy9LUzVISitn?=
 =?utf-8?B?eGFlK0g2WHNBNHVYVi9CZlRTNVN6SzNiUElMV3B1WENmNkJEOTJWbmk5TWgw?=
 =?utf-8?B?akFKelFObGJYcXEvYlBrZ0dicWhSRXMvNlh4ME1RMDRvRURRTmkxTkNpWWsw?=
 =?utf-8?B?RlBWZjFMVkt1anhvbG9LMWNzVi9jb1BsTC9pcnBvRC9yVzlyUGRQN1VqRWdF?=
 =?utf-8?B?TDMrQkhtQjhJNi8wTThSWHJVMGxEWjYvK0w5VndtRmJSTDF3anpWQWMwYzg2?=
 =?utf-8?B?S0tQUG02TkpCOHFZa0U2MjV3dFBqZzFwZzB3VHhDdmJFMFVJbWhNZmdOYmlO?=
 =?utf-8?B?RVFmMGErdnVCdVpubkxNK2N1QjIyOHdBcjhHODNVZUswZlozMXB0Qlo1b2xX?=
 =?utf-8?B?THJHTHhaWFNSR29JL3ZGSjdPTUpERHFjeFl1cUQvaXltOXhVZFZMUkQrbDFi?=
 =?utf-8?B?RFNwOFplQVRacEhKNDZFSkF3MFZSYzdxbFZSV2IyQlFWQm1kY0FoNDV1WkJG?=
 =?utf-8?B?eXVyeVZvL0NYRG5ZRFAzdnZsakVLZnY3K2FCOWFFVG9MTHF3Sk1NMnZLWVl5?=
 =?utf-8?B?UHg3TmV6SW5RV014YXFxQms1L1Q3b2dGNkV0TTdhVVJWNWRmQ2lDdHhONVkz?=
 =?utf-8?B?L0ROZnhxWURJRTBwZDdNM3MwSEpDQmxmS3FrZzE2VXRMNFlpQjgyRzVjOHJ6?=
 =?utf-8?B?VlgxTWRTS3FuVlUrQ0JENGVxQnQvNEs2TzUvc1ZwVDRSSVJGRkhxcUJjbnpE?=
 =?utf-8?B?YTk4RHdVQyt6SWpwUkU3QzN1UVJ1QW92ZDY5eVFBT0RqUXZLVXowSWF4dUg0?=
 =?utf-8?B?clBzanZiMEwyNlh3dmJLRlNzOWFQaTg0NHRRNThlTWVLY0dDY2pWc2Z0ZWM5?=
 =?utf-8?B?ckJIY0txUmJxVEdBOTVncGI3YUF1UUk0UkVzbDlBSHZsd0pQSWN5bEZVQU50?=
 =?utf-8?B?Z3dGMGYybzFQVmtEV0pUVUI0M2ZrcHUvUnNWTFAxcTJpZzJyQlVFVWt6Sm1J?=
 =?utf-8?B?czh3UXkxRnhVN296aEhiZkd5c1RSRm1GV09qRlZLdkd1NVVXN2ZVeEFFMGFC?=
 =?utf-8?B?eld0cFZQb2J4UmVaU0pJVnh6UTMzcUM5UzN6QUcrM3FkYkFiSGdZMUx3WlVi?=
 =?utf-8?B?bkhaZXhoaEtLYnVlRS9kZEZoWU16eHFIcDF1bXNzaUZURmY1Vm9WaG01dDBE?=
 =?utf-8?B?a2svYzM2bEJ0NzNuVGFkeTdlR1hqWUVQbjZpWnVCZlRkNWMrbVdVVk9RY3Vp?=
 =?utf-8?B?b3lNdmRBWmtXT3R2aGdhS3ZEeEhvOXQ0RU9kVmw0YlpqUFNnTzMralZockVj?=
 =?utf-8?B?YVRodVcwQWV3UEw3Q3BZdDhQdFNzT3BPS3U4WkJXK3hVQ0RUbll6bjd6VEEy?=
 =?utf-8?B?dzJ0YzhJbVdFSVl2RmNOZVBJb3NpYkw1Wlp3dGFSK1FPMnFJY282aEZPYXFs?=
 =?utf-8?B?OVJZMXJSaFhjanh2WUxKa2RCQzVsbXZHclNDb0NQaVRkeGhYeUxYMHFFNTRZ?=
 =?utf-8?B?L1owTFQ2cjZuaEZrNFc3SUtoU2pVV0JDQkoxZ3NDMldGMnhuVlMvc1ZCV2xX?=
 =?utf-8?B?Z0x4TGFFdFlXRXBTbkRXTEdDa2p6dUliUkgzQ0pLQVpuZHVGT0hZQnEwZERj?=
 =?utf-8?B?MTY5dUpDMG96Qk9PTlJpWU8xYmQzdTIzMnpyd1JGUUZhclJIbHhBc2hzRHcv?=
 =?utf-8?Q?mH3DS1YjgcxAl3MbECd5aq2ha?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea93b6f-99ce-4802-78a8-08de30ed95e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 15:23:31.6163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: It0HbDAkFYibpP5XM1ii1emGr5BJ6pjtR/XKlKzcqNVwGlyNJrI1ba8zUzxdkc/wIqqrwr7Kt1OzdjFNsd+L5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9347

On 11/21/25 02:06, Alexey Kardashevskiy wrote:
> Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
> (Trust Domain In-Socket Protocol). This enables secure communication
> between trusted domains and PCIe devices through the PSP (Platform
> Security Processor).
> 
> The implementation includes:
> - Device Security Manager (DSM) operations for establishing secure links
> - SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
> - IDE (Integrity Data Encryption) stream management for secure PCIe
> 
> This module bridges the SEV firmware stack with the generic PCIe TSM
> framework.
> 
> This is phase1 as described in Documentation/driver-api/pci/tsm.rst.
> 
> On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
> The CCP driver provides the interface to it and registers in the TSM
> subsystem.
> 
> Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
> the data in the SEV-TIO-specific structs.
> 
> Implement TSM hooks and IDE setup in sev-dev-tsm.c.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> Changes:
> v2:
> * address bunch of comments from v1 (almost all)
> ---
>  drivers/crypto/ccp/Kconfig       |   1 +
>  drivers/crypto/ccp/Makefile      |   8 +
>  drivers/crypto/ccp/sev-dev-tio.h | 142 ++++
>  drivers/crypto/ccp/sev-dev.h     |   7 +
>  include/linux/psp-sev.h          |   7 +
>  drivers/crypto/ccp/sev-dev-tio.c | 863 ++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
>  drivers/crypto/ccp/sev-dev.c     |  48 +-
>  8 files changed, 1480 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index f394e45e11ab..3e737d3e21c8 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -25,6 +25,7 @@ config CRYPTO_DEV_CCP_CRYPTO
>  	default m
>  	depends on CRYPTO_DEV_CCP_DD
>  	depends on CRYPTO_DEV_SP_CCP
> +	select PCI_TSM

This shouldn't be here. This is CCP related, not SEV related. This
should be moved under CRYPTO_DEV_SP_PSP.

>  	select CRYPTO_HASH
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_AUTHENC
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index a9626b30044a..839df68b70ff 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -16,6 +16,14 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                     hsti.o \
>                                     sfs.o
>  
> +ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),yy)
> +ccp-y += sev-dev-tsm.o sev-dev-tio.o
> +endif
> +
> +ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),my)
> +ccp-m += sev-dev-tsm.o sev-dev-tio.o
> +endif
> +

Would it be clearer / cleaner to do:

ifeq ($(CONFIG_PCI_TSM),y)
ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += sev-dev-tsm.o sev-dev-tio.o
endif

>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
>  		   ccp-crypto-aes.o \
> diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
> new file mode 100644
> index 000000000000..7c42351210ef
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tio.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __PSP_SEV_TIO_H__
> +#define __PSP_SEV_TIO_H__
> +
> +#include <linux/pci-tsm.h>
> +#include <linux/tsm.h>
> +#include <linux/pci-ide.h>
> +#include <uapi/linux/psp-sev.h>
> +
> +#if defined(CONFIG_CRYPTO_DEV_SP_PSP)

Since the TSM related files are included based on CONFIG_PCI_TSM,
shouldn't this use CONFIG_PCI_TSM?> +
> +struct sla_addr_t {
> +	union {
> +		u64 sla;
> +		struct {
> +			u64 page_type:1;
> +			u64 page_size:1;
> +			u64 reserved1:10;
> +			u64 pfn:40;
> +			u64 reserved2:12;

	u64 page_type	:1,
	    page_size	:1,
	    reserved1	:10,
	    pfn		:40,
	    reserved2	:12;

This makes it easier to understand. Please do this everywhere you define
bitfields.

> +		};
> +	};
> +} __packed;
> +
> +#define SEV_TIO_MAX_COMMAND_LENGTH	128
> +
> +/* SPDM control structure for DOE */
> +struct tsm_spdm {
> +	unsigned long req_len;
> +	void *req;
> +	unsigned long rsp_len;
> +	void *rsp;
> +};
> +
> +/* Describes TIO device */
> +struct tsm_dsm_tio {
> +	u8 cert_slot;
> +	struct sla_addr_t dev_ctx;
> +	struct sla_addr_t req;
> +	struct sla_addr_t resp;
> +	struct sla_addr_t scratch;
> +	struct sla_addr_t output;
> +	size_t output_len;
> +	size_t scratch_len;
> +	struct tsm_spdm spdm;
> +	struct sla_buffer_hdr *reqbuf; /* vmap'ed @req for DOE */
> +	struct sla_buffer_hdr *respbuf; /* vmap'ed @resp for DOE */
> +
> +	int cmd;
> +	int psp_ret;
> +	u8 cmd_data[SEV_TIO_MAX_COMMAND_LENGTH];
> +	void *data_pg; /* Data page for DEV_STATUS/TDI_STATUS/TDI_INFO/ASID_FENCE */
> +
> +#define TIO_IDE_MAX_TC	8
> +	struct pci_ide *ide[TIO_IDE_MAX_TC];
> +};
> +
> +/* Describes TSM structure for PF0 pointed by pci_dev->tsm */
> +struct tio_dsm {
> +	struct pci_tsm_pf0 tsm;
> +	struct tsm_dsm_tio data;
> +	struct sev_device *sev;
> +};
> +
> +/* Data object IDs */
> +#define SPDM_DOBJ_ID_NONE		0
> +#define SPDM_DOBJ_ID_REQ		1
> +#define SPDM_DOBJ_ID_RESP		2
> +
> +struct spdm_dobj_hdr {
> +	u32 id;     /* Data object type identifier */
> +	u32 length; /* Length of the data object, INCLUDING THIS HEADER */
> +	union {
> +		u16 ver; /* Version of the data object structure */
> +		struct {
> +			u8 minor;
> +			u8 major;
> +		} version;
> +	};
> +} __packed;
> +
> +/**
> + * struct sev_tio_status - TIO_STATUS command's info_paddr buffer
> + *
> + * @length: Length of this structure in bytes
> + * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
> + * @tio_init_done: Indicates TIO_INIT has been invoked
> + * @spdm_req_size_min: Minimum SPDM request buffer size in bytes
> + * @spdm_req_size_max: Maximum SPDM request buffer size in bytes
> + * @spdm_scratch_size_min: Minimum SPDM scratch buffer size in bytes
> + * @spdm_scratch_size_max: Maximum SPDM scratch buffer size in bytes
> + * @spdm_out_size_min: Minimum SPDM output buffer size in bytes
> + * @spdm_out_size_max: Maximum for the SPDM output buffer size in bytes
> + * @spdm_rsp_size_min: Minimum SPDM response buffer size in bytes
> + * @spdm_rsp_size_max: Maximum SPDM response buffer size in bytes
> + * @devctx_size: Size of a device context buffer in bytes
> + * @tdictx_size: Size of a TDI context buffer in bytes
> + * @tio_crypto_alg: TIO crypto algorithms supported
> + */
> +struct sev_tio_status {
> +	u32 length;
> +	union {
> +		u32 flags;
> +		struct {
> +			u32 tio_en:1;
> +			u32 tio_init_done:1;
> +		};
> +	};
> +	u32 spdm_req_size_min;
> +	u32 spdm_req_size_max;
> +	u32 spdm_scratch_size_min;
> +	u32 spdm_scratch_size_max;
> +	u32 spdm_out_size_min;
> +	u32 spdm_out_size_max;
> +	u32 spdm_rsp_size_min;
> +	u32 spdm_rsp_size_max;
> +	u32 devctx_size;
> +	u32 tdictx_size;
> +	u32 tio_crypto_alg;
> +	u8 reserved[12];
> +} __packed;
> +
> +int sev_tio_init_locked(void *tio_status_page);
> +int sev_tio_continue(struct tsm_dsm_tio *dev_data);
> +
> +int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id, u16 root_port_id,
> +		       u8 segment_id);
> +int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8 cert_slot);
> +int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force);
> +int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data);
> +
> +#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
> +
> +#if defined(CONFIG_PCI_TSM)
> +void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
> +void sev_tsm_uninit(struct sev_device *sev);
> +int sev_tio_cmd_buffer_len(int cmd);
> +#else
> +static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
> +#endif
> +
> +#endif	/* __PSP_SEV_TIO_H__ */
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index b9029506383f..dced4a8e9f01 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -34,6 +34,8 @@ struct sev_misc_dev {
>  	struct miscdevice misc;
>  };
>  
> +struct sev_tio_status;
> +
>  struct sev_device {
>  	struct device *dev;
>  	struct psp_device *psp;
> @@ -61,6 +63,11 @@ struct sev_device {
>  
>  	struct sev_user_data_snp_status snp_plat_status;
>  	struct snp_feature_info snp_feat_info_0;
> +
> +#if defined(CONFIG_PCI_TSM)
> +	struct tsm_dev *tsmdev;
> +	struct sev_tio_status *tio_status;
> +#endif

Do you need the #if here? Can this just be part of the sev_device struct
and just always NULL if CONFIG_PCI_TSM isn't set?

Is "struct tsm_dev" not defined if CONFIG_PCI_TSM isn't 'y'? I would
think it would be simpler for all to have that defined no matter what.
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index c0c817ca3615..cce864dbf281 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -109,6 +109,13 @@ enum sev_cmd {
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>  	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
> +	/* SEV-TIO commands */
> +	SEV_CMD_TIO_STATUS		= 0x0D0,
> +	SEV_CMD_TIO_INIT		= 0x0D1,
> +	SEV_CMD_TIO_DEV_CREATE		= 0x0D2,
> +	SEV_CMD_TIO_DEV_RECLAIM		= 0x0D3,
> +	SEV_CMD_TIO_DEV_CONNECT		= 0x0D4,
> +	SEV_CMD_TIO_DEV_DISCONNECT	= 0x0D5,
>  	SEV_CMD_MAX,
>  };
>  
> diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
> new file mode 100644
> index 000000000000..f7b2a515aae7
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tio.c

...

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2f1c9614d359..365867f381e9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -38,6 +38,7 @@
>  
>  #include "psp-dev.h"
>  #include "sev-dev.h"
> +#include "sev-dev-tio.h"
>  
>  #define DEVICE_NAME		"sev"
>  #define SEV_FW_FILE		"amd/sev.fw"
> @@ -75,6 +76,12 @@ static bool psp_init_on_probe = true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>  
> +#if defined(CONFIG_PCI_TSM)

Not sure the module parameter should be hidden in this case. But if you
do want it hidden, why not move the #if down one line so that
sev_tio_enabled is always defined. And then...

> +static bool sev_tio_enabled = true;

static bool sev_tio_enabled = IS_ENABLED(CONFIG_PCI_TSM)

will give the proper default.
> +module_param_named(tio, sev_tio_enabled, bool, 0444);
> +MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
> +#endif
> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -251,7 +258,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> -	default:				return 0;
> +	default:				return sev_tio_cmd_buffer_len(cmd);
>  	}
>  
>  	return 0;
> @@ -1439,8 +1446,14 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> +
> +#if defined(CONFIG_PCI_TSM)
>  		data.tio_en = sev_tio_present(sev) &&
> +			sev_tio_enabled && psp_init_on_probe &&

Why add the psp_init_on_probe check here? Why is it not compatible?
psp_init_on_probe is for SEV and SEV-ES, not SNP.

Instead of the #if, please use IS_ENABLED(CONFIG_PCI_TSM) so that the
#ifdefs can be eliminated from the code.

Having all these checks in sev_tio_supported() (comment from earlier
patch) will simplify things.
>  			amd_iommu_sev_tio_supported();
> +		if (sev_tio_present(sev) && !psp_init_on_probe)
> +			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
> +#endif
>  		cmd = SEV_CMD_SNP_INIT_EX;
>  	} else {
>  		cmd = SEV_CMD_SNP_INIT;
> @@ -1487,6 +1500,24 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  	atomic_notifier_chain_register(&panic_notifier_list,
>  				       &snp_panic_notifier);
>  
> +#if defined(CONFIG_PCI_TSM)

Does this have to be here? If the functions are properly #ifdef'd in the
header file, then you won't have a compile issue and tio_en would only
be set if CONFIG_PCI_TSM is y.

> +	if (data.tio_en) {
> +		/*
> +		 * This executes with the sev_cmd_mutex held so down the stack
> +		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
> +		 * unlikely) but will cause a deadlock.
> +		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
> +		 * for this one call here.
> +		 */
> +		void *tio_status = page_address(__snp_alloc_firmware_pages(
> +			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
> +
> +		if (tio_status) {
> +			sev_tsm_init_locked(sev, tio_status);
> +			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
> +		}
> +	}
> +#endif

Add a blank line here.

>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
>  	return 0;
> @@ -2766,7 +2797,22 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  
>  static void sev_firmware_shutdown(struct sev_device *sev)
>  {
> +#if defined(CONFIG_PCI_TSM)

Ditto on the #if here. Shouldn't the function be properly ifdef'd in the
header file which would not require this?

> +	/*
> +	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
> +	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
> +	 */
> +	if (sev->tio_status)
> +		sev_tsm_uninit(sev);

Should this be part of __sev_firmware_shutdown() or
__sev_snp_shutdown_locked()?

> +#endif
> +
>  	mutex_lock(&sev_cmd_mutex);
> +
> +#if defined(CONFIG_PCI_TSM)

Ditto here. Without CONFIG_PCI_TSM, sev->tio_status will be NULL
already, so kfree() will just return.

> +	kfree(sev->tio_status);
> +	sev->tio_status = NULL;

Wouldn't it be safer to do this after the call to
__sev_firmware_shutdown() in case that function some day needs to use
that structure?

Thanks,
Tom

> +#endif
> +
>  	__sev_firmware_shutdown(sev, false);
>  	mutex_unlock(&sev_cmd_mutex);
>  }

