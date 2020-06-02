Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A12BC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 15:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7365320757
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 15:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="GOf2Omzd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFBP7q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 11:59:46 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:53984
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbgFBP7q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 11:59:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGMbFKZwDhFJHPTxODIBu/Lz8cZ7NZBPOQFAgiDHmlpX5GxhPZZ0QL9zNMJSpelt5IGaojjOHbTTEsYDbVmw+QPJx4Hkxwf/h4yb4aOvLuLb9gHUZEkApMXqwxgj3m6v2pvkDH12rzjpw0RTebiRf9YWtTnypBXyn0NCZRjAYJh9Dg6o9HAaanQHeX/xLq6TbpqO4UF0MnvMmIxSzULyxHqIgDt+YxowwPXAoVBexkzScjJax2y3iio0TAx4MiBRCTpiLt4RJrAcOvMxUn0e7/a78e/nEsgWqofWck5iIfXBuM8f+uQTsm4CuTbsTZhTw9nyvSyZKX5zZBs2TWXjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiPJavAvqE7B0wQWVFt1fbDgB4sf8PCfWdhpl8edDoQ=;
 b=cwOS2tI7zZUptgv1EEir8J2KEEmAOSh87fo79ODSdZAlP5ixPOUuK11C3FKqjiiFR6gSfi7d7519l1c9SgnyzeIsuDRXn/mljWC2B3Wx76egXevciFK9hLpbUWE4LqUzhR1B6BrcejBuXLvDwe+PYxwAE3gED4uehNN0YVu41HJPThtWiOOucG/Qn3VnOiYGXPQvKdsVZp4v22K80LZMtcI2XdKrQsL6GTSxCPpJMAFQjJGOw3vkkPPyc52hKcLZj3nR1acIgyZAvt9XD97jmo3ejIk+lsOTdzXS31gllHtm4raTnJqRrxz4lVY/IGKHdTx8jFGe8K4y9q3C174Zew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiPJavAvqE7B0wQWVFt1fbDgB4sf8PCfWdhpl8edDoQ=;
 b=GOf2OmzdCv+Lttr6G4SSsOnpTLmSWlBRor5IwvEUyXXmkEohTrZSyLkR50F9Ho30v6RgzSrap0GrCjZjg3aKJXRBOIxyW5baMGSRZYPd66NBGXznXiY92x4oCg8L9KnBVRQ2yjf9SLA5wA3GaoXtOObArMpSnjSZTvLXygF0YV0=
