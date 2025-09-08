Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4801FDA92;
	Mon,  8 Sep 2025 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347819; cv=fail; b=fT4T0hY5ShpW67FJJa1Fhl82i/9LsxPT+kPagVrUXDzCr/nPUtCLPyL/+AQP1MHQ6DnUE5CJrd52Uz/E2mQa4WtdcDOcHvODYkmoOxnBYJKdI1q0MSRKR064wUrVT+T5pFJ2ziJ94yl6v4815VtGJBVyCD4bgBfFPPSFFusxTe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347819; c=relaxed/simple;
	bh=9m2v8wHBhYhC7dkaKBiw+w6A+Hbx3eReFFfDk11djdw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y6nfmU6LTUua5XySTy8ufE6RdwkLsDpQmy+/lzz0buMUQc5DR4dFxaW5cdUK6b6gSC2srw3NEQuZ5Xqdy542C7jt9Oc9+TscIBHssBLLojUp3sXfb7Sp643hqqP75TJ/WdFTMchqbzQec8ty000tw/dvovFgRVwWFcsmkNM1hgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kViRi1aD; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kViRi1aD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JEVp/NZja4arRfll9y18uYO1P6MQNpUpkemXudJAAX2857GvESWWIy+LiUVQGuhlB9xHExabyX+yqlijnWk0XnI52+OfBCUEB9x3dqOKpL26NzMEZg4l+We5t3Izykf95A7DOYkjML8BnmcCaRZD/woyShjS+xFyoEVZxp878bNPaqpMvZBBy5oDadhJ/ZIQmj1AxEzt19VdwFnRYgOYER0NzL6t+801wPPiSdnZvKpammE6Y4PyylW29EqKUhGfvw2iybhN8I/1i230Xzb1bfWO1VFMflClqyMRjDf0nfFWcyMwoQEIdrC/eyzT1n7FC6+xQ49Y2cXovWRtCzVhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=in7MT0UiQaZGjpz/I6lc4scZeEzyt4re+V8cQIC+Wys=;
 b=QhWF8hMjOgGzuO8a1RUOjmVFAAxbP9IOn5h3GHM0Hedv2tLufztD2UpjtfmkXcHBEvLTMBJ1PehH0SF0iznSciV0PtEjBadZSNaZFlLYRRz+lE/NzO48pM1f+fOYMaCzrNbFteUlsTy1FkZCW61y9wW5Cj8p5inCBRbnWbHog4IXhBABNl4grXbye+VLZdbWWFC2Z1ikygrm3nb2ymnR9Z3+2Dt/ZRz1sp13Su24qRYaN5SFkqAozd4bYquIZMcX+RxVzPd4bUzCxrRrIuHdOHdEH7EL8RwdCbbxJLZEQkSfrJ/+iIp5vcjm3Ke3vkQIieVfa9Ld+Z5WfTq2bq4mIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in7MT0UiQaZGjpz/I6lc4scZeEzyt4re+V8cQIC+Wys=;
 b=kViRi1aDLz7yBX66awFDf7i2UWRVykJrG+9uaN9k5HyTwHG3mzbDnoYxk4nqARM7fhTuGW3cJhi56a5X/5ni7IoJOOBudgM0NNtTStiaT0408aCCQaqc17xeaTMKAIDNPx/sv+Qn6fhO9jgRK6zBeXDO1oDi88NjBxrAzCYcSLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 16:10:14 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 16:10:14 +0000
Message-ID: <78670082-36a2-2520-ac7f-b71482540035@amd.com>
Date: Mon, 8 Sep 2025 11:10:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Fix incorrect return type for
 psp_get_capability()
