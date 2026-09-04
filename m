Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2139.outbound.protection.partner.outlook.cn [139.219.146.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E64D42F709;
	Fri,  4 Sep 2026 09:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514534; cv=fail; b=Aahppc9eSHisOrnUo6w/wuXag3gmcyn+B6I64zaX198xZCbW/j4KTB/wNMfWhkftTvhOBaEjSh2FPAxLboS5PlGAj0X2a9UE94OucAk15RG53tBxbu4POYMkKLwzON7LcpoCSKW4dENd5Ce7HO3HIHaCApl1HKM5/QDYGnMLuTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514534; c=relaxed/simple;
	bh=9vmWV71nlkiCuNFosAt6zaIyWxFaQukVguZsR1Gm9b0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ckzAovS1WXRAzZHnoPgk4uX5iva2R1H3i8TeG/4Xp8tzJfTpnZnKh8n908JO6IaqdY5Ot8SnFs/r+oORWXrndBrf+P/yhVxWSGYlN5RP8iZ4/HLFnTLowV8Cv+xSoXCu7+KP/Bf9U76ibQEo8Bdl3ioZrwitLgar6FCQtwfJaJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jaov32bi8Hy01lIa2LBZoi5DWlkRJdClTOWuydWcBqdSR21ejaVpVP6sYxjV21M75T6GMuS4LJq2/41y+9m30aEQgR8aulzNuGzyk2E7TtvOCJhAsRxA3lxge+bav5gg/jr9gJRzTIdgGIKFBlJVOnrRpVuB60NVZ8844x7r+WfG67fqxnMiIipgm9Vh9vdj2sHVwsI0q8WBChp2M1uiQGBdrk7+KZg+NA7iNb/Ck+m2IPICYgDF3xc9eIsuEGqxFYmJI6bfOuNU68/jWJjAvc+FpuFWqOI2Joorq4tnMseK3uW5Q80nqTL5qqUrO37aEmUBTneTOToSPT47c7Vphg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vmWV71nlkiCuNFosAt6zaIyWxFaQukVguZsR1Gm9b0=;
 b=LgFnigUzJFiYsGiNDoGHC7gNHrPGIj/XetY5no8ETdAoKn/rfRnrAh2Px07ukH9wK3EoqUWK0ZFm6/VuMnZcwzUG2ES7xlYMCdUaqZY/CBT2JAUzYyGZCdp1mrEpSxlovhLMjaXaawooIY6e9bunXmAxceeO++id6aaWd7q0V3PkChs9hRIkF6vvntUCOr3NBDUVqi8lqT6Y91D39iD3Ir6WoL71UkcuW2j+K2PbKXRVhgBFsz0IUSFM56yrjBWXyRNIXAP2rO7B1LJtE01DIeUWR8BsFB2ybhrg0uXgspBz4wyZH6oNWr1UHiP4D/mmhcI1n88eZBd9+Cx8/Aa/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from NT0PR01MB1277.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:e::14) by NT0PR01MB1069.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.18; Fri, 4 Sep
 2026 09:35:18 +0000
Received: from NT0PR01MB1277.CHNPR01.prod.partner.outlook.cn
 ([fe80::301e:8ee:529f:7f30]) by NT0PR01MB1277.CHNPR01.prod.partner.outlook.cn
 ([fe80::301e:8ee:529f:7f30%3]) with mapi id 15.21.0315.011; Fri, 4 Sep 2026
 09:35:18 +0000
From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject:
 =?gb2312?B?u9i4tDogW1BBVENIIHY3IDIvMl0gaHdybmc6IHN0YXJmaXZlOiByZXdvcmsg?=
 =?gb2312?Q?clk/reset_teardown_order_for_JHB100?=
