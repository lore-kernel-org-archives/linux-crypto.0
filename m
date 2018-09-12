From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH v2 01/12] bus: fsl-mc: add support for dpseci device type
Date: Wed, 12 Sep 2018 09:41:31 +0000
Message-ID: <1d9bd63f-7170-d64a-71bf-07401fde32d3@nxp.com>
References: <20180912085937.22489-1-horia.geanta@nxp.com>
 <20180912085937.22489-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>, Leo Li <leoyang.li@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912085937.22489-2-horia.geanta@nxp.com>
Content-Language: en-US
Content-ID: <1C7E84BA29B47B44BBA8AB945B207911@eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

DQoNCk9uIDEyLjA5LjIwMTggMTE6NTksIEhvcmlhIEdlYW50xIMgd3JvdGU6DQo+IFNpZ25lZC1v
ZmYtYnk6IEhvcmlhIEdlYW50xIMgPGhvcmlhLmdlYW50YUBueHAuY29tPg0KDQpBY2tlZC1ieTog
TGF1cmVudGl1IFR1ZG9yIDxsYXVyZW50aXUudHVkb3JAbnhwLmNvbT4NCg0KPiAtLS0NCj4gICBk
cml2ZXJzL2J1cy9mc2wtbWMvZnNsLW1jLWJ1cy5jIHwgNSArKysrKw0KPiAgIGluY2x1ZGUvbGlu
dXgvZnNsL21jLmggICAgICAgICAgfCA2ICsrKysrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTEg
aW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYnVzL2ZzbC1tYy9mc2wt
bWMtYnVzLmMgYi9kcml2ZXJzL2J1cy9mc2wtbWMvZnNsLW1jLWJ1cy5jDQo+IGluZGV4IDVkODI2
NmM2NTcxZi4uNDU1MmIwNmZlNjAxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2J1cy9mc2wtbWMv
ZnNsLW1jLWJ1cy5jDQo+ICsrKyBiL2RyaXZlcnMvYnVzL2ZzbC1tYy9mc2wtbWMtYnVzLmMNCj4g
QEAgLTE4OCw2ICsxODgsMTAgQEAgc3RydWN0IGRldmljZV90eXBlIGZzbF9tY19idXNfZHBydGNf
dHlwZSA9IHsNCj4gICAJLm5hbWUgPSAiZnNsX21jX2J1c19kcHJ0YyINCj4gICB9Ow0KPiAgIA0K
PiArc3RydWN0IGRldmljZV90eXBlIGZzbF9tY19idXNfZHBzZWNpX3R5cGUgPSB7DQo+ICsJLm5h
bWUgPSAiZnNsX21jX2J1c19kcHNlY2kiDQo+ICt9Ow0KPiArDQo+ICAgc3RhdGljIHN0cnVjdCBk
ZXZpY2VfdHlwZSAqZnNsX21jX2dldF9kZXZpY2VfdHlwZShjb25zdCBjaGFyICp0eXBlKQ0KPiAg
IHsNCj4gICAJc3RhdGljIGNvbnN0IHN0cnVjdCB7DQo+IEBAIC0yMDMsNiArMjA3LDcgQEAgc3Rh
dGljIHN0cnVjdCBkZXZpY2VfdHlwZSAqZnNsX21jX2dldF9kZXZpY2VfdHlwZShjb25zdCBjaGFy
ICp0eXBlKQ0KPiAgIAkJeyAmZnNsX21jX2J1c19kcG1jcF90eXBlLCAiZHBtY3AiIH0sDQo+ICAg
CQl7ICZmc2xfbWNfYnVzX2RwbWFjX3R5cGUsICJkcG1hYyIgfSwNCj4gICAJCXsgJmZzbF9tY19i
dXNfZHBydGNfdHlwZSwgImRwcnRjIiB9LA0KPiArCQl7ICZmc2xfbWNfYnVzX2Rwc2VjaV90eXBl
LCAiZHBzZWNpIiB9LA0KPiAgIAkJeyBOVUxMLCBOVUxMIH0NCj4gICAJfTsNCj4gICAJaW50IGk7
DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ZzbC9tYy5oIGIvaW5jbHVkZS9saW51eC9m
c2wvbWMuaA0KPiBpbmRleCBmMjdjYjE0MDg4YTQuLjUxNjBmMDZmZmJhYyAxMDA2NDQNCj4gLS0t
IGEvaW5jbHVkZS9saW51eC9mc2wvbWMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2ZzbC9tYy5o
DQo+IEBAIC00MDUsNiArNDA1LDcgQEAgZXh0ZXJuIHN0cnVjdCBkZXZpY2VfdHlwZSBmc2xfbWNf
YnVzX2RwY29uX3R5cGU7DQo+ICAgZXh0ZXJuIHN0cnVjdCBkZXZpY2VfdHlwZSBmc2xfbWNfYnVz
X2RwbWNwX3R5cGU7DQo+ICAgZXh0ZXJuIHN0cnVjdCBkZXZpY2VfdHlwZSBmc2xfbWNfYnVzX2Rw
bWFjX3R5cGU7DQo+ICAgZXh0ZXJuIHN0cnVjdCBkZXZpY2VfdHlwZSBmc2xfbWNfYnVzX2RwcnRj
X3R5cGU7DQo+ICtleHRlcm4gc3RydWN0IGRldmljZV90eXBlIGZzbF9tY19idXNfZHBzZWNpX3R5
cGU7DQo+ICAgDQo+ICAgc3RhdGljIGlubGluZSBib29sIGlzX2ZzbF9tY19idXNfZHByYyhjb25z
dCBzdHJ1Y3QgZnNsX21jX2RldmljZSAqbWNfZGV2KQ0KPiAgIHsNCj4gQEAgLTQ1MSw2ICs0NTIs
MTEgQEAgc3RhdGljIGlubGluZSBib29sIGlzX2ZzbF9tY19idXNfZHBydGMoY29uc3Qgc3RydWN0
IGZzbF9tY19kZXZpY2UgKm1jX2RldikNCj4gICAJcmV0dXJuIG1jX2Rldi0+ZGV2LnR5cGUgPT0g
JmZzbF9tY19idXNfZHBydGNfdHlwZTsNCj4gICB9DQo+ICAgDQo+ICtzdGF0aWMgaW5saW5lIGJv
b2wgaXNfZnNsX21jX2J1c19kcHNlY2koY29uc3Qgc3RydWN0IGZzbF9tY19kZXZpY2UgKm1jX2Rl
dikNCj4gK3sNCj4gKwlyZXR1cm4gbWNfZGV2LT5kZXYudHlwZSA9PSAmZnNsX21jX2J1c19kcHNl
Y2lfdHlwZTsNCj4gK30NCj4gKw0KPiAgIC8qDQo+ICAgICogRGF0YSBQYXRoIEJ1ZmZlciBQb29s
IChEUEJQKSBBUEkNCj4gICAgKiBDb250YWlucyBpbml0aWFsaXphdGlvbiBBUElzIGFuZCBydW50
aW1lIGNvbnRyb2wgQVBJcyBmb3IgRFBCUA0KPiA=
