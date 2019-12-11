Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85602C3F68F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 14:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62606222C4
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 14:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbfLKOmD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 09:42:03 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:58784 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729929AbfLKOmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 09:42:03 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 09:42:01 EST
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 51D1D6285B9;
        Wed, 11 Dec 2019 15:36:25 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 11 Dec
 2019 15:36:24 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Wed, 11 Dec 2019 15:36:24 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Adam Ford <aford173@gmail.com>, Horia Geanta <horia.geanta@nxp.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 2/2] arm64: dts: imx8mm: Add Crypto CAAM support
Thread-Topic: [PATCH 2/2] arm64: dts: imx8mm: Add Crypto CAAM support
Thread-Index: AQHVp9OTS5mnZfHbzke4GpMb7fpZMqeyADMAgAMAHAA=
Date:   Wed, 11 Dec 2019 14:36:24 +0000
Message-ID: <fd146818-98c9-7092-5d49-a985db5900c7@kontron.de>
References: <20191130225153.30111-1-aford173@gmail.com>
 <20191130225153.30111-2-aford173@gmail.com>
 <VI1PR0402MB348586BEDA9BE13CEB10C75698580@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHCN7x+roEAmteNLT9KkLxPvL6AFFHMUW=J_cLcSdE50kODZQQ@mail.gmail.com>
In-Reply-To: <CAHCN7x+roEAmteNLT9KkLxPvL6AFFHMUW=J_cLcSdE50kODZQQ@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACEAAA732C76144993E26E2C6A1682CB@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 51D1D6285B9.A01DE
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: aford173@gmail.com, aymen.sghaier@nxp.com,
        davem@davemloft.net, devicetree@vger.kernel.org, festevam@gmail.com,
        herbert@gondor.apana.org.au, horia.geanta@nxp.com,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        robh+dt@kernel.org, s.hauer@pengutronix.de, shawnguo@kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQWRhbSwNCg0KT24gMDkuMTIuMTkgMTc6NDcsIEFkYW0gRm9yZCB3cm90ZToNCj4gT24gTW9u
