Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B05BC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 10:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F00552175B
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 10:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="lJiC23Vs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390106AbfEXKN1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 06:13:27 -0400
Received: from mail-eopbgr130094.outbound.protection.outlook.com ([40.107.13.94]:28482
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389806AbfEXKN0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 06:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVzd26HQXPo53uc5D1JL5RKSHzUuwrSWJ69nPRCjo5E=;
 b=lJiC23VsEAy1bGGMZZYMbyrKAnlUC6CCZOmNfDSR2DkpDvW4jMHIPG6CjzQmzj33KZG6eEEi8GVY5BGwesqMC7gB6stU6pmfU4jW/oi5LMzkvZgojpmJAQcsa/dxx7LhCm33yFgKAyxoldPRaCBfYwrCUr86pbCnRUDBwtYNs4k=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2407.eurprd09.prod.outlook.com (20.177.113.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Fri, 24 May 2019 10:13:22 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 10:13:22 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAAAYtCAAATFsA==
Date:   Fri, 24 May 2019 10:13:22 +0000
Message-ID: <AM6PR09MB3523E18FC16E2FFA117127D2D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cf8f54a-bbd4-4592-5f55-08d6e03073b8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2407;
x-ms-traffictypediagnostic: AM6PR09MB2407:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2407CDA6562610AFF92F2121D2020@AM6PR09MB2407.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(376002)(39850400004)(346002)(199004)(189003)(8936002)(6916009)(68736007)(316002)(52536014)(8676002)(7116003)(15974865002)(33656002)(86362001)(256004)(71200400001)(71190400001)(81166006)(74316002)(6436002)(81156014)(6506007)(73956011)(7696005)(102836004)(76116006)(99286004)(66446008)(54906003)(229853002)(66476007)(7736002)(66946007)(66556008)(64756008)(76176011)(26005)(55016002)(305945005)(3480700005)(486006)(186003)(446003)(25786009)(9686003)(66066001)(476003)(4326008)(53936002)(478600001)(14454004)(6246003)(5660300002)(3846002)(6116002)(2906002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2407;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9pSmaYSmmDsNDwhmhKGbiLkNCNY2Fhp71ChVmocDUJDwUT0FXuw7xc2vblyimAbZsIAe3oXLtrwmxLiq9D5DUC1vb3K2/PAL40zg2FBjEfOnNfFEgandSVcXFsV0RL3GZH0sTRazLfhplb6qYf5OL4zzsH02XuwEwBILMDwLDDvUtSzOJgV82SrXCYo6TfxbsAcPXSel57T9oVPb0kA9aLRv8Cj1UDmXtQaYd00Lu4NTCJdsh5gtjPt3XJu1OEXqc6KQzgk1HftAbNZKJyv1RDJaB4fmQcQ2D1E4ktnlcVIQ5aeVDdPCc4n0VealCBNLcsKQ5OrXIl/WqSO6l3sLNzOvU3X7wf2sh+teHVnLE3NFV++6k4hE+x7SxTB/wiERjfMQ1wxy84udcqpN1s5cM6//leTmZmUDBn+0WO1+pJE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf8f54a-bbd4-4592-5f55-08d6e03073b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 10:13:22.2789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2407
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBUcnVlLiBUaG9zZSBhcmUgdGhlICJvdGhlciIgcmVhc29ucyAtIGJlc2lkZXMgYWNjZWxlcmF0
aW9uIC0gdG8gdXNlIGhhcmR3YXJlDQo+IG9mZmxvYWQgd2hpY2ggd2Ugb2Z0ZW4gdXNlIHRvIHNl
bGwgb3VyIElQLg0KPiBCdXQgdGhlIGhvbmVzdCBzdG9yeSB0aGVyZSBpcyB0aGF0IHRoYXQgb25s
eSB3b3JrcyBvdXQgZm9yIHNpdHVhdGlvbnMNCj4gd2hlcmUgdGhlcmUncyBlbm91Z2ggd29yayB0
byBkbyB0byBtYWtlIHRoZSBzb2Z0d2FyZSBvdmVyaGVhZCBmb3IgYWN0dWFsbHkNCj4gc3RhcnRp
bmcgYW5kIG1hbmFnaW5nIHRoYXQgd29yayBpbnNpZ25pZmljYW50Lg0KPg0KPiBBbmQgZXZlbiB0
aGVuLCBpdCdzIG9ubHkgYSB2YWxpZCB1c2UgY2FzZSBpZiB0aGF0IGlzIHlvdXIgKmludGVudGlv
biouDQo+IElmIHlvdSAqanVzdCogbmVlZGVkIHRoZSBoaWdoZXN0IHBlcmZvcm1hbmNlLCB5b3Ug
ZG9uJ3Qgd2FudCB0byBnbyB0aHJvdWdoDQo+IHRoZSBIVyBpbiB0aGlzIGNhc2UgKHVubGVzcyB5
b3UgaGF2ZSBhICp2ZXJ5KiB3ZWFrIENQVSBwZXJoYXBzLCBvciBhDQo+IGh1Z2UgYW1vdW50IG9m
IGRhdGEgdG8gcHJvY2VzcyBpbiBvbmUgZ28pLg0KPg0KPiBUaGUgY2F0Y2ggaXMgaW4gdGhlICJh
bHdheXMiLiBCdXQgaG93IGRvIHlvdSBtYWtlIGFuIGluZm9ybWVkIGRlY2lzaW9uDQo+IGhlcmU/
IFRoZSBjdXJyZW50IENyeXB0byBBUEkgZG9lcyBub3QgcmVhbGx5IHNlZW0gdG8gcHJvdmlkZSBh
IG1lY2hhbmlzbQ0KPiBmb3IgZG9pbmcgc28uIEluIHdoaWNoIGNhc2UgTVkgYXBwcm9hY2ggd291
bGQgYmUgImlmIEknbSBub3QgU1VSRSB0aGF0DQo+IHRoZSBIVyBjYW4gZG8gaXQgYmV0dGVyLCB0
aGVuIEkgcHJvYmFibHkgc2hvdWxkbid0IGJlIGRvaW5nIGluIG9uIHRoZSBIVyIuDQo+DQo+ID4g
LSBzZXZlcmFsIHVzZXJsYW5kIHByb2dyYW1zIGFuZCBpbi1rZXJuZWwgdXNlcnMgbWF5IGJlIGFj
dGl2ZSBhdCB0aGUNCj4gPiBzYW1lIHRpbWUsIHNvIHRoZSBmYWN0IHRoYXQgYSBzaW5nbGUgdXNl
ciBzbGVlcHMgZG9lc24ndCBtZWFuIHRoZQ0KPiA+IGhhcmR3YXJlIGlzIHVzZWQgaW5lZmZpY2ll
bnRseQ0KPiA+DQo+IEknbSBub3Qgd29ycmllZCBhYm91dCB0aGUgKkhXKiBiZWluZyB1c2VkIGlu
ZWZmaWNpZW50bHkuDQo+IEknbSB3b3JyaWVkIGFib3V0IHVzaW5nIHRoZSBIVyBub3QgYmVpbmcg
YW4gaW1wcm92ZW1lbnQuDQo+DQoNCkluIGxpZ2h0IG9mIHRoaXMgZGlzY3Vzc2lvbjogSSd2ZSBi
ZWVuIHBvbmRlcmluZyBhYm91dCB0aGlzIGEgbG90IGFuZA0KSSB0aGluayB0aGUgYmVzdCBhcHBy
b2FjaCB3b3VsZCBiZSB0aGF0IHRoZSBkZWZhdWx0IGRyaXZlciBmb3IgYSBjZXJ0YWluDQpjaXBo
ZXIgc3VpdGUgc2hvdWxkIGFsd2F5cyBiZSB0aGUgZmFzdGVzdCAqc29mdHdhcmUqIHNvbHV0aW9u
IHVubGVzcyB0aGUNCmNvbnN1bWVyIGV4cGxpY2l0bHkgcmVxdWVzdHMgLSBpLmUuIGJlY2F1c2Ug
dGhlIHVzZXIgY29uZmlndXJlZCBpdCB0byBkbw0Kc28gLSBhIGNlcnRhaW4gc3BlY2lmaWMgKGhh
cmR3YXJlIGFjY2VsZXJhdGVkKSBpbXBsZW1lbnRhdGlvbi4NCg0KVG8gcmVsaWV2ZSB0aGUgYnVy
ZGVuIG9mIHNlbGVjdGluZyBhIHZlcnkgc3BlY2lmaWMgaW1wbGVtZW50YXRpb24geW91DQpjb3Vs
ZCBjb25zaWRlciBhZGRpbmcgc29tZSBmbGFnIHJlcXVlc3RpbmcgdGhlICJiZXN0IiBoYXJkd2Fy
ZQ0KYWNjZWxlcmF0ZWQgaW1wbGVtZW50YXRpb24sIGV4cGxpY3RseS4gV2l0aCB0aGUgZGVmYXVs
dCBzdGlsbCBiZWluZyB0aGUNCmJlc3Qgc29mdHdhcmUgaW1wbGVtZW50YXRpb24gaWYgdGhlIGZs
YWcgaXMgbm90IHNldC4NCg0KVGhlIGRvd25zaWRlIG9mIHRoYXQsIHRob3VnaCwgaXMgdGhhdCBl
eGlzdGluZyBDcnlwdG8gQVBJIGNvbnN1bWVycyB0aGF0DQpkbyBub3QgbWFrZSB0aGUgIGVmZm9y
dCB0byBhZGFwdCB0byB0aGlzIHNjaGVtZSBuZXZlciBiZW5lZml0IGZyb20gYW55DQpoYXJkd2Fy
ZSBhY2NlbGVyYXRpb24uDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24g
SVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgSW5zaWRlIFNlY3VyZQ0Kd3d3
Lmluc2lkZXNlY3VyZS5jb20NCg==
