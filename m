Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BDDC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 14:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D536D20836
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 14:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbfLKOX5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 09:23:57 -0500
Received: from skedge03.snt-world.com ([91.208.41.68]:44654 "EHLO
        skedge03.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729671AbfLKOX5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 09:23:57 -0500
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge03.snt-world.com (Postfix) with ESMTPS id C5A2767A6F1;
        Wed, 11 Dec 2019 15:23:33 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 11 Dec
 2019 15:23:33 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Wed, 11 Dec 2019 15:23:33 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Horia Geanta <horia.geanta@nxp.com>, Adam Ford <aford173@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "Fabio Estevam" <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
Thread-Topic: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
Thread-Index: AQHVp9kQe4CI+Rf8yUmun0IOEuspVqe0/KsA
Date:   Wed, 11 Dec 2019 14:23:32 +0000
Message-ID: <d82428e3-326b-db80-2e40-4ef1bdbca060@kontron.de>
References: <20191130225153.30111-1-aford173@gmail.com>
 <e8e429dd-4508-9835-fd01-825d2de8871e@kontron.de>
 <CAHCN7xLkV1WC=9ACj1Mi8+uE8kRCEjCEe+Y36pXwkNeNrgrNVg@mail.gmail.com>
 <VI1PR0402MB34857B8C5560B912B34674AB985B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34857B8C5560B912B34674AB985B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA2FCE7CD7265A47BE96B7819248829C@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: C5A2767A6F1.AF622
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

T24gMTAuMTIuMTkgMDg6NTYsIEhvcmlhIEdlYW50YSB3cm90ZToNCj4gT24gMTIvNi8yMDE5IDk6
NTUgUE0sIEFkYW0gRm9yZCB3cm90ZToNCj4+IE9uIFdlZCwgRGVjIDQsIDIwMTkgYXQgNTozOCBB
TSBTY2hyZW1wZiBGcmllZGVyDQo+PiA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPiB3cm90
ZToNCj4+Pg0KPj4+IEhpIEFkYW0sDQo+Pj4NCj4+PiBPbiAzMC4xMS4xOSAyMzo1MSwgQWRhbSBG
b3JkIHdyb3RlOg0KPj4+PiBUaGUgaS5NWDhNIE1pbmkgdXNlcyB0aGUgc2FtZSBjcnlwdG8gZW5n
aW5lIGFzIHRoZSBpLk1YOE1RLCBidXQNCj4+Pj4gdGhlIGRyaXZlciBpcyByZXN0cmljdGluZyB0
aGUgY2hlY2sgdG8ganVzdCB0aGUgaS5NWDhNUS4NCj4+Pj4NCj4+Pj4gVGhpcyBwYXRjaCBsZXRz
IHRoZSBkcml2ZXIgc3VwcG9ydCBhbGwgaS5NWDhNIFZhcmlhbnRzIGlmIGVuYWJsZWQuDQo+Pj4+
DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IEFkYW0gRm9yZCA8YWZvcmQxNzNAZ21haWwuY29tPg0KPj4+
DQo+Pj4gV2hhdCBhYm91dCB0aGUgZm9sbG93aW5nIGxpbmVzIGluIHJ1bl9kZXNjcmlwdG9yX2Rl
Y28wKCk/IERvZXMgdGhpcw0KPj4+IGNvbmRpdGlvbiBhbHNvIGFwcGx5IHRvIGkuTVg4TU0/DQo+
Pg0KPj4gSSB0aGluayB0aGF0J3MgYSBxdWVzdGlvbiBmb3IgTlhQLiAgSSBhbSBub3Qgc2VlaW5n
IHRoYXQgaW4gdGhlIE5YUA0KPj4gTGludXggUmVsZWFzZSwgYW5kIEkgZG9uJ3QgaGF2ZSBhbiA4
TVEgdG8gY29tcGFyZS4NCj4+DQo+IElJUkMgdGhlIGkuTVggQlNQIHJlbGVhc2VzIHVzZSB0aGUg
SlJJIGZvciBpbml0aWFsaXppbmcgdGhlIFJORywNCj4gYW5kIG5vdCB0aGUgREVDTyByZWdpc3Rl
ciBpbnRlcmZhY2UuDQo+IA0KPj4gSSB3YXMgYWJsZSB0byBnZXQgdGhlIGRyaXZlciB3b3JraW5n
IG9uIHRoZSBpLk1YTU0gd2l0aCB0aGUgcGF0Y2guDQo+Pg0KPiBZb3UgYXJlIHByb2JhYmx5IHVz
aW5nIGEgbmV3ZXIgVS1ib290LCB3aGljaCBpbmNsdWRlcw0KPiBjb21taXQgZGZhZWM3NjAyOWYy
ICgiY3J5cHRvL2ZzbDogaW5zdGFudGlhdGUgYWxsIHJuZyBzdGF0ZSBoYW5kbGVzIikNCj4gDQo+
PiBOWFAgIFRlYW0sDQo+Pg0KPj4gRG8geW91IGhhdmUgYW55IG9waW5pb25zIG9uIHRoaXM/DQo+
Pg0KPiBTaW5jZSBjdXJyZW50IFUtYm9vdCBpbml0aWFsaXplcyBib3RoIFJORyBzdGF0ZSBoYW5k
bGVzLCBwcmFjdGljYWxseQ0KPiBpbnN0YW50aWF0ZV9ybmcoKSBpcyBhIG5vLW9wLg0KPiANCj4g
QSBzaW1wbGUgZXhwZXJpbWVudCBpcyB0byAibGllIiBhYm91dCB0aGUgc3RhdGVfaGFuZGxlX21h
c2ssIHRvIGV4ZXJjaXNlDQo+IHRoZSBERUNPIGFjcXVpcmUgY29kZSAob3IsIGFzIG1lbnRpb25l
ZCBhYm92ZSwgdG8gcnVuIHdpdGggYW4gb2xkZXIgVS1ib290KToNCj4gDQo+IEBAIC0yNjgsMTIg
KzI3MiwxOSBAQCBzdGF0aWMgaW50IGluc3RhbnRpYXRlX3JuZyhzdHJ1Y3QgZGV2aWNlICpjdHJs
ZGV2LCBpbnQgc3RhdGVfaGFuZGxlX21hc2ssDQo+ICAgICAgICAgIHN0cnVjdCBjYWFtX2N0cmwg
X19pb21lbSAqY3RybDsNCj4gICAgICAgICAgdTMyICpkZXNjLCBzdGF0dXMgPSAwLCByZHN0YV92
YWw7DQo+ICAgICAgICAgIGludCByZXQgPSAwLCBzaF9pZHg7DQo+ICsgICAgICAgc3RhdGljIGlu
dCBmb3JjZV9pbml0ID0gMTsNCj4gDQo+ICAgICAgICAgIGN0cmwgPSAoc3RydWN0IGNhYW1fY3Ry
bCBfX2lvbWVtICopY3RybHByaXYtPmN0cmw7DQo+ICAgICAgICAgIGRlc2MgPSBrbWFsbG9jKENB
QU1fQ01EX1NaICogNywgR0ZQX0tFUk5FTCk7DQo+ICAgICAgICAgIGlmICghZGVzYykNCj4gICAg
ICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gDQo+ICsgICAgICAgaWYgKGZvcmNlX2lu
aXQgJiYgKHN0YXRlX2hhbmRsZV9tYXNrID09IDB4MykpIHsNCj4gKyAgICAgICAgICAgICAgIGRl
dl9lcnIoY3RybGRldiwgIkZvcmNpbmcgcmVpbml0IG9mIFJORyBzdGF0ZSBoYW5kbGUgMCFcbiIp
Ow0KPiArICAgICAgICAgICAgICAgZm9yY2VfaW5pdCA9IDA7DQo+ICsgICAgICAgICAgICAgICBz
dGF0ZV9oYW5kbGVfbWFzayA9IDB4MjsNCj4gKyAgICAgICB9DQo+ICsNCj4gICAgICAgICAgZm9y
IChzaF9pZHggPSAwOyBzaF9pZHggPCBSTkc0X01BWF9IQU5ETEVTOyBzaF9pZHgrKykgew0KPiAg
ICAgICAgICAgICAgICAgIC8qDQo+ICAgICAgICAgICAgICAgICAgICogSWYgdGhlIGNvcnJlc3Bv
bmRpbmcgYml0IGlzIHNldCwgdGhpcyBzdGF0ZSBoYW5kbGUNCj4gDQo+IEluIHRoaXMgY2FzZSBi
b290IGxvZyBjb25maXJtcyB0aGUgREVDTyBjYW5ub3QgYmUgYWNxdWlyZWQ6DQo+IFsgICAgMi4x
MzcxMDFdIGNhYW0gMzA5MDAwMDAuY3J5cHRvOiBGb3JjaW5nIHJlaW5pdCBvZiBSTkcgc3RhdGUg
aGFuZGxlIDAhDQo+IFsgICAgMi4xNzIyOTNdIGNhYW0gMzA5MDAwMDAuY3J5cHRvOiBmYWlsZWQg
dG8gYWNxdWlyZSBERUNPIDANCj4gWyAgICAyLjE3Nzc4Nl0gY2FhbSAzMDkwMDAwMC5jcnlwdG86
IGZhaWxlZCB0byBpbnN0YW50aWF0ZSBSTkcNCj4gDQo+IFRvIHN1bSB1cCwgd3JpdGluZyB0byBE
RUNPUlNSIGlzIG1hbmRhdG9yeS4NCg0KVGhhbmtzIEhvcmlhIGZvciBwcm92aWRpbmcgdGhlIGRl
dGFpbHMuDQoNCkFkYW0sIGNhbiB5b3UgdXBkYXRlIHlvdXIgcGF0Y2ggdG8gZW5hYmxlIHRoZSBj
b2RlIGluIA0KcnVuX2Rlc2NyaXB0b3JfZGVjbzAoKSBmb3IgaS5NWDhNTT8NCg0KSWYgSSB1bmRl
cnN0YW5kIHRoaXMgY29ycmVjdGx5LCB0aGlzIGlzIG5lY2Vzc2FyeSB0byBoYXZlIHRoZSBSTkcg
DQppbml0aWFsaXplIGNvcnJlY3RseSBubyBtYXR0ZXIgd2hhdCB2ZXJzaW9uIG9mIFUtQm9vdCBp
cyB1c2VkLg0KDQpUaGFua3MsDQpGcmllZGVy
