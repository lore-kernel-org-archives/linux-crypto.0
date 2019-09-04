Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BE0C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 12:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24FA920820
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 12:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="DmOTfP92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfIDMZo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 08:25:44 -0400
Received: from mail-eopbgr730046.outbound.protection.outlook.com ([40.107.73.46]:37952
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbfIDMZn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 08:25:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hM2XONEJGrqMWTXAgFSyGIAP6Ss74Xzql9beFKecUO4tpsBGEoVRxfTfhYslZ0heIdSFTpeTVqX3r1YfzvjhLrIF64ifFN9K+mJ2OBgljRu1FSjNOyN+GnUei6uOLc/DvCeHPPLmz02/mL64DhH66yU0BHmssh8A2gMiY8r/UV9xBPF87TT3Qkau7nTXg7Gzqls3kRfrOJBq5wT8SLHsbwuWyGiy8KEEssA3hegT2gyKyHD+jnk9KRn1cRwhkDYCUrqSXlusS3nWKIRj5+UxQ6M65UV1lFguKVLtY6asubltzJjo9hn3/2mtqGdMahEE2FfmPFKabQ4JD5zx6OWkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0SACXdxv7eGR66FN771DOAJMeFxeuKfJzoOg7CmDGI=;
 b=bzx6eO9KQBpsujdiBVq1wjzalR8aPaZUUqUkJBtM1D2JXmkQ4xUoxLvegWVF9AYSm9grMS7MemmgB/V85yhVxnaIl+472Uo+B5smNK6fvaCczY8vtnxEP7rY0yfQQ4xBZcSWN5lVbO7358TFHoL5SBGr113MXIpGvIsudxusS+IOnD9oyV8aaJO9td0RIwvO/9N+RuXAMIOqFiDbTMmWVN27z7WKVXXEtn61eSrZkRTgvFA7xR9FoRH1d8KzwNxDWKA6KpVpKXz0dRHrwuUsJDdCj8Khyh2eSnc83dbImGwmBj2+mo/RCbZFN3KF+SiFkvo9OpV6ooM3ZHBGf7fo0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0SACXdxv7eGR66FN771DOAJMeFxeuKfJzoOg7CmDGI=;
 b=DmOTfP92sYkKn/LqmAVvYIae4yfkvhGk69B+F8g1i5pbcyW/VrsM7TPHpH/Tqo3NDj1LmDRTkYS45OTVz7vP+R5OZpA5sJ5psyxya1DbBHf23gnefSmEXAE6nMMc3iz/ikXMpol0yPL5aIP4ue2KV3O9dUmujOjSjaPf8k7qfX4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2317.namprd20.prod.outlook.com (20.179.144.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 12:25:39 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Wed, 4 Sep 2019
 12:25:39 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 -next] crypto: inside-secure - Fix build error without
 CONFIG_PCI
Thread-Topic: [PATCH v2 -next] crypto: inside-secure - Fix build error without
 CONFIG_PCI
Thread-Index: AQHVYfrTy4jcxbeEsEeyU2s27hKUDqcbaoBwgAAFDACAAAHAQA==
Date:   Wed, 4 Sep 2019 12:25:39 +0000
Message-ID: <MN2PR20MB297342698B98343D49FC2C82CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190902141910.1080-1-yuehaibing@huawei.com>
 <20190903014518.20880-1-yuehaibing@huawei.com>
 <MN2PR20MB29732EEECB217DDDF822EDA5CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8PVYyA-mzjrhR6r6upMc=xzpAhsbkuKRtb8T2noo_2XQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu8PVYyA-mzjrhR6r6upMc=xzpAhsbkuKRtb8T2noo_2XQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c294bd10-c1c5-4104-e382-08d73132ff2e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2317;
x-ms-traffictypediagnostic: MN2PR20MB2317:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB231767AA42DC9F4D63509A2FCAB80@MN2PR20MB2317.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39850400004)(136003)(396003)(366004)(199004)(189003)(13464003)(186003)(8676002)(6116002)(3846002)(8936002)(102836004)(53546011)(6506007)(76176011)(33656002)(81156014)(81166006)(7696005)(26005)(74316002)(53936002)(66946007)(71200400001)(66556008)(64756008)(66446008)(66476007)(6246003)(71190400001)(99286004)(7736002)(76116006)(305945005)(9686003)(55016002)(15974865002)(4326008)(25786009)(86362001)(316002)(54906003)(2906002)(476003)(6436002)(256004)(14444005)(229853002)(11346002)(486006)(14454004)(446003)(6916009)(5660300002)(66066001)(52536014)(478600001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2317;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YOlVoicLDkLunizfHLm0UXe76BgbxyBHDXtAuZsHMe39cxFcBVJCgwqnxdAZ5VviRmZlB4KGEuzdfPVXgxg9eBWYnXlQBqQ2Rz5BhVbLntKpqOwUfG/F0BuvXwuRUyhD1DfQJbFzoVU+Vs3Qe+Ic2c+VGSJ/W8S1rn6ss9STFONoo1hSyJ3eDVUVdf3S/fztDX19Gtkxo/JEpz5Xt//CUBD+d9iCkdjaOKRh9IZertGUztaKw9dogOurXyzkDS9XZc3Zfcl7IgEJ2MAOuofYmZ7NYJXDxQM5IuRK3lgtps93EttOVzGK6q0uDqbVLxhKHAoTCr/n8DvlhABRbwueXYndRxlEhsXzjNOCWYS61gHL3zPujET8VsKkY2PAKxwn+GSmXDthrAmsJVXn78WuFz7aa+H1WPc+74zFkn8wn2M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c294bd10-c1c5-4104-e382-08d73132ff2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 12:25:39.3704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2RvAv8xmwjfsdCwbMyw+BpseYiekeYWbzCwRd6ZcaiL4T9egWrmhhANcdqk8t0D/duS/zelZZUy2q618tArCr1l99fwJO3WaUw9cUeMUOCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2317
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgNCwg
MjAxOSAyOjExIFBNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmlt
YXRyaXguY29tPg0KPiBDYzogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPjsgYW50
b2luZS50ZW5hcnRAYm9vdGxpbi5jb207DQo+IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgcHZhbmxlZXV3ZW5AaW5zaWRlc2VjdXJlLmNvbTsgbGludXgt
DQo+IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAtbmV4dF0gY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0g
Rml4IGJ1aWxkIGVycm9yIHdpdGhvdXQgQ09ORklHX1BDSQ0KPiANCj4gT24gV2VkLCA0IFNlcCAy
MDE5IGF0IDA0OjU3LCBQYXNjYWwgVmFuIExlZXV3ZW4NCj4gPHB2YW5sZWV1d2VuQHZlcmltYXRy
aXguY29tPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+ID4gRnJvbTogbGludXgtY3J5cHRvLW93bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgt
Y3J5cHRvLW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVoYWxmIE9mDQo+ID4gPiBZdWVI
YWliaW5nDQo+ID4gPiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgMywgMjAxOSAzOjQ1IEFNDQo+
ID4gPiBUbzogYW50b2luZS50ZW5hcnRAYm9vdGxpbi5jb207IGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiA+IHB2YW5sZWV1d2VuQGluc2lkZXNl
Y3VyZS5jb20NCj4gPiA+IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBZdWVIYWliaW5nDQo+ID4gPiA8eXVlaGFpYmluZ0BodWF3
ZWkuY29tPg0KPiA+ID4gU3ViamVjdDogW1BBVENIIHYyIC1uZXh0XSBjcnlwdG86IGluc2lkZS1z
ZWN1cmUgLSBGaXggYnVpbGQgZXJyb3Igd2l0aG91dCBDT05GSUdfUENJDQo+ID4gPg0KPiA+ID4g
SWYgQ09ORklHX1BDSSBpcyBub3Qgc2V0LCBidWlsZGluZyBmYWlsczoNCj4gPiA+DQo+ID4gPiBy
aXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWwuYzogSW4gZnVuY3Rpb24gc2FmZXhj
ZWxfcmVxdWVzdF9yaW5nX2lycToNCj4gPiA+IGRyaXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1cmUv
c2FmZXhjZWwuYzo5NDQ6OTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9u
DQo+ID4gPiBwY2lfaXJxX3ZlY3RvcjsNCj4gPiA+ICBkaWQgeW91IG1lYW4gcmN1X2lycV9lbnRl
cj8gWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tZGVjbGFyYXRpb25dDQo+ID4gPiAgICBpcnEg
PSBwY2lfaXJxX3ZlY3RvcihwY2lfcGRldiwgaXJxaWQpOw0KPiA+ID4gICAgICAgICAgXn5+fn5+
fn5+fn5+fn4NCj4gPiA+DQo+ID4gPiBVc2UgI2lmZGVmIGJsb2NrIHRvIGd1YXJkIHRoaXMuDQo+
ID4gPg0KPiA+IEFjdHVhbGx5LCB0aGlzIGlzIGludGVyZXN0aW5nLiBNeSAqb3JpZ2luYWwqIGlt
cGxlbWVudGF0aW9uIHdhcyB1c2luZw0KPiA+IHN0cmFpZ2h0ICNpZmRlZnMsIGJ1dCB0aGVuIEkg
Z290IHJldmlldyBmZWVkYmFjayBzdGF0aW5nIHRoYXQgSSBzaG91bGQgbm90DQo+ID4gZG8gdGhh
dCwgYXMgaXQncyBub3QgY29tcGlsZSB0ZXN0YWJsZSwgc3VnZ2VzdGluZyB0byB1c2UgcmVndWxh
ciBDIGlmJ3MNCj4gPiBpbnN0ZWFkLiBUaGVuIHRoZXJlIHdhcyBxdWl0ZSBzb21lIGJhY2stYW5k
LWZvcnRoIG9uIHRoZSBhY3R1YWwNCj4gPiBpbXBsZW1lbnRhdGlvbiBhbmQgSSBlbmRlZCB1cCB3
aXRoIHRoaXMuDQo+ID4NCj4gPiBTbyBub3cgaXQgdHVybnMgb3V0IHRoYXQgZG9lc24ndCB3b3Jr
IGFuZCBJJ20gc3VnZ2VzdGVkIHRvIGdvIGZ1bGwtY2lyY2xlDQo+ID4gYmFjayB0byBzdHJhaWdo
dCAjaWZkZWYncz8gT3IgaXMgdGhlcmUgc29tZSBvdGhlciB3YXkgdG8gbWFrZSB0aGlzIHdvcms/
DQo+ID4gQmVjYXVzZSBJIGRvbid0IGtub3cgd2hlcmUgdG8gZ28gZnJvbSBoZXJlIC4uLg0KPiA+
DQo+IA0KPiANCj4gQyBjb25kaXRpb25hbHMgYXJlIHByZWZlcnJlZCBvdmVyIHByZXByb2Nlc3Nv
ciBjb25kaXRpb25hbCwgYnV0IGlmIHRoZQ0KPiBjb25kaXRpb25hbCBjb2RlIHJlZmVycyB0byBz
eW1ib2xzIHRoYXQgYXJlIG5vdCBkZWNsYXJlZCB3aGVuIHRoZQ0KPiBLY29uZmlnIHN5bWJvbCBp
cyBub3QgZGVmaW5lZCwgcHJlcHJvY2Vzc29yIGNvbmRpdGlvbmFscyBhcmUgdGhlIG9ubHkNCj4g
b3B0aW9uLg0KPiANClN1cmUsIEkgZ2V0IHRoYXQuIEJ1dCBJICpoYWQqIHRoZSAjaWZkZWYncyBh
bmQgdGhlbiBvdGhlciBwZW9wbGUgdG9sZCBtZQ0KdG8gZ2V0IHJpZCBvZiB0aGVtLiBIb3cgaXMg
b25lIHN1cHBvc2VkIHRvIGtub3cgd2hlbiB3aGljaCBzeW1ib2xzIGFyZQ0KZGVjbGFyZWQgZXhh
Y3RseT8gTW9yZW92ZXIsIEkgZmVlbCB0aGF0IGlmICNpZmRlZidzIGFyZSBzb21ldGltZXMgdGhl
DQpvbmx5IHdheSwgdGhlbiB5b3Ugc2hvdWxkIGJlIGNhcmVmdWwgcHJvdmlkaW5nIGZlZWRiYWNr
IG9uIHRoZSBzdWJqZWN0Lg0KDQo+IFRoaXMgaXMgdGhlIHJlYXNvbiB3ZSBoYXZlIHNvIG1hbnkg
ZW1wdHkgc3RhdGljIGlubGluZSBmdW5jdGlvbnMgaW4NCj4gaGVhZGVyIGZpbGVzIC0gaXQgZW5z
dXJlcyB0aGF0IHRoZSBzeW1ib2xzIGFyZSBkZWNsYXJlZCBldmVuIGlmIHRoZQ0KPiBvbmx5IGlu
dm9jYXRpb25zIGFyZSBmcm9tIGRlYWQgY29kZS4NCj4gDQpUaGlzIHRpZXMgYmFjayBpbnRvIG15
IHByZXZpb3VzIHF1ZXN0aW9uOiBob3cgYW0gSSBzdXBwb3NlZCB0byBrbm93IHdoZXRoZXINCnN0
dWZmIGlzIG5pY2VseSBjb3ZlcmVkIGJ5IHRoZXNlIGVtcHR5IHN0YXRpYyBpbmxpbmVzIG9yIG5v
dD8gSWYgdGhpcw0KaGFwcGVucyB0byBiZSBhIGhpdC1hbmQtbWlzcyBhZmZhaXIuDQoNCk5vdGUg
dGhhdCBJIHRlc3RlZCB0aGUgY29kZSB3aXRoIHRoZSAyIHBsYXRmb3JtcyBhdCBteSBkaXNwb3Nh
bCAtIGFjdHVhbGx5DQp0aGUgb25seSAyIHJlbGV2YW50IHBsYXRmb3JtcyBmb3IgdGhpcyBkcml2
ZXIsIGlmIHlvdSBhc2sgbWUgLSBhbmQgdGhleQ0KYm90aCBjb21waWxlZCBqdXN0IGZpbmUsIHNv
IEkgaGFkIG5vIHdheSBvZiBmaW5kaW5nIHRoaXMgInByb2JsZW0iIG15c2VsZi4NCg0KPiANCj4g
PiA+IEZpeGVzOiA2MjVmMjY5YTVhN2EgKCJjcnlwdG86IGluc2lkZS1zZWN1cmUgLSBhZGQgc3Vw
cG9ydCBmb3IgUENJIGJhc2VkIEZQR0ENCj4gZGV2ZWxvcG1lbnQNCj4gPiA+IGJvYXJkIikNCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCj4g
PiA+IC0tLQ0KPiA+ID4gdjI6IHVzZSAnaWZkZWYnIGluc3RlYWQgb2YgJ0lTX0VOQUJMRUQnDQo+
ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsLmMg
fCAxMyArKysrKysrKysrLS0tDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5
cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWwuYyBiL2RyaXZlcnMvY3J5cHRvL2luc2lkZS0NCj4g
PiA+IHNlY3VyZS9zYWZleGNlbC5jDQo+ID4gPiBpbmRleCBlMTJhMmEzLi41MjUzOTAwIDEwMDY0
NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9zYWZleGNlbC5jDQo+
ID4gPiArKysgYi9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsLmMNCj4gPiA+
IEBAIC05MzcsNyArOTM3LDggQEAgc3RhdGljIGludCBzYWZleGNlbF9yZXF1ZXN0X3JpbmdfaXJx
KHZvaWQgKnBkZXYsIGludCBpcnFpZCwNCj4gPiA+ICAgICAgIGludCByZXQsIGlycTsNCj4gPiA+
ICAgICAgIHN0cnVjdCBkZXZpY2UgKmRldjsNCj4gPiA+DQo+ID4gPiAtICAgICBpZiAoSVNfRU5B
QkxFRChDT05GSUdfUENJKSAmJiBpc19wY2lfZGV2KSB7DQo+ID4gPiArI2lmZGVmIENPTkZJR19Q
Q0kNCj4gPiA+ICsgICAgIGlmIChpc19wY2lfZGV2KSB7DQo+ID4gPiAgICAgICAgICAgICAgIHN0
cnVjdCBwY2lfZGV2ICpwY2lfcGRldiA9IHBkZXY7DQo+ID4gPg0KPiA+ID4gICAgICAgICAgICAg
ICBkZXYgPSAmcGNpX3BkZXYtPmRldjsNCj4gPiA+IEBAIC05NDcsNyArOTQ4LDEwIEBAIHN0YXRp
YyBpbnQgc2FmZXhjZWxfcmVxdWVzdF9yaW5nX2lycSh2b2lkICpwZGV2LCBpbnQgaXJxaWQsDQo+
ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpcnFpZCwgaXJxKTsNCj4gPiA+ICAg
ICAgICAgICAgICAgICAgICAgICByZXR1cm4gaXJxOw0KPiA+ID4gICAgICAgICAgICAgICB9DQo+
ID4gPiAtICAgICB9IGVsc2UgaWYgKElTX0VOQUJMRUQoQ09ORklHX09GKSkgew0KPiA+ID4gKyAg
ICAgfSBlbHNlDQo+ID4gPiArI2VuZGlmDQo+ID4gPiArICAgICB7DQo+ID4gPiArI2lmZGVmIENP
TkZJR19PRg0KPiA+ID4gICAgICAgICAgICAgICBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwbGZf
cGRldiA9IHBkZXY7DQo+ID4gPiAgICAgICAgICAgICAgIGNoYXIgaXJxX25hbWVbNl0gPSB7MH07
IC8qICJyaW5nWFwwIiAqLw0KPiA+ID4NCj4gPiA+IEBAIC05NjAsNiArOTY0LDcgQEAgc3RhdGlj
IGludCBzYWZleGNlbF9yZXF1ZXN0X3JpbmdfaXJxKHZvaWQgKnBkZXYsIGludCBpcnFpZCwNCj4g
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlycV9uYW1lLCBpcnEpOw0KPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBpcnE7DQo+ID4gPiAgICAgICAgICAgICAgIH0N
Cj4gPiA+ICsjZW5kaWYNCj4gPiA+ICAgICAgIH0NCj4gPiA+DQo+ID4gPiAgICAgICByZXQgPSBk
ZXZtX3JlcXVlc3RfdGhyZWFkZWRfaXJxKGRldiwgaXJxLCBoYW5kbGVyLA0KPiA+ID4gQEAgLTEx
MzcsNyArMTE0Miw4IEBAIHN0YXRpYyBpbnQgc2FmZXhjZWxfcHJvYmVfZ2VuZXJpYyh2b2lkICpw
ZGV2LA0KPiA+ID4NCj4gPiA+ICAgICAgIHNhZmV4Y2VsX2NvbmZpZ3VyZShwcml2KTsNCj4gPiA+
DQo+ID4gPiAtICAgICBpZiAoSVNfRU5BQkxFRChDT05GSUdfUENJKSAmJiBwcml2LT52ZXJzaW9u
ID09IEVJUDE5N19ERVZCUkQpIHsNCj4gPiA+ICsjaWZkZWYgQ09ORklHX1BDSQ0KPiA+ID4gKyAg
ICAgaWYgKHByaXYtPnZlcnNpb24gPT0gRUlQMTk3X0RFVkJSRCkgew0KPiA+ID4gICAgICAgICAg
ICAgICAvKg0KPiA+ID4gICAgICAgICAgICAgICAgKiBSZXF1ZXN0IE1TSSB2ZWN0b3JzIGZvciBn
bG9iYWwgKyAxIHBlciByaW5nIC0NCj4gPiA+ICAgICAgICAgICAgICAgICogb3IganVzdCAxIGZv
ciBvbGRlciBkZXYgaW1hZ2VzDQo+ID4gPiBAQCAtMTE1Myw2ICsxMTU5LDcgQEAgc3RhdGljIGlu
dCBzYWZleGNlbF9wcm9iZV9nZW5lcmljKHZvaWQgKnBkZXYsDQo+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+ICAgICAgICAgICAgICAgfQ0KPiA+ID4gICAgICAg
fQ0KPiA+ID4gKyNlbmRpZg0KPiA+ID4NCj4gPiA+ICAgICAgIC8qIFJlZ2lzdGVyIHRoZSByaW5n
IElSUSBoYW5kbGVycyBhbmQgY29uZmlndXJlIHRoZSByaW5ncyAqLw0KPiA+ID4gICAgICAgcHJp
di0+cmluZyA9IGRldm1fa2NhbGxvYyhkZXYsIHByaXYtPmNvbmZpZy5yaW5ncywNCj4gPiA+IC0t
DQo+ID4gPiAyLjcuNA0KPiA+ID4NCj4gPg0KPiA+IFJlZ2FyZHMsDQo+ID4gUGFzY2FsIHZhbiBM
ZWV1d2VuDQo+ID4gU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMg
QCBWZXJpbWF0cml4DQo+ID4gd3d3Lmluc2lkZXNlY3VyZS5jb20NCg0KUmVnYXJkcywNClBhc2Nh
bCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2lu
ZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0KDQo=
