Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A137C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jul 2022 09:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiGHJqA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiGHJpz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jul 2022 05:45:55 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30059.outbound.protection.outlook.com [40.107.3.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15CB796A6
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2022 02:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odMcLCeRC/c/n0KIgl62XBjtafTEdshb2bYN9Ah5XvUNGofJk4uYFxrC0Nc1PvmwKqpuyRb4j2ocEZyG5RwLuXMA0egUi0wR7H6bHChfhtwd5CkJc6aBEJ/4ucLJd+771/NEi0QswowG/ce+7vmruP/dvhPspoFqbnQG48C/4Iqy4/aeDw7h8qtmuyym7TWWqUkDluwKwgGncJW+Rx9myJB6+8d2en+rcECvz/9Ixz8PuP9LPwmtOM6rKTZDXHrXdcApEA/B8IBmw7Ukqc9wfNG9EcfwmOke4XwHIFVQmGjTM0vO//h/Wm2sgikAUot4UcmVUHzRwb6/c0CDVtIvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLUAC5eihUoDFQP8yUiMNfvpU6KnNMXRlLyL64rBDZc=;
 b=WBMJkArpHQAZazS6cIwBg+VU0fYKJeCPLLRzSBe219Y14B4COIZ9k9DOvFraoH5riT7XPg5b8DPaV5xbvEqn17Ad2R9EN2nfGB+xiJPlI+oLoRbVo3n9aIcQF/p4Nee0r6GY6c6jp3+DcBY8BweVbi0IAcpqifUDH3Dqt71iTlLd+ZkzEj4Ujy5+CtDseeXDCkTfhTWFYVLIdQhwa7rvqvlKiKw2BgLz511ouWejnCWimhxgdWYZ5v0CYaT5twiJzxs3n/tW9+o0JRkLoK9C10OFvTcnUjlOsPGTxwgD1qHuSZnLOcVKCjRS9xd+9uDg2Rf+PYsQHffqrr2hMRLw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLUAC5eihUoDFQP8yUiMNfvpU6KnNMXRlLyL64rBDZc=;
 b=TSkqaGVwW+f1TKdwtIEiOU53yDmhQWJ065xtl5e6jGhZn7YIyPpUVr6vj0y51i0hcI9Oymex3RdI4HVsqkpFqDiyRkUWoScriKvsFKD97/kRxicBfXsmWyOGaWwPNq6hBFRusoN0rUhy3Hpjo2kXNtxQ97U/pcOzmnvRpm4obvQ=
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16)
 by DB7PR04MB4762.eurprd04.prod.outlook.com (2603:10a6:10:16::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Fri, 8 Jul
 2022 09:45:35 +0000
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::7478:5e4e:81cb:af90]) by VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::7478:5e4e:81cb:af90%6]) with mapi id 15.20.5395.021; Fri, 8 Jul 2022
 09:45:35 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [EXT] [PATCH crypto-next] crypto: caam/qi2 - switch to
 netif_napi_add_tx_weight()
Thread-Topic: [EXT] [PATCH crypto-next] crypto: caam/qi2 - switch to
 netif_napi_add_tx_weight()
