Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859B8C38142
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Jan 2023 05:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjAXF7f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 00:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjAXF7e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 00:59:34 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2043.outbound.protection.outlook.com [40.107.6.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DA8EC
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2023 21:59:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPj0PwB2B58WvQ5WlhHIsyjnmrJnfzi6EdK4pvpKbAprGA9hvzmHnDX/2n6l6XGR2UmWbx+/W18qK6RXasmATPej4T1NnC9Jm6bWK1NtNawjCBrTo5wXAciTHEQyxD+MiPfD4J3BS8dl5teUn9isVuECa/0Wp/1ztHxecs0pAbZUZAIbP2aQ6u/SKu/onnW9dvL4JIs/ZFEHKVEWjA1Iec+RZ9mHBJ4q0tacPc6HhuOEW081GRWlUEP8y0r6wcgQBeanVl7mfGg6y6Gdtmpl/iifbNG9uojWGo2R/Mka+mce1ldnYBaxijsG8xRSQEEbkxGVCuj8nBJxcQfi8SwmRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1xBmPuvEOTZRibFLZvlG0KAHtfGCmcY97jCgwP1nWc=;
 b=E4nBpjJ2AyfpkyC1nH+gGzenIYExVceCBb3FqQam7XKTzel3fk9ky9YARoJxwIpU0VaP7k8UFNp+KOESnRgo8VhXftbUK/YXh/TaMYbKfc6S1JrUYWGNhlgSAlmVr+d+V6IKrYJxyH2SM8Chnz5CPmC7EIuIGhIdR9LrH41bjy3mljOXqC9RVljAbdtpULx7Gyr8r7BjLc7kei3eEnOubO+zfDAwHXRf4twlyYlU5NP4d7SP6RCU2kvo8xWJJWmy9D7X49oK9t6SPLvM/HQehuV5rFF3Sy6T84Nz5ex+l643Vhp5Nqn2kGrtkUFg0VyOdUc3bi/mZavRaG1ECfNYsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1xBmPuvEOTZRibFLZvlG0KAHtfGCmcY97jCgwP1nWc=;
 b=DW6U6UitJbXYRrlGcqw3MC98qgXrwz8rLdDBYw2Wc7GRNZWw6+9acE5wJK7BawDp1R/6ON/ndphMiw0mHV0YkxMfUDv85zaYs+xPRj8NTFfseSpnZ/HgghOJ77P7bG0ag3Q5AMqW8L4T0pSQ3iRnhBepyY0q3gPuws44iU/1rcE=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by DB9PR04MB9675.eurprd04.prod.outlook.com (2603:10a6:10:307::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:59:29 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::c2c7:5798:7033:5f87]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::c2c7:5798:7033:5f87%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:59:29 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>
Subject: RE: [EXT] [PATCH] crypto: caam - Use ahash_request_complete
Thread-Topic: [EXT] [PATCH] crypto: caam - Use ahash_request_complete
Thread-Index: AQHZLjOk6sG+TpMCPEejWeXjQJGx/66tFLyg
Date:   Tue, 24 Jan 2023 05:59:29 +0000
Message-ID: <AM0PR04MB6004BD5600952AB555261B72E7C99@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <Y8zmcwnwZOIoj8Vs@gondor.apana.org.au>
In-Reply-To: <Y8zmcwnwZOIoj8Vs@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|DB9PR04MB9675:EE_
x-ms-office365-filtering-correlation-id: 9b9aa43b-db41-4619-b88c-08dafdd02834
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7me2VmsMVHBXHPSiHWt/o+f9ivRL7A8OhtucQm1s4Rh6ppepTkxCOa6fFWFkefaI+kEwanfQot9WqJtsimSZl3IGWPF0/DWIj3ZECa34FX5mOIGkHVuxO9FwHhNpW657snx5jfAtOvMa3zGIkL6ZUxnf634XH1alIZBY5dABootL+Uw5js0m5ldoRg0Als+dmW/9J3/u97zCHwcjRj5QLJyOiXx8bMrwuq8gwQTMHU63XwE1xh4oeEgoKcqw4/wvj2n5rJRtR7mPwPP+XCt8YM1NgQactaExTpEDsqfJqAy9TEAtY79Ai84KEhrfu1oV0jqt36V5phQmx/YvA2BxCmSB5jn39ilwiQI+x5gJObvlCViM1+pGmHTw663uKITzngYzTEOccq4Zx6X06ZHSj8wI2hVTE8F8UXhAPkvZAin5ZA8bMW/je9g4KKBtMgknK+5Sj4L2IcAGHu1w1mewgorZ/91xuIgMlFfs5+twqThJLF0+unuj3GzPKWEsM0IcphcMwgzxiCeN+T8SJIWLbpLSWrM1WTVzJNr8e1jtugKlnjqpeiW9RMY/VYLo3F13+OphQXC0YkqKw5WW7S/vX0apJ4joa7NRfJ6scUA3W1qaH2egvvca2Yasq76Tlq1tx1nAPvHv/ouZjCk1ALW2BZ10vcBlnV6kUvP0dLD063/3KSPhzrtKcKsyfdJ2axcx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(71200400001)(7696005)(66946007)(66446008)(76116006)(66476007)(64756008)(8676002)(966005)(66556008)(316002)(45080400002)(9686003)(44832011)(52536014)(8936002)(41300700001)(186003)(83380400001)(26005)(5660300002)(6506007)(53546011)(2906002)(110136005)(122000001)(33656002)(38100700002)(6636002)(478600001)(38070700005)(86362001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9N/2MhsmMqgpHFIO8w+thYANm0kQw2i2KguKok6SQSyQ4jgjxXyWOJJ2b78Y?=
 =?us-ascii?Q?B5HHlVYH2VuzxaIwsAGSOZDbJ3k/UbBtGl6QktUqv3Qb+Sn86RK9UvRhgXxg?=
 =?us-ascii?Q?9MuFZXOaO8GXag/ib0j1heBtkjgMXwut8Y86DD1gphUbSZJVoSHv6TC6Zlmb?=
 =?us-ascii?Q?wCIdj+/cZKGDBay10eAscK7IrQr744H78TsCJZ5WTB2fHyETCWBON/B0n9pX?=
 =?us-ascii?Q?GRSSS2s0SzIxhV/nAAFx1UypgeiU09ht66lf2VFYBFExEqKvetSjU0dMJ35j?=
 =?us-ascii?Q?9Ey6JMx4uL7+mObwHkfTpxI0FmS702likML1l1kzB5DFTTqos8snwuiNJfqm?=
 =?us-ascii?Q?2PIdhoUjjZgfI+GzSiiTVUR5Rfo1iWz1CkqT/uoM4cH5rZDySIjoX+N55GIt?=
 =?us-ascii?Q?I37avy+cnCprLl7Mtgf0i4GIwTCRSxigjg0ze6LwXm1t+6gp9PK5fFeBvb/O?=
 =?us-ascii?Q?krb3GDHnc1aep0uDvhTB/iJW7FdK7kMIfOR+6oU2rsZu9C+h+eci/pOPg5xA?=
 =?us-ascii?Q?jHlSAwy0y9QdVN5Yv3QnZCqQ2HPfzcewixHgNQJgShy2pIYIVsVO2gI59xVY?=
 =?us-ascii?Q?jubKnYazei6GHrAosIGbbbEiglo1qxaVzp7K7A/Xdn0usaJqN8XYdVCRwZrd?=
 =?us-ascii?Q?Qv9fIfMK95fscLnCSnhhdDQmvPzV5ZiuIZt+4zTe4squB0/h0Udug1w1yCmK?=
 =?us-ascii?Q?g6+0cFBCqbR/1cJmj5hjS9jHWcj8wBM6qFpAn4p/ukobwO6Y2AHycBsWXhdy?=
 =?us-ascii?Q?8CmSsCfluPvNaliTjDFwzdua/k2gAkGNBOWu1owg382ZnfTbDJ20aGqFiQJ8?=
 =?us-ascii?Q?f2R07S23jF5WEgu4++YZRCPFvNNMCk7Gz+ajBGzk23gp6oX8GYuwdwCjH135?=
 =?us-ascii?Q?I77qvQryLV2aD02PTG/4Un86t6W6ju0RGyNXIfmNJqvlCgoI3hpwEvYj7XUW?=
 =?us-ascii?Q?LfavOPajhMpsrljh3JoInpgudpK6foCnUsoUlHE7MVSYGsb4dEcGnx4oixQ3?=
 =?us-ascii?Q?VOWp19KpeKhyMlSDOR1/0ITCtUZg34++owmMnASSftF5JHa5QH3Ds2KRHiLw?=
 =?us-ascii?Q?x5SO61c9cIaaCxADVTNtl/UoiH9PC393CY0zY2ifiRiNeZ1Meb7wBLnE2nmv?=
 =?us-ascii?Q?Ch/NhJOheTVufD/lksH0p/awSdHvO3grnB0/02Xe7uXTOEKhBgQd9S1wcjgP?=
 =?us-ascii?Q?fl/0w5UT/Xmt9IcNSczlmRyG8u9KZWYSJGjx7+DxQ73wQ/fKLwTL31CSBs2x?=
 =?us-ascii?Q?VUzcpWPcv4EKHplqr3pjHWyMFa5rQG4GS19dBeEjwv5zJf+tdMJKeE4RA+S9?=
 =?us-ascii?Q?xMIje/ENxMNFi9isuF895DneWnKQepGdMuP9s4NuV0Rlk+kY3bX7D5rEHtOB?=
 =?us-ascii?Q?K1u+sg1f82k5UHh+1+GdqgdfLT6ur1kW6gwbkQgClrxA9dzuAjncXbD0DUTl?=
 =?us-ascii?Q?0KjFULgAX8E40RPcfz23Zi6Ib+SqkDq2yXNY9vZ2ZiItfxEroU0SbyS12HAg?=
 =?us-ascii?Q?8Kwg/XyBkqwDhdXw3DlLukv1K+no8PYc50cBNdJFyqPvM6ynTlnY4Z+1vBEU?=
 =?us-ascii?Q?Joc2ru2zXrjzcrYiU6jglzkICrAJnpGupB+SsB+B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9aa43b-db41-4619-b88c-08dafdd02834
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 05:59:29.5602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ohdhv0LQ2jmzcGIEROAGEH9sg1mM8w1yS1zO6gGXC9cLTWBeSfAhMaC5l2FSBmbsrYDuzS0QaGGcHt8fRkRXyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9675
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, January 22, 2023 1:02 PM
> To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; Horia Geant=
a
> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>
> Subject: [EXT] [PATCH] crypto: caam - Use ahash_request_complete
>=20
> Caution: EXT Email
>=20
> Instead of calling the base completion function directly, use the correct=
 ahash
> helper which is ahash_request_complete.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/drivers/crypto/caam/caamalg_qi2.c
> b/drivers/crypto/caam/caamalg_qi2.c
> index 0ddef9a033a1..5c8d35edaa1c 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -3419,7 +3419,7 @@ static void ahash_done(void *cbk_ctx, u32 status)
>                              DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
>                              ctx->ctx_len, 1);
>=20
> -       req->base.complete(&req->base, ecode);
> +       ahash_request_complete(req, ecode);
>  }
>=20
>  static void ahash_done_bi(void *cbk_ctx, u32 status) @@ -3457,7 +3457,7 =
@@
> static void ahash_done_bi(void *cbk_ctx, u32 status)
>                                      DUMP_PREFIX_ADDRESS, 16, 4, req->res=
ult,
>                                      crypto_ahash_digestsize(ahash), 1);
>=20
> -       req->base.complete(&req->base, ecode);
> +       ahash_request_complete(req, ecode);
>  }
>=20
>  static void ahash_done_ctx_src(void *cbk_ctx, u32 status) @@ -3484,7 +34=
84,7
> @@ static void ahash_done_ctx_src(void *cbk_ctx, u32 status)
>                              DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
>                              ctx->ctx_len, 1);
>=20
> -       req->base.complete(&req->base, ecode);
> +       ahash_request_complete(req, ecode);
>  }
>=20
>  static void ahash_done_ctx_dst(void *cbk_ctx, u32 status) @@ -3522,7 +35=
22,7
> @@ static void ahash_done_ctx_dst(void *cbk_ctx, u32 status)
>                                      DUMP_PREFIX_ADDRESS, 16, 4, req->res=
ult,
>                                      crypto_ahash_digestsize(ahash), 1);
>=20
> -       req->base.complete(&req->base, ecode);
> +       ahash_request_complete(req, ecode);
>  }
>=20
>  static int ahash_update_ctx(struct ahash_request *req) diff --git
> a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c index
> 1f357f48c473..82d3c730a502 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -614,7 +614,7 @@ static inline void ahash_done_cpy(struct device *jrde=
v,
> u32 *desc, u32 err,
>          * by CAAM, not crypto engine.
>          */
>         if (!has_bklog)
> -               req->base.complete(&req->base, ecode);
> +               ahash_request_complete(req, ecode);
>         else
>                 crypto_finalize_hash_request(jrp->engine, req, ecode);  }=
 @@ -676,7
> +676,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 =
*desc,
> u32 err,
>          * by CAAM, not crypto engine.
>          */
>         if (!has_bklog)
> -               req->base.complete(&req->base, ecode);
> +               ahash_request_complete(req, ecode);
>         else
>                 crypto_finalize_hash_request(jrp->engine, req, ecode);
>=20
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2F&data=3D05%7C01%7Cgaurav.jain%40nxp.com%7C2c
> 291da8543f4910bd3b08dafc4ac495%7C686ea1d3bc2b4c6fa92cd99c5c301635%
> 7C0%7C0%7C638099695322344265%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiM
> C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7
> C%7C%7C&sdata=3DhWeStOfWJ6Ukmo%2FeqL%2BRuLstFvJAjtByuGesO73BY0M%
> 3D&reserved=3D0
> PGP Key:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C01%7Cgaurav.jain%40nxp.c
> om%7C2c291da8543f4910bd3b08dafc4ac495%7C686ea1d3bc2b4c6fa92cd99c5
> c301635%7C0%7C0%7C638099695322500501%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000%7C%7C%7C&sdata=3DqCab7Bd9xy2uQAgWO3QsxzwHSOYGUM3uEary7b
> %2FSeTY%3D&reserved=3D0
