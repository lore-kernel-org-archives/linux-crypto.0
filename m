Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6638C282E1
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5AC217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="1M0KcJ1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbfEXJed (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:34:33 -0400
Received: from mail-eopbgr10090.outbound.protection.outlook.com ([40.107.1.90]:63815
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389582AbfEXJed (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hKlUwDruFOK1GcShUCFAqBkA2cGmC02WLSQi38FJtY=;
 b=1M0KcJ1liawHk/rWD1/1FExG73s0xiElCw0DMu/AFqnXznDZq6FKj3q3f7oqjj1T2DjgTgFKo0l1HYucb0dru3nP3kZNrsHfx0Tljxjaeqt52+RJD+79wvfJcPSo4NHn2NyRCNKlWyS8fQg3TcVgETZNK+sIwSKPQQZFIWf22Pw=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3269.eurprd09.prod.outlook.com (20.179.244.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 09:34:29 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 09:34:29 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MA==
Date:   Fri, 24 May 2019 09:34:28 +0000
Message-ID: <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
In-Reply-To: <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37c3f195-a2f4-4cc3-e9e2-08d6e02b04f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3269;
x-ms-traffictypediagnostic: AM6PR09MB3269:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB32699630FEB1EEF17E39444BD2020@AM6PR09MB3269.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39850400004)(396003)(366004)(136003)(199004)(189003)(8936002)(186003)(8676002)(81156014)(81166006)(14454004)(68736007)(99286004)(316002)(26005)(54906003)(305945005)(7736002)(486006)(6916009)(14444005)(11346002)(476003)(446003)(256004)(66066001)(52536014)(2906002)(6116002)(3846002)(9686003)(55016002)(33656002)(229853002)(6436002)(5660300002)(6506007)(4326008)(102836004)(7696005)(86362001)(76176011)(25786009)(6246003)(3480700005)(74316002)(7116003)(478600001)(15974865002)(53936002)(71200400001)(66476007)(73956011)(66946007)(71190400001)(76116006)(66556008)(64756008)(66446008)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3269;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LJSQ7hhkzcGDq4XygqaJEZUkR/9fn81VWvfhFh+cBIYdOK5vLjImEkyPNST2ipHkRg9lBn6Zf2VOFxf7XQYw301nr6L4BkDFE2BDvZbhcav016yBCxKXLuXO8QyWfK2+JKr/TI89Y9LIl8sY1mCtATrVm6QlKUGUgAPLRSCN53hL1NHuJRcuGgfY49ZNp+jzdWk5LG1I2zgCd76gi8OgzEJtMm4csGOBSpEPaKN4wVsnmipf0Iu2QWiijz8IIQiMyw9kK+9IKo8UkeOg51Rs8AIyJdL74x9ZQZhpaQ0Xp+J0CLv2hJu0nVtTyAdQjoOmIVZj+k/gGbLCttjWWqIITH/iMfAdc/fwjK3w1EQYmIK95Y5MSYwtRZzpnl/I+uNTEjLlO6dlGLKm8mAV+5dANoYlEl4Epe9JDUVMY41g6nw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c3f195-a2f4-4cc3-e9e2-08d6e02b04f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:34:28.9275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3269
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBBbGwgdXNlcmxhbmQgY2xpZW50cyBvZiB0aGUgaW4ta2VybmVsIGNyeXB0byB1c2UgaXQgc3Bl
Y2lmaWNhbGx5IHRvDQo+IGFjY2VzcyBoL3cgYWNjZWxlcmF0b3JzLCBnaXZlbiB0aGF0IHNvZnR3
YXJlIGNyeXB0byBkb2Vzbid0IHJlcXVpcmUNCj4gdGhlIGhpZ2hlciBwcml2aWxlZ2UgbGV2ZWwg
KG5vIHBvaW50IGluIGlzc3VpbmcgdGhvc2UgQUVTIENQVQ0KPiBpbnN0cnVjdGlvbnMgZnJvbSB0
aGUga2VybmVsIGlmIHlvdSBjYW4gaXNzdWUgdGhlbSBpbiB5b3VyIHByb2dyYW0NCj4gZGlyZWN0
bHkpDQo+DQo+IEJhc2ljYWxseSwgd2hhdCBpcyB1c2VkIGlzIGEgc29ja2V0IGludGVyZmFjZSB0
aGF0IGNhbiBibG9jayBvbg0KPiByZWFkKCkvd3JpdGUoKS4gU28gdGhlIHVzZXJzcGFjZSBwcm9n
cmFtIGRvZXNuJ3QgbmVlZCB0byBiZSBhd2FyZSBvZg0KPiB0aGUgYXN5bmNocm9ub3VzIG5hdHVy
ZSwgaXQgaXMganVzdCBmcm96ZW4gd2hpbGUgdGhlIGNhbGxzIGFyZSBiZWluZw0KPiBoYW5kbGVk
IGJ5IHRoZSBoYXJkd2FyZS4NCj4NCldpdGggYWxsIGR1ZSByZXNwZWN0LCBidXQgaWYgdGhlIHVz
ZXJsYW5kIGFwcGxpY2F0aW9uIGlzIGluZGVlZA0KKmZyb3plbiogd2hpbGUgdGhlIGNhbGxzIGFy
ZSBiZWluZyBoYW5kbGVkLCB0aGVuIHRoYXQgc2VlbXMgbGlrZSBpdHMNCnByZXR0eSB1c2VsZXNz
IC0gZm9yIHN5bW1ldHJpYyBjcnlwdG8sIGFueXdheSAtIGFzIHBlcmZvcm1hbmNlIHdvdWxkIGJl
DQpkb21pbmF0ZWQgYnkgbGF0ZW5jeSwgbm90IHRocm91Z2hwdXQuDQpIYXJkd2FyZSBhY2NlbGVy
YXRpb24gd291bGQgYWxtb3N0IGFsd2F5cyBsb3NlIHRoYXQgY29tcGFyZWQgdG8gYSBsb2NhbA0K
c29mdHdhcmUgaW1wbGVtZW50YXRpb24uDQpJIGNlcnRhaW5seSB3b3VsZG4ndCB3YW50IHN1Y2gg
YW4gb3BlcmF0aW9uIHRvIGVuZCB1cCBhdCBteSBkcml2ZXIhDQoNCldoaWNoIGJyaW5ncyB1cCBh
IHF1ZXN0aW9uOiBpcyB0aGVyZSBzb21lIHdheSBmb3IgYSBkcml2ZXIgdG8gaW5kaWNhdGUNCnNv
bWV0aGluZyBsaWtlICJkb24ndCB1c2UgbWUgdW5sZXNzIHlvdSBjYW4gc2VyaW91c2x5IHBpcGVs
aW5lIHlvdXINCnJlcXVlc3RzIj8NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2ls
aWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBJbnNpZGUgU2VjdXJl
DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0KDQo=
