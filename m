Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B1FC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 11:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FEC32073A
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 11:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="HqCmx8tD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgAPLei (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:34:38 -0500
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:57411
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbgAPLei (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 06:34:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBen2DF7aLTd1dkswMX/kZdbRyXS45SwHN2kzADejY8nO4U/Q6dzcJFvIkYxJ3KBibi6my8mlQr/7A9UbtXfAnicygGhu+e9XKRQ+PC2aoOrva4+YnoPPoV8koVheVuIVdQpBDyS1Q0f0CR51ILn/MnxKVGlAYmavF34Sdxejva4TNHtLv5VgN24u8L71KWd984ThSmKBmi1ebfl28H176TiEb4Izp+oldc7izJXQyqWWTQWHCjdPFzHE4mdcq+aKITno1MNrtUxCJlf3SDQZgIwgF884aLLYrb8IQhv1F6Y7iVodgTXrg0SGZyqGNq8QK/e4zKBetv4TynrZzcZJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiJ+M4QLhkh+5BI+alTVgquliUFQLGXcC9Cq/LKkQTU=;
 b=b90VE5zyBWqqY12L7l6rfH5l+fAXCp+MqniO45rjI+40dc7bYnsVEQP9SgAXZnZwnCEsZZQBtVB5qdMLsuhxTYe7OpNkUmftqoNbbjPgpwf9U0gtsGXH2Zf0JFvz08hCfCZ9N/FkzBO+l2XlBYw1Y0iAARWQPp7mRGhTo8NaDlg9jijmQGrz5FJ3yK548TATzfBAUThAlqhy1dOOKR4+MklD/GN27ujdG70Okzi/Z08cU2V0B9pkA5uRGz8HDl7/t/otNwrB6V/RHzGuJ6L5nYwSBm5uhQUO/IIsGh4aXwVqkxkDNLZBcvx3Zq1/s3DX13vBOVslLT9HqCmrtYTfIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiJ+M4QLhkh+5BI+alTVgquliUFQLGXcC9Cq/LKkQTU=;
 b=HqCmx8tD8IPP+DE665t8t/FoPHotFLgNhUIxwnfOQYnIZftXgEWXx7RMWkpWxBORb0nZIl7vLKiiSvPR3vfCeTFzSpFMxQ1u1y8ZWTqbDEODV0MxqQSiQ/PvrAJKNTP5DoHxe+D3nzJ24lppRdKP6WZEIe8zXLUJBaRVZPL5xDw=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB7184.eurprd04.prod.outlook.com (10.186.157.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 11:34:34 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 11:34:34 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH RFC 09/10] crypto: engine: permit to batch requests
Thread-Topic: [PATCH RFC 09/10] crypto: engine: permit to batch requests
Thread-Index: AQHVyuLsCMmCcJsnqU6cDfOK2wZNrg==
Date:   Thu, 16 Jan 2020 11:34:34 +0000
Message-ID: <VI1PR04MB4445182A8A827C3EA303A2978C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
 <20200114135936.32422-10-clabbe.montjoie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc7d1cc7-1848-47ef-f84e-08d79a780fc5
x-ms-traffictypediagnostic: VI1PR04MB7184:|VI1PR04MB7184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB71844E3EB904213FC2BF6A168C360@VI1PR04MB7184.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:431;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(189003)(199004)(9686003)(44832011)(8936002)(6636002)(5660300002)(81156014)(81166006)(8676002)(71200400001)(7696005)(4326008)(2906002)(6506007)(316002)(66446008)(66556008)(66476007)(66946007)(64756008)(54906003)(55016002)(110136005)(86362001)(76116006)(478600001)(186003)(53546011)(33656002)(52536014)(26005)(7416002)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7184;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K8NvZTVtd5OYewy94MF+rcoIqr+bSkh6Tos48cpcll6axwnooJkAscM+8NnYxMtBu158xTtB7wE71UO+MJHXhsNqTzRSWN0eTrrZYqr7W9G58uRD5uGCLmFk1lp1mN/egxGs6FTnRoLanfbGZBWuyCIR1nuC30GzZaJIX+nEC2gs12o46vxqPrSbEVD6CpogZb/6JwTmWHyHK0OeaFDil+NGf9WjSM7bR/M8d3o9TI2cFSqAYviZE+bBVN4eP3AwGDyg+q0YNFx5vv6xatK0GhrIVOxot3jX3lK+HVZkW6bmRQO6M42BWp8r8hsbTKjGZEfS9uZQIT92jVQeFn59urn7jOUY04fk+fgGXGjcMOcZxuN387Nl3k6g49ltL9g+tr9kxuKxBYG2Y2D6Vzo3yi/4+p0fqglV+qSzC++Vev96MycfEdm+vd2VwRlUGCLz
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7d1cc7-1848-47ef-f84e-08d79a780fc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 11:34:34.6480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qDAKvTY8ZwVEF+2SRLCJRXSSdQd/L6gw0cPkXsr9rc471vpmjvA28c7qp+pMuhqr18orkZkdXIb9JkPsKffMvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7184
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/14/2020 4:00 PM, Corentin Labbe wrote:=0A=
> Now everything is ready, this patch permits to choose the number of=0A=
> request to batch.=0A=
> =0A=
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>=0A=
> ---=0A=
>   crypto/crypto_engine.c  | 32 +++++++++++++++++++++++++++-----=0A=
>   include/crypto/engine.h |  2 ++=0A=
>   2 files changed, 29 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
> index e23a398ba330..e9cd9ec9a732 100644=0A=
> --- a/crypto/crypto_engine.c=0A=
> +++ b/crypto/crypto_engine.c=0A=
> @@ -114,6 +114,7 @@ static void crypto_pump_requests(struct crypto_engine=
 *engine,=0A=
>   	}=0A=
>   =0A=
>   	engine->ct =3D 0;=0A=
> +retry:=0A=
>   	/* Get the fist request from the engine queue to handle */=0A=
>   	backlog =3D crypto_get_backlog(&engine->queue);=0A=
>   	async_req =3D crypto_dequeue_request(&engine->queue);=0A=
> @@ -151,7 +152,10 @@ static void crypto_pump_requests(struct crypto_engin=
e *engine,=0A=
>   		}=0A=
>   		engine->cur_reqs[engine->ct].prepared =3D true;=0A=
>   	}=0A=
> -	engine->ct++;=0A=
> +	if (++engine->ct < engine->rmax && engine->queue.qlen > 0) {=0A=
> +		spin_lock_irqsave(&engine->queue_lock, flags);=0A=
> +		goto retry;=0A=
> +	}=0A=
>   	if (!enginectx->op.do_one_request) {=0A=
>   		dev_err(engine->dev, "failed to do request\n");=0A=
>   		ret =3D -EINVAL;=0A=
> @@ -393,15 +397,18 @@ int crypto_engine_stop(struct crypto_engine *engine=
)=0A=
>   EXPORT_SYMBOL_GPL(crypto_engine_stop);=0A=
>   =0A=
>   /**=0A=
> - * crypto_engine_alloc_init - allocate crypto hardware engine structure =
and=0A=
> + * crypto_engine_alloc_init2 - allocate crypto hardware engine structure=
 and=0A=
>    * initialize it.=0A=
>    * @dev: the device attached with one hardware engine=0A=
>    * @rt: whether this queue is set to run as a realtime task=0A=
> + * @rmax: The number of request that the engine can batch in one=0A=
> + * @qlen: The size of the crypto queue=0A=
>    *=0A=
>    * This must be called from context that can sleep.=0A=
>    * Return: the crypto engine structure on success, else NULL.=0A=
>    */=0A=
> -struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool =
rt)=0A=
> +struct crypto_engine *crypto_engine_alloc_init2(struct device *dev, bool=
 rt,=0A=
> +						int rmax, int qlen)=0A=
=0A=
I think one _alloc_init function is enough, which will set the size of =0A=
crypto-engine queue (not hardcoded like it is now) and the number of =0A=
requests that the engine can execute in parallel.=0A=
=0A=
{=0A=
>   	struct sched_param param =3D { .sched_priority =3D MAX_RT_PRIO / 2 };=
=0A=
>   	struct crypto_engine *engine;=0A=
> @@ -421,12 +428,12 @@ struct crypto_engine *crypto_engine_alloc_init(stru=
ct device *dev, bool rt)=0A=
>   	engine->priv_data =3D dev;=0A=
>   	snprintf(engine->name, sizeof(engine->name),=0A=
>   		 "%s-engine", dev_name(dev));=0A=
> -	engine->rmax =3D 1;=0A=
> +	engine->rmax =3D rmax;=0A=
>   	engine->cur_reqs =3D devm_kzalloc(dev, sizeof(struct cur_req) * engine=
->rmax, GFP_KERNEL);=0A=
>   	if (!engine->cur_reqs)=0A=
>   		return NULL;=0A=
>   =0A=
> -	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);=0A=
> +	crypto_init_queue(&engine->queue, qlen);=0A=
>   	spin_lock_init(&engine->queue_lock);=0A=
>   =0A=
>   	engine->kworker =3D kthread_create_worker(0, "%s", engine->name);=0A=
> @@ -443,6 +450,21 @@ struct crypto_engine *crypto_engine_alloc_init(struc=
t device *dev, bool rt)=0A=
>   =0A=
>   	return engine;=0A=
>   }=0A=
> +EXPORT_SYMBOL_GPL(crypto_engine_alloc_init2);=0A=
> +=0A=
> +/**=0A=
> + * crypto_engine_alloc_init - allocate crypto hardware engine structure =
and=0A=
> + * initialize it.=0A=
> + * @dev: the device attached with one hardware engine=0A=
> + * @rt: whether this queue is set to run as a realtime task=0A=
> + *=0A=
> + * This must be called from context that can sleep.=0A=
> + * Return: the crypto engine structure on success, else NULL.=0A=
> + */=0A=
> +struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool =
rt)=0A=
> +{=0A=
> +	return crypto_engine_alloc_init2(dev, rt, 1, CRYPTO_ENGINE_MAX_QLEN);=
=0A=
> +}=0A=
>   EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);=0A=
>   =0A=
>   /**=0A=
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
> index 55d3dbc2498c..fe0dfea8bf07 100644=0A=
> --- a/include/crypto/engine.h=0A=
> +++ b/include/crypto/engine.h=0A=
> @@ -115,6 +115,8 @@ void crypto_finalize_skcipher_request(struct crypto_e=
ngine *engine,=0A=
>   int crypto_engine_start(struct crypto_engine *engine);=0A=
>   int crypto_engine_stop(struct crypto_engine *engine);=0A=
>   struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool=
 rt);=0A=
> +struct crypto_engine *crypto_engine_alloc_init2(struct device *dev, bool=
 rt,=0A=
> +						int rmax, int qlen);=0A=
>   int crypto_engine_exit(struct crypto_engine *engine);=0A=
>   =0A=
>   #endif /* _CRYPTO_ENGINE_H */=0A=
> =0A=
=0A=
