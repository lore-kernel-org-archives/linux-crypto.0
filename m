Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010007.outbound.protection.outlook.com [52.101.84.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3354403E9D;
	Wed, 30 Sep 2026 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790763606; cv=fail; b=YVhx+qLEst+yXHb5SzvLkGXep35ObKBCzOXm4FXVZ8D3igo5hq2QavE1/EovpZkcRXlWcPCrTo8lLbfNnpZJJu8ZT5xTIRezMXfft4AlASdlk80ItvsHPzRn8aWorwFm5IczfkujEdc6MH/gzE99onDca+ixRVDxv0EQiJ9p4ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790763606; c=relaxed/simple;
	bh=xcMLP00ZIwiQdyYeYsece2UCbTsgwOhzEFZr0kuqtvU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DLehbApSBjXG0GRIZp/e2zKRTF8mGKpxXJ7hVJFdU8jzKRgFuHf+zpkzAKa+fl1RmCpHHIUsnxfcjrTw09H4PKo7EQ7E/mOSmba7d1sX3uxVxB+7SY41NwN/IJVD8DoTFsaCNpV92+7exO3XpUWcAzR76aV45rKVZL3ZiumsyPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=cSnueZoN; arc=fail smtp.client-ip=52.101.84.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cSnueZoN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+jKJKDX8ArR0O63UJjhEhUZJ1d0bGKM4wlvnqGuiCTGWVQQH6XKfiLsF9ij/ZTOKNfxlgWpeptrXCuBHB9wgWFxT0pf/Bd6xIrBARgO+mJylMCRyn4vK1dEgVP0Os/t0VzuZwWWOp063YEB/NejI4kA7Lg0onboP1nsjFYdTAEpy9frxsL/lBaKrtzprYh6zzx2I/xXaXQcw8kum8e/dvDzPvZiW/9ns/zWmg7y3d2UV8A7S8uqJx8uN9O3+7qvuELhPqefkKBGtY2ZxdBSJvz1qgVSS36bRBuuLAJRiPItZZ8pnftaEoAIVZ3EYNMj7R1tyUXbNq/smmqKW9IXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcMLP00ZIwiQdyYeYsece2UCbTsgwOhzEFZr0kuqtvU=;
 b=OY22r2N+agTdfUS3VTe29wA5HwnK+4Kub0rX5VqeaA5jr6VGmAjhSce9XWXr2Q12OhFME2LD5PBuVQlPeVz4AU4XoikLa55o6o148OTbXxoUXws/5yGLUIOCgAE6icawsU55yd/Mp3/1zkss/pCjijSXT7NpV+UUGqnnsPWmb8ndsJLDDV+52ZFvxoh8qxdaEOJoW6DMGPHprQyUm6FPlv8rgN2X2cyvZuGoXeG7jxCbEk++RIE/XmoZjapp3beb7p8VL5K7a8wOc5wiDxvto1eazUF4hEmCNbk4tOHfhRBikmuqagkWJr8YG3XiDiuniG53pPhnzpFpJWhPbJ1bAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcMLP00ZIwiQdyYeYsece2UCbTsgwOhzEFZr0kuqtvU=;
 b=cSnueZoNKCHl8tCCpVCoW41IYtn28J5oPqqqf+s+kxyN0aHuUF0qlsSEXQjEImGBGC+kkJpav4mPR1E2HBasyp8M+3j18Ep6Veh/UVAM6wHsDH+GXjNPtHLxqGM562M1mFIy0OPU+ttBrcuL2ENRJDruzx9uizR7g5YhyQW6+cqeXK4/oBUQ0L2gEmAhdFtYqj5RqPnQuxuie86Z+8Fvt9b7baK842SbSmYqFXXjmDKZPsO5ls0bF2i+yAaGC2nwvp5UTIN3D4s9aG/dh6Qs3pQKo1IXq3WBcxuvESxo+n4vW+KQSDJqP+7nOZJ6AMxWJyfbjvKUl0HlRl4rDu5J2Q==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by PA1PR04MB10294.eurprd04.prod.outlook.com (2603:10a6:102:44d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 10:19:40 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 10:19:40 +0000
From: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
To: Vincent Jardin <vjardin@free.fr>, "Sahil Malhotra (OSS)"
	<sahil.malhotra@oss.nxp.com>
CC: Horia Geanta <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Thread-Topic: [EXT] [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Thread-Index: AQHdUFEyqpVyUPmPFEismuIaSWStHbbmtr0wgAAfOwCAABKs0A==
Date: Wed, 30 Sep 2026 10:19:40 +0000
Message-ID:
 <DB9PR04MB8139EBEF938487D49307D3F9828B2@DB9PR04MB8139.eurprd04.prod.outlook.com>
References:
 <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>
 <DB9PR04MB8139034E6D0186A687183208828B2@DB9PR04MB8139.eurprd04.prod.outlook.com>
 <arzRoCQHvM_K9y9W@L20747.iliad.fr>
In-Reply-To: <arzRoCQHvM_K9y9W@L20747.iliad.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-30T10:15:37.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|PA1PR04MB10294:EE_
x-ms-office365-filtering-correlation-id: 9e8ad052-7dd4-4c5b-54ca-08df1edc5685
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|19092799006|376014|1800799024|18002099003|22082099003|38070700021|10067099003|260925021311599003|260925022911599003|260925021911599003|11063799006|56012099006|4143699003|41080700001|15866825006;
x-microsoft-antispam-message-info:
 fKLjwsVRGwGcuYPnT/YnH/PKiLWs9L76lX3jgHSQXSnz0LWXiZc6EDrGjv7vKLmLNzhQFjxKdLqBFTwEqjmZYs0vNf14BfXRu1o2HzQ5T7ZaxOtiL4GViwwzwPoaeZpXwSDH3m6eaSlu6o64f2zDXpN4gjjV2voL2723f2PBqLFYErf8mKR36sgKFl/9rAzd5C73Ul15BFCEJD7xuo1mXItqs84IMIxPcyaJl41Z0Bi0r+b6hk4pNxV8FtW5kj1R/roNcFZwBIHeRtY0OAqSl0B/9UMo5gaocdzyZSF3Xavs+3WnYTdbfsqBtXp0B5g9gPnxk0XwnO5zhpfEOQIoU2SYuD50b1DzAtYuN0FyP+xww9mkRlG1vJ8AaeXE7RYSU83NmOtuuNvN4wgiPYBl7IAB3rb6wVeH8RKnCFGIuQ4FyoWO2tk8y6uldBb5C5GWU3Dl7rR14C4TBRPXIIzvqhm7GWkGnninY19NI6y2N8CLkzgwNGjjSXgN7zoIPhZXOWXi31YVLKj9R2SqLtMwPISsfLPHsdB9Nlj0eNgDLGdv5g2HqgzUEFBVqftUgyxg5Y7yTRea6JQCcb5XPXieSQBzb+yDbsmNuKkhsoPxteAZPJ0usDAH0wd7COvRQSn6r/KV5YrA44p5ckK2hjDjyYbXRpgm4sNDnKCQmkpSA5baF4pkNJHkbp5VlSUzNQnp+lDWLBsJ+BkNrPInNhtBwg5VtMllMOJ8qzrmqegswgZjyjLHMbuPSia2fjaDHZlDdVV0Eic8GnEoVfpt9Oj+TsrkmH4zQLt6uFUTPy//aR0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(19092799006)(376014)(1800799024)(18002099003)(22082099003)(38070700021)(10067099003)(260925021311599003)(260925022911599003)(260925021911599003)(11063799006)(56012099006)(4143699003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UG8wQzN3Q3E1K0pkWDh3aWdwcnJpK3NqdURlSEJRaWhETmZNVGFIMVJyVDB6?=
 =?utf-8?B?NmU5NVRjYi9xd3d4SVlHVWNUb1hEcFZmMFNSaVc1N1ZkazZZSWZmRDRhVk8r?=
 =?utf-8?B?cmZIdHRPaE1QYU1SR1hGb2hkVDRVeGJTd2pNS3BRRDRTTUtPV2Y1RG5EdjZ2?=
 =?utf-8?B?NTQ5WFF3TnFRcmhzV3AyUm93VHpYN1hMQUJkNE9vTWs4MGVBUmFoY2xaSnIv?=
 =?utf-8?B?amdXT2lscndIUnN3K1VtQ1FFZnFIakwyeUlzK3JLUEZGMk84TWhobWRhM0F1?=
 =?utf-8?B?SkJHVkVwTkIzREpoTUk2d1VXN1pMS3gwTUxoSCsxQW5OZU1jdEUzVVp5aGtZ?=
 =?utf-8?B?UmlweWQwQW9zRWlYRmZyMUtOS3hiMkFIdXlLRi9QVmRqZlRyREQrNFdyWGFj?=
 =?utf-8?B?a2pTd0ZHaEVQVVg3NlU2eU92YUk3QTNHaUZndEFJaXFJOGhXeFVDSFNVYlp6?=
 =?utf-8?B?ZzZZZGtyK1M0MWJGVm5FQTNrRzRwWXluTTB5N2s4ZWthUUpPQllIbkIyY2Q0?=
 =?utf-8?B?TkhqRnNuZ3k4bGlkVXhxTlNqM3h2cVJPbGZHaDFhditJT1UwN1J5OUc4d0ZD?=
 =?utf-8?B?UDlEaCtxWms2SHZEWTRHcFYwelkvVE0xbjM2U1dNUlNDZVF5QXl2eUpzZE5T?=
 =?utf-8?B?S3M5MG9tSmdJV1MvRWsrbDNvLy9Pb0U0RFlITGFHM2JzcEdxUndpNGh3N0VE?=
 =?utf-8?B?K1N6WjFHTk5ERzNkZDlWRHFEaDYvRHpKb2l6RzVucmpEUVZyRVoxd3M2U0JK?=
 =?utf-8?B?bUdTS0RYcEsraEphdS9YVlU5Q1FzL3QxYmQ4RHdFWnFrblU2TUx2V1hNdGJa?=
 =?utf-8?B?M0pIM2VsYVpoZEMrKzZkeUZFckJLbGNWZjJMQzB2NHJoaHZkZDdTRzFUOVlq?=
 =?utf-8?B?U2I2R3l5YndpSmVMeExaekQ3L1JrNnRJMlp6T1VPT2VGYVFuaGpXa2FpVVdE?=
 =?utf-8?B?K0NCeFh1YXIrUXBFUkh3bFpnN0JVV2Z3K0RnYmw3bnpjSTd6Ly9EYVVLL0du?=
 =?utf-8?B?bEpqbHNYWEZIbkk4cDVkOG1ScWRUK1doM1FEY3VDOTRKY0d1RGhheFZlTzVo?=
 =?utf-8?B?NDhGamdhRXBwN2tVOGFDRXZXNnRxaHp1QjdXejVXWDltMWpadk1aRXREeDNr?=
 =?utf-8?B?Yng1LzZoNUtJbno0ejBoSzhZdDJtSEVVTm5udVVxekZNMktPUlhTeXZWTHZD?=
 =?utf-8?B?bTh5TWlwWHo0b0ltN2pCeTJZSUEyTU45OWhBV01uVzJuYTljSVJmdDVjREJI?=
 =?utf-8?B?WUFIVlNXajFYMytZZ0twVzRPbloxYjdvLzdoazhSS1R2U0kvbFRsSEJES2o2?=
 =?utf-8?B?SFc3bUpXQ3Y5cGRwTitjMmw1VnUrWStZNWxzQm1IdDVXdlpGbFZ6dTN5akpt?=
 =?utf-8?B?QXVkdkxDV3FmNkV6MzlxS3J6STgwNkJWZXpsR3lWRmVCQnVRWE9zRWxXYVlj?=
 =?utf-8?B?UTJ5TmdjbHVON2duT2ZUUE16b2Nha2tscFZSZmFlby9CYU8yRHRrQ0d1Nkts?=
 =?utf-8?B?cE9mUU1ucDNCYTZWSVp5aTlWQk1RRWx4ckF6VFBFdS9TVXVsU25md01SUUgr?=
 =?utf-8?B?bEZYdDM1S2hJb0ZXa0NrRUZNNEZqTHdydXBIMkVTSjZJMmw4Vy9sOFVjVWRE?=
 =?utf-8?B?c3RqWXRtOENUVERweGoxS1BwMktqUmRGYjNmVklRd25iZXoydW02RFZxNWdJ?=
 =?utf-8?B?WXcyanhKNGdraGZHL0FMZTRNNStlN1k5RDhlMVQ1TlgwbS9SYVNGaXF3Z3Z5?=
 =?utf-8?B?bStiNVRIcXZGVTdOdGFralc3NzVtNWcycWNaK01HY0twemJNR0N2WmV6V2sr?=
 =?utf-8?B?dzVFdjRKSkRaSkpNenJFMTFMNGhZa08xMVNTdDlTY2VOajliRzNYbUZ2cksr?=
 =?utf-8?B?SUdGc0ZPL3h4dTVaZVhDRE5QQkJCNVpFbzdieVdNZndEbTVreVdmRlNrQTJY?=
 =?utf-8?B?VHRSU0ZEKzFpekl1STBrb1c3WFJQdmJTVUpIZks4OStHRGhDcjVJbTArMzFF?=
 =?utf-8?B?WUF4dTFWSXJmNDZxQ2NqSVc4aTJPWkxaaGdkdzFwVStkQ05sakZqbEowL0JQ?=
 =?utf-8?B?UVAyVWszZmd1aG5ucnFwU3lrT3hodE93UStlWS9yanViWWtLTTl4Z1dDbzZj?=
 =?utf-8?B?VEs0UmFvWGU3UWtWN2E5Sy9CK0VrbmNhZmlGWm9QQit1M2duSXZIWHYzWFdi?=
 =?utf-8?B?VzZNYWhHMkFMYzhnVTkybEpVQ25xeWZKTWhqN0h3VkpKVkpyQnhyZ0Y2ZFJI?=
 =?utf-8?B?S3oxbGhzejRhek4vZlBOc2tzK0JqZ25Scmk0bzJCby9DTHovZ0owYyt3K3h0?=
 =?utf-8?B?VEc1U2puV013OEJDalZNWHpMTlBQc1dWMVpocWNkQk9nSVFhcnorZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e8ad052-7dd4-4c5b-54ca-08df1edc5685
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 10:19:40.2526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyyt4B5JUCZWueMTpcbnBU1Nm+OZ58rmFtv/CKO/r9E5h+ULn3A5kf1zEViXqsX8CIzdv8uhuLnlC9xr1ts97A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10294

SGkgVmluY2VudCwNCg0KR290IHlvdXIgcG9pbnQsIFJlZ2FyZGluZyB0aGUgbnVtYmVycyBvbiBM
UzEwODggYW5kIExTMjA4OCBJIG5lZWQgdG8gZmV0Y2ggdGhlbS4NCkZvciB0aGlzIHBhdGNoLCBJ
IGFtIG9rLg0KDQpSZXZpZXdlZC1ieTogU2FoaWwgTWFsaG90cmEgPHNhaGlsLm1hbGhvdHJhQG54
cC5jb20+DQoNClJlZ2FyZHMsDQpTYWhpbCBNYWxob3RyYQ0KDQoNCk5YUCBDb25maWRlbnRpYWwN
Cj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmluY2VudCBKYXJkaW4gPHZq
YXJkaW5AZnJlZS5mcj4NCj4gU2VudDogMzAgU2VwdGVtYmVyIDIwMjYgMTQ6MzkNCj4gVG86IFNh
aGlsIE1hbGhvdHJhIChPU1MpIDxzYWhpbC5tYWxob3RyYUBvc3MubnhwLmNvbT4NCj4gQ2M6IEhv
cmlhIEdlYW50YSA8aG9yaWEuZ2VhbnRhQG54cC5jb20+OyBQYW5rYWogR3VwdGENCj4gPHBhbmth
ai5ndXB0YUBueHAuY29tPjsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
PjsgRGF2aWQgUy4NCj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgR2F1cmF2IEphaW4g
PGdhdXJhdi5qYWluQG54cC5jb20+OyBFcmljDQo+IEJpZ2dlcnMgPGViaWdnZXJzQGtlcm5lbC5v
cmc+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW0VYVF0gW1BBVENIIHYyXSBjcnlwdG86IGNhYW0v
cWkyIC0gbG93ZXIgdGhlIGFsZ29yaXRobSBwcmlvcml0eQ0KPg0KPiBDYXV0aW9uOiBUaGlzIGlz
IGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdoZW4gY2xpY2tpbmcgbGlua3Mg
b3Igb3BlbmluZw0KPiBhdHRhY2htZW50cy4gV2hlbiBpbiBkb3VidCwgcmVwb3J0IHRoZSBtZXNz
YWdlIHVzaW5nIHRoZSAnUmVwb3J0IHRoaXMgZW1haWwnDQo+IGJ1dHRvbg0KPg0KPg0KPiBIaSBT
YWhpbCwNCj4NCj4gTGUgMzAvMDkvMjYgMDc6MjEsIFNhaGlsIE1hbGhvdHJhIChPU1MpIGEgw6lj
cml0IDoNCj4gPiBIaSBWaW5jZW50LA0KPiA+DQo+ID4gSSdtIG5vdCBzdXJlIEkgdW5kZXJzdGFu
ZCB0aGUgbmVlZCBmb3IgdGhpcyBjaGFuZ2UuDQo+ID4gSXMgaXQgbm93IGV4cGVjdGVkIHRoYXQg
aGFyZHdhcmUgYWNjZWxlcmF0b3JzIHNob3VsZCBoYXZlIGEgbG93ZXIgZGVmYXVsdA0KPiBwcmlv
cml0eSB0aGFuIEFSTSBDRT8NCj4gPiBVc2VycyB3aG8gd2FudCB0byB1c2UgQVJNIENFIGNhbiBh
bHJlYWR5IGNob29zZSBpdCBhdCBydW50aW1lLCBzbyBjaGFuZ2luZw0KPiB0aGUgZGVmYXVsdCBw
cmlvcml0eSBkb2VzIG5vdCBzZWVtIG5lY2Vzc2FyeSBmcm9tIG15IHBlcnNwZWN0aXZlLg0KPg0K
PiBOb3QgYXMgYSBnZW5lcmFsIHJ1bGUuIFRoZSBkZWZhdWx0IHByaW9yaXR5IHNob3VsZCBzZWxl
Y3Qgd2hhdCBpcyBiZXN0IGZvciBtb3N0DQo+IHVzZXJzIHdpdGggdGhlIHBsYXRmb3JtIGFzIGl0
IHNoaXBzLCBhbmQgb24gdGhlIExYMjE2MEEgdGhpcyBpcyB0aGUgQ0UuDQo+DQo+IE1lYXN1cmVk
IG9uIGFuIExYMjE2MEEgKDE2eCBDb3J0ZXgtQTcyIGF0IDIuMiBHSHopIHdpdGggdGNyeXB0LCBB
RVMtMTI4LUdDTQ0KPiBlbmNyeXB0aW9uLCA0IEtpQiByZXF1ZXN0czoNCj4NCj4gICAgIGdjbS1h
ZXMtY2UgICAgICAgICAgICAgICAgICAgICAgMSBjb3JlICAgICAgMTEwNyBNQi9zDQo+ICAgICBn
Y20tYWVzLWNhYW0tcWkyLCAxIGluIGZsaWdodCAgICAgICAgICAgICAgIDEyOCBNQi9zDQo+ICAg
ICBnY20tYWVzLWNhYW0tcWkyLCAzMiBpbiBmbGlnaHQgIDEuNCBjb3JlcyAgIDQxOCBNQi9zDQo+
DQo+IEl0IGlzIHRoZSBzYW1lIGZvciBjYmMsIGN0ciwgeHRzLCByZmM0MTA2IGFuZCBzaGEyNTYv
NTEyLCBhdCBldmVyeSBzaXplIEkgbWVhc3VyZWQ6DQo+IHRoZSBTRUMgaXMgc2xvd2VyLCBhbmQg
aXRzIGRyaXZlciBwYXRoIGNvc3RzIG1vcmUgQ1BVIHBlciBieXRlIHRoYW4gZG9pbmcgdGhlDQo+
IGNyeXB0byBvbiB0aGUgY29yZS4NCj4NCj4gVGhlIFNFQyBjYW4gd2luLCBidXQgb25seSBpbiBh
IG5hcnJvdyBjYXNlLiBUaGUgTUMgRFBDIGFuZCBEUEwgaGF2ZSB0byBiZQ0KPiB0dW5lZCBmb3Ig
aXQgKG9uZSBEUElPIGFuZCBvbmUgRFBTRUNJIHF1ZXVlIHBhaXIgcGVyIENQVSwgYW5kIHRoZSBT
RUMNCj4gY29oZXJlbmN5IHNldHRpbmcgaW4gdGhlIERQQyksIGFuZCB0aGUgbG9hZCBoYXMgdG8g
YmUgbGFyZ2UgYnVmZmVycyBvdmVyIG1hbnkNCj4ga2V5cy4gSSBkaWQgc2V0IHN1Y2ggc2NlbmFy
aW8gZm9yIG15IGludGVybmFsIHdvcmtpbmcgY2FzZXMsIGJ1dCBpdCB0aGV5IGFyZSBub3QgdGhl
DQo+IGRlZmF1bHQgY2FzZXMuDQo+DQo+IFRoaXMgaXMgdGhlIGNhc2Ugb2YgUUFUIGluIGNvbW1p
dA0KPiAgIDgwMjQ3NzQxOTBhNSAoImNyeXB0bzogcWF0IC0gbG93ZXIgcHJpb3JpdHkgZm9yIHNr
Y2lwaGVyIGFuZCBhZWFkIGFsZ29yaXRobXMiKQ0KPiBtb3N0IHVzZXJzIGNhbGwgdGhlIGNyeXB0
byBBUEkgc3luY2hyb25vdXNseSBvbiBzbWFsbCBidWZmZXJzIGFuZCBkbyBub3QgYmVuZWZpdA0K
PiBmcm9tIHRoZSBhY2NlbGVyYXRvci4NCj4NCj4gICA+IFVzZXJzIHdobyB3YW50IHRvIHVzZSBB
Uk0gQ0UgY2FuIGFscmVhZHkgY2hvb3NlIGl0IGF0IHJ1bnRpbWUsIHNvDQo+ICAgPiBjaGFuZ2lu
ZyB0aGUgZGVmYXVsdCBwcmlvcml0eSBkb2VzIG5vdCBzZWVtIG5lY2Vzc2FyeSBmcm9tIG15DQo+
ICAgPiBwZXJzcGVjdGl2ZS4NCj4NCj4gSW4gcHJhY3RpY2UgaXQgd29ya3MgdGhlIG90aGVyIHdh
eSByb3VuZC4gSVBzZWMsIGRtLWNyeXB0IG9yIGtUTFMgYXNrIGZvciBhbg0KPiBhbGdvcml0aG0g
YnkgbmFtZSBhbmQgZ2V0IHRoZSBoaWdoZXN0IHByaW9yaXR5LCB0aGV5IGRvIG5vdCBjaG9vc2Ug
YSBkcml2ZXIuIFRoZQ0KPiB1c2VycyB3aG8gZ2FpbiBmcm9tIHRoZSBTRUMgYXJlIHRoZSBvbmVz
IHdobyBhbHNvIHR1bmUgdGhlIERQQyBhbmQgRFBMIGZvciBpdCwNCj4gYW5kIHRoZXkgY2FuIHJh
aXNlIGl0cyBwcmlvcml0eSB3aXRoIGNyeXB0b191c2VyLCBvciBhc2sgZm9yIHRoZSBkcml2ZXIg
YnkgbmFtZS4NCj4NCj4gU28gdGhlIENQVSBzaG91bGQgYmUgdGhlIDFzdCBnZWFyLCBhbmQgdGhl
IFNFQyBzaG91bGQgYmUgdGhlIG5leHQgb25lLCBmb3IgdGhvc2UNCj4gd2hvIHNldCB0aGUgcGxh
dGZvcm0gdXAgZm9yIGl0LiBJdCBpcyBub3QgYSBzdGF0ZW1lbnQgdGhhdCBoYXJkd2FyZSBjcnlw
dG8gaXMgc2xvd2VyDQo+IGluIGdlbmVyYWwuDQo+DQo+IEkgb25seSBtZWFzdXJlZCB0aGUgTFgy
MTYwQSwgbm90IHRoZSBMUzEwODhBIG9yIExTMjA4OEEuIElmIHlvdSBoYXZlIG51bWJlcnMNCj4g
dGhlcmUgd2l0aCB0aGUgU0VDIGFoZWFkLCBJJ20gaGFwcHkgdG8gbG9vayBhdCB0aGVtLg0KPg0K
PiBCZXN0IHJlZ2FyZHMsDQo+ICAgVmluY2VudA0KDQo=
