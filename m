From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH -next] crypto: stm32 - remove redundant dev_err call in
 stm32_cryp_probe()
Date: Wed, 17 Jan 2018 13:02:40 +0000
Message-ID: <d2641cbb-61fa-00e7-6ac8-f05d3cde0628@st.com>
References: <1516189224-11877-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1516189224-11877-1-git-send-email-weiyongjun1@huawei.com>
Content-Language: en-US
Content-ID: <C16F6955D8EF284D9599FBC4240A63E9@st.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SGksDQoNCg0KVGhhbmsgeW91IGZvciB0aGUgcGF0Y2guDQoNCg0KT24gMTcvMDEvMTggMTI6NDAs
IFdlaSBZb25nanVuIHdyb3RlOg0KPiBUaGVyZSBpcyBhIGVycm9yIG1lc3NhZ2Ugd2l0aGluIGRl
dm1faW9yZW1hcF9yZXNvdXJjZQ0KPiBhbHJlYWR5LCBzbyByZW1vdmUgdGhlIGRldl9lcnIgY2Fs
bCB0byBhdm9pZCByZWR1bmRhbnQNCj4gZXJyb3IgbWVzc2FnZS4NCj4NCj4gU2lnbmVkLW9mZi1i
eTogV2VpIFlvbmdqdW4gPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+DQpSZXZpZXdlZC1ieTogRmFi
aWVuIERlc3Nlbm5lIDxmYWJpZW4uZGVzc2VubmVAc3QuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJz
L2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmMgfCA0ICstLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmMgYi9kcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1j
cnlwLmMNCj4gaW5kZXggY2YxZGRkYi4uNGEwNmE3YSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9j
cnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL3N0
bTMyLWNyeXAuYw0KPiBAQCAtMTA1MiwxMCArMTA1Miw4IEBAIHN0YXRpYyBpbnQgc3RtMzJfY3J5
cF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIA0KPiAgIAlyZXMgPSBw
bGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9NRU0sIDApOw0KPiAgIAljcnlw
LT5yZWdzID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKGRldiwgcmVzKTsNCj4gLQlpZiAoSVNfRVJS
KGNyeXAtPnJlZ3MpKSB7DQo+IC0JCWRldl9lcnIoZGV2LCAiQ2Fubm90IG1hcCBDUllQIElPXG4i
KTsNCj4gKwlpZiAoSVNfRVJSKGNyeXAtPnJlZ3MpKQ0KPiAgIAkJcmV0dXJuIFBUUl9FUlIoY3J5
cC0+cmVncyk7DQo+IC0JfQ0KPiAgIA0KPiAgIAlpcnEgPSBwbGF0Zm9ybV9nZXRfaXJxKHBkZXYs
IDApOw0KPiAgIAlpZiAoaXJxIDwgMCkgew0KPg0K
