Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793650896;
	b=jl7DTOgHp242cFcbgT8NauuvFQ3c8Bx5TZ0AQSR9Db8RY2L2Lf4ifRJTlt45fY9RJVJj
	 Zb+QyAC7T1kRYNLHqSsShdd5s9IUi7soOsPmL87ui+63QEV4Pky1E5ySVRm4Fn6eXYeIm
	 DR0QMUb2zv43gY5PJQZcDuxtH7QH7/PW6RhT7Q0dXCYtitGVsldUyNUsWlBOUG0c95Xv9
	 C48m1UcKLteaBAVxzo2yoxD8k2at0mAVGxQo7kVpwt40MvGI44+7/x0NOJ7XPxlCmfiKb
	 eG5ZJbZpHUVX5X/RW+jO29FAreB1NKaqmoUKzXmqn6oakBY8t1u8Q6GvBdUkCRHKweQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793650896;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
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
	bh=RZzIfwZOmCgviJKQ3vlMGbRooiHjRH+3prmBiyfx2yk=;
	b=arK3ZXFi5qz1P/JzM8bPjfjIF72pnDSjecQ8OQ95zPyomFEhhiY5fWHSn0kD113G+4qC
	 RFb+hkcpEs7KtfMjUU1r5pFxXYU+vJ9juoaI5duiEGVQUsfoOs5968Gr7UQWv/LbAt0BJ
	 c1ybbfAFWcfl5nOzIksWp22sdY3frKttVraBLOUiOwy50BvU31I1vhSpL/EIMeO5NjKmx
	 27VLOz7NRjmGF5yTwoLMI5TafrBCgpXLlyolowjrmaeZe8WVm0IKVY4eeI8TkmqI1aSCI
	 Im8A+63O9jGtaQSanDYYjJPlzEocgZhJubPMDXc65ON/GY5dW+Qq+SKQpQROP2peBZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0d6pbPNT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.53
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E39606A324;
	Mon,  2 Nov 2026 20:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72E39606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0d6pbPNT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=whvgyascafWIFj642anGzLiTSgQ0+2sAsKfFNyXrTkZ9ePb8TZ9Vxegvdz4hnZmgdma207T/2VxkyIixTP855kIZkzU9LpBAEkJWtLWgq1QIFcZbQW98jb4xV4iygfcyaNdpTqHAXPmTAKM4fb49+yycE2CEjvt3a0/Ads7jaHTw9ChztFP0w797nINdanaxBijaUoT5s44ZSksnSWVjp2qYpSvLnyfg9Fy/t6W64+9kaPYRzvnN+Iu4x5gdbwAhjwmU7VglBPTYk76/cwo4h2QsNfPRqzXSZZ5WnVQp5Asy9nK9mUWJY1dQOeTvLCDjY493q0gacvKO8pkPjGUbGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZzIfwZOmCgviJKQ3vlMGbRooiHjRH+3prmBiyfx2yk=;
 b=o46JO19HldfnHhSjJEowE14O3TSjFxikeO4nVF2AkV0wwkujHRZqwtUMVl92jA64HChNNQCTyxFDya8CSlVHQfiRiQ7HPgbCpu4Z3mzD0UpXBAA4mXPLvMof+3cmL3uvWnRaSH4SkY7o35sDIilwE7apME0uhKHYMZVofZMaGHQlJRJSvQ4OepKJjDcU6C2+zuIeVTQJTmyuXg+yi+unJWQ4SqCTmgoo4qOy54ST/CVo9TRyd/jmzpmx0lwKuRglEmaJkrAb2iN0oymODQNGVYeo1ZsAF3KdaOWv5MCFKGu8ndHXDIJC0EeP8CUKFm3TtJNnzY1SFyLSNuaZ2sbI5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZzIfwZOmCgviJKQ3vlMGbRooiHjRH+3prmBiyfx2yk=;
 b=0d6pbPNTDuPzfrKNG8jtXmelTfOW6EjxlK7iECVmjiFhRFwLMSXYp6A/aJcFXga+GzAUhgu2AD9bEoXbuICnExl3XZF2IneonBmB2dnQh//6aAxa5Y/j2cpXrILmFyZDTb3snM8HyXuNJRAs99IJ8WRG/fLcmAISBoiPrEQ1GUo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MN2PR12MB4437.namprd12.prod.outlook.com (2603:10b6:208:26f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 20:21:32 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 20:21:32 +0000
