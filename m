Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2FDC282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D032A217D7
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="q4OpbPM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbfDQUtY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 16:49:24 -0400
Received: from mail-eopbgr60123.outbound.protection.outlook.com ([40.107.6.123]:19819
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727013AbfDQUtY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 16:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uW4yvn5JcbHIu5H5jpP7D6DqrmQs9EpqT9i1JAI3+pw=;
 b=q4OpbPM6hm676pvu0aoavFXxRBhpkJoA10I1TB/v/XaQJ+vcZPlvJQdwww32R/k97e8YdO0zmTNP+yLUH207Vh1bz++Sqy982Wx8Icg30IfaKBDaBpJGDDmddnHwVb8hroc2lznm91Dten7tLmDAu5KUVcwhO+FDOiL3YjkEzgY=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3288.eurprd09.prod.outlook.com (20.179.244.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Wed, 17 Apr 2019 20:49:20 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd%5]) with mapi id 15.20.1813.011; Wed, 17 Apr 2019
 20:49:20 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: RE: Question regarding crypto scatterlists / testmgr
Thread-Topic: Question regarding crypto scatterlists / testmgr
Thread-Index: AdT1UrNnwXz5dYegQq+/zS0mWvhdgAAB6piAAAEBl3A=
Date:   Wed, 17 Apr 2019 20:49:20 +0000
Message-ID: <AM6PR09MB3523E3B73CFCC6087C6981F1D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8000sDAX89=cre2uZ07vJC86FVjcoKagyk_Qqyrkbytw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8000sDAX89=cre2uZ07vJC86FVjcoKagyk_Qqyrkbytw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7dcc3b8-b26e-4469-f244-08d6c3762a7f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600141)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB3288;
x-ms-traffictypediagnostic: AM6PR09MB3288:
x-microsoft-antispam-prvs: <AM6PR09MB3288494339F34F9A4E6A0350D2250@AM6PR09MB3288.eurprd09.prod.outlook.com>
x-forefront-prvs: 0010D93EFE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(346002)(366004)(136003)(376002)(396003)(52314003)(189003)(199004)(55016002)(5660300002)(66066001)(102836004)(256004)(305945005)(446003)(4326008)(186003)(53936002)(54906003)(86362001)(97736004)(478600001)(71200400001)(2906002)(6916009)(11346002)(71190400001)(6246003)(68736007)(316002)(9686003)(25786009)(14444005)(99286004)(7736002)(105586002)(106356001)(74316002)(33656002)(3846002)(486006)(6116002)(6436002)(476003)(76176011)(14454004)(8936002)(6506007)(81156014)(52536014)(81166006)(8676002)(26005)(7696005)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3288;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vVEMd8eRdhsp/eAKHtL6ewJQ/j0Cnay8t8ekY8JOkyKcCh4i/1c94Ma8229HSuNsAB2T9NDn0rhWvySOgJhedo+ABNVERv6v+J8d9tFAooeVD00kwef5qiv2jR0JUEpCfHYPnRALQGNqv6EkCfSpxTkduvY69sAqYiYo1BFAJsOaEw5sekj5HqASCPfM0X3pqhOyMRPg01tXNF6i4k/a+L8yRJ06nEQuv2WwvWhPDqzttKTlCz4Im94K2xjYAI1pi6cJc6DVeMc3iPUb1D2he1F7bamBfZNcQOtX1pgUP9FJKd01yUVPuvoyuEXs3HHfQfVlEvBrdwEGvsQASo37wc1UKtI/kjrQu9D4QD+j6pucM1moSJokdTnBMJYOAkPpq1272sFNG52B3EZeqGLbKdKavAmh3yHt6jdR+0vKmKA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7dcc3b8-b26e-4469-f244-08d6c3762a7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2019 20:49:20.5348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3288
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IEknbSB0cnlpbmcgdG8gZml4IHRoZSBpbnNpZGUtc2VjdXJlIGRyaXZlciB0byBwYXNzIGFs
bCB0ZXN0bWdyDQo+ID4gdGVzdHMgYW5kIEkgaGF2ZSBvbmUgZmluYWwgaXNzdWUgcmVtYWluaW5n
IHdpdGggdGhlIEFFQUQgY2lwaGVycy4NCj4gPiBBcyBpdCB3YXMgbm90IGNsZWFyIGF0IGFsbCB3
aGF0IHRoZSBleGFjdCBwcm9ibGVtIHdhcywgSSBzcGVudA0KPiA+IHNvbWUgdGltZSByZXZlcnNl
IGVuZ2luZWVyaW5nIHRlc3RtZ3IgYW5kIEkgZ290IHRoZSBkaXN0aW5jdA0KPiA+IGltcHJlc3Np
b24gdGhhdCBpdCBpcyB1c2luZyBzY2F0dGVyIHBhcnRpY2xlcyB0aGF0IGNyb3NzIHBhZ2UNCj4g
PiBib3VuZGFyaWVzLiBPbiBwdXJwb3NlLCBldmVuLg0KPiA+DQo+ID4gV2hpbGUgdGhlIGluc2lk
ZS1zZWN1cmUgZHJpdmVyIGlzIGJ1aWx0IG9uIHRoZSBwcmVtaXNlIHRoYXQNCj4gPiBzY2F0dGVy
IHBhcnRpY2xlcyBhcmUgY29udGludW91cyBpbiBkZXZpY2Ugc3BhY2UuIEFzIEkgY2FuJ3QNCj4g
PiB0aGluayBvZiBhbnkgcmVhc29uIHdoeSB5b3Ugd291bGQgd2FudCB0byBzY2F0dGVyL2dhdGhl
ciBvdGhlcg0KPiA+IHRoYW4gdG8gaGFuZGxlIHZpcnR1YWwtdG8tcGh5c2ljYWwgYWRkcmVzcyB0
cmFuc2xhdGlvbiAuLi4NCj4gPiBJbiBhbnkgY2FzZSwgdGhpcyBzaG91bGQgYWZmZWN0IGFsbCBv
dGhlciBvdGhlciBvcGVyYXRpb25zIGFzDQo+ID4gd2VsbCwgYnV0IG1heWJlIHRob3NlIGp1c3Qg
Z290ICJsdWNreSIgYnkgZ2V0dGluZyBwYXJ0aWNsZXMNCj4gPiB0aGF0IHdlcmUgc3RpbGwgY29u
dGlndW91cyBpbiBkZXZpY2Ugc3BhY2UsIGRlc3BpdGUgdGhlIHBhZ2UNCj4gPiBjcm9zc2luZyAo
dG8gKnJlYWxseSogdmVyaWZ5IHRoaXMsIHlvdSB3b3VsZCBoYXZlIHRvIGZ1bGx5DQo+ID4gcmFu
ZG9taXplIHlvdXIgcGFnZSBhbGxvY2F0aW9uISkNCj4gPg0KPiA+IEFueXdheSwgYXNzdW1pbmcg
dGhhdCBJICpzaG91bGQqIGJlIGFibGUgdG8gaGFuZGxlIHBhcnRpY2xlcw0KPiA+IHRoYXQgYXJl
ICpub3QqIGNvbnRpZ3VvdXMgaW4gZGV2aWNlIHNwYWNlLCB0aGVuIHRoZXJlIHNob3VsZA0KPiA+
IHByb2JhYmx5IGFscmVhZHkgZXhpc3Qgc29tZSBmdW5jdGlvbiBpbiB0aGUga2VybmVsIEFQSSB0
aGF0DQo+ID4gY29udmVydHMgYSBzY2F0dGVybGlzdCB3aXRoIG5vbi1jb250aWd1b3VzIHBhcnRp
Y2xlcyBpbnRvIGENCj4gPiBzY2F0dGVybGlzdCB3aXRoIGNvbnRpZ3VvdXMgcGFydGljbGVzLCB0
YWtpbmcgaW50byBhY2NvdW50IHRoZQ0KPiA+IHByZXNlbmNlIG9mIGFuIElPTU1VPyBDb25zaWRl
cmluZyBwcmV0dHkgbXVjaCBldmVyeSBkZXZpY2UNCj4gPiBkcml2ZXIgd291bGQgbmVlZCB0byBk
byB0aGF0Pw0KPiA+IERvZXMgYW55b25lIGtub3cgd2hpY2ggZnVuY3Rpb24ocykgdG8gdXNlIGZv
ciB0aGF0Pw0KPiA+DQo+DQo+IEhlbGxvIFBhc2NhbCwNCj4NCj4gU2NhdHRlcmxpc3RzIGFyZSBt
YWRlIHVwIG9mIHN0cnVjdCBwYWdlL29mZnNldCB0dXBsZXMsIGFuZCBzbyB0aGV5DQo+IHNob3Vs
ZCBtYXAgdHJhbnNwYXJlbnRseSBvbnRvIHBoeXNpY2FsIHJhbmdlcy4NCj4NCj4gSXQgbG9va3Mg
bGlrZSB0aGUgQUVBRCBza2NpcGhlciB3YWxrIEFQSSBsYWNrcyBhICpfYXN5bmMoKSB2YXJpYW50
DQo+IHNldHRpbmcgdGhlIFNLQ0lQSEVSX1dBTEtfUEhZUyBiaXQsIGxpa2Ugd2UgaGF2ZSBmb3Ig
dGhlIG9yZGluYXJ5DQo+IGJsb2NrIGNpcGhlcnMuIFBsdW1iaW5nIHRoYXQgaW50byBjcnlwdG8v
c2tjaXBoZXIuYyBzaG91bGQgYmUgcmF0aGVyDQo+IHN0cmFpZ2h0LWZvcndhcmQuDQo+DQo+IC0t
DQo+IEFyZC4NCkFyZCwNCg0KDQpBbSBJIHJlYWRpbmcgdGhpcyBjb3JyZWN0bHkgYXMgInlvdXIg
ZHJpdmVyIHNob3VsZCBpbmRlZWQgZXhwZWN0DQp0aG9zZSBwYXJ0aWNsZXMgdG8gYmUgY29udGln
dW91cywgYnV0IHRoZXJlIGlzIHNvbWUgcHJvYmxlbSBpbiBzb21lDQpvdGhlciBsb2NhdGlvbiBp
biB0aGUgQVBJIGNhdXNpbmcgdGhpcyB0byBub3QgYWx3YXlzIGJlIHRoZSBjYXNlIj8NCg0KSSB0
b29rIGEgcXVpY2sgcGVlayBhdCBza2NpcGhlci5jLCB3aGljaCBpcyBhIGRlc2lnbiB1bmZhbWls
aWFyIHRvDQptZSwgYnV0IHRoZSBmaXJzdCB0aGluZyB0aGF0IHN0cmlrZXMgbWUgaXMgdGhhdCB0
aGVyZSBpcyBhbg0KInNrY2lwaGVyX3dhbGtfYXN5bmMiLCB0aGF0IGluZGVlZCBzZXRzIHRoaXMg
U0tDSVBIRVJfV0FMS19QSFlTIGJpdCwNCmJ1dCBubyBtYXRjaGluZyAic2tjaXBoZXJfd2Fsa19h
ZWFkX2FzeW5jIiBmdW5jdGlvbiB0aGF0IEkgd291bGQgc29ydA0Kb2YgZXhwZWN0IGRvaW5nIGEg
c2ltaWxhciB0aGluZyBmb3IgQUVBRCBjaXBoZXJzIC4uLg0KDQoNClJlZ2FyZHMsDQoNClBhc2Nh
bCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2lu
ZXMgQCBJbnNpZGUgU2VjdXJlDQoNCg==
