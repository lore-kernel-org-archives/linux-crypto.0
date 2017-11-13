From: Fabien DESSENNE <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Subject: Re: [PATCH v5 2/2] crypto: stm32 - Support for STM32 CRYP crypto
 module
Date: Mon, 13 Nov 2017 10:30:40 +0000
Message-ID: <774a92f2-af70-0424-b066-0cc1db3f9ab0@st.com>
References: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
 <1508425830-13565-3-git-send-email-fabien.dessenne@st.com>
 <20171022072659.GB8489@Red> <d924a278-90d0-969e-f1ae-a12f92e8972d@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre TORGUE <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Lionel DEBIEVE <lionel.debieve-qxv4g6HH51o@public.gmane.org>,
        Benjamin GAIGNARD <benjamin.gaignard-qxv4g6HH51o@public.gmane.org>,
        Ludovic BARRE <ludovic.barre-qxv4g6HH51o@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d924a278-90d0-969e-f1ae-a12f92e8972d-qxv4g6HH51o@public.gmane.org>
Content-Language: en-US
Content-ID: <32DFA78EC06AD043AC672D4861F49477-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

SGkgSGVyYmVydCwNCg0KQ2FuIHlvdSBjaGVjayBpZiB0aGlzIHBhdGNoc2V0IChyZW1vdmVkIHRo
ZSBBRUFEIHBhcnQgYXMgeW91IHN1Z2dlc3RlZCArIA0KbGlia2NhcGkgdGVzdCBPSyBhcyBzdWdn
ZXN0ZWQgYnkgQ29yZW50aW4pIGNhbiBiZSBhcHBsaWVkIG5vdz8NCg0KQlINCg0KRmFiaWVuDQoN
Cg0KT24gMDcvMTEvMTcgMTU6NDAsIEZhYmllbiBERVNTRU5ORSB3cm90ZToNCj4NCj4gT24gMjIv
MTAvMTcgMDk6MjYsIENvcmVudGluIExhYmJlIHdyb3RlOg0KPj4gT24gVGh1LCBPY3QgMTksIDIw
MTcgYXQgMDU6MTA6MzBQTSArMDIwMCwgRmFiaWVuIERlc3Nlbm5lIHdyb3RlOg0KPj4+IFRoaXMg
bW9kdWxlIHJlZ2lzdGVycyBibG9jayBjaXBoZXIgYWxnb3JpdGhtcyB0aGF0IG1ha2UgdXNlIG9m
IHRoZQ0KPj4+IFNUTWljcm9lbGVjdHJvbmljcyBTVE0zMiBjcnlwdG8gIkNSWVAxIiBoYXJkd2Fy
ZS4NCj4+PiBUaGUgZm9sbG93aW5nIGFsZ29yaXRobXMgYXJlIHN1cHBvcnRlZDoNCj4+PiAtIGFl
czogZWNiLCBjYmMsIGN0cg0KPj4+IC0gZGVzOiBlY2IsIGNiYw0KPj4+IC0gdGRlczogZWNiLCBj
YmMNCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEZhYmllbiBEZXNzZW5uZSA8ZmFiaWVuLmRlc3Nl
bm5lQHN0LmNvbT4NCj4+PiAtLS0NCj4+PiAgICBkcml2ZXJzL2NyeXB0by9zdG0zMi9LY29uZmln
ICAgICAgfCAgICA5ICsNCj4+PiAgICBkcml2ZXJzL2NyeXB0by9zdG0zMi9NYWtlZmlsZSAgICAg
fCAgICAzICstDQo+Pj4gICAgZHJpdmVycy9jcnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jIHwgMTE3
MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+Pj4gICAgMyBmaWxlcyBj
aGFuZ2VkLCAxMTgzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+PiAgICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9jcnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jDQo+Pj4NCj4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vc3RtMzIvS2NvbmZpZyBiL2RyaXZlcnMvY3J5cHRv
L3N0bTMyL0tjb25maWcNCj4+PiArc3RhdGljIHZvaWQgc3RtMzJfY3J5cF9pcnFfd3JpdGVfYmxv
Y2soc3RydWN0IHN0bTMyX2NyeXAgKmNyeXApDQo+Pj4gK3sNCj4+PiArCXVuc2lnbmVkIGludCBp
LCBqOw0KPj4+ICsJdTMyICpzcmM7DQo+Pj4gKwl1OCBkOFs0XTsNCj4+PiArDQo+Pj4gKwlzcmMg
PSBzZ192aXJ0KGNyeXAtPmluX3NnKSArIF93YWxrZWRfaW47DQo+Pj4gKw0KPj4+ICsJZm9yIChp
ID0gMDsgaSA8IGNyeXAtPmh3X2Jsb2Nrc2l6ZSAvIHNpemVvZih1MzIpOyBpKyspIHsNCj4+PiAr
CQlpZiAobGlrZWx5KGNyeXAtPnRvdGFsX2luID49IHNpemVvZih1MzIpKSkgew0KPj4+ICsJCQkv
KiBXcml0ZSBhIGZ1bGwgdTMyICovDQo+Pj4gKwkJCXN0bTMyX2NyeXBfd3JpdGUoY3J5cCwgQ1JZ
UF9ESU4sICpzcmMpOw0KPj4gSGVsbG8NCj4+DQo+PiBUcnkgYWxzbyB0byB0ZXN0IHlvdXIgZHJp
dmVyIHdpdGggdXNlcnNwYWNlIHZpYSBBRl9BTEcgKGxpYmtjYXBpIGlzIGEgZ29vZCBzdGFydCku
DQo+PiBJdCBzaG91bGQgcHJvYmFibHkgY3Jhc2ggaGVyZS4NCj4+IEkgaGF2ZSBkbyB0aGUgc2Ft
ZSBvbiBteSBmaXJzdCBzdW54aS1zcyBkcml2ZXIgYW5kIHlvdSBzaG91bGQgdXNlIGttYXAoKS4N
Cj4+DQo+PiBSZWdhcmRzDQo+IEhpIENvcmVudGluLA0KPg0KPiBUaGFuayB5b3UgZm9yIHN1Z2dl
c3RpbmcgdG8gdGVzdCBmcm9tIHVzZXJzcGFjZSB0aHJvdWdoIHRoZSBBRl9BTEcNCj4gc29ja2V0
IHdpdGggbGlia2NhcGkuDQo+IFRoaXMgaW5jcmVhc2VzIG15IHRlc3QgY292ZXJhZ2UuDQo+DQo+
IEkgcmFuIHRoZSBtaXNjZWxsYW5lb3VzIHRlc3RzIChrY2FwaS1lbmMtdGVzdChsYXJnZSkuc2gg
KyB0ZXN0LnNoKSBhbmQNCj4gY291bGQgbm90IG9ic2VydmUgYW55IGNyYXNoLg0KPiBOb3RlIHRo
YXQgSSBoYWQgYWxyZWFkeSBmaXhlZCBzb21lICdtZW1vcnkgY3Jhc2hlcycgd2hpbGUgdGVzdGlu
ZyB3aXRoDQo+IHRlc3RtZ3IgLyB0Y3J5cHQgd2hpbGUgdGVzdGluZyBmcm9tIHRoZSBrZXJuZWwu
DQo+DQo+IFNvIGl0IGxvb2tzIGxpa2UgdGhlIHByb3Bvc2VkIGltcGxlbWVudGF0aW9uIGlzIGZp
bmUuDQo+DQo+IEJSDQo+DQo+IEZhYmllbg0K
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
