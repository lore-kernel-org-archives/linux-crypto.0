Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC32BC33C9E
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 00:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A04B21739
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 00:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="GkPCl4zc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgA2ATn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 19:19:43 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:27133 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbgA2ATn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 19:19:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1580257180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kfvAn0vNrbL9PZk1MCNoE2C/CIN4ualR2ryIdhQZA7k=;
        b=GkPCl4zct7zbuO2J/NLyI1IXoIxlzY9FkW/uQDAckaYQ1gmZPKhEZTO9358NN91SaiJVjd
        NOJO+Ef0TJDdybEUm29YtpT4MvBJz28OKVz5AZ+NgSonO1rfvJ13eiO/Fxj+nBFRT160+5
        RVO3t+vbYO7066B4bIIWQ5rWDmpcsBk=
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-YCuEEzjeP-aSa8XSa-ampw-1; Tue, 28 Jan 2020 19:18:33 -0500
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com (52.132.97.155) by
 CY4PR0401MB3508.namprd04.prod.outlook.com (52.132.103.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Wed, 29 Jan 2020 00:18:30 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::8140:5c22:404e:65e7]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::8140:5c22:404e:65e7%7]) with mapi id 15.20.2665.026; Wed, 29 Jan 2020
 00:18:29 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: RE: Possible issue with new inauthentic AEAD in extended crypto tests
Thread-Topic: Possible issue with new inauthentic AEAD in extended crypto
 tests
Thread-Index: AQHV1Ohtfj6tA7gaZ0uNkoHJDpcQdaf/XTuAgAARvQCAAD8mgIAA510AgAAczlA=
Date:   Wed, 29 Jan 2020 00:18:29 +0000
Message-ID: <CY4PR0401MB3652A030115942389B57A8E3C3050@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain>
 <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
 <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com>
 <b5a529fd1abd46ea881b18c387fcd4dc@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <b5a529fd1abd46ea881b18c387fcd4dc@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.220.222.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79e4d8a9-c267-4b19-5639-08d7a450c4a3
