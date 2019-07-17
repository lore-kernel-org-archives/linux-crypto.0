Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C50C76186
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 10:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CAEA20880
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 10:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Ue7Fkbij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfGQKYT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 06:24:19 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:34691
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbfGQKYS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 06:24:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqOKAgg1fsb3AasGy3uISNMCDfc0VEk4uhBGMCeB7H63ndQj3D7zGeM3L5Qfrz5EjSaikpKzEx0uy0kA+VZGlzlEHDD9NZEtmO6PREmm5Hy3yjZjt83fdqhGWG/s85Y0fVhOWiv4YQXW0nilx2K+e7t3LTYc+73cl9LuAxOY2KsGIUQw4ogyOFgKYQ5mpwGtVFETvCn1vviVaS+5HB8mv3bH3oa8FCRFcfEXsSKrr0DGnk3R8H3ocs4d9VUf+GdBoz9zzZZVw7blc8LLmbvEhQPJdfCl0E78+F4rJdoXXGUqUmQSM4G1x4IxHQR+eugzKog5cqXlOlFLzMMIft17QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPaPT2czoME/hYVRz4ZLl0n89PINpuSoCKA/T7QGlF4=;
 b=Fpzk8G6usP/bnKBwfNjFXg08Agb8mp+EpngGgd2GXzrse0IZNLYGwuB8evqNCRFvLfx2PDM9R/c/IW9Ky8DmBbRomNTLPwE3i5YOtjbVgXwXdDShegTyjasm30jc8Ulo4bRWvFdL+K8TK+kLRtmEI9usS0RFmb9gl61BIY1Sz7hFOs4Nh4GnlII8uazFZelabo0WH4Obf8zsoRJQekg1wyrEOsUC/queeVSlM+4Ad1djhkoKVNdO/v9arHDivpU6/jW1Q5+6X82pNM0Cqypub6JD1QCtBwcLVVLkRcK9qg9fz/TfeIlplE7X2FCR3d8QJYwwP+UqLspori9B5cTRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPaPT2czoME/hYVRz4ZLl0n89PINpuSoCKA/T7QGlF4=;
 b=Ue7FkbijxvzpDw8xpkI2pe7Q1PWtdUkJP97djwHd1rVDVtE9ZXaorNIsuWVSVPYVFShdVFsy1cIH28OdU/HRfZle7zupnMVMPCRMifWAhSAtq+yG/II3ChFpNLNwpJT+tFSkniF/fzHbFg0WCLUJkapMIvScScA1Kb+XuRpErwc=
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com (52.134.92.158) by
 AM0PR04MB6306.eurprd04.prod.outlook.com (20.179.33.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Wed, 17 Jul 2019 10:24:14 +0000
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::7882:51:e491:8431]) by AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::7882:51:e491:8431%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 10:24:14 +0000
From:   Aisheng Dong <aisheng.dong@nxp.com>
To:     Anson Huang <anson.huang@nxp.com>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "rfontana@redhat.com" <rfontana@redhat.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 1/2] char: hw_random: imx-rngc: use
 devm_platform_ioremap_resource() to simplify code
Thread-Topic: [PATCH 1/2] char: hw_random: imx-rngc: use
 devm_platform_ioremap_resource() to simplify code
Thread-Index: AQHVPH/7DE8H1hoPXUqVaCkN1Qua16bOmm/g
Date:   Wed, 17 Jul 2019 10:24:14 +0000
Message-ID: <AM0PR04MB4211FB9C3F6247BD9D3F16D580C90@AM0PR04MB4211.eurprd04.prod.outlook.com>
References: <20190717090438.31522-1-Anson.Huang@nxp.com>
In-Reply-To: <20190717090438.31522-1-Anson.Huang@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aisheng.dong@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63dba6aa-c8a0-4836-2306-08d70aa0eabb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB6306;
x-ms-traffictypediagnostic: AM0PR04MB6306:
x-microsoft-antispam-prvs: <AM0PR04MB6306EF46DFB2302BC059046180C90@AM0PR04MB6306.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(199004)(189003)(7416002)(81166006)(81156014)(446003)(74316002)(2501003)(7736002)(25786009)(64756008)(66946007)(66476007)(66556008)(66446008)(86362001)(8936002)(478600001)(558084003)(68736007)(76116006)(316002)(8676002)(110136005)(53936002)(76176011)(55016002)(5660300002)(6436002)(3846002)(4326008)(6116002)(66066001)(33656002)(52536014)(7696005)(11346002)(476003)(14454004)(2906002)(71190400001)(44832011)(305945005)(486006)(71200400001)(9686003)(6246003)(229853002)(186003)(102836004)(26005)(6506007)(2201001)(256004)(99286004)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6306;H:AM0PR04MB4211.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pESA92BjbljArhySGbx3ge47Yi/fKGqy+nUmDti0gddT3wMJU3SmCHuXmTfIPEjGqtT1eNhRR11YqUItyA9xZu+MHXM+mTTyXqrztD5zH8rQ9cUlVXV9HF3886lhpZasi4o10zrpYicfaEXQFFqYpLFO/7CC8ZMO9wfgFZ/TokYzGgu7uxbEqVNN5CJegU/B6VNHoDIJGEhZ3dUNZN/CDxjn8oqk6e9ZZSZW3xbLxNv/9QDkr7AcuBCQxb1Fov+mh0u2NAV98ji704aoSBDOAZXmLCB0yIkWFdWwLWyYLs/fsAMfwS/bQ081HqYZzFYpPFTAPfqo++NIfZ4B0DQ6pvS97Igl3vzpXBhhjYCcs/J6Ay8HzDq4JwElNpBY1cv2e+NBUeABrvEZScOwmFN1ZF3A2/KAYB23s1s1anxQN/Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63dba6aa-c8a0-4836-2306-08d70aa0eabb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 10:24:14.4642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aisheng.dong@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6306
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBGcm9tOiBBbnNvbi5IdWFuZ0BueHAuY29tIDxBbnNvbi5IdWFuZ0BueHAuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIEp1bHkgMTcsIDIwMTkgNTowNSBQTQ0KPiANCj4gVXNlIHRoZSBuZXcgaGVs
cGVyIGRldm1fcGxhdGZvcm1faW9yZW1hcF9yZXNvdXJjZSgpIHdoaWNoIHdyYXBzIHRoZQ0KPiBw
bGF0Zm9ybV9nZXRfcmVzb3VyY2UoKSBhbmQgZGV2bV9pb3JlbWFwX3Jlc291cmNlKCkgdG9nZXRo
ZXIsIHRvIHNpbXBsaWZ5DQo+IHRoZSBjb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5zb24g
SHVhbmcgPEFuc29uLkh1YW5nQG54cC5jb20+DQoNClJldmlld2VkLWJ5OiBEb25nIEFpc2hlbmcg
PGFpc2hlbmcuZG9uZ0BueHAuY29tPg0KDQpSZWdhcmRzDQpBaXNoZW5nDQo=
