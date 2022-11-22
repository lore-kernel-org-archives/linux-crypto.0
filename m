Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C5BC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 11:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKVLWl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 06:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiKVLV2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 06:21:28 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2064.outbound.protection.outlook.com [40.107.20.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7305CD08
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 03:17:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1W6op+6XIkQS5aFzd2q+85bC+kkOviCnzhAnEjDE04jO+5bhQ7QObgYKtvTndpNNs48pOaYK/sA3FhGEpenYaYB7W1iqtQbxjf6Pgsb9sQGWyQsknRubGJ3uBjEyxq2UGPra9IjnlJTdmR32w5OaRZxwHbTMTqlCBHh1B7WomiousuSjbvydJwNvAne691X/ts39+iuslqMQ3CBfzSNy91IzFajkv2p7ZPIHYUkPtiPDBkr+WDHOyU66LYNrG0rkl/OvfbSa9LgzLUgbl6361RKm3cPJVCLdjSwKsyJE0qHxw55Mrp4Hp41DRLr/Rq1P8NXy9DfA4kd0z4xcbgGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8PEASxj5M5+PjpqnYj7ao14Nmbe+ZLanMtm0e9TVd4=;
 b=ihvoJDjJJtWYL86YRv+NThrkKNK5KjvadFMDDaudqTHjkMsxASdiUb1NYVt3CbRta3KLsV+HD+AmfxBbMJHgIdPbL7wLzHDBDarTGJ92uMaRWOW94i36ffb0akJ+Yp3OlZtpLrHRUBtoq9LOsJTv743lCsfYwewFqXBbz3GXfplhPYMWWetp83yLKdilw9aTOfSjdOqBNQ3I8trfCryQ5HjnZXgnUkXijAjhPzNH7Zhk1Huqrzb56djh8oJQ1PtslfPTg7hqHychEwQcXS7kRPxg3q3YamgFrCYp6Xoj85BN4RAG4nMgJskbjfyP34R2kNJJKfd0udk8Id0akdNZxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8PEASxj5M5+PjpqnYj7ao14Nmbe+ZLanMtm0e9TVd4=;
 b=DOabyhD30qJi5TmEUgWCJiWO7ZXLnrwsvTBYr6kBi8fNDin9scWvpNc6yhE7OzY++pG55WgmPAzLVqITj6XrZ3lldjyJ/fRcf/5FvgeuuYKZ5lrvPwgyUYzxmIdjH9bYSQ7/CKM4/Rv0u87i/B/ziYWQIqGhWiuOzstqHyX5Sr0=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AM7PR04MB6917.eurprd04.prod.outlook.com (2603:10a6:20b:109::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 11:17:01 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::9fc6:22f0:81ec:dbc2]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::9fc6:22f0:81ec:dbc2%4]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:17:01 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: [EXT] [PATCH] crypto: caam - Use helper to set reqsize
