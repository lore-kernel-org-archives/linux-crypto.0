Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C939C195980;
	Fri,  8 Nov 2024 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082516; cv=fail; b=UQWubdDyoUj3K6KbPax1FPPOEiCVo/nh4iSZip+mmZMZmsYMPyR4UHQ/rY3CqP7zeMBMRafhB7MqmnVrepISoHsjcLFS09XgczwCeq6/9jTUlEdMm5ScJAW1pUkIxomgtONZgWa7cZGbZHIxxNOHI6wSiCso2W0m7pi8Ma+erJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082516; c=relaxed/simple;
	bh=H3+dcjMKxnMSEKeq2awbeZoS6v+LmJ4tYo6VTChh9GA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pQEQXxGamJbaAjL1VMV5tmJJbG67HOEiXt25CXUWkuuMA9/8kDHyMmcQDSj3dLvhV+8e0Y8LWPqZqWp0nDHAQiJTVvPTADdVn8E2Yx1QxoiPzChSCLIwTffF8QL8KnZyZjmquCdslMdFu9Pt9TNN+BoBgyWJrrL+/2HK5Pz72xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gWvQWgpS; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gWvQWgpS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HU0f2bxr35W1kYE+9eZT75ZYKQ2GIe7DCfm6zIgf+hNGFVPkpUeVHlf67u4PWlZRdnGRgsKgu0omcfV7LYkcVUVdPsmZji8iyocRTI2p02a301vHGUy8B6Lk0tsjFXE8c9k5E88hLKe54UpksRmqxo1gTdCsHhtKOK/vyRXkWkwN52FiWvcZNvryNvpAMiV1JpNzohAFFyVaFUS0omayNIoZ/yzBVGHp1V1rFGzps4RGkj3+Lul90zc3DDRS5s4xoIqoTFFTGFDs/r+0mRveqIT1w3bYMJdKJPVF45PnIvX2waIaEk1qjSmbHbsCyfK75+P9zWXsseAhY9/tj/Z9Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJQoGhfd9vtohuV1+/oDR7f6c0ByjA9UtygltjTldq0=;
 b=hzdN2l4BajOCjKOuKL77iqEBp54d/9AXMVEYxjX0Esgv5hXkv0IXbzGeuH0wy+325NOybXsdkg4Ir608v5VPm8V5aGmfQ2dTixFIGTnGTqxLLqput2pWcUrGLUSmTkjUwnY23tRLLUESjqJKMPFtpmz7aia1jhhgJt4maTI3UPoezYbqlha28q97lcMnDEF+VKdDTa08Ey4Lj52GOD5O3XURvHWW/zibR4Wbl+L8RFqZKWONh5CuLzw2Ix8AfBE6ZYA+LzcxTT2SxIalFe4bAJJ5BB3RYaRRnp82/rofVR/SfCHkb/7d8oq5pWBGGFqQfgVaHzXT3Rzu2EkLOkaZaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJQoGhfd9vtohuV1+/oDR7f6c0ByjA9UtygltjTldq0=;
 b=gWvQWgpSVNXd9ZsQ3VU4agKu/t8bNFjnCKdXWklr5oE4txurlfOP2X9J43iHRv+X2bbaSPQ3g//ZY1XOerx81Gsq7ty4so9r55YduG7Qps1awPkBL2ToVCenfH89slr7wDuchtYgqGjTK4HKNZXqWXq2PR8EDDEOMNoQ42rYsLs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB8473.namprd12.prod.outlook.com (2603:10b6:8:183::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 16:15:05 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 16:15:04 +0000
Message-ID: <6642c244-3360-9347-3836-59c5cda5834f@amd.com>
Date: Fri, 8 Nov 2024 10:14:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 04/10] crypto: ccp: Fix uapi definitions of PSP errors
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Michael Roth <michael.roth@amd.com>,
 Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-coco@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Luis Chamberlain
 <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 stable@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-5-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241107232457.4059785-5-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB8473:EE_
