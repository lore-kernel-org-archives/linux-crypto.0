Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F54C04EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 17:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5004720866
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 17:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="sWPVErPu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5004720866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbeJQBOl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 21:14:41 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:6992
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730397AbeJQBOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 21:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMatmsTNLG7zIY5H0wCgczq8tqMc+JQ/qmJkbIT4fAA=;
 b=sWPVErPuXcDV0zYYdTIjej1ptI2nuk24jimIcfON1PwamU2jB5ktLaY5SIROE+SBHwq83Wo0kVZcFVA76y/rUMYizSocjvnNFTyGmBx9Vf/NhrZ0/qUiFuu5A+BfGZXxlsA5KIPxyYNR6xhGVcaJdz6Gzdz/FBUtXrH+BgbzGjc=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB5059.eurprd04.prod.outlook.com (20.177.40.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.25; Tue, 16 Oct 2018 17:23:11 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 17:23:11 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     "festevam@gmail.com" <festevam@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "marek.vasut@gmail.com" <marek.vasut@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Topic: [PATCH v3 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Index: AQHUZWj5i/DYKbq7fkKcieuhPA7M6KUiCNKAgAAWHIA=
Date:   Tue, 16 Oct 2018 17:23:11 +0000
Message-ID: <f88233e6a76e99f95f6611bccdf234681e84f7ce.camel@nxp.com>
References: <cover.1539705285.git.leonard.crestez@nxp.com>
         <dcbcaf888bbd0a35dcf34228df2d9eb4fd762ea7.1539705286.git.leonard.crestez@nxp.com>
         <CAOMZO5Ck846zd_Xo=9sVK0EAxNLsUsWiC59H2Ms6x8xoD8iwWw@mail.gmail.com>
In-Reply-To: <CAOMZO5Ck846zd_Xo=9sVK0EAxNLsUsWiC59H2Ms6x8xoD8iwWw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [95.76.156.53]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB5059;6:DwiZ5OdQDTncJwfYWfgMTNdosSeBlFph+MUSKWfYLvOb/AdO8MjH/WWbB+9pBl9RS86nE1lU882uSgCQWW4Zhi4Na5SBRvubg9gcaK8jZ+L67sFoYXCa3dpw0/9ZBCOXkllnA/7c6zVilDup+/3aOH9k2FbiKGoAAswQyizP2SO/qBZe7cM6/HtZ1827/l0pafPUjmoxW7gjuqsNrbIvhh8JHDk6Fl3ctVcWG9OrHLnL/2dD3J9PyVYei1tM9uZ+SdzaCXW49RUz6UkU4NwaSqNCRh2JzLw+HMt30/5eqewhEBeDZb3eXnmx3pcyZsdY67cBuIFcWZDReT7jrPqDX01nJ/pbyvc/T1KVT2lgR5090XVW3LqUufk2zS7fvuTS4aO5hCkSISPeAOD4fyTxVIKvtYQYCSEDm+q8YAgxAxYDZM4fth5FUFMAQZPEKGL9M5XF4h5Rn440SCvlKx6BsQ==;5:zvdVmIsIPSelUGJEQeL8s6fK+odDqPpNFrtEyJ1hQ2ILC2mP2qk9laB+Yx4BqHPa7UOw969gKjnupjSfJ9VRVWxLiKMQstdf+pe8NfSW5Y6bFvqStoFhHeD5bUClCIOUAMHgT5tlwTg8jfZAj+eqtrP7l9XivFXnbJ3oMLeiKg0=;7:ZX5+wrrirXqCX7mRpROTB65AZkPeWMUUVeZtt/BIpGZ7DPv81MYRiD+Iimkr7ofG/CN5Q4j6jSD5KMr6LPN0lf2KwyP0NoF0OclibAmzuHBBlNlogyD9eN1Ajnq7mTlHkBEZRNDiRtidLTVGq64L8bd6LxdxXV6KO+CuOj2rQ1CJtcMmGEONN4640enTuPSbJEr4x8ZLFk7MWE6vpVULFXppGbGErtahMFvLFXsHnSDIvDStiYiLQBFlYh+fzAOM
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 63c6366b-7d8e-4c6b-7303-08d6338c0c92
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB5059;
x-ms-traffictypediagnostic: AM0PR04MB5059:
x-microsoft-antispam-prvs: <AM0PR04MB5059A885E24528B8872E27D3EEFE0@AM0PR04MB5059.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051);SRVR:AM0PR04MB5059;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB5059;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(366004)(39860400002)(396003)(189003)(199004)(1730700003)(14444005)(76176011)(11346002)(1361003)(6512007)(229853002)(36756003)(2501003)(50226002)(6506007)(7736002)(1411001)(5640700003)(39060400002)(446003)(486006)(256004)(476003)(316002)(53936002)(2900100001)(6486002)(4326008)(4001150100001)(97736004)(44832011)(5250100002)(25786009)(2616005)(86362001)(102836004)(6916009)(71200400001)(106356001)(105586002)(66066001)(186003)(54906003)(2351001)(478600001)(6246003)(6436002)(99286004)(26005)(71190400001)(81156014)(81166006)(118296001)(3846002)(5660300001)(6116002)(2906002)(68736007)(7416002)(8936002)(305945005)(8676002)(14454004)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5059;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: reSoo8FmoxewxXdH4+QU1w4h1WKsl+XMbW878HwKZBHeMdFDdaMzdTLQ8392rwIKoJNxqrbx+1PdOKjo2lItrI7S4O6AtrVN2cnRqClwC8UjLYAqPZIHjzC8mxSZ51G0BMElcX6nwo1jnSCOCB/d0c41BdiwHL3s9IzIfHE/FR9e7RKMqheDvQVuAVhSiIT0BnrJA9vTQ5duyqBefio8A4ZWWKqBUXZLIahl0RVLufQfg3O4t/XU6UpIbvwhK4P8SCP3mP8vNAlaI3H4FQwuCbeH7Ubvl0ASecKyL9/py0MXZPtiJSvCUPn97+xylATm79OvNfAxCqvn3YMrLPlksdZzZERI//ba5WDtKJxROhY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-ID: <55D657036B547E4D91B7FD5CB5FEA6B4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c6366b-7d8e-4c6b-7303-08d6338c0c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 17:23:11.7915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5059
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016172311.5oTKYVucv1KaV2c8vLbgllZoBdZQpDQmK9_mBxN3Ows@z>

T24gVHVlLCAyMDE4LTEwLTE2IGF0IDEzOjAzIC0wMzAwLCBGYWJpbyBFc3RldmFtIHdyb3RlOg0K
PiA+ICsgICAgICAgLyogRENQIGNsb2NrIGlzIG9wdGlvbmFsLCBvbmx5IHVzZWQgb24gc29tZSBT
T0NzICovDQo+ID4gKyAgICAgICBzZGNwLT5kY3BfY2xrID0gZGV2bV9jbGtfZ2V0KGRldiwgImRj
cCIpOw0KPiA+ICsgICAgICAgaWYgKElTX0VSUihzZGNwLT5kY3BfY2xrKSkgew0KPiA+ICsgICAg
ICAgICAgICAgICBpZiAoc2RjcC0+ZGNwX2NsayAhPSBFUlJfUFRSKC1FTk9FTlQpKQ0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKHNkY3AtPmRjcF9jbGspOw0KPiA+
ICsgICAgICAgICAgICAgICBzZGNwLT5kY3BfY2xrID0gTlVMTDsNCj4gDQo+IFRoaXMgZGNwX2Ns
ayBhc3NpZ25tZW50IHRvIE5VTEwgZG9lcyBub3Qgc2VlbSB0byBiZSBuZWNlc3NhcnkuDQoNClRo
ZSBjbGsgQVBJIGlnbm9yZXMgYWxsIGNhbGxzIGlmIGNsayA9PSBOVUxMICh3aGljaCBpcyB2ZXJ5
IG5pY2UpIGJ1dA0Kbm90IGlmIElTX0VSUihjbGspLiBTZXR0aW5nIGRjcF9jbGsgdG8gTlVMTCBh
dm9pZHMgc3ByaW5rbGluZyBvdGhlcg0KY2hlY2tzLg0KDQo+ID4gKyAgICAgICByZXQgPSBjbGtf
cHJlcGFyZV9lbmFibGUoc2RjcC0+ZGNwX2Nsayk7DQo+ID4gKyAgICAgICBpZiAocmV0KQ0KPiA+
ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+IA0KPiA+ICAgICAgICAgcmV0ID0gZGV2
bV9yZXF1ZXN0X2lycShkZXYsIGRjcF92bWlfaXJxLCBteHNfZGNwX2lycSwgMCwNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgImRjcC12bWktaXJxIiwgc2RjcCk7DQo+ID4gICAg
ICAgICBpZiAocmV0KSB7DQo+ID4gICAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAiRmFpbGVk
IHRvIGNsYWltIERDUCBWTUkgSVJRIVxuIik7DQo+IA0KPiBJbiBjYXNlIG9mIHN1YnNlcXVlbnQg
ZXJyb3JzIHlvdSBzaG91bGQgY2FsbA0KPiBjbGtfZGlzYWJsZV91bnByZXBhcmUoc2RjcC0+ZGNw
X2NsaykuDQoNClllcywgd2lsbCByZXNlbmQuIE1heWJlIHNvbWUgZGF5IGNsayBjb25zdW1lciB3
aWxsIGF1dG9tYXRpY2FsbHkgdW5kbw0KcGVuZGluZyBwcmVwYXJlL2VuYWJsZXMgb24gcmVsZWFz
ZT8NCg==
