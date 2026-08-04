Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2093.outbound.protection.partner.outlook.cn [139.219.146.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E74195A3;
	Tue,  4 Aug 2026 07:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785830248; cv=fail; b=bxA53JeSfdU4i2EkZ33OVmEQWvGnIFXKsazxlh7uz9l0vH4z/IcShP2HBDyxHHmO/S8uyDm97PKwWMCUpsi+qEHD0XR+ob9vfPTBN0+ziVLBH257cTRIWXFlUT4pOXzETTqw/RiK2cOztmV+KiWE7pWjao4D/i/sEgTE4yT4AHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785830248; c=relaxed/simple;
	bh=4yM4goIqE2PXhSoss69IJPvPSHlwsqRvC6pS2P2weRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sgnSS6Oc2Zp1BwI/ok5PHZ9dq/9dgHiB6X2qpvAWls10NpzLTmO4feEbnwGDkm0GQzovsX3ou2hTONs0w+EWk0R/69Blg91Sl9BabJkD2Oz+Uox2kIOrxTFvLOi87JYV2wCKKx/IUqD9Kw4upTVRADEuSW0dG03cfFo+qZ5uKtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qkg0ygK7n08KXB6vGt8OVvH+9UXGOKs9BEVnzc0Vofx2Te/BEftd10Vj12GS3xzH0g0gT8qA7u3F7EeL3V2GMl9Uu4jdnaI+gVlMKsCdGbmk4lMxG7eLDY/b//5yTIf2X+R4/zkL90ckHdUtcL47BxrHfvRikinYOdnKl8CHFPLaMqVYEDk+wmXpLAbOFg+OrcGb4RqqqjNj+XSsZWGoRTuYg5JHYszV6bjIUaWXT9o9ezONS7DaV4izTqCaZTnbpL3WJesRsQn0K3eU/V8iiyKuqBpo9EVWPuHI4loYz/CRuHLY5Vc+HDfhVl3zMzz5EgbGGlTPh1kagh0HIf1snQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yM4goIqE2PXhSoss69IJPvPSHlwsqRvC6pS2P2weRA=;
 b=ebwBWlkCI+ykdVjbqzw5OklvFFUmQSoJlNs7wRrX5CCAbQDNsl0LH5RlYNGxiBKNvkCtiyuhuqVsE0OberSNUVlYNQIydPmGpSR1fwzLxsmeP9aeRJLtuyMvASfNxlc0/1BgEAb/qjcqyZG2Rvj6A8+dbqDu2fjOjpdYbjT41kjEsgrzF2ZJEHJ/c3Z7gWt3Sl3003+kHkZ1syUfDyO8hu7NHW3ZCRtqfsWCJ5FB5228OQaki5DVW3FZ2QnIixN5BXu1HlLN+eiP2e/4jHAMGr093u1wGAORW1E41rjGvsGXT4NQHhjMbsc6hDuUH/yCv1sAeAGBt21Dc1kQlANcgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1173.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Tue, 4 Aug
 2026 07:41:55 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 07:41:55 +0000
From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject:
 =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggdjYgMi8yXSBod3JuZzogc3RhcmZpdmU6IHJld29y?=
 =?utf-8?Q?k_clk/reset_teardown_order_for_JHB100?=
Thread-Topic: [PATCH v6 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Thread-Index: AQHdGnguUcDbbpJ+JUaY5OYwkcSlA7aFsUMAgAfgTDA=
Date: Tue, 4 Aug 2026 07:41:55 +0000
Message-ID:
 <ZQ0PR01MB126968B53B0EEA13786725E182D42@ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn>
References: <20260723075206.3032-1-lianfeng.ouyang@starfivetech.com>
 <20260723075206.3032-3-lianfeng.ouyang@starfivetech.com>
 <amr55gfWKtJESwo9@gondor.apana.org.au>
In-Reply-To: <amr55gfWKtJESwo9@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1173:EE_
x-ms-office365-filtering-correlation-id: 4e3af359-6cb6-4176-7d26-08def1fbdb9e
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|56012099006|10067099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 onmPhrbXyUzKC0xIPraHq4pxfslcEidpqCMcI/4ejkW1xg3KMiJMz/H/bosYMkWZBaHvqBM8LGh2ZNWoG3U5R5eUOZiNxBGzJzeo2p1zx2dSYgmbL1LCaCoohM+QW8vssPDzwz70/ThIgH0blGBTMQO0YoS+SqrwWQWGshcwMJnMPAHlfDeDCe0MHh+INLjSuyrOraBvNl0qQNvQyUFs1ivBkrghHJz1FStTRqH0FJcvC1B8aoiLyaMGVaXr5cFWP80HiMr/l8sqCRbX35TEmBRYMKCqyVJXjOFZNP0v3JDy674kYEQbO+QCJj8kGUyrSnU0zFQHsIopxEmLnxYVOWKZ8N6W/YaYkwYmkCWE6EcJ/kKCz+NRzXBjzQQZ24Jv+Bv2/oG+ttp/QB3aaOlkZuqag1oo7MPsfG6ZZbzOjD7idRXXFXnCdTHXP6VspwaX7pzQVcYNaBiFnHRZjZak4vPCJVNAXCNlb41wS5NWtHn0t3HMDH/NrcWas04YfmTZBBsqq0D6HO71kKpRrOeQw1RDCwx19+Ytl9xd7xBGQc+Z2DqPYVKSU8/CQd90QV0F
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WXJNOGFuYms2NDA1ZnljZ1BCbEJQR3N2cjAvZytGNHlJZGhIU29XSjMyUW5E?=
 =?utf-8?B?eDFDWHp4Zm5LUHEyOCtRc0NESXNxK0RKZ0QrYXR3QlhnZWhxUkw4ekcxcFpB?=
 =?utf-8?B?VkZwdVJYRkN5TmRhMkV5U0V0RHg3Y08xODZJeGVIR3pEVDhmMnJXUENXWU4y?=
 =?utf-8?B?ZlYzYlkybDVZclVxdERzTDM0aHdFbzFHaEQ1RnlaNVNHWFVCSDl3dDZsclJP?=
 =?utf-8?B?clJ4WjdtK3lvWGRCaWMrd09DVnpMSlhhWEZ0ZjltOVVFcGVNSzVLUEZRM1Zm?=
 =?utf-8?B?eGg1ZStFdFRwTXZRUllKKytvMmhDV21TSUtIWDVQZG0xcFMzdzM0eVpxUU53?=
 =?utf-8?B?N1g5b1FKeTR2K2ZydVFDWFNhTmpaK283MWFnSFB3RU44YjdwV2RFVmRGSW9H?=
 =?utf-8?B?SElXTjB4TXNGcno3NTlnVXpBRFl2eEhtczNEeEFjYTRHNlZZaDNIRitQN0s2?=
 =?utf-8?B?Rlo2T3oyY2hUVW5hZmprQXNTRUdiTjZMS2Y2NmFUNW5RSXU3KzYvd1RhTGRi?=
 =?utf-8?B?a0dsZlVKa2hwc0JmdTFlNjZuZUxYc1lvWWxvendnQjVTZ0JvRExHQUhjMDRy?=
 =?utf-8?B?RUw1R3cxSHVMMllWMGw3ZlhmQUhOcE1YdUY3S1kzSEFhcUo1T005YlIrMU5F?=
 =?utf-8?B?Y0RianhyZXZJQWxONVJaNCt1N3pSK25TYTJ0MmdTVG9XazZ5U284SEFyKzl5?=
 =?utf-8?B?aFhvT2xOU29UNVpBcm9xU3VubmlHeWJEM2lObjZKZTlpbHVCRWNKU0htNHUz?=
 =?utf-8?B?VXl3d2xTSkJtdjdVamlkbC9sekZscUlINGtaWE5lUmdNY1M5dmtoMVIrL2Na?=
 =?utf-8?B?SjdhS29hTnUrQXEvdkJyTGtRZm9naFZqSUFLSWdBMjNBbGdjQ2p0WjVDbnlE?=
 =?utf-8?B?N0JBWXAvTUZBWXZxZjBpTy9ia0Y2NlkyL0xkcXgzKzVJZWZsc3VJOTZxRGZw?=
 =?utf-8?B?TVc1cm9iV295N1hHUkdNcG8wVTZ1cVB6WHJHODI0Vy9tSDd5SlZlNUQrRDRu?=
 =?utf-8?B?WG8yaXlUT3dteHRCVUVPQUwxWDhWUys4UHNQRUJYdXNudS9ObWlsL1NyRDJX?=
 =?utf-8?B?Zldadk1qTFZtaE1DdTFjaEZSNlg3N0dtc2J4RVdHWkxLN0VRL09wZENQcnFD?=
 =?utf-8?B?emdzSmRmTk5iSEtwQWl1SURLOUVtYVNFS0xvL3ppNWRJRWtEc0hTb1RtdGhm?=
 =?utf-8?B?Mkp6YkNudlpoT1krc2E0NHhWMDNnaElHYmlveFFpVnMwT2ltZ1crT0hmY2tY?=
 =?utf-8?B?WFg1dFRTb2xNVklpUjErZmR6Y29ac1E2TGlBSDRnTzFYbnVGVTlGNU1JdHVa?=
 =?utf-8?B?QnNvZ2pGcWpsVnNMSTZsZFdBTlJFTzZORUkzU2ZvSU1jbUFEZHUzMlpGTEJF?=
 =?utf-8?B?bGVlS3R4K210VExDa2NPSlhackVwRDViZ2F2dkdzLzZjcDR6OWwrNHMxQTlD?=
 =?utf-8?B?MVY4SzlHMmxXZ1c1a1VlUFFIYXlEalBoU0tBbEFzOStNNzFqQTN2bVZpQjVU?=
 =?utf-8?B?TFoxMmNoSUZNNmE0WlBudTMxNlhUeVRCdTRoTHpYVVVzY1dEbkJRRGlpUkw5?=
 =?utf-8?B?VVZudFkzTzF0N1FFL1Z6WkZvWnVIUEZBYmRLdnZtZGw1VW96NFlvSmRGTXFC?=
 =?utf-8?B?TFY2TGkveHlGaERpOVNYa3JFQWI1SmxKc05yNzVBYW5kVzBBVGMwanBlMzdF?=
 =?utf-8?B?VTFDTEI2SzFqRTZqb2xNeVBFQnQrVExISHFIcDQ1RlRtRE15S0lrcmVxMXZ5?=
 =?utf-8?B?b1hINzJQQWY3MHVOeGxYdFhzOFlxWWFsYVcrdVVKMjA4VmlXSUl2OTh0WjZM?=
 =?utf-8?B?VVlSZkwra2k0ODJFUENMay96ZzVnNWN4ZWtEQ0UwWnBGRGZJNGVyMWJSdDZ1?=
 =?utf-8?B?RDdsaFh3Sk54YXlxWHZ0QnV3OXFnOTVxaTBMUnBpVWtFYU1JSzNGSFBYRk5H?=
 =?utf-8?B?UFVSQitQV1pmaHZtamk5L2Zhc3BUaklDY1lYNXBWdk94OVppUHMzVThzeWVZ?=
 =?utf-8?B?WUhPa1pVRk9YaUJnMGh1OE1CcmJXb1pVMlN0dHdVMXJWQTRHWm9ud3I0b0ll?=
 =?utf-8?B?bHdDZFVmak5BR3BJVndkWjFXY0ZmTm1MbjhlWlFrL05FeWxSdGNldlp4d0hH?=
 =?utf-8?B?Tlg1TFRzRTl3UUJvTDJhOVlrRUMrV01hNXB6YmZ3TjJXZ05qdWJ3SGliZ2N1?=
 =?utf-8?B?M1lYaVV1RUdMWlNrVExSNmNPYTQ0S1oxRDUxelRrOHNqczR4N21NSUs3ZTFU?=
 =?utf-8?B?d3FUNjk4VmNZaXl6NHJscTc4NEg3WmJ1U3JtY1JOY0xpZFF5a1VMS3FMNC9J?=
 =?utf-8?B?SjNxMmtMcm1pUEtaR2JlaWxPWWxEeDJEQzd6RFh0dXhXSSt0a3IvNjBkK3dS?=
 =?utf-8?Q?T9XvtGyrFY3G/dqU=3D?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3af359-6cb6-4176-7d26-08def1fbdb9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2026 07:41:55.6692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bKQXtEbhBf0/SIsw/FKBM5oMYKMffJXyDkU8Xx2KbkjgqDg5AbgblAQltJs4bRegA1UcO42FHQs7XWszCOOP5pr7kSfF1pvDnkQLusyAHGxAnA+QJysLzWc2aHtg70VF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1173

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEhlcmJlcnQgWHUgPGhl
cmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4g5Y+R6YCB5pe26Ze0OiAyMDI25bm0N+aciDMw
5pelIDE1OjE1DQo+IOaUtuS7tuS6ujogTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdA
c3RhcmZpdmV0ZWNoLmNvbT4NCj4g5oqE6YCBOiBPbGl2aWEgTWFja2FsbCA8b2xpdmlhQHNlbGVu
aWMuY29tPjsgUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz47DQo+IEtyenlzenRvZiBLb3ps
b3dza2kgPGtyemsrZHRAa2VybmVsLm9yZz47IENvbm9yIERvb2xleQ0KPiA8Y29ub3IrZHRAa2Vy
bmVsLm9yZz47IFBoaWxpcHAgWmFiZWwgPHAuemFiZWxAcGVuZ3V0cm9uaXguZGU+Ow0KPiBsaW51
eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4g
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiDkuLvpopg6IFJlOiBbUEFUQ0ggdjYgMi8y
XSBod3JuZzogc3RhcmZpdmU6IHJld29yayBjbGsvcmVzZXQgdGVhcmRvd24gb3JkZXIgZm9yDQo+
IEpIQjEwMA0KPiANCj4gT24gVGh1LCBKdWwgMjMsIDIwMjYgYXQgMDM6NTI6MDZQTSArMDgwMCwg
bGlhbmZlbmcub3V5YW5nIHdyb3RlOg0KPiA+DQo+ID4gKwlpZiAoIXdhaXQgJiYgIW11dGV4X3Ry
eWxvY2soJnRybmctPmxvY2spKQ0KPiA+ICsJCXJldHVybiAtRUFHQUlOOw0KPiA+ICsNCj4gPiAr
CW11dGV4X2xvY2soJnRybmctPmxvY2spOw0KPiANCj4gRGlkIHlvdSBhY3R1YWxseSB0ZXN0IHRo
aXM/IElmIG11dGV4X3RyeWxvY2sgc3VjY2VlZHMgd291bGRuJ3QNCj4gdGhlIHN1YnNlcXVlbnQg
bXV0ZXhfbG9jayBpbW1lZGlhdGVseSBkZWFkLWxvY2s/DQoNCnNvcnJ5LCB5b3UncmUgYWJzb2x1
dGVseSByaWdodCDigJQgdGhpcyBpcyBhIGJ1Zy4gbXV0ZXhfdHJ5bG9jaygpIGFscmVhZHkgYWNx
dWlyZXMgDQp0aGUgbG9jayBvbiBzdWNjZXNzLCBzbyB0aGUgc3Vic2VxdWVudCBtdXRleF9sb2Nr
KCkgd291bGQgc2VsZi1kZWFkbG9jayBvbiB0aGUgDQpzYW1lIGV4ZWN1dGlvbiBmbG93IChrZXJu
ZWwgbXV0ZXhlcyBhcmUgbm9uLXJlY3Vyc2l2ZSkuIFRoZSBjaGFuZ2Ugd2FzIHNtYWxsIA0KZW5v
dWdoIHRoYXQgSSBkaWRuJ3QgcnVuIGEgdGVzdCAsIGJ1dCB0aGF0J3Mgbm8gZXhjdXNlIGZvciBt
aXNzaW5nIGl0IGluIHJldmlldy4NCu+7vw0KSSB3aWxsIGZpeCBieSBtYWtpbmcgdGhlIHR3byBw
YXRocyBtdXR1YWxseSBleGNsdXNpdmU6DQppZiAoIXdhaXQpIHsNCglpZiAoIW11dGV4X3RyeWxv
Y2soJnRybmctPmxvY2spKQ0KCQlyZXR1cm4gLUVBR0FJTjsNCn0gZWxzZSB7DQoJbXV0ZXhfbG9j
aygmdHJuZy0+bG9jayk7DQp9DQoNCj4gU29tZXRoaW5nJ3Mgd3Jvbmcgd2l0aCB5b3VyIHBhdGNo
ZXMgYW5kIFNhc2hpa28gY291bGRuJ3QgYXBwbHkNCj4gdGhlbSBhdCBhbGw6DQo+IA0KPiBodHRw
czovL3Nhc2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjA3MjMwNzUyMDYuMzAzMi0xLWxpYW5mZW5n
Lm91eWFuZyU0MHN0DQo+IGFyZml2ZXRlY2guY29tDQo+IA0KPiBUaGFua3MsDQoNCkl0IHNlZW1z
IHRoYXQgdGhpcyB3ZWJzaXRlIGRpZCBub3QgcHJvdmlkZSBhIHJlYXNvbiBmb3IgZmFpbGVkIHRv
IGFwcGx5LiANCkl0IHdhcyBwb3NzaWJsZSBiZWZvcmUgdjQgdmVyc2lvbi4gSXMgdGhpcyBlcnJv
ciByZWxhdGVkIHRvIG15IGNvZGU/DQoNCj4gLS0NCj4gRW1haWw6IEhlcmJlcnQgWHUgPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gSG9tZSBQYWdlOiBodHRwOi8vZ29uZG9yLmFwYW5h
Lm9yZy5hdS9+aGVyYmVydC8NCj4gUEdQIEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUv
fmhlcmJlcnQvcHVia2V5LnR4dA0KDQpCZXN0IFJlZ2FyZHMsDQpMaWFuZmVuZyBPdXlhbmcNCg0K
