Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABB7C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 20:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F0E42075E
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 20:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="IOxKr9S1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfE0Uqv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 16:46:51 -0400
Received: from mail-eopbgr80099.outbound.protection.outlook.com ([40.107.8.99]:37027
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbfE0Uqv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 16:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfH2tA8b+1NxT7Ynp6Mbr0XbFUcBAupvI1oaSJ54oq8=;
 b=IOxKr9S1ORDBXRVbjRfED8N6doPX0ueQrAdKK6sL3u77mQsLLnFY8V+5HcKBTveapG/CxTUAedtAw5DGfWWeH7Khip0MjFJMFS8pQC49S2nV8AH4A4c2FUo/bk9u08Uh7uK4UYuK9/zAwjdRPj27ioT5nI4V7pvF/9966uQ2Ub4=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3027.eurprd09.prod.outlook.com (10.255.96.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.20; Mon, 27 May 2019 20:46:46 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 20:46:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAS0FFCAAAQtAIAAAZkAgAAJO4CAAADysIAABwUAgAAHPfCAABPWkIAAJKQAgAACLPCAAAjaAIAAUYEQ
Date:   Mon, 27 May 2019 20:46:46 +0000
Message-ID: <AM6PR09MB352361519A463D3A20F8190AD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
 <AM6PR09MB35231DD72CBD3CC7B6EA96FDD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu87J0wZSkNCritGmrrGZ5ems7OE2zSM2k9HDGYZ8Ogmog@mail.gmail.com>
In-Reply-To: <CAKv+Gu87J0wZSkNCritGmrrGZ5ems7OE2zSM2k9HDGYZ8Ogmog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24426fa8-468b-41de-e792-08d6e2e46f25
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3027;
x-ms-traffictypediagnostic: AM6PR09MB3027:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB302736EA7C590D66568E99F5D21D0@AM6PR09MB3027.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39850400004)(346002)(136003)(199004)(189003)(305945005)(99286004)(6506007)(7696005)(102836004)(2906002)(76176011)(7736002)(7116003)(71190400001)(54906003)(74316002)(5660300002)(86362001)(6916009)(8676002)(71200400001)(81156014)(81166006)(186003)(3480700005)(53936002)(966005)(26005)(316002)(6246003)(8936002)(4326008)(3846002)(6116002)(478600001)(25786009)(15974865002)(66446008)(64756008)(446003)(6436002)(66946007)(76116006)(229853002)(66556008)(66476007)(55016002)(68736007)(6306002)(33656002)(73956011)(9686003)(476003)(11346002)(66066001)(14454004)(486006)(14444005)(256004)(52536014)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3027;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pDiebhPQroA7GdqKFBJ5lp/Xu7+p8roleFwnrY8+mVpiAD3LrFoh9ioaxNrxuSfWRK78R7rNV8bu2hl+YIpPYzi+Ye+c3f1UjFPehPRLiazd9Pf0N+WoO6XpDwbo8YmovFWur3QFOUbaoxvETa/RTWhqrq3e/uDrnQOWvERlkmFzbh6+4j4y2PKc8BBI0aoI1SHHQ66GgTpJXX1pX+u5RZ6zvEMtT0TYyt4f7W6+Z+4rFV0CFPjOgCVkGM8WVNtw8F6jPlGnwNwgvCQxh1fyuzXGmqywoPHGTYGVs4NmN8TKUDs0cHbsfiXXz1Majn2+0bWjv3tBP6ZVzikFhuUlRCSXS/ZhNWStaCZEyYy1oFp/PU+38ooo054m2d7d2Qy4KMHd3EJBj9tY8WQ9RuKfQYuLjNShZWrTOJVIRPhzM7A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24426fa8-468b-41de-e792-08d6e2e46f25
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 20:46:46.3550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3027
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IFNvbWUgcGVvcGxlIGRpZCB2b2x1bnRlZXIgYWJvdXQgYSBtb250aCBhZ28gYnV0IEkgaGF2
ZW4ndCBoZWFyZCBmcm9tDQo+ID4gYW55IG9mIHRoZW0gc2luY2UgLi4uIHdoaWNoIG1lYW5zIG15
IGZpeGVzIHdvbid0IG1ha2UgaXQgaW50byBhbnkga2VybmVsDQo+ID4gdHJlZXMgYW55IGRheSBz
b29uLg0KPiA+DQo+DQo+IE9LLiBDYW4geW91IHNoYXJlIHlvdXIgZ2l0IHRyZWUgYWdhaW4/IEkg
d2lsbCB0cnkgdG8gcGluZyBzb21lIHBlb3BsZS4NCj4NCldlbGwsIEkganVzdCBnb3QgYSByZXNw
b25zZSwgYnV0IGluIGNhc2UgYW55b25lIGVsc2UgaXMgaW50ZXJlc3RlZDoNCmh0dHBzOi8vZ2l0
aHViLmNvbS9wdmFubGVldXdlbi9saW51eC5naXQsIGJyYW5jaCAiaXNfZHJpdmVyX2FybWFkYV9m
aXgiDQoNCj4gPiBZb3Uga2VlcCBtaXNzaW5nIG15IHBvaW50IHRob3VnaCAuLi4gSSB3YXMgbm90
IHN1Z2dlc3RpbmcgdGVhY2hpbmcNCj4gPiB1cHBlciBsYXllcnMgYWJvdXQgemVybyBsZW5ndGhz
IG9yIGFueSBvdGhlciBoYXJkd2FyZSBsaW1pdGF0aW9ucy4NCj4gPiBNeSBwb2ludCBpcyB0aGF0
IHRoZSBvdmVyYWwgbWFqb3J5IG9mIHRoZSAidXBwZXIgbGF5ZXJzIiBhcmUga25vd24gbm90DQo+
ID4gdG8gbmVlZCB6ZXJvIGxlbmd0aHMgb3IgYW55IG9mIHRoZXNlIG90aGVyIGNvcm5lciBjYXNl
cyBhbmQgb3VyIGRyaXZlci8NCj4gPiBoYXJkd2FyZSBkb2Vzbid0IHJlYWxseSBjYXJlIGFib3V0
IHN1cHBvcnRpbmcgdGhlIG9uZXMgdGhhdCBkbywgYmVjYXVzZQ0KPiA+IHRob3NlICJ1cHBlciBs
YXllcnMiIHdvdWxkIG5vdCBiZW5lZml0IGZyb20gb3VyIGRyaXZlci9oYXJkd2FyZSBhbnl3YXku
DQo+ID4NCj4NCj4gWWVzLCBidXQgJ2FyZSBub3Qga25vd24nIHRvZGF5IGlzIG5vdCBlbm91Z2gu
IE9uY2Ugd2Ugb3BlbiB0aGF0IGRvb3IsDQo+IGl0IGJlY29tZXMgb3VyIHJlc3BvbnNpYmlsaXR5
IGFzIGtlcm5lbCBtYWludGFpbmVycyB0byBlbnN1cmUgdGhhdA0KPiB0aGlzIHJlbWFpbnMgdGhl
IGNhc2UuDQo+DQpObywgdGhlIG9ubHkgcmVzcG9uc2liaWxpdHkgaXQgbWlnaHQgYWRkIGlzIHRo
ZSByZXNwb25zaWJpbGl0eSB0bw0KdmFsaWRhdGUgdGhhdCBkcml2ZXIgWCBpbmRlZWQgc3RpbGwg
d29ya3Mgd2l0aCAidXBwZXIgbGF5ZXIiIFksIGFuZCBpZg0Kbm90LCB0byB1cGRhdGUgdGhlIGRy
aXZlcnMnIFJFQURNRSB0byByZW1vdmUgdGhhdCBhc3NlcnRpb24uDQoNCkJ1dCBob25lc3RseSBo
b3cgRE8gdGhlIGtlcm5lbCBtYWludGFpbmVycyB2YWxpZGF0ZSB0aGF0IGRyaXZlciBYIGlzDQpu
b3QgYnJva2VuLCBjb25zaWRlcmluZyB0aGV5IG1heSBub3QgaGF2ZSBhY2Nlc3MgdG8gdGhlIGFj
dHVhbCBoYXJkd2FyZT8NCkkgZG9uJ3QgcmVhbGx5IGdldCB0aGUgaW1wcmVzc2lvbiBhbnlvbmUg
aXMgYWN0aXZlbHkgdmVyaWZ5aW5nIHRoZQ0KSW5zaWRlIFNlY3VyZSBkcml2ZXIgaXMgc3RpbGwg
d29ya2luZyBmb3IgZXZlcnkga2VybmVsIHJlbGVhc2UgLi4uDQoNClNvIEkgdGhpbmsgaXQncyBh
IHByZXR0eSBtb290IHBvaW50IC0geW91J3JlIG5vdCBkb2luZyB0aGF0IGFueXdheS4NCg0KPiBT
byBpIHVuZGVyc3RhbmQgcGVyZmVjdGx5IHdlbGwgdGhhdCBjdXJyZW50IGluLWtlcm5lbCB1c2Vy
cyBtYXkgbmV2ZXINCj4gaXNzdWUgY3J5cHRvIHJlcXVlc3RzIHRoYXQgZXhlcmNpc2UgdGhpcyBj
b2RlIHBhdGguIEJ1dCB0aGUgbmljZSB0aGluZw0KPiB0b2RheSBpcyB0aGF0IHdlIGRvbid0IGhh
dmUgdG8gY2FyZSBhYm91dCB0aGlzIGF0IGFsbCwgc2luY2UgemVybw0KPiBsZW5ndGggdmVjdG9y
cyBhcmUgc2ltcGx5IHN1cHBvcnRlZCBhcyB3ZWxsLiBPbmNlIHdlIHN0YXJ0DQo+IGRpc3Rpbmd1
aXNoaW5nIHRoZSB0d28sIHdlIGhhdmUgdG8gc3RhcnQgcG9saWNpbmcgdGhpcyBhdCAqc29tZSog
bGV2ZWwNCj4gcmF0aGVyIHRoYW4ganVzdCBwcmV0ZW5kIHRoZSBpc3N1ZSBpc24ndCB0aGVyZSBh
bmQgZ2V0IGJpdHRlbiBieSBpdA0KPiBkb3duIHRoZSByb2FkLg0KPg0KSSdtIG5vdCBwcmV0ZW5k
aW5nIHRoZSBpc3N1ZSBpc24ndCB0aGVyZS4gSSBqdXN0ICprbm93KiBJIGRvbid0IGNhcmUNCmFi
b3V0IHRoZSBpc3N1ZSBmb3IgbXkgcGFydGljdWxhciBkcml2ZXIvaHcgYXQgYWxsIGJlY2F1c2Ug
aXQncw0KaXJyZWxldmFudCBmb3IgdGhlICJ1cHBlciBsYXllciJzIEknbSBhY3R1YWxseSBzcGVj
aWZpY2FsbHkgdGFyZ2V0dGluZy4NCg0KPiBTbyBubywgaSBhbSBub3QgbWlzc2luZyB5b3VyIHBv
aW50LiBCdXQgSSB0aGluayB3ZSBkaXNhZ3JlZSBvbiB5b3VyDQo+IGNvbmNsdXNpb24gdGhhdCB0
aGlzIHBlcm1pdHMgaXMgdG8gb3B0aW1pemUgdGhpcyBjYXNlIGF3YXkgYW5kIHNpbXBseQ0KPiBk
b24ndCByZWFzb24gYWJvdXQgaXQgYXQgYWxsLg0KPg0KSSBuZXZlciBjb25jbHVkZWQgdG8gb3B0
aW1pemUgdGhlIGNhc2UgYXdheSBhY3Jvc3MgdGhlIHdob2xlIEFQSS4NCk9yIG5vdCByZWFzb25p
bmcgYWJvdXQgaXQgYXQgYWxsIGZvciB0aGF0IG1hdHRlci4gSnVzdCBmb3IgY3V0dGluZw0KZHJp
dmVycyBzb21lIHNsYWNrLCB1bmRlciB0aGUgZXhwbGljaXQgY29uZGl0aW9uIHRoYXQgdGhleSdy
ZSBub3QNCmV2ZXIgc2VsZWN0ZWQgYXMgZGVmYXVsdCBpbXBsZW1lbnRhdGlvbi4NCg0KPiA+IFlv
dSBrbm93LCBhbGwgSSAqcmVhbGx5KiBjYXJlIGFib3V0IGF0IHRoaXMgcG9pbnQgaXMgKmp1c3Qq
IHN1cHBvcnRpbmcNCj4gPiB0aGUga2VybmVsIElQc2VjIHN0YWNrLiBUaGUgcmVzdCBpcyBqdXN0
IGJhZ2dhZ2UgZm9yIG1lIGFueXdheS4NCj4gPg0KPg0KPiBJIHNlZS4NCj4NCj4gPiBJdCdzIGFs
bCBhYm91dCBwcmV2ZW50aW5nIHRoZSAidXBwZXIgbGF5ZXJzIiBmcm9tIHNlbGVjdGluZyBvdXIg
ZHJpdmVyLg0KPiA+IFdoaWNoIGNhbiBiZSBhcnJhbmdlZCB2ZXJ5IGVhc2lseS4gSnVzdCBzZXQg
Y3JhX3ByaW9yaXR5IHRvIDAgd2hpY2gNCj4gPiByZXF1aXJlcyBpdCB0byBiZSBzZWxlY3RlZCBl
eHBsaWNpdGx5LCBtb3ZpbmcgdGhlIHJlc3BvbnNpYmlsaXR5IHRvDQo+ID4gd2hvbWV2ZXIgY29u
ZmlndXJlcyB0aGUgbWFjaGluZS4NCj4gPg0KPg0KPiBTbyB3aGljaCBhbGdvcml0aG1zIHRoYXQg
SVBzZWMgYWN0dWFsbHkgdXNlcyBvbiB5b3VyIGhhcmR3YXJlIGRvZXMNCj4gdGhpcyBpc3N1ZSBh
cHBseSB0bz8gRG9lcyB0aGUgaGFyZHdhcmUgaW1wbGVtZW50IHRoZSBjb21wbGV0ZSBBRUFEDQo+
IHRyYW5zZm9ybT8gT3IgZG9lcyBpdCByZWx5IG9uIHNvZnR3YXJlIHRvIHdpcmUgdGhlIE1BQyBh
bmQgc2tjaXBoZXINCj4gcGllY2VzIHRvZ2V0aGVyPw0KPg0KQWN0dWFsbHksIGl0IENBTiBkbyB0
aGUgZnVsbCBFU1AgdHJhbnNmb3JtLiBQbHVzIHRoZSBJUCBoZWFkZXIgcHJvY2Vzc2luZy4NCkJ1
dCBzaW5jZSB0aGF0IGNhbm5vdCBiZSBhY2NlbGVyYXRlZCB5ZXQsIEknbSBoYXBweSBqdXN0IHRv
IGdldCBzb21lIEFFQUQNCmFjY2VsZXJhdGlvbiBnb2luZy4gUGVyaGFwcyB3aXRoIElWIGdlbmVy
YXRpb24gcHVsbGVkIGluIGFzIHdlbGwuDQoNCj4gPiA+IEJ1dCBJIGZ1bGx5IHVuZGVyc3RhbmQg
dGhhdCBkZWFsaW5nIHdpdGggdGhpcyBjYXNlIGluIGhhcmR3YXJlIGlzIG5vdA0KPiA+ID4gZmVh
c2libGUgZWl0aGVyLCBhbmQgc28gdGhpcyBhcHByb2FjaCBpcyB3aGF0IHdlIHdpbGwgaGF2ZSB0
byBsaXZlDQo+ID4gPiB3aXRoLg0KPiA+ID4NCj4gPiBXZSBkb24ndCAqaGF2ZSogdG8gZG8gYW55
dGhpbmcgLi4uIHRoaXMgdGhpbmcgaXMgbm90IHNldCBpbiBzdG9uZSBhcyBmYXINCj4gPiBhcyBJ
IGtub3cuIFdlIGNvdWxkIGFjdHVhbGx5IGNvbWUgdXAgd2l0aCBhIHJlYWwgY29tcHJvbWlzZSwg
d2hpY2ggdGhpcw0KPiA+IGlzIG5vdC4gSXQganVzdCByZXF1aXJlcyBzb21lIGZsZXhpYmlsaXR5
IG9mIG1pbmQgYW5kIHNvbWUgZ29vZCB3aWxsIC4uLg0KPiA+DQo+DQo+IFRoZSBMYXRpbiB0ZXJt
IGVzY2FwZXMgbWUsIGJ1dCBzdXJlbHksIGNvbXBsYWluaW5nIGFib3V0IHRoZSBvdGhlcidzDQo+
IHVud2lsbGluZ25lc3MgdG8gY29tcHJvbWlzZSByYXRoZXIgdGhhbiBnaXZlIGFjdHVhbCBjb252
aW5jaW5nDQo+IGFyZ3VtZW50cyBpcyBvbmUgb2YgdGhlIHdlbGwga25vd24gcmhldG9yaWNhbCBm
YWxsYWNpZXM/IDotKQ0KPg0KSSBkb24ndCBrbm93LCBJJ20ganVzdCBhbiBlbmdpbmVlciwgbm90
IGEgcmhldG9yaWNhbCBtYXN0ZXJtaW5kIDotKQ0KDQpCdXQgeW91IHdlcmUgdGhlIG9uZSBjbGFp
bWluZyB0byBjb21wcm9taXNlIGFuZCBJJ20ganVzdCBtYWtpbmcgdGhlDQpvYnNlcnZhdGlvbiB0
aGF0IEkgZG9uJ3Qgc2VlIGEgd2hvbGUgbG90IG9mIGNvbXByb21pc2U6IGl0J3MgZWl0aGVyDQpp
bXBsZW1lbnQgZXZlcnkgbGl0dGxlIGNvcm5lciBvZiB0aGUgYWxnb3JpdGhtcyBvciBidXN0LCBp
dCBzZWVtcy4NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNo
aXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBJbnNpZGUgU2VjdXJlDQp3d3cuaW5zaWRl
c2VjdXJlLmNvbQ0K