LCBEZWMgOSwgMjAxOSBhdCAxMDoyMyBBTSBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAu
Y29tPiB3cm90ZToNCj4+DQo+PiBPbiAxMi8xLzIwMTkgMTI6NTIgQU0sIEFkYW0gRm9yZCB3cm90
ZToNCj4+PiBUaGUgaS5NWDhNIE1pbmkgc3VwcG9ydHMgdGhlIHNhbWUgY3J5cHRvIGVuZ2luZSBh
cyB3aGF0IGlzIGluDQo+Pj4gdGhlIGkuTVg4TVEsIGJ1dCBpdCBpcyBub3QgY3VycmVudGx5IHBy
ZXNlbnQgaW4gdGhlIGRldmljZSB0cmVlLA0KPj4+IGJlY2F1c2UgaXQgbWF5IGJlIHJlc3JpY3Rl
ZCBieSBzZWN1cml0eSBmZWF0dXJlcy4NCj4+Pg0KPj4gV2hhdCBleGFjdGx5IGFyZSB5b3UgcmVm
ZXJyaW5nIHRvPw0KPiANCj4gSSBkb24ndCBrbm93IHRoaXMgaGFyZHdhcmUgdmVyeSB3ZWxsLCBi
dXQgb24gYSBkaWZmZXJlbnQgcGxhdGZvcm0sIHdlDQo+IG5lZWRlZCB0byBtYWtlIHRoZSBjcnlw
dG8gZW5naW5lcyBhcyBkaXNhYmxlZCBpZiB0aGV5IHdlcmUgYmVpbmcNCj4gYWNjZXNzZWQgdGhy
b3VnaCBzZWN1cmUgb3BlcmF0aW9ucyB3aGljaCBtYWRlIGl0IHVuYXZhaWxhYmxlIHRvIExpbnV4
DQo+IHdpdGhvdXQgdXNpbmcgc29tZSBzcGVjaWFsIGJhcnJpZXJzLiBJIGRpZG4ndCBoYXZlIHRo
ZSBzcGVjaWFsDQo+IGhhcmR3YXJlIG9uIHRoZSBvdGhlciBwbGF0Zm9ybSB0aGF0IHJlcXVpcmVk
IGl0IHRoYXQgd2F5LCBzbyBJIGNhbid0DQo+IHJlYWxseSBleHBsYWluIGl0IHdlbGwuICBJIGtu
b3cgb24gdGhvc2Ugc3BlY2lhbCBjYXNlcywgYmVjYXVzZSBzb21lDQo+IHBlb3BsZSB3ZXJlIGFj
Y2Vzc2luZyB0aGVzZSByZWdpc3RlcnMgdGhyb3VnaCBvdGhlciBtZWFucywgdGhlIGRldmljZXMN
Cj4gaGFkIHRvIGJlIG1hcmtlZCBhcyAnZGlzYWJsZWQnIHNvIHRvIGF2b2lkIGJyZWFraW5nIHNv
bWV0aGluZy4gIFNpbmNlDQo+IEkgd2Fzbid0IHN1cmUgaWYgdGhpcyB3YXMgbGVmdCBvdXQgb2Yg
dGhlIGkuTVg4TSBNaW5pIG9uIHB1cnBvc2UsIEkNCj4gbGV0IHRoaXMgZGlzYWJsZWQganVzdCBp
biBjYXNlIHRoaXMgaGFyZHdhcmUgcGxhdGZvcm0gd2FzIGFsc28NCj4gYWZmZWN0ZWQgaW4gYSBz
aW1pbGFyIGFuZCBwZW9wbGUgd2FudGluZyB0byB1c2UgaXQgY291bGQgbWFyayBpdCBhcw0KPiAn
b2theScNCg0KSSBkb24ndCBrbm93IGVub3VnaCBhYm91dCB0aGlzIHRvIHVuZGVyc3RhbmQgdGhl
IHByb2JsZW0geW91J3JlIA0KZGVzY3JpYmluZy4gSXQgc2VlbXMgbGlrZSBtb3N0IFNvQ3MgaGF2
ZSB0aGUgQ0FBTSBlbmFibGVkIGJ5IGRlZmF1bHQgaW4gDQp0aGUgZGV2aWNldHJlZS4gT24gZmly
c3QgZ2xhbmNlIEkgY291bGQgb25seSBmaW5kIGZzbC1seDIxNjBhLmR0c2kgdGhhdCANCmhhcyBp
dCBkaXNhYmxlZC4NCg0KPiANCj4gYWRhbQ0KPiANCj4+DQo+Pj4gVGhpcyBwYXRjaCBwbGFjZXMg
aW4gaW50byB0aGUgZGV2aWNlIHRyZWUgYW5kIG1hcmtzIGl0IGFzIGRpc2FibGVkLA0KPj4+IGJ1
dCBhbnlvbmUgbm90IHJlc3RyaWN0aW5nIHRoZSBDQUFNIHdpdGggc2VjdXJlIG1vZGUgZnVuY3Rp
b25zDQo+Pj4gY2FuIG1hcmsgaXQgYXMgZW5hYmxlZC4NCj4+Pg0KPj4gRXZlbiBpZiAtIGR1ZSB0
byBleHBvcnQgY29udHJvbCByZWd1bGF0aW9ucyAtIENBQU0gaXMgInRyaW1tZWQgZG93biIsDQo+
PiBpdCBsb3NlcyBvbmx5IHRoZSBlbmNyeXB0aW9uIGNhcGFiaWxpdGllcyAoaGFzaGluZyBldGMu
IHN0aWxsIHdvcmtpbmcpLg0KDQpJIGRvbid0IGtub3cgbXVjaCBhYm91dCB0aGlzLCBidXQgYXMg
SG9yaWEgc2FpZCB0aGUgQ0FBTSBtaWdodCBoYXZlIA0KbGltaXRlZCBjYXBhYmlsaXRpZXMgaW4g
c29tZSBjYXNlcyBidXQgd291bGQgc3RpbGwgd29yay4NCg0KVGhlcmVmb3JlIEkgdGhpbmsgdGhl
IENBQU0gc2hvdWxkIGJlIGVuYWJsZWQgYnkgZGVmYXVsdCBhcyBpdCBhbHJlYWR5IGlzIA0KZG9u
ZSBmb3IgbW9zdCBvdGhlciBTb0NzLg0KDQpSZWdhcmRzLA0KRnJpZWRlcg0KDQo+Pg0KPj4gQWdh
aW4sIHBsZWFzZSBjbGFyaWZ5IHdoYXQgeW91IG1lYW4gYnkgInNlY3VyZSBtb2RlIGZ1bmN0aW9u
cyIsDQo+PiAic2VjdXJpdHkgZmVhdHVyZXMiIGV0Yy4NCj4+DQo+PiBIb3JpYQ0KPiANCj4gX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gbGludXgtYXJt
LWtlcm5lbCBtYWlsaW5nIGxpc3QNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQu
b3JnDQo+IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
YXJtLWtlcm5lbA0KPiA=
