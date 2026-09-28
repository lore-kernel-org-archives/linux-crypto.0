Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013027.outbound.protection.outlook.com [52.101.72.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE2648F828;
	Mon, 28 Sep 2026 09:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587697; cv=fail; b=BfTeBnviwDxOfGLnUF6oMDwzNUEiuRGNnuo5rnd3t+UPyhr4IOhc7tZkA0qaPqKUInAHftUuPTPcbhqHeu2EMtXifV/Oi4Lj2JwVgvO4Nlnc7P8h2Zp1qipE8GtdteQPpVLtyqk10kD+j3lLPp1hBJbQ1LEhj3QROe00L4as/no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587697; c=relaxed/simple;
	bh=qfVdOzkD3DwGA+WoJU2puqVIC2S61NioDZqPQ7Y9oAs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RYa0jPsDfaXOdzHx52wHyMKxlpw3/Uf4WEpSChVhRHKQnrPcRB7OYa3STLj4hYn+acRXEuxDpIdJinrdVe8PTjFMhxqOe+VY5ys0QmtZbMnYKC3imTpAtK3sUA06FF1HExEI9+SMGn4mglJOobNo95wQ3hkuTJcuVKVq7Feisbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=S1Nb/8Cr; arc=fail smtp.client-ip=52.101.72.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="S1Nb/8Cr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y0Wp/CSn8nBm59X+L8OibYztoIzddFy7Ai8jNA2CTQzGiRp52DoqcBTnED6zW//8eYqqwpNco1oFmSUdoKaadGuGzkOvySZhVHIXwOF+AQ8zsPZCKzckCv1z934LdGQ3bMnIO8kRDP1r3aAkI8XjAQc6046D6jh/BKGKtfAX/ewa+IF8FFsjrr//xpCVzepm0dQP8CvTP21tLBrpfOM8vE8pvo3/EDJIrQIDjExapV7gHDLvz6Zud01lw2+UqrGoj8FLsdy1zcBFbROGgBEnSY9RttmITHHZHq2a+GQ40gczLecqETVQ5XOgK35Hw0uKuwxj/0lQZ1VY8U7xazcZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfVdOzkD3DwGA+WoJU2puqVIC2S61NioDZqPQ7Y9oAs=;
 b=e72fT/4HfQM7ppsVR5A6A5bPhdH9OZme0vxdPnI5IBDKD9nef9STMBYara9OE0NkGmLetZd8yXqpfz+Yh9XC9qK6BgW8Qa+pfkoJQ55I5OwT7dIENZYWf4stZo7/7EDrFyeRdCifeUoOI+0Wy2xiBC75qGzgplunPYY4KK/IHH37rJ8XKwDcDhK9/+18F43o9UJSd7gCDW1Cyfd93UuEdtPTb+3nSGiYnBP58SbstIEm/QAJWcCtucBDozcU2026qeG/1D9sgsOWxVpDvsybyZhxzQnShb/eJxvC7f8+t9vohkz7HwahVd9O2JH1lv6x6IaBuSo4hDGzKLLMqisfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfVdOzkD3DwGA+WoJU2puqVIC2S61NioDZqPQ7Y9oAs=;
 b=S1Nb/8CrUcZfBUwF4ANWrRHogskTS2mj1CguhidsZUxsFiBCEJ8LORMOsCX3+pPH//sxXvMmQBdHNErSTUekfragphMDPhI5TYHhmuqLh3zNNmuTCm3bMQvQz0CAXuUo4b3XsXJajzhMLmobiigX0gPBe1lBCJol0tmVFgvijNIhaFgj1ebvZl+YdLzl70NMC+8gvJvUOgZmiX7CFsmxtsO0hOFGBf9kM27pdgmFiOzjQILp8bAlkoTGA4B4RBilu59TCZjI+vKJ2bX8q9LPe1ImPd0vTYoG547oD3RSIgogAqL44EKTYr9VT+RZQ6A8Ze7881bFOTGibuPYILMDVw==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by AM0PR04MB7074.eurprd04.prod.outlook.com (2603:10a6:208:196::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 09:27:36 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 09:27:36 +0000
From: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
To: ZhaoJinming <zhaojinming@uniontech.com>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain
	<gaurav.jain@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S .
 Miller" <davem@davemloft.net>
CC: Tudor Ambarus <tudor-dan.ambarus@nxp.com>, Radu Andrei Alexe
	<radu.alexe@nxp.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [EXT] [PATCH] crypto: caam - fix double-free in
 caam_rsa_set_priv_key_form()
Thread-Topic: [EXT] [PATCH] crypto: caam - fix double-free in
 caam_rsa_set_priv_key_form()
Thread-Index: AQHdS0X6MxTcWWySZ06RwvpXSymlmrbjv5iA
Date: Mon, 28 Sep 2026 09:27:36 +0000
Message-ID:
 <DB9PR04MB81397D8C6578A804D3D291F4828D2@DB9PR04MB8139.eurprd04.prod.outlook.com>
References:
 <FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com>
In-Reply-To:
 <FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-28T09:23:50.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|AM0PR04MB7074:EE_
x-ms-office365-filtering-correlation-id: c7d986ed-deff-4862-32a7-08df1d42bbf1
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|19092799006|10067099003|11063799006|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 5ncyPxIus29kXFkuzkvOgPCt+HMQ3h+TbIMNhcEhqeHgB4yRox784q/6l5CfCNHIONTXE71hitm73JacbC7UXiP+6FSTwPHFS7TsneqbOKNu8VIhNbfbsVOUM4VtjtePsnF0KkhmXoLOVfo0sWkEWMU9I2qKhWtJDm9M51SHKSiQL4FUID8DFNsDcaoIix//skuH/qkpK/Mgp+WHXk7Dd8F0JtQootdNDjAxeJsmwL9zC27dH5Fz8RO/vI9uVqrJg4rx/AOdtOPjFarg7UxViES84KMDBenzEOITADPydejLIeyexNglH2Gwlpz44ctU+ixIWKWF8S0eEbTa2mRawQCKJpSFm8osR6pfhEQY9IMEKLXKlujBqnFLPASmIzOFX3f+xSfBcwnajG5PWB7it0v6pVG4q9h4NEnU+sgZH1wsl6DnhMoMPuOfkK5BOQ6kRfsnP9EIYzMJ1BkVc8nximGzaWMZB2BP2OaFjXqbBekOwKl0B9NO+gYIiFYiPjDnKDO43sNVqrw/E1NV4J9uxBbs+ItBJAm52mWLnVy7Dat/OkB2H8KUWNPBPUxJEYFY8/C39LjL+XQlFXvpW5ICVUK3V7mDIAv40pG6Rr4qNL3lRZBdja3xD0UjMKeif/cNEeMNz5NF/HmYHrvDzsdcJYdPI6nnl9zW6c+do+W9cl6iNC1A4ptsmcPyGGw5N9+Ij/s4V17r3uw+/hqT9HkuYMTbgm+cguupjLsMQkoxrlg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(19092799006)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SEZLVm0xclNaWUxsQ05IKzVDakdkdU55NEFMcEF1Y3J2dHludFJxOEJEVU1P?=
 =?utf-8?B?R3hVMUxhaERZZUJwNW9mMzNmUFhaRXBIWHBHQlNqajZlTFBuSzRTbVNpZ3dn?=
 =?utf-8?B?Zlk4UmRIcFAzM3pKT3lIT0E2cXVpTHJVK0pxTmM4RUVSRk9OT08zeklZbGIr?=
 =?utf-8?B?cWtpRW5hS3NiT0loVXhkYXgyQ0pWR3JWenVZUXBHbXFIaVYyWDFKWVpzbHVE?=
 =?utf-8?B?ODF2SVBidlMwSE1EZHhudjQ0ZGtVeFZwUUdhaFpiczVlOEdwTGFHRU9JRHR2?=
 =?utf-8?B?QlRhbFFkQjRGOEl1ZEFPYjI1blBiSTUycjJESnB3Z2I4MEtkV1VqSW1vQTJO?=
 =?utf-8?B?ODNFM2FKMXhJeDUveW9DRjlINWx1NXhiZEk4OEcrT2NmY3MxaEtzTGppZzMy?=
 =?utf-8?B?YjhOTVNLRDk0S3IrMU5VWThWT2l0ckJYQ2FOVUxPOU5nTDJySWNNL0hGc3J6?=
 =?utf-8?B?Q2YxZkZRZmF3cTRkSUhIMGFrNndOTEtTSFA0bklHdTJ0bnNHOGJHUXkvclpY?=
 =?utf-8?B?NnVNL1MwRit6TEZjdUZZOU1CQzNLdnB0SmMvWm9CSGFFcEE2OWJjNGhmTGhz?=
 =?utf-8?B?VXRNQVllZXJ2Q2kycTVjRXVwdFk3dzZSaGN4SVNZbWQxM1VUMS90bGhEU0Qw?=
 =?utf-8?B?N3BOTG83eFNEUGZEaUV4TDZqVWwyOXE5dFNrb2gzVTZmNllmalZnRlZpcVZs?=
 =?utf-8?B?TzdXS09yc2pwQTdHY2NsbzNqVWtHNEVaTTFHN3FKN0pxR3ovb2hNNVhQWWs0?=
 =?utf-8?B?ZjBjWWNYT2tJTWtlSmFNNnkzMHg0QXZ4YWtGbmU5N3prNlR2MnhOWlNGdHh4?=
 =?utf-8?B?TVdhOHZmdS9FZUVCWGVCOVhZM1VPeGJSU2NQTDdJZ3p0RFRTSmRiZEtDMnBn?=
 =?utf-8?B?UEFkVG9EVGlqOVcrb3BRZ3h6NTdZS3pYQTdCL29XZUx4cHRIN0VBZjUrVSsw?=
 =?utf-8?B?YkNwUUJLM0d3bThsR1J4eTk4a3U4djl2UDBGM1RDaVprRTV6aEhSeXdiTnFE?=
 =?utf-8?B?aXVPL1VWMUxyN2p1S2gvNzdlZWpXSU5FYno1di9MS1haWklDMjg5emc3M2Vl?=
 =?utf-8?B?aWZlcGZHQjdqdzc1RWE1RG9SSXppYlkyQmZCTXBVMHgrelAxMDJLQ0hGaENY?=
 =?utf-8?B?YTRRRkxLWWcyckVwME1VQkpieXpvbUpMbU5IazRiM09PbUQ2RUpMbVprcTJJ?=
 =?utf-8?B?RlZGWjR0SzlGYnNSTW5ORlJyeHQ2VFkxQUU4ZnFraDFTSXRCZHJrMXNWYUN4?=
 =?utf-8?B?ZVhQN25DRHI1MTdrY1o4WHNQa01kSzkvcFBaTGZQMk80MW00RjZMSlI2WHhQ?=
 =?utf-8?B?a1VDQ1BpclZ0YzE3TFpFMTIyQWpodlQwdWdZL1ZnZldWLzRDTXVIcVVjZXpq?=
 =?utf-8?B?MFJCWnRORWJHem5kWlczdWI5cDQxUTRLd3kvRWRGdlJlVGZEZVVDVnFseDFE?=
 =?utf-8?B?TTE3Rmxpd0cyM0lwWWg2VkFaT1BtY3l0bTRUNVFSOXE2MGJqYnNucFJRUHc5?=
 =?utf-8?B?TWF2a1BjY0F1eVpoRjJsM3d4bE1lOWhyMDNDaTBkZFVEcTMxZ1RVTEJJZFFZ?=
 =?utf-8?B?WldML1RuT0Vtb2Vqb1VVL2xnQmMxODZmNHBPZHpxNUdsOUpwTUpBcFY3UE9C?=
 =?utf-8?B?Rm9NUzJHN0VKYUQ1RTZvQmtYSmV6QldteE5ZTXFYY0VjV3ZKNWZtaW5wcEhY?=
 =?utf-8?B?bFB4QTIvRFZJRkpqZ093VjN5QVYxUnVqMk9pcmZId3I2ZlRseXl1WE9TMmJy?=
 =?utf-8?B?QTdrY042SUlYL2c4NWdUU00zN2o4NXJpdXJKSzVTUSt0NnVtQ0FjK3RUQ3Nn?=
 =?utf-8?B?a3ljMlBQVjlETi9lYVV4RFl0VmhSMDJ5Y2h4SXVjOGFhRy9MZ0o1TWhWVWty?=
 =?utf-8?B?UTFmN2YxV2FCcDlRWitYV3ZsNlh6L1QvVmlOWHRvWmUrblZmazJSRkY0TkFY?=
 =?utf-8?B?akU5cnlQZkc2VTA2WkFwL2g4cVlJUjFCWUFtVlFhSis3NEN3VmQ4YzRHbEl6?=
 =?utf-8?B?VExwUUQ3OEx3SmxuWmJnZDloTWlOU1JaODR4elZDZ2ZvOTBZYjZIQjVLeHk0?=
 =?utf-8?B?Uzh4OTB2dWQvajY2VFlFT3RBTEg1RnVkUWptTzFmS0U0S0tWUS9uTUZUSkl0?=
 =?utf-8?B?cHJLaXlDY25Gb0ZwcmVsMUg0WGQrOWVNUmR6bWM4a29KZzlpdmlZQWFXNU1r?=
 =?utf-8?B?ZE9sajdSL29sTExud2N4N0RObkViNVNaczFsUUZLQzdrQm5UN0RhbnR2ZElW?=
 =?utf-8?B?RXRFblU2bVdjdXJUQzJnbU5WbkZhdHlCK0FxVUwvZk5qaGw4aVZuUGEwYXJv?=
 =?utf-8?B?M0J5eS9aRytTalRQSkZFWWsyajZhYlA2V3NQRk5QOWhldko2eTFNUT09?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d986ed-deff-4862-32a7-08df1d42bbf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 09:27:36.7540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ANhAE5k8S4XwzpYFkMtKN6Z/+kwMCP1VGoxcUrjxNZvOzu60opfz7/rYsXSVaLBTHObrMYxPka1q4ivYxEsm8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7074

VGhhbmtzLCBaaGFvSmlubWluZyBmb3IgdGhlIGZpeC4NCg0KVGhlIGZpeCBsb29rcyBjb3JyZWN0
Lg0KDQpTaW5jZSBSU0Ega2V5IGZvcm0gMyBzdXBwb3J0IHdhcyBsYXRlciBhZGRlZCBieQ0KNGE2
NTFiMTIyYWRiICgiY3J5cHRvOiBjYWFtIC0gYWRkIHN1cHBvcnQgZm9yIFJTQSBrZXkgZm9ybSAz
IiksDQpkb2VzIHRoaXMgZG91YmxlLWZyZWUgYWZmZWN0IGJvdGggZm9ybSAyIGFuZCBmb3JtIDMg
cGFyc2luZyBwYXRocz8NCklmIHNvLCBpdCBtYXkgYmUgd29ydGggbWVudGlvbmluZyB0aGF0IGlu
IHRoZSBjb21taXQgbWVzc2FnZSwgYWx0aG91Z2gNCnRoZSByb290IGNhdXNlIHN0aWxsIGFwcGVh
cnMgdG8gaGF2ZSBiZWVuIGludHJvZHVjZWQgYnkgNTJlMjZkNzdiOGIzDQooImNyeXB0bzogY2Fh
bSAtIGFkZCBzdXBwb3J0IGZvciBSU0Ega2V5IGZvcm0gMiIpIC4NCg0KUmV2aWV3ZWQtYnk6IFNh
aGlsIE1hbGhvdHJhIDxzYWhpbC5tYWxob3RyYUBueHAuY29tPg0KDQoNCk5YUCBDb25maWRlbnRp
YWwNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWmhhb0ppbm1pbmcgPHpo
YW9qaW5taW5nQHVuaW9udGVjaC5jb20+DQo+IFNlbnQ6IDIzIFNlcHRlbWJlciAyMDI2IDE1OjQ1
DQo+IFRvOiBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPjsgUGFua2FqIEd1cHRh
DQo+IDxwYW5rYWouZ3VwdGFAbnhwLmNvbT47IEdhdXJhdiBKYWluIDxnYXVyYXYuamFpbkBueHAu
Y29tPjsgSGVyYmVydCBYdQ0KPiA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgRGF2aWQg
UyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gQ2M6IFR1ZG9yIEFtYmFydXMgPHR1
ZG9yLWRhbi5hbWJhcnVzQG54cC5jb20+OyBSYWR1IEFuZHJlaSBBbGV4ZQ0KPiA8cmFkdS5hbGV4
ZUBueHAuY29tPjsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IFpoYW9KaW5taW5nDQo+
IDx6aGFvamlubWluZ0B1bmlvbnRlY2guY29tPg0KPiBTdWJqZWN0OiBbRVhUXSBbUEFUQ0hdIGNy
eXB0bzogY2FhbSAtIGZpeCBkb3VibGUtZnJlZSBpbg0KPiBjYWFtX3JzYV9zZXRfcHJpdl9rZXlf
Zm9ybSgpDQo+DQo+IENhdXRpb246IFRoaXMgaXMgYW4gZXh0ZXJuYWwgZW1haWwuIFBsZWFzZSB0
YWtlIGNhcmUgd2hlbiBjbGlja2luZyBsaW5rcyBvcg0KPiBvcGVuaW5nIGF0dGFjaG1lbnRzLiBX
aGVuIGluIGRvdWJ0LCByZXBvcnQgdGhlIG1lc3NhZ2UgdXNpbmcgdGhlICdSZXBvcnQNCj4gdGhp
cyBlbWFpbCcgYnV0dG9uDQo+DQo+DQo+IGNhYW1fcnNhX3NldF9wcml2X2tleV9mb3JtKCkgZnJl
ZXMgdGhlIHBhcnRpYWxseSBhbGxvY2F0ZWQga2V5IGNvbXBvbmVudHMNCj4gKHAsIHEsIHRtcDEs
IHRtcDIsIGRwLCBkcSkgd2l0aCBrZnJlZV9zZW5zaXRpdmUoKSBvbiBpdHMgZXJyb3IgcGF0aCwg
YnV0IGRvZXMNCj4gbm90IHNldCB0aG9zZSBwb2ludGVycyB0byBOVUxMIGFmdGVyd2FyZC4NCj4N
Cj4gV2hlbiB0aGUgZnVuY3Rpb24gcmV0dXJucyBhbiBlcnJvciwgY2FhbV9yc2Ffc2V0X3ByaXZf
a2V5KCkganVtcHMgdG8gaXRzIGVycg0KPiBsYWJlbCBhbmQgY2FsbHMgY2FhbV9yc2FfZnJlZV9r
ZXkoKSwgd2hpY2ggZnJlZXMgYWxsIG9mIHRob3NlIHNhbWUgcG9pbnRlcnMNCj4gYWdhaW4sIHJl
c3VsdGluZyBpbiBhIGRvdWJsZS1mcmVlLg0KPg0KPiBUaGlzIGlzIHJlYWNoYWJsZSB3aGVuIHRo
ZSBhbGxvY2F0aW9uIG9mIHEsIHRtcDEsIHRtcDIsIGRwLCBkcSBvciBxaW52IGZhaWxzLA0KPiBl
LmcuIHVuZGVyIG1lbW9yeSBwcmVzc3VyZSwgb3IgZm9yIGEgbWFsZm9ybWVkIGtleSB3aG9zZSBD
UlQgbWVtYmVycw0KPiBkZWNvZGUgdG8gemVybyBsZW5ndGggYW5kIG1ha2UgY2FhbV9yZWFkX3Jz
YV9jcnQoKSByZXR1cm4gTlVMTC4NCj4NCj4gU2V0IGVhY2ggcG9pbnRlciB0byBOVUxMIHJpZ2h0
IGFmdGVyIGZyZWVpbmcgaXQgc28gdGhhdCB0aGUgc3Vic2VxdWVudA0KPiBjYWFtX3JzYV9mcmVl
X2tleSgpIGNhbGwgYmVjb21lcyBhIG5vLW9wIGZvciB0aGUgYWxyZWFkeS1mcmVlZCBmaWVsZHMu
DQo+DQo+IEZpeGVzOiA1MmUyNmQ3N2I4YjMgKCJjcnlwdG86IGNhYW0gLSBhZGQgc3VwcG9ydCBm
b3IgUlNBIGtleSBmb3JtIDIiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWdu
ZWQtb2ZmLWJ5OiBaaGFvSmlubWluZyA8emhhb2ppbm1pbmdAdW5pb250ZWNoLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2MuYyB8IDYgKysrKysrDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0
by9jYWFtL2NhYW1wa2MuYyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbXBrYy5jDQo+IGluZGV4
IGNiMDAxYWExZGU2Ni4uYWM1MTVlZDhjNTc1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0
by9jYWFtL2NhYW1wa2MuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2MuYw0K
PiBAQCAtMTAzMywxNiArMTAzMywyMiBAQCBzdGF0aWMgaW50IGNhYW1fcnNhX3NldF9wcml2X2tl
eV9mb3JtKHN0cnVjdA0KPiBjYWFtX3JzYV9jdHggKmN0eCwNCj4NCj4gIGZyZWVfZHE6DQo+ICAg
ICAgICAga2ZyZWVfc2Vuc2l0aXZlKHJzYV9rZXktPmRxKTsNCj4gKyAgICAgICByc2Ffa2V5LT5k
cSA9IE5VTEw7DQo+ICBmcmVlX2RwOg0KPiAgICAgICAgIGtmcmVlX3NlbnNpdGl2ZShyc2Ffa2V5
LT5kcCk7DQo+ICsgICAgICAgcnNhX2tleS0+ZHAgPSBOVUxMOw0KPiAgZnJlZV90bXAyOg0KPiAg
ICAgICAgIGtmcmVlX3NlbnNpdGl2ZShyc2Ffa2V5LT50bXAyKTsNCj4gKyAgICAgICByc2Ffa2V5
LT50bXAyID0gTlVMTDsNCj4gIGZyZWVfdG1wMToNCj4gICAgICAgICBrZnJlZV9zZW5zaXRpdmUo
cnNhX2tleS0+dG1wMSk7DQo+ICsgICAgICAgcnNhX2tleS0+dG1wMSA9IE5VTEw7DQo+ICBmcmVl
X3E6DQo+ICAgICAgICAga2ZyZWVfc2Vuc2l0aXZlKHJzYV9rZXktPnEpOw0KPiArICAgICAgIHJz
YV9rZXktPnEgPSBOVUxMOw0KPiAgZnJlZV9wOg0KPiAgICAgICAgIGtmcmVlX3NlbnNpdGl2ZShy
c2Ffa2V5LT5wKTsNCj4gKyAgICAgICByc2Ffa2V5LT5wID0gTlVMTDsNCj4gICAgICAgICByZXR1
cm4gLUVOT01FTTsNCj4gIH0NCj4NCj4gLS0NCj4gMi41MS4wDQo+DQoNCg==
