Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794886502;
	b=Im8pmRga/b4X9sECkUlSyBhx2Y3wX6AGndTOg6sKgXfGluyHFiIAwsKAsr/ow9ywG3vH
	 ZKLJMoWNpgBSRm4SceX9eOjnIA5cBfzZ7G/97bIMlN3bVEjPCGsN/hEUXENiIpNiesYZC
	 XdcTKyeN4VwW8/lFwF/b0BxNILAkEodXwNjXZb5Mgv+fZ2+2ZJoNLaDkSAbgSpW1UMsRk
	 4ewKVvdCWEBEUqtZbAt/16ECS1ZfDPyNiKxcHHhcK7SorJeSu2f/k4HX+DqHKBsQmDLxz
	 /XrFKxLBrOMb9i2IUK//ZsDFRTcxnWBcbWoyrAgRjHakcRnWOE9KzdLOyKt1a6nfnfQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794886502;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=bl5qGGbw/T9alykmySoTq0ETNQVOHYwTYYyg5gbSfdY=;
	b=WnyLpbiOzkogDra6ul8OZKq3WcCdooDvfNyE7lu9PrtV2cHOiH+vxmqNAj7zBSyEbQWF
	 0GtIc533dFDnRLyNyMbyerbPznwgmJexVxGGjzRTvy6uhaYf20BztkcBplITBuRKdiWJy
	 IHd4ByHixrmyb6zjrzuLw4ZHKBynzqbzOU765MPGdA2QYWKae9xPgaMMRDlAghYrMWeYz
	 dX6UzL3dILfZbcBiguDiI7+Me+iyizKFowOz4GQj4dPc5p5FN4btWuaZYUoLCXRwH3D+g
	 c3X7lwhjeCqF3DE5fOPy2qTgqIab2RK0WUGzOGOPgHDkPXfEpc3+l8XmY5wEiH1OQ8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=m7Z3wBeQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.26
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2D606A31C;
	Tue, 17 Nov 2026 03:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8A2D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=m7Z3wBeQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9By7uOvEgf35n7gKdDFubasD+mwRp+6jslhDsqCT53psS/4YxduV7qFFCw2HTq72Qs9PiLmNup8qlymNXd1tI76uzm9wucdnS0UXK87aSqVYSQ7w11BZoo4eZH3yOXczjKNd/EDAIQGpC1+7tx6pHM9Z0PQ5VDucYrdxKliqnfBfmE9HHfhlPF89mMnP30xKUR7ESVt6Dmww1kjFsKpQmDkMSV4EJoF8Odf3eBV628u3yYtqCTKe9ygKHRyrjVB8ex62bWkzXZ1IVzEgx5sdqjSjH7gvpZLRsRnN+hUA2Voh/uIYwSxJt8SJWhDRgPsl1vY3pKTost3QYI0OhvWDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bl5qGGbw/T9alykmySoTq0ETNQVOHYwTYYyg5gbSfdY=;
 b=i250CUJ/NzuNSOT2w3bTteQzw0Ok/l3gC0KKCklQCnSiGDmMUE6lvfyiFEMQyiNGsiZPGNz6hADMa/S/3ujeQCPU4uK0Gv67wLhv8cz0R40MvjlDh1Vfit7c4AeOizyKeYdMOd8EQjZNOELqex0DB8NKW4dxmWoERpCcdHovOmiFw/GbfLw3lJDCgD8/CYUOeOZ4oo3qTCLT6DucnxQucdOUT6fyGyADqPUrLIG94LAg83BZLZrh+hMaexp2K6NSItt9bIB8Ne1foZ9GBZV/qTATciBhKBWUcXimkqNvmteSVkXasEAudwxjMt0x/NeWnlbkGsK8sOGc4VhBJPSceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bl5qGGbw/T9alykmySoTq0ETNQVOHYwTYYyg5gbSfdY=;
 b=m7Z3wBeQqSYMxc5FvJI9iybP9k6/tP/y6oVFUNfo5QweAVa76vbnDEoX84d337AR9/3uUJKACsv6XOlGZqHrjwKjOB8ynqteTbb6ClloRoHDbUH52AUdHlBihjJBU6S6HzveANZ5ElYTy8n2E7mBaug6Di5cCNchHjcdyGE9aGk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6188.namprd12.prod.outlook.com (2603:10b6:208:3e4::6)
 by PH7PR12MB7425.namprd12.prod.outlook.com (2603:10b6:510:200::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 03:34:57 +0000
Received: from IA1PR12MB6188.namprd12.prod.outlook.com
 ([fe80::e933:4d1e:8759:e9a0]) by IA1PR12MB6188.namprd12.prod.outlook.com
 ([fe80::e933:4d1e:8759:e9a0%2]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 03:34:57 +0000
Message-ID: <54e24f60-bd59-4609-aad7-902c93c38f79@amd.com>
Date: Tue, 17 Nov 2026 09:04:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp - unwind PSP sub-devices on partial
 psp_init() failure
To: Mario Limonciello <superm1@kernel.org>,
 Kim Phillips <kim.phillips@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261116203622.615371-1-kim.phillips@amd.com>
 <c99b891f-05fb-4629-b439-ac3828a4ea0a@kernel.org>
Content-Language: en-US
From: Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <c99b891f-05fb-4629-b439-ac3828a4ea0a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0358.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:219::17) To IA1PR12MB6188.namprd12.prod.outlook.com
 (2603:10b6:208:3e4::6)
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
X-MS-TrafficTypeDiagnostic: IA1PR12MB6188:EE_|PH7PR12MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: c27b8f74-e665-4053-ca46-08df445bc076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|261028144727099003|261026121527099003|261102123227099003|261026140227099003|261022105027099003|261021121427099003|261021123027099003|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003|261009223027099003|261009221227099003;
X-Microsoft-Antispam-Message-Info:
	sL1FaG8cSWlzn0tZkWBiOXaF2uqoouejeI+flx4cJ3WoUr2n48c/ZXrFjO7JhEaTiTTTJtsyRfY2sLGf8Lnhn54teVW2LSRikD4qo0ciRCwRlWtDwCnzXlMatcClzq5fkarad6kCUvnGMEHPwiiMaHMUu0iPKDePbQ/zPIJC74BswjAOf8LknsPupLLCKJBvnxZAE4tZ4VNiu2dp6NfyL7/TpidVNnNUXlB1a6cgzJpSVQLrN32wisZCrR4kFPOU4cED8UxoBRPStXTeV8qPI5Co61VIcsGlOja+1UMnm4wiso5b6dXBPUkmXdh2bAPWdqXXkeoq6Ke+xyfbq1mroCgrhNTA9oGaqoDawIetwKDIAUABMv9ipp3Pej2FRdUApj81H9DDVFWBYAaH75qnU1Qs7Y0t+JL0ZlB/Ufqx+8FFahL5EWCdB3ehsNpZrx/gVZv4w03tI3rAdsUgxQ85A0a9vz7SwiYILKZLPbRcC688Y9A1ThALnb7nlfZOPnQS0bNDdB7iAwROT3tLik3i7X97+mBL5tkSRmIfU0khGTy3K/HlS5+ozYF8wAj571JZgWPTLE65yOC/g1U8UqZPF/QdfcvTPvzSBryLo943reg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6188.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(261028144727099003)(261026121527099003)(261102123227099003)(261026140227099003)(261022105027099003)(261021121427099003)(261021123027099003)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(261009223027099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW5XS3pmSER6U2VuaFJkME9mSzJJMGNoRDJNdDA1QUh6eGVjWnBpaUM5MW1K?=
 =?utf-8?B?RG44TFlYUE5rWllTY1NRckZKZExlbG5xTHI3cjlaaWlIK0pFRUpsM2VwN3RF?=
 =?utf-8?B?RzJ3YmRPQ3k5QVNPekdBWkpRVUxabjh6R0NMUWhaUStLRTJ5Nld5eHpsSlVv?=
 =?utf-8?B?a1BwUE02RElsaHF0OHYxbVB1UjBJeFFRWmlmYWRDTlRxMmt2TW82VWJRaEhK?=
 =?utf-8?B?RDR3UDc3b2lkODZVUzNTeVpVWXFmUjlWVU1lM0FmUXdvc1l0Z2hHbEhEeWtP?=
 =?utf-8?B?ZjlZSkoxWitBY3dMMllkeEVpZ3RNV3lNcVo2V3dZWGdlU1VQZ2E0UGFVOHQ1?=
 =?utf-8?B?aU9aYWwrSm9xMno0VXB2TWxyVWZaOG5WbW9mU21IR1lUckdYOEFJcngrTVF2?=
 =?utf-8?B?anFSREpyMFlBaVpINkFXejNCUU1RYzVyRHdOU05qRXlzVVQ1Ui9aWktKVVZu?=
 =?utf-8?B?VnFOUjRjWE51RS9vUTZ5U2c5NnI4LzRRbnlwNTJtU1BqbWZJQ0QveWFtRzk1?=
 =?utf-8?B?N0JoMXVlQnh1R0MrYnFraTNKQVJaSmQ5d3dTQ0hTYXIrYzhhbHBlLzl2MERY?=
 =?utf-8?B?YWl5MGNYOGZDV08ycFNHdXQ4M1hJMFhDZEFPVkh4YXhPY0tXS3dsUFNmVHVS?=
 =?utf-8?B?SGlTOG1mUU9zT1gvSGsrcnBEcTBya2FPRFdNTU5BemNsbXdIOHRJaHBhcExp?=
 =?utf-8?B?c0w4N0k2akJybkt5UTEwRHhMOEZLSFRuYUlpeldTRWV0ejh1d01mVjBzZkt4?=
 =?utf-8?B?dnNtSE1JYmdoVGIwQVVDQ0VWVzZhS3J5VUZSVmFIaU1kTzUvMjBDdVVpUXkz?=
 =?utf-8?B?SElLVm1vZHd4UEtEbXhPRVdkWTlJOHZSdVZVRDBHWm9qc2g2RFR0T3AweVlP?=
 =?utf-8?B?b3dsL1Q2bks4aWkzejlldzlXWisyV3JqVWF1SStYNTJRRDNONDArdUpvRWdu?=
 =?utf-8?B?aXVCemRBazMzT2JBdXBpK2diTXNIbVJKVVBoVFU3OXZPb2YwVDFJOFV5OGRB?=
 =?utf-8?B?eTVycU16eXZWcXRwV2FqdEFoQmtTcER2WHk3Zks1aDdqWDdDbGUxVVJGV1Nn?=
 =?utf-8?B?eUNhOGZPb2Y2Sm1OVWpXdVBEYURsempvejdDcisxeGMxb1B6YzZsbytCbmYx?=
 =?utf-8?B?a0pKZ1pxbng0WXFLN0ZtbWdPckpoT2xwYkVHcGQwYmhkWHl0dXYra0V5dDZY?=
 =?utf-8?B?cXptL1plMU9nQjhYaWtaMWdMSjMyZ0xSVytvTitvcHczQUpJMXFRTW11UHBZ?=
 =?utf-8?B?eGw4am9abmNTV2Y0U3ZjN0pBdlJLVEJYVURkcGZvbGFjMGRhRks3RGNZbU5R?=
 =?utf-8?B?R3BIN0JsV1I5MkFCa2tJczlrTUVPSVpvNmtUWTAvMmFHTWh4UjJJcTN2dHh1?=
 =?utf-8?B?aUhteFZZTUR6SVBBUlNjM2VPUmdYZzVKa0NsY1hSN1dhdW1nMXBEUVJwU01Q?=
 =?utf-8?B?UkZOVGVOQ3lFSk04aVg3aStYN3J0NFJnV3J4MkdKenN4MC83U2NYNzJTdElO?=
 =?utf-8?B?NFVUaFk0YmFZKzV4UVROVGVlaGIvWFVKK3hjdi9MbURTVFQvUmJvbTZ6aFpv?=
 =?utf-8?B?am1ZeVJWeEVsaFZzVE0yWVBPWkovZnVrS2lobjNWZFJjN3hGMkp0YWVuRERZ?=
 =?utf-8?B?S0VqcDQ5dE81NFpMenlOYVdhUnlPbGM1aDdXaXY0cXBrU2JYZ1ZiK0Rycmdk?=
 =?utf-8?B?THV5MHQvWUxnZDVRSWZ6T2cxUDc1cTBOcExKdnRKTGJZOHQ2TUZWS2hzNW8y?=
 =?utf-8?B?V2pxM1RlWXQxanl1OGdaK05kNkw3NTJPL2c2NlZZM2doSjVZMDA0UVY0bDZE?=
 =?utf-8?B?U1BlZnY3T2tmcjBSZDZDR3VaSTJGRm4wN1NIdXdYMkFQd0RhM1NnTkhzVTd1?=
 =?utf-8?B?NnljajJ6d1Rod2wxcTFISjdSbGQ1R2ZjS2VqQWxxWWYxSFk2dHZHWVNPMUQv?=
 =?utf-8?B?WHAwQWdubzlmTGZYbEkwdm1iL0UvaURYOFFrQUcyMk41bDdweEc2QktWRjU2?=
 =?utf-8?B?OStkcUtrYzFPQit3blE4Zk5qNlVhUDBXYmpqd2hTdnY3T0hqMkRSdVRTN0Vv?=
 =?utf-8?B?ejlya01XbkQraTVMWmVzWDFhL0NXRUVYNHczcjZDUEVmZ2lqQy9ITS90Vysr?=
 =?utf-8?B?UVZ5MG9XL1RUMlZrTE9nSG5Dc2lyU3hNcmNwYWg2aDE1R00xT0RPOUZOSEUz?=
 =?utf-8?B?Yzl5T3dqSjZ1aHhFelkreGVkTUZqTTNUZWpmUjQySlZqZTk0czQwOHE1dXd5?=
 =?utf-8?B?cjFGN2tLOTNiSkxRU2ExT3U1WlJhb3JUY2N6VTY3SE1VcXBwKzd1bnh6cEZm?=
 =?utf-8?Q?QIwIVtePYkaSjowAMo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27b8f74-e665-4053-ca46-08df445bc076
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6188.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 03:34:57.5841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /aM/WJ2zjSL3cr6Xw3lC2lRTy+Lu6ygZ/yZYDLxzQWKQd94YiSJUAuircUH4S1UHDtiVne6lnJbctol6DC6PuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7425

On 11/17/2026 2:54 AM, Mario Limonciello wrote:
> 
> 
> On 11/16/26 14:36, Kim Phillips wrote:
>> psp_init() initializes sub-devices sequentially but returns immediately
>> on the first failure, leaving earlier sub-devices registered. Its caller
>> psp_dev_init() then sets sp->psp_data = NULL, so the later
>> psp_dev_destroy() on unbind bails out early and never unregisters them.
>>
>> Non-devm resources such as the /dev/sev and /dev/dbc character devices
>> stay globally visible while their devm-allocated backing structures are
>> freed by the driver core, giving a use-after-free if userspace opens the
>> orphaned device.
>>
>> Add reverse-order unwind labels to psp_init() so each sub-device is torn
>> down before the error is propagated. Every *_dev_destroy() is already
>> NULL-guarded on its own psp->*_data pointer, so skipped or unreached
>> sub-devices are no-ops.
>>
>> sp_init() continues to ignore the psp_dev_init() return value on
>> purpose: a PSP failure must not fail the probe, as the CCP can still
>> initialize successfully.
>>
>> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/bug/linux-0de87f0c-0f5a-4dad-8ef1-f49844eb4cce
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
>> Cc: Mario Limonciello <mario.limonciello@amd.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
>> ---
>> v1: https://lore.kernel.org/linux-crypto/20261021215716.1076732-1-kim.phillips@amd.com/
> 

Looks good to me.

Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

> Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
> 
>>
>>   drivers/crypto/ccp/psp-dev.c | 23 ++++++++++++++++++-----
>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index b14ce51065d5..3d9341c2876d 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -207,19 +207,19 @@ static int psp_init(struct psp_device *psp)
>>       if (!psp_check_tee_support(psp)) {
>>           ret = tee_dev_init(psp);
>>           if (ret)
>> -            return ret;
>> +            goto e_sev;
>>       }
>>         if (!psp_check_sfs_support(psp)) {
>>           ret = sfs_dev_init(psp);
>>           if (ret)
>> -            return ret;
>> +            goto e_tee;
>>       }
>>         if (psp->vdata->platform_access) {
>>           ret = platform_access_dev_init(psp);
>>           if (ret)
>> -            return ret;
>> +            goto e_sfs;
>>       }
>>         /* dbc must come after platform access as it tests the feature */
>> @@ -227,15 +227,28 @@ static int psp_init(struct psp_device *psp)
>>           psp->capability.dbc_thru_ext) {
>>           ret = dbc_dev_init(psp);
>>           if (ret)
>> -            return ret;
>> +            goto e_platform_access;
>>       }
>>         /* HSTI uses platform access on some systems. */
>>       ret = psp_init_hsti(psp);
>>       if (ret)
>> -        return ret;
>> +        goto e_dbc;
>>         return 0;
>> +
>> +e_dbc:
>> +    dbc_dev_destroy(psp);
>> +e_platform_access:
>> +    platform_access_dev_destroy(psp);
>> +e_sfs:
>> +    sfs_dev_destroy(psp);
>> +e_tee:
>> +    tee_dev_destroy(psp);
>> +e_sev:
>> +    sev_dev_destroy(psp);
>> +
>> +    return ret;
>>   }
>>     int psp_dev_init(struct sp_device *sp)
>>
>> base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351
> 

