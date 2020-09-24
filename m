Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB18C4346E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 08:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1551B2311A
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 08:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="LR9TCIE/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIXIIU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 04:08:20 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:48771 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727013AbgIXIIT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 04:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1600934896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uElOBufzp7ieQ88Hlg5I8luefOlEQrKuTYrmQxqITyU=;
        b=LR9TCIE/oXoDvMC8vWIIuJwHuQTkg7rzlViEIiFlh+X0fMNj+DHWDVXVqEXv2zq/j5wFDD
        9YbAWxNYISNDL830L+udVnp/jY4uo/ScES9Mf5sgi8Iufj6Ju8gU8orTPyJxq5JlCChbE9
        AtF44EGv+0D0AK7+jKVEw2yUIJD1/c8=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-8XnvwsLSMsSV_RJqj0In_A-1; Thu, 24 Sep 2020 04:08:14 -0400
X-MC-Unique: 8XnvwsLSMsSV_RJqj0In_A-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 24 Sep
 2020 08:08:13 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::bd2c:886:bd40:f40d%5]) with mapi id 15.20.3370.019; Thu, 24 Sep 2020
 08:08:12 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Thread-Topic: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Thread-Index: AQHWhPjdSpcGgYTiMUOu7ID5mrD0iqluCCwAgAAMa6CAAAVIgIAABV7AgAkXuQCAADvR4A==
Date:   Thu, 24 Sep 2020 08:08:12 +0000
Message-ID: <CY4PR0401MB3652E2654AE84DC173E008E2C3390@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
 <20200918065806.GA9698@gondor.apana.org.au>
 <CY4PR0401MB365283BF192613FD82EC0C12C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200918080127.GA24222@gondor.apana.org.au>
 <CY4PR0401MB365268AA17E35E5B55ABF7E6C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200924031154.GA8282@gondor.apana.org.au>
