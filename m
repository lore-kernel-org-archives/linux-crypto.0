Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735576;
	b=IE3tJYad8O0L7nwCcwNoJs1IKP43zYN5Vf2/zcJuYHytj9UypROlZedy8Zm8LIyRtCnf
	 oGlVpjoVE3ODTYana0rWJWLVePC8hOxNzlDxoA8rLtwCBze/YcIQwga+W/GfQZTbE9nUp
	 LeYdl9vjSpY/hJtb+9+BqfPzdq6SI0L4Amj5Dl78L8iOnxGFutUPn5aJciDxgNUoyUPkb
	 nTFTClWf9gGdZDnYyhQ6QkL+ok4gQpJdViVDnZ6POY3Mzg49nwBP43CJ1M+Dh3/gUz1xU
	 uOjhNWAKiIdqcD0652muhkCKFRboYbSJs3Aw80yqeLb8Uz5Q3vJg/bZ3Kj2HedfI18g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735576;
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
	bh=mU1ze0anlP9xr1b7JSQCDF1ZnyI683a2QS4JUFe1yGw=;
	b=IRKJkl+7FPgyA6sbSrH5FDfckSgLK9tqj/DsD9fmsS8wMjOcxXZTzYbVITXS4oMXpzEu
	 dFO4WNajYucSoJoWx3I+YRjav3Odbdh7SqnydKTTKBMI1jwjc9BctvCNBOUeIiZZHP39m
	 TeUF3pEYvGMl2ZbVSWmkcyH4qqvXePxMlYP94GKayXsryk5NI0mZ9pleWzH74egfp+sbd
	 dqkjU2n06QA4gIF2RU7dW/ToR85mqWTOcTLXnzG7EIaog4kagAUnGjUdpPsiR1FiODpsj
	 rBKV18T3fxoqZ9Ol/bodIkWckd1YtRSKlcq/5y2CbTf/P1MFAqgT4wsf9wH2MKLYjaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=DEMrtLSO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.51
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010051.outbound.protection.outlook.com [52.101.69.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FD9606A326;
	Tue,  3 Nov 2026 19:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1FD9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=DEMrtLSO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VixdzxOIIpWEGG/uWtleMbura6TJDyaQML/1HVFPvD8jbZEC9rZ2bN3v+tk7nZCoaT3ssTZf9bds55ZvCCbuFB1Em9PyYIrRW0S6qzzCcX1JyWzKX/iCR8zn945JME7A99Jlz88TJpppRrjE4ekuUi6IC1A55YNgBzZAcs68ddN1JOkhxgAvWudzFuMRjEhvmj3AyNA6ydE9ZmvCG1fD6gzSEk2Al39+iH16Mopc9/p8dErdjS/HxLCuUbHbQ5pEfC2lGIp8kcf47eQtriIPWd7Chc++VdYJu1gkFOaY7TwZUjV9G4RXY4kEWbqB7kwsPbLVVoBd7f9Ho9PHm4Pl8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mU1ze0anlP9xr1b7JSQCDF1ZnyI683a2QS4JUFe1yGw=;
 b=LfPurSvffWEGJs9ZayarJ6/o2V5ws++3PbnwgQvMupFeg4wCuiUSS+67IcwJhUY+g7whnHcR0MOFO3k0KSxjFzF/quLgtIUpHOT9esBF8tWPiOrqedAeGvdyiRlMlUnNMjv9NUNdOEFcfJVwhIH/LT45zAwEAvaRJkzFW234s+PLBOzftHHiPt1pVP+9HzhuWohghbH8FbvUp/RGixQC6ajwZE+jnqUNufpFbVOsOeE5eHgirMD2BnOYi2stnmyY9LO9b5QwUnXWGYS5IVpxLt0NdgzWiYa+xY7uifSN8qLYjgch14wC0cOhE5Gxx78414Bs9f5L39YZU5O1UpoLRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mU1ze0anlP9xr1b7JSQCDF1ZnyI683a2QS4JUFe1yGw=;
 b=DEMrtLSOq2yOAFoHC9/kUPOcjZPsII04+HsW3Qj8toevF5vsRt1Gk2uI48DQ34ZxfrchEXvyOE06oyGvACMqgdoxDEIJy8+oNm0rst7mVLnHOx0N+xpugaGsZ7LjkwHwij+tDNHND5I/qSvmITQ0++uE/H1e9zLKuW92koPypJH8CkE0J77Q2/FhMdEt8Fw/GJpznYiTNCqRcrQPQpDg81qAjCxFu/+5w3KJ/Wt41H3i6FyR43ev5X9nt7Z1LpkQCx009avvtePtck38Nd1pYv0rc60yLhl/YHzhrO8etq32ItrZN3ocvmiagOnk5dtbL+NzJpWixo6of4ij1n5UYw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by AMBPR04MB299223.eurprd04.prod.outlook.com (2603:10a6:20b:7d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 19:52:53 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:52:53 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:33 -0500
Subject: [PATCH v2 2/7] async_tx: replace direct ->device_prep*() calls
 with standard DMA engine API
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-2-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
 Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=2505;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=XmzUor4OLtseYCEWSLJlfsHeN0VhkIYnp4A0l9/PBCw=;
 b=SsKk9hxRiNxXBTAyJsCSTcBDRBbJ49caGv1W03VASmKFAmuOoFS3HAJU+9VMexPp9ohYhyzd0
 0QfCjgY+/OcB6RCDpa0MoVxFZSOyyQShB6zxDJy/Z5PaBPV0xipU+Jr
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::16) To MI3PR04MB12438.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f1a876b7-e240-40d8-80bf-08df39e40c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|261021133027099003|11063799006|261022075727099003|261021121427099003|56012099006|261021123027099003|261022105027099003|261009223027099003|261021135927099003|261102123227099003|261022115727099003|261021130227099003|261022113327099003|261026140227099003|261026130827099003|261026121527099003|261028144727099003|261026135527099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	OARuWCCog9xwTs6UR4s+5wRoaEs+TysxfD9iGwOKWIj58Iu008YEtXXCOmw1TKzqzytc8+7pKa3x42ESZ7y+pKijyMLQhjYoGHl4vn27kNmNOx4l4j4JNuJ/fQw6Qf2sCESVg87OrHzGiac5+tD9WlL1NhzyA+4HXIN+PJZujWUMmf1yozfhMKyGMay9uxOc40gYOIY9sElGn2ejjINH6APJkC93B8zjd9Xrc+Lo5pqpD0a5hFj8EHy/MnAaHfnDI2svjjsO1wyJYW2u7ESKAOOcRupCNxUQC7/tm7XjMGArRj65EeX39LN359AXijcgVRRIit2k09C1gs0JQL9EFbEF7XMvi7TTQ+AsjMicqfAqE2EgvC8jAY58UfLKaFmot+kOBDxFl+AXVzLXvO/wi6MV/txqRN4rCf6Mstb4QLT5o7koMx3WJ4cO6tE5Y4ttRPOdXZ2K+PE3uOzghSpjw4+f0Lfg4SDtLHsEkudbTKp2mxGGiq7YM6a1x0XdR1Fxh+kscdFAfTxJCVophKq7Xri3VuV3MF+Hc8poKpTmq0CW9t4zcBbQ9yreSYJfbA57tvDh4IGd8rQdX6tL/U2/rWsquSrNRWGu/MLD7E4SySff643/0u8Up718AmrlS8HEIA3sJGpBhkSqYQiGHEBVEAZvG2nZSfankDEPDUqzWlQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(261021133027099003)(11063799006)(261022075727099003)(261021121427099003)(56012099006)(261021123027099003)(261022105027099003)(261009223027099003)(261021135927099003)(261102123227099003)(261022115727099003)(261021130227099003)(261022113327099003)(261026140227099003)(261026130827099003)(261026121527099003)(261028144727099003)(261026135527099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bURmblZFUTlMYU81cTJGL0R3cy84aVA3dWNZWHpXVTJjN1N2N1pJK1B4anQy?=
 =?utf-8?B?NkNNRWdqcDhJNnl4a29XZzI1Z29OcGNsSXJIRGlrUE5WY0Q4THVZc1JIR0Vw?=
 =?utf-8?B?Mitja1R6cDRFZVlmNXUzZUpObDZEbzRhMU9hWGNnZU5XVlZ1TGllMXdLc1ll?=
 =?utf-8?B?dHdDR25PUDRHSGZvaG5Jc0pxSFBXSlcwc1hGL29uaGJtUnptNnhLQThwWTFw?=
 =?utf-8?B?WlFyN0hMVGRITDlkWTJEbmQrQ1poMEZSVkRwbGMxVjBpYkp1cTNQSWFINVlE?=
 =?utf-8?B?c0pGazE0d0JKNjc1Q21TVFVDUHNycGhENG9WL09mVWtFZW9kUEllU0NkOGpj?=
 =?utf-8?B?UUpzR2pCeDM1WEpvWUdxY29aU1JTd05LL1NJeVgvSXJFU2ZSd0FyRWhTc2ow?=
 =?utf-8?B?bUNyYlJBUDhySmEyYW83Y0NiVWJyUnYrdzRObmgwUytpZElZRER1YXZGRWY1?=
 =?utf-8?B?a0wrM2ROcGM3M3dZTmZwQWROaldoK3hsdzBhL3YvTTVZY3p2V1RjOXp3d2ls?=
 =?utf-8?B?RVpVMG9DcHJYaEVZSFkvM1pjYkhCeVZDSG05VXlmZjVWbC9BeHgyTGcwWUpU?=
 =?utf-8?B?R0t2dHVTQjcyWURCTHZvQ2JSdk4yMFFSdk9Xb2w5VUxqcndBRWFVRXdBM1VC?=
 =?utf-8?B?OVQyNmU3MG5FanRYKzdvRWVWOWN4TVM0c0N0QWttb2NXdnFuR0lRWmc1U0FU?=
 =?utf-8?B?R2xOVXd0dWNzNlpFdnNNdDBnTEhBU1ZTcXpqWE9HcStYbzRWZFhQdlFDVXJC?=
 =?utf-8?B?c2NjN2x6ZWoySEo5Z2xwN2tDQjI1dGNvN0UvcTRlUDZZam5FdGJRbjlWc2s4?=
 =?utf-8?B?TDc4dE83RGZBZkxlSUtReUNuY3RGS3NmZHpLQUo4dTdrUElNblFLb1k3bnRa?=
 =?utf-8?B?cmtpYkszY2tGZjlzQ3d6MmNVbCtDVUpERWs1aXlYUjNkNmdDRnV0TlJKL1pu?=
 =?utf-8?B?NmlPb0xOTFVjc1FxZkRZdnhKRjQxUGd0SmFIekxkQm5zMjRHV2ZtRHY4S2t4?=
 =?utf-8?B?WmFIWUFyYkt5bms2L2ROUnpVSVdRMmxscWxBQmx2cDRNMXordjBtdjkxWlB1?=
 =?utf-8?B?bU1uRld5ZzZNZmZuS2Npd0xXRGQ4bzJSU1JYMGd6ZnNGektuZjJSQjlJNG9u?=
 =?utf-8?B?NFd3aklVUThRMm5KeWI2N1l0akJZcmFFaWJDdDdHWDlNS1lkYlg1d0U1Kyt6?=
 =?utf-8?B?cFhrRXFuVnlJY0RLRDZ1OVpYOWQ4bDJNVEMvL2RuQnU0cXhaTjdQRUNOTEgy?=
 =?utf-8?B?b1ZiRGdiTjZ6K3VGRGJaTjIxMDB5emdCdHk4ZmJxVHQySEljMFBKU21qWHhI?=
 =?utf-8?B?ZThpMXZlQlR3Yy9hR0hQWmJGKzZuUDEwaUJtVFFnNXFuQ21XS2dtSkhXQ0lv?=
 =?utf-8?B?aVFCeHlEVUd2dWVKMTZObGpOSXlORmlkV2xCR29hZDI2Vk1HWC9EckpiSkxY?=
 =?utf-8?B?NHRIS1dZU2Q3M0lWeDVVYjFnbTJSelhZOWtTc05iZmdCZGUrWEdxeVR6QWg4?=
 =?utf-8?B?cjVlcTRyUUhBemM2UngzTGpkWTllTS9IaFN1ckZEVS9QZlk1aG5QSlVKZ1Rq?=
 =?utf-8?B?NXNLUXJQdmdOZnNCSDRXZVhBTHhkcFAzcFlJWm5iaTMxUURzOWtFQ1ZwQlNa?=
 =?utf-8?B?SllhQ2tlYS9mbVpLMXNUbm15clN3R1BwRzROQUFQckgvUlpFSnZsdWR3MGQ4?=
 =?utf-8?B?M1NUR0pQd0swY3VSL0NXbnFsajNaMngyN2RyWnJzb0U3aUE1bXNvSUZ5TkZk?=
 =?utf-8?B?UFFHREdNNVdNOTk4MnpMRlhBY3hPZVltc2pCODMwYUo2UjJQdUNQMU40Mnkz?=
 =?utf-8?B?N3NWY1ZuS0o3STIyOGVVdGV3cFp3Z1pkQnExR2ZJV01kUU9HUnNVcnZ6K3Nt?=
 =?utf-8?B?TzNsTG02b2tCMzlhdjhwV2h6MzRhWUZiSk8vbllNOW1QV3VFSUNVVkwwTzAv?=
 =?utf-8?B?RDk3b0dnRzFRbHE3MWFLeitpdG5peXhKanNxMlFvUmlLVnZzeWtzaFFyOVNG?=
 =?utf-8?B?VDhyWmR3U2EwSlFSYVQwZ29NWExmNVdxSUtUYkZyT2Fqc1NwTFVRcU9hamN2?=
 =?utf-8?B?Q2xsRGR1a3pxVzMvYmg0alc2c3NpVVhybitDT0swdDhFdmRiOUpENU53OTlj?=
 =?utf-8?B?THRiRFpKUWVIZjhxdDBON2ZQQnVHZ2NQV3FrelV5dEFoM3pLL2c2Y3czcDJl?=
 =?utf-8?B?UkR3QVlnWC9EemNEem44N2pKTDhrV3JJTS9rTlRibDY2RzNNOEg1VUJmL0Z4?=
 =?utf-8?B?dU5jR2ZrOGR1YktmSzZpWDFTTlplbTIzVittdUJTU01WZUNVU3U0ZEhtQmRY?=
 =?utf-8?B?MzE3N29uN2V5eWhjZ3dhL0tzTEthSlRxMS81MCtQWU9JZGx6eCtSQjNkZGY2?=
 =?utf-8?Q?K/ihOVpFdCd1KaTsp6gWUIPL0RKjLTcKcpT/P?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a876b7-e240-40d8-80bf-08df39e40c99
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:52:53.7238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XzSYgGaJkEGHRxupnybbGQIuVRjIJUR8Npv/AdwrypV6baYMqQGMPG4fAMf/kQaPmoPfaS094jjzArqTvfRWYzmT+LmSQ6NGJdlGgaCzY1CbKVG2m43MtBEH2giNMXlK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR04MB299223

From: Frank Li <Frank.Li@nxp.com>

DMA engine consumers must not call the channel's device_prep_*() function
pointers directly. Use the standard dmaengine wrapper APIs instead.

Assisted-by: LLM
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c | 6 +++---
 crypto/async_tx/async_tx.c     | 4 ++--
 include/linux/async_tx.h       | 8 ++------
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 893e7e17f1f61..538bb83df841c 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -58,9 +58,9 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 					      DMA_FROM_DEVICE);
 		unmap->len = len;
 
-		tx = device->device_prep_dma_memcpy(chan, unmap->addr[1],
-						    unmap->addr[0], len,
-						    dma_prep_flags);
+		tx = dmaengine_prep_dma_memcpy(chan, unmap->addr[1],
+					       unmap->addr[0], len,
+					       dma_prep_flags);
 	}
 
 	if (tx) {
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 67e811945339b..f6e8f68f00972 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -79,7 +79,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 
 	/* attached dependency, flush the parent channel */
 	if (!intr_tx) {
-		device->device_issue_pending(chan);
+		dma_async_issue_pending(chan);
 		return;
 	}
 
@@ -112,7 +112,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			intr_tx->tx_submit(intr_tx);
 			async_tx_ack(intr_tx);
 		}
-		device->device_issue_pending(chan);
+		dma_async_issue_pending(chan);
 	} else {
 		if (dma_wait_for_async_tx(depend_tx) != DMA_COMPLETE)
 			panic("%s: DMA error waiting for depend_tx\n",
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 1ca9f9e05f4f1..9f7fef19f2142 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -87,12 +87,8 @@ struct async_submit_ctl {
  */
 static inline void async_tx_issue_pending(struct dma_async_tx_descriptor *tx)
 {
-	if (likely(tx)) {
-		struct dma_chan *chan = tx->chan;
-		struct dma_device *dma = chan->device;
-
-		dma->device_issue_pending(chan);
-	}
+	if (likely(tx))
+		dma_async_issue_pending(tx->chan);
 }
 #ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 #include <asm/async_tx.h>

-- 
2.43.0

