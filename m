Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8DDC33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A2EC2077C
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 08:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="D518acYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgAJIbm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 03:31:42 -0500
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:23969
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbgAJIbl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 03:31:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyFPOqqRRtqrBgI/p5FufTEoSpFThkOIwEaBby6XiZduFR2Z2nnXSKoLLA807XdWQmN8UhljOQiz/82AUCEQHIQZRNsYaVZN+Pg3w4cDJSSValQdEXwK2kIh9AuoBr7YgbsCi7nX2tP2fVP1NtsvjjQmLPYBLM+cQ8FZKaSaaxsBPCph4emhcJQpxn7v+MnEqGX5MaqpaJkhzmMJ/jnX8frS2RJMjSYIBh2FDo7XlV9LPOk8RkAkNBjxhRY6EKIf/7Evy/mvI/eEqqIF20mtGABd9If4OEYvtfvqC+47nE/RcInAMEvDk5+ojSiheCkZD84UxBRTS/GyROVW6qRYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLmUF+YroLx0VdAqzpsUB7wvvf3lHp2EubhDQqKskoA=;
 b=VsT7t8+dnjDqIt7r0dcZwZswuo7cTFZmGFQzsB84T1ykhwU5BRNEDQmBBeJmnzqZqTb6pAKenWsPid8jaCydX2J/M9Z8MCNUxtBCl1cfqymv1ze0uiYfTHCcZaMcg8xRqmxACletjIz5B7/xkMo+epb1fjDoMSjf0hBDZAEDlP/0n0yvu44gKpjgmnjyKfdLl8O195Mh29s/zoRUva+GQlAvjZcDvrfJVtLtQZAB9QXPC7zbYms6HGslKo8ciCiF3oCmozX529t+4T3sQJzmQ2m70Ub+o9o/VNAhIgyMG1n8hkuzGxthSO/howCE+6wmEr5/Fc7k9aUsmW3yRDoYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLmUF+YroLx0VdAqzpsUB7wvvf3lHp2EubhDQqKskoA=;
 b=D518acYF3kWKMJxnw7Weaf7Fga7qu8TwKkBo2+XWrUXMXwQ42iIq4QrCjKvbrwQnWl8ayBslQehViUmwMRt1glyhd+YSy+amMu7/SkuZLVAamoKzMYtqQnYkh6dlfNMPWcFeu6goa9zA2XUfIpBdq9sIU7gQ4+Vbxy89pA/w6v4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3487.eurprd04.prod.outlook.com (52.134.8.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Fri, 10 Jan 2020 08:31:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2623.011; Fri, 10 Jan 2020
 08:31:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 08/10] crypto: caam - add crypto_engine support for
 AEAD algorithms
Thread-Topic: [PATCH v2 08/10] crypto: caam - add crypto_engine support for
 AEAD algorithms
Thread-Index: AQHVwdGvJJHe3rGkXUy7JI3MEOJf4A==
Date:   Fri, 10 Jan 2020 08:31:38 +0000
Message-ID: <VI1PR0402MB3485A163A639D6434E166EEF98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb872179-d1ba-4a94-d6f0-08d795a78327
x-ms-traffictypediagnostic: VI1PR0402MB3487:|VI1PR0402MB3487:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34872DEF8F82D7D43FC7199798380@VI1PR0402MB3487.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(189003)(199004)(4326008)(71200400001)(8936002)(6636002)(5660300002)(110136005)(7696005)(4744005)(9686003)(478600001)(186003)(55016002)(86362001)(2906002)(54906003)(26005)(6506007)(53546011)(52536014)(316002)(8676002)(44832011)(66476007)(66556008)(66946007)(64756008)(33656002)(66446008)(81166006)(81156014)(91956017)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3487;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQcCV76ngMgJj5rPrWHoG1dMiktAU+yDpYaTo+1gaMJRmL2uiLTE99UuBIdPR/koQHyw1QmLzme2JbtSBeDq56NfbHc74nBgrN4n151VO9lm2D6ve+4mPI91aHlA15LeWl0nX9RPWvvaO0WiZtn8F85yPxKzMVbWnPXzf2ewcXI+ufjg3eU9O9NZCrIg7JF1YUHvoN4oBP2NFIRSgmFjoiRKfRGst+dtkJY/d4emIo/CHUlAscYv/TlkmaM3WTVhLurVanFNRaPqif7KEmug4Xrx+IQCtbcJlkMnNWqtRv1U9G8CkXiUOeIdKwZIjkQG4C5d6qv2l7BHWoIsFikD0HlgB76A+CBaIjrlsTcSQPFvAOfVgYWpExmZgWkMtlKHuu6OYRLQxApCIzKsTEOUJnZpl5XW99BElgCrgP/XSDYe+1LN4ID90YkeD+MIkD6g
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb872179-d1ba-4a94-d6f0-08d795a78327
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 08:31:38.7688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iJ51284OWmaB6PKIbe1PaQZP7Enn+iL5trkJde3U4zo9eIGzFJh5+Zv/FQaypY6CLP+rWw7LolNgIpqYuPkhUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3487
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/3/2020 3:04 AM, Iuliana Prodan wrote:=0A=
> +struct caam_aead_req_ctx {=0A=
> +	struct aead_edesc *edesc;=0A=
> +	void (*aead_op_done)(struct device *jrdev, u32 *desc, u32 err,=0A=
> +			     void *context);=0A=
Similar with skcipher, aead_op_done is not needed since aead_crypt_done=0A=
is the only callback used.=0A=
=0A=
> +static int aead_enqueue_req(struct device *jrdev, u32 *desc,=0A=
> +			    void (*cbk)(struct device *jrdev, u32 *desc,=0A=
> +					u32 err, void *context),=0A=
> +			    struct aead_request *req, struct aead_edesc *edesc)=0A=
cbk parameter is not used.=0A=
=0A=
> +{=0A=
> +	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);=0A=
> +	int ret;=0A=
> +=0A=
> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
> +		return crypto_transfer_aead_request_to_engine(jrpriv->engine,=0A=
> +								  req);=0A=
Resources leak in case of failure.=0A=
=0A=
> +	else=0A=
> +		ret =3D caam_jr_enqueue(jrdev, desc, aead_crypt_done,=0A=
> +				      &edesc->jrentry);=0A=
Need to justify why only some requests are transferred to crypto engine.=0A=
=0A=
Horia=0A=
