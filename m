Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB074C35640
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F7720578
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="b46+Wgfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgBUIjC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 03:39:02 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:14463
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729805AbgBUIjB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 03:39:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JboakKXBSxcg+N+Elz/x1ibHQTVi5LBydb4J9lm0XjazGg30+H9X0pjU8ph1V8saE4NErDmmAiaz4teaR3zdvw0GrAgWPP0IyidddkhXUa6Qzei1LGZlCRChZAZLBACtJpD1uNqSAgvaKjnWuOb1DPgj6h88C73llLalkzjUhWVZX5sfqaJgN3pgJqOwQaEH+Gn1YyLVVXklAH6Eu30ysHPY+UQnxQAb2G5Sj1dMDEL02jdKurjFKZHt/CdakH6XhwJWVsC3/psysgdvvCsp9efUMYnHy/v7VMhL3bHZieiF1kkLt37qa+u2ebJ2eiRWPcPI1Q8sz0iiOYpJPnju2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7hL3X74V/bYChiVFolNqJGsPb4Mixm/+IoZcnky78k=;
 b=ZqQ3I1IBJQeaDGA16tr9urTS7FssNCYLqxZCf3uL6OVcBNCsz0rgS9kElkzOlUDVv2s+OEB+Aa3vrqKkVnMT8CH/v08geXa6GrlAIe8Ras7yHbMaqZtpKJpmjEM46hoj2oJhhA0zIWZkJViH37NfFwgw/yuHd6sBB9o/JiB+bVcN2DlUYls8NM9utt5xnOSNtwZnh/3mhfoCXHqlC28miahDHj6yywizXK9GnN/iinC6wRktWDThjWRyWLdZVYcCIlpe9LxYQefV+3lgoLP0ilL6KPyGfOWILNzTGN9dmgIt9nnI/qpZb38mkUFmRHT6mOWDFxbKrawdQxrWky+ocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7hL3X74V/bYChiVFolNqJGsPb4Mixm/+IoZcnky78k=;
 b=b46+WgfdPCmmjQZ1CO//vTpiA1i6d6GibwyD5n+RBvnTdOl8kwkI8Nv66pXfeT+01OlSShW7zMPfJN96YbgOpK6shw49cj5/w0AOo08FdxagRvGq3dm4EcC2p+KHeP2fwloNN5/kHavVA6oMfFkYxdgjf7Y3Ez423SDW+w1EyDo=
