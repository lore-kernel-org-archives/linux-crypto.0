Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6A3C46470
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 22:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A4726250
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 22:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OBwDK5n2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE3WAr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 18:00:47 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:21566
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbfE3WAr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 18:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rb7SlVs13HMhFjzgqp6Uf0KOsaQIZ0naFm1S4PgFJDw=;
 b=OBwDK5n23erKtdqurAo3oc4WROwSw6qGjiXgZmlbtT4VIirTVLwHXvZzCIQ8AxvH9JQy8H79OMW4aphYFPreFw1v32l8zC8MZLphqCu0eWa8IFfEnYEvxMbvNsZJysjvNw7I31gH7B0cmwNDbTtZi29ryJjiudXjziI1Y72/Pcw=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB3120.eurprd04.prod.outlook.com (10.170.229.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 30 May 2019 22:00:41 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872%7]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 22:00:41 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF/PjPULMOhfkiEXDJZ6fiBzQ==
Date:   Thu, 30 May 2019 22:00:41 +0000
Message-ID: <VI1PR04MB44453A74B90C08AF14CED7DE8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
 <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
 <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
 <20190530143438.d62y3woaogyivqpm@gondor.apana.org.au>
 <CAKv+Gu87wkLkZZLfsJwc02yuKpDx7Sa=Nx+1YW8pPE4DoWXGRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2082bcdc-facd-4552-142f-08d6e54a41d6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR04MB3120;
x-ms-traffictypediagnostic: VI1PR04MB3120:
x-microsoft-antispam-prvs: <VI1PR04MB3120ACF542949C6A7B0F82BB8C180@VI1PR04MB3120.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(366004)(396003)(346002)(54094003)(189003)(199004)(91956017)(4326008)(76116006)(44832011)(81166006)(64756008)(476003)(102836004)(6506007)(229853002)(3846002)(81156014)(478600001)(316002)(66476007)(66946007)(446003)(6116002)(76176011)(25786009)(68736007)(66556008)(8676002)(86362001)(66446008)(71200400001)(52536014)(71190400001)(486006)(53546011)(5660300002)(256004)(99286004)(74316002)(73956011)(53936002)(6246003)(66066001)(8936002)(6436002)(54906003)(2906002)(26005)(186003)(33656002)(55016002)(305945005)(14454004)(14444005)(7696005)(9686003)(7736002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3120;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +nwIWaTlOJijHtCig8jeeLVG2745XxbD15US7cpL4D3U4XLtF/IOXbPfWS0nOB57MGXYom1k/dDWitrFY+ca7FuafLDVqfhrV8T1pw+1anXgfzV3L2Y3e8x1E5Nd7k8E9djlEnxjgv2BG/uk2F6q7YjYAuAihbzvqYr/MTrGnaj85kYoeMHZtiL01hwWJ1mOH9u4pY+9rEi8cxduQS+Xk6yLiVgThM+Rs4nPr1F1QKBXk3LnLiPbctQfUcc4nKsYdNxux1Zo1XMa42jltILIBtgT/6Ex69s6YuIuy8lXCdpydlcXgk6R0eUThUrPPt2sbNGECVHY0rTXfPZZUz1CcXneLnK8E59VwoPDO+Pnh+3Qw4hBHhdTv9EJP9W4uuLosMVceesA+bg4EmaEgyF0NTPVHk2+q6cPqjK9+BKm5Og=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2082bcdc-facd-4552-142f-08d6e54a41d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 22:00:41.3703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3120
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 6:05 PM, Ard Biesheuvel wrote:=0A=
> On Thu, 30 May 2019 at 16:34, Herbert Xu <herbert@gondor.apana.org.au> wr=
ote:=0A=
>>=0A=
>> On Thu, May 30, 2019 at 04:31:09PM +0200, Ard Biesheuvel wrote:=0A=
>>>=0A=
>>> This might work:=0A=
>>=0A=
>> Looks good to me.=0A=
>>=0A=
> =0A=
> Thanks Herbert,=0A=
> =0A=
> But given your remark regarding CBC being the only algo that has this=0A=
> requirement, I wonder if this might be sufficient as well.=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index c0ece44f303b..65b050e3742f 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -1844,7 +1844,7 @@ static int skcipher_decrypt(struct skcipher_request=
 *req)=0A=
>           * The crypto API expects us to set the IV (req->iv) to the last=
=0A=
>           * ciphertext block.=0A=
>           */=0A=
> -       if (ivsize)=0A=
> +       if (ctx->cdata.algtype & OP_ALG_AAI_CBC)=0A=
>                  scatterwalk_map_and_copy(req->iv, req->src, req->cryptle=
n -=0A=
>                                           ivsize, ivsize, 0);=0A=
> =0A=
> =0A=
> Iulia, Horia?=0A=
> =0A=
I can confirm that gcm (and ccm), with ctr-aes-caam, is passing with the =
=0A=
above fix.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
