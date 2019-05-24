Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA74C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF6492168B
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="phtDWwS2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbfEXJVe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:21:34 -0400
Received: from mail-eopbgr40097.outbound.protection.outlook.com ([40.107.4.97]:32736
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389721AbfEXJVe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SAF2e6eb8rkz9k43941xmGZpKR1GgQs0Mf56/aROX0=;
 b=phtDWwS2QBymQv+f9w4hEt+xaNC9eWNb8nypGjo5Xn27qPhcQCczzfqNFKzXEDpByLHRH0nyL/sN8/VTcxZjoAomOgouNFtN+yp/4UwPc6UOIWrN1q2AySQxJJlp7SKlnh7s/X8RADqP1f+Bs2iCnjHtuWBg7O+6RHfFupwsbjE=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3335.eurprd09.prod.outlook.com (20.179.245.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Fri, 24 May 2019 09:21:30 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 09:21:30 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQ
Date:   Fri, 24 May 2019 09:21:30 +0000
Message-ID: <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
In-Reply-To: <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ae7012e-5198-4bc2-a4f3-08d6e02934d8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3335;
x-ms-traffictypediagnostic: AM6PR09MB3335:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB3335BBF0FAE8C7957FD59142D2020@AM6PR09MB3335.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(346002)(39850400004)(376002)(189003)(199004)(86362001)(66066001)(7116003)(102836004)(6506007)(9686003)(6436002)(71190400001)(8936002)(71200400001)(6306002)(7696005)(99286004)(6916009)(486006)(76176011)(53936002)(6246003)(64756008)(66556008)(66476007)(66446008)(25786009)(73956011)(66946007)(76116006)(55016002)(4326008)(74316002)(3480700005)(3846002)(6116002)(81166006)(81156014)(446003)(186003)(478600001)(33656002)(14454004)(316002)(52536014)(476003)(11346002)(229853002)(15974865002)(305945005)(68736007)(5660300002)(256004)(4744005)(7736002)(2906002)(26005)(8676002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3335;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rEnT//tAJC40jj7ossXlBWE9DOmNb4BD1iTMRsYnmhUnIaBiP4Wwgd2k+5Fy0CWyqEnnQKkukXXbxP7j+i7EnsbtejxtM8uqxhXmzykpzgy/XDX6oifxJm8iWwHTwr2TbMLbmHAG+XPaTa0EceuNmX4e/PJOnPPOINB5o2eBXLAP25o0FLI3iuNScDCldfh+82gjz/EoSE8wpprRjDm9ZEjR1jiHqpcb0JrbLj5UBZcFGP1GGwq6CzSKmD7MNp2lxe7XGpgKMj8FQa4jjDcn6T7qS876jTThvxn9kGYIHebPrgS45Kdzf7SIR9Hdv9hdhk4zUqqR1YXUVEd1nhqBqbmDtoNv4PB575DHZA0cO5wWI+mq4OWCe/LLF7fEv2zPkILMgTfPwi7g3f5wbQMsMmoKlnkfr0LkgFYDE+bu5/s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae7012e-5198-4bc2-a4f3-08d6e02934d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:21:30.2888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3335
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IEFzIEkgYWxyZWFkeSBtZW50aW9uZWQgaW4gYW5vdGhlciB0aHJlYWQgc29tZXdoZXJlLCB0
aGlzIG1vcm5pbmcgaW4gdGhlDQo+ID4gc2hvd2VyIEkgcmVhbGlzZWQgdGhhdCB0aGlzIG1heSBi
ZSB1c2VmdWwgaWYgeW91IGhhdmUgbm8gZXhwZWN0YXRpb24gb2YNCj4gPiB0aGUgbGVuZ3RoIGl0
c2VsZi4gQnV0IGl0J3Mgc3RpbGwgYSBwcmV0dHkgc3BlY2lmaWMgdXNlIGNhc2Ugd2hpY2ggd2Fz
DQo+ID4gbmV2ZXIgY29uc2lkZXJlZCBmb3Igb3VyIGhhcmR3YXJlLiBBbmQgb3VyIEhXIGRvZXNu
J3Qgc2VlbSB0byBiZSBhbG9uZSBpbg0KPiA+IHRoaXMuDQo+ID4gRG9lcyBzaGFYWFhzdW0gb3Ig
bWQ1c3VtIHVzZSB0aGUga2VybmVsIGNyeXB0byBBUEkgdGhvdWdoPw0KPg0KPiBUaGUgb25lcyBm
cm9tIGxpYmtjYXBpIGRvIChodHRwOi8vd3d3LmNocm9ub3guZGUvbGlia2NhcGkuaHRtbCkNCj4N
Cj4gQ2hyaXN0b3BoZQ0KPg0KSSB3YXMgbm90IGF3YXJlIG9mIHRoYXQsIHNvIHRoYW5rcyBmb3Ig
cG9pbnRpbmcgdGhhdCBvdXQuDQpEbyB0aGV5IHVzZSB0aGUgYXN5bmMgY2FsbHMgKF9haW8pIHRo
b3VnaD8gQmVjYXVzZSBvdGhlcndpc2UgdGhleSBzaG91bGRuJ3QNCmVuZCB1cCBiZWluZyBoYXJk
d2FyZSBhY2NlbGVyYXRlZCBhbnl3YXkgLi4uDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3
ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgSW5zaWRl
IFNlY3VyZQ0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
