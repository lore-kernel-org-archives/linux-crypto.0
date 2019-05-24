Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF01C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2DCA20644
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 09:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="fmOsR4ey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390268AbfEXJmf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 05:42:35 -0400
Received: from mail-eopbgr10128.outbound.protection.outlook.com ([40.107.1.128]:37925
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389677AbfEXJme (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 05:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=beCnDuwjVJgZ5gahakgwmh50wqVxdYEaBZwq6L6lMBM=;
 b=fmOsR4eyRBcUvxErCw/128HGT6noY4GTm1rRvHbCR6fMgMdgTGTxA+4oZW1/9LBH6jakuh8CkveZb95Z2dDSYCizDDHTDx1ldSY7iLjmi6AkIw8YZP2jJiWcPk93THxNOfIyk2qZf8bivbgcNMTAYMmb2wlNUBIfjC6bTyRSWsA=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3368.eurprd09.prod.outlook.com (20.179.245.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 09:42:31 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 09:42:31 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "noloader@gmail.com" <noloader@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAALWAgAANgcA=
Date:   Fri, 24 May 2019 09:42:31 +0000
Message-ID: <AM6PR09MB352306D397F46D5FB5880999D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <CAH8yC8nBDa438QsJvs91CGV-e+-j9UxnB2pQ6-KAy0jV3EXj-w@mail.gmail.com>
In-Reply-To: <CAH8yC8nBDa438QsJvs91CGV-e+-j9UxnB2pQ6-KAy0jV3EXj-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4d56b1f-174f-45e6-4d87-08d6e02c244f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3368;
x-ms-traffictypediagnostic: AM6PR09MB3368:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR09MB3368FB4A6AFE3BE9618E0622D2020@AM6PR09MB3368.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(346002)(366004)(39850400004)(396003)(376002)(136003)(189003)(199004)(7116003)(8676002)(66946007)(73956011)(229853002)(74316002)(2906002)(68736007)(3480700005)(486006)(478600001)(14454004)(316002)(66066001)(64756008)(305945005)(446003)(81166006)(186003)(5660300002)(7736002)(11346002)(102836004)(53546011)(8936002)(256004)(6506007)(86362001)(71200400001)(71190400001)(52536014)(81156014)(26005)(54906003)(110136005)(4326008)(6246003)(476003)(66446008)(66476007)(25786009)(2501003)(6306002)(99286004)(6436002)(66556008)(9686003)(55016002)(76116006)(7696005)(33656002)(76176011)(53936002)(3846002)(6116002)(15974865002)(18886075002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3368;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3nZv9ZY8pq94Z/dAhl/d1xThD3b4SsN94d6COv5CKsPuNelb55vyNwaVmm0D3t/BLCvo6KlIf1E5V4fS2JI+m5moFBoXt+XY5Mma3Eil5qEqpCic9JVd6Ab8rYEqUqV4JIKdnHvDvdVWJ2wS2cjkkwGggbe+bC52kOA/TQbORwIaGd8GF3QOoDCHGuqUUmy6ipOpP7wLdnOdDstnBpLThoqh5n6ZCHHQ6QDMO3x6CnIhndefp/QJUPvBtdptqux6Zmi8rr0ZKZ6JLWgZSZmocDgI3Or8v6yFTr406DRPe450Z4N+ddSSCahCJpZuj6Q1lEYLsoNYrfGt/aw8rKhUDVw1RE4fu/GM1FOhNNpBZ5byS4UNplQ2A4t9L+aJo2pDXBdCf5BecCBYGMtS+/pBdGZg7OcP/OXQUALLO8l63nI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d56b1f-174f-45e6-4d87-08d6e02c244f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:42:31.0904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3368
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBGcmksIE1heSAyNCwgMjAxOSBhdCA0OjQ3IEFNIENocmlzdG9waGUgTGVyb3kNCj4gPGNo
cmlzdG9waGUubGVyb3lAYy1zLmZyPiB3cm90ZToNCj4gPiAuLi4NCj4gPiA+IEFzIEkgYWxyZWFk
eSBtZW50aW9uZWQgaW4gYW5vdGhlciB0aHJlYWQgc29tZXdoZXJlLCB0aGlzIG1vcm5pbmcgaW4g
dGhlDQo+ID4gPiBzaG93ZXIgSSByZWFsaXNlZCB0aGF0IHRoaXMgbWF5IGJlIHVzZWZ1bCBpZiB5
b3UgaGF2ZSBubyBleHBlY3RhdGlvbiBvZg0KPiA+ID4gdGhlIGxlbmd0aCBpdHNlbGYuIEJ1dCBp
dCdzIHN0aWxsIGEgcHJldHR5IHNwZWNpZmljIHVzZSBjYXNlIHdoaWNoIHdhcw0KPiA+ID4gbmV2
ZXIgY29uc2lkZXJlZCBmb3Igb3VyIGhhcmR3YXJlLiBBbmQgb3VyIEhXIGRvZXNuJ3Qgc2VlbSB0
byBiZSBhbG9uZSBpbg0KPiA+ID4gdGhpcy4NCj4gPiA+IERvZXMgc2hhWFhYc3VtIG9yIG1kNXN1
bSB1c2UgdGhlIGtlcm5lbCBjcnlwdG8gQVBJIHRob3VnaD8NCj4gPg0KPiA+IFRoZSBvbmVzIGZy
b20gbGlia2NhcGkgZG8gKGh0dHA6Ly93d3cuY2hyb25veC5kZS9saWJrY2FwaS5odG1sKQ0KPg0K
PiBBbmQgdGhleSBjYW4gYmUgbG9hZGVkIGludG8gT3BlblNTTCB0aHJvdWdoIHRoZSBhZmFsZyBp
bnRlcmZhY2UuDQo+DQoNCkhtbSAuLi4geWVhaCAuLi4gT3BlblNTTCAuLi4geWV0IGFub3RoZXIg
c3luY2hyb25vdXMgQVBJIHRoYXQgZG9lc24ndCBzdGFuZCBhDQpjaGFuY2Ugb2YgYmVpbmcgSFcg
YWNjZWxlcmF0ZWQgKGFsdGhvdWdoIEludGVsIGNvbnRyaWJ1dGVkIHNvbWUgYXN5bmMgQVBJDQpm
YWlybHkgcmVjZW50bHkgLSBidXQgSSBkb24ndCBrbm93IG9mIGFueSBhcHBsaWNhdGlvbiBhY3R1
YWxseSBwb3J0ZWQgdG8gdXNlDQp0aGF0IC0gd291bGQgbG92ZSB0byBoZWFyIGFib3V0IGFueSBp
ZiB0aGV5IGRvIGV4aXN0KS4NCg0KU29ycnksIG9wZW4gd291bmQgLi4uDQoNClJlZ2FyZHMsDQpQ
YXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBF
bmdpbmVzIEAgSW5zaWRlIFNlY3VyZQ0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
