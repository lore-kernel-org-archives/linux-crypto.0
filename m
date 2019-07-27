Return-Path: <SRS0=7d9E=VY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756FFC433FF
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 12:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BEDE2075E
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 12:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="DuImJ75F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfG0M5A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Jul 2019 08:57:00 -0400
Received: from mail-eopbgr700053.outbound.protection.outlook.com ([40.107.70.53]:53176
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728431AbfG0M47 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Jul 2019 08:56:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNa7YUmeHGv6i5BEAD0tvFGQBOTzLgX+8M3UBMTrltppWBztPyUziwnef2EM33q+jb6SPT2YkIV6f0smJuwj+rzoWjH0QgoZ00niuW34bspcdCJlxmtSqfI8R2N/NcLFlAGwsZxd222ERMNcaVDGPELQSvo2O4WNCH7k/OIf7ZKBVLZs+R1iLLfTE2rdwlem+3L1S5MaHxfBWdieGfSkgjZr2V+1ZwZPnql/U24DUJzL/49JA/b0YBqLnmJzt5OV4DMju/6qoH86Uf/dMDvITefl07XMS7AZB4aQviTLMNM/qrPb/lfgqLipkcB6IN25hTv36Z+dlloujkViBFX2aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWnUpRNQkrRE3Dhv5FHFfkuP36NMfhfID4pHOSEMr5I=;
 b=ckPSY+b8zQ3nm6kgdxVdi3+FaricssQDnlTvOZqL04uM0dXkNh0gqD4j76tonZnrpsZClj1Ahx8QyWm/oKkBjgD+mkni9L64tdiO+otvzrryxad9gVEkbub35ftF6rB24vsachx0Yds2TmIgOvSnLNx1rYkADyAx1GdPVsNUt9DmfTF3O6BaqASa9yqTI0IBq+tZ99ecoZZSP4biKLnOq+OBY67LWTbDhKG+zAvvGWzgFCMJgW8b/FyiGzLSSHnTUc3oDpKDxcu9A/BWmpgZg1HuH/HFlHHYLUw4peuJGl4qQsZDNhHMBuN91lg00T/tLpgpnHQ2KiTh30HS15brnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWnUpRNQkrRE3Dhv5FHFfkuP36NMfhfID4pHOSEMr5I=;
 b=DuImJ75F/K+3X6vzTSkUWnsJRk5pqx+FnOVRc8Pl7q7fGBbJzOtnPZI0AfSynHi8MExbziGp4cfHBQ+cLLpiLvDHhYWAfbTppYBpFzBEddgYTT2CWlgtBDCb7X/2cxePo2Y2Ne/AdEqKqi9eWy5NLm0p5z6Ti6JlJl8B/iNFvCw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3150.namprd20.prod.outlook.com (52.132.174.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Sat, 27 Jul 2019 12:56:54 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 12:56:54 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbde3twgACHxQCAAHlQoA==
Date:   Sat, 27 Jul 2019 12:56:54 +0000
Message-ID: <MN2PR20MB2973AA13DA1AF2AF35F27850CAC30@MN2PR20MB2973.namprd20.prod.outlook.com>
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
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
In-Reply-To: <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25694346-7d83-421d-b79f-08d71291e69c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3150;
x-ms-traffictypediagnostic: MN2PR20MB3150:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB31500C6333034428D6AEA886CAC30@MN2PR20MB3150.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(39850400004)(396003)(189003)(199004)(51914003)(13464003)(26005)(6116002)(102836004)(3846002)(68736007)(52536014)(55016002)(9686003)(6306002)(66946007)(76116006)(66476007)(66556008)(64756008)(6506007)(53546011)(66446008)(6246003)(4326008)(33656002)(478600001)(14444005)(14454004)(53936002)(256004)(81166006)(54906003)(76176011)(11346002)(5660300002)(305945005)(71190400001)(71200400001)(8676002)(966005)(446003)(229853002)(2906002)(81156014)(99286004)(316002)(7696005)(25786009)(86362001)(486006)(186003)(74316002)(15974865002)(8936002)(66066001)(7736002)(6916009)(6436002)(476003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3150;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Vac9E0Tw2hbahvcdQunQTG9/AmrT10ZxvS02PrP3tLs6nCuP2TvFZ4aSCO/lNsxRk0cA8/07gjGbzgJ2plvcWDLmHQIoF/udDn7b8UN5jh9ViNyhILXD4s3XTIQHfiBpr5Ma/O9ObZgtXXRgUyP4axQK3etFm5kWuqTcGQF6z+6/DGOum80lcEDVL0joC0Xj8Qq2aJgJsolVVDCvZoNFMEmI8ZaKAuzCN4w9ldV6O6135IBplZY0QG3KOfyDo/6dgEJ7kwGhwD443FJVV+E9s6sIAtu2AzRhw/fZt4Bpc8vN6PAAQv9JTz1JPkpTlH0tL6hvUvbYq19x9MNs+2PKhLI+cMwHMehPIsRdoeViE/Rxi/sejeJ7emOCkwJ2/sCVZtmpJP7v2NHeXGOZ79Xb9s4sxhD4zeXJ/rt/hF3c+d4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25694346-7d83-421d-b79f-08d71291e69c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 12:56:54.2843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3150
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxh
cmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPg0KPiBTZW50OiBTYXR1cmRheSwgSnVseSAyNywgMjAx
OSA3OjM5IEFNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmltYXRy
aXguY29tPg0KPiBDYzogSG9yaWEgR2VhbnRhIDxob3JpYS5nZWFudGFAbnhwLmNvbT47IE1pbGFu
IEJyb3ogPGdtYXp5bGFuZEBnbWFpbC5jb20+OyBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5h
cGFuYS5vcmcuYXU+OyBkbS0NCj4gZGV2ZWxAcmVkaGF0LmNvbTsgbGludXgtY3J5cHRvQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW2RtLWRldmVsXSB4dHMgZnV6eiB0ZXN0aW5nIGFu
ZCBsYWNrIG9mIGNpcGhlcnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KPiANCj4gT24gU2F0LCAyNyBK
dWwgMjAxOSBhdCAwMDo0MywgUGFzY2FsIFZhbiBMZWV1d2VuDQo+IDxwdmFubGVldXdlbkB2ZXJp
bWF0cml4LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4gPiBGcm9tOiBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPg0KPiA+ID4g
U2VudDogRnJpZGF5LCBKdWx5IDI2LCAyMDE5IDk6NTkgUE0NCj4gPiA+IFRvOiBQYXNjYWwgVmFu
IExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPjsgQXJkIEJpZXNoZXV2ZWwgPGFy
ZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+DQo+ID4gPiBDYzogTWlsYW4gQnJveiA8Z21henlsYW5k
QGdtYWlsLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IGRt
LWRldmVsQHJlZGhhdC5jb207IGxpbnV4LQ0KPiA+ID4gY3J5cHRvQHZnZXIua2VybmVsLm9yZw0K
PiA+ID4gU3ViamVjdDogUmU6IFtkbS1kZXZlbF0geHRzIGZ1enogdGVzdGluZyBhbmQgbGFjayBv
ZiBjaXBoZXJ0ZXh0IHN0ZWFsaW5nIHN1cHBvcnQNCj4gPiA+DQo+ID4gPiBPbiA3LzI2LzIwMTkg
MTozMSBQTSwgUGFzY2FsIFZhbiBMZWV1d2VuIHdyb3RlOg0KPiA+ID4gPiBPaywgZmluZCBiZWxv
dyBhIHBhdGNoIGZpbGUgdGhhdCBhZGRzIHlvdXIgdmVjdG9ycyBmcm9tIHRoZSBzcGVjaWZpY2F0
aW9uDQo+ID4gPiA+IHBsdXMgbXkgc2V0IG9mIGFkZGl0aW9uYWwgdmVjdG9ycyBjb3ZlcmluZyBh
bGwgQ1RTIGFsaWdubWVudHMgY29tYmluZWQNCj4gPiA+ID4gd2l0aCB0aGUgYmxvY2sgc2l6ZXMg
eW91IGRlc2lyZWQuIFBsZWFzZSBub3RlIHRob3VnaCB0aGF0IHRoZXNlIHZlY3RvcnMNCj4gPiA+
ID4gYXJlIGZyb20gb3VyIGluLWhvdXNlIGhvbWUtZ3Jvd24gbW9kZWwgc28gbm8gd2FycmFudGll
cy4NCj4gPiA+IEkndmUgY2hlY2tlZCB0aGUgdGVzdCB2ZWN0b3JzIGFnYWluc3QgY2FhbSAoSFcg
KyBkcml2ZXIpLg0KPiA+ID4NCj4gPiA+IFRlc3QgdmVjdG9ycyBmcm9tIElFRUUgMTYxOS0yMDA3
IChpLmUuIHVwIHRvIGFuZCBpbmNsdWRpbmcgIlhUUy1BRVMgMTgiKQ0KPiA+ID4gYXJlIGZpbmUu
DQo+ID4gPg0KPiA+ID4gY2FhbSBjb21wbGFpbnMgd2hlbiAvKiBBZGRpdGlvbmFsIHZlY3RvcnMg
dG8gaW5jcmVhc2UgQ1RTIGNvdmVyYWdlICovDQo+ID4gPiBzZWN0aW9uIHN0YXJ0czoNCj4gPiA+
IGFsZzogc2tjaXBoZXI6IHh0cy1hZXMtY2FhbSBlbmNyeXB0aW9uIHRlc3QgZmFpbGVkICh3cm9u
ZyByZXN1bHQpIG9uIHRlc3QgdmVjdG9yIDksIGNmZz0iaW4tcGxhY2UiDQo+ID4gPg0KPiA+ID4g
KFVuZm9ydHVuYXRlbHkgaXQgc2VlbXMgdGhhdCB0ZXN0bWdyIGxvc3QgdGhlIGNhcGFiaWxpdHkg
b2YgZHVtcGluZw0KPiA+ID4gdGhlIGluY29ycmVjdCBvdXRwdXQuKQ0KPiA+ID4NCj4gPiA+IElN
TyB3ZSBjYW4ndCByZWx5IG9uIHRlc3QgdmVjdG9ycyBpZiB0aGV5IGFyZSBub3QgdGFrZW4NCj4g
PiA+IHN0cmFpZ2h0IG91dCBvZiBhIHNwZWMsIG9yIGNyb3NzLWNoZWNrZWQgd2l0aCBvdGhlciBp
bXBsZW1lbnRhdGlvbnMuDQo+ID4gPg0KPiA+DQo+ID4gRmlyc3Qgb2ZmLCBJIGZ1bGx5IGFncmVl
IHdpdGggeW91ciBzdGF0ZW1lbnQsIHdoaWNoIGlzIHdoeSBJIGRpZCBub3QgcG9zdCB0aGlzIGFz
IGEgc3RyYWlnaHQNCj4gPiBwYXRjaC4gVGhlIHByb2JsZW0gaXMgdGhhdCBzcGVjaWZpY2F0aW9u
IHZlY3RvcnMgdXN1YWxseSAob3IgYWN0dWFjbGx5LCBhbHdheXMpIGRvbid0IGNvdmVyDQo+ID4g
YWxsIHRoZSByZWxldmFudCBjb3JuZXIgY2FzZXMgbmVlZGVkIGZvciB2ZXJpZmljYXRpb24uIEFu
ZCAicmVmZXJlbmNlIiBpbXBsZW1lbnRhdGlvbnMNCj4gPiBieSBhY2FkZW1pY3MgYXJlIHVzdWFs
bHkgc2hhZHkgYXQgYmVzdCBhcyB3ZWxsLg0KPiA+DQo+ID4gSW4gdGhpcyBwYXJ0aWN1bGFyIGNh
c2UsIHRoZSByZWZlcmVuY2UgdmVjdG9ycyBvbmx5IGNvdmVyIDUgb3V0IG9mIDE2IHBvc3NpYmxl
IGFsaWdubWVudA0KPiA+IGNhc2VzIGFuZCB0aGUgY3VycmVudCBzaXR1YXRpb24gcHJvdmVzIHRo
YXQgdGhpcyBpcyBub3Qgc3VmZmljaWVudC4gQXMgd2UgaGF2ZSAyIGltcGxlLQ0KPiA+IG1lbnRh
dGlvbnMgKG9yIGFjdHVhbGx5IG1vcmUsIGlmIHlvdSBjb3VudCB0aGUgbW9kZWxzIHVzZWQgZm9y
IHZlY3RvciBnZW5lcmF0aW9uKQ0KPiA+IHRoYXQgYXJlIGNvbnNpZGVyZWQgdG8gYmUgY29ycmVj
dCB0aGF0IGRpc2FncmVlIG9uIHJlc3VsdHMuDQo+ID4NCj4gPiBXaGljaCBpcyB2ZXJ5IGludGVy
ZXN0aW5nLCBiZWNhdXNlIHdoaWNoIG9uZSBpcyBjb3JyZWN0PyBJIGtub3cgdGhhdCBvdXIgbW9k
ZWwgYW5kDQo+ID4gaGFyZHdhcmUgaW1wbGVtZW50YXRpb24gd2VyZSBpbmRlcGVuZGVudGx5IGRl
dmVsb3BlZCAoYnkgMiBkaWZmZXJlbnQgZW5naW5lZXJzKQ0KPiA+IGZyb20gdGhlIElFRUUgc3Bl
YyBhbmQgbWF0Y2ggb24gcmVzdWx0cy4gQW5kIG91ciBoYXJkd2FyZSBoYXMgYmVlbiB1c2VkICJv
dXQgaW4NCj4gPiB0aGUgZmllbGQiIGZvciBtYW55IHllYXJzIGFscmVhZHkgaW4gZGlzayBjb250
cm9sbGVycyBmcm9tIG1ham9yIHNpbGljb24gdmVuZG9ycy4NCj4gPiBCdXQgdGhhdCdzIHN0aWxs
IG5vdCBhIGd1YXJhbnRlZSAuLi4uIFNvIGhvdyBkbyB3ZSByZXNvbHZlIHRoaXM/IE1ham9yaXR5
IHZvdGU/IDstKQ0KPiA+DQo+IA0KPiBUaGFua3MgZm9yIHRoZSBhZGRpdGlvbmFsIHRlc3QgdmVj
dG9ycy4gVGhleSB3b3JrIGZpbmUgd2l0aCBteSBTSU1EDQo+IGltcGxlbWVudGF0aW9ucyBmb3Ig
QVJNIFswXSwgc28gdGhpcyBsb29rcyBsaWtlIGl0IG1pZ2h0IGJlIGEgQ0FBTQ0KPiBwcm9ibGVt
LCBub3QgYSBwcm9ibGVtIHdpdGggdGhlIHRlc3QgdmVjdG9ycy4NCj4gDQpUaGFua3MgZm9yIHRo
ZSBoZWFkcyB1cCEgQXMgdGhlIGVuZ2luZWVyIGFjdHVhbGx5IHJlc3BvbnNpYmxlIGZvciBvdXIg
aGFyZHdhcmUNCmltcGxlbWVudGF0aW9uLCBJIGNhbiBub3cgc2xlZXAgYXQgbmlnaHQgYWdhaW4g
Oi0pDQoNCk5vdCB0aGF0IEkgd2FzIHRvbyB3b3JyaWVkIC0gdGhlIGRlc2lnbiBoYXMgYmVlbiBp
biBhY3RpdmUgdXNlIGZvciBuZWFybHkgMTIgeWVhcnMNCmFscmVhZHkgd2l0aG91dCBhbnkga25v
d24gaXNzdWVzLCBidXQgc3RpbGwgLi4uDQoNCj4gSSB3aWxsIHRyeSB0byBmaW5kIHNvbWUgdGlt
ZSB0b2RheSB0byBydW4gdGhlbSB0aHJvdWdoIE9wZW5TU0wgdG8gZG91YmxlIGNoZWNrLg0KPiAN
Cj4gDQo+IFswXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9hcmRiL2xpbnV4LmdpdC9jb21taXQvP2g9eHRzLWN0cw0KDQpSZWdhcmRzLA0KUGFzY2FsIHZh
biBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBA
IFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
