Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DBCC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 07:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112F7217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 07:47:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="bE3BzzOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389039AbfEXHrM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 03:47:12 -0400
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:50696
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388911AbfEXHrM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 03:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyDYivYcrn6yeF53Wb2DYLc9LVXUZmRNjbPMIvPCl4s=;
 b=bE3BzzOBfNr0ZibhSl7/3LFypFz7jXoqjKTMFtl1dmt4fZqsDMtt7IotMP0ONbb1CbULhmRMmk8fG89hTQV1EmEr5uVIuyUqGePDm2mOuEkP1vHhKvufOxJeVbhAIqZfXmGO79kSpZsN+dcaY6NAtzRSEuKjfNJj9MT1LbpjAoI=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2245.eurprd09.prod.outlook.com (20.177.113.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 07:47:06 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 07:47:06 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAkNEAgAAUIpA=
Date:   Fri, 24 May 2019 07:47:06 +0000
Message-ID: <AM6PR09MB3523A3C44CFE5C83746B6136D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com>
In-Reply-To: <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4526094f-9085-4c9a-4b5e-08d6e01c04ad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2245;
x-ms-traffictypediagnostic: AM6PR09MB2245:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB22459E035D08D1BBB7ECEFE8D2020@AM6PR09MB2245.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(136003)(376002)(396003)(189003)(199004)(52314003)(256004)(66556008)(14444005)(64756008)(66476007)(73956011)(6436002)(55016002)(66946007)(229853002)(476003)(9686003)(66446008)(76116006)(486006)(11346002)(99286004)(446003)(7696005)(316002)(74316002)(76176011)(3846002)(6116002)(54906003)(8676002)(52536014)(33656002)(2906002)(305945005)(8936002)(81166006)(81156014)(71200400001)(71190400001)(478600001)(26005)(15974865002)(68736007)(86362001)(186003)(5660300002)(7736002)(14454004)(102836004)(53936002)(6506007)(25786009)(6246003)(6916009)(3480700005)(4326008)(66066001)(7116003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2245;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 075LeOPjPTDHii7TG7QnBg4ujDbImVlUPQf5Ko3TKMRG3Vg19yyxHMIRXu0ZN7yUpJ1VpyvdJFfYhHcXzgkejNTjzi4rlPqI1EBXhBsYBhKlfnPIt0XM5qN9pqA2OkempqkImv5riaSduTV9WLReSQYY2vr3wb7KR9Ni/7rv0QXmnMTWvnvq5W+B82pJ2fqTqqCplaKnYmUXXXD52FMJvNRjFglJYWc0U5j+qYE9rDPMvMA9ZKq5r5rFqaQZlmdR7PFEN7+IMfAjvwWxHZDQJBaXcX0rX+sDilw0vyjzIWQLar5vUHZ1gKMK3IdH74B52U1r1SDZqAXeCc/hDB1Fytf6wmD2Q5mQq06Lv7KRZHo/Y3cHckWiEtHUJhrWSM58i8UqjmAmYaWoX/K4QMEcO3DYzy5FobX7LQjTCaMZfbI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4526094f-9085-4c9a-4b5e-08d6e01c04ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 07:47:06.0596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2245
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+IFZhbGlkPyBBIHRvdGFsbHkgZmFicmljYXRlZCBjYXNlLCBpZiB5b3UgYXNrIG1lLiBZZXMs
IHlvdSBjb3VsZCBkbyB0aGF0LA0KPiA+IGJ1dCBpcyBpdCAqdXNlZnVsKiBhdCBhbGw/IFJlYWxs
eT8NCj4NCj4gWWVzLCByZWFsbHkuIFRoZSBsaWtlbGlob29kIG9mIGEgdGVzdCB2ZWN0b3Igb2Nj
dXJyaW5nIGluIHByYWN0aWNlIGlzDQo+IGVudGlyZWx5IGlycmVsZXZhbnQuIFdoYXQgbWF0dGVy
cyBpcyB0aGF0IHRoZSB0ZXN0IHZlY3RvcnMgcHJvdmlkZQ0KPiBrbm93biBvdXRwdXRzIGZvciBr
bm93biBpbnB1dHMsIGFuZCBtYW55IGFsZ29yaXRobSBzcGVjaWZpY2F0aW9ucw0KPiBleHBsaWNp
dGx5IGNvbnRhaW4gdGhlIGVtcHR5IG1lc3NhZ2UgYXMgb25lIG9mIHRoZSBkb2N1bWVudGVkIHRl
c3QNCj4gdmVjdG9ycy4NCj4NCkkgd2hvbGVoZWFydGVkbHkgZGlzYWdyZWUgLSBpbiB0aGUgY29u
dGV4dCBvZiBoYXJkd2FyZSBkZXNpZ24sIGFueXdheS4NCldoZW4geW91IGltcGxlbWVudCBzb21l
dGhpbmcsIHlvdSBjYXJlIGFib3V0IHByYWN0aWNsZSB1c2FiaWxpdHkuDQpXYXN0aW5nIGdhdGVz
IC8gdGltaW5nIC8gcG93ZXIgLyBjeWNsZXMgLyB3aGF0ZXZlciBvbiBzb21ldGhpbmcgdGhhdA0K
aGFzIG5vIHVzZSByZWxldmFudCB1c2UgY2FzZSBpcyBqdXN0IHNpbGx5LiAoSW4gdGhlIHBhcnRp
Y3VsYXIgY2FzZSBvZg0KemVybyBsZW5ndGggbWVzc2FnZXMsIHRoaXMgaXMgbm90IHNvIHRyaXZp
YWwgdG8gaW1wbGVtZW50IGluIGEgZGF0YQ0KZHJpdmVuIEhXIGFyY2hpdGVjdHVyZSEgRGF0YSBk
cml2ZW4gLi4uIEJ1dCBubyBkYXRhIC4uLikNCkFzIGxvbmcgYXMgeW91IHByb3Blcmx5IHNwZWNp
ZnkgeW91ciBoYXJkd2FyZSdzIGxpbWl0YXRpb25zLCBpdCBzaG91bGQNCm5vdCBuZWVkIHRvIGJl
IGFuIGlzc3VlLiBJZiB0aGUgSFcgZG9lc24ndCBtYXRjaCB5b3VyIHVzZSBjYXNlLCB0aGVuDQpk
b24ndCB1c2UgaXQgZm9yIHRoYXQgLi4uIEhXIGFsbW9zdCBhbHdheXMgaGFzIHN1Y2ggbGltaXRh
dGlvbnMuDQoNCkZvciBGSVBTIGNlcnRpZmljYXRpb24sIHplcm8gbGVuZ3RoIHZlY3RvcnMgYXJl
IGNvbnNpZGVyZWQgKm9wdGlvbmFsKi4NClByb2JhYmx5IGJlY2F1c2UgdGhleSByZWFsaXplZCBt
b3N0IEhXIG91dCB0aGVyZSBjYW4ndCBkbyBpdCAuLi4NCg0KPiBJbiBmYWN0LCBnaXZlbiB0aGUg
YWJvdmUsIEkgYW0gc2xpZ2h0bHkgc2hvY2tlZCB0aGF0IHlvdXIgaGFyZHdhcmUNCj4gZG9lcyBu
b3QgaGFuZGxlIGVtcHR5IG1lc3NhZ2VzIGNvcnJlY3RseS4gQXJlIHlvdSBzdXJlIGl0IGlzIGEN
Cj4gaGFyZHdhcmUgcHJvYmxlbSBhbmQgbm90IGEgZHJpdmVyIHByb2JsZW0/DQo+DQpBcyBhIG1h
dHRlciBvZiBmYWN0LCBwcmV0dHkgc3VyZSwgeWVhaCwgYXMgSSdtIGFjdHVhbGx5ICJ0aGUgSFcg
Z3V5Ii4NCg0KTm90aGluZyByZWFsbHkgc2hvY2tpbmcgYWJvdXQgdGhhdC4gV2UgbWFpbmx5IGRv
IG5ldHdvcmsgcHJvdG9jb2wNCmFjY2VsZXJhdGlvbiBhbnl3YXksIGJlaW5nIGFibGUgdG8gZG8g
c29tZSBiYXNpYyBvcGVyYXRpb25zIGlzIGp1c3QgYQ0KYm9udXMuIFdlIGRvIHNwZWNpZnkgdmVy
eSBleHRlbnNpdmVseSB3aGF0IHdlIGNhbiBhbmQgY2Fubm90IHN1cHBvcnQuDQoNCj4gSW4gYW55
IGNhc2UsIGFzIEVyaWMgcG9pbnRzIG91dCBhcyB3ZWxsLCBub3RoaW5nIGlzIHN0b3BwaW5nIHlv
dSBmcm9tDQo+IGFkZGluZyBhIHNwZWNpYWwgY2FzZSB0byB5b3VyIGRyaXZlciB0aGF0IGZhbGxz
IGJhY2sgdG8gdGhlIHNvZnR3YXJlDQo+IGltcGxlbWVudGF0aW9uIGZvciBrbm93biBicm9rZW4g
dGVzdCBjYXNlcy4NCj4NClN1cmUuIEJ1dCBteSBwb2ludCBpcyB0aGF0IHlvdSBlbmQgdXAgd2l0
aCBhIGRyaXZlciBmdWxsIG9mIHNwZWNpYWwgY2FzZXMuDQpXaGljaCBpcyBqdXN0IGJsb2F0IHNs
b3dpbmcgaXQgZG93biBhbmQgYmxvd2luZyBpdCB1cC4NCg0KQmVzaWRlcywgaW4gb3JkZXIgdG8g
YmUgYWJsZSB0byBmYWxsYmFjayB0byBzb2Z0d2FyZSBmb3IgdGhpcyBjYXNlDQpJIHdvdWxkIGhh
dmUgdG8gbWFpbnRhaW4gYSBzaGFkb3cgc29mdHdhcmUgY29udGV4dCBmb3IgKmV2ZXJ5KiBIVyBj
b250ZXh0DQpqdXN0IGJlY2F1c2Ugc29tZW9uZSAqbWlnaHQqIGRvIHNvbWUgemVybyBsZW5ndGgg
b3BlcmF0aW9uIHNvbWV3aGVyZSBpbg0KdGhlIGZ1dHVyZS4gQmVjYXVzZSBieSB0aGUgdGltZSB0
aGUgY29udGV4dCBpcyBlc3RhYmxpc2hlZCAoc2V0a2V5KSwNCkkgY2Fubm90IHByZWRpY3QgdGhh
dCBJIHdpbGwgZ2V0IHN1Y2ggYSB6ZXJvIGxlbmd0aCByZXF1ZXN0IHlldC4gWXVjay4NCg0KPiBS
ZW1vdmluZyB0ZXN0IGNhc2VzIGZyb20gdGhlIHNldCBiZWNhdXNlIG9mIGJyb2tlbiBoYXJkd2Fy
ZSBpcyBvdXQgb2YNCj4gdGhlIHF1ZXN0aW9uIElNTy4gSXQgZG9lc24ndCBhY3R1YWxseSBmaXgg
dGhlIHByb2JsZW0sIGFuZCBpdCBtYXkNCj4gYWN0dWFsbHkgcmVzdWx0IGluIGJyZWFrYWdlLCBl
c3BlY2lhbGx5IGZvciBoL3cgYWNjZWxlcmF0ZWQgY3J5cHRvDQo+IGV4cG9zZWQgdG8gdXNlcmxh
bmQsIG9mIHdoaWNoIHdlIGhhdmUgbm8gaWRlYSB3aGF0c29ldmVyIGhvdyBpdCBpcw0KPiBiZWlu
ZyB1c2VkLCBhbmQgd2hldGhlciBjb3JyZWN0IGhhbmRsaW5nIG9mIHplcm8gbGVuZ3RoIHZlY3Rv
cnMgaXMNCj4gbGlrZWx5IHRvIGJyZWFrIGFueXRoaW5nIG9yIG5vdC4NCj4NClRoZSBkcml2ZXIg
Y291bGQgY2hlY2sgZm9yIGl0IGFuZCByZXR1cm4gYW4gLUVJTlZBTCBlcnJvciBjb2RlLg0KVGhh
dCB3b3VsZCBub3QgYnJlYWsgYW55dGhpbmcgYmVzaWRlcyB0aGUgYXBwbGljYXRpb24gaXRzZWxm
IHRyeWluZw0KdG8gZG8gdGhpcy4gV2hpY2ggY291bGQgdGhlbiBmYWlsIGdyYWNlZnVsbHkuDQoN
Cj4gPiBObywgaXQncyBub3QgYmVjYXVzZSBhIGZpbGUgb2YgbGVuZ3RoIDAgaXMgYSBmaWxlIG9m
IGxlbmd0aCAwLCB0aGUgbGVuZ3RoDQo+ID4gaW4gaXRzZWxmIGlzIHN1ZmZpY2llbnQgZ3VhcmFu
dGVlIG9mIGl0cyBjb250ZW50cy4gVGhlIGhhc2ggZG9lcyBub3QgYWRkDQo+ID4gKmFueXRoaW5n
KiBpbiB0aGlzIGNhc2UuIEl0J3MgYSBjb25zdGFudCBhbnl3YXksIHRoZSBzYW1lIHZhbHVlIGZv
ciAqYW55Kg0KPiA+IHplcm8tbGVuZ3RoIGZpbGUuIEl0IGRvZXNuJ3QgdGVsbCB5b3UgYW55dGhp
bmcgeW91IGRpZG4ndCBhbHJlYWR5IGtub3cuDQo+ID4gSU1ITyB0aGUgdG9vbCBzaG91bGQganVz
dCByZXR1cm4gYSBtZXNzYWdlIHN0YXRpbmcgImhhc2hpbmcgYW4gZW1wdHkgZmlsZQ0KPiA+IGRv
ZXMgbm90IG1ha2UgYW55IHNlbnNlIGF0IGFsbCAuLi4iLg0KPiA+DQo+DQo+IFlvdSBhcmUgbWFr
aW5nIGFzc3VtcHRpb25zIGFib3V0IGhvdyB0aGUgY3J5cHRvIGlzIGJlaW5nIHVzZWQgYXQgYQ0K
PiBoaWdoZXIgbGV2ZWwuIEVyaWMncyBleGFtcGxlIG1heSBub3QgbWFrZSBzZW5zZSB0byB5b3Us
IGJ1dCBhcmd1aW5nDQo+IHRoYXQgKmFueSogdXNlIG9mIHNoYTI1NnN1bSBvbiBlbXB0eSBmaWxl
cyBpcyBndWFyYW50ZWVkIHRvIGJlDQo+IG5vbi1zZW5zaWNhbCBpbiBhbGwgaW1hZ2luYWJsZSBj
YXNlcyBpcyByaWRpY3Vsb3VzLg0KPg0KQWN0dWFsbHksIHRoZSB0aG91Z2h0IG9jY3VycmVkIHRv
IG1lIGluIHRoZSBzaG93ZXIgdGhpcyBtb3JuaW5nIHRoYXQgdGhhdA0KKm1pZ2h0KiBiZSB1c2Vm
dWwgaW4gY2FzZSB5b3UgZG9uJ3QgaGF2ZSBleHBlY3RhdGlvbnMgb2YgdGhlIGxlbmd0aA0Kd2hh
dHNvZXZlciBhbmQgb25seSBrbm93IHRoZSBleHBlY3RlZCBzdW0uIEluIHdoaWNoIGNhc2UgdGhh
dCB3b3VsZA0KdmFsaWRhdGUgdGhhdCBhIHplcm8tbGVuZ3RoIGZpbGUgaXMgaW5kZWVkIHdoYXQg
eW91IHNob3VsZCBoYXZlIC4uLg0KDQpTdGlsbCAtIGlzIHRoYXQgc29tZXRoaW5nIHRoZSBjcnlw
dG8gQVBJIGlzICpjdXJyZW50bHkqIGJlaW5nIHVzZWQgZm9yPw0KQW5kIGlmIG5vdCwgZG8gd2Ug
ZXZlciAqaW50ZW5kKiB0byB1c2UgaXQgZm9yIHNvbWV0aGluZyBsaWtlIHRoYXQ/DQpJZiBub3Qs
IHRoZW4gd2UgY291bGQganVzdCBzcGVjaWZ5IGl0IHRvIGJlIGlsbGVnYWwgc3VjaCB0aGF0IG5v
IG9uZQ0Kd291bGQgZXZlciBhdHRlbXB0IHRvIGRvIGl0LiBZb3UgaGF2ZSB0aGF0IGZyZWVkb20g
YXMgbG9uZyBhcyB0aGVyZSBhcmUNCm5vIGV4aXN0aW5nIGFwcGxpY2F0aW9ucyBkZXBlbmRpbmcg
b24gaXQgLi4uDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJj
aGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzDQoNClRlbC4gOiArMzEgKDApNzMgNjUgODEg
OTAwDQoNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
