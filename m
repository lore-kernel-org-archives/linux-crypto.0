Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE88C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 18:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiDPSDK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 14:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiDPSDK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 14:03:10 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EB53EBB9
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 11:00:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksFPlydlPBm5pHqn3y8gymsg5YolMfURt61di3bOxOYR8a5jCocOIlczPk1l3KXNH4Vg1a7+T6GOAp+FS1LYj4Hy5hhKhkSQbPgHjpLdMoU+K+WzckRalrySWqjwk6RJ1WMmI4zoQTzb3/XPd4HDyK45PqyFXla3uTHaF2X/SsmAaS7fTfN03tim2nnQouSD1Ps65L2YPpe1k5Vx3onHvwl9PR6XFoy3vqmx+R+wlMmAgNUx7rzZ0PeuyYjzF1fuEPy24+WBr9prqTa632QHiyeXdOXRLGunXk65q9n1nxX1pG1RfQX0GaxEgTLqMco2Mbr+q0cN1cHsHQAiVcgAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3NwxS3xZU3gY4dSBT8OgTxk5xo7VYgaqWGMj/NS+eI=;
 b=PS7uSre6azTqyEKgb0usRvy4DqVFpALICJU4kCwwlB2Jel1EOi3dZiGNM+i8V7a2E0WPz/evd0cXK01oitjoQG90snExF6jMLPj3RycunGf99Djet+wMFQDRNNqa33HFRIVbjp/+e8pBu/UxSmHsKlLiqFVt9GHNoCForgFypUthLVa4/7/EGkI63yxOtHfkIkENhRDsxyIFhQZxrx4GyNh1V6/y2DduZ23fG0++ciFJxvOsw+d6pAq5djjl1O7YX6BcNbpaKVEwXFIlIOgNjSJ89kY/z+88qxWvlxo/6pg5SLbNeQYULYHSNTE0W4MxJk9mjkGkbk0FF9mSFcOYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3NwxS3xZU3gY4dSBT8OgTxk5xo7VYgaqWGMj/NS+eI=;
 b=Wkwwl/v+Ss05nHvRHYb0bwWboiz4jzicG+shjBTX6drrVH5LB2ZdqukrY0cnC/5h7RM0YpYrqBip7msVeB53lJLzK+t5knt2eYEx16XIwV3jxFC4qGnccDW+/FiNxa/QhPj8x+NLWCnrWsTmztILTsT5nYehK2xdZfIFo5a9tYI=
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::17)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Sat, 16 Apr
 2022 18:00:33 +0000
Received: from AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e]) by AM9PR04MB8211.eurprd04.prod.outlook.com
 ([fe80::653a:305c:1f26:a34e%4]) with mapi id 15.20.5144.032; Sat, 16 Apr 2022
 18:00:33 +0000
