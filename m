From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH] crypto: stm32: fix module device table name
Date: Thu, 30 Nov 2017 11:12:51 +0000
Message-ID: <1a0e7db7-8634-8b2b-12a9-8df6846a1a37@st.com>
References: <20171130110433.15811-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:27251 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750771AbdK3LNa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 06:13:30 -0500
In-Reply-To: <20171130110433.15811-1-clabbe.montjoie@gmail.com>
Content-Language: en-US
Content-ID: <7161F50617F62D458E88C0E482BA994F@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SGkgQ29yZW50aW4NCg0KDQpUaGFuayB5b3UgZm9yIHRoZSBwYXRjaC4NCg0KDQpPbiAzMC8xMS8x
NyAxMjowNCwgQ29yZW50aW4gTGFiYmUgd3JvdGU6DQo+IFRoaXMgcGF0Y2ggZml4IHRoZSBmb2xs
b3dpbmcgYnVpbGQgZmFpbHVyZToNCj4gICAgQ0MgW01dICBkcml2ZXJzL2NyeXB0by9zdG0zMi9z
dG0zMi1jcnlwLm8NCj4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIGRyaXZlcnMvY3J5cHRvL3N0bTMy
L3N0bTMyLWNyeXAuYzoxMTowOg0KPiBkcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmM6
MTA0OToyNTogZXJyb3I6ICdzdGlfZHRfaWRzJyB1bmRlY2xhcmVkIGhlcmUgKG5vdCBpbiBhIGZ1
bmN0aW9uKQ0KPiAgIE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIHN0aV9kdF9pZHMpOw0KPg0KPiBM
ZXQncyByZXBsYWNlIHN0aV9kdF9pZHMgd2l0aCBzdG0zMl9kdF9pZHMgd2hpY2ggaXMganVzdCBk
ZWNsYXJlZA0KPiBiZWZvcmUuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IENvcmVudGluIExhYmJlIDxj
bGFiYmUubW9udGpvaWVAZ21haWwuY29tPg0KDQpSZXZpZXdlZC1ieTogRmFiaWVuIERlc3Nlbm5l
IDxmYWJpZW4uZGVzc2VubmVAc3QuY29tPg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvY3J5cHRvL3N0
bTMyL3N0bTMyLWNyeXAuYyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL3N0bTMy
L3N0bTMyLWNyeXAuYyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyeXAuYw0KPiBpbmRl
eCAwOThmYWQyNjZjNDEuLjE4MDc3ODliMjNmNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlw
dG8vc3RtMzIvc3RtMzItY3J5cC5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMy
LWNyeXAuYw0KPiBAQCAtMTA0Niw3ICsxMDQ2LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9k
ZXZpY2VfaWQgc3RtMzJfZHRfaWRzW10gPSB7DQo+ICAgCXsgLmNvbXBhdGlibGUgPSAic3Qsc3Rt
MzJmNzU2LWNyeXAiLCB9LA0KPiAgIAl7fSwNCj4gICB9Ow0KPiAtTU9EVUxFX0RFVklDRV9UQUJM
RShvZiwgc3RpX2R0X2lkcyk7DQo+ICtNT0RVTEVfREVWSUNFX1RBQkxFKG9mLCBzdG0zMl9kdF9p
ZHMpOw0KPiAgIA0KPiAgIHN0YXRpYyBpbnQgc3RtMzJfY3J5cF9wcm9iZShzdHJ1Y3QgcGxhdGZv
cm1fZGV2aWNlICpwZGV2KQ0KPiAgIHsNCg==
