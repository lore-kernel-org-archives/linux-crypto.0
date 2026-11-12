Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794469747;
	b=o0/tdFqbqJX+FhVGNtxhLqzmBuHxdaE1ZjU6mEvC+uFnq0vZTrDd5S8XbLnZcYZ9IwhC
	 OCB/P51LJrM9QDVGAiCV1rUMG2um3RWJpVjXnlpjm+PciSHizEl5fhTAXfoiiskzn13P7
	 ztZ2G6RUqSJHVhQ9bRSPAV/LPMpZmWzmDY1WudvWClO96Rs8espjqVVJqB1ec7Ato/+6p
	 lJwnXnTyGJrZImKIv7WO+WR4QpYwJerkHei89sJsPI6L0qGd4N6918309/39/g2WhhRcx
	 oBsSrTnCwY4AUz/U/CDnfMZFaEovIQWeOAWIPZZi+hAJhapFNeBhhhCOADo6plCWQzQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469747;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=Ozl8ZeMsV0kH1hnZO3VystZbTs2G7Knw5UEzzIPmHtM=;
	b=Ii/VJOdSPnkDX8NK0X2sop8mT0TaFEexHW+RJ4ascu7z0LTyV+fF9zsUvYIAglWcT7Av
	 8k6Mfw8JjM7i80WJyFl1I/Z84NwFCaDr9fxsnAhH/3vxTIH0mobGW1IRCnsJCJMDv6Qt6
	 7f+gcgewmFAmhtk4vNl473SSSRgflSzaacIBrdsTIRbUZbnPv+n9Dt5jJKGw5kohSCHfV
	 uWgA5eUKLT3I1i5R30plN+zA69URbbTyoU3jwZmU3YCc2AZpFgqC4IIKRwhBCmDGsIzy6
	 1aTkD8HjNW4fHeyaX5BYZWjoqSH+ENK3kzABCWkFXViUnnckHmV+oaY7PHMIF546Zbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Aqq6F1bo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.31
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013031.outbound.protection.outlook.com [52.101.72.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1175E606A8B4;
	Thu, 12 Nov 2026 07:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1175E606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Aqq6F1bo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFG8EQwywlkwPkNtDzok6ALAiR2dAmS9nyzU5CxLt76lvWYI+Z0MufJzv0mtUnR+6iypIiVf3N1H9yBrEjVUrcbRwfWhP0TXE1S/4cOfILvKvCDtk6DMbDHNnW3wICPFOyxkZluvS7rDOc+4rhriMfR/667Q75CRYdgwDBAPZoI37o1M9LllrdyK5JAHDN6H31BUlgN2EjsW/gv6vhtKuu/1DDGoFyr7NMZ9ed0QhXc9SJPaXpxJhKUGN7OBwx7g2e1vXsgyx0r8taZDroy1tQZkCFUr/t6WnEpMhB8EvbfYg/63uJVppmhucry9e0bKoy10znHv87qi0VOZdqg3Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ozl8ZeMsV0kH1hnZO3VystZbTs2G7Knw5UEzzIPmHtM=;
 b=Ano2OYe5yiQxUVWa3sJDZHchnb9FQTOrgnIawHJyQIvpXy2xXUYnmiEh9nBsZPnwqEbWxGEuC6oWrQXiwyDhiX1zpGDt2dSQ3bsu0yQMJ0smKC/XMoDyEo91f32UQxhBkiaPUn0aWdJ0ONLfGTHRlqZgMdxxReG2autbpFzlOEQCiLTRL1d0zY+LXSRUeCPbB7IjUi4CAWiHLFPJdnLnd1wCVWDwFYi3paOSy/8b9eWbTgmn9P5FOLBGkZT1/URz5D3ugGv6hI68Aab3AURcpGJQptFM8J5m8fnerqsZN95XrpPnOXoj0IZw0oMHf2s5UkN4DfWB0/MBazg1/zj5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ozl8ZeMsV0kH1hnZO3VystZbTs2G7Knw5UEzzIPmHtM=;
 b=Aqq6F1bo9+5rT68qoLcz7TE/ggLM9tw2VVzvRY7IbDrRNffWiBI4XR+LxpuHU/f5ENaixDTicpsAFpXI7G7SWPC2C3Xj18Y7lPPuONPflk9y/zTxjp2CAFGVMC+f3ZYIxzfo8kZpYhX1my/2sOq/WdeDZ+Ve/NLawjzP3IxTeuINl+VuxTX3I2/uNRlbTxZQs/3MwTymIHbc9RG5URkoUZsf3Hcpp78YVrHZ1CZfzud30Mbna/dHKZp9XrdKXz1wDxU91Z2bY9wNDJou4pIpAUBs0Wc8L1x4UrLPrrfuMpOZxy2PCsNkK7mvImTYIzf9iol+cd30k2uyzb5wwH0xcA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by OSKPR04MB11367.eurprd04.prod.outlook.com (2603:10a6:e10:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 07:49:04 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 07:49:04 +0000
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
Subject: Re: [PATCH v4 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Thu, 12 Nov 2026 08:49:03 +0100
Message-ID: <20261112074903.462744-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111230221.40297-3-changwei.zou@canonical.com>
References: <20261111230221.40297-1-changwei.zou@canonical.com> <20261111230221.40297-3-changwei.zou@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::9) To AS1PR04MB9358.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f714e893-95fb-4f36-eda4-08df40916c93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|1800799024|366016|18002099003|22082099003|4143699003|5023799004|11063799006|261026121527099003|261022105027099003|261026140227099003|261022075727099003|261009223027099003|261028144727099003|56012099006|261021121427099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	+9+pRR4GWXK6aYunY48ORXzmgToit3KqdvHrC4gQsOxlblKgph8ykR4+9Ya+cp8IPCMN3U5rLRO0s0SSm9P6DYK4qNk7S9cehrk1Mk7hkFJNeBsQDiFvmRh3v5Rtk57a74RY/WtzXQnUm4UpmKMK8bzByLhMFDuK2QavobRBMA12r8NP92ji0TH/e08hQb/t82jPwShGbQOTN9xxZuZjQn7vKyhu2e3RhR9e6cyPDdxwmQRKN96PLTjXN3+5uAGI7UNcoCfMeB9DQ5mySjHaNVKjNtOm+xyVbzkurjTpe0W6YU5GYxPtFehxU5G/0s16Pb2XgnEYrASg6e5NJCRaN34+eHTCMvEytGLZEQEbcSJpJDVzNFCVKUEuNufN8dor/kn3H+FXoyIx+R/9tYruRxLSFO2rdhsKcmHKxkVDGT2Xeplz1LgqzsELR/vw50yIgCd5RW5xn/BjKrqKdfY67opnnjxdQVO/LpoGy1rXz70IOEGQz+JQkobmwKEePGWIOqmzJ2igoELxOyGGT4cYIfxEpPPl1VdBC12W32S0sE/M1+jo/HyNkHdA0Bu9oq6NdbcWp8b4Fy91NOlu+vtSh5NrFa1BvpR4mHIKQFKLzoIuKC+b2nBeqi20kiA/YGADVL6/MiH0s43nIdRV3hXo9sUyxWXDYG1lBWJK++1GPAE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(5023799004)(11063799006)(261026121527099003)(261022105027099003)(261026140227099003)(261022075727099003)(261009223027099003)(261028144727099003)(56012099006)(261021121427099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkQyOWVPdmFpczRJR1lnN0xOWlJ6NFlpdXp0RVRsdTZqRkw5OFBSTFZtNDN1?=
 =?utf-8?B?TTQyWmxwWnIxTWNTS1o5RnlJQXdQR0Q5REdndzczS09ZTmZIaktEWEpCZ1Vr?=
 =?utf-8?B?SXA0WGpWdTY2SVdvNC9GNU9sdDUyWkdsWTdxNS9BZjJCNzRCM2M1ckpSRkt5?=
 =?utf-8?B?ZUsyZ3B3VDNoYUZhMDVoei9vOWY0dUIxWkh3MnIwTkpBU2ZkK1M2Rmo5cGlP?=
 =?utf-8?B?aFYxeVNLWU1KclF4cng4T2MzdzhhN1FBRkFmZDBKampXOVdydU9QbUlzWjBy?=
 =?utf-8?B?UlNWVSsrd0pEbnphZkdGSGE1ZzJORUk1TG00U3RYUFJnRmljR2p4T1didUg5?=
 =?utf-8?B?MXZ6V3JRVm9yWXZCTmhXMExrclduOHJnNjFZM290Tmg1QWNQMCt0S29CYU1I?=
 =?utf-8?B?OXA0Ymp1dVp6WkF6N0Jtbk0yVG9VQWswV1lFeENVMmxCaGR5UndLSUNpY0pm?=
 =?utf-8?B?Tm9KdkZtUUtnaUdHZ0FxZzJydEl4T2Erb2NSS2YxTy9mZ2gxUGZ2Yytvdklu?=
 =?utf-8?B?K1ovREo2VEV1WUZYTThSYmZRcG05TkthWWpyQlE3TGlzRG1nenpCdVZZS2JB?=
 =?utf-8?B?U1R2em5EOWEyc2dwajBDM3ZwZDFBbkgweTZBREF0VlllMVdaU3dXUTc5M2JU?=
 =?utf-8?B?aUpsNXJTZ3RVc3E4c2RRRDdoekJqdlhCSUlkWUxLVUhmNFEreFhMODdBazhq?=
 =?utf-8?B?anZNcWtzakhWUkdYWXZ6NTh5ZXJRVitTMzZuSmFsMGFtS3F2OGtBMHFHaDBZ?=
 =?utf-8?B?Y3NTN3dMb2c2NWZUOGQ0OVhxVVJ5LzZwUE9vZG8xcEZuQzUycm5WVEk0YzJ3?=
 =?utf-8?B?U1R4MjN4QWZHanBnNVZabTJlS1RXVVZEcmlqa1o2RTVWTUNDUy95TTd5a0N0?=
 =?utf-8?B?WTJJNi9SZ3UyU082bWNtYlNoMzRSbmtGTE5ZTkZVY2t4R2QrRXhYOWhTUThl?=
 =?utf-8?B?UEpsQXpXREFOZE95ZHdlQU00UWZoeGduTi9FcjZOU2duNWdnejJ4eFkxeHkz?=
 =?utf-8?B?SXRvOHd4K29OMnZ6UGM5dE4wZ3BRb3RCRFNVdFNqeVI3SGRXYXhZMjZOcGVJ?=
 =?utf-8?B?Q3NiNlBYYmFJL1ZEUXNIelhra2lHdkRzZ3RHOGs4M0g2dU5JU0twc04zYXEz?=
 =?utf-8?B?RkpWY2pwVk0rNW03Ulo2a3JpNURPYXpYV2ZtY1BOSUJWUndLRVVZckh6bDhB?=
 =?utf-8?B?U2t6bU8wekZJOTBVdnU2TE0yQWQ4YnZPZnFVTlEzVTh6anl6NjBENVowMWtO?=
 =?utf-8?B?VHBDRmpFQW1uNkV5ZG0ybTB0aUlqbk02WkpVM1RLYWIwS0ZJRGtFK1l0QUVN?=
 =?utf-8?B?RGkzRjlwamlYTThYUjE2dFpaazVhMzZlUnQ4NWR5dzlxVlZ3RjlHVTkxYnNr?=
 =?utf-8?B?Wm9TNTJ0ZTV5WEFHN2RXSkl4MlNEUXVlR0pXZHpLRmdkUGVNbWJIMkVyYjVy?=
 =?utf-8?B?NDY2LzIvcWUycHg2cGFiT1dFMEFmR3JlMmtHUXBJeGNPbWRxTGRUSTc3T3ZV?=
 =?utf-8?B?YVhNMlZscjRBN3J0bE5CamNoaVBndHU5dldMYzNvaDQ5MGpNdXhZdDZSNnNK?=
 =?utf-8?B?UmdyamJlL3g2TDJwMnVJc0VuRHpLcmxTTi93Y1hrdlBOTFRkUTc4eURDUTVC?=
 =?utf-8?B?Rnk3ZEhxZVE3bjVaSFhtS1R4K0FDYllFTVFXVEtNUEJrZVBlTTZ0Z2Z2d2l2?=
 =?utf-8?B?ZkgzaW5uN1FZSDNBZWJBUXhNSmhqR1RQQ0xZNzcxUnJpeE5LdEladXdOelR3?=
 =?utf-8?B?NnJZOUcwYzFNTm1FK204SHUxa0pJaUNtUUpMakprb0M2eVJJbysraVJrWWp0?=
 =?utf-8?B?a1RyU2F4alhWMDVIYmh4ejExaDJCL3JmejJueGh4ZThLTGZGWWRNL1BldFk4?=
 =?utf-8?B?cGk4S29SMHo5NE1TVUNDY3FIcmdjYzNnQU5PVDh3aG1jRTd6V0xnb2Z6U1ll?=
 =?utf-8?B?RnNHTGovVjU5akVkNDZoSTE3T2s2eDY4TVJXL3VEb0tNazNWWEUyN2tnU2ZW?=
 =?utf-8?B?enIwWW4xWHZITjNCaVo4K3hVVW9iNzhBRVdLU3JIQVY0eGJwTWliV200TEhJ?=
 =?utf-8?B?Q1lDMUVZNitGSDVhZzFpa0xrcEZpeVlLTThmcUhlMFQyejF4RVdPQXh3bUUw?=
 =?utf-8?B?Y210Wm5MaW82Vk1WM3F4bklBRGUwcFpGV09JbFd6MWUrY2JnbU9VeWJJM3Jh?=
 =?utf-8?B?VkliU2lWSG8rNXNQZ3Y5akUxNlRlYWFHdytGY1FvbldhRTltYVFpRUNZU1I0?=
 =?utf-8?B?eVVHNm9VMGxKaS9kWlVMM0JYd3YvVml1WWllbEkyZnd4L3YvWDI1ZHFwd1NP?=
 =?utf-8?B?VWRSVExMajhOZzhJS3dhSWNuRmgvNmxGNmJSa2xVUE0vb3FUbXBqZGlVU05v?=
 =?utf-8?Q?n1S2pbFAVcmYTq+iY5BIUSCNDCxA0E9wxkFA2?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f714e893-95fb-4f36-eda4-08df40916c93
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:49:04.7463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJ3wNBYCQnsBNG8LFXvVGQy1AyoqTYanIUheoE7Y3Tyc9Q7Qv6Vm+foJI84Jw3CSzKWC3n1tIf43eJabiiR4NeogMb3GslkSVpnnlm/WUTq1/i5vd+I/z+WHbjgC5+KU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSKPR04MB11367

On Thu, Nov 12, 2026 at 10:02:21AM +1100, Changwei Zou wrote:
> The rsa-caam driver directly DMA-maps the destination buffer supplied by
> the caller via req->dst without checking whether it meets the cacheline
> alignment requirements of DMA-incoherent hardware such as i.MX8.

Hi Changwei,

Thanks for v4. I went through all completion and error paths
(rsa_pub_done, rsa_priv_f_done, akcipher_do_one_req incl. -ENOSPC retry,
akcipher_enqueue_req incl. -EBUSY, the init_fail paths and the
rsa_edesc_alloc() labels): unmap happens before the bounce buffer is
freed and nothing leaks. The v4 bounce_len change is also correct.
A few comments, mostly on structure and the commit message.

[...]

> +	req_ctx->bounce_buf = NULL;
> +	req_ctx->orig_dst = req->dst;
> +	if (req->dst_len > 0) {
[...]
> +				sg_init_one(&req_ctx->dst, req_ctx->bounce_buf,
> +					    bounce_len);
> +				req->dst = &req_ctx->dst;

1) Please do not overwrite req->dst. It belongs to the caller and is
visible to it while the request is in flight; it also forces every
exit path (and any future one) to remember to restore it. The driver
already uses req_ctx->fixup_src/fixup_src_len for the same purpose on
the input side. Adding req_ctx->fixup_dst (= req->dst or the bounce sg)
and using it in rsa_edesc_alloc(), set_rsa_*_pdb() and rsa_io_unmap()
would remove orig_dst and the restore logic entirely, and make the
patch smaller.

2) Commit message: on arm64 with CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC,
small unaligned kmalloc buffers are already bounced by the DMA API
(dma_kmalloc_needs_bounce() only looks at the size, not the offset).
Could you state which caller hands in the misaligned dst in the
module-signature path (offset into a larger buffer, stack, ...) and
why the DMA layer does not cover it? That helps judge whether this
belongs in the driver or the caller.

Thanks,
Sahil
