Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2052.outbound.protection.outlook.com [40.107.241.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3844C8BFA
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jan 2024 06:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DxgG6Z3s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PA8Unz1Sz42p+fQHXZz2VGLMA9UJEy5k8rV1GsHKTjt4Vn26Ll7oRng662SJFFw4Qy3XM1Ya28fqPZooVZ7byWrE3jCmrgq9leVoiz7FKEsFhCCLHkBK8aMth6M/buWHOfQrBboarRzN9sFlKMnF22yl9aazQvhNiwwT5MOPa8gBkpHlZh/0gEZb1Gbo4sSkrR17e45OpqRGXIYr0ejAprHCagDXl0zhGiNZ0YONQmMGbd9UvfOcOk+0dseft3qTQ7WUpiAaHfifzv/OkkBT9Nhy/fMft7wUaovzkcTnid4qrj7d/hjJjWPVRdoIrFAYLQgwugIZnHt57ZtYLhv1JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ulu35AjD8XL13qQuvBkrDzQ+GRkQubfytZXUaZPlkM=;
 b=idRpbrBeZKphFDz9HMA54Hgp3aTlZdOgDJejUp8jWGhSFHkZb6fTTOoXI0jnuhKMIkp8CUyE3hdJe9KDPSFtQaGyeByujl9wbyYuYknncBC0W4rnrEv9hAQvgbooXtQiRv5NmAhjDWyqOAOCvNxNaj535T83580bQbORfsJOFr5I00/uN9v2t80Zv8oAHgJtvM50A9vXbpikEgBh4bfThR05VEt3N+Fcd0CZOzle+eDEPiNHa+Pr2r/Q9FJ0aX1XcG0LpkKsMVUXAq5pWKNVuznnxIvAVz5IpxP4J36sUCfzslw37s3eprNyGqqOu/1/YFmCO0MZTcH3W6WKKncLDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ulu35AjD8XL13qQuvBkrDzQ+GRkQubfytZXUaZPlkM=;
 b=DxgG6Z3sOWccD2kB6njRRpVHJynKayBWd8+29LPbW1iobY30pxqFj/ie/R8Ce/HFI4X0Pqw7PggGiWlEQv79/11i4d9rWyBqn/QL3h8pI5OlyQKXA/nTM68RRSP6tXPMWpgHlJI4d7VHSHJ97gOlElacviP4qIZdd3R9sFcX44c=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AS8PR04MB8993.eurprd04.prod.outlook.com (2603:10a6:20b:42c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.21; Mon, 8 Jan
 2024 06:51:59 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::f62e:ed0f:3b06:a7d8]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::f62e:ed0f:3b06:a7d8%7]) with mapi id 15.20.7159.020; Mon, 8 Jan 2024
 06:51:59 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Ondrej Mosnacek <omosnace@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Linux Crypto
 Mailing List <linux-crypto@vger.kernel.org>, Varun Sethi <V.Sethi@nxp.com>
Subject: RE: [EXT] caam test failures with libkcapi
Thread-Topic: [EXT] caam test failures with libkcapi
Thread-Index: AQHaNIUs5x+vRqPNKUaISMpgxN6Xu7C1H2qwgAHHygCAESHn8IABYFoAgAYoQXA=
Date: Mon, 8 Jan 2024 06:51:59 +0000
Message-ID:
 <AM0PR04MB6004695966A6CB52A29B065BE76B2@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <ZYT/beBEO7dAlVO2@gondor.apana.org.au>
 <AM0PR04MB6004FDAC2B2C0B4D41A92A89E794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <CAFqZXNtb1hErawH30dN4vgGPD0tQv9Rd+9s26MBaT3boRYtPCA@mail.gmail.com>
 <AM0PR04MB6004F095D6800C4BC99E5C4FE760A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <CAFqZXNs-QzXFm+cLN62LrpPjb_R3DqJHgM_yjrOkzen8LEgS9A@mail.gmail.com>
In-Reply-To:
 <CAFqZXNs-QzXFm+cLN62LrpPjb_R3DqJHgM_yjrOkzen8LEgS9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AS8PR04MB8993:EE_
