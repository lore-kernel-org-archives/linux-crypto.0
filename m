Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B8AC43331
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 12:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC6EB222C6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 12:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="CwGZXc4U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfKMM7b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 07:59:31 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:57134 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfKMM7a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 07:59:30 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: VrT1qDStd1I6DlrpEMYcEzm4edmFHsIKJ0iS2oU2kKI+QdP67TME53SOva6vpSRhXJZEwWR9Le
 R/9klp6RqD6aYmokZeeNrEvsNiRvR2jjfCQKo+rWDQQayIiq2jW3f3rWI2Z7eDqwf5IkgWrb86
 0nyB3rc6vneS0u475EbAQwqX5VoNWhD0oDTgE4LCnbQYlBMO754P3haOL4laJFN0qEUQ1ixBOP
 i3wGctuUUNMiuFbdaCanJA/eMP06QAdcEmqN53zZFf6L0uGnFHcmxGsnoAhaTiuyV1tnCPXVag
 56g=
X-IronPort-AV: E=Sophos;i="5.68,300,1569308400"; 
   d="scan'208";a="56899821"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2019 05:59:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 05:59:29 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 13 Nov 2019 05:59:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK16Zi9TiuV+8LoLdMChby4a7O/befxJogCeS6RIaTfY4f6L6gg4JY6VMxwAJ7tMzOQfczHaXbFhr+gO5XkkmdNxurvrVFBy9y/cgQw4lZ+UNSw69wz6IzLZYxZcuxDuuWJZoZrsyhTRys5kjLmOwrJH11H75nn3nzenSO1qgJcRf+Ucr8rLEeOZFWO5C4CUuBXgS9iWy8PLJTHV++Em1EXdmbmXwP2pN2GSEYuOF4zS0xZc2H3Xp7NTBsgTmw3TGSh+8CWqNWSNHikf9+4e6d1FJ55fwbREdq1732wKUENXLBbtMG8H71o9tYwUYo4NItmh7BN+AfUYdtI1EmAI3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/X3u1tBOl4VNHDP9vTWVyWuXD7PV7dAaXkwH1zK+MRA=;
 b=mz0Fy8KsqU1U748O5vOrGhqEj6DjU2571sZBo+fJT2if42JyHFQdVG8IM0Vfa1SPUFvvwZgrMFl3O5N9zKwjFZsaGLtIc5woWuBiLYswr0NFV6mihRY4cjnb2/b7/HzxO3LZXQOFkLiylsGX1GluRHESrpWlMvx7EbVKUqt86dAurCFk5VvR4I9KUTxqOojFFk33OK6LyV+ePFmDBogdWsCkbCtgkRbMuv6/llpY2Bux9hLwx64/yvvJUWHhg/4A3iTYtMqQauqv3qyOT2F50M+PtWhCQ3L6wopGZpyky08yBedEStagRJhX6Z0tF5uztqcUdq4LikS5DjHs+UTHcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/X3u1tBOl4VNHDP9vTWVyWuXD7PV7dAaXkwH1zK+MRA=;
 b=CwGZXc4U5SLaAVC2Z1mkVtQXStlbzWZ2nmit5kSDLnS+Lman9oBvottFgYqRS8sK1GQvTiuZ/qksx+iEHEkydRNf7zurRAqtgnbJS7W7WgK2sKbp+gpnixCzkEjzTrLR5p40QqU/vcDdMoGYGBnEbF5xra9MT/R6JQPuwlZP1bo=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (10.255.89.94) by
 BY5PR11MB3893.namprd11.prod.outlook.com (10.255.72.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 12:59:26 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::d128:6959:f7a2:9d17]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::d128:6959:f7a2:9d17%4]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 12:59:26 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <ardb@kernel.org>, <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH v4 09/29] crypto: atmel-tdes - switch to skcipher API
Thread-Topic: [PATCH v4 09/29] crypto: atmel-tdes - switch to skcipher API
Thread-Index: AQHVlyCrUyMVvOzH5kCRTAfrfAfH16eJFg6A
Date:   Wed, 13 Nov 2019 12:59:26 +0000
Message-ID: <174aa3b2-6eba-14dd-8364-69543f967dba@microchip.com>
References: <20191109170954.756-1-ardb@kernel.org>
 <20191109170954.756-10-ardb@kernel.org>
In-Reply-To: <20191109170954.756-10-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR08CA0043.eurprd08.prod.outlook.com
 (2603:10a6:205:2::14) To BY5PR11MB4435.namprd11.prod.outlook.com
 (2603:10b6:a03:1ce::30)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9db3152-0498-4004-3477-08d768395002
