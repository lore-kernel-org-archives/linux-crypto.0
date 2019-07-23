Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD3DC7618F
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 01:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21C7E21955
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 01:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="KiyldgTK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfGWBUu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 21:20:50 -0400
Received: from mail-eopbgr00048.outbound.protection.outlook.com ([40.107.0.48]:11074
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727088AbfGWBUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 21:20:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCzygrMpweUSWiFvjE2zpaG5hJHt9NtDj+GZ2k2JkDQlLliU3ZjJ3M89b2NCLdzZ7wAWnyCpfhTi8NaQpXegSZm76lEWZqTaFNuNu4NWg1ddkwDlq1+gzuSXnLb+8fFhtCjhaAyFi0/qtC+6OJACqkEu7artv0HXRrUq9x/Nznoe2olgtAkd6YvlD/ibX1AdoDe2/LWmjaX2tNS2N984oHofjLiFQu2nSQ/gcNGTdmFvrO/ph0mioxKXfhT4b7SvGP04kRr+4cgigLGPpG8gNUrm8Y7+YSyFtD1A5KS2u9p3YI2B4pTgMZ9zLIBndLG4jZjDgjodJoRfbSoW20MwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jh1rulet5E9Uw0zSLca3pRCyf0NnLVPMvU4Ac7W6J0U=;
 b=ahUFhuljfOv8Qg2cjJ7mz+zoy+0/3IxsWexpaJXqSw6hjMibYfRmaEX5O137CN/O3vCMO8TzIT3OydkwiORDl1bQK8kZ+pYDv1Se44iDRKsuduV46JLxow6rbCMx9jw/QX4SjzqGlGsxQeebkRNDkE39RzSIOTem7D3u7lg2Bwow5RyGFBR7jt81HXabDg0kihKXDz+uDzZ8u/ZPg8KBCYTy9eT5nMltSecUNuKcfYJHaaxlAA+rJRK5X92lGQryA/j9Kn7z1UYVkpxLIgp8NB8Ol1VCtIBBgXDpRPkovCFEFPoY0tMh0iLXP0VcYEYVFKimjmqQUgJzIWUA6xj78A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jh1rulet5E9Uw0zSLca3pRCyf0NnLVPMvU4Ac7W6J0U=;
 b=KiyldgTK2AVp9g3wyhfBYPzYokAaUVmzZP5cv6/1nxTNJNBcWtGfgGNdAyiZXExzDHY7w4F/WIRBOb+OyDLTNTeP3rwGDvMz7iAnQ2EmBx45V/Le/5XCwtQQIMuIEgdZZCqKlIVesZ6Ir2Ph1QDmSMbkcTvfsOGGiDYcO2MGADs=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB3994.eurprd04.prod.outlook.com (52.135.128.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 01:20:46 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 01:20:46 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVPiRTTO5nYvxvX0qf2jZsStExEKbXa3hw
Date:   Tue, 23 Jul 2019 01:20:46 +0000
Message-ID: <DB7PR04MB46203BDE7B36E66FCD5D03D08BC70@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <20190719111821.21696-1-vakul.garg@nxp.com>
 <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [103.92.41.140]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ecef650-fb84-40d3-b331-08d70f0bfd28
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB3994;
x-ms-traffictypediagnostic: DB7PR04MB3994:
x-microsoft-antispam-prvs: <DB7PR04MB3994A17B3E508A26D4C9AA148BC70@DB7PR04MB3994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(13464003)(189003)(199004)(99286004)(6436002)(14454004)(486006)(110136005)(9686003)(256004)(53936002)(3846002)(478600001)(8676002)(446003)(74316002)(55016002)(25786009)(44832011)(7736002)(11346002)(305945005)(316002)(6116002)(8936002)(66066001)(86362001)(476003)(229853002)(6506007)(71190400001)(26005)(102836004)(33656002)(66946007)(2501003)(7696005)(76176011)(68736007)(71200400001)(52536014)(64756008)(76116006)(66556008)(66446008)(66476007)(54906003)(81156014)(81166006)(2906002)(53546011)(5660300002)(4326008)(186003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB3994;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nIlBTvPpkU3JYCXYNGbwbIeQTwwMpPxlAwjHIJAb6E9f87EABTSWq6Cm5iiuJSYddApFFe3r0hd/aKLB8pNwBKDJNCwCsZB0v1LmLR3/dgMwUWKPqaddJZ1CZUpxvit5iZwKxEmvEk+szWQ1243WYCm3bG9IVj4VWgOgoXAUmGSgX4nzhmltfNmjPmRzlJNZ82s6XKlzktcYAU3hOGuGi5jkEcOczSM98wZKLv3MviljVSmdj6fOiI48LQph+tbsr9FWK5iI7wJiKa7B82frX3T92qPdLt+Nqh7/3x7MT9skdVKZQQBncX40as3sSWVNW918PhWZyMwrXWdAUiRW+G/tuOeYvqOqd1s5ksyls2ZmCacBjMxemtSQjDAFQm2MQ7msPA6bnk/65bhiQiBrjqDzfT95DQnb0L1+4+AsjqM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecef650-fb84-40d3-b331-08d70f0bfd28
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 01:20:46.0665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3994
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Horia Geanta
> Sent: Monday, July 22, 2019 7:55 PM
> To: Vakul Garg <vakul.garg@nxp.com>; linux-crypto@vger.kernel.org
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>;
> herbert@gondor.apana.org.au
> Subject: Re: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats u=
sing
> debugfs
>=20
> On 7/19/2019 2:23 PM, Vakul Garg wrote:
> [...]
> > +if CRYPTO_DEV_FSL_DPAA2_CAAM
> > +
> > +config CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS
> > +	depends on DEBUG_FS
> > +	bool "Enable debugfs support"
> > +	help
> > +	  Selecting this will enable printing of various debug information
> > +          in the DPAA2 CAAM driver.
> > +
> > +endif
> Let's enable this based on CONFIG_DEBUG_FS.
>=20
> > diff --git a/drivers/crypto/caam/Makefile
> > b/drivers/crypto/caam/Makefile index 9ab4e81ea21e..e4e9fa481a44
> 100644
> > --- a/drivers/crypto/caam/Makefile
> > +++ b/drivers/crypto/caam/Makefile
> > @@ -30,3 +30,4 @@ endif
> >  obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) +=3D dpaa2_caam.o
> >
> >  dpaa2_caam-y    :=3D caamalg_qi2.o dpseci.o
> > +dpaa2_caam-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS) +=3D
> > +dpseci-debugfs.o
> dpaa2_caam-$(CONFIG_DEBUG_FS)
>=20
> [...]
> > diff --git a/drivers/crypto/caam/caamalg_qi2.h
> > b/drivers/crypto/caam/caamalg_qi2.h
> > index 973f6296bc6f..b450e2a25c1f 100644
> > --- a/drivers/crypto/caam/caamalg_qi2.h
> > +++ b/drivers/crypto/caam/caamalg_qi2.h
> > @@ -10,6 +10,7 @@
> >  #include <soc/fsl/dpaa2-io.h>
> >  #include <soc/fsl/dpaa2-fd.h>
> >  #include <linux/threads.h>
> > +#include <linux/netdevice.h>
> How is this change related to current patch?
>=20
> >  #include "dpseci.h"
> >  #include "desc_constr.h"
> >
> > @@ -64,6 +65,7 @@ struct dpaa2_caam_priv {
> >  	struct iommu_domain *domain;
> >
> >  	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;
> > +	struct dentry *dfs_root;
> dfs_root is used only in dpseci-debugfs.c, let's have it there as global.
>=20

I submitted this change in v3. There is still a minor issue with this patch=
 version.=20
Before submitting the next v4, I have a question.

Could there be a situation that there are multiple  dpseci objects assigned=
 to kernel?
In that case, we need to maintain dfs_root for each separately.
=20


> Horia