From:   Varun Sethi <V.Sethi@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vabhav Sharma <vabhav.sharma@nxp.com>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Subject: RE: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Thread-Topic: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Thread-Index: AQHYUZmQg66H5GpCqEmaCXX+FqD/z6zy0zog
Date:   Sat, 16 Apr 2022 18:00:33 +0000
Message-ID: <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
References: <20220416135412.4109213-1-festevam@gmail.com>
In-Reply-To: <20220416135412.4109213-1-festevam@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ace476e0-8175-4f45-f741-08da1fd30082
x-ms-traffictypediagnostic: PAXPR04MB8238:EE_
x-microsoft-antispam-prvs: <PAXPR04MB823875813CABDAB717AF5356E8F19@PAXPR04MB8238.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CohyrfVO+RDGxFFvzBuuDIW8hz4tPIzwBUU7ymMNwpge+RbEyNMUtUDukvM9+yui4n4i3KVm8UIWulY6Xzx7lV6CbfsUPn+xp010vjh8olDTOY8OAyak3oxJwslfjOiEmTJwHpy7D5jC3hTNRK1nGIGvcOoLunMlQQAQrVaqcYkQVDc3mNh0ODaoovB12zgnNWBJh+CwD+GwEXCVVPEpoki4CdWN1rSsi7NKWCIBDjoVj4RUrYnGu0SmuZLOG9OYuYz4LhOjsEXGdmVVsU9hq49i6aNjtHgc3wI19QlDNyVZHvmcCowm0fDmzozQxSx0fo4cRXJF63IYT1a2Eyan/W9/c5CtZy7gkiceOJ9RmmGRkitK2a4LPyhn/BS8pT5WEATQIpmtZNAQ0pVy1Ao9MoynapJ6R0EyAsJ9mDjhz8sPebcoNAsFeNfKCNcmRw3C77e32VToQCYwfwgqFwcFDmnRsDkWEts7Cl55qsbpVwMRXc8tJcw4g4kgnXAHRLqNaN6/fwsGJKn6nVFB5CjkdwDqdocRxXmHCdfg6/1IzY1L/OKCyWeeAAxCt4XMTnsn/Y02jbrGHIt2p1NN/VdJlnCHey6Vg1UhWGlPiWhjFd6w8blDay0JHZFPl1aj7PZ+kGvf63LHtqr1VcY0vqoFmK+5Gr9IKcl8L9tek3oiWqg+4ZW8RDbTqFBErrxbQhvz9Vaz6Ao00zwiWrnrfJwQlYcuOZniqVPZnYStYy9oqdiu+7Qc2RhxoBtmRZmSngHatucpCjhsz9LhgQY/YvjAPsDTZ10Kpahp41kuKpceNuw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8211.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(6506007)(7696005)(45080400002)(4326008)(26005)(66476007)(64756008)(8676002)(66946007)(66556008)(66446008)(5660300002)(966005)(54906003)(71200400001)(186003)(508600001)(33656002)(52536014)(55016003)(8936002)(83380400001)(6636002)(316002)(9686003)(2906002)(38100700002)(53546011)(110136005)(55236004)(122000001)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MaijcOXOzESbMm7lOKvTRCWHpHkKShskCHNiDPsI9z3oE/RMLil/t2/b0lMl?=
 =?us-ascii?Q?jWWa4DgVjEmvyxA7xoESPcEj8236kQ5h0pVcKsR1Zm+e5M0W21+Kpu65+jtM?=
 =?us-ascii?Q?L9vE+lggn4IM8Qf+cPiTVsCpNfbxI1jAtHLuBcKr3cah0B3dMBUDioFCRzvv?=
 =?us-ascii?Q?l9vkV3YNqogIRlrZ+1cnSMqG79P+KsfiSFOzzWtCPX8hd+fNFJeTddfvlZss?=
 =?us-ascii?Q?pa6otcKD0MeyGhHic+0i4WCkv7VOBRHcUr1jpyPkl1Aqfnn9wjga8D3NXU95?=
 =?us-ascii?Q?+fjfTQYe18IHOWSZK896soK0gGAboLd8KUK0rtdQPXhnvyFzVY2oeK4wnqED?=
 =?us-ascii?Q?BdnG3qpWKJaNhplbTntHjgcrvuZoSc/f/Y26GAx6puGYsKl4mfvhZNKQ2tXX?=
 =?us-ascii?Q?ZZiq01y90HjUWwme7YWQSTzfr3JkSmxUKN87d3vu6OZvKbwkMuVL7SwvsFhc?=
 =?us-ascii?Q?sCZC1NgQwtKrsE/c5LN9oHhta0piY7lRVb6hF88h5f9ZFSYs3cqDhkV5CQNK?=
 =?us-ascii?Q?JBCyGafqTRNogP/m+HMDIlOcWh/+LOPgQKnCR9q4GTOtuF1aFhBn+IAIVBwH?=
 =?us-ascii?Q?NQOUflxJUchuhgQ+alEswzrZO9FlrDGJZmRrh2bu2j1PTljLl6VeHeF9KuI1?=
 =?us-ascii?Q?WhLNo/oZaQjem33r9xiotk6GWkdb5pL7pGO+cSHBEflKh+z7bWofmLLbXhpL?=
 =?us-ascii?Q?07Uml6gS6o6Wm3dFJPROTGEv81qOs/o15ThmjHoflKJR44b+65zczMO7UQdB?=
 =?us-ascii?Q?XVh0k3HbvPQ5Eas5XGhdLKmTnQ2CbadEiUmooxl/1/R4nk1kRQG/W6YIw8tO?=
 =?us-ascii?Q?/47CYmxMoi2ELedI5qHTU9tC+nNX5DzjZryR+Kjj6mmP++f7yMWO03iwie0P?=
 =?us-ascii?Q?agLJayMscFG6+oLDchUvebDgNX3qyQ5rEk2NMbpXNbbuNBgLYrNjn40TFoNJ?=
 =?us-ascii?Q?aRM8Ih6z/HmCkj3JBKJoGHZXAWYEGnM5jzjE/8kiOmPJJojFTZkoSYrYW4kT?=
 =?us-ascii?Q?hfQ/nEiVdbZXOo2OgmtVsGHMpG/iRSQdQsLKEDrDg3poElYb/66hkaTzhnzL?=
 =?us-ascii?Q?P3xvZBMDwVvTPFO8JnOeJXtOPWyXh7ztuXd7mOrcG2mF+nfe2tzFI+/P8Pr9?=
 =?us-ascii?Q?sUfv0xOvW2uVmQoPU+agvKEmRsFOOo9K9mq3L3azU+1xYdGpfOUy1gYSBYl1?=
 =?us-ascii?Q?yvhhG3ahVcu4KEQDS3DwaSCGV6fVmS7LejySpgE0zpKC/pCwVi3trBrnGB7+?=
 =?us-ascii?Q?IrhS/h8IPJQQ6Td/O2dCEZfapnSCPMW7d+yITEN1n2cy+Gro8Mo9RSSk3XKn?=
 =?us-ascii?Q?BoerWxbgugXsZltu+OLTcTOy9w72ZX4O7Mcea7WqLOxWKGK5fkrJWzbLy3yJ?=
 =?us-ascii?Q?ZQBfElReXgdN5yJJfjemr9nCa9UurXXQFGdqrcbOp5blAQ1GvNDgU0lJkU0U?=
 =?us-ascii?Q?72C/mFnoHhGaZy58SMdalyNrBx0fqLWkjwcZVB2zp1/vja12hC1X7gq9oME7?=
 =?us-ascii?Q?3aoEpiHwY03TqYavj8OvAnBK6YQFI04ziSaTJ7rHwC0nYTnz9RWHYKOrw7Hx?=
 =?us-ascii?Q?D3I3xRfN7nBgEb1Z39lFsv4rIHvdHx9FfxjncCQlhwtS8XPvxsgVPvaNpe0b?=
 =?us-ascii?Q?Lp/Dh/LCuKjFUYoQwTHHu1gqd9QYMX6cCFM7LiSIxNSbdJENx9SxQjvlKJ2v?=
 =?us-ascii?Q?U+z4y2g3eMSUG1++Lm60U4oM5JMERIWvqYRPSuG0E87O4S/F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8211.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace476e0-8175-4f45-f741-08da1fd30082
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 18:00:33.1927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6kBJGNzDP4WEhw6Xus3tL1FlzYt/gKCYkhfYl3NJB72enIlx+iFTYWq46culvyhs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fabio,
Vabhav is working on a fix for the Linux driver. He would be introducing a =
new property in the CAAM device tree node, which would be used for specifyi=
ng the entropy delay value. This would make the solution generic. This prop=
erty is optional.
Also, please note that the entropy delay value has been derived for i.MX6SX=
 after a silicon characterization study.


