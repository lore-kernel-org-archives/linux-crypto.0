Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60900C33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 11:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AAAF2073A
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 11:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rzN5ARw7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgAPLeO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:34:14 -0500
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:42626
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbgAPLeO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 06:34:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlWOAa3vpx6i2cUxKuaDf7IY9qsqLiFQJC5Urz3o9yHg40NYt10LbThCpVVhBPfzyjVXKebzPZZkcp8gTGAUkgR/DP54rsCa83hPiq+wubpSGciEZLWSLAau5pp9mw3tDvAGVt64zuc4nUK+5AFkYq8fk/UaHOEHgG5GbTEL/4q/yJHj3SUNFLwR57NK+uMCljlG986vtqLMiqjwiBN8+DYy7O/yATWLFXC+0GZDYm3RFpU0mjWSW/r/e9FUVnbpvPZgRzYlRSL6om2SvZ4SkqmDxVCUr82EeIj3fKl+3vWlKANhYgIOTHgJNFyr7bYcdWmsVO2QBS97ZR3gj0wwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1q1/JPqHG2FO/D0IgadxobMkmPtShYsAvrYP2T6FMW4=;
 b=FmqBbogklhPKkxT2bROK/MhJI62mSSzgdrIcCK/LaU+uEfMXhfw0ujgB9EE3Nz/a4zItLzXq1iOKrJ1/KB5xunzQpxRzSQrS+bJwFDbDNFRSrhYDNw3j/4iQJ9b8m6Q6KzdLPTfywATljEHxphoMW4EM9YOgSRgN4KbdOr/dyQsbNXt3RgN3S9OZ3u9iijZBJUL2LTMRuWJcU+tTFBvCKhdGHyKwOtD59+lJPZd4Z99lUuQO6rpUv8Wb5PbBnyuAmbMRSEELzPpes+RuooYcOrSswLzhReSSq+Yu3kmqnBNJ4kgTG5ZY6lZr+DVNNnXGZzQLXsTfpmj5ZNpwcAzssQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1q1/JPqHG2FO/D0IgadxobMkmPtShYsAvrYP2T6FMW4=;
 b=rzN5ARw7nQgWPKlvVjWDJBucT4fMxhAi5Fk9IzA1uFan7TJeqVEjYl/JP+RbzAM25AtLbrcrCscvawTbiKNpS3MvlWzc+/x6sS0rhFg1MZ+a+UCFbKXZIsBea9rE+9qPD7g7F7hSQdzSFPvzdOD6FNla7jziaZGOrlYLOHCYM38=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB7184.eurprd04.prod.outlook.com (10.186.157.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 11:34:10 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 11:34:10 +0000
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
Subject: Re: [PATCH RFC 05/10] crypto: engine: transform cur_req in an array
Thread-Topic: [PATCH RFC 05/10] crypto: engine: transform cur_req in an array
Thread-Index: AQHVyuLoLn4V3kbUsEW/6unpDUGQYQ==
Date:   Thu, 16 Jan 2020 11:34:09 +0000
Message-ID: <VI1PR04MB444537D76D295AF3A337039D8C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
 <20200114135936.32422-6-clabbe.montjoie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 03975f72-c4e3-49d8-e225-08d79a780105
x-ms-traffictypediagnostic: VI1PR04MB7184:|VI1PR04MB7184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7184B025F84A4A03986102EF8C360@VI1PR04MB7184.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(189003)(199004)(9686003)(44832011)(8936002)(6636002)(5660300002)(81156014)(81166006)(8676002)(71200400001)(7696005)(4326008)(2906002)(6506007)(316002)(66446008)(66556008)(66476007)(66946007)(64756008)(54906003)(55016002)(110136005)(86362001)(76116006)(478600001)(186003)(53546011)(33656002)(52536014)(26005)(7416002)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7184;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hrBsgrYduZTlWIChCUXQkrx9vs0LT5UeaO21RvKYd/azLeLmiiHaMr2j9oiXfbhE4tDjRa5UlxDhg7DIoB6Am6QLhSJUq4LyM0YPvM22oSZqSRN/n+DK8Ij17xTl9ps/mFqSpeZCvnvqZaDHHJUzsAiLbFrUb7He9BpA4HNES4KgcEUGm2aemzqgQVB95p8tH3L8jhSLiA/TQiDJ3lDJtsB1bQGGVSEET3nZ9U8vR8j7GN6QOklztRHN9F8jdMtWfk9K193s1X8GOr5mZzNQAsOenS2Iba/cCOtP2U9VCYSLgW7kPHN1Nloav+qPCkA0pnWD18/fcTx+X/V+49LdVH4GJZ8FHUcw0gXYjzrnxGDHNas7mvZMkLel7cVgAqLSLTU3rXJ/5+efW/855hC80Sq6GCqLepr8hlidh0NovhEsFsn7vZOe30cWq+p2WfQT
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03975f72-c4e3-49d8-e225-08d79a780105
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 11:34:09.9130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1C+gGUxK5gPeiss0FxOexpPN9tFL4C2x6P/JIw333VVeD7lG736LpKGR+LH6mcd35FzJihwaCRizUL5db9Qcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7184
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/14/2020 3:59 PM, Corentin Labbe wrote:=0A=
> For having the ability of doing a batch of request in one do_one_request(=
), we=0A=
> should be able to store them in an array. (for unpreparing them later).=
=0A=
> This patch converts cur_req in an array of request, but for the moment=0A=
> hardcode the maximum to 1.=0A=
> =0A=
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>=0A=
> ---=0A=
>   crypto/crypto_engine.c  | 32 ++++++++++++++++++--------------=0A=
>   include/crypto/engine.h | 19 +++++++++++++++----=0A=
>   2 files changed, 33 insertions(+), 18 deletions(-)=0A=
> =0A=
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
> index eb029ff1e05a..b72873550587 100644=0A=
> --- a/crypto/crypto_engine.c=0A=
> +++ b/crypto/crypto_engine.c=0A=
> @@ -30,26 +30,27 @@ static void crypto_finalize_request(struct crypto_eng=
ine *engine,=0A=
>   	struct crypto_engine_ctx *enginectx;=0A=
>   =0A=
>   	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
> -	if (engine->cur_req =3D=3D req)=0A=
> +	if (engine->cur_reqs[0].req =3D=3D req)=0A=
>   		finalize_cur_req =3D true;=0A=
>   	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>   =0A=
>   	if (finalize_cur_req) {=0A=
> -		enginectx =3D crypto_tfm_ctx(req->tfm);=0A=
> -		if (engine->cur_req_prepared &&=0A=
> +		enginectx =3D crypto_tfm_ctx(engine->cur_reqs[0].req->tfm);=0A=
> +		if (engine->cur_reqs[0].prepared &&=0A=
>   		    enginectx->op.unprepare_request) {=0A=
> -			ret =3D enginectx->op.unprepare_request(engine, req);=0A=
> +			ret =3D enginectx->op.unprepare_request(engine, engine->cur_reqs[0].r=
eq);=0A=
>   			if (ret)=0A=
>   				dev_err(engine->dev, "failed to unprepare request\n");=0A=
>   		}=0A=
> +		engine->cur_reqs[0].req->complete(engine->cur_reqs[0].req, err);=0A=
>   		spin_lock_irqsave(&engine->queue_lock, flags);=0A=
> -		engine->cur_req =3D NULL;=0A=
> -		engine->cur_req_prepared =3D false;=0A=
> +		engine->cur_reqs[0].prepared =3D false;=0A=
> +		engine->cur_reqs[0].req =3D NULL;=0A=
>   		spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
> +	} else {=0A=
> +		req->complete(req, err);=0A=
>   	}=0A=
>   =0A=
> -	req->complete(req, err);=0A=
> -=0A=
>   	kthread_queue_work(engine->kworker, &engine->pump_requests);=0A=
>   }=0A=
>   =0A=
> @@ -74,7 +75,7 @@ static void crypto_pump_requests(struct crypto_engine *=
engine,=0A=
>   	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>   =0A=
>   	/* Make sure we are not already running a request */=0A=
> -	if (engine->cur_req)=0A=
> +	if (engine->cur_reqs[0].req)=0A=
>   		goto out;=0A=
>   =0A=
>   	/* If another context is idling then defer */=0A=
> @@ -114,7 +115,7 @@ static void crypto_pump_requests(struct crypto_engine=
 *engine,=0A=
>   	if (!async_req)=0A=
>   		goto out;=0A=
>   =0A=
> -	engine->cur_req =3D async_req;=0A=
> +	engine->cur_reqs[0].req =3D async_req;=0A=
>   	if (backlog)=0A=
>   		backlog->complete(backlog, -EINPROGRESS);=0A=
>   =0A=
> @@ -143,14 +144,14 @@ static void crypto_pump_requests(struct crypto_engi=
ne *engine,=0A=
>   				ret);=0A=
>   			goto req_err;=0A=
>   		}=0A=
> -		engine->cur_req_prepared =3D true;=0A=
> +		engine->cur_reqs[0].prepared =3D true;=0A=
>   	}=0A=
>   	if (!enginectx->op.do_one_request) {=0A=
>   		dev_err(engine->dev, "failed to do request\n");=0A=
>   		ret =3D -EINVAL;=0A=
>   		goto req_err;=0A=
>   	}=0A=
> -	ret =3D enginectx->op.do_one_request(engine, async_req);=0A=
> +	ret =3D enginectx->op.do_one_request(engine, engine->cur_reqs[0].req);=
=0A=
>   	if (ret) {=0A=
>   		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret=
);=0A=
>   		goto req_err;=0A=
> @@ -158,7 +159,7 @@ static void crypto_pump_requests(struct crypto_engine=
 *engine,=0A=
>   	return;=0A=
>   =0A=
>   req_err:=0A=
> -	crypto_finalize_request(engine, async_req, ret);=0A=
> +	crypto_finalize_request(engine, engine->cur_reqs[0].req, ret);=0A=
>   	return;=0A=
>   =0A=
>   out:=0A=
> @@ -411,10 +412,13 @@ struct crypto_engine *crypto_engine_alloc_init(stru=
ct device *dev, bool rt)=0A=
>   	engine->running =3D false;=0A=
>   	engine->busy =3D false;=0A=
>   	engine->idling =3D false;=0A=
> -	engine->cur_req_prepared =3D false;=0A=
>   	engine->priv_data =3D dev;=0A=
>   	snprintf(engine->name, sizeof(engine->name),=0A=
>   		 "%s-engine", dev_name(dev));=0A=
> +	engine->rmax =3D 1;=0A=
> +	engine->cur_reqs =3D devm_kzalloc(dev, sizeof(struct cur_req) * engine-=
>rmax, GFP_KERNEL);=0A=
> +	if (!engine->cur_reqs)=0A=
> +		return NULL;=0A=
>   =0A=
>   	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);=0A=
>   	spin_lock_init(&engine->queue_lock);=0A=
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
> index e29cd67f93c7..362134e226f4 100644=0A=
> --- a/include/crypto/engine.h=0A=
> +++ b/include/crypto/engine.h=0A=
> @@ -18,13 +18,23 @@=0A=
>   #include <crypto/skcipher.h>=0A=
>   =0A=
>   #define ENGINE_NAME_LEN	30=0A=
> +=0A=
> +/*=0A=
> + * struct cur_req - Represent a request to be processed=0A=
> + * @prepared:	Does the request was prepared=0A=
> + * @req:	The request to be processed=0A=
> + */=0A=
> +struct cur_req {=0A=
> +	bool				prepared;=0A=
> +	struct crypto_async_request	*req;=0A=
> +};=0A=
> +=0A=
>   /*=0A=
>    * struct crypto_engine - crypto hardware engine=0A=
>    * @name: the engine name=0A=
>    * @idling: the engine is entering idle state=0A=
>    * @busy: request pump is busy=0A=
>    * @running: the engine is on working=0A=
> - * @cur_req_prepared: current request is prepared=0A=
>    * @list: link with the global crypto engine list=0A=
>    * @queue_lock: spinlock to syncronise access to request queue=0A=
>    * @queue: the crypto queue of the engine=0A=
> @@ -38,14 +48,14 @@=0A=
>    * @kworker: kthread worker struct for request pump=0A=
>    * @pump_requests: work struct for scheduling work to the request pump=
=0A=
>    * @priv_data: the engine private data=0A=
> - * @cur_req: the current request which is on processing=0A=
> + * @rmax:	The number of request which can be processed in one batch=0A=
> + * @cur_reqs: 	A list for requests to be processed=0A=
>    */=0A=
>   struct crypto_engine {=0A=
>   	char			name[ENGINE_NAME_LEN];=0A=
>   	bool			idling;=0A=
>   	bool			busy;=0A=
>   	bool			running;=0A=
> -	bool			cur_req_prepared;=0A=
>   =0A=
>   	struct list_head	list;=0A=
>   	spinlock_t		queue_lock;=0A=
> @@ -61,7 +71,8 @@ struct crypto_engine {=0A=
>   	struct kthread_work             pump_requests;=0A=
>   =0A=
>   	void				*priv_data;=0A=
> -	struct crypto_async_request	*cur_req;=0A=
> +	int 				rmax;=0A=
> +	struct cur_req 			*cur_reqs;=0A=
>   };=0A=
=0A=
To keep requests independent IMO it would be best to have a list of =0A=
requests like: struct requests run_queue, where=0A=
=0A=
struct requests {=0A=
	unsigned int max_no_reqs;=0A=
	unsigned int current_no_reqs;=0A=
	struct cur_req *cur_reqs; //list of the requests=0A=
} run_queue;=0A=
