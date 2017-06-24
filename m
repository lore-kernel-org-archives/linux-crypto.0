From: "Albrekht, Ilya" <ilya.albrekht@intel.com>
Subject: RE: [bug] sha1-avx2 and read beyond
Date: Sat, 24 Jun 2017 00:56:52 +0000
Message-ID: <E31A9F2A86F5F543BC6B7554E63385C5504A413B@fmsmsx115.amr.corp.intel.com>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
 <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
 <20170623084330.GA30353@gondor.apana.org.au>
 <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
 <ea4d8991-7452-053e-8e53-8dcb6d28f69d@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Locktyukhin, Maxim" <maxim.locktyukhin@intel.com>,
        "Zohar, Ronen" <ronen.zohar@intel.com>,
        "mouli@linux.intel.com" <mouli@linux.intel.com>,
        "minipli@googlemail.com" <minipli@googlemail.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "marex@denx.de" <marex@denx.de>
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Jan Stancek <jstancek@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10911 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754612AbdFXA4x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 20:56:53 -0400
In-Reply-To: <ea4d8991-7452-053e-8e53-8dcb6d28f69d@linux.intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SGVsbG8gYWxsLA0KDQpJJ20gc29ycnkgZm9yIGxhdGUgcmVwbHkgKEkgd2FzIG91dCBvZiBvZmZp
Y2UgZm9yIGEgbW9udGgpLg0KDQpJdCdzIGJlZW4gYSB3aGlsZSBzaW5jZSB3ZSB0b3VjaGVkIHRo
aXMgY29kZS4gV2UgYXJlIGdvaW5nIHRvIGRvIG91ciBiZXN0IHRvIHN1cHBvcnQgaXQuIEknbGwg
YmUgYmFjayB0byB0aGUgb2ZmaWNlIGVhcmxpZXIgbmV4dCB3ZWVrIGFuZCB3aWxsIGZpZ3VyZSBv
dXQgdGhlIGZpeCBBU0FQLg0KDQpCZXN0IFJlZ2FyZHMsDQpJbHlhIEFsYnJla2h0DQoNCi0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBUaW0gQ2hlbiBbbWFpbHRvOnRpbS5jLmNoZW5A
bGludXguaW50ZWwuY29tXSANClNlbnQ6IEZyaWRheSwgSnVuZSAyMywgMjAxNyA5OjM5IEFNDQpU
bzogSmFuIFN0YW5jZWs7IEhlcmJlcnQgWHU7IG1lZ2hhLmRleUBsaW51eC5pbnRlbC5jb20NCkNj
OiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBBbGJyZWtodCwgSWx5YTsgTG9ja3R5dWto
aW4sIE1heGltOyBab2hhciwgUm9uZW47IG1vdWxpQGxpbnV4LmludGVsLmNvbTsgbWluaXBsaUBn
b29nbGVtYWlsLmNvbTsgaHBhQGxpbnV4LmludGVsLmNvbTsgbWFyZXhAZGVueC5kZQ0KU3ViamVj
dDogUmU6IFtidWddIHNoYTEtYXZ4MiBhbmQgcmVhZCBiZXlvbmQNCg0KT24gMDYvMjMvMjAxNyAw
MTo0OCBBTSwgSmFuIFN0YW5jZWsgd3JvdGU6DQo+IA0KPiANCj4gLS0tLS0gT3JpZ2luYWwgTWVz
c2FnZSAtLS0tLQ0KPj4gT24gV2VkLCBNYXkgMjQsIDIwMTcgYXQgMDg6NDY6NTdBTSAtMDQwMCwg
SmFuIFN0YW5jZWsgd3JvdGU6DQo+Pj4NCj4+Pg0KPj4+IC0tLS0tIE9yaWdpbmFsIE1lc3NhZ2Ug
LS0tLS0NCj4+Pj4gSGksDQo+Pj4+DQo+Pj4+IEknbSBzZWVpbmcgcmFyZSBjcmFzaGVzIGR1cmlu
ZyBORlMgY3Rob24gd2l0aCBrcmI1IGF1dGguIEFmdGVyIHNvbWUgDQo+Pj4+IGRpZ2dpbmcgSSBh
cnJpdmVkIGF0IHBvdGVudGlhbCBwcm9ibGVtIHdpdGggc2hhMS1hdngyLg0KPj4+DQo+Pj4gQWRk
aW5nIG1vcmUgc2hhMV9hdngyIGV4cGVydHMgdG8gQ0MuDQo+Pj4NCj4+Pj4NCj4+Pj4gUHJvYmxl
bSBhcHBlYXJzIHRvIGJlIHRoYXQgc2hhMV90cmFuc2Zvcm1fYXZ4MigpIHJlYWRzIGJleW9uZCAN
Cj4+Pj4gbnVtYmVyIG9mIGJsb2NrcyB5b3UgcGFzcywgaWYgaXQgaXMgYW4gb2RkIG51bWJlci4g
SXQgYXBwZWFycyB0byANCj4+Pj4gdHJ5IHJlYWQgb25lIGJsb2NrIG1vcmUuIFRoaXMgY3JlYXRl
cyBhIHByb2JsZW0gaWYgaXQgZmFsbHMgYmV5b25kIA0KPj4+PiBhIHBhZ2UgYW5kIHRoZXJlJ3Mg
bm90aGluZyB0aGVyZS4NCj4+Pg0KPj4+IEFzIG5vdGVkIGluIG15IHJlcGx5LCB3b3JzdCBjYXNl
IGFwcGVhcnMgdG8gYmUgcmVhZCBhaGVhZCBvZiB1cCB0byAzIA0KPj4+IFNIQTEgYmxvY2tzIGJl
eW9uZCBlbmQgb2YgZGF0YToNCj4+PiAgIGh0dHA6Ly9tYXJjLmluZm8vP2w9bGludXgtY3J5cHRv
LXZnZXImbT0xNDkzNzMzNzEwMjMzNzcNCj4+Pg0KPj4+ICArLS0tLS0tLS0tLSstLS0tLS0tLS0r
LS0tLS0tLS0tKy0tLS0tLS0tLSsNCj4+PiAgfCAyKlNIQTFfQkxPQ0tfU0laRSAgfCAyKlNIQTFf
QkxPQ0tfU0laRSB8ICANCj4+PiArLS0tLS0tLS0tLSstLS0tLS0tLS0rLS0tLS0tLS0tKy0tLS0t
LS0tLSsNCj4+PiAgICAgICAgICAgICBeIHBhZ2UgYm91bmRhcnkNCj4+PiAgICAgXiBkYXRhIGVu
ZA0KPj4+DQo+Pj4gSXQgaXMgc3RpbGwgcmVwcm9kdWNpYmxlIHdpdGggNC4xMi1yYzIuDQo+Pg0K
Pj4gQ2FuIHNvbWVvbmUgZnJvbSBJbnRlbCBwbGVhc2UgbG9vayBpbnRvIHRoaXM/IE90aGVyd2lz
ZSB3ZSdsbCBoYXZlIHRvIA0KPj4gZGlzYWJsZSBzaGEtYXZ4Mi4NCj4gDQo+IFNvIEkgdGFrZSBp
dCBteSB3b3JrYXJvdW5kIHBhdGNoIFsxXSBpcyBub3QgYWNjZXB0YWJsZSBpbiBzaG9ydC10ZXJt
IA0KPiBhcyB3ZWxsPw0KPiANCj4gWzFdIGh0dHA6Ly9tYXJjLmluZm8vP2w9bGludXgtY3J5cHRv
LXZnZXImbT0xNDkzNzMzNzEwMjMzNzcNCj4gDQo+IFJlZ2FyZHMsDQo+IEphbg0KPiANCg0KTWVn
aGEsDQoNCkNhbiB5b3UgdGFrZSBhIGxvb2sgYXQgdGhpcyBpc3N1ZT8NCg0KVGhhbmtzLg0KDQpU
aW0NCg==
