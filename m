Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1DFC04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 18:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 303EA20B7C
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 18:51:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="JHhsVkRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfE1SvK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 14:51:10 -0400
Received: from mail-eopbgr150112.outbound.protection.outlook.com ([40.107.15.112]:41811
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726481AbfE1SvK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 14:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPRs8qrVbIxPkBpOkxDhzp7ka49Ka5X1CxgSptVFus0=;
 b=JHhsVkRgtvel3fnWWOOeDoMRd0bJA436wg89fBUUn5J8Rz+I157torHPw0B7VUqOFJYh8LhJrzMVAycAFW1UC3OvNi7f1aHpOhC2w32UCaxAty9qGpEEZ0eZn3jnhFXHjHGlimGROwK7GmxVV75w8O5S5Lp6yqhVF3HMzUf+/vM=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2247.eurprd09.prod.outlook.com (20.177.113.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 18:51:07 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 18:51:07 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Conding style question regarding configuration
Thread-Topic: Conding style question regarding configuration
Thread-Index: AdUVadXkEfSYWnL2TvyyCw6EdJwBbwAA23iAAAYjRWA=
Date:   Tue, 28 May 2019 18:51:07 +0000
Message-ID: <AM6PR09MB3523B77DE66DD5353F08A687D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
In-Reply-To: <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddfaceb8-52cc-4aff-852e-08d6e39d7183
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB2247;
x-ms-traffictypediagnostic: AM6PR09MB2247:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB22479330086D1DE54CEA5DD6D21E0@AM6PR09MB2247.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39850400004)(366004)(396003)(189003)(199004)(25786009)(33656002)(99286004)(5660300002)(66556008)(53936002)(76116006)(6246003)(73956011)(14444005)(66946007)(52536014)(66476007)(64756008)(66446008)(26005)(256004)(186003)(86362001)(102836004)(76176011)(11346002)(6506007)(446003)(7696005)(486006)(476003)(6436002)(2906002)(229853002)(14454004)(68736007)(305945005)(6916009)(66066001)(81156014)(8676002)(7736002)(6116002)(478600001)(74316002)(71190400001)(71200400001)(3846002)(15974865002)(4326008)(316002)(9686003)(55016002)(8936002)(81166006)(21314003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2247;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2TZXEUgKP5LCCl8iCtCgJ6CsDgvMWVaC9BB20cA1/D9tppBXzxn/QXJVIq8B50wNbCycjAac+2MEM+3Qq5BozFn1zAgr856pMvkVeNjL1AD/pdDaoHQ0oDrtjsJNdornPnTwqttmFKFVV+t/EXw+J+exEeeEzsTiZpKtHgsd+KEB+dWGw3RfDBUvLie1m8fjCoKelnRPJxTntYjyairxMJTC7xyDEUY2ySi342gDpuz9t7nirLPisY7eIhdz1bkvfWWOpxAD/y2/HOkr9vXvS0gDCGVGkTjhdwoo+whb4lPypkzRy6P6f8SckyolFRxMpgbK+6spPAEKCYlbAbIjC9mm2KU1wsimj44D02G3dfEb+q/IhtKa5xNbQT7SZyGKZH5RRxPqx83MBrNJwJn5s+YS/ekNfbftNJYXQjrvHts=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfaceb8-52cc-4aff-852e-08d6e39d7183
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 18:51:07.2139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2247
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IFF1aWNrIHF1ZXN0aW9uIHJlZ2FyZGluZyBob3cgdG8gY29uZmlndXJlIG91dCBjb2RlIGRl
cGVuZGluZyBvbiBhDQo+IENPTkZJR194eHgNCj4gPiBzd2l0Y2guIEFzIGZhciBhcyBJIHVuZGVy
c3Rvb2Qgc28gZmFyLCB0aGUgcHJvcGVyIHdheSB0byBkbyB0aGlzIGlzDQo+IG5vdCBieQ0KPiA+
IGRvaW5nIGFuICNpZmRlZiBidXQgYnkgdXNpbmcgYSByZWd1bGFyIGlmIHdpdGggSVNfRU5BQkxF
RCBsaWtlIHNvOg0KPiA+DQo+ID4gaWYgKElTX0VOQUJMRUQoQ09ORklHX1BDSSkpIHsNCj4gPiB9
DQo+ID4NCj4gPiBTdWNoIHRoYXQgdGhlIGNvbXBpbGVyIGNhbiBzdGlsbCBjaGVjayB0aGUgY29k
ZSBldmVuIGlmIHRoZSBzd2l0Y2ggaXMNCj4gPiBkaXNhYmxlZC4gTm93IHRoYXQgYWxsIHdvcmtz
IGZpbmUgYW5kIGRhbmR5IGZvciBzdGF0ZW1lbnRzIHdpdGhpbiBhDQo+ID4gZnVuY3Rpb24sIGJ1
dCBob3cgZG8geW91IGNvbmZpZ3VyZSBvdXQsIHNheSwgZ2xvYmFsIHZhcmlhYmxlDQo+IGRlZmlu
aXRpb25zDQo+ID4gcmVmZXJlbmNpbmcgdHlwZXMgdGhhdCBhcmUgdGllZCB0byB0aGlzIGNvbmZp
Z3VyYXRpb24gc3dpdGNoPyBPcg0KPiBzaG91bGQNCj4gPiBJIGp1c3QgbGVhdmUgdGhlbSBpbiwg
ZGVwZW5kaW5nIG9uIHRoZSBjb21waWxlciB0byBvcHRpbWl6ZSB0aGVtIGF3YXk/DQo+ID4NCj4g
PiBPYnZpb3VzbHkgdGhlIGNvZGUgZGVwZW5kcyBvbiB0aG9zZSB2YXJpYWJsZXMgYWdhaW4sIHNv
IGlmIGl0J3Mgbm90DQo+ID4gZG9uZSBjb25zaXN0ZW50bHkgdGhlIGNvbXBpbGVyIHdpbGwgY29t
cGxhaW4gc29tZWhvdyBpZiB0aGUgc3dpdGNoIGlzDQo+IG5vdA0KPiA+IGRlZmluZWQgLi4uDQo+
ID4NCj4gPiBBbHNvLCB3aXRoIGlmIChJU19FTkFCTEVEKCkpIEkgY2Fubm90IHJlbW92ZSBteSBm
dW5jdGlvbiBwcm90b3R5cGVzLA0KPiA+IGp1c3QgdGhlIGZ1bmN0aW9uIGJvZHkuIElzIHRoYXQg
cmVhbGx5IGhvdyBpdCdzIHN1cHBvc2VkIHRvIGJlIGRvbmU/DQo+ID4NCj4gDQo+IFllcy4gQ29k
ZSBhbmQgZGF0YSB3aXRoIHN0YXRpYyBsaW5rYWdlIHdpbGwganVzdCBiZSBvcHRpbWl6ZWQgYXdh
eSBieQ0KPiB0aGUgY29tcGlsZXIgaWYgdGhlIENPTkZJR194eCBvcHRpb24gaXMgbm90IGVuYWJs
ZWQsIHNvIGFsbCB5b3UgbmVlZA0KPiB0byBndWFyZCBhcmUgdGhlIGFjdHVhbCBzdGF0ZW1lbnRz
LCBmdW5jdGlvbiBjYWxscyBldGMuDQo+DQpPaywgbWFrZXMgc2Vuc2UuIFRoZW4gSSdsbCBqdXN0
IGNvbmZpZyBvdXQgdGhlIHJlbGV2YW50IGZ1bmN0aW9uIGJvZGllcw0KYW5kIGFzc3VtZSB0aGUg
Y29tcGlsZXIgd2lsbCBkbyB0aGUgcmVzdCAuLi4NCg0KVGhhbmtzLA0KUGFzY2FsIHZhbiBMZWV1
d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIEluc2lk
ZSBTZWN1cmUNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg0KDQo=
