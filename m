Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CD5C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BD4C2146F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 10:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="CpXIniM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfE0Knw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 06:43:52 -0400
Received: from mail-eopbgr10104.outbound.protection.outlook.com ([40.107.1.104]:34811
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfE0Knw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 06:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrdpJ4jIfxr8GxEmBX7Uh99l4sMI7+AIHOizXFZyuCY=;
 b=CpXIniM6Vt+ZFW2HV+YsQhat+5nE2qwHXncTgp+uJ/flwCPpPDDHtHMdWb5mCx/uAQ3JKoe7bn1Ng1KklwGtVXlzK9DIVY+yiPbRa90UEnxDgDmNXrw6uV6cWQlm4tv4SoWWu6ZLz+Aew5/apwnUg322Akd2/ZgjY3YOGaq/eco=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2933.eurprd09.prod.outlook.com (20.179.2.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Mon, 27 May 2019 10:43:43 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 10:43:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAS0FFCAAAQtAIAAAZkAgAAJO4CAAADysA==
Date:   Mon, 27 May 2019 10:43:42 +0000
Message-ID: <AM6PR09MB3523090454E4FB6825797A0FD21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
In-Reply-To: <CAKv+Gu8ScTXM2qxrG__RW6SLKZYrevjfCi_HxpSOJRH5+9Knzg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b145c2d-67ad-4567-c05d-08d6e2903031
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2933;
x-ms-traffictypediagnostic: AM6PR09MB2933:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB29330BB0DAFFC1C0DD572C39D21D0@AM6PR09MB2933.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(396003)(376002)(39850400004)(54014002)(189003)(199004)(5660300002)(52536014)(478600001)(66476007)(66556008)(102836004)(64756008)(53936002)(3480700005)(68736007)(7116003)(74316002)(86362001)(26005)(81156014)(66446008)(186003)(14454004)(8936002)(15974865002)(229853002)(81166006)(73956011)(6246003)(8676002)(76116006)(6506007)(66946007)(4326008)(71190400001)(71200400001)(2906002)(99286004)(7696005)(14444005)(256004)(6436002)(486006)(7736002)(305945005)(446003)(25786009)(6916009)(54906003)(9686003)(3846002)(6116002)(33656002)(55016002)(476003)(66066001)(316002)(11346002)(76176011)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2933;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5ohuN95HP5i2QJp1z8mLgwp8folu54DHJS46AJb1xN9G7g+PtlWCsqwPdrIXWcUydGO2AP9NHm6vhy6IizDCcJYBeWFhqhFs5fAGhFJbNqjJLJW7EGyM9+/pOd0hOo3Z7UH9yV8Xc0n4SXkhIgPTcXPGF2xXVphmxvtf9WVc55IDFUD/zy3g+utSEt6AEd63pHWkIw3mEWDLLURR9l+6EkpS4lHbXuR5gnVmSPOIS40sMV1Khn0IGgh2eKQTtMCejojaWqM2xHYZ3A9HvWU+6q2gGx8azLa4j2r+/S5xA2zWd97Cvlf0fY8mvfkOb4f0VaFTZ/XWikGM2Iv3gtvHubISgkXxqHb+NQAuSahRaWhh5I8slJrNPhormx6eKzlyh7DQIun0QljozOqIjf5CO+mXJRgqCQKAivQYhhVSbEs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b145c2d-67ad-4567-c05d-08d6e2903031
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 10:43:43.0099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2933
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBBcyBJIGV4cGxhaW5lZCBiZWZvcmUsIHdoYXQgYXBwZWFycyBzeW5jaHJvbm91cyB0byBhIHNp
bmdsZSB1c2VybGFuZA0KPiBwcm9jZXNzIG1heSBsb29rIHZlcnkgZGlmZmVyZW50bHkgZnJvbSB0
aGUgT1MgYW5kIGgvdyBwZXJzcGVjdGl2ZS4gQnV0DQo+IG9mIGNvdXJzZSwgSSB0YWtlIHlvdXIg
cG9pbnQgdGhhdCBoL3cgaXMgbm90IGZhc3RlciB0aGFuIHRoZSBDUFUgaW4NCj4gdGhlIGdlbmVy
YWwgY2FzZSwgYW5kIHNvIGNhcmUgbXVzdCBiZSB0YWtlbi4NCj4NCiJTeW5jaHJvbm91cyIgaW4g
dGhpcyBjb250ZXh0IHdhcyByZWZlcnJpbmcgdG8gYSB1c2UgY2FzZSB3aGVyZSB0aGUNCmFwcGxp
Y2F0aW9uIGRvZXMgYSByZXF1ZXN0IGFuZCB0aGVuICp3YWl0cyogZm9yIHRoZSByZXN1bHQgb2Yg
dGhhdA0KcmVxdWVzdCBiZWZvcmUgY29udGludWluZy4NCldoaWxlICJhc3luY2hyb25vdXMiIHdv
dWxkIHJlZmVyIHRvIGEgY2FzZSB3aGVyZSB0aGUgYXBwbGljYXRpb24gZmlyZXMNCm9mZiBhIHJl
cXVlc3QgYW5kIHRoZW4gbWVycmlseSBnb2VzIG9mZiBkb2luZyAib3RoZXIiIHRoaW5ncyAod2hp
Y2gNCmNvdWxkIGJlLCBidXQgaXMgbm90IGxpbWl0ZWQgdG8sIHByZXBhcmluZyBhbmQgcG9zdGlu
ZyBuZXcgcmVxdWVzdHMpLg0KDQpTbyBJJ20gc3RyaWN0bHkgdmlld2luZyBpdCBmcm9tIHRoZSBh
cHBsaWNhdGlvbnMnIHBlcnNwZWN0aXZlIGhlcmUuDQoNCj4gVGhpcyBpcyBtYWRlIHdvcnNlIGJ5
IHRoZSBwcmlvcml0eSBzY2hlbWUsIHdoaWNoIGRvZXMgbm90IHJlYWxseQ0KPiBjb252ZXJ5IGlu
Zm9ybWF0aW9uIGxpa2UgdGhpcy4NCj4NClllcywgdGhlIHByaW9yaXR5IHNjaGVtZSBpcyBmYXIg
dG9vIHNpbXBsaXN0aWMgdG8gY292ZXIgYWxsIGRldGFpbHMNCnJlZ2FyZGluZyBoYXJkd2FyZSBh
Y2NlbGVyYXRpb24uIFdoaWNoIHdoeSB3ZSBwcm9iYWJseSBzaG91bGRuJ3QgdXNlDQppdCB0byBz
ZWxlY3QgaGFyZHdhcmUgZHJpdmVycyBhdCBhbGwuDQoNCj4gPiBCdXQgdGhlbiBhZ2FpbiB0aGF0
IHdvdWxkIHN0aWxsIGJlIHRvbyBzaW1wbGlzdGljIHRvIHNlbGVjdCB0byBiZXN0DQo+ID4gZHJp
dmVyIHVuZGVyIGFsbCBwb3NzaWJsZSBjaXJjdW1zdGFuY2VzIC4uLiBzbyB3aHkgZXZlbiBib3Ro
ZXIuDQo+ID4NCj4gPiA+IGZsYWcgZm9yIHRoYXQuIEJ1dCBldmVuIGlmIHRoYXQgZG9lcyBoYXBw
ZW4sIGl0IGRvZXNuJ3QgbWVhbiB5b3UgY2FuDQo+ID4gPiBzdG9wIGNhcmluZyBhYm91dCB6ZXJv
IGxlbmd0aCBpbnB1dHMgOi0pDQo+ID4gPg0KPiA+IElmIHRoZSBzZWxlY3Rpb24gb2YgdGhlIGhh
cmR3YXJlIGRyaXZlciBiZWNvbWVzIGV4cGxpY2l0IGFuZCBub3QNCj4gPiBhdXRvbWF0aWMsIHlv
dSBjb3VsZCBhcmd1ZSBmb3IgYSBjYXNlIHdoZXJlIHRoZSBkcml2ZXIgZG9lcyBOT1QgaGF2ZQ0K
PiA+IHRvIGltcGxlbWVudCBhbGwgZGFyayBjb3JuZXJzIG9mIHRoZSBBUEkuIEFzLCBhcyBhIGhh
cmR3YXJlIHZlbmRvciwNCj4gPiB3ZSBjb3VsZCBzaW1wbHkgcmVjb21tZW5kIE5PVCB0byB1c2Ug
aXQgZm9yIGFwcGxpY2F0aW9uIFhZWiAgYmVjYXVzZQ0KPiA+IGl0IGRvZXMgdGhpbmdzIC0gbGlr
ZSB6ZXJvIGxlbmd0aCBtZXNzYWdlcyAtIHdlIGRvbid0IHN1cHBvcnQuDQo+ID4NCj4NCj4gU3Bv
a2VuIGxpa2UgYSB0cnVlIGgvdyBndXkgOi0pDQo+DQpHdWlsdHkgYXMgY2hhcmdlZC4gSSBBTSBh
IHRydWUgSC9XIGd1eSBhbmQgbm90IGEgc29mdHdhcmUgZW5naW5lZXIgYXQgYWxsLg0KQnV0IGhh
dmUgeW91IGV2ZXIgc3RvcHBlZCB0byB3b25kZXIgV0hZIGFsbCBoYXJkd2FyZSBndXlzIHRhbGsg
bGlrZSB0aGF0Pw0KTWF5YmUsIGp1c3QgbWF5YmUsIHRoZXkgaGF2ZSBhIGRhbW4gZ29vZCByZWFz
b24gdG8gZG8gc28gLi4uDQoNCj4gT3VyIGNyeXB0byBzL3cgc3RhY2sgYW5kIHRoZSBzdG9yYWdl
LCBuZXR3b3JraW5nIGFuZCBvdGhlciBzdWJzeXN0ZW1zDQo+IHRoYXQgYXJlIGxheWVyZWQgb24g
dG9wIG9mIGl0IGFyZSBjb21wbGV4IGVub3VnaCB0aGF0IHdlIHNob3VsZG4ndCB0cnkNCj4gdG8g
Y2F0ZXIgZm9yIG5vbi1jb21wbGlhbnQgaGFyZHdhcmUuIFRoaXMgaXMgd2h5IHlvdSBuZWVkIHRv
IGZpeCB0aGlzDQo+IGluIHlvdXIgZHJpdmVyOiB0byBwcmV2ZW50IHRoZSBpc3N1ZSBmcm9tIGxl
YWtpbmcgaW50byBvdGhlciBsYXllcnMsDQo+IG1ha2luZyBpdCBldmVuIG1vcmUgZGlmZmljdWx0
IHRvIGRvIHRlc3RpbmcgYW5kIHZhbGlkYXRpb24uDQo+DQpOb3cgd2hlcmUgYW0gSSBzdWdnZXN0
aW5nIHRoYXQgYXBwbGljYXRpb25zIHNob3VsZCBjYXRlciBmb3Igbm9uLWNvbXBsaWFudA0KaGFy
ZHdhcmU/IEknbSBzaW1wbHkgc3VnZ2VzdGluZyB0aGF0IHlvdSBzaG91bGQgTk9UIHVzZSB0aGUg
aGFyZHdhcmUgZm9yDQpzdWNoIGFuIGFwcGxpY2F0aW9uIGF0IGFsbC4gSWYgeW91IG1ha2UgaXQg
ZXhwbGljaXQsIHlvdSBjYW4gZG8gdGhhdC4NCg0KQW5kIGJlc2lkZXMsIHdobyBkZWNpZGVzIHdo
YXQgaXMgImNvbXBsaWFudCIgYW5kIHdoYXQgdGhlIHJ1bGVzIGFyZT8NClBsZWFzZSBrZWVwIGlu
IG1pbmQgdGhhdCBleGlzdGluZyBoYXJkd2FyZSBjYW5ub3QgYmUgY2hhbmdlZC4gU28gd2h5DQp3
YXNuJ3QgdGhlIEFQSSBkZXNpZ25lZCBhcm91bmQgdGhlIGxpbWl0YXRpb25zIG9mICpleGlzdGlu
ZyogaGFyZHdhcmU/DQpJdCBjYW4gdGFrZSBzZXZlcmFsIHllYXJzIGZvciBhIGhhcmR3YXJlIGZp
eCB0byByZWFjaCB0aGUgZW5kIHVzZXIgLi4uDQoNCkFzIGZvciB0ZXN0aW5nIGFuZCB2YWxpZGF0
aW9uOiBpZiB0aGUgc2VsZWN0aW9uIGlzIGV4cGxpY2l0LCB0aGVuIHRoZQ0KcmVzcG9uc2liaWxp
dHkgZm9yIHRoZSB0ZXN0aW5nIGFuZCB2YWxpZGF0aW9uIGNhbiBtb3ZlIHRvIHRoZSBIVyB2ZW5k
b3IuDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0
LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgSW5zaWRlIFNlY3VyZQ0Kd3d3Lmluc2lkZXNlY3Vy
ZS5jb20NCg==