Thread-Index: AQHYkMLh4MjakZTCuEmrih07fQSLsK10PEnQ
Date:   Fri, 8 Jul 2022 09:45:34 +0000
Message-ID: <VI1PR04MB534278EC3B0FD825ACD73E43E7829@VI1PR04MB5342.eurprd04.prod.outlook.com>
References: <20220705225857.923711-1-kuba@kernel.org>
In-Reply-To: <20220705225857.923711-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fa81556-9236-436b-a00c-08da60c69b31
x-ms-traffictypediagnostic: DB7PR04MB4762:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bUd42YSNbwcYWnS/ntj2E14uJ8ztO4g4XXORVHPel8XA9SzRZKYHP4CN36dfhvKRjNKHR/jgZQAnvKgr64DYxVPgtYNnVZbXXy+ueH1VJvy52VLcGW67d3+Ob7P6GaPowNUWdpeQwfUkzi1ukyIkNlAjGeW4JlVb136739V4nLWnBRmHBlm6ECD34wzsjaNZexGN86Qtv0WJJZbTtPnv7g2JfMZdrLu4+xdw5y3ML+JxjGDDKbvNJirdjdAD06N3w/teOxXK2XZOfPEPPaUqf9Xu5yAnrH9BEzduLNP41lzUiCYKy+WkgvCB8ELcIi1vUikpnPvjGVUWe0+3YRp7mwCXKNLol2sDWyyZIO2C7/8bDFWCyI4KPgY/zhvv0EMIsfu67yxvkqgsp1wi4T5QsOdcPnSG1Vz8FlXKiAWMjNYaN0D5UttcwzWKpsJ+6hKPqojEDtFM/iV1rq+CwqSSAWbxkL8k1KAzmyoCzqcCfjGTLxHfHEAIGWzoMAtru1KA/UlAMcm7tl9BQzWx7PnnRUMgoCaBWY+T5F9Yod9O5sCLhAvbRO6NZAVGdxqClgGmGJU6JE68GjgHA2j3Np3LcJ4CAVyjV1ZdrOOaJSsB944OO036ww6rYpPeZUYgJGWxbM9hmUaGHd1XEPQT14PofNt91YSgenqXm04quED0D8HGixI3ZjAAPAqiFtqlo5pI2Zhpm0A9K3BY1iDLiydZygiYt1xAnxqjLiGMtikZn0YSNXYD/kHpJ6xUS1TU+dOPfEkohYTJF0n/53SEzkjH9KB6TyUY3j/+8GHaWV2aCnINvxQwaSLpUhaLPbqi8IgsrWiMGjdh4RmYWwMsAnium8226ijMKAS7Yv9Kho8MQAM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5342.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(83380400001)(186003)(5660300002)(52536014)(4326008)(76116006)(55016003)(26005)(41300700001)(7696005)(8676002)(478600001)(9686003)(44832011)(53546011)(6506007)(38070700005)(316002)(110136005)(66476007)(2906002)(66556008)(86362001)(33656002)(122000001)(71200400001)(6636002)(66446008)(8936002)(38100700002)(66946007)(55236004)(64756008)(54906003)(16393002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SZRdA3eh+iVGpptrBDjTdryz5i2dQVPJ7KjzHXFH/4792baokfwBQvnLmpjM?=
 =?us-ascii?Q?ippkp6brDMp2GMYAeONhujn1AZFrFpshEfrh0BV+JIppX0n4W6rIVEObTpTc?=
 =?us-ascii?Q?hP8zZvkxPjJS0dcfzvcJAZaB2A30WspetsM75OpswCsFYCoNT8jT4mXTID/9?=
 =?us-ascii?Q?RrS+LAe17PqURcMHQzj5hqzYG6NYPxySVR4l/Qnl0EAUjxubCaaHCAn4A8w+?=
 =?us-ascii?Q?UZv1mkNzs/qLcw2xuAmG3mCsy10ErnJc83yN9vkaBsjJBezvI5H1+B70WfuL?=
 =?us-ascii?Q?EPh8l+GLrbn2bJM3xJLw4Enh4JFAGO8tsdJbl0cHHBeEM7jfINdmKVlRonRJ?=
 =?us-ascii?Q?MrWzo9SsvlCrGTaKOYnXCXoEAUmNKyEFQOUt9CKxbbkPf9gclS9mdlSPfncT?=
 =?us-ascii?Q?tIsbIb4tudnQylltwoI5rThNGlqCfjK3TK3ddaxPtpz+w1yWz3OnF1JknZWE?=
 =?us-ascii?Q?X7mfyTGZ6twS0bZmwxzwP703AnhuMU4owoYyIcwOmn+jl7bX8ih3/ICHsyX/?=
 =?us-ascii?Q?Df5ZP5L7quGo2RmyiGXGhVbsryDJKqmuh9ZtrvWME0Cffuuv8tRmgvfm7NFe?=
 =?us-ascii?Q?F+8F4BgITkZ0qFgiY+AkfBb9WgAmJZyouVWjFpdEzguQLWlnwTDrgOgEgcmw?=
 =?us-ascii?Q?/SH6mxLwipisscAT25gW7DyA94o6ICiLyjq1HhS9Aodlcc2JYDp3JX0EgkAt?=
 =?us-ascii?Q?pFp9fQdJj9/MDNEn1BQi9SsUZh+5W0D9fBAZ0ZKZQwGuzpBVa+QykjwHl7R8?=
 =?us-ascii?Q?licEPPqhtDgR3WcP157ylNuBd1HU5knq8HL3UI/nt1pU+FXct8GDmxPcJS+F?=
 =?us-ascii?Q?qFN+wtn7qn/jo375qNwRrRRNaxdukVZjRN8DTc5i7GCIPGtxDYIxfHP3CZCe?=
 =?us-ascii?Q?31YiYZu9bEpqv1BHaHsU3xalmzdf9qu3cl0YoF6KYAB9VaOtD08MPdpCOOmi?=
 =?us-ascii?Q?0wGGsqHkrF84H7lMkwczI+dFVPR/vWVgUVnlUmyFMynhYn4Z8KatZbwlu9LS?=
 =?us-ascii?Q?IR/mHXO6DXk625O9+onOYSa7piYjr1YUD743drz5fK4Zxcy0cE89tbpZQKmV?=
 =?us-ascii?Q?s8Hnw0m5ynuKllwWbANoUDEaaDqEDAtPWKmF82s5vu1sLh5KoPRpLcGjD+MC?=
 =?us-ascii?Q?F9NPO+WmGu8JNfGP0ZTkJR6asYYz9SnUSCYib2HNy+O5aKvSBhblKXqg6PRb?=
 =?us-ascii?Q?gL82P9qEHQyul24z+uytM1ps+8H71CEjq5FVh7ChQVgJABKjlVw8QNMLUrzW?=
 =?us-ascii?Q?Svrj2ZlSPZ9cUXGoiZsdN3ao2oISsHfyiMOKKeeExlGJ6NC/1JrkUkj8b9P6?=
 =?us-ascii?Q?NICl0z1L2KSVP2x89n1LXmdbmej80+qEfyqxdvLJ+YKwIQ4Em0h+jamNeWW1?=
 =?us-ascii?Q?zLh0btlTqJP8++qtJWOinOvDvss+RouVPmFGFxOYYgoNMq66KcHwVMvl88/Y?=
 =?us-ascii?Q?juWfiiZ+htszc3LC1Q3y7ARly3uu7A8AmtreIMHhMYs6l0QLOa+7xmMLsblu?=
 =?us-ascii?Q?8zuCNPpsRe7loh15Qn0XZkipQzWn3UW6mfg90g6pF0V5z1chVBA/Ly6LzC4X?=
 =?us-ascii?Q?oOOlRyagrgUaZDqLhSsGE3bAOJTOArNDtZBzk5Oc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5342.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa81556-9236-436b-a00c-08da60c69b31
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 09:45:34.9702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a0BM5WeXwhFHHdg56YNnBITbFk5XfTa8hJH+3ouzohg5uVDGg7t0Ko/PPmZoz3J94sMfhrOvq0wT+GcTph6dEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4762
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Meenakshi, Vabhav

Please help to review the below patch..

Regards
Gaurav Jain

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, July 6, 2022 4:29 AM
> To: herbert@gondor.apana.org.au
> Cc: Jakub Kicinski <kuba@kernel.org>; Horia Geanta <horia.geanta@nxp.com>=
;
> Pankaj Gupta <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>;
> linux-crypto@vger.kernel.org
> Subject: [EXT] [PATCH crypto-next] crypto: caam/qi2 - switch to
> netif_napi_add_tx_weight()
>=20
> Caution: EXT Email
>=20
> caam has its own special NAPI weights. It's also a crypto device so presu=
mably it
> can't be used for packet Rx. Switch to the (new) correct API.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: horia.geanta@nxp.com
> CC: pankaj.gupta@nxp.com
> CC: gaurav.jain@nxp.com
> CC: herbert@gondor.apana.org.au
> CC: linux-crypto@vger.kernel.org
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 5 +++--
>  drivers/crypto/caam/qi.c          | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/crypto/caam/caamalg_qi2.c
> b/drivers/crypto/caam/caamalg_qi2.c
> index 6753f0e6e55d..56bbfdfb0d9f 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -5083,8 +5083,9 @@ static int __cold dpaa2_dpseci_setup(struct
> fsl_mc_device *ls_dev)
>=20
>                 ppriv->net_dev.dev =3D *dev;
>                 INIT_LIST_HEAD(&ppriv->net_dev.napi_list);
> -               netif_napi_add(&ppriv->net_dev, &ppriv->napi, dpaa2_dpsec=
i_poll,
> -                              DPAA2_CAAM_NAPI_WEIGHT);
> +               netif_napi_add_tx_weight(&ppriv->net_dev, &ppriv->napi,
> +                                        dpaa2_dpseci_poll,
> +                                        DPAA2_CAAM_NAPI_WEIGHT);
>         }
>=20
>         return 0;
> diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c index
> 8163f5df8ebf..1c9450b29583 100644
> --- a/drivers/crypto/caam/qi.c
> +++ b/drivers/crypto/caam/qi.c
> @@ -749,8 +749,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
>                 net_dev->dev =3D *qidev;
>                 INIT_LIST_HEAD(&net_dev->napi_list);
>=20
> -               netif_napi_add(net_dev, irqtask, caam_qi_poll,
> -                              CAAM_NAPI_WEIGHT);
> +               netif_napi_add_tx_weight(net_dev, irqtask, caam_qi_poll,
> +                                        CAAM_NAPI_WEIGHT);
>=20
>                 napi_enable(irqtask);
>         }
> --
> 2.36.1

