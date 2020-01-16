Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD58C33CB6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 11:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEB42073A
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 11:34:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mHJ6roZz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgAPLeX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:34:23 -0500
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:26606
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbgAPLeW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 06:34:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYwjU8IMDuYLntjRCDwswlEsNoBmkQ70+O5jcVh7CyRichM3xcONv+BLVHFizRWv4Kg5Ua6oShtiXSmtV4z5+iOKLQPzL0V4I01SRpNWHvGFOu2R0lbT176eXolW2Zv3K0W/LsCalMoz4qx8rPj2daIJ2QiXnYukkypku5LztS2naLwP9FbnYWSPo408wEwl9GrFA/LD24j6R2pKnS5ykSeIpi5CDrgBEIRJqlUbDF7yq9GmJbsLb89H2BcPKconbF1/8pl2SwY2a7f7/G+q+5Lj9AWLlpcPu7851M8QwwT8EmAzFsPTtAhvX/I8gABkT5cVp58ECamg0eOMkTADrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7vftZODp7N45v2I6k/5mp68xKFfdE5FTVnZFi7YVVU=;
 b=RkQAkr5P2KxTXE1ElrzpsNtXIMpSoq/4MJ0PFRqEhk0bZ/TXKne0O8CFgrreGwhDYUThWzZCuh8hS9EeAEjwU6BHJx7g0ARTnWokmqu1r90r8jjsj8PMqES2+jnUanZL09tiT5EJkSWix3ItzekwO7WTy/8Dg5BtQbvj7a4LTI5yzTZmAadXoCY9JuyWa9qllgkVsISsjx07I3hvlF0uHK4oQUTb9dQZzwxN1CqZfGL8j5ctSlGRMtHxwUfAVMXMVivc5VBIB25p7yeGEh9MnMewmDVxNYBjbMFZK8q3xFQouJfF9Ebu2r8svMSWfiGUUKBDXIxuzseQWs1Y/ocoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7vftZODp7N45v2I6k/5mp68xKFfdE5FTVnZFi7YVVU=;
 b=mHJ6roZzWDplPjZEBjIoHsbggZ2qM9rZtHnAnqUPWWvrdm8J8anYjE13VqIMa83WWKDWzwOWTYOOGP0A2hV9wKB2CsxTLNcWUwf/onojGgcT2u4OKM49GdOpqtgpn8w57M8dOhOEHoC/jdeM0qG8NMzrMPuHiy1Lgkyxd64G9uE=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB7184.eurprd04.prod.outlook.com (10.186.157.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 11:34:19 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 11:34:19 +0000
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
Subject: Re: [PATCH RFC 06/10] crypto: engine: introduce ct
Thread-Topic: [PATCH RFC 06/10] crypto: engine: introduce ct
Thread-Index: AQHVyuLpwfJViqB/TkiZAIjgROs28Q==
Date:   Thu, 16 Jan 2020 11:34:19 +0000
Message-ID: <VI1PR04MB44455F7F7830159B6ED336648C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
 <20200114135936.32422-7-clabbe.montjoie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 951b7343-9be3-449e-05a6-08d79a7806e4
x-ms-traffictypediagnostic: VI1PR04MB7184:|VI1PR04MB7184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB718406D5E0075A2B652C9D828C360@VI1PR04MB7184.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(189003)(199004)(9686003)(44832011)(8936002)(6636002)(5660300002)(81156014)(81166006)(8676002)(71200400001)(7696005)(4326008)(2906002)(6506007)(316002)(66446008)(66556008)(66476007)(66946007)(64756008)(54906003)(55016002)(110136005)(86362001)(76116006)(478600001)(186003)(53546011)(33656002)(52536014)(26005)(7416002)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7184;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KbYVuIPnPrrb+m7mEkr2F4fRlKHoxdg1nnjCv7U1IpeoXtL2mupxwKTt30I1TD4ptalvD8jpa99FOeMt3+j8/buAtqSnDaD5TXkpRQClqTRaVMWXUh1ZdrAaNeA7VQOtt8Se5H45hSG5bavNDjqcmBudsoh6CIRn6PqNYrHGJZ9j8XLRNk54QVALG/FWuTI2NvcHt9gYpD+tGULjiA/Qiv8Mpg8CDz9O68DlwrrEECrZmjWty/2QbL79zlanR0KVkuND8rSArh873+y0V053glbYV4I//S4DlxVvUTUlLP2f58U2FZJn6pIlKURrP6aVElmjNb+K2xI6SY2Y4IV8HBL80CZVKQydw1V3kDK9BNw2un+5UxUCJrWYQdKkKHwOQmYQN8sXYKUpMIUDc/tCUJzzqhFs0IpRRTnh42KWxTDf0ts5D1zF5TzTNjgqLgpp
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 951b7343-9be3-449e-05a6-08d79a7806e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 11:34:19.7385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQ5imzjKGCbotMlIwqAkYw8oVvujyTv5ed/SwmjOwKcv5lA6Lbtvw60HNPot6i0Y1Ca8xZ4T18bfa6QrhhID+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7184
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/14/2020 4:00 PM, Corentin Labbe wrote:=0A=
> We will store the number of request in a batch in engine->ct.=0A=
> This patch adds all loop to unprepare all requests of a batch.=0A=
> =0A=
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>=0A=
> ---=0A=
>   crypto/crypto_engine.c  | 30 ++++++++++++++++++------------=0A=
>   include/crypto/engine.h |  2 ++=0A=
>   2 files changed, 20 insertions(+), 12 deletions(-)=0A=
> =0A=
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
> index b72873550587..591dea5ddeec 100644=0A=
> --- a/crypto/crypto_engine.c=0A=
> +++ b/crypto/crypto_engine.c=0A=
> @@ -28,6 +28,7 @@ static void crypto_finalize_request(struct crypto_engin=
e *engine,=0A=
>   	bool finalize_cur_req =3D false;=0A=
>   	int ret;=0A=
>   	struct crypto_engine_ctx *enginectx;=0A=
> +	int i =3D 0;=0A=
>   =0A=
>   	spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>   	if (engine->cur_reqs[0].req =3D=3D req)=0A=
You're checking here just the first request, but do the completion for =0A=
all? Why? Shouldn't we check for each request if it was done by hw or not?=
=0A=
=0A=
I've also seen that the do_one_request is called only on the first =0A=
request, from the batch.=0A=
=0A=
In your driver you do the prepare/unprepare for the whole batch at once, =
=0A=
but not all drivers, who uses crypto-engine, are doing this (see virtio, =
=0A=
amlogic, stm32). And I don't know if they can...=0A=
=0A=
> @@ -35,17 +36,20 @@ static void crypto_finalize_request(struct crypto_eng=
ine *engine,=0A=
>   	spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>   =0A=
>   	if (finalize_cur_req) {=0A=
> -		enginectx =3D crypto_tfm_ctx(engine->cur_reqs[0].req->tfm);=0A=
> -		if (engine->cur_reqs[0].prepared &&=0A=
> -		    enginectx->op.unprepare_request) {=0A=
> -			ret =3D enginectx->op.unprepare_request(engine, engine->cur_reqs[0].r=
eq);=0A=
> -			if (ret)=0A=
> -				dev_err(engine->dev, "failed to unprepare request\n");=0A=
> -		}=0A=
> -		engine->cur_reqs[0].req->complete(engine->cur_reqs[0].req, err);=0A=
> +		do {=0A=
> +			enginectx =3D crypto_tfm_ctx(engine->cur_reqs[i].req->tfm);=0A=
> +			if (engine->cur_reqs[i].prepared &&=0A=
> +			    enginectx->op.unprepare_request) {=0A=
> +				ret =3D enginectx->op.unprepare_request(engine, engine->cur_reqs[i].=
req);=0A=
> +				if (ret)=0A=
> +					dev_err(engine->dev, "failed to unprepare request\n");=0A=
> +			}=0A=
> +			engine->cur_reqs[i].prepared =3D false;=0A=
> +			engine->cur_reqs[i].req->complete(engine->cur_reqs[i].req, err);=0A=
> +		} while (++i < engine->ct);=0A=
>   		spin_lock_irqsave(&engine->queue_lock, flags);=0A=
> -		engine->cur_reqs[0].prepared =3D false;=0A=
> -		engine->cur_reqs[0].req =3D NULL;=0A=
> +		while (engine->ct-- > 0)=0A=
> +			engine->cur_reqs[engine->ct].req =3D NULL;=0A=
>   		spin_unlock_irqrestore(&engine->queue_lock, flags);=0A=
>   	} else {=0A=
>   		req->complete(req, err);=0A=
> @@ -109,13 +113,14 @@ static void crypto_pump_requests(struct crypto_engi=
ne *engine,=0A=
>   		goto out;=0A=
>   	}=0A=
>   =0A=
> +	engine->ct =3D 0;=0A=
>   	/* Get the fist request from the engine queue to handle */=0A=
>   	backlog =3D crypto_get_backlog(&engine->queue);=0A=
>   	async_req =3D crypto_dequeue_request(&engine->queue);=0A=
>   	if (!async_req)=0A=
>   		goto out;=0A=
>   =0A=
> -	engine->cur_reqs[0].req =3D async_req;=0A=
> +	engine->cur_reqs[engine->ct].req =3D async_req;=0A=
>   	if (backlog)=0A=
>   		backlog->complete(backlog, -EINPROGRESS);=0A=
>   =0A=
> @@ -144,8 +149,9 @@ static void crypto_pump_requests(struct crypto_engine=
 *engine,=0A=
>   				ret);=0A=
>   			goto req_err;=0A=
>   		}=0A=
> -		engine->cur_reqs[0].prepared =3D true;=0A=
> +		engine->cur_reqs[engine->ct].prepared =3D true;=0A=
>   	}=0A=
> +	engine->ct++;=0A=
>   	if (!enginectx->op.do_one_request) {=0A=
>   		dev_err(engine->dev, "failed to do request\n");=0A=
>   		ret =3D -EINVAL;=0A=
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
> index 362134e226f4..021136a47b93 100644=0A=
> --- a/include/crypto/engine.h=0A=
> +++ b/include/crypto/engine.h=0A=
> @@ -50,6 +50,7 @@ struct cur_req {=0A=
>    * @priv_data: the engine private data=0A=
>    * @rmax:	The number of request which can be processed in one batch=0A=
>    * @cur_reqs: 	A list for requests to be processed=0A=
> + * @ct:		How many requests will be handled in one batch=0A=
>    */=0A=
>   struct crypto_engine {=0A=
>   	char			name[ENGINE_NAME_LEN];=0A=
> @@ -73,6 +74,7 @@ struct crypto_engine {=0A=
>   	void				*priv_data;=0A=
>   	int 				rmax;=0A=
>   	struct cur_req 			*cur_reqs;=0A=
> +	int ct;=0A=
>   };=0A=
>   =0A=
>   /*=0A=
> =0A=
=0A=
