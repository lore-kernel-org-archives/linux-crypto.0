Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17DDC33C9E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD42D24685
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="dbvgviL2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgA1LBT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 06:01:19 -0500
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:13189
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbgA1LBS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 06:01:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XV/2gsiMsSyzq0gzyrLh9Lv/QIsm5dhuiOVx+CEKpMbXCA/wimxKOHav+HuiammaUBRqunbWvq3eJbXe50WauCVuXVX6ZCrmy+LvkwFspCNyNJrAde+7lG6YaJKZ0reMdVHpOuU7oVSO8TUuQgv/yzVWiyw4EpHOnI86UlYVF8CvtMKUOumOM5USUV1spI5bUsmMJQjsN9HHbfAi6hwZkJRlD2NTEMNQ7GKIsBn76aEv68fVb5H92cEnQP7ANfuoOkBlHyr1rmqJBu1LnG5HmWveRyfVJINsZAdFdosaQzgMk5mXcI9ZqMoqg/AS9vTgNXEfvkqbjapGT6xonaJ7Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PnVgme5rmlurghlnH8NRpFqjkg7JyHQ2kktlSpInd8=;
 b=bi5ybWnwb9IrcJ6I7YizBmDdCdArXj3vAHllof/mYD/zctQvsS5DYNE/HPs2tjFPyrpjOVV+/MhUwBu4vazJDZfbQ+6W5uCAaLU0ZjgcBbsbnHNba2pgYkoSopPj5SM1YDOUDyfH4VV3ub8lUHdbH9NqmL2BtKvXzacyrZfChcmMZFSdJBwNctRWShi1b+YwIxXz5ILf1owR80+/s+YXuOxKe0fn3/cli6V2wm61KRSP+ykW796rvhV2coR4GarjaZvu0j6ucMvwrW0CpNUik5eNycVLbKwzJj/87AQtsGzRwYBwU7g+6P6mIUGNNOS83coW4//LkDl8XOHvJjNgmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PnVgme5rmlurghlnH8NRpFqjkg7JyHQ2kktlSpInd8=;
 b=dbvgviL2h1AVBeV1Yno+kPLluQinVSjYWyNyUSrMAqnrXoKkysbd6f9D6LHf9rOYBzRC7+SJyTZ12pRc+dgy8UMcLPfctRR7CehpXkNy5kGPT/dKyUUqjIpg36ANT17fd+e9tJ00Eqd5iodUUY1xmorLjo/uhIMbevlGmyFKad8=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0PR04MB5059.eurprd04.prod.outlook.com (20.176.214.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Tue, 28 Jan 2020 11:01:13 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::59a8:ca29:d637:3c84]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::59a8:ca29:d637:3c84%5]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 11:01:13 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: engine - support for parallel requests
Thread-Topic: [PATCH] crypto: engine - support for parallel requests
Thread-Index: AQHV1V+Lpg4k6idDrkSeyHdnycf4Dg==
Date:   Tue, 28 Jan 2020 11:01:13 +0000
Message-ID: <AM0PR04MB71718DED6BD597DD2FE023298C0A0@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <1580163425-13266-1-git-send-email-iuliana.prodan@nxp.com>
 <20200128085845.GB10493@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83970353-8e5f-46ae-0e8a-08d7a3e163a9
