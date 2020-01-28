Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E2CC33CB2
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422502467E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:00:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="SMyFYM5Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgA1LAM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 06:00:12 -0500
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:55716
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbgA1LAL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 06:00:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NV1BfXhUY5qXAOECyy1aMzgM8uzusdiZruNgC6qXBmR9Buee+zdu6tPFwHDB86e/X8spzA1joUMVImO8u2GeeCJD9B96xtHhFbMvyy708LaEZR/XmtRdekNO90DZVnYFKAqrHrLxsQYXLhs0ukGfZD8qFEsTCE9vBdGGrAbtGthlNp09dkloH0KdrtnVh1yQ7Yy+hwwjWSr/U1e6ajSgzmG5FVCOdPnqBQhbQeiJOIGVEO2XyKCCuj/JI6p8+cy7yDV7Du6wOBcAkGAhdodYKFv55529uimzTzMW9/CmJuRRU1LPh+wQCwCq8fv6gWasJWR73rpAf854hSpsFBUxMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzdyJW0xXobfS5QQp4kfdQ9JMLi54rhduByjgo25ZY8=;
 b=ocg1keLpQakzqv8sG4HZ3gLVJr9l+uH46X9zuFg6iMaG4DYdRYtery2T1juqxKPCMndU3P1wIquzQhdziYO2x5942QNCL23yOYZWdQ6m2RodGNAPIGG7bgJJQNk85fpKBORbzdDlGwgB8BdYbakJQbVs2GyCbRMjP6tW09uCOvvpGGEajRtSmomjosTD6ByKDDX7mnCNv5PhZzcuNdeqcU1erc5ijcNyus/WrlrmU1MXZ1Jt9zVpBzmjIZM5l/hQJCCmu/BROk+vkN3GQBsxzUvBg8AHm4ZFXdy2sgrODJ3M+UYVS0x2e1ihlDq9FCAX1uW69qiQV9kq5cZwFK2QBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzdyJW0xXobfS5QQp4kfdQ9JMLi54rhduByjgo25ZY8=;
 b=SMyFYM5Y3z0C7Br1V/rQX0IsI3TWfzWN0DSMv+Z83MkPiO7SSUXJLS7olEt2AYXTWCIo58qm5gJ1p7C6p0CWOLvDqT5SaOKeNKUVqC8A5xs62MX65AHynI94Qrc3WrAjuYxyw4gERTj1jWCyhQ86i4WciSl3hdM7AKBMgyAUc5k=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0PR04MB5268.eurprd04.prod.outlook.com (20.176.214.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.24; Tue, 28 Jan 2020 11:00:02 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::59a8:ca29:d637:3c84]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::59a8:ca29:d637:3c84%5]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 11:00:02 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>
Subject: Re: [PATCH 5/9] crypto: engine: add enqueue_request/can_do_more
Thread-Topic: [PATCH 5/9] crypto: engine: add enqueue_request/can_do_more
Thread-Index: AQHV0REbcTp6Ox1gSU+lAn+fB1GkDg==
Date:   Tue, 28 Jan 2020 11:00:02 +0000
Message-ID: <AM0PR04MB71714D3EA035F07DEF13BBB58C0A0@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
 <20200122104528.30084-6-clabbe.montjoie@gmail.com>
 <AM0PR04MB717155300E3575C07D31E1D08C0B0@AM0PR04MB7171.eurprd04.prod.outlook.com>
 <20200128084041.GA10493@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 398e4c58-ec97-484d-e302-08d7a3e13975
