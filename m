Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFB0C432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 09:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665C5222C7
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 09:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="pR6qgJQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfIZJkt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:40:49 -0400
Received: from mail-eopbgr820078.outbound.protection.outlook.com ([40.107.82.78]:30432
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbfIZJks (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 05:40:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY8Dl3z7yJqG+MbxNirstLp6o8KzStMKbOOACKd9FYJKhEOJ9BeVQT5H8izw6izy96o7so6KEx5Ge/ofJevkt7882L6cpVcaa6MCanWj5B/82mzTEhQSqyvqvjSo0C/bKP8orJvdLDXcFZEcbomUTfPZ4HkkImhYYnyToWuBjdWSdjWhJy2eG0/jUkhD/Z695AoG3yFFbWw0WcRP3HG8KK6GpZaakVRrTzktEeDw3QCdflDJyEDLRQoJd0ObKywuSGaikzH9D2yMQ7Gkd4Gr05Ss23FGBufU5DbbzszOOMZzWa1PiTkU9mYmxYOQ1cJL8hvh+3JfpECodf7hr0nnyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzOCjkfETybK/UjjXpGa6E43RofR02zSKx9EjEqjvvg=;
 b=FU8GAh30sH9d+cFtKIbdkjvcAZ4TP+DLnbgUyq4+Xb8nAYn3oryTRUEw3N2UGovEmN3/rna5sZSyONC7Mhhcs+FvZD2cbNKYsK/g09G9Ee03EtKxT5AcDSwgazB+0kw/fScAlidnCodBO4TnZexrYS/6YEo4KvexKr/gjMPUs3xQeR2o22fK2QrJ1M27907H1za1MCgl/kgVrx41AGig3ERhEUW2NAk+xc8t9GTsnrWbmC7mJE2ht+krxrNSOaVE7ieCViQMUu22jgAr7/deCVlo1tWzkAgjkPZAJ2c0ZIE9S4U6rPHpc+M5xeLtTR5mePoZXOWG7d5NtYNGNZPDtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzOCjkfETybK/UjjXpGa6E43RofR02zSKx9EjEqjvvg=;
 b=pR6qgJQVzEQo1HjzR44XdwkGUNXfxUkneocBb3GWhewHXJTg6DXv6mdZWKhKEeDhxZDHJDdP7jAbwwuW22IhgKyQkrf2LDteN9j6News6YpHsZtLXUl3WSJ2figOHgAD6Mh5DzNBqtVPIRtSrl0b9Y4xrwjpvXQEynO/0QzKkys=
Received: from CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) by
 CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.19; Thu, 26 Sep 2019 09:40:44 +0000
Received: from CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::11e4:36be:e674:7c6d]) by CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::11e4:36be:e674:7c6d%7]) with mapi id 15.20.2284.028; Thu, 26 Sep 2019
 09:40:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: RE: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
Thread-Topic: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
Thread-Index: AQHVc7xLFDyOijy/PkCX/N7Gn7qoy6c89gcAgACj7jA=
Date:   Thu, 26 Sep 2019 09:40:42 +0000
Message-ID: <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org>
 <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed0bab6f-a763-4733-b3c4-08d7426599c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR20MB2968;
