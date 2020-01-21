Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789D4C2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 14:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E602217F4
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 14:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WKWvCXxr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAUOUc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 09:20:32 -0500
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:49287
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbgAUOUc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 09:20:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muE6SzSZ12Ci2lxjGAivXzLmXdW/qGCQQxBbqP0sNScApm7mizGq/9rGOLdTJpNFhlwrciFp2lxnIDRrXrI7VViFe6JfvYTaSLv1EHS3DNh+gqGjRtJ2JL0x6DKAAykBLMSqXdYKGaFcWAJtOtqrEsmcvlYcwcUBflztH41oFGTFiXo8uVBJbU6QACFn5zRoz+bcJBVJhb2jDt9mScPdoywjXp4noJgW9WvN63RN1ZX4f3DzNZDIHR8401JugDIsNN8uGT5aw1kvqFyMkiFxq2r+yxKF/kyy3rKB3quTinLOQXNXhcPx9xI/m8mbbjlMuXJWRCOHj1cNNS5ARdaLyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5r4RKqXuAbnzsfFP7wHDsE5tCflY0qwh816vubip3Bo=;
 b=TH4mymLwGzVbrdF5NVstOH8MABV83p0RzYqgVhezPl/uiCEgLANloBZMrJ9ekEt5PO7vXECcmjF0xmQFCZ2Kac34j+3Cbau0udGED8dqtg8wEcOgCNgbJCU66d0co2mbZk65LVXswnWuTHd/PA/qATJq5V2/9ke/ACTcPuGEAwlj9ed6tOIoYZOuTvmJxzdTnGXTjI+CgGZa8D8suWCSMBJUhoGl1srORavc3f2zgIesPBENd4210PUoYuD7xlWxynnpt6X6kmfajHhvQQbtsJt9unv+lXbVCK+606hJpfUw9UUpAr8UKVnqHL63Vp2hoanP8/1P5wF7rQTx+RfkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5r4RKqXuAbnzsfFP7wHDsE5tCflY0qwh816vubip3Bo=;
 b=WKWvCXxrS62zdCO16cHCPOtj9ZNhEkQPHe2+xEwRjlnW55BkO7RxnaQzFpXEOZo/rLSLxPK8Ur3faH38XlQLOQI7RRwP409faCWzkNhhDJbScudnrvwIaNguTj5iVGP0Uow1m+hnOnXKSJJ329keI5eD6u3m6K6aeJBkJ3NGnH8=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5231.eurprd04.prod.outlook.com (20.177.50.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 14:20:27 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 14:20:27 +0000
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
Subject: Re: [RFC PATCH] Crypto-engine support for parallel requests
Thread-Topic: [RFC PATCH] Crypto-engine support for parallel requests
Thread-Index: AQHVz+nyH19jpegvq0OzoQlSx1aIPw==
Date:   Tue, 21 Jan 2020 14:20:27 +0000
Message-ID: <VI1PR04MB44454A0468073981FDA603B38C0D0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
 <20200121100053.GA14095@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46304299-6e75-4dc5-7d4b-08d79e7d100c
x-ms-traffictypediagnostic: VI1PR04MB5231:|VI1PR04MB5231:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5231C36DFD8B295AB5ECDFA08C0D0@VI1PR04MB5231.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:312;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(199004)(189003)(30864003)(53546011)(66946007)(6506007)(54906003)(55016002)(52536014)(66556008)(64756008)(66476007)(71200400001)(66446008)(76116006)(91956017)(86362001)(33656002)(7696005)(8676002)(8936002)(478600001)(81156014)(26005)(7416002)(2906002)(186003)(5660300002)(81166006)(6916009)(4326008)(44832011)(9686003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5231;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m+ZT3HfFPVLRyFCLcRwuxI7N6W2qCPlsiRoKW5UsW++Ti4ZHoNFf3IBhTEmBde4mZq0BmIgTFF0lryVUW86tuIVgTbeosiNZUjS0b/7iq3W4KNQI0wbFaSFC3XRHaQbi7OqJMeayZd2s9WfGBJ2e7ngVMuNQtmGQXl+DjOfEZ97hj3uty7osklvFAPuVbXZnEyby0Jx+jSQj9XqZCTD2mSFxHqhYUZ5PUYP1x0HE8d8VnFl9mPQHJgeGiMeOcfZrvK3JBj62KDDJKvpDT01C9VohdGKDZ7/w0mbAFtQnEjF7sii4jDdbxmXisBIzvwyMs0wIJWCx4yOxmik9J7PZLwcC/M8aXNOHVDUJACju4wq9Ly1STihIW7bo1x6EMO08uMEF3D+q7140XEG1jQJDJFKGKP2AfQpRSn4wUUPUhXf9ba/nWVFvpsPrXpv3kvH5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46304299-6e75-4dc5-7d4b-08d79e7d100c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 14:20:27.2276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nOmlZ7tMcdb6vUyWtlyP44egShxY6VqJxGIR9cbs/bEWY7pmB7pYEQXcN2yuPvEIWiymmymuo0x5HGdKB8G5rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5231
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/21/2020 12:00 PM, Corentin Labbe wrote:=0A=
> On Tue, Jan 21, 2020 at 01:32:29AM +0200, Iuliana Prodan wrote:=0A=
>> Added support for executing multiple requests, in parallel,=0A=
>> for crypto engine.=0A=
>> A no_reqs is initialized and set in the new=0A=
>> crypto_engine_alloc_init_and_set function.=0A=
>> Here, is also set the maximum size for crypto-engine software=0A=
>> queue (not hardcoded anymore).=0A=
>> On crypto_pump_requests the no_reqs is increased, until the=0A=
>> max_no_reqs is reached, and decreased on crypto_finalize_request,=0A=
>> or on error path (in case a prepare_request or do_one_request=0A=
>> operation was unsuccessful).=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> ---=0A=
>>   crypto/crypto_engine.c  | 112 +++++++++++++++++++++++++++++++++-------=
--------=0A=
>>   include/crypto/engine.h |  11 +++--=0A=
>>   2 files changed, 84 insertions(+), 39 deletions(-)=0A=
>>=0A=
>> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
>> index eb029ff..5219141 100644=0A=
>> --- a/crypto/crypto_engine.c=0A=
>> +++ b/crypto/crypto_engine.c=0A=
>> @@ -14,6 +14,7 @@=0A=
>>   #include "internal.h"=0A=
>>   =0A=
>>   #define CRYPTO_ENGINE_MAX_QLEN 10=0A=
>> +#define CRYPTO_ENGINE_MAX_CONCURRENT_REQS 1=0A=
>>   =0A=
>>   /**=0A=
>>    * crypto_finalize_request - finalize one request if the request is do=
ne=0A=
>> @@ -22,32 +23,27 @@=0A=
>>    * @err: error number=0A=
>>    */=0A=
>>   static void crypto_finalize_request(struct crypto_engine *engine,=0A=
>> -			     struct crypto_async_request *req, int err)=0A=
>> +				    struct crypto_async_request *req, int err)=0A=
>>   {=0A=
>>   	unsigned long flags;=0A=
>> -	bool finalize_cur_req =3D false;=0A=
>> +	bool finalize_req =3D false;=0A=
>>   	int ret;=0A=
>>   	struct crypto_engine_ctx *enginectx;=0A=
>>   =0A=
>>   	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>> -	if (engine->cur_req =3D=3D req)=0A=
>> -		finalize_cur_req =3D true;=0A=
>> +	if (engine->no_reqs > 0) {=0A=
>> +		finalize_req =3D true;=0A=
>> +		engine->no_reqs--;=0A=
>> +	}=0A=
>>   	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>>   =0A=
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
>> +	if (finalize_req && enginectx->op.prepare_request &&=0A=
>> +	    enginectx->op.unprepare_request) {=0A=
>> +		ret =3D enginectx->op.unprepare_request(engine, req);=0A=
>> +		if (ret)=0A=
>> +			dev_err(engine->dev, "failed to unprepare request\n");=0A=
>>   	}=0A=
>> -=0A=
>>   	req->complete(req, err);=0A=
>>   =0A=
>>   	kthread_queue_work(engine->kworker, &engine->pump_requests);=0A=
>> @@ -73,8 +69,8 @@ static void crypto_pump_requests(struct crypto_engine =
*engine,=0A=
>>   =0A=
>>   	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>>   =0A=
>> -	/* Make sure we are not already running a request */=0A=
>> -	if (engine->cur_req)=0A=
>> +	/* Make sure we have space, for more requests to run */=0A=
>> +	if (engine->no_reqs >=3D engine->max_no_reqs)=0A=
>>   		goto out;=0A=
>>   =0A=
>>   	/* If another context is idling then defer */=0A=
>> @@ -108,13 +104,16 @@ static void crypto_pump_requests(struct crypto_eng=
ine *engine,=0A=
>>   		goto out;=0A=
>>   	}=0A=
>>   =0A=
>> +retry:=0A=
>>   	/* Get the fist request from the engine queue to handle */=0A=
>>   	backlog =3D crypto_get_backlog(&engine->queue);=0A=
>>   	async_req =3D crypto_dequeue_request(&engine->queue);=0A=
>>   	if (!async_req)=0A=
>>   		goto out;=0A=
>>   =0A=
>> -	engine->cur_req =3D async_req;=0A=
>> +	/* Increase the number of concurrent requests that are in execution */=
=0A=
>> +	engine->no_reqs++;=0A=
>> +=0A=
>>   	if (backlog)=0A=
>>   		backlog->complete(backlog, -EINPROGRESS);=0A=
>>   =0A=
>> @@ -130,7 +129,7 @@ static void crypto_pump_requests(struct crypto_engin=
e *engine,=0A=
>>   		ret =3D engine->prepare_crypt_hardware(engine);=0A=
>>   		if (ret) {=0A=
>>   			dev_err(engine->dev, "failed to prepare crypt hardware\n");=0A=
>> -			goto req_err;=0A=
>> +			goto req_err_2;=0A=
>>   		}=0A=
>>   	}=0A=
>>   =0A=
>> @@ -141,26 +140,45 @@ static void crypto_pump_requests(struct crypto_eng=
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
>> -=0A=
>> -req_err:=0A=
>> -	crypto_finalize_request(engine, async_req, ret);=0A=
>> -	return;=0A=
>>   =0A=
>> +	/*=0A=
>> +	 * If there is still space for concurrent requests,=0A=
>> +	 * try and send a new one=0A=
>> +	 */=0A=
>> +	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>> +	if (engine->no_reqs < engine->max_no_reqs)=0A=
>> +		goto retry;=0A=
> =0A=
> You should check if engine->queue.qlen > 0 before retry.=0A=
> =0A=
>> +	goto out;=0A=
>> +=0A=
>> +req_err_1:=0A=
>> +	if (enginectx->op.unprepare_request) {=0A=
>> +		ret =3D enginectx->op.unprepare_request(engine, async_req);=0A=
>> +		if (ret)=0A=
>> +			dev_err(engine->dev, "failed to unprepare request\n");=0A=
>> +	}=0A=
>> +req_err_2:=0A=
>> +	async_req->complete(async_req, ret);=0A=
>> +	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>> +	/*=0A=
>> +	 * If unable to prepare or execute the request,=0A=
>> +	 * decrease the number of concurrent requests=0A=
>> +	 */=0A=
>> +	engine->no_reqs--;=0A=
>> +	goto retry;=0A=
> =0A=
> You should check if engine->queue.qlen > 0 before retry.=0A=
> =0A=
Here (and above) is not needed to check for qlen > 0, since on retry, =0A=
first thing is tryin to dequeue an async_req from crypto-engine queue. =0A=
In crypto_dequeue_request function is a check for qlen, that means than =0A=
in pump_request will goto out.=0A=
=0A=
>>   out:=0A=
>>   	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>>   }=0A=
>> @@ -386,15 +404,21 @@ int crypto_engine_stop(struct crypto_engine *engin=
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
>> + * crypto-engine queue and the maximum number of concurrent requests th=
at can=0A=
>> + * be executed at once.=0A=
>>    * @dev: the device attached with one hardware engine=0A=
>>    * @rt: whether this queue is set to run as a realtime task=0A=
>> + * @max_no_reqs: maximum number of request that can be executed in para=
llel=0A=
>> + * @qlen: maximum size of the crypto-engine queue=0A=
>>    *=0A=
>>    * This must be called from context that can sleep.=0A=
>>    * Return: the crypto engine structure on success, else NULL.=0A=
>>    */=0A=
>> -struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool=
 rt)=0A=
>> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *d=
ev,=0A=
>> +						       bool rt, int max_no_reqs,=0A=
>> +						       int qlen)=0A=
>>   {=0A=
>>   	struct sched_param param =3D { .sched_priority =3D MAX_RT_PRIO / 2 };=
=0A=
>>   	struct crypto_engine *engine;=0A=
>> @@ -411,12 +435,13 @@ struct crypto_engine *crypto_engine_alloc_init(str=
uct device *dev, bool rt)=0A=
>>   	engine->running =3D false;=0A=
>>   	engine->busy =3D false;=0A=
>>   	engine->idling =3D false;=0A=
>> -	engine->cur_req_prepared =3D false;=0A=
>>   	engine->priv_data =3D dev;=0A=
>>   	snprintf(engine->name, sizeof(engine->name),=0A=
>>   		 "%s-engine", dev_name(dev));=0A=
>> +	engine->max_no_reqs =3D max_no_reqs;=0A=
>> +	engine->no_reqs =3D 0;=0A=
>>   =0A=
>> -	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);=0A=
>> +	crypto_init_queue(&engine->queue, qlen);=0A=
>>   	spin_lock_init(&engine->queue_lock);=0A=
>>   =0A=
>>   	engine->kworker =3D kthread_create_worker(0, "%s", engine->name);=0A=
>> @@ -433,6 +458,23 @@ struct crypto_engine *crypto_engine_alloc_init(stru=
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
>> +	return crypto_engine_alloc_init_and_set(dev, rt,=0A=
>> +						CRYPTO_ENGINE_MAX_CONCURRENT_REQS,=0A=
>> +						CRYPTO_ENGINE_MAX_QLEN);=0A=
>> +}=0A=
>>   EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);=0A=
>>   =0A=
>>   /**=0A=
>> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
>> index e29cd67..5f9a6df 100644=0A=
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
>> @@ -38,14 +37,14 @@=0A=
>>    * @kworker: kthread worker struct for request pump=0A=
>>    * @pump_requests: work struct for scheduling work to the request pump=
=0A=
>>    * @priv_data: the engine private data=0A=
>> - * @cur_req: the current request which is on processing=0A=
>> + * @max_no_reqs: maximum number of request which can be processed in pa=
rallel=0A=
>> + * @no_reqs: current number of request which are processed in parallel=
=0A=
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
>> @@ -61,7 +60,8 @@ struct crypto_engine {=0A=
>>   	struct kthread_work             pump_requests;=0A=
>>   =0A=
>>   	void				*priv_data;=0A=
>> -	struct crypto_async_request	*cur_req;=0A=
>> +	int			max_no_reqs;=0A=
>> +	int			no_reqs;=0A=
>>   };=0A=
>>   =0A=
>>   /*=0A=
>> @@ -102,6 +102,9 @@ void crypto_finalize_skcipher_request(struct crypto_=
engine *engine,=0A=
>>   int crypto_engine_start(struct crypto_engine *engine);=0A=
>>   int crypto_engine_stop(struct crypto_engine *engine);=0A=
>>   struct crypto_engine *crypto_engine_alloc_init(struct device *dev, boo=
l rt);=0A=
>> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *d=
ev,=0A=
>> +						       bool rt, int max_no_reqs,=0A=
>> +						       int qlen);=0A=
>>   int crypto_engine_exit(struct crypto_engine *engine);=0A=
>>   =0A=
>>   #endif /* _CRYPTO_ENGINE_H */=0A=
>> -- =0A=
>> 2.1.0=0A=
>>=0A=
> =0A=
> Hello=0A=
> =0A=
> In your model, who is running finalize_request() ?=0A=
finalize_request() in CAAM, and in other drivers, is called on the _done =
=0A=
callback (stm32, virtio and omap).=0A=
=0A=
> In caam it seems that you have a taskqueue dedicated for that but you can=
not assume that all drivers will have this.=0A=
> I think the crypto_engine should be sufficient by itself and does not nee=
d external thread/taskqueue.=0A=
> =0A=
> But in your case, it seems that you dont have the choice, since do_one_re=
quest does not "do" but simply enqueue the request in the "jobring".=0A=
> =0A=
But, do_one_request it shouldn't, necessary,  execute the request. Is ok =
=0A=
to enqueue it, since we have asynchronous requests. do_one_request is =0A=
not blocking.=0A=
=0A=
> What about adding along prepare/do_one_request/unprepare a new enqueue()/=
can_do_more() function ?=0A=
> =0A=
> The stream will be:=0A=
> retry:=0A=
> optionnal prepare=0A=
> optionnal enqueue=0A=
> optionnal can_do_more() (goto retry)=0A=
> optionnal do_one_request=0A=
> =0A=
> then=0A=
> finalize()=0A=
> optionnal unprepare=0A=
> =0A=
=0A=
I'm planning to improve crypto-engine incrementally, so I'm taking one =0A=
step at a time :)=0A=
But I'm not sure if adding an enqueue operation is a good idea, since, =0A=
my understanding, is that do_one_request is a non-blocking operation and =
=0A=
it shouldn't execute the request.=0A=
=0A=
IMO, the crypto-engine flow should be kept simple:=0A=
1. a request comes to hw -> this is doing transfer_request_to_engine;=0A=
2. CE enqueue the requests=0A=
3. on pump_requests:=0A=
	3. a) optional prepare operation=0A=
	3. b) sends the reqs to hw, by do_one_request operation. To wait for =0A=
completion here it contradicts the asynchronous crypto API. =0A=
do_one_request operation has a crypto_async_request type as argument.=0A=
Note: Step 3. b) can be done several times, depending on size of hw queue.=
=0A=
4. in driver, when req is done:=0A=
	4. a) optional unprepare operation=0A=
	4. b) crypto_finalize_request is called=0A=
	=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
> The can_do_more simply will tell if we can enqueue more (this will handle=
 your case(ringjob), and my case(batching)=0A=
> Instead of storing the limit in the crypto_engine, you keep control on th=
e driver side.=0A=
> =0A=
> For your case the do_one_request will be unset, for mine I will use to ra=
n the batch.=0A=
> But for other drivers, no change will be necessary (appart adding some en=
queue=3DNULL,can_do_more=3DNULL).=0A=
> =0A=
> We can also imagine an easier solution like enqueue returning a positive =
value saying to queue more.=0A=
> =0A=
> Regards=0A=
> =0A=
=0A=
