Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012063.outbound.protection.outlook.com [52.101.43.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266A032D0F9;
	Wed,  7 Jan 2026 14:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767794803; cv=fail; b=R21E+HG6LaCuEhCS4xhSEZNY6djZcg4U295GUXvWst61qNX4791xEV/ogIJNVWquG85Kk04qmk3Jio+ZbyXxZGVi3K9tkIfj7Gl5ap22yqvISNbMzYaPUGL20WverMW7vEmfGuiRmiAuD904tXbn1B0Ukli5s5N6BJuGPF0Cwtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767794803; c=relaxed/simple;
	bh=8t5p4akoRXfeYkJBbkA6BamGHDBTfCSwqrKfKNCimcM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PRCTRtKfIQp1V+rPOAqac5JHLCXjAv/hppET7uYDk79A0tmpgiE83nzvmFf1A73QWnlBjAWZEHDB/kj+8zApPfe5B9YVnH55/9+ykrhlZ/DYlrIsGezEO13y2AxMKQ7x3UW7vH0q4dW2Ds1GogWZSTXvXk3kqgktHAdGQAW/VXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2+4R1Lo7; arc=fail smtp.client-ip=52.101.43.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2+4R1Lo7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DDiEtE2ZWWgskD+1mO5Zneg4UrigBq6eJ2zGPZ4BdBsDzULFwUq/Gb6cBAOqKnJRha9SKDJpnyCNzTmg68XN4rqnPOaHgkhM71wZ8pXaxhkVpQmqjwiDcbzpWaQOyNqVEgJWwMBEijTD3kPI8pXeoss5xYQc2pg+UeNkpQBT4iCkaiUPYm4Jf9DP3yOa9apJi0wwfKjjjBLjbJnRZXZAmL+tZOq0lJHOToLJIN9ODqvKFFx4jLY6D8wiFinp4qCFd3hhlqua39YCIQ967DERuXsRU94zIDUm48fbwfXNDUeeicDDgId8PotJCrr8A51E65lcwG9rtVg8wNMUgKSpgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTNRxGqXlUQZ7hEFglg00BvHx6aMdQiW8ZeE4yMHazg=;
 b=Q8XWaLxcBz6XkjPuWUkV0MBoRoImWqqF0R9RlzZP8xfxFaleLzLlxkZwxaYSjwjrRWD9PW+Scw3ONAb1mKUAVaoifsPrlKZE5vdqbwTmrCT5lWlYiM3VLjelGi6hWUtbBmSYB3JP96Vdo3I50B0JZQLd2FM6oGsvUzmmWIxib2OW1Zw3cgx0R2SXimsnt8dx7hDPadwLZq+iHS1X2xNVqQeA9vbmB4vVQH89aABfRzWn38hvmWJSRN5N0I8pIMUFFrMjOnJDDiQl9rUkuQW/xodh0IDXPDENsaYTW0Q78+TB8Lwoz9d7dOP5qEjC6rNRI21qA8fPzuYYfpF5Pn6A6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTNRxGqXlUQZ7hEFglg00BvHx6aMdQiW8ZeE4yMHazg=;
 b=2+4R1Lo7BBkjXZ7DrTFK2Q4+Uyv/WZgXj502vrf4/x8XvbRiVtzhcyPLJ5KiA0QH/lWWpDxSbgNziAnyUh1PGDmQY4lL3gjMuAXFT7eaG9t0dOdymmfTSHHtNfuKC1GtrxjzNtT6CHpC9PYQr9OQkQMNAOt8PYEvr6RvPz6PNKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB7645.namprd12.prod.outlook.com (2603:10b6:8:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 14:06:25 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 14:06:24 +0000
Message-ID: <889a3e2d-f720-435e-93d1-d0fb7a89d18a@amd.com>
Date: Wed, 7 Jan 2026 08:06:22 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] Fixes for PMF and CCP drivers after S4
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
References: <20260106045423.55190-1-superm1@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260106045423.55190-1-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB7645:EE_
X-MS-Office365-Filtering-Correlation-Id: 7050ddd5-6e9c-4f18-d46c-08de4df5f15c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk4zbG51cUN5TkE4Zjl3MjJsNGtERElNRGs1YzgxWGZTdTVMWUV6YnYvdk82?=
 =?utf-8?B?U0JpTWpnQ0wrUEFsVm1Ybjk3N1pveTBlVDRCanFyaTVtazB0NnNodGVwbnhi?=
 =?utf-8?B?S3J4R0s5SXpMbEV6UDFkaDJxSlM5Y1hpdVlRVEMvRzlQbm1xYmZ6aGl1cjNy?=
 =?utf-8?B?eitncmQwejJuUjBaZE5Ya0piM1NtRzVtV3FCTjg0dEJmR0l4SGZWZEN1bkNV?=
 =?utf-8?B?eVpZKzBXUEtiY1V5eDBJbkRQOFU0bk55OHpLOWdZR2pGSWcvc0JBWkRFU2Zn?=
 =?utf-8?B?YjVWM1lRRkJWOHpYVk9QeWF1ekQzNE1mOGUrYUsyMlpRWGtHUUNOaXQ3eTdX?=
 =?utf-8?B?bFpDOFBjaHNFWHhIWUhvRnhmMHdDMC91UW9INkEvMFdhNVg5RER0Zk5zZ21q?=
 =?utf-8?B?K2t3VHBSM0JYTVpoOUNyS2RTRnBqZ1pKeFpQZCtRNGYxRjZiZjJWSGZOMmQ2?=
 =?utf-8?B?QVBLdFVnd1ArL1dCRFBRV1h0Nkxvcmt4bS8zQXF2MWQwMFQ3WlpDVVBrVTZ4?=
 =?utf-8?B?UjNPYVhsVlMzOXo3ZjNGZXBYWmErNEpqc0lCeEE0OGR3VmZiUGp5ZjY4Q0p3?=
 =?utf-8?B?MENvKzhDWm9Kby9oMVNWb1dKQVpGNjZ6UVNKMndNVCtHU1p4KzN6OUlBMnlM?=
 =?utf-8?B?cUpEMDd0UXhUaVpsalgrNnlRQWlWa1BBNTllNHJHT1E0WmxieTFoZEl6bjJW?=
 =?utf-8?B?S3ZOU1RjTmtiNGR1aHFma1VoNkxId0dDZmlTdUEyVE8zenhmTjEzYW8wQTZO?=
 =?utf-8?B?V0pFZUZSUWRXM01CWWdpQi91YnJLaDVkcWcvZjVUZVl2a25talVOcEYxaTNF?=
 =?utf-8?B?Zk9tQkloOXpvSHdxaWxPZlUrZkJFVitxa1l4TU9ZNi9odDFWZWhrcGpaQ1h1?=
 =?utf-8?B?U1BEbW43ZHBBVjhxclU1M1haRGN5S2tENzdhZG12MUhBN05UMm5HTTcxQlZS?=
 =?utf-8?B?VVhqVnNrUEpuT3dBMEdxb2dLazhORHQ2dHRvTXczclI1QkJManhQVmhGYUdR?=
 =?utf-8?B?a2ZJMTA0K0lvSGp5cnFRd3RTMUU5dHc5Z2haaGhRV1l4TndHNnEyQXY5eHl4?=
 =?utf-8?B?TGRmK0h4UjBJdDZSUmZFWFJocVh0ZTQ4aEF3eFpxYkkwVjVTbDRWRUhPb0hG?=
 =?utf-8?B?S0xJOVZjV2VsbG9xc3JyRnJIOS85am00ZVVVaGhoQ0pNUHRjT1pVTjcwWG0r?=
 =?utf-8?B?c2dZRERVWFdOVHZYZ1RUNHdIb1lKSXNFeWxzTjhTZ2hicHNtbyt0K0RoTmtC?=
 =?utf-8?B?ckE1Q2UwaWJ4UXNrWkxzQXoySWVPenVCYXJ6ZS9JTVVVcXZrZUk1Nm1TRnp3?=
 =?utf-8?B?RzVReVFMckh6WitvK1R6K3NtSmpHS1FTQ1UxVWJPUUhnYkVDV21qNGJtZWZs?=
 =?utf-8?B?N1V4alRDYnlpaG8yc2hIdVpkbGM4cElnNHZQbnU2YUZieWs3c0VOZVM4aEtM?=
 =?utf-8?B?czFjZDZMcG1pV1h4N3dpd3ZGcExSRzBQUnJ4M0pqdTdsdFhxNUpSSHlLNlJj?=
 =?utf-8?B?TkRzOEFKU1ZoL01xeDFUMnVaVGhyOG5nZ0JDaEJldFFIMTJQZ2lVaVJaYXZ3?=
 =?utf-8?B?Um9ObVdsVmxCa05DQjRwWWdxTDRsSVBERG9CMUJWOHZtRDl0SGVjU0g4Ums5?=
 =?utf-8?B?UFpaRXBMUTFVM1ZRUVAzQ0dXeHUwbi9qSXUyazdnL1ZMQWluN00vVlBpUGRW?=
 =?utf-8?B?dGZQT0RRa1Y4Yjc2MUlrYzRGcFY2cFh2YVBpcVJjT096NDFRSXVuVTBXOVlP?=
 =?utf-8?B?NlFnMW5GTEdoZ2t5ZjByZXlBSm4rVmltYjVUL3hUQ0xUWGcxWGM2SDZ4NHhy?=
 =?utf-8?B?eDBLeHhBWG5XR0lUai9Na1ZhUkVJRmdCOWxTZEFlUDVjM1JBSnRvM3NHOHd1?=
 =?utf-8?B?aWk5MzZ0cktHZVJUa2RHMFlOTzQxaW5vWnJvMjdpUUVrMzljOW11Q21Ndm1P?=
 =?utf-8?Q?SSjCKqd6yJpOu2Ip4bukK/CozwcdYfRu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGFQR1ZSL0Q4bkxMVDF3ZUIrQ2FKQ1lPTzlVNlBqWWxvaWNWOHJlZnNleWZ1?=
 =?utf-8?B?QmhJUC9wNkRUS1R3VDQ4dVhOaVhNRXUrSUdOYnhqbWNSYUNkWmpxVCt2ODkz?=
 =?utf-8?B?TkNUZ3FqQlVPNyttRHJuSVJud1kzNklnRkNJZitJaGdqdWN4T29oL01pN2VP?=
 =?utf-8?B?aXlHSUtUUitaSUdNVmlHMHN4dXhsK0VhYnRKeE1vYzg3KzBlSC8zK3VEL0Jj?=
 =?utf-8?B?SXdEekNSWW9mU2RaK3VjNXE0K2VZRisvRDExbDdabElzVGE1NklSMUVaODVl?=
 =?utf-8?B?UXFsRWRnTlI1TlA1MXhwUXY0RHdiY0hMWm1oUEtOMEVMbVZVRTQvL01UVS9S?=
 =?utf-8?B?anJRR0UyZzN3VTg4WnQ2TWx5QkN5VE43YS8veWF2KzJKQUNYQm11emthVnVl?=
 =?utf-8?B?a2lINkxpSW8razFPZWw3VUNyVldTRkloSUtNcGgzejIyWnUreUxJWHlHdTMx?=
 =?utf-8?B?RjBUMnM3MkhyRjhzVFBERTFvM2NqMGx5UHlvT2R1RlZoWkNoR1BPU3FkZ0po?=
 =?utf-8?B?eTFLYnF0U0NmKzNrbFJCcTUvcWplQWxnVGJZdUdPWnkrOUg4cnc4N0l1VTBE?=
 =?utf-8?B?cEFRMU1UWFUzcTducmRvemhrYkJSeWNTM01TZzJ6c1B3OFR5NjBka0NhdlE0?=
 =?utf-8?B?WkRBY0tkWWF6YmZDSzNqV1lVNlhTbURrMHVaZWRGNTY1c0UycmhRckdESEk2?=
 =?utf-8?B?emtLb3BlNFdBRXlRYXA1bC8rbUtPbURHM0V5cTFpb3NRSjNsK2JmS2VUaWpU?=
 =?utf-8?B?Nzk5VVBUb2wyKytqalhFUUY4S0luT3pEM205b2RSVmtzbEttVGdVU3Bub1ky?=
 =?utf-8?B?MTlnZk5sY3lGVWJpbHdwcDZaWk9CTjFFQm5laEpKM3BnZncyM05MckVEek9Y?=
 =?utf-8?B?bklCSG9VdzlzMzdYVGVuc3JHa2NKMXdGTWhvMjBGWkVZUEhsZnZrN3IybWY2?=
 =?utf-8?B?NzFvcWpGQm96bDB1L0t6eC8wb0FKb2tnNUoxMzZPaFZROGQ2L1UyNGltZldp?=
 =?utf-8?B?anFwUUR1bzBUcWV6aDlobllOdElZcVhmM0o3dlJZWElMMWdmb3RTc1lyY3Jl?=
 =?utf-8?B?MHNiR2hDVmYyOXV0aEh3Q1lTTFc0alRxWUw5d3V1Z1lEY2pCdU9yV3NkMmJu?=
 =?utf-8?B?STMyTXpaakVTWC9NTUV0ZEpoYU9XVUx6YkEzTkFOQW5YemVxUHo0TC8yT3pB?=
 =?utf-8?B?NEdKRmgvaVhOSUdTVkt1cjJQMlI3ZlVMQU1BclNFUUFXNjc0ZFhjeE0yZ1pJ?=
 =?utf-8?B?clVwZURUb3A2NTFvRFh4VTRyQW5XdldjajI2eXBIYXpEVThsN3dxSzZ2K1I1?=
 =?utf-8?B?S1R0TEVCY1RtazllZE41dkxxZE5ZQWdaVk5pQzJqNEZLV1R6a2h1NEdsUk9u?=
 =?utf-8?B?R0xvaFhOT08zSmVpa2x6RVExaURUQVV1MGRLNm93YThTd1NHVjVmaDAwc0FK?=
 =?utf-8?B?RW1rT3ozS2QrVWlkckNYMGVRWTVlRTd4Nkh1TWh2ZFNDTjU5MmJvcEhxV3A2?=
 =?utf-8?B?d0wzeVVRK0xQRjZYRi9JTTkxaGxTV3A2QzUyZ0ZadWdjVjVZako4ZjdEV3FP?=
 =?utf-8?B?T2VUTjd3MVVGeHE0Vi85NVdwcXJTcFpQanRwUDVkcDNtYUZUNjRKdTF2ZnRP?=
 =?utf-8?B?bkMyUWNPYlhZeWhOZmp1eklzaHZVNXJ1OC9ENTRseVE3U2xVZE9mZDMwK3NS?=
 =?utf-8?B?Sk9yY1RtSy9TTEtKcmxlSWttdVM2bWFGU3Nnak9mTDZXVnRtZElCUGhnQ2Q2?=
 =?utf-8?B?VkJDVlR0aXZzeEtJSXRPd3BXeVdIRmtrekVNaTBkMjB1eXJaOG1IVkdwb3hY?=
 =?utf-8?B?MkhUWEFTOHVDbHlBVkEzNWxHK2tlVERlTTRHOVpHYzNuQXNwaG9MS2NiMENm?=
 =?utf-8?B?QTRVK2FZcmdxdklqT1ZESmFoTGhpaWFCWHA1UUliR3lFSG9WMUVKaHpCLyt0?=
 =?utf-8?B?cnFsWFJmV0VpTCs4ZE9vaEYzYS9WOXk2SkJrTnh5SUFpRHpTSDBaNGRIaUJ2?=
 =?utf-8?B?N3ZvMGp2STIrOWlqWFNMWGw4b1l3ZWVEQXprQ2NWcVZ5UzZsN2J1OTBXVWwx?=
 =?utf-8?B?S1p6elVvUkVzZmp2clNFakttbnNkUzJjME54ZXJjQkVoZnFJMVlSVnlLS2Y1?=
 =?utf-8?B?Q0JnUzYvVkY3ckpQNTczakI2b1FXSVJ4SFdDUVV3Nm5wRlU3aDRvZDkybzNZ?=
 =?utf-8?B?WFJjMktQaVlZbmJxMVZ1MGNKOS8xWDYrQWZjRExTVnFFWEhEVjMrODJHSm5L?=
 =?utf-8?B?Wlpvc0w2ek5LL245LzJPRzdKRU1waUtRckN2YlgwejZmVXpMNDdrU0VITjJC?=
 =?utf-8?Q?YtaXeR3j8qbhAW0lhg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7050ddd5-6e9c-4f18-d46c-08de4df5f15c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 14:06:24.8185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIVFMl+aN8iTiZ4V/iU7xpf+wZHRiczdna2hXiYw8h/sd1uoydkpMP75PyFd9FJ/5Nnq5RG8wEgXoQDTQThi9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7645

On 1/5/26 22:54, Mario Limonciello (AMD) wrote:
> Lars Francke reported that the PMF driver fails to work afer S4 with:
>   ccp 0000:c3:00.2: tee: command 0x5 timed out, disabling PSP
> 
> This is because there is a TA loaded to the TEE environment that
> is lost during S4.  The TEE rings need to be reinitialized and the
> TA needs to be reloaded.
> 
> This series adds those flows to the PMF and CCP drivers.

Please include a summary of the changes between versions when you submit
the next version.

Thanks,
Tom

> 
> Mario Limonciello (AMD) (4):
>   crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
>   crypto: ccp - Add an S4 restore flow
>   crypto: ccp - Factor out ring destroy handling to a helper
>   crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
>     fails
> 
> Shyam Sundar S K (1):
>   platform/x86/amd/pmf: Prevent TEE errors after hibernate
> 
>  drivers/crypto/ccp/psp-dev.c          | 11 +++++
>  drivers/crypto/ccp/sp-dev.h           |  2 +
>  drivers/crypto/ccp/sp-pci.c           | 24 ++++++++++-
>  drivers/crypto/ccp/tee-dev.c          | 54 +++++++++++++++++------
>  drivers/crypto/ccp/tee-dev.h          |  1 +
>  drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
>  drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
>  drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
>  include/linux/psp.h                   |  1 +
>  9 files changed, 154 insertions(+), 23 deletions(-)
> 

