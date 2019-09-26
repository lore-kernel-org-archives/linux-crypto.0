Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF36C432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 10:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24B2A20872
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 10:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="pX/kAJtm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfIZKTZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 06:19:25 -0400
Received: from mail-eopbgr810043.outbound.protection.outlook.com ([40.107.81.43]:4058
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbfIZKTZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 06:19:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8s27oQ1fe1SPDM2L4DLaJ0uPhd7Sc6ZRL0YqJNgf/Rv6faDWZPM1qAK21Y/DU5OfLr1tqOuliWKLFtiax9QaW0O1sqpNx6Q48+kv9kRQ8lrP4cI+uyh1VfTBpFQZ6Iw23n0Tgy1qoeQ4mDN9K25oHOiy78c5pdmrA8YBkqI5N9UAWrq2jWi5MXWgh6vJM2dyLmBEvVXzAJ8u912lCTP4RxDSzxCxrUzlg66ezBHNDQ1/QB2CW9O5IUCP46u2pYsx0c/j04GQ02zxExZRrAuDkAGxkLqOerMu9SoXVM9FAerWHuSBM7t+iAcbn/Me98Fv3RMoD3OKlI4UbUstKzZ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAOIItoJtzjHgT3VgXzrizF6GeAZHPrIhl0VwL5HiEk=;
 b=M+icVshusRp0ypT1SUKtrhP8w5PEkxoYHv06kdvhQR/TroyJVciLJ1VSulMZ2xHaxa2P2SEdrE0YnOztV7P7bfki6AkG+qRUhDdARpvYL47rgQFnFUtLAObC2vugUqucR9rDmpmi8XLiN0Ts8Y9t3x+kBXy1dGl4x1l+6oeZU4/uUyGVA3Kv3zwskAThbSSJukrNDp2js9oijDUDtTJzkUSRFHdOLTN0vndfnEA8F+WH3NU6HPoujHnMeu7rGShOiy9VHzAE0N8ty3bF/PJQ1pbsjo37Hs+R565D1A+VLCCSac6wsS14anPDA8AI2KGc89N0wLncyavMux8b8sR3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAOIItoJtzjHgT3VgXzrizF6GeAZHPrIhl0VwL5HiEk=;
 b=pX/kAJtmQ1RwDu2bDxdxeZfgQL33ko8F1XReoR4RyrDQ0z+TfQLGTAYQv/APT7JlwYYVtRiWihlYvONowErHi1ft8a6LFgM4CGrGfQ4u5Ietf/W6P8QoPguoeRwbfapI6Ox3YtzD4qXqzxn1ehjzB8woMfv0pEt6exq2phc/QG0=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2559.namprd20.prod.outlook.com (20.179.145.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 26 Sep 2019 10:19:22 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 10:19:22 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: RE: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
Thread-Topic: [RFC PATCH 00/18] crypto: wireguard using the existing crypto
 API
Thread-Index: AQHVc7w6foOeRxVj+U6Yc++T56fqIac9qd4AgAAO6oA=
Date:   Thu, 26 Sep 2019 10:19:22 +0000
Message-ID: <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
In-Reply-To: <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01404587-89bf-4bd1-c8d5-08d7426b0021
x-ms-traffictypediagnostic: MN2PR20MB2559:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2559D543BD65EB3921AEC1E0CA860@MN2PR20MB2559.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(189003)(199004)(229853002)(6436002)(66446008)(64756008)(66476007)(66556008)(76116006)(66946007)(7736002)(110136005)(4326008)(54906003)(478600001)(316002)(305945005)(14454004)(55016002)(66066001)(74316002)(86362001)(7416002)(2906002)(33656002)(15974865002)(7696005)(476003)(99286004)(76176011)(9686003)(11346002)(3846002)(446003)(6116002)(25786009)(81156014)(26005)(8676002)(81166006)(6506007)(186003)(102836004)(6246003)(256004)(52536014)(71200400001)(71190400001)(486006)(8936002)(5660300002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2559;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 29e2ap8m9VXYbJRXzIcQuxwSlvKluCKQg5aOnOjqr+fYMeKwWpzHwR8i9Sq/t1dpz5BCEJQNxS2vJjk7Q2ruSAWWWv1MJ+bpL4AOD/kxpl7DZ6QLUEdPQRkCHcg9Uhfb7RoUuG/zzIkR8ZPTJF++3dU3mFmyY0YWt+Kky7MZGjpr2/0HiN+/qyW7H7k0zvQ5j9ppv+OBSZt2qKxCbKx0hNMD+j6H4ubVnl/mvybhgNDClIFdpsvWlFg7DYoCnjd1rKzm60CqqPEU7WNCHNy0aqAYHWb/e484/pU2ySoF5GS2sdbYx5u1UdroUK7coFWCmdmG/IiboLByrHN5fClgSQsXdlhi5j57Mo0/G/Itm4WoVE/C+meRaryaVHEqZqedIN6YB/LlP2mr1Cw2VhCRhdmLcWhhEsCniFSKxYrypLs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01404587-89bf-4bd1-c8d5-08d7426b0021
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 10:19:22.6642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nRLslS6ayKPqc/YTelEJBrp5A19M65r3g/9poTO8F6ciFlTOAEVwSL9sE2cvafyndw8WrjQ5wkJBb0mCe2aoqD0TNdKgtQCQ0s7b90eO2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2559
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBUaGVyZeKAmXMgYWxzbyBhIGRlZ3JlZSBvZiBwcmFjdGljYWxpdHk6IHJpZ2h0IG5vdyB0aGVy
ZSBpcyB6ZXJvIENoYVBvbHkNCj4gYXN5bmMgYWNjZWxlcmF0aW9uIGhhcmR3YXJlIGFueXdoZXJl
IHRoYXQgd291bGQgZml0IGludG8gdGhlIGNyeXB0bw0KPiBBUEkuDQo+DQpBY3R1YWxseSwgdGhh
dCBhc3N1bXB0aW9uIGlzIGZhY3R1YWxseSB3cm9uZy4gSSBkb24ndCBrbm93IGlmIGFueXRoaW5n
DQppcyAqcHVibGljbHkqIGF2YWlsYWJsZSwgYnV0IEkgY2FuIGFzc3VyZSB5b3UgdGhlIHNpbGlj
b24gaXMgcnVubmluZyBpbg0KbGFicyBhbHJlYWR5LiBBbmQgc29tZXRoaW5nIHdpbGwgYmUgcHVi
bGljbHkgYXZhaWxhYmxlIGVhcmx5IG5leHQgeWVhcg0KYXQgdGhlIGxhdGVzdC4gV2hpY2ggY291
bGQgbmljZWx5IGNvaW5jaWRlIHdpdGggaGF2aW5nIFdpcmVndWFyZCBzdXBwb3J0DQppbiB0aGUg
a2VybmVsICh3aGljaCBJIHdvdWxkIGFsc28gbGlrZSB0byBzZWUgaGFwcGVuIEJUVykgLi4uDQoN
Cj4gQXQgc29tZSBwb2ludCwgaXQgbWlnaHQgY29tZSB0byBleGlzdCBhbmQgaGF2ZSBpbmNyZWRp
YmxlDQo+IHBlcmZvcm1hbmNlLCBhbmQgdGhlbiB3ZeKAmWxsIGJvdGggZmVlbCB2ZXJ5IG1vdGl2
YXRlZCB0byBtYWtlIHRoaXMgd29yaw0KPiBmb3IgV2lyZUd1YXJkLiBCdXQgaXQgbWlnaHQgYWxz
byBub3QgY29tZSB0byBiZSAoQUVTIHNlZW1zIHRvIGhhdmUgd29uDQo+IG92ZXIgbW9zdCBvZiB0
aGUgaW5kdXN0cnkpLCBpbiB3aGljaCBjYXNlLCB3aHkgaGFzc2xlPw0KPg0KTm90ICJhdCBzb21l
IHBvaW50Ii4gSXQgd2lsbC4gVmVyeSBzb29uLiBNYXliZSBub3QgaW4gY29uc3VtZXIgb3Igc2Vy
dmVyDQpDUFVzLCBidXQgZGVmaW5pdGVseSBpbiB0aGUgZW1iZWRkZWQgKG5ldHdvcmtpbmcpIHNw
YWNlLg0KQW5kIGl0ICp3aWxsKiBiZSBtdWNoIGZhc3RlciB0aGFuIHRoZSBlbWJlZGRlZCBDUFUg
bmV4dCB0byBpdCwgc28gaXQgd2lsbCANCmJlIHdvcnRoIHVzaW5nIGl0IGZvciBzb21ldGhpbmcg
bGlrZSBidWxrIHBhY2tldCBlbmNyeXB0aW9uLg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1
d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmlt
YXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