x-ms-office365-filtering-correlation-id: 5fa606f7-24ed-4f83-1a4c-08dc10164faa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 F6ABLOy1frJdPgTqXtKa8VjyTlFmAsMQ0yAwVG7CblDtpgb4MNloUJIR56e37r+1dlfAO20B5e+ZLU4vcjH6UPhCA7fhRRd4buHJEGi0ZDQ9HWsQBJnTj+a1oLBzxgrM9EWyZ5R6YB7NhBmIJD2FF+uqx7Sz4VY037qGLeqh12N1jOuUFlBEB5P8tyqBjQtroEU1gJig7oirw0oz53LZwpBZrCA257AItyJilUxAY3ol4kBKPKAFeyoB30ISp2kWQEoRUts9aPjcpifSRFitytv5v5bRUhenAxJh12yi/aKZiLOPFdHayLGlPZTTZYJZZIgixIcOaBBphXGS6PxQOEbgnjcWnamvAwwHik9gAAmUvastnUZGH28jWbTlAgdz39eHqEa9IcZ1HbRJ7A5RE78Ehcow/soeQQ1z3+AV1rXkSRrcav8LA16FM2F021AtBE/mUnwkHpvigMLBfD0K5z+n26CLJUPmAtUDZzcgGEMHiw+6QXIsDrsNP6owq8ntQm5/m5zHYE3E4RmNI+WRKddpLwAs2xpliJkOGGBzGnIE+VkDX/pWkG3BqZYl0WXB6EKxxyq2/keygYhzM2bxXAyJCSBb2SLGC36+iLInhdKmJqMqxxRpyd8pxhm0UtwLsW5DuQqCzaA+0KvBW9ytQ04du1TFzdwoAU1f//ny2b4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(186009)(451199024)(1800799012)(64100799003)(316002)(54906003)(8936002)(45080400002)(8676002)(71200400001)(7696005)(6506007)(83380400001)(52536014)(44832011)(4326008)(33656002)(53546011)(66556008)(66946007)(76116006)(55016003)(9686003)(478600001)(966005)(6916009)(64756008)(26005)(66476007)(66446008)(122000001)(38100700002)(2906002)(5660300002)(38070700009)(41300700001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UElpWFlJRXEvUUFCWHdWaENiUzVxVUgrUGZVaHZxdkNrMlk5VVkvVmo3aDk2?=
 =?utf-8?B?b2tEWXB3T1gxNUdvcE91b2dERFNucmxCOVdoSVpnZFBOdDBqOEQ3TTZYeTBN?=
 =?utf-8?B?WDRGUHJCVGJWQVhLWDFNWUZ4eVhpdEdJZXp5U3JLRTkwRkxFQmd3TmdaNFhy?=
 =?utf-8?B?NS9rYmc2cTNhZktla2Nla24vUllWaE82U2hmZ1B0Vk1ZcHkxWWNlQWNCbUVM?=
 =?utf-8?B?M0pvWGJkM2t2dmlQUlZ6NE1jSDBmS2dydlZCRXJzWFczazg3dDE4SXJLQkFj?=
 =?utf-8?B?OVVwTTBucXE3bW1nNkNqQyt3REtPdkFlMHJlMWJ4ZlEzK3NOTTJUNzdtaUFD?=
 =?utf-8?B?MlFQbVNCb1BQSjc3bnJPYXM4QWZpUmRKVmxCcEg3TVFvY05tL3BXMXBWSFpi?=
 =?utf-8?B?dXhiT3ZvRGRYTlp0SGQvRnpOYVpvTFI0UmJ2Nk8vTjJBV1B2eXZEcko4RGRH?=
 =?utf-8?B?ME9WWFRJSC9hVWoxUEU0UmowbnNVSzJuU1JMUGxuRkZaRjNJQ2ZqZGxtQS9z?=
 =?utf-8?B?bUxHMmo0MDV1Sk81VE54OE9UWjZhd3lPSHk4ellianMrZ3A5aFVIRk1NZ0kr?=
 =?utf-8?B?ZjV4U3ZBRWRWd3ZDejcyajlIY09Nazd4aTdQMmNBVHV0MHNka0syWHZMaERB?=
 =?utf-8?B?Q0Q5Q0dCdFJHdVhmNnJrM09CS3JzL1VSQTZVS09hUDc0S2Z3Z21DQWFuVi9r?=
 =?utf-8?B?eXh6NDVrYjB4THBQNDJTbm9SUDBvNVhvZ2FpTURyNit1aC9qNFhsRUw4c1dO?=
 =?utf-8?B?MUU1c2Nxa0x5eTFESXFGYmdNVE56WVJ3SVVrYmpqbGhJdUpBRTViY1ovQzlB?=
 =?utf-8?B?ZWdFc1JKWEhaWmdTdEcwRzFONms3ZjFXTTRCKzh1a3lXeTRSc3ZzaDZVcWFE?=
 =?utf-8?B?bk9GSHl0QUcxNDVVOU9GaGl5ZDMycnJkUHFNOVlVY3M5K3kwS3dYK3BTallG?=
 =?utf-8?B?bWJrUVpxaVN1K3BTWWZPcmk2bHo3SGYyZXhocG1rVktwWVZmTmxZWXZhT1A2?=
 =?utf-8?B?WnpScDBpLzZMYnVUK3pobzdReTJNQ25NQ0ExNk1vSGlDSmdQRkRuOVU3Snl6?=
 =?utf-8?B?YllzbFZENnN1SStxYlBQVnhZMlFjM1RKbW9WcmRxNkpvbnBXTHMrUllkWHJW?=
 =?utf-8?B?eDFNdmcvWDAyK2ZOR0pweEZtQ2dOb2FhSmNsVWdmNGVtOU9oMVUrUnRFWUM1?=
 =?utf-8?B?U2cwZVcxZTVlUXVQK3NpNHBxZVBkc3Vlclh5SHVTQ1FCbkdyNEtZR3lYSVpE?=
 =?utf-8?B?OWNkVWczeUpwSkU2cmRFT3JvNUx3dnpyWWhXQmM3NHExc3hFSVIyZ3VrVVkw?=
 =?utf-8?B?K2g3S2FuL1BXNWZsSVdpMC9mOVdrTktiNjRPVXk5ZFpCZUpJaU5jVWtpSmhL?=
 =?utf-8?B?ckNpYU1la2hBYUlaYUpYQitaL24yL1RuTWVLc1Zpakc0SXorVVpqY1F0VXpU?=
 =?utf-8?B?YTZBcStlakt4U2ZHOTkvYzU3bUxWenZFVTd4MGdxN3ZSaUFCWk5WbnlPZ1dQ?=
 =?utf-8?B?cTNyM242RVpQdDBtbzFYaHFMcnJpRWNiRHJ2R0czYWVObkRMeTdETW1rOGVu?=
 =?utf-8?B?RW1lK2FpbkdIcEJvNlNQOVZwSHY4dzlmcnd4NDZUVGdlS1FuV2kxajkweW9T?=
 =?utf-8?B?UitQTTdzN2N1aEt5VXpFZUthcW95Nks1MHJLVzJTNjBYUDJyQ2l5WUV4UU51?=
 =?utf-8?B?eW11QTFKOFVlL0MwYTRKUnJyT0tXcGkvWFNGQ3RrVndneDNiSDBOVkU2dFJP?=
 =?utf-8?B?aG1XNGNNV0IvYWgvUHlVME4xVnduRG5SVnJxUWNxQWFZM284ZDBMbVVkZWxj?=
 =?utf-8?B?VUExc0VSZVUxR24wc0FBVG5FVTE3YWpta25rMVRuaGlHZ3pMdkd0aVV3ZnNI?=
 =?utf-8?B?VHAyck1vYXNvWVQ5QVpLbEVpdXNWaFhhWlBUQ0hadkJVSnAxdk1jY3Yrczdx?=
 =?utf-8?B?bUJXekVzVFM2WHREbHhkbUZ0YVI5NFdnYXNKT3dDaG5Wc1NSOXp6ZDhFb1hQ?=
 =?utf-8?B?cWhxWFkwU1IxblFvYTVsWjduQ3lYWEVqWlk3ZkI5c0pSK3JTUXBxN0hTdXBv?=
 =?utf-8?B?QUhVc3BEbGJaU2FZVXZPZ0UwRzZOaGdLdHJCRGx4U0hUdWdIVzkzdFJ5djVU?=
 =?utf-8?Q?XlEE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa606f7-24ed-4f83-1a4c-08dc10164faa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2024 06:51:59.1420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdN85yavlsU8WoW7u9zfKoahPTRfPuRfnm9qAdj6pPOYNH5Qm/95g3d7dzHz2NWXOGWY6z/Qset6qlrBAYpppg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8993

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT25kcmVqIE1vc25hY2Vr
IDxvbW9zbmFjZUByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSmFudWFyeSA0LCAyMDI0
IDI6MDcgUE0NCj4gVG86IEdhdXJhdiBKYWluIDxnYXVyYXYuamFpbkBueHAuY29tPg0KPiBDYzog
SGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgSG9yaWEgR2VhbnRhDQo+
IDxob3JpYS5nZWFudGFAbnhwLmNvbT47IFBhbmthaiBHdXB0YSA8cGFua2FqLmd1cHRhQG54cC5j
b20+OyBMaW51eA0KPiBDcnlwdG8gTWFpbGluZyBMaXN0IDxsaW51eC1jcnlwdG9Admdlci5rZXJu
ZWwub3JnPjsgVmFydW4gU2V0aGkNCj4gPFYuU2V0aGlAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6
IFtFWFRdIGNhYW0gdGVzdCBmYWlsdXJlcyB3aXRoIGxpYmtjYXBpDQo+IA0KPiBDYXV0aW9uOiBU
aGlzIGlzIGFuIGV4dGVybmFsIGVtYWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdoZW4gY2xpY2tpbmcg
bGlua3Mgb3INCj4gb3BlbmluZyBhdHRhY2htZW50cy4gV2hlbiBpbiBkb3VidCwgcmVwb3J0IHRo
ZSBtZXNzYWdlIHVzaW5nIHRoZSAnUmVwb3J0IHRoaXMNCj4gZW1haWwnIGJ1dHRvbg0KPiANCj4g
DQo+IE9uIFdlZCwgSmFuIDMsIDIwMjQgYXQgMTI6NTDigK9QTSBHYXVyYXYgSmFpbiA8Z2F1cmF2
LmphaW5AbnhwLmNvbT4gd3JvdGU6DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogT25kcmVqIE1vc25hY2VrIDxvbW9zbmFjZUByZWRo
YXQuY29tPg0KPiA+ID4gU2VudDogU2F0dXJkYXksIERlY2VtYmVyIDIzLCAyMDIzIDc6MjkgUE0N
Cj4gPiA+IFRvOiBHYXVyYXYgSmFpbiA8Z2F1cmF2LmphaW5AbnhwLmNvbT4NCj4gPiA+IENjOiBI
ZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBIb3JpYSBHZWFudGENCj4g
PiA+IDxob3JpYS5nZWFudGFAbnhwLmNvbT47IFBhbmthaiBHdXB0YSA8cGFua2FqLmd1cHRhQG54
cC5jb20+OyBMaW51eA0KPiA+ID4gQ3J5cHRvIE1haWxpbmcgTGlzdCA8bGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZz4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbRVhUXSBjYWFtIHRlc3QgZmFpbHVy
ZXMgd2l0aCBsaWJrY2FwaQ0KPiA+ID4NCj4gPiA+IENhdXRpb246IFRoaXMgaXMgYW4gZXh0ZXJu
YWwgZW1haWwuIFBsZWFzZSB0YWtlIGNhcmUgd2hlbiBjbGlja2luZw0KPiA+ID4gbGlua3Mgb3Ig
b3BlbmluZyBhdHRhY2htZW50cy4gV2hlbiBpbiBkb3VidCwgcmVwb3J0IHRoZSBtZXNzYWdlDQo+
ID4gPiB1c2luZyB0aGUgJ1JlcG9ydCB0aGlzIGVtYWlsJyBidXR0b24NCj4gPiA+DQo+ID4gPg0K
PiA+ID4gT24gRnJpLCBEZWMgMjIsIDIwMjMgYXQgMTE6NTDigK9BTSBHYXVyYXYgSmFpbiA8Z2F1
cmF2LmphaW5AbnhwLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+ID4gPiA+IENhbiB5b3UgcGxlYXNl
IHNoYXJlIHRoZSBsb2dzIGZvciBsaWJrY2FwaSB0ZXN0IGZhaWx1cmVzLg0KPiA+ID4NCj4gPiA+
IEEgbG9nIGZyb20gb3VyIGtlcm5lbCBDSSB0ZXN0aW5nIGlzIGF2YWlsYWJsZSBoZXJlIChpdCBp
cyBmcm9tDQo+ID4gPiBDZW50T1MgU3RyZWFtIDksIGJ1dCBpdCBmYWlscyBpbiB0aGUgc2FtZSB3
YXkgb24gdGhlIEZlZG9yYSdzDQo+ID4gPiA2LjYuNi1iYXNlZA0KPiA+ID4ga2VybmVsKToNCj4g
PiA+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1o
dHRwcyUzQSUyRiUyRnMzDQo+ID4gPiAuYW1heiUyRiZkYXRhPTA1JTdDMDIlN0NnYXVyYXYuamFp
biU0MG54cC5jb20lN0NiMDVkYmJmOWMwZDg0OA0KPiBhZjViZWYNCj4gPiA+DQo+IDA4ZGMwZDAw
NmI1OSU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzgzOTkN
Cj4gNTQyNg0KPiA+ID4NCj4gNDgwNjk0MjYlN0NVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lq
b2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybA0KPiB1TXpJDQo+ID4gPg0KPiBpTENKQlRpSTZJazFo
YVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCU3QyU3QyU3QyZzZGF0YT15a3BGJTJCTQ0KPiAlMkJE
V2oNCj4gPiA+IHc2R0hONjE2NWtMZTdjOFdGUkpTU0xUZldkJTJGcUx4STl3JTNEJnJlc2VydmVk
PTANCj4gPiA+IG9uYXdzLmNvbSUyRmFyci1ja2ktcHJvZC10cnVzdGVkLWFydGlmYWN0cyUyRnRy
dXN0ZWQtDQo+ID4gPg0KPiBhcnRpZmFjdHMlMkYxMTA5MTgwODc0JTJGdGVzdF9hYXJjaDY0JTJG
NTc2NjQxNDcyNCUyRmFydGlmYWN0cyUyRnJ1bg0KPiA+ID4gLmQNCj4gPiA+DQo+IG9uZS4wMyUy
RmpvYi4wMSUyRnJlY2lwZXMlMkYxNTE5NDczMyUyRnRhc2tzJTJGMzElMkZsb2dzJTJGdGFza291
dC5sDQo+ID4gPg0KPiBvZyZkYXRhPTA1JTdDMDIlN0NnYXVyYXYuamFpbiU0MG54cC5jb20lN0Mz
YjUyYTgzNDQ5YmY0YjNmZmZlMjA4ZGMNCj4gPiA+DQo+IDAzYmY0YjY2JTdDNjg2ZWExZDNiYzJi
NGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3QzYzODM4OTM2NzMNCj4gPiA+DQo+IDM4MDcy
NzA5JTdDVW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lW
MmwNCj4gPiA+DQo+IHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCU3
QyU3QyU3QyZzZGF0YT05U0NGaVQNCj4gPiA+IDFuTnNUWmc0Ymg2bjc1Q2VpY0RDNTFKdzN3YWNR
Q2FMN3c0dlElM0QmcmVzZXJ2ZWQ9MA0KPiA+DQo+ID4gSW4gdGhpcyBsb2cgSSBjYW5ub3Qgc2Vl
IENBQU0gZmFpbHVyZXMuIGNhbiB5b3UgdGVsbCB3aGljaCBDQUFNIHRmbSBmYWlsZWQ/DQo+IA0K
PiBUaGUgdGVzdCBleGVyY2lzZXMgdGhlIGtlcm5lbCBjcnlwdG8gQVBJIHZpYSB0aGUgQUZfQUxH
IGludGVyZmFjZS4gVGhlIGZhaWx1cmVzDQo+IGJhc2ljYWxseSBkZXRlY3QgdGhhdCBmb3IgY2Vy
dGFpbiBpbnB1dHMgdGhlIGNyeXB0byBBUEkgcmV0dXJucyBkaWZmZXJlbnQgcmVzdWx0cw0KPiB0
aGFuIGV4cGVjdGVkIHdoZW4gdGhlIENBQU0gZHJpdmVyIGlzIHVzZWQgKHRoZSBtYWNoaW5lIGlu
IHF1ZXN0aW9uIGhhcyB0aGUNCj4gcmVsZXZhbnQgaGFyZHdhcmUsIHNvIHRoZSBjYWFtX2pyIGNy
eXB0byBkcml2ZXJzIGFyZSByZWdpc3RlcmVkIGZvciBjZXJ0YWluDQo+IGFsZ29yaXRobXMgYW5k
IHRoZXkgdGFrZSBwcmlvcml0eSkuDQo+IA0KPiBGb3IgZXhhbXBsZSwgd2hlbiB5b3UgaW5zdGFs
bCBsaWJrY2FwaS10b29scyBhbmQgcnVuOg0KPiANCj4ga2NhcGkgLXggMiAtcyAgLWUgLWMgImdj
bShhZXMpIiAtaSAxNmM0YjRiZDExOThmMzlmNGFlODE3YjcgXA0KPiAgICAgLWsNCj4gODdjOTFh
OGI2M2Y2NjkzNGRkMzcwMzQxNWIyNTM4NDYxZmJmZWY1NWNlN2E5Y2E5YmI5NDI1NDk5ZjRjZDFk
NiBcDQo+ICAgICAtYQ0KPiAiMzAzYmI1N2U0NTM0YjA4YTRkNWYwMDFhODRiMzA1MmM5ZDBkNThl
ZTAzZWRhNTIxMWE1NDA5NTBlODE5ZGMiIFwNCj4gICAgIC1wICJiMDVmYmQ0MDNjMmZhNDFhOGNj
NzAyYTc0NzRlZDliYTZjNTBmY2M2YzE5NzMyYTdkMzAwZjExMTM4NjJiYyINCj4gLWwgNA0KPiAN
Cj4gLi4udGhlIGNhYW1fanIgaW1wbGVtZW50YXRpb24gcmVzdWx0cyBpbg0KPiBiMDVmYmQ0MDNj
MmZhNDFhOGNjNzAyYTc0NzRlZDliYTZjNTBmY2M2YzE5NzMyYTdkMzAwZjExMTM4NjJiYzZkMjc1
DQo+IDZkNiwNCj4gd2hpbGUgdGhlIGV4cGVjdGVkIG91dHB1dCBpcw0KPiA5YmVhNTI2M2U3YjM2
NWQ1YTA2Y2IzY2NhYjBkNDNjYjlhMWNhOTY3ZGZiN2IxYTY5NTViM2M0OTMwMThhZjZkMjcNCj4g
NTZkNi4NCj4gWW91IGNhbiBzZWFyY2ggdGhlIHRlc3QgbG9nIGZvciAiRkFJTEVEIiB0byBmaW5k
IHRoZSBvdGhlciBmYWlsaW5nIGNvbW1hbmRzDQo+IChub3RlIHRoYXQgaW4gc29tZSBjYXNlcyB5
b3UgbmVlZCB0byBlc2NhcGUgdGhlIC1jIGFyZ3VtZW50IGFzIGl0IGNvbnRhaW5zDQo+IHBhcmVu
dGhlc2VzKS4NCg0KVGhhbmtzIGZvciB0aGUgaW5mb3JtYXRpb24uIEkgd2lsbCB1c2UgdGhpcyB0
ZXN0IHZlY3RvciBhbmQgd2lsbCBzaGFyZSB0aGUgdXBkYXRlIHdpdGggeW91Lg0KDQpHYXVyYXYg
SmFpbg0KPiANCj4gLS0NCj4gT25kcmVqIE1vc25hY2VrDQo+IFNlbmlvciBTb2Z0d2FyZSBFbmdp
bmVlciwgTGludXggU2VjdXJpdHkgLSBTRUxpbnV4IGtlcm5lbCBSZWQgSGF0LCBJbmMuDQoNCg==