x-ms-traffictypediagnostic: CY4PR0401MB3508:
x-microsoft-antispam-prvs: <CY4PR0401MB35083C9939B7DD639E618531C3050@CY4PR0401MB3508.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39850400004)(396003)(366004)(376002)(189003)(199004)(55016002)(86362001)(66556008)(9686003)(54906003)(26005)(66446008)(110136005)(6506007)(53546011)(66476007)(64756008)(4326008)(33656002)(8676002)(81166006)(478600001)(8936002)(81156014)(186003)(316002)(5660300002)(52536014)(71200400001)(7696005)(76116006)(66946007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3508;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wxEq1b4S1LqKrGA/JaNUKP87HGMFSrmc+gMhAydOS29OlEiaHV2O8ur0avJwFPE6PsSzAZxCYEa4LjmBDCst/LiOfWVHgkWV7nbNEScv5b/5A2BaAwXyy8MXQrKHqqtUmg9xEgd7yMW1zzI9xZebUUfBrChK9SGnkF34idFBpyXkmZUNWqpwXvCGB7i3Aa1pWgVLrsAsr2XFizoyEh37xiAGyFtByMfcPcPVGWIcOFaurtVHJnU+dZ8MEAXXdTRjwxweuSAp2GJIlmnT26SM71apj8krW+EKROUkQxu2+xBqp44KAJ2pVoh6pgfg+NaCMhd/IVQBkFgG8CnxNZxjQ32QDMPY/LCsVyVBxK9NuSK738oqLUFy27C446mucl9y/C3wgU9zFGhNJqAFOKAIVM13O6JDVMZGo8/aEulztM3Xp6pcQ6N1cvooe/22LTzv2iIUjPcxilSzF70IuX0+I7o0Tkis9hbmfS3T7lPtx6A=
x-ms-exchange-antispam-messagedata: wJhQB07XLcmU8/+eox2Y8WOhbyhTFFuyGJnVdNKqtKiWH6C5XeJrWbTY5AoZvfGXcgFhoN9N2I/GvDWEbiiNvAy2LubbkYcclPRqXOcvxlDY5K/eaBNFMHEsWDU2rqLKlKhq5thhlsMJiAXS4X/1rA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e4d8a9-c267-4b19-5639-08d7a450c4a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 00:18:29.8163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F50tZld/LFfQKsFHD0QzCFdCu8iRR3A+blekfpK6uPEQU3uMGFqsS9zJJv/QNIKTMs27FQt3vpnWi1mzgw6aZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3508
X-MC-Unique: YCuEEzjeP-aSa8XSa-ampw-1
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
ZWhhbGYgT2YgRXJpYyBCaWdnZXJzDQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMjgsIDIwMjAg
MTA6MTMgUE0NCj4gVG86IEdpbGFkIEJlbi1Zb3NzZWYgPGdpbGFkQGJlbnlvc3NlZi5jb20+DQo+
IENjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBTdGVwaGFuIE11
ZWxsZXIgPHNtdWVsbGVyQGNocm9ub3guZGU+OyBMaW51eCBDcnlwdG8gTWFpbGluZyBMaXN0IDxs
aW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZz47IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2Vl
cnRAbGludXgtbTY4ay5vcmc+OyBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBP
ZmlyIERyYW5nDQo+IDxPZmlyLkRyYW5nQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBQb3NzaWJs
ZSBpc3N1ZSB3aXRoIG5ldyBpbmF1dGhlbnRpYyBBRUFEIGluIGV4dGVuZGVkIGNyeXB0byB0ZXN0
cw0KPg0KPiA8PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3Jp
Z2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxp
bmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhlDQo+IHNlbmRl
ci9zZW5kZXIgYWRkcmVzcyBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KPg0KPg0KPiBP
biBUdWUsIEphbiAyOCwgMjAyMCBhdCAwOToyNDoyNUFNICswMjAwLCBHaWxhZCBCZW4tWW9zc2Vm
IHdyb3RlOg0KPiA+IC0gVGhlIHNvdXJjZSBpcyBwcmVzdW1lZCB0byBoYXZlIGVub3VnaCByb29t
IGZvciBib3RoIHRoZSBhc3NvY2lhdGVkDQo+ID4gZGF0YSBhbmQgdGhlIHBsYWludGV4dC4NCj4g
PiAtIFVubGVzcyBpdCdzIGluLXBsYWNlIGVuY3J5cHRpb24sIGluIHdoaWNoIGNhc2UsIHlvdSBh
bHNvIHByZXN1bWUgdG8NCj4gPiBoYXZlIHJvb20gZm9yIHRoZSBhdXRoZW50aWNhdGlvbiB0YWcN
Cj4NCj4gVGhlIGF1dGhlbnRpY2F0aW9uIHRhZyBpcyBwYXJ0IG9mIHRoZSBjaXBoZXJ0ZXh0LCBu
b3QgdGhlIHBsYWludGV4dC4gIFNvIHRoZQ0KPiBydWxlIGlzIGp1c3QgdGhhdCB0aGUgY2lwaGVy
dGV4dCBidWZmZXIgbmVlZHMgdG8gaGF2ZSByb29tIGZvciBpdCwgbm90IHRoZQ0KPiBwbGFpbnRl
eHQuDQo+DQo+IE9mIGNvdXJzZSwgd2hlbiBkb2luZyBpbi1wbGFjZSBlbmNyeXB0aW9uL2RlY3J5
cHRpb24sIHRoZSB0d28gYnVmZmVycyBhcmUgdGhlDQo+IHNhbWUsIHNvIGJvdGggd2lsbCBoYXZl
IHJvb20gZm9yIGl0LCBldmVuIHRob3VnaCB0aGUgdGFnIGlzIG9ubHkgbWVhbmluZ2Z1bCBvbg0K
PiB0aGUgY2lwaGVydGV4dCBzaWRlLiAgVGhhdCdzIGp1c3QgdGhlIGxvZ2ljYWwgY29uc2VxdWVu
Y2Ugb2YgImluLXBsYWNlIi4NCj4NCj4gPiAtIFRoZSBvbmx5IHdheSB0byB0ZWxsIGlmIHRoaXMg
aXMgaW4tcGxhY2UgZW5jcnlwdGlvbiBvciBub3QgaXMgdG8NCj4gPiBjb21wYXJlIHRoZSBwb2lu
dGVycyB0byB0aGUgc291cmNlIGFuZCBkZXN0aW5hdGlvbiAtIHRoZXJlIGlzIG5vIGZsYWcuDQo+
DQo+IFJlcXVpcmluZyB1c2VycyB0byByZW1lbWJlciB0byBwcm92aWRlIGEgZmxhZyB0byBpbmRp
Y2F0ZSBpbi1wbGFjZQ0KPiBlbmNyeXB0aW9uL2RlY3J5cHRpb24sIGluIGFkZGl0aW9uIHRvIHBh
c3NpbmcgdGhlIHNhbWUgc2NhdHRlcmxpc3QsIHdvdWxkIG1ha2UNCj4gdGhlIEFQSSBtb3JlIGNv
bXBsZXguDQo+DQpBbHNvLCB3aGF0IHdvdWxkIHRoZSBiZW5lZml0PyBZb3UnZCBzdGlsbCBoYXZl
IHRvIGNvbXBhcmUgdGhlIGZsYWcuIFRoZSBwZXJmb3JtYW5jZQ0KZGlmZmVyZW5jZSBvZiBjb21w
YXJpbmcgdGhlIGZsYWcgdnMgY29tcGFyaW5nIDIgcG9pbnRlcnMgKHRoYXQgeW91IG5lZWQgdG8g
cmVhZCBhbnl3YXkpDQppcyBsaWtlbHkgY29tcGxldGVseSBuZWdsaWdpYmxlIG9uIG1vc3QgbW9k
ZXJuIENQVSBhcmNoaXRlY3R1cmVzIC4uLg0KDQo+ID4gLSBZb3UgY2FuIGNvdW50IG9uIHRoZSBz
Y2F0dGVyZ2F0aGVyIGxpc3Qgbm90IGhhdmluZyAgYSBmaXJzdCBOVUxMDQo+ID4gYnVmZmVyLCAq
dW5sZXNzKiB0aGUgcGxhaW50ZXh0IGFuZCBhc3NvY2lhdGVkIGRhdGEgbGVuZ3RoIGFyZSBib3Ro
DQo+ID4gemVybyBBTkQgaXQncyBub3QgaW4gcGxhY2UgZW5jcnlwdGlvbi4NCj4gPiAtIFlvdSBj
YW4gY291bnQgb24gbm90IGdldHRpbmcgTlVMTCBhcyBhIHNjYXR0ZXJsaXN0IHBvaW50LCAqdW5s
ZXNzKg0KPiA+IHRoZSBwbGFpbnRleHQgYW5kIGFzc29jaWF0ZWQgZGF0YSBsZW5ndGggYXJlIGJv
dGggemVybyBBTkQgaXQncyBub3QgaW4NCj4gPiBwbGFjZSBlbmNyeXB0aW9uLiAoSSdtIGFjdHVh
bGx5IHVuc3VyZSBvZiB0aGlzIG9uZT8pDQo+DQo+IElmIHdlIGNvbnNpZGVyIHRoYXQgdGhlIGlu
cHV0IGlzIG5vdCBqdXN0IGEgc2NhdHRlcmxpc3QsIGJ1dCByYXRoZXIgYQ0KPiBzY2F0dGVybGlz
dCBhbmQgYSBsZW5ndGgsIHRoZW4gdGhlc2Ugb2JzZXJ2YXRpb25zIGFyZSByZWFsbHkganVzdCAi
eW91IGNhbg0KPiBhY2Nlc3MgdGhlIGZpcnN0IGJ5dGUsIHVubGVzcyB0aGUgbGVuZ3RoIGlzIDAi
IC0tIHdoaWNoIGlzIHNvcnQgb2Ygb2J2aW91cy4gIEFuZA0KPiByZXF1aXJpbmcgYSBkZXJlZmVy
ZW5jYWJsZSBwb2ludGVyIGZvciBsZW5ndGggPSAwIGlzIGdlbmVyYWxseSBjb25zaWRlcmVkIHRv
IGJlDQo+IGJhZCBBUEkgZGVzaWduOyBzZWUgdGhlIG1lbWNweSgpIGZpYXNjbw0KPiAoaHR0cHM6
Ly93d3cuaW1wZXJpYWx2aW9sZXQub3JnLzIwMTYvMDYvMjYvbm9ubnVsbC5odG1sKS4NCj4NCj4g
VGhlIEFQSSBjb3VsZCBiZSBzaW1wbGlmaWVkIGJ5IG9ubHkgc3VwcG9ydGluZyBmdWxsIHNjYXR0
ZXJsaXN0cywgYnV0IGl0IHNlZW1zDQo+IHRoYXQgdXNlcnMgYXJlIGN1cnJlbnRseSByZWx5aW5n
IG9uIGJlaW5nIGFibGUgdG8gZW5jcnlwdC9kZWNyeXB0IGp1c3QgYSBwcmVmaXguDQo+DQo+IElN
TywgdGhlIGJpZ2dlc3QgcHJvYmxlbXMgd2l0aCB0aGUgQUVBRCBBUEkgYXJlIGFjdHVhbGx5IHRo
aW5ncyB5b3UgZGlkbid0DQo+IG1lbnRpb24sIHN1Y2ggYXMgdGhlIGZhY3QgdGhhdCB0aGUgQUFE
IGlzbid0IGdpdmVuIGluIGEgc2VwYXJhdGUgc2NhdHRlcmxpc3QsDQo+DQpXaGlsZSBJIGNhbiB1
bmRlcnN0YW5kIHRoaXMgbWF5IGJlIGJlbmVmaWNpYWwgaW4gc29tZSBjYXNlcywgSSBiZWxpZXZl
IHRoZXkgZG8gbm90DQpvdXR3ZWlnaCB0aGUgZG93bnNpZGVzOg0KLSBJbiBtYW55IHVzZSBjYXNl
cywgQUFEK2NpcGhlciB0ZXh0IGFyZSBzdG9yZWQgYXMgb25lIGNvbnRpZ3VvdXMgc3RyaW5nLiBS
ZXF1aXJpbmcgdGhpcw0Kc3RyaW5nIHRvIGJlIHNwaXQgaW50byBzZXBlcmF0ZSBwYXJ0aWNsZXMg
Zm9yIEFBRCBhbmQgY2lwaGVydGV4dCB3b3VsZCBiZSBhIGJ1cmRlbi4NCi0gRm9yIGhhcmR3YXJl
IGFjY2VsZXJhdG9ycywgdGhlcmUgaXMgYSBjb3N0IGFzc29jaWF0ZWQgd2l0aCBlYWNoIGFkZGl0
aW9uYWwgcGFydGljbGUsIGluDQp0ZXJtcyBvZiBlaXRoZXIgYmFuZHdpZHRoIG9yIHBlcmZvcm1h
bmNlIG9yIGJvdGguIFNvIGxlc3MgcGFydGljbGVzID0gYmV0dGVyLCBnZW5lcmFsbHkuDQoNClRo
ZSBvbmx5IHRoaW5nIHRoYXQgSSBmaW5kIG9kZCBpcyB0aGF0IGlmIHlvdSBkbyBhIG5vbi1pbnBs
YWNlIG9wZXJhdGlvbiB5b3UgaGF2ZSB0aGlzDQp1bmRlZmluZWQoPykgZ2FwIGluIHRoZSBvdXRw
dXQgZGF0YSB3aGVyZSB0aGUgQUFEIHdvdWxkIGJlIGZvciBpbnBsYWNlLiBUaGF0IG1ha2VzDQps
aXR0bGUgc2Vuc2UgdG8gbWUgYW5kIHJlcXVpcmVzIGV4dHJhIGVmZm9ydCB0byBza2lwIG92ZXIg
aW4gdGhlIGRyaXZlci4NCg0KPiBhbmQgdGhhdCB0aGUgQVBJIG9ubHkgc3VwcG9ydHMgc2NhdHRl
cmxpc3RzIGFuZCBub3QgdmlydHVhbCBhZGRyZXNzZXMgKHdoaWNoDQo+IG1ha2VzIGl0IGRpZmZp
Y3VsdCB0byB1c2UgaW4gc29tZSBjYXNlcykuDQo+DQpXaGlsZSBJIGNhbiB1bmRlcnN0YW5kIHRo
YXQgdGhpcyBpcyBkaWZmaWN1bHQgaWYgdGhlIEFQSSB1c2VyIGp1c3QgZ290IHRoaXMgdmlydHVh
bCBhZGRyZXNzDQpwcm92aWRlZCBmcm9tIHNvbWV3aGVyZSBlbHNlIGFuZCBuZWVkcyB0byBkbyB0
aGUgdHJhbnNsYXRpb24sIHRoZSBvdGhlciBzaWRlIG9mIHRoZQ0KbWVkYWwgaXMgdGhhdCBhbnkg
aGFyZHdhcmUgZHJpdmVyIHdvdWxkIG90aGVyd2lzZSBoYXZlIHRvIGRvIGFkZHJlc3MgdHJhbnNs
YXRpb24gYW5kDQpzY2F0dGVybGlzdCBidWlsZGluZyBvbiB0aGUgZmx5IChhcyBoYXJkd2FyZSBu
ZWVkcyB0byBhY2Nlc3MgY29udGlndW91cyBwaHlzaWNhbCBtZW1vcnkpLA0Kd2hpY2ggd291bGQg
YmUgcmVhbCBidXJkZW4gdGhlcmUuIFdoaWxlIG1hbnkgQVBJIHVzZXJzX2FyZV8gYWJsZSB0byBw
cm92aWRlIGEgbmljZQ0Kc2NhdHRlcmxpc3QgYXQgbmVnbGlnaWJsZSBleHRyYSBjb3N0LiBTbyB3
aHkgYnVyZGVuIHRob3NlPw0KDQo+IEluIGFueSBjYXNlIHdlIGRvIG5lZWQgbXVjaCBiZXR0ZXIg
ZG9jdW1lbnRhdGlvbi4gIEknbSBwbGFubmluZyB0byBpbXByb3ZlIHNvbWUNCj4gb2YgdGhlIGNy
eXB0byBBUEkgZG9jdW1lbnRhdGlvbiwgYnV0IEknbGwgcHJvYmFibHkgZG8gdGhlIGhhc2ggYW5k
IHNrY2lwaGVyDQo+IGFsZ29yaXRobSB0eXBlcyBmaXJzdCBiZWZvcmUgZ2V0dGluZyB0byBBRUFE
LiAgU28gaWYgeW91IHdhbnQgdG8gaW1wcm92ZSB0aGUNCj4gQUVBRCBkb2N1bWVudGF0aW9uIGlu
IHRoZSBtZWFuIHRpbWUsIHBsZWFzZSBnbyBhaGVhZC4NCj4NCj4gLSBFcmljDQoNClJlZ2FyZHMs
DQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0IE11bHRpLVByb3RvY29s
IEVuZ2luZXMsIFJhbWJ1cyBTZWN1cml0eQ0KUmFtYnVzIFJPVFcgSG9sZGluZyBCVg0KKzMxLTcz
IDY1ODE5NTMNCg0KTm90ZTogVGhlIEluc2lkZSBTZWN1cmUvVmVyaW1hdHJpeCBTaWxpY29uIElQ
IHRlYW0gd2FzIHJlY2VudGx5IGFjcXVpcmVkIGJ5IFJhbWJ1cy4NClBsZWFzZSBiZSBzbyBraW5k
IHRvIHVwZGF0ZSB5b3VyIGUtbWFpbCBhZGRyZXNzIGJvb2sgd2l0aCBteSBuZXcgZS1tYWlsIGFk
ZHJlc3MuDQoNCg0KKiogVGhpcyBtZXNzYWdlIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGZvciB0
aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gSXQgbWF5IGNvbnRhaW4g
aW5mb3JtYXRpb24gdGhhdCBpcyBjb25maWRlbnRpYWwgYW5kIHByaXZpbGVnZWQuIElmIHlvdSBh
cmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQgb2YgdGhpcyBtZXNzYWdlLCB5b3UgYXJlIHBy
b2hpYml0ZWQgZnJvbSBwcmludGluZywgY29weWluZywgZm9yd2FyZGluZyBvciBzYXZpbmcgaXQu
IFBsZWFzZSBkZWxldGUgdGhlIG1lc3NhZ2UgYW5kIGF0dGFjaG1lbnRzIGFuZCBub3RpZnkgdGhl
IHNlbmRlciBpbW1lZGlhdGVseS4gKioNCg0KUmFtYnVzIEluYy48aHR0cDovL3d3dy5yYW1idXMu
Y29tPg0K

