Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ECD18D64F;
	Thu, 15 Aug 2024 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731412; cv=fail; b=gFOnTleXKWG5nLsT6Hbo8c7A9uIROu8DvgcONGtUwuhPJoVSx5l5uxgekSqBpSRwCuFgrUKboeGVYBf82jrmtWNdsrMFpU1IVzq+aGGvyBhnGew4RxiOImEMAqQX3dlZHihxELh3uUoFQeFTrR2G2ABiBR5XSBmr/M4HOlyI8WU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731412; c=relaxed/simple;
	bh=CyOGeXTzgRDcVtdHBKS5p+C2654L2GuJhhycO72ryok=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=V/Lli5S/XNnfyBC3qCrZ7OD/0RdEEWjpT+c0ePSn0NsRgzuVeS1UiEO8v6kwj6S5fJqdoA8nAXpHm+hIvNk1x2oDKb4Kq4fCqqsd85SPuhsZktIELTxgGOELQoBcTDtHd2DHb5vZu1OA+2Zy3HBcjpubVqj4MeOkT+n4QYcYPkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rXZctyT7; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rXZctyT7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o4900PhAqiB12xhAyldsX5tcb9qzsLn9/eTT0rESm4iY1lXovunBR2Yd+7Srmnma4OtTYcrer6rcBpNSDV/PfHLq1k8Wzeo7wyyrWNQvgkjm/knGQajyD6OpNAVeJhJ+aJ+FA8Pnoixfuekj1pL4FUBWBQMoTupKxuTquuXqZUcAzCk7pTex3WlGXctCTGEiRvDLA/GKwykzBmHaSbop1vh0H76pr1hK+rnSK25QPnRqhCOqOdFkJ6SFH5n6ZD+5iAlbYr0JMO8BYkLndCvobGG4Z/E/gYzuLTMZF+o0SUp2JXUrmsGn9T/9JWYekI0OZxW7gqSfDr25AFuoqOe7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KnmcYFN63qQdMJbtMpnXXzn225898Xe5tZBNZIT2sQ=;
 b=s9O1/aHBFAV/42e9pefF1iGgqNr4JND/tWkzLp1WS30a3oP8tZaCXocaAI1AimR9izBdHmJOf3XbzWuT+DqyF1Yq1pc1Brlz3t9o8eH0Q834lNHezD1ECgxQaIwgm276EcRBR9eN5QgzcHZ8jpRNDj7P2tg3JQJKtHXM2H3VfKJUWlimifHUomwh9uYwlGXh25R9DBJYkbsza11CT7KN/avVHuRz6pMO9qzcIcvXn3GWfJ+2+qBRlin1kREwCUrjOqfaODbEcwb3667UK+QGhCA9dhpYSGqLB+sXJsjVdwbrOlg2aC+aVxzqd7RB6mV2EmS2xBx42Tsj7aWJXQ2juw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KnmcYFN63qQdMJbtMpnXXzn225898Xe5tZBNZIT2sQ=;
 b=rXZctyT7w9LOVb53rSECtWMBEX2UpJ4LyoaWmwyaCMBeAacZJaZ56Qr71SRcMjU/0zj5iswiaKGfAWKwKsHeavtgm/i4N0mz+4vLhekyEZrtE3JNoAQRBTYjWBXtMFCCoVnMP1/LeRKT/srT6ahUnsfVyTcAZSMMRum6MOtXQ0w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV8PR12MB9419.namprd12.prod.outlook.com (2603:10b6:408:206::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 14:16:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 14:16:47 +0000
Message-ID: <0561862d-99d9-ae72-49d0-9ad0639482ea@amd.com>
Date: Thu, 15 Aug 2024 09:16:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Diederik de Haas <didi.debian@cknow.org>, John Allen <john.allen@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [BUG] Non working HWRNG on AMD Ryzen 5 5500GT
In-Reply-To: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0206.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV8PR12MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: 6874310f-9187-40ea-d537-08dcbd34e5c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUV2UVB6SWZxQkd1R2phUm85WGFiYlRRamlqTEwxdDlBMjVYbThoOVNDU2Nq?=
 =?utf-8?B?aTI2TDFmMHZDeCtPbWxIYzVwb0tER2wwcDZjOTl1eVpNYS96OGprT3FxR01t?=
 =?utf-8?B?U00raUJIeTlTUXJDY2QwZTJOZzg2RUszQzRnU0ZtcEVaenVIVU9sNTFmMVls?=
 =?utf-8?B?bDBkSkphZFZoaENOY3Zvd2pRcnhKS1JnOUNPVFEreHg2NTFDVXZ5YVM1SnUz?=
 =?utf-8?B?MW5NSnZpUGViYTlTZloyWGk4RFpxTkhDSWYxYnpJN2x6TEhlbjhjRVg4VFlP?=
 =?utf-8?B?TTdsWUlULzVWUkZWMDVGVGJ2ak5nMlE5aU0zSFgwSmhrRkhOUjlCeFZRTGp1?=
 =?utf-8?B?Rk9QVTJqV0Q2L3M0RjhYKytLcjcwZW8rREd4SVdkYnYxY2NyWVFwNTB0WkNX?=
 =?utf-8?B?OVp4N2lpYWhDZGMxQlFwTE5LZUhocGljZXNTbUwzTDlabXM0M1U2M1Zta0lP?=
 =?utf-8?B?Z01LdnRwUDIwNjZ1MFc3TStkU2UrR0FKWWlvVENJVkVpdENGQnVXeDNiWkxv?=
 =?utf-8?B?KzY3eFY2eG5XYXkxQU1BYktLZi9hck5GSVJtWHBzcnBjUUNuUTk0N2o0ZzBZ?=
 =?utf-8?B?TW5HKzVOd2NlWVNKUUcrWHpSSXF2SldOZkJGV2xhQnRCWjk3dkh6NnkwcFJy?=
 =?utf-8?B?Um5BMlkzdDBRUVJPcmtTMGFoRHRjOTZCMGxNM3Fub044a1d5amNGVC95U0Zh?=
 =?utf-8?B?RmNWUXZlZzZIR1ZDaGw1ZVNmc0JFeFlRQzl2RHIzUG9XZWw5L0ROcHY2ZEx0?=
 =?utf-8?B?U1ptWnZWcFFYTXdNQVE1Um9HK3pPN0Q3Vno3c0tiWDZGNlk3dlZhOUQ2UmpD?=
 =?utf-8?B?YXFmYU1pT0ZLR29HcGlzMENFR29FT0kyRVpjU3RCdGtRajRpLzY1VWJLaDE0?=
 =?utf-8?B?Z3I0QnNySFJ0T2xpUU42eGRoNVB0anlXTTBVYmRQRmlsNlRkcnBUVE9BS2lC?=
 =?utf-8?B?YXBQWnQ4Tk5wRkRmaVlxeWQrd1A2bGRxdG9ISnBkSXVSZ2xvQTVheGtNVm5u?=
 =?utf-8?B?aEFmQ1dvRGs1UG5Lc01mdmRBa3hOMHVwWFZ6K0ROVjBRWUJERUlCRnhmTStF?=
 =?utf-8?B?MDlXbGlTclNEc0NzN1VuczZiMXVIRWlKbmZqRmxXK0g2b2tDUzhjN05YQ0VS?=
 =?utf-8?B?cVh3aStRemNMalpHVnBEUXVmMmhjWUFWSkk4cmRxQXZXVUJBNHdlR1FZWmxB?=
 =?utf-8?B?UldkeTJ1WWRvMDU2UCtBWmZNWUdScWJFTWxFTUowWXRoRmFFU08vMmY2THlU?=
 =?utf-8?B?UGZUMjlwSHcyb0tNZlA2VjM1OExNeG0yVE9Wa3p4amx5Y1JYNElWazZyK3NJ?=
 =?utf-8?B?QnM5b3RPNlBXU0xJUzhQZk5UL1d3RmVPQnBYeHN3SXdRdkwzOXhmdzFnKzZs?=
 =?utf-8?B?RTcxM2J3VmoyYTRnRFVBcVFHd0pzcHJyKzVIdTQ5eGdra2VDcWJmVC9tUURZ?=
 =?utf-8?B?Wk8xQzJOTVFqeWF5STErUEZEZVdZTlgraWFQUXJWSk15THBWdjNFOGlBbDdn?=
 =?utf-8?B?N3EyYTB6MnA1WDZ5dWZNMlFvRXpEaVVGT1V6bC9XbmphWFhyQ3VWRzkwamk4?=
 =?utf-8?B?OS9pQjRwcjNtRzhuczFGRGNjWnozSkptUitXb1kveFB4YWZiK3NDcmJHM0xN?=
 =?utf-8?B?RlIyeTJXZ2hSVWlaVGJZVE5VMjcrdm8wOW5lampLaFp1eWxjMUczY1FIdy9O?=
 =?utf-8?B?dTRQTTUzRE96aXZBRmhuT2daWEdTQ1RlcElzNVphb2VDSnZvcTFOdVlTYXFY?=
 =?utf-8?B?ZlREZVJFM1Znb0hsdFUvRHl3ejRlbDkzeFQzOWNwbnlVSUR0YnU4cGp0emZy?=
 =?utf-8?Q?d9ZRpDqsLZ3kC6Y9n2fgZHmEbWTl7cFvCr134=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEFadmZ4aXB6emlESzBYaDJxcUJlSzlISVY3aXJUZWlKLzNKNU9zSHhoR2lh?=
 =?utf-8?B?eVVYUEZnSkJyRTdiRnIwS3l2QXRVbHRZWWU1VWptcUtQWGQ5ZzZydEJOeUU4?=
 =?utf-8?B?NkdZRzl1QWxjRGJDem5OZlUyd2VJNnI4YlpOZHhYSFNQRUsrdlRIUGszL3Zq?=
 =?utf-8?B?KzBqM1VrV1B1dG1DajJkcXJySXIyRlN6OFcwa2pPY2YvV2UvU3BIL1dvYitp?=
 =?utf-8?B?dldmWUxYRXlvN3hnNnEyUE1nOVZna1JacTFWdmxTb2ZtbUR4WndNaGdBVWV4?=
 =?utf-8?B?MElUeHFlamdxU01qOEtTa0JsUGJrMjIrcmZnK05BcmZkUVJsMi9aVi9DTWpN?=
 =?utf-8?B?QmdyaEMvU1VLMWNicnhtY0hKQTR2WFMzYWdnVlFRdVcrSC9RTkRGQ2U4ZzF4?=
 =?utf-8?B?a3lDbjcvbnZNdUlkS1ZBRUYyMlRhTnBPMmU5ZmJEYVgwejQyQjJwcjdDTzkv?=
 =?utf-8?B?U2RicTFhOXNHSmxqa1Q5c09HVC9ESFVkQjd3aFQvRm5KQ05MYWVtSjVLZ3Ri?=
 =?utf-8?B?UzNKUWhsc1hrWnZET3ZCaEJjZCtpaVdNbkU4R1RxRUsyQ0NzWXk3MzlhZ3do?=
 =?utf-8?B?WVhLdG95V0o0eHNyOWc4K2lwZEpVNDEvcytnQ0toaC8yTnFGQ3FtT2xPWGZT?=
 =?utf-8?B?N2xFNFZWa3dUVWdvaWFXeHNHUzRXcnZ4dFdqY0ozczA3YitBMm9iMTUwV1RF?=
 =?utf-8?B?YVlLaGtaREg5dFg3b2FnemVubW9EckVia2RHN2EyV3M1ZHQ0aWVmZ010azNn?=
 =?utf-8?B?eS80SzNqelhaWjBaaFR3bktuMGZZOVg3WU5EKzlHZ0pRSjF5TVQwWDlPd08w?=
 =?utf-8?B?WGdPSGpUejduR3QrUFRvSTlIbWJUV2dsWklKYmF3RkVLamRKbzJuUGlKZDlZ?=
 =?utf-8?B?Q0s2aVlqVXlaZCswcUhOcUtsenFCeVlrTnFZaTkzdlk4UUxxUDFXM21LbGJY?=
 =?utf-8?B?aERtdmdOT1Q5MzlTNkk2VS9wOHJFdEtBaXYrUXcra3JnYmJwWlNnellXZlJK?=
 =?utf-8?B?dzVYTkx0c0FZbzdjdEZzS0VZczFoSGxpVWZYMW5qczlxdXJ2YVlyYk4waDRm?=
 =?utf-8?B?R3NBcUZYamhsTk1Xbll5Nkx4cGJNdmViNWxpbW9RRm42djRIQzVyU2s5dGt4?=
 =?utf-8?B?eThZSWxxL09YYzBDTk1DbTJJQ1JiT21QbW5qbk52dlhpZmltT0x5Nnk0Rm8y?=
 =?utf-8?B?ZzRUWGR2L2RRVEtxa2ltaTZRSktFS29KWUI0T3hTKzBvZDN4WEdnS1Q1Y1Zv?=
 =?utf-8?B?c1RXZlk3VC9qSzVXV2FqY0FSWHFzM2xEY0pKb1FsQVhFUHNXNTVtd3JzSTZK?=
 =?utf-8?B?eW9ONXVtQkR0WDl4eFJqbUFoa2lqRGJoZlIrS1p6NWZrWEFiVHlKdnZTWTk5?=
 =?utf-8?B?bjZQaGs4SDg4VVVqczRzUXZreFJFZVZRVkJmMEpqYjFxNEhMK1ZQZmowYzNO?=
 =?utf-8?B?dDd1K3dtK05MMmpXdzlzQjczUnZlY3l5eTZSNHdmYUE0VEdUME1vQU12ajRD?=
 =?utf-8?B?V2hFZnFNQnRFSGdTVC9lU1V6a2NNL3dtZndRRi9sQytmWm1CdXJwMlVFYyt1?=
 =?utf-8?B?ZmpEQ1lZU1BrOWdzNlNPWXo3clZ6NHQ1NzRyNGljT21SWHBidWhZTWU1dDdM?=
 =?utf-8?B?c3UwQUVsRDZ5dG83Wi9IRUNrTXpuU1dYMmg4emJhaXNOMkNteVN5N3dGeWh0?=
 =?utf-8?B?WEpURjJPR3pDVXVtRW9UOHVFK2lHTzNUUUM0eXNNTXgyODZvK0FTV0tsT3NP?=
 =?utf-8?B?REIvSGI4eFB5bzQ3cFVDcjVtNThDS0E1czlDY3g1djE1OStqVi8vZHFIVlA4?=
 =?utf-8?B?dTdMK0hPdk9nT3dhUUl5Wkl6OHZ6YnNCZnRrMWVZWENpRk1nZjY5V0pwcHds?=
 =?utf-8?B?TU1OcUtZRkRZRlVkQWRjVkRzU0ZNV0FTMVVVeUYzTHJHTFZiTmpNWFltSmwy?=
 =?utf-8?B?ejNlMUxNZmdMS2hJbVJMZFV6KzhnUFVpaHRSTkdabERXaEtoQ0U4TnVRZXFz?=
 =?utf-8?B?Zm1Jcml4cC8wZXhSSk0zL1BISkxGZGdNY0FPM1dzcjdNVExXZUFMTTRUNS9i?=
 =?utf-8?B?M0g3UU1EcUlJQVpFd0sreWdyZ2daRjdyL0VURTRSVTFJUE5WZTZQeURLUWxB?=
 =?utf-8?Q?vNcJiqoHcOJ7wElbYP+K6GFQl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6874310f-9187-40ea-d537-08dcbd34e5c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 14:16:47.1974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+L719CSMEV5q5GtEM1A2HAZ+Zr8ZPKJCJIxRIh7Z0FpQjkN4iDXTqH22YwCDpIzKmvOdgo5SaYIxaOuk4/khg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9419

On 8/15/24 08:56, Diederik de Haas wrote:
> Hi,
> 
> I recently bought an Asus ROG STRIX B550-F GAMING MB with an
> AMD Ryzen 5 5500GT CPU (and installed the latest BIOS: 3607).
> I'm running Debian Testing/Sid on it with kernel 6.9 and now 6.10
> and it seems to work great.
> I've been doing some (unrelated) tests with `rngtest` from the
> `rng-tools5` package and wondered how it would fare on my AMD CPU.

I'm not very familiar with this test. What is the command line that you
are using to invoke it?

> 
> And I found out it doesn't work at all!
> But on another system I have (Asus ROG CROSSHAIR VII HERO MB +
> AMD Ryzen 1800X CPU) it works absolutely fine.
> 
> # dmesg | grep ccp
> [    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
> be running a broken BIOS.
> [    5.401031] ccp 0000:07:00.2: tee enabled
> [    5.401113] ccp 0000:07:00.2: psp enabled

Which system is this output from?

Can you provide the output from lspci -nn?

Thanks,
Tom

> 
> Found an article [1] which could be relevant and downloaded and ran the
> accompanying test program (written by Jason Donenfeld):
> # ./amd-rdrand-bug
> Your RDRAND() does not have the AMD bug.
> # ./test-rdrand
> RDRAND() =x47c993c0
> RDRAND() =xec7c697d
> ... (more seemingly random numbers)
> RDRAND() =xba858101
> 
> I tried it with the latest microcode dd 2024-07-10, but that didn't make
> a difference.
> 
> So I'd like to know if this may actually be a bug on the kernel side.
> 
> Happy to provide additional information or run tests or try patches.
> 
> Cheers,
>   Diederik
> 
> [1] https://arstechnica.com/gadgets/2019/10/how-a-months-old-amd-microcode-bug-destroyed-my-weekend/
