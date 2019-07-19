Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07367C76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9EA821849
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="zeSpG54K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfGSH3b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 03:29:31 -0400
Received: from mail-eopbgr820049.outbound.protection.outlook.com ([40.107.82.49]:64782
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbfGSH3b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 03:29:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/qCm7WyfhzSh99MLeklx9O8Ju4+Bil756yyCsO03Hn9/Z/uA896Qf6xrYqqt0C4SZ89qZ7MzNRDFI8TaLNa1V/ktDizGsRYOsZ/w0obu5O+SXzVvcEzNzUv6iQ4RVrcNWVkBQN/IEIN7tankmH11lw44wMmtKLpuav34fpWRyUNYFT/vV6NRRDcE3acN45pe558Y/vfAWkqHS1XLVbAo6WKn9o8jfAETGnG1gqC/uZVxkpnOplrvqIFbFYHVFChqB2t0zmiIoPdn5BaVPeYmuapvFsCtI6sUzwt/Yiirz3phy2Ah+j8Mw+WBHcIKdbFDcNrcGg+3zw450+68k6B2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09laiAsNxWdxta9Ye84Es9OV+3PTcyV53lcT7e3rkHg=;
 b=JWKj/7/nL5xXZMD9QDBs7pZDxfcZLcIr75V3EGKfyxhm1wGeb/cWRhataIz1ppSHtt89vlqhtyN1me28VeG1IEdPuPU0fIPcZNohSmPRGid8OXktFWzGnyJUkN3C1v5NVL1jCbZJ2HwHfzh4apk6V7l87V6oexos+4zPoEJwOL/eSl6kpANWBnowdfuc4JYwbkis4ZamodNJhFMTfOUj9aDvHXirmIL2a6CX6JQMAlKFhbq4VI+6ajyXTiRLZU9Fh/QY97uziUndm23ynS0v9TdYPAL0Zp3arI63uV21EQONsEtnoP24JF1Mvz1l9Shr2cX4FAkYVXMrTHa3kSgX9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09laiAsNxWdxta9Ye84Es9OV+3PTcyV53lcT7e3rkHg=;
 b=zeSpG54KnRMSiD6BqihVLGLtl+x0Kccd9TgikTuN32b0pAZE1lYHcLGy2RjDSfJ4OgNxVy8QP+r55+oecSrmEEjEaOxmfXQnRm5chyhHnnduxyVsr6kjKSGkfrf4dQMd49Su54zTmZnnqlAWlNf7cmN5oNPpCcbPyLn0sGZJvWw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3149.namprd20.prod.outlook.com (52.132.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 07:29:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 07:29:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: xts fuzz testing and lack of ciphertext stealing support
Thread-Topic: xts fuzz testing and lack of ciphertext stealing support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgABt8gCAAADKkIAABYEAgAAHwACAAAYnsIAA2AKAgAAZT1A=
Date:   Fri, 19 Jul 2019 07:29:25 +0000
Message-ID: <MN2PR20MB297371CEE0F60E58E110C6FDCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
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
 <MN2PR20MB2973DE308D0050DBF3F26870CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8dE6EO1NOwni91cvEWJvPzieC3wKph73j2jWxzx_xKAw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8dE6EO1NOwni91cvEWJvPzieC3wKph73j2jWxzx_xKAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28ce9ef0-63d5-4f4b-cd67-08d70c1ad402
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3149;
x-ms-traffictypediagnostic: MN2PR20MB3149:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3149D1B7C07483BAC9132F77CACB0@MN2PR20MB3149.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39850400004)(136003)(366004)(13464003)(199004)(189003)(81166006)(8936002)(81156014)(25786009)(52536014)(15974865002)(8676002)(76176011)(4326008)(478600001)(6436002)(6246003)(5660300002)(102836004)(107886003)(305945005)(71190400001)(71200400001)(55016002)(316002)(256004)(446003)(99286004)(66946007)(9686003)(53546011)(54906003)(86362001)(229853002)(186003)(3846002)(26005)(53936002)(14454004)(7736002)(476003)(33656002)(11346002)(486006)(6506007)(68736007)(66556008)(76116006)(64756008)(66446008)(66066001)(66476007)(6916009)(6116002)(74316002)(7696005)(2906002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3149;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vIcbcXoVOY0dxj6QWGBsrvSI0CUfaXGjzUl5VT+a1gS+eSwgALs0k//fccQhvY4A1RXJ3wfTQ7dka76EMhtLdco7rKdfdvY9sYHKwDFgazEA4klh1/NfR46w+fTJBsKJO/7riuebiJt/BpHOOfJ9dQwW7i6D+J9FXfV99xb0CPaiRd5uR30ZLIO0UmL8UlmoyyqPF8m2QqDpgOdoBGLT5yX/C5c4SygpyfM/r3MMmwwEhQ/p+MeKwbYyiEckxlaOZjfjIz86BhXqbz1R74URnnRaVHdj4OmqYHrm5H7/MLgaXacBjvXHotOnFe+Fx8/k2tSYuDPZYPddxBhVTmCuF263ere/QLoqvtKdULTVbx11w3pMI7y1vMvZ1+ze1ZltK/b9ubgp8WvmrIAEvlAPWKsRuM0D6lNAPRKxNLFHV3k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ce9ef0-63d5-4f4b-cd67-08d70c1ad402
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 07:29:25.9612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3149
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogRnJpZGF5LCBKdWx5IDE5LCAyMDE5IDc6
MzUgQU0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5j
b20+DQo+IENjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBNaWxh
biBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29tPjsgSG9yaWEgR2VhbnRhIDxob3JpYS5nZWFudGFA
bnhwLmNvbT47IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOyBkbS1kZXZlbEByZWRo
YXQuY29tDQo+IFN1YmplY3Q6IFJlOiB4dHMgZnV6eiB0ZXN0aW5nIGFuZCBsYWNrIG9mIGNpcGhl
cnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KID4gDQo+IEkgd291bGQgYXJndWUgdGhhdCB0aGVzZSBj
YXNlcyBhcmUgZGlhbWV0cmljYWxseSBvcHBvc2l0ZTogeW91DQo+IHByb3Bvc2VkIHRvIHJlbW92
ZSBzdXBwb3J0IGZvciB6ZXJvIGxlbmd0aCBpbnB1dCB2ZWN0b3JzIGZyb20gdGhlDQo+IGVudGly
ZSBjcnlwdG8gQVBJIHRvIHByZXZlbnQgeW91ciBkcml2ZXIgZnJvbSBoYXZpbmcgdG8gZGVhbCB3
aXRoDQo+IGlucHV0cyB0aGF0IHRoZSBoYXJkd2FyZSBjYW5ub3QgaGFuZGxlLg0KPiANCkkgZGlk
IG5vdCBwcm9wb3NlIGFueSBzdWNoIHRoaW5nIC0gSSBqdXN0IHByb3Bvc2VkIHRvIG1ha2UgemVy
byBsZW5ndGggaGFzaCBzdXBwb3J0ICpvcHRpb25hbCoNCihpLmUuIGRvbid0IGZhaWwgYW5kIGRp
c2FibGUgdGhlIGRyaXZlciBvbiBpdCkgYXMgaXQncyB0b3RhbGx5IGlycmVsZXZhbnQgZm9yIDk5
Ljk5OTk5JSBvZiB1c2UgY2FzZXMuDQooaW5jbHVkaW5nICphbGwqIHVzZSBjYXNlcyBJIGNvbnNp
ZGVyIHJlbGV2YW50IGZvciBIVyBhY2NlbGVyYXRpb24pDQoNCj4gSSBhbSBwcm9wb3Npbmcgbm90
IHRvIGFkZCBzdXBwb3J0IGZvciBjYXNlcyB0aGF0IHdlIGhhdmUgbm8gbmVlZCBmb3IuDQo+DQpX
aGlsZSB5b3UgYXJlIHByb3Bvc2luZyB0byBzdGljayB3aXRoIGFuIGltcGxlbWVudGF0aW9uIHRo
YXQgY2FuIG9ubHkgZGVhbCB3aXRoIDYuMjUlICgxLzE2dGgpIG9mIA0KKmxlZ2FsKiBpbnB1dCBk
YXRhIGZvciBYVFMgYW5kIGZhaWxzIG9uIHRoZSByZW1haW5pbmcgOTMuNzUlLiBUaGF0J3MgaGFy
ZGx5IGEgY29ybmVyIGNhc2UgYW55bW9yZS4NCiANCj4gWFRTIHdpdGhvdXQgQ1RTIGlzIGluZGlz
dGluZ3Vpc2hhYmxlIGZyb20gWFRTIHdpdGggQ1RTIGlmIHRoZSBpbnB1dHMNCj4gYXJlIGFsd2F5
cyBhIG11bHRpcGxlIG9mIHRoZSBibG9jayBzaXplLCBhbmQgaW4gMTIgeWVhcnMsIG5vYm9keSBo
YXMNCj4gZXZlciByYWlzZWQgdGhlIGlzc3VlIHRoYXQgb3VyIHN1cHBvcnQgaXMgbGltaXRlZCB0
byB0aGF0LiBTbyB3aGF0DQo+IHByb2JsZW0gYXJlIHdlIGZpeGluZyBieSBjaGFuZ2luZyB0aGlz
PyBkbS1jcnlwdCBkb2VzIG5vdCBjYXJlLA0KPiBmc2NyeXB0IGRvZXMgbm90IGNhcmUsIHVzZXJs
YW5kIGRvZXMgbm90IGNhcmUgKGdpdmVuIHRoYXQgaXQgZG9lcyBub3QNCj4gd29yayB0b2RheSBh
bmQgd2UgYXJlIG9ubHkgZmluZGluZyBvdXQgbm93IGR1ZSB0byBzb21lIGZ1enogdGVzdA0KPiBm
YWlsaW5nIG9uIENBQU0pDQo+IA0KSWYgaXQncyBub3Qgc3VwcG9ydGVkLCB0aGVuIGl0IGNhbm5v
dCBiZSB1c2VkLiBNb3N0IHBlb3BsZSB3b3VsZCBub3Qgc3RhcnQgY29tcGxhaW5pbmcgYWJvdXQg
dGhhdCwgDQp0aGV5IHdvdWxkIGp1c3Qgcm9sbCB0aGVpciBvd24gbG9jYWxseSBvciB0aGV5J2Qg
Z2l2ZSB1cCBhbmQvb3IgdXNlIHNvbWV0aGluZyBlbHNlLiANClNvIHRoZSBmYWN0IHRoYXQgaXQn
cyBjdXJyZW50bHkgbm90IGJlaW5nIHVzZWQgZG9lcyBub3QgbWVhbiBhIHdob2xlIGxvdC4gQWxz
bywgaXQgZG9lcyBub3QgbWVhbiANCnRoYXQgdGhlcmUgd2lsbCBub3QgYmUgYSByZWxldmFudCB1
c2UgY2FzZSB0b21vcnJvdy4gKGFuZCBJIGNhbiBhc3N1cmUgeW91IHRoZXJlICphcmUqIGRlZmlu
aXRlbHkNCnJlYWwtbGlmZSB1c2UgY2FzZXMsIHNvIEkgaGF2ZSB0byBhc3N1bWUgdGhlc2UgYXJl
IGN1cnJlbnRseSBoYW5kbGVkIG91dHNpZGUgb2YgdGhlIGJhc2Uga2VybmVsKQ0KDQpJbiBhbnkg
Y2FzZSwgaWYgeW91IHRyeSB0byB1c2UgWFRTIHlvdSB3b3VsZCAqZXhwZWN0KiBpdCB0byB3b3Jr
IGZvciBhbnkgaW5wdXQgPj0gMTYgYnl0ZXMgYXMgdGhhdCdzDQpob3cgdGhlIGFsZ29yaXRobSBp
cyAqc3BlY2lmaWVkKi4gV2l0aG91dCB0aGUgQ1RTIHBhcnQgaXQncyBzaW1wbHkgbm90IFhUUy4N
Cg0KPiA+IEkgcHJldHR5IG11Y2ggbWFkZSB0aGUgc2FtZSBhcmd1bWVudCBhYm91dCBhbGwgdGhl
c2UgZHJpdmVyIHdvcmthcm91bmRzDQo+ID4gc2xvd2luZyBkb3duIG15IGRyaXZlciBmYXN0IHBh
dGggYnV0IHRoYXQgd2FzIGNvbnNpZGVyZWQgYSBub24taXNzdWUuDQo+ID4NCj4gPiBJbiB0aGlz
IHBhcnRpY3VsYXIgY2FzZSwgaXQgc2hvdWxkIG5vdCBuZWVkIHRvIGJlIG1vcmUgdGhhbjoNCj4g
Pg0KPiA+IGlmICh1bmxpa2VseShzaXplICYgMTUpKSB7DQo+ID4gICB4dHNfd2l0aF9wYXJ0aWFs
X2xhc3RfYmxvY2soKTsNCj4gPiB9IGVsc2Ugew0KPiA+ICAgeHRzX3dpdGhfb25seV9mdWxsX2Js
b2NrcygpOw0KPiA+IH0NCj4gPg0KPiANCj4gT2YgY291cnNlLiBCdXQgd2h5IGFkZCB0aGlzIGF0
IGFsbCBpZiBpdCBpcyBrbm93biB0byBiZSBkZWFkIGNvZGU/DQo+DQpCdXQgdGhhdCdzIGp1c3Qg
YW4gYXNzdW1wdGlvbiBhbmQgYXNzdW1wdGlvbnMgYXJlIHRoZSByb290IG9mIGFsbCBldmlsIDst
KQ0KDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0
LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5j
b20NCg==
