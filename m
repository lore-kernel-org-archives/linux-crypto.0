Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405F2C352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 11:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 031B320726
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 11:26:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lygOrMyh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGL0m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:26:42 -0500
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:14020
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbgBGL0m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 06:26:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOC+o3PH8/o4Q74/t5/QL+iFfXdLTK70AbI55oBMQ1hNRLFm8wb1bN1+qTd1uWkkDXkvEgN4Aw0dwe23ssRCxp0DEXTTCb32y3IWMJjgxmF1Tkw8L038xdkTAJGMZD6pCJNmluDxm94GUnw0hgdtI125ctK8QxflISyA1EQ/BX+OZy74+ga9epp5jm87eyvmWr9WhIJSkRAJtMdy2uDDmnixUeWcJIYvvBI4B+G/ui0Y3W1Pd1lQASsNN+th0bzHxpHvDMpx9W9kmlyv1UdZhcMxbUikLLzzgYdvb90oZ4zNnGfzr0CfpVvjSljkxIa9WBROi7dLAkTp6KFoTg3J1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh60Z76SN3npqkO38LqYNDbKN8yjHAqbbjyBmnS3mmk=;
 b=SaN4oljqWp3LCbX4DnnkKfZOuFcghOcGqlKMy0G4uUl/HCyZtRixuS1tXBkhnd6eGuYxqNcdc/pFLbw9DIR+wsL3GF717ArgWURMt8WUp4MtVK830Wh80swdWg2EOz4ixOiKj3Awxiq8RJCH7+G13gRBgd9sbSxnpkinIMdzwNWkgP3hYgB96zyHGkDIGxLyNmR2jyT3iaS9OZu8WGexKHKrrZXLOIqT0oaE9Vq5JcvQD0I84Ut7SVYN/P1LOt5ufJlppXjX55j+hw15cFMmrOvV/tw01GBfR+MFiY6LTyYScPPUDDrvzHnVtcpEdmo1dEBs2Im5aa1aESh3Rz1pWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh60Z76SN3npqkO38LqYNDbKN8yjHAqbbjyBmnS3mmk=;
 b=lygOrMyhxQa3bXMAAv2WL3X9WzQ4a+N6huxEjS0S/8S8LThiYcT5rFwFuMK81M4VRnpBRim6Mq/Hxu2Tx4cC1KiejwLXM+BphZ/gUIcQoynORI00ZJoG6ZEdl+rbxl7h7xdkKT8t+ccnAxDNIleCDrdiUYMf/Sx4A0t3xBvvH5c=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0PR04MB4964.eurprd04.prod.outlook.com (20.177.40.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Fri, 7 Feb 2020 11:26:39 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256%7]) with mapi id 15.20.2707.020; Fri, 7 Feb 2020
 11:26:39 +0000
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
Subject: Re: [PATCH v2 1/2] crypto: engine - support for parallel requests
Thread-Topic: [PATCH v2 1/2] crypto: engine - support for parallel requests
Thread-Index: AQHV21d9ovH+nULTjUSN5UBY10erRw==
Date:   Fri, 7 Feb 2020 11:26:38 +0000
Message-ID: <AM0PR04MB71711FEFD0738893772BE3198C1C0@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <1580819660-30211-1-git-send-email-iuliana.prodan@nxp.com>
 <1580819660-30211-2-git-send-email-iuliana.prodan@nxp.com>
 <20200205191128.GA32606@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fda9f352-b5a6-40be-ef3b-08d7abc09953
