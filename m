Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F53CC76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 10:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6881F20880
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 10:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZS3ZHe4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfGQKYs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 06:24:48 -0400
Received: from mail-eopbgr00041.outbound.protection.outlook.com ([40.107.0.41]:12545
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbfGQKYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 06:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRAlDqn+Mi2mdDkdyDAyyL4dIh2yFBn4Zt9Kb/d/6LrhFKsLQa1wTfmoY82CdLDL5XF2Ua7xRyT046c+IAtIpC9clcKAKjii2YwdWXsdi4ShijV3CY6taa6U2318HmYOuGTfiATftyKt6uFx+If91w8G8KUGeXP/FiY3fT7PTZ7mHz+zGO8ONRcf51y6qDbrv1hAVAm6N0tqpZciXOjK9pFfddqYeAy2ZtpEBxa0Np/QYxSNsHZgoRMJy7ZIizlQxDoq+1xUOV4CSVm0DweYuUjnB53fkDj4tCLe1p0xc5F1UHBvlWU/tochROVLr9+nA7/TM/j48ENtctVDQCnVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPaPT2czoME/hYVRz4ZLl0n89PINpuSoCKA/T7QGlF4=;
 b=MPVq5yILoTfMjDR0AteqDYPrx4snc0kUHN5kRVHL3eGfHm25YoYavj0o7Hov8GxEQ03nzpfVm739ANePGWL4lBM+uf+1+ak45M3upLC7UR+5DO4e8i/F3/8B/RSuVBjtNCI6mzMQbrpLlaweBfybX8d3jN6nBX/z4OuNIeg+3AYUaWCKZY/3G7mhAgUQy+0OvMUVFH2Ucw3WkwVbzQs4XxPpqBIFTM1jYJbS7Pc669koyBLL9Fva3he3xB8L3boXOMq8cigxhijNm05V3DKuNV/LGvj9GGcPb6sSkxyFkUClJ5Gami8tDUzJi323kTucW8kjMMFxfjgFEerMTDUxQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPaPT2czoME/hYVRz4ZLl0n89PINpuSoCKA/T7QGlF4=;
 b=ZS3ZHe4Qy2UDElGOCAgwU2CEo8qkZt6a0YZJNZvKT/IUpK3oJMNFdFW2Dl2+mlXczfo/szWAUVEOCyNQS7MdMuSKHILs5kK+3QHZxoYpgcQlStoc7U40aEEekFG1nQyGwDdetc8rXlhEVp4UmqztybvHvQ43IajRLg7AfKU1Ajs=
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com (52.134.92.158) by
 AM0PR04MB5604.eurprd04.prod.outlook.com (20.178.203.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Wed, 17 Jul 2019 10:24:44 +0000
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::7882:51:e491:8431]) by AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::7882:51:e491:8431%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 10:24:44 +0000
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
Subject: RE: [PATCH 2/2] char: hw_random: mxc-rnga: use
 devm_platform_ioremap_resource() to simplify code
Thread-Topic: [PATCH 2/2] char: hw_random: mxc-rnga: use
 devm_platform_ioremap_resource() to simplify code
Thread-Index: AQHVPH/8+IsxXD8FhUCRO+/vflUVhqbOmptw
Date:   Wed, 17 Jul 2019 10:24:44 +0000
Message-ID: <AM0PR04MB42113B130EF5F03C0AF1801A80C90@AM0PR04MB4211.eurprd04.prod.outlook.com>
References: <20190717090438.31522-1-Anson.Huang@nxp.com>
 <20190717090438.31522-2-Anson.Huang@nxp.com>
In-Reply-To: <20190717090438.31522-2-Anson.Huang@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aisheng.dong@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b07ef63-8af8-411a-95d2-08d70aa0fc8d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB5604;
x-ms-traffictypediagnostic: AM0PR04MB5604:
x-microsoft-antispam-prvs: <AM0PR04MB56043F92844E560614CEAF5680C90@AM0PR04MB5604.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(199004)(189003)(8936002)(6506007)(53936002)(102836004)(71190400001)(44832011)(7696005)(2201001)(81156014)(76176011)(66446008)(66556008)(66476007)(76116006)(64756008)(71200400001)(5660300002)(2906002)(99286004)(305945005)(2501003)(66946007)(52536014)(229853002)(26005)(8676002)(6436002)(66066001)(6246003)(476003)(446003)(55016002)(11346002)(478600001)(86362001)(3846002)(186003)(110136005)(6116002)(25786009)(68736007)(33656002)(316002)(256004)(4326008)(74316002)(558084003)(14454004)(486006)(7416002)(7736002)(81166006)(9686003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5604;H:AM0PR04MB4211.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kopargwr+xnTBicKRrzy37X/5hnuGPmbGu3/tvOg0a9W7HFW9jj5Au98Ie7PkrL7JM8rKkhvqQL4MaBF6SPu71sx7DskS2FErurmGWNmiReDZ4ZZbUdxYYq9IyMbeJ5p/dFm3jHlGn/3O5bxuCf4Fc92lOF0poQ0SvnVHZxjdrtzE9tFQtdukFTx6g24UBObFrnpkVdt54AJ0xNv45EVMfQgeyn6MTtHm01GXHiecvalSmdiL2jgnvyWomr0MpfDFPbV3Bsrl5jsC7VMtCXOuUOxeqHilbvqojgHPhZEnuluOrqmc3A4vOt/sII7Yh0U2AWs2C5LXZa4Q6Rrkv7DgE05F+wDK08LOIHvEvWhFaSvTxIVnwQsEJdRUDuP0vi/xEKjkAJJYW83TmeOe6Tar5dZw68zar4dYMCabBX5eQQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b07ef63-8af8-411a-95d2-08d70aa0fc8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 10:24:44.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aisheng.dong@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5604
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
