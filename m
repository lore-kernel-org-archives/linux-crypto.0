Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF42C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F374217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="Sq2Ly08Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389777AbfEXJ2d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:28:33 -0400
Received: from mail-eopbgr50104.outbound.protection.outlook.com ([40.107.5.104]:13380
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389724AbfEXJ2d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQYQmHrFwMnDa+B1GNnPiushg66FpXL3jW8o6OL05AU=;
 b=Sq2Ly08Qj9FgZ3xqtwAm3/yjkdp6rKXQgun+hf9PepKPpzrTQH0weqlMF0LgrgVIe4TUnlCB2FP1Wl0joCAJw/rpid+ovnVA0hXBJXgKAroQCHcekRyR4bSmZbGi2Napwr4bDw0udompv/YJonbHZ8w9CUy0lH7Pv1XZBJiuFfY=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2518.eurprd09.prod.outlook.com (20.177.115.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 09:28:29 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 09:28:29 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAkNEAgAAUIpCAACxugIAAAroA
Date:   Fri, 24 May 2019 09:28:28 +0000
Message-ID: <AM6PR09MB35236190204F71E4D92EA751D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com>
 <AM6PR09MB3523A3C44CFE5C83746B6136D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_-Z9rVC4Yup1ZyhES4-bYopMVNWw4-0d+G2oFD83z7OA@mail.gmail.com>
In-Reply-To: <CAKv+Gu_-Z9rVC4Yup1ZyhES4-bYopMVNWw4-0d+G2oFD83z7OA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 117366c6-b0d9-4018-6ff4-08d6e02a2e58
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2518;
x-ms-traffictypediagnostic: AM6PR09MB2518:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2518CE6C6FC00266DAD377C3D2020@AM6PR09MB2518.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(396003)(366004)(39850400004)(189003)(199004)(64756008)(66446008)(2906002)(8936002)(66946007)(305945005)(81166006)(229853002)(7736002)(66476007)(66556008)(81156014)(7696005)(4326008)(5660300002)(6506007)(53936002)(3480700005)(478600001)(4744005)(76176011)(86362001)(7116003)(99286004)(8676002)(25786009)(54906003)(316002)(6246003)(68736007)(6436002)(186003)(74316002)(26005)(15974865002)(55016002)(256004)(71190400001)(66066001)(71200400001)(52536014)(6916009)(446003)(476003)(73956011)(76116006)(6116002)(3846002)(11346002)(486006)(33656002)(9686003)(14454004)(102836004)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2518;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mjiwnGugptg6KMO4hEUUxxtl1Wlon9ZbB0fhbRclwGi1HQxqcKq+fLoBcSbljxwVVu6znq6lMwHr8vfiRISk3p3EpYmWDAhKeCFAAD+s8/F8Jg/x+lHTn47inybyUlqhJPDQOXqZW7LRL8FadFuMjmolXua8MwnB7SmX04WVxzQJEYKuLV7Uz5ZnSyxkC1ClcGFUY3a7k62zSNPW7mjY9eJwvNnoPxutiYubdTrCvYVhNTn5EzghtKaEAiBdPZj+sDSSHFP+V3elSWye18vx76X/opCDYaqfO/27Frn6JZA+wn33VU6dELsnaVSjGHUcaQJ4/Q1L3UYZyen21ugKOu0UoBMlr9dacNAdCEY4OujgI6zpY13b+Gtdogv/ZMLfp8TARqhBxjbuCHW+3TGTVzPHfd304+wq0mmM6iRqnlA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 117366c6-b0d9-4018-6ff4-08d6e02a2e58
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:28:28.9220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2518
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pg0KPiBBcG9sb2dpZXMsIEkgZGlkIG5vdCBtZWFuIHRvIGltcGx5IHRoYXQgeW91IGRvbid0IHVu
ZGVyc3RhbmQgeW91ciBvd24NCj4gaGFyZHdhcmUuDQo+DQpOb3QgbmVlZGVkIGF0IGFsbC4gVGhh
dCdzIG5vdCBob3cgSSByZWFkIGl0IGFuZCBiZXNpZGVzIHRoYXQgSSdtIG5vdA0KZWFzaWx5IG9m
ZmVuZGVkIGFueXdheS4gQ29udmVyc2VseSwgSSBkb24ndCBpbnRlbmQgdG8gb2ZmZW5kIG90aGVy
cywNCkkganVzdCBlbmpveSBoZWF0ZWQgZGlzY3Vzc2lvbnMgOy0pIFdoaWNoIEkgZG9uJ3QgbWlu
ZCBsb3NpbmcgYXQgYWxsLA0KQlRXIGFzIEkgYWNjZXB0IHRoYXQgSSdtIG9ubHkgaHVtYW4gYW5k
IGRvbid0IGtub3cgZXZlcnl0aGluZyBhYm91dA0KZXZlcnl0aGluZyAuLi4NCg0KUmVnYXJkcywN
ClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29s
IEVuZ2luZXMgQCBJbnNpZGUgU2VjdXJlDQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
