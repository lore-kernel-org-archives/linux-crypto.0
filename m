Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:6992
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730397AbeJQBOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 21:14:40 -0400
From: Leonard Crestez <leonard.crestez@nxp.com>
To: "festevam@gmail.com" <festevam@gmail.com>
CC: dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "marek.vasut@gmail.com" <marek.vasut@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] crypto: mxs-dcp - Add support for dcp clk
Date: Tue, 16 Oct 2018 17:23:11 +0000
Message-ID: <f88233e6a76e99f95f6611bccdf234681e84f7ce.camel@nxp.com>
References: <cover.1539705285.git.leonard.crestez@nxp.com>
         <dcbcaf888bbd0a35dcf34228df2d9eb4fd762ea7.1539705286.git.leonard.crestez@nxp.com>
         <CAOMZO5Ck846zd_Xo=9sVK0EAxNLsUsWiC59H2Ms6x8xoD8iwWw@mail.gmail.com>
In-Reply-To: <CAOMZO5Ck846zd_Xo=9sVK0EAxNLsUsWiC59H2Ms6x8xoD8iwWw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <55D657036B547E4D91B7FD5CB5FEA6B4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gVHVlLCAyMDE4LTEwLTE2IGF0IDEzOjAzIC0wMzAwLCBGYWJpbyBFc3RldmFtIHdyb3RlOg0K
PiA+ICsgICAgICAgLyogRENQIGNsb2NrIGlzIG9wdGlvbmFsLCBvbmx5IHVzZWQgb24gc29tZSBT
T0NzICovDQo+ID4gKyAgICAgICBzZGNwLT5kY3BfY2xrID0gZGV2bV9jbGtfZ2V0KGRldiwgImRj
cCIpOw0KPiA+ICsgICAgICAgaWYgKElTX0VSUihzZGNwLT5kY3BfY2xrKSkgew0KPiA+ICsgICAg
ICAgICAgICAgICBpZiAoc2RjcC0+ZGNwX2NsayAhPSBFUlJfUFRSKC1FTk9FTlQpKQ0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKHNkY3AtPmRjcF9jbGspOw0KPiA+
ICsgICAgICAgICAgICAgICBzZGNwLT5kY3BfY2xrID0gTlVMTDsNCj4gDQo+IFRoaXMgZGNwX2Ns
ayBhc3NpZ25tZW50IHRvIE5VTEwgZG9lcyBub3Qgc2VlbSB0byBiZSBuZWNlc3NhcnkuDQoNClRo
ZSBjbGsgQVBJIGlnbm9yZXMgYWxsIGNhbGxzIGlmIGNsayA9PSBOVUxMICh3aGljaCBpcyB2ZXJ5
IG5pY2UpIGJ1dA0Kbm90IGlmIElTX0VSUihjbGspLiBTZXR0aW5nIGRjcF9jbGsgdG8gTlVMTCBh
dm9pZHMgc3ByaW5rbGluZyBvdGhlcg0KY2hlY2tzLg0KDQo+ID4gKyAgICAgICByZXQgPSBjbGtf
cHJlcGFyZV9lbmFibGUoc2RjcC0+ZGNwX2Nsayk7DQo+ID4gKyAgICAgICBpZiAocmV0KQ0KPiA+
ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+IA0KPiA+ICAgICAgICAgcmV0ID0gZGV2
bV9yZXF1ZXN0X2lycShkZXYsIGRjcF92bWlfaXJxLCBteHNfZGNwX2lycSwgMCwNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgImRjcC12bWktaXJxIiwgc2RjcCk7DQo+ID4gICAg
ICAgICBpZiAocmV0KSB7DQo+ID4gICAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAiRmFpbGVk
IHRvIGNsYWltIERDUCBWTUkgSVJRIVxuIik7DQo+IA0KPiBJbiBjYXNlIG9mIHN1YnNlcXVlbnQg
ZXJyb3JzIHlvdSBzaG91bGQgY2FsbA0KPiBjbGtfZGlzYWJsZV91bnByZXBhcmUoc2RjcC0+ZGNw
X2NsaykuDQoNClllcywgd2lsbCByZXNlbmQuIE1heWJlIHNvbWUgZGF5IGNsayBjb25zdW1lciB3
aWxsIGF1dG9tYXRpY2FsbHkgdW5kbw0KcGVuZGluZyBwcmVwYXJlL2VuYWJsZXMgb24gcmVsZWFz
ZT8NCg==
