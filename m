Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362FAC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 22:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2FDF2087F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 22:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZmHQGicQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgA0W6n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 17:58:43 -0500
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:1860
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbgA0W6n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 17:58:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEwEx59jAdK0Wg1Z8wKoQX83ugYFvI+Gbm7nXDQClSdbHtHkfsPTQ/q7SHffVYDkxhsIQN+S0qMr5R5MKgjLmTeX6Dw/kkSFv9aLKW8RwJOvLbd00vkTnLpbf6NJq+72r2Zbi0I00qzYxdISXnQhbkoN4F+U6WaXIIkA/dxCZI1om19PuH9b9zhEodZH8t+aZwJD9Z6C13Sr7cvPQP3/OIYtNfTd+FymdIhHFGxeyXXyAY9N2iblrgLlBJdLJDpM39ZgVTI1Zk4Ss1Vfdep1U946z7T6phAP4h8+1pHkO/6CKBY3BK7Rff97hYviRoGtCh7p62TXftvFTchAY3mRQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0+yuWxB15ACIGMy5ikOWlTGT9103nJnVrQZ5zr15Sc=;
 b=R1NSEJUV1B/faOtQMw1+1dsHvPDmrJe6isfiLK7ML/vAaXM+nTmz4sucY/Ww8Ivq/qIt1AwTIBRDBIWxzFMEY8UjmMp2nSM62L7anOSL6qP8ombsrgzIN/uVDEv//mNEJVfC2TPmks6hjVQRWZYHO2Sc51UtNBLvaLtfveSI3bd+Xvb6gxrfXEhFQd+3mM3AI1EJosYICeS26XwqBb6An4C8fdti729sk6/PEuV3WmaTwM+NuvO3qbm9ZySQRIZ4obWDnMkKvS0sYtD1G+EUAKTZ233MXLrr4KVS1CsigkEsbanXReBUPmoVk1p6ozPR5n0UbvfzRjvaGf4BbTt2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0+yuWxB15ACIGMy5ikOWlTGT9103nJnVrQZ5zr15Sc=;
 b=ZmHQGicQLwbiEZ0AiVz+eAN1+guzDRsJRirrsfo/vbhZ+Vh41XX3JeLZbJNrJjsHvGS3xJbEi9P+VaXAuKuQzF/CWKOxFdpZ5KpPkcf3UeocpTR0FTugv3O00W0XE1Ek3eSH6ERarRNccqXOwGQLdF1bl9nRPZfFrbTlzkQpeYA=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0PR04MB5107.eurprd04.prod.outlook.com (20.177.41.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 22:58:36 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::59a8:ca29:d637:3c84]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::59a8:ca29:d637:3c84%5]) with mapi id 15.20.2665.026; Mon, 27 Jan 2020
 22:58:36 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 5/9] crypto: engine: add enqueue_request/can_do_more
Thread-Topic: [PATCH 5/9] crypto: engine: add enqueue_request/can_do_more
Thread-Index: AQHV0REbcTp6Ox1gSU+lAn+fB1GkDg==
Date:   Mon, 27 Jan 2020 22:58:36 +0000
Message-ID: <AM0PR04MB717155300E3575C07D31E1D08C0B0@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
 <20200122104528.30084-6-clabbe.montjoie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b139fd7-ab62-49cc-fe68-08d7a37c7129