x-ms-traffictypediagnostic: AM0PR04MB5059:|AM0PR04MB5059:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5059C08EEA80FAF19596B0F08C0A0@AM0PR04MB5059.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:506;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(199004)(189003)(7416002)(81166006)(81156014)(6506007)(53546011)(8676002)(8936002)(86362001)(316002)(71200400001)(54906003)(7696005)(76116006)(66476007)(66946007)(5660300002)(6916009)(66556008)(66446008)(26005)(64756008)(478600001)(30864003)(55016002)(52536014)(4326008)(9686003)(2906002)(186003)(44832011)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5059;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1kotVTMS8jVsoOKYKcHpqNANRENjRJyy2A2F3LL8fFML++2OxM6zLEu4g6CBZDeDjEzE3iPYamXF7ZEbWQED7tHkLjfyuDu19zmsYR9PGKK4dJsQyBU9d/YIo14DUYz52il+vxDG5n7xkbLlGPP7VsCcKpvJ1NF+Ja+megRbvVRNAfQ8Yi54PNqUKWu/q6rRh9Rq59hR0KcWpDECqCOQr5AX+ujDwMv+rUTQHMawd4oIgDApYBjUGNird8eAGyP4wczbSiQl2IB7qkZ5ITzr14u/wp2YdJS5zRzEsZozccR2NHVqIxjtQqdpTVLexuEyff7bUOPBAxyPwmw2p+8CPqplj7RuB3ewddCbU9DtFAk6tco1A85E8Ssj6JSBz8d+Z8p24Yqj3Cm//9+5fz56a/l0jdU24Hos8Oqx4UAgCgGLED4JwaxyCQDFwfTPkJX
x-ms-exchange-antispam-messagedata: rJ1GoCGZcsb3cKzxNgZQioZuAD5j1faavB27CTwefgOhNqg1VMYjT/0Bz7YsSS16qRzF1WyJsKXDA1+s4HwCzdtAK+M2YdgzhdYuVgDs9sKC6LXfYv+mBjwdfodSlidEND5FK94r/jkYOCj07kGkkA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83970353-8e5f-46ae-0e8a-08d7a3e163a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 11:01:13.0619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 49RZUXGWsGIeclr72b1kQPETdUcHHllZbo+1cDn2JYYBV8MZBgzMjtGO9ooSPlkVLrutnPm9aWdemxSkaI+I+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5059
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/28/2020 10:58 AM, Corentin Labbe wrote:=0A=
> On Tue, Jan 28, 2020 at 12:17:05AM +0200, Iuliana Prodan wrote:=0A=
>> Added support for executing multiple requests, in parallel,=0A=
>> for crypto engine.=0A=
>> A new callback is added, can_enqueue_hardware, which asks the=0A=
>> driver if the hardware has free space, to enqueue a new request.=0A=
>> The new crypto_engine_alloc_init_and_set function, initialize=0A=
>> crypto-engine, sets the maximum size for crypto-engine software=0A=
>> queue (not hardcoded anymore) and the can_enqueue_hardware callback.=0A=
>> On crypto_pump_requests, if can_enqueue_hardware callback returns true,=
=0A=
>> a new request is send to hardware, until there is no space and the=0A=
>> callback returns false.=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>>=0A=
>> ---=0A=
>> Changes since V0 (RFC):=0A=
>> 	- removed max_no_req and no_req, as the number of request that=0A=
>> 	  can be processed in parallel;=0A=
>> 	- added a new callback, can_enqueue_hardware, to check whether=0A=
>> 	  the hardware can process a new request.=0A=
>> ---=0A=
>>=0A=
>>   crypto/crypto_engine.c  | 105 ++++++++++++++++++++++++++++++----------=
--------=0A=
>>   include/crypto/engine.h |  10 +++--=0A=
>>   2 files changed, 71 insertions(+), 44 deletions(-)=0A=
>>=0A=
>> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
>> index eb029ff..ee3a610 100644=0A=
>> --- a/crypto/crypto_engine.c=0A=
>> +++ b/crypto/crypto_engine.c=0A=
>> @@ -22,32 +22,18 @@=0A=
>>    * @err: error number=0A=
>>    */=0A=
>>   static void crypto_finalize_request(struct crypto_engine *engine,=0A=
>> -			     struct crypto_async_request *req, int err)=0A=
>> +				    struct crypto_async_request *req, int err)=0A=
>>   {=0A=
>> -	unsigned long flags;=0A=
>> -	bool finalize_cur_req =3D false;=0A=
>>   	int ret;=0A=
>>   	struct crypto_engine_ctx *enginectx;=0A=
>>   =0A=
>> -	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>> -	if (engine->cur_req =3D=3D req)=0A=
>> -		finalize_cur_req =3D true;=0A=
>> -	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>> -=0A=
>> -	if (finalize_cur_req) {=0A=
>> -		enginectx =3D crypto_tfm_ctx(req->tfm);=0A=
>> -		if (engine->cur_req_prepared &&=0A=
>> -		    enginectx->op.unprepare_request) {=0A=
>> -			ret =3D enginectx->op.unprepare_request(engine, req);=0A=
>> -			if (ret)=0A=
>> -				dev_err(engine->dev, "failed to unprepare request\n");=0A=
>> -		}=0A=
>> -		spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>> -		engine->cur_req =3D NULL;=0A=
>> -		engine->cur_req_prepared =3D false;=0A=
>> -		spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>> +	enginectx =3D crypto_tfm_ctx(req->tfm);=0A=
>> +	if (enginectx->op.prepare_request &&=0A=
>> +	    enginectx->op.unprepare_request) {=0A=
>> +		ret =3D enginectx->op.unprepare_request(engine, req);=0A=
>> +		if (ret)=0A=
>> +			dev_err(engine->dev, "failed to unprepare request\n");=0A=
>>   	}=0A=
>> -=0A=
>>   	req->complete(req, err);=0A=
>>   =0A=
>>   	kthread_queue_work(engine->kworker, &engine->pump_requests);=0A=
>> @@ -73,10 +59,6 @@ static void crypto_pump_requests(struct crypto_engine=
 *engine,=0A=
>>   =0A=
>>   	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>>   =0A=
>> -	/* Make sure we are not already running a request */=0A=
>> -	if (engine->cur_req)=0A=
>> -		goto out;=0A=
>> -=0A=
>>   	/* If another context is idling then defer */=0A=
>>   	if (engine->idling) {=0A=
>>   		kthread_queue_work(engine->kworker, &engine->pump_requests);=0A=
>> @@ -108,13 +90,18 @@ static void crypto_pump_requests(struct crypto_engi=
ne *engine,=0A=
>>   		goto out;=0A=
>>   	}=0A=
>>   =0A=
>> +start_request:=0A=
>> +	/* If hw is busy, do not send any request */=0A=
>> +	if (engine->can_enqueue_hardware &&=0A=
>> +	    !engine->can_enqueue_hardware(engine->dev))=0A=
>> +		goto out;=0A=
>> +=0A=
>>   	/* Get the fist request from the engine queue to handle */=0A=
>>   	backlog =3D crypto_get_backlog(&engine->queue);=0A=
>>   	async_req =3D crypto_dequeue_request(&engine->queue);=0A=
>>   	if (!async_req)=0A=
>>   		goto out;=0A=
>>   =0A=
>> -	engine->cur_req =3D async_req;=0A=
>>   	if (backlog)=0A=
>>   		backlog->complete(backlog, -EINPROGRESS);=0A=
>>   =0A=
>> @@ -130,7 +117,7 @@ static void crypto_pump_requests(struct crypto_engin=
e *engine,=0A=
>>   		ret =3D engine->prepare_crypt_hardware(engine);=0A=
>>   		if (ret) {=0A=
>>   			dev_err(engine->dev, "failed to prepare crypt hardware\n");=0A=
>> -			goto req_err;=0A=
>> +			goto req_err_2;=0A=
>>   		}=0A=
>>   	}=0A=
>>   =0A=
>> @@ -141,26 +128,38 @@ static void crypto_pump_requests(struct crypto_eng=
ine *engine,=0A=
>>   		if (ret) {=0A=
>>   			dev_err(engine->dev, "failed to prepare request: %d\n",=0A=
>>   				ret);=0A=
>> -			goto req_err;=0A=
>> +			goto req_err_2;=0A=
>>   		}=0A=
>> -		engine->cur_req_prepared =3D true;=0A=
>>   	}=0A=
>>   	if (!enginectx->op.do_one_request) {=0A=
>>   		dev_err(engine->dev, "failed to do request\n");=0A=
>>   		ret =3D -EINVAL;=0A=
>> -		goto req_err;=0A=
>> +		goto req_err_1;=0A=
>>   	}=0A=
>> +=0A=
>>   	ret =3D enginectx->op.do_one_request(engine, async_req);=0A=
>>   	if (ret) {=0A=
>>   		dev_err(engine->dev, "Failed to do one request from queue: %d\n", re=
t);=0A=
>> -		goto req_err;=0A=
>> +		goto req_err_1;=0A=
>>   	}=0A=
>> -	return;=0A=
>>   =0A=
>> -req_err:=0A=
>> -	crypto_finalize_request(engine, async_req, ret);=0A=
>> -	return;=0A=
>> +	goto retry;=0A=
>> +=0A=
>> +req_err_1:=0A=
>> +	if (enginectx->op.unprepare_request) {=0A=
>> +		ret =3D enginectx->op.unprepare_request(engine, async_req);=0A=
>> +		if (ret)=0A=
>> +			dev_err(engine->dev, "failed to unprepare request\n");=0A=
>> +	}=0A=
>> +req_err_2:=0A=
>> +	async_req->complete(async_req, ret);=0A=
>>   =0A=
>> +retry:=0A=
>> +	if (engine->can_enqueue_hardware) {=0A=
>> +		spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>> +		goto start_request;=0A=
>> +	}=0A=
>> +	return;=0A=
>>   out:=0A=
>>   	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>>   }=0A=
>> @@ -386,15 +385,25 @@ int crypto_engine_stop(struct crypto_engine *engin=
e)=0A=
>>   EXPORT_SYMBOL_GPL(crypto_engine_stop);=0A=
>>   =0A=
>>   /**=0A=
>> - * crypto_engine_alloc_init - allocate crypto hardware engine structure=
 and=0A=
>> - * initialize it.=0A=
>> + * crypto_engine_alloc_init_and_set - allocate crypto hardware engine s=
tructure=0A=
>> + * and initialize it by setting the maximum number of entries in the so=
ftware=0A=
>> + * crypto-engine queue.=0A=
>>    * @dev: the device attached with one hardware engine=0A=
>> + * @cbk: pointer to a callback function to be invoked when pumping requ=
ests=0A=
>> + *       to check whether the hardware can process a new request.=0A=
>> + *       This has the form:=0A=
>> + *       callback(struct device *dev)=0A=
>> + *       where:=0A=
>> + *       @dev: contains the device that processed this response.=0A=
>>    * @rt: whether this queue is set to run as a realtime task=0A=
>> + * @qlen: maximum size of the crypto-engine queue=0A=
>>    *=0A=
>>    * This must be called from context that can sleep.=0A=
>>    * Return: the crypto engine structure on success, else NULL.=0A=
>>    */=0A=
>> -struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool=
 rt)=0A=
>> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *d=
ev,=0A=
>> +						       bool (*cbk)(struct device *dev),=0A=
>> +						       bool rt, int qlen)=0A=
>>   {=0A=
>>   	struct sched_param param =3D { .sched_priority =3D MAX_RT_PRIO / 2 };=
=0A=
>>   	struct crypto_engine *engine;=0A=
>> @@ -411,12 +420,12 @@ struct crypto_engine *crypto_engine_alloc_init(str=
uct device *dev, bool rt)=0A=
>>   	engine->running =3D false;=0A=
>>   	engine->busy =3D false;=0A=
>>   	engine->idling =3D false;=0A=
>> -	engine->cur_req_prepared =3D false;=0A=
>>   	engine->priv_data =3D dev;=0A=
>> +	engine->can_enqueue_hardware =3D cbk;=0A=
>>   	snprintf(engine->name, sizeof(engine->name),=0A=
>>   		 "%s-engine", dev_name(dev));=0A=
>>   =0A=
>> -	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);=0A=
>> +	crypto_init_queue(&engine->queue, qlen);=0A=
>>   	spin_lock_init(&engine->queue_lock);=0A=
>>   =0A=
>>   	engine->kworker =3D kthread_create_worker(0, "%s", engine->name);=0A=
>> @@ -433,6 +442,22 @@ struct crypto_engine *crypto_engine_alloc_init(stru=
ct device *dev, bool rt)=0A=
>>   =0A=
>>   	return engine;=0A=
>>   }=0A=
>> +EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);=0A=
>> +=0A=
>> +/**=0A=
>> + * crypto_engine_alloc_init - allocate crypto hardware engine structure=
 and=0A=
>> + * initialize it.=0A=
>> + * @dev: the device attached with one hardware engine=0A=
>> + * @rt: whether this queue is set to run as a realtime task=0A=
>> + *=0A=
>> + * This must be called from context that can sleep.=0A=
>> + * Return: the crypto engine structure on success, else NULL.=0A=
>> + */=0A=
>> +struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool=
 rt)=0A=
