Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8692BC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 06:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 489DC21882
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 06:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="lJq60Oye"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfKIGRU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 01:17:20 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22972 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfKIGRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 01:17:19 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: y9cs2Hoadp7XZ/Un2+rwXXIEG3KdHiXt+5d7fLutIMCSR8Z8RN9USSllml55T5Q9FW1wSKuhg/
 LLqXJ53E3yawAbTdEnNMIXDgyIrLORYGY/bREoA1b89AqkQglZfliBzL/ibxQXzyu5aYSz82L/
 epp078m3PlFD/XrOlWy1CuInw/NFGQ7TybylR4CnL3ycvYicBLWYlYqG/ELh/Xs+JjeiKvIRoo
 XM/BukFVI+e8aKYMtKd0O6iarDFKT6fTv0X/XRgY+CcGY7+y+j+iol8A6QKNuKdRUFaxQh2dRO
 YAE=
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="57658683"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2019 23:17:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 23:17:16 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 23:17:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFU/oJSN82dXv4tK56abzflTxbKfFXoprmsXuGMDArgG2MvvamktYnNbvMLfYEcrojNjFVvCjCTCwuoGJCGq97IVbxk9yxlhwa5T7pvp8X/zjEtzI62iVo79394jReCfjsImWu3iLtBrXEWNb911xzq3c83big5islFD9CuDSaMH3Wv4CikLb182aXLDvL/wjX0aQADRFSHMHKjufbbL7vrFIuvD5ct70hPyoe2yHb9GidfPhZ2j5TyifJeUNeUpWIrvdh4ebPT3w3D7T4xQdS9BbxgfbKGs5NkfbZc2hm0PMO5VVLbYW0hp1cZ6H1d2r2cx151JR+9o+RN7thYHvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Kmagvn7nV6sSDSgnw4oXYs1P7kYkfwJkcJhLJyvKQc=;
 b=XytTnW6Y7GiNWCY7J0pcsWE1Kgt5nVzuAwUBfw6AjHXzoY78Yj6U+jrCp3pkJOUarf1gSJ8/TPMR4ZKkxvX4Zj58o9aO4eMSuyRCrBp5QRwpcNKsvzBqpt3JPopOQY9G+87DJPX1XVfn6LlUSRenuV5N+pChV7BfnnC4hC6XZptkLToZiNsTMKo+O6ArpjxPY+/a7giyv6XgMuSsxuc7TjyqQIEar0SvkjdJYka0ccG5kIgHmV5TY4tRQvwaIdzcGRG7GoJ1Wzn4G5uvZACCQ1sQMFCbQmRrXJa2IVehdeUUfVZSZhZhPDlGDjVD8k8gPqhBFV96HUTOSloa1gDL/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Kmagvn7nV6sSDSgnw4oXYs1P7kYkfwJkcJhLJyvKQc=;
 b=lJq60OyeU9HAQicxhcKSp3hCHnN7Vn7UzIxK170M5ZQlLKAwji1fwRu6UJ/N19waP0lciys1ZYCi/7RpsN55yi1Gj4X40PN8AI1omvwvwGViGT/XP9nQ7geaVdfeJKtWQV1oimFCbiKGq0du2CSVrrUziV5ZwJBq1/6LOPcD4ZA=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4381.namprd11.prod.outlook.com (52.135.37.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Sat, 9 Nov 2019 06:17:13 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457%5]) with mapi id 15.20.2430.023; Sat, 9 Nov 2019
 06:17:13 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <ardb@kernel.org>, <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH v3 09/29] crypto: atmel-tdes - switch to skcipher API
Thread-Topic: [PATCH v3 09/29] crypto: atmel-tdes - switch to skcipher API
Thread-Index: AQHVk90I7pi7OUKBQkSZy2whdLCRX6eCYuOA
Date:   Sat, 9 Nov 2019 06:17:13 +0000
Message-ID: <53f2e6e9-a55b-4b0b-0d72-0e9c58f21c9f@microchip.com>
References: <20191105132826.1838-1-ardb@kernel.org>
 <20191105132826.1838-10-ardb@kernel.org>
In-Reply-To: <20191105132826.1838-10-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0202CA0014.eurprd02.prod.outlook.com
 (2603:10a6:803:14::27) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.12.60.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edfc1816-f02c-4c4f-41f3-08d764dc760b
x-ms-traffictypediagnostic: MN2PR11MB4381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4381A4051E6A4DEEE61D5BEBF07A0@MN2PR11MB4381.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(4744005)(66556008)(25786009)(256004)(2906002)(5660300002)(4326008)(2501003)(66446008)(52116002)(31696002)(31686004)(64756008)(66476007)(478600001)(76176011)(6246003)(8936002)(86362001)(14454004)(107886003)(66066001)(8676002)(81156014)(66946007)(316002)(102836004)(71200400001)(71190400001)(26005)(81166006)(99286004)(110136005)(305945005)(6512007)(386003)(6506007)(53546011)(54906003)(186003)(476003)(486006)(11346002)(446003)(2616005)(6436002)(3846002)(6116002)(6486002)(229853002)(36756003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4381;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hjr2Cld9UHkQlojvJ77K6JbTQ1J+jKcXzBXcH6UTxU64ewQBWG2fxTARZRcEvXo17SHG5OhFgQc1RGuni8cJgcrTrosBmU38awSekvQIJ1aCW/OrcNmS5K3pep+HejAfSA94WoZEcNWH35lGvomalw550IHCCHGjTrRc8aR4rGnxqUkYyuHbPk1bUuK3TuEHKazQyFZYXUZtZi73vl90IvzNKSrwBTWRNfADU5u03DNEWeI25Trfb0OFPe9ec/9S9qdETybNdnpzj57QkbjzqXltebdqKphR1Riu2TQwhOPcCKW+4oPubMJriYbrMDofwZg2URmkdnJiRqb3dORTiBergBk11lLroJrbbNyWgQAaMmLFW/rykfDgS8Hfx5SP7GIVUiwGCMRf/XuRcnBGhYs7aQkC53aFoZth6jH87WkoaNmT2C8C1nkD4TUCJ0bz
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F0CA05DD26C7C4E9F38134BCCCB9662@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: edfc1816-f02c-4c4f-41f3-08d764dc760b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 06:17:13.4994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kq2+f0tLE76sMGBED44JQhaVw0CkSY+EGDNVzqXT3dLHZ3aLBddXrbc7Ch3bWCtYxkx73bl81xY7NrQwWh3tHuksQGFY56HDrgRUqjNsWS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4381
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
