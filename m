Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735571;
	b=vPj1Kp9EQnUlGzhtv9Jn2rAa3XPbOqOeXhWcyxYToqrOmZGi6St5NOBxhx9tc6k7Jfy1
	 VJQDH5/cWhqsUjTcaKwaeVOLuToVnX8dMDQJCy23g7xmUIFmqniJlbRCHYFQPaicURRXQ
	 1xFB+xD98hYALwYglB/tj4jHcxiYm8A34y3h1/uUvRpkeaMNHdZw3jYTwNGMugK/tYEDn
	 euMW/fUY74umTW3bcINNGT2qyNfh14fPwjA7xzD/baVr6X6W3+VnfQ3RyH8yg3Wh+mm/d
	 uh2mVuQbvd8gF8Hn1tEXUJcIyYsSiqjaTl77pebmjfXQQTp+O7KmjD4SCgmAt6uvZfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735571;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Oml+f30RrdEFrEn91E1eyPWN8LvzRQxJK5H7WJo8i5Q=;
	b=dmVAH5pl8zZX2t76dySIwN9CxcTCNe/iCDCcL+mnMf+05fGXVtaIgoCoGd3R7Q/MAEsv
	 vaGHoDtGPzlBEz5CQoKGW7fIkTpUpUuuLLgr905xAezNqO6sn2/YD9/ns1I+CQEx1vEmp
	 TOdJRmrnvSkGBngkRFFdBulzmqyKmSe1opCvGUElm8t+ieO1mp2cRfh4HCcll6o8rAu9G
	 FvpfWDQXpQCGfYoxbr6o6UO1XF6/sxA0bNTCEV+ku3xppLWxpwJ5fbubFIvWrkymg1XEA
	 XZeVVS6j6fwm5iOTQwVD9iBMc6jy9liDaLYY7EeNBtHEFjhlMCFEOz5Bn5H1dluxQbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=sTsXpEzT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.29
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013029.outbound.protection.outlook.com [40.107.159.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92444606A32E;
	Tue,  3 Nov 2026 19:52:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92444606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=sTsXpEzT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1yue04S1s195MiDXTfnqUoGHlxBILWaBgrfI4Q3jodPm6PEapqHgR4nfT+SxU3JaeirwSUA4802dwOop2I9Ke2lLtonzMb2WSHd0rrupZseqtnb8ez+ugHd2n4YosItW3/tHrbkTiill7xMOiRWShm4fV/378vF2sdKX4DRl604GiMbcYwLLXUdtqtL6q9yCJAdrqiqytE1OtZvKZ9iMDIG1hDXrZWSTgh+9fb9g3Eq+Brw0Bv/gxL1XHtELJwHO2dXm2dTxOkWMgJgnrlnPaHkkmX+LwYRLmpPMTQMAD/+SbJiwKL8B/rB4W+n4G3hU8YNwYsYiTVwBeANiVheAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oml+f30RrdEFrEn91E1eyPWN8LvzRQxJK5H7WJo8i5Q=;
 b=X5T5Xv8WCTGHJue9dPOlR6ySQNGujQu+gmwWy2HmD3D5YDVy1uE/TkrNRRCm2clMIGY6/8tcDIsC3U0Ac2xwVnZ+L8zUvGbKCzntIWX7W8/PaUoTi/OjvM4tdaf0H9JhoFgbqKM5wHESArWJ5hPrdTx+CFPgyFKBprVZMMep4K4CozMoNgOTYGvFvUjLP8kyoR72kBXZTOdokFvHalFIiABd249RmmCGEVfPzrlwJv7gK9A7NO65HjGILPSWWruw6o34RpfGHnA7bi8Lho/+Fy21rg2KAWu4cxi/wR2eiENdYXaeP++IDnpslg9C1+qE7xjjNMv3fofWyzXRDbkIkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oml+f30RrdEFrEn91E1eyPWN8LvzRQxJK5H7WJo8i5Q=;
 b=sTsXpEzTv4e/JeEywaRhJydiAXpq9pD+6XWWHoqNNhXlwxfiF/qBQ0GDryYqSrHv3A+xptkMGeJ0d9SJk405BPDPP8rGXW16DDZAHdLU0Z5xGJQw+Cm/QsWJXyLM6FGK0E+/JlsAb6vpByYrcIiFR97DFUYMBcVrIhv383ntRBJuewzYpoB8hGi4rgGaHSHFr3OrhhnptryEwLl1NEG+PGWW2sOevs4ql0FlI4S7wUwPsQGOpkh5+A4cPQguEjZJBmGdY/pV0dguQNTTte5fPrSJL1QBsFWuHrP72vaaC3m0VsRewbP5+Cfd5VLFlyqyTaUuPQm/rsjzr99ISzHDKg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by AMBPR04MB299223.eurprd04.prod.outlook.com (2603:10a6:20b:7d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 19:52:48 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:52:48 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:32 -0500
Subject: [PATCH v2 1/7] async_tx: use dmaengine_desc_set_callback()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-1-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=1253;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=n2EBs7am2N9pbCxd3/SlttGg/OJIT4ORc5S22xKHPuM=;
 b=KxmdUNh9pqXs0lP6sE2he6f+peow0fIOhh3ZhwABMuB1tB2XBQ4HG1lYHlZPCVRK4kZCNovSH
 94Q8I8RPCdIB+6InLaH/GIyvWexVebjwh844Wt/A/3VNQc1PAaPkgoV
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:510:23d::24) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
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
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|AMBPR04MB299223:EE_
X-MS-Office365-Filtering-Correlation-Id: ba440ebd-8539-497c-959f-08df39e4094b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|261021121427099003|56012099006|261021123027099003|261022105027099003|261009223027099003|261102123227099003|261026140227099003|261028144727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XBAbZCK9LCJeaoUbrKDSadUidZclrOr5Q8j8X+Unl+FPdxpO07AQVQfW6R2Hjo8/5xM5kXtHtyF3EG/vnoVFsfTvQvrtgGtnGeqVEjH9zxMebpS6tXEWp7juqVQDBOPDMvkAdlJv9mi56Wh/Ge42z/HKlurvQR+II79IbwX7Sg8GkkK0QflVZWKSjMKHiP5X5iqQInwuYscXgP7fgyVJEvVWEA8kOahsxw+CbSavd+I0JvgdxeJKMyZxZPV9EryoTsVKpX3fK9aifcIZTBPjHAd9JQVoQlskOKDL64to7xa09IkVvwHbez0Ppl16X53bRLMzXAup4RWSyYxuLl6dIr3nVnImw1y0qIfolaWEZn6PvfebKJ9uTQg2hEYs9j70XmXEvzCu7406Wr3i1V2CygOU5/E7f50wagDWqBu33weptdJnSQ4AinwAt+N/PAQgkXe8UqyoQeI12WBu1EseRINNG3t5imEhJfRVcf/+XpxofcEcxXt7rPUJL9D0To/XpusUEvNqGxHcUFIwUzvxh+ZVNt1ZctTkWppiAau3j3J3Uj1wGOtWdMJOP435KSaOrzqd9knRZTwyTRKPRPNWrR4T5IGX70YiJDPGd8F0wF/mwbZMhY2k4Jv0YZ/3kGWTb6v0BXlvfsJ4orYz2QW5aBaVSc3OVYDh2Pa5mJWkyXA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(261021121427099003)(56012099006)(261021123027099003)(261022105027099003)(261009223027099003)(261102123227099003)(261026140227099003)(261028144727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekhyOERDMXFVWVA5NUhpM2diMG1VRDJUN0hiZklreVUyOGw5UEhXMGp3ZDRG?=
 =?utf-8?B?SzNYNCtNUVVSc0pTUlgyNzBFNHhiaUVrOWtWcTJuV1NEemdidlpsYUEzTC95?=
 =?utf-8?B?WHIvWnF2TUhHMm1yTHJsRC9HalZlRTQ1OHhhZmJrdVd4bjZVOEpnWHpDNWRz?=
 =?utf-8?B?MkdIQzZ5ek9zdTU4cXEySFM3TGZqczYvNDlCRHA5TEs4ZHBVc2d1WHBmdnlN?=
 =?utf-8?B?QUsvU3grQ2MxaHJwY0gyQUx1U3VUeG1WbHJBSE54cmk1d3lnVFM4bHJoRnUy?=
 =?utf-8?B?VVFKcXVJR05tR2RSMzFHdWhFUXJsVjNEYUpIdzZiQVY3L0c1dTgvM1RDL280?=
 =?utf-8?B?bXJhNlVnZnFrKzFGc0lVMzNGUWE5Y01HTmFvV1dkNU5nN2lQVkwrVVZHeThz?=
 =?utf-8?B?TlBpa05vaVljK0xnNmFWaHN6VGJ2TUVBWVFNV0l0TDN2RUZubkt5ZmFTZGow?=
 =?utf-8?B?bGo4K1BnbTFoVFVZa2daYzh4dEdkVjBYaGFUYkJXSy9pcXByZzFrUEE2aTFH?=
 =?utf-8?B?OTJFVWV1VWQ2NmJ6S3phMlFhMTl3LzE5dUNuVWdPYmNVYnlDdVJYbllMSmhh?=
 =?utf-8?B?eEFKRHBqREloNHU2eUpoeVlobVZoQ0pTQ1ovV0xLWkhBaUJ1TytFOU9BVFJF?=
 =?utf-8?B?UThqRkNwODRla3FTbUpBanR0NDFYOHB1NU44QmQ0QVFJMlFCcSsreE5udTBr?=
 =?utf-8?B?cDJzRlRkdzAxdUNyM1hqQ0REenQwYnVobm1OY1lOL0VsY1htOE1tcWQzcnV0?=
 =?utf-8?B?VFI3T0FQaXQ2ZEdqV0k5TnpzNDJUODdMWitKdkhOK3lDcFlIb2RTdWpUT3I3?=
 =?utf-8?B?ek9LUWFjVk5sWUJ4ZmdoZFJpS2JORHNWQ01xdmlUcFc2RGlINUFIL3VtNnpI?=
 =?utf-8?B?U3VYK0ZIWWV5NWJ0bXJtL0R3SlVSSUxOUlFEc1c1QjlzRE5yTnpramxacDZS?=
 =?utf-8?B?TEIxVDRZeUhNcmZDOWF5ZVJrRHNJS2dxMlhVSElFVTVva251YnRaeU5zcE9m?=
 =?utf-8?B?aVRsdlBhRzgzRURSWndTaXdOeFF6SXRFbW95ZjJ1b3Q0VnF6RlVtM0VMOGY2?=
 =?utf-8?B?UXYrZE01U3NZNTYvN2hZQndzV2o1cEJsbGZjMHlCb3RDUjdlU0Y0c1doMDd6?=
 =?utf-8?B?a1dBRWM1ZFV3dXlqTU1PaURIb1BTSWdsaTVyS0lnY1NxZWc5K2pOcFJXZG9C?=
 =?utf-8?B?VVIxVkQ4QVFDSkVaY3VCK085clFrOWVDTEdqQXNTQXZhbG11RWFkK094TDJz?=
 =?utf-8?B?dXdncUlIVVFWZzNqaDEzMktUK2lWN3NYWjNmNDgyZmxQL2RRSVVlMUY4akR6?=
 =?utf-8?B?RDVXYVRoUjVFSmE0am8ycjliODIxQ3ZpMHFZK3d5b3hpdmZNUHozbUpnelZM?=
 =?utf-8?B?aFhLRk02WlhkNTRIazFydDNhbWRLYTFkVDhpY1BaMGd3OXRzN2NpK01SZVQ0?=
 =?utf-8?B?OExHYWFmc2o5RnZUSFRCa2djd0VBRnRvSEV1R3U4S0JFME42bUV4T0pjMjRV?=
 =?utf-8?B?WG9EWTlWLzBoQ1RyQi9jaHVrS3pBTlpKcFVsaTF1SG5CU0Y0elgyNTBjcmFC?=
 =?utf-8?B?N0ExanZpMU9wOFdYampGb3JWa0MrckJoMzNjUi8rRlVvUnd4SlpiL2QzWDI5?=
 =?utf-8?B?WjVRSGFWZU5paTA2bVp0ektsUFNGS2I2Unl3bXl3RnFHRkx4T2VPRStkNWZL?=
 =?utf-8?B?VzJnQ1cyQ0VOVjNKUVVGRzNKeVdkOWNxK0VLenZJWUJUQUQwOTJpVzkzaERS?=
 =?utf-8?B?UlUzekdKZXgrRXh1YnJVMzNTOWtRM1RORXpMMGx6U3JpbGlmTVgzTzEzVndV?=
 =?utf-8?B?OUROVHJraEQxMUdhbXNWVjZCS3ZDTm56cFREUFNUbnE3MVFmVGZUcGdUbFFP?=
 =?utf-8?B?SXVaaVVrbzR2amRad3owdGJLdGJXM1dKdlR2UDRYRHlhNk8rOHB6WlhZc3po?=
 =?utf-8?B?bFpYanllT3Q5d1dGUStnVmRWdGdZS1dBQnhHRXp0Qng2T3MxYmhCVHdwelN2?=
 =?utf-8?B?S3NQZXlLL2RHaEVQVHVaVVRaRlVobUoydGtXdEg3SEhSdElRYVNmUXVRemto?=
 =?utf-8?B?dzR5TStvNlNSNEVsNlc0VUcyREpoNmJ2Z0dSTm1zM2gwdjNHMW81eUxpKzBY?=
 =?utf-8?B?QnhNYUMxNGNTVGprODFMc2h4T1dZeFRHZU9RNjdmRkdIWktFSFlpdEszK0Js?=
 =?utf-8?B?SWlZdEkwSW1aU29SM0I3WmFBOVFuMUR2YmFlWHJJS3pMeU5oeGVvY0E1cUFB?=
 =?utf-8?B?bHhKc1M3K1FyL0pQekZHM1o5bW9hMkd2WHE0RjNXOFRydzByanVCYXJFWVVL?=
 =?utf-8?B?UTZyNlJZdEc3NEhxWWU5OU1rUENLTlgwOG9kTmZJRDFScitjOGtnL3V0TEti?=
 =?utf-8?Q?s6cBQeMEgpm0jCIs8PtJhBk97XvVKwP7mury9?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba440ebd-8539-497c-959f-08df39e4094b
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:52:48.3126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGxSgkyaYS7c0J/lDBCsBL6eMcyo6UzloiscWhYCRDu5DPgprAog8QYbwE1zp9Zt/FiR96UwgQ3XkLfro8cooVsheV5+L3lvdwqJJ575fYsaiQ8aElnTkjqqLM15vGM0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR04MB299223

From: Frank Li <Frank.Li@nxp.com>

Replace open-coded assignments to callback and callback_param fields
of struct dma_async_tx_descriptor with calls to the
dmaengine_desc_set_callback() helper.

No functional change intended.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index ad72057a5e0d7..67e811945339b 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -92,8 +92,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 		intr_tx = NULL;
 
 	if (intr_tx) {
-		intr_tx->callback = NULL;
-		intr_tx->callback_param = NULL;
+		dmaengine_desc_set_callback(intr_tx, NULL, NULL, NULL);
 		/* safe to chain outside the lock since we know we are
 		 * not submitted yet
 		 */
@@ -145,8 +144,7 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 {
 	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
 
-	tx->callback = submit->cb_fn;
-	tx->callback_param = submit->cb_param;
+	dmaengine_desc_set_callback(tx, submit->cb_fn, NULL, submit->cb_param);
 
 	if (depend_tx) {
 		enum submit_disposition s;

-- 
2.43.0