Content-Language: en-US
To: Yunseong Kim <ysk@kzalloc.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Mario Limonciello <mario.limonciello@amd.com>,
 John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250903135547.19617-2-ysk@kzalloc.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250903135547.19617-2-ysk@kzalloc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ea3338-aa5b-483d-d115-08ddeef23191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFhNNEp4czNNaW9lL1FPVTdpNFAxd3JPQWVBalBKdXR0em1Ja0JsV2E3Y2Uv?=
 =?utf-8?B?RkppTU9SVno1aDFDbVZqWGxNb2lYenN0K3lYdUlwL0lpaCs3SmdvaE1KS2tt?=
 =?utf-8?B?c2ppdEFVSW5saTV4bUg4YTRDbEQ2bGlQQmVrMUJPWUFjZ3JKVXg1UkVrblBi?=
 =?utf-8?B?MW1FK2NqRjZPU1RYZ0xQblJqUWYxL1ArY2dCRzRTWVFzQUNEcXZOTU9TWUVs?=
 =?utf-8?B?V0tYOWlreERvUEVqUDQ5OEJIcFBySGlEWUxKd3hjRnJPUEhFYk9GZEhzdjcx?=
 =?utf-8?B?d3JSd1VVK1UvckpWWk1oM0xjR2orZDBiVFRPQ2wybXNYMXBtNVRBeUNMNHI3?=
 =?utf-8?B?b1ZCOXNXSDc4YkxlMFdMZzdhNExCcUREcTFab0tNQXQrNGx3Q04yMm14dytB?=
 =?utf-8?B?djJvTzN6bks4M0c3WkFiTmRpM2hFMDlMc1BhMmkvQmtWcXFCZ2ZpR0Riam02?=
 =?utf-8?B?YU1qMkpHNG56WDdZcCtqa0JvNzJOK3JwMkdxbk1MNHJnTXJ1NkE4VnRqRUYv?=
 =?utf-8?B?Kzc0MUE0cHp3bWxISUpGRVRjRGhGNXlJUjZXL1o5MG5lM1U1eERsZ0JDa3By?=
 =?utf-8?B?dmhpNmhUY2RtWmZ5VVpnYWhuNGc4K3pvZ2VDUEdCNGswbE1rYVRhME9ZNlo5?=
 =?utf-8?B?RkIxenV6OEFoYWk3ZDRIb1VNc0lZQkxXT3VkVGRTbklQVHloaW94RWc5UGNG?=
 =?utf-8?B?OVcxbTU5TGFHaDlaUjNLY08zWjJ1M3FpajREY1MrY3k2L3huTGoyczZGeWhV?=
 =?utf-8?B?UU9XNTkwRmhPT0FEOXA3Q2RBUEFmY3d5djJ1ZFdYMW9sY2M4Z0JuYXBGaC9M?=
 =?utf-8?B?bklhOU5ZYUt5ckM2c242SlgzN3oxU25SVW5wT0MzcG1DWUFmd0JRVmFLUjJY?=
 =?utf-8?B?MUpkT3p0UXcwN3NCRUpudUZBaFk3R3o3b0hGUXNUcEcwRmFxdm5mQXFoZnFj?=
 =?utf-8?B?TXJCaFZqdldkUjlOY3F0SHR2RnpZdmVvOXFOQlkzR2JIZnkvbTNJcFBUdnFi?=
 =?utf-8?B?Sm1seGRtTGRjbFJRL215MTJZam83aG1CTkM3MGRtMWVqay9LdUtGK2Jjd25i?=
 =?utf-8?B?VnhNMXQ3T1BWL052dzRmL2M2cTFtYmVYVjkyV0RsT0IrNElQNGJ5ekZRL3A1?=
 =?utf-8?B?YnpkN0p1WUo2T3BKM1hlSktWek5HdjkvaUk2bzlHZU5YUXRYVXErYnZ4MU5O?=
 =?utf-8?B?TWlsS0NqcHFQNndPU2g1eFhvVk9GVE80UVBabXI0dS9Hdk9wTE9xTEtIZU5u?=
 =?utf-8?B?OWZjbExZT3F4YVpsZVpiV21SQU1ESGR0Tk50N0hBanZKWWNQRVNSRVRDaDJB?=
 =?utf-8?B?azFHQXFWWHErRUV0S3NpL1NxbmdVR1hZUjJoZFlTUnZRbFBuVkZxQzVuZklx?=
 =?utf-8?B?amJVcHJ6RVZmdHI0c25TU3FmM3VuTG42WkppMmhqMmVEelM4TThVcjBwODRo?=
 =?utf-8?B?dytNanVKajJIaDdWNW5tRjllR3NKS3Z1NFNLZExBVjVzUGtBQk05TFdLMEdD?=
 =?utf-8?B?RXh5L2Y1QmlFWjdOMDY0aGVDc2pZYkFIM0p6amkvMU9ZVlkyYjhKbU5CRnFr?=
 =?utf-8?B?TjlpamNKajl4a3lSd1Jicmk1T01taXpRSXhROGVPY21WekZpM0ltQlc1UGlr?=
 =?utf-8?B?L3lha1FVSml4NU02OWp5QVBIT3I3YnZuYzlqZndXQWlLeGhYS09kU0p3SUxN?=
 =?utf-8?B?MElWOXQ1WU12Y3NxQnpadk9yVkNwZlJBZVNZMzM1UmNWWUtYVjhEdU5uN2dr?=
 =?utf-8?B?eVkzR0llVEtHNEE5Z1Y4ZWFPWFRBRXRkNXRmOW5MV1hocVJFZXErOE1tMjZs?=
 =?utf-8?B?cCs3KzRuYm9DT3c0b0p6U01HTGFUVTNwakwyUkVIdGFiVWdlcER6S0dncWJG?=
 =?utf-8?B?NjM2a2M0aDFlLzFHQ2RtZFA1WDJUVkpHT25mQSszRzRsTEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTQ4R0ZGTFZqL3NOQ1UwUVBXUlYyRUFOL0l0YjZ1WFEvUHhUTUdxeTdrUlh3?=
 =?utf-8?B?aFZFaDQvTThFdHd5YjQ5alF2NUYwVDM0WEEvcDJpTW9vOFlFaE1DendwZ25R?=
 =?utf-8?B?M1lOVFpaODE0NWJPbEJhMnZpUlJxK1BQRldiamxHZjFXUFYvUHlIQWIzUFVD?=
 =?utf-8?B?K2NLTHRzbGk5SEJ4blFFODY5eUNIMGF0TzNsdXZXeGJSRXZKVUw0QkFwT2VH?=
 =?utf-8?B?RUVpbUpybnJacFN2NndyL1V6ZDJybUFLaTUwZ1NTVmNVOXNmc29yTUtid1ZR?=
 =?utf-8?B?QzEvV3BVYnFxMVJwWC82NWFrbExYM1NqUmo5Mit4QmVpa2xzeVhjaS9JL3cw?=
 =?utf-8?B?TmxLVjNqNUJYVEdvTVRobDRzOUFHYlJxelZmdi85cUIyN3N1QjBERHpjanRu?=
 =?utf-8?B?R1JlYS9kSkdwdXNZTmpWRkRVUDd1MDI3QnBYZkNhek0rdkt6dkQ3a3NzN05I?=
 =?utf-8?B?NUpibDFBcDk0YVhaRnJ4VVkrNUh4aFhPQ2RUaDNMV0xZUjVSQ1BaTGsvd0xV?=
 =?utf-8?B?N0EwSGVkaWx4cFJlZXFmazRPcXVjUE9KTlh6OE15Zi9lUUdqdGJYcjk5S1oz?=
 =?utf-8?B?R1Z5Mmh0UVF2S1FwMHBmWGpvb3h5OWhReGQ5MXNEb3VJMEk3ektjUGhDUFBP?=
 =?utf-8?B?NDM2WkJyM1R0UmJJZWlvd1duNHhmanRuV29WbzE0YjNWcm9jM3puVHlEN3Na?=
 =?utf-8?B?UWFhbUQzMDcvYURJVGJqemRpa3dERm1kd3FudlUwcEVwWlhFOUxPUnFmUm4y?=
 =?utf-8?B?THlYMEFhS1M5U0dzRThxZER3TTVtMEZQUEtSR20yVGlNQ20zYkFDRDFlVDBB?=
 =?utf-8?B?bnpGL1NONngwWnlOYU1xQUlUS1NhN1FoTDFkazBDYVgrWWsvZVhNT0NxcWYr?=
 =?utf-8?B?Nm5rNmpmNElKNWRoZURMT1pXbDBZWW5VTHJYZVA5aURTYXN5dmZJU1dmTEtF?=
 =?utf-8?B?TUsvV2JhL2pES2Z0bXJaRkRGb0dzODZlbk56bXBoditYZkFSU3ZYTkk3NUdJ?=
 =?utf-8?B?NnBhR0doeGZ5K0Nmb2FnaEpwNEU1bTJ1R21QU0huMmNsNXN5eWVrU1d0L2pS?=
 =?utf-8?B?d0RtYUdvUTk0UC9vejVyMXhiTjF1cWpnK0hPRjB0djVHRDVVL2hsQ0VRbmtp?=
 =?utf-8?B?RzFFbjRMdVRsZTVicG9xendqOWRBRXdBMmdmdDRBcUY2Rnh5QWRHSWExTHUr?=
 =?utf-8?B?MGdVQlBJZ05yc3QybHNlWjlZN2dQZzQ5VTQwSllUQ1RtZHBFb0ZmajVDSnBr?=
 =?utf-8?B?aGZXditzeDROa0puY1IvcG1FdTkwbFRNOStUOTJYWmZjWk5xUHJQZVRkN3FX?=
 =?utf-8?B?bWh1MlJ2djE2TEQvdWtoenpPRndoL0F3cFE1WXl2Mk5HNXM3TE41TUI2aE1O?=
 =?utf-8?B?cEJlZlZMTXVEbVRnTjVpTlIxQU42RHZCMTRPaDluZDNacFVSZXBUcml4OFZo?=
 =?utf-8?B?S2pFeGhxZHdYQ3o0S01Ra01RbFp3blBtVXhPSUU0SlVnMTNwTXYxdUlyQ0p2?=
 =?utf-8?B?RUE3dVp6WStWS2lzUUo4dmpPS2k2RDl0TzUrWkh0cXdmM0xzOENleWsrWkRM?=
 =?utf-8?B?SHVwQkEyaXdlMWdRSWxRREgvc0FkcU4vVTRCaTFSSU01TUo4WkhQRVQ1RnUr?=
 =?utf-8?B?RytFY214dTdaRWJxSTQxY3RLQVFQMStkMlp6c0NndDVLMjljRG5QaVRkNW50?=
 =?utf-8?B?aDdGSStwdWRJUHRWOFphQjgyb2ROenIwdWJtSUZlTWxCTnlMZldLMHhCRFZi?=
 =?utf-8?B?MVhicytMT0tVckZVd1RhNlJ6UkIreFdpbEtsS0FQa29BSmRobFZhRXMzY0JD?=
 =?utf-8?B?QnM3bitGbTkzSEMra2wyR1A4YXVjaU1lTjk1NFJBVUN5MFptZ1RjNkRoSHVR?=
 =?utf-8?B?cjVQdFNKUGw1M3lObTFvcnlNb0wzVUZUTzFQNXpuQldIQnloT1MwUjdqV0FB?=
 =?utf-8?B?V2wrNSs2cDgreFVXd09YZGNNdVpwTGh3T0FoZ0NWMGE1bStUK2JTMHZUditQ?=
 =?utf-8?B?ZDduNEhCSzRXWFg4NHBuak04ZDU2dkU1MUQrcmZOM0xQTVFZSE9VeEwvUCts?=
 =?utf-8?B?WkdDdDZieDYrSmtCSTZJZ2FhY0FRY0JNRzh4YjR1QllSalJTYnFDVnRmWFVI?=
 =?utf-8?Q?M06av2gsMwWnAdcLUO0wRfhwR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ea3338-aa5b-483d-d115-08ddeef23191
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 16:10:13.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mMFv0HbBy+gkEvZL4phneqkTEXpQEfoCvhRUgTYns5sc/t6tJDDOKGo8R1rUjubaWorGsmzmzVpij4JS0jr/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492

