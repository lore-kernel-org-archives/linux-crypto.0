Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793654761;
	b=ncEA8e77FvO6R+NJl113HD3bDU52Ey7TwpOuap25t9WTcsr1Hf//zqas5Rbs0VKE3KjP
	 yIhPZ2P128f2sHTsroslYkgeZDhlI2XEiff9ifAFbL6ghdxY9X/k/2AUnjuSQfANwA6xU
	 K22Wn22JUqYJb7rna5aKaBTQXUrJxJgr16zUe/I7EqhT7WcKqtXX9gmMrAovl1uqjMbmR
	 m4JQpzOEsB/QiJykkUnjJEMYcaQVywUTT1jqyJLl4kQAPXOtp8s8sGrsMHTco9Nmbv8Ny
	 3DFDxQQ/HOHLNw+Q4tiR22aWndCQHNYdHtiBH0uvzrwuG5//5C22nlEo9mOpZQDPLcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654761;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Eg9ROp279EM9eK6sCSMZvnBt4oAYYzk899PP7xALCg0=;
	b=VMjk7HZ+e2japKk2XG1nbMVjjQqehciXAQrRLFBWmqe9SH39R898hL7pZ1eexBJS51Zw
	 f1iu7afbP7fHMH/obk9HTPS5/p3CvfYJuHVHTF60hx58xIawNxZgAg4ciwrrxSMZU4cW9
	 rGu0l8wiJV5lGq3xx2HyW17Kh86d0Ogs7EO0Xk8x13F+tMp6yU2pZwFtrfWHBDkL4a/x/
	 LXHyV7rIVpvD3eD7xaHNTsDtoYy4vW9j4Fkn6JIaQdvrwfLsXYSnSPzqmOcFwvpw26mjq
	 fep0lbFR4RfQsgYgTwqhqmn1PCK1XRwbwd72vjwyyHODs5CwiVlG/mLgtNHAljraEhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5aYpVy7T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.37
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B505606A324;
	Mon,  2 Nov 2026 21:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B505606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5aYpVy7T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qzh5Z8QnUis1dzwT4V9j8qEgYoNUFYdWcw2VJOqGlcvNocbZHgjcQdfGUsbq+oq2g7m+NtEEpismeiojiU/gbd/LPCSv5izCZ+oLKZrje/xQzn1Eh3Qiz2DQYC0X9IMeByx+3dd+8kgpfa/8wvunrrlcuoMXLDPr4lRb+H28ermiwJ8L5ltqo+03aPfqiDJ4Vrv/EYHRImyNHJL5o7fYpOqL9CpsNhYQ/TX3hPPmJuY8pLbRp5ZTkm8/Kf0kzsD3ON1mNILRKM8T/7LYllxxiNvBAfL7Z9FASKJp9OrKRSP17TXJJvMw+YnrpqFFz58UUR1k8TM8uE5uKHlBuXBmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eg9ROp279EM9eK6sCSMZvnBt4oAYYzk899PP7xALCg0=;
 b=VLtIqo59efeGmFLXqUlOx2gY71MJra8PIu57WSIr0wNQfNTdA/jWJmN7PD0J+QVdrtOsxyJkj8i6jmFY52hskhnypcNtxOrxiB+lfrf26E2FcRYPALCQ76/KA4nhmdMhkW5jCme6pOlBNf7w60wWbqb3w/CAGCaU+6RyvyZRzc++Qaxozh4HDHlUis3jp+r58cfbkvhSpc70x6lFFYieTUbtUwS5uO0XMEA7N8rAUVP1S7haFOKITA5y9sbXlizr3SRk8i7kS6swTofXFl75PsKimDaDre8k1v4Xe5Kv5mXfI5TsRZ/Pz91VinK3xUW2AX+0pBzIHwtQHihn2L02JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eg9ROp279EM9eK6sCSMZvnBt4oAYYzk899PP7xALCg0=;
 b=5aYpVy7TguwTomAyyE3NStBq4YJLa+f+gORaKelUBDNpyeaZV2YYR7V+h/4sKHJILiNILYBWRNrHKUKXFrFV3igbqEK92Ed+IgjKC/adDlWXhRRXMFY/NG2lG2/olckR3JFq33Q7ibjsWWUx/5fpxlgmWkszXBBIlHt5CGlFF10=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 21:25:57 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0569.009; Mon, 2 Nov 2026
 21:25:57 +0000