x-ms-traffictypediagnostic: AM0PR04MB5268:|AM0PR04MB5268:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5268DB565D011F313AEC9C458C0A0@AM0PR04MB5268.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(189003)(199004)(8936002)(81166006)(6506007)(2906002)(81156014)(9686003)(8676002)(44832011)(53546011)(33656002)(55016002)(64756008)(66556008)(66476007)(66946007)(66446008)(76116006)(26005)(4326008)(316002)(186003)(6916009)(478600001)(966005)(45080400002)(54906003)(7696005)(86362001)(71200400001)(5660300002)(52536014)(354624002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5268;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IW95WuHMYKEk6SLhACdgVfxRQCrQDdarlNcJGP/UBT1/mWaV/6UdoqiIo5osTbUfjF7qu/p32YSc3iD/ucSxvoNBnMJY9u2UJt5beK0vwv7vgps9mGSHOS1J0sCxSPxlnJvvdlHYWX/T6KO34OCgZMPJCRSPBkwQTg8SJEXx9U9FHFXUXPdFxn4B3hvtbySppElPUVrtGPjw3Q4MlnkmSJONuAiNXDUvb5mRY8DJIBRmm7jVHcZ4XahSsbsPlTybRIhzswQkwqzRnv54UsgEJCrFrtfHG+P31tB9vXI2oOb7lWITIrLX3kfRiigjfJ8EFi+C6yu7i1G4qfpBUWlI7feo+cPHb2bIaDHMBmucJmc0+j91/bfSDvR/gzWo8xxpzRkPFqBJy2rnluZgrY4ex/TZYqhDLBUxoO+z8+71WHXcbPwpIVavqa6brtmZIR3duRoR5IVS901DnBk1Ic4EXHTZXf5X6pQrTgYjqpClx3pxmZrP/8r/MQON2RMCkwVs/BK/ikYN/0sSccKVhEaYllR6xe90hkmn5ycqDOgTvfH9E5bChMcx8J5Q7Fd+w2nP
x-ms-exchange-antispam-messagedata: vMAknu8azTj4soNUWuchX2Esyg2eHHG6UAZOzOqcWEIEi7g5YPvNsYIPFgeK79kgqBQaVnIE5xgnycluFsgOpXumDRdfumOWddryhQ7hv0h2eJjJnpK6jF2jdOkmw3h7vN0rYwi064rnZvDTkuHpKA==
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398e4c58-ec97-484d-e302-08d7a3e13975
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 11:00:02.2653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBACNJIt6651ZrfC7gkyZG7Hhx12ccT4G5wzaF4FsaP1oq7jbvHt/nUZOjIrLuHwjC5WnHuEuDzbzI8OaK/mLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5268
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/28/2020 10:40 AM, Corentin Labbe wrote:=0A=
> On Mon, Jan 27, 2020 at 10:58:36PM +0000, Iuliana Prodan wrote:=0A=
>> On 1/22/2020 12:45 PM, Corentin Labbe wrote:=0A=
>>> This patchs adds two new function wrapper in crypto_engine.=0A=
>>> - enqueue_request() for drivers enqueuing request to hardware.=0A=
>>> - can_queue_more() for letting drivers to tell if they can=0A=
>>> enqueue/prepare more.=0A=
>>>=0A=
>>> Since some drivers (like caam) only enqueue request without "doing"=0A=
>>> them, do_one_request() is now optional.=0A=
>>>=0A=
>>> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>=0A=
>>> ---=0A=
>>>    crypto/crypto_engine.c  | 25 ++++++++++++++++++++++---=0A=
>>>    include/crypto/engine.h | 14 ++++++++------=0A=
>>>    2 files changed, 30 insertions(+), 9 deletions(-)=0A=
>>>=0A=
>>> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c=0A=
>>> index 5bcb1e740fd9..4a28548c49aa 100644=0A=
>>> --- a/crypto/crypto_engine.c=0A=
>>> +++ b/crypto/crypto_engine.c=0A=
>>> @@ -83,6 +83,7 @@ static void crypto_pump_requests(struct crypto_engine=
 *engine,=0A=
>>>    		goto out;=0A=
>>>    	}=0A=
>>>    =0A=
>>> +retry:=0A=
>>>    	/* Get the fist request from the engine queue to handle */=0A=
>>>    	backlog =3D crypto_get_backlog(&engine->queue);=0A=
>>>    	async_req =3D crypto_dequeue_request(&engine->queue);=0A=
>>> @@ -118,10 +119,28 @@ static void crypto_pump_requests(struct crypto_en=
gine *engine,=0A=
>>>    			goto req_err2;=0A=
>>>    		}=0A=
>>>    	}=0A=
>>> +=0A=
>>> +	if (enginectx->op.enqueue_request) {=0A=
>>> +		ret =3D enginectx->op.enqueue_request(engine, async_req);=0A=
>>> +		if (ret) {=0A=
>>> +			dev_err(engine->dev, "failed to enqueue request: %d\n",=0A=
>>> +				ret);=0A=
>>> +			goto req_err;=0A=
>>> +		}=0A=
>>> +	}=0A=
>>> +	if (enginectx->op.can_queue_more && engine->queue.qlen > 0) {=0A=
>>> +		ret =3D enginectx->op.can_queue_more(engine, async_req);=0A=
>>> +		if (ret > 0) {=0A=
>>> +			spin_lock_irqsave(&engine->queue_lock, flags);=0A=
>>> +			goto retry;=0A=
>>> +		}=0A=
>>> +		if (ret < 0) {=0A=
>>> +			dev_err(engine->dev, "failed to call can_queue_more\n");=0A=
>>> +			/* TODO */=0A=
>>> +		}=0A=
>>> +	}=0A=
>>>    	if (!enginectx->op.do_one_request) {=0A=
>>> -		dev_err(engine->dev, "failed to do request\n");=0A=
>>> -		ret =3D -EINVAL;=0A=
>>> -		goto req_err;=0A=
>>> +		return;=0A=
>>>    	}=0A=
>>>    	ret =3D enginectx->op.do_one_request(engine, async_req);=0A=
>>>    	if (ret) {=0A=
>>> diff --git a/include/crypto/engine.h b/include/crypto/engine.h=0A=
>>> index 03d9f9ec1cea..8ab9d26e30fe 100644=0A=
>>> --- a/include/crypto/engine.h=0A=
>>> +++ b/include/crypto/engine.h=0A=
>>> @@ -63,14 +63,16 @@ struct crypto_engine {=0A=
>>>     * @prepare__request: do some prepare if need before handle the curr=
ent request=0A=
>>>     * @unprepare_request: undo any work done by prepare_request()=0A=
>>>     * @do_one_request: do encryption for current request=0A=
>>> + * @enqueue_request:	Enqueue the request in the hardware=0A=
>>> + * @can_queue_more:	if this function return > 0, it will tell the cryp=
to=0A=
>>> + * 	engine that more space are availlable for prepare/enqueue request=
=0A=
>>>     */=0A=
>>>    struct crypto_engine_op {=0A=
>>> -	int (*prepare_request)(struct crypto_engine *engine,=0A=
>>> -			       void *areq);=0A=
>>> -	int (*unprepare_request)(struct crypto_engine *engine,=0A=
>>> -				 void *areq);=0A=
>>> -	int (*do_one_request)(struct crypto_engine *engine,=0A=
>>> -			      void *areq);=0A=
>>> +	int (*prepare_request)(struct crypto_engine *engine, void *areq);=0A=
>>> +	int (*unprepare_request)(struct crypto_engine *engine, void *areq);=
=0A=
>>> +	int (*do_one_request)(struct crypto_engine *engine, void *areq);=0A=
>>> +	int (*enqueue_request)(struct crypto_engine *engine, void *areq);=0A=
>>> +	int (*can_queue_more)(struct crypto_engine *engine, void *areq);=0A=
>>>    };=0A=
>>=0A=
>> As I mentioned in another thread [1], these crypto-engine patches (#1 -=
=0A=
>> #5) imply modifications in all the drivers that use crypto-engine.=0A=
>> It's not backwards compatible.=0A=
> =0A=
> This is wrong. This is false.=0A=
> AS I HAVE ALREADY SAID, I have tested and didnt see any behavour change i=
n the current user of crypto engine.=0A=
> I have tested my serie with omap, virtio, amlogic, sun8i-ss, sun8i-ce and=
 didnt see any change in behavour WITHOUT CHANGING them.=0A=
> I resaid, I didnt touch omap, virtio, etc...=0A=
> Only stm32 is not tested because simply there are not board with this dri=
ver enabled.=0A=
> =0A=
=0A=
I'm not saying that doesn't compile or anything, is just that you change =
=0A=
the API and those drivers will not comply on this new API.=0A=
I believe that "it works" is not sufficient, should work properly!=0A=
=0A=
> I have also tested your serie which adds support for crypto engine to caa=
m, and the crash is the same with/without my serie.=0A=
> So no behavour change.=0A=
> =0A=
Thanks for testing this. I'll look into it!=0A=
=0A=
>> Your changes imply that do_one_request executes the request & waits for=
=0A=
>> completion and enqueue_request sends it to hardware. That means that all=
=0A=
>> the other drivers need to be modify, to implement enqueue_request,=0A=
>> instead of do_one_request. They need to be compliant with the new=0A=
>> changes, new API. Otherwise, they are not using crypto-engine right,=0A=
>> don't you think?=0A=
>>=0A=
> =0A=
> My change imply nothing, current user work the same.=0A=
> But if they want, they COULD switch to enqueue_request().=0A=
> =0A=
>> Also, do_one_request it shouldn=92t be blocking. We got this confirmatio=
n=0A=
>> from Herbert [2].=0A=
> =0A=
> Re-read what Herbert said, "It certainly shouldn't be blocking in the gen=
eral case." But that means it could.=0A=
> But this wont change my patch since both behavour are supported.=0A=
> =0A=
=0A=
Since your driver is the one being different (implements do_one_request =0A=
as blocking), it's not fair to change the other drivers just for you =0A=
special case when we update the crypto-engine. It should be the other =0A=
way around.=0A=
Add a special case for you and let the other drivers unchanged.=0A=
The updated crypto-engine API should be consistent (same semantics) with =
=0A=
the old one. Your proposal doesn't extend the current API, but =0A=
reshuffles the callbacks changing their meaning.=0A=
We should agree on how we should update crypto-engine to accommodate all =
=0A=
the scenarios, but maintaining backwards compatibility.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
>>=0A=
>> [1]=0A=
>> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore=
.kernel.org%2Flkml%2FVI1PR04MB44455343230CBA7400D21C998C0C0%40VI1PR04MB4445=
.eurprd04.prod.outlook.com%2F&amp;data=3D02%7C01%7Ciuliana.prodan%40nxp.com=
%7C238e3e9a8e5f4d934cf308d7a3cdc3da%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%=
7C0%7C637157976462463995&amp;sdata=3DrgzYhX0g9hrzlYcHs7aUWVNFYs6mj86gDu7YIo=
wy0Nk%3D&amp;reserved=3D0=0A=
>> [2]=0A=
>> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore=
.kernel.org%2Flkml%2F20200122144134.axqpwx65j7xysyy3%40gondor.apana.org.au%=
2F&amp;data=3D02%7C01%7Ciuliana.prodan%40nxp.com%7C238e3e9a8e5f4d934cf308d7=
a3cdc3da%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637157976462463995&am=
p;sdata=3DJdp0Q8xPnn5uXtcv6hrk3sFbeC5PgzfwRys2itmL09w%3D&amp;reserved=3D0=
=0A=
> =0A=
=0A=