On 9/3/25 08:55, Yunseong Kim wrote:
> psp_get_capability() is declared as returning an 'unsigned int'. However,
> it returns -ENODEV on failure when it cannot access the device registers
> (i.e., when ioread32 returns 0xffffffff).
> 
> Since -ENODEV is a negative value, returning it from a function declared as
> 'unsigned int' results in an implicit cast to a large positive integer.
> This prevents the caller psp_dev_init() from correctly detecting the
> error condition, leading to improper error handling.
> 
> Fix this by changing the return type of psp_get_capability() to 'int'.
> 
> Additionally, change the type of the local variable 'val' to 'u32', which

So you have a couple of changes going on here...  which would mean
separate patches. But since the raw field of psp_cap_register is an
unsigned int and ioread32 returns an unsigned int, this doesn't need to
be changed at all.

> is more appropriate for register access, and reformat the long dev_notice
> line to adhere to kernel coding style guidelines.
> 
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 1c5a7189631e..84dde53db25b 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -140,9 +140,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static unsigned int psp_get_capability(struct psp_device *psp)
> +static int psp_get_capability(struct psp_device *psp)

This change is ok, everything else below is not needed.

Thanks,
Tom

>  {
> -	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
> +	u32 val = ioread32(psp->io_regs + psp->vdata->feature_reg);
>  
>  	/*
>  	 * Check for a access to the registers.  If this read returns
> @@ -152,7 +152,8 @@ static unsigned int psp_get_capability(struct psp_device *psp)
>  	 * could get properly initialized).
>  	 */
>  	if (val == 0xffffffff) {
> -		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
> +		dev_notice(psp->dev,
> +			"psp: unable to access the device: you might be running a broken BIOS.\n");
>  		return -ENODEV;
>  	}
>  	psp->capability.raw = val;
