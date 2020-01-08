Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA9FC282DD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 17:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86F672073A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 17:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Qqz4QYYd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgAHQ75 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:59:57 -0500
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:34567
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729555AbgAHQ7z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 11:59:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/9pmop6R6gXhYgqG+ZQtWBwwZ6opJgZBcfuEqyVsl3s8eHHkxRrsfvAUH3vANuNiAypfcywKjcK3iS2aSjdkC9dJLS5ColwpejYDdHQL3WwWXxV06f3dgSXFNfTw8OYGAFG3bZ7EPfoAAffAFOCCDtBcrCuxheWSlaGea1qkLVA8vrPn43R+FTrQ7XC5X7bOj/wsDrJ3Yu+HHLda+WQ+sfn90pRbI3Dm7DTKugvxR6edQb2pMa4yxWGugVZzLtuK3RKXJTxS5SKs0H06TdTG1uufsyHP18qdxpW2YWRKqkQed0isKMMzpPH0XEMGPyMRwpssGWL4E4axQAj8H1fgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsVExKfSNysx3JQYrkGKoybIoK8bY9SRiJ3jbNGFDwU=;
 b=mBxqehX7XjITCVlr47E9zt5ebj4LouzMRmEbFodWDBqhWjUBnHiy0C5RvXfzpUV+2S0shgKpP0SLrn5yJwe60e+bLcyt9ro2frdeoFvCEHof9v6V0otD2KSDyAkckXJShLvz4pFfJMMcIDltkhrOh+nj+hs+jCRbBiM3gRn/H8nhy208YViN24CWdjH2xXzg2FPWKFqEvdkQ0TubqawlZQtA3FKdh7UrIF+snLQ4ozPRTD6S1Pl35r0UfNaFfFpEW5gyJZchEnfigPbrSfwVhyZhPbaNhOC+L3kvr/JCQCTLtNKGB28r1rhjYQiBYDNzvoFJRM8DFJDEUUrWHQgtmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsVExKfSNysx3JQYrkGKoybIoK8bY9SRiJ3jbNGFDwU=;
 b=Qqz4QYYdNqc5tI2yA+n+ksA83AIxQWUmK7inqxGcOPkBoBb276mPsClSRXprgjn2a+wfiI+EI6kjemeRMx2lpV5Q5mMVM/iBSzE54HSh2eLYg2Xe+nxtiMKZ1/b2CEFg2+5W65HdQAN39/EW9hoOaF35CahRxT0PRSumgnQOE9E=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3855.eurprd04.prod.outlook.com (52.134.17.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 16:59:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2602.015; Wed, 8 Jan 2020
 16:59:51 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 06/10] crypto: caam - refactor caam_jr_enqueue