In-Reply-To: <20200924031154.GA8282@gondor.apana.org.au>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f4085a4-6209-41e7-c4fc-08d86060fbab
x-ms-traffictypediagnostic: CY4PR0401MB3652:
x-microsoft-antispam-prvs: <CY4PR0401MB365208D5A36EDFBC0E2FCCBDC3390@CY4PR0401MB3652.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +Q2brwpHjuBmESavPCPnZGvFpq1ODT5uxDb7YLkbSj8QtrN/UVPbqn0+E4szmtgdkNx8sYvzD4JzsS1m0xrK5lsggcJ6vIgGHQIWQNhkejIptlUdcFtVY9uWPibfzkp8BkBS5kbtLvwusYm64c3R8bRoRxtEDPXHNOsBKa4LgJHYMSV/7sV7RDTLHX1yMBiNco7Cz5yTuIM1uEDXrDGmEY0YJe7X0aW9qDGmJqhrylnLjOQoMPGA5x2vNQW0qNTZp2c/RvSxWYc1k97UuhuAFrA1AWMDyjUR93YTaEVKCpmtighKGZRgzptDhoQRppOEC0r3QVN5Q2ZsxV5lT+TCVGpKnz5labohOdIbRedBWLJOBzxoCkzJlxxCz/+kKKASih93tOQimkd0Cq533u6mGZLoVQlsia0op6UnLkozWDgIdxHs9+fThid+oDLSqXGOSqjQb1TAOfj7HcgPyVBO8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(396003)(39850400004)(316002)(83080400001)(64756008)(66446008)(8936002)(966005)(66556008)(71200400001)(66476007)(478600001)(66946007)(4326008)(86362001)(83380400001)(2906002)(6506007)(52536014)(55016002)(53546011)(33656002)(9686003)(54906003)(186003)(7696005)(5660300002)(26005)(8676002)(76116006)(6916009);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: Q+WksKp1dLcmClmlNCbL1z9xvF97DATT8S9ygONF07mP6GM0SkIrnf/sUaS/lYn7CPjSEV1B/ZuC6tF+k5rgZNR1l6z/QMSoaz7IbMFbvFbSG5BVBQcYZ00KbcdrvahIN2F/YA6lT5JyXZ97k1LZfJnn5KIwghnSssYDRVhOyKrtgAZeZLiR2xxw89WlqluWHkTbD4EcN61zcE9fHO3qERbGkyZxQr++U4vWHUr2eaVBE6nQkzE8fqk7oggPDvU9J9J/k5cLYDZS8JOw4OCJ7kL0vJSkJxr2xVbnXjza8mT4kYD6q5am+ZGtMjT7zXOHZK5lvcvZujVrJ6MhT+adxajjOH4A3WhSEzv7oB/fIXpYBQ0hBxQobYRkSj1tQZM1yjI/N7nEDg/58pMrSDIWVYkU7wsljP0KFTBQgNAeZr2hlm+PXiGZ1FdBq1wTNOeAnQzsKr5RhFmYYNMhFGXd6mTRZHZ7Sx2cwkfv3N/WHW5yF61eY04M2SxFg0gok3L0ePZQG7whnbMG8Aykva7YwazAk3VvaV9HLMntwYo1i+CI3C9vcJ4zQ985Gu02s9aiQO7FnWmWc3m4KUZzwL2bopWGuzBMiK4l6p/gkGw4bACl4LBz7V0KJ72B/LNrkvANyItwqeupe2muQ0ytscqQcg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f4085a4-6209-41e7-c4fc-08d86060fbab
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 08:08:12.5612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: czcd3cBq1JmaHUv136NHVdtKWkLVaJOyvWDnxRjknPdLRRLI9EdaBzyN9yTXvDdf/MfFxJmluPp7ZuvGqdo4cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3652
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0
QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjQsIDIw
MjAgNToxMiBBTQ0KPiBUbzogVmFuIExlZXV3ZW4sIFBhc2NhbCA8cHZhbmxlZXV3ZW5AcmFtYnVz
LmNvbT4NCj4gQ2M6IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGFudG9pbmUudGVuYXJ0
QGJvb3RsaW4uY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBBcmQgQmllc2hldXZlbCA8YXJkYkBr
ZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBjcnlwdG86IGluc2lkZS1zZWN1cmUg
LSBGaXggY29ycnVwdGlvbiBvbiBub3QgZnVsbHkgY29oZXJlbnQgc3lzdGVtcw0KPg0KPiA8PDwg
RXh0ZXJuYWwgRW1haWwgPj4+DQo+IE9uIEZyaSwgU2VwIDE4LCAyMDIwIGF0IDA4OjIxOjQ0QU0g
KzAwMDAsIFZhbiBMZWV1d2VuLCBQYXNjYWwgd3JvdGU6DQo+ID4NCj4gPiA+IENhbiB0aGlzIGFs
aWdubWVudCBleGNlZWQgQVJDSF9ETUFfTUlOQUxJR04/IElmIG5vdCB0aGVuIHRoZQ0KPiA+ID4g
bWFjcm8gQ1JZUFRPX01JTkFMSUdOIHNob3VsZCBjb3ZlciBpdC4NCj4gPg0KPiA+IEkgZG9uJ3Qg
a25vdy4gSSdtIG5vdCBmYW1pbGlhciB3aXRoIHRoYXQgbWFjcm8gYW5kIEkgaGF2ZSBub3QgYmVl
biBhYmxlIHRvIGRpZyB1cCBhbnkNCj4gPiBjbGVhciBkZXNjcmlwdGlvbiBvbiB3aGF0IGl0IHNo
b3VsZCBjb252ZXkuDQo+DQo+IEknbSBwcmV0dHkgc3VyZSBpdCBpcyBiZWNhdXNlIHRoYXQncyB0
aGUgcmVhc29uIGttYWxsb2MgdXNlcyBpdA0KPiBhcyBpdHMgbWluaW11bSBhcyBvdGhlcndpc2Ug
bWVtb3J5IHJldHVybmVkIGJ5IGttYWxsb2MgbWF5IGNyb3NzDQo+IGNhY2hlLWxpbmVzLg0KPg0K
SWYgdGhhdCBpcyBpbmRlZWQgd2hhdCBrbWFsbG9jIHVzZXMgZm9yIGFsaWdubWVudCwgZ29vZCBw
b2ludCAuLi4NCkkgc3VwcG9zZSBpZiB0aGF0IGlzIGd1YXJhbnRlZWQsIGl0IGlzIGEgcG9zc2li
bGUgYWx0ZXJuYXRpdmUgc29sdXRpb24gdG8gYXQgbGVhc3QNCnRoZSBjb2hlcmVuY2UgcHJvYmxl
bSBJIG5lZWRlZCB0byBzb2x2ZS4NCg0KQnV0LCB3aHkgdXNlIHNvbWUgZml4ZWQgd29yc3QgY2Fz
ZSB2YWx1ZSBpZiB5b3UgY2FuIGJlIG1vcmUgc21hcnQgYWJvdXQgaXQ/DQooVGhhdCBhcHBsaWVz
IHRvIGttYWxsb2MgYXMgd2VsbCwgYnkgdGhlIHdheSAuLi4gd2h5IGRvZXMgaXQgdXNlIHNvbWUg
Zml4ZWQgZGVmaW5lDQpmb3IgdGhhdCBhbmQgbm90IHRoZSBkeW5hbWljYWxseSBkaXNjb3ZlcmVk
IHN5c3RlbSBjYWNoZSBsaW5lIHNpemU/KQ0KDQpBbHNvLCB0aGVyZSBpcyBzb21lIGJlbmVmaXQg
dG8gYWxpZ25pbmcgdGhlc2UgYnVmZmVycyBmb3Igc3lzdGVtcyB0aGF0IEFSRSBmdWxseQ0KY29o
ZXJlbnQgYW5kIHRoZXJlZm9yZSBkbyBub3QgKHNlZW0gdG8pIGRlZmluZSBBUkNIX0RNQV9NSU5B
TElHTi4NCkFsdGhvdWdoIHRoYXQgd291bGQgYWxzbyBhcHBseSB0byBhbnkga21hbGxvYydkIGJ1
ZmZlcnMgc3VwcGxpZWQgZXh0ZXJuYWxseSAuLi4NCg0KPiA+IEluIGFueSBjYXNlLCBhbGlnbmlu
ZyB0byB0aGUgd29yc3QgY2FjaGUgY2FjaGVsaW5lIGZvciBhIENQVSBhcmNoaXRlY3R1cmUgbWF5
IG1lYW4NCj4gPiB5b3UgZW5kIHVwIHdhc3RpbmcgYSBsb3Qgb2Ygc3BhY2Ugb24gYSBzeXN0ZW0g
d2l0aCBhIG11Y2ggc21hbGxlciBjYWNoZWxpbmUuDQo+DQo+IEl0IHdvbid0IHdhc3RlIGFueSBt
ZW1vcnkgYmVjYXVzZSBrbWFsbG9jIGlzIGFscmVhZHkgdXNpbmcgaXQgYXMNCj4gYSBtaW5pbXVt
Lg0KPg0KVGhlIGZhY3QgdGhhdCBrbWFsbG9jIHVzZXMgaXQgZG9lcyBfbm90XyBydWxlIG91dCB0
aGUgZmFjdCB0aGF0IGl0IHdhc3RlcyBtZW1vcnkgLi4uDQpBbmQgYXMgbG9uZyBhcyB5b3UgdXNl
IGttYWxsb2MgZm9yIGZhaXJseSBsYXJnZSBkYXRhIHN0cnVjdHVyZXMsIGl0IHNob3VsZG4ndCBt
YXR0ZXIgbXVjaC4NCkJ1dCBoZXJlIEkgbmVlZCBhIGNvdXBsZSBvZiBmYWlybHkgc21hbGwgYnVm
ZmVycy4NCg0KPiBDaGVlcnMsDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdv
bmRvci5hcGFuYS5vcmcuYXU+DQo+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcu
YXUvfmhlcmJlcnQvDQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJi
ZXJ0L3B1YmtleS50eHQNCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJ
UCBBcmNoaXRlY3QgTXVsdGktUHJvdG9jb2wgRW5naW5lcywgUmFtYnVzIFNlY3VyaXR5DQpSYW1i
dXMgUk9UVyBIb2xkaW5nIEJWDQorMzEtNzMgNjU4MTk1Mw0KDQpOb3RlOiBUaGUgSW5zaWRlIFNl
Y3VyZS9WZXJpbWF0cml4IFNpbGljb24gSVAgdGVhbSB3YXMgcmVjZW50bHkgYWNxdWlyZWQgYnkg
UmFtYnVzLg0KUGxlYXNlIGJlIHNvIGtpbmQgdG8gdXBkYXRlIHlvdXIgZS1tYWlsIGFkZHJlc3Mg
Ym9vayB3aXRoIG15IG5ldyBlLW1haWwgYWRkcmVzcy4NCg0KDQoqKiBUaGlzIG1lc3NhZ2UgYW5k
IGFueSBhdHRhY2htZW50cyBhcmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVj
aXBpZW50KHMpLiBJdCBtYXkgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzIGNvbmZpZGVudGlh
bCBhbmQgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCBv
ZiB0aGlzIG1lc3NhZ2UsIHlvdSBhcmUgcHJvaGliaXRlZCBmcm9tIHByaW50aW5nLCBjb3B5aW5n
LCBmb3J3YXJkaW5nIG9yIHNhdmluZyBpdC4gUGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2FnZSBhbmQg
YXR0YWNobWVudHMgYW5kIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0KDQpSYW1i
dXMgSW5jLjxodHRwOi8vd3d3LnJhbWJ1cy5jb20+DQo=

