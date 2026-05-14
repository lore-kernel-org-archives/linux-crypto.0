Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2118.outbound.protection.partner.outlook.cn [139.219.17.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A621C01;
	Thu, 14 May 2026 07:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778742808; cv=fail; b=K0P5hO5Np6aAS+mBRJN5nDwYwCunBZzaxCCTAkRKXoOyT2KW8zmsfqfnYN4BlQ6toWICu3Va9S6j42dH5VoyL+HvQyd5nj32eVYkEbPRexN7UqiKa7NRmbdP/CZhhxeH8ohKErALRDG5o+RJ3OaFjvMLlhh/cLQhcPMwT36yHis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778742808; c=relaxed/simple;
	bh=NYBEaHsbnJse1Qx85mS45Y6yLOniQ4XlENoyoMgj4eQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hsv9r/i83sTQKiDAYVPWz/iR0nDeSJRrCUEEZx9BVAo3HDIIuQwSzWvbZEATq1riokna5JVsZHxkUxTYneNme00RUxRRYm25ry/qtu/H0H7eASoYb+uywJxzb6FoREauB/4pDKmipJqysLfUyNI3pjBJ0PxD0EHzzdkH0Qx8+08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOCWapmKFHs4NhWM+OFKTwUSluub0O5JuGHypX/bzUWyV9HznTBDZ1yeFPMZtYfCNNutZU1uGyIE9xssj2VufZrjO3VTR76rh6J8pJoRmL3yS7YNbye3NHbs/liZjfmG0jZ/elncsct42tLP+51fUmMykeFJfTlUW40Y/UCn4ndtTsYQ+CX6+oI8WqaSegoIewWhU0sZY6mHo+oUVOux4OXs1poxhyYuXjy9UULVBWknmvm9cg6ROmQDvfD/3fKasFYkMI9MMI4Tote5rAFwy7SbcwR3UjrW3OAeXoHqT9tLoqxP5Z1STONVRQT+BHYmciSxi57KFMPK2L+FmSQvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYBEaHsbnJse1Qx85mS45Y6yLOniQ4XlENoyoMgj4eQ=;
 b=fNTlcz8Fydu/iQWkCJpKg1u+XdoIQFWil6fqPw5qeF90A+IQ61+LMKa21SFQZ+lH1xUTtWdXjJflsfWwNFe/6g2n39uyrmaoOQlp64YIB9lILHlaLpVR2nfm1eLuVfCVuTtdFqu1jOpwCg3wPiiZK2tr1acqVACrcNcXdQRrNc9uNvtxQX6Xli8b+MF3ffaem9ogFs8gpPPfwcSS1Nu19SLXvl6cq/cOumm6wzT027oB+zgAjPi8NIGds8vocUveD0PQi85Eyp/E0gPsuKX3kxVEuXuFB7Y25fl6gWiaK09W6gRJzuyC0agsiJZwP+wx9clHI+DWEeczJyR/r3wNxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1014.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 06:41:03 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 06:41:02 +0000
From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
To: Conor Dooley <conor@kernel.org>
CC: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Philipp
 Zabel <p.zabel@pengutronix.de>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject:
 =?gb2312?B?u9i4tDogW1BBVENIIHYxIDEvMl0gZHQtYmluZGluZ3M6IEFkZCBiaW5kaW5n?=
 =?gb2312?Q?s_for_StarFive_JHB100_SoC_trng_controller.?=
Thread-Topic: [PATCH v1 1/2] dt-bindings: Add bindings for StarFive JHB100 SoC
 trng controller.
Thread-Index: AQHc4dfyFhKDHssFEUOpT9vdIzRYb7YKohKAgAAnTACAAkKmgA==
Date: Thu, 14 May 2026 06:41:02 +0000
Message-ID:
 <ZQ0PR01MB126971A1EFFCB5A427C853D982072@ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn>
References: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
 <20260512062404.4540-2-lianfeng.ouyang@starfivetech.com>
 <20260512-seventeen-deduct-fa7eead281ef@spud>
 <20260512-rifling-granny-a467a53ef289@spud>
In-Reply-To: <20260512-rifling-granny-a467a53ef289@spud>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1014:EE_
x-ms-office365-filtering-correlation-id: 3c89e22f-7fa6-4d37-a201-08deb183c488
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|18002099003|22082099003|56012099003|4143699003;
x-microsoft-antispam-message-info:
 9/lMsO4gWCmOYssjBhLKMViSojh62r5RWq+2xkmUmybZiSmbbJg1KvdPyPlIG3N9yXbgqxEdycwu4DnX56cwRHNqGFDE9u9M91CRImzz1Tm4xccUp7xyMTrSlPPEsCcEdwRM70r11CawkET93ZNkocdv8/RDbBzUcw8fT9xb77DavyBaaQZ9epHYSMqz+F09ZlvXXYLTbqNb8iltQxa7mHwxq5iRlmpmT/LvGrIdxUmxnzw4dFKcdsIUqgh3x1+n+V/hLgvyE/m9Tv6VX5RkdWfwE/yBz8uX7SP0nZN2eDX90OfQ4G6JR81ahEJxA3TTVhT0if3haK7ewHc2jYO2oDePtoAhIqcjZpBDn1J/sy+1OT8iF6z6QHL7KpMBd2bb9f9hAsiqBmc1FCM1uOjMkgE5Hm5pfCI08TLnPGdW8c5Sq4oWi4nbWyvi4aygQ3g2eOlccE8yIvuI8Ow/MZFOV0iXZZoymqtXhKA+8RaRMBw0YYejsFrMH+rtc1RuX4PkYFoi/n6Jm8JMufzn4+AAsHXZ8yEzvur/6y0hEes1Z2uwU3HJ2u14RhFawjeAVOWs
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(18002099003)(22082099003)(56012099003)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?bjdtVzRPTml1b21yVkoxQ1VheEpXVEN1ZWhld2EvMXNJV2x3OGhLRVR2TFgr?=
 =?gb2312?B?OFQ4dWJTTE53QUJNRTY5Y2V1V3lEbVpvZytUdDVnak15YmQxd2pRY2M0ME9V?=
 =?gb2312?B?Y0Z5aHIxSDc0MG1kNmIwTmg1QkpUV1NTRmt0YWoyS2Y0azZoeEdYUUloVXdB?=
 =?gb2312?B?U2lhemRnUU44OURCR1lhenB3ZmpWSVR3dS9mZG4vUE84cFd0cituQ3ZEdHRq?=
 =?gb2312?B?MWY1NlJtajBIdFZudjhmbFpuSkZqMUkrS1hDZ05nNklFN3hFY3ZuT29tci9J?=
 =?gb2312?B?YzJwek1pMnVwUEs4Z0UrQndFSlZlOUVjZGFJS0hGY1ViY1ZFVGhkN2ZRSnlq?=
 =?gb2312?B?cDRJcEVFaXlLYldEejQ2eUU0VllyS1FkOHQxcVFsbUxOWjRrSW5hekh6R2My?=
 =?gb2312?B?WlRzclZFS0Yxak1za3J4d1VFUWlvUDR5QXQvZ1ZuK1N0aUxSeHZrTVNSbUFp?=
 =?gb2312?B?ZURIbmJEYklxWHF1dy9ldFdxMjNRZXR0bDdjS1BIZG9oZDRZVkUxa2NFd0or?=
 =?gb2312?B?Sm9Jd3EzbVVxSENXU2cwVjZSYkN6eHdRM01mc2lGcXRKa2VkQVZyS2VHZ0Ra?=
 =?gb2312?B?YVNueFpZbmtTYWVIUFFhT2s5OEZNd0diL1A5Z2s3VW5lREpyM0xtaTFmc3FS?=
 =?gb2312?B?ODdQbmpVZnZReUU5bkZhUENlWElXejE1cHRIcWNrL1pTblI0N1ljL1ptVmV1?=
 =?gb2312?B?NjhudlU3bjkwUUMwY09QTUxPNFFMMHhzTkRKcWtOVVlHeU5XbklQM1VKdUx6?=
 =?gb2312?B?am1NVmNpckRJV3hnVlU1L3ZRTTVEUFRBcjFVd3l2ZmZXd0ZkVUpyU1JkSkEr?=
 =?gb2312?B?cjZtZlRDeFFBdndUZlNwWG1Fb2pMdEJBYVNucEZVNzI0eU9SOUxwaFc2a3ZP?=
 =?gb2312?B?T2trZ2NQblhqa2EzZU03eWJPMmczWjIxWkNWam43ZDhVMEpCL3JzSkFGS2hx?=
 =?gb2312?B?UWsyQUVwa1pNZVZKU2ExVklYYVhIck5aaHhWWXU2MzBabXRSbXpEQm8xUnVh?=
 =?gb2312?B?SDdLaitQaThoYk5FY1lvVWdvY3J2ZFMraURmUUdvVDBndnhEVzI1NUUrYnd0?=
 =?gb2312?B?VzRPbkdnRXNqSFlQVzdJd21uVEw2Y3hZcHd5bVZBQlAwRGcycW5UOC9GQ2g0?=
 =?gb2312?B?V25VR2liQ3dqMDZ1N0JXV28rbW1VSENCN3dGSFA4RGhQd0RUQkVMYklVaDlZ?=
 =?gb2312?B?ekFGRVNSU0VWUnhkUkNyOGVaUENKbnVMcVZrdElLQnZaQVJWdm45NGNaR0lR?=
 =?gb2312?B?SDVPcW9CSXVYTkxVSXdYZTFMd2sxMUVJczBmZ2Z4MlExQytycWtuTDQzLzlt?=
 =?gb2312?B?RGJhbHBLR2QwejBYMDYwQk9BNUVVRmpoQXdTcEhhL0xScHhBK3ZtTGsvQU5F?=
 =?gb2312?B?TXI1a2trOWFkendmZEt1Y3dOOXBJUXBuZ2hSSGtIcm1NaFhJZGdBWlh4N0Zj?=
 =?gb2312?B?NW1QUWwxOUpPSzlyY0dXWDJ2WWFZeFZIcFVMeStXY1RNZmJ6SnpEbVd6TGVR?=
 =?gb2312?B?N2xNVUpiUE5SQ1dZTWp2elhtUFRpOFl6ZjR3azBrVWxzcmhsRnFtOW05eExU?=
 =?gb2312?B?Z1QxclRVVnZWSjZic05TWmJDSUpMMnBodWRhTEVuT2xLSC9mU0VBVHVNY25R?=
 =?gb2312?B?QlY3MThDZUlBU2Z3TVE2S0FUKzVIUmpkOWdDdHJLc29NNUZSTWxUL204QXh6?=
 =?gb2312?B?Sld6OEtJTjkxMnlXY3ljR3p6YUQ3R1ZhQlR4cDVHNS9UMjVoQkg4eWpDbUND?=
 =?gb2312?B?WmRONGptQjhYd2M2UkdjVVJudUtpS0FjSXhNcmNqQTJ6SmxqSjBnd1hnNHQ4?=
 =?gb2312?B?MmNVeUVjT3UwUWN4SlFYZWRUd3k2Y0Flc005eGNQZ1p2Wm1XOTVKTG40MFZE?=
 =?gb2312?B?Qk5JUWxRUkJWU2pMOEc4ZzBOQVdMUFovWDNaMkRJVzlqZEl1TDZCRmQ5L0E3?=
 =?gb2312?B?WE1odllORkpMQi9mNW40Z2p4bDhBa24wd0IyRDRidXRsSVNmSzNud2dHWEh4?=
 =?gb2312?B?Z3N0RTEzME12Y2RETG1IbmhtV1VWc09TTGFEZnoxTXU3emF1UG1kZDdIWHpW?=
 =?gb2312?B?VVpSOGlBdFV4Lys4bEM0OERHc2hvS0RIZXl5UnN6bENjdnc2WDI3NVo5SEJL?=
 =?gb2312?B?VlRBbXl2L09YbXdkN2VUMzZxWTJRWE5FUUN6THlqWXZPUjUzZVJUdHNaRE4y?=
 =?gb2312?B?aW93RmxTT3psQVlGeEZPLzZ2Q0NDLzNld2lkTUszVWJHV2ZjNVVBK0h5UXRn?=
 =?gb2312?B?empuSzV6ZXh1Zm1DTmhYeVVsdDh4dDU3SUtvRllNd2dady9ERS9NUTlEbExu?=
 =?gb2312?B?Y3dxYWxzMVhiQ3laNzFUdUNIR09GZ3lvanpYOVZBdEoxOUdYWmZZOWdCNTBi?=
 =?gb2312?Q?0RPUAF7XxWsPdqZQ=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c89e22f-7fa6-4d37-a201-08deb183c488
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2026 06:41:02.8799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rr/vpR1WfglzaDVNrst96bsbeMDFMQgpYObi8B3IAfPLsjggYL/pYQBVwG/69PNYKhhBI5ioWSBl7AJ0azslY41VlwKHicqIloPYQo3CP/6ydkWDFzIEUlUJJabkUkAM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1014

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogQ29ub3IgRG9vbGV5IDxjb25vckBr
ZXJuZWwub3JnPg0KPiC3osvNyrG85DogMjAyNsTqNdTCMTPI1SAzOjM2DQo+IMrVvP7IyzogTGlh
bmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gs63LzTog
T2xpdmlhIE1hY2thbGwgPG9saXZpYUBzZWxlbmljLmNvbT47IEhlcmJlcnQgWHUNCj4gPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+OyBL
cnp5c3p0b2YNCj4gS296bG93c2tpIDxrcnprK2R0QGtlcm5lbC5vcmc+OyBDb25vciBEb29sZXkg
PGNvbm9yK2R0QGtlcm5lbC5vcmc+OyBQaGlsaXBwDQo+IFphYmVsIDxwLnphYmVsQHBlbmd1dHJv
bml4LmRlPjsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g1vfM4jogUmU6IFtQ
QVRDSCB2MSAxLzJdIGR0LWJpbmRpbmdzOiBBZGQgYmluZGluZ3MgZm9yIFN0YXJGaXZlIEpIQjEw
MCBTb0MgdHJuZw0KPiBjb250cm9sbGVyLg0KPiANCj4gT24gVHVlLCBNYXkgMTIsIDIwMjYgYXQg
MDY6MTU6MDdQTSArMDEwMCwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiA+IE9uIFR1ZSwgTWF5IDEy
LCAyMDI2IGF0IDAyOjI0OjAzUE0gKzA4MDAsIGxpYW5mZW5nLm91eWFuZyB3cm90ZToNCj4gPiA+
IEZyb206IExpYW5mZW5nIE91eWFuZyA8bGlhbmZlbmcub3V5YW5nQHN0YXJmaXZldGVjaC5jb20+
DQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5v
dXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvc3RhcmZpdmUsamg3MTEwLXRybmcueWFtbCB8IDINCj4g
PiA+ICstDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdA0KPiA+ID4gYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3Mvcm5nL3N0YXJmaXZlLGpoNzExMC10cm5nLnlhbWwNCj4gPiA+IGIvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3JuZy9zdGFyZml2ZSxqaDcxMTAtdHJuZy55
YW1sDQo+ID4gPiBpbmRleCA0NjM5MjQ3ZTllNTEuLjExMzQ2ZDc3YjJmNiAxMDA2NDQNCj4gPiA+
IC0tLQ0KPiA+ID4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mvcm5nL3N0YXJm
aXZlLGpoNzExMC10cm5nLnlhbWwNCj4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9ybmcvc3RhcmZpdmUsamg3MTEwLXRybmcueWFtDQo+ID4gPiArKysgbA0KPiA+
ID4gQEAgLTEzLDggKzEzLDggQEAgcHJvcGVydGllczoNCj4gPiA+ICAgIGNvbXBhdGlibGU6DQo+
ID4gPiAgICAgIG9uZU9mOg0KPiA+ID4gICAgICAgIC0gaXRlbXM6DQo+ID4gPiAtICAgICAgICAg
IC0gY29uc3Q6IHN0YXJmaXZlLGpoODEwMC10cm5nDQo+ID4gPiAgICAgICAgICAgIC0gY29uc3Q6
IHN0YXJmaXZlLGpoNzExMC10cm5nDQo+ID4gPiArICAgICAgICAgIC0gY29uc3Q6IHN0YXJmaXZl
LGpoYjEwMC10cm5nDQo+ID4NCj4gPiBZb3UgbmVlZCB0byBhZGQgYSBjb21taXQgbWVzc2FnZSBo
ZXJlIGV4cGxhaW5pbmcgd2h5IHJlbW92aW5nIHRoZQ0KPiA+IGpoODEwMCBpcyBva2F5Lg0KPiA+
IHB3LWJvdDogY2hhbmdlcy1yZXF1ZXN0ZWQNCg0KT2theSwgSmg4MTAwIHdpbGwgbm8gbG9uZ2Vy
IGJlIHN1cHBvcnRlZCwgc28gaXQgd2lsbCBiZSByZW1vdmVkIGZyb20gdGhlIGRyaXZlci4gSW4g
dGhlIG5leHQgdmVyc2lvbiwgSSB3aWxsIGFkZCB0aGVzZSBkZXNjcmlwdGlvbnMgdG8gdGhlIGNv
bW1pdCBtZXNzYWdlDQoNCj4gDQo+IEFkZGl0aW9uYWxseSwgZ2l2ZW4gdGhlIGRyaXZlciBjaGFu
Z2VzLCBpdCBsb29rcyBsaWtlIHVzaW5nIGEgamg3MTEwIGZhbGxiYWNrIGlzDQo+IGludmFsaWQg
YW55d2F5Lg0KDQpUaGFuayB5b3UgZm9yIHlvdXIgY29ycmVjdGlvbi4gVGhlIG5leHQgdmVyc2lv
biB3aWxsIGJlIHJldmlzZWQgYXMgZm9sbG93cw0KICBjb21wYXRpYmxlOg0KICAgIGVudW06DQog
ICAgICAtIHN0YXJmaXZlLGpoNzExMC10cm5nDQogICAgICAtIHN0YXJmaXZlLGpoYjEwMC10cm5n
DQoNCj4gDQo+ID4NCj4gPiA+ICAgICAgICAtIGNvbnN0OiBzdGFyZml2ZSxqaDcxMTAtdHJuZw0K
PiA+ID4NCj4gPiA+ICAgIHJlZzoNCj4gPiA+IC0tDQo+ID4gPiAyLjQzLjANCj4gPiA+DQo+ID4g
Pg0KPiANCg0K