>> +{=0A=
>> +	return crypto_engine_alloc_init_and_set(dev, NULL, rt,=0A=
>> +						CRYPTO_ENGINE_MAX_QLEN);=0A=
>> +}=0A=
>>   EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);=0A=
>>   =0A=
>>   /**=0A=
>> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
>> index e29cd67..15d1150 100644=0A=
>> --- a/include/crypto/engine.h=0A=
>> +++ b/include/crypto/engine.h=0A=
>> @@ -24,7 +24,6 @@=0A=
>>    * @idling: the engine is entering idle state=0A=
>>    * @busy: request pump is busy=0A=
>>    * @running: the engine is on working=0A=
>> - * @cur_req_prepared: current request is prepared=0A=
>>    * @list: link with the global crypto engine list=0A=
>>    * @queue_lock: spinlock to syncronise access to request queue=0A=
>>    * @queue: the crypto queue of the engine=0A=
>> @@ -35,17 +34,17 @@=0A=
>>    * @unprepare_crypt_hardware: there are currently no more requests on =
the=0A=
>>    * queue so the subsystem notifies the driver that it may relax the=0A=
>>    * hardware by issuing this call=0A=
>> + * @can_enqueue_hardware: callback to check whether the hardware can pr=
ocess=0A=
>> + * a new request=0A=
>>    * @kworker: kthread worker struct for request pump=0A=
>>    * @pump_requests: work struct for scheduling work to the request pump=
=0A=
>>    * @priv_data: the engine private data=0A=
>> - * @cur_req: the current request which is on processing=0A=
>>    */=0A=
>>   struct crypto_engine {=0A=
>>   	char			name[ENGINE_NAME_LEN];=0A=
>>   	bool			idling;=0A=
>>   	bool			busy;=0A=
>>   	bool			running;=0A=
>> -	bool			cur_req_prepared;=0A=
>>   =0A=
>>   	struct list_head	list;=0A=
>>   	spinlock_t		queue_lock;=0A=
>> @@ -56,12 +55,12 @@ struct crypto_engine {=0A=
>>   =0A=
>>   	int (*prepare_crypt_hardware)(struct crypto_engine *engine);=0A=
>>   	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);=0A=
>> +	bool (*can_enqueue_hardware)(struct device *dev);=0A=
>>   =0A=
>>   	struct kthread_worker           *kworker;=0A=
>>   	struct kthread_work             pump_requests;=0A=
>>   =0A=
>>   	void				*priv_data;=0A=
>> -	struct crypto_async_request	*cur_req;=0A=
>>   };=0A=
>>   =0A=
>>   /*=0A=
>> @@ -102,6 +101,9 @@ void crypto_finalize_skcipher_request(struct crypto_=
engine *engine,=0A=
>>   int crypto_engine_start(struct crypto_engine *engine);=0A=
>>   int crypto_engine_stop(struct crypto_engine *engine);=0A=
>>   struct crypto_engine *crypto_engine_alloc_init(struct device *dev, boo=
l rt);=0A=
>> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *d=
ev,=0A=
>> +						       bool (*cbk)(struct device *dev),=0A=
>> +						       bool rt, int qlen);=0A=
>>   int crypto_engine_exit(struct crypto_engine *engine);=0A=
>>   =0A=
>>   #endif /* _CRYPTO_ENGINE_H */=0A=
>> -- =0A=
>> 2.1.0=0A=
>>=0A=
> =0A=
> =0A=
> Hello=0A=
> =0A=
> For someone which said "I'm planning to improve crypto-engine incremental=
ly", this is lot of change in one.=0A=
> You could have used my first 4 patchs which clean crypto_engine (for gett=
ing rid of cur_req_prepared/cur_req for example).=0A=
> =0A=
=0A=
The number of patches is something debatable!=0A=
Your first patches were already in my RFC!=0A=
This patch adds support for independent requests by adding a check for =0A=
hardware availability. Removing current request (cur_req) means we need =0A=
to add something else to break from the loop we have in pump_requests(). =
=0A=
I didn't see how I could split it in several commits, but I don't see =0A=
this as a big deal.=0A=
We can split it any way we/Herbert agree on.=0A=
=0A=
> Furthermore, the callback should not be registred at init, but should be =
part of the struct crypto_engine_op.=0A=
=0A=
We need to check if we can enqueue a new request before dequeuing the =0A=
request from crypto-engine's queue.=0A=
=0A=
> And the callback need to have the crypto engine itself as parameter, in c=
ase the driver own more than one crypto engine.=0A=
I can add crypto-engine as argument if you consider it useful.=0A=
=0A=
> In my serie I added also the current request for giving more hint on the =
current state and let the driver do the right decision.=0A=
> =0A=
If you refer to linked requests, this is something specific for your =0A=
case/driver. I'm not handling this case, here.=0A=
But, for sure, is not correct to do do_one_request, only on the first =0A=
request. This breaks the current API and doesn't scale to supporting =0A=
multiple independent requests.=0A=
