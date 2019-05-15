Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D396CC04AA7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E542084E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GMSayusQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfEOGqx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 02:46:53 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:9737
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbfEOGqx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 02:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btTHRitrwesrTb0WgFFCXCFfFT0QQciVa1ooaDatsKI=;
 b=GMSayusQiudWvxXKcUjUkNsRkxp4Tnan32Nphqk7eCilrR5UOdhu/I3HjNqXbbvBMi/1bVp1TqgwOatnrPn6cSr5O+3Aw0IW6NpXz9AxxwdC94rYPZE3e6ykskionzFbDsJA3GZ4QCTt+Pfse+0XAJOUNzMqEBAYKsgbcvm7yq0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3549.eurprd04.prod.outlook.com (52.134.4.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Wed, 15 May 2019 06:46:48 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 06:46:48 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256) failure
 because of invalid input
Thread-Topic: [PATCH 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVCnRqYSdT4/1YZ0yCFxU3GNf2og==
Date:   Wed, 15 May 2019 06:46:48 +0000
Message-ID: <VI1PR0402MB34853587C20B018A8F53C2BF98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557852263-26896-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b1150cd-3f2a-461e-5468-08d6d9011ab2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3549;
x-ms-traffictypediagnostic: VI1PR0402MB3549:
x-microsoft-antispam-prvs: <VI1PR0402MB3549610F9EFB54BF799BBEE898090@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(366004)(376002)(43544003)(189003)(199004)(6246003)(44832011)(476003)(55016002)(74316002)(76116006)(316002)(14444005)(66946007)(6506007)(53546011)(25786009)(64756008)(66446008)(66476007)(446003)(66556008)(26005)(53936002)(14454004)(486006)(4326008)(5660300002)(256004)(9686003)(6436002)(33656002)(305945005)(6636002)(99286004)(68736007)(54906003)(7736002)(229853002)(71190400001)(71200400001)(81166006)(81156014)(8676002)(186003)(86362001)(8936002)(73956011)(66066001)(102836004)(6116002)(3846002)(2906002)(76176011)(110136005)(52536014)(478600001)(7696005)(32563001)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3549;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Og/9WwFjYmr4i36xki/femT7WxQ2+NwP4m/sVEkSRvAIxjXIsXapRp3mgJ9d8MR2xsPBK/uGzvnqlRRrDc1MJrg0BtL0mSBx6kZ+MqZV4eEFjzh5IfYHLsAf8Szt3nsDf26A2BbAsWKDf5P7kFPM7qGZ9k9nb2/0ZWMbJ+bwrl+2ntARjf0ZHOz15KbzJdV50eZOUcBFiJ6oSkb2K5I3ExIX5v/cSdIO91GYYzetRB+w1R/FLZUT1A/HRAKbG8wJttUHTdQDRFZQyK4xLdo6rQ4pQXMtdlhzGSNqwG+DW0Rs+0Yl17+YVpwV35zvZ1o0Kv68hxBt1aEE3zJpHcxEpgiA0FIew78zuiQD4SRCbtW+wuQnCmcJYlVvJ7dgO09Ntz61bTA7UnTufaYjoUIXZvg3XY20jOLnoMT+bx7lX/8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1150cd-3f2a-461e-5468-08d6d9011ab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 06:46:48.4692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/14/2019 7:45 PM, Iuliana Prodan wrote:=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.=
c=0A=
[...]=0A=
> @@ -218,27 +230,45 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akc=
ipher_request *req,=0A=
>  	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
>  	struct device *dev =3D ctx->dev;=0A=
>  	struct caam_rsa_req_ctx *req_ctx =3D akcipher_request_ctx(req);=0A=
> +	struct caam_rsa_key *key =3D &ctx->key;=0A=
>  	struct rsa_edesc *edesc;=0A=
>  	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?=0A=
>  		       GFP_KERNEL : GFP_ATOMIC;=0A=
>  	int sg_flags =3D (flags =3D=3D GFP_ATOMIC) ? SG_MITER_ATOMIC : 0;=0A=
>  	int sgc;=0A=
> -	int sec4_sg_index, sec4_sg_len =3D 0, sec4_sg_bytes;=0A=
> +	int sec4_sg_index =3D 0, sec4_sg_len =3D 0, sec4_sg_bytes;=0A=
Initialization of sec4_sg_index not needed, it's unconditionally set furthe=
r below.=0A=
=0A=
[...]=0A=
> -	if (src_nents > 1)=0A=
> -		sec4_sg_len =3D src_nents;=0A=
> +	if (!diff_size && src_nents =3D=3D 1)=0A=
> +		sec4_sg_len =3D 0; /* no need for an input hw s/g table */=0A=
> +	else=0A=
> +		sec4_sg_len =3D src_nents + !!diff_size;=0A=
> +	sec4_sg_index =3D sec4_sg_len;=0A=
>  	if (dst_nents > 1)=0A=
>  		sec4_sg_len +=3D dst_nents;=0A=
>  =0A=
=0A=
[...]=0A=
> @@ -1060,6 +1107,12 @@ static int __init caam_pkc_init(void)=0A=
>  		goto out_put_dev;=0A=
>  	}=0A=
>  =0A=
> +	/* allocate zero buffer, used for padding input */=0A=
> +	zero_buffer =3D kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |=0A=
> +			      GFP_KERNEL);=0A=
> +	if (!zero_buffer)=0A=
> +		return -ENOMEM;=0A=
Need to take care of freeing resources on error path.=0A=
=0A=
> +=0A=
>  	err =3D crypto_register_akcipher(&caam_rsa);=0A=
>  	if (err)=0A=
>  		dev_warn(ctrldev, "%s alg registration failed\n",=0A=
=0A=
Thanks,=0A=
Horia=0A=