X-MS-Office365-Filtering-Correlation-Id: f3031840-6f56-432b-06e9-08dd001080f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2FTOERseHdsR2JWSFhTNUMzc294RGZabk9TTG5iZW1RRWVGdUJNdjd1WGtP?=
 =?utf-8?B?dVZFOUw3UVU5dzBVY2Q5Z2xMNC9ZajNhcHMzcFE3V0kxSmVlTmRVSy9CczZ3?=
 =?utf-8?B?SWZzY1FZV2U1Z1UyTTFEYkpDMW1PVmxLTnpPT285VEcwbzBRcW9xMEl4VExQ?=
 =?utf-8?B?MWVlb3VXVE5rdktCNFUvYTlLWU4zdGNCd1V1LzVaQ01iSko5cllFQXpCWGh0?=
 =?utf-8?B?YVMxRlladEMrWmhnUEgzaFZ4QmNMQldtSnk0YzBlQjM3ZG5tNjVGZ0o1QzJD?=
 =?utf-8?B?eGRQWTZPUCtkVVFiWTBHcnJhZWxDUjlDSmNHaG0vSlhmdm5KMmRzSVFWUGha?=
 =?utf-8?B?T0tNNWIrZlRlUVlZOUEwT1lhaDBFa2tVd0R4YisxM2ZsRUhLbFZJOC9nODNI?=
 =?utf-8?B?bHo0RFVPSlIzMXc0VlcyQnNJQzNvL093Z0FzQkZ4RDlBMkc1eXdCcm00dEIz?=
 =?utf-8?B?Vmg0UTd1Sk14bE9uc1VHZEJHOUNaYjd4Ynh4R3MzZmVxR01mMGVuSDR3OG1F?=
 =?utf-8?B?ZTg5VUxkQjZ4YkNNdnB4d2x2blpjTnNGZ0hJWmxrRFpkdVV6NklEU0pBaUtZ?=
 =?utf-8?B?MEQ2UTdxOEFSUGFvQysyM2tGYU1WekdENUQ3ckprRjhLMkNWTlVxSkJiVW9a?=
 =?utf-8?B?WmdFdUFNRlk5Wk8wZEpHR05LU2ZVL0VOeHhnTzQ0alVOVDdQaVZRYU1QSE9I?=
 =?utf-8?B?clBCZ3lVRjJpVkNqbmQrVWxrUEJVdExScHFuaHV3ZFpJYXlwV0U5N29hNHFs?=
 =?utf-8?B?YlkyVmxLNTlNdUZtbW5XQ2h4L0lHbSs4UzNUaXdqVE02VFg1cnFPYlJLRjhH?=
 =?utf-8?B?V1p6YVVoMlZDck0rd2JwZm4venZKa0hCTFhDOXZCUEkrUEZyVklJTnBySkpK?=
 =?utf-8?B?L2ZVQ2FmOEdiMFVXVVFkYlJxMnhvTWRseWVlbGUyVTBkYnh2eHovZWJoT0Vk?=
 =?utf-8?B?Y09qUGwrNGJUdUFoU3VyN255dVpyZ1ZKRWxuL2tXNCtmdWsyOHp6SHhualBB?=
 =?utf-8?B?NXltOVRSTE9DQVJ2dldSUm1TZzFmK29GZDd6aTlMUU1JL3NsNkI5TzhDOHJ2?=
 =?utf-8?B?VVlxQXA1alVrSnJlVVhCc3hEeVJMY015RlpKVVdFanNzMGcwS3gvaHVUYUQ4?=
 =?utf-8?B?WmozWGFiNWFGVmVCOGc5WklLMFEwSjNvYTlibVZUdVNoTjlTazJsZ0lzbHJj?=
 =?utf-8?B?YXB6WnpRcWswRUcrOFU1NHVJeW9FUFdoTVNnSVBYbmdxemV2UlJpc05HQjRQ?=
 =?utf-8?B?WS9HM21QVHdYdXlac3NROHdTNGUxeFAxWmwxcStsRFRsQTRqeUFoak1kR0Uy?=
 =?utf-8?B?cktkQUNMa1A2VU5MdGFZQUk0MkhVNFk1NWdab3hEWkN4SVVONm14MG9IeVQz?=
 =?utf-8?B?MzdoVi8yR3RWYWlSaHlkT3g1TStUQkRtcHRGdDdVY0Q0MktJNHpqV0dlaUFC?=
 =?utf-8?B?LzdwaE00RmtNdnRWU29TTFdSSlF1NWJWYWtBMTFoWW1RQ2x6RnYrdjNDRTE3?=
 =?utf-8?B?aGZ3UmIrTDVXQkhZOXFPSnBmSEtCQ3ExSHZCRjNXVHBoc0Z0R1Z5bVhXY1NM?=
 =?utf-8?B?MTIzUE1wS1A2cmZTbXRJeGN5MTFEVFAxYTVkUzdCUDBINmxTWnp1NzRTZFBk?=
 =?utf-8?B?aTUxZ0FSbVprbjJFdHNUTEU3dklHWkozaXhPSGFjTHVhSGZSTjVGSnVsM2oz?=
 =?utf-8?B?ZWowZTlHck1lQXVIS1RhUjg1bXFqeFFDY2lnMDlpVkd0eFl5TlZBYjJOZFhp?=
 =?utf-8?Q?LjN8KYGf32r2+V6pya/+/G+QFSsSwh8dBvu9QRO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzZNd0o3VzJxcWdMNkI4dzhFQkw4SlYyUDlQZTU5UzRTTHF5ZkdqWXRpTjhV?=
 =?utf-8?B?c0g0NDg0RmZxMXZEbk5jS2dVRWFOMFpISWlJcWwrVmlKOFVOWjFXRlRMYmli?=
 =?utf-8?B?NDBEbzduSndtTGJGN1FPdTJKMGlONm1XbmdWVFAxNkcyM2JxSU4xenFDRk5r?=
 =?utf-8?B?OHk1ZFVUV01LSTVUc2pGVGxjMkR3NjkyelNiNVd0MXhrNEQ5RkMxV1pVdlFu?=
 =?utf-8?B?UDBua3lRaGI5NDJGa09YdERCN29WN3NNNTlhSG44dHcvTEZ0eStGdllKQmVx?=
 =?utf-8?B?TkIwRW95NVljSW1nM2RtMnE3OWI2QkJld1NPd1RxS3lZUlcxbmNrNEhOSjRu?=
 =?utf-8?B?SnNlbE9DbldlSnNlUGYvZXZrd0ZJaktCbDVYOS9PZjh0Q1RuOW4xVzNNcWpo?=
 =?utf-8?B?Q0hjcmF5SVlrSlVYWHQyMllucDFzNUJEYnRLUDh1ZnFqNGpkd2xrTlJyWTFE?=
 =?utf-8?B?WDhIMVNRaEV2Q1BKb3F5bVlOcEwwM01iZ1JCQm15SHpaYURZVXRWdmVNUElw?=
 =?utf-8?B?L3BxVFhRZWxVYnYrMFhHT1FrU3Z1bzBOZkdObktkVTR4L1B6WTlOazFRbXpN?=
 =?utf-8?B?VXdnRGJ4TUtpRE9VUklxb1lWMDZlZU5IeHcwdUdBaXBRODhyT2w1NER1VjNV?=
 =?utf-8?B?ZndFbk1ZM3RhekU0eVNVd280L2l4dGJxZzBpZGwvbEFsU3VaYXhQYnM0Qits?=
 =?utf-8?B?Y2Z3OVA2OU0xVFVpdlVRaDJBSTUzd1BlalhmWVhPR1NqRVlPVVFmNmNta0xJ?=
 =?utf-8?B?MTFYR0dFend0OEl0ZUtHYlQxZ2NwTlp4VnV2eUt5UnQ0WmZCalFoUU41Mnor?=
 =?utf-8?B?dVByQkt3MmQwZE1USWNkOFpNZndGajAxT3lkcHBUODdaVHpXS2ZZUFhnbWRC?=
 =?utf-8?B?OWFsdG85L1lRb21XalNNQ3EycTZ0T0NFNHVWM2ZRamw2RGNRSVgrQTI3UmZT?=
 =?utf-8?B?K1NQc3luUHF2NDR1dTVubXd6ZDJ2MkxxdFVtZlhXRDk2SUhIMUNYc1gyWGV3?=
 =?utf-8?B?Z09yN3phQWJOY0RaYkw0azNlTzJGWVFhb01aKzhubDk5aE1BeUJKT09rMmVv?=
 =?utf-8?B?L3JneDB4Nk8rNkgxcFJTc0VRWFI3Rkl5NGlWZjFjMm9hSWZGUDRUM2VBYjNp?=
 =?utf-8?B?TitPa3BnOVRjd04vNkpWQ3dyWno2Mm1uUEgzV1U3QlhFZmpKTlp2UlJsb3dV?=
 =?utf-8?B?YUhXY3BQcXEvd3hmd3oyakx4SGI1QWdrdU1WcmRKREE3TDRySHZCSy9xZXhY?=
 =?utf-8?B?dTdlV2doeWV6dGx0VTVvR1dLaHA3M2RlQ1Z4V2hBa3JqcFcyTWx4ckgyWUx0?=
 =?utf-8?B?SXd5cXlrVi9HeVNtZExHUmVxeVVkcDQ4Nk5TUXRJNTRJeCtlTENpL0tRM3lY?=
 =?utf-8?B?WmJra2V0YVhNVnR3Tm1BU1BDbHJuNmI0WUhQYXBvRjJEVnRvTkErWVpzSXpa?=
 =?utf-8?B?ZlE0UzNrSmk3bGw0MEtleDJvMjRmRzBTeXRiK2tsTDA3QmRETjRlTVhlNmpF?=
 =?utf-8?B?Vmt5YnVPSGd3ZGZyRGRrNzVTVXVYcklhbGRaMVpBNWJpdzMvejN1bEdhbkVH?=
 =?utf-8?B?T3dYQlM3NWdFOWJYTFVuM0c4SnFWd0E5R0ZLUFVnQXB3L0EvbWp5Q2tVUmY0?=
 =?utf-8?B?OWxvUktGYkRXc05LNlpFOFVpLzBnK1FIMmI5UXRuandldWFjYXNkL3cxekxs?=
 =?utf-8?B?bHpvUTR0YzJ4eUhHUmFLVDFQQk5uOExHeGNxZ2dnLzZraURDTjZWeVZuYVQ0?=
 =?utf-8?B?QXYzTjFpbHNETUszWXA3cDBDNHp1RC9GenlHNTVCakh3d2MzMFdtb2FWQlZz?=
 =?utf-8?B?dzdCN3ZXYnNVKytZUXcyQ0pnUGptUS9RVHBHczFvOERoUFU5ZXhSWlFITWZ2?=
 =?utf-8?B?RFZhMVpnVDNtbkZuRllFbk9wUEc3RjJUazhtWkViYkx5OXFscjBQVXRHS3Fr?=
 =?utf-8?B?VlB3allSTkdXZGdtYlEyWGE0bGw0MUtBdlRRMUtPOXF5Wm00cnlVRFUzSXpY?=
 =?utf-8?B?K0o5OE9rRTFncGwxSEMzNWNJRDUvd3pWQitkVXhnWnJ1ZTcyRGhwWmpBLzJk?=
 =?utf-8?B?YkRjRzgybTZ4VjVHMUVrYklsRHgxVWpiWDVKWHUwTmE2S2pzUFJFR2pVTlJi?=
 =?utf-8?Q?0oPhKJISHQag1R3ZfC+R65VXD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3031840-6f56-432b-06e9-08dd001080f4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 16:15:04.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOXtrhrMx4jM/5Mc2Sh18T0OzEnCkQ3z82QGE2Q4IDRwG1Aqtq4htq9vu4Vyqeg3dRbXMF3fatUtlwotMiKaOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8473

