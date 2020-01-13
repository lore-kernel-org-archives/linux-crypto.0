Return-Path: <SRS0=KDyu=3C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EA3C33CAD
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 12:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E6152081E
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jan 2020 12:21:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="RuoE2PRJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgAMMVk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jan 2020 07:21:40 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6089
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbgAMMVk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jan 2020 07:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kO6MlYbubNL+yha9aHctjgpiH2KLHyygXALH/7vBaUDB0V4QlaUJwdubcHXCXLd3bFIsIfLeL4JN2OuTGAZBouSGWH6dnF6mzjpVOOewjPQml6nsLKNsIP5MHYl5wrxT+aTd0donKbaC7SvYPdZsSfM4IzWk1epKAtwYV05ZAipYq3b5QLWj7b26hTVjx3AziqC7zZ4343IcJ77f4Wwe8pAV5RcL9fRThznD+YgDS1x5Na92GGfT7ORmJvMqwWst7onxVfYqmFx4/yn8Z8085q+0dQopvnHHvun0R01hCHllVq7+jcicy9xCcez7GocO3DeIq9pcntc7yGT9SI2vrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ang5ANRrM8pxpVNnJnwHIonfBSIBRLgdWw0F+9dB6aU=;
 b=A2OaNXe12l2SfDe6XXPZf0Kbh7F1P5DiJEE+RFTgqC3NcZqWnv1oleh0Fj2cYW56V/DVJeIbxEEJeX+b0rQle2zwn+V23PxuwXHTEvQoI5kAGh6shTxEwwiIW57tB/yx1uzW3pAmN+2mcCcZVHMDeJN/tRowU81jKPY8xj8ctLNTw6BLftn+JSngR0sODdX8DDTdYVqnvxyNP7N0ik2ASiWDFQF1RIkfoRLLTqMpJLUt5RnTo6nA8nVqrHCzT5A4BMlyU2NF+j1u8j5/ud+HIM1I/7j3IPQ1XAMJfAvkg+EB6ZT2KpyHr5jMZpUkIATHTFaUau2gxUhNPo+HmGFSgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ang5ANRrM8pxpVNnJnwHIonfBSIBRLgdWw0F+9dB6aU=;
 b=RuoE2PRJO2J3gWfsWY5V6gtfxQF2as7z9p1REhnr3ayj21z7GSnd3VtrpCJQt2uPCKa0GYUN9d1W37Kq4H88q7Lf6m1zbl7NZIyu6D1Trohlvhanl/gPLUMyj1R6KZbrDY0nt8PscW1iCU7PNCxF8YA+g+iK7J5RFVkUmpQmKEY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3839.eurprd04.prod.outlook.com (52.134.16.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.15; Mon, 13 Jan 2020 12:21:36 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 12:21:36 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 09/10] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH v2 09/10] crypto: caam - add crypto_engine support for
 RSA algorithms
Thread-Index: AQHVwdGq8rD6kVc2eEOuvzLis67wVg==
Date:   Mon, 13 Jan 2020 12:21:36 +0000
Message-ID: <VI1PR0402MB3485EE10F3200D7E7EE1EBA698350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
 <1578013373-1956-10-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB3485162217C242B16CF1371B98380@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR04MB44452FF06F35075413CF87F88C350@VI1PR04MB4445.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 062cfdf9-58bc-49e3-641e-08d798232248
