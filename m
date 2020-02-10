Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1669CC3B185
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 08:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E60208C4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 08:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="WPoSvXOI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgBJIDu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 03:03:50 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:60334 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgBJIDu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 03:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1581321827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHK3lWly4jNRuC3Crnr9bcj2XAAiB0Gt2UJBFK5QWmw=;
        b=WPoSvXOIG6BtlbKM40VB32E3q7nTgc647XL1y6OO/52ZC3GLLPUxghObFK+SJjmh0qr+I6
        cCraxG1ijdUHFBqtpRuh+rCqdKNGcccgQkToafVwk/OKBFD4ruqfSYZxkP1nKiCOLaxiKC
        DEoEeeBXrJtbZA9Y3JvEJlIc8B88nNk=
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-NxjQkI2bPcq93ydaFFmj2Q-1; Mon, 10 Feb 2020 03:03:46 -0500
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com (52.132.97.155) by
 CY4PR0401MB3587.namprd04.prod.outlook.com (52.132.99.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.27; Mon, 10 Feb 2020 08:03:41 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::9486:c6fe:752d:5eda%3]) with mapi id 15.20.2707.028; Mon, 10 Feb 2020
 08:03:41 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Stephan Mueller <smueller@chronox.de>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: RE: Possible issue with new inauthentic AEAD in extended crypto tests
Thread-Topic: Possible issue with new inauthentic AEAD in extended crypto
 tests
Thread-Index: AQHV1Ohtfj6tA7gaZ0uNkoHJDpcQdaf/XTuAgAARvQCAAD8mgIAA510AgAwnTACAAqlrgIAACBWAgABBmICAAArhgIAC2qmAgAGOxNA=
Date:   Mon, 10 Feb 2020 08:03:40 +0000
Message-ID: <CY4PR0401MB3652A1930E7D1CFC921C700FC3190@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <28236835.Fk5ARk2Leh@tauon.chronox.de>
 <CAOtvUMchWrNsvmLJ2D-qiGOAAgbr_yxtt3h81yOHesa7C6ifZQ@mail.gmail.com>
 <6968686.FA8oO0t0Vk@tauon.chronox.de>
 <7f68982502574b03931e7caad965e76f@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <7f68982502574b03931e7caad965e76f@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8af8a60b-2dd8-4353-e604-08d7adffbde8
