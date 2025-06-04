Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6779339A1;
	Wed,  4 Jun 2025 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072725; cv=fail; b=eSsLkYAI4xkLAld9mVnph03I65eMuHKGUQBwbCdULreY8kXNx6eusDg9zg1HaKqvjGdVeT3ektM0Co8zBI3iVqitHq/SSQeWTio3lhDu40cBw+w37uhhJClD+b0MQ+osUbzfUtnjr93bJGGRygxgXWJd7sHHEwphdfw7VsdP5rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072725; c=relaxed/simple;
	bh=pQehkr0QxMGCAW0e7cJuDyXuMra29KvjbtcnL3H6J38=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AtEO3f/3sk/aJy7WPBbjC7RkdmTKZLX176EuLf2DhIP+lRmgg5GVsne3TCNqUgQbWlZf8ywtb0cqTShluW6L1AcK0hFm6Nxp8U7PYDxLkI7GCZS6bAevyTUZjgLjJ7TOkgQmU1d5wBFAEu4cmYnlnjZxh0PN/kKYK9BRInHw/po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jF8MIvsE; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jF8MIvsE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZsZ4q9felOm3VaStHClvqcmMYE8nvwAvHDzBANGMETCVzfKCRxf0IL17nqZPe8bQUHJ8lGl+3BUD+EUewF2LQkmx8j9Io2v2IZpntk7VezLlMKPHt95u8ytypWJv7H28iVUJfOMlZF937UFJhyTpPR92vlE0d6WyMCGXdwjBmHMhpMzONr7jvvL0gJGGybzKwsqaDHITzGblq4QIbyoqA5ZiIgHLJp/DvJD/DPSnYqZDrQoTgq4STC9ZRoVruj8ER/roK7vik87kyTzl3qIyNM3KMhCZU0exdpien9uEOKZt9HoBHSf8/UD5eySs1XtI9VfMKj7bsYJD47KUtcHoAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JofnGBD8+A0mIxTF8+P72AOhQyBdtSSQsQbpWUdZVPw=;
 b=S8Zjhnu3Hs6VeefdXWVyWOJ69Vb6C4zXCORjyxV6l+NgModMBBN67b2dLhLwhG6tcr5si9vPhGEYY00HQDncRMzwesf6iYNqIiRdAQJLflXx7Ih2j0XxCZgWjMdevmFsTinLgd11CAA57yrRtkXWM8/FMkcc9oLPsMcIqr5PHSbHVV3hVKH+tWc2Py2z5rZ/mhLy62C/a8XYkHQUSo7aggj9fqeIHU1ZineurnlzBdR4ZkHybtklf79X9ynKD1w1Aze3wnMYFt5sOQa3LpUfta3/m8eg5+FXm6l+cC4Z46f24oa5ThAH0beDT9yb/4pY2rtKq/n9tk4RSXH3RI1uug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JofnGBD8+A0mIxTF8+P72AOhQyBdtSSQsQbpWUdZVPw=;
 b=jF8MIvsEM/SIvIoxiphB7FWxOEMCZt3liYQCnmP06sIA195bGtH4UbL2NW+sEh4SzSpYyA9SRd5JWf/W6uR38ytqR8ejOXzsOXg/4KaymiOSv34uR14IbGMIZWPUm02Tp67Ou9xSGVsg5RWJXkJTGVdHEbH70HVs5XchQmrqGms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS4PR12MB9657.namprd12.prod.outlook.com (2603:10b6:8:27f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 21:31:59 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 21:31:59 +0000
Message-ID: <57aeb651-b7d3-49c2-a4ad-056529f62a62@amd.com>
Date: Wed, 4 Jun 2025 16:31:56 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Fix SNP panic notifier unregistration
To: Tom Lendacky <thomas.lendacky@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: aik@amd.com, dionnaglaze@google.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250602191017.60936-1-Ashish.Kalra@amd.com>
 <8cd27c20-6439-deec-f09c-e4f6f789761c@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <8cd27c20-6439-deec-f09c-e4f6f789761c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS4PR12MB9657:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c066f84-4286-4725-cc0a-08dda3af3cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zjd5S0tJYXBsWERWMmFENnRUc2VGWDdQQkxoTElPbUk2WDdJSmliQ0xsL2ZT?=
 =?utf-8?B?QXcyclJUeHdHNjhkWXZjQytvS1hIelBRZU16VHFUTnkvZFowcGQ2MUNoT2lJ?=
 =?utf-8?B?QmhWSUhDSXRsM2VETmc5QVFaT29UVTJjcENUbVZ2T0dPU0hCQkx5WldlTyta?=
 =?utf-8?B?U3lOeUVzMThsOXFpdEhZdk9tVktMWXFwVEVmSmVhNkpYSWVvM3k0b0lvRUYz?=
 =?utf-8?B?aWV0UHRVOE0vekJpa0pQaVV5YndNbHVIVTRORFVxQnNhNmsxNGF5UjdnNm5m?=
 =?utf-8?B?U2k0MjVJeHlCUng3U0JOQ25uU1JFK0U0RzVwVWUzUlk5QjNzc3RFOXBubytI?=
 =?utf-8?B?OTU3dkI1bXl6MWFpSWp5d0ZvQW5zcFdEbVdHNFNYOXhhbjNIVHNEY3JBL1cr?=
 =?utf-8?B?LzdLVDB6d3d2MzNZVENXMEdGcE5vbjNyeUlrMERGcG5VNzgzMHQxNkZ1bDhX?=
 =?utf-8?B?Q09JYUVCQkh1K0dGTjU1Y1VCMDNlTktMdTV0WE1UK1BIMUtVN2Jld1NrT0c2?=
 =?utf-8?B?aWt4bjV4VnlMTGM2LytBeStFS1BabFZ4THN5N2k2eGFvSEh2emxkTlkrYmI0?=
 =?utf-8?B?UzRrcWk0YlZ1T3NibWY2T3VUdmFyQVdqTXMzYVFoRFhmNHMzK29JUHArMUlT?=
 =?utf-8?B?ZU5WRVlFam5FbjJUZ2ZmQkFpM0tkTnJYZW5UVGNoRVFhTDVsUlR1TnE3bC9B?=
 =?utf-8?B?bTM3aGpZc00raWw1a0VvRTh3N241L0NNWVhxbG54S1picjk1ZXM2VEtVUURG?=
 =?utf-8?B?bWZQSzRaWGlsLzVlc1JrSm56S25tbWtLUTh5YUl2bFNqcUVDSG9Gc0FlNStj?=
 =?utf-8?B?enpWek1HU3lmVEhzUzZmNGVFcGt1SW9XMVV1M29UU1cwWkVYZWdkYzYyVmxD?=
 =?utf-8?B?MFpUWGhUYm5vajhBNUpWOGZqN21nOEROUFR4VEFTL0RIU0h1SWdYQXRlcGtX?=
 =?utf-8?B?YXZFZDVzQ0cwYjZQMHR2U1l6WDhXYWdyd1R2UXV0blRnVTMzaXdkMHFnclN2?=
 =?utf-8?B?elBQMEw1Z2xjMkIrTGtra1M2a1k1K3pjcmtDN3VvblUvNmRIMFZqYXVSZVZM?=
 =?utf-8?B?OS9KS0REUHk2QWJNb2ZlVWtjblFnRkllTFNKTm1BME9Sd3AraVdzNVcvbVE1?=
 =?utf-8?B?V1lZWFJMYWxPTGhzYXVpR0hiQnRnaVQrRVhxTWt0bjFCeWdWZnlQYUpkTGty?=
 =?utf-8?B?MllpQWVsZnl6dWRHbEZGZnQzSXNkNUdtNndlTjl3YzB3WCtMRVRPZEVJTHJL?=
 =?utf-8?B?L0w2T2dUSlFkM2Y5MHRMRUxjTjMxamJHZll2NDd1RjZRWWw0RXQycit0M1JR?=
 =?utf-8?B?U2NBNWY4Vm1IUGVzekpiYXNkSjJFWnhWaDJzTWE1c1p5U2RQRHdXK3MxM2NN?=
 =?utf-8?B?RHRrMExtZjJUZ004RlBMcmlBcmR6ODhURTdsdkdYdHZ4dGxSdVlRZ0w2YVMz?=
 =?utf-8?B?d2NXSE9nTG1MbTFVaWp2UWxlSFVEbGtBeTV3T2NlZW5aaGYxYXZrUDFXWDI0?=
 =?utf-8?B?ZE80WTFnL0krS293TWQ5bGpQRk9kWjluRHRyQnNZUXZidS9aaUpBalljRjNH?=
 =?utf-8?B?aWtneXlySnNxWXI3dEFFRkorSlZ3WFpYNXJaS1pNME5hZGkyK1ZySG9mc25m?=
 =?utf-8?B?bVlJaDMzWlBLdTJtekxSeEI3Z3p3aUtiemJQQXkwZjNKcldZTVh2cXdrU2ow?=
 =?utf-8?B?cmFtQmZya0tsUGNvUFQwZ01YMGpDSG41MEJFZGxPamp2bVBpZzh4cjBwUjFo?=
 =?utf-8?B?QXczRGhzS1gzbXROSmY0aC9sajN3cUVSNDhMRHlZU1hSSzFoWFBGNDhyNFcw?=
 =?utf-8?B?YnEzQmtkOEt2RCtnd2tHelJ0L0dKZ05ubGlzOUxtcHFmYlc1T2xBZXNCdTZE?=
 =?utf-8?B?Z25sWDlOdDArNnN1QWRXaDN6M1ZFc0pyZTZ6ejR4MnVFRXdiNHhyUU1RVXZD?=
 =?utf-8?Q?rgywHbVA7no=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUxCcGM2SkFzRjB0VGxhNk9jTkt5Rjh1Tm5KcEUrZ28raWtpZWxNRDBGZ2Rv?=
 =?utf-8?B?TS9WcjRyRE5pem5TTWVCZll0NVI5N0FyVVlUUzQyOWtyN2pjV0l4RDE5WTJU?=
 =?utf-8?B?dkNWbFg0YTl2Y2twaTBvSFpURUc3SUFxb0YvTEFINW5kSW4vYnpGc09NbWJx?=
 =?utf-8?B?dVVNRUpTK28yeEJPMDY1VmRQbEwxcHlCaE8yL3J1WEU4NmdHdG93dHM0MVNs?=
 =?utf-8?B?Q0l5a0pVd05KOFZDWGVTWFJ4M0Z1dE9VL0pTRVdPTmR3aE1WZlhqZ2ozdXBw?=
 =?utf-8?B?UThZWVo3ZHZFaEg4elE1enNOdXdzdE05bjgvR002SllBalFBQytsVFBabXVJ?=
 =?utf-8?B?R2ovejhVU0oxNS83MjRHVzllMk9xSThucFVSZmcvSXgwSHlwYlM4U1BHR2g3?=
 =?utf-8?B?clBUTnJWempadStSbjNCcUlxZGZiMVd1d3RxUlRjZWVtYjFUOEdXUDl3VzY5?=
 =?utf-8?B?ekdCaVlTd3AzV3oxZGZUUmdETStSWVE4NnQxVHFZSzlKaE05Q2Q4T3pzM2Nx?=
 =?utf-8?B?OHRPenlpSk9sOGUybUJYdXpQUWRCOW1ta25zT3ZEM2ZweXN2K2pveFZWN1Zn?=
 =?utf-8?B?ZjhuSkQwUk1jY0tLaWxaWC9naWhwaStrVjQ5Nmt4QjZpTXFVaDY1UzE3WXdY?=
 =?utf-8?B?V2ZuWWFRb1BLOHhsOExTTGhhaWJ3akNjVUIyNzhVSVFyWHg2by91SW15b0U0?=
 =?utf-8?B?eTdIYnRYVU02VjZYa1JFbUFNeXV2VG11KzdvVmFEdmtsUS9VNlVBYkQ0UG9D?=
 =?utf-8?B?d05XeER0d1ErajZkakMwVWYrOGNHeGM3WjQ4Tkp0YmxNbzNYMjZDNzVzMlQw?=
 =?utf-8?B?TUdhZGRqTUdrZXNQTDNoeFhINDVuQnFnbklDTnZGdWMrcWZoVGVxakg1NlA5?=
 =?utf-8?B?TTVBQXgvS05EY2FHZTFqQnN3dmsvQWNKNzVCMTNrbXpBQzUyTUt6MWFNSnZJ?=
 =?utf-8?B?QkdwcW9hcTVBYmRNelg4V1RUVjljQ210WHcxMVIrYTZGaUJuSSthRWNoa1hW?=
 =?utf-8?B?T0t5c0JFMVU1OXJiS2lUMmJoSHFtdW9HQ0pOZUN1MUJXdUE5OXpYRW14Mjl3?=
 =?utf-8?B?SklCSkNMam8rTVQ5Yk13ODRDWkppYTNIM1NySHNyb3N2cFlYYkVPZ2VUcU9C?=
 =?utf-8?B?QXJZSTNqb1VjR214US91K1doVnRMaXVJaVZaRThCcEJpSUJMTTZMZGVvakNN?=
 =?utf-8?B?RUF2Y2tFb0hSUjhFVk15UFJkWUVwRGgwRnhzb3U0WE02UG8waUFadFJ1QW8r?=
 =?utf-8?B?MUlhdWJ6RFBrcFFkWTRURlNBRWl2Rjh1Z3FPQVQ5cnBKV01sSmRHV0pyU2sw?=
 =?utf-8?B?R1F6eVY3QnNCaWJPVXRXaU5YY3ZLRzhySzVrNGpzUlFTWUxYUjRndDlUNXQz?=
 =?utf-8?B?eWtEREZ2UE15dnJya3hUTm5EajB0UWVuQktLVENwejFqdExsOWpta1BNclk2?=
 =?utf-8?B?cS9rREhiZVdHWG1RaU56S1ZlY3YzVERaL0FtUmNHM3UyTjY2OG5vY2V4WFVx?=
 =?utf-8?B?TjNhTjNlMTNET3V1Q0tmRGw2RkViaXJhVU13K3kxTyswdDcya2krdHpBdkFW?=
 =?utf-8?B?NjZQMVA2cDMwYjl0REc3c0xsUXdkVEd2V1BHd3ROenhOSXRycHdVRXpJa2hh?=
 =?utf-8?B?dzRwS3NPK2tLWlhTN1R4dHk0S3VtZWNnRDhSM0luMHZaeXltNVlqVlVzcVBO?=
 =?utf-8?B?cXhnVk9nV0wwaG1SdStkakx6eVdFczVsRXlISldwWDNsR2JUS0Z6ODI3eTl1?=
 =?utf-8?B?RFVQLzZGWHRrWmtyaWR4eVFNZm1jV3JNeUdQNi80WVljcGlhQmc3b3FCeUlj?=
 =?utf-8?B?cWw0bjdNeCtxRmlxMkNJWHhCR0VuS2Q0dTR5UDEreVZvTUt3bFh1ZFVVZkho?=
 =?utf-8?B?emFnNVd4Mkc0b3ZGNEZuai9MYkJ6UzhQdVR0dm1tbkNBRXVrSUNkVE9DZUhv?=
 =?utf-8?B?ZVlaZkc0TWY5aE9mN3g2OHU1QmxacXpybkxHWUxRTDlGQXF0Sk4ycy84ZVJy?=
 =?utf-8?B?TGtMY2FGcVJzQkRXa1I3RklZayt0cUVVWXpsR2dPWmQwc3lwcWlCUmR3Qy9L?=
 =?utf-8?B?eGZ5UjJDajJkTm9ZWktacjVBM2x1Q1B4c3RWT2cvSFVMTExHR3FjZVNRQjZM?=
 =?utf-8?Q?PpS60fv1wyH5w02ptMDTw/hLg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c066f84-4286-4725-cc0a-08dda3af3cda
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 21:31:59.3725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3TT9raCADf6WW5ZX8Am0ZJ8tezF2FPs831yyyjdv+y5mYVEUxXQ51W3N8HtSFojd+6L+Otk3Q+b8tdgS/NA3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9657

Hello Tom,

On 6/4/2025 10:57 AM, Tom Lendacky wrote:
> On 6/2/25 14:10, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Panic notifiers are invoked with RCU read lock held and when the
>> SNP panic notifier tries to unregister itself from the panic
>> notifier callback itself it causes a deadlock as notifier
>> unregistration does RCU synchronization.
> 
> You mean that during a panic, __sev_snp_shutdown_locked() is trying to
> unregister the notifier?

Yes.

This is the code path :

snp_shutdown_on_panic() ->
__sev_firmware_shutdown() ->
__sev_snp_shutdown_locked() ->
atomic_notifier_chain_unregister(.., &snp_panic_notifier)

So atomic_notifier_chain_unregister() is being invoked from the panic notifier (context) itself.

> 
> Wouldn't it be better to check if a panic is in progress and not try to
> perform the unregister?

Yes, actually it will be easier to do that by simply checking the panic parameter in
__sev_snp_shutdown_locked().

> 
> Or, is snp_panic_notifier() resilient enough to just always have it
> registered / unregistered on module load/unload?
> 

For registration it makes more sense to do that only if SNP is being initialized and as part of
__sev_snp_init_locked(), for unregistration see notes below.

> Also, wouldn't a better check be snp_panic_notifier.next != NULL during
> sev_pci_exit()?

Actually i can't use snp_initialized here as it will always be false.

But i also can't use snp_panic_notifier.next != NULL, because if it has already been unregistered then
snp_panic_notifier.next may be non-NULL as unregister() would have chained it to the next notifier
on the chain.

Actually i can simply call atomic_notifier_chain_unregister() unconditionally during module unload as it
handles the case of the specific notifier already unregistered and/or not added to the chain.

Thanks,
Ashish
 
> 
> Thanks,
> Tom
> 
>>
>> Fix SNP panic notifier to unregister itself during module unload
>> if SNP is initialized.
>>
>> Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 8fb94c5f006a..942d93da1136 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1787,9 +1787,6 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>>  	sev->snp_initialized = false;
>>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>>  
>> -	atomic_notifier_chain_unregister(&panic_notifier_list,
>> -					 &snp_panic_notifier);
>> -
>>  	/* Reset TMR size back to default */
>>  	sev_es_tmr_size = SEV_TMR_SIZE;
>>  
>> @@ -2562,4 +2559,8 @@ void sev_pci_exit(void)
>>  		return;
>>  
>>  	sev_firmware_shutdown(sev);
>> +
>> +	if (sev->snp_initialized)
>> +		atomic_notifier_chain_unregister(&panic_notifier_list,
>> +						 &snp_panic_notifier);
>>  }

