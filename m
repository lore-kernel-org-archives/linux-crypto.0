Return-Path: <SRS0=iQPq=3N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AE5C32771
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jan 2020 08:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1242A24682
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jan 2020 08:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="oD1NuICW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgAXIAW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jan 2020 03:00:22 -0500
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:52708
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727163AbgAXIAW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jan 2020 03:00:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQC1ScTqWQ/4N1ooTrCIjZhPz9cLrjI87YPJTScDUInrLKwx5pYbvrDq0fRyQUkNPgln9iuPrqatrmAoiTeCLwAiGFEzoxOoQnpQtlOGgtmKnKdIBGwTyAnQ3zZk0OxPyx0xbWpsb9JTh8ysLYovlrI2ur9sgHrR9LN0lrMxSCXg0JfVaqXBkv1R1q8GANU4pvawQ48SI26BBwQwByfm/Pcl3AI+zx+zQQ0LjdpCDVbQn9UTGw0wsPShFGhN18makYnVRHAXbXA1j07h02LoJgjZpkMUIKdPJBHcQejrZCC4nFWm7bE8UOC1efiXu5YlrYmH7c6HAKK/2bjPBdSAGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0aVPJBTZdS5S0ZtXKiO1FwMd5KxZ0WjhluC8SryCNc=;
 b=XiN0zDFx9NzslBEOUI3NE/MZUIZb7HZfu+U9Bc4rRcLrCq/rvFcMSTHjw6zZ+qJ2k9u1Y6Ss6hVgnVVP81RNshG77Q+DMvGvjeOwiAo+68czh9sZuTKl7zFCCgBVhnPK1zXDw7M+9PkiKKkrPWeMpClTwBFLKEkfDuXxz+99M1PzIgubBBsrY+YPyrVq3gkeiHwcGz0SdK/PzWY5kyrL14fCMGV2l7kQ6I5mJ2v12qsxgKk7C0t1HPycJ4VwfZ7370QYzs9sEGK3R8e1cM4h3Z/UfxaHZpjCJaZU622EoLcfngUCcaOdESy2EmnsZq4+flDhamLspD8kd3GDaKPgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0aVPJBTZdS5S0ZtXKiO1FwMd5KxZ0WjhluC8SryCNc=;
 b=oD1NuICWcFB4EfsAbzykDlcLS0xeikZuODI0ZaJvjl//JC3XXXfUaIHDloT57lWtE/g9SwpufcdN6IxgfNFGJcrVnzyjbgZPJuQoJavuVGJ0mHkwBpBMd2k31YnUWOuzrmUjDThoe/VrD/r9fTXdozoucvB5XKFDe7lNDOwspIE=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (52.134.89.85) by
 AM0PR04MB4769.eurprd04.prod.outlook.com (20.177.41.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Fri, 24 Jan 2020 08:00:17 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::6105:a475:df04:bfb1]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::6105:a475:df04:bfb1%7]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 08:00:17 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Arun Pathak <arun.pathak@nxp.com>
Subject: RE: [PATCH] add support for TLS1.2 algorithms offload
Thread-Topic: [PATCH] add support for TLS1.2 algorithms offload
Thread-Index: AQHV0d9fpUp9vdyUr0ua541zV8eJN6f5crpw
Date:   Fri, 24 Jan 2020 08:00:17 +0000
Message-ID: <AM0PR04MB5089CE1A958D7FF52BBD8D5F950E0@AM0PR04MB5089.eurprd04.prod.outlook.com>
References: <20200123110413.23064-1-pankaj.gupta@nxp.com>
 <VI1PR0402MB34855705F10BB498911FEF78980F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34855705F10BB498911FEF78980F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.gupta@nxp.com; 
x-originating-ip: [92.120.1.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5ea0b38d-e9bf-43a4-2d8c-08d7a0a37395
x-ms-traffictypediagnostic: AM0PR04MB4769:|AM0PR04MB4769:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB476937C82E7F553966FF391B950E0@AM0PR04MB4769.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(199004)(189003)(76116006)(66946007)(64756008)(71200400001)(316002)(44832011)(66476007)(66446008)(8936002)(81166006)(66556008)(81156014)(9686003)(8676002)(55016002)(6506007)(86362001)(26005)(966005)(110136005)(53546011)(7696005)(5660300002)(186003)(33656002)(52536014)(2906002)(4326008)(478600001)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4769;H:AM0PR04MB5089.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q9bqI6RcafyOtzY1wE9t+s/4R6NjQTEi6DJsfudm2xxfe0P5vhHmOinVLcQd2roeIXOGGZr/K+x5aPT90fCBpMhGu7bzTVt6htcQwX1WHdHCM8+RntgL7vsuzDiE0LIpqM1fJPjAToaNi1hu48Qr7oY5/jmZ914WaXkKkn+r8SR95M3H6pKn0rwZq5V38uyxJxMJxtbgx/bOkxNcaYPQuyDaIoOpSCJOINozDva1z304XlntffEmscyhBDJHJhYynLs/zZjxY4GBYle3gdgnIfYFj7mDTqjjQn8fWwDuNDtr9COytJ7PXgmAT90bAyNaxW05wQYRMzcKlh+6UKb+0tqLb8+E6GmXllMhV+7oBuEzBW62V1s11+YjftLKV0w9KGNwIANP/rR4M0NWnjsMqS6eNv0AF+xFWcicA9t2DySK1AYfnUz0ZCV6NUIIo+Bv/LY9aQ+QZuhGWFwTEjwCDOiHpC3HMuW4eZ/nyZ0W9F4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea0b38d-e9bf-43a4-2d8c-08d7a0a37395
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 08:00:17.4604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q5WSB1JML8UsVnGD2u7hb55Hzm7p4XWJFRtPiBtnBvtUUsnnWPufEQSiy9DB2SWzx/G5A5dDkjdAjhl4rf78TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4769
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

Thanks for review comment.
Yes, rightly said.

I will re-work and update.

Regards
Pankaj

-----Original Message-----
From: Horia Geanta <horia.geanta@nxp.com>=20
Sent: Thursday, January 23, 2020 8:18 PM
To: Pankaj Gupta <pankaj.gupta@nxp.com>; Aymen Sghaier <aymen.sghaier@nxp.c=
om>; Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@davem=
loft.net>; linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Arun Pathak <arun.pathak@nxp.com>
Subject: Re: [PATCH] add support for TLS1.2 algorithms offload

On 1/23/2020 1:22 PM, Pankaj Gupta wrote:
>         - aes-128-cbc-hmac-sha256
>         - aes-256-cbc-hmac-sha256
>=20
> Enabled the support of TLS1.1 algorithms offload
>=20
>         - aes-128-cbc-hmac-sha1
>         - aes-256-cbc-hmac-sha1
>=20
Patch does not apply, since there's no specific tls support in upstream caa=
m drivers.

caam drivers register crypto algorithms to the crypto API, and ktls uses wh=
atever it pleases:
https://www.kernel.org/doc/html/latest/networking/tls-offload.html
https://www.kernel.org/doc/html/latest/networking/tls.html

Horia