Thread-Topic: [EXT] [PATCH] crypto: caam - Use helper to set reqsize
Thread-Index: AQHY/laFgIwbb5s0xUS+DAkaxiVoxa5KytEg
Date:   Tue, 22 Nov 2022 11:17:01 +0000
Message-ID: <AM0PR04MB6004FB2D687CB6D99AA3BFE9E70D9@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <Y3yZI18QRK0kdaX0@gondor.apana.org.au>
In-Reply-To: <Y3yZI18QRK0kdaX0@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AM7PR04MB6917:EE_
x-ms-office365-filtering-correlation-id: c9c982ac-6168-491c-b5bb-08dacc7b141a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yYzlcZdTcripKV+VP+t0b6otxBy0OgmYVGfqf8RnEIbL+px4nipEAlF3KpTesFr1QGuoRF9deYNk59+BOlOOJmA7Q9oiz5iqadSrEQgGx6CLCfv/PPvTTRQfoX7ZveSlfEfbQ1ntAENhCVpAFvuOnkGQ6RsrDMVxdDHA6FCO+XM0MFlot/V75Km3AhtcpBN+86RUCBCZ9vfE7wZbKmZZ+bZf1x10ou9lArABy+XuGi/qU1tZJH5k3/siAaY7ghNp68LW7/6uFBCvfyXto7FGi/C6tsEWMpzLsbY3lpRo6spz1GgI7bzPB/Ajtmsx9RPxXpVrDz1y+Z/dedgcT43twF6sWkJ/Iu/JoCRZdnefR3VIqIfff0R4QlbWrh1W+WLN5ocxZfDRWGfdNLGgQzq81wc5lgFfIOY8aPLGnLZkQfq/rxPFOuRo0SZxYBdvQmgOLmxaEsOI94BZdOGi25509AGw37SvFXYmSTN4J5+qN4y2l8+PigNCdxT1hi3AgDzyIsWbIZlkiyYCliZB2spItpDWi1UP4Jw8FliTLZcD7k5DagOrrvjj2ehZZyPbKXOG65eeaC9GSv94u3MxsWFrVgiKEILcNytbba3kiocghBTAE42o4LO53/PFTToyOL58vu8+Dfz0rHr0sviZVCrVSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199015)(86362001)(2906002)(966005)(45080400002)(71200400001)(478600001)(76116006)(66476007)(66946007)(26005)(9686003)(64756008)(66556008)(66446008)(52536014)(186003)(8936002)(316002)(6506007)(7696005)(53546011)(110136005)(5660300002)(33656002)(44832011)(55016003)(83380400001)(38070700005)(8676002)(38100700002)(41300700001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+exnLEKB6MjW7t9AB+v9uBXIHhCUFbKZlUzMMpCs+FIqPQ613A6iY8lAoDu/?=
 =?us-ascii?Q?IRB5QX1th9qOggIRRs/OJ2EFZ/f9N8NDL8rwcH90j0ShcoXomwNCukklSCHd?=
 =?us-ascii?Q?L2R0Ku+oj0yZfYQV6zbXX9gVF68CLxbvHOlUWLccIfP95YaQ9WTLl1mA/ZJj?=
 =?us-ascii?Q?pfeo0ulAotSNHhUyEhAXOc5I3YDE6LsYED8ayGaLkzt6rP+S1gFsiATDxMla?=
 =?us-ascii?Q?UhTdUCND8JCAy+4kAllEQ9WjgXMdUweyXgN9taAIqNMNb/qXUocgWkknJ/4k?=
 =?us-ascii?Q?fHEPNjKq9J+PdNGfZoxFt5eMvOR7K5wi6c1HYFJPInZ01Tc45RDjhHA2PjHZ?=
 =?us-ascii?Q?Li71jrxzEqCCV2mpyr/QPYiSQMZG3Gp3BJNZTKbghCJ3upP131oO6c/+jxpP?=
 =?us-ascii?Q?M6+LRfzSTErVvsDORqjBiZVT+TY1OTt/lowt+lAGvGlKw2Fuxzrrl0YVwpSm?=
 =?us-ascii?Q?yqGJ3LtHM8qzkpLHO1KJIHJF0lGqfvoC+qM7gycEXPR69pwnAnoVz+vT/GSv?=
 =?us-ascii?Q?eHswpDqTBK7aeo1MPQKOvN0Q7n3rKf5VU88NTSwOJzWbaYjFR1kLGwjmIKzN?=
 =?us-ascii?Q?2+oSlcpX5Dk0T38Mes4O/KAM7ggM/QNDGO4UPqWRodMo+J1lJvIzzskKbAnD?=
 =?us-ascii?Q?rnA+5bqXS9OHyJhiOfD0aCsMrFC4hxe2ij36wuSVeyPZdhQsxwtxoEADW34d?=
 =?us-ascii?Q?Nhu2DeI9Lm2qz57O3QQ/zZk7db9gL53hs7YBu/FW5ZtKHv9ld69A4RsEGHYS?=
 =?us-ascii?Q?t0FKzYo6zAhbWSWnIu6OdBnC48c3hHkGzhv8zF5wFmJ1eO2vNULaRT0tate6?=
 =?us-ascii?Q?A4cpDXbG9P9yyUebZyR6FuVei9htsYR6Cry8BCy8thV1KclK7Dy3Jtmug2Ay?=
 =?us-ascii?Q?Rp5EpeWJQWXNho3b9q0Lr/nqjK+0a1eOqQOOuApsxRcrpaXkL/uoS1vXiE3Y?=
 =?us-ascii?Q?0i80wnQkq4FzduHd1LhIaiNOoJKdXP7eo72sBf6nY8y6QMNbNWhD2vzXqru5?=
 =?us-ascii?Q?k0tcRV8y/1K1GK7skB3OpwDi8IF+wSiFwMgEl0dEGeZi8jnbwVfLP0NRWyZ7?=
 =?us-ascii?Q?Uf4IANxcGzQXOXlr50POvsnRUx2uKa1BhlCQl7FW/H7C3ZCmq+ICKF9f5hcb?=
 =?us-ascii?Q?S2/o3RtmY0wlIy+L9iZZpDFUQ78DTCtNoGMTJdrGU4BwAeMph8qquh6/mcXe?=
 =?us-ascii?Q?0Qsy1s3QjnVBL+Hq5Xo7JbUatFKluosKD5aXTEI6fP2CdvBk8c7ckP5CVimY?=
 =?us-ascii?Q?cSx0E098UR95/mTaL2197D0QTPAwVpBEmE1kv+AUh6LuEOTnZ64fUauHX4yx?=
 =?us-ascii?Q?NUOkvzcufnnUddeKWxME4VyxaczBEkEcPl3EMZaHckfo9hgkdcfLM3+baIOn?=
 =?us-ascii?Q?ZrZTYZTdlHuZSHGy6/AsetA9NpwUMYKqPz7cZvx2QZMFSmPn85gT/8KweSBQ?=
 =?us-ascii?Q?TqUMoqcVeXRZ3Tb2P6jLHEGl17fgnzx13puavo2/zPxAr3QIfjUpSlMHrD4O?=
 =?us-ascii?Q?uvNeAnAaWLhfuT+GkWWfuOjPamD2UecLfV4wsj5nPBE1F96ZPAyavLMlaQaj?=
 =?us-ascii?Q?RBoK3dNWO2x2d6P1xxPIM0XExScPBR9OHlWjytcg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c982ac-6168-491c-b5bb-08dacc7b141a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 11:17:01.6060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Hz++jTAMkPdYOf4aYncoZk67DEbdk1f7dF7scUz5MlWo9SafPuZUvAjXrfTJmkmuiwvT6WJRxKeuw11z5FDDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6917
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, November 22, 2022 3:11 PM
> To: Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>; Linux Crypto
> Mailing List <linux-crypto@vger.kernel.org>
> Subject: [EXT] [PATCH] crypto: caam - Use helper to set reqsize
>=20
> Caution: EXT Email
>=20
> The value of reqsize must only be changed through the helper.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.=
c
> index 886727576710..642846693d7c 100644
> --- a/drivers/crypto/caam/caampkc.c
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -1099,6 +1099,8 @@ static int caam_rsa_init_tfm(struct crypto_akcipher
> *tfm)  {
>         struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);
>=20
> +       akcipher_set_reqsize(tfm, sizeof(struct caam_rsa_req_ctx));
> +
>         ctx->dev =3D caam_jr_alloc();
>=20
>         if (IS_ERR(ctx->dev)) {
> @@ -1141,7 +1143,6 @@ static struct caam_akcipher_alg caam_rsa =3D {
>                 .max_size =3D caam_rsa_max_size,
>                 .init =3D caam_rsa_init_tfm,
>                 .exit =3D caam_rsa_exit_tfm,
> -               .reqsize =3D sizeof(struct caam_rsa_req_ctx),
>                 .base =3D {
>                         .cra_name =3D "rsa",
>                         .cra_driver_name =3D "rsa-caam",
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2F&amp;data=3D05%7C01%7Cgaurav.jain%40nxp.com%
> 7Ca470497faa5540d2b14508dacc6da6d8%7C686ea1d3bc2b4c6fa92cd99c5c301
> 635%7C0%7C0%7C638047068575576790%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> 3000%7C%7C%7C&amp;sdata=3DvTJzDwXqxU3VydsCSr2myyfTiY3DQ2IFc8Qyxads
> BkA%3D&amp;reserved=3D0
> PGP Key:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2Fpubkey.txt&amp;data=3D05%7C01%7Cgaurav.jain%40
> nxp.com%7Ca470497faa5540d2b14508dacc6da6d8%7C686ea1d3bc2b4c6fa92c
> d99c5c301635%7C0%7C0%7C638047068575576790%7CUnknown%7CTWFpbGZ
> sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0
> %3D%7C3000%7C%7C%7C&amp;sdata=3DgJ0koAZ3Rw6SNDquvcLWMat6IkOGbO
> wn94sM8XlMtq4%3D&amp;reserved=3D0
