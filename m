Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727BDC10F14
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 06:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FED82075B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 06:58:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="3bUygWCf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfDPG60 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 02:58:26 -0400
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:36677
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727424AbfDPG60 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 02:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pcxuRUGFYpuWCy9LVeAu6MHodIDEAykPnUOUrfu6Jw=;
 b=3bUygWCfXS4YYj8gHZs2c+8GvVHq61bqk4p61DXmjoXxFEIBMbtYjZBV6wO3xX5oynlw15S5NLD2G67e/N10V4UagtoJ4H4PB9gMFEb+9qM2OhTEPrFc4UpZzS5TE8Z/j2u/uIKpG44NEyrtIXAS4CWJ6PrHzrlMQe5P+JysQLQ=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2824.eurprd09.prod.outlook.com (20.179.1.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Tue, 16 Apr 2019 06:58:20 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::6112:a401:331e:a9b9%6]) with mapi id 15.20.1792.018; Tue, 16 Apr 2019
 06:58:20 +0000
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
Thread-Index: AQHU84f0k/ZyPbZSmUmrONQ4OcgLtKY9W0yAgAABiZCAAAX+AIAA9LCg
Date:   Tue, 16 Apr 2019 06:58:20 +0000
Message-ID: <AM6PR09MB35234C86C0502E1FAAB3A305D2240@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
 <3a1288ab-8e18-5421-05b4-4f4ef2fc531c@redhat.com>
 <AM6PR09MB35237F925CF4C82FBBA53862D22B0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <fda47663-9536-0d36-5a0e-c6da77e21209@redhat.com>