Thread-Topic: [PATCH v2 06/10] crypto: caam - refactor caam_jr_enqueue
Thread-Index: AQHVwdGz6i/Y7lkd70GPiPG71gFRzw==
Date:   Wed, 8 Jan 2020 16:59:51 +0000
Message-ID: <VI1PR0402MB34852528A105E1C472686078983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-7-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c5bd083-0769-4dc9-8a55-08d7945c2d3c
x-ms-traffictypediagnostic: VI1PR0402MB3855:|VI1PR0402MB3855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3855F9D0D1EECF87DB420F8B983E0@VI1PR0402MB3855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(189003)(199004)(76116006)(478600001)(91956017)(8676002)(6506007)(44832011)(4326008)(7696005)(186003)(53546011)(81166006)(26005)(81156014)(2906002)(66446008)(66946007)(8936002)(66476007)(66556008)(64756008)(5660300002)(33656002)(110136005)(86362001)(54906003)(52536014)(71200400001)(9686003)(6636002)(55016002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3855;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UdX5lOixl8EQ10rLlKKqRTsSVFb9wNPk8PWEMsltnJH0U6mZrcn/J23KX+O4jFo0TSkXXlf7NqsKX8H37jMAyPU5nH0jS6E7uIpbgeqaXqi0dFdX7rbRw9eVrSXWTKkswMHtTsJyYBbFX1cpHmfRoKRPvU4RHTFEBYrQH+KO5y/ZlOMaOb4V2l4rpbtU3thEfuq95nNPSSLtnhK8kx8qdthoUI4p6/z1j8Kffhu9jWZQOPwU842chyQMWVefRMUy4XRnufwuhqr6MT94QXaXwoxl6qWncC5NnAdt+/LXvlwb8HEWRLfGX0iPyTOmdvKY8/5B0+HBvbbkSaOtFvSRo3P0llD3i2FnDCY0upQwmILMSIqnB/3hjJMj/Y9M+L6/8fTMhvx+2ow3LZZCxPbgMGGdxtsBuH9KdDS8ZM/Cnz6Gc8DTJkxF2IfCRfapGDQR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5bd083-0769-4dc9-8a55-08d7945c2d3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 16:59:51.2559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmF7VHUoa13+rboWoUj19BeyrzgCc74IpqzTgM+uEeb3COpcFcHny8OmW3Duj0t2s+ZeYpQHyK5svg2nptQPeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3855
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/3/2020 3:04 AM, Iuliana Prodan wrote:=0A=
> Added a new struct - caam_{skcipher, akcipher, ahash, aead}_request_entry=
,=0A=
> to keep each request information. This has a specific crypto request and=
=0A=
> a bool to check if the request has backlog flag or not.=0A=
> This struct is passed to CAAM, via enqueue function - caam_jr_enqueue.=0A=
> =0A=
> This is done for later use, on backlogging support in CAAM.=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index 21b6172..34662b4 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -871,6 +871,17 @@ static int xts_skcipher_setkey(struct crypto_skciphe=
r *skcipher, const u8 *key,=0A=
>  }=0A=
>  =0A=
>  /*=0A=
> + * caam_aead_request_entry - storage for tracking each aead request=0A=
> + *                           that is processed by a ring=0A=
> + * @base: common attributes for aead requests=0A=
> + * @bklog: stored to determine if the request needs backlog=0A=
> + */=0A=
> +struct caam_aead_request_entry {=0A=
> +	struct aead_request *base;=0A=
> +	bool bklog;=0A=
> +};=0A=
> +=0A=
> +/*=0A=
>   * aead_edesc - s/w-extended aead descriptor=0A=
>   * @src_nents: number of segments in input s/w scatterlist=0A=
>   * @dst_nents: number of segments in output s/w scatterlist=0A=
> @@ -878,6 +889,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher=
 *skcipher, const u8 *key,=0A=
>   * @mapped_dst_nents: number of segments in output h/w link table=0A=
>   * @sec4_sg_bytes: length of dma mapped sec4_sg space=0A=
>   * @sec4_sg_dma: bus physical mapped address of h/w link table=0A=
> + * @jrentry: information about the current request that is processed by =
a ring=0A=
>   * @sec4_sg: pointer to h/w link table=0A=
>   * @hw_desc: the h/w job descriptor followed by any referenced link tabl=
es=0A=
>   */=0A=
> @@ -888,11 +900,23 @@ struct aead_edesc {=0A=
>  	int mapped_dst_nents;=0A=
>  	int sec4_sg_bytes;=0A=
>  	dma_addr_t sec4_sg_dma;=0A=
> +	struct caam_aead_request_entry jrentry;=0A=
>  	struct sec4_sg_entry *sec4_sg;=0A=
>  	u32 hw_desc[];=0A=
>  };=0A=
>  =0A=
Now that most of the backlogging logic moved from the backend (jr.c)=0A=
to frontends (caamalg.c, caamhash.c etc.), it looks like there's no need fo=
r=0A=
all the *_request_entry structures.=0A=
Instead, bklog flag could be added directly into the corresponding=0A=
*_edesc structure.=0A=
=0A=
Horia=0A=
