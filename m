Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB6BC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 10:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF015256ED
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 10:16:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="q1QLW0Xw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfE3KQ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 06:16:57 -0400
Received: from mail-eopbgr150111.outbound.protection.outlook.com ([40.107.15.111]:8302
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbfE3KQ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 06:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyzaNumf6sCNNL2Zaf6lYgCCWb4mc+qex48iDg6WOD0=;
 b=q1QLW0XwNiXSWu3nevyldxZ+Hxk+9jnWdSedb+gAxN2QxSyX1bwUuE3Hz4hgZFjsUtLZnXMz5VuaZBHxJRGxeS1ZxbzWWtJLsUr/VUmLMpybrg+EpXIFsdggwat3q7DlXu+sBD/zEY7P09uBGgojvyYp9Z7Is34vZHkd3mTdxTQ=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2533.eurprd09.prod.outlook.com (20.177.115.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.20; Thu, 30 May 2019 10:16:50 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 10:16:50 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: RE: Conding style question regarding configuration
Thread-Topic: Conding style question regarding configuration
Thread-Index: AdUVadXkEfSYWnL2TvyyCw6EdJwBbwAA23iAAAYjRWAALLNogAAl1WUQ
Date:   Thu, 30 May 2019 10:16:50 +0000
Message-ID: <AM6PR09MB35232561AF362BF5A9FE72FFD2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
 <AM6PR09MB3523B77DE66DD5353F08A687D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190529180731.Horde.NGHeOXuCgw23pVdGqjc0fw9@messagerie.si.c-s.fr>
In-Reply-To: <20190529180731.Horde.NGHeOXuCgw23pVdGqjc0fw9@messagerie.si.c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b65dca46-5c9c-43eb-816c-08d6e4e7ee4f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2533;
x-ms-traffictypediagnostic: AM6PR09MB2533:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2533E56AB9A3D1FE18F54CA3D2180@AM6PR09MB2533.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(39850400004)(136003)(366004)(189003)(199004)(81156014)(186003)(8676002)(8936002)(55016002)(9686003)(33656002)(5660300002)(3846002)(6116002)(14454004)(316002)(305945005)(68736007)(7736002)(54906003)(71190400001)(53936002)(52536014)(256004)(6246003)(478600001)(86362001)(6436002)(4326008)(25786009)(229853002)(64756008)(15974865002)(73956011)(81166006)(6916009)(71200400001)(2906002)(486006)(6506007)(7696005)(99286004)(102836004)(66946007)(66556008)(76116006)(76176011)(66066001)(476003)(66446008)(66476007)(446003)(11346002)(74316002)(26005)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2533;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XdpcXENs23BOVytjJq9aZDWG85q8GjZIVdoVjgQ6x90p5189fi4eDWtOcSlfef/t5t4+1qoiJMWxBqNaPsElv5HAKFqvdzFsmZJGok4te8b7yGfevXdYikTle+3sCeG1rMzsibK6kC7ezChGK7rteIwfLO6seNN+LEaVlrSaBVpG2+Nqat1Fbdczc1SY7pwGRx8Y52P+fwg55hUWEJLCqVU+lmxawJLo5CwGriKkvIMjJPpxAdOoUzp/hxdVWhN8yZ7B7456PE/5a6ulHjSptTXwkQogB9moEWwq6YAQCgmpNdMoaaJlXRXjAwkenqz0dB/SexvuOi8Cundl7c98/i62FAQnu4uxNXZa6T+qjeTT+EhzI0sNCP+l/SbVB83Ja1hjG+h1j+0oDPsxP1qCfWsyuQTjHxdJrh/KlZAYfpY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b65dca46-5c9c-43eb-816c-08d6e4e7ee4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 10:16:50.4800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2533
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+PiBZZXMuIENvZGUgYW5kIGRhdGEgd2l0aCBzdGF0aWMgbGlua2FnZSB3aWxsIGp1c3QgYmUg
b3B0aW1pemVkIGF3YXkgYnkNCj4gPj4gdGhlIGNvbXBpbGVyIGlmIHRoZSBDT05GSUdfeHggb3B0
aW9uIGlzIG5vdCBlbmFibGVkLCBzbyBhbGwgeW91IG5lZWQNCj4gPj4gdG8gZ3VhcmQgYXJlIHRo
ZSBhY3R1YWwgc3RhdGVtZW50cywgZnVuY3Rpb24gY2FsbHMgZXRjLg0KPiA+Pg0KPiA+IE9rLCBt
YWtlcyBzZW5zZS4gVGhlbiBJJ2xsIGp1c3QgY29uZmlnIG91dCB0aGUgcmVsZXZhbnQgZnVuY3Rp
b24gYm9kaWVzDQo+ID4gYW5kIGFzc3VtZSB0aGUgY29tcGlsZXIgd2lsbCBkbyB0aGUgcmVzdCAu
Li4NCj4gPg0KPiANCj4gTm8gbmVlZCB0byBjb25maWcgb3V0IGZ1bmN0aW9uIGJvZGllcyB3aGVu
IHRoZXkgYXJlIHN0YXRpYy4NCj4NCldlbGwsIEkgZ290IGEgY29tcGxhaW50IGZyb20gc29tZW9u
ZSB0aGF0IG15IGRyaXZlciB1cGRhdGVzIGZvciBhZGRpbmcgUENJRQ0Kc3VwcG9ydCB3b3VsZG4n
dCAgY29tcGlsZSBwcm9wZXJseSBvbiBhIHBsYXRmb3JtIHdpdGhvdXQgYSBQQ0koRSkgc3Vic3lz
dGVtLg0KU28gSSBmaWd1cmUgSSBkbyBoYXZlIHRvIGNvbmZpZyBvdXQgdGhlIHJlZmVyZW5jZXMg
dG8gUENJIHNwZWNpZmljIGZ1bmN0aW9uDQpjYWxscyB0byBmaXggdGhhdC4NCg0KT3IgYXJlIHlv
dSBqdXN0IHJlZmVycmluZyB0byBib2RpZXMgb2Ygc3RhdGljIHN1YmZ1bmN0aW9ucyB0aGF0IGFy
ZSBubw0KbG9uZ2VyIGJlaW5nIGNhbGxlZD8gV291bGQgdGhlIGNvbXBpbGVyIHNraXAgdGhvc2Ug
ZW50aXJlbHk/DQoNCj4gSWYgbm90LCBpdCdzIGJldHRlciB0byBncm91cCB0aGVuIGluIGEgQyBm
aWxlIGFuZCBhc3NvY2lhdGUgdGhhdCBmaWxlDQo+IHRvIHRoZSBjb25maWcgc3ltYm9sIHRocm91
Z2ggTWFrZWZpbGUNCj4gDQo+IENocmlzdG9waGUNCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVl
dXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBJbnNp
ZGUgU2VjdXJlDQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
