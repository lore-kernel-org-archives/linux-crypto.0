Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E721CD2C;
	Thu, 29 May 2025 01:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748481583; cv=fail; b=VAP5DqO2pEHzt3wCaFZ7H+/RRFlhmRTG2jUSxqXJYyvaUVRlJ+v5vRrpQGZh+rfMEfn8pRs54bkTiqeOZrnHlqP3TOGR2p+SEImPw7ImND+aaTWdmhGFImhKPOh907hVdUBr+7XLSQLswkVbL28Zq8PRlFG1IXUUdr/6BTzdLSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748481583; c=relaxed/simple;
	bh=w8sMi6CPO8WuwYYb5mssfTvg3BbgO/V0MTlECe7z2Ls=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sb6gXiRweiDlQF2VJOkfm2e8EP3/YqOZIoklil73FFZ+VtfGSZr/4/yZ1uGSvehPkKK45VIOPTeMTh39YXyytRZ7ndhBSUWIgqoPQO29IlSWonXBAazU3wGTM0fxKJXpSIxbS90vI4HHhj54ojQFqm8TukKpgnj72EJIqcoQDeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vFRZpc9v; arc=fail smtp.client-ip=40.107.102.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vFRZpc9v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGY4EdM+1QbOZTEgpi2JjfRXXu+cb84KGKNhVNiPDv/zcSK8L8oMhrCF5U40WMKT6vm0oT/Bnxczzth/dY0Urn+DcCG+Sw+qUrjCoLQEzM1B+iS4aESUXQSN9SBkCAVsUvNZDXCof4PXSJp++jfj4ywqp27o95Z7bdIki1pkT2B/Pscb2KcJ+bliHJLJPgMtwsEbbsZO5IeWVg6LqZYBg5dEzGI3QYiSNj4aZtU158LCIxk/TPRe8JK6WdxnkjIukgqU1KplWLTgyv3JuC9MPmc+pwiuVtoQCe1WKf6f2GobwMn1LmgoWSpO323J6UnDXC7JL3wHsU5vOjFFZUndtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7IyjSgm+NNeE+29aQOctAXa4IJX1W7MNhxjn1DAV4Y=;
 b=SEISaVUuHsPuJsFW5J6mnLdyMeqQDnht8oesIqqQ+gVnN3PicT19rbuLB5BtNzeYR7MvQ2iOlYbuVnGzMu3oahWN7gUu+P+udh+N+SeYd/E1MbPoyRbyfnibxz3E9KwWzNiubdmzNwCqu8/baitSbVAp5/MrM8vkY8rAy/LDdVOVghAO9VBGOWULKSFK+AGgLQ+9b8ULxGUqbLWvAfGxehO26iC3k55N9ghZDdaNLpYBIQUZ0siOMMhX46GHr9uvRkFkEWJ6wgZgsoJ6Cnqa5ZY5+u/8duJ2eiSPtmFCFedYhI1tGl4dL5033SqeYz62RiH6IlcYEdWfouyPOaWnog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7IyjSgm+NNeE+29aQOctAXa4IJX1W7MNhxjn1DAV4Y=;
 b=vFRZpc9vN0zTJeTB/mEd8y9lE/20Tq7sRsRkykoxTD7tt5Z0elk/altiHeWH2IhXj19sLIr3WnGdCJVX2lr5tgofwLsyYL7x1OqBoPnFB8Uce7jfKHOtu894DYqdwB9WFFapsn7zXM/Ky3EqZ197eBSuTdfXPeYpUqJ75v4BfKE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Thu, 29 May
 2025 01:19:39 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 01:19:38 +0000
