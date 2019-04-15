Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035BDC10F12
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 15:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 987BB20880
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 15:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="JgGnh1FQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfDOPwF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 11:52:05 -0400
Received: from mail-eopbgr80114.outbound.protection.outlook.com ([40.107.8.114]:4853
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727564AbfDOPwE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 11:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXY/iLvu0SVIX/e5iYVT79z/sygnujnE5eGIuuQTw0c=;
 b=JgGnh1FQOMuUCvaiL+zTy9zb8JEFzXwa620eelB7PVRT/mMBtrUIiH9ZeT/xr90/5W0NCxiTFM/uHIl9C6YmKxSlxJBj9cX69jyN+BveE7mQCwY298+skyQ+ESfhKW8Lv1jaWp/D45ceUB9Yv76nXah3pfDt9FZFuynlgvuUL2w=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3335.eurprd09.prod.outlook.com (20.179.245.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.14; Mon, 15 Apr 2019 15:51:55 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1792.018; Mon, 15 Apr 2019
 15:51:55 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Hao Feng <fenghao@hygon.cn>,
        'Tom Lendacky ' <thomas.lendacky@amd.com>,
        'Gary Hook ' <gary.hook@amd.com>,
        'Herbert Xu ' <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>,
        'Janakarajan Natarajan ' <Janakarajan.Natarajan@amd.com>,
        'Joerg Roedel ' <joro@8bytes.org>,
        =?utf-8?B?JyBSYWRpbSBLcsSNbcOhxZkgJw==?= <rkrcmar@redhat.com>,
        'Thomas Gleixner ' <tglx@linutronix.de>,
        'Ingo Molnar ' <mingo@redhat.com>,
        'Borislav Petkov ' <bp@alien8.de>,
        "' H. Peter Anvin '" <hpa@zytor.com>
CC:     'Zhaohui Du ' <duzhaohui@hygon.cn>,
        'Zhiwei Ying ' <yingzhiwei@hygon.cn>,
        'Wen Pu ' <puwen@hygon.cn>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/6] Add Hygon SEV support
Thread-Topic: [PATCH 0/6] Add Hygon SEV support
Thread-Index: AQHU84f0k/ZyPbZSmUmrONQ4OcgLtKY9W0yAgAABiZA=
Date:   Mon, 15 Apr 2019 15:51:55 +0000
Message-ID: <AM6PR09MB35237F925CF4C82FBBA53862D22B0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
 <3a1288ab-8e18-5421-05b4-4f4ef2fc531c@redhat.com>
In-Reply-To: <3a1288ab-8e18-5421-05b4-4f4ef2fc531c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3eb22cda-29de-40a6-aa9a-08d6c1ba4944
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB3335;
x-ms-traffictypediagnostic: AM6PR09MB3335:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB33350D356410E0B8928EE39AD22B0@AM6PR09MB3335.eurprd09.prod.outlook.com>
x-forefront-prvs: 000800954F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(396003)(346002)(376002)(366004)(136003)(199004)(189003)(13464003)(86362001)(229853002)(4326008)(15974865002)(25786009)(7416002)(54906003)(186003)(6436002)(110136005)(7736002)(305945005)(316002)(3846002)(68736007)(6116002)(99286004)(7696005)(26005)(76176011)(102836004)(74316002)(106356001)(6246003)(105586002)(66066001)(2906002)(71200400001)(66574012)(8936002)(486006)(52536014)(9686003)(71190400001)(256004)(476003)(478600001)(55016002)(6506007)(81156014)(8676002)(11346002)(14454004)(97736004)(446003)(53936002)(81166006)(33656002)(53546011)(5660300002)(14444005)(921003)(1121003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3335;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vPkI0DzdlvesGC5Mtt0lMId2SVbM6VZu9NXgUxTfeUQ4OCd17udSbBl7UIIU5+LiFQNu5nvXZ+fry9HmplO1MRBcjGS6fB4piKjsF889wK2WeY1e1VZ0e9aEW99S+N6btgvkH4hKt7amr1BYPEpuXRVgt/mNJn3toVC3k4/pzngx5BEkLOtF5LeyO7xk7WGwPiWeUnhVoovuMtrhzE++TeEDJ/9oBYj7N1OFeujjVoItK+MyiB0pBlPT4AFrtZGxVmvccwLuTrDYwlKQqikX83MQXuNKVWQ2Lc1EXrNA6OppHZQowoHXR9sczx72l3NfBdE20SaweTvbIdkQii+yToINPmpaA0Sl8nh4w2e5zYi5yjCzqOkRc0Wb3qoX1HWUQqjND7X6tfrir6qcbj560wiVH3XtdkN44nQNnOttAlI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb22cda-29de-40a6-aa9a-08d6c1ba4944
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2019 15:51:55.5497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3335
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtY3J5cHRvLQ0KPiBvd25lckB2Z2VyLmtlcm5l
bC5vcmddIE9uIEJlaGFsZiBPZiBQYW9sbyBCb256aW5pDQo+IFNlbnQ6IE1vbmRheSwgQXByaWwg
MTUsIDIwMTkgNTozOCBQTQ0KPiBUbzogSGFvIEZlbmcgPGZlbmdoYW9AaHlnb24uY24+OyAnVG9t
IExlbmRhY2t5ICcNCj4gPHRob21hcy5sZW5kYWNreUBhbWQuY29tPjsgJ0dhcnkgSG9vayAnIDxn
YXJ5Lmhvb2tAYW1kLmNvbT47ICdIZXJiZXJ0DQo+IFh1ICcgPGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdT47ICcgRGF2aWQgUy4gTWlsbGVyICcNCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyAn
SmFuYWthcmFqYW4gTmF0YXJhamFuICcNCj4gPEphbmFrYXJhamFuLk5hdGFyYWphbkBhbWQuY29t
PjsgJ0pvZXJnIFJvZWRlbCAnIDxqb3JvQDhieXRlcy5vcmc+OyAnDQo+IFJhZGltIEtyxI1tw6HF
mSAnIDxya3JjbWFyQHJlZGhhdC5jb20+OyAnVGhvbWFzIEdsZWl4bmVyICcNCj4gPHRnbHhAbGlu
dXRyb25peC5kZT47ICdJbmdvIE1vbG5hciAnIDxtaW5nb0ByZWRoYXQuY29tPjsgJ0JvcmlzbGF2
DQo+IFBldGtvdiAnIDxicEBhbGllbjguZGU+OyAnIEguIFBldGVyIEFudmluICcgPGhwYUB6eXRv
ci5jb20+DQo+IENjOiAnWmhhb2h1aSBEdSAnIDxkdXpoYW9odWlAaHlnb24uY24+OyAnWmhpd2Vp
IFlpbmcgJw0KPiA8eWluZ3poaXdlaUBoeWdvbi5jbj47ICdXZW4gUHUgJyA8cHV3ZW5AaHlnb24u
Y24+OyB4ODZAa2VybmVsLm9yZzsNCj4gbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsga3Zt
QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCAwLzZdIEFkZCBIeWdvbiBTRVYgc3VwcG9ydA0KPg0KPiBPbiAxNS8w
NC8xOSAxNDowNCwgSGFvIEZlbmcgd3JvdGU6DQo+ID4gSHlnb24gU0VWIGZvbGxvd3MgQU1EIFNF
ViB3b3JrIGZsb3csIGJ1dCB1c2VzIENoaW5hIG5hdGlvbmFsIHN0YW5kYXJkDQo+ID4gY3J5cHRv
Z3JhcGhpYyBhbGdvcml0aG1zIFNNMi9TTTMvU000IGluc3RlYWQgb2YgKFJTQSwgRUNEU0EsDQo+
ID4gRUNESCkvU0hBL0FFUy4gUmV1c2UgbW9zdCBBTUQgU0VWIGNvZGUgcGF0aCB0byBzdXBwb3J0
IEh5Z29uIFNFViwNCj4gPiBhbHNvIGFkZHMgMyBuZXcgY29tbWFuZHMoR01fUFVCS0VZX0dFTiwg
R01fR0VUX0RJR0VTVCwNCj4gPiBHTV9WRVJJRllfRElHRVNUKSB0byBzdXBwb3J0IFNNMiBrZXkg
ZXhjaGFuZ2UgcHJvdG9jb2wuDQo+ID4NCj4gPiBTTTIgaXMgYmFzZWQgb24gRUNDKEVsbGlwdGlj
IEN1cnZlIENyeXB0b2dyYXBoeSksIGFuZCB1c2VzIGEgc3BlY2lhbA0KPiA+IGN1cnZlLiBJdCBj
YW4gYmUgdXNlZCBpbiBkaWdpdGFsIHNpZ25hdHVyZSwga2V5IGV4Y2hhbmdlIGFuZA0KPiA+IGFz
eW1tZXRyaWMgY3J5cHRvZ3JhcGh5LiBGb3Iga2V5IGV4Y2hhbmdlLCBTTTIgaXMgc2ltaWxhciB0
byBFQ0RILA0KPiBidXQNCj4gPiBpbnZvbHZlcyBuZXcgcmFuZG9tIGtleSwgbWVhbmluZyB0aGUg
dHdvIHNpZGVzIG5lZWQgdG8gZXhjaGFuZ2UgZXh0cmENCj4gPiByYW5kb20gcHVibGljIGtleSBi
ZXNpZGVzIHRoZWlyIHB1YmxpYyBrZXksIHRoYXQncyB3aHkgYWRkaXRpb25hbA0KPiBBUElzDQo+
ID4gYXJlIG5lZWRlZCB0byBzdXBwb3J0IEh5Z29uIFNFVi4NCj4gPiBTTTMgaXMgYSBoYXNoIGFs
Z29yaXRobSwgc2ltaWxhciB0byBTSEEtMjU2Lg0KPiA+IFNNNCBpcyBhIGJsb2NrIGNpcGhlciBh
bGdvcml0aG0sIHNpbWlsYXIgdG8gQUVTLTEyOC4NCj4NCj4gSSBkb24ndCBzZWUgU00yIGFuZCBT
TTMgaW1wbGVtZW50ZWQgZWxzZXdoZXJlIGluIExpbnV4LiAgU000IGlzIG9ubHkNCj4gc3VwcG9y
dGVkIGJ5IGEgZmV3IHdpcmVsZXNzIGRyaXZlcnMuDQo+DQo+IEFwYXJ0IGZyb20gdGhlIGNvbmNl
cm5zIHRoYXQgVGhvbWFzIG1lbnRpb25lZCwgeW91IGhhdmUgdG8gY29udmluY2UgdGhlDQo+IHJl
c3Qgb2YgdGhlIGNvbW11bml0eSB0aGF0IHRoZXNlIHByaW1pdGl2ZXMgYXJlIHNlY3VyZSAoZm9y
IGV4YW1wbGUgYnkNCj4gY29udHJpYnV0aW5nIHN1cHBvcnQgZm9yIHRoZW0gdG8gZHJpdmVycy9j
cnlwdG8pLCBhbmQgdGhlbiBLVk0gd2lsbA0KPiBzdGFydCB1c2luZyB0aGVtLg0KPg0KDQpJIGRv
bid0IGtub3cgYWJvdXQgU00yLCBidXQgYm90aCBTTTMgYW5kIFNNNCBhcmUgYWxyZWFkeSBpbXBs
ZW1lbnRlZCBpbg0KdGhlIGtlcm5lbCB0cmVlIGFzIGdlbmVyaWMgQyBjb2RlIGFuZCBjb3ZlcmVk
IGJ5IHRoZSB0ZXN0bWdyLg0KDQpUaGVyZSBhbHNvIGhhcyBiZWVuIHF1aXRlIHNvbWUgYW5hbHlz
aXMgZG9uZSBvbiB0aGVtIChHb29nbGUgaXMgeW91cg0KZnJpZW5kKSBhbmQgdGhleSBhcmUgZ2Vu
ZXJhbGx5IGNvbnNpZGVyZWQgc2VjdXJlLiBCZXNpZGVzIHRoYXQsIHRoZXkgYXJlDQppbiBoZWF2
eSBwcmFjdGljYWwgdXNlIGluIG1haW5sYW5kIENoaW5hLCB1c3VhbGx5IGFzIGRpcmVjdCByZXBs
YWNlbWVudHMNCmZvciBTSEEyLTI1NiBhbmQgQUVTIGluIHdoYXRldmVyIHByb3RvY29sIG9yIHVz
ZSBjYXNlIHlvdSBuZWVkOiBJUHNlYywNClRMUywgV1BBMiwgWFRTIGZvciBkaXNrIGVuY3J5cHRp
b24sIHlvdSBuYW1lIGl0Lg0KDQo+DQo+IEJlY2F1c2UgYXMgZmFyIGFzIEkga25vdywgdGhleSBj
b3VsZCBiZSBqdXN0IGFzIHNlY3VyZSBhcyBkb3VibGUgcm90MTMuDQo+DQoNCllvdSBjb3VsZCBl
ZHVjYXRlIHlvdXJzZWxmIGZpcnN0IGluc3RlYWQgb2YganVzdCBtYWtpbmcgYXNzdW1wdGlvbnM/
DQoNClJlZ2FyZHMsDQoNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3Qs
IE11bHRpLVByb3RvY29sIEVuZ2luZXMNCg0KVGVsLiA6ICszMSAoMCk3MyA2NSA4MSA5MDANCg0K
d3d3Lmluc2lkZXNlY3VyZS5jb20NCg0K
