Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D7CC7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 17:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B3A20651
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 17:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="YDMTC9zQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfGRRDc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 13:03:32 -0400
Received: from mail-eopbgr740044.outbound.protection.outlook.com ([40.107.74.44]:65216
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727730AbfGRRDc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 13:03:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZusYJWORAZ0mOnLAaisJIgGncWpNHLiQZYk+CpzlxzxJ8kfgH0bn3FTFvdpqxTEukkX83gEDnKSlvDHFfsmAiTjM2UiYCOLz3eU0QcMapnWAzETXubOjqdt/yRFOmbqHsdxn+RZ+tB2A0T4j8mxFqHJuSvYuIECozaQOwHqfdkwHfveLy2edraxSEo9IiWlgIJU7T5CeIcEjji+5ZI7elIMoN3giHJLBhwWKBpLz4ixxdsPhwVLJmpjRyv1Qjkg8R+NGSgFFZON3Vaf/x4aJDEtDCS6YwjK1mXHoaaJjhbnp9Io67i7tMlTButrgnll8HHFH/llgG/ERHxFmkYZYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ7r5JBiAvG9h5BixWk434zjjb4qZItGs0MddreTUvk=;
 b=KKsY/JYR6HgiRZiTncihDpTJzbxfi1CuQ+kDRF8mCgI4Tccm9Ug5ShBNIhbb9/aRmNEbwMn9UaQJ15kxCN4acy/hr4NK8IxYPziO5v4/WLkgoJQyLQMBWE9wlNFIbTcoQwGxOYIkHAPDWRckUjWBVopKuA/rOWvpg0Z61KviCeAdEjFdj7jQ/RTRODBwDDIPcYOr9cGbZ2NI2DEZ0XFyrPPXx4xtSKbBTsUiXFURBEIcao3hXsmpkGVD/Xy1nbIn2PUuabVrG396uiFRSLV1IOADNEZtE5gStn1Tk1DyPaIDdwuf3u7RpPBkviRbe9z+W4Iw2iQ9GW3RF3zvFGkeMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ7r5JBiAvG9h5BixWk434zjjb4qZItGs0MddreTUvk=;
 b=YDMTC9zQd/2K/0hNzCDY63u3j68nN1e2/+ZN1+KWC0vqeJZ5+nOHX7c/aKxHWm4UVwIhyQh+bdHSbxSJJo71J4z8VRq7WygtJeEPs4iyngB4Bk5b6F0ASpGYVe+kdApdPVIcNUXut6ciY63iN3fkZhhNd/4GILkggREin4PYdXo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2783.namprd20.prod.outlook.com (20.178.253.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 17:03:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 17:03:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Milan Broz <gmazyland@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: xts fuzz testing and lack of ciphertext stealing support
Thread-Topic: xts fuzz testing and lack of ciphertext stealing support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgABt8gCAAADKkIAABYEAgAAHwACAAAYnsA==
Date:   Thu, 18 Jul 2019 17:03:26 +0000
Message-ID: <MN2PR20MB2973DE308D0050DBF3F26870CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
 <MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
 <CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
In-Reply-To: <CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8aa9f57-3496-49b9-dad7-08d70ba1d9d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2783;
x-ms-traffictypediagnostic: MN2PR20MB2783:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB27837D9B0554290E68BCDA5ACAC80@MN2PR20MB2783.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39850400004)(136003)(366004)(189003)(199004)(53936002)(66066001)(71190400001)(86362001)(486006)(68736007)(71200400001)(6436002)(6506007)(15974865002)(7696005)(102836004)(52536014)(478600001)(76116006)(66556008)(66946007)(64756008)(66476007)(9686003)(107886003)(7736002)(4326008)(229853002)(5660300002)(55016002)(6116002)(25786009)(66446008)(316002)(54906003)(6246003)(305945005)(476003)(446003)(8936002)(81156014)(81166006)(11346002)(8676002)(256004)(99286004)(14454004)(2906002)(76176011)(186003)(3846002)(33656002)(26005)(110136005)(74316002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2783;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2M5HmybPp8n4VSpoi4+RAnf0TAQO+1WdyCS8/Ql75cksYG/VwBYPbcU204dfT39+gl2uWrzFggwYyYAtL+1O9R36UR8zDUtP2PN54g3ztwGXnNWuS/2vvy5Qzef4mqfOMQygBBVKrPHH5IoqZApFsD7Qjo/nESyIe4vucpZuLlgAca3iyM2PoOM3tFIfmXAg4M9oP3D/TCnbiR7mDCE7UHEYsQxbjjR5k1FzJhBzXiGGKz8r0GLQk6K73ngVeO/EZJDiBYuLE20OesQ3WfQuo/SosdvJ4Ev4tHQKJeytUNFXMdZdz1JfcDVdDN9VaRWyYZpb6n5qTSHEvXKu0WaQv/Q1B0v3MkTwOHe+EZu7/KOzz8oeHFl0LFgzJmWjIknWAufX4qn6lJ8Zp8sVQEWytmSvOHSu3GwL45UEFyaZBSw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8aa9f57-3496-49b9-dad7-08d70ba1d9d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 17:03:26.6160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2783
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+ID4gRm9yIFhUUywgeW91IGhhdmUgdGhpcyBhZGRpdGlvbmFsIGN1cnZlIGJhbGwgYmVpbmcg
dGhyb3duIGluIGNhbGxlZCB0aGUgInR3ZWFrIi4NCj4gPiA+IEZvciBlbmNyeXB0aW9uLCB0aGUg
dW5kZXJseWluZyAieHRzIiB3b3VsZCBuZWVkIHRvIGJlIGFibGUgdG8gY2hhaW4gdGhlIHR3ZWFr
LA0KPiA+ID4gZnJvbSB3aGF0IEkndmUgc2VlbiBvZiB0aGUgc291cmNlIHRoZSBpbXBsZW1lbnRh
dGlvbiBjYW5ub3QgZG8gdGhhdC4NCj4gPg0KPiA+IFlvdSBzaW1wbHkgdXNlIHRoZSB1bmRlcmx5
aW5nIHh0cyBmb3IgdGhlIGZpcnN0IG4gLSAyIGJsb2NrcyBhbmQNCj4gPiBkbyB0aGUgbGFzdCB0
d28gYnkgaGFuZC4NCj4gPg0KPiANCj4gT0ssIHNvIGl0IGFwcGVhcnMgdGhlIFhUUyBjaXBoZXJ0
ZXh0IHN0ZWFsaW5nIGFsZ29yaXRobSBkb2VzIG5vdA0KPiBpbmNsdWRlIHRoZSBwZWN1bGlhciBy
ZW9yZGVyaW5nIG9mIHRoZSAyIGZpbmFsIGJsb2Nrcywgd2hpY2ggbWVhbnMNCj4gdGhhdCB0aGUg
a2VybmVsJ3MgaW1wbGVtZW50YXRpb24gb2YgWFRTIGFscmVhZHkgY29uZm9ybXMgdG8gdGhlIHNw
ZWMNCj4gZm9yIGlucHV0cyB0aGF0IGFyZSBhIG11bHRpcGxlIG9mIHRoZSBibG9jayBzaXplLg0K
PiANClllcywgZm9yIFhUUyB5b3UgZWZmZWN0aXZlbHkgZG9uJ3QgZG8gQ1RTIGlmIGl0J3MgYSAx
NiBieXRlIG11bHRpcGxlIC4uLg0KDQo+IFRoZSByZWFzb24gSSBhbSBub3QgYSBmYW4gb2YgbWFr
aW5nIGFueSBjaGFuZ2VzIGhlcmUgaXMgdGhhdCB0aGVyZSBhcmUNCj4gbm8gaW4ta2VybmVsIHVz
ZXJzIHRoYXQgcmVxdWlyZSBjaXBoZXJ0ZXh0IHN0ZWFsaW5nIGZvciBYVFMsIG5vciBpcw0KPiBh
bnlvbmUgYXdhcmUgb2YgYW55IHJlYXNvbiB3aHkgd2Ugc2hvdWxkIGJlIGFkZGluZyBpdCB0byB0
aGUgdXNlcmxhbmQNCj4gaW50ZXJmYWNlLiBTbyB3ZSBhcmUgYmFzaWNhbGx5IGFkZGluZyBkZWFk
IGNvZGUgc28gdGhhdCB3ZSBhcmUNCj4gdGhlb3JldGljYWxseSBjb21wbGlhbnQgaW4gYSB3YXkg
dGhhdCB3ZSB3aWxsIG5ldmVyIGV4ZXJjaXNlIGluDQo+IHByYWN0aWNlLg0KPiANCllvdSBrbm93
LCBoYXZpbmcgd29ya2VkIG9uIGFsbCBraW5kcyBvZiB3b3JrYXJvdW5kcyBmb3Igc2lsbHkgaXJy
ZWxldmFudA0KKElNSE8pIGNvcm5lciBjYXNlcyBpbiAgdGhlIGluc2lkZS1zZWN1cmUgaGFyZHdh
cmUgZHJpdmVyIG92ZXIgdGhlIHBhc3QNCm1vbnRocyBqdXN0IHRvIGtlZXAgdGVzdG1nciBoYXBw
eSwgdGhpcyBpcyBraW5kIG9mIGlyb25pYyAuLi4NCg0KQ2lwaGVyIHRleHQgc3RlYWxpbmcgaGFw
cGVucyB0byBiZSBhICptYWpvciogcGFydCBvZiB0aGUgWFRTIHNwZWNpZmljYXRpb24NCihpdCdz
IG5vdCBhY3R1YWxseSBYVFMgd2l0aG91dCB0aGUgQ1RTIHBhcnQhKSwgeWV0IHlvdSBhcmUgc3Vn
Z2VzdGluZyBub3QgDQp0byBpbXBsZW1lbnQgaXQgYmVjYXVzZSAqeW91KiBkb24ndCBoYXZlIG9y
IGtub3cgYSB1c2UgY2FzZSBmb3IgaXQuDQpUaGF0IHNlZW1zIGxpa2UgYSBwcmV0dHkgYmFkIGFy
Z3VtZW50IHRvIG1lLiBJdCdzIG5vdCBzb21lIG1pbm9yIGNvcm5lciANCmNhc2UgdGhhdCdzIG5v
dCBzdXBwb3J0ZWQuVGhlIGltcGxlbWVudGF0aW9uIGlzIGp1c3QgKmluY29tcGxldGUqDQp3aXRo
b3V0IGl0Lg0KDQo+IE5vdGUgdGhhdCBmb3Igc29mdHdhcmUgYWxnb3JpdGhtcyBzdWNoIGFzIHRo
ZSBiaXQgc2xpY2VkIE5FT04NCj4gaW1wbGVtZW50YXRpb24gb2YgQUVTLCB3aGljaCBjYW4gb25s
eSBvcGVyYXRlIG9uIDggQUVTIGJsb2NrcyBhdCBhDQo+IHRpbWUsIGRvaW5nIHRoZSBmaW5hbCAy
IGJsb2NrcyBzZXF1ZW50aWFsbHkgaXMgZ29pbmcgdG8gc2VyaW91c2x5DQo+IGltcGFjdCBwZXJm
b3JtYW5jZS4gVGhpcyBtZWFucyB3aGF0ZXZlciB3cmFwcGVyIHdlIGludmVudCBhcm91bmQgeGV4
KCkNCj4gKG9yIHdoYXRldmVyIHdlIGNhbGwgaXQpIHNob3VsZCBnbyBvdXQgb2YgaXRzIHdheSB0
byBlbnN1cmUgdGhhdCB0aGUNCj4gY29tbW9uLCBub24tQ1RTIGNhc2UgZG9lcyBub3QgcmVncmVz
cyBpbiBwZXJmb3JtYW5jZSwgYW5kIHRoZSBzcGVjaWFsDQo+IGhhbmRsaW5nIGlzIG9ubHkgaW52
b2tlZCB3aGVuIG5lY2Vzc2FyeSAod2hpY2ggd2lsbCBiZSBuZXZlcikuDQo+DQpJIHByZXR0eSBt
dWNoIG1hZGUgdGhlIHNhbWUgYXJndW1lbnQgYWJvdXQgYWxsIHRoZXNlIGRyaXZlciB3b3JrYXJv
dW5kcw0Kc2xvd2luZyBkb3duIG15IGRyaXZlciBmYXN0IHBhdGggYnV0IHRoYXQgd2FzIGNvbnNp
ZGVyZWQgYSBub24taXNzdWUuDQoNCkluIHRoaXMgcGFydGljdWxhciBjYXNlLCBpdCBzaG91bGQg
bm90IG5lZWQgdG8gYmUgbW9yZSB0aGFuOg0KDQppZiAodW5saWtlbHkoc2l6ZSAmIDE1KSkgew0K
ICB4dHNfd2l0aF9wYXJ0aWFsX2xhc3RfYmxvY2soKTsNCn0gZWxzZSB7DQogIHh0c193aXRoX29u
bHlfZnVsbF9ibG9ja3MoKTsNCn0NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2ls
aWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3
d3cuaW5zaWRlc2VjdXJlLmNvbQ0KDQo=
