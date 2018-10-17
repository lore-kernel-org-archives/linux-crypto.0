Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF53ECDE30
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 154372150F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:59:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="vJQgw0py"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 154372150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbeJQUzc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:55:32 -0400
Received: from mail-ve1eur01on0065.outbound.protection.outlook.com ([104.47.1.65]:1993
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727018AbeJQUzc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPhQJKnlR6JwPywMnv2isSV1tqx8ESRflXaYnN9dyRM=;
 b=vJQgw0pyj+Wa9byFBWUCEA9TTQzn+ueT0rsrWi3ImOcHxdYW5NM7ppE6TM2E1vVHeIpUAR6ZhuUwegprZ04FxxoetuD1m3QSM01qsNd6IBYbZ1yteBWS5CY1tucYag+DznjaOU/aHAVDMGKW1xk5PlzrBDqZbnnEd8/svyGz6/U=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4900.eurprd04.prod.outlook.com (20.176.215.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Wed, 17 Oct 2018 12:59:39 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.032; Wed, 17 Oct 2018
 12:59:39 +0000
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
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Topic: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Index: AQHUZhY4HefM3c9m50qn78KSFJ8+NKUjYzGAgAADJwA=
Date:   Wed, 17 Oct 2018 12:59:39 +0000
Message-ID: <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
         <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
         <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com>
In-Reply-To: <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [95.76.156.53]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4900;6:9Vi7dkFuW222dA1e8+Q3z5MoNFPva0zY1uxE7nV6qKdBbQJD2zhtDMpRfLGYrI5ftw7uDS5zW+msQoNBTEE16BBHb0fWABMEiPfFy3ZFPHRFjfVoM5BayANq/8Vv0hURfWE9AO0cpOLirhBE7mkJhJORgD0IM0a8BLeFvSaR72Nx61AhRBXxZFcG6Hiw7p5U0AHqMhdGW2FComRItkxZc46XheylwtlmxgZ6FNb4pu+bJzzZTAahPFGPQKga4FhxdEiOj7xoHAl2Q2tPeEnr0UspFeJjMMByew2MRcb438AWLXcCmpe4tKnLp2KbUcsVJ57Smb9FN/rh5JK80DGWD2JqIGWtuCeb1cEXn25sAFtFMffsZFZmJWvN8cnNi7txaY5m86Chug9M0KXDCUDSeiVSr7GI6JfPqdr9UqnBnu/FYdCAOgLz/ldwxZ0w4YQYDiHnYvXVY13ne5WIl6xR1g==;5:pxnUbnB2it6UMNddKWx3csjeRXrH1PISpAhE6q5Y8RCosbBBAUuBwQe+wG9n5osA0wRvw8xh1IEHqPjiCQ5aNJSnN1x4DJfg4CF8UxobFNy/Qx4uWZshvXzP9ej7Hqr/p+xOfn/nIkH1/lI6jV02iDqwa+XasHZTVIMfdoRq//8=;7:eiTwB5VpqRV8S1uP6x6Wdpy6UfeOg7L/XC3wLfYt6IN/rGmJjQelBYngxmgPv9D0b/+Fn1WUgfWdw3KXbgNaTuBpJ5m/50aoXPuzDKqB0SvwyEK7WB4Fehdbs9V8l12oxfMYwR46e5xDgNBK73KDnIO/Q9qMTEE4gMMDVvkhV0jdZqoYG3yjHl/NWmQw/RV4zKnkfaEE+KmN5IghjCq4liaf4DxDxRD6wN7NHEHX+wlPNOBO9pETQNBsp7c2TjZM
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 66869379-c94b-4ee3-b74c-08d63430664e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4900;
x-ms-traffictypediagnostic: AM0PR04MB4900:
x-microsoft-antispam-prvs: <AM0PR04MB490069FEC51D78A65D6B9D89EEFF0@AM0PR04MB4900.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4900;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4900;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(54534003)(199004)(189003)(256004)(186003)(102836004)(26005)(106356001)(105586002)(2501003)(50226002)(8676002)(2351001)(1411001)(5250100002)(1730700003)(81166006)(81156014)(68736007)(229853002)(2906002)(36756003)(3846002)(6116002)(14444005)(44832011)(66066001)(8936002)(476003)(486006)(2616005)(446003)(11346002)(4001150100001)(6436002)(478600001)(5640700003)(6512007)(14454004)(6486002)(2900100001)(97736004)(53936002)(76176011)(7416002)(1361003)(39060400002)(54906003)(86362001)(71200400001)(316002)(25786009)(71190400001)(6246003)(118296001)(4326008)(6506007)(7736002)(305945005)(53546011)(6916009)(99286004)(5660300001)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4900;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: bqF5w3JJDAafmYViUghtLdMb6Rz2RSBuVNisgFBVdFw7ulam6jnQRLsJogh3k65Z53n48cxJ/6setXePARBArX2HTgE5WzkstrgLd8lHBC7cz1wwb7POdwtTVcBK3bO/gVHMeD8xm0Mds13Pt52//z2bA8xbLsjaShiatkbjDFwAnGYjK08sHcPGcnfh5pZ3RfpwTMDgEtVRzm+kwZCBX5RpzmfX1z1eZrWVcgXsumBAxKqtKh2bigw/b0Tg1sLnYyOa5iq8j3ZCJDiXvfrRbSTG25aUj2mEJaDaEKVzYqUNo18DEMJQDv7kghaAtJ94x4+OYNNKqSj6PhhCOXXeWNHmIfSJef1zws9v7bDDToM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-ID: <F0D4898771DE40499701E9026682387F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66869379-c94b-4ee3-b74c-08d63430664e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:59:39.7742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4900
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017125939.f3JtrhWtsi9Wh3ssYW6K11GH-wLY8uhg-mJeusNLasY@z>

T24gV2VkLCAyMDE4LTEwLTE3IGF0IDA5OjQ4IC0wMzAwLCBGYWJpbyBFc3RldmFtIHdyb3RlOg0K
PiBPbiBXZWQsIE9jdCAxNywgMjAxOCBhdCA5OjM4IEFNIExlb25hcmQgQ3Jlc3RleiA8bGVvbmFy
ZC5jcmVzdGV6QG54cC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIDZ1bGwgYW5kIDZzbGwgdGhl
IERDUCBibG9jayBoYXMgYSBjbG9jayB3aGljaCBuZWVkcyB0byBiZSBleHBsaWNpdGx5DQo+ID4g
ZW5hYmxlZC4NCj4gPiANCj4gPiBBZGQgbWluaW1hbCBoYW5kbGluZyBmb3IgdGhpcyBhdCBwcm9i
ZS9yZW1vdmUgdGltZS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBMZW9uYXJkIENyZXN0ZXog
PGxlb25hcmQuY3Jlc3RlekBueHAuY29tPg0KPiANCj4gUGxlYXNlIGFsd2F5cyBleHBsYWluIHdo
YXQgY2hhbmdlZCBmcm9tIHRoZSBwcmV2aW91cyBwYXRjaCB2ZXJzaW9uLg0KDQpUaGVyZSBpcyBh
IGNoYW5nZWxvZyBpbiB0aGUgY292ZXIgbGV0dGVyLg0KDQo+ID4gKyAgICAgICAvKiBSZXN0YXJ0
IHRoZSBEQ1AgYmxvY2suICovDQo+ID4gKyAgICAgICByZXQgPSBzdG1wX3Jlc2V0X2Jsb2NrKHNk
Y3AtPmJhc2UpOw0KPiA+ICsgICAgICAgaWYgKHJldCkgew0KPiA+ICsgICAgICAgICAgICAgICBk
ZXZfZXJyKGRldiwgIkZhaWxlZCByZXNldFxuIik7DQo+ID4gKyAgICAgICAgICAgICAgIGdvdG8g
ZXJyX2Rpc2FibGVfdW5wcmVwYXJlX2NsazsNCj4gPiArICAgICAgIH0NCj4gDQo+IFRoaXMgc2Vl
bXMgbGlrZSBhbiB1bnJlbGF0ZWQgY2hhbmdlIHRoYXQgc2hvdWxkIGJlIGluIGEgc2VwYXJhdGUg
cGF0Y2guDQo+IA0KPiBBbHNvLCB0aGlzIHdhcyBub3QgcHJlc2VudCBpbiB2Mywgc28gaXQgaXMg
YmV0dGVyIHRvIGV4cGxhaW4gdGhhdCB0aGlzDQo+IGhhcyBiZWVuIGludHJvZHVjZWQgaW4gdjQu
DQoNClRoaXMgb25seSBsb29rcyBzbGlnaHRseSBvZGQgaW4gZ2l0IGRpZmYgYnV0IGl0J3Mgbm90
IHVucmVsYXRlZC4NCg0KSSBwbGFjZWQgY2xrIGdldC9wcmVwYXJlL2VuYWJsZSBqdXN0IGJlZm9y
ZSBzdG1wX3Jlc2V0X2Jsb2NrIGFuZCBtYWRlDQpzdG1wX3Jlc2V0X2Jsb2NrIHByaW50IGEgbWVz
c2FnZSBhbmQgZ290byBlcnJfZGlzYWJsZV91bnByZXBhcmVfY2xrIG9uDQpmYWlsdXJlIGluc3Rl
YWQgb2YganVzdCAiaWYgKHJldCkgcmV0dXJuIHJldDsiDQo=
