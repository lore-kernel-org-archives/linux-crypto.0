Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D48EC28CC3
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 10:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75C37256D0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 10:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="gif+x5rk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE3KDB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 06:03:01 -0400
Received: from mail-eopbgr40125.outbound.protection.outlook.com ([40.107.4.125]:34786
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725440AbfE3KDB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 06:03:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1YYFxLS/dhsnjJRkEPefWdv3tIDakqRKeHwex3lOBw=;
 b=gif+x5rkzvcktgsU6LGgZ+cf6o487KcPkJo5IfR0HpC2zN+14y5E5QPOfBl6WqeeK3BEky5ftBDTIAKeZhaLBpyCjmPqJEWQKjC1RjY3vjp105hwH4tyhLys3qoxz12SNnTziXb0GsuQW2DIVkgfBUMn5758EuZuJBqglr4+4ug=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2344.eurprd09.prod.outlook.com (20.177.113.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 10:02:58 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 10:02:57 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Richard Weinberger <richard@nod.at>,
        Stephan Mueller <smueller@chronox.de>
CC:     david <david@sigma-star.at>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: Can an ahash driver be used through shash API?
Thread-Topic: Can an ahash driver be used through shash API?
Thread-Index: AQHVFihP88/NJMXnyUClc8VyHvQMd6aCJmgAgABlkgCAAOLFEA==
Date:   Thu, 30 May 2019 10:02:57 +0000
Message-ID: <AM6PR09MB3523027D7045FD96E9FE4C33D2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <729A4150-93A0-456B-B7AB-6D3A446E600E@sigma-star.at>
 <4256916.YlTHG9RRyR@tauon.chronox.de>
 <1331220190.73461.1559161310462.JavaMail.zimbra@nod.at>
In-Reply-To: <1331220190.73461.1559161310462.JavaMail.zimbra@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c174e36-7ec7-4a01-facc-08d6e4e5fdf0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB2344;
x-ms-traffictypediagnostic: AM6PR09MB2344:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2344578E5F88ECE3265AD2EED2180@AM6PR09MB2344.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39850400004)(396003)(136003)(366004)(199004)(189003)(186003)(68736007)(26005)(54906003)(3846002)(476003)(446003)(11346002)(110136005)(486006)(6506007)(2906002)(76176011)(8936002)(316002)(86362001)(81156014)(8676002)(52536014)(66066001)(7736002)(305945005)(81166006)(102836004)(74316002)(6116002)(64756008)(5660300002)(76116006)(14454004)(6436002)(71190400001)(71200400001)(53936002)(55016002)(6246003)(7696005)(99286004)(256004)(66476007)(66946007)(4326008)(229853002)(66556008)(66446008)(33656002)(73956011)(25786009)(14444005)(15974865002)(478600001)(9686003)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2344;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eUXdyixJRljCTsrfU9NmTVxYew1lHBia4DJ8R/rx/Aq/OSNBIP9YSWwz225aCXP6kP1GGfReKRQPJi7BBxtgMtXEbEIuEW+PlH0AiwmJYrBRl1AmcaHvN7PV0BH1vkefTPg2NKgbs6yB8ITPLGTqwI5KzjljPXp8kulMlEpEvon1UcE79v6hd1gdKR+vuK7iNX2t6dU82rsgY4t2PYWbuHsMsMX8yWZ3lP7g/i1BZsNsqOrfGB2tyffARwkpaV/PzuAOsI+T4XoZNk3/VUmRS63qkA5JVOKgGn99Vz7zA/6hbNadBFAD47FjzZ1H8q8yJqvbJhy4Snx5yJnIGpkMIfNILF4GGlsR8wQSzCb9gGUNWyO4Nd0g3FUDPJkA8u6Y+VbXScRIoMITUiXtgtyrIxtt9O67CjsLAqSAXcc6eHA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c174e36-7ec7-4a01-facc-08d6e4e5fdf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 10:02:57.4388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2344
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiA+DQo+ID4gVGhlIGNyeXB0b19hbGxvY19zaGFzaCB3aWxsIG9ubHkgaWRlbnRpZnkgY2lwaGVy
IGltcGxlbWVudGF0aW9ucyB0aGF0DQo+IHdlcmUNCj4gPiByZWdpc3RlcmVkIHdpdGggdGhlIENS
WVBUT19BTEdfVFlQRV9TSEFTSCBmbGFnLiBUaGF0IGZsYWcgaXMgc2V0IHdoZW4gYQ0KPiBjaXBo
ZXINCj4gPiBpcyByZWdpc3RlcmVkIHVzaW5nIGNyeXB0b19yZWdpc3Rlcl9zaGFzaC4NCj4gPg0K
PiA+IFRodXMsIGNpcGhlcnMgcmVnaXN0ZXJlZCB3aXRoIGNyeXB0b19yZWdpc3Rlcl9haGFzaCB3
aWxsIG5vdCBiZWFyIHRoaXMNCj4gZmxhZw0KPiA+IGFuZCB0aHVzIHdpbGwgbm90IGJlIGZvdW5k
IGJ5IHRoZSBhbGxvY2F0aW9uIGZ1bmN0aW9uLg0KPiANCj4gaXMgdGhlcmUgYSByZWFzb24gd2h5
IHdlIGRvbid0IGVtdWxhdGUgdGhlIHN5bmNocm9ub3VzIGZ1bmN0aW9uYWxpdHkNCj4gaW4gdGhl
IGNyeXB0byBBUEkgbGF5ZXIgaWYgYSBkcml2ZXIgaW1wbGVtZW50cyBvbmx5IHRoZSBhc3luYyBp
bnRlcmZhY2U/DQo+IA0KPiBPciBpcyBpdCBqdXN0IGEgbWF0dGVyIG9mIC1FTk9QQVRDSD8gOikN
Cj4gDQpXZWxsLCBvbmUgcmVhc29uIG1pZ2h0IGJlIHRoYXQgYXN5bmNocm9ub3VzIGltcGxlbWVu
dGF0aW9ucyBhcmUgdXN1YWxseQ0KaGFyZHdhcmUgYWNjZWxlcmF0b3JzIHRoYXQgcmVseSBvbiBt
YW55IG9wZXJhdGlvbnMgYmVpbmcgYmF0Y2ggcXVldWVkIGluDQpvcmRlciB0byBhY3R1YWxseSB1
c2VmdWxseSBhY2NlbGVyYXRlIGFueXRoaW5nIChkdWUgdG8gbGFyZ2UgbGF0ZW5jaWVzKS4NCldo
aWNoIHlvdSBjYW4ndCBkbyBmcm9tIHRoZSBzeW5jaHJvbm91cyBpbnRlcmZhY2UsIHNvIHlvdSdk
IGdldCBhIHNsb3cgZG93biwgDQpub3QgYSBzcGVlZCB1cC4gDQooQnV0IHNvbWUgcGVvcGxlIC0g
QWQgOi0pIC0gbWlnaHQgYXJndWUgdGhhdCB1c2luZyB0aGUgYWNjZWxlcmF0b3IgbWF5IHN0aWxs
DQpiZSB1c2VmdWwgdG8gb2ZmbG9hZCB0aGUgQ1BVLCByZWR1Y2UgcG93ZXIgY29uc3VtcHRpb24s
IGV0Yy4pDQoNCkluIGFueSBjYXNlLCBJIGRpZG4ndCByZWFsbHkga25vdyB0aGlzIGJ1dCBJJ20g
cXVpdGUgaGFwcHkgd2l0aCBpdC4gSWYgeW91DQp3YW50ICpwZXJmb3JtYW5jZSosIHlvdSBzaG91
bGRuJ3QgZW5kIHVwIGF0IGEgaC93IGFjY2VsZXJhdG9yIHdpdGggYSANCnN5bmNocm9ub3VzIEFQ
SS4gSWYgeW91IGRvIHdhbnQgdGhlIGgvdyBhY2NlbGVyYXRpb24sIHlvdSBjYW4gYWx3YXlzIHVz
ZQ0KdGhlIGFzeW5jaHJvbm91cyBBUEksIHNvIG5vdGhpbmcgbG9zdCB0aGVyZSwgeW91IGRvIGhh
dmUgYSBjaG9pY2UuDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAg
QXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgSW5zaWRlIFNlY3VyZQ0Kd3d3Lmlu
c2lkZXNlY3VyZS5jb20NCg==