In-Reply-To: <fda47663-9536-0d36-5a0e-c6da77e21209@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6292bfae-2506-41e3-4fe7-08d6c238e964
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR09MB2824;
x-ms-traffictypediagnostic: AM6PR09MB2824:
x-microsoft-antispam-prvs: <AM6PR09MB28247A97563CFB629F2433F4D2240@AM6PR09MB2824.eurprd09.prod.outlook.com>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(39850400004)(136003)(346002)(189003)(199004)(99286004)(97736004)(9686003)(33656002)(25786009)(7416002)(81166006)(74316002)(14454004)(86362001)(8676002)(5660300002)(3846002)(2906002)(4326008)(68736007)(305945005)(81156014)(71200400001)(52536014)(6116002)(7736002)(6246003)(8936002)(14444005)(256004)(76176011)(71190400001)(229853002)(110136005)(53936002)(6506007)(55016002)(93886005)(106356001)(7696005)(54906003)(316002)(446003)(486006)(6436002)(478600001)(476003)(26005)(186003)(66066001)(102836004)(105586002)(11346002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2824;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SwZWRDpKyuBy3V1M4hrKYsQE37f+fkWxzp9vx11lHTq59/Mj6PRfBVGRf75IpQyG/gTQ27gHKJrZ8dKjyN5PVwJMJYRNqjpyXrAd63P5M+1ASH3Du3AdwLua3L5+tR7D5A5VWFTATkk7UvUYTkdcveFcR80OJ/ILEFyG9jId1JrDqhw74Yn5ksQ7r+K3MYtTDQtx4Xu5jsPpKQbCG4cVEvrHfCss4aACS45QCzAe+IMLS8k6uQpdckhhf16q5upUGbO/MIY6iW+Zi9HPASyXZNniHfFhgeF7MekFcJMkwY0FbjcbT3bk2ae75I7ntAu3enP/u/84xjy+9lUIaolwysovGkgtbVrdmREYEeFrqy7w56tABhVBO3ft+JQuyL5uWV6pZkSe0gc/+gIdJkVroLgZZmAm/i5LDRQZSOBC1cw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6292bfae-2506-41e3-4fe7-08d6c238e964
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 06:58:20.8355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2824
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IEJlc2lkZXMgdGhhdCwgdGhleSBhcmUNCj4gPiBpbiBoZWF2eSBwcmFjdGljYWwgdXNlIGlu
IG1haW5sYW5kIENoaW5hLCB1c3VhbGx5IGFzIGRpcmVjdA0KPiByZXBsYWNlbWVudHMNCj4gPiBm
b3IgU0hBMi0yNTYgYW5kIEFFUyBpbiB3aGF0ZXZlciBwcm90b2NvbCBvciB1c2UgY2FzZSB5b3Ug
bmVlZDoNCj4gSVBzZWMsDQo+ID4gVExTLCBXUEEyLCBYVFMgZm9yIGRpc2sgZW5jcnlwdGlvbiwg
eW91IG5hbWUgaXQuDQo+DQo+IEhvdyBzaG91bGQgdGhhdCBtZWFuIGFueXRoaW5nPw0KPg0KVWht
IC4uLiBubywgdGhlIGZhY3QgdGhhdCBzb21ldGhpbmcgaXMgYWN0dWFsbHkgKnVzZWZ1bCogdG8g
cG90ZW50aWFsbHkNCmEgYmlsbGlvbiBwbHVzIHBlb3BsZSBkb2Vzbid0IG1lYW4gYW55dGhpbmcg
Li4uDQoNCj4gSSBkaWQgZWR1Y2F0ZSBteXNlbGYgYSBiaXQsIGJ1dCBJJ20gbm90IGFuIGV4cGVy
dCBpbiBjcnlwdG9ncmFwaHksIHNvIEkNCj4gd291bGQgbGlrZSB0byBiZSBzdXJlIHRoYXQgdGhl
c2UgYXJlIG5vdCBhbm90aGVyIFNwZWNrIG9yIERVQUwtRUMtRFJCRy4NCj4NCklubm9jZW50IHVu
dGlsIHByb3ZlbiBndWlsdHkgbWVhbiBhbnl0aGluZyB0byB5b3U/DQoNCj4gICJTTTIgaXMgYmFz
ZWQgb24gRUNDKEVsbGlwdGljIEN1cnZlIENyeXB0b2dyYXBoeSksIGFuZCB1c2VzIGEgc3BlY2lh
bA0KPiBjdXJ2ZSIgaXMgZW5vdWdoIGZvciBtZSB0byBzZWUgd2FybmluZyBzaWducywgYXQgbGVh
c3Qgd2l0aG91dCBmdXJ0aGVyDQo+IGV4cGxhbmF0aW9ucywNCj4NClRoZSBzcGVjaWZpY2F0aW9u
IGlzIHB1YmxpYyAoaWYgeW91IGNhbiByZWFkIENoaW5lc2UsIGFueXdheSksIHNvIG9wZW4gdG8N
CmFuYWx5c2lzLiBFaXRoZXIgd2F5LCBpdCdzIHF1aXRlIGlycmVsZXZhbnQgdG8gQ2hpbmVzZSBv
cmdhbmlzYXRpb25zIHRoYXQNCkhBVkUgdG8gdXNlIFNNMi4gQW5kIGFueW9uZSBlbHNlIGNhbiBq
dXN0IGRlY2lkZSBOT1QgdG8gdXNlIGl0LCB5b3UgZG9uJ3QNCmV2ZW4gaGF2ZSB0byBjb21waWxl
IGl0IGludG8geW91ciBrZXJuZWwuIEl0J3MgY2FsbGVkIGZyZWVkb20uDQoNCj4gYW5kIHNvIGRv
ZXMgdGhlIGZhY3QgdGhhdCB0aGUgaW5pdGlhbCBTTTMgdmFsdWVzIHdlcmUNCj4gY2hhbmdlZCBm
cm9tIFNIQS0yIGFuZCBBRkFJQ1QgdGhlcmUgaXMgbm8gcHVibGljIGp1c3RpZmljYXRpb24gZm9y
DQo+IHRoYXQuDQo+DQpBY3R1YWxseSwgU00zIGlzIGFuICppbXByb3ZlbWVudCogb24gU0hBLTIs
IGFuZCB0aGVyZSBoYXMgYmVlbiBhbXBsZQ0KYW5hbHlzaXMgZG9uZSBvbiB0aGF0IHRvLCBpbiBm
YWN0LCBjb25maXJtIGl0J3MgKHNsaWdodGx5KSBiZXR0ZXIuDQpTbyB0aGVyZSBJUyBwdWJsaWMg
anVzdGlmaWNhdGlvbi4gRG9uJ3Qgc2hvdXQgaWYgeW91IGRvbid0IGtub3cgdGhlDQpmYWN0cy4N
Cg0KUmVnYXJkcywNClBhc2NhbA0K
