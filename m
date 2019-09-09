Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288ECC4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C95252086D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="HE73ee2U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfIINU2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 09:20:28 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:3072
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729896AbfIINU2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 09:20:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPK9OZXVeRuOqGuOM1sNog0GZtkMX6vjXT+29yB4ssI7UmEeezJOF5xNCcjvcBsW9CTPK4Njo5kvF1OwF9LTjjqWAmYCwd9Drm6ZcBdtw7+akKmXaHtsl2B/L/zrhm70y1+6NaYnjHrkC175MAoGCfIKVhNPp+5sX80Ar4yq62nqvBqzZCXn3RRUt+gLsMBoB//pPeiQskIyd80JrmgEzw66PYG4N/fXEUbPUiQlAY0r9BOH467m6OgdDsabNlOjw3d0ghAc/qrxSqZU5L38V7+iYLc4oxaJPStMvmSmgBoer+t1z12bospqbOygcoYPR8ICHUUVQoV++DOjIfSbHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/HAj8PT0EHf0fhBEBNblSa4nYrU9p0z0d9wWc7PMJ8=;
 b=XghDVq3m7VZFFh2n6BqszgFXRsMGGvxLeAJk8nB3VaCEJCHOFdELBeQnvVvLYr7SkkJj0lhBftqYRrrjhRW6Quh1Fr88bkLN2im82t4FCRr6dcK4bkzA8LWbCfV6bcXiJ6q9EM1v8THBljEQH04c6/54QVhOMvh5w2DHDC0cX8eiFXyRok5IHMaSbbcdCmQkp6CoOXHedFW1U1qi6X7OJYBQjTM+pSG+Kb1ceIAYImDEif4j4rRKvIKZ4ApUKZ0UF1pyLDMgoErbXBzj4XK0YB4dYKSVMliSo+NzqcE6SXXEtggdOUCJHExvNmmWc7EmdEmccbr3BO2JFDC7wT0BfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/HAj8PT0EHf0fhBEBNblSa4nYrU9p0z0d9wWc7PMJ8=;
 b=HE73ee2UGQGjSSDSZ6oVm9d8W+N5KjF/F1GHRE8BG2uCRsmrlg5cYdMVVqQaaLQON5CIVCxshVS4qv+4470Rs9sG+QOED9GDP4vPHb9x0Oi/EbVWMmR8MjIL2wrq7PYOJYPR7wtxEyPA9+7RawVKF1TxblgGQp9JobpFaLGduFI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3744.eurprd04.prod.outlook.com (52.134.15.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Mon, 9 Sep 2019 13:20:24 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:20:24 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/12] crypto: caam - use devres to unmap memory
Thread-Topic: [PATCH 05/12] crypto: caam - use devres to unmap memory
Thread-Index: AQHVYslxhkN+v424iUiSLFIc+2ZSDA==
Date:   Mon, 9 Sep 2019 13:20:23 +0000
Message-ID: <VI1PR0402MB348584CFE60C93F5F58065FE98B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-6-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32dcc714-379b-4a3a-f7c7-08d7352878f0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3744;
x-ms-traffictypediagnostic: VI1PR0402MB3744:|VI1PR0402MB3744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3744457743ACC09A9B59815898B70@VI1PR0402MB3744.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:224;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(199004)(189003)(99286004)(71200400001)(44832011)(4744005)(71190400001)(2906002)(476003)(256004)(110136005)(74316002)(316002)(7696005)(305945005)(486006)(229853002)(14454004)(54906003)(33656002)(446003)(186003)(4326008)(53936002)(26005)(7736002)(6436002)(2501003)(81156014)(8676002)(53546011)(86362001)(55016002)(8936002)(76176011)(6246003)(66556008)(66476007)(66946007)(6116002)(3846002)(9686003)(64756008)(76116006)(91956017)(5660300002)(25786009)(66066001)(66446008)(102836004)(52536014)(6506007)(81166006)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3744;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +DUwp8AcyI9aZSGlzCItz57WAUg3dHYjBIpvAeJB52jzlCB+8YgSQABBo5UWKe+l66mBB3gb8i/A3baQdU3NTaMwv0bFyO9wHG3Mf30m84U0uxg//OC5OAKUUKaa6KuqSs4kOyLv7eSKeYghGckH7rfqZtzLIhxeo3VFIRkBHHswb8GXUz5fFpe38mPKtxjFSLnX0d3fP6Io4P5YVLZosIdM5FFu6OhBa3ei0cWbdfGpXu8u78+sgS00X7wnPo+ZdhW3EkeYDa8Im6s8x2/3vGlPZ6BEL5LOWd3sot87DZ1cjjlqr70t+qyhoRMGK5LkMrVNVQtDi1CKXeSzqoCe5DXUv5DtWkLeqd1VBVdXNDXv4teDS/1OC3plD52I7YzCj8RqDAjpLKDfUjn3SDbVxxzPf3McYdWd6GKq0d5wZFw=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32dcc714-379b-4a3a-f7c7-08d7352878f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:20:23.7727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v9OAStVsy6VyjQbv9/5Y+GcZLtzARzBI03W1o+P0BJREShQTmFuKBJAaUadMk2DNcihXLxabeCVie9zzacs/gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3744
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Use devres to unmap memory and drop corresponding iounmap() call.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
