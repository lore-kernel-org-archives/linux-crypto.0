Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A919C76188
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 09:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B444A2199C
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 09:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="tgap3fLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfGVJoz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 05:44:55 -0400
Received: from mail-eopbgr800045.outbound.protection.outlook.com ([40.107.80.45]:20256
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729122AbfGVJom (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 05:44:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWEmjh+V/woQ7/0iGjgOEwYJ4Y/hGcds1ajFNrAuTVlEje1nfmbkv+5TSb1ieLbVqfYNlqH9My1UO3VwxHNek3cNdUbA/dSxaoZ0KTVb32wrzL5OGFeCL8h+PCuE6hHJc26bXPtGbUq1HFO1+3DSNakk4P58TccVJc8/csv73oncuOOPkZMp46GocRdkAjEvaIkAqqnyANPozjh+q+zdqci3G6rn1jX0QyZXb+cvdpDVoHEn3MKdKVeiMCEuNY3TLueyM5fIrev8KxaU1+COTKiJ3p1sMIz/FNSmLIbyXzb69xbSEgwGI8itfRk1wJ53pndx0ovQ01Rr1DMh4Pd6rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qWkqzaPH7zVRDPXKLBi9IM/BAV2HugtDBO6E8p4EJE=;
 b=Vzy9WYT7FBqxpbtHeuSQ95TPFLpL9/gtYIQ1HhTeD3mZuCGUFTGmjrguQCwxylOWWUcVMx9+uf6j+cr5zfjwld6inl71VSNxXep/7a9DmMK9BzKjB4GvG4D2hF4vr9mNjdnEyaE3g/WOOlQgKzXwaWngyLKf+y1TuvlOuFetpW+/BHs09ojeeyEdXdqs5kAS5qTuNfGu+5+axuvizOKGkf3MunFvelNNL9eirxyRVfuDyR9ldzSHVN7GX0EaX6yUf6QiDUJ/rFjT+kIsZi1EYFl9YulnqHaTriFaIN1gjRTpr1D10tWsWniismbe3loBWNB44v5m1FycMzcrKjeP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qWkqzaPH7zVRDPXKLBi9IM/BAV2HugtDBO6E8p4EJE=;
 b=tgap3fLMDxz6uwbpyltwhBN3mxTvWcmxH7iaT9K0a/NrssE5Lnl2O6oFUi/h2iMJwdAZNq1wRNeCTIju7pHmHScVE32kiiijjZN5y3yi+T14tX9H8ydeQXET3vs86cSDyx2QjuUum0CquKRinolQFT6+r5Z1Jld2WMHXzT36YvI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2768.namprd20.prod.outlook.com (20.178.253.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 09:44:40 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 09:44:40 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Milan Broz <gmazyland@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgAAoQICAAtuUgIAACm4AgAG39ACAAYCLgA==
Date:   Mon, 22 Jul 2019 09:44:39 +0000
Message-ID: <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
 <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
 <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ec2de08-4292-43d4-df45-08d70e893780
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2768;
x-ms-traffictypediagnostic: MN2PR20MB2768:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB276803A761AB71175319C86CCAC40@MN2PR20MB2768.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(39850400004)(136003)(189003)(199004)(13464003)(14454004)(305945005)(81166006)(15974865002)(7696005)(26005)(99286004)(5660300002)(6246003)(53936002)(446003)(68736007)(7736002)(11346002)(2906002)(3846002)(6116002)(81156014)(55016002)(86362001)(8936002)(9686003)(76176011)(66066001)(66446008)(64756008)(110136005)(256004)(14444005)(6436002)(102836004)(25786009)(316002)(33656002)(71190400001)(71200400001)(4326008)(66476007)(476003)(76116006)(66946007)(66556008)(74316002)(186003)(478600001)(54906003)(52536014)(486006)(8676002)(229853002)(53546011)(6506007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2768;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cuyGhPaVRMaUcdTEBeSocQcnKXM3VKYQAVlL70/aeGirhDYGBtqVJLXQ5qQsMlj7DCnas30Z2hjAaG7A9utkp25HuWzPUr8bZ8S6rg4vW6RzzMw/t1JE9d18CRsZ8ZzB4l+5l1+yvl8ZFIUu6y8KTrBxxr5XF/xq+5XTdFMf0mfPpLNLRF/oWqOZZRDddIvrYrUm9LbDd5B6zIFS4ajdRNEPKrcCCD99tLUdEnRdigFAHQFuAD9nOuOCY7A4Im7DyGV8onjnbkHulsSecNWpUmwORWbcK20ne/y2KFKRbDw6sz678NfDMw+hogZ+1ntLpxB7T+pXGO3DJgZZI0+XrchlMSCy5d2Z5R8nOOoBTUR2Y+iMmfQItV6iSFUr2+/hJrRluf86BjNgfFM5SMwtdS7/eHAbws0faw3Fek3EoE4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec2de08-4292-43d4-df45-08d70e893780
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 09:44:39.9026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2768
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogU3VuZGF5LCBKdWx5IDIxLCAyMDE5IDEx
OjUwIEFNDQo+IFRvOiBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29tPg0KPiBDYzogUGFz
Y2FsIFZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT47IEhlcmJlcnQgWHUg
PGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IGRtLWRldmVsQHJlZGhhdC5jb207IGxpbnV4
LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOyBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBu
eHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW2RtLWRldmVsXSB4dHMgZnV6eiB0ZXN0aW5nIGFuZCBs
YWNrIG9mIGNpcGhlcnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KPiANCj4gT24gU2F0LCAyMCBKdWwg
MjAxOSBhdCAxMDozNSwgTWlsYW4gQnJveiA8Z21henlsYW5kQGdtYWlsLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPiBPbiAyMC8wNy8yMDE5IDA4OjU4LCBFcmljIEJpZ2dlcnMgd3JvdGU6DQo+ID4gPiBP
biBUaHUsIEp1bCAxOCwgMjAxOSBhdCAwMToxOTo0MVBNICswMjAwLCBNaWxhbiBCcm96IHdyb3Rl
Og0KPiA+ID4+IEFsc28sIEkgd291bGQgbGlrZSB0byBhdm9pZCBhbm90aGVyICJqdXN0IGJlY2F1
c2UgaXQgaXMgbmljZXIiIG1vZHVsZSBkZXBlbmRlbmNlIChYVFMtPlhFWC0+RUNCKS4NCj4gPiA+
PiBMYXN0IHRpbWUgKHdoZW4gWFRTIHdhcyByZWltcGxlbWVudGVkIHVzaW5nIEVDQikgd2UgaGF2
ZSBtYW55IHJlcG9ydHMgd2l0aCBpbml0cmFtZnMNCj4gPiA+PiBtaXNzaW5nIEVDQiBtb2R1bGUg
cHJldmVudGluZyBib290IGZyb20gQUVTLVhUUyBlbmNyeXB0ZWQgcm9vdCBhZnRlciBrZXJuZWwg
dXBncmFkZS4uLg0KPiA+ID4+IEp1c3Qgc2F5aW5nLiAoRGVzcGl0ZSB0aGUgbGFzdCB0aW1lIGl0
IHdhcyBrZXlyaW5nIHdoYXQgYnJva2UgZW5jcnlwdGVkIGJvb3QgOy0pDQo+ID4gPj4NCj4gPiA+
DQo+ID4gPiBDYW4ndCB0aGUgIm1pc3NpbmcgbW9kdWxlcyBpbiBpbml0cmFtZnMiIGlzc3VlIGJl
IHNvbHZlZCBieSB1c2luZyBhDQo+ID4gPiBNT0RVTEVfU09GVERFUCgpPyAgQWN0dWFsbHksIHdo
eSBpc24ndCB0aGF0IGJlaW5nIHVzZWQgZm9yIHh0cyAtPiBlY2IgYWxyZWFkeT8NCj4gPiA+DQo+
ID4gPiAoVGhlcmUgd2FzIGFsc28gYSBidWcgd2hlcmUgQ09ORklHX0NSWVBUT19YVFMgZGlkbid0
IHNlbGVjdCBDT05GSUdfQ1JZUFRPX0VDQiwNCj4gPiA+IGJ1dCB0aGF0IHdhcyBzaW1wbHkgYSBi
dWcsIHdoaWNoIHdhcyBmaXhlZC4pDQo+ID4NCj4gPiBTdXJlLCBhbmQgaXQgaXMgc29sdmVkIG5v
dy4gKFNvbWUgc3lzdGVtcyB3aXRoIGEgaGFyZGNvZGVkIGxpc3Qgb2YgbW9kdWxlcw0KPiA+IGhh
dmUgdG8gYmUgbWFudWFsbHkgdXBkYXRlZCBldGMuLCBidXQgdGhhdCBpcyBqdXN0IGJhZCBkZXNp
Z24pLg0KPiA+IEl0IGNhbiBiZSBkb25lIHByb3Blcmx5IGZyb20gdGhlIGJlZ2lubmluZy4NCj4g
Pg0KPiA+IEkganVzdCB3YW50IHRvIHNheSB0aGF0IHRoYXQgc3dpdGNoaW5nIHRvIFhFWCBsb29r
cyBsaWtlIHdhc3RpbmcgdGltZSB0byBtZQ0KPiA+IGZvciBubyBhZGRpdGlvbmFsIGJlbmVmaXQu
DQo+ID4NCj4gPiBGdWxseSBpbXBsZW1lbnRpbmcgWFRTIGRvZXMgbWFrZSBtdWNoIG1vcmUgc2Vu
c2UgZm9yIG1lLCBldmVuIHRob3VnaCBpdCBpcyBsb25nLXRlcm0NCj4gPiB0aGUgZWZmb3J0IGFu
ZCB0aGUgb25seSB1c2VyLCBmb3Igbm93LCB3b3VsZCBiZSB0ZXN0bWdyLg0KPiA+DQo+ID4gU28s
IHRoZXJlIGFyZSBubyB1c2VycyBiZWNhdXNlIGl0IGRvZXMgbm90IHdvcmsuIEl0IG1ha2VzIG5v
IHNlbnNlDQo+ID4gdG8gaW1wbGVtZW50IGl0LCBiZWNhdXNlIHRoZXJlIGFyZSBubyB1c2Vycy4u
LiAoc29ycnksIHNvdW5kcyBsaWtlIGNhdGNoIDIyIDopDQo+ID4NCj4gPiAoTWF5YmUgc29tZW9u
ZSBjYW4gdXNlIGl0IGZvciBrZXlzbG90IGVuY3J5cHRpb24gZm9yIGtleXMgbm90IGFsaWduZWQg
dG8NCj4gPiBibG9jayBzaXplLCBkdW5uby4gQWN0dWFsbHksIHNvbWUgZmlsZXN5c3RlbSBlbmNy
eXB0aW9uIGNvdWxkIGhhdmUgdXNlIGZvciBpdC4pDQo+ID4NCj4gPiA+IE9yICJ4dHMiIGFuZCAi
eGV4IiBjb3VsZCBnbyBpbiB0aGUgc2FtZSBrZXJuZWwgbW9kdWxlIHh0cy5rbywgd2hpY2ggd291
bGQgbWFrZQ0KPiA+ID4gdGhpcyBhIG5vbi1pc3N1ZS4NCj4gPg0KPiA+IElmIGl0IGlzIG5vdCBh
dmFpbGFibGUgZm9yIHVzZXJzLCBJIHJlYWxseSBzZWUgbm8gcmVhc29uIHRvIGludHJvZHVjZSBY
RVggd2hlbg0KPiA+IGl0IGlzIGp1c3QgWFRTIHdpdGggZnVsbCBibG9ja3MuDQo+ID4NCj4gPiBJ
ZiBpdCBpcyB2aXNpYmxlIHRvIHVzZXJzLCBpdCBuZWVkcyBzb21lIHdvcmsgaW4gdXNlcnNwYWNl
IC0gWEVYIChhcyBYVFMpIG5lZWQgdHdvIGtleXMsDQo+ID4gcGVvcGxlIGFyZSBhbHJlYWR5IGNv
bmZ1c2VkIGVub3VnaCB0aGF0IDI1NmJpdCBrZXkgaW4gQUVTLVhUUyBtZWFucyBBRVMtMTI4Li4u
DQo+ID4gU28gdGhlIGV4YW1wbGVzLCBoaW50cywgbWFuIHBhZ2VzIG5lZWQgdG8gYmUgdXBkYXRl
ZCwgYXQgbGVhc3QuDQo+ID4NCj4gDQo+IE9LLCBjb25zaWRlciBtZSBwZXJzdWFkZWQuIFdlIGFy
ZSBhbHJlYWR5IGV4cG9zaW5nIHh0cyguLi4pIHRvDQo+IHVzZXJsYW5kLCBhbmQgc2luY2Ugd2Ug
YWxyZWFkeSBpbXBsZW1lbnQgYSBwcm9wZXIgc3Vic2V0IG9mIHRydWUgWFRTLA0KPiBpdCB3aWxs
IGJlIHNpbXBseSBhIG1hdHRlciBvZiBtYWtpbmcgc3VyZSB0aGF0IHRoZSBleGlzdGluZyBYVFMN
Cj4gaW1wbGVtZW50YXRpb25zIGRvbid0IHJlZ3Jlc3MgaW4gcGVyZm9ybWFuY2Ugb24gdGhlIG5v
bi1DVFMgY29kZQ0KPiBwYXRocy4NCj4gDQo+IEl0IHdvdWxkIGJlIHVzZWZ1bCwgdGhvdWdoLCB0
byBoYXZlIHNvbWUgZ2VuZXJpYyBoZWxwZXIgZnVuY3Rpb25zLA0KPiBlLmcuLCBsaWtlIHRoZSBv
bmUgd2UgaGF2ZSBmb3IgQ0JDLCBvciB0aGUgb25lIEkgcmVjZW50bHkgcHJvcG9zZWQgZm9yDQo+
IENUUywgc28gdGhhdCBleGlzdGluZyBpbXBsZW1lbnRhdGlvbnMgKHN1Y2ggYXMgdGhlIGJpdCBz
bGljZWQgQUVTKSBjYW4NCj4gZWFzaWx5IGJlIGF1Z21lbnRlZCB3aXRoIGEgQ1RTIGNvZGUgcGF0
aCAoYnV0IHBlcmZvcm1hbmNlIG1heSBub3QgYmUNCj4gb3B0aW1hbCBpbiB0aG9zZSBjYXNlcyku
IEZvciB0aGUgQVJNIGltcGxlbWVudGF0aW9ucyBiYXNlZCBvbiBBRVMNCj4gaW5zdHJ1Y3Rpb25z
LCBpdCBzaG91bGQgYmUgcmVhc29uYWJseSBzdHJhaWdodCBmb3J3YXJkIHRvIGltcGxlbWVudCBp
dA0KPiBjbG9zZSB0byBvcHRpbWFsbHkgYnkgcmV1c2luZyBzb21lIG9mIHRoZSBjb2RlIEkgYWRk
ZWQgZm9yIENCQy1DVFMNCj4gKGJ1dCBJIHdvbid0IGdldCBhcm91bmQgdG8gZG9pbmcgdGhhdCBm
b3IgYSB3aGlsZSkuIElmIHRoZXJlIGFyZSBhbnkNCj4gdm9sdW50ZWVycyBmb3IgbG9va2luZyBp
bnRvIHRoZSBnZW5lcmljIG9yIHg4Ni9BRVMtTkkgaW1wbGVtZW50YXRpb25zLA0KPiBwbGVhc2Ug
Y29tZSBmb3J3YXJkIDotKSBBbHNvLCBpZiBhbnkgb2YgdGhlIHB1YmxpY2F0aW9ucyB0aGF0IHdl
cmUNCj4gcXVvdGVkIGluIHRoaXMgdGhyZWFkIGhhdmUgc3VpdGFibGUgdGVzdCB2ZWN0b3JzLCB0
aGF0IHdvdWxkIGJlIGdvb2QNCj4gdG8ga25vdy4NCg0KVW5mb3J0dW5hdGVseSwgdGhlc2UgYWxn
b3JpdGhtICYgcHJvdG9jb2wgc3BlY2lmaWNhdGlvbnMgdGVuZCB0byBiZSB2ZXJ5IGZydWdhbCB3
aGVuIGl0DQpjb21lcyB0byBwcm92aWRpbmcgdGVzdCB2ZWN0b3JzLCBiYXJlbHkgc2NyYXRjaGlu
ZyB0aGUgc3VyZmFjZSBvZiBhbnkgY29ybmVyIGNhc2VzLCBidXQNCmF0IGxlYXN0IHRoZXJlIGlz
IG9uZSBub24tbXVsdGlwbGUtb2YtMTYgdmVjdG9yIGluIHRoZSBvcmlnaW5hbCBJRUVFIFAxNjE5
IC8gRDE2IA0Kc3BlY2lmaWNhdGlvbiBpbiBBbm5leCBCIFRlc3QgVmVjdG9ycyAobGFzdCB2ZWN0
b3IsICJYVFMtQUVTLTEyOCBhcHBsaWVkIGZvciBhIGRhdGEgdW5pdCANCnRoYXQgaXMgbm90IGEg
bXVsdGlwbGUgb2YgMTYgYnl0ZXMiKQ0KDQpCZXNpZGVzIHRoYXQsIEknZCBiZSBoYXBweSB0byBn
ZW5lcmF0ZSBzb21lIHRlc3R2ZWN0b3JzIGZyb20gb3VyIGRlZmFjdG8tc3RhbmRhcmQNCmltcGxl
bWVudGF0aW9uIDstKQ0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQ
IEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNp
ZGVzZWN1cmUuY29tDQoNCg==
