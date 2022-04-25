Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A1FC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 09:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiDYJmy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 05:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbiDYJmP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 05:42:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC6B825C70
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 02:37:57 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-264-gSzupilVOGmWAUMzmc48-Q-1; Mon, 25 Apr 2022 10:37:54 +0100
X-MC-Unique: gSzupilVOGmWAUMzmc48-Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 25 Apr 2022 10:37:53 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 25 Apr 2022 10:37:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>
CC:     Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: RE: [PATCH] hex2bin: make the function hex_to_bin constant-time
Thread-Topic: [PATCH] hex2bin: make the function hex_to_bin constant-time
Thread-Index: AQHYWCRFXKVloRHnAkSgNzNf81l36q0AX1Cg
Date:   Mon, 25 Apr 2022 09:37:53 +0000
Message-ID: <789f0463ce974e90a93f4dbf8c471156@AcuMS.aculab.com>
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
In-Reply-To: <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjQgQXByaWwgMjAyMiAyMjo0Mg0KPiANCj4g
T24gU3VuLCBBcHIgMjQsIDIwMjIgYXQgMjozNyBQTSBMaW51cyBUb3J2YWxkcw0KPiA8dG9ydmFs
ZHNAbGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiA+DQo+ID4gRmluYWxseSwgZm9yIHRo
ZSBzYW1lIHJlYXNvbiAtIHBsZWFzZSBkb24ndCB1c2UgIj4+IDgiLiAgQmVjYXVzZSBJIGRvDQo+
ID4gbm90IGJlbGlldmUgdGhhdCBiaXQgOCBpcyB3ZWxsLWRlZmluZWQgaW4geW91ciBhcml0aG1l
dGljLiBUaGUgKnNpZ24qDQo+ID4gYml0IHdpbGwgYmUsIGJ1dCBJJ20gbm90IGNvbnZpbmNlZCBi
aXQgOCBpcy4NCj4gDQo+IEhtbS4uIEkgdGhpbmsgaXQncyBvay4gSXQgY2FuIGluZGVlZCBvdmVy
ZmxvdyBpbiAnY2hhcicgYW5kIGNoYW5nZSB0aGUNCj4gc2lnbiBpbiBiaXQgIzcsIGJ1dCBJIHN1
c3BlY3QgYml0ICM4IGlzIGFsd2F5cyBmaW5lLg0KPiANCj4gU3RpbGwsIElmIHlvdSB3YW50IHRv
IGp1c3QgZXh0ZW5kIHRoZSBzaWduIGJpdCwgIj4+IDMxIiBfaXNfIHRoZQ0KPiBvYnZpb3VzIHRo
aW5nIHRvIHVzZSAoeWVhaCwgeWVhaCwgcHJvcGVybHkgInNpemVvZihpbnQpKjgtMSIgb3INCj4g
d2hhdGV2ZXIsIHlvdSBnZXQgbXkgZHJpZnQpLg0KDQpFeGNlcHQgdGhhdCByaWdodCBzaGlmdHMg
b2Ygc2lnbmVkIHZhbHVlcyBhcmUgVUIuDQpJbiBwYXJ0aWN1bGFyIGl0IGhhcyBhbHdheXMgYmVl
biB2YWxpZCB0byBkbyBhbiB1bnNpZ25lZA0Kc2hpZnQgcmlnaHQgb24gYSAyJ3MgY29tcGxpbWVu
dCBuZWdhdGl2ZSBudW1iZXIuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