Received: from DBBPR04MB6025.eurprd04.prod.outlook.com (20.179.43.215) by
 DBBPR04MB6233.eurprd04.prod.outlook.com (20.179.43.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 21 Feb 2020 08:38:59 +0000
Received: from DBBPR04MB6025.eurprd04.prod.outlook.com
 ([fe80::b978:17a1:d649:85b8]) by DBBPR04MB6025.eurprd04.prod.outlook.com
 ([fe80::b978:17a1:d649:85b8%5]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 08:38:59 +0000
From:   Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] crypto: caam/qi2 - fix chacha20 data size error
Thread-Topic: [PATCH] crypto: caam/qi2 - fix chacha20 data size error
Thread-Index: AQHV6IvXVLFeSwTUXUy7oMx87mqcQaglU0KA
Date:   Fri, 21 Feb 2020 08:38:59 +0000
Message-ID: <DBBPR04MB602554E638B8CA1B9B809F6BFE120@DBBPR04MB6025.eurprd04.prod.outlook.com>
References: <20200221075201.5725-1-horia.geanta@nxp.com>
In-Reply-To: <20200221075201.5725-1-horia.geanta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=valentin.ciocoi@nxp.com; 
x-originating-ip: [46.97.170.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83bc6a89-0943-4a07-a684-08d7b6a97efc
x-ms-traffictypediagnostic: DBBPR04MB6233:|DBBPR04MB6233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB6233046D4C8C80A747268F82FE120@DBBPR04MB6233.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(54906003)(6506007)(66446008)(66556008)(8936002)(4326008)(53546011)(7696005)(66476007)(8676002)(110136005)(64756008)(81166006)(71200400001)(81156014)(26005)(5660300002)(86362001)(66946007)(52536014)(2906002)(9686003)(55016002)(478600001)(33656002)(316002)(186003)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR04MB6233;H:DBBPR04MB6025.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHUZfwtvcw6ThLhJt10OHjEeRosAApqOQLKYdiXhAeVEJ9EukP7K8SyWj9mkw68eEcW3kRez7Eeer8V8tdM3xdnvOtXQeOZziCnaZLKtdCq5WxwSkERC/l4XHVBlbr9paRS6msXlxGCBnW0wlKxrG34+IFOCyjyPTFpYOZxTJ5kUg+RVPZ+16sv0Ggjp6vlsfmqqaF4nxRrywWLZa7hfmKZFBubC18+xgsKOjf0GzwCyWpPva6rh8rlrZEtuxTCaVf3s3Ci9MOUq08pkHqt1LR7o4fMI6jaCsPF+MxnIv7oUeabzhY86Af3K+aJbtGHsxc9PRGUXAkupqXK+iwqfFoFtz8jvXkGoT9SoeU3lOtJFNwvlnRVXqwZUF0JbOM/XAfOBlqeUt3uiNtNMem6El3L8N6QOvzI04PwlJ8NkSq4kiWynQzQFxwuCt2ppmLs5
x-ms-exchange-antispam-messagedata: zYHfcAtUmRcccOJc0P7qVtQgA3wGtKeCZ0eP1UQLcnsFSY/Dzp5vMINDJ06t7R3Lehgq2zyZaRvaQl+orzRGTq2yCh24K0Kad7eM9FSE0t/pr+Zm2bQoauEe1xyA5BASv9hg2E5vcj9J+cSbaVgBVA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bc6a89-0943-4a07-a684-08d7b6a97efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 08:38:59.0770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t6xzjydRdyBLi6+23gJOqlf1Li17Apl9WTWF28IrJAgaRyJBQH72eJh+2YhQ5ul3pJGt87Uqv67pW1PDW9gT3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6233
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIb3JpYSBHZWFudMSDIDxob3Jp
YS5nZWFudGFAbnhwLmNvbT4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyMSwgMjAyMCAwOTo1
Mg0KPiBUbzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDYzog
RGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQXltZW4gU2doYWllcg0KPiA8
YXltZW4uc2doYWllckBueHAuY29tPjsgVmFsZW50aW4gQ2lvY29pIFJhZHVsZXNjdQ0KPiA8dmFs
ZW50aW4uY2lvY29pQG54cC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBkbC1s
aW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIGNyeXB0
bzogY2FhbS9xaTIgLSBmaXggY2hhY2hhMjAgZGF0YSBzaXplIGVycm9yDQo+IA0KPiBIVyBnZW5l
cmF0ZXMgYSBEYXRhIFNpemUgZXJyb3IgZm9yIGNoYWNoYTIwIHJlcXVlc3RzIHRoYXQgYXJlIG5v
dA0KPiBhIG11bHRpcGxlIG9mIDY0Qiwgc2luY2UgYWxnb3JpdGhtIHN0YXRlIChBUykgZG9lcyBu
b3QgaGF2ZQ0KPiB0aGUgRklOQUwgYml0IHNldC4NCj4gDQo+IFNpbmNlIHVwZGF0aW5nIHJlcS0+
aXYgKGZvciBjaGFpbmluZykgaXMgbm90IHJlcXVpcmVkLA0KPiBtb2RpZnkgc2tjaXBoZXIgZGVz
Y3JpcHRvcnMgdG8gc2V0IHRoZSBGSU5BTCBiaXQgZm9yIGNoYWNoYTIwLg0KPiANCj4gW05vdGUg
dGhhdCBmb3Igc2tjaXBoZXIgZGVjcnlwdGlvbiB3ZSBrbm93IHRoYXQgY3R4MV9pdl9vZmYgaXMg
MCwNCj4gd2hpY2ggYWxsb3dzIGZvciBhbiBvcHRpbWl6YXRpb24gYnkgbm90IGNoZWNraW5nIGFs
Z29yaXRobSB0eXBlLA0KPiBzaW5jZSBhcHBlbmRfZGVjX29wMSgpIHNldHMgRklOQUwgYml0IGZv
ciBhbGwgYWxnb3JpdGhtcyBleGNlcHQgQUVTLl0NCj4gDQo+IEFsc28gZHJvcCB0aGUgZGVzY3Jp
cHRvciBvcGVyYXRpb25zIHRoYXQgc2F2ZSB0aGUgSVYuDQo+IEhvd2V2ZXIsIGluIG9yZGVyIHRv
IGtlZXAgY29kZSBsb2dpYyBzaW1wbGUsIHRoaW5ncyBsaWtlDQo+IFMvRyB0YWJsZXMgZ2VuZXJh
dGlvbiBldGMuIGFyZSBub3QgdG91Y2hlZC4NCj4gDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4gIyB2NS4zKw0KPiBGaXhlczogMzM0ZDM3YzllMjYzICgiY3J5cHRvOiBjYWFtIC0gdXBk
YXRlIElWIHVzaW5nIEhXIHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBIb3JpYSBHZWFudMSD
IDxob3JpYS5nZWFudGFAbnhwLmNvbT4NCg0KVGVzdGVkLWJ5OiBWYWxlbnRpbiBDaW9jb2kgUmFk
dWxlc2N1IDx2YWxlbnRpbi5jaW9jb2lAbnhwLmNvbT4NCg0K
