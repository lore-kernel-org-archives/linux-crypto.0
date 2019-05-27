Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2941BC04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0F3E21848
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="B8QViCsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfE0PQP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 11:16:15 -0400
Received: from mail-eopbgr00090.outbound.protection.outlook.com ([40.107.0.90]:37383
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfE0PQP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 11:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SviG1AHg9jZPC5URfm0VnZWOhoV4WmvuTLximgD6FQ=;
 b=B8QViCsQ1QkN4ASBF/gJjJZpDSeb+L71sJWqgDjBhmfclHs+q78sEi1Ez/8l4GYPHWk9pftWkr1UCI3HDyHKBd/q4OdrDNniJswPMmhggG8mHgbncEDffqXdvUg2uzxhIjHm9PcRreCdM6BYLEpgxedWp2og2FNSnqx2rMCcakE=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2264.eurprd09.prod.outlook.com (20.177.114.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Mon, 27 May 2019 15:16:11 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 15:16:11 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAS0FFCAAAQtAIAAAZkAgAAJO4CAAADysIAABwUAgAAHPfCAABPWkIAAJKQAgAACLPA=
Date:   Mon, 27 May 2019 15:16:11 +0000
Message-ID: <AM6PR09MB35231DD72CBD3CC7B6EA96FDD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
 <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-q2ETftN=S_biUmamxeXFe=CHMWGd=xeZT+w4Zx0Ou2w@mail.gmail.com>
 <AM6PR09MB352398BD645902A305C680C9D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8ScTXM2qxrG__RW6SLKZYrevjfCi_HxpSOJRH5+9Knzg@mail.gmail.com>
 <AM6PR09MB3523090454E4FB6825797A0FD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu85qp44C9Leydz=ES+ByWYoYSWMC-Kiv2Gw403sYBGkcw@mail.gmail.com>
 <AM6PR09MB35236E55357F5FA41AF47146D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu86f-JuU23igrxRSkWOfXhQVUO8pA0FaY=n7pxQ3r5poA@mail.gmail.com>
In-Reply-To: <CAKv+Gu86f-JuU23igrxRSkWOfXhQVUO8pA0FaY=n7pxQ3r5poA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9860f454-7fc9-4cda-a0a1-08d6e2b64086
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB2264;
x-ms-traffictypediagnostic: AM6PR09MB2264:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB226480B121744B7133558215D21D0@AM6PR09MB2264.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(396003)(366004)(376002)(346002)(199004)(189003)(6436002)(486006)(9686003)(229853002)(55016002)(476003)(11346002)(305945005)(33656002)(102836004)(66946007)(73956011)(76116006)(74316002)(66446008)(64756008)(3480700005)(446003)(68736007)(256004)(66556008)(25786009)(71200400001)(71190400001)(66476007)(86362001)(7736002)(5660300002)(52536014)(1671002)(15974865002)(53936002)(8676002)(26005)(186003)(6246003)(6116002)(4326008)(3846002)(109986005)(59246006)(54906003)(7116003)(76176011)(478600001)(7696005)(2906002)(6506007)(99286004)(8936002)(81156014)(316002)(81166006)(66066001)(14454004)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2264;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o5axeRqII1SnMI6W9kypwsRA9ThNDFxjtB0NiOHhkI43tolYZViFvMgdHQ1e29kdTXfEhBsvZOovBFSR0Ihre9r+BksKO4rtTGy1BaB2lbfURvKYGTpOfD0er4VVacxC+2IP/0VyWBln87eAyxaFvTrPI/H9Y2bKcfzxT4oX7In9scNELsPCUj9fBuH0UaRYrtmDl9MFsbDyt+Ou+zbyHLY9V4hYSTD4NbfioLQOazVS2qfXDvCRN/6HYbiai71InUaYcEpOM4ev56DKLPvHLslh8g1Pwal/WjiZBaDtfMHmzulO+leHiOmL7Yzlq6P7d8lPJ8+7AbB5oEOaj0/wkMOV1v0LOFqgvMTgOExoKSm0KUH8Gw6iJn/cBcpFSQ88puF1nmnvtyKUGnjBFNn5EdXtKBMlldFA1swlb2UvUE0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9860f454-7fc9-4cda-a0a1-08d6e2b64086
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 15:16:11.2974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2264
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IE9uZSB0aGluZyBJIGZvcmdvdCB0byBtZW50aW9uIGhlcmUgdGhhdCBzaG91bGQgZXNwZWNp
YWxseSBpbnRlcmVzdCB5b3U6DQo+ID4geW91IGFkZCBhIGxvdCBvZiBjb21wbGV4aXR5IHRvIHRo
ZSAqZHJpdmVyKiB0aGF0IG5lZWRzIHRvIHZlcmlmaWVkIGFuZA0KPiA+IG1haW50YWluZWQgKGJ5
IHRoZSBrZXJuZWwgY29tbXVuaXR5PyEpLiBTb21lIG9mIHRoZXNlIHdvcmthcm91bmRzIEkgaGFk
IHRvDQo+ID4gaW1wbGVtZW50IGFyZSByZWFsbHkgcXVpdGUgYSBjb252b2x1dGVkIG1lc3MgYW5k
IGl0J3Mgc3RhcnRpbmcgdG8gdGFrZSB1cA0KPiA+IGEgc2lnbmlmaWNhbnQgcG9ydGlvbiBvZiB0
aGUgZHJpdmVyJ3MgY29kZSBiYXNlIGFzIHdlbGwgLi4uIGp1c3QgdG8gc3VwcG9ydA0KPiA+IHNv
bWUgZnJpbmdlIGNhc2VzIHRoYXQgYXJlIG5vdCBldmVuIHJlbGV2YW50IHRvIHRoZSBoYXJkd2Fy
ZSdzIG1haW4gdXNlDQo+ID4gY2FzZXMgKGFzICJ3ZSIgYXMgdGhlICJoYXJkd2FyZSB2ZW5kb3Ii
IHNlZSBpdCkgYXQgYWxsLg0KPiA+DQo+ID4gTm90ZSB0aGF0IEkgYWN0dWFsbHkgKmhhdmUqIGlt
cGxlbWVudGVkIGFsbCB0aGVzZSB3b3JrYXJvdW5kcyBhbmQgbXkNCj4gPiBkcml2ZXIgaXMgZnVs
bHkgcGFzc2luZyBhbGwgZnV6emluZyB0ZXN0cyBldGMuIEknbSBqdXN0IG5vdCBoYXBweSB3aXRo
IGl0Lg0KPiA+DQo+DQo+IEdvb2QsIGdsYWQgdG8gaGVhciB0aGF0LiBJIHdvdWxkIHRlc3QgaXQg
bXlzZWxmIGlmIG15IE1hY2NoaWF0b0Jpbg0KPiBoYWRuJ3Qgc2VsZiBjb21idXN0ZWQgcmVjZW50
bHkgKGZvciB0aGUgc2Vjb25kIHRpbWUhKSBidXQgdGhlcmUgYXJlDQo+IHNvbWUgb3RoZXJzIHRo
YXQgdm9sdW50ZWVyZWQgSUlVQz8NCj4NClNvbWUgcGVvcGxlIGRpZCB2b2x1bnRlZXIgYWJvdXQg
YSBtb250aCBhZ28gYnV0IEkgaGF2ZW4ndCBoZWFyZCBmcm9tDQphbnkgb2YgdGhlbSBzaW5jZSAu
Li4gd2hpY2ggbWVhbnMgbXkgZml4ZXMgd29uJ3QgbWFrZSBpdCBpbnRvIGFueSBrZXJuZWwNCnRy
ZWVzIGFueSBkYXkgc29vbi4NCg0KPiBJIHRoaW5rIG5vYm9keSBpcyBoYXBweSB0aGF0IHdlIGFy
ZSBhZGRpbmcgY29kZSBsaWtlIHRoYXQgdG8gdGhlDQo+IGtlcm5lbCwgYnV0IGl0IHNlZW1zIHdl
IHdpbGwgaGF2ZSB0byBhZ3JlZSB0byBkaXNhZ3JlZSBvbiB0aGUNCj4gYWx0ZXJuYXRpdmVzLCBz
aW5jZSB0ZWFjaGluZyB0aGUgdXBwZXIgbGF5ZXJzIGFib3V0IHplcm8gbGVuZ3RoIGlucHV0cw0K
PiBiZWluZyBzcGVjaWFsIGNhc2VzIGlzIHNpbXBseSBub3QgYWNjZXB0YWJsZSAoYW5kIGl0IHdv
dWxkIHJlc3VsdCBpbg0KPiB0aG9zZSB3b3JrYXJvdW5kcyB0byBiZSBhZGRlZCB0byBnZW5lcmlj
IGNvZGUgd2hlcmUgaXQgd291bGQgYmUNCj4gYWZmZWN0aW5nIGV2ZXJ5b25lIGluc3RlYWQgb2Yg
b25seSB0aGUgdXNlcnMgb2YgeW91ciBJUCkNCj4NCllvdSBrZWVwIG1pc3NpbmcgbXkgcG9pbnQg
dGhvdWdoIC4uLiBJIHdhcyBub3Qgc3VnZ2VzdGluZyB0ZWFjaGluZw0KdXBwZXIgbGF5ZXJzIGFi
b3V0IHplcm8gbGVuZ3RocyBvciBhbnkgb3RoZXIgaGFyZHdhcmUgbGltaXRhdGlvbnMuDQpNeSBw
b2ludCBpcyB0aGF0IHRoZSBvdmVyYWwgbWFqb3J5IG9mIHRoZSAidXBwZXIgbGF5ZXJzIiBhcmUg
a25vd24gbm90DQp0byBuZWVkIHplcm8gbGVuZ3RocyBvciBhbnkgb2YgdGhlc2Ugb3RoZXIgY29y
bmVyIGNhc2VzIGFuZCBvdXIgZHJpdmVyLw0KaGFyZHdhcmUgZG9lc24ndCByZWFsbHkgY2FyZSBh
Ym91dCBzdXBwb3J0aW5nIHRoZSBvbmVzIHRoYXQgZG8sIGJlY2F1c2UNCnRob3NlICJ1cHBlciBs
YXllcnMiIHdvdWxkIG5vdCBiZW5lZml0IGZyb20gb3VyIGRyaXZlci9oYXJkd2FyZSBhbnl3YXku
DQoNCllvdSBrbm93LCBhbGwgSSAqcmVhbGx5KiBjYXJlIGFib3V0IGF0IHRoaXMgcG9pbnQgaXMg
Kmp1c3QqIHN1cHBvcnRpbmcNCnRoZSBrZXJuZWwgSVBzZWMgc3RhY2suIFRoZSByZXN0IGlzIGp1
c3QgYmFnZ2FnZSBmb3IgbWUgYW55d2F5Lg0KDQpJdCdzIGFsbCBhYm91dCBwcmV2ZW50aW5nIHRo
ZSAidXBwZXIgbGF5ZXJzIiBmcm9tIHNlbGVjdGluZyBvdXIgZHJpdmVyLg0KV2hpY2ggY2FuIGJl
IGFycmFuZ2VkIHZlcnkgZWFzaWx5LiBKdXN0IHNldCBjcmFfcHJpb3JpdHkgdG8gMCB3aGljaA0K
cmVxdWlyZXMgaXQgdG8gYmUgc2VsZWN0ZWQgZXhwbGljaXRseSwgbW92aW5nIHRoZSByZXNwb25z
aWJpbGl0eSB0bw0Kd2hvbWV2ZXIgY29uZmlndXJlcyB0aGUgbWFjaGluZS4NCg0KPiBCdXQgSSBm
dWxseSB1bmRlcnN0YW5kIHRoYXQgZGVhbGluZyB3aXRoIHRoaXMgY2FzZSBpbiBoYXJkd2FyZSBp
cyBub3QNCj4gZmVhc2libGUgZWl0aGVyLCBhbmQgc28gdGhpcyBhcHByb2FjaCBpcyB3aGF0IHdl
IHdpbGwgaGF2ZSB0byBsaXZlDQo+IHdpdGguDQo+DQpXZSBkb24ndCAqaGF2ZSogdG8gZG8gYW55
dGhpbmcgLi4uIHRoaXMgdGhpbmcgaXMgbm90IHNldCBpbiBzdG9uZSBhcyBmYXINCmFzIEkga25v
dy4gV2UgY291bGQgYWN0dWFsbHkgY29tZSB1cCB3aXRoIGEgcmVhbCBjb21wcm9taXNlLCB3aGlj
aCB0aGlzDQppcyBub3QuIEl0IGp1c3QgcmVxdWlyZXMgc29tZSBmbGV4aWJpbGl0eSBvZiBtaW5k
IGFuZCBzb21lIGdvb2Qgd2lsbCAuLi4NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0K
U2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMNCnd3dy5pbnNpZGVz
ZWN1cmUuY29tDQoNCg==
