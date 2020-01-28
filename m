Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,LONGWORDS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DCCC2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 15:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4542073A
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 15:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="l/3sqy9m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgA1PuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 10:50:19 -0500
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:31971
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbgA1PuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 10:50:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=By7BIZ2shaqK1TwbdlkTf/hJIg8KAgQFtGb/v18GY2OfVgrZyhlC1Hawfy004cCsY7Qg1cck2b34RzKUUSwy1P0TeEqCh/28VSSETuOJqH/scFzJ68PjgOie0cJvadjjUa8C8ayCyDpcDtNkiweerWKEtL7j4CI+zmeSOl3PyU31NI805umdIWW2ikdkvhPZwb0Aif9XZWFRBcoDNL1eLEzqx5SFBlVlHplHh2Tt4pCyVzz8VL0ot5zCw1trTnadYZjEC+g8H4MkXieATZa5oMSi4w1vybO06QeRKwPK8P5BQxjML3jYdLQFCzNqPJuvdCQ4vjmuhPczeafEvaWg9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOzm/0tavGiYMUY2uMY5N4bzxWJs+ul+QnJrYXCt4AQ=;
 b=Dv7XC6hm7KGWSfUPG2k3yJXzWbOCtAeFfSLxke7hp6oZLVZL+weh5fN7H/726cqCrMK/66Wg1ayN8gNqFKKBcHAEMKnZ8UODj9CY5Ll7FUzUiEGWQr2Gu15Gl9m74cX0n1GofUi2s5p4rVfr2yModQaL0aShJCmOSd6XEJkkZBMY1xuwxwu5y7iPEdz+bVZO863p4wBUl3fr7ESweHgtS0MWYOKcFmLEwWBe64tVdPu5VBk5fnAGy7P+UF8XwxWE5pyk6tKmZkTN8VBT+RiAzlYTDw6lBMlchChEzDPmBECZ+J8AgzJzKfoi66WqlC8FPNrP2rS5Mbhbdshd89NnLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOzm/0tavGiYMUY2uMY5N4bzxWJs+ul+QnJrYXCt4AQ=;
 b=l/3sqy9mBO4B+AQHUcuw0b3TuOiu974cH5DM/EBpTYbIeowyv+1ws0miirO6S09PTWO5fuXzcnC75pzvlvGONVL1S/iWGMppxxkhrhT1BS5HpZfhfqETMhvUDegqhKfbCQCPu3IcBU9cbKnRWwAS3l23YQLQWbK9M2409KM55m4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3758.eurprd04.prod.outlook.com (52.134.14.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Tue, 28 Jan 2020 15:50:14 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 15:50:14 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
CC:     "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] crypto: engine: workqueue can only be processed one
 by one
Thread-Topic: [PATCH 1/9] crypto: engine: workqueue can only be processed one
 by one
Thread-Index: AQHV0RErU4XkhL83r0qysobyMlLYdA==
Date:   Tue, 28 Jan 2020 15:50:14 +0000
Message-ID: <VI1PR0402MB3485B787EA6BCDD5A5600BAA980A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
 <20200122104528.30084-2-clabbe.montjoie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f11a6f60-1b53-48d3-4620-08d7a409c41d
x-ms-traffictypediagnostic: VI1PR0402MB3758:|VI1PR0402MB3758:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3758AA4CC3AA84A217F2FC9D980A0@VI1PR0402MB3758.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(189003)(199004)(5660300002)(7696005)(26005)(186003)(44832011)(33656002)(71200400001)(2906002)(8936002)(55016002)(53546011)(6506007)(64756008)(66446008)(52536014)(91956017)(478600001)(76116006)(9686003)(66946007)(66476007)(6636002)(86362001)(81156014)(54906003)(81166006)(110136005)(316002)(8676002)(66556008)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3758;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5HLvYAl8kq+OkduLeeWErPQ75E2C3JzpZaNoewmoJawzV1HHYXMotZuGCF6/A00A9d4qeVZV5c0m2nu65ngKx9jz0DthFeqdyOs71Dxw9QZ1U129Jt6cVgdq7iF6nFL25OtyCw8BwCnd4pqWsm0kFQOWBb5ftYtBEGV7TS8Bei4v8Ss6Z7U5MbP7z2zVg+3/iYq3hbOMX5YwIVpvRn75j7xdfLDgEqDMt5agnh0iu0ooVpNLqzZQ9GieamMX+omhNoXg89/JUogZbqxoEbuQrzEPpStaEJQQnca+3f2TBaJz9l3yaJHcI+AXAGxkT1XOGx7Upfn8GTvKbkTG73dbFf/+a33OFBJ5dNBnHKAi3DPZw+k3HkzH5XYjtsdBOMi0Jsh4RCr1PXZub7V7iW+fZpAb1qOC6rXq8PfxWK3nBQbmt2NHzQxT3XyDh5abI6Yo
x-ms-exchange-antispam-messagedata: H0VihkBo2rCWd4HjHzTDJSbeKrCARRGiQBYiZxXbZZ0NsqtgEtzMdhRSSs0NteY1k9H9AFN6tDs261g7d7d9lrxK6y80T/FhoxQjT7dVParfo3ovRV2+cAalSXRQMyRwBx2wBpeLvghaV2kDPCZQkw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11a6f60-1b53-48d3-4620-08d7a409c41d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 15:50:14.6441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +kNzlJIgiV16h0AQ1A94J101UrsS34r1J0/QYd5oOQ47SUGR89DSHG7vRNFc5hgL4I+GIhzAIqLwu2coHHW0/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3758
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/22/2020 12:46 PM, Corentin Labbe wrote:=0A=
> Some bykeshedding are unnecessary since a workqueue can only be executed=
=0A=
> one by one.=0A=
> This behaviour is documented in:=0A=
> - kernel/kthread.c: comment of kthread_worker_fn()=0A=
> - Documentation/core-api/workqueue.rst: the functions associated with the=
 work items one after the other=0A=
[...]=0A=
> @@ -73,16 +73,6 @@ static void crypto_pump_requests(struct crypto_engine =
*engine,=0A=
>  =0A=
>  	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>  =0A=
> -	/* Make sure we are not already running a request */=0A=
> -	if (engine->cur_req)=0A=
> -		goto out;=0A=
> -=0A=
This check is here for a good reason, namely because crypto engine=0A=
cannot currently handle multiple crypto requests being in "flight"=0A=
in parallel.=0A=
=0A=
More exactly, if this check is removed the following sequence could occur:=
=0A=
crypto_pump_work() -> crypto_pump_requests() -> .do_one_request(areq1)=0A=
crypto_pump_work() -> crypto_pump_requests() -> .do_one_request(areq2)=0A=
crypto_finalize_request(areq1)=0A=
crypto_finalize_request(areq2)=0A=
=0A=
This isn't correctly handled in crypto_finalize_request(),=0A=
since .unprepare_request will be called only for areq2.=0A=
=0A=
/**=0A=
 * crypto_finalize_request - finalize one request if the request is done=0A=
 * @engine: the hardware engine=0A=
 * @req: the request need to be finalized=0A=
 * @err: error number=0A=
 */=0A=
static void crypto_finalize_request(struct crypto_engine *engine,=0A=
			     struct crypto_async_request *req, int err)=0A=
{=0A=
	unsigned long flags;=0A=
	bool finalize_cur_req =3D false;=0A=
	int ret;=0A=
	struct crypto_engine_ctx *enginectx;=0A=
=0A=
	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
	if (engine->cur_req =3D=3D req)=0A=
		finalize_cur_req =3D true;=0A=
	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
=0A=
	if (finalize_cur_req) {=0A=
		enginectx =3D crypto_tfm_ctx(req->tfm);=0A=
		if (engine->cur_req_prepared &&=0A=
		    enginectx->op.unprepare_request) {=0A=
			ret =3D enginectx->op.unprepare_request(engine, req);=0A=
			if (ret)=0A=
				dev_err(engine->dev, "failed to unprepare request\n");=0A=
		}=0A=
		spin_lock_irqsave(&engine->queue_lock, flags);=0A=
		engine->cur_req =3D NULL;=0A=
		engine->cur_req_prepared =3D false;=0A=
		spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
	}=0A=
=0A=
	req->complete(req, err);=0A=
=0A=
	kthread_queue_work(engine->kworker, &engine->pump_requests);=0A=
}=0A=
=0A=
Horia=0A=