On 11/7/24 17:24, Dionna Glaze wrote:
> Additions to the error enum after the explicit 0x27 setting for
> SEV_RET_INVALID_KEY leads to incorrect value assignments.
> 
> Use explicit values to match the manufacturer specifications more
> clearly.
> 
> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> CC: stable@vger.kernel.org
> 
> From: Alexey Kardashevskiy <aik@amd.com>

It looks like you used the patch command to apply Alexey's patch, which
will end up making you the author.

You'll need to use git to make Alexey the author or use git to import the
patch from Alexey. Then you would just have Alexey's signed off followed
by yours as you have below without having to specify the From: in the
commit message.

Thanks,
Tom

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  include/uapi/linux/psp-sev.h | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 832c15d9155bd..eeb20dfb1fdaa 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -73,13 +73,20 @@ typedef enum {
>  	SEV_RET_INVALID_PARAM,
>  	SEV_RET_RESOURCE_LIMIT,
>  	SEV_RET_SECURE_DATA_INVALID,
> -	SEV_RET_INVALID_KEY = 0x27,
> -	SEV_RET_INVALID_PAGE_SIZE,
> -	SEV_RET_INVALID_PAGE_STATE,
> -	SEV_RET_INVALID_MDATA_ENTRY,
> -	SEV_RET_INVALID_PAGE_OWNER,
> -	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
> -	SEV_RET_RMP_INIT_REQUIRED,
> +	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
> +	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
> +	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
> +	SEV_RET_INVALID_PAGE_OWNER         = 0x001C,
> +	SEV_RET_AEAD_OFLOW                 = 0x001D,
> +	SEV_RET_EXIT_RING_BUFFER           = 0x001F,
> +	SEV_RET_RMP_INIT_REQUIRED          = 0x0020,
> +	SEV_RET_BAD_SVN                    = 0x0021,
> +	SEV_RET_BAD_VERSION                = 0x0022,
> +	SEV_RET_SHUTDOWN_REQUIRED          = 0x0023,
> +	SEV_RET_UPDATE_FAILED              = 0x0024,
> +	SEV_RET_RESTORE_REQUIRED           = 0x0025,
> +	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
> +	SEV_RET_INVALID_KEY                = 0x0027,
>  	SEV_RET_MAX,
>  } sev_ret_code;
>  