Received: from CY4PR19MB0997.namprd19.prod.outlook.com (2603:10b6:903:a7::16)
 by CY4PR19MB0966.namprd19.prod.outlook.com (2603:10b6:903:a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 15:59:41 +0000
Received: from CY4PR19MB0997.namprd19.prod.outlook.com
 ([fe80::28b5:6f9f:d1c8:3d4]) by CY4PR19MB0997.namprd19.prod.outlook.com
 ([fe80::28b5:6f9f:d1c8:3d4%5]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 15:59:40 +0000
From:   Sebastien Buisson <sbuisson@ddn.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Sebastien Buisson <sbuisson.ddn@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sebastien Buisson <sbuisson@ddn.com>
Subject: Re: [PATCH] crypto: add adler32 to CryptoAPI
Thread-Topic: [PATCH] crypto: add adler32 to CryptoAPI
Thread-Index: AQHWNRG3Iy7sg4SP2UyGDOcR1goiz6jDXh4AgAIlYwA=
Date:   Tue, 2 Jun 2020 15:59:40 +0000
Message-ID: <B28A02E7-BE74-4ACE-981F-0CE47AC80CFE@ddn.com>
References: <20200528170051.7361-1-sbuisson@whamcloud.com>
 <20200601071320.GE11054@sol.localdomain>
In-Reply-To: <20200601071320.GE11054@sol.localdomain>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=ddn.com;
x-originating-ip: [77.147.201.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5575e6dd-c082-4d2d-a82e-08d8070df599
x-ms-traffictypediagnostic: CY4PR19MB0966:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR19MB09665FB8C375A8B34CF172D3D78B0@CY4PR19MB0966.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHL/boYgNqqO5ZhRXJpWW78VXneNtTxPbpCEonYRSIGRGfi2ZS8oH0zaAc8XN1/++YaYygvP1hXpSOh8Cuy/54sAV9hfBLbOZ5HZWHAN2V+bJ4SVR2Pmvr8fos95xujjMtd5h0K9smGM2S1ExIo5UoYGGEAM5vEKTiarGinzZazGMWxKc1B1ZkzW7t+ufkK6OBLzvNmqyITIL+s1OqYCNos7Rj6J0lAYYFwzSixV7s0kwrMpBcnufn6OyIv4V4GHUmMrcLc0OawGXrPVLOT8x3Ixgpe7i3vRM4CWr2lEJB/6GhcXiKmvtPTSR3DfsdYA9VDzOPNHmYtzWrY4tXCfTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR19MB0997.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39850400004)(396003)(366004)(346002)(376002)(71200400001)(4326008)(2906002)(66446008)(2616005)(66946007)(91956017)(76116006)(66476007)(66556008)(64756008)(8936002)(4744005)(8676002)(6916009)(33656002)(5660300002)(316002)(186003)(54906003)(36756003)(6486002)(478600001)(6512007)(6506007)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: L/T1AWAXuabpeDtLQBWQ7mLjSZVkHvRZ0hVXuszVZh/YX4gbUeTxKguTGBuORCsiJMAsS2LHKjXMdrNGX8WxAmShnvcFtSoqqbjOreF/AzaOb40JKbDESYowemC/WzsIy4uY08ocs+YidO12jqM6kTEaqFAArDM6NtctK6CCYX4ngp1B8bSrpBgPq2PafperbS8hg7TzeEJPdzTkCsRb1PGiosaOJoQk77TQP4dzxtEmzeq5DvCbyCrrHRMKbdImyWsa3n8HsJJkMLZw5Zwf0JhS6Z6AAroWzKUgs9b8WeGWL9EeCxgQU2nWLS4jSuK13iA1jyXDHzhRoHyB1u//o+MvWjx6Q83y/1Tnr3OsBGrUOnyF2orIYVK8hHPYLVabapP4FCh8utm6tWk4cMbwVwNtPqosQwbhQeZjeqrGRy9c0mOjaiCylHMad9XgSjk9yCxlSne4dxecUo80xC8Kmk1G8QI306wC8vNxD5REAWc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA9DA79AA643CA4DBFF223F9FE12620E@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5575e6dd-c082-4d2d-a82e-08d8070df599
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 15:59:40.8093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwYEVffexwGZibgswixMmkvZ5V3/TYJWuLelnCfkKBsqyAgJCmi+tjXzxUYKkrSD7s1izt4Wri4ktuy5JcYlFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR19MB0966
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IExlIDEganVpbiAyMDIwIMOgIDA5OjEzLCBFcmljIEJpZ2dlcnMgPGViaWdnZXJzQGtlcm5l
bC5vcmc+IGEgw6ljcml0IDoNCj4gDQo+IE9uIFRodSwgTWF5IDI4LCAyMDIwIGF0IDA3OjAwOjUx
UE0gKzAyMDAsIHNidWlzc29uLmRkbkBnbWFpbC5jb20gd3JvdGU6DQo+PiBGcm9tOiBTZWJhc3Rp
ZW4gQnVpc3NvbiA8c2J1aXNzb25Ad2hhbWNsb3VkLmNvbT4NCj4+IA0KPj4gQWRkIGFkbGVyMzIg
dG8gQ3J5cHRvQVBJIHNvIHRoYXQgaXQgY2FuIGJlIHVzZWQgd2l0aCB0aGUgbm9ybWFsIGtlcm5l
bA0KPj4gQVBJLCBhbmQgcG90ZW50aWFsbHkgYWNjZWxlcmF0ZWQgaWYgYXJjaGl0ZWN0dXJlLXNw
ZWNpZmljDQo+PiBvcHRpbWl6YXRpb25zIGFyZSBhdmFpbGFibGUuDQo+PiANCj4+IFNpZ25lZC1v
ZmYtYnk6IFNlYmFzdGllbiBCdWlzc29uIDxzYnVpc3NvbkB3aGFtY2xvdWQuY29tPg0KPj4gLS0t
DQo+PiBjcnlwdG8vS2NvbmZpZyAgICAgICAgfCAgIDcgKw0KPj4gY3J5cHRvL01ha2VmaWxlICAg
ICAgIHwgICAxICsNCj4+IGNyeXB0by9hZGxlcjMyX3psaWIuYyB8IDExNyArKysrKysrKysrKysr
KysrDQo+PiBjcnlwdG8vdGVzdG1nci5jICAgICAgfCAgIDcgKw0KPj4gY3J5cHRvL3Rlc3RtZ3Iu
aCAgICAgIHwgMzYyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+PiA1IGZpbGVzIGNoYW5nZWQsIDQ5NCBpbnNlcnRpb25zKCspDQo+PiBjcmVhdGUg
bW9kZSAxMDA2NDQgY3J5cHRvL2FkbGVyMzJfemxpYi5jDQo+IA0KPiBEaWQgeW91IGFjdHVhbGx5
IHJ1biB0aGUgc2VsZi10ZXN0cyBmb3IgdGhpcz8gIFRoZXkgZmFpbCBmb3IgbWUuDQoNCkkgd2Fz
IHdvbmRlcmluZyBob3cgdG8gcnVuIHRlc3RtZ3IgdGVzdHMgYWxvbmU/DQo=
