Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE68C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 11:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 086D620880
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 11:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="tz0aFF82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfDALo4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:44:56 -0400
Received: from mail-eopbgr30107.outbound.protection.outlook.com ([40.107.3.107]:64741
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfDALo4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 07:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PKaxtzcWSbZDfmEUxfffipod89bjasqMD7C14FOBKE=;
 b=tz0aFF828uCLEombS2BBJLW33TPbyYipumhRUSMNutdypvqID6Vkrj38zUsAY8cxVPIXi67prI6F6sN2e2qLsXVs26rQKsIvT/fRwmn6JImdQu6fwmn6szKf7jmw6kAx+59kws1Jgj6+wQ7YvFiqVfyMhw+AVY7P7YH15RbmWLg=
Received: from AM5PR0901MB1155.eurprd09.prod.outlook.com (10.167.221.149) by
 AM5PR0901MB0898.eurprd09.prod.outlook.com (10.167.218.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.22; Mon, 1 Apr 2019 11:44:52 +0000
Received: from AM5PR0901MB1155.eurprd09.prod.outlook.com
 ([fe80::3ce1:45ba:90be:a0e5]) by AM5PR0901MB1155.eurprd09.prod.outlook.com
 ([fe80::3ce1:45ba:90be:a0e5%4]) with mapi id 15.20.1750.017; Mon, 1 Apr 2019
 11:44:52 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Jordan Glover <Golden_Miller83@protonmail.ch>,
        Vitaly Chikunov <vt@altlinux.org>
CC:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Should we consider removing Streebog from the Linux Kernel?
Thread-Topic: Should we consider removing Streebog from the Linux Kernel?
Thread-Index: AQHU4sWwUj3VtGfBQkiED74NdqjOzKYb2puAgAqGLACAAL5OgIAADQKAgAALCkA=
Date:   Mon, 1 Apr 2019 11:44:52 +0000
Message-ID: <AM5PR0901MB115597BC2754E1B388AF15F2D2550@AM5PR0901MB1155.eurprd09.prod.outlook.com>
References: <20190325044550.GI5675@mit.edu>
 <20190325060041.wl23bncqjab7dj5c@altlinux.org>
 <20190331224329.GA681@sol.localdomain>
 <20190401100437.6tivlvp53zjprda6@altlinux.org>
 <LTLnFwnutvaWrlb3nFL9UEbwFqGlQPrULSlMM7Wli53B65WOofk1Vpp_ycEazJ3ore49c12K7UsDVHIOf8xuN5tepSyH0b-8zmP4gELpaVo=@protonmail.ch>
In-Reply-To: <LTLnFwnutvaWrlb3nFL9UEbwFqGlQPrULSlMM7Wli53B65WOofk1Vpp_ycEazJ3ore49c12K7UsDVHIOf8xuN5tepSyH0b-8zmP4gELpaVo=@protonmail.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fd6f4f3-d061-4837-c19c-08d6b6977401
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:AM5PR0901MB0898;
x-ms-traffictypediagnostic: AM5PR0901MB0898:
x-microsoft-antispam-prvs: <AM5PR0901MB08986FF44EEA56F065677C85D2550@AM5PR0901MB0898.eurprd09.prod.outlook.com>
x-forefront-prvs: 0994F5E0C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(366004)(376002)(346002)(396003)(136003)(199004)(189003)(446003)(476003)(486006)(66066001)(11346002)(86362001)(256004)(14444005)(5660300002)(25786009)(76176011)(74316002)(33656002)(53936002)(52536014)(6436002)(9686003)(55016002)(97736004)(81166006)(81156014)(2906002)(8676002)(7736002)(4326008)(229853002)(305945005)(8936002)(7696005)(99286004)(6116002)(478600001)(3846002)(110136005)(6246003)(68736007)(316002)(54906003)(71200400001)(93886005)(71190400001)(105586002)(106356001)(14454004)(186003)(26005)(6506007)(53546011)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM5PR0901MB0898;H:AM5PR0901MB1155.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: btqNxdyvGurm4RoePQjhGzbk7vWjPHcfjg4qnRVW7W5CXcYYpnjtpTs2Qy+ZacjANKKxfqbXQ3XpNF7NaQR8j4bRScsxdo9jWiLTGXkMl7fEVTWoVTQuvIjvsQ2qNC8khxF1sw5JGCUSHjoyKdbJjdkLAIk6/aAZMDh40/Q4vq+p18wD8j9nkUxQRSy0G5EqeL5Fy6bJyYG4irv7NwUc3vCGdjAM0njswpYHgukVmLu0lKX5p+0wi13ma5U161ilYhdwyd3BJEoikMy5t87AMxxiGz35SZG/LGYgRT0pcglP1oHCULfYwLdEF4aU1LFfr/V+SVdqZNuPVBM8mhmJePfg3vhFCVkGnSvsiZFJnTT+LUdp5ENdu7Ok6ylRBlM5Sqmok4e5XNlgyqodxCGhniaUUixt8h6mjvqSEYYrwH4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd6f4f3-d061-4837-c19c-08d6b6977401
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2019 11:44:52.0971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0901MB0898
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBNb25kYXksIEFwcmlsIDEsIDIwMTkgMTA6MDQgQU0sIFZpdGFseSBDaGlrdW5vdiA8dnRA
YWx0bGludXgub3JnPiB3cm90ZToNCj4NCj4gPiA+DQo+ID4gPiBDYW4geW91IGVsYWJvcmF0ZSBv
biB3aHkgeW91IHdhbnQgdG8gdXNlIFN0cmVlYm9nPyBXaGVuIHdlIGFkZGVkDQo+ID4gPiBTcGVj
aywgd2UgZXhwbGFpbmVkIGluIGdyZWF0IGRldGFpbCB3aHkgaXQgd2FzIHVzZWZ1bCBmcm9tIGEN
Cj4gPiA+IHRlY2huaWNhbCBwZXJzcGVjdGl2ZSAoYmVmb3JlIEFkaWFudHVtIHdhcyByZWFkeSku
IEkgZG9uJ3Qgc2VlIGFueSBzdWNoDQo+IGV4cGxhbmF0aW9uIGZvciBTdHJlZWJvZy4NCj4gPg0K
PiA+IE91ciB1c2VycyBkZW1hbmQgdGhhdCBmaWxlIGludGVncml0eSBpcyBpbXBsZW1lbnRlZCB1
c2luZyB0aGVpcg0KPiA+IG5hdGlvbmFsIHN0YW5kYXJkIGFsZ29yaXRobS4NCj4gPg0KPiA+IFRo
YW5rcywNCj4NCj4gRG9lcyBpdCBtZWFuIHRoYXQgZXZlcnkgc3RhdGUgY2FuIGRlbWFuZCBmcm9t
IExpbnV4IGtlcm5lbCB0byBjYXJyeWluZyBjcnlwdG8NCj4gYWxnb3JpdGhtcyBvZiB0aGVpciBj
aG9pY2U/DQo+DQpJIGRvdWJ0IHRoYXQgc3RhdGVzIGNhbiBoYXZlIHRoYXQga2luZCBvZiBsZXZl
cmFnZSBvdmVyIHRoZSBtYWluIGxpbnV4IGtlcm5lbCwNCmJ1dCB0aGV5IERPIGhhdmUgdGhhdCBr
aW5kIG9mIGxldmVyYWdlIG92ZXIgbG9jYWwgY29tcGFuaWVzIGFuZCBpbmRpdmlkdWFscy4NCkFu
ZCBpdCBpcyBub3QgdW5jb21tb24gZm9yIHN0YXRlcyBub3QgIHRvIHRydXN0IGFueSAid2VzdGVy
biIgY3J5cHRvIGFuZA0KKm1hbmRhdGUqKCEpIHRoZSB1c2Ugb2Ygc3BlY2lmaWMgaG9tZS1ncm93
biBhbGdvcml0aG1zIGluc3RlYWQuDQpTbyBpZiB5b3UgbmVlZCB0byBmYWNpbGl0YXRlIHN1Y2gg
cmVxdWlyZW1lbnRzIGZyb20geW91ciBkZXZpY2UgaW5jb3Jwb3JhdGluZw0KTGludXgsIGl0J3Mg
dGVycmlibHkgY29udmVuaWVudCBmb3IgdGhvc2UgYWxnb3JpdGhtcyB0byBiZSBwYXJ0IG9mIHRo
ZSBtYWlubGluZSBrZXJuZWwuDQpBcyB0aGUgYWx0ZXJuYXRpdmUgd291bGQgYmUgdG8gZWl0aGVy
IG1haW50YWluIHRob3NlIG91dHNpZGUgb2YgdGhlIGtlcm5lbCB0cmVlDQpvciB0byBmb3JrIHRo
ZSBrZXJuZWwgaW4gaXRzIGVudGlyZXR5LCBjb25zaWRlcmluZyB5b3UgKm11c3QqIHN1cHBvcnQg
dGhlbS4NCg0KaS5lLiB5b3UgY2FuJ3QgYmxhbWUgdGhlbSBmb3IgdHJ5aW5nIC4uLiBhbmQgd2hh
dCBXT1VMRCBiZSBhIGdvb2QgcmVhc29uIGZvcg0KaW5jbHVkaW5nIGEgY2VydGFpbiBhbGdvcml0
aG0gYW55d2F5Pw0KDQpSZWdhcmRzLA0KUGFzY2FsLCBIVyBTZWN1cml0eSBBcmNoaXRlY3QNCg==
