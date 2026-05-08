Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBDE37BE7F;
	Fri,  8 May 2026 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274661; cv=fail; b=bt+DkadZCKqTIHvF0gvEsF4+yr8fDw79xlVYyACMESH6aNkiN2ZQVzn94P/eUw2IF/0m3VxhT4ec+xH0uZEcX91Tp7iJ6IcY3UycSzJFNqXEahHoL2MVmeUtgMD6eaDK523plJ8/1mmv9kCN23KthfoVYxDiV80h+reuiO8giQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274661; c=relaxed/simple;
	bh=7GmfDJVxBvWwvVelT54R4YO0oc818Fgmbp1mj/V0LsE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NolKjvPjacabd28G5913oL4a940Ilhw6roUOmWtEPsBpTmc402bmvCgV9BILQ8dz8Fl0zxTVWD5uV+fexaQUHbyvwhOsWagMp4dK1cl+aRVChsYlS1dQkXpi2S2Mufu+pjI324vJw3si0FyIOwuHyacH9w0ValfrrtLhLzISNxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k4jnnT6R; arc=fail smtp.client-ip=52.101.53.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k4jnnT6R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHLH4FDxdYCeNQD+ZkOtVJVrOxwtN2gT7CxUkU29VqjGq+Fw7kv2R+aASxO9M6OvZUln4nSGfh0nwiYRP5KV8TNm/IrQ5TgWTZSH28a0+RHzvM30RKuvQH3j3XR+1frQCDZH6d970naFTJzyEZ1rj6A+aNwZ15XnpR3xKUY+4/TKyU85kxPZtzI1YykauevvFmvgKi3OrS2zbsUpZfZLnYDhDpkpjecc2dJCXDtndqwCndFrEgNkoNRPMu8a3OlTcXfBmsN+Mxl78MtpUr20wmZ7aSfk7qLV1+S5XHfAPkCESubRBzvqqGveNlNDTQRv89f09HThS7IZ2mbsnD6OaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISGxXX7Kbj/+l5U/3c3RGJtAyBp8uw2KHDfvJB3K8ag=;
 b=JP/O8zsiuugogl96fTGevefL00SIHKFx72SyyxO27X3iV8Qlkrd9H46AKNNYYiYTz0itRGHVffKtMDV2K3IcCRELG9NWhcCqavLB/N3kXARtgGT7j3c5I1IVsFepHY9/17381SbSuJhVpDSKInKYqoeZetTm3lA1+i1NBRypxpYWNP9miSVMiZ+LPJ/2Pg1s5fkXWhx1ylzNaQZmLdfglRLt07WuWLc0LseUr+wCiyyh72mT7tdZOUy3BScfLHp7O+4noF7FxOX84dAnkKytHSAU5sfEsSeQ9TvpVpadcevXCvU3duZTlMqqzD7OSaneeP6SVnhi4cHFGaC+ftVx8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISGxXX7Kbj/+l5U/3c3RGJtAyBp8uw2KHDfvJB3K8ag=;
 b=k4jnnT6R4w3NfnwdGdyZMCRjPQkGfEOQLtZnCh0S0idjTtmANn25kUKX7acJ5MZW4l3iWDU48OeQuqnOmq6aXf0Zz146LOoRsMGPFNI3R6Hd6IOAnzalpj8GNQWHvB6yWiqxT2euZT7BYPbbNKdBCtfOz6/FNGDbSin8KfQtTns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by BY5PR12MB4323.namprd12.prod.outlook.com (2603:10b6:a03:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 21:10:56 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.20.9870.023; Fri, 8 May 2026
 21:10:56 +0000
Message-ID: <673592c4-8eca-4b84-9f60-7020327d1afd@amd.com>
Date: Fri, 8 May 2026 17:10:52 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tycho Andersen <tycho@kernel.org>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 nikunj@amd.com, michael.roth@amd.com
References: <20260501152051.17469-1-prsampat@amd.com>
 <afitM-Ub50JsTCHz@tycho.pizza>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <afitM-Ub50JsTCHz@tycho.pizza>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0340.namprd03.prod.outlook.com
 (2603:10b6:610:11a::28) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|BY5PR12MB4323:EE_
X-MS-Office365-Filtering-Correlation-Id: d5551556-c7a3-4481-7e5e-08dead464ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XqsDpVJ3knvvvKWjWwicVIiKsOUHCMPZa4mamRci0N6YCL1bAxC5cF40+Qag5hj/hA8d2JP6bmO7NAuT0yiBaHGdcUvLR1BBCpPVJ1qg9PewUP43VZWk2h1HHUIUIo3bbsE4Dd/RvUbclATID9HnpITUTGzir2TGfUdC1aTZYjh4SfrPBPBCjkmnnih/tnI5S/1ZYVrWGzKXKo7vCNkHBzH9i78ZVLZgODQgy157iuzWdt8P3aY07CxFQ1Eu59FX212+m+QmciRWtilt97joa+qvbuVMXcL+BYVqLIbdEKqjugZYu9jDBlSimLrhHnsv837yfAeyhON5KIBP0P2Gg76/riy/ZclRWPzrCqKBLljYRnLXuqmfAjggRqNPcWY40VetzdF1fREZ8IlzGIIafIhPW9rh58KsXzlxqPMelSWl4R9T8ogzfYVwjtadUm7GhwV7vlzTob3doOnSPFwgtPeGBhRr9gj2qN6ozdzwBkUypUbTv1wz23MmH8IDXtofNeg5V18KkN4n6aHi5OfhF7sQRbB3p3m/BXwp1fhtMwI0QuwdIVk2PozJ5gJCuDf7oMEgefg031NRox9Ojk7Wsfs80Y29+c2X3fyiZTrla2+mnu1esrDQbW9PWTfBxNIGB1Dq492WJHU4UgSb3QAPH3q24uJ24FywRkMU/+4FksQnecoAtppvnu2mPuNnLNK0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXpIMHFVekhuVXMwZFkyZlNMRklrNFIzZEVkRnNYKzVBbjhPMEdoZHY2bjZB?=
 =?utf-8?B?ZHNka1ZnVDJtdld6Y3hoSGl0YzA0WklhRHQySnlqaEJRcHdaRXdsdVFGaCs4?=
 =?utf-8?B?ZEVmQUh6UHZKRDhmQWdNc2c3OTN6Q0tuVDhPM29HeEk2aWJqUzl3cGFxMlo1?=
 =?utf-8?B?eFJYUDlSRlgzMmJpV3JlV29MT2k0UEtEQWVtTUZ0WUs2ZGtYa1VYbWR6RW9h?=
 =?utf-8?B?Y0thWWlKVEFxeGdhb24wWForbjhTRUJ0cjV1UHVaUTZIcjRxcFhzVnlCMmlP?=
 =?utf-8?B?cDBzQnZ3WTQrM0JRVi95SkUzcFJIRWsyamwyRFBJWnVQVURGU2hIenIyUnAz?=
 =?utf-8?B?c1FXQkVKbVMydHZlRGlLYm9US3RwU2szMFBxUDhZUzhyR0ZPdGwyQUVFc2U4?=
 =?utf-8?B?eloxUjFjaXJ4VFl4M1ZRTlpSRU5KK0xXTGlPWU1IMWt1NFEwbGp6UWVpTWFm?=
 =?utf-8?B?Wm95WXdPUUYwQzI4aGhCR1ROdWx5dmV3d2laQzRwSm82bENNblNFNVlqU2Fx?=
 =?utf-8?B?YWVNR1hSd0pVN1pzYm0zM1ZrOVRQZEhZbEZENC9aVVBPNjFkZ0h4T09MYU1E?=
 =?utf-8?B?ZzdicVJJOUg4anpzQTBmT0ZUWkJxV0w4RXRpSUdiMmJBM3k2SFBFSFhtckpl?=
 =?utf-8?B?b2dlakFkdk91UUpOTkNWWnN0V29OY1d3bnhsVkVzQm9nemUrZzdnWEVPcXhV?=
 =?utf-8?B?czZOck84QUxmVnNOTDRJNDFlL01HbU9jWTRxMFFCT0FhUTJGaU9yZVlKUXZI?=
 =?utf-8?B?YzF4RVdjT0h2cGxlV3I2VndBczJwN2FxMzlHbEk4NU9lL2lJQTU3QTJrYlJZ?=
 =?utf-8?B?V1RhMGRZdXJZcXZPdXhZbW9nZUljZC80RFBGUkFxRFh5SWpvSmk2ZG4rOWpz?=
 =?utf-8?B?b0ZkOEw1VEJBbjFGcWwrWE03d1NtVzJDSWVaSjVhMWFtSndNTTZWS1NDL0Vn?=
 =?utf-8?B?czlCMnFIZ21kemRwSUpOOXlVeTZzZFRjQmdFSm5wa0pPWWNLYWRyRzVPRmQ0?=
 =?utf-8?B?VGVmK0xWeis2bXQreU1DcWViaE5pNXBuNE1CWms0TTVObElIMGJFUjVhMGtR?=
 =?utf-8?B?YzRoazVqNmpYTkFERWhzNEYrcVJ4TmR0ZmlrMy8wUFU2TnRLS1FDWUw2MVpw?=
 =?utf-8?B?OGVzK05VRVQveVBoYjhIL08zNEc0Q3hwU2RvRzZJUUI0ek5SclBiZ1piV0ox?=
 =?utf-8?B?d2d5bzY4MWlneXM4MktsQytTNnlMdTdTQmtIK1ovQU1aYjdBTTVzc215WHIw?=
 =?utf-8?B?SnFYdWFwYkg0bjQ4UDVOdU80enpzSmthY1NzcDQwWGxNLytjVzlGeEdHMWlI?=
 =?utf-8?B?MTNPeGhtSTgvSFNUUlRLUnNaQmFOODlJVVBBRkFTVXBoWDJ0YlhWaDIwSitG?=
 =?utf-8?B?UTd2MTB2aHI2ZnVJZWJoTlBmYlJ2ZlZCaU5hL2xmd3lpbU5lM0p4MDRyZnI1?=
 =?utf-8?B?NlJTamV3dzVxQUl3WFNCSmdsbC8yWkszY2tuNlRKK21mWnNtQUdCTXdHWk1O?=
 =?utf-8?B?aFNZbmVDalQxLzlUSmZHaWdsT1lJQzNkVWIxSWZJaTBwLzVqOE9RY1BlM3NZ?=
 =?utf-8?B?UW1oQ0JsYUZiMk1wVithbEpvK0FDY21RejBSMmJDTHZMZzZNSVJQS2F6N0RW?=
 =?utf-8?B?M0R5RFpaWkhwMllvcisvYWFFdXZsbzQwNm5xWW9FWjVManA0dkMraTZ6cnJ6?=
 =?utf-8?B?YUZXRWFCNWl1b3VZWkg1bVVma2RFNjEwc2RCenhVSEg3d0g1Unl5Z1d1UHZL?=
 =?utf-8?B?NjBuY2RJWGJSanBNaVl3UUhBaW15REdlakhndW1qaGpMMDI2OWtjdXNHSXpx?=
 =?utf-8?B?VUZTUFMzUFB0VDQrWDBIdTN5dCtDWnRWR1BFNWM4cE5NeHhiY1BUUUsySytS?=
 =?utf-8?B?QUt5UDB2QUEwSThQem0rdk5ocnBvZGlJUG8rdVh2MXNWVGRsb3lRNzVXb3Fz?=
 =?utf-8?B?R1V0RHdmYnRTTEFiZks3Y0NyTy8wdnBuVTlQSDlwYkZtenV1L2pZUS96dnBy?=
 =?utf-8?B?R2dFRDFHOHkzeEFIRVpYR08vMXJzaEh1TU1CeVZRMVY3eFh1THBUVUdTNjc1?=
 =?utf-8?B?cjgwZGx3MWJPdUViM3lFOWR0aGp1Q2x4Zk1vNVdtK2dyazluOERvaldIWTMy?=
 =?utf-8?B?cXdNKytuRzNtTVJtTGVCcVp0eFQ1UlluQTdnVFUwNkx3VnBSSEZpdFN0TVJx?=
 =?utf-8?B?N1BSK09zSzVKc0kraSsycXZGZHJyNEpqMGJlLzF3d2MybGcxM2FNbEtZODJC?=
 =?utf-8?B?V0FEL2JORHFzMzNiNFg5S1pXK29zNGVwOWRKV01CWWpsK0dUNHpEd0REeHBq?=
 =?utf-8?Q?2B4XgtujyuLEWAE556?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5551556-c7a3-4481-7e5e-08dead464ba8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 21:10:56.4425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wNMW8iw/UJLVYarsQGxLq8WBb7qEHNKU5svm75DKas+uyn2FrETjqqWG2i+e1+grCH2DjEtNC45Pbwl+Jopqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4323

Hi Tycho,

Missed this one in my mailbox. Thanks for the review!

On 5/4/26 10:32 AM, Tycho Andersen wrote:
> On Fri, May 01, 2026 at 11:20:51AM -0400, Pratik R. Sampat wrote:
>>   - failed_status (read-only): firmware-reported failure status from the
>>     last operation, as returned alongside the status vectors
> 
> "from the last operation" is not quite right here, it looks like it
> re-runs the STATUS command and reports that error?

That is correct. It runs the STATUS command and reports the status of the
verification operation. Probably better to phrase it as the "last verification
operation" instead?

> 
>> +		failed_status: Read only interface that reports the status of
>> +			       the verification operation.
> 
> This should probably also note that it runs a fresh operation.
> 

Ack.

> I was trying to think of a nice way to report the status of the last
> operation short of caching it, but I didn't come up with anything
> good. I don't think it's important enough to cache, the failure codes
> right now are all for things that would persist across runs.
> 

Right, I didn't want to leave room for any ambiguity so avoided caching it for
one additional call.
If the failure status is set, we do fail the VERIFY op as well, but I wasn't
too sure how to report that failure without an additional interface like this.


--Pratik
