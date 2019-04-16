Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27567C10F13
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 09:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEDF720651
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 09:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="S110jzCD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfDPJI4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:08:56 -0400
Received: from mail-eopbgr00103.outbound.protection.outlook.com ([40.107.0.103]:51128
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbfDPJIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 05:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/pSjiISLH8SU6qCCZYjqqjSUKXvCPWR2PLZaCySIy8=;
 b=S110jzCDctEgsUE7A/JpkF97OwAgU5dTfNeTKLGcTuBRuxX+2TsXb8G5v6gIaCCKIyApzs/UZwj5cq/uesMd2Avxru3BXlfljY6Hv51/H812OkZZzOjyCh+lViGW/gTiMVpO/Nz0nlrL2f4YShxCd9zpr254HQnhGnU/ooYvetc=
Received: from DBBPR09MB3526.eurprd09.prod.outlook.com (20.179.47.151) by
 DBBPR09MB3077.eurprd09.prod.outlook.com (10.255.79.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.15; Tue, 16 Apr 2019 09:08:50 +0000
Received: from DBBPR09MB3526.eurprd09.prod.outlook.com
 ([fe80::e16b:1c2d:ee2d:bb5c]) by DBBPR09MB3526.eurprd09.prod.outlook.com
 ([fe80::e16b:1c2d:ee2d:bb5c%4]) with mapi id 15.20.1792.018; Tue, 16 Apr 2019
 09:08:49 +0000
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
Thread-Index: AQHU84f0k/ZyPbZSmUmrONQ4OcgLtKY9W0yAgAABiZCAAAX+AIAA9LCggAAY2oCAAAFi4A==
Date:   Tue, 16 Apr 2019 09:08:49 +0000
Message-ID: <DBBPR09MB3526D65B174254E791553545D2240@DBBPR09MB3526.eurprd09.prod.outlook.com>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
 <3a1288ab-8e18-5421-05b4-4f4ef2fc531c@redhat.com>
 <AM6PR09MB35237F925CF4C82FBBA53862D22B0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <fda47663-9536-0d36-5a0e-c6da77e21209@redhat.com>
 <AM6PR09MB35234C86C0502E1FAAB3A305D2240@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <985108b1-6d51-4458-48de-c5b96c5f14f9@redhat.com>
In-Reply-To: <985108b1-6d51-4458-48de-c5b96c5f14f9@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2e32afc-3b4a-4dc8-7944-08d6c24b23d9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DBBPR09MB3077;
x-ms-traffictypediagnostic: DBBPR09MB3077:
x-microsoft-antispam-prvs: <DBBPR09MB3077E3A6D4DDE8AD209A9444D2240@DBBPR09MB3077.eurprd09.prod.outlook.com>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(396003)(376002)(39850400004)(52314003)(189003)(199004)(71190400001)(74316002)(52536014)(186003)(6506007)(71200400001)(5660300002)(3846002)(7416002)(66066001)(478600001)(6116002)(55016002)(9686003)(446003)(26005)(102836004)(68736007)(4326008)(486006)(86362001)(6246003)(53936002)(2906002)(476003)(11346002)(81166006)(8676002)(25786009)(33656002)(93886005)(105586002)(14444005)(97736004)(99286004)(110136005)(81156014)(256004)(316002)(76176011)(6436002)(305945005)(106356001)(14454004)(8936002)(7696005)(229853002)(54906003)(7736002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DBBPR09MB3077;H:DBBPR09MB3526.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vynIgbBAraI+WVEv1TQVbMItIoMewImJr96oAxe2wf6RAzJ07W+YYFIkxpYMoI1D1ya1OXnjvMv3SZOLIMXC7trtmSMFIr/leBNx6JftwEXMoEskbbuXQ8xDzUmvyLCJ3FLbImVj6sh8LdAx5VBsa/bD8sVh6PpuyXMRrE8m67GYwVMGjEYBRq7KaJeIQGF5jHOFYW0nnca9zvsJj6N5Bd6N3LnWj1302gFuCZ8QU9CncHw22hsagbElEgTSPVUOx2N3xmqYpLJaDMgR+Ped0JCQvBx1JFrwBl+aJ1cltDxlPLN7YPSq0vmUR+7afHeLCsekSwzBswmBFqvc6pJooQiUg8qDn0//3MFGoAti3KjpCzFZTznWptox61p7KKjyS5UGmRC+ZJ3xqkZ9jQ0D1EmKXuN4kmPhhLy5iAgP2hY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e32afc-3b4a-4dc8-7944-08d6c24b23d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 09:08:49.7723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR09MB3077
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+DQo+ID4gVWhtIC4uLiBubywgdGhlIGZhY3QgdGhhdCBzb21ldGhpbmcgaXMgYWN0dWFsbHkg
KnVzZWZ1bCogdG8NCj4gcG90ZW50aWFsbHkNCj4gPiBhIGJpbGxpb24gcGx1cyBwZW9wbGUgZG9l
c24ndCBtZWFuIGFueXRoaW5nIC4uLg0KPg0KPiBVc2VmdWwgZG9lcyBub3QgbWVhbiBzZWN1cmUs
IGRvZXMgaXQ/ICBQS1pJUCBlbmNyeXB0aW9uIHdhcyBjZXJ0YWlubHkNCj4gdXNlZnVsIGJhY2sg
aW4gdGhlIGRheSwgYnV0IGl0IHdhcyBub3Qgc2VjdXJlLg0KPg0KIlNlY3VyZSIgaXMgYSByZWxh
dGl2ZSB0ZXJtIGFueXdheS4gVGhlcmUncyBhbHdheXMgYSB0cmFkZS1vZmYgYmV0d2Vlbg0KcGVy
Zm9ybWFuY2UsIGNvc3QsIHBvd2VyIGNvbnN1bXB0aW9uIGFuZCBzZWN1cml0eS4gRGlmZmVyZW50
IHVzZSBjYXNlcw0KcmVxdWlyZSBkaWZmZXJlbnQgbGV2ZWxzIG9mIHNlY3VyaXR5LiBJTUhPIHRo
YXQgZGVjaXNpb24gc2hvdWxkIGJlIHVwDQp0byB0aGUgYXBwbGljYXRpb24gLyB1c2VyIC8gbWFy
a2V0LCBhbmQgbm90IHVwIHRvIHNvbWUgc29mdHdhcmUNCmVuZ2luZWVycyB0aGF0IGFyZSBub3Qg
ZXhwZXJ0cyBvbiB0aGUgc3ViamVjdCBtYXR0ZXIgYW55d2F5IChidXQgSSBhbQ0KaG9wZWZ1bCB0
aGF0IHNvbWUgcGVvcGxlIGhlcmUgYXJlLCBpbiBmYWN0LCBleHBlcnRzIHRvIHNvbWUgZXh0ZW50
KS4NCg0KPiAiRnJlZWRvbSIgZGlkbid0IGFwcGx5IHdoZW4gU3BlY2sgd2FzIHByb3Bvc2VkIGZv
ciBpbmNsdXNpb24gaW4gTGludXgsDQo+IGFuZCBJIHdvdWxkIGxpa2UgdG8gbWFrZSBzdXJlIEkg
ZG9uJ3QgbWFrZSBhIG1pc3Rha2Ugd2hlbiBhZGRpbmcgY3J5cHRvDQo+IGludGVyZmFjZXMuICBJ
ZiBTTTIvMy80IHdlcmUgYnJva2VuLCBJIGNvdWxkbid0IGNhcmUgbGVzcyBpZiBzb21lb25lDQo+
IEhBUyB0byB1c2UgdGhlbSwgdGhleSBjYW4gcGF0Y2ggdGhlaXIga2VybmVsLg0KPg0KSXMgU3Bl
Y2sgYWN0dWFsbHkgdXNlZCBpbiBhbnkgcmVhbC1saWZlIHByb3RvY29sIG9yIGFwcGxpY2F0aW9u
Pw0KSSBkaWQgbm90IGZvbGxvdyB0aGUgU3BlY2sgZGlzY3Vzc2lvbiBidXQgSSBoYXZlIGEgaHVu
Y2ggdGhhdCB3YXMgYSBmYXINCm1vcmUgaW1wb3J0YW50IHJlYXNvbiBub3QgdG8gaW5jbHVkZSBp
dCB0aGFuIGl0IGJlaW5nIGEgd2VhayBjaXBoZXIgb3INCml0J3Mgc2hhZHkgTlNBIG9yaWdpbnMg
Li4uDQoNCkFuZCB5ZXMsIHRoZXkgY2FuIGFsd2F5cyBmb3JrIHRoZSBrZXJuZWwgYW5kIGRvIHRo
ZWlyIG93biBzdHVmZiB3aXRoIGl0LA0KYnV0IHRoYXQncyBnb2luZyB0byBiZSBhIHN1cHBvcnQg
bmlnaHRtYXJlIGZvciBwZW9wbGUgLSBsaWtlIHVzIC0gd2FudGluZw0KdG8gYWRkIEhXIGFjY2Vs
ZXJhdGlvbiBvbiB0b3Agb2YgdGhhdC4gQW5kIHllcywgIndlIiBjYW4gZG8gU00zICYgU000Lg0K
RnVsbCBkaXNjbG9zdXJlOiBpdCBpcyBpbiBteS9vdXIgaW50ZXJlc3QgdG8ga2VlcCBTTTMgJiBT
TTQgaW4gdGhlIHRyZWUuDQoNCj4gIEJ1dCBpZiB0aGV5J3JlIG5vdCB0aGVuIEkgYXBwcmVjaWF0
ZSB0aGF0IHlvdSB3cm90ZSB0byBjb3JyZWN0IG1lLA0KPiBpdCdzIGhlbHBmdWwuICBQbGVhc2UN
Cj4gdW5kZXJzdGFuZCB0aGF0IDk5JSBvZiB0aGUgY29tbXVuaXR5IGhhcyBub3QgZXZlciBoZWFy
ZCBvZiBhbnl0aGluZyBidXQNCj4gU0hBLXsxLDIsM30sIEVDRFNBLCBFZDI1NTE5LCBBRVMuICBJ
ZiBzb21lYm9keSBjb21lcyB1cCB3aXRoIGEgcGF0Y2gNCj4gd2l0aCAic3RyYW5nZSIgY3J5cHRv
LCBpdCdzIHVwIHRvIHRoZW0gdG8gc2F5IHRoYXQgdGhleSBhcmUgc2VjdXJlLS0tDQo+IGFuZCBh
Z2FpbiwgdGhlIGtleSB3b3JkIGlzIHNlY3VyZSwgbm90IHVzZWZ1bC4NCj4NCkkgcmVjb2duaXNl
IHRoZSBmYWN0IHRoYXQgbW9zdCBwZW9wbGUgYXJlIG5vdCBleHBlcnRzIG9uIHRoZSBzdWJqZWN0
DQptYXR0ZXIuIEhvd2V2ZXIsIHRoZXJlJ3MgYSBsb3QgeW91IGNhbiBmaW5kIG91dCBpbiBhIHNo
b3J0IEdvb2dsZSBzZXNzaW9uDQpiZWZvcmUgeW91IHN0YXJ0IGEgZGlzY3Vzc2lvbiBvbiBpbmNv
cnJlY3QgYXNzdW1wdGlvbnMgLi4uDQpBbnl3YXksIGFsd2F5cyBoYXBweSB0byBlZHVjYXRlIHBl
b3BsZSBhIGJpdC4NCg0KUmVnYXJkcywNCg0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQ
IEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIEluc2lkZSBTZWN1cmUNCg0KDQoN
Cg==
