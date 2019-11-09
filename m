Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713D2C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 06:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3297121848
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 06:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="cLL+mO8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfKIGXd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 01:23:33 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:52974 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfKIGXd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 01:23:33 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 7P1/hi4SilswJRNBQ86Y1VW8zjgvKQFi9McEEFFWKJRZTm41OfY1R3UMPl8mzF1N85U4kHZOIJ
 uWBIipppkIEArQ+rys2Ax5bBARvXdTIEIMBX910JdEs1HHuGM/8xUm8NLdit1zYCMlG4XIl+O6
 WKm23w5ULFaNyl5PxbSp/EuVYOhfR5G0AkO62wws/4IOW04nwGtaxe9gYcTvBVZTERDrSnA+Xv
 euvuI/QGb4H1RlWReOm0ODCJ/nIGpWQWM756HFuYhBL4nw6vcWeq+DHFdB+Z1ZDBgq5jQxIDqB
 EO4=
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="54800979"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2019 23:23:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 23:23:09 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 23:23:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/W2bsQtGD507YM4AFWMhBzLZlrGeldlzJtZC4elmQg5XI00BMSLn3Le3LABifPcLPCUlHftSgNSEFjhbsIbifxBny4Be376zU9mK4muaCHUy8l+EDe3z9X9pUCFimxIBSYbga+JfxTxZZMku+uZ4jzoJLSY10BhQTP7amfm7AyDbWQi/YznfRBB8q5FWOXD2EJMagYgVvnUfpGKk1LL8jGkpVnLVy1GBGV8cVazH8IcKTKh8aeNqEg/shsmS+O4v8o7U/iNNAiK/PDTUE662MsHGlhLHvM/DnIbOm2AiEt2wjv1xMo77/vg/cq5cg2jxqCbmKkJ6n9n01EWgG+gzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Kmagvn7nV6sSDSgnw4oXYs1P7kYkfwJkcJhLJyvKQc=;
 b=JWOSCgT15yZhENwsSk5c44Vd4UB7SC5hFnHHm5PRNED3S9AYepu7u91gz4GVvf5TrHrUafoWDrEbvzKUSi2PmKqiWYC64S73u1a60WcFwdX3PfGCrZqw50/tIUS4UDa258e8wISRh9DwiCnbRNYbJNyLKLMMhMv8zNbZzY4SV/mNx5mc8Qawpnhr/RCIo0F4lms/o6SqbqsnrpGiN8cF8rXJptLy/BIlpRdABfbwaQWN4i8tthAt7lJfNmOqBqW822OaxXGO/YtuxCqcGwiy8A+DxyxgOZR1zuYqfZu2ikYL/VyCC8IQweJ+8+Prr64V94u/kwfFdiGJfMshkaPetQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Kmagvn7nV6sSDSgnw4oXYs1P7kYkfwJkcJhLJyvKQc=;
 b=cLL+mO8fpJxjVO5kV7SJuhTbobKlDf4QC4G44LUBHbYzBo7sVAgAL8X93V+JxfV/1IdC174qOeR1BOSYisctIZr166TFTW1dS6CwYbHwYJVQb0y5slo1jWmtxo3qsRM89M778snPEl5AIwHh74MlJkZEbsq0TYZbeI7TPthaqg8=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4287.namprd11.prod.outlook.com (52.135.37.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Sat, 9 Nov 2019 06:23:06 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457%5]) with mapi id 15.20.2430.023; Sat, 9 Nov 2019
 06:23:06 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <ardb@kernel.org>, <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH v3 08/29] crypto: atmel-aes - switch to skcipher API
Thread-Topic: [PATCH v3 08/29] crypto: atmel-aes - switch to skcipher API
Thread-Index: AQHVk90MoVdSv33QXUOLAx243AJe1aeCZIaA
Date:   Sat, 9 Nov 2019 06:23:06 +0000
Message-ID: <fe064b41-94b8-1695-dc43-da8e151c77a8@microchip.com>
References: <20191105132826.1838-1-ardb@kernel.org>
 <20191105132826.1838-9-ardb@kernel.org>
