Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794469746;
	b=xFNWtm886Lf/VvVmMDXws1H8ZqejpjqAtB9Sk+Cans60W4ytoADTGmOEPRyMpcfLX9XO
	 AbE9aOmh+0+MswOHUgXOJau9/mGl6D3qW4vSH3xjKWIVZxJkiYDi3KFtd2aoCsiLrdIaj
	 pGIVb7GDA/unuiVAaGTcxQ9SwgCHaqtm1RXEPAhNcqjAYbjzR/VjOv9aSuZGjVY7NyfF6
	 T+uNuhMebTxlEXy3MxqLwCxsfSOLlC0lFvs5LM5W0F68NDvyns1iLvge+G0fM4n8eKiA+
	 LsW8QpFm/AVE8pOHch3GELILXdxXqR8bgJ3WiQsb8y//bfBUeMSZtnNXnTbiZaXNPYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469746;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OdspFrhjBGhANm9feIN89uVVAr+bfRvVCJ5QVVcSh6w=;
	b=qyyKrzKaOMWepwms+05Z+MfvicNTFqc76mmAMo6Ulh+c24VbNP+umKvjm0yKJ/TRGe0v
	 5AiiYyccuANjgf6/m/x8EkD7B3sR5jQC/QP/XO/KM+C0+ApDqAMcJM7dEl+l9+VekpN5V
	 /g1K1/Jyi32NbPrbfuXE0UR7IPoYnQ8BHNUZz8ZW6c9QsRrk36rzB7mXyCQUGT9Wd5r0d
	 fhowOaCxyeCeFNP5HSNO4bzomUELf7C4pPIhSndfKCj5qvrwx4mtl0YakmZ9DDShZOeQG
	 5utI4uRatY4gUJgWis9tPgblOZ5jIiPeFXzGId+2e9/lIb1TyRX0lublkvrqsPawxTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b="ZEx/g//g";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.31
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013031.outbound.protection.outlook.com [52.101.72.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45493606A33A;
	Thu, 12 Nov 2026 07:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45493606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ZEx/g//g
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rV9hztjdU9nBz1YV0NfooUeIgK/I5AjFCD5OqnhLbM/1WNiuQNjII8hnnvWYnFjk/f7DYw+Q9zAYtSLdQ8rKgEzme968ljCtpNvxTPGxGcDeAVExuLW0NLGCe90IF9tD5CG0d21TWJilksi8Ca6BPZtjQyj1C3ADfSFsdH0FuFJUbZ6JzedZsblLtxRrnqoUMrQPEQK2OdslB4Syb8YreMflKcnKufM01D+IKoj/+hxvMarYyXOEtn5Xq3XlXMaOOtQOm5MksjNy9NYmsTMvcFWefbd8402eBKhVFI2TJcUufBGg1i9CMWjjgCCLcPCdYpz+4nRCLSL1CbTH7XkuPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OdspFrhjBGhANm9feIN89uVVAr+bfRvVCJ5QVVcSh6w=;
 b=Hy9WrrCvPc8Q1qcq7Dx2xGzFNV2h9Yi9/Adqu2Op8p7yCpJaYVfh+OCh0Uj9VomquJw1tHaRqdD6b1/olyh+TKckrShvW+l3Xs3q7qFEfLF6EchUz4X9UN1l1OSyGgciYNkoMSLPKoIS5Fuqa8y4RK/BGqwdYDR04SCtqGan3ffGC8UEuv7EqWDmS6TAcDNpYz9Z1xb1qrmQGGarmYQd4F3Ppnv5NAXEppfwTrLCTX9DG233U1gkiptnFCkoJ6i+M3Kr57T2PtpvtdUFbsGkbKcb0TVSIlW7F6E4JxwHRV3zLj6WUVrCMklHzzMV4rhOg5gVgTUP78Bnm2fVmFQXpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdspFrhjBGhANm9feIN89uVVAr+bfRvVCJ5QVVcSh6w=;
 b=ZEx/g//gJBReC1lFXeoANqEfQLo4ckZaZq6FZbIg3xM46zkHX4mzirQO+0/+OgRCcrjQR9vyJBs3JnYMmgvaRfQfkn0cViH4pRFSxmLdFEOzrWyLJySff74BO4HgU0+VQA/9wHvO9UP39bg5VTNHR+qTAIUHlmo1F7JtsqlG5h7LdirrmM42CLexITow6zRi3DKcT4maP8qphV1AZFVp52qK/x7DDL40vz5jZMlTqPepL9JozJqLcdKUhsGetrenjA8ViY7WFKV7PlWGFMzCgbu6/ag0B6KtFTK4XtBBXZQRPut/1Ga+fZ88NOAkFCOwnwTXMzZFcFLEY7J5LLJoUQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by OSKPR04MB11367.eurprd04.prod.outlook.com (2603:10a6:e10:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 07:49:03 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 07:49:03 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] crypto: caam - Fix wrong unmap operations
Date: Thu, 12 Nov 2026 08:49:01 +0100
Message-ID: <20261112074901.462686-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111230221.40297-2-changwei.zou@canonical.com>
References: <20261111230221.40297-1-changwei.zou@canonical.com> <20261111230221.40297-2-changwei.zou@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0089.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::15) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
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
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|OSKPR04MB11367:EE_
X-MS-Office365-Filtering-Correlation-Id: d8a99284-434d-4511-3157-08df40916bb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|1800799024|366016|18002099003|22082099003|4143699003|11063799006|261026121527099003|261009223027099003|56012099006|261021121427099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	yekhcsFvsPxt3afsXGscLhH1x2FSuDLJLSmJsyYUvnTtgBjGHIGnIJtuYJ8LRmMIH4bNtdrcW85dJvvHGaXbq4uGQzTw6SBbFlsiQZ1xcZZn96AmJ2SZLgemXsjPK/WMzPOpM37rSehcHa1UW5e1uKw2Cu0LWr+QQQH2R/eM7CZ/W1DuUbn9ZztXhBE0Gi+f2eXXdp35tdGaug/d/PVIZR/DNh8i/+z5MwkmfNrpbgsClhciOezoSWwrdowCPQXuKENHh/VmRgW+DklRBN6Q0mAsoy1hOO4U02ZqJADuDfP9yfuEse5/LY0waI6J2WUMKPFnzHiGc61+80GxZy7SKrg6r+F9MkS+MPQS2H+bu7o8t7wc8Q1zy3K28sHm3MxOUgLpUtvXxjbV7J9VZPsw7efA6cmTAdtpDPpDQdqQbLIJEdcX6aYpVLosVnN8box4sj6xdqfh+fk9EaI+6gMP4ImLqwRZYqqvgzXiEVTMsxqPN+W+slv9LpAvgeBemNHKpF2hZ/0dRnMP+ROAUDB9QjfiBBJ0lwyRSsm8WYNIMfl+dN+gZqVTHQgaKl/56eODNUpxqR0igCVCqs57NQad4G5R/DRr6G+QlIrGmWmieHVfAwla2hm6BpjcMjMGN/TvPjhl4Wipyh7WmIvtpM6B4IiK1aZ2Q64ZJOO7be6wilE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(11063799006)(261026121527099003)(261009223027099003)(56012099006)(261021121427099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG9Pc0RIQ2g4ZUJRLy9adGFiV2o3M29icG9aczluNEdEbHRWQ1Z4UVdVMkho?=
 =?utf-8?B?bXMyRFNpWnRWalpXYXgyM3FYRzV0UHozaG5oN0U0MFA4NWR0RUxHZ2o0cUdF?=
 =?utf-8?B?UmNpNy92TGV3NGxOVzlzQlBCQTI5WWZPZ2tyYnM2N1Z5bnk5WExuSnFRUjVO?=
 =?utf-8?B?aEZRWEhTZDgvQm1Eb3FOQ2xIc1JQSldaTjdzVUkwNHNaZGJ1ZlY1UGoyOFJr?=
 =?utf-8?B?eW0vNE5IMFlhUXRoWEI5VnA3L2Z6VU1ia0VvWTFMd2xUTjlENmV2ejB1R3dY?=
 =?utf-8?B?Z0VkSG90OWo4Wm1OaW85ZVhiNFZYZkRTNnFBZXROaXNEdWp4Z1gza2d3Zzlr?=
 =?utf-8?B?Ny8xMllUU2pEckk0Mit0aXpjYlkvYU5nRDl3Z2NVTUdBQytkYUp3bGxpOVJz?=
 =?utf-8?B?VzcxS3RIN25Ib2FvdTkwMlNEeXl4SXZIcWpPVUpoVXdHTmZHZU1iMWFmQjhK?=
 =?utf-8?B?SE9rSmlWUC90R1dtWkVEcmhOMnJMbGZRNnhGMlQ2aVAzakNDQlMwT0dsNHBC?=
 =?utf-8?B?R09rSEpYMUxHbTdTWVk5MFJNcHQyc1lwYzF4c0tERlY2ckJsM3J6S3FHVkl1?=
 =?utf-8?B?WWQyKzNTUldWOVY3L2NZbFRKN1BzQ3dpMEVURGp4czNzenZ5OFF3T1l2TXh3?=
 =?utf-8?B?TWphNGNxYjlNL1RidU5WdGFGdEx3Z0FQTXFmelgwL052UjlaZThIdjVQVC8r?=
 =?utf-8?B?RGhwWEpRbVQ5M2VXREtLYWlnZTJZOTNQZUdRQ1RHc2VIN0RQeUM5b3dibHcy?=
 =?utf-8?B?TXdOelpOYWNqeWJGQjNhTVJ1WHdTSzUxbUlrNzB1RWFFaHR3TnVBWG56T3pP?=
 =?utf-8?B?dUw3YWd1cDgwQzZXWFgxNmgyNnFBWGMwUUs0VWE3anhpaUdoWUhQSTZZSTUw?=
 =?utf-8?B?VFo5bTBFUXh4ZTdyamdsK1VlS3lOOFFpYmRORisyN3RwNzR1U1pBOTBzd2s4?=
 =?utf-8?B?RXJQYmhkQmxaenJNK3dUSGNGT0hCV0lQUzBNektPbUY0SHloZU9KSmIvWm9t?=
 =?utf-8?B?SGJKMmYzM3Y1S25pUmJjZzBtdUZUbXRXYWR5MmQ0WW04Sk9NdldnQnBPUS9M?=
 =?utf-8?B?MlY0bkloR2V5Y2xpZTg1UnZJMGlwaHpmZWdTMjFjNkx3Q0VpMnRIVDBpWTRv?=
 =?utf-8?B?SEtHSGVpcnQzemtRTjAraXh4dEs0Y28rZDhFZEg3N01BUENtbTVLMzY2Vy9j?=
 =?utf-8?B?WXYzYTAvemFodVNndGxKZWw0UW5vV2lZTjRMS285ZS9QYWtaS3Y0dDFBRExC?=
 =?utf-8?B?QkkzZng5L2NtUVZPTVJXeUxPL2pFdzQwQ2JEbUNkbTRqQS90NzBQSkEyYy94?=
 =?utf-8?B?TGFLeU5FeG1UMGJMazVhUWFjU2FnaVkxNy9oYi9HNnFNVzhQbkkvRUxLWUNr?=
 =?utf-8?B?aTlmLzNFSWJwWWZLNGgyQnFRdWVXQzZCZHV5ZTZ1cVRxV0N5K0U5YUZOaXlo?=
 =?utf-8?B?b2tkTVpLTE9EZDBwdWZMWitXSUEzeFhzVjZSTHphazBoZlVCZHFvMWlUYnEr?=
 =?utf-8?B?V0hhb29mYWJQbDYvVXZXVGZZd2FjTFNlVFYzdy95M1hWSitDejhqVmVDUHZ2?=
 =?utf-8?B?eStxdGorVzM5eWcyQXJuaFV3QlFVWlVQUFZKQ1RKMitVdHRZZkJoa3orV1Y5?=
 =?utf-8?B?UElGYWZhcVl0clpsTTVGblprSGRqZ3A0TVRlN3oxeS80clkvazdDcStPNEl0?=
 =?utf-8?B?M0RZeHNrWXFkOC9CbHI5a1luR1d6RXVlbHRoV3ZMZUN5Q0g5NmFQaWRJUnBx?=
 =?utf-8?B?WjdaSXQ4THFGdkdEQnRaYXZWcXBVNG1aVXRuR01SWnBaMEtZQ2NudXNHVWhm?=
 =?utf-8?B?Vy9tN2JsUERMSk80bWx6WFVKTUpSQVpGRTlmRWJSOXF3YWJqS0RiU0NZSlNE?=
 =?utf-8?B?dExlSkQrZktKSTkrUndvVURIUDdPYU9UWmhHNXZPcVhuNEpRYU1yY1dSTHVs?=
 =?utf-8?B?RlJ2cGwzTC81cjdiWE9YR1ZCV0pJbWZDeTdNR0MzaG5qY3pRdHVVZjU5QWlG?=
 =?utf-8?B?SDRGSDZWbkRCRVB0TXFMck10L0tSa3o4TklpRzF3ZGFkMVpHRjJic0ZWVmNU?=
 =?utf-8?B?NXhDYnR4aGhiZkdDc0lwQXhodm1IVTY0c2IzV1hkUG5iM29OWjgzdWE1ZGd1?=
 =?utf-8?B?TFJyRnBLcCtsTFRYY2VqYXZMbWhQcVhlN2tDa3dsbVEyeXdsUVJsa04xQ2cv?=
 =?utf-8?B?RnB4Y2tMdWQxejZKMWtIWHNtVm54Rmsvd1BjQVdLUHI4enVUZ1hYME5UZkVM?=
 =?utf-8?B?OTVxU3d6eXptdk9ZQlNERVlBc1ZLSDhrN2ptRXV0NEVoSkNna2RBUzZwanpO?=
 =?utf-8?B?S1pHYUtsWEZPUUhualR3TWFSSlpHeGxzZ1BtL1VlL1cwNE1Ta2lsVzRvTVN3?=
 =?utf-8?Q?AdocBp9Tni8/xaeNNVtuNeFP+WAtpBMf30+U6HOkA0xFE?=
X-MS-Exchange-AntiSpam-MessageData-1: kEWcndl2FV9QgA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a99284-434d-4511-3157-08df40916bb3
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:49:03.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTFPHKj9zowKDaL9wVecAFloIgZ8fOH3f3ruMFjQOxujzAP7QX923wXyRO9m1O94Cl/NV/dZrK/oc6Qm4z7FQrvmD2DmuVgNEh7tQejihVkeUw4DZ7U5BqM9n6hZMDir
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSKPR04MB11367

On Thu, Nov 12, 2026 at 10:02:20AM +1100, Changwei Zou wrote:
> Since priv_form only takes values FORM1/FORM2/FORM3 with no distinct
> public key enumerator, rsa_pub_unmap() was not called correctly in
> akcipher_do_one_req() and akcipher_enqueue_req().
>
> Use the completion callback (rsa_pub_done vs rsa_priv_f_done) to
> distinguish public from private key operations, then dispatch to the
> correct unmap function based on key->priv_form.

Hi Changwei,

[...]

> +		if (req_ctx->akcipher_op_done == rsa_pub_done) {
> +			rsa_pub_unmap(jrdev, req_ctx->edesc, req);
> +		} else {
> +			switch (key->priv_form) {

Nit (not blocking): this public/FORM1/FORM2/FORM3 dispatch is now
open-coded twice (here and in akcipher_enqueue_req()). A small
helper, e.g. rsa_pdb_unmap(dev, edesc, req, cbk), would keep both
paths in sync.

Thanks,
Sahil