x-ms-traffictypediagnostic: AM0PR04MB5107:
x-microsoft-antispam-prvs: <AM0PR04MB5107CF74D6025AE4248812AD8C0B0@AM0PR04MB5107.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(316002)(186003)(6506007)(53546011)(81156014)(81166006)(71200400001)(8936002)(66556008)(66476007)(110136005)(91956017)(966005)(76116006)(66946007)(5660300002)(2906002)(52536014)(8676002)(55016002)(9686003)(4326008)(66446008)(45080400002)(478600001)(7696005)(86362001)(64756008)(26005)(44832011)(54906003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5107;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UuDwOtDviMwgR5Wd4OuRfKl58TEpuEZucfPN/UCdbswMIUYVt3dwrvfPl6FfajnQI+P0tXVXIYwq17eGi+DjVDqTx2UAPssA1ajUVMOVm41sYfK7icsPJcpzol32oR9qKEp4JU8Y7l2/do8ss5lBcc4gSQuJ+APOO0igzRvXS4IZ/d3k8qMh7wjyT9PKGQEb8Lj92o0A8bO6gzVUQriJpPAoFYAekS7GPyZHduTqPhGsAvXNjVsbtlMt8f+gPOTpj+ePLDD34NcHnsWLP5fyBrhevJLPSR57ss/Qt5kGTr5zJi06gKd9M7EjawyJL8B7KauhXczaJ3tHqo4kAOzFxRKuSVZvY5/QA2laprrQZx7ikqDFdRrYtViTkAdl7U7+UMIbHBQRwND0GNgqYpAIW1kh0glROAAxri4XBeSMwbr2AEf1pVYRWIhDjlFOYyzz+fhkZrc6YJTSuQaJJfLDo6xhOnkFP648tr4fGkw4HqLvpYJBAvBrGQXT+mARGKzSFLVzkMu+v0fZeLuf/AdvrA==
x-ms-exchange-antispam-messagedata: jdENUvtrhmqrXspfYcYwq/0mI8W0ZEUYRwUC01o3ytqG2vxauEFDPV0a+D8lwdz9UcRfsBbQ+0bTgszr4PYSIpCjnzD+D+KKlv4wMkFyUFME98p6j7KZ9G2ZKx7xt8GXck+zs49EsvCtNRpbzzty4w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b139fd7-ab62-49cc-fe68-08d7a37c7129
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 22:58:36.5088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F+CnJMpdU+pAJl/uOX4TpKCZ31WgrO9p/bnUtW+3nByPp91grqJ9pXZQo2slD8fOONFXV7gy/+efyu35LQe+kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5107
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/22/2020 12:45 PM, Corentin Labbe wrote:=0A=
> This patchs adds two new function wrapper in crypto_engine.=0A=
> - enqueue_request() for drivers enqueuing request to hardware.=0A=
> - can_queue_more() for letting drivers to tell if they can=0A=
> enqueue/prepare more.=0A=
> =0A=
> Since some drivers (like caam) only enqueue request without "doing"=0A=
> them, do_one_request() is now optional.=0A=
> =0A=
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>=0A=
> ---=0A=
>   crypto/crypto_engine.c  | 25 ++++++++++++++++++++++---=0A=
>   include/crypto/engine.h | 14 ++++++++------=0A=
>   2 files changed, 30 insertions(+), 9 deletions(-)=0A=
> =0A=
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
> index 5bcb1e740fd9..4a28548c49aa 100644=0A=
> --- a/crypto/crypto_engine.c=0A=
> +++ b/crypto/crypto_engine.c=0A=
> @@ -83,6 +83,7 @@ static void crypto_pump_requests(struct crypto_engine *=
engine,=0A=
>   		goto out;=0A=
>   	}=0A=
>   =0A=
> +retry:=0A=
>   	/* Get the fist request from the engine queue to handle */=0A=
>   	backlog =3D crypto_get_backlog(&engine->queue);=0A=
>   	async_req =3D crypto_dequeue_request(&engine->queue);=0A=
> @@ -118,10 +119,28 @@ static void crypto_pump_requests(struct crypto_engi=
ne *engine,=0A=
>   			goto req_err2;=0A=
>   		}=0A=
>   	}=0A=
> +=0A=
> +	if (enginectx->op.enqueue_request) {=0A=
> +		ret =3D enginectx->op.enqueue_request(engine, async_req);=0A=
> +		if (ret) {=0A=
> +			dev_err(engine->dev, "failed to enqueue request: %d\n",=0A=
> +				ret);=0A=
> +			goto req_err;=0A=
> +		}=0A=
> +	}=0A=
> +	if (enginectx->op.can_queue_more && engine->queue.qlen > 0) {=0A=
> +		ret =3D enginectx->op.can_queue_more(engine, async_req);=0A=
> +		if (ret > 0) {=0A=
> +			spin_lock_irqsave(&engine->queue_lock, flags);=0A=
> +			goto retry;=0A=
> +		}=0A=
> +		if (ret < 0) {=0A=
> +			dev_err(engine->dev, "failed to call can_queue_more\n");=0A=
> +			/* TODO */=0A=
> +		}=0A=
> +	}=0A=
>   	if (!enginectx->op.do_one_request) {=0A=
> -		dev_err(engine->dev, "failed to do request\n");=0A=
> -		ret =3D -EINVAL;=0A=
> -		goto req_err;=0A=
> +		return;=0A=
>   	}=0A=
>   	ret =3D enginectx->op.do_one_request(engine, async_req);=0A=
>   	if (ret) {=0A=
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
> index 03d9f9ec1cea..8ab9d26e30fe 100644=0A=
> --- a/include/crypto/engine.h=0A=
> +++ b/include/crypto/engine.h=0A=
> @@ -63,14 +63,16 @@ struct crypto_engine {=0A=
>    * @prepare__request: do some prepare if need before handle the current=
 request=0A=
>    * @unprepare_request: undo any work done by prepare_request()=0A=
>    * @do_one_request: do encryption for current request=0A=
> + * @enqueue_request:	Enqueue the request in the hardware=0A=
> + * @can_queue_more:	if this function return > 0, it will tell the crypto=
=0A=
> + * 	engine that more space are availlable for prepare/enqueue request=0A=
>    */=0A=
>   struct crypto_engine_op {=0A=
> -	int (*prepare_request)(struct crypto_engine *engine,=0A=
> -			       void *areq);=0A=
> -	int (*unprepare_request)(struct crypto_engine *engine,=0A=
> -				 void *areq);=0A=
> -	int (*do_one_request)(struct crypto_engine *engine,=0A=
> -			      void *areq);=0A=
> +	int (*prepare_request)(struct crypto_engine *engine, void *areq);=0A=
> +	int (*unprepare_request)(struct crypto_engine *engine, void *areq);=0A=
> +	int (*do_one_request)(struct crypto_engine *engine, void *areq);=0A=
> +	int (*enqueue_request)(struct crypto_engine *engine, void *areq);=0A=
> +	int (*can_queue_more)(struct crypto_engine *engine, void *areq);=0A=
>   };=0A=
=0A=
As I mentioned in another thread [1], these crypto-engine patches (#1 - =0A=
#5) imply modifications in all the drivers that use crypto-engine.=0A=
It's not backwards compatible.=0A=
Your changes imply that do_one_request executes the request & waits for =0A=
completion and enqueue_request sends it to hardware. That means that all =
=0A=
the other drivers need to be modify, to implement enqueue_request, =0A=
instead of do_one_request. They need to be compliant with the new =0A=
changes, new API. Otherwise, they are not using crypto-engine right, =0A=
don't you think?=0A=
=0A=
Also, do_one_request it shouldn=92t be blocking. We got this confirmation =
=0A=
from Herbert [2].=0A=
=0A=
[1] =0A=
https://lore.kernel.org/lkml/VI1PR04MB44455343230CBA7400D21C998C0C0@VI1PR04=
MB4445.eurprd04.prod.outlook.com/=0A=
[2] =0A=
https://lore.kernel.org/lkml/20200122144134.axqpwx65j7xysyy3@gondor.apana.o=
rg.au/=0A=
