Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C115C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 571A42089F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="MqeP3IyW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389153AbfIMQcY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 12:32:24 -0400
Received: from mail-eopbgr770081.outbound.protection.outlook.com ([40.107.77.81]:52063
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389130AbfIMQcY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 12:32:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm7ZQKKHegw6cFKvaWCXEcoTNNJNpictKCypVxDQjcM7nAsw1aLjAF8/yTwwjoE2wg3TvNCqxnUf/Opbl9kHcb5kx2Tf/w0DMfJyhwmmmb3ZkGN1Yjj6+je1qHv2rTaqJwiR0+EeqCOSrLnSBX/GVzPS3vOvGA/yGdXcqJTJgS6+2SJSvSjzhjnR1zmJD2irxszuxbWObb5LKbQfNJE5/yNfOPH9dZFA4uKbFpWdx0WSBm3JdAyM4r9IPE0eE8TRYgDw/bBiV5RP+E5R8P3g+ABMTFaeQ/kw7K7wdZTYpJ89mS9nndASs6ABBP7MFpUsw3bYVF4ZMRvKb3pDWnzIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raB6fnC4WEsm7dJi7U4UiiCndjOcbHC0HcQSfzOLdQs=;
 b=J4+WliGd9I4xTaS21Vmqnq/232vwBtD0c0uYbgcx7aVijqPCtuxiEt0+rdD31eJdoH0ijqffamT6DOAHq0YxNYrshBuEH8uzuO9QsSKMcuO/t+vFCHCPPQZ15F7WZhfc2P8AGR4oXc0c9q69C+yrGKBPO4yQXbq8Rmj5xymnBHe8lja8xnRhuSnDrVyYhOwrbUHLm9jT1k+d2tthHVDuZ/uy4mtEu7zyatdG10ZUvo+O41AFTiSzCY8G13kaJ1J596EIQNr/ISP1auekCH1NCV0RqCVss92ObAOs/7ZXAKGczUTyZ+iZjFPp6F8ZsamTaVPXZhgkkxoZpoqxEbZF2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raB6fnC4WEsm7dJi7U4UiiCndjOcbHC0HcQSfzOLdQs=;
 b=MqeP3IyWTtwNqYt7RISGLDHes6XdPh8XaXgtngogDhtsRcWPk1qRbEzwcIlC6CHhu8PPAsEiyMFg92sL8UVqCpioSvUHGUQPm8O83fGlXAEiSs4au3GvaOoNQD67FfrTclYF7xVad+UYt/jBgSsSsL2ml8mO4TbhOy2dgjNfRJI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2717.namprd20.prod.outlook.com (20.178.253.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Fri, 13 Sep 2019 16:32:19 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 16:32:13 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH 1/3] crypto: inside-secure - Added support for authenc
 HMAC-SHA1/DES-CBC
Thread-Topic: [PATCH 1/3] crypto: inside-secure - Added support for authenc
 HMAC-SHA1/DES-CBC
Thread-Index: AQHVakTJFPzpgTjNwEGLLTrQOP3DlqcpurqAgAAMuHCAAAM7AIAAAXmA
Date:   Fri, 13 Sep 2019 16:32:12 +0000
Message-ID: <MN2PR20MB2973747D1984F453B007BBC5CAB30@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568383406-8009-2-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu_qMDxNDYnMOmV1mA4+JwX3eAB3B-4aC=YJ07oZrz+wCg@mail.gmail.com>
 <MN2PR20MB2973F80500C43C22E05B2332CAB30@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9-r3bKae_YNkvhWEwwS-GRUhp9qJn6+Lsgug97iGqS+A@mail.gmail.com>
In-Reply-To: <CAKv+Gu9-r3bKae_YNkvhWEwwS-GRUhp9qJn6+Lsgug97iGqS+A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96213574-31c2-47b6-8e11-08d73867ee7b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2717;
x-ms-traffictypediagnostic: MN2PR20MB2717:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB27179775FAB3901812C37851CAB30@MN2PR20MB2717.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39850400004)(199004)(13464003)(189003)(446003)(99286004)(2906002)(6916009)(11346002)(3846002)(6116002)(66446008)(64756008)(66556008)(71200400001)(66946007)(71190400001)(66476007)(486006)(76176011)(7696005)(25786009)(74316002)(33656002)(476003)(86362001)(76116006)(15974865002)(66066001)(52536014)(305945005)(6246003)(6436002)(14444005)(7736002)(14454004)(53546011)(6506007)(55016002)(9686003)(26005)(102836004)(8936002)(53936002)(8676002)(316002)(81156014)(5660300002)(186003)(54906003)(478600001)(4326008)(229853002)(81166006)(256004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2717;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CMVjxXMHrQ54MIRxmQjHPuP20AZZgcgP7VzvLZqt3LcoSHYw2UgEgU6CVUIKf1XdakJYOD6wpJbMeZ0mEd05QHXnt1SK6OYtafwc3dMopAwHjkg+SP9Ed7LLxAtUQOwwnoaIy4zFthynXzjoeMihnOEMWK+M6ZT/+QUF/ItZmw5RtMdryrZzKbqaJqj8NK0tUPsCUwgLFKhEPEuIQk7akKoyisNesnQSexPSAmMxFdjhkccOKcOYtSPPe6L7rGQclVHkEPjUd/pQsN5seNS7rM/SzAyo2gnbontQqwy0qFUSaaFUvI/vhYR6cCUORT0cz8A6X64sF4fsCh0c8H+rZ1N9zDL0kmSfv6fqjyz55HhUk2vL/k77yCw/SKpOy4VI1lW4HZcI8lm76MZq3huw0FExjpbfTGXVvdbsi8TXGME=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96213574-31c2-47b6-8e11-08d73867ee7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 16:32:12.7607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9xjZQquhrVfrNIDr9B7FlTmZeUhA5EHhYg0vFwylHjNsuyCIA8aF1Oe3F0ufOWIz7w45B3Elv9JQVWIiVz1iIr6FvuAcd13ycD4cPCpLXlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2717
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgMTMsIDIw
MTkgNjoyNCBQTQ0KPiBUbzogUGFzY2FsIFZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJpbWF0
cml4LmNvbT4NCj4gQ2M6IFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+
OyBvcGVuIGxpc3Q6SEFSRFdBUkUgUkFORE9NIE5VTUJFUg0KPiBHRU5FUkFUT1IgQ09SRSA8bGlu
dXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZz47IEFudG9pbmUgVGVuYXJ0DQo+IDxhbnRvaW5lLnRl
bmFydEBib290bGluLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5h
dT47IERhdmlkIFMuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCAxLzNdIGNyeXB0bzogaW5zaWRlLXNlY3VyZSAtIEFkZGVkIHN1cHBvcnQgZm9y
IGF1dGhlbmMgSE1BQy0NCj4gU0hBMS9ERVMtQ0JDDQo+IA0KPiBPbiBGcmksIDEzIFNlcCAyMDE5
IGF0IDE3OjE3LCBQYXNjYWwgVmFuIExlZXV3ZW4NCj4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXgu
Y29tPiB3cm90ZToNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+
IEZyb206IEFyZCBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPg0KPiA+ID4g
U2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgMTMsIDIwMTkgNToyNyBQTQ0KPiA+ID4gVG86IFBhc2Nh
bCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+DQo+ID4gPiBDYzogb3BlbiBsaXN0
OkhBUkRXQVJFIFJBTkRPTSBOVU1CRVIgR0VORVJBVE9SIENPUkUgPGxpbnV4LWNyeXB0b0B2Z2Vy
Lmtlcm5lbC5vcmc+Ow0KPiA+ID4gQW50b2luZSBUZW5hcnQgPGFudG9pbmUudGVuYXJ0QGJvb3Rs
aW4uY29tPjsgSGVyYmVydCBYdQ0KPiA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsNCj4g
PiA+IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFBhc2NhbCBWYW4gTGVl
dXdlbg0KPiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTog
W1BBVENIIDEvM10gY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0gQWRkZWQgc3VwcG9ydCBmb3IgYXV0
aGVuYyBITUFDLQ0KPiA+ID4gU0hBMS9ERVMtQ0JDDQo+ID4gPg0KPiA+ID4gT24gRnJpLCAxMyBT
ZXAgMjAxOSBhdCAxNjowNiwgUGFzY2FsIHZhbiBMZWV1d2VuIDxwYXNjYWx2YW5sQGdtYWlsLmNv
bT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciB0
aGUgYXV0aGVuYyhobWFjKHNoYTEpLGNiYyhkZXMpKSBhZWFkDQo+ID4gPiA+DQo+ID4gPiA+IFNp
Z25lZC1vZmYtYnk6IFBhc2NhbCB2YW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5j
b20+DQo+ID4gPg0KPiA+ID4gUGxlYXNlIG1ha2Ugc3VyZSB5b3VyIGNvZGUgaXMgYmFzZWQgb24g
Y3J5cHRvZGV2L21hc3RlciBiZWZvcmUgc2VuZGluZw0KPiA+ID4gaXQgdG8gdGhlIGxpc3QuDQo+
ID4gPg0KPiA+IExvb2tzIGxpa2Ugd2l0aCB0aGlzIHBhdGNoc2V0IGFuZCB0aGUgcHJldmlvdXMg
KFNIQTMpIHBhdGNoc2V0IEkgZm9yZ290DQo+ID4gdG8gYWRkIHRoZSBkaXNjbGFpbWVyIHRoYXQg
aXQgYXBwbGllcyBvbiB0b3Agb2YgdGhlIHByZXZpb3VzIHBhdGNoc2V0Lg0KPiA+IE1lYSBjdWxw
YS4NCj4gPg0KPiA+IFNvIHRoZXJlIHlvdSBnbzogIkFkZGVkIHN1cHBvcnQgZm9yIGF1dGhlbmMg
SE1BQy1TSEExL0RFUy1DQkMiIGFwcGxpZXMNCj4gPiBvbiB0b3Agb2YgIkFkZGVkIChITUFDKSBT
SEEzIHN1cHBvcnQiLCB3aGljaCBhcHBsaWVzIG9uIHRvcCBvZg0KPiA+ICJBZGQgc3VwcG9ydCBm
b3IgU000IGNpcGhlcnMiLg0KPiA+DQo+IA0KPiBTb3JyeSBpZiBJIHdhc24ndCBjbGVhciwgYnV0
IHRoYXQgd2FzIG5vdCBteSBwb2ludC4NCj4gDQo+IFlvdSBzaG91bGQgcmVhbGx5IGJhc2UgeW91
ciBjb2RlIG9uIGNyeXB0b2Rldi9tYXN0ZXIgc2luY2Ugc29tZSBvZiB0aGUNCj4gREVTIGhlbHBl
cnMgeW91IGFyZSB1c2luZyBkb24ndCBleGlzdCBhbnltb3JlLg0KPg0KQWgsIG9rLCBJJ2xsIGxv
b2sgaW50byB0aGF0IC4uLiBJIGRvbid0IGFsd2F5cyBub3RpY2UgdGhhdCBzb21ldGhpbmcNCmNo
YW5nZWQgaW4gY3J5cHRvZGV2L21hc3Rlci4gV2hpY2ggZG9lc24ndCBoYXBwZW4gdG9vIGZyZXF1
ZW50bHksIHNvDQppdCdzIGVhc3kgdG8gbWlzcy4gT25lIG9mIHRoZSBkb3duc2lkZXMgb2YgR2l0
IGNvbXBhcmVkIHRvICJub3JtYWwiDQp2ZXJzaW9uIGNvbnRyb2wgc3lzdGVtczogeW91IGhhdmUg
dG8gbWFudWFsbHkga2VlcCB0cmFjayBvZiBtYXN0ZXIuDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFu
IExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAg
VmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
