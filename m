Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B44C2BD09
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 11:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4BD72081B
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 11:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfLDLiu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 06:38:50 -0500
Received: from skedge03.snt-world.com ([91.208.41.68]:34632 "EHLO
        skedge03.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLDLiu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 06:38:50 -0500
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge03.snt-world.com (Postfix) with ESMTPS id A91FB67B181;
        Wed,  4 Dec 2019 12:38:46 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 4 Dec 2019
 12:38:46 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Wed, 4 Dec 2019 12:38:46 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Adam Ford <aford173@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
Thread-Topic: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
Thread-Index: AQHVp9kQe4CI+Rf8yUmun0IOEuspVqepzk4A
Date:   Wed, 4 Dec 2019 11:38:46 +0000
Message-ID: <e8e429dd-4508-9835-fd01-825d2de8871e@kontron.de>
References: <20191130225153.30111-1-aford173@gmail.com>
In-Reply-To: <20191130225153.30111-1-aford173@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8132CB5151D4E48A2A1202728C1E995@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: A91FB67B181.A1F6F
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

SGkgQWRhbSwNCg0KT24gMzAuMTEuMTkgMjM6NTEsIEFkYW0gRm9yZCB3cm90ZToNCj4gVGhlIGku
TVg4TSBNaW5pIHVzZXMgdGhlIHNhbWUgY3J5cHRvIGVuZ2luZSBhcyB0aGUgaS5NWDhNUSwgYnV0
DQo+IHRoZSBkcml2ZXIgaXMgcmVzdHJpY3RpbmcgdGhlIGNoZWNrIHRvIGp1c3QgdGhlIGkuTVg4
TVEuDQo+IA0KPiBUaGlzIHBhdGNoIGxldHMgdGhlIGRyaXZlciBzdXBwb3J0IGFsbCBpLk1YOE0g
VmFyaWFudHMgaWYgZW5hYmxlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFkYW0gRm9yZCA8YWZv
cmQxNzNAZ21haWwuY29tPg0KDQpXaGF0IGFib3V0IHRoZSBmb2xsb3dpbmcgbGluZXMgaW4gcnVu
X2Rlc2NyaXB0b3JfZGVjbzAoKT8gRG9lcyB0aGlzIA0KY29uZGl0aW9uIGFsc28gYXBwbHkgdG8g
aS5NWDhNTT8NCg0KZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmM6DQoNCglpZiAoY3RybHByaXYt
PnZpcnRfZW4gPT0gMSB8fA0KCSAgICAvKg0KCSAgICAgKiBBcHBhcmVudGx5IG9uIGkuTVg4TVEg
aXQgZG9lc24ndCBtYXR0ZXIgaWYgdmlydF9lbiA9PSAxDQoJICAgICAqIGFuZCB0aGUgZm9sbG93
aW5nIHN0ZXBzIHNob3VsZCBiZSBwZXJmb3JtZWQgcmVnYXJkbGVzcw0KCSAgICAgKi8NCgkgICAg
b2ZfbWFjaGluZV9pc19jb21wYXRpYmxlKCJmc2wsaW14OG1xIikpIHsNCgkJY2xyc2V0Yml0c18z
MigmY3RybC0+ZGVjb19yc3IsIDAsIERFQ09SU1JfSlIwKTsNCg0KCQl3aGlsZSAoIShyZF9yZWcz
MigmY3RybC0+ZGVjb19yc3IpICYgREVDT1JTUl9WQUxJRCkgJiYNCgkJICAgICAgIC0tdGltZW91
dCkNCgkJCWNwdV9yZWxheCgpOw0KDQoJCXRpbWVvdXQgPSAxMDAwMDA7DQoJfQ0KDQpSZWdhcmRz
LA0KRnJpZWRlcg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJs
LmMgYi9kcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYw0KPiBpbmRleCBkYjIyNzc3ZDU5YjQuLjFj
ZTAzZjg5NjFiNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMNCj4g
KysrIGIvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMNCj4gQEAgLTUyNyw3ICs1MjcsNyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IHNvY19kZXZpY2VfYXR0cmlidXRlIGNhYW1faW14X3NvY190YWJs
ZVtdID0gew0KPiAgIAl7IC5zb2NfaWQgPSAiaS5NWDZVTCIsIC5kYXRhID0gJmNhYW1faW14NnVs
X2RhdGEgfSwNCj4gICAJeyAuc29jX2lkID0gImkuTVg2KiIsICAuZGF0YSA9ICZjYWFtX2lteDZf
ZGF0YSB9LA0KPiAgIAl7IC5zb2NfaWQgPSAiaS5NWDcqIiwgIC5kYXRhID0gJmNhYW1faW14N19k
YXRhIH0sDQo+IC0JeyAuc29jX2lkID0gImkuTVg4TVEiLCAuZGF0YSA9ICZjYWFtX2lteDdfZGF0
YSB9LA0KPiArCXsgLnNvY19pZCA9ICJpLk1YOE0qIiwgLmRhdGEgPSAmY2FhbV9pbXg3X2RhdGEg
fSwNCj4gICAJeyAuZmFtaWx5ID0gIkZyZWVzY2FsZSBpLk1YIiB9LA0KPiAgIAl7IC8qIHNlbnRp
bmVsICovIH0NCj4gICB9Ow0KPiA=
