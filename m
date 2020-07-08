Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A455C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 13:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC832078D
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 13:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="T1YNy9NR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgGHNfx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 09:35:53 -0400
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:42900 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbgGHNfx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 09:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1594215351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tm84vDr942HcFGtOTKdtg7Ig535+iEqYPMVmzpDehoY=;
        b=T1YNy9NR3f+vOHKS+R1VyiZXmYuh1hB0XgOTdWrBnBNgIfpRo8eMujp9wrF0X43zSIzFKq
        tHC/AOzqUv7csFO2jekM50VYAi937yx7uTsTTjZW6+sWRY8tPVzDn5rRhMMYJiD80jK4dO
        67zxS9Jy/SyzvQhq7MNN9Tim0nZbKYo=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-DTlfygeqPpKqOT1nQum_qQ-1; Wed, 08 Jul 2020 09:35:47 -0400
X-MC-Unique: DTlfygeqPpKqOT1nQum_qQ-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0839.namprd04.prod.outlook.com
 (2603:10b6:903:e9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 8 Jul
 2020 13:35:44 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8%3]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 13:35:44 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Ard Biesheuvel <ardb@kernel.org>
Subject: RE: question regarding crypto driver DMA issue
Thread-Topic: question regarding crypto driver DMA issue
Thread-Index: AdZVBDBo9ipAzqBdRAO9+tIch7rFqAAA++kAAAkGgoA=
Date:   Wed, 8 Jul 2020 13:35:44 +0000
Message-ID: <CY4PR0401MB3652D4CA49D9ECBE9FC150B0C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <CY4PR0401MB3652172E295BA60CBDED9EE8C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <CAMj1kXFGPkpaKy9NunG0sefv3bc+ETDu6H2T8RcQaKAk+tTMJg@mail.gmail.com>
In-Reply-To: <CAMj1kXFGPkpaKy9NunG0sefv3bc+ETDu6H2T8RcQaKAk+tTMJg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aca0ceb4-7a67-4eec-9db2-08d82343d0ba
x-ms-traffictypediagnostic: CY4PR04MB0839:
x-microsoft-antispam-prvs: <CY4PR04MB0839CD0CC7091DB93792754DC3670@CY4PR04MB0839.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JLFPEYzkYGfiezhQk7ebksHDp1ql3PbH0OVphyWSMEnRlkhD7lDeU91MLQD8d93ILK7ovm0C4XTTxGnet0GKhGZPRXFmect2lDazdwHKBOvBW7uyuQwnbLlz7l++q5MLSAmaHGOnnei4Lh0NfAdivV8Wgbc/ToDd4qR2Gt1JB89YXgxTG6ZkDxbv+itUhjPYnTI/cQZiyD5y6mxtWvthSiAtUA3uVnpNEgrzVyFPBv2d0ksmrabXs6DkUGhqqc290sanfNKlKsCSprsKdZpgiLzJ825ZIqAQAvxpH9fdhEu1qZFrLeeVLM+cNlGQi4ub5TQXRocDTlWlDeiDEh96Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(136003)(366004)(376002)(346002)(66446008)(71200400001)(8676002)(26005)(316002)(66476007)(7696005)(55016002)(66556008)(64756008)(66946007)(83380400001)(76116006)(9686003)(4326008)(6506007)(52536014)(2906002)(186003)(6916009)(33656002)(478600001)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cVpDHwDfgG9RN/P6yH2tXFoKPzVpg0fQfteITz7shUcz54KFgd8ArTT7EXBz0JROAqS9WU+ztvTeaqGvoaScRYuROMQ+yx5gnzith+tHIpsfn0G1t0gl0fFM6yIbQT74gSp74/KyXr9l7QFbtPKv8FMR85y2Gwn4pdGyQzmYPwmf3+sYfSm++viieGE0Wrg5PcQK/zL6bOMICpQP8cml4teFx5when/js+i3kj/sXPRJvdXH3RzurjsIx0GX/9Zo6xYMwPVFqXW5lX/e2c3xdoQApJXPe38P6C/A75BZZONXIbo5SLNQdKRR6/75AG5iOt/Z0N45vyP7REbr0pQTJRtElIr8pijVDzr++l9SsIIESI/baCsFg6PErRvn0Hc6juggwSMtH7wRbU9U07BFHzGCJE97wemDFGTj8NjobPCxccQUnrjA7a0TVpCFOd5WwdH+wAiyRJxomiIgXQmhjwaLdT5PSkGyshLelc0rVae8OQ3JJ2xim5TeR/EGnukW
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca0ceb4-7a67-4eec-9db2-08d82343d0ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 13:35:44.2958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Ov4eYhd3dz3AaxDip5jAsAtn9AmZjg0KwJrXt4wk44SW4LJaQsJmv7nW3dsjZQhH0UIZ09Qbwrd3sCJnO+wAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0839
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQXJkLA0KDQpUaGFua3MgZm9yIHJlc3BvbmRpbmchDQoNCj4gPiBGb3IgdGhlIHNpdHVhdGlv
biB3aGVyZSB0aGlzIHByb2JsZW0gaXMgb2NjdXJpbmcsIHRoZSBhY3R1YWwgYnVmZmVycyBhcmUg
c3RvcmVkIGluc2lkZQ0KPiA+IHRoZSBhaGFzaF9yZXEgc3RydWN0dXJlLiBTbyBteSBxdWVzdGlv
biBpczogaXMgdGhlcmUgYW55IHJlYXNvbiB3aHkgdGhpcyBzdHJ1Y3R1cmUgbWF5DQo+ID4gbm90
IGJlIERNQS1hYmxlIG9uIHNvbWUgc3lzdGVtcz8gKGFzIEkgaGF2ZSBhIGh1bmNoIHRoYXQgbWF5
IGJlIHRoZSBwcm9ibGVtIC4uLikNCj4gPg0KPg0KPiBJZiBETUEgaXMgbm9uLWNvaGVyZW50LCBh
bmQgdGhlIGFoYXNoX3JlcSBzdHJ1Y3R1cmUgaXMgYWxzbyBtb2RpZmllZA0KPiBieSB0aGUgQ1BV
IHdoaWxlIGl0IGlzIG1hcHBlZCBmb3IgRE1BLCB5b3UgYXJlIGxpa2VseSB0byBnZXQgYQ0KPiBj
b25mbGljdC4NCj4NCkFoIC4uLiBJIGdldCBpdC4gSWYgSSBkbWFfbWFwIFRPX0RFVklDRSB0aGVu
IGFsbCByZWxldmFudCBjYWNoZWxpbmVzIGFyZSBmbHVzaGVkLCB0aGVuDQppZiB0aGUgQ1BVIGFj
Y2Vzc2VzIGFueSBvdGhlciBkYXRhIHNoYXJpbmcgdGhvc2UgY2FjaGVsaW5lcywgdGhleSBnZXQg
cmVhZCBiYWNrIGludG8NCnRoZSBjYWNoZS4gQW55IHN1YnNlcXVlbnQgYWNjZXNzIG9mIHRoZSBh
Y3R1YWwgcmVzdWx0IHdpbGwgdGhlbiByZWFkIHN0YWxlIGRhdGEgZnJvbQ0KdGhlIGNhY2hlLg0K
DQo+IEl0IHNob3VsZCBoZWxwIGlmIHlvdSBhbGlnbiB0aGUgRE1BLWFibGUgZmllbGRzIHN1ZmZp
Y2llbnRseSwgYW5kIG1ha2UNCj4gc3VyZSB5b3UgbmV2ZXIgdG91Y2ggdGhlbSB3aGlsZSB0aGV5
IGFyZSBtYXBwZWQgZm9yIHdyaXRpbmcgYnkgdGhlDQo+IGRldmljZS4NCj4NClllcywgSSBndWVz
cyB0aGF0IGlzIHRoZSBvbmx5IHdheS4gSSBhbHNvIHRveWVkIHdpdGggdGhlIGlkZWEgb2YgdXNp
bmcgZGVkaWNhdGVkIHByb3Blcmx5DQpkbWFfYWxsb2MnZWQgYnVmZmVycyB3aXRoIHBvaW50ZXJz
IGluIHRoZSBhaGFzaF9yZXF1ZXN0IHN0cnVjdHVyZSwgYnV0IEkgZG9uJ3Qgc2VlIGhvdw0KSSBj
YW4gYWxsb2NhdGUgcGVyLXJlcXVlc3QgYnVmZmVycyBhcyB0aGVyZSBpcyBubyBjYWxsYmFjayB0
byB0aGUgZHJpdmVyIG9uIHJlcSBjcmVhdGlvbi4NCg0KU28gLi4uIGlzIHRoZXJlIGFueSBtYWdp
Y2FsIHdheSB3aXRoaW4gdGhlIExpbnV4IGtlcm5lbCB0byBjYWNoZWxpbmUtYWxpZ24gbWVtYmVy
cyBvZg0KYSBzdHJ1Y3R1cmU/IENvbnNpZGVyaW5nIGNhY2hlbGluZSBzaXplIGlzIHZlcnkgc3lz
dGVtLXNwZWNpZmljPw0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQ
IEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1
cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2Vj
dXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBS
YW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBi
b29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQg
YW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNp
cGllbnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFs
IGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9m
IHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcs
IGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBh
dHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1
cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

