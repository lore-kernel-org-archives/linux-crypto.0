Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D73C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 20:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89EF5207FC
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 20:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Uu+yUQvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392691AbfIFUSp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 16:18:45 -0400
Received: from mail-eopbgr750078.outbound.protection.outlook.com ([40.107.75.78]:13958
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392658AbfIFUSp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 16:18:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAB4hIScEI5YVAIBZnNby/l8g2mkUYEX7vr2N6GXD7y8GH+fS31yJINXu0TxNHWnsbfBmSaKd96C0EvjSTqTxoUEh2/lHq79ELelqkERcSl9eEuvnU8KC1tGae4De2zylpt680H75fz/N8dx0gNqyPYfCLgqqz7abu9+PKIeqvw6BOD6/03Qzh1UESO7+Bo78P3xAq/259caiWu3MkBjZIJh2fkH+1lfkMQ66NS+wVHr1JPepmgXE5wLbSOObUD0HAzKN/6/kkOBDfz/tZC16ejUXF6VJYpJXKpcTeoEFbfG+2Ie8ofp8IR/xfOBHqOMA0SgQEt9n0pfdnMeuAHICg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od7Nt/umOR8rhh+aqRVgwkURU5OTvBpYQLRVO6wpbSM=;
 b=Hpf37S7thO9qQDVDkl8iC2/70mFqIpiUna/TznnJP0oBVDVwoo8nbENGwrc/tVT6DIK2TssL6qFi0/7r+7R1NlGa8Etg28KWmhNzEQq6WHbqq7xRKRf+B0dLCt8QD3KjHYOg8kSxsH7on/TjzmBtIICin3Q2hRFjpFTO2Fl7UCVcrGXH1352IkNQBgRO9HC4l7LogviwTiiKCEZg/RcTNzEc9dsudpABcyNL5n5igJyJW3+m/9/IGNAX0aB/JBdseZFiY2DwHUb8YWrp+SlJLapOnJIrKW+OuFASLwl2Uc/Zl5MPUulnvUPtNi++Gy1CZg9849vzeiAVRg61RPzg/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od7Nt/umOR8rhh+aqRVgwkURU5OTvBpYQLRVO6wpbSM=;
 b=Uu+yUQvUvT7kXoombtf0BdP1ij2lY8/yifXagoH7R1qFvfHavefAS10qJyNIlmAcv7Uxvdwge10/FZirTQRhnRZzaS/Z28qzN6xwURrltJ9Ys5r/zVgE0BEFtn6Gy1D7xDflOYLBJ+hXSkeZqUrzv1EhL/W1R1oMPWTNw14p+y0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2911.namprd20.prod.outlook.com (10.255.7.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 6 Sep 2019 20:18:41 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 20:18:41 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable
 warning
Thread-Topic: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable
 warning
Thread-Index: AQHVZMb9qMxHnA67BkKvoz9dTWlgFKcez7HQgAArtYCAABrUIA==
Date:   Fri, 6 Sep 2019 20:18:41 +0000
Message-ID: <MN2PR20MB29731C08A41B4018E9C2146FCABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190906152250.1450649-1-arnd@arndb.de>
 <MN2PR20MB297378A683764AF4F2171B7CCABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAK8P3a13Ebqd51SWx9svUyvFxV4MKDJKOwKEozzKyga9azBqJA@mail.gmail.com>
In-Reply-To: <CAK8P3a13Ebqd51SWx9svUyvFxV4MKDJKOwKEozzKyga9azBqJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ece8be5-5521-4a3f-83af-08d7330768ef
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2911;
x-ms-traffictypediagnostic: MN2PR20MB2911:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2911D894D587E3AC1BA2E4CFCABA0@MN2PR20MB2911.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39850400004)(366004)(396003)(43544003)(189003)(199004)(13464003)(8676002)(25786009)(26005)(6916009)(71190400001)(71200400001)(256004)(14444005)(8936002)(6116002)(3846002)(66066001)(81166006)(15974865002)(81156014)(229853002)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(52536014)(5660300002)(4326008)(14454004)(186003)(54906003)(33656002)(7696005)(76176011)(76116006)(74316002)(316002)(305945005)(2906002)(7736002)(86362001)(11346002)(6246003)(102836004)(6436002)(476003)(55016002)(9686003)(446003)(486006)(99286004)(53936002)(53546011)(6506007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2911;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jQEUkoSxdgW/LVMYmCVTOpvqVFXmM0tIIQiEAJKPdO3SuWDhVlahLxSMKPMd6f8pCagShrBtfrjnNYYnWscLQfDB0ykg9VMiFheVYNSWLdwi9naDnQvKlx2MTA5Hski7s6XGQm6JaSHVSCUVNEKApEP/pyrNNQ9UOaWddcwpxjaxICt5KfjrpVkNvy0AjKBH3i4KhDrcwxvVj7hNjzDlan6htNiIV38D92rNgsZ5WFOdUs4F82uatzQ4WH8S2gx1SmrVc1t5P1GUzwnSZHpAd8JzE+15XsADLXSPSsEAJ0HJKiNdtopd0k1a95VJ2HrlNPQXtHcDJTOYCC7UT2GaRqVg84e/qM8/uFKxP6A6kBZ5WcK6/xBsstGOcYfv7otOOO7p2e7KhAVIbNGG0Ze/OHDtN2aNIBbo6PLSsJx1gUU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ece8be5-5521-4a3f-83af-08d7330768ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 20:18:41.3260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eC+dG5/76t5PAICUwWO1ig1km5t4tuuEjasqnqr9SR4Q0FynOlpAVAn0yD8hLr7mLQVP1a4FLmkH+vWYJXZIIt7tMygXA1ENG/gP+GSbcCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2911
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPg0KPiBTZW50OiBGcmlkYXksIFNlcHRlbWJlciA2LCAyMDE5IDg6NDAgUE0NCj4g
VG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+DQo+IENj
OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBEYXZpZCBTLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBBbnRvaW5lDQo+IFRlbmFydCA8YW50b2luZS50ZW5h
cnRAYm9vdGxpbi5jb20+OyBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9y
Zz47IEtlZXMgQ29vaw0KPiA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPjsgbGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIDEvMl0gY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0gZml4IHVuaW5pdGlhbGl6ZWQt
dmFyaWFibGUgd2FybmluZw0KPiANCj4gT24gRnJpLCBTZXAgNiwgMjAxOSBhdCA2OjA4IFBNIFBh
c2NhbCBWYW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+IHdyb3RlOg0K
PiANCj4gPiA+DQo+ID4gPiAgY29uZmlnIENSWVBUT19ERVZfU0FGRVhDRUwNCj4gPiA+ICAgICAg
IHRyaXN0YXRlICJJbnNpZGUgU2VjdXJlJ3MgU2FmZVhjZWwgY3J5cHRvZ3JhcGhpYyBlbmdpbmUg
ZHJpdmVyIg0KPiA+ID4gLSAgICAgZGVwZW5kcyBvbiBPRiB8fCBQQ0kgfHwgQ09NUElMRV9URVNU
DQo+ID4gPiArICAgICBkZXBlbmRzIG9uIE9GIHx8IFBDSQ0KPiA+ID4NCj4gPg0KPiA+IFRoaXMg
c2VlbXMgbGlrZSBpdCBqdXN0IGlnbm9yZXMgdGhlIHByb2JsZW0gYnkgbm90IGFsbG93aW5nIGNv
bXBpbGUgdGVzdGluZw0KPiA+IGFueW1vcmU/IFNvbWVob3cgdGhhdCBkb2VzIG5vdCBmZWVsIHJp
Z2h0IC4uLg0KPiANCj4gTm8sIGl0IGp1c3QgaWdub3JlcyB0aGUgdW5pbnRlcmVzdGluZyBjYXNl
LiBZb3UgY2FuIGNvbXBpbGUtdGVzdCB0aGlzIG9uDQo+IGFueSBhcmNoaXRlY3R1cmUgYnkgdHVy
bmluZyBvbiBPRi4NCj4gDQpZb3UgYXJlIGVudGlyZWx5IGNvcnJlY3QuIEJlY2F1c2Ugb2YgdGhl
IENPTVBJTEVfVEVTVCBpdCBjb3VsZCBiZSBjb21waWxlZA0Kd2l0aG91dCBlaXRoZXIgT0Ygb3Ig
UENJIHN1cHBvcnQsIHdoaWNoIG1ha2VzIG5vIHNlbnNlIHdoYXRzb2V2ZXIgLi4uDQoNCj4gPiA+
ICAgICAgIHNlbGVjdCBDUllQVE9fTElCX0FFUw0KPiA+ID4gICAgICAgc2VsZWN0IENSWVBUT19B
VVRIRU5DDQo+ID4gPiAgICAgICBzZWxlY3QgQ1JZUFRPX0JMS0NJUEhFUg0KPiA+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWwuYyBiL2RyaXZlcnMv
Y3J5cHRvL2luc2lkZS0NCj4gPiA+IHNlY3VyZS9zYWZleGNlbC5jDQo+ID4gPiBpbmRleCBlMTJh
MmEzYTU0MjIuLjljMGJjZTc3ZGUxNCAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvY3J5cHRv
L2luc2lkZS1zZWN1cmUvc2FmZXhjZWwuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9jcnlwdG8vaW5z
aWRlLXNlY3VyZS9zYWZleGNlbC5jDQo+ID4gPiBAQCAtOTM4LDYgKzkzOCw3IEBAIHN0YXRpYyBp
bnQgc2FmZXhjZWxfcmVxdWVzdF9yaW5nX2lycSh2b2lkICpwZGV2LCBpbnQgaXJxaWQsDQo+ID4g
PiAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXY7DQo+ID4gPg0KPiA+ID4gICAgICAgaWYgKElTX0VO
QUJMRUQoQ09ORklHX1BDSSkgJiYgaXNfcGNpX2Rldikgew0KPiA+ID4gKyNpZmRlZiBDT05GSUdf
UENJDQo+ID4gPg0KPiA+DQo+ID4gVGhlIHdob2xlIHBvaW50IHdhcyBOT1QgdG8gdXNlIHJlZ3Vs
YXIgI2lmZGVmcyBzdWNoIHRoYXQgdGhlIGNvZGUgY2FuDQo+ID4gYmUgY29tcGlsZSB0ZXN0ZWQg
d2l0aG91dCBuZWVkaW5nIHRvIHN3aXRjaCBjb25maWd1cmF0aW9ucy4NCj4gPiBUaGVyZSBpcyBh
bHJlYWR5IGEgZGlmZmVyZW50IHNvbHV0aW9uIGluIHRoZSB3b3JrcyBpbnZvbHZpbmcgc29tZSBl
bXB0eQ0KPiA+IGlubGluZSBzdHVicyBmb3IgdGhvc2UgcGNpIHJvdXRpbmVzLCBwbGVhc2Ugc2Vl
IGFuIGVhcmxpZXIgbWFpbCBieSBIZXJiZXJ0DQo+ID4gdGl0bGVkICJQQ0k6IEFkZCBzdHViIHBj
aV9pcnFfdmVjdG9yIGFuZCBvdGhlcnMiLg0KPiANCj4gQWgsIGdvb2QuIFRoYXQgc2hvdWxkIHRh
a2UgY2FyZSBvZiBtb3N0IG9mIHRoZSBwcm9ibGVtcy4gSSB0aGluaw0KPiB3ZSBzdGlsbCBuZWVk
IHRoZSBLY29uZmlnIGNoYW5nZSwgdW5sZXNzIHRoZSBzYWZleGNlbF9pbml0KCkNCj4gZnVuY3Rp
b24gaXMgYWxzbyBjaGFuZ2VkIHRvIHVzZSBpZihJU19FTkFCTEVEKCkpIGNoZWNrcw0KPiBpbnN0
ZWFkIG9mICNpZi4NCj4gDQo+ICAgICAgQXJuZA0KPg0KWWVzLCBJIGFncmVlLg0KDQoNClJlZ2Fy
ZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90
b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg0K