x-ms-traffictypediagnostic: CY4PR0401MB3587:
x-microsoft-antispam-prvs: <CY4PR0401MB35878E9DDD77727EDD2ED7E1C3190@CY4PR0401MB3587.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39840400004)(396003)(136003)(346002)(366004)(189003)(199004)(64756008)(9686003)(66556008)(6506007)(55016002)(53546011)(66446008)(186003)(76116006)(66946007)(316002)(52536014)(54906003)(66476007)(2906002)(33656002)(5660300002)(71200400001)(81166006)(81156014)(26005)(86362001)(110136005)(478600001)(8676002)(4326008)(8936002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3587;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rK8Ftz7gVvbX4SAXo8m2qlgDTwxxqtgKXjCpCHaahfIAFy5Y18XPfM+DTFxM2gjcPG8WI+UaJWsYAviaNDmjVdWBt9hdgIuTYJg57rC3oAAuAmu57+KFncUwilkfILgrpIGMXxwpH/g9dy1jk/lJF8BYT3s5DCfpkd7mHKnZzbSptGLxw1a5SzDNEXw7mwbvN+jbApVRlRXcGZFKKE8CAukGRWmiE/4OFT9b83ye4LpRUKqCErZUVLsi1HkkjCaUIHJTRqG1KffvkrDpSNDHvmgHXAXq0GPdnqYFUWEo8AxZ4YA/oK8u1PEaF18/LuOh0IMy3UzZbJFI5AdW99PDEWBoUOWDBaXI0eR6pPPFJ0ASbQg+Y9Y0SLN8FA42Ew3+tVN3ZnBBqjpjzUznNAFYdSF1nyMRhf9Inzaqz8LwGwlpeZv0V8MQbUf4gMtH7BY3
x-ms-exchange-antispam-messagedata: QG9Rp8X9jCC/37IM7ypiLlfYtVVptPK8JPfgzj4bj5PmBHOU5MmGO/xx4Yq5zK2r+F8EQvb9kG2dw3L+ypGQcbgSJrDXE+wMxrXXHCh73ov3Ox9zs0DAvDGRNBD2VmfQx6W7rG0UrxA7f21AfF9aWQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af8a60b-2dd8-4353-e604-08d7adffbde8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2020 08:03:40.8878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jpOdvJjxDV1u1b1seiaXBlVXrYMzUdgdnDeZx9UMVj1iNEDov0wLJb3z6ZlQXFOYxL0yyfpIJwlL831CdJt92Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3587
X-MC-Unique: NxjQkI2bPcq93ydaFFmj2Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgR2lsYWQgQmVuLVlvc3NlZg0KPiBTZW50OiBTdW5kYXksIEZlYnJ1YXJ5IDksIDIw
MjAgOTowNSBBTQ0KPiBUbzogU3RlcGhhbiBNdWVsbGVyIDxzbXVlbGxlckBjaHJvbm94LmRlPg0K
PiBDYzogRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwub3JnPjsgSGVyYmVydCBYdSA8aGVy
YmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgTGludXggQ3J5cHRvIE1haWxpbmcgTGlzdCA8bGlu
dXgtDQo+IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+OyBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0
QGxpbnV4LW02OGsub3JnPjsgRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgT2Zp
ciBEcmFuZw0KPiA8T2Zpci5EcmFuZ0Bhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogUG9zc2libGUg
aXNzdWUgd2l0aCBuZXcgaW5hdXRoZW50aWMgQUVBRCBpbiBleHRlbmRlZCBjcnlwdG8gdGVzdHMN
Cj4NCj4gPDw8IEV4dGVybmFsIEVtYWlsID4+Pg0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdp
bmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5r
cyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZQ0KPiBzZW5kZXIv
c2VuZGVyIGFkZHJlc3MgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4NCj4NCj4gT24g
RnJpLCBGZWIgNywgMjAyMCBhdCAyOjMwIFBNIFN0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hy
b25veC5kZT4gd3JvdGU6DQo+ID4NCj4gPiBBbSBGcmVpdGFnLCA3LiBGZWJydWFyIDIwMjAsIDEy
OjUwOjUxIENFVCBzY2hyaWViIEdpbGFkIEJlbi1Zb3NzZWY6DQo+ID4NCj4gPiBIaSBHaWxhZCwN
Cj4gPg0KPiA+ID4NCj4gPiA+IEl0IGlzIGNvcnJlY3QsIGJ1dCBpcyBpdCBzbWFydD8NCj4gPiA+
DQo+ID4gPiBFaXRoZXIgd2UgcmVxdWlyZSB0aGUgc2FtZSBJViB0byBiZSBwYXNzZWQgdHdpY2Ug
YXMgd2UgZG8gdG9kYXksIGluIHdoaWNoDQo+ID4gPiBjYXNlIHBhc3NpbmcgZGlmZmVyZW50IElW
IHNob3VsZCBmYWlsIGluIGEgcHJlZGljdGFibGUgbWFubmVyIE9SIHdlIHNob3VsZA0KPiA+ID4g
ZGVmaW5lIHRoZSBvcGVyYXRpb24gaXMgdGFraW5nIHR3byBJViBsaWtlIHN0cnVjdHVyZXMgLSBv
bmUgYXMgdGhlIElWIGFuZA0KPiA+ID4gb25lIGFzIGJ5dGVzIGluIHRoZSBhc3NvY2lhdGVkIGRh
dGEgYW5kIGhhdmUgdGhlIElQc2VjIGNvZGUgdXNlIGl0IGluIGENCj4gPiA+IHNwZWNpZmljIHdh
eSBvZiBoYXBwZW4gdG8gcGFzcyB0aGUgc2FtZSBJViBpbiBib3RoIHBsYWNlcy4NCj4gPiA+DQo+
ID4gPiBJIGRvbid0IGNhcmUgZWl0aGVyIHdheSAtIGJ1dCByaWdodCBub3cgdGhlIHRlc3RzIGJh
c2ljYWxseSByZWxpZXMgb24NCj4gPiA+IHVuZGVmaW5lZCBiZWhhdmlvdXINCj4gPiA+IHdoaWNo
IGlzIGFsd2F5cyBhIGJhZCB0aGluZywgSSB0aGluay4NCj4gPg0KPiA+IEkgYW0gbm90IHN1cmUg
YWJvdXQgdGhlIG1vdGl2YXRpb24gb2YgdGhpcyBkaXNjdXNzaW9uOiB3ZSBoYXZlIGV4YWN0bHkg
b25lDQo+ID4gdXNlciBvZiB0aGUgUkZDNDEwNiBpbXBsZW1lbnRhdGlvbjogSVBTZWMuIFByb3Zp
ZGluZyB0aGUgSVYvQUFEIGlzIGVmZmljaWVudA0KPiA+IGFzIHRoZSByZmM0MTA2IHRlbXBsYXRl
IGludGVudHMgdG8gcmVxdWlyZSB0aGUgZGF0YSBpbiBhIGZvcm1hdCB0aGF0IHJlcXVpcmVzDQo+
ID4gbWluaW1hbCBwcm9jZXNzaW5nIG9uIHRoZSBJUFNlYyBzaWRlIHRvIGJyaW5nIGl0IGluIHRo
ZSByaWdodCBmb3JtYXQuDQo+ID4NCj4NCj4gVGhlIG1vdGl2YXRpb24gZm9yIHRoaXMgZGlzY3Vz
c2lvbiBpcyB0aGF0IG91ciBjdXJyZW50IHRlc3Qgc3VpdGUgZm9yDQo+IFJGQzQxMDYgZ2VuZXJh
dGVzIHRlc3QgbWVzc2FnZXMgd2hlcmUgcmVxLT5pdiBpcyBkaWZmZXJlbnQgdGhhbiB0aGUNCj4g
Y29weSBpbiB0aGUgYXNzb2NpYXRlZCBkYXRhLg0KPg0KSW50ZXJlc3RpbmcgLi4uIHRoaXMgbXVz
dCBiZSBhIHJlY2VudCBjaGFuZ2UgdGhlbiwgYmVjYXVzZSB0aGF0J3Mgbm90IHdoYXQNCkkgcmVt
ZW1iZXIgYW5kIGl0J3MgYWxzbyBub3QgaW4gdGhlIGN1cnJlbnQgNS42LXJjMSAgdHJlZSBmcm9t
IExpbnVzLg0KDQpTbyB3aGF0IHdvdWxkIHlvdSBleHBlY3QgdGhlbj8gVGhhdCBpdCB0YWtlcyB0
aGUgSVYgZnJvbSByZXEtPml2IGFuZA0KdG90YWxseSBpZ25vcmVzIHRoZSBBQUQgZGF0YSBwYXJ0
PyBUaGF0IHdvdWxkIGJlIHRoZSBvbmx5IGJlaGF2b3IgbWFraW5nDQpzZW5zZSBmb3IgcmZjNDEw
NiBzcGVjaWZpY2FsbHkuIExlYXZlcyB0aGUgcXVlc3Rpb24gd2h5IHlvdSB3b3VsZCBhbGxvdw0K
dGhlIGFwcGxpY2F0aW9uIHRvIHN1cHBseSB0b3RhbGx5IHJhbmRvbSBkYXRhIHRvIHRoZSBjaXBo
ZXJzdWl0ZS4NCg0KQnV0IHRoZW4gd2hhdCBhYm91dCByZmM0NTQzIHdoZXJlIHlvdSBoYXZlIHRo
ZSBzYW1lIEFQSSAocHJlc3VtYWJseQ0KcmZjNDEwNiB3YXMgYWxpZ25lZCB3aXRoIHRoYXQ/KSBi
dXQgeW91IE1VU1QgaGF2ZSByZXEtPml2IG1hdGNoaW5nIHRoYXQNCkFBRCBkYXRhIG90aGVyd2lz
ZSB5b3UncmUgbm90IGNvbXBsaWFudCB3aXRoIHRoYXQgUkZDLiAocmVnYXJkbGVzcyBvZg0Kd2hl
dGhlciB0aGF0ICdtaWdodCBiZSB1c2VmdWwnIC0gdGhlIG5hbWUgd291bGQgYmUgd3JvbmcgdGhl
bikNCg0KPiBUaGlzIGlzIG5vdCBwZXIgbXkgaW50ZXJwcmV0YXRpb24gb2YgUkZDIDQxMDYsIHRo
aXMgaXMgbm90IHRoZSBBUEkgYXMNCj4gaXMgZGVzY3JpYmVkIGluIHRoZSBoZWFkZXIgZmlsZXMg
YW5kIGZpbmFsbHkgaXQgaXMgbm90IHBlciB0aGUgdXNlDQo+IGNhc2Ugb2YgdGhlIHNpbmdsZSB1
c2VyIG9mIFJGQyA0MTA2IGluIHRoZSBrZXJuZWwgYW5kIHJpZ2h0IG5vdyB0aGVzZQ0KPiB0ZXN0
cw0KPiBjYXVzZXMgdGhlIGNjcmVlIGRyaXZlciB0byBmYWlsIHRoZXNlIHRlc3RzLg0KPg0KQWdy
ZWUNCg0KPiBBZ2FpbiwgSSBhbSAqbm90KiBzdWdnZXN0aW5nIG9yIGRpc2N1c3NpbmcgY2hhbmdp
bmcgdGhlIEFQSS4NCj4NClRoZSBBUEkganVzdCBuZWVkcyBzb21lIGNsYXJpZmljYXRpb24gaW4g
dGhpcyBhcmVhLiBJdCBtYWtlcyBzZW5zZSB0bw0KX3JlcXVpcmVfIHJlcS0+aXYgYW5kIHRoZSBJ
ViBwYXJ0IGF0IHRoZSBlbmQgb2YgdGhlIEFBRCBidWZmZXIgdG8gYmUNCl9pZGVudGljYWxfIHN1
Y2ggdGhhdCB0aGUgZHJpdmVyIGNhbiBfYXNzdW1lXyB0aGlzIHRvIGJlIHRoZSBjYXNlLg0KQ29u
c2lkZXJpbmcgdGhlc2UgY2lwaGVyc3VpdGVzIGFyZSByZWFsbHkgc3BlY2lmaWMgdG8gSVBzZWMg
RVNQLg0KDQo+IEkgYW0gYXNraW5nIHRoZSB2ZXJ5IHByYWN0aWNhbCBxdWVzdGlvbiBpZiBpdCBt
YWtlcyBzZW5zZSB0byBtZSB0bw0KPiBkZWx2ZSBpbnRvIHVuZGVyc3RhbmRpbmcgd2h5IHRoaXMg
dXNlIGNhc2UgaXMgZmFpbGluZyB2ZXJzdXMgZml4aW5nDQo+IHRoZSB0ZXN0IHN1aXRlIHRvICB0
ZXN0IHdoYXQgd2UgYWN0dWFsbHkgdXNlLg0KPg0KPiBHaWxhZA0KPg0KPiAtLQ0KPiBHaWxhZCBC
ZW4tWW9zc2VmDQo+IENoaWVmIENvZmZlZSBEcmlua2VyDQo+DQo+IHZhbHVlcyBvZiDOsiB3aWxs
IGdpdmUgcmlzZSB0byBkb20hDQoNCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2ls
aWNvbiBJUCBBcmNoaXRlY3QgTXVsdGktUHJvdG9jb2wgRW5naW5lcywgUmFtYnVzIFNlY3VyaXR5
DQpSYW1idXMgUk9UVyBIb2xkaW5nIEJWDQorMzEtNzMgNjU4MTk1Mw0KDQpOb3RlOiBUaGUgSW5z
aWRlIFNlY3VyZS9WZXJpbWF0cml4IFNpbGljb24gSVAgdGVhbSB3YXMgcmVjZW50bHkgYWNxdWly
ZWQgYnkgUmFtYnVzLg0KUGxlYXNlIGJlIHNvIGtpbmQgdG8gdXBkYXRlIHlvdXIgZS1tYWlsIGFk
ZHJlc3MgYm9vayB3aXRoIG15IG5ldyBlLW1haWwgYWRkcmVzcy4NCg0KDQoqKiBUaGlzIG1lc3Nh
Z2UgYW5kIGFueSBhdHRhY2htZW50cyBhcmUgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5k
ZWQgcmVjaXBpZW50KHMpLiBJdCBtYXkgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IGlzIGNvbmZp
ZGVudGlhbCBhbmQgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lw
aWVudCBvZiB0aGlzIG1lc3NhZ2UsIHlvdSBhcmUgcHJvaGliaXRlZCBmcm9tIHByaW50aW5nLCBj
b3B5aW5nLCBmb3J3YXJkaW5nIG9yIHNhdmluZyBpdC4gUGxlYXNlIGRlbGV0ZSB0aGUgbWVzc2Fn
ZSBhbmQgYXR0YWNobWVudHMgYW5kIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5LiAqKg0K
DQpSYW1idXMgSW5jLjxodHRwOi8vd3d3LnJhbWJ1cy5jb20+DQo=