x-ms-traffictypediagnostic: CH2PR20MB2968:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2PR20MB29688A8175381F706C45D807CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(346002)(376002)(396003)(366004)(199004)(51444003)(189003)(110136005)(6506007)(7416002)(66446008)(102836004)(186003)(54906003)(66476007)(66556008)(316002)(66946007)(64756008)(26005)(33656002)(8676002)(76176011)(7696005)(99286004)(2906002)(8936002)(81166006)(81156014)(256004)(486006)(76116006)(446003)(11346002)(3846002)(14444005)(476003)(9686003)(55016002)(478600001)(305945005)(229853002)(7736002)(52536014)(6246003)(86362001)(5660300002)(15974865002)(6116002)(71190400001)(71200400001)(14454004)(25786009)(4326008)(6436002)(66066001)(74316002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR20MB2968;H:CH2PR20MB2968.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CfT+ul3bIIAlTW9qJ+CuU8gwSiIE0OGeOlQRIZXpPhWZIxuV+MdtPa/glshU3UYj4nsu/Aw+9lwWVQDOiWp6CSLaENKw6ojwucbxVWlTYUhkYpqvdXHZ0wbbwU6483o0ngtB82moR+KXWQ8v+72O5A8WPCHsbFYhrEehXwiw9BWHq03aI8Kx84MvhqlJFN779XRggTAT4iVkm0bkzX9U3VX+EWKvn7fXmkEW9PsAMAkS11jXUrHyZxao1xZJTCYJ40dBaVmGajA1YRZjqfMsSVrcjXpMHCzvNj5PpzofItZRpW7Dd12mgSVCAR/1K0cflby39lORCpbFn/3gyqlBcI36qUh1YRyiqyqchCyMsKv68kaSCmsYDAaELlNAk2Cz4ZPhdaq5URrsjps2gCVlDWwnW/bKDxlARSuXkbLR4rI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed0bab6f-a763-4733-b3c4-08d7426599c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 09:40:42.9255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jAh2PHFCKTN/9J5YGuwbsW0pnON7hyoquTWG6VbU40tc6UhnEiy7KxFxATj7yp3qSW1aXWZbqwuk4eaQJKGY527dyxkIVIb2/J6AUALeN4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR20MB2968
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+DQo+ID4gUmVwbGFjZSB0aGUgY2hhY2hhMjBwb2x5MTMwNSgpIGxpYnJhcnkgY2FsbHMgd2l0
aCBpbnZvY2F0aW9ucyBvZiB0aGUNCj4gPiBSRkM3NTM5IEFFQUQsIGFzIGltcGxlbWVudGVkIGJ5
IHRoZSBnZW5lcmljIGNoYWNoYTIwcG9seTEzMDUgdGVtcGxhdGUuDQo+IA0KPiBIb25lc3RseSwg
dGhlIG90aGVyIHBhdGNoZXMgbG9vayBmaW5lIHRvIG1lIGZyb20gd2hhdCBJJ3ZlIHNlZW4gKHdp
dGgNCj4gdGhlIHNtYWxsIG5vdGUgSSBoYWQgaW4gYSBzZXBhcmF0ZSBlbWFpbCBmb3IgMTEvMTgp
LCBidXQgdGhpcyBvbmUgSQ0KPiBjb25zaWRlciBqdXN0IG5hc3R5LCBhbmQgYSBwcmltZSBleGFt
cGxlIG9mIHdoeSBwZW9wbGUgaGF0ZSB0aG9zZQ0KPiBjcnlwdG8gbG9va3VwIHJvdXRpbmVzLg0K
PiANCj4gU29tZSBvZiBpdCBpcyBqdXN0IHRoZSBmdW5kYW1lbnRhbCBhbmQgcG9pbnRsZXNzIHNp
bGx5IGluZGlyZWN0aW9uLA0KPiB0aGF0IGp1c3QgbWFrZXMgdGhpbmdzIGhhcmRlciB0byByZWFk
LCBsZXNzIGVmZmljaWVudCwgYW5kIGxlc3MNCj4gc3RyYWlnaHRmb3J3YXJkLg0KPiANCj4gVGhh
dCdzIGV4ZW1wbGlmaWVkIGJ5IHRoaXMgcGFydCBvZiB0aGUgcGF0Y2g6DQo+IA0KPiA+ICBzdHJ1
Y3Qgbm9pc2Vfc3ltbWV0cmljX2tleSB7DQo+ID4gLSAgICAgICB1OCBrZXlbTk9JU0VfU1lNTUVU
UklDX0tFWV9MRU5dOw0KPiA+ICsgICAgICAgc3RydWN0IGNyeXB0b19hZWFkICp0Zm07DQo+IA0K
PiB3aGljaCBpcyBqdXN0IG9uZSBvZiB0aG9zZSAid2Uga25vdyB3aGF0IHdlIHdhbnQgYW5kIHdl
IGp1c3Qgd2FudCB0bw0KPiB1c2UgaXQgZGlyZWN0bHkiIHRoaW5ncywgYW5kIHRoZW4gdGhlIGNy
eXB0byBpbmRpcmVjdGlvbiBjb21lcyBhbG9uZw0KPiBhbmQgbWFrZXMgdGhhdCBzaW1wbGUgaW5s
aW5lIGFsbG9jYXRpb24gb2YgYSBzbWFsbCBjb25zdGFudCBzaXplDQo+IChhZmFpayBpdCBpcyBD
SEFDSEEyMFBPTFkxMzA1X0tFWV9TSVpFLCB3aGljaCBpcyAzMikgYmUgYW5vdGhlcg0KPiBhbGxv
Y2F0aW9uIGVudGlyZWx5Lg0KPiANCj4gQW5kIGl0J3Mgc29tZSByYW5kb20gb2RkIG5vbi10eXBl
ZCB0aGluZyB0b28sIHNvIHRoZW4geW91IGhhdmUgdGhhdA0KPiBzaWxseSBhbmQgc3R1cGlkIGR5
bmFtaWMgYWxsb2NhdGlvbiB1c2luZyBhIG5hbWUgbG9va3VwOg0KPiANCj4gICAgY3J5cHRvX2Fs
bG9jX2FlYWQoInJmYzc1MzkoY2hhY2hhMjAscG9seTEzMDUpIiwgMCwgQ1JZUFRPX0FMR19BU1lO
Qyk7DQo+IA0KPiB0byBjcmVhdGUgd2hhdCB1c2VkIHRvIGJlIChhbmQgc2hvdWxkIGJlKSBhIHNp
bXBsZSBhbGxvY2F0aW9uIHRoYXQgd2FzDQo+IGhhcyBhIHN0YXRpYyB0eXBlIGFuZCB3YXMganVz
dCBwYXJ0IG9mIHRoZSBjb2RlLg0KPiANCldoaWxlIEkgYWdyZWUgd2l0aCB0aGUgcHJpbmNpcGxl
IG9mIGZpcnN0IG1lcmdpbmcgV2lyZWd1YXJkIHdpdGhvdXQgDQpob29raW5nIGl0IHVwIHRvIHRo
ZSBDcnlwdG8gQVBJIGFuZCBkb2luZyB0aGUgbGF0dGVyIGluIGEgbGF0ZXIsDQpzZXBhcmF0ZSBw
YXRjaCwgSSBET05UJ1QgYWdyZWUgd2l0aCB5b3VyIGJhc2hpbmcgb2YgdGhlIENyeXB0byBBUEkN
Cm9yIEhXIGNyeXB0byBhY2NlbGVyYXRpb24gaW4gZ2VuZXJhbC4NCg0KWWVzLCBJIGRvIGFncmVl
ICB0aGF0IGlmIHlvdSBuZWVkIHRvIGRvIHRoZSBvY2Nhc2lvbmFsIHNpbmdsZSBjcnlwdG8gDQpv
cCBmb3IgYSBmaXhlZCBhbGdvcml0aG0gb24gYSBzbWFsbCBhbW91bnQgb2YgZGF0YSB0aGVuIHlv
dSBzaG91bGQNCmp1c3QgdXNlIGEgc2ltcGxlIGRpcmVjdCAgbGlicmFyeSBjYWxsLiBJJ20gYWxs
IGZvciBhIFppbmMgdHlwZSANCmxpYnJhcnkgZm9yIHRoYXQuDQooYW5kIEkgYmVsaWV2ZSBBcmQg
aXMgYWN0dWFsbHkgYWN0aXZlbHkgbWFraW5nIHN1Y2ggY2hhbmdlcyBhbHJlYWR5KQ0KDQpIb3dl
dmVyLCBpZiB5b3UncmUgZG9pbmcgYnVsayBjcnlwdG8gbGlrZSBuZXR3b3JrIHBhY2tldCBwcm9j
ZXNzaW5nDQooYXMgV2lyZWd1YXJkIGRvZXMhKSBvciBkaXNrL2ZpbGVzeXN0ZW0gZW5jcnlwdGlv
biwgdGhlbiB0aGF0IGNpcGhlcg0KYWxsb2NhdGlvbiBvbmx5IGhhcHBlbnMgb25jZSBldmVyeSBi
bHVlIG1vb24gYW5kIHRoZSBvdmVyaGVhZCBmb3INCnRoYXQgaXMgdG90YWxseSAqaXJyZWxldmFu
dCogYXMgaXQgaXMgYW1vcnRpemVkIG92ZXIgbWFueSBob3VycyBvciANCmRheXMgb2YgcnVudGlt
ZS4NCg0KV2hpbGUgSSBnZW5lcmFsbHkgZGlzbGlrZSB0aGlzIHdob2xlIGh5cGUgb2Ygc3Rvcmlu
ZyBzdHVmZiBpbg0KdGV4dHVhbCBmb3JtYXRzIGxpa2UgWE1MIGFuZCBKU09OIGFuZCB0aGVuIHdh
c3RpbmcgbG90cyBvZiBDUFUNCmN5Y2xlcyBvbiBwYXJzaW5nIHRoYXQsIEkndmUgbGVhcm5lZCB0
byBhcHByZWNpYXRlIHRoZSBwb3dlciBvZg0KdGhlc2UgdGV4dHVhbCBDcnlwdG8gQVBJIHRlbXBs
YXRlcywgYXMgdGhleSBhbGxvdyBhIGhhcmR3YXJlIA0KYWNjZWxlcmF0b3IgdG8gYWR2ZXJ0aXNl
IGNvbXBsZXggY29tYmluZWQgb3BlcmF0aW9ucyBhcyBzaW5nbGUNCmF0b21pYyBjYWxscywgYW1v
cnRpemluZyB0aGUgY29tbXVuaWNhdGlvbiBvdmVyaGVhZCBiZXR3ZWVuIFNXDQphbmQgSFcuIEl0
J3MgYWN0dWFsbHkgdmVyeSBmbGV4aWJsZSBhbmQgcG93ZXJmdWwhDQoNCj4gSXQgYWxzbyBlbmRz
IHVwIGRvaW5nIG90aGVyIGJhZCB0aGluZ3MsIGllIHRoYXQgcGFja2V0LXRpbWUNCj4gDQo+ICsg
ICAgICAgaWYgKHVubGlrZWx5KGNyeXB0b19hZWFkX3JlcXNpemUoa2V5LT50Zm0pID4gMCkpIHsN
Cj4gKyAgICAgICAgICAgICAgIHJlcSA9IGFlYWRfcmVxdWVzdF9hbGxvYyhrZXktPnRmbSwgR0ZQ
X0FUT01JQyk7DQo+ICsgICAgICAgICAgICAgICBpZiAoIXJlcSkNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPiANCj4gdGhpbmcgdGhhdCBob3BlZnVsbHkgX2lzXyB1
bmxpa2VseSwgYnV0IHRoYXQncyBqdXN0IG1vcmUgcG90ZW50aWFsDQo+IGJyZWFrYWdlIGZyb20g
dGhhdCB3aG9sZSBhc3luYyBjcnlwdG8gaW50ZXJmYWNlLg0KPiANCj4gVGhpcyBpcyB3aGF0IHBl
b3BsZSBkbyAqbm90KiB3YW50IHRvIGRvLCBhbmQgd2h5IHBlb3BsZSBvZnRlbiBkb24ndA0KPiBs
aWtlIHRoZSBjcnlwdG8gaW50ZXJmYWNlcy4NCj4gDQpMaWZlIGlzIGFsbCBhYm91dCBuZWVkaW5n
IHRvIGRvIHRoaW5ncyB5b3UgZG9uJ3QgbGlrZSB0byBkbyAuLi4NCklmIHlvdSB3YW50IHRoZSBw
ZXJmb3JtYW5jZSwgeW91IG5lZWQgdG8gZG8gdGhlIGVmZm9ydC4gVGhhdCBzaW1wbGUuDQpIVyBh
Y2NlbGVyYXRpb24gc3VyZWx5IHdvbid0IHdvcmsgZnJvbSBhIG5haXZlIHN5bmNocm9ub3VzIGlu
dGVyZmFjZS4NCihTYW1lIGFwcGxpZXMgdG8gcnVubmluZyBjcnlwdG8gaW4gYSBzZXBhcmF0ZSB0
aHJlYWQgb24gdGhlIENQVSBCVFchKQ0KDQpJbiBhbnkgY2FzZSwgV2lyZWd1YXJkIGJ1bGsgY3J5
cHRvICpzaG91bGQqIGV2ZW50dWFsbHkgcnVuIG9uIHRvcA0Kb2YgQ3J5cHRvIEFQSSBzdWNoIHRo
YXQgaXQgY2FuIGxldmVyYWdlICpleGlzdGluZyogSFcgYWNjZWxlcmF0aW9uLg0KSXQgd291bGQg
YmUgaW5jcmVkaWJseSBzaWxseSBub3QgdG8gZG8gc28sIGdpdmVuIHRoZSBIVyBleGlzdHMhDQoN
Cj4gQW5kIEknbSBzdGlsbCBub3QgY29udmluY2VkIChhKSBldmVyIG1ha2VzIHNlbnNlIC0gdGhl
IG92ZXJoZWFkIG9mIGFueQ0KPiBhY2NlbGVyYXRvciBpcyBqdXN0IGhpZ2ggZW5vdWdodCB0aGF0
IEkgZG91YnQgeW91J2xsIGhhdmUgbnVtYmVycyAtDQo+IHBlcmZvcm1hbmNlIF9vcl8gcG93ZXIu
DQo+IA0KWW91IHNob3VsZG4ndCBtYWtlIHN1Y2ggYXNzZXJ0aW9ucyBpZiB5b3Ugb2J2aW91c2x5
IGRvbid0IGtub3cgd2hhdA0KeW91J3JlIHRhbGtpbmcgYWJvdXQuIFllcywgdGhlcmUgaXMgc2ln
bmlmaWNhbnQgb3ZlcmhlYWQgb24gdGhlIENQVQ0KZm9yIGRvaW5nIGxvb2thc2lkZSBjcnlwdG8s
IGJ1dCBpdCdzICh1c3VhbGx5KSBub3RoaW5nIGNvbXBhcmVkIHRvDQpkb2luZyB0aGUgYWN0dWFs
IGNyeXB0byBpdHNlbGYgb24gdGhlIENQVSBiYXJyaW5nIGEgZmV3IGV4Y2VwdGlvbnMuIA0KKE5v
dGFibHkgQUVTLUdDTSBvciBBRVMtQ1RSIG9uIEFSTTY0IG9yIHg2NCBDUFUncyBhbmQgKm1heWJl
KiANCkNoYWNoYS1Qb2x5IG9uIHJlY2VudCBJbnRlbCBDUFUncyAtIGJ1dCB0aGVyZSdzIGEgKmxv
dCogbW9yZSBjcnlwdG8gDQpiZWluZyB1c2VkIG91dCB0aGVyZSB0aGFuIGp1c3QgQUVTLUdDTSBh
bmQgQ2hhY2hhLVBvbHksIG5vdCB0byANCm1lbnRpb24gYSBsb3QgbW9yZSBsZXNzIGNhcGFibGUg
KGVtYmVkZGVkKSBDUFUncyBydW5uaW5nIExpbnV4KQ0KDQpGb3IgYW55dGhpbmcgYnV0IHRob3Nl
IGV4Y2VwdGlvbnMsIHdlIGJsb3cgZXZlbiB0aGUgZmFzdGVzdCBJbnRlbA0Kc2VydmVyIENQVSdz
IG91dCBvZiB0aGUgd2F0ZXIgd2l0aCBvdXIgY3J5cHRvIGFjY2VsZXJhdG9ycy4NCihJIGNhbiBi
b3JlIHlvdSB3aXRoIHNvbWUgZmlndXJlcyBhY3R1YWxseSBtZWFzdXJlZCB3aXRoIHRoZQ0KQ3J5
cHRvIEFQSSBvbiBvdXIgSFcsIG9uY2UgSSdtIGRvbmUgb3B0aW1pemluZyB0aGUgZHJpdmVyIGFu
ZCBJIA0KaGF2ZSBzb21lIHRpbWUgdG8gY29sbGVjdCB0aGUgcmVzdWx0cykNCg0KQW5kIGluIGFu
eSBjYXNlLCBmb3Igc29tZXdoYXQgbGFyZ2VyIGJsb2Nrcy9wYWNrZXRzLCB0aGUgb3ZlcmhlYWQN
Cm9uIHRoZSBDUFUgd291bGQgYXQgbGVhc3QgYmUgc3VjaCB0aGF0IGl0J3MgbGVzcyB0aGFuIHdo
YXQgdGhlIENQVQ0Kd291bGQgbmVlZCB0byBkbyB0aGUgY3J5cHRvIGl0c2VsZiAtIGV2ZW4gaWYg
aXQncyBmYXN0ZXIgLSBzdWNoIHRoYXQNCnRoZXJlIGlzIHJvb20gdGhlcmUgdG8gZG8gKm90aGVy
KiwgcHJlc3VtYWJseSBtb3JlIHVzZWZ1bCwgd29yay4NCg0KVGhlbiB0aGVyZSdzIGluZGVlZCB0
aGUgcG93ZXIgY29uc3VtcHRpb24gaXNzdWUsIHdoaWNoIGlzIGNvbXBsZXgNCmJlY2F1c2UgY3J5
cHRvIHBvd2VyICE9IHRvdGFsIHN5c3RlbSBwb3dlciBzbyBpdCBkZXBlbmRzIHRvbyBtdWNoIG9u
DQp0aGUgYWN0dWFsIHVzZSBjYXNlIHRvIG1ha2UgZ2VuZXJpYyBzdGF0ZW1lbnRzIG9uIGl0LiBT
byBJJ2xsIGxlYXZlDQp0aGF0IHdpdGggdGhlIHJlbWFyayB0aGF0IEludGVsIHNlcnZlciBDUFUn
cyBoYXZlIHRvIHNlcmlvdXNseQ0KdGhyb3R0bGUgZG93biB0aGVpciBjbG9jayBpZiB5b3Ugc3Rh
cnQgdXNpbmcgQVZYNTEyIGZvciBjcnlwdG8sIGp1c3QgdG8NCnN0YXkgd2l0aGluIHRoZWlyIHBv
d2VyIGJ1ZGdldCwgd2hpbGUgd2UgY2FuIGRvIHRoZSBzYW1lIHBlcmZvcm1hbmNlDQoofjIwMCBH
YnBzKSBpbiBqdXN0IGEgZmV3ICh+MikgV2F0dHMgb24gYSBzaW1pbGFyIHRlY2hub2xvZ3kgbm9k
ZS4NCihleGNsdWRpbmcgdGhlIENQVSBtYW5hZ2VtZW50IG92ZXJoZWFkLCBidXQgdGhhdCBzdXJl
bHkgd29uJ3QgY29uc3VtZQ0KZXhjZXNzaXZlIHBvd2VyIGxpa2UgQVZYNTEyKQ0KDQo+IEJ1dCBl
dmVuIGlmIHlvdSdyZSByaWdodCB0aGF0IGl0IG1pZ2h0IGJlIGEgcG93ZXIgYWR2YW50YWdlIG9u
IHNvbWUNCj4gcGxhdGZvcm0sIHRoYXQgd291bGRuJ3QgbWFrZSBpdCBhbiBhZHZhbnRhZ2Ugb24g
b3RoZXIgcGxhdGZvcm1zLiBNYXliZQ0KPiBpdCBjb3VsZCBiZSBkb25lIGFzIGEgY29uZmlnIG9w
dGlvbiB3aGVyZSB5b3UgY2FuIG9wdCBpbiB0byB0aGUgYXN5bmMNCj4gaW50ZXJmYWNlIHdoZW4g
dGhhdCBtYWtlcyBzZW5zZSAtIGJ1dCBub3QgZm9yY2UgdGhlIGluZGlyZWN0aW9uIGFuZA0KPiBl
eHRyYSBhbGxvY2F0aW9ucyB3aGVuIGl0IGRvZXNuJ3QuIEFzIGEgc2VwYXJhdGUgcGF0Y2gsIHNv
bWV0aGluZyBsaWtlDQo+IHRoYXQgZG9lc24ndCBzb3VuZCBob3JyZW5kb3VzIChhbmQgSSB0aGlu
ayB0aGF0J3MgYWxzbyBhbiBhcmd1bWVudCBmb3INCj4gZG9pbmcgdGhhdCBDUFUtPkxFIGNoYW5n
ZSBhcyBhbiBpbmRlcGVuZGVudCBjaGFuZ2UpLg0KPiANCk1ha2luZyBpdCBhIHN3aXRjaCBzb3Vu
ZHMgZ29vZCB0byBtZSB0aG91Z2guDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNp
bGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0K
d3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
