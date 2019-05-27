Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3873C282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81D3721734
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="xPkw3WB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfE0Jw0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 05:52:26 -0400
Received: from mail-eopbgr20114.outbound.protection.outlook.com ([40.107.2.114]:28483
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfE0JwZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 05:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FtW4V579nqGENRsfdsjxwUYszy7znMZlsUPC7YlRprI=;
 b=xPkw3WB+WxziZ2H3u8nzEnHVG2aeu99AowJTYJNPQRvRI4xuXq6AZIzIjV35blGTbyQ0YrlvTLu2Erwxs7gfVlUXBffxssSFCF5VKn63pPc56qJ/QrdZC5+ZPhxB7SKElESzgUXhTWodEJAmzzXLr6TKoqE3i/hFzvd4xCRWak4=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2792.eurprd09.prod.outlook.com (20.179.1.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Mon, 27 May 2019 09:52:20 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 09:52:20 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAAD1MIAABH2AgAAAYtCAABcmgIAEn2yA
Date:   Mon, 27 May 2019 09:52:19 +0000
Message-ID: <AM6PR09MB3523075E7AD2AC48AADCC274D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
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
 <AM6PR09MB35232C98F70FCB4A37AE7148D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-iPWA8i9f9SYkoG4SJYUv93PBo6ozMqBA7nGegUVm5gQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu-iPWA8i9f9SYkoG4SJYUv93PBo6ozMqBA7nGegUVm5gQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cfe6c17-fada-4a23-b220-08d6e2890286
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2792;
x-ms-traffictypediagnostic: AM6PR09MB2792:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2792391B5DE3A794DAB6AE9ED21D0@AM6PR09MB2792.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(366004)(396003)(39840400004)(13464003)(189003)(199004)(5660300002)(52536014)(478600001)(66476007)(66556008)(102836004)(64756008)(53936002)(3480700005)(68736007)(7116003)(74316002)(26005)(53546011)(81156014)(66446008)(86362001)(186003)(14454004)(8936002)(15974865002)(229853002)(81166006)(73956011)(66946007)(6246003)(8676002)(76116006)(6506007)(4326008)(71190400001)(71200400001)(2906002)(99286004)(7696005)(14444005)(256004)(486006)(6436002)(7736002)(305945005)(446003)(25786009)(6916009)(54906003)(9686003)(3846002)(6116002)(55016002)(33656002)(476003)(66066001)(316002)(11346002)(76176011)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2792;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: btjeaoOOvnUeE1PV5Rt30y9TItcVpf3O+4lcFiOcbqwvR2lot6YgtLt/7RA41pMJS3j8rJu4LEDmsXKlAZj6WqjFvesik5z3kx+m8EO4iEmqcMmiN50mhIf0olHVxLmZrxvpcrdma9MkmvIEA4mP3wjSP5hrMcRVD5o5GONGN0G6V1YTbl9rXEWwIQPQmCer+UlmULCpnoh2SVLsPvYXCUA/XLc+IhoTH7wrhtNO6BHAn1DsJ0arVKbO2RdgQspKYpwRxScwAmyKRvcdgLFK8QRRFaLYmcRoazFNFe3pE+w+By2mcoPJeucqMXEWT26rk7IGmSfLIuY88aeH4+ko7jf1+maBD+POxvv2b48FiQPKe3JBtKZDPAqPHOlNTZ0flpHCckq9HFJYGL6GKfmNrhQvO2Whymypj7HZklp9Lpw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cfe6c17-fada-4a23-b220-08d6e2890286
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 09:52:19.8733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2792
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCBbbWFp
bHRvOmFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmddDQo+IFNlbnQ6IEZyaWRheSwgTWF5IDI0LCAy
MDE5IDE6MTAgUE0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AaW5zaWRl
c2VjdXJlLmNvbT4NCj4gQ2M6IENocmlzdG9waGUgTGVyb3kgPGNocmlzdG9waGUubGVyb3lAYy1z
LmZyPjsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogYW5vdGhl
ciB0ZXN0bWdyIHF1ZXN0aW9uDQo+DQo+IE9uIEZyaSwgMjQgTWF5IDIwMTkgYXQgMTE6NTcsIFBh
c2NhbCBWYW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3ZW5AaW5zaWRlc2VjdXJlLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiA+IEFnYWluLCB5b3UgYXJlIG1ha2luZyBhc3N1bXB0aW9ucyBoZXJlIHRoYXQg
ZG9uJ3QgYWx3YXlzIGhvbGQuIE5vdGUgdGhhdA0KPiA+ID4gLSBhIGZyb3plbiBwcm9jZXNzIGZy
ZWVzIHVwIHRoZSBDUFUgdG8gZG8gb3RoZXIgdGhpbmdzIHdoaWxlIHRoZQ0KPiA+ID4gY3J5cHRv
IGlzIGluIHByb2dyZXNzOw0KPiA+ID4gLSBoL3cgY3J5cHRvIGlzIHR5cGljYWxseSBtb3JlIHBv
d2VyIGVmZmljaWVudCB0aGFuIENQVSBjcnlwdG87DQo+ID4gPg0KPiA+IFRydWUuIFRob3NlIGFy
ZSB0aGUgIm90aGVyIiByZWFzb25zIC0gYmVzaWRlcyBhY2NlbGVyYXRpb24gLSB0byB1c2UNCj4g
aGFyZHdhcmUNCj4gPiBvZmZsb2FkIHdoaWNoIHdlIG9mdGVuIHVzZSB0byBzZWxsIG91ciBJUC4N
Cj4gPiBCdXQgdGhlIGhvbmVzdCBzdG9yeSB0aGVyZSBpcyB0aGF0IHRoYXQgb25seSB3b3JrcyBv
dXQgZm9yIHNpdHVhdGlvbnMNCj4gPiB3aGVyZSB0aGVyZSdzIGVub3VnaCB3b3JrIHRvIGRvIHRv
IG1ha2UgdGhlIHNvZnR3YXJlIG92ZXJoZWFkIGZvciBhY3R1YWxseQ0KPiA+IHN0YXJ0aW5nIGFu
ZCBtYW5hZ2luZyB0aGF0IHdvcmsgaW5zaWduaWZpY2FudC4NCj4gPg0KPiA+IEFuZCBldmVuIHRo
ZW4sIGl0J3Mgb25seSBhIHZhbGlkIHVzZSBjYXNlIGlmIHRoYXQgaXMgeW91ciAqaW50ZW50aW9u
Ki4NCj4gPiBJZiB5b3UgKmp1c3QqIG5lZWRlZCB0aGUgaGlnaGVzdCBwZXJmb3JtYW5jZSwgeW91
IGRvbid0IHdhbnQgdG8gZ28gdGhyb3VnaA0KPiA+IHRoZSBIVyBpbiB0aGlzIGNhc2UgKHVubGVz
cyB5b3UgaGF2ZSBhICp2ZXJ5KiB3ZWFrIENQVSBwZXJoYXBzLCBvciBhDQo+ID4gaHVnZSBhbW91
bnQgb2YgZGF0YSB0byBwcm9jZXNzIGluIG9uZSBnbykuDQo+ID4NCj4gPiBUaGUgY2F0Y2ggaXMg
aW4gdGhlICJhbHdheXMiLiBCdXQgaG93IGRvIHlvdSBtYWtlIGFuIGluZm9ybWVkIGRlY2lzaW9u
DQo+ID4gaGVyZT8gVGhlIGN1cnJlbnQgQ3J5cHRvIEFQSSBkb2VzIG5vdCByZWFsbHkgc2VlbSB0
byBwcm92aWRlIGEgbWVjaGFuaXNtDQo+ID4gZm9yIGRvaW5nIHNvLiBJbiB3aGljaCBjYXNlIE1Z
IGFwcHJvYWNoIHdvdWxkIGJlICJpZiBJJ20gbm90IFNVUkUgdGhhdA0KPiA+IHRoZSBIVyBjYW4g
ZG8gaXQgYmV0dGVyLCB0aGVuIEkgcHJvYmFibHkgc2hvdWxkbid0IGJlIGRvaW5nIGluIG9uIHRo
ZSBIVyIuDQo+ID4NCj4NCj4gSXQgYmVjb21lcyBldmVuIG1vcmUgY29tcGxpY2F0ZWQgdG8gcmVh
c29uIGFib3V0IGlmIHlvdSB0YWtlIGludG8NCj4gYWNjb3VudCB0aGF0IHlvdSBtYXkgaGF2ZSAx
MHMgb3IgMTAwcyBvZiBpbnN0YW5jZXMgb2YgdGhlIENQVSBjcnlwdG8NCj4gbG9naWMgKG9uZSBm
b3IgZWFjaCBDUFUpIHdoaWxlIHRoZSBudW1iZXIgb2YgaC93IElQIGJsb2NrcyBhbmQvb3INCj4g
cGFyYWxsZWwgcHJvY2Vzc2luZyBxdWV1ZXMgdHlwaWNhbGx5IGRvZXNuJ3Qgc2NhbGUgaW4gdGhl
IHNhbWUgd2F5Lg0KPg0KPiBCdXQgd2UgYXJlIGdvaW5nIGRvd24gYSByYWJiaXQgaG9sZSBoZXJl
OiBldmVuIGlmIHlvdSBhbmQgSSB3b3VsZA0KPiBhZ3JlZSB0aGF0IGl0IG5ldmVyIG1ha2VzIGFu
eSBzZW5zZSB3aGF0c29ldmVyIHRvIHVzZSBoL3cgYWNjZWxlcmF0b3JzDQo+IGZyb20gdXNlcmxh
bmQsIHRoZSByZWFsaXR5IGlzIHRoYXQgdGhpcyBpcyBoYXBwZW5pbmcgdG9kYXksIGFuZCBzbyB3
ZQ0KPiBoYXZlIHRvIGVuc3VyZSB0aGF0IGFsbCBkcml2ZXJzIGV4cG9zZSBhbiBpbnRlcmZhY2Ug
dGhhdCBwcm9kdWNlcyB0aGUNCj4gY29ycmVjdCByZXN1bHQgZm9yIGFsbCBpbWFnaW5hYmxlIGNv
cm5lciBjYXNlcy4NCj4NCj4gPiA+IC0gc2V2ZXJhbCB1c2VybGFuZCBwcm9ncmFtcyBhbmQgaW4t
a2VybmVsIHVzZXJzIG1heSBiZSBhY3RpdmUgYXQgdGhlDQo+ID4gPiBzYW1lIHRpbWUsIHNvIHRo
ZSBmYWN0IHRoYXQgYSBzaW5nbGUgdXNlciBzbGVlcHMgZG9lc24ndCBtZWFuIHRoZQ0KPiA+ID4g
aGFyZHdhcmUgaXMgdXNlZCBpbmVmZmljaWVudGx5DQo+ID4gPg0KPiA+IEknbSBub3Qgd29ycmll
ZCBhYm91dCB0aGUgKkhXKiBiZWluZyB1c2VkIGluZWZmaWNpZW50bHkuDQo+ID4gSSdtIHdvcnJp
ZWQgYWJvdXQgdXNpbmcgdGhlIEhXIG5vdCBiZWluZyBhbiBpbXByb3ZlbWVudC4NCj4gPg0KPg0K
PiBFdmlkZW50bHksIGl0IHJlcXVpcmVzIHNvbWUgY2FyZSB0byB1c2UgdGhlIEFGX0FMRyBpbnRl
cmZhY2UNCj4gbWVhbmluZ2Z1bGx5LiBCdXQgdGhhdCBkb2VzIG5vdCBtZWFuIGl0IGNhbm5vdCBl
dmVyIGJlIHVzZWQgaW4gdGhlDQo+IHJpZ2h0IHdheS4NCj4NCkkgdGhpbmsgd2UgYWdyZWUgb24g
dGhlIGJpZyBwaWN0dXJlLg0KQXMgSSBhbHJlYWR5IGFyZ3VlZCBpbiBhIGRpZmZlcmVudCB0aHJl
YWQsIHRoZSBiZXN0IGFwcHJvYWNoIGlzIHByb2JhYmx5DQp0byBub3Qgc2VsZWN0IHRoZSBoYXJk
d2FyZSBieSBkZWZhdWx0IGF0IGFsbCwgYnV0IG1ha2UgaXQgYW4gZXhwbGljaXQNCmNob2ljZS4N
Cg0KSSBzdXBwb3NlIHRoYXQgY291bGQgYmUgYWNoaWV2ZWQgd2l0aGluIHRoZSBjdXJyZW50IGZy
YW1ld29yayBieSBqdXN0DQpnaXZpbmcgYWxsIGhhcmR3YXJlIGRyaXZlcnMgYSBsb3cgY3JhX3By
aW9yaXR5IGZpZ3VyZS4NCg0KVGhpbmcgaXMsIHRoYXQgcmVxdWlyZXMgcHJvdmlkaW5nIHNvbWUg
Y29uZmlkZW5jZSB0byBoYXJkd2FyZSB2ZW5kb3JzDQp0aGF0IEFMTCBjcnlwdG8gY29uc3VtZXJz
IHdpbGwgaW5kZWVkIHByb3ZpZGUgc29tZSBjb25maWd1cmF0aW9uIG9wdGlvbg0KdG8gc2VsZWN0
IHRoZSBkcml2ZXIgZXhwbGljaXRseS4NCg0KSW4gd2hpY2ggY2FzZSBoYXJkd2FyZSB2ZW5kb3Jz
IGNvdWxkIHNpbXBseSByZWNvbW1lbmQgdXNpbmcgdGhlaXIgZHJpdmVyDQpmb3IgY2VydGFpbiBh
cHBsaWNhdGlvbnMgdGhhdCBoYXZlIGJlZW4gdGVzdGVkIGFuZCBrbm93biB0byBiZSB1c2VmdWxs
eQ0KYWNjZWxlcmF0ZWQgKG9yIGFjaGlldmUgbG93ZXIgcG93ZXIgY29uc3VtcHRpb24gb3IgbG93
ZXIgQ1BVIGxvYWQsDQp3aGF0ZXZlciBpcyB5b3VyIHNwZWNpZmljIHJlcXVpcmVtZW50KS4gT3Ig
dG8gTk9UIHVzZSB0aGVpciBkcml2ZXJzIGZvcg0KY2VydGFpbiBhcHBsaWNhdGlvbnMgdGhhdCBk
b24ndCBiZW5lZml0Lg0KDQpBbm90aGVyIHBzeWNob2xvZ2ljYWwgYmFycmllciwgdGhvdWdoLCBp
cyB0aGF0IGNyYV9wcmlvcml0eSBjYW4gYmUNCnBlcmNlaXZlZCAgYXMgc29tZSBpbmRpY2F0aW9u
IG9mIGhvdyAiZ29vZCIgdGhlIGhhcmR3YXJlIGlzLiBBbmQgb2J2aW91c2x5DQpubyBoYXJkd2Fy
ZSB2ZW5kb3Igd291bGQgd2FudCB0byBtYWtlIGhpcy9oZXIgaGFyZHdhcmUgbG9vayB3b3JzZSB0
aGFuDQp0aGUgY29tcGV0aW9uLiBPciB3b3JzZSB0aGFuIHNvZnR3YXJlIGltcGxlbWVudGF0aW9u
cyBmb3IgdGhhdCBtYXR0ZXIuDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGlj
b24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgSW5zaWRlIFNlY3VyZQ0K
d3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