In-Reply-To: <20191105132826.1838-9-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P193CA0020.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::30) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.12.60.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12942c85-b92f-463e-31f1-08d764dd484e
x-ms-traffictypediagnostic: MN2PR11MB4287:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4287484895CDD852CC7C67DDF07A0@MN2PR11MB4287.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(39860400002)(376002)(366004)(189003)(199004)(31696002)(71190400001)(6506007)(107886003)(71200400001)(486006)(76176011)(102836004)(2906002)(53546011)(99286004)(386003)(31686004)(11346002)(7736002)(2501003)(446003)(476003)(26005)(25786009)(36756003)(2616005)(66066001)(305945005)(4326008)(86362001)(6436002)(6116002)(3846002)(66476007)(66556008)(64756008)(14454004)(478600001)(186003)(6512007)(8936002)(66446008)(316002)(8676002)(81156014)(81166006)(256004)(229853002)(5660300002)(66946007)(6486002)(110136005)(4744005)(54906003)(6246003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4287;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MVvZoBTFKoULtxgHlz1q0yxbO4CjxYR67tbHxgqCgzFWL0J2F93vb5B3Oz7EVuBR/WtwQLt633qSybqvXDoaZfAE5IepO1aLl5w+6FV+55LcuXw3VqM3JccEtZYBsWQxX4hF+BrywE/LpC3PCQJCkpLpjGBdF+u+H5OKLWc4QymWIgzzD/rgeZSXXOm0NQiaar/C+hGbgG/wgYt1FXptAttv1KgDi53DQbqngH73elaazJwRH880TruPYfZLf2Y/hgC6ml3YUvVCrOK1VqFcm54l3WJOGN6G0ClA7nYuPjz45QOGiq3nx3zyd62ITrK6GayDKc64Sz/1HplnAj/0LWWx8PyWldAFkaMV99og89LGzwazFKv1sZEyh1qmNOYYLBP/3q3TpmbYDPI63OvPvP/TqgYdvWZylApA/U5PO2Aj9eVCMZVGt3KlZskCzXdH
Content-Type: text/plain; charset="utf-8"
Content-ID: <693EBB30A4E23D42BF49A30252435200@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 12942c85-b92f-463e-31f1-08d764dd484e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 06:23:06.1897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBR2COXkn4mw7mac076AiDmjxb/HCPvLLPAZVsqIWNZ7XUUKiQNCzFXXXiK0BSrsjS6YOwoe72Fw+BI7kaZGVFEw3oPchVvCcTliopN08Rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4287
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDExLzA1LzIwMTkgMDM6MjggUE0sIEFyZCBCaWVzaGV1dmVsIHdyb3RlOg0KPiBDb21t
aXQgN2E3ZmZlNjVjOGM1ICgiY3J5cHRvOiBza2NpcGhlciAtIEFkZCB0b3AtbGV2ZWwgc2tjaXBo
ZXIgaW50ZXJmYWNlIikNCj4gZGF0ZWQgMjAgYXVndXN0IDIwMTUgaW50cm9kdWNlZCB0aGUgbmV3
IHNrY2lwaGVyIEFQSSB3aGljaCBpcyBzdXBwb3NlZCB0bw0KPiByZXBsYWNlIGJvdGggYmxrY2lw
aGVyIGFuZCBhYmxrY2lwaGVyLiBXaGlsZSBhbGwgY29uc3VtZXJzIG9mIHRoZSBBUEkgaGF2ZQ0K
PiBiZWVuIGNvbnZlcnRlZCBsb25nIGFnbywgc29tZSBwcm9kdWNlcnMgb2YgdGhlIGFibGtjaXBo
ZXIgcmVtYWluLCBmb3JjaW5nDQo+IHVzIHRvIGtlZXAgdGhlIGFibGtjaXBoZXIgc3VwcG9ydCBy
b3V0aW5lcyBhbGl2ZSwgYWxvbmcgd2l0aCB0aGUgbWF0Y2hpbmcNCj4gY29kZSB0byBleHBvc2Ug
W2FdYmxrY2lwaGVycyB2aWEgdGhlIHNrY2lwaGVyIEFQSS4NCj4gDQo+IFNvIHN3aXRjaCB0aGlz
IGRyaXZlciB0byB0aGUgc2tjaXBoZXIgQVBJLCBhbGxvd2luZyB1cyB0byBmaW5hbGx5IGRyb3Ag
dGhlDQo+IGJsa2NpcGhlciBjb2RlIGluIHRoZSBuZWFyIGZ1dHVyZS4NCj4gDQo+IENjOiBOaWNv
bGFzIEZlcnJlIDxuaWNvbGFzLmZlcnJlQG1pY3JvY2hpcC5jb20+DQo+IENjOiBBbGV4YW5kcmUg
QmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+DQo+IENjOiBMdWRvdmljIERl
c3JvY2hlcyA8bHVkb3ZpYy5kZXNyb2NoZXNAbWljcm9jaGlwLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4NCg0KVGVzdGVkLWJ5OiBUdWRvciBB
bWJhcnVzIDx0dWRvci5hbWJhcnVzQG1pY3JvY2hpcC5jb20+DQo=
