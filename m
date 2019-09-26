Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F58C432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 07:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183A4206E0
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 07:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="g72/cgbU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfIZHRd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 03:17:33 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:52409
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728268AbfIZHRd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 03:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN0SEmiZLgmGa+FJ+ERsNtuRcNiFvEYeqdGddvIqA65tuf/oVQbZDRhu2aGjx6hkRIrjNe4ybER5ekPC6mAncl98qo2/zoPQvcNw57fIcNzLX2MWnYDxkREs6QsLs8Jw/y+6CHLZOQFvLfl/1TnKPndbhgKrHONbS0g9TntbSxsqTd2JawLkwpuArDboGGnftNQoMn+U3U4JEbC9DN66/KlOa0WQFVUpYRBdLJu4mVaeGVCHOUK7GmCn/lDqwx0X89Ldgfg8BgLdLY04a4M09R9cdyKzSJgegi92hZp1DcOGfreQBCWC4dFxC7C9arKxP5FglrvxHqm9LYu6AiJcWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Usdii16aeL1V+iQtTRqfMYkpBPQOeTr4oZM0QgcsS24=;
 b=mSMl2d4yqsenMxZwE9SEZ76BRJCrUR88AAl2E+2KHrVY6QuDXG9I1GPCM1xxnw50CnGmphPEsuiNUAigZ3t/8/V+ayXE6WGqozl8y3W+1g6it5EXXYSU0ZLiRowRO6SHGgqiF036dP9UHnrH8Bxr8TCzTr6CUhJtg0KcI84L/6RxoXDYPsm2a5tkPw9NQbNtYBFOKG7cdVmXF+POiDRrX7Bhy4aMoSEQhF1d5A09W6ZdDIi3M3UecJDhC7mhEIHcmnIZz3DeI4QmzXqPE822YKKxJydwrC9P7Ic+04W6t6cfbX/rlqR/+w1SVLk4kL+zvtFEfJDmZa9XGGdfRtXT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Usdii16aeL1V+iQtTRqfMYkpBPQOeTr4oZM0QgcsS24=;
 b=g72/cgbUiYQV69UsPJ/MbiKg7eO5nB2TxV2mfLvoF67+hBWQmQruTpr28HYxLzCoJq/hEJFXZeUCBuyC5942oZQw0dI26sFP1iK70656vA65tKKqd13vXnq520ssS+ddQdpESkGcL0YTsXMITLk7Ty7xRRjSM6IVG1dHKW2lVlg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2749.eurprd04.prod.outlook.com (10.175.23.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Thu, 26 Sep 2019 07:17:28 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::b84e:b20f:138a:63e9]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::b84e:b20f:138a:63e9%7]) with mapi id 15.20.2284.023; Thu, 26 Sep 2019
 07:17:28 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - use mapped_{src,dst}_nents for descriptor
Thread-Topic: [PATCH] crypto: caam - use mapped_{src,dst}_nents for descriptor
Thread-Index: AQHVc6HU9i9GulTWykOrXicA04oXkw==
Date:   Thu, 26 Sep 2019 07:17:28 +0000
Message-ID: <VI1PR0402MB348551336691838632965ADA98860@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1569416676-21810-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe0bb9f6-bce5-472d-db0a-08d7425196e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2749;
x-ms-traffictypediagnostic: VI1PR0402MB2749:|VI1PR0402MB2749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2749815B2A34A78ABDC6805198860@VI1PR0402MB2749.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(102836004)(476003)(478600001)(53546011)(66946007)(6506007)(66446008)(486006)(3846002)(186003)(66476007)(66556008)(71200400001)(71190400001)(64756008)(14454004)(44832011)(316002)(26005)(25786009)(99286004)(2906002)(76116006)(14444005)(256004)(446003)(6116002)(91956017)(110136005)(5660300002)(66066001)(55016002)(86362001)(54906003)(6436002)(76176011)(4744005)(9686003)(52536014)(229853002)(8676002)(81166006)(7696005)(81156014)(8936002)(4326008)(6246003)(33656002)(305945005)(6636002)(74316002)(7736002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2749;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9TjyIB1ybIcVzEQ6q2rMpfyAq+fA5Tdkgi+EIUMy7/G+/o2xVD1Zmqz2a47F7nEUaFOymd5OPwvLFlOd725R5A4gdcs1+EFgGov2wr3whVadsBRKIGyCKlEdkn2M62o8mHdgle82tBLvfdyRIGHIAigLErHxSwGkrpoaF95xICrJc6Q6qgz16PbtYA6N8LGoAgBzX1saCRgA26USzK4arQhtBdl6vTOXqdEYyP2o7W1Ro/pr3MNirW5SuACRG0s68gf68rX44mmX4biZwr5NDU7alI5vIThJKrpKEGDZvBXLE1LqlzdhA8Y9bPWkFTE8Z6I14os4DXWlNI3/irlIuUWq2E1h9uXHREop1jkM3Vl1YIIkQxz4T1rF2PZEe4S2WInsgw8XPxPe890JRqPcOBhZ7mD4u2f1YKsTIOFfFgo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0bb9f6-bce5-472d-db0a-08d7425196e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 07:17:28.6171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nHszJG2elqD06cBE+I634zlZfZCD7RR0T0Q3BrX23ZQEJ7i1eHGgMheZQX/JX2wghiDh1Bti8WU1c04gB50bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2749
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/25/2019 4:04 PM, Iuliana Prodan wrote:=0A=
> @@ -428,17 +433,18 @@ static int set_rsa_priv_f1_pdb(struct akcipher_requ=
est *req,=0A=
>  		return -ENOMEM;=0A=
>  	}=0A=
>  =0A=
> -	if (edesc->src_nents > 1) {=0A=
> +	if (edesc->mapped_src_nents > 1) {=0A=
>  		pdb->sgf |=3D RSA_PRIV_PDB_SGF_G;=0A=
>  		pdb->g_dma =3D edesc->sec4_sg_dma;=0A=
> -		sec4_sg_index +=3D edesc->src_nents;=0A=
> +		sec4_sg_index +=3D edesc->mapped_src_nents;=0A=
> +=0A=
>  	} else {=0A=
>  		struct caam_rsa_req_ctx *req_ctx =3D akcipher_request_ctx(req);=0A=
>  =0A=
>  		pdb->g_dma =3D sg_dma_address(req_ctx->fixup_src);=0A=
>  	}=0A=
>  =0A=
> -	if (edesc->dst_nents > 1) {=0A=
> +	if (edesc->mapped_dst_nents > 1) {=0A=
>  		pdb->sgf |=3D RSA_PRIV_PDB_SGF_F;=0A=
>  		pdb->f_dma =3D edesc->sec4_sg_dma +=0A=
>  			     sec4_sg_index * sizeof(struct sec4_sg_entry);=0A=
AFAICS there are a few other places besides set_rsa_priv_f1_pdb=0A=
that should be updated:=0A=
	set_rsa_pub_pdb=0A=
	set_rsa_priv_f2_pdb=0A=
	set_rsa_priv_f3_pdb=0A=
=0A=
Horia=0A=
