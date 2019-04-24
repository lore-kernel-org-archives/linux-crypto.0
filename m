Return-Path: <SRS0=+uK6=S2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26758C282E1
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 08:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3CD218FD
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 08:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="sggOTt2D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfDXIzQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Apr 2019 04:55:16 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:19705 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfDXIzP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Apr 2019 04:55:15 -0400
X-IronPort-AV: E=Sophos;i="5.60,389,1549954800"; 
   d="scan'208";a="28972443"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Apr 2019 01:55:15 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 24 Apr 2019 01:55:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeIO53FEinJQaUy6CNZ9rWLpssL/tW/isO6t36/TirQ=;
 b=sggOTt2D0SEg3k/vY+oIV4NuPkL4jRJlRDddkdJBsh5VlIGHA57/wHoHJsxyy5zb1k8bZmvs3yFYmkSsRMXX0PBNOH72DXsxZvg4u8aqOXpIndadC9/CjX7734IWYIkBJeDQvru5mLR21KGQugxBx3CAHLV8BshcSeq0M5qNNUg=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1950.namprd11.prod.outlook.com (10.175.54.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Wed, 24 Apr 2019 08:55:10 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::65cd:b698:41:54d6]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::65cd:b698:41:54d6%2]) with mapi id 15.20.1813.017; Wed, 24 Apr 2019
 08:55:10 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <yuehaibing@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <Tudor.Ambarus@microchip.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: atmel - remove set but not used variable
 'alg_name'
Thread-Topic: [PATCH -next] crypto: atmel - remove set but not used variable
 'alg_name'
Thread-Index: AQHU+ntsxLImuCAh0U608XBhtA1qRg==
Date:   Wed, 24 Apr 2019 08:55:10 +0000
Message-ID: <0d8312a8-289e-71ea-3b20-c2e5c1ef47d6@microchip.com>
References: <20190424075352.22828-1-yuehaibing@huawei.com>
In-Reply-To: <20190424075352.22828-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Nicolas.Ferre@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.6.168.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4625408c-b3b3-4409-ec13-08d6c8928ea3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR11MB1950;
x-ms-traffictypediagnostic: MWHPR11MB1950:
x-microsoft-antispam-prvs: <MWHPR11MB1950CA800867271305F79230E03C0@MWHPR11MB1950.namprd11.prod.outlook.com>
x-forefront-prvs: 00179089FD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(136003)(376002)(346002)(189003)(199004)(2616005)(6486002)(186003)(6512007)(68736007)(26005)(53936002)(6436002)(97736004)(54906003)(11346002)(2906002)(316002)(446003)(476003)(81156014)(8676002)(81166006)(486006)(110136005)(7736002)(36756003)(31686004)(386003)(6506007)(66066001)(6246003)(53546011)(99286004)(86362001)(229853002)(256004)(52116002)(2501003)(3846002)(31696002)(76176011)(6116002)(305945005)(14444005)(6636002)(102836004)(71190400001)(478600001)(4326008)(2201001)(8936002)(25786009)(72206003)(73956011)(66446008)(66946007)(66556008)(14454004)(64756008)(66476007)(71200400001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1950;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w3JJoMpfgibysfQPZ8c0RSsZF+qt+Y7H602Ufqexp7E9kdJxHoCBe7hj24EZ5PRf33QFakOSP8fxbdbLaaCpdYpp0W1jOj9r+tVBF8JDd5zjI3R8lT0Ks8xJNou7eciP8P4fHn3xizQR/j22flvaYUGOI1u16h2faUwb4xPogygWpPfJ4ppn70q4Il3+ofsB74rl4DXkS7sOuqLre2oHyEsaE8y9EnUkE+uHkIzpBtM8xRUeceNGJJlIsMBc/K5k1VaPi/rb7HdmAjUSz+jDWptVZ/f/HyTpppwMiA6Fo7vBN1RK01KJ2xvFPV6ckbeqvomLrRxwAtYu6ccAvBDVbttutco2CQs2pc6UdWY83W/+pC+k5+f/dYs2G6y4RZzve1nBV4u9pq0WW/JWxi6M2AXXkL7g0ZG4pWRRcDFu2iE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAF955894FDA0348A95A32720B830B00@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4625408c-b3b3-4409-ec13-08d6c8928ea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2019 08:55:10.6464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1950
X-OriginatorOrg: microchip.com
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMjQvMDQvMjAxOSBhdCAwOTo1MywgWXVlIEhhaWJpbmcgd3JvdGU6DQo+IEZyb206IFl1ZUhh
aWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCj4gDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQt
YnV0LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvY3J5cHRvL2F0bWVsLXRk
ZXMuYzogSW4gZnVuY3Rpb24gJ2F0bWVsX3RkZXNfc2V0a2V5JzoNCj4gZHJpdmVycy9jcnlwdG8v
YXRtZWwtdGRlcy5jOjgwMzoxNDogd2FybmluZzogdmFyaWFibGUgJ2FsZ19uYW1lJyBzZXQgYnV0
IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gSXQgaXMgbm90IHVz
ZWQgYW55IG1vcmUgc2luY2UNCj4gY29tbWl0IDUyZWEzY2QyOTE3YiAoImNyeXB0bzogYXRtZWwg
LSBGb3JiaWQgMi1rZXkgM0RFUyBpbiBGSVBTIG1vZGUiKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
WXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KDQpMb29rcyBnb29kIHRvIG1lOg0K
UmV2aWV3ZWQtYnk6IE5pY29sYXMgRmVycmUgPG5pY29sYXMuZmVycmVAbWljcm9jaGlwLmNvbT4N
Cg0KPiAtLS0NCj4gICBkcml2ZXJzL2NyeXB0by9hdG1lbC10ZGVzLmMgfCAzIC0tLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y3J5cHRvL2F0bWVsLXRkZXMuYyBiL2RyaXZlcnMvY3J5cHRvL2F0bWVsLXRkZXMuYw0KPiBpbmRl
eCAxMjQ5MmQ5Li5mYTc2NjIwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9hdG1lbC10
ZGVzLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtdGRlcy5jDQo+IEBAIC04MDAsMTIg
KzgwMCw5IEBAIHN0YXRpYyBpbnQgYXRtZWxfdGRlc19zZXRrZXkoc3RydWN0IGNyeXB0b19hYmxr
Y2lwaGVyICp0Zm0sIGNvbnN0IHU4ICprZXksDQo+ICAgCQkJICAgdW5zaWduZWQgaW50IGtleWxl
bikNCj4gICB7DQo+ICAgCXN0cnVjdCBhdG1lbF90ZGVzX2N0eCAqY3R4ID0gY3J5cHRvX2FibGtj
aXBoZXJfY3R4KHRmbSk7DQo+IC0JY29uc3QgY2hhciAqYWxnX25hbWU7DQo+ICAgCXUzMiBmbGFn
czsNCj4gICAJaW50IGVycjsNCj4gICANCj4gLQlhbGdfbmFtZSA9IGNyeXB0b190Zm1fYWxnX25h
bWUoY3J5cHRvX2FibGtjaXBoZXJfdGZtKHRmbSkpOw0KPiAtDQo+ICAgCWZsYWdzID0gY3J5cHRv
X2FibGtjaXBoZXJfZ2V0X2ZsYWdzKHRmbSk7DQo+ICAgCWVyciA9IF9fZGVzM192ZXJpZnlfa2V5
KCZmbGFncywga2V5KTsNCj4gICAJaWYgKHVubGlrZWx5KGVycikpIHsNCj4gDQoNCg0KLS0gDQpO
aWNvbGFzIEZlcnJlDQo=
