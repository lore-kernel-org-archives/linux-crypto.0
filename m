Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1618CC76188
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 14:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D31A82171F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 14:29:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="YupCltgC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbfGVO3O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 10:29:14 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:30462
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfGVO3N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 10:29:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/zB5yT3dPsftjqhulUPyxA4B8ot0QcyqHGKDrKdcSxTqvuXZybezxYkM84gBqmPiabQbZosLdtzrVwhp7jAjgMTVAa45hFg26zXUM07FnghKbWG1xNq1QBXyfVej82AK6Oqc3V0y1NMMnuJc/uZNykunb/J7aPLHCQjZnlYsNAIgUToqn0N6VD7JQBa2TsxpD65OzhtnVS1p/pnmYjDE2h6w3Z19evgmcFPitxpckcCpY4zyoYRq8oVNWNd1HV7fD0unXmPqv5nRgzDJ89FSYgkA8mosWKJjd1OSi2CLlkAM0nW/GS4D9qoa05CmDSypav3nybxXbrLD19I+bK8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA0W8KShJnspAkRhRC2KjUZWdp91TQwrQv+7cJZpEYM=;
 b=DADpoGmlukbzAp8ziYkxdlxJTgZdzSP4PjNzI7+1lW3vqklSLGh02ij9t0vUuRhkryZRVQ+QLwcd9HJOb0DVe2zNyX8k4KmIqStZ6gLf9+s38+8J3otvOGoiBSq2tYKfbk/aimKWufAey+mlcm5vOc7raluzy142jZ3nZrfpkbsmNRWGO1RkGG1G3qnElabHAGKWNaQbpvswYTMHNn0Tl11dnPlHrUIlIH1/Bzgvjf8/dqakOCPxH0xvwZwJx5e+B1Vlj+D2xFw10RI6fSaQYj7qQpTtRJ2MHy7H+0nXTjL5vOI5EQ4KbNnZTBci/7wRJhglRn/4i09exFpH3Ktqew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA0W8KShJnspAkRhRC2KjUZWdp91TQwrQv+7cJZpEYM=;
 b=YupCltgCEDo3HizfLjxLcPAp6BCfCEv0ygmnpQYGj7SXZu4yWqrO4/fzzJC/8eAiqhlTHvYRkvp4MarYuD7JErqthTUxSyrG5TLZmBrOfa/yFOviwelxKDr5MhdmFkNjPQU++Nnluvyr37yVlcK/LTTewyYDVZIMqu1544CWdAI=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB5114.eurprd04.prod.outlook.com (20.176.235.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Mon, 22 Jul 2019 14:29:10 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 14:29:10 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVPiRTTO5nYvxvX0qf2jZsStExEKbWtrQQ
Date:   Mon, 22 Jul 2019 14:29:10 +0000
Message-ID: <DB7PR04MB4620F4D9DCCF4894E0C6941E8BC40@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <20190719111821.21696-1-vakul.garg@nxp.com>
 <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [103.92.40.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed08a313-c6b6-4313-8121-08d70eb0f660
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5114;
x-ms-traffictypediagnostic: DB7PR04MB5114:
x-microsoft-antispam-prvs: <DB7PR04MB5114A36A22560BE3925AF5148BC40@DB7PR04MB5114.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(13464003)(189003)(199004)(53936002)(6436002)(44832011)(2501003)(33656002)(55016002)(9686003)(486006)(2906002)(66066001)(6116002)(3846002)(8936002)(68736007)(76176011)(7696005)(25786009)(6506007)(53546011)(102836004)(478600001)(64756008)(81156014)(81166006)(11346002)(446003)(26005)(66476007)(186003)(74316002)(99286004)(66556008)(316002)(4326008)(305945005)(7736002)(76116006)(52536014)(71200400001)(71190400001)(5660300002)(256004)(86362001)(14454004)(54906003)(110136005)(66946007)(66446008)(476003)(8676002)(6246003)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5114;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rYbf5Zw1t+BaKuN8u3Sfc/eA3wbhJUY5GMppW9kYHI6UxBiEp9CBrRQWPLlUthDeh8TmCVFsb87kW9fqvmr8VBrUdl6F3iJqwOQKh8jSeD34mqtB5kjvyKwEqS1TFhd3ciAFthwenMjNx7l3vL/Gyl7YbpSaPEyGlK1GcDzUmDIMy8/1B+tqBD9EqqSiN/pzze2YgjR1acP0vhvyLr0+a2hQLtBllgkAWUmup2qZfCQxONiQNpfszItLLbIC0Il2LY2rTda94oMFWYGRnvSC6d66l72au6MScGAKgeadpL6LlQ40yui+YmKwLcYeky6Cqo09elKpsnPtIJtFXxEimy7Gn5oM7HbRdu9xg65kqp9jRiRThdG09sk5KUnK73sWTpyprL9B/J1h8TtYvjDB7JVBDSEnUKJf2ZE9qIcW4fw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed08a313-c6b6-4313-8121-08d70eb0f660
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 14:29:10.5447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5114
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

It is not clear to me.
Do you mean not have additional CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS?

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

It should have been here in first place because we have some napi related t=
hings in this file.
It is required as I got compilation errors now.

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
> Horia
