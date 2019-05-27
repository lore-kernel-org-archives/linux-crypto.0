Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07128C07542
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD81021721
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="uRs3YqLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfE0Jod (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 05:44:33 -0400
Received: from mail-eopbgr80114.outbound.protection.outlook.com ([40.107.8.114]:26357
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726094AbfE0Jod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 05:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+ppGxXvndN5C5VC73wmgSPDyc0OQyUhYgA5AeAV6qQ=;
 b=uRs3YqLpZNnMixsqKinPH60fZmsNwk2a19T2YWZtPsPR1mQmDEaQZczZGUpWiQGDIFqNRB+zOcY9thePpxVUi2S1Q16Phxc2bSWIHEmYc1KgJxEf5NwsOws0jmB9GTQWLCFKYyb2FvqfQ7zU8Ggg9L0rQOi2JNXUWLVrvrfUl0o=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2567.eurprd09.prod.outlook.com (20.177.115.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Mon, 27 May 2019 09:44:16 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 09:44:16 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAS0FFA=
Date:   Mon, 27 May 2019 09:44:16 +0000
Message-ID: <AM6PR09MB35235BFCE71343986251E163D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
In-Reply-To: <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 034986d8-f27a-417d-c626-08d6e287e225
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2567;
x-ms-traffictypediagnostic: AM6PR09MB2567:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2567947B362937F427B070E6D21D0@AM6PR09MB2567.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(39840400004)(376002)(366004)(199004)(189003)(13464003)(3846002)(6116002)(9686003)(2906002)(26005)(68736007)(55016002)(25786009)(7116003)(3480700005)(6506007)(8676002)(81156014)(8936002)(74316002)(305945005)(76176011)(7696005)(186003)(66446008)(64756008)(66556008)(66476007)(11346002)(446003)(66946007)(76116006)(71190400001)(71200400001)(5660300002)(478600001)(229853002)(86362001)(7736002)(6436002)(4326008)(73956011)(66066001)(316002)(14454004)(486006)(476003)(6916009)(15974865002)(53936002)(102836004)(54906003)(52536014)(99286004)(14444005)(53546011)(81166006)(33656002)(6246003)(256004)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2567;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nQKVGa+PfDoZwiN5PZPGHumc4YqVT9SCDSUODv6qIlDHKV9WdtPNXDZDZPfDs8Ez1IgDAmnDLHQF7nGqN9GZNN8Bh8qqibc8zDfAGTVfTCDhtFmv3XtuzWeG67p++mqtIMraOyEfwVTH7Q2c+jD67zn+7rx2yWWvXwdRCtp36PEACtkZiV0SqvAjA+w8uGVwxlFD5W7a1WD3RCb1225tUh4v+oo3edaIRu4GmNZ1ymuNJ5T22m4SH2GWxNeXGEBtYCfwboEeWsABSr0n2GrM3t0Hm9c0cRzjZVvQeAzFIWGDO8XyfkhoFs67nmSrc2LOr/d/ezRwH8pEfBKPMUr97SAVtX2/BZ0ZTzVSLJvCK4tf7OYROuScQPucbQlhxHMleokUjihMrFSCNp7/hqBZ6I292/od14J+jt/MdH+tyCM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034986d8-f27a-417d-c626-08d6e287e225
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 09:44:16.1183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2567
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCBbbWFp
bHRvOmFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmddDQo+IFNlbnQ6IEZyaWRheSwgTWF5IDI0LCAy
MDE5IDExOjQ1IEFNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQGluc2lk
ZXNlY3VyZS5jb20+DQo+IENjOiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGMt
cy5mcj47IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IGFub3Ro
ZXIgdGVzdG1nciBxdWVzdGlvbg0KPg0KPiBPbiBGcmksIDI0IE1heSAyMDE5IGF0IDExOjM0LCBQ
YXNjYWwgVmFuIExlZXV3ZW4NCj4gPHB2YW5sZWV1d2VuQGluc2lkZXNlY3VyZS5jb20+IHdyb3Rl
Og0KPiA+DQo+ID4gPiBBbGwgdXNlcmxhbmQgY2xpZW50cyBvZiB0aGUgaW4ta2VybmVsIGNyeXB0
byB1c2UgaXQgc3BlY2lmaWNhbGx5IHRvDQo+ID4gPiBhY2Nlc3MgaC93IGFjY2VsZXJhdG9ycywg
Z2l2ZW4gdGhhdCBzb2Z0d2FyZSBjcnlwdG8gZG9lc24ndCByZXF1aXJlDQo+ID4gPiB0aGUgaGln
aGVyIHByaXZpbGVnZSBsZXZlbCAobm8gcG9pbnQgaW4gaXNzdWluZyB0aG9zZSBBRVMgQ1BVDQo+
ID4gPiBpbnN0cnVjdGlvbnMgZnJvbSB0aGUga2VybmVsIGlmIHlvdSBjYW4gaXNzdWUgdGhlbSBp
biB5b3VyIHByb2dyYW0NCj4gPiA+IGRpcmVjdGx5KQ0KPiA+ID4NCj4gPiA+IEJhc2ljYWxseSwg
d2hhdCBpcyB1c2VkIGlzIGEgc29ja2V0IGludGVyZmFjZSB0aGF0IGNhbiBibG9jayBvbg0KPiA+
ID4gcmVhZCgpL3dyaXRlKCkuIFNvIHRoZSB1c2Vyc3BhY2UgcHJvZ3JhbSBkb2Vzbid0IG5lZWQg
dG8gYmUgYXdhcmUgb2YNCj4gPiA+IHRoZSBhc3luY2hyb25vdXMgbmF0dXJlLCBpdCBpcyBqdXN0
IGZyb3plbiB3aGlsZSB0aGUgY2FsbHMgYXJlIGJlaW5nDQo+ID4gPiBoYW5kbGVkIGJ5IHRoZSBo
YXJkd2FyZS4NCj4gPiA+DQo+ID4gV2l0aCBhbGwgZHVlIHJlc3BlY3QsIGJ1dCBpZiB0aGUgdXNl
cmxhbmQgYXBwbGljYXRpb24gaXMgaW5kZWVkDQo+ID4gKmZyb3plbiogd2hpbGUgdGhlIGNhbGxz
IGFyZSBiZWluZyBoYW5kbGVkLCB0aGVuIHRoYXQgc2VlbXMgbGlrZSBpdHMNCj4gPiBwcmV0dHkg
dXNlbGVzcyAtIGZvciBzeW1tZXRyaWMgY3J5cHRvLCBhbnl3YXkgLSBhcyBwZXJmb3JtYW5jZSB3
b3VsZCBiZQ0KPiA+IGRvbWluYXRlZCBieSBsYXRlbmN5LCBub3QgdGhyb3VnaHB1dC4NCj4gPiBI
YXJkd2FyZSBhY2NlbGVyYXRpb24gd291bGQgYWxtb3N0IGFsd2F5cyBsb3NlIHRoYXQgY29tcGFy
ZWQgdG8gYSBsb2NhbA0KPiA+IHNvZnR3YXJlIGltcGxlbWVudGF0aW9uLg0KPiA+IEkgY2VydGFp
bmx5IHdvdWxkbid0IHdhbnQgc3VjaCBhbiBvcGVyYXRpb24gdG8gZW5kIHVwIGF0IG15IGRyaXZl
ciENCj4gPg0KPg0KPiBBZ2FpbiwgeW91IGFyZSBtYWtpbmcgYXNzdW1wdGlvbnMgaGVyZSB0aGF0
IGRvbid0IGFsd2F5cyBob2xkLiBOb3RlIHRoYXQNCj4gLSBhIGZyb3plbiBwcm9jZXNzIGZyZWVz
IHVwIHRoZSBDUFUgdG8gZG8gb3RoZXIgdGhpbmdzIHdoaWxlIHRoZQ0KPiBjcnlwdG8gaXMgaW4g
cHJvZ3Jlc3M7DQo+IC0gaC93IGNyeXB0byBpcyB0eXBpY2FsbHkgbW9yZSBwb3dlciBlZmZpY2ll
bnQgdGhhbiBDUFUgY3J5cHRvOw0KPiAtIHNldmVyYWwgdXNlcmxhbmQgcHJvZ3JhbXMgYW5kIGlu
LWtlcm5lbCB1c2VycyBtYXkgYmUgYWN0aXZlIGF0IHRoZQ0KPiBzYW1lIHRpbWUsIHNvIHRoZSBm
YWN0IHRoYXQgYSBzaW5nbGUgdXNlciBzbGVlcHMgZG9lc24ndCBtZWFuIHRoZQ0KPiBoYXJkd2Fy
ZSBpcyB1c2VkIGluZWZmaWNpZW50bHkNCj4NCldpdGggYWxsIGR1ZSByZXNwZWN0LCBidXQgeW91
IGFyZSBtYWtpbmcgYXNzdW1wdGlvbnMgYXMgd2VsbC4gWW91IGFyZQ0KbWFraW5nIHRoZSBhc3N1
bXB0aW9uIHRoYXQgcmVkdWNpbmcgQ1BVIGxvYWQgYW5kL29yIHJlZHVjaW5nIHBvd2VyDQpjb25z
dW1wdGlvbiBpcyAqbW9yZSogaW1wb3J0YW50IHRoYW4gYWJzb2x1dGUgYXBwbGljYXRpb24gcGVy
Zm9ybWFuY2Ugb3INCmxhdGVuY3kuIFdoaWNoIGlzIGNlcnRhaW5seSBub3QgYWx3YXlzIHRoZSBj
YXNlLg0KDQpJbiBhZGRpdGlvbiB0byB0aGUgYXNzdW1wdGlvbiB0aGF0IHVzaW5nIHRoZSBoYXJk
d2FyZSB3aWxsIGFjdHVhbGx5DQoqYWNoaWV2ZSogdGhpcywgd2hpbGUgdGhhdCByZWFsbHkgZGVw
ZW5kcyBvbiB0aGUgcmF0aW8gb2YgZHJpdmVyIG92ZXJoZWFkDQood2hpY2ggY2FuIGJlIHF1aXRl
IHNpZ25pZmljYW50LCB1bmZvcnR1bmF0ZWx5LCBlc3BlY2lhbGx5IGlmIHRoZSBBUEkgd2FzDQpu
b3QgcmVhbGx5IGNyZWF0ZWQgZnJvbSB0aGUgZ2V0LWdvIHdpdGggSFcgaW4gbWluZCkgdnMgaGFy
ZHdhcmUgcHJvY2Vzc2luZw0KdGltZS4NCg0KSW4gbWFueSBjYXNlcyB3aGVyZSBvbmx5IHNtYWxs
IGFtb3VudHMgb2YgZGF0YSBhcmUgcHJvY2Vzc2VkIHNlcXVlbnRpYWxseSwNCnRoZSBoYXJkd2Fy
ZSB3aWxsIHNpbXBseSBsb3NlIG9uIGFsbCBhY2NvdW50cyAuLi4gU28gTGludXMgYWN0dWFsbHkg
ZGlkDQpoYXZlIGEgcG9pbnQgdGhlcmUuIEhhcmR3YXJlIG9ubHkgd2lucyBmb3Igc3BlY2lmaWMg
dXNlIGNhc2VzLiBJdCdzDQppbXBvcnRhbnQgdG8gcmVhbGl6ZSB0aGF0IGFuZCBub3QgdHJ5IGFu
ZCB1c2UgaGFyZHdhcmUgZm9yIGV2ZXJ5dGhpbmcuDQoNClJlZ2FyZHMsDQoNClBhc2NhbCB2YW4g
TGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBJ
bnNpZGUgU2VjdXJlDQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