Message-ID: <3ffa8780-f985-40ac-b011-e31c2cbfc8ba@amd.com>
Date: Wed, 28 May 2025 20:19:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Fix dereferencing uninitialized error
 pointer
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
 dan.carpenter@linaro.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250528202018.78192-1-Ashish.Kalra@amd.com>
 <aDebwj8rcuWPIKOa@gondor.apana.org.au>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <aDebwj8rcuWPIKOa@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0152.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA0PR12MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e3939b9-1174-48bd-d1b6-08dd9e4ee126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SDVDWmd1a2hWU3N6T2xMZXJJbDdOeDhOTUxHcU96OW1DZW5RaUpCTWdYSHM4?=
 =?utf-8?B?eXRmNVUycVBXdWZvR3BQOWt5M2F2UDZORnByQXlxbU5neVlIZG9HbWZvOVgv?=
 =?utf-8?B?ajlDWVRCTVhOWXU2a1NmUHRaQ1VZRXZmaExUWmk0Y3gvZjFydDNoaTRGSkRB?=
 =?utf-8?B?V2hMTmpCenpoQVdsTU40c01WWHg3QUZuTjBFTXB2Y2dVSXRac0NyV0ZYakZy?=
 =?utf-8?B?emZhTis2aEFLWk0vL3A3S2NmZDhRdW9NOGptY3NQdE5teFZ1ZDMwTVQ3eWRm?=
 =?utf-8?B?VWxNOVFlQXZNMlVZWjRXTWhpUDdybWxVbm9XQy9PTm9CZzVxZDVSS3M2T2xQ?=
 =?utf-8?B?UlVxYUZoWjJjbU1hd0hnc1lFc09xdjE5eU5wZFRMMEZIakw3VUdwdXhWeVJp?=
 =?utf-8?B?M2g2ckZPMU5HZ3lJYXU4a0NaK0d3cHBrejF5ejhkN25tZnFBejdqTVpQRWh2?=
 =?utf-8?B?M05ZMmgzd0g1aThYbmNSVlhGT0dXcWVXbGlWZjk3S0ZCMDdXaEVRcEYrOFFQ?=
 =?utf-8?B?MFRXTTMrRW5lSGEwM1hPQkhqYktNYVhKTzRGbGJBQXB6b1lBenRvYzU5bmdG?=
 =?utf-8?B?eUZMRFNwUllWdVpDaytlZ1A5enJtaUIyTGh0Y3QrM3BIckFiMi93ZFhMWlhx?=
 =?utf-8?B?WGFjS2J1R0lNbU0wOU16eGlVNUp3SlFWeVBoendHcjhQcXFjWFlORTliL2o3?=
 =?utf-8?B?QUV1aDFjMU0wbklqenRDTVFLUmVnSE04V2E4endKbjFDcG1MRndmdTJnQUIw?=
 =?utf-8?B?aVVTOTdUQTFjMTkwWVFIMzNwVjFiYTF1TlZOV2tTVVVkUDRaeTVla1JmcmZP?=
 =?utf-8?B?bUNsQ1BzalU0UEpWOFJrWnhVNVAyTTJZazU0eVZ1d0NCZ0w0Wm10SG5EeVAy?=
 =?utf-8?B?eVJmZGI5WEFwT24xWGgyRWE2T1J5Smxsb0wvWUI4R1hVbDVVN1F4bTZuczF3?=
 =?utf-8?B?T2s0K1IwRHBoN094YzdReWNNbXJCeEZJV1VBRjlvK2NTb2FhMnE3NlE2VXM0?=
 =?utf-8?B?by9WVTgrUFlxd05oU2QyRFRxaFgvMXNmUGpIclBWWG9NK1pJVmJLbGNNRmVB?=
 =?utf-8?B?OWdreENBRnFwTGlJb2NWYVZQYVFLMkk3ZldwcUs2WnQ1ZTJKOWNGUy91TTVV?=
 =?utf-8?B?TXNDNmNlL21QMVRhUHRta2ZNUy9Pa1dldzRrUVBrSWJCZFdwV2FlckVuZ3NM?=
 =?utf-8?B?SkhlRk9KaTEvRGJmSnlJZFB0SFc2NWdwb0VweDJMTVVxdjU1L2ZzTS9wNzgv?=
 =?utf-8?B?Q3lrQkxMcVdFWTg1ZEZvYm5acGhWclZIZ1BNeTVscmFoUUFSMDZJNlptYzNV?=
 =?utf-8?B?T1NyVjFybExFVjhaK003SDlwRUZMZHZRUk5lUm9vNGNzRVFLcmlHdGM4Nks1?=
 =?utf-8?B?Nk9EVHp6Y0lqSUk5NVJrNTdBWU9YWVdmOGtoa3laUlUrYXNna3R2TGp0Rnl1?=
 =?utf-8?B?b05JR1RacDdSOFMzZmVZUTMrZ0lscWpoYWJHajNYejlJelZ5bHNGdFpJYVN6?=
 =?utf-8?B?K1ZWNkNPSXVpYWtGcGROSHFsdXp0K3E5QnQ0L1cwVTBLdjRxVkF5NjFGZjNj?=
 =?utf-8?B?NXIzNlB3cm9hTDJkbFNib2k3UkZnY1prYlVVZXk2YmN2eUlRblFReHg3VDNa?=
 =?utf-8?B?RHFUOW9LQ0hUN3g5QmwraUhkNjJpdUwxREFpSmJoYytnK3B2ZE5pMURWdkE1?=
 =?utf-8?B?VzRMSmt3N0VHUmdOTWl2MW90VlhRSnZyZ0g0NEJRK053Tlg2QmN0aTJCZFJG?=
 =?utf-8?B?Zkc2cUFYV0hGSlJwem4rbHZWcUJpS0EvL0dlS3hsdjM1a1IvRlpYT25NMFZX?=
 =?utf-8?B?cE8zQ2krWU1NYm00R0tldUg4NmxpdVk2YjBwMklpWEtxZVkxYUM2SzY1RnlI?=
 =?utf-8?B?QXNpd0liRjNUWnorWFYvd0VPUHl3ZzlGYW9UdEZtWFJVVGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG5VQ1kvVDNvNkNXdzY1R2luL1d3RUl3S2VCZ1N5OWN6NVphWU5BN1VLdDNI?=
 =?utf-8?B?MmhEVGF3L0NSR2kxZ3BBTGFJcFE0MXhib1AyY2xDTXhLNFFFd1AySzlLQXo3?=
 =?utf-8?B?aVQ4QytmYXU0UTFuT3VrQUdjUytuRHl2bHVxR0JNY1VPVC8vR2hqak13RDlx?=
 =?utf-8?B?bk9MU05BSGhOTmZxTCt0dmZyT1pvdElWanFLMU9PaWdQdFA3eVFLSHF5YkYv?=
 =?utf-8?B?TmZiK3p2Ti9aa2o0SVhDZVd2NG54NEJwaEpHSDE3YW9sS2VhSEgzVSsySG5h?=
 =?utf-8?B?T3N1MWg0eDJ1ckJrQWNLWE1SUm55UlJLQmYvd3ljRzN3dGl6Q29lb2xUL2lr?=
 =?utf-8?B?MVZKU25Vb2Z0cndYd3ZmUHFRR0VNYVNUQ3NITEFYVGZ6N2liMlhtMTY5dURz?=
 =?utf-8?B?TlREaEN6YzJIYzB4Um5sQ3o3Ky85YTVUbW85UkwvZVB0SXlaZk5raUlneE5v?=
 =?utf-8?B?MW40V0d5eTIzcHhVS0RHMkt0R1BtR3Fmd0loZzZsVGFOUDlPcW5FSGlzbitn?=
 =?utf-8?B?ZXRvTURlQ1JQVDlYRkJqUElGQm50Mm1hNzVib3M2TTZNVlBFWkhxMnJTS0I5?=
 =?utf-8?B?SnpTNEJwdFA1VndtaThkeGhYNHFQTDFaYnRVNEUweDdGb3BPUHVDM0F5NlZO?=
 =?utf-8?B?aWw3QURjd1JoY0g3K0pSRzFyTWZ6TGNkYmowUkxPcVRwdlI3THFPZmR6ZEx6?=
 =?utf-8?B?YStSZE8xRzZxR04xY3JNczczUDQ4MlFwSk1hdU5mbUFwcW5YdUVZVFZlTlRs?=
 =?utf-8?B?T0FGWkx2THdNYmxXUisrclpJZ2luQUFPV0ZPKzdvVk8vamNVQmo3OTVrdUFs?=
 =?utf-8?B?bTlOYlU1Z0p3SE5mNnJ6NmQ1Yms3eXJoTWVWbG1LMkxleUdKeTNkZ2NkWUVF?=
 =?utf-8?B?WkZxdDhBMlNOUGxWbTVxYU5mWXRFMzJ3RW85WVpYQlMyUXpqZWdnUkIzd2V0?=
 =?utf-8?B?MVc1Y3JOMjd3cGVWeU5xRTR3QnJDNVhlOGlzRHB6YXhsQkZrNlRkekMzQ0Mr?=
 =?utf-8?B?WHhhT1kwSmMxaEk0TEh1Ry8rbkF3RGt3MFdtUDU1Ri9nSFVXaVpseWNLL0Nq?=
 =?utf-8?B?M0RndXdkc0RFVjdrUm84M0dTUHlBYk1qaThUQTE1VHFvSlFpTmpiSGhNbGtt?=
 =?utf-8?B?dGI4RUNISWpqYTNiUU9wMDdYdmJENmxlS0xSYURHTytmbzVEbjhLN1U4UkZk?=
 =?utf-8?B?SjNKV1dsamhYOTM4MmJSZVUzOURDVnpGMzdUaEJiYlFnS0t5RHpZS05hcVRo?=
 =?utf-8?B?dkJ1TlNzTnk4SmU4SEdoRlIvcEhYNmUraXpnalI5c3dSaGFXejZERThhVXBx?=
 =?utf-8?B?TXd1Y3VoNUtQQVpTS2VrVThDcEtpbTR1akhNTGd0TEh5ZVBYWWlTTTh4cmlq?=
 =?utf-8?B?ZEczNlozUjRCbHBweEpkZ0h5MDRhY3ExeEhSRmpWNGU3MDRGMzVzbGV5dW5T?=
 =?utf-8?B?QTJCajlDeUNhaDlxNzN6MXhkRmE1akl3TXFQcTdIWHBqbzlWRGlPVU9WM1FU?=
 =?utf-8?B?NGdFbzFaalcrZkF1TC90QUJyNUw4bzF4VGhuOHExWHhPOXRMR25OVFhuWUJa?=
 =?utf-8?B?S1dCblRhdnRCK1lPMkg5a2dZeXNsS2VNSGh0dVQyMlVPTDZreFN1QXNLVnRB?=
 =?utf-8?B?eEcreGQvVmxYSzA2RitpS1poTzJVcW51U2hKa3VyVnNkckFoSmdLMFFnTUtj?=
 =?utf-8?B?OEhWdmpzSkoxWFB1T1VmYVJVRTBpR1E2cFJ3dGVGSy9SdWFralU0NUdjdUxB?=
 =?utf-8?B?elNWMlhIYkVWZmZNaGdBYXc2V1p1K1RLU2Y0RjlpRlY0S1ZEbGgyYXNwWm85?=
 =?utf-8?B?ZVNaK2J4VjRHS0lVRDBscjRrRGlrMGt3YVcrMFR4Z3VqR08weHJyTDhhOHl5?=
 =?utf-8?B?WG9OWjQ3cmJReFEvNWlXeTJhRFNGTHBWanN3alNDQ1RMOHpoN0RkSENhWEpK?=
 =?utf-8?B?UldCb1ZhMmg2YTVFc3FIbVlYTlA2RS9tL2dDQVVIdU1tcnd0OVlSTm05NW5m?=
 =?utf-8?B?eU5HVXFrNVo0bjhndTZVZERNeFdDdnUxUitvMlJXK21kOVYwWVV6d0tCSUVO?=
 =?utf-8?B?elpTUk8xTVZJS0g1NWIxaTZvaElSbEIxc1pvekR0S2xwaVpoaGpTYXJ3V3BH?=
 =?utf-8?Q?qkO8T8NaTT7al8ly/XKx9Pjlc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3939b9-1174-48bd-d1b6-08dd9e4ee126
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 01:19:38.1009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48mdyb1whf8G1xyy8Tw2Hyo3cRXyX350EdSQaYrnAKlW0UIUIwA94aiw2IymncLwlYq5wC4hFPYuWD1ATZ8qbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382


On 5/28/2025 6:26 PM, Herbert Xu wrote:
> On Wed, May 28, 2025 at 08:20:18PM +0000, Ashish Kalra wrote:
>>
>> @@ -1320,10 +1322,10 @@ static int __sev_platform_init_locked(int *error)
>>  
>>  	/* Prepare for first SEV guest launch after INIT */
>>  	wbinvd_on_all_cpus();
>> -	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
>> +	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &dfflush_error);
>>  	if (rc) {
>>  		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
>> -			*error, rc);
>> +			dfflush_error, rc);
> 
> dfflush_error is never returned to the caller unlike psp_ret, is
> this intentional?

Yes, this is intentional. 

As this function does SEV_INIT, it needs to return the firmware error (psp_ret) of SEV_INIT back to the caller.

For DF_FLUSH failures, errors are indicated only via the log and for that dfflush_error is used.

Thanks,
Ashish

> 
> Thanks,

