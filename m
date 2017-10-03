From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH v3 1/3] crypto: engine - permit to enqueue aead_request
Date: Tue, 3 Oct 2017 07:48:08 +0000
Message-ID: <20206811-7075-5ca9-98cd-26a5709751fb@st.com>
References: <1503047946-27799-1-git-send-email-fabien.dessenne@st.com>
 <1503047946-27799-2-git-send-email-fabien.dessenne@st.com>
 <20170922090921.GA15677@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Lionel DEBIEVE <lionel.debieve@st.com>,
        Ludovic BARRE <ludovic.barre@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:11884 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750720AbdJCHsz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 03:48:55 -0400
In-Reply-To: <20170922090921.GA15677@gondor.apana.org.au>
Content-Language: en-US
Content-ID: <6A13099D6F49FD49A41E7B8A50CAC0A1@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gMjIvMDkvMTcgMTE6MDksIEhlcmJlcnQgWHUgd3JvdGU6DQo+IE9uIEZyaSwgQXVnIDE4LCAy
MDE3IGF0IDExOjE5OjA0QU0gKzAyMDAsIEZhYmllbiBEZXNzZW5uZSB3cm90ZToNCj4+IFRoZSBj
dXJyZW50IGNyeXB0byBlbmdpbmUgYWxsb3dzIGFibGtjaXBoZXJfcmVxdWVzdCBhbmQgYWhhc2hf
cmVxdWVzdCB0bw0KPj4gYmUgZW5xdWV1ZWQuIEV4dGVuZCB0aGlzIHRvIGFlYWRfcmVxdWVzdC4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBGYWJpZW4gRGVzc2VubmUgPGZhYmllbi5kZXNzZW5uZUBz
dC5jb20+DQo+IEknZCBsaWtlIHRvIHNlZSB0aGUgY3J5cHRvX2VuZ2luZSBpbnRlcmZhY2UgY2xl
YW5lZCB1cCBhIGxpdHRsZQ0KPiBiZWZvcmUgd2UgZXhwYW5kIGl0IGZ1cnRoZXIuICBQbGVhc2Ug
cmVmZXIgdG8NCj4NCj4gaHR0cHM6Ly93d3cubWFpbC1hcmNoaXZlLmNvbS9saW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnL21zZzE0NzQ0MzQuaHRtbA0KPg0KPiBUaGFua3MsDQpJdCBsb29rcyBs
aWtlIHRoZXJlIGlzIG5vIG1vcmUgYWN0aXZpdHkgYXJvdW5kIHRoaXMgImNyeXB0b19lbmdpbmUg
DQppbnRlcmZhY2UgY2xlYW4gdXAiIHRhc2suDQpUaGlzIHVuZm9ydHVuYXRlbHkgaGFzIGJlZW4g
YmxvY2tpbmcgdGhlIGludHJvZHVjdGlvbiBvZiB0aGlzIG5ldyBTVE0zMiANCmNyeXB0byBkcml2
ZXIgZm9yIDMgbW9udGhzIG5vdy4NCldvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gaGF2ZSB0aGlzIGRy
aXZlciByZXZpZXdlZCBmaXJzdCwgYW5kIHRoZW4gDQpyZXdvcmtlZCAoSSBleHBlY3QgbWlub3Ig
dXBkYXRlIGhlcmUpIHdoZW4gdGhlIGludGVyZmFjZSB1cGRhdGUgaXMgcmVhZHk/DQoNCkJSDQoN
CkZhYmllbg==