Message-ID: <5c80e556-cdb8-46fd-9bee-c54732377236@amd.com>
Date: Mon, 2 Nov 2026 14:21:28 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:806:21::25) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MN2PR12MB4437:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bd69554-4081-42da-5c93-08df391ee24e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|11063799006|4143699003|261021135927099003|56012099006|261009223027099003|261028144727099003|261026140227099003|261026121527099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RNQOwmPkqtoOX0IuDuUaoXv/ne1uYfLHEQfGxHfvCttQKB2Jlnfw8LbCkTvZw2MWbdGt+PfFhqoogc0Rg9UbTnxFKuF6hU2MeFqvMcfgCm6P3dFQaMmB3Qm5c5x37r51LjGSJxwsGhYcuRgG66VwxEPz0Gkfzew3O66ljIdHfEspcgiZXL17QPrdtpiEaGpaafC0cib3Duw6ZTLCmd2UGtRo2blGpu1gi9N2qakW/XTPNYwFv2l16Bq8My8sLbXuVb9EqgsjaxPaemjj5BAgyWNyNrkNKRt1QLlH1ts1GBxBmJahG/z+vRQb+DxglmnJkswMXjOA5gWsBpEs5asJbapuCX4aUt+u58oy4gEbgYq6VYUbiJwWpguA6pmXNzLkqkwQXj48iGfxB3J2ch0w0cR5MwwsmajUoO06ha+SuNG4p2w9NFNwBqNTrfVs6KnGMnUMxyj5YTDkZ/bZniPWxDnih4v6ozTzhNH+jKqd4psHS0hnPQAlgDt7WHkWpJn6+AkGDz9kD33bspKipeJLDZLNjPim4zGkvuRabcb4wvq3HldWifBeD6uAXGXr9BzCDrp6ZgpkDmfcvijqUtWPxLagZFu586pESqozUnlVsaVeLoj2SviUGcbdN81tE/QIEAqhESxGB2ZWx2o8F9fwaCY/x9YoiEZUso11ZH2pjME=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(11063799006)(4143699003)(261021135927099003)(56012099006)(261009223027099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVYvZWJBc283UDZvVU9Dc3lRaGQ5b1lCVWxPU1hidytYd1V6OVQyWTJZNGFh?=
 =?utf-8?B?a05lZjhJY2liTWE2c2sxbWMvZzduT29DR2FDbjFUUkFpY0tHVERvbDdSWWtK?=
 =?utf-8?B?dzNDMU5MYkVJV2t5K081bFBXbktQTTFERGdPS0oyaEg0YXM3WVlkREdSVmF6?=
 =?utf-8?B?TXNpTkZGMEQ4ekFLUDg3dnlGYnlNQTFGTGhUeGhmTlk2WTJvdjVNMHVhbXlG?=
 =?utf-8?B?UnhwVVBLYWZQcWYxcG1wandqalh5amxkcGR2UzZIcjZYSm5lMjBBRWx3L0sw?=
 =?utf-8?B?S3NzdGtvNkdVdFFwb1BTMWRsY1EzeHVmWjUzSUU2S1hEc2VnL2JkWXdtZWpa?=
 =?utf-8?B?cEdBeEhoTmtlYUNxNk5lUGRnaXlpdDhOT2tHTjBJc2k1dTlqRDZFK1FwenNo?=
 =?utf-8?B?ZDd5U0ovL0MvcW4xR2lkMUFmWUNWVXRVekZEY0c4VTdHVzQxcEhsNjUyVnBz?=
 =?utf-8?B?dnlxMUpJT2NyTlRCa01RY0dWcGtSMGkyY29wL0NtZStCVk80cGxiYkxqbmE0?=
 =?utf-8?B?QlRsS0xCei81aVpxU2RQOFkyTkNDQ0pWUFRMZlQzN2NuWDR3Yzd5Q1h3U3F0?=
 =?utf-8?B?RVJmMW1FTjRTNTgwZ2hYWURkT1V1TWM1T293cUhsQktzeU9uUVNBZzZaUytJ?=
 =?utf-8?B?VzBKUjFiU2dXTzFBQkdTUDdKRE15RGRVZVN5ak1pN3dvSnowa0tuNG8rbGZH?=
 =?utf-8?B?aEwrQnVBQ1Y5MnlMVGFDc2VHS3RURk40UGZIdlJWM29VeXVDREZVdXA0Qnpw?=
 =?utf-8?B?R2RXZ1owcXNzMjgrbUl1TnlMSi9qUU9YNXMyQU4rNENRZHQ5R3R5T1JncUc0?=
 =?utf-8?B?ODhZTGg3eUszTWxNT25MVlEybkl5U0JmTHY3bkVqallUZnFOWVZBTlN5Skk1?=
 =?utf-8?B?TVVxQjQ3eWpQSGtldUY5V3NRcEJXTkhvM25uTlZXWGZXbDBRSnN4SVNYeFJ0?=
 =?utf-8?B?ZmtVUkh1Y053bnFlUk5mb29GVGhBblIyR0RCV3RlejM4TFJodzBWYlJCakhH?=
 =?utf-8?B?MFg0a2xyZmZsNm9NQkdRZ3pVMXRrYnhHOWJlcU5nNG9pOXpIS1lQcldxVDFm?=
 =?utf-8?B?SVBJMXhHWHdVSDFFaE10S055YytCS0tLelhqeFp3UHhYNlhhZ1hNU0dSbzMy?=
 =?utf-8?B?Z3pkTWhmWjJXcm5SSWFxc0RjN1UybmlndUx3U0huOG9PZi8wNWdnTmY4ZGxa?=
 =?utf-8?B?MXRXV1JjMFJjSFc4cTZLdHR3bW1Zc0NtNUt6b3pBMy9XSEpOV2Y3YXNPaDh2?=
 =?utf-8?B?eFNwSjlSVkNVSnMzYW5QSVowU1NUaUdqaUJXVVMyS1ZJSTVoNUMxckJxc2dP?=
 =?utf-8?B?YnVrc0dlTWNSeFV1WXVUU1dSVHVuQ2k3RUVFZWhEZVpZWkFwT1I3dktJeGdE?=
 =?utf-8?B?RnNsbTZIaTQ0SG5iNUZrMU1zNWs3aW8wS0FQeGhRSENzVWRIbTAvdG9DaXJl?=
 =?utf-8?B?bjB1SUxIL2gzMUl0dnNXRitrdXdPYk9wMTBmK3NWcHQwL3B3TGxHazVvaUlu?=
 =?utf-8?B?VnhnSUp6ZkhYRXJvMFBGOGRFRFV5SEc4ZWRXQjhBRFNoaVZaS3M1SDREYTdq?=
 =?utf-8?B?c3YxdnpPdTU0WTh4M0pUWXd0dU1aYVNsS1hBNENRYVJHWDBmb2xtYTdRL096?=
 =?utf-8?B?WUVpUG9CQlJFOHo1Ri8xc0Q0N0RRMnpveHFYaE9KZzdsTjNXSGVFai91WFhl?=
 =?utf-8?B?SlpZTy9BWkowT0EvQkFFZGlqejVpSUhsaVBsY3FxR25oZzVTK1VKR0FhN2ZB?=
 =?utf-8?B?ZGhxWmEvWmVOZWdwT1dUU0szNlZybk4xL2pBaFFuY1VxblQ1NGR2K1p4dXVD?=
 =?utf-8?B?ejRRRWhvUE5UQks0ZVc2TGUyeTNJczl4OXBWM0pyODRUM3pxUEJheHp1QTFq?=
 =?utf-8?B?T3h0V2pKRHpNaFhBWlM5S0NKMlpnWmxRR1ZzMmQ0TEpRb2tVVUFnM3h6ZzUw?=
 =?utf-8?B?eVc3M1lUYisya3o4NE9rOGJVdE5RNHpiWVNHYnBsYkpqYkRQVTNGL3dTUUhv?=
 =?utf-8?B?eEhQS2NaMmJoOVJ5dWRGRTM3UzJzUWo5aE5BbWtLUVIyS1VCUWFOM2RpKy9C?=
 =?utf-8?B?ZTdObDl0K0kzQms3Si93U01nbElDSU9oZ0hRUGsweDBTMTdmZ2VHb25jc20r?=
 =?utf-8?B?eGFiZk5oOTN6UnRmanlmelpBL08zTnBFdSt5ejNEVHd0WDQ0elF5anQrZFg5?=
 =?utf-8?B?RlNVNjdZUUV1aUtsT3I3OFcvbFpONlBjTzg1MlBxL2pEMTQ4dmZUODRINzUw?=
 =?utf-8?B?dVZKdld5WXFORENqVDJvbVYvT1FWL0w3MVlkN3A4dHE0bmZORDVoSWJocXNR?=
 =?utf-8?B?RXJZbE1RUUZxdjB0eW1BOVNIcmhwa2RRU3FVdC8ranRRZ0wyTGhDZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd69554-4081-42da-5c93-08df391ee24e
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 20:21:32.0424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEdTqR4huGiyfDd+WyJenLWpgkvhiz3MtjC2jh6LeJyQKOkSDj40DciVVjz5q1EQkjGKyKaQseaV6k0ONSpfOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4437


On 11/2/2026 1:31 PM, Borislav Petkov wrote:
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
> }
> 
> Along with the below, which should have happened too:
> 
> 1. RMPOPT depends on SEV_SNP, ofc. This would make sure RMPOPT is cleared
>    everytime SNP is cleared, as it should be.
> 

