Return-Path: <SRS0=A/Go=3G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4969CC33CB1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 16:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D33A2083E
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 16:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Mth8BhjJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAQQNd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jan 2020 11:13:33 -0500
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:41135
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728977AbgAQQNd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jan 2020 11:13:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcBTyJn5d6zJwCoLzjMNI1f16HGn/kLWQWa93mU4AX+vwuRv0JoPYCh5Nd25ozKWRmuMnuk7W9GGAS3LRNlLvFyJjEUDP1ZCl+KIdURikefhI0Z0rTfalQH3Y/mQrf/ZdsMXwGAGhXnyb0X86mLvXUSEop5HLN8dCTPICgp2e41eOf02LleBBxlB7+zpfvv2/2Kaxur6VR+sjoSVZBmqe9zE3OAy8kMBNeNp4V3Xafn9EDMnC1GXlcTJuAz4GyWMIK2qmmdUz4N0f05Gw/sKk2Lirlad5eP9zyv3r63ZVUMmXThy35EqHfskwov3A8ceud8Se5kLK4lwwV4RHIAGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9/5kjcdWbAE5hk+kybYBb/gYZSew8nhRNQwAf06l5A=;
 b=acvrFPeqsCi269+EkJdmYv3+sFptYa25+AkFK6IQVKNevMlG9zh8a6Dh8819WkJXyVfPiC7eJXbvVLXugZdueJ42k/1lWIyamVsFjQlKf1VUhhJpQ5APjgU4FPlOT/z0gJIDieMTG0LXXjKFkmzkMPR8yTNfOPvSocMcs3yAOpQNM/7fJ10vBtS75SBRUWlMEI5dOHtrINtaSUInx9RyTEyzIM0T0oh+crnTPfntzrDtjqczhEru4RXmcQBboHhgx0O9HJJinJb5pPjf5czhZXOW9CDWllQVbjaQuOPz89ks78w0+VluUvBegNP649f4w+aKnDri1Bt92/jgBFRnjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9/5kjcdWbAE5hk+kybYBb/gYZSew8nhRNQwAf06l5A=;
 b=Mth8BhjJJN0yTo/anymVnmRYb+if+CwQH+ooWwSQ628bhTnw9u3pwdaK3xFTZQc1sURHa2Gf8ENppPTUMvPx3YBWdruFkiQT9zlL+cA8kvah2x6Ej3gEanArqWZBnWBKR9sG/L7Q3TIgack4yjnNCllPJc4ljA5CVbomN5jJ+1I=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB7200.eurprd04.prod.outlook.com (10.186.159.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 17 Jan 2020 16:13:29 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2644.023; Fri, 17 Jan 2020
 16:13:29 +0000
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
Date:   Fri, 17 Jan 2020 16:13:28 +0000
Message-ID: <VI1PR04MB444513CB6C188CCB4C2D13D28C310@VI1PR04MB4445.eurprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 0b32e820-2dc4-44ac-09a4-08d79b6830a7
x-ms-traffictypediagnostic: VI1PR04MB7200:|VI1PR04MB7200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7200AD01282E826D12A76BCD8C310@VI1PR04MB7200.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:359;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(199004)(189003)(316002)(52536014)(71200400001)(6506007)(4326008)(53546011)(5660300002)(478600001)(33656002)(9686003)(186003)(26005)(54906003)(110136005)(55016002)(86362001)(2906002)(8936002)(44832011)(7416002)(66946007)(66476007)(7696005)(66446008)(8676002)(81156014)(81166006)(6636002)(64756008)(66556008)(91956017)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7200;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l6tuzCOUmqfczgobZN22Lt6IM+m/HfuydCggoXywn7hjAvfb1XLshRODJG4u0SHpugL5CdAjx5Ro/c6VPrhIPlkCL/MxTEBK8ckIX4btlEjtRE5y0aGQqLcZWdQhO6p53gZo2P90A81SoumNCf7lcXQUKKR5HI2CHllB5ZH5ArLS3eBwBKF5eb28ByJ1eOK5YRoTti8/OMTMJhWqaajH0Pux6l0qejdGr9owPOrBhOXXC+biKCKowQosL1DFEFN15hLX+yW9HN/699nX/92KAUflAGikuwBtGGYuZcxv0Zlw1Dyj9LqO1fI7QhzZUvCgHihSj0mxqfWhgE5YIRs05N4BqorOaJhcRPcMrbh/0lzH/9kA5NpNTPXK5kKCmX3OJz6UdcSaQBO728USIzJRVz7183yLdUPZclnTP9Zci+H+0w/gU3tTxzzLSy8dJmfu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b32e820-2dc4-44ac-09a4-08d79b6830a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 16:13:28.9934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X2v7iEA30IpudsRBvfQytitMgjkij35NKRRX/Nq2OAmzyL1obMlj2B7K8VqgGVbynb6ZeWvpocJme2AYdS9Zfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7200
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
This should be in a critical section.=0A=
=0A=
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
>   {=0A=
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
