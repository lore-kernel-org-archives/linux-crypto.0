From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH 6/6] crypto: stm32-cryp: convert to the new crypto engine
 API
Date: Thu, 11 Jan 2018 07:45:25 +0000
Message-ID: <2b382b5d-8dc5-b414-99d5-d42c1ed6a3cf@st.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
 <20180103201109.16077-7-clabbe.montjoie@gmail.com>
 <ccffd847-3df7-d690-4102-5a10f6439f87@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org"
        <virtualization@lists.linux-foundation.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "mst@redhat.com" <mst@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:59115 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932100AbeAKHqF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 02:46:05 -0500
In-Reply-To: <ccffd847-3df7-d690-4102-5a10f6439f87@st.com>
Content-Language: en-US
Content-ID: <5758224F1ECE1448A16066F9657450AA@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

KEFkZGluZyBteSB0ZXN0ZWQgYnkpDQoNCg0KT24gMTAvMDEvMTggMTU6MjUsIEZhYmllbiBERVNT
RU5ORSB3cm90ZToNCj4NCj4gT24gMDMvMDEvMTggMjE6MTEsIENvcmVudGluIExhYmJlIHdyb3Rl
Og0KPj4gVGhpcyBwYXRjaCBjb252ZXJ0IHRoZSBzdG0zMi1jcnlwIGRyaXZlciB0byB0aGUgbmV3
IGNyeXB0byBlbmdpbmUgQVBJLg0KPj4gU2lnbmVkLW9mZi1ieTogQ29yZW50aW4gTGFiYmUgPGNs
YWJiZS5tb250am9pZUBnbWFpbC5jb20+DQoNClRlc3RlZC1ieTogRmFiaWVuIERlc3Nlbm5lIDxm
YWJpZW4uZGVzc2VubmVAc3QuY29tPg0KDQo+PiAtLS0NCj4+ICAgIGRyaXZlcnMvY3J5cHRvL3N0
bTMyL3N0bTMyLWNyeXAuYyB8IDIxICsrKysrKysrKysrKysrKystLS0tLQ0KPj4gICAgMSBmaWxl
IGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyeXAuYyBiL2RyaXZlcnMvY3J5cHRv
L3N0bTMyL3N0bTMyLWNyeXAuYw0KPj4gaW5kZXggY2YxZGRkYmVhYTJjLi45OWUwNDczZWYyNDcg
MTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmMNCj4+ICsr
KyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyeXAuYw0KPj4gQEAgLTkxLDYgKzkxLDcg
QEANCj4+ICAgICNkZWZpbmUgX3dhbGtlZF9vdXQgICAgICAgICAgICAgKGNyeXAtPm91dF93YWxr
Lm9mZnNldCAtIGNyeXAtPm91dF9zZy0+b2Zmc2V0KQ0KPj4gICAgDQo+PiAgICBzdHJ1Y3Qgc3Rt
MzJfY3J5cF9jdHggew0KPj4gKwlzdHJ1Y3QgY3J5cHRvX2VuZ2luZV9yZXFjdHggZW5naW5lY3R4
Ow0KPj4gICAgCXN0cnVjdCBzdG0zMl9jcnlwICAgICAgICpjcnlwOw0KPj4gICAgCWludCAgICAg
ICAgICAgICAgICAgICAgIGtleWxlbjsNCj4+ICAgIAl1MzIgICAgICAgICAgICAgICAgICAgICBr
ZXlbQUVTX0tFWVNJWkVfMjU2IC8gc2l6ZW9mKHUzMildOw0KPj4gQEAgLTQ5NCwxMCArNDk1LDIw
IEBAIHN0YXRpYyBpbnQgc3RtMzJfY3J5cF9jcHVfc3RhcnQoc3RydWN0IHN0bTMyX2NyeXAgKmNy
eXApDQo+PiAgICAJcmV0dXJuIDA7DQo+PiAgICB9DQo+PiAgICANCj4+ICtzdGF0aWMgaW50IHN0
bTMyX2NyeXBfY2lwaGVyX29uZV9yZXEoc3RydWN0IGNyeXB0b19lbmdpbmUgKmVuZ2luZSwNCj4+
ICsJCQkJICAgICB2b2lkICphcmVxKTsNCj4gTWVyZ2UgdGhlc2UgMiBsaW5lcyBpbiBhIHNpbmds
ZSBvbmUNCj4NCj4+ICtzdGF0aWMgaW50IHN0bTMyX2NyeXBfcHJlcGFyZV9jaXBoZXJfcmVxKHN0
cnVjdCBjcnlwdG9fZW5naW5lICplbmdpbmUsDQo+PiArCQkJCQkgdm9pZCAqYXJlcSk7DQo+PiAr
DQo+PiAgICBzdGF0aWMgaW50IHN0bTMyX2NyeXBfY3JhX2luaXQoc3RydWN0IGNyeXB0b190Zm0g
KnRmbSkNCj4+ICAgIHsNCj4+ICsJc3RydWN0IHN0bTMyX2NyeXBfY3R4ICpjdHggPSBjcnlwdG9f
dGZtX2N0eCh0Zm0pOw0KPj4gKw0KPj4gICAgCXRmbS0+Y3J0X2FibGtjaXBoZXIucmVxc2l6ZSA9
IHNpemVvZihzdHJ1Y3Qgc3RtMzJfY3J5cF9yZXFjdHgpOw0KPj4gICAgDQo+PiArCWN0eC0+ZW5n
aW5lY3R4Lm9wLmRvX29uZV9yZXF1ZXN0ID0gc3RtMzJfY3J5cF9jaXBoZXJfb25lX3JlcTsNCj4+
ICsJY3R4LT5lbmdpbmVjdHgub3AucHJlcGFyZV9yZXF1ZXN0ID0gc3RtMzJfY3J5cF9wcmVwYXJl
X2NpcGhlcl9yZXE7DQo+PiArCWN0eC0+ZW5naW5lY3R4Lm9wLnVucHJlcGFyZV9yZXF1ZXN0ID0g
TlVMTDsNCj4+ICAgIAlyZXR1cm4gMDsNCj4+ICAgIH0NCj4+ICAgIA0KPj4gQEAgLTY5NSwxNCAr
NzA2LDE3IEBAIHN0YXRpYyBpbnQgc3RtMzJfY3J5cF9wcmVwYXJlX3JlcShzdHJ1Y3QgY3J5cHRv
X2VuZ2luZSAqZW5naW5lLA0KPj4gICAgfQ0KPj4gICAgDQo+PiAgICBzdGF0aWMgaW50IHN0bTMy
X2NyeXBfcHJlcGFyZV9jaXBoZXJfcmVxKHN0cnVjdCBjcnlwdG9fZW5naW5lICplbmdpbmUsDQo+
PiAtCQkJCQkgc3RydWN0IGFibGtjaXBoZXJfcmVxdWVzdCAqcmVxKQ0KPj4gKwkJCQkJIHZvaWQg
KmFyZXEpDQo+PiAgICB7DQo+PiArCXN0cnVjdCBhYmxrY2lwaGVyX3JlcXVlc3QgKnJlcSA9IGNv
bnRhaW5lcl9vZihhcmVxLCBzdHJ1Y3QgYWJsa2NpcGhlcl9yZXF1ZXN0LCBiYXNlKTsNCj4gICA+
IDgwIGNoYXJhY3RlcnMgKENIRUNLUEFUQ0gpDQo+DQo+PiArDQo+PiAgICAJcmV0dXJuIHN0bTMy
X2NyeXBfcHJlcGFyZV9yZXEoZW5naW5lLCByZXEpOw0KPj4gICAgfQ0KPj4gICAgDQo+PiAgICBz
dGF0aWMgaW50IHN0bTMyX2NyeXBfY2lwaGVyX29uZV9yZXEoc3RydWN0IGNyeXB0b19lbmdpbmUg
KmVuZ2luZSwNCj4+IC0JCQkJICAgICBzdHJ1Y3QgYWJsa2NpcGhlcl9yZXF1ZXN0ICpyZXEpDQo+
PiArCQkJCSAgICAgdm9pZCAqYXJlcSkNCj4gTWVyZ2UgdGhlc2UgMiBsaW5lcyBpbiBhIHNpbmds
ZSBvbmUNCj4NCj4+ICAgIHsNCj4+ICsJc3RydWN0IGFibGtjaXBoZXJfcmVxdWVzdCAqcmVxID0g
Y29udGFpbmVyX29mKGFyZXEsIHN0cnVjdCBhYmxrY2lwaGVyX3JlcXVlc3QsIGJhc2UpOw0KPiAg
ID4gODAgY2hhcmFjdGVycyAoQ0hFQ0tQQVRDSCkNCj4NCj4+ICAgIAlzdHJ1Y3Qgc3RtMzJfY3J5
cF9jdHggKmN0eCA9IGNyeXB0b19hYmxrY2lwaGVyX2N0eCgNCj4+ICAgIAkJCWNyeXB0b19hYmxr
Y2lwaGVyX3JlcXRmbShyZXEpKTsNCj4+ICAgIAlzdHJ1Y3Qgc3RtMzJfY3J5cCAqY3J5cCA9IGN0
eC0+Y3J5cDsNCj4+IEBAIC0xMTA0LDkgKzExMTgsNiBAQCBzdGF0aWMgaW50IHN0bTMyX2NyeXBf
cHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4+ICAgIAkJZ290byBlcnJfZW5n
aW5lMTsNCj4+ICAgIAl9DQo+PiAgICANCj4+IC0JY3J5cC0+ZW5naW5lLT5wcmVwYXJlX2NpcGhl
cl9yZXF1ZXN0ID0gc3RtMzJfY3J5cF9wcmVwYXJlX2NpcGhlcl9yZXE7DQo+PiAtCWNyeXAtPmVu
Z2luZS0+Y2lwaGVyX29uZV9yZXF1ZXN0ID0gc3RtMzJfY3J5cF9jaXBoZXJfb25lX3JlcTsNCj4+
IC0NCj4+ICAgIAlyZXQgPSBjcnlwdG9fZW5naW5lX3N0YXJ0KGNyeXAtPmVuZ2luZSk7DQo+PiAg
ICAJaWYgKHJldCkgew0KPj4gICAgCQlkZXZfZXJyKGRldiwgIkNvdWxkIG5vdCBzdGFydCBjcnlw
dG8gZW5naW5lXG4iKTsNCg==