Message-ID: <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
Date: Mon, 2 Nov 2026 15:25:52 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>, "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0393.namprd03.prod.outlook.com
 (2603:10b6:610:11b::21) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: 57523ab8-02b0-452f-8a14-08df3927e20b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|11063799006|4143699003|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+oMPxVInMi9dHnEa2TnwlUEFirZUEoki7LBxkYKcZijfO/7fqL169eKBHCOjL7O1t+whSkLLSuKj3a9PNmy1lVT6c647sgla4+elgvHQTikxVxHuUSOPQ1tHkrCE5p77v2VWnkB6WcZ3eQTUdv2bDRtfInDmhMlRIY3HEbcgtPR48//PiYZMSxXXNniXEYzELcNFD1pdp+II3142lx7LXEFEF1cZXFfTlXNJX3wdxuHvLEAxNn00lEohGgmK4OTk2gdsDtwMUBOIVVnCo4Irpue4EpHNuklH+YkA+0+McYEbGB68IaxmATlYSMTYAHZ/zYJQeCb5fZuk4AQ1e0Q0g4zUmgEiin+r1mZHHGtCGB4HQhgzs41n/OtsfdC6xiEFQqte9guL5SBmHWtt15dllIkgmnB87zaIWazk27v1phFtfTZT9HZ3NwPvYnbe34tjZpXSR5xlTHfNtWkB3y8p51OWjC3CzHKC1rG/oGIdClz+moRONSgVnZYvn2siV6NlSB9j3KpAzrKYJa3bqh+SSn4lfO8Tp/nNE4RFrXB6qdtBra1fVD4Bu1eGey2CILe4ufDpjwACJnS4WvydCwA+UrhLgb6bcJUX0kPzEF4FHrFYPSG5pnourP11fpKnGACXr+C7ELyTPluv138DA7EORcVFmB4jVLa5VmXkN/io76c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXMrdjMzdjJYWEdTYU9LMDNHWTMrWTRRZWlyNEMvcjR6d0RxM29KSzBGK3hG?=
 =?utf-8?B?SDQ0NzZCYUZJZTFvQ2hYdFdnYlBnZnNMTUZyc3VWOTcxS01DUGxjaUNrVnlt?=
 =?utf-8?B?dHA3Q2czc2RGWjVRQVNFWTlFOXd2ZnltY3dBMndodHpWdGNPNUZDTHNocWJX?=
 =?utf-8?B?WFJ6VWhWaUQwMXJPZHF5d2UwWHdoeTAzeEdtUWkxd0lsTnZoS3hDdkR4czg4?=
 =?utf-8?B?VkgwN2prQzl5czVGeTV2MlJERWpvL2FzeVUxZnFvS0g0UjdMU2ZFM2VuVmxt?=
 =?utf-8?B?YTNCZFpsaVduRlhWVjErazZLZkpFVnhnOTl0dFI2T2hZc29Ic242RjJJV3JS?=
 =?utf-8?B?WjBrcVZqOE8wK1dtL3lkc0p6NFhTRmpyRnZRNEZNZENZR0dMWE9ySTNNMllx?=
 =?utf-8?B?T0Z0U2M4bnVZeG1LaVZlSVorQmVUc3FZUFg3bDN4RnI2WWZBdHVEdHBla2Vh?=
 =?utf-8?B?VGJldFN0TW1lR0FkemdPN2paZkJiNVV3SHRqellzMGdUNHNjWHZhaU1CRHdV?=
 =?utf-8?B?anprKzdFT0ZYL2Y2N3ZuL0NLS0xmU2RFbzJnMFZrRExBc3BzRCt3SkhoSUsz?=
 =?utf-8?B?TjYzRnI4TmZleEs4WGNoS0VzdDBVVlBIbVFrVXRLdU5idXZ3Yk44bmJUQlRv?=
 =?utf-8?B?dEpuUzRnVnp1NUVCeWNLa0tRWnFqa3ZlSlh6T04vNzEwZGVwNTYyeGNKTHN5?=
 =?utf-8?B?b0lmVkJZUHdlYWJPZU0wVnE1bHVJQ0N5NlNLam5QamNySTRvRXBUc2thU2VV?=
 =?utf-8?B?ZFZmSGhndEltSHVvRHB0SHdmUllzQ0ZIOE5URkVhNUdzN2FCbGx5ZWI2ZmVZ?=
 =?utf-8?B?eUp1bWJacHdLNllqL3RaS2Y0UXhXc2JxKzdmMWFTU2grUkxiN3pHTXY4Ykk0?=
 =?utf-8?B?a3BXRnd0Ykk5K1ZIQ3c4d1FoRlNFRkhjSE9tWm1haWNZWnhNZXZkY0VKM3B6?=
 =?utf-8?B?cXhHT3VuZ3JNQ3ZtQmhMNm9ldVhxNzFqTEJZbnZxSFRCU3Q0Z0w2QjcrNnZx?=
 =?utf-8?B?WmRjZEVqQzlBd3B5UEZkY0V5c2FhMlMxRmRKOC9SYjczZDkwZ3hQZnZVaFAy?=
 =?utf-8?B?V1dZem5WRnFEcVAyK3ozbEswMmY3SnI4QzV1K2JVTE1vMG9EN1JzU29XZVhM?=
 =?utf-8?B?Nzhxclc2K3Y2dTJHNzA1NWpKWm8yMjdPb1FxdGIxT0EvSEhIcGFUNS9YWlU4?=
 =?utf-8?B?UTVsTGs4U252dUJ0bE1ZOXc4MUVuNE8xb0JZblBCMFhob2lka01NSW5RMmpE?=
 =?utf-8?B?Z2ZjWjVQbkxobnBWait5VC85UTVNNTdnb0lFcldPTDJGTXV2L1F6RVFWWlR5?=
 =?utf-8?B?c05nNER3MjFoYWRHb0djeC91STFvSEJMbW1QZzRwOFBwcE1aeFdxRXB6bGkr?=
 =?utf-8?B?SnBPT0xEdmZnNnlBYTFqSnZ4T0FCYjR6cE9HOHRkUlNHZklTLzM0MWlWblVC?=
 =?utf-8?B?MGZVdW5MSERGNm9jV0s3aCtOeVBUZEVmVElKSjNLbkgxcEtwamtmc0xKRGx0?=
 =?utf-8?B?b3FkaWQzU2wyaVNHUlJTVjMvbGlZdGQ3Y0oxMkJqQnFyNkNGNWE3RFllbTU2?=
 =?utf-8?B?Z2Y0V3Q2SmtmRGhHNkxRMzBCdHowb3V3Ulh5REVPSUNGNURKcVVWNEppZitp?=
 =?utf-8?B?WGE2MExmTGhzcmtROC9JQzk3TXZDMjRnK0oxWVJ3M2hWakd0YWFaUW1LV28w?=
 =?utf-8?B?bk8rMzdZN3RoejMvNHQxQXR0cVVzY0c1aWFvcTV5RVllS0o5OTdDb0ZDemFI?=
 =?utf-8?B?Ukk0cUNYMXJrRHc2QitmNUFuTlo1OHZGNlBMT3NhZVJLZkt6S1krdkg0bWgv?=
 =?utf-8?B?dENnQjBLbncxY21NdjRWK1d6aVB5cWJMbk5kZEQzNEVwSm4wOUNVVG5RbzVQ?=
 =?utf-8?B?WVMrZjdscm9XVTZSdUoxeXgvRG00NkhnOENVSEtNa2ZUdTNVRW05VEwyTHl4?=
 =?utf-8?B?QndhR1RzVzU5U2Rkc2l2YlNqa2FhWDR4ZHIvMjFpdnYxN0h6YmpCREFUMXlr?=
 =?utf-8?B?em02bk9Ba0FLdTJYWjZvM1UxaFpwSDg1ak9mRnVnZEliUTB0a3dPdEZ6S0wx?=
 =?utf-8?B?RmYvZ0tWbHVCTUxaVEs0ekZQSmtSQ2ZDUjVzOGtOVlZjS2VkVE1aekREWXJa?=
 =?utf-8?B?Tm1CSVZadm80U0doR2N1akZHRkx4SWEyWGduNVo1TWZRT1FhTXV5dGxXWWxt?=
 =?utf-8?B?QTJCMkJQZ1NtaFdkRWZnQUtFekp5MjJzT05wV2c5YmxKbkhHRU1uRklPK1Bs?=
 =?utf-8?B?TVVUeE1TblowSWI4aUpLYW1Nc3R0dUx5emFjK1hyTDdPQngyak82VXRuWWJq?=
 =?utf-8?Q?LB3GBziwUtT7bD2YnL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57523ab8-02b0-452f-8a14-08df3927e20b
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 21:25:57.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoRwYVDqsOXTTfxbJV/07ajMLPNRv5/w2R1Nr3i5aWMRrUyHrIWTmiGfJoNStXvKsegEKSCj148eojajmDfvxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980