x-ms-traffictypediagnostic: VI1PR0402MB3839:|VI1PR0402MB3839:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38395B69D1DE05C6FA726E9A98350@VI1PR0402MB3839.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(189003)(199004)(81166006)(81156014)(9686003)(8676002)(110136005)(52536014)(478600001)(8936002)(2906002)(71200400001)(55016002)(86362001)(316002)(33656002)(6636002)(6506007)(54906003)(66556008)(66946007)(5660300002)(44832011)(53546011)(186003)(26005)(4326008)(91956017)(76116006)(7696005)(66446008)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3839;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3CZOgm2qI0oOeSZdx9OLwu4ps48Z70qzDCWtCV4FBzieqz1EzL9LmDByHjtXhQV+A8eA85AHHf04RXpftmbKjZ6LSG3byZ1suxY+NGa8HgZUV0V3Bvaxvzx5fWFXkgXXTZl5jwkYDvvSpxbx+XrPWQw+2cBhtcrPq4YAkhm/VeXhOLVcPkfRYpmZW4rwgKTOjJhihV0VaFIsbT6o2dVpYIloofYOSKGEzhfKQXxoXnazQF9rO7bVit7TdKno3OFWYqLIacwxwW//A5Pn0rjjlMTDdQ0CH52+sdphuArD3QrZSh+Awu7RjeukwgoEp1xXZwe4bCTF3EecHbGeuxzU2ub6tv2J3RVw1+EmUKVJZT5Oxn9pepH1LPamiwz0wcY+kuNdsdtVhkd2pvNstVmlJJmoaXqNhIN38BKvjFza+ZOXv2zOH5SHqIybnJmLigoI
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062cfdf9-58bc-49e3-641e-08d798232248
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 12:21:36.1512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F2QS6/JNnljPbSpjjtaaRxyilYnPUDiW/K1Mf6Y+x/mBfha5vgICQKJSwgRNHGwT5v9Qb1oO87nT5V8DUEZ2kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/13/2020 11:48 AM, Iuliana Prodan wrote:=0A=
> On 1/10/2020 10:46 AM, Horia Geanta wrote:=0A=
>> On 1/3/2020 3:03 AM, Iuliana Prodan wrote:=0A=
>>> +static int akcipher_enqueue_req(struct device *jrdev, u32 *desc,=0A=
>>> +				void (*cbk)(struct device *jrdev, u32 *desc,=0A=
>>> +					    u32 err, void *context),=0A=
>>> +				struct akcipher_request *req,=0A=
>>> +				struct rsa_edesc *edesc)=0A=
>>> +{=0A=
>>> +	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);=0A=
>>> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);=0A=
>>> +	struct caam_rsa_ctx *ctx =3D akcipher_tfm_ctx(tfm);=0A=
>>> +	struct caam_rsa_key *key =3D &ctx->key;=0A=
>>> +	int ret;=0A=
>>> +=0A=
>>> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)=0A=
>>> +		return crypto_transfer_akcipher_request_to_engine(jrpriv->engine,=0A=
>>> +								  req);=0A=
>> Resource leak in case transfer fails.=0A=
>>=0A=
>>> +	else=0A=
>>> +		ret =3D caam_jr_enqueue(jrdev, desc, cbk, &edesc->jrentry);=0A=
>> What's the problem with transferring all requests to crypto engine?=0A=
>>=0A=
> I'll address all your comments in v3.=0A=
> =0A=
> Regarding the transfer request to crypto-engine: if sending all requests =
=0A=
> to crypto-engine, multibuffer tests, for non-backlogging requests fail =
=0A=
> after only 10 requests, since crypto-engine queue has 10 entries.=0A=
> Here's an example:=0A=
> root@imx6qpdlsolox:~# insmod tcrypt.ko mode=3D422 num_mb=3D1024=0A=
> insmod: ERROR: could not insert module tcrypt.ko: Resource temporarily =
=0A=
> unavailable=0A=
> root@imx6qpdlsolox:~#=0A=
> root@imx6qpdlsolox:~# dmesg=0A=
> ...=0A=
> testing speed of multibuffer sha1 (sha1-caam)=0A=
> tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):=
=0A=
> tcrypt: concurrent request 11 error -28=0A=
> tcrypt: concurrent request 13 error -28=0A=
> tcrypt: concurrent request 14 error -28=0A=
> tcrypt: concurrent request 16 error -28=0A=
> tcrypt: concurrent request 18 error -28=0A=
> tcrypt: concurrent request 20 error -28=0A=
> tcrypt: concurrent request 22 error -28=0A=
> tcrypt: concurrent request 24 error -28=0A=
> tcrypt: concurrent request 26 error -28=0A=
> tcrypt: concurrent request 28 error -28=0A=
> tcrypt: concurrent request 30 error -28=0A=
> tcrypt: concurrent request 32 error -28=0A=
> tcrypt: concurrent request 34 error -28=0A=
> =0A=
> tcrypt: concurrent request 1020 error -28=0A=
> tcrypt: concurrent request 1022 error -28=0A=
> tcrypt: At least one hashing failed ret=3D-28=0A=
> root@imx6qpdlsolox:~#=0A=
> =0A=
> If sending just the backlog request to crypto-engine, and non-blocking =
=0A=
> directly to CAAM, these tests have a better chance to pass since JR has =
=0A=
> 1024 entries.=0A=
> =0A=
> Will need to work/update crypto-engine: set queue length when initialize =
=0A=
> crypto-engine, and remove serialization of requests in crypto-engine. =0A=
> But, until then, I would like to have a backlogging solution in CAAM driv=
er.=0A=
> =0A=
My point is you need to add details about the current limitations=0A=
in the commit message (even in the source code, it wouldn't hurt),=0A=
justifying the choice of not using crypto engine for all requests.=0A=
=0A=
Horia=0A=
