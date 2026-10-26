Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793014945;
	b=kWulDsukxLevxA7w1NOsByZEUQ2GJ9MuqXuwD3JvGp2DW8sOmrqSC8IF+1yhOPyi3UKN
	 w1oOQcsMb2iaWR5BIQBIfiL3E2D4rqPr13QnRQR/DsspXY6UbUjlviG7oLWM8CXzN+zGG
	 6Ud4KhvXUsgGfl0G5YGOHCjSRfpwmflyOT4Vn3FaMFXPavtLgYo8gsdVriUEwdiS1Qg6T
	 sHnAmce/5/EEkIiqFxJWzo2WCMRTdfchI5AtUXSU7voNJ1TGnvFAyoQ5I77CRC6lkTYb2
	 l810V8dTmVz1/qlTrDTF92wr7bFZ2yrhKGhqhe2iA085zoyhryUwLKMR+3CD/Lppvxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793014945;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-exchange-messagesentrepresentingtype:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-sharedmailbox-routingagent-processed:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=i3EK0iQhwpCGcpmFn2akFg6SsS9DVigGcliDiprx7oo=;
	b=KpUpswVUhwkQd4XTlQOIYJeebF69PhxjkliSCZasT2qZ8QCNsqoflQhIFJKQwkoVMmy/
	 e78QR+7+l+ldGse7SqeA++1e7Lg3kubiumtGKBcHVfeUIArjL+98Cvq+52seP+1TZ/hUE
	 +5+0g/AGNV+FY9wXPYQXaQ9BncXNoPVGfE1WFLWkts0r+TVTGOOOlWuHzjjmCSVMW+DSl
	 OA8Z6kBs7LodRnZH7c2YGtS9vZDY9LQDGXuWxh0v7Id8L6bn2DBODuCsyZc+1+1Wv42wK
	 e34xjLjjjex3DkeY+pC/qu2RnefBpcstYAFkJGNNpM9UPttCsA0hqAVcOr4ZzqRqM3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Z9OzELdr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.35
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013035.outbound.protection.outlook.com [40.107.159.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0CB606A31B;
	Mon, 26 Oct 2026 11:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0CB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=Z9OzELdr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IxJEn4TEyojFhfNluGr5dABdBMnLYsijvbsENpT1G13EfL3ZuzhihkEW1nDd6BrLKXmiFAVlAI3Zz7/jUqOz2MYqfmNOqzYjSlz1MCkQAa7vED70fO13gBH15qas0gINlUZKFNunzb4NxKq+56BOdyJivozKieSL/VwL1fHGKJIxWHEFvRepqjTiworYHhGO3CYuqh703dJxPUqY4dg1QB+YxMg09TrXabbTVGouL3aJOdN0M+GIm/mHRE0vrsL1yVIWvhiIOENnLCHFcKTXdLjDK2NWnryAaPjQIUXTqoFhO45kDTmpvSay5xrXUs97msFfkoK0Rec05TDI/KWEaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3EK0iQhwpCGcpmFn2akFg6SsS9DVigGcliDiprx7oo=;
 b=Aov8LYfwYjTeb9CEcC4z81jgtQRKpnk0713QMe6YTjHb8RYArkrHhzp18/J7c9u71MhXZLW0jWCODUA5ewhK3Nh78v7fGbXVBDMyhe+BVLdEBFaIhB6V4PjRJ40CT/f7yujGb4kAWmeCKfAyuEVjGA6Rq7YkMg6NTfOLBI91cEESeqXYWXTtO4ctbHVaHbABhhnOzlpPce+MczBaeudAENJVJP3jydzj0xYRTpm8AT6C1YnU3lRjem7bb+Bfd9ZplZ1+LsR2DIXfncbwuau6GKqXQuI+Y7oqjle1J4rmsib/h11KsKndtQ+rUMREExVcd2HR3/Tq6ytypy4r29YjFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3EK0iQhwpCGcpmFn2akFg6SsS9DVigGcliDiprx7oo=;
 b=Z9OzELdrUmeuKg01ID1vwjI5GiVviY8Rrb/OF3CQr8ordRTS923pSsB6y3rw+V71jk0iTk/o38Mrycrx+nnyWgD5VF8kaZ8BjmiXsKLmiIOd6LZuX+4MGMLT3DkecFlGPctFXkpYID6vJXRehCDidRDY9AWTYD8XKXJ2JvQ+IZeKhofkui/q/tpUYsx/mEQ6yd/n9zfrNi7AXBg3CDek2fIHoiq/or4xno4XzDK0rJiZgQ70VF8VdX9TjJ3aLZyxruO6dQEAcdv6htNJJWhdJ/1lV7Rz2OJVaaDRP7/Hsap3DG7CTcsAMCfo6ksFp6Mf4o+L3S//zYFeFvF6qISlqg==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by GVXPR04MB10587.eurprd04.prod.outlook.com (2603:10a6:150:220::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 11:42:19 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 11:42:19 +0000
From: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, =?utf-8?B?SsOpcsOpbXkgSmVhbg==?=
	<Jeremy.Jean@oss.cyber.gouv.fr>
CC: Horia Geanta <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
	"David S. Miller" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [EXT] Re: [REPOST PATCH] crypto: caam - reject overlong RSA CRT
 parameters
Thread-Topic: [EXT] Re: [REPOST PATCH] crypto: caam - reject overlong RSA CRT
 parameters
Thread-Index: AQHdXIenhKA2XAcKrke1VTw6iF32Y7cPT9QAgABsU+A=
Date: Mon, 26 Oct 2026 11:42:19 +0000
Message-ID:
 <DB9PR04MB8139891E52D924862752219B82612@DB9PR04MB8139.eurprd04.prod.outlook.com>
References: <20261008093553.384608-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <atCc0iL0RrDLwHHX@gondor.apana.org.au> <at7aRrDPsroWZtuA@gondor.apana.org.au>
In-Reply-To: <at7aRrDPsroWZtuA@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-10-26T11:10:28.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|GVXPR04MB10587:EE_
x-ms-office365-filtering-correlation-id: 0cb622e3-72e2-42cb-542f-08df33563135
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|23010399003|376014|1800799024|38070700021|4143699003|11063799006|56012099006|261021130227099003|261021121427099003|261021123027099003|261021135927099003|261022115727099003|261022113327099003|261022105027099003|261022075727099003|261021133027099003|261009223027099003|261009221727099003|261009221227099003|261009220027099003|261009223327099003|10067099003|18002099003|22082099003|3023799007|4133799003;
x-microsoft-antispam-message-info:
 SmjOAe88/SlimLZ85e73av0Xgj7xDmevuatKNXam6UrX63QKPVVoG10CNO9mnmoAczC4eY3pkgPu+6BYAPw62bPqoAYD4UAYcegmw2BomPM2ebJOm1XZRLUWbw5tv+mwK/WxZUVjkJDuQ6bCjC0+Hmq6rpTs5v6qNcTXd9g7ytmUxnSxcehqWN4pYQ/jupOhVmWReCfBu42Eg7ZwSvtMsDPmLepEcYQy+vn2ENAdrlWOOvN9f2EUjlRGzIOsJTCK1a2WE1vNjoqlHSSWM6jp00DaU+hAnLqS1WVvX8XPmrEyv/68x1JY0xnP53IRW50/Jrx4+W02Jf9BBnjJO0jE+tiUJhjUKtXNBowHTAjRKsTSRwB3t1TjPlPfLTpMZvWBei3OBVeErBTD8wpxqzmgULIi3Ll4+CkkU00c+iaQ6rZFV9QFb+9DU/6RnlxknyRvvv1tHj34oiEq/gW1apVgRN1i8/PrEy1JKoEjWy7kCxQNaoR/D48IWKB1B5C9Bqn52Yb1LlleEzHQAyv7eu/S2H9CeTSk44+BGpsw0p+JU1dytN+yoS6Nqik+JbD0T7YwhS107WeA5a4jmFNTcUqfAHnWEDtgpH5qiu/YhzNZSXu4mcbYMphWsiOSpunvGeS11qtd3OYvQIhK+p7CsrUQ2v0YRhPaWUh9hqQPH92yJPrTNg5wn2qilBSfcgTLUQ9oGeN8AKGrNfPWsnfhPmRO6ijEXaVqt+XX6z/KyA6Z8AE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(23010399003)(376014)(1800799024)(38070700021)(4143699003)(11063799006)(56012099006)(261021130227099003)(261021121427099003)(261021123027099003)(261021135927099003)(261022115727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021133027099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009220027099003)(261009223327099003)(10067099003)(18002099003)(22082099003)(3023799007)(4133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S3p5VjQ4dE5YWC83NDk1MlVLeGVCdWNyOTZ5K3k2ZG50Wk8yTWJBMHF4NGhp?=
 =?utf-8?B?b3B3ZUh0Y2ZrQjdIc254cDUzYmZCeE9YdFp1WHZaMklQbUZNUGN0eVNQdTh5?=
 =?utf-8?B?T3JkZG11SEh6a0pPR3g2dkczZ1hkNjhxc2kxdzYyc1ZHeUtOYklhWVJ1U2M1?=
 =?utf-8?B?Q2lVSGFKZ3ZwbFRxL1YrbDNoc09pdXZLTFh5amNWNHBiNk1MWUJXL3dJOUVw?=
 =?utf-8?B?SUVzZmtNZkovRXVMTTJUbFgzT3VTVnNjYnZBRVdLcmhxaUU4c1RhRW4zS0xH?=
 =?utf-8?B?TlBDUEMyaVRheU83akw4d3lhenhHWmorMzZkQzhyWTlJZHlqTXY5cWlrdVZZ?=
 =?utf-8?B?dzdOVHZpcGVHNXFlcE5oZXA0V203VnhicG4vMGNoMU1rK2xEekgxNVBtMU5O?=
 =?utf-8?B?ajBBOHgzVmtvQkdZUkc3Q3FWV3BlR1JjZW9ZOXgwK2Izc0gxVU9ta1o5Wkd1?=
 =?utf-8?B?bFdxZkxuYVlaL3pXRDArQWtySVYzNHRwZEt2d01KNlpPMWdzTnh2bEcrbHM5?=
 =?utf-8?B?V0d4aVUyV3Y3UFd1QzVBcFlpOURNeVdqN05TQWFPampVVGtqeHNEQmhtcWph?=
 =?utf-8?B?bldFNkRRc2NrZ3R4SzhoQmNJQ1FNMHN4aWZ0d24wc3FUY2xSWW1kWjB6Y3BY?=
 =?utf-8?B?TkhTVmphVnczSDdQREFvYkR3b0pQaHhDamp6Z3dXUHI0dmx1RHlieVVoOGIr?=
 =?utf-8?B?TXIyQXZyaWtqY1cxamJnVW04UExFVHNQeFRXWTh3dE9lL3hqS1ovcHdJL1lK?=
 =?utf-8?B?alFsSVhNNVU2aTVCVVFydkI4L1k0SWNGbVd1WVpFUUdHUzNSaWs0S3FjZ2tO?=
 =?utf-8?B?OWJoRWNZTFJHTVBIc2MvTS9mZEJiSVVEUUxVeW5sbjk2OEdmd2xYeCtob2hE?=
 =?utf-8?B?UTBlL3g1Z2g5NkNnbEUwMTFMMzFuck94bENaS2JYQ3F4UXFKYzJBRGJ1Ti9u?=
 =?utf-8?B?TG1oUG1BNVQzaUNDcnhMSEcvZEc3bW9HU0tyMVNOaTAxUnFFam82dndKcUxP?=
 =?utf-8?B?R04yZEVkSUZFZWhtQkFYb2xkOHlwcWk0eDhndmI0RDRNWFdBNFZ2dnZucGU1?=
 =?utf-8?B?ZVMvS2dVQzl3K3E5YlcwS1ZuR2pvSXVXcTUxTjJGaEFkR3NyQXh5YWhxK002?=
 =?utf-8?B?am9CaUo1WXE0dlhaazF2Ukl4cWdzNUNzQkphczJ0czArZlVPTkJLVm5ENit1?=
 =?utf-8?B?a2FndVlXNzhRcy9wMzVRak13TXk4dGpBQWY5cHV1YW9iZjhwMDVFZ2JOM3A3?=
 =?utf-8?B?V2ZmUEh2eDdQOFA2dk13V3l1L0dNZEdLQnZSTlhteG9YcUlEK3EvN3RrWTZT?=
 =?utf-8?B?blVLL2VsQ0RtVnRzVVphc3QybE50SldyS2Q0U29CZHVKTlphc2hKMTR6VG83?=
 =?utf-8?B?cXVpYnR0OUhoaFpab1dCUzdiY25waGdHN1UzaWZheWtZY2ljYnZFNS9ieVA4?=
 =?utf-8?B?YnJaNzJsaDlvRUp4RXltcXRxR3lTNXJsaENEM05pby9JTHdSRHFtOHNRMGE3?=
 =?utf-8?B?OWN0WTN2akVOZlNtSzRubFBNajBLTk13c1ZNNktWbTNCdDJJeXNBUFRIdWhN?=
 =?utf-8?B?OVQ2VmJwUENzV3NkT0xORkgzM25rSllZUlJkRVRmcVVPbWtaazEyMFZNRXVX?=
 =?utf-8?B?L2xyb1pNQ0hsVCtDMDNlZjVub3MxY0t2cUVYaDE2WitpZEtXdE1IYitMM3hh?=
 =?utf-8?B?LzhxZ3I0MVR3WE5jLzRPbkUzRlJUWDVHcjNSeTEreFhoMHNOVDRJcktXNVgr?=
 =?utf-8?B?dTBwd3ZtUlpJZkxvSlRjMExXVXJhODNHWkVrRURoeGtkZ05ibnhZZ3IvYldW?=
 =?utf-8?B?azE0VFdrWmV3bDRIYWt1K2t0S0lwQmhNNWs0b3lMZlVkVkF5bmNZWGhYRUZN?=
 =?utf-8?B?a3liNUR5N0psS0dLNy83RTA4VlQwVktVaEVyUEI2MnhhbXZFTUVhbWk1cXNa?=
 =?utf-8?B?TkxBY2pyR1JZelZGY0hHT0dWamZvS2xiUXdHMWZzV21qbjhyZGk5KzkyT3pM?=
 =?utf-8?B?b01xelBnUEd3ajlzcGpHYzdpNVhIZk1ldG5hN3dzd0ZxQy9HUW1FWFk3V3NN?=
 =?utf-8?B?MGJtelNQRmlEZk1Jd1ZOK1FYVW9OeGc5RjZxYnNuRnpFQjVmUnI5ZVppZSt1?=
 =?utf-8?B?Wnl3NHArVzZZV2JoMDVOREFMVkd4aW52dHhKZlIrMUtKeUdmUlduN21BR3A3?=
 =?utf-8?B?L1JFajVwNVZLTnR5R1Z1SmpMV2VBVkxwSWJnQlpybzh2MWEzVFMrVUhvM1RZ?=
 =?utf-8?B?b1loVzBCbk9VSUY5ekVWZ0Z4TXZCRnMwYXJJRDZ6N3lhZEUwQjkxaFBzUy9F?=
 =?utf-8?B?Slgzd1JZanRHdHY5V0gwMTRDU3FndXdsYnJmNXliK1pIY0diLzdmdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb622e3-72e2-42cb-542f-08df33563135
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 11:42:19.5657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddwP3AbVfCoE2TYkpUXD3gWeg4LRkgD6W88y2q8jjAopzthJp34LwUlG86d8cXv5soL2f9eMyvYN/ga7kPMptw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10587

SGkgSGVyYmVydCwNCg0KU29ycnkgZm9yIHRoZSBkZWxheS4NCkkganVzdCByZXZpZXdlZCB0aGUg
cGF0Y2ggYW5kIGluIHByb2Nlc3Mgb2YgcmV2aWV3aW5nIG90aGVyIHBlbmRpbmcgcGF0Y2hlcyBh
bHNvLg0KDQpSZWdhcmRzLA0KU2FoaWwgTWFsaG90cmENCg0KDQpOWFAgQ29uZmlkZW50aWFsDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlcmJlcnQgWHUgPGhlcmJlcnRA
Z29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gU2VudDogMjYgT2N0b2JlciAyMDI2IDEwOjEzDQo+IFRv
OiBKw6lyw6lteSBKZWFuIDxKZXJlbXkuSmVhbkBvc3MuY3liZXIuZ291di5mcj4NCj4gQ2M6IEhv
cmlhIEdlYW50YSA8aG9yaWEuZ2VhbnRhQG54cC5jb20+OyBQYW5rYWogR3VwdGENCj4gPHBhbmth
ai5ndXB0YUBueHAuY29tPjsgU2FoaWwgTWFsaG90cmEgPHNhaGlsLm1hbGhvdHJhQG54cC5jb20+
OyBEYXZpZA0KPiBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBsaW51eC1jcnlwdG9A
dmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW1JFUE9TVCBQQVRDSF0gY3J5
cHRvOiBjYWFtIC0gcmVqZWN0IG92ZXJsb25nIFJTQSBDUlQNCj4gcGFyYW1ldGVycw0KPg0KPiBD
YXV0aW9uOiBUaGlzIGlzIGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdoZW4g
Y2xpY2tpbmcgbGlua3MNCm9yDQo+IG9wZW5pbmcgYXR0YWNobWVudHMuIFdoZW4gaW4gZG91YnQs
IHJlcG9ydCB0aGUgbWVzc2FnZSB1c2luZyB0aGUgJ1JlcG9ydA0KPiB0aGlzIGVtYWlsJyBidXR0
b24NCj4NCj4NCj4gT24gVGh1LCBPY3QgMTUsIDIwMjYgYXQgMDg6Mjg6NTBQTSArMTEwMCwgSGVy
YmVydCBYdSB3cm90ZToNCj4gPiBPbiBUaHUsIE9jdCAwOCwgMjAyNiBhdCAwOTozNTo1M0FNICsw
MDAwLCBKw6lyw6lteSBKZWFuIHdyb3RlOg0KPiA+ID4gY2FhbV9yZWFkX3JzYV9jcnQoKSByaWdo
dC1hbGlnbnMgZFAsIGRRLCBhbmQgcUludiBpbiBidWZmZXJzIHNpemVkDQo+ID4gPiBmcm9tIHRo
ZSBjb3JyZXNwb25kaW5nIHByaW1lLiByc2FfcGFyc2VfcHJpdl9rZXkoKSBvbmx5IGJvdW5kcyB0
aGVzZQ0KPiA+ID4gaW50ZWdlcnMgYWdhaW5zdCBuLCBzbyBhIG1hbGZvcm1lZCBrZXkgY2FuIHBy
b3ZpZGUsIGZvciBleGFtcGxlLCBhDQo+ID4gPiB0d28tYnl0ZSBkUCB3aXRoIGEgb25lLWJ5dGUg
cC4gZHN0bGVuIC0gbmJ5dGVzIHRoZW4gdW5kZXJmbG93cyBhbmQNCj4gPiA+IG1lbWNweSgpIHdy
aXRlcyBvdXRzaWRlIHRoZSBhbGxvY2F0aW9uIGR1cmluZyBzZXRfcHJpdl9rZXkoKS4gS0FTQU4N
Cj4gPiA+IHJlcG9ydHMgYSBzbGFiLW91dC1vZi1ib3VuZHMgd3JpdGUgaW4gY2FhbV9yZWFkX3Jz
YV9jcnQoKS4NCj4gPiA+DQo+ID4gPiBSZWplY3QgZW1wdHkgb3Igb3ZlcmxvbmcgQ1JUIHBhcmFt
ZXRlcnMgYWZ0ZXIgc3RyaXBwaW5nIGxlYWRpbmcgemVyb3MuDQo+ID4gPiBxSW52IGlzIGNvbnN1
bWVkIGJ5IENBQU0gYXMgYSBwLXNpemVkIHZhbHVlLCBzbyBzaXplIGl0IGZyb20gcA0KPiA+ID4g
cmF0aGVyIHRoYW4gcSB0byBtYXRjaCB0aGUgRE1BIG1hcHBpbmcgaW4gc2V0X3JzYV9wcml2X2Yz
X3BkYigpLiBMZXQNCj4gPiA+IHRoZSB0b3AtbGV2ZWwga2V5IGNsZWFudXAgaGFuZGxlIHBhcnRp
YWwgZm9ybS0zIGFsbG9jYXRpb25zIGFuZA0KPiA+ID4gcmV0dXJuIHRoZSBzcGVjaWZpYyBlcnJv
ciB0byB0aGUgY2FsbGVyLg0KPiA+ID4NCj4gPiA+IEFsc28gdGVzdCBuYnl0ZXMgYmVmb3JlIGRl
cmVmZXJlbmNpbmcgaXQgd2hpbGUgc3RyaXBwaW5nIHplcm9zLCBzbw0KPiA+ID4gYW4gYWxsLXpl
cm8gaW50ZWdlciBkb2VzIG5vdCByZWFkIG9uZSBieXRlIGJleW9uZCBpdHMgaW5wdXQuDQo+ID4g
Pg0KPiA+ID4gRml4ZXM6IDRhNjUxYjEyMmFkYiAoImNyeXB0bzogY2FhbSAtIGFkZCBzdXBwb3J0
IGZvciBSU0Ega2V5IGZvcm0NCj4gPiA+IDMiKQ0KPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gPiA+IEFzc2lzdGVkLWJ5OiBMTE0NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IErDqXLD
qW15IEplYW4gPEplcmVteS5KZWFuQG9zcy5jeWJlci5nb3V2LmZyPg0KPiA+ID4gLS0tDQo+ID4g
PiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtcGtjLmMgfCA2OQ0KPiA+ID4gKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMzAgaW5zZXJ0
aW9ucygrKSwgMzkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBTYWhpbCwgY291bGQgeW91IHBsZWFz
ZSByZXZpZXcgdGhpcyBwYXRjaD8NCj4NCj4gSGkgU2FoaWw6DQo+DQo+IEl0J3MgYmVlbiB0d28g
d2Vla3MgYW5kIHlvdSd2ZSBwcm92aWRlZCBubyBmZWVkYmFjay4NCj4NCj4gSWYgdGhlcmUgaXNu
J3QgZ29pbmcgdG8gYmUgdGltZWx5IGZlZWRiYWNrIHRvIHBhdGNoZXMgb24gdGhpcyBkcml2ZXIg
dGhlbg0KaXQgd2lsbCBiZQ0KPiByZW1vdmVkLg0KPg0KPiBUaGFua3MsDQo+IC0tDQo+IEVtYWls
OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+IEhvbWUgUGFnZToNCj4g
aHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAl
M0ElMkYlMkZnb25kbw0KPiByLmFwYW5hLm9yZy5hdSUyRn5oZXJiZXJ0JTJGJmRhdGE9MDUlN0Mw
MiU3Q3NhaGlsLm1hbGhvdHJhJTQwbnhwLmMNCj4gb20lN0M4YWUyMjAxZTZkMzA0ZDRiY2EwNzA4
ZGYzMzFiOTg5NyU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjDQo+IGQ5OWM1YzMwMTYzNSU3QzAlN0Mw
JTdDNjM5Mjg1ODY1OTUyNjIyNDcyJTdDVW5rbm93biU3Q1RXDQo+IEZwYkdac2IzZDhleUpGYlhC
MGVVMWhjR2tpT25SeWRXVXNJbFlpT2lJd0xqQXVNREF3TUNJc0lsQWlPaUpYYQ0KPiBXNHpNaUlz
SWtGT0lqb2lUV0ZwYkNJc0lsZFVJam95ZlElM0QlM0QlN0MwJTdDJTdDJTdDJnNkYXRhPVlQMg0K
PiBIREd4dG1QSFJxdFUzJTJGNmxGcWhqSndPVWE4Q3pwNklWM1FKSSUyRmFZYyUzRCZyZXNlcnZl
ZD0wDQo+IFBHUCBLZXk6DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0
bG9vay5jb20vP3VybD1odHRwJTNBJTJGJTJGZ29uZG8NCj4gci5hcGFuYS5vcmcuYXUlMkZ+aGVy
YmVydCUyRnB1YmtleS50eHQmZGF0YT0wNSU3QzAyJTdDc2FoaWwubWFsaG90cg0KPiBhJTQwbnhw
LmNvbSU3QzhhZTIyMDFlNmQzMDRkNGJjYTA3MDhkZjMzMWI5ODk3JTdDNjg2ZWExZDNiYw0KPiAy
YjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzkyODU4NjU5NTI2NTYxNjAlN0NVbmtu
DQo+IG93biU3Q1RXRnBiR1pzYjNkOGV5SkZiWEIwZVUxaGNHa2lPblJ5ZFdVc0lsWWlPaUl3TGpB
dU1EQXdNDQo+IENJc0lsQWlPaUpYYVc0ek1pSXNJa0ZPSWpvaVRXRnBiQ0lzSWxkVUlqb3lmUSUz
RCUzRCU3QzAlN0MlN0MlN0MNCj4gJnNkYXRhPTlONUl1VWMwUmVFZmgzN09VdnZWcWZXTXMxTkpS
eFM2eURkMzJObVV1ODQlM0QmcmVzZXINCj4gdmVkPTANCg==