x-ms-traffictypediagnostic: AM0PR04MB4964:|AM0PR04MB4964:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB49643E5C33C05D66A7A9D02B8C1C0@AM0PR04MB4964.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0306EE2ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(199004)(189003)(4326008)(186003)(6506007)(53546011)(54906003)(26005)(316002)(55016002)(8676002)(81166006)(81156014)(7416002)(5660300002)(8936002)(6916009)(52536014)(9686003)(71200400001)(86362001)(2906002)(66446008)(33656002)(66476007)(66946007)(66556008)(64756008)(76116006)(44832011)(7696005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4964;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NCPVGh+HlATU4jGS2EsfvzJPbiFGtsrX4FLMZor8YEBbkmVW2hRZBwKU3JxA1Vr7kE2G0f3cCedRcVGMJSY6scyJoUN9auVP1ZkRx7E91NxFSvQCW2YJitis5DKRco1vZQ8hPfCkTNOYU/7Sl/hqG0xDNtTsYyovNYTPh+d+DlbgjB24lJMAXXdxazFHsOrczNI8Ht6wKifvz9FlegoUNkgxdzeGV7Q0bjov3qmcHOhLRs006jzxY/OowEL5v2ticS0F1LJEmRcY3yie8J4eZNUqLR2hfGAPIkoyV6vkNPwCL5ljvJh01DWbynISIrlSduBm76TZFXbEckX1SYdXdEs77OJaimHtFVsqO59eOhic/gP/8LbMDGWBGiH0XJkfsmPVsw+E4KKZNRewoOjmHCCa8TwXfiecj1fWQGtqoOCI25KWD5CSAcR76gD9/z3D
x-ms-exchange-antispam-messagedata: MDEDPhnVA8plwD+arzy8TrU3O0lfqYRMuPlw2neiGv5XHiKDlEN14SEcIe/w/+g/DaO7A8uExLB2C+ILN2Phhd0O52pMDGWndyb3OLoR4ipuZKVAMTx3KFvxHqUioV3fbAO5lX4RfXaVXEmQfnk7kg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda9f352-b5a6-40be-ef3b-08d7abc09953
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2020 11:26:38.9783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLlB6TidNyd43O+dAL0kgKsUw3kILkoNLegGYoRYH5uR9+X1txZqZg/Pm8i5+lDybNPVfZfo3mE0aGgef0smug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4964
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/5/2020 9:11 PM, Corentin Labbe wrote:=0A=
> On Tue, Feb 04, 2020 at 02:34:19PM +0200, Iuliana Prodan wrote:=0A=
>> Added support for executing multiple requests, in parallel,=0A=
>> for crypto engine.=0A=
>> A new callback is added, can_enqueue_more, which asks the=0A=
>> driver if the hardware has free space, to enqueue a new request.=0A=
>> The new crypto_engine_alloc_init_and_set function, initialize=0A=
>> crypto-engine, sets the maximum size for crypto-engine software=0A=
>> queue (not hardcoded anymore) and the can_enqueue_more callback.=0A=
>> On crypto_pump_requests, if can_enqueue_more callback returns true,=0A=
>> a new request is send to hardware, until there is no space and the=0A=
>> callback returns false.=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> ---=0A=
>>   crypto/crypto_engine.c  | 106 ++++++++++++++++++++++++++++++----------=
--------=0A=
>>   include/crypto/engine.h |  10 +++--=0A=
>>   2 files changed, 72 insertions(+), 44 deletions(-)=0A=
>>=0A=
>> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
>> index eb029ff..aba934f 100644=0A=
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
> =0A=
> Hello=0A=
> =0A=
> Your patch has the same problem than mine reported by Horia.=0A=
> If a queue has more than one request, a first crypto_pump_requests() will=
 send a request and for drivers which do not block on do_one_request() cryp=
to_pump_requests() will end.=0A=
> Then another crypto_pump_requests() will fire sending a second request wh=
ile the driver does not support that.=0A=
=0A=
> So we need to replace engine->cur_req by another locking mechanism.=0A=
> Perhaps the cleaner is to add a "request count" (increased when do_one_re=
quest, decreased in crypto_finalize_request)=0A=
> I know that the early version have that and it was removed, but I do not =
see any better way.=0A=
> =0A=
=0A=
The "request count" I've change it to can_enqueue_more, so the hw can =0A=
"answer" if it can enqueue or not.=0A=
=0A=
I'll (re)add the cur_req in crypto-engine.=0A=
If the new callback, can_enqueue_more, is not implemented the crypto- =0A=
engine will work as before - will send requests to hardware, one-by-one, =
=0A=
on crypto_pump_requests, and complete it, on crypto_finalize_request, =0A=
and so on.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
