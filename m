Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB10C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6136821841
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="kpq8RVrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbfEXIEK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 04:04:10 -0400
Received: from mail-eopbgr140104.outbound.protection.outlook.com ([40.107.14.104]:32532
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388959AbfEXIEJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 04:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcSGlHrsw8D+11JGAOEsaTgXKcl4R+CAt2gD0uLf/QI=;
 b=kpq8RVrAp8zy1rwhk6PxXp53KZu03zDtLoHBkNBvsCtWRsvFBIQNUNdTT9dVuYPmhbJNp94gM126QfAFca9/hX9s/zplPkqzxIel8dRuXJ41IOlN5u+03S1ct7Gvnn8KHVNp3dMS/WJLdywOH394Xy9yxf8bwHlUXMlX/Vm9OfA=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2712.eurprd09.prod.outlook.com (20.178.87.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 08:04:05 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 08:04:05 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAoKCAgAAbo8A=
Date:   Fri, 24 May 2019 08:04:05 +0000
Message-ID: <AM6PR09MB3523B42B27EF8E26EFF84E62D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <6e5a9618-fc54-f649-6ca3-5c8ced027630@c-s.fr>
In-Reply-To: <6e5a9618-fc54-f649-6ca3-5c8ced027630@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eabf84c9-ebb0-40a4-0a59-08d6e01e6422
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2712;
x-ms-traffictypediagnostic: AM6PR09MB2712:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB2712BDC35F9DE7076170F9B9D2020@AM6PR09MB2712.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(346002)(376002)(366004)(396003)(136003)(189003)(199004)(51914003)(3480700005)(3846002)(229853002)(102836004)(6116002)(25786009)(6916009)(6436002)(6506007)(6306002)(55016002)(11346002)(7116003)(4326008)(76176011)(486006)(7696005)(54906003)(9686003)(26005)(186003)(2906002)(6246003)(99286004)(316002)(15974865002)(86362001)(68736007)(71190400001)(66066001)(76116006)(66476007)(66556008)(64756008)(71200400001)(66446008)(73956011)(4744005)(966005)(446003)(53936002)(66946007)(52536014)(305945005)(7736002)(476003)(81156014)(81166006)(14454004)(8676002)(256004)(74316002)(5660300002)(478600001)(8936002)(33656002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2712;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j8xJEjxlmKPBjJKoDNvi9cCK+HJZjilAoY+RzaU04WlZAVvJdpENRbrLVxp15NPPUlnSNGmG8k0wTd4kRXxpAKTooI65TFf2X/gmKIbjTgwG/PkdR6PtcTGfLlkEuQuvBpz9p/1u/FgrGaQinzMuRHSjwOECecpGpuqLYcehGBX916blFeX5yLSoLNvdrTk/PxnqvP+yMm6tYCbzYGBoZWazdgf/kawPTaib9agLxdM4H9kEz/+VQsbmn0zW+whRGC6gUUhZRQhHNSo0aOBSNhA7PUl4kM9FkGfFRoYjrfLoBf/NB39ZDI5oN9pnUa5jsAekd4gGHewhKi7BoXALDovjXqL4GXOFip8j29B0E8zUDj1MSF8zf/ff0pkvoPLL1EbO9lyX9cPBebfe5O/C7H5ViEQrGsRSYSzi9TWTIdQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eabf84c9-ebb0-40a4-0a59-08d6e01e6422
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 08:04:05.1777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2712
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pg0KPiBJIGhhZCB0aGUgc2FtZSBpc3N1ZSB3aGVuIHBvcnRpbmcgdGhlIFNFQzIgVGFsaXRvcyBk
cml2ZXIgdG8gYWxzbw0KPiBzdXBwb3J0IFNFQzEuIFNlZSBmb2xsb3dpbmcgY29tbWl0IHRvIHNl
ZSB0aGUgd2F5IGl0IGhhcyBiZWVuIGZpeGVkOg0KPg0KPiBodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZA0K
PiA9MmQwMjkwNWViZDIyYzAyNzFhMjVlNDI0YWIyMDljOGI3MDY3YmU2Nw0KPg0KPiBDaHJpc3Rv
cGhlDQo+DQpDcmlzdG9waGUsDQoNClRoYW5rcyBmb3IgdGhlIGhlbHAhIEkganVzdCBoYWQgYSBx
dWljayBsb29rIGFuZCB0aGlzIGluZGVlZCBsb29rcyBsaWtlIGEgZ29vZA0Kc29sdXRpb24gdGhh
dCBJIGNvdWxkIHVzZSBmb3IgbXkgZHJpdmVyIGFzIHdlbGwuDQoNCihBY3R1YWxseSwganVzdCBi
ZWZvcmUgcmVhZGluZyB5b3VyIG1haWwgSSBoYWQgYSBkaXNjdXNzaW9uIHdpdGggYSBjb3dvcmtl
cg0KaGVyZSBhbmQgaGUgY2FtZSB1cCB3aXRoIHRoZSBleGFjdCBzYW1lIHNvbHV0aW9uLiBCdXQg
c3RpbGw6IHRoYW5rcyA6LSkNCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNv
biBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBJbnNpZGUgU2VjdXJlDQp3
d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
