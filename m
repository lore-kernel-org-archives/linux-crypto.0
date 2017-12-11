From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH] crypto: stm32: fix modular build
Date: Mon, 11 Dec 2017 14:31:09 +0000
Message-ID: <cfa89fc5-8604-f92c-5f78-78e461e3e72a@st.com>
References: <20171211114752.3637710-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:7184 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751729AbdLKOcA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 09:32:00 -0500
In-Reply-To: <20171211114752.3637710-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <5A8553FC184C2C4C9F4E30AD8FDDCD61@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SGkgQXJuZCwNCg0KVGhpcyBpc3N1ZSB3YXMgcmVwb3J0ZWQgYSBmZXcgZGF5cyBhZ28sIGFuZCBI
ZXJiZXJ0IGFwcGxpZWQgdGhlIHBhdGNoIDIgDQptaW51dGVzIGJlZm9yZSB5b3Ugc2VuZCB0aGUg
bWFpbCAoc2VlIA0KW2h0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20vbGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZy9tc2cyOTc2Mi5odG1sXSkuDQoNCkFueXdheSwgdGhhbmsgeW91IGZvciBy
ZXBvcnRpbmcgdGhpcy4NCg0KRmFiaWVuDQoNCg0KT24gMTEvMTIvMTcgMTI6NDcsIEFybmQgQmVy
Z21hbm4gd3JvdGU6DQo+IEJ1aWxkaW5nIHRoZSBzdG0zMiBjcnlwdG8gc3Vwb3J0IGFzIGEgbG9h
ZGFibGUgbW9kdWxlIGNhdXNlcyBhIGJ1aWxkDQo+IGZhaWx1cmUgZnJvbSBhIHNpbXBsZSB0eXBv
Og0KPg0KPiBkcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmM6MTAzNToyNTogZXJyb3I6
ICdzdGlfZHRfaWRzJyB1bmRlY2xhcmVkIGhlcmUgKG5vdCBpbiBhIGZ1bmN0aW9uKTsgZGlkIHlv
dSBtZWFuICdzdG0zMl9kdF9pZHMnPw0KPg0KPiBUaGlzIHJlbmFtZXMgdGhlIHJlZmVyZW5jZSB0
byBwb2ludCB0byB0aGUgY29ycmVjdCBzeW1ib2wuDQo+DQo+IEZpeGVzOiA5ZTA1NGVjMjFlZjgg
KCJjcnlwdG86IHN0bTMyIC0gU3VwcG9ydCBmb3IgU1RNMzIgQ1JZUCBjcnlwdG8gbW9kdWxlIikN
Cj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gLS0tDQo+
ICAgZHJpdmVycy9jcnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jIHwgMiArLQ0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jIGIvZHJpdmVycy9jcnlwdG8vc3RtMzIv
c3RtMzItY3J5cC5jDQo+IGluZGV4IDQ1OTc1NTk0MDYzMi4uY2YxZGRkYmVhYTJjIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmMNCj4gKysrIGIvZHJpdmVy
cy9jcnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jDQo+IEBAIC0xMDMyLDcgKzEwMzIsNyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBzdG0zMl9kdF9pZHNbXSA9IHsNCj4gICAJeyAu
Y29tcGF0aWJsZSA9ICJzdCxzdG0zMmY3NTYtY3J5cCIsIH0sDQo+ICAgCXt9LA0KPiAgIH07DQo+
IC1NT0RVTEVfREVWSUNFX1RBQkxFKG9mLCBzdGlfZHRfaWRzKTsNCj4gK01PRFVMRV9ERVZJQ0Vf
VEFCTEUob2YsIHN0bTMyX2R0X2lkcyk7DQo+ICAgDQo+ICAgc3RhdGljIGludCBzdG0zMl9jcnlw
X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgew0K