Thread-Topic: [PATCH v7 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Thread-Index: AQHdKgMOy5TXywyie0mitQcbZlhZAba+SlUAgAACojA=
Date: Fri, 4 Sep 2026 09:35:18 +0000
Message-ID:
 <NT0PR01MB12773F5E2E17527283D2B0E482B52@NT0PR01MB1277.CHNPR01.prod.partner.outlook.cn>
References: <20260812023401.44149-1-lianfeng.ouyang@starfivetech.com>
 <20260812023401.44149-3-lianfeng.ouyang@starfivetech.com>
 <apqOSl1m-5ctry_T@gondor.apana.org.au>
In-Reply-To: <apqOSl1m-5ctry_T@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: NT0PR01MB1277:EE_|NT0PR01MB1069:EE_
x-ms-office365-filtering-correlation-id: e8ac8449-f1d1-49aa-0f48-08df0a67d559
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|4143699003|10067099003|56012099006|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 n0XWGvlvOFFbYYQk68HeU8bjEkA/eHtx5OQpJKroF60KLCPneAR5EGsVlqX97bIgg/aRU9HF3OFKUkNq3pXf4AQ7qf8Fz7EdbWK63hGq1oHEi+owuOr+QQA8tSLzAq/15+IEIFl6zsQA20wAelmupeNqSW1Bz4HEkAio2IKHH6dsqkdiQ0JrmeV+RW6dtm4CyCdMbitpjOrt1Y4DaSM3/Av1pCmFHoOBPPaBhFAB+RrCACE2t2rtPh/aBVyGoY+2y7ABZRk6MZb6nlxJsFwOkiBxqOlVsy7df1ocm7BY5kobhdf1xcjBNVgDdpebe4sz1XKCwvCAM5CSA0GsP6SXqb0CY7jJWGZijkTbt6uWLbfQOeDFK0ggXT7U3S2KwCyHBQqzg6GVYj6+/1WzrOgdVLsw3slRuesP4jpxGtdKB/ELsI0Arjayi3TR9AjvBfdH166wKm4csXxDgs1B7USPeaxe6o7BvBjt0llUVaGJD+HTfdHKNxRzesQrbrbknmkBiZ7Cc4mPPDVQRyEVQs6LGBq3+tYbKHTtKqvwkrFvJ2fqOd3JvfShvR3wle8P0aqO
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1277.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?NCsyc1hna1dpeCt1VUk4TFJwK2h6Z0RSR3NJOUpQTWFPbG56d1VYVEFjM3Fa?=
 =?gb2312?B?S3VMNkh1dlJJd29VdEdmMS9ld1RYOWtFZzltcFZ3aHFjL0dYLzdEVm8rSHRK?=
 =?gb2312?B?cXpmUXlQL1pHbC84Rmh0L3FvN3V2bktPSmFMOFZML1puR0xzS0xmbU5hOEtQ?=
 =?gb2312?B?NE1zMmZFZ01IMGpyYmwrYXFQZXVLdnJRaGN5Vno1SXByMks3Y2FsVXdWcndX?=
 =?gb2312?B?WFQ0OWUwWjJoRmNLa2Z2WGJHMkF6YjlxTWhxamZHeUhBNE5HeXhBVHVFNHNK?=
 =?gb2312?B?MDZXSnpiTkVUTzVOWWhlUlZYTytLc083WTdmQ0hhZi9VWkp0R0hGd1I1TlZO?=
 =?gb2312?B?MUVEM3lYM20vVkVGV2FGTkxwTW1pbWZKcGh1a2JrQWtEMjkyME1CSU04aGhR?=
 =?gb2312?B?ZExCbGtKYjFCSHBFTFhNN2tESXJtTU1hTGQwOWprbkhwRldmZmlmY05FdU04?=
 =?gb2312?B?Z3pQOWtYenBTTmVFNHdXVE5PY1F4YmtpRTBCMXJTUUs1OXJBUFFoZmxyb05T?=
 =?gb2312?B?Z2lVYVpHakNNYXhrd0Q4cCtYTGVMZjlOeFgyTmtSeFBzbk5yNCtKcVRrNzRl?=
 =?gb2312?B?NHlURUtUY1UwQkNpUm9vL1Ezb05PcFEyczZLRCs2eWdZY3FJdmt4MitXR3ZJ?=
 =?gb2312?B?MzJrMHJVOUtscy9oV1NSSDhnVE5TQVQ5UjliM0xFeTB4azBQNEFRdDQwUnk5?=
 =?gb2312?B?eTFvVk05ajBDUzlzc2lJcGxKWUhNeEtrcjJER1pIRjFZQi9ubE50UmRKeHV3?=
 =?gb2312?B?U1FJU0RZeXBCSUU5NmM1M3hGZ1RGQlVHVWF4b2x2bkxFUURmdThqQ2ZlSG5x?=
 =?gb2312?B?R2U2QlFpSHczSUdEK1hWQVoxN25ZeHhheGhtZURLM1p1bDMwZ1dsb1FnTDVQ?=
 =?gb2312?B?VUNoQW4xNGdXVU02NTk1eTdMR1Y1c2E4V2xhMGtQTFBzTTAycXpFNHJGQ1VM?=
 =?gb2312?B?TlVjNVVLYm01MEhPRy93UUdXOThIakovc1F2ZDM0dlcrQWtWR0YwU2dNNGdL?=
 =?gb2312?B?aEtMNjNGVW5wcU40UlVMbTE1cUFGVnlRRTJWLyt5b3lJMk1VbmhtZ2pKMlZY?=
 =?gb2312?B?Sk1POENOQVdSd2xBd3pxcDJOK29zYS9HZUFkMFdLckdiUE9wdG84N2hzRS9a?=
 =?gb2312?B?QUhEUi95bVJVWlpsdHRibjRzSVB4QkFTYUswYjdiblFwZkpidnpoMjYwMDNm?=
 =?gb2312?B?bXZ1QTR1RFdSR2I1S1RqbXN6ZEwzbXIvQkxkU2JBNkxjYkRkU1N4czM5RCtu?=
 =?gb2312?B?K2tCWDFIbEx2UUh2RjNpZGdlQTZtcnFZbFozMk1UeHM5N3VzOGRzeXhONW9k?=
 =?gb2312?B?Myt4Y3E0VENkU0dZak1uVFFNY2szNndHSjZjaXFhR3FrWmxYNng4UE8ycjh6?=
 =?gb2312?B?eEV4OGgzYVp4VzYyWXEyN1hvOUd0N2grUnJXSFpVMCszdTVoenVFSkhvVXBt?=
 =?gb2312?B?N1g0WlRYcUFTY2ZLVVJqMTNXZk5paU1hYUJ6WE1adDJQNWhaY09nSkFCT1dS?=
 =?gb2312?B?MnFRNEdhZmpBUGx3QzlPUlFFRHRNa2s2UzlJTmxpS3RHUFRCRHc1QjQyTDlK?=
 =?gb2312?B?L0hrcWJMNWlJaEh5Sldya1AvVmlBTk9QQS9sRWprYlAzRFRZMnRrYm9lUjBC?=
 =?gb2312?B?QmtScEFIOXFDZEZrSHV4eDlTa0pJbVhBRGRnczlMeVlSQXRzL0preFNiNTZ4?=
 =?gb2312?B?TmxVNFlYYkIyZzg1eVNMQURxZkx0aDVFQ2p1SUlvc2ZoOEFzNTNMWWJNR1hm?=
 =?gb2312?B?RmxBajVDdS93UGZWaTNVT2JpWDJRTUZaL1lMOHZZM3BwMDl6MnFLVEdjY3lk?=
 =?gb2312?B?WXQ3NDg5Qjh3Rnp3YkYxNFpSYVhXK1JVdVo0ay9QZjJaS3Q1NVNkRUZFNUtT?=
 =?gb2312?B?Ymk1aXd2bmFkb1o4N0RLTnd3Z2d5RngvWmhRNkFydDhjdXovcEhPbmlFK1Ns?=
 =?gb2312?B?ZU9IYWgxc0ZoUnlaY25vYnZzd3V4Uk5TdXhWZjlROGZHRElKVFE0c1lEOStG?=
 =?gb2312?B?TnNqQW1sTHVDbmphbnJYTHdBZzRKVmdlS0NkQmxPRS83dHlRd0MrZXhQSVc4?=
 =?gb2312?B?YkY0VWJSNHJNdXI5T2tLQWdyM2RJUnlVQ2xmMzVldUZhMnFRbkJ1eHlCQ1ZH?=
 =?gb2312?B?RElBVjdsK1JUdlBJdlp2QVZBbTlpWkl1b3BEYnFKcFFzajlxbVJGYjE4a1lL?=
 =?gb2312?B?MjJyQWlFekJlbzcya0pSaFBHdnBPZUlINU83Zm90UEkrYm5QNk9Kd003NXhw?=
 =?gb2312?B?eU9ncG42N25xSnRoQlpHQnJhZ1REZHhaY0hpOXZ5RVpwd1dvczRVYVJNalhQ?=
 =?gb2312?B?YzM2WkVCYXFUTC85c0ptd1I3SEpyL21vMnJiQ0pZM05kRXgralNJOUFzb1lp?=
 =?gb2312?Q?nUqaqega5WONZ3NM=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1277.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ac8449-f1d1-49aa-0f48-08df0a67d559
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 09:35:18.7114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WRHPWryM81hJvmibkXEznfZ3s8NshoOsAqaRmL5PleKqEfYryCIpweG37uoXrFgr5kCpQuSUbFjTmElSv9aM04YYc9ba3qd8BjZJSZkMFJ5ayd/6g43kRYlwI4Rt7B3m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1069

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSGVyYmVydCBYdSA8aGVyYmVydEBn
b25kb3IuYXBhbmEub3JnLmF1Pg0KPiC3osvNyrG85DogMjAyNsTqOdTCNMjVIDE3OjI0DQo+IMrV
vP7IyzogTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4N
Cj4gs63LzTogT2xpdmlhIE1hY2thbGwgPG9saXZpYUBzZWxlbmljLmNvbT47IFJvYiBIZXJyaW5n
IDxyb2JoQGtlcm5lbC5vcmc+Ow0KPiBLcnp5c3p0b2YgS296bG93c2tpIDxrcnprK2R0QGtlcm5l
bC5vcmc+OyBDb25vciBEb29sZXkNCj4gPGNvbm9yK2R0QGtlcm5lbC5vcmc+OyBQaGlsaXBwIFph
YmVsIDxwLnphYmVsQHBlbmd1dHJvbml4LmRlPjsNCj4gbGludXgtY3J5cHRvQHZnZXIua2VybmVs
Lm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNCj4g1vfM4jogUmU6IFtQQVRDSCB2NyAyLzJdIGh3cm5nOiBzdGFyZml2ZTogcmV3
b3JrIGNsay9yZXNldCB0ZWFyZG93biBvcmRlciBmb3INCj4gSkhCMTAwDQo+IA0KPiBPbiBXZWQs
IEF1ZyAxMiwgMjAyNiBhdCAxMDozNDowMUFNICswODAwLCBsaWFuZmVuZy5vdXlhbmcgd3JvdGU6
DQo+ID4gRnJvbTogTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNo
LmNvbT4NCj4gPg0KPiA+IFJld29yayB0aGUgU3RhckZpdmUgVFJORyBkcml2ZXIgdG8gYWRkcmVz
cyBoYXJkd2FyZS1zcGVjaWZpYyByZXF1aXJlbWVudHMNCj4gPiAgIGZvciBKSEIxMDAgU29DLiBU
byBhdm9pZCByZXNldC1kb21haW4gY3Jvc3NpbmcgZ2xpdGNoZXMsIHRoZSBkcml2ZXIgbm93DQo+
ID4gICBlbnN1cmVzIGNsb2NrcyBhcmUgZ2F0ZWQgYmVmb3JlIGFzc2VydGluZyByZXNldCBkdXJp
bmcgdGVhcmRvd24gZm9yDQo+ID4gICBKSEIxMDAsIHdoaWxlIEpINzExMCByZXRhaW5zIHRoZSBv
cmlnaW5hbCByZXNldC1maXJzdCBzZXF1ZW5jZS4NCj4gPg0KPiA+IEFkZCBwZXItY29tcGF0aWJs
ZSBtYXRjaCBkYXRhIChzdHJ1Y3Qgc3RhcmZpdmVfdHJuZ19kYXRhKSBkZXNjcmliaW5nIHRoZQ0K
PiA+ICAgY2xvY2svcmVzZXQgdGVhcmRvd24gb3JkZXIsIGEgbmV3ICJzdGFyZml2ZSxqaGIxMDAt
dHJuZyIgY29tcGF0aWJsZSwgYW5kDQo+ID4gICBzZWxlY3QgdGhlIG9yZGVyaW5nIGZyb20gaXQu
DQo+ID4NCj4gPiBGaXggdGhlIHJ1bnRpbWUtUE0gZ2V0L3B1dCBiYWxhbmNpbmcgYWNyb3NzIHRo
ZSBpbml0L3JlYWQvcmVzZWVkL2NsZWFudXANCj4gPiAgIHBhdGhzLCBtYW5hZ2UgUE0gYW5kIHRo
ZSBjbGsvcmVzZXQgdGVhcmRvd24gdmlhIGRldm0gc28gYWxsIGVycm9yIHBhdGhzDQo+ID4gICB1
bndpbmQgY29ycmVjdGx5LCBydW4gdGhlIFNFVS10cmlnZ2VyZWQgcmVzZWVkIGZyb20gYSB3b3Jr
cXVldWUgaW5zdGVhZA0KPiA+ICAgb2YgaGFyZCBJUlEsIGFuZCBzZXJpYWxpc2UgdGhlIGNvbW1h
bmQgc2VxdWVuY2VzIHdpdGggYSBtdXRleC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpYW5m
ZW5nIE91eWFuZyA8bGlhbmZlbmcub3V5YW5nQHN0YXJmaXZldGVjaC5jb20+DQo+ID4gLS0tDQo+
ID4gIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQ0KPiA+ICBk
cml2ZXJzL2NoYXIvaHdfcmFuZG9tL2poNzExMC10cm5nLmMgfCAyOTUNCj4gKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMjM5IGluc2VydGlvbnMoKyks
IDU4IGRlbGV0aW9ucygtKQ0KPiANCj4gU2FzaGlrbyB3YXNuJ3QgYWJsZSB0byBhcHBseSB5b3Vy
IHBhdGNoZXMuICBQbGVhc2UgdHJ5IHJlYmFzaW5nDQo+IGFuZCByZXBvc3RpbmcuDQo+IA0KPiBo
dHRwczovL3Nhc2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjA4MTIwMjM0MDEuNDQxNDktMS1saWFu
ZmVuZy5vdXlhbmclNDBzDQo+IHRhcmZpdmV0ZWNoLmNvbQ0KPiANCj4gVGhhbmtzLA0KDQpUaGFu
a3MgZm9yIHRoZSBmZWVkYmFjay4gSSB3aWxsIHJlYmFzZSBteSBwYXRjaGVzIGFnYWluc3QgdGhl
IGxhdGVzdCB0cmVlIGFuZCByZXBvc3QgdGhlbS4NCg0KQmVzdCBSZWdhcmRzLA0KTGlhbmZlbmcg
T3V5YW5nDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5v
cmcuYXU+DQo+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQv
DQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0L3B1YmtleS50
eHQNCg==
