From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH] crypto: stm32 - Use standard CONFIG name
Date: Fri, 22 Dec 2017 08:17:51 +0000
Message-ID: <05d7ef21-50a5-8203-00b3-85cc17ca4a97@st.com>
References: <1513793972-11173-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net >> David S . Miller" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Lionel DEBIEVE <lionel.debieve@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:49651 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751069AbdLVISV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:18:21 -0500
In-Reply-To: <1513793972-11173-1-git-send-email-clabbe@baylibre.com>
Content-Language: en-US
Content-ID: <19CC72A07F88F340B880C452C9219AE8@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SGkgQ29yZW50aW4NCg0KDQpUaGFuayB5b3UgZm9yIHRoZSBwYXRjaC4NCg0KDQpPbiAyMC8xMi8x
NyAxOToxOSwgQ29yZW50aW4gTGFiYmUgd3JvdGU6DQo+IEFsbCBoYXJkd2FyZSBjcnlwdG8gZGV2
aWNlcyBoYXZlIHRoZWlyIENPTkZJRyBuYW1lcyB1c2luZyB0aGUgZm9sbG93aW5nDQo+IGNvbnZl
bnRpb246DQo+IENSWVBUT19ERVZfbmFtZV9hbGdvDQo+DQo+IFRoaXMgcGF0Y2ggYXBwbHkgdGhp
cyBjb252ZW50aW9ucyBvbiBTVE0zMiBDT05GSUcgbmFtZXMuDQo+DQo+IFNpZ25lZC1vZmYtYnk6
IENvcmVudGluIExhYmJlIDxjbGFiYmVAYmF5bGlicmUuY29tPg0KUmV2aWV3ZWQtYnk6IEZhYmll
biBEZXNzZW5uZSA8ZmFiaWVuLmRlc3Nlbm5lQHN0LmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9j
cnlwdG8vc3RtMzIvS2NvbmZpZyAgfCA2ICsrKy0tLQ0KPiAgIGRyaXZlcnMvY3J5cHRvL3N0bTMy
L01ha2VmaWxlIHwgNiArKystLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KSwgNiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL3N0bTMy
L0tjb25maWcgYi9kcml2ZXJzL2NyeXB0by9zdG0zMi9LY29uZmlnDQo+IGluZGV4IDYxZWYwMGI2
YmY0NS4uNjNhYTc4YzBiMTJiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9zdG0zMi9L
Y29uZmlnDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL0tjb25maWcNCj4gQEAgLTEsNCAr
MSw0IEBADQo+IC1jb25maWcgQ1JDX0RFVl9TVE0zMg0KPiArY29uZmlnIENSWVBUT19ERVZfU1RN
MzJfQ1JDDQo+ICAgCXRyaXN0YXRlICJTdXBwb3J0IGZvciBTVE0zMiBjcmMgYWNjZWxlcmF0b3Jz
Ig0KPiAgIAlkZXBlbmRzIG9uIEFSQ0hfU1RNMzINCj4gICAJc2VsZWN0IENSWVBUT19IQVNIDQo+
IEBAIC02LDcgKzYsNyBAQCBjb25maWcgQ1JDX0RFVl9TVE0zMg0KPiAgICAgICAgICAgICBUaGlz
IGVuYWJsZXMgc3VwcG9ydCBmb3IgdGhlIENSQzMyIGh3IGFjY2VsZXJhdG9yIHdoaWNoIGNhbiBi
ZSBmb3VuZA0KPiAgIAkgIG9uIFNUTWljcm9lbGVjdHJvbmljcyBTVE0zMiBTT0MuDQo+ICAgDQo+
IC1jb25maWcgSEFTSF9ERVZfU1RNMzINCj4gK2NvbmZpZyBDUllQVE9fREVWX1NUTTMyX0hBU0gN
Cj4gICAJdHJpc3RhdGUgIlN1cHBvcnQgZm9yIFNUTTMyIGhhc2ggYWNjZWxlcmF0b3JzIg0KPiAg
IAlkZXBlbmRzIG9uIEFSQ0hfU1RNMzINCj4gICAJZGVwZW5kcyBvbiBIQVNfRE1BDQo+IEBAIC0x
OSw3ICsxOSw3IEBAIGNvbmZpZyBIQVNIX0RFVl9TVE0zMg0KPiAgICAgICAgICAgICBUaGlzIGVu
YWJsZXMgc3VwcG9ydCBmb3IgdGhlIEhBU0ggaHcgYWNjZWxlcmF0b3Igd2hpY2ggY2FuIGJlIGZv
dW5kDQo+ICAgCSAgb24gU1RNaWNyb2VsZWN0cm9uaWNzIFNUTTMyIFNPQy4NCj4gICANCj4gLWNv
bmZpZyBDUllQX0RFVl9TVE0zMg0KPiArY29uZmlnIENSWVBUT19ERVZfU1RNMzJfQ1JZUA0KPiAg
IAl0cmlzdGF0ZSAiU3VwcG9ydCBmb3IgU1RNMzIgY3J5cCBhY2NlbGVyYXRvcnMiDQo+ICAgCWRl
cGVuZHMgb24gQVJDSF9TVE0zMg0KPiAgIAlzZWxlY3QgQ1JZUFRPX0hBU0gNCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3J5cHRvL3N0bTMyL01ha2VmaWxlIGIvZHJpdmVycy9jcnlwdG8vc3RtMzIv
TWFrZWZpbGUNCj4gaW5kZXggMmMxOWZjMTU1YmZkLi41M2QxYmI5NGIyMjEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvY3J5cHRvL3N0bTMyL01ha2VmaWxlDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRv
L3N0bTMyL01ha2VmaWxlDQo+IEBAIC0xLDMgKzEsMyBAQA0KPiAtb2JqLSQoQ09ORklHX0NSQ19E
RVZfU1RNMzIpICs9IHN0bTMyX2NyYzMyLm8NCj4gLW9iai0kKENPTkZJR19IQVNIX0RFVl9TVE0z
MikgKz0gc3RtMzItaGFzaC5vDQo+IC1vYmotJChDT05GSUdfQ1JZUF9ERVZfU1RNMzIpICs9IHN0
bTMyLWNyeXAubw0KPiArb2JqLSQoQ09ORklHX0NSWVBUT19ERVZfU1RNMzJfQ1JDKSArPSBzdG0z
Ml9jcmMzMi5vDQo+ICtvYmotJChDT05GSUdfQ1JZUFRPX0RFVl9TVE0zMl9IQVNIKSArPSBzdG0z
Mi1oYXNoLm8NCj4gK29iai0kKENPTkZJR19DUllQVE9fREVWX1NUTTMyX0NSWVApICs9IHN0bTMy
LWNyeXAubw0K
