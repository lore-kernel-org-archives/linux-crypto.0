Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5EBC43215
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDAF42075E
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:06:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Tm5KJTcV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfKVLGD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:06:03 -0500
Received: from mail-eopbgr10040.outbound.protection.outlook.com ([40.107.1.40]:51943
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730559AbfKVLGD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwBpT0Iq17NvwUcydoo+EV1zc1llVZ0/8ykRqUWVYeuLZkLY9yTiM/d7xAqRvxA1lbxibw6UDNXfstB/k6fy5jfBfssiNWBzGY41iOD4H98/q3MrRVHAwREWXrnh9cSDBIHkxfGCf8E4MSFg4CyZ1TBoTfXij2d319bVuG0OiKifqn+PcQ3q66D+454NalA1Ym7Cu6cvSMdGpz3A38NSYWsnZZvQawYySUHa76D4xSJ33rfFISoEYNvgkz2pWTgR4xuhInkzpdpINi1fHrDWeZpENV5b1MZOc3tG0vLQPRnkGy1fqAVaaF4++DeaciDbgLqHWM0mmz357vBzCv3VDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vukLchv3Jxu3895xHcndGe6HUbIis8l1yK6kQgM4RZE=;
 b=DhlnZcb5FGmFFprLGLj/YTPNUr4SBmOttELwmTr0Bz+8gHOXNNwSyp1N0n1hujxyGLvfRspAZfc/noMJCDt793PUcDvIlT80oaBUn/wH9E0kTi3XBv3+BZbJdLLCqc8RZ0wE+RaQV8mV+QYAe6Mz4n6ds1pcm0C8pd3eebnK2UAF6sileG19UL5TSApWtI2hkLAc9ANeNtsej2pDAlcDEKm54qnlMqDfsq8KqJ/QSTaZtY+7mQe1Nj7Q7f/JHTXpkpW+9ghfqVFoUElYuEuNyf0EYBwl0+Mzv0ENi5oZ+eEIRPx7VoPpsKmLLAYcjA0LpqUhu9eMVaqr6/EvRgArdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vukLchv3Jxu3895xHcndGe6HUbIis8l1yK6kQgM4RZE=;
 b=Tm5KJTcVPPtXHzEgGTHEZVnvbH7taiPEjFhoG39i6N7sObVIiRBp0Sj/YOw8UTqTYwZcwamPMcv9E0BBAmYQ8qlOGhmI0eUA6cGrAAfgJKFZS/UEuCN3tehpQysuh64vgU16QP7Ue/ZtXPOLqvKSGl0z2WCI325aqubmnXS0ycA=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4206.eurprd04.prod.outlook.com (52.134.123.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 11:05:59 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d%5]) with mapi id 15.20.2451.032; Fri, 22 Nov 2019
 11:05:59 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Topic: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Index: AQHVnZa0/lOdW2TUXUqvGjTaL30gkA==
Date:   Fri, 22 Nov 2019 11:05:59 +0000
Message-ID: <VI1PR04MB4445DACDF6F1AF1CDABC6E7A8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
 <20191122103309.wf2hg7km45ugzzhr@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2110a36d-a19e-4a74-4748-08d76f3bf4dc
x-ms-traffictypediagnostic: VI1PR04MB4206:|VI1PR04MB4206:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB420611B3FDDB74C59FB620548C490@VI1PR04MB4206.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(199004)(189003)(305945005)(6436002)(8936002)(7736002)(102836004)(55016002)(86362001)(186003)(44832011)(446003)(52536014)(76176011)(81166006)(7696005)(14454004)(6916009)(5660300002)(81156014)(478600001)(71200400001)(99286004)(33656002)(71190400001)(3846002)(53546011)(229853002)(6246003)(66476007)(6116002)(2906002)(64756008)(66556008)(316002)(9686003)(8676002)(6506007)(26005)(66066001)(91956017)(14444005)(4326008)(54906003)(66446008)(25786009)(76116006)(74316002)(256004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4206;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jBLMVcUSYkk6BtVBHjL9vQSwEzxNghoKYhOwvSem5SLlclFxZMVaQtEjI9WIUULew02y6r+i49YyH/COnXvZhiJKKSDzUSpYeAoZ3O52VmbgXlgnShPG/zcQznZE0IT0D9hl3QH6BdJfnpQ9QYkwd8YMiEgOzhzC2H8xvLojC9FCFVjCfBSC/R7uK3J5aANSD/s1yHlPCdYiCpvRkFTckC8gvVHXMeAHhgj0YmOOFok27rtt0voHkUe4dPytjUa1HhkH4uN2PYgwahWPURPJsL31sKKaB7b39aNyvCabKjVy7QEivOZ4xOzogeOaW4+Zd81um8EEIY6Snwb5bBmbhjY9Eg+eWfY++avl4LOgV/7fkbfcUkMDLA0yalQ5OEy1Yh3DHczaKjIVTy/6JLyxROfw7vPm5mOXR0cjza+Z/fUyYA+xRvMf1kqNjefuXaXc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2110a36d-a19e-4a74-4748-08d76f3bf4dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 11:05:59.6981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uxO4bFcV4wWh3STKH0KcnY4Zw7hm92mad3KoDr2ZM1/3TWLIxj5zrF0oKsTYqxCkLiHlFv/seQ4bG0JrFVIjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4206
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/2019 12:33 PM, Herbert Xu wrote:=0A=
> On Mon, Nov 18, 2019 at 12:30:41AM +0200, Iuliana Prodan wrote:=0A=
>>=0A=
>> +static int transfer_request_to_engine(struct crypto_engine *engine,=0A=
>> +				      struct crypto_async_request *req)=0A=
>> +{=0A=
>> +	switch (crypto_tfm_alg_type(req->tfm)) {=0A=
>> +	case CRYPTO_ALG_TYPE_SKCIPHER:=0A=
>> +		return crypto_transfer_skcipher_request_to_engine(engine,=0A=
>> +								  skcipher_request_cast(req));=0A=
>> +	default:=0A=
>> +		return -EINVAL;=0A=
>> +	}=0A=
>> +}=0A=
> =0A=
> Please don't do this.  As you can see the crypto engine interface=0A=
> wants to you to use the correct type for the request object.  That's=0A=
> what you should do to.=0A=
=0A=
Sorry, but I don't understand what is wrong here? I'm using the correct =0A=
type, the specific type, for the request when sending it to crypto engine.=
=0A=
This transfer_request_to_engine function is called from caam_jr_enqueue, =
=0A=
where I have all types of request, so I'm using the async_request, and =0A=
when transferring to crypto engine I cast it to the specific type.=0A=
=0A=
=0A=
> In fact I don't understand why you're only using the crypto engine=0A=
> for the backlog case.  Wouldn't it be much simpler if you used the=0A=
> engine unconditionally?=0A=
=0A=
I believe is an overhead to sent all request to crypto engine since most =
=0A=
of them can be directly executed by hw.=0A=
Also, in case there is no need for backlog and the hw is busy we can =0A=
drop the request.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
