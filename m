Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8786AC7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45936227C0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mzvWTcrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfGWJIY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 05:08:24 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:48035
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbfGWJIX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 05:08:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGWtEoLg+EOk2XBt8esc/RJs54bsXx4uAtX0jSfFbUEOzLFEVAl0MuACijZpbdMPaHI7zMccskupAU6epBYU+Ql5NsXrAeypU81HGFEielF4b+MBvpy+IH0Q/IsOiI+ZLYkPiqYUOOjqrjl3Vv/QgyDa1PJGKXtEuFVpTfbkmvZRYnCuJqn+jYx2cJJeL+xsKTk3gCXoS9ED+9IjqjUg3IxK0vm8pnSsj65RG/cJ794gANslAr81d74C/mu7QumvbR1XjKrjscm4xEvO4TcHcP7A4Hie9UTq/7sVumRLfKMf1ylG76EZbFF3xP3GCYl2x40EY1ASuTMqquzyaQakIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ya7JUp6Ln83cIHtoXV0YAYVDho1OrNt6dxRMZv4Yh0=;
 b=KLNgVLgTpnFmK5qs32x14tZ8fWlf6OavPyNQtnNqbxXylM5WQjN9QOKKhDIc2zkO8Ib0GFwKn6d9eIJuh9nGGiBQNq4kWXpUYvU6p6AEh1Y+AX+TB3f4pqUXyOsa7WTUZ5LbgoXo7gIDO0aVYQldK239eLvGPIJG329lfdNtKOEMxu2eJMm3LddiTbwhphTZdvr6oFklgCY3lMP5hZIXgZUQeAmV6Glo1L4IjA6aLWbi/M5Cxw5yBeP95zFNDiYs5Vub7jl1IxUPHz3VqMG01gER5b9JSXpLbHulim8SAdfz9BMvNClqul4GHByuqoTPwRqA3I5cIzZ0WujU6QrHCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ya7JUp6Ln83cIHtoXV0YAYVDho1OrNt6dxRMZv4Yh0=;
 b=mzvWTcrDBc718t77QfQFLDRvlvDL2lqlSWWpxCQlSNLQJ4bzx7SaimuLsMX4xlVc8v1U3m/KoLw4QEh742p9v+kAxCZuCPkkTCFIX6lA6nlZhAvF6AkxgV0gRzekG28fCzP6TT5qcmIRUImO3u4tPXvXYOi7LAX6vvcY6Ufn9Sk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3616.eurprd04.prod.outlook.com (52.134.7.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 09:08:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 09:08:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVQTKZYEyobdVG002zgP86IbRAmA==
Date:   Tue, 23 Jul 2019 09:08:19 +0000
Message-ID: <VI1PR0402MB3485646A093D68040F78A3CF98C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190723083822.32523-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b3706ef-66db-47c4-5679-08d70f4d4e0d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3616;
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB3616B1B5A24809606D7C8B5298C70@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(189003)(199004)(478600001)(966005)(26005)(186003)(6246003)(53936002)(4326008)(25786009)(2501003)(2906002)(52536014)(76176011)(7696005)(5660300002)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(102836004)(8936002)(6506007)(53546011)(6306002)(81166006)(8676002)(81156014)(33656002)(68736007)(99286004)(14454004)(71190400001)(110136005)(44832011)(54906003)(486006)(71200400001)(7736002)(74316002)(305945005)(256004)(6116002)(229853002)(316002)(476003)(446003)(86362001)(3846002)(55016002)(6436002)(9686003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3616;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q23hBA+Zh+y5I6+Hd0B11+4u3O3U5SG7urtDwulJ8hy9bfYVwQtYa1JFurZgtvx27/uN2Cee3N7p5XRV2WMed1G87V/SIlzLqXNPdnBd1Sev/UoNx0oV4aBCE5vfuQ401HcjBIYpbxY07NJi+gen4IHtE9ANNfzuN2ztoR7lC9txDMrq706nk2kszfcWRWVz+TdFidnaWykUxOqlRQOAO3NmayelHnnzkoCaSwQP+pxNvh8ckS5wIYS87AZHvkSozrV9T78zlW8I6ukhbLvxkP86sj5s8l17EN9u4ztfSKCBMVuexNwl8XqJj5dAAOTr3r2n84zJNCQCOgDntcALu/xQtsmFwCvmfW3NblAt55ua5mUE7Ub4PxNjFqWkQ75BAJFomDjmLo8j65nRaVVvNQ0ftZKf8q5BltvXN4RAOdI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3706ef-66db-47c4-5679-08d70f4d4e0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:08:19.1050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/23/2019 11:42 AM, Vakul Garg wrote:=0A=
> diff --git a/drivers/crypto/caam/dpseci-debugfs.c b/drivers/crypto/caam/d=
pseci-debugfs.c=0A=
> new file mode 100644=0A=
> index 000000000000..2e43ba9b7491=0A=
> --- /dev/null=0A=
> +++ b/drivers/crypto/caam/dpseci-debugfs.c=0A=
> @@ -0,0 +1,80 @@=0A=
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */=0A=
> +/* Copyright 2019 NXP=0A=
> + */=0A=
=0A=
.c and .h files have different syntax, see:=0A=
https://www.kernel.org/doc/html/latest/process/license-rules.html#license-i=
dentifier-syntax=0A=
=0A=
> diff --git a/drivers/crypto/caam/dpseci-debugfs.h b/drivers/crypto/caam/d=
pseci-debugfs.h=0A=
> new file mode 100644=0A=
> index 000000000000..1dbdb2587758=0A=
> --- /dev/null=0A=
> +++ b/drivers/crypto/caam/dpseci-debugfs.h=0A=
> @@ -0,0 +1,19 @@=0A=
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */=0A=
> +/* Copyright 2019 NXP=0A=
> + */=0A=
=0A=
Yet another nitpick: incorrect commenting style (for the 2nd comment)=0A=
https://www.kernel.org/doc/html/latest/process/coding-style.html#commenting=
=0A=
=0A=
Why not make it a single-line comment?=0A=
=0A=
Sorry for not catching these earlier.=0A=
=0A=
Horia=0A=