x-ms-traffictypediagnostic: BY5PR11MB3893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB3893D6A7DDE39F07FC2FFBA9F0760@BY5PR11MB3893.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39860400002)(199004)(189003)(102836004)(36756003)(6246003)(64756008)(8676002)(52116002)(99286004)(4326008)(76176011)(107886003)(66476007)(26005)(81166006)(31696002)(81156014)(6506007)(478600001)(53546011)(2501003)(71200400001)(386003)(25786009)(8936002)(66556008)(71190400001)(6486002)(6436002)(31686004)(110136005)(86362001)(229853002)(5660300002)(66066001)(66446008)(66946007)(2906002)(54906003)(6512007)(4744005)(2616005)(7736002)(6116002)(256004)(14454004)(476003)(446003)(305945005)(486006)(186003)(316002)(11346002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR11MB3893;H:BY5PR11MB4435.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o9InjO9kdchnDYhCYzMcTJdzirl4Bc2rrUhULcnA0hpcwqZqsY4WnvDQzYwGb0gwsscAD4mM/V3G1NCSP8t6o3lYRcbTlNRKw/JB0Ak+I0vG4Y5e+cc+Cc+4jLtV+w9bI4cEsWDBmLQS55GBdXn8EjjN8Q1w3FIh1LzhmxlZaG+fOco9N/1BQ/JfWTUov7yRSMmzA0QbUMqlbrzgxrBhzVT/OdPNcgX5cmJzSMHSsMMVHjStE2/42Tbd4v0M3ynh+pu3eh+2A4BfGLUrl6IbtIiXxQ1h7U4V25Rph/8OYloXJB+1Wl/q1PZ999fYv+bYpjBJGNruqoysYpZJo+VMYw+T52Dmq9NJR5YN/qIx8GkGXsLsHxrU1+yGc60r83Q0VgJ//9AKsvX6KLYqhux1y56gmrz0EKbSruXLGjFwDXcPOKkxQn8BjPmCHLxod+6Z
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5A6D4674EC004479D5D8AF933D102D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a9db3152-0498-4004-3477-08d768395002
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 12:59:26.3569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ng8TfABP6Hns5A6JKrJT7cZ2xfbz4mupD/Yj8SX2ABiwD2x8zKRN8u4gPTvePv2UELknJ9ez6ZS5UFAbmGhrw69b4vWfFJio2BzkrfEyZcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3893
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDExLzA5LzIwMTkgMDc6MDkgUE0sIEFyZCBCaWVzaGV1dmVsIHdyb3RlOg0KPiBDb21t
aXQgN2E3ZmZlNjVjOGM1ICgiY3J5cHRvOiBza2NpcGhlciAtIEFkZCB0b3AtbGV2ZWwgc2tjaXBo
ZXIgaW50ZXJmYWNlIikNCj4gZGF0ZWQgMjAgYXVndXN0IDIwMTUgaW50cm9kdWNlZCB0aGUgbmV3
IHNrY2lwaGVyIEFQSSB3aGljaCBpcyBzdXBwb3NlZCB0bw0KPiByZXBsYWNlIGJvdGggYmxrY2lw
aGVyIGFuZCBhYmxrY2lwaGVyLiBXaGlsZSBhbGwgY29uc3VtZXJzIG9mIHRoZSBBUEkgaGF2ZQ0K
PiBiZWVuIGNvbnZlcnRlZCBsb25nIGFnbywgc29tZSBwcm9kdWNlcnMgb2YgdGhlIGFibGtjaXBo
ZXIgcmVtYWluLCBmb3JjaW5nDQo+IHVzIHRvIGtlZXAgdGhlIGFibGtjaXBoZXIgc3VwcG9ydCBy
b3V0aW5lcyBhbGl2ZSwgYWxvbmcgd2l0aCB0aGUgbWF0Y2hpbmcNCj4gY29kZSB0byBleHBvc2Ug
W2FdYmxrY2lwaGVycyB2aWEgdGhlIHNrY2lwaGVyIEFQSS4NCj4gDQo+IFNvIHN3aXRjaCB0aGlz
IGRyaXZlciB0byB0aGUgc2tjaXBoZXIgQVBJLCBhbGxvd2luZyB1cyB0byBmaW5hbGx5IGRyb3Ag
dGhlDQo+IGFibGtjaXBoZXIgY29kZSBpbiB0aGUgbmVhciBmdXR1cmUuDQo+IA0KPiBDYzogTmlj
b2xhcyBGZXJyZSA8bmljb2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tPg0KPiBDYzogQWxleGFuZHJl
IEJlbGxvbmkgPGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tPg0KPiBDYzogTHVkb3ZpYyBE
ZXNyb2NoZXMgPGx1ZG92aWMuZGVzcm9jaGVzQG1pY3JvY2hpcC5jb20+DQo+IFRlc3RlZC1ieTog
VHVkb3IgQW1iYXJ1cyA8dHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPg0KDQpSZXZpZXdlZC1ieTogVHVk
b3IgQW1iYXJ1cyA8dHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPg0K
