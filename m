Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638EB21D3EC;
	Tue,  2 Dec 2025 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764685541; cv=fail; b=OnVXGT6tx1yrnXEF+n2l9xQcxU3VnYSzNOooiw3SMYLVUm3sFxBiCeXn0zlzQY/WVkH+0wv0iBOZ+2DkmQzH9WSfwVqxA8OuWXy6+xQmUI5D53I2o7JUIZ4+Gfd+4tXJrr5U7Dv6bwXlkOnqLNuDjrGI8NAWJoqhxR3CQs+ofdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764685541; c=relaxed/simple;
	bh=No1usOQ+TuNySrdUb9cu8Yk7loIZEwwolIouNBGcWls=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZRbNgOPi+Iaia7FjxWN9eXiRG1FidXCveHcY0urT1hjT8nfSwsNz04SIW1WEy2y8cfg05HmtyLsLLyuKfN99todn2kifxrUSOb3sNP4WIk1gVeXgA43irLTINZBJ6G+iuDM/9s7+2GVlUv/PUWxD3l8eskMDdkt0NUB/73rS/fA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SGicgivG; arc=fail smtp.client-ip=52.101.193.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SGicgivG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUYos/UGEIFusMXr1aB9mhLWCBipCB4SzIackpZYYdLFxUK5p+T9/K6nM0WB5Vy7GqX0hv+EbYwV7galZyOQHjxmXlDA2iMvp0c4p1bTS2+QN3A7W4ObAgQZmDcVTbyEXp8VBNhB1kGmnZcafDw0XryCpU0X2H/ZG7pWGRgjF9ETgqfhhtAF0luNM8KWuNxPN4wev/Jt68cs/Rx/g2MVLLWJ1AdI775FC5T+cGu7FqgPk6C53jmhFTxAL9W+RhcaeoxDVY2kk+Rr/iuGBjzlGqVojjRFKMcL4IWbUlFxChj9npu2U6sTh+6pOP+ClafBEOo0uXb4siX9QgCXPElDZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdBdBHWs7s9MZyHemK3a9PtoO5EC96zsaZwPZccrPGc=;
 b=e/DbH40+eIyCPzD6UHeqlzSt1/w1GZ9kocP1ZJM6UmjLEKkj1xB+8GYood3WOhnAC1lROh1JCe7uQLkNlmHAoaa0KmO/+B4Qd/GoGkqyArrV4NQEpZJy5cJuByflf5/LQQraFp1SmiBsQIuW0kL0q2qWJzqa937SLaAVMo6STA8KZfRfhaa1PjXIubiG+SGeb3FQ8agcfYgfoI8uH90zua6843tX6glk7cMCPOgwnnN0JpCoUx9EVssYdIMuX2vYLcWELQDJzb3hY1xjqBXMn3YHrjYdkFfaAPqzDPVbH3IvLeIz267FrjFIuI6afjz41tyjGo0Sdk/G7aeO7tSWtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdBdBHWs7s9MZyHemK3a9PtoO5EC96zsaZwPZccrPGc=;
 b=SGicgivGrPCUJ6mMUoGlMxVtgmnLH2wfGsr/Ke7vkF/1EKDLKw60yuoEYXEtpqfJPzYxgdOG+/aMPBaO0v978mRc/ZeM7a5A9AfxsXihXEinJ3r9gpXBxHTRpJ59jALStg1kxcJrBcCjkJe6yJykVASJEviqBiCyCHx7RZLs9Ds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4273.namprd12.prod.outlook.com (2603:10b6:a03:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 14:25:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 14:25:34 +0000
Message-ID: <745851ab-7776-4875-a57c-978fb10239d9@amd.com>
Date: Tue, 2 Dec 2025 08:24:16 -0600
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
 <fd5bdddc-fd22-4373-a8ff-3933c63cbacc@amd.com>
 <de801efa-61fe-4540-8749-c3483e0f793e@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <de801efa-61fe-4540-8749-c3483e0f793e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0232.namprd04.prod.outlook.com
 (2603:10b6:806:127::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4273:EE_
X-MS-Office365-Filtering-Correlation-Id: 41eab856-43a4-4b62-5775-08de31aea770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnNFSnNBQ1FmN2l2QmttY1VuUUZqekh4Y2xGR21IaEk1NFpNQnhpWnNQeXZJ?=
 =?utf-8?B?NE5mOEN1b3RYaGY4UHpHZWJqMWJUUkFBZ3p0M2N1blFDNGlIanh0M3VaWHFL?=
 =?utf-8?B?ZDQ1OHk0YURTZXFYK3I5dWNJTEFIdU5wTHo3d21GU2pKZmhjeEJDYU5MdG5l?=
 =?utf-8?B?RU94VFBGNUZDMVptZVBzWVlWeXZrdGhFTGlHVFpZL25RNkptMDZLeVl5MEI4?=
 =?utf-8?B?dG8vYmlaRnRGbEN3N2dpTlI1MjZ0eFJPeFlTRzNmMkY1eHgraXIrSVhxT1dh?=
 =?utf-8?B?eGU4ajk2Sm4wZ1M1emxUS1Z5Sk1QS2VyTndsUmxtOUFkUE03Yi9FZ3lJOGZs?=
 =?utf-8?B?NnM1TldqeGEyNGI3LzdYRHluOFE4YmhQYmI4cGRtRjhzN296VnNwTVdKWEFE?=
 =?utf-8?B?b2lzNC82Tk5MT2lnL1IwSjJMN3hZZE9XcklxaUJLenYvdmJMZ0hhQW1wRnh4?=
 =?utf-8?B?eERIbGRjZzJzQXVBZVVKNURtbjZmaldxN2RCcVYrY2RhMmtlZXFVNWRJVUlD?=
 =?utf-8?B?T1ZFdEFDVWNIY0pjZTErak9DWCtCQnNYTkRYUUlyM2VMNXdjRFg3MnkyWmhV?=
 =?utf-8?B?MGZ5aDlUZGlIWHNBbnU4aG5Jd3YvUEZTaXdNSzcyTEJQeGpSRmJPRXBhMThu?=
 =?utf-8?B?VCsrempralJBbGxkekhwRDRWR3J2SHpsR1dkQUNPc3UvMWhVeUVZbWovK25t?=
 =?utf-8?B?MVhYT2trUHhDdTBsdnNpRURkMWlrL3F6NmlWY0NDVTkyV2NLeGd6SVFDOW5l?=
 =?utf-8?B?MG5nczd6WlNtdUhzNk9WRTNYdU51OXNBZEw3amdTdmVWc3poRVBKeWgxSmRp?=
 =?utf-8?B?cjNCaHdyYUxoQ3pWVUlCL1F2ckpCQlJYQllhQ241Y2Q0VGVXNk5sTjZydXVk?=
 =?utf-8?B?OVdTRFdkS1haM0pMMXhDSVV0UUh4dDg4SzZCUTQzSU9UanlxZzVnUFhNK041?=
 =?utf-8?B?dnFseW5SQ0xLcTNGV1I0d1c4YUlJTE1pUGhBcnZ4OGF2NGZwbUlxditNcmdV?=
 =?utf-8?B?Sy9YVWhZL1Y2cGdBTS8zdHlkb1pkOWFJTnpIK1M3WVYxKzZralJ1MGpIa1I3?=
 =?utf-8?B?UmhqM08rZWhiQVcwMHp4WEw4Y2tOQXg2Uk5vRlhrSUxPVlg1dUdTMG9tNVZu?=
 =?utf-8?B?cTdxaDNjS1BzYmRxZXhJU2NLRi9LQzZESk1Zbis0SitkdW9OT3UwVzdDVjRw?=
 =?utf-8?B?UnBTSEFFK2xOUTB5MHU4WUVIU1RpNHJRdW1ZQ3gveWJJRmFlYTJWeVZQMWN0?=
 =?utf-8?B?eWRBbkJNVlpFb2orZURaTWsvUkJ2WWQ1cmh2eWhGYUlNSHlOdklWK3k3Ti9r?=
 =?utf-8?B?OWhiK0p6VEFsOFZXQTd2RFlHNjYvV0tFR0VzTDVNUTJMTGNsWllBMy94YTdU?=
 =?utf-8?B?Ty9XZ25QVWl4UElrWnloWlNZVGc2a2tOdjFQQTBXRDhhSkVMeWRCQ3B2QUN1?=
 =?utf-8?B?d25jdWdGc3pNaXFjR05CbUlRcEc2QmdDMk5QVDlTQi9LSWQ4bmZmVVg5UjZN?=
 =?utf-8?B?Qm13d1R5MzZJQW5hdUFkaU1EY0xsVXYxQjVBNnNlR21oQ2xyOElnMCtaK1Jw?=
 =?utf-8?B?VzV5VzhOcGlUY2h5M2VsaU9oUlZ4d3ZOMTRMTWJQZG8veXlEOHNud0plVVNH?=
 =?utf-8?B?NVU4ald4b3lXM0M5Y1dqTktwcVBPM1JEekVXOTE4Z2xEOEt3ditwTmcyQlhp?=
 =?utf-8?B?aDY0UVp0UllGeHl0YUFMaFkyUHltRlFJVmRjcUgwdkJERlR4dnBBcmZNZDdq?=
 =?utf-8?B?Tmplekp1UERzQ2pSRFVhZElZVXRjekV0Wk0zcU5nTXdyU09HVk9maXZNM01a?=
 =?utf-8?B?UlVCbUJPV1pnSjh2bEdhRXVxYSt4dk9td2xVZ3l0UnRSVmJGekFlY2pzdXI3?=
 =?utf-8?B?OWExaU1zbUhQZFZJdVpTZzgvZzZMNUd5dTFxeUhFMzNlQmxiR3VaUkFhVUZM?=
 =?utf-8?Q?+aaahwRV2BQKSo4u3qfQvflr1xmRW9VM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGc4c2hCdm5CT1pDZWt5MUZRYkJzMEpTRk9GUGxPUVpHUzZoUHFCSVhOOUt6?=
 =?utf-8?B?aFJPeEtMK25MenBsdHB2Yk5zNUhCVE0wUzl4Mm1Ga1hlZzZEU1BCYVFvZm1L?=
 =?utf-8?B?LzdldlJ6ZWw4VHdRUW1JSXl4MW9lcC9iT1lCV0k3VWErclBOMjlGckVTUDZy?=
 =?utf-8?B?MC93ZzhTVnYxNkFiaFM0TzVONGoyVUZBSHJCc0hFK3hSUjk3OE1hS1Zua1Fl?=
 =?utf-8?B?Tm9aL3Bxci9HaUQzc2hGSzJENVYvRVRsUUtBYmY2b1hYdXBqY2VYQzQ2bmdV?=
 =?utf-8?B?NUdKTDlwdkJpbXZRUFJZQTZjUWRpUDRCeko1Sm8vVEtMUlBuR2RwUXRsUXE4?=
 =?utf-8?B?NFZ3emRIbW91WU5UT0RIdm93RjBRdkF0cnlBcmJCVHpSQ2ZCeHd2eGJscnBV?=
 =?utf-8?B?TVBHZ2lpSnRmUlgxYXVaTzRBOTlYWWRBSEg3QW5iUFIxVnBYSU12bTAwclNi?=
 =?utf-8?B?R0VaQmhJU2p0RTQ5T2dCemZSMHpNWUZVU3FheXoxNkc2SlZ5N2J4VE9oWE5T?=
 =?utf-8?B?M1JhcUJDcGtQSGJBeXlhRjliKy9sb0dOcytxTlJpTEpLa1FXVm5hczhqaUc5?=
 =?utf-8?B?bzJxbzlaQmo2MTdHcnQreTMwQ1hQRTlTdzZ4b0ZZak9sbDRycExXRWgzdDRV?=
 =?utf-8?B?bTFQUTY2S0NPekdtMGF5ZTFENTBuUTVCZEo1K2ZtZEhyZ0tJbFY4MkFxYWJJ?=
 =?utf-8?B?M0VjU09TSVpsaVpYTmUremFvdWgwcTlJVW16L09zcVJBM0dnZnB6dHdPRW4x?=
 =?utf-8?B?Y092ZGl1YXRjRy80YnRBNG9lVWoyOWkwcmpjSTNLYll4QU42NnlEQ21uSjI2?=
 =?utf-8?B?dmx2SDd5V2dCWDV2Q01Fa2UvUzBHY2hWRnVMR1BwbzB4bXJBMXVwYXZ3OHNC?=
 =?utf-8?B?bUhuclRkQnpPWHYxd3k5RVFremtsWVVaVzF3SWJ2RytTdmx5alE4MnZwSkhT?=
 =?utf-8?B?K2h1QlJvWGEwSTQwckozWWRvd2M0OWt2REV1SDdKNlV3bHh3RzF2V2ZNNC9p?=
 =?utf-8?B?dThQQXUrcG01c2R1NmVubzZDVW1hTlNoTjhRTzcyaFBGWnE1N3ZOcHZWZTBV?=
 =?utf-8?B?T2cvV0U1MjdBdEZaOW1KM0o3c0J2dW0xQVZOWFQ2NEZlU2VSc2Fia2hGRlU4?=
 =?utf-8?B?T0o4NGpxVDdDR25EeEVHL1hnR2dpK1hXZ0ZjeVBoazdmcW5rejBHcFFHaDBL?=
 =?utf-8?B?bTdGNzlkOS9RVzdyVTk2MUhReHZ2a2FmMjlwSnpKRDR5LzRIZnJQb0lJaER0?=
 =?utf-8?B?V296OElTWTl0cEs0RXVVK01oaWlCRTlndXFwVW52K1ZQTHQxME9TcG1zNzRJ?=
 =?utf-8?B?UUJ6bTh6SC9xMXVxS2ZyNUJVTWk3dnFxRHBycEp2akxGWjVaMzhucmswbWpj?=
 =?utf-8?B?WG9McnBHSFhLaktvWnJJeGFUTWxobVhrNDIvTkkraXNleElQY2ZCL3Y5RHJx?=
 =?utf-8?B?OVkvTU85Y3J4VU9yV1I2UDg3YmErTVY0bmVSVkx6Uk1sa1NNY3lnWnVTdi8y?=
 =?utf-8?B?clgwZXZvTy9WOTBOZHUvV2lSaUFWZEgxY1NSVWhEcE51V2E3SWp2dVhRUVhT?=
 =?utf-8?B?QnNaeEFUUG1UaG5SNUpwRWhKZURLa0ZFMkVSNUJIREVZS1FQWG5GTk1Ca1Vx?=
 =?utf-8?B?b3ZxM0Y1MGN4Mlg4M016Wk9jbWduRDVJN3hBSmtxZjErTFlZZDEvOVJhNkF5?=
 =?utf-8?B?MnkwcnNCSVBqSmEwOHBjRDBCbTYvVGdRRjBPeFB2eld5YTJjZ0tPZ3dJZElH?=
 =?utf-8?B?U0RwOGI1VHdyWlVERDJOaWY4Q0JCNTJiellXaVlaUVNYWTNnelAzUXJiYTc4?=
 =?utf-8?B?SWxOZ0FxTlJMWjlPVmJWMlFPZXUwLzJnQmN4WDVPenRRRzdCU1N0c2dYNUx0?=
 =?utf-8?B?OEJ1eDhXcG1iUTVhYUpyZUFxVTF5dy9PRzExek40aGtXaEVkK2lqZVJ4bE8r?=
 =?utf-8?B?a1VzYjFYdmxDVjlreExEbGNqNDFwaFI1cUsvVmdpTzAvdmZUa3VJK05PNk9K?=
 =?utf-8?B?SWlIcHQ5SGR4NzhpclV3bEp6NEljN1JHcTdlaERvTWwvaXF3U1dFNE5IRWNp?=
 =?utf-8?B?NXF1TnpvcVdkMHM3UGw0NmJtek5zWTNIRlJRNnRoOXNvTXlxbjduSzNHWEZV?=
 =?utf-8?Q?Sx4aBNZuc0T1FovwKigQ/RqBX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41eab856-43a4-4b62-5775-08de31aea770
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 14:25:33.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVo5aiMMwpkJsUw5BF3flkWf3dULFo1NGlKrzNB6Rl/n2HtPyYuxhR7ENzNrI7PgcFOBi0aM5NdT/gNZEvqqeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273

On 12/1/25 20:04, Alexey Kardashevskiy wrote:
> On 2/12/25 02:23, Tom Lendacky wrote:
>> On 11/21/25 02:06, Alexey Kardashevskiy wrote:

>>> +struct sla_addr_t {
>>> +    union {
>>> +        u64 sla;
>>> +        struct {
>>> +            u64 page_type:1;
>>> +            u64 page_size:1;
>>> +            u64 reserved1:10;
>>> +            u64 pfn:40;
>>> +            u64 reserved2:12;
>>
>>     u64 page_type    :1,
>>         page_size    :1,
>>         reserved1    :10,
>>         pfn        :40,
>>         reserved2    :12;
> 
> okay for formatting but...
> 
>>
>> This makes it easier to understand. Please do this everywhere you define
>> bitfields.
> 
> ...I really want to keep the union here (do not care in other places
> though) for easier comparison of a whole structure.

Yes, the union is fine, I was only referring to how to represent the
bitfields.

> 
> 

>>> @@ -1439,8 +1446,14 @@ static int __sev_snp_init_locked(int *error,
>>> unsigned int max_snp_asid)
>>>           data.init_rmp = 1;
>>>           data.list_paddr_en = 1;
>>>           data.list_paddr = __psp_pa(snp_range_list);
>>> +
>>> +#if defined(CONFIG_PCI_TSM)
>>>           data.tio_en = sev_tio_present(sev) &&
>>> +            sev_tio_enabled && psp_init_on_probe &&
>>
>> Why add the psp_init_on_probe check here? Why is it not compatible?
>> psp_init_on_probe is for SEV and SEV-ES, not SNP.
> 
> If psp_init_on_probe is not set, then systemd (or modprobe?) loads
> kvm_amd and at that point SEV init is delayed but SNP init is not so
> SEV-TIO gets enabled.
> 
> Then, there is some systemd service in my test Ubuntu which:
> 1) runs QEMU to discover something, with SEV enabled, that trigger
> SEV_PDH_CERT_EXPORT
> 2) the kernel ioctl handler has to initialize SEV
> 3) sev_move_to_init_state() returns shutdown_required=true (it does not
> distinguish SEV and SNP)
> 4) the SEV_PDH_CERT_EXPORT handler shuts down both SEV and SNP (which
> includes SEV-TIO).

That seems like bad behavior. It should only shutdown SEV, not SNP.
> 
> The right thing to do is just not use psp_init_on_probe as it is really
> a debugging knob. But people are going to use it while DOWNLOAD_EX

It's not a debugging knob, there are customers that use it.
> (which we need this psp_init_on_probe thing for) and SEV-TIO are still
> in their infancy. It took me half a day to sort this all in my head,
> hence the check.
> 
> I will remove it from the above but leave the warning below and add the
> comment:
> 
> /*
>  * When psp_init_on_probe is disabled, the userspace calling SEV ioctl
>  * can inadvertently shut down SNP and SEV-TIO during initialization,
>  * causing unexpected state loss.
>  */

Maybe a follow-on patch can fix the behavior so that SNP isn't shutdown
if it was already initialized.

> 
> 
>> Instead of the #if, please use IS_ENABLED(CONFIG_PCI_TSM) so that the
>> #ifdefs can be eliminated from the code.
>>
>> Having all these checks in sev_tio_supported() (comment from earlier
>> patch) will simplify things.
> 
> I am open coding sev_tio_supported(), and ditching 4/5, seems pointless
> as hardly anyone will want to enable just TIO in the PSP without the
> host os support for it, right?

Ok, I'll check out the new version.

Thanks,
Tom

> 
