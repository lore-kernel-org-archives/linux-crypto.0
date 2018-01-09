From: Anson Huang <anson.huang@nxp.com>
Subject: RE: [PATCH V2 2/2] ARM: dts: imx7s: add snvs rtc clock
Date: Tue, 9 Jan 2018 09:36:00 +0000
Message-ID: <AM3PR04MB1315C4E150966727F46A4029F5100@AM3PR04MB1315.eurprd04.prod.outlook.com>
References: <1515466276-5541-1-git-send-email-Anson.Huang@nxp.com>
 <1515466276-5541-2-git-send-email-Anson.Huang@nxp.com>
 <CAOMZO5DKsgydHaoKrrRngMck_9aQqFja9SParvDiD6V79ryuHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "Russell King - ARM Linux" <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Adriana Reus <adriana.reus@nxp.com>,
        Stefan Agner <stefan@agner.ch>,
        Dong Aisheng <dongas86@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linu
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOMZO5DKsgydHaoKrrRngMck_9aQqFja9SParvDiD6V79ryuHg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

DQoNCkJlc3QgUmVnYXJkcyENCkFuc29uIEh1YW5nDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiBGcm9tOiBGYWJpbyBFc3RldmFtIFttYWlsdG86ZmVzdGV2YW1AZ21haWwuY29t
XQ0KPiBTZW50OiAyMDE4LTAxLTA5IDU6MjcgUE0NCj4gVG86IEFuc29uIEh1YW5nIDxhbnNvbi5o
dWFuZ0BueHAuY29tPg0KPiBDYzogSG9yaWEgR2VhbnTEgyA8aG9yaWEuZ2VhbnRhQG54cC5jb20+
OyBBeW1lbiBTZ2hhaWVyDQo+IDxheW1lbi5zZ2hhaWVyQG54cC5jb20+OyBIZXJiZXJ0IFh1IDxo
ZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+Ow0KPiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBSb2IgSGVycmluZyA8cm9iaCtkdEBrZXJuZWwub3JnPjsNCj4gTWFyayBS
dXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT47IFNoYXduIEd1byA8c2hhd25ndW9Aa2VybmVs
Lm9yZz47DQo+IFNhc2NoYSBIYXVlciA8a2VybmVsQHBlbmd1dHJvbml4LmRlPjsgRmFiaW8gRXN0
ZXZhbQ0KPiA8ZmFiaW8uZXN0ZXZhbUBueHAuY29tPjsgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4
IDxsaW51eEBhcm1saW51eC5vcmcudWs+Ow0KPiBNaWNoYWVsIFR1cnF1ZXR0ZSA8bXR1cnF1ZXR0
ZUBiYXlsaWJyZS5jb20+OyBTdGVwaGVuIEJveWQNCj4gPHNib3lkQGNvZGVhdXJvcmEub3JnPjsg
QWRyaWFuYSBSZXVzIDxhZHJpYW5hLnJldXNAbnhwLmNvbT47IFN0ZWZhbg0KPiBBZ25lciA8c3Rl
ZmFuQGFnbmVyLmNoPjsgRG9uZyBBaXNoZW5nIDxkb25nYXM4NkBnbWFpbC5jb20+OyBvcGVuDQo+
IGxpc3Q6T1BFTiBGSVJNV0FSRSBBTkQgRkxBVFRFTkVEIERFVklDRSBUUkVFIEJJTkRJTkdTDQo+
IDxkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZz47IGxpbnV4LWNsa0B2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOyBtb2RlcmF0ZWQgbGlzdDpBUk0vRlJF
RVNDQUxFIElNWCAvIE1YQyBBUk0NCj4gQVJDSElURUNUVVJFIDxsaW51eC1hcm0ta2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmc+OyBsaW51eC1rZXJuZWwgPGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5r
ZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIDIvMl0gQVJNOiBkdHM6IGlteDdz
OiBhZGQgc252cyBydGMgY2xvY2sNCj4gDQo+IEhpIEFuc29uLA0KPiANCj4gT24gVHVlLCBKYW4g
OSwgMjAxOCBhdCAxMjo1MSBBTSwgQW5zb24gSHVhbmcgPEFuc29uLkh1YW5nQG54cC5jb20+DQo+
IHdyb3RlOg0KPiANCj4gPiArICAgLSBjbG9ja3MNCj4gPiArICAgICAgVXNhZ2U6IHJlcXVpcmVk
IGlmIFNOVlMgTFAgUlRDIHJlcXVpcmVzIGV4cGxpY2l0IGVuYWJsZW1lbnQgb2YgY2xvY2tzDQo+
ID4gKyAgICAgIFZhbHVlIHR5cGU6IDxwcm9wX2VuY29kZWQtYXJyYXk+DQo+ID4gKyAgICAgIERl
ZmluaXRpb246ICBBIGxpc3Qgb2YgcGhhbmRsZSBhbmQgY2xvY2sgc3BlY2lmaWVyIHBhaXJzIGRl
c2NyaWJpbmcNCj4gPiArICAgICAgICAgIHRoZSBjbG9ja3MgcmVxdWlyZWQgZm9yIGVuYWJsaW5n
IGFuZCBkaXNhYmxpbmcgU05WUyBMUCBSVEMuDQo+IA0KPiANCj4gSXQgaXMgYSBzaW5nbGUgY2xv
Y2sgdGhhdCBpcyB1c2VkIGhlcmUsIHNvIGl0IHdvdWxkIGJlIGJldHRlciB0byBkZXNjcmliZSB0
aGUgdGV4dCBhczoNCj4gDQo+ICAgICAgIERlZmluaXRpb246ICBBIGNsb2NrIHNwZWNpZmllciBk
ZXNjcmliaW5nIHRoZSBjbG9jayByZXF1aXJlZCBmb3IgZW5hYmxpbmcgYW5kDQo+IGRpc2FibGlu
ZyBTTlZTIExQIFJUQw0KPiANCj4gPiArICAgLSBjbG9jay1uYW1lcw0KPiA+ICsgICAgICBVc2Fn
ZTogcmVxdWlyZWQgaWYgU05WUyBMUCBSVEMgcmVxdWlyZXMgZXhwbGljaXQgZW5hYmxlbWVudCBv
ZiBjbG9ja3MNCj4gPiArICAgICAgVmFsdWUgdHlwZTogPHN0cmluZz4NCj4gPiArICAgICAgRGVm
aW5pdGlvbjogQSBsaXN0IG9mIGNsb2NrIG5hbWUgc3RyaW5ncyBpbiB0aGUgc2FtZSBvcmRlciBh
cyB0aGUNCj4gPiArICAgICAgICAgIGNsb2NrcyBwcm9wZXJ0eS4NCj4gDQo+IGFuZCBoZXJlIHlv
dSBtdXN0IGRlc2NyaWJlIHRoYXQgdGhlIG5hbWUgc2hvdWxkIGJlICJzbnZzLXJ0YyI6DQo+IA0K
PiAgICAgICBEZWZpbml0aW9uOiBDbG9jayBuYW1lIHN0cmluZyBzaG91bGQgYmUgInNudnMtcnRj
Ii4NCg0KDQpBZ3JlZSwgdGhhbmtzLiBXaWxsIHJlc2VuZCB0aGUgcGF0Y2guDQoNCkFuc29uLg0K
DQo=