Regards
Varun

> -----Original Message-----
> From: Fabio Estevam <festevam@gmail.com>
> Sent: Saturday, April 16, 2022 7:24 PM
> To: herbert@gondor.apana.org.au
> Cc: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Varun Sethi <V.Sethi@nxp.com>; linux-
> crypto@vger.kernel.org; Fabio Estevam <festevam@denx.de>
> Subject: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
>=20
> Caution: EXT Email
>=20
> From: Fabio Estevam <festevam@denx.de>
>=20
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance i=
n
> HRWNG") the following CAAM errors can be seen on i.MX6SX:
>=20
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error ...
>=20
> This error is due to an incorrect entropy delay for i.MX6SX.
>=20
> Fix it by increasing the minimum entropy delay for i.MX6SX as done in U-B=
oot:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch=
wo
> rk.ozlabs.org%2Fproject%2Fuboot%2Fpatch%2F20220415111049.2565744-1-
> gaurav.jain%40nxp.com%2F&amp;data=3D04%7C01%7CV.Sethi%40nxp.com%7C7
> 9659c64ea334807ca2c08da1fb0b1b3%7C686ea1d3bc2b4c6fa92cd99c5c301635
> %7C0%7C0%7C637857141005203180%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi
> MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> &amp;sdata=3D%2BpR3ecPQNZ001zRGWe%2FWo%2FayfltO6zYK1p%2BwQ57c6J
> U%3D&amp;reserved=3D0
>=20
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Change since v1:
> - Align the fix with U-Boot.
>=20
>  drivers/crypto/caam/ctrl.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c inde=
x
> ca0361b2dbb0..c515c20442d5 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -648,6 +648,8 @@ static int caam_probe(struct platform_device *pdev)
>                         return ret;
>         }
>=20
> +       if (of_machine_is_compatible("fsl,imx6sx"))
> +               ent_delay =3D 12000;
>=20
>         /* Get configuration properties from device tree */
>         /* First, get register page */
> @@ -871,6 +873,15 @@ static int caam_probe(struct platform_device *pdev)
>                          */
>                         ret =3D instantiate_rng(dev, inst_handles,
>                                               gen_sk);
> +                       /*
> +                        * Entropy delay is calculated via self-test meth=
od.
> +                        * Self-test is run across different voltages and
> +                        * temperatures.
> +                        * If worst case value for ent_dly is identified,
> +                        * the loop can be skipped for that platform.
> +                        */
> +                       if (of_machine_is_compatible("fsl,imx6sx"))
> +                               break;
>                         if (ret =3D=3D -EAGAIN)
>                                 /*
>                                  * if here, the loop will rerun,
> --
> 2.25.1

