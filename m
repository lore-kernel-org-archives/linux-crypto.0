Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28140C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 07:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDEED27C82
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 07:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="K8eW5TS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfFCHOI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 03:14:08 -0400
Received: from mail-eopbgr00104.outbound.protection.outlook.com ([40.107.0.104]:29091
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfFCHOH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 03:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w96BdczBGe1flAVzkzFbPiZJateGfnLCM/H4lUfjMWM=;
 b=K8eW5TS8nNYc0X9ds26I0DubMaZ6toIICR20mQc3sNtzghdbxPWEsljNECvCXerr3HJWdeZJeB0yhkG8kguBxSzhEe0KtAh+Mccwtr5AJNBMURXrF6IQyM/Ldqja2NBHzeIbO4OLl2rznQ8Iz+omtlzttwy+6izFmV1rFZi+bVA=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2662.eurprd09.prod.outlook.com (20.177.115.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 07:14:04 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::a44f:9cb2:a373:a6eb%7]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 07:14:04 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: RE: Conding style question regarding configuration
Thread-Topic: Conding style question regarding configuration
Thread-Index: AdUVadXkEfSYWnL2TvyyCw6EdJwBbwAA23iAAAYjRWAALLNogAAl1WUQAMKYSAAAAEJfQA==
Date:   Mon, 3 Jun 2019 07:14:04 +0000
Message-ID: <AM6PR09MB3523A2815F9786F4AC1AADA3D2140@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
 <AM6PR09MB3523B77DE66DD5353F08A687D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190529180731.Horde.NGHeOXuCgw23pVdGqjc0fw9@messagerie.si.c-s.fr>
 <AM6PR09MB35232561AF362BF5A9FE72FFD2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <e1dfd2d6-c8d2-b542-5378-bde21fa3cf1c@c-s.fr>
In-Reply-To: <e1dfd2d6-c8d2-b542-5378-bde21fa3cf1c@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2e91bf6-e00c-4d2d-e3f9-08d6e7f30f91
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2662;
x-ms-traffictypediagnostic: AM6PR09MB2662:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB26627184F105ABE7499A7423D2140@AM6PR09MB2662.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(39840400004)(346002)(136003)(189003)(199004)(54014002)(478600001)(76176011)(81156014)(7736002)(316002)(81166006)(102836004)(8936002)(8676002)(15974865002)(66066001)(11346002)(486006)(6506007)(305945005)(74316002)(14454004)(6916009)(186003)(4326008)(966005)(25786009)(6246003)(3846002)(6116002)(476003)(53936002)(2906002)(26005)(446003)(6436002)(33656002)(71190400001)(71200400001)(68736007)(256004)(55016002)(54906003)(5660300002)(66446008)(99286004)(9686003)(229853002)(7696005)(66556008)(52536014)(6306002)(86362001)(66946007)(66476007)(73956011)(76116006)(64756008)(14444005)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2662;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N6XjuraL3zFz/OVFGoSpELVbCVRDAkT1glAb71GymRKn0NAdxlkKk1EBjikvlSdG13wn0H5VVwwogL3eIDYufgUMTQLjvieKFd/YkeMpuxJfJyuYAJsYjiG4OIW041LAcoxqhWI3T1DXUVLUAntFD8P5mPjKS5RDYhkTLXcjILHuixivNY39z37syrsTRIN7SA8Y7tbNaHd/2D5V2e90iJ8VhBrKTLF7JTbfoH2Zn3v4CMeUJ9tL5l27g8Sn7uA69hdcgq5dTNZc2Jt7VbCrUuN5gH7PVVuyV46xSGYkhoRcnvX/FCf1nKQFT4KO/rNvfrQ5+bXHnL5HMcLYUZI2a3C5HZPgKF+rQxmGG814vPD4nfRMMefxpVn5i5m43xoHKBXVQhN57zrVKKrqduCXioxdiLO5MFx3RCQCaUzv0JM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e91bf6-e00c-4d2d-e3f9-08d6e7f30f91
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 07:14:04.2003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2662
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IFdlbGwsIEkgZ290IGEgY29tcGxhaW50IGZyb20gc29tZW9uZSB0aGF0IG15IGRyaXZlciB1
cGRhdGVzIGZvciBhZGRpbmcNCj4gUENJRQ0KPiA+IHN1cHBvcnQgd291bGRuJ3QgIGNvbXBpbGUg
cHJvcGVybHkgb24gYSBwbGF0Zm9ybSB3aXRob3V0IGEgUENJKEUpDQo+IHN1YnN5c3RlbS4NCj4g
PiBTbyBJIGZpZ3VyZSBJIGRvIGhhdmUgdG8gY29uZmlnIG91dCB0aGUgcmVmZXJlbmNlcyB0byBQ
Q0kgc3BlY2lmaWMNCj4gZnVuY3Rpb24NCj4gPiBjYWxscyB0byBmaXggdGhhdC4NCj4gDQo+IERv
IHlvdSBoYXZlIGEgbGluayB0byB5b3VyIGRyaXZlciB1cGRhdGVzID8gV2UgY291bGQgaGVscCB5
b3UgZmluZCB0aGUNCj4gYmVzdCBzb2x1dGlvbi4NCj4gDQo+IENocmlzdG9waGUNCj4gDQoNCkV2
ZXJ5b25lIGlzIGZyZWUgdG8gaGF2ZSBhIGxvb2sgYXQgbXkgR2l0IHRyZWUuIEhlbHAgaXMgYXBw
cmVjaWF0ZWQ6DQpodHRwczovL2dpdGh1Yi5jb20vcHZhbmxlZXV3ZW4vbGludXguZ2l0LCBicmFu
Y2ggImlzX2RyaXZlcl9hcm1hZGFfZml4Ig0KDQpCdXQgcGxlYXNlIGtlZXAgaW4gbWluZCB0aGF0
IHRoaXMgaXMgbm90IGFuICJvZmZpY2lhbCIgdXBkYXRlIHlldCwgSSdtIA0Kd29ya2luZyB3aXRo
IHRoZSBvZmZpY2lhbCBkcml2ZXIgbWFpbnRhaW5lciB0byBnZXQgc29tZSBvZiBteSBjaGFuZ2Vz
IA0KbWVyZ2VkIGluIHdpdGggaGlzIGNoYW5nZXMuDQoNCkkgZG8gaGF2ZSBhIGZvbGxvdy11cCBx
dWVzdGlvbiB0aG91Z2g6DQpXaGF0IGlmIHRoZSBmdW5jdGlvbiBpcyByZWZlcmVuY2VkIGZyb20g
YSBwY2lfZHJpdmVyIHN0cnVjdD8NCkkgY2FuJ3QgdXNlIElTX0VOQUJMRUQgYXJvdW5kIHRoZSBz
dHJ1Y3QgZGVmaW5pdGlvbiwgc28gaW4gdGhhdCBjYXNlDQp0aGUgZnVuY3Rpb25zIHdpbGwgc3Rp
bGwgYmUgcmVmZXJlbmNlZCBhbmQgSSBwcm9iYWJseSBkbyBoYXZlIHRvIHVzZQ0KSVNfRU5BQkxF
RCB0byBzdHJpcCB0aGVpciBib2RpZXM/IENvcnJlY3Q/DQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFu
IExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAg
SW5zaWRlIFNlY3VyZQ0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
