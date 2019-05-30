Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7525DC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370F125AE7
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="PKJIJs9+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE3O3b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 10:29:31 -0400
Received: from mail-eopbgr60125.outbound.protection.outlook.com ([40.107.6.125]:15022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725440AbfE3O3b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 10:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a41RSy3xYrgcioxnM0FdDfBPp4Fw7GpoC1QH4jzAFIU=;
 b=PKJIJs9+r8lEs07PKmWEyGtl2Qrb0qbKehGRIixP96aSVCqLt6buR+w7aDRr5fY8Z/gt1xrh1di6nSReiyz9vzyFmhQ8qgyyczo1CMS5nofZN6j03oqMTv34W4EUGU8ENjK8tQiRdRJpUCYpePCzzeYovQRhI+Ct7X5ou5Wjp/A=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3320.eurprd09.prod.outlook.com (20.179.245.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Thu, 30 May 2019 14:29:27 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 14:29:27 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkGC+Z078hijGEOmhwjdTCZ6EaaDst8AgAADzYCAAAHQcA==
Date:   Thu, 30 May 2019 14:29:26 +0000
Message-ID: <AM6PR09MB3523C09EFDE90A8A8ECFCA09D2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
 <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530135800.ekcso3n2p5zkg6yv@gondor.apana.org.au>
 <CAKv+Gu-3zzN=cikd4PftCVo2fJi9t_0kqZHBQncjokYQV5wVnA@mail.gmail.com>
In-Reply-To: <CAKv+Gu-3zzN=cikd4PftCVo2fJi9t_0kqZHBQncjokYQV5wVnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e2a1fcf-5d4f-4cf2-a951-08d6e50b383d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3320;
x-ms-traffictypediagnostic: AM6PR09MB3320:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB3320EF713FCB7BD6CDB7EC07D2180@AM6PR09MB3320.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39850400004)(376002)(346002)(136003)(199004)(189003)(486006)(66476007)(305945005)(68736007)(76116006)(9686003)(7736002)(33656002)(66446008)(64756008)(66556008)(229853002)(73956011)(66946007)(11346002)(256004)(102836004)(14444005)(6116002)(74316002)(71200400001)(71190400001)(5660300002)(15974865002)(25786009)(86362001)(52536014)(446003)(186003)(53936002)(14454004)(55016002)(26005)(476003)(81166006)(6246003)(3846002)(4326008)(54906003)(110136005)(2906002)(6506007)(478600001)(7416002)(316002)(7696005)(99286004)(66066001)(8936002)(76176011)(81156014)(8676002)(6436002)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3320;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EFKY2u/PO0Vk6taFdLu5HCyuTr+KGrNOVtW+Wi+KwszojI1weq7v3E8vplRsw0oYg3UJ/riMeFe01vIN/Ls4dCKg54d9e8sazw/30p6cQdfPXEgoUPVqz3q61GR9H/WxCHtbCTNx0nVFiKJlmfUmNZV2B7adEkAZGJ6mS0qgqVoba6bTXGeq/0EFm+Nq4cRxzDB/Xts9KQBY5jjEbdhZ70zWeX2bRbv62kWMIutWa3q91Ilxd9izYw/selKTtOWfhz0hUCLSrAy7/53T5SXpvtwEjJwEXnfbBi4qi6c/kW0J+3UJ+4V2o4bMXjPrDo5ueEQ0UZ71sbLJyl5ybWDwbb3saCGtM/E0qSGaqdpRpeqoh1bRbgI+F6cSNgZzFyYtmST560KYdRNhAcqpDg7S8hih1DSXFfyLU8AH+guXwgE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2a1fcf-5d4f-4cf2-a951-08d6e50b383d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 14:29:26.8830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3320
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBUaHUsIDMwIE1heSAyMDE5IGF0IDE1OjU4LCBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRv
ci5hcGFuYS5vcmcuYXU+DQo+IHdyb3RlOg0KPiA+DQo+ID4gT24gVGh1LCBNYXkgMzAsIDIwMTkg
YXQgMDE6NDU6NDdQTSArMDAwMCwgSXVsaWFuYSBQcm9kYW4gd3JvdGU6DQo+ID4gPg0KPiA+ID4g
T24gdGhlIGN1cnJlbnQgc3RydWN0dXJlIG9mIGNhYW1hbGcsIHRvIHdvcmssIGl2IG5lZWRzIHRv
IGJlIGNvcGllZA0KPiA+ID4gYmVmb3JlIG1lbWNweShpdiwgcmVxLT5pdiwgaXZzaXplKSwgZnJv
bSBza2NpcGhlcl9lZGVzY19hbGxvYw0KPiBmdW5jdGlvbi4NCj4gPiA+IEZvciB0aGlzIHdlIG5l
ZWQgZWRlc2MsIGJ1dCB0aGlzIGNhbm5vdCBiZSBhbGxvY2F0ZWQgYmVmb3JlIGtub3dpbmcNCj4g
aG93DQo+ID4gPiBtdWNoIG1lbW9yeSB3ZSBuZWVkLiBTbywgdG8gbWFrZSBpdCB3b3JrLCB3ZSds
bCBuZWVkIHRvIG1vZGlmeSBtb3JlIGluDQo+IENBQU0uDQo+ID4NCj4gPiBBbGwgdGhlIGNvcHlp
bmcgZG9lcyBpczoNCj4gPg0KPiA+ICAgICAgICAgaWYgKGl2c2l6ZSkNCj4gPiAgICAgICAgICAg
ICAgICAgc2NhdHRlcndhbGtfbWFwX2FuZF9jb3B5KHJlcS0+aXYsIHJlcS0+c3JjLCByZXEtDQo+
ID5jcnlwdGxlbiAtDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBpdnNpemUsIGl2c2l6ZSwgMCk7DQo+ID4NCj4gPiBXaHkgZG8geW91IG5lZWQgdG8gYWxsb2Nh
dGUgdGhlIGVkZXNjIGJlZm9yZSBkb2luZyB0aGlzPw0KPiA+DQo+IA0KPiBCZWNhdXNlIHRoYXQg
aXMgd2hlcmUgdGhlIGluY29taW5nIGl2IGlzIGN1cnJlbnRseSBjb25zdW1lZC4gQ29weWluZw0K
PiBpdCBvdXQgbGlrZSB0aGlzIHdpcGVzIHRoZSBpbnB1dCBJViBmcm9tIG1lbW9yeS4NCg0KSSBo
YWQgYSBzaW1pbGFyIHByb2JsZW0gZm9yIHRoZSBJbnNpZGUgU2VjdXJlIGRyaXZlcjogZm9yIGRl
Y3J5cHQgb3BlcmF0aW9ucywNCnlvdSBuZWVkIHRvIGNvcHkgdGhlIG91dHB1dCBJViBmcm9tIHlv
dXIgaW5wdXQgZGF0YSBidWZmZXIgKGl0J3MgdGhlIGxhc3QgDQppbnB1dCBkYXRhIGNpcGhlciBi
bG9jaykgYnV0IHlvdSBuZWVkIHRvIGRvIHRoYXQgKmJlZm9yZSogeW91IHN0YXJ0IHRoZQ0KaGFy
ZHdhcmUsIGFzIGZvciBpbi1wbGFjZSBvcGVyYXRpb25zLCBpdCBpcyBvdmVyd3JpdHRlbi4NCg0K
QXQgdGhlIHNhbWUgdGltZSwgeW91IGNhbm5vdCBzdG9yZSBpdCB0byByZXEtPml2IHlldCwgYmVj
YXVzZSB0aGF0IHN0aWxsDQpjb250YWlucyB0aGUgaW5wdXQgSVYgdGhhdCB5b3UgbmVlZCBmb3Ig
cHJvY2Vzc2luZyB0aGUgZmlyc3QgYmxvY2suDQoNClRoZSBvbmx5IHNvbHV0aW9uIEkgY291bGQg
Y29tZSB1cCB3aXRoLCBpcyB0byBwYXJrIGl0IGluIHNvbWUgdGVtcG9yYXJ5DQpidWZmZXIgaW4g
dGhlIHNrY2lwaGVyX3JlcXVlc3RfY3R4ICpiZWZvcmUqIHN0YXJ0aW5nIHRoZSBoYXJkd2FyZSBh
bmQgY29weSANCml0IHRvIHJlcS0+aXYgKmFmdGVyKiB0aGUgb3BlcmF0aW9uIGNvbXBsZXRlcy4N
Cg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11
bHRpLVByb3RvY29sIEVuZ2luZXMgQCBJbnNpZGUgU2VjdXJlDQp3d3cuaW5zaWRlc2VjdXJlLmNv
bQ0K
