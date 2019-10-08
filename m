Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C45C10F14
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 07:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAEBF20867
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 07:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="sU7nZUml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfJHH5b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:57:31 -0400
Received: from mail-eopbgr710047.outbound.protection.outlook.com ([40.107.71.47]:64800
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730313AbfJHH53 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 03:57:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbVE3uXQ90k8+0jpIXStRydFij7sxJPH3+WCqcrF57iAY96rh9eGcQG+Pj5lwgDsHph7zYvWOJNGwOnfLlj1Y7QTzSSTk2nU2aJlr8xmy34aM4EVLVC3BxOpBb8z5rMmV9tUA6S9dpMp+DVH44GMC0rm/rQvywmRnRHbEs76klcxPOtBrglFXiqgkOUcT6Su39mBGxRpHwj8Z5YoDxdAgcyJwAbN06JtN5HWrtZBDwak/Ztjqyd5xq6rMwiKANfJ2wBIZwknWtDxCquKzDojzelfqAm+q8v0VZnY6spBUzh2ELg0oIFMZLXorjutu3gKrmz9Hk0ip2d+PmWb6N85qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hZbOtTkkVZaFq386IDJUVLqMqNIR0RpXADvQHgB78c=;
 b=YpA4Ea3JZneH3EUQC7lu4RvRDCXixzFv97SmJxp+OZ6M+h6Pw/Imf8W1IMDZxj1ZCnoFpXYxAWdaTPFknrz65EZ/gGSK9+KnZ5Xk3IIh/aP2mgb/l0+PyDj6oCxgVunyueIFJcbnkwcljUa/knUH9ue4ZevRQh2B/dIG5n824S9pt9R6iRKZJ4XaDTAh6N/2t51Sb00B9mPLlN8S26/X01DbGwQF8o9Jy+NEb1ljkSdVzkvW82sdNJIYK3VKTYqvLMIBNhG2UzdWz0iXRLhtGgtHo23jR4jeaMPRX2wO/LUrZ5XW2Fm1Jt2PjuHHoyJxLzSt9dExNXcvX5ArEiRXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hZbOtTkkVZaFq386IDJUVLqMqNIR0RpXADvQHgB78c=;
 b=sU7nZUmlP7JWeWubJhYtTe1/IpinECET91xI92fzOReRA3HuhsB00g2rEVM6AL/D8LmrmJBW1x0exHOXbmKilv0g+LbYetboWjWatJ/vkknqx1uwBpEVrCuAoRaXAX/a8dged86DpF2IinVxGavv7SCmx+PwCbB42qvwzvCvaeo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2381.namprd20.prod.outlook.com (20.179.147.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 07:57:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 07:57:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     YueHaibing <yuehaibing@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pascalvanl@gmail.com" <pascalvanl@gmail.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] crypto: inside-secure - Fix randbuild error
Thread-Topic: [PATCH -next] crypto: inside-secure - Fix randbuild error
Thread-Index: AQHVfagq9QgwAxh3xk6Yw1cHeAjlcqdQWBnggAACeoCAAAW9IA==
Date:   Tue, 8 Oct 2019 07:57:26 +0000
Message-ID: <MN2PR20MB2973F842E33546BC52A1430DCA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191008071503.55772-1-yuehaibing@huawei.com>
 <MN2PR20MB297342D98080781DB5DC7BABCA9A0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu__LnHTAbs5TtczT7eWA=4drh5_zOMCyowz3ohFTAtqEw@mail.gmail.com>
In-Reply-To: <CAKv+Gu__LnHTAbs5TtczT7eWA=4drh5_zOMCyowz3ohFTAtqEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f49a332-fbaa-41ae-bc4e-08d74bc52927
x-ms-traffictypediagnostic: MN2PR20MB2381:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23817389C9C3A33B10C6292CCA9A0@MN2PR20MB2381.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(136003)(366004)(376002)(396003)(13464003)(189003)(199004)(81156014)(8676002)(53546011)(6246003)(66446008)(76116006)(66556008)(446003)(11346002)(66946007)(54906003)(316002)(6916009)(102836004)(81166006)(64756008)(6506007)(9686003)(76176011)(7696005)(4326008)(52536014)(99286004)(25786009)(8936002)(5660300002)(66476007)(55016002)(33656002)(71190400001)(256004)(14454004)(71200400001)(229853002)(26005)(86362001)(74316002)(6436002)(186003)(6116002)(3846002)(66066001)(2906002)(7736002)(486006)(305945005)(476003)(478600001)(15974865002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2381;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iGJybTN9HrWsEL2Ujxls4vXfutSwBP0QvRMTNT0qedIAYoPkQWP9s5PM9uwJ5sGA3z4VjbWMhKNFItsklN+wfKqdGB7XZi72dvUZFLJ5bZxVsvclZH194hApl+xCA3tlUuyl2mou0eLE53JR8QNw38raPC5yXbwDbuzbGlvP5PjHG4Z0xAsXGSndRZSBCxiveGgGga/2WJyjxexMYVdjaoj1n0sNZ0IFnLAaCJYasEui+ITtfe3VppuYPyTdrGAU6g78Zjcofp2G+AaTZ8SbwhvqzamwVMXpgrawutwRjMbbFENJLzHvoDKnAPrc/HMfjKo3dsQ7qijl75PqdtFlYK+9CyFMsYaOfKMo6agOtyw2Ug5vebOm5Kgs4UooupulF7+yIUV0oJlIb9zv7gWyLzYm02hcNQVdyB7MLJfu1mQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f49a332-fbaa-41ae-bc4e-08d74bc52927
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 07:57:26.6315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Z6iUgdkDojt/OMJajIS2wLxk7iWOSctAUK5aZZwOMvbPKwXNV4s9mvbUtDyipV60jym8b0jOSYzYKhf5qor3p7jsvUSVLVjJcaU8nExaWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2381
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogVHVlc2RheSwgT2N0b2JlciA4LCAyMDE5
IDk6MzUgQU0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJp
eC5jb20+DQo+IENjOiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+OyBoZXJiZXJ0
QGdvbmRvci5hcGFuYS5vcmcuYXU7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IHBhc2NhbHZhbmxA
Z21haWwuY29tOyBhbnRvaW5lLnRlbmFydEBib290bGluLmNvbTsgbGludXgtY3J5cHRvQHZnZXIu
a2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCAtbmV4dF0gY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0gRml4IHJhbmRidWlsZCBl
cnJvcg0KPiANCj4gT24gVHVlLCA4IE9jdCAyMDE5IGF0IDA5OjMyLCBQYXNjYWwgVmFuIExlZXV3
ZW4NCj4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IGxpbnV4LWNyeXB0by1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNyeXB0by1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uIEJl
aGFsZiBPZg0KPiA+ID4gWXVlSGFpYmluZw0KPiA+ID4gU2VudDogVHVlc2RheSwgT2N0b2JlciA4
LCAyMDE5IDk6MTUgQU0NCj4gPiA+IFRvOiBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IHBhc2NhbHZhbmxAZ21haWwuY29tOw0KPiA+ID4gYW50b2luZS50
ZW5hcnRAYm9vdGxpbi5jb20NCj4gPiA+IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBZdWVIYWliaW5nDQo+ID4gPiA8eXVlaGFp
YmluZ0BodWF3ZWkuY29tPg0KPiA+ID4gU3ViamVjdDogW1BBVENIIC1uZXh0XSBjcnlwdG86IGlu
c2lkZS1zZWN1cmUgLSBGaXggcmFuZGJ1aWxkIGVycm9yDQo+ID4gPg0KPiA+ID4gSWYgQ1JZUFRP
X0RFVl9TQUZFWENFTCBpcyB5IGJ1dCBDUllQVE9fU00zIGlzIG0sDQo+ID4gPiBidWlsZGluZyBm
YWlsczoNCj4gPiA+DQo+ID4gPiBkcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2Vs
X2hhc2gubzogSW4gZnVuY3Rpb24gYHNhZmV4Y2VsX2FoYXNoX2ZpbmFsJzoNCj4gPiA+IHNhZmV4
Y2VsX2hhc2guYzooLnRleHQrMHhiYzApOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBzbTNfemVy
b19tZXNzYWdlX2hhc2gnDQo+ID4gPg0KPiA+ID4gU2VsZWN0IENSWVBUT19TTTMgdG8gZml4IHRo
aXMuDQo+ID4gPg0KPiA+ID4gUmVwb3J0ZWQtYnk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWku
Y29tPg0KPiA+ID4gRml4ZXM6IDBmMmJjMTMxODFjZSAoImNyeXB0bzogaW5zaWRlLXNlY3VyZSAt
IEFkZGVkIHN1cHBvcnQgZm9yIGJhc2ljIFNNMyBhaGFzaCIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBk
cml2ZXJzL2NyeXB0by9LY29uZmlnIHwgMSArDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL0tjb25m
aWcgYi9kcml2ZXJzL2NyeXB0by9LY29uZmlnDQo+ID4gPiBpbmRleCAzZTUxYmFlLi41YWYxN2Ri
IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vS2NvbmZpZw0KPiA+ID4gKysrIGIv
ZHJpdmVycy9jcnlwdG8vS2NvbmZpZw0KPiA+ID4gQEAgLTc1MSw2ICs3NTEsNyBAQCBjb25maWcg
Q1JZUFRPX0RFVl9TQUZFWENFTA0KPiA+ID4gICAgICAgc2VsZWN0IENSWVBUT19TSEE1MTINCj4g
PiA+ICAgICAgIHNlbGVjdCBDUllQVE9fQ0hBQ0hBMjBQT0xZMTMwNQ0KPiA+ID4gICAgICAgc2Vs
ZWN0IENSWVBUT19TSEEzDQo+ID4gPiArICAgICBzZWxlY3QgQ1JZUFRPX1NNMw0KPiA+ID4gICAg
ICAgaGVscA0KPiA+ID4gICAgICAgICBUaGlzIGRyaXZlciBpbnRlcmZhY2VzIHdpdGggdGhlIFNh
ZmVYY2VsIEVJUC05NyBhbmQgRUlQLTE5NyBjcnlwdG9ncmFwaGljDQo+ID4gPiAgICAgICAgIGVu
Z2luZXMgZGVzaWduZWQgYnkgSW5zaWRlIFNlY3VyZS4gSXQgY3VycmVudGx5IGFjY2VsZXJhdGVz
IERFUywgM0RFUyBhbmQNCj4gPiA+IC0tDQo+ID4gPiAyLjcuNA0KPiA+ID4NCj4gPiBCdXQgLi4u
IEkgZG9uJ3QgcmVhbGx5IHdhbnQgdG8gYnVpbGQgU00zIGludG8gdGhlIGtlcm5lbCBmb3IgYWxs
IEluc2lkZQ0KPiA+IFNlY3VyZSBkcml2ZXJzLCBzaW5jZSBpbiB0aGUgbWFqb3JpdHkgb2YgY2Fz
ZXMsIHRoZSBIVyB3aWxsIG5vdCBhY3R1YWxseQ0KPiA+IHN1cHBvcnQgU00zIGFuZCBJIGRvbid0
IHdhbnQgdG8gYmxvYXQgdGhlIGtlcm5lbCBpbWFnZSBpbiB0aGF0IGNhc2UuDQo+ID4NCj4gPiBT
byBtYXliZSBpdCdzIGJldHRlciB0byAjaWZkZWYgb3V0IHRoZSBmYWlsaW5nIHBhcnQgb2YgdGhl
IGRyaXZlciBpZg0KPiA+IENPTkZJR19TTTMgaXMgbm90IHNldD8NCj4gPg0KPiANCj4gU2luY2Ug
eW91IGFyZSBvbmx5IHVzaW5nIHRoZSB6ZXJvIGxlbmd0aCBtZXNzYWdlIGhhc2gsIGNhbiB3ZSBq
dXN0DQo+IGNvcHkgdGhhdCBpbnRvIHlvdXIgZHJpdmVyIGluc3RlYWQ/DQpJZiB0aGF0IGlzIHJl
YWxseSB0aGUgY2FzZSAtIGRvbid0IGhhdmUgdGltZSB0byBsb29rIGludG8gdGhhdCByaWdodCBu
b3cgLQ0KdGhlbiBJIHdvdWxkIGJlIGZpbmUgd2l0aCB0aGF0IHRvby4gSWYgbm8gb25lIG9iamVj
dHMsIHRoZW4gSSB3aWxsIG1ha2UgYQ0KcGF0Y2ggZm9yIHRoYXQgd2hlbiBJIGNhbiBmaW5kIHNv
bWUgdGltZSB0byBkbyBzbyAofmVhcmx5IG5leHQgd2VlaykuDQoNClJlZ2FyZHMsDQpQYXNjYWwg
dmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVz
IEAgVmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