Yes, that is a good point, but do note that the cpuid-dep only fires when the SEV_SNP CPUID bit is cleared though,
and the IOMMU "can't enable SNP" path clears only CC_ATTR_HOST_SEV_SNP, not the CPUID bit.

> 2. snp_enable_rmpopt() needs to check SNP first, ofc, and then RMPOPT.

Yes.

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

Looks good, the simplification is nice. Two things worth noting:

1). With the leaner snp_probe_rmptable_info(), a probe_segmented_rmptable_info() failure no longer clears RMPOPT inline — it now relies
on the new {RMPOPT, SEV_SNP} dep: the false return (from probe_segmented_rmptable_info()) makes bsp_determine_snp() clear SEV_SNP, 
which clears RMPOPT. 

2). As i mentioned above, the cpuid-dep only fires when the SEV_SNP CPUID bit is cleared though, and the IOMMU "can't enable SNP" path
clears only CC_ATTR_HOST_SEV_SNP, not the CPUID bit. So we still need the rmpopt_init() (in patch 2 of this series) move into 
snp_rmptable_init() to avoid announcing RMPOPT / allocating the workqueue on a host where the IOMMU turned SNP off — 
this dep doesn't cover that case.

Rest looks right.

Thanks,
Ashish

> 
> Thx.
> 