On 11/2/26 13:31, Borislav Petkov wrote:
> On Mon, Nov 02, 2026 at 09:50:32AM -0600, Kalra, Ashish wrote:
>> The original patch returns false if segmented RMP is enabled but
>> probe_segmented_rmptable_info() fails, your version falls through to
>> probe_contiguous_rmptable_info() instead. 
>>
>> I believe it makes sense to keep the return false there: on a
>> segmented RMP enabled platform the RMP is segmented, not contiguous, so the
>> contiguous probe shouldn't run.
> 
> That simplifies the code even more:
> 
> bool snp_probe_rmptable_info(void)
> {
>         if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
>                 goto out;
> 
>         rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>         if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
>                 return probe_segmented_rmptable_info();
> 
> out:
>         setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>         return probe_contiguous_rmptable_info();

The current code clears X86_FEATURE_RMPOPT when
probe_segmented_rmptable_info() fails. The above code doesn't. But since
SNP will be disabled on failure of snp_probe_rmptable_info(), I guess it
doesn't matter. In which case you can eliminate the goto by doing:

	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
			return probe_segmented_rmptable_info();
	}

	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
	return probe_contiguous_rmptable_info();

Which looks pretty clean.

Thanks,
Tom
		> }
> 
> Along with the below, which should have happened too:
> 
> 1. RMPOPT depends on SEV_SNP, ofc. This would make sure RMPOPT is cleared
>    everytime SNP is cleared, as it should be.
> 
> 2. snp_enable_rmpopt() needs to check SNP first, ofc, and then RMPOPT.
> 
> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index 99801e844b30..acbcec394ef1 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -93,6 +93,7 @@ static const struct cpuid_dep cpuid_deps[] = {
>  	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
>  	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
>  	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
> +	{ X86_FEATURE_RMPOPT,			X86_FEATURE_SEV_SNP   },
>  	{}
>  };
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index ff6d17795054..a47b812b2ea3 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -669,10 +669,10 @@ void snp_enable_rmpopt(void)
>  	u64 base;
>  	int cpu;
>  
> -	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>  		return;
>  
> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>  		return;
>  
>  	if (!rmpopt_soft_init)
> 
> ---
> 
> here's the full diff. Have a look pls and let me know what else I am missing:
> 
> ---
> 
> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index 99801e844b30..acbcec394ef1 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -93,6 +93,7 @@ static const struct cpuid_dep cpuid_deps[] = {
>  	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
>  	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
>  	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
> +	{ X86_FEATURE_RMPOPT,			X86_FEATURE_SEV_SNP   },
>  	{}
>  };
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bd70c4d0b774..a47b812b2ea3 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -669,10 +669,10 @@ void snp_enable_rmpopt(void)
>  	u64 base;
>  	int cpu;
>  
> -	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>  		return;
>  
> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>  		return;
>  
>  	if (!rmpopt_soft_init)
> @@ -817,20 +817,15 @@ static bool probe_segmented_rmptable_info(void)
>  
>  bool snp_probe_rmptable_info(void)
>  {
> -	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
> -		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> -
> -		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
> -			if (probe_segmented_rmptable_info())
> -				return true;
> +	if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
> +		goto out;
>  
> -			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> -			return false;
> -		}
> -	} else {
> -		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> -	}
> +	rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> +		return probe_segmented_rmptable_info();
>  
> +out:
> +	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  	return probe_contiguous_rmptable_info();
>  }
> 
> ---
> 
> Thx.
> 

