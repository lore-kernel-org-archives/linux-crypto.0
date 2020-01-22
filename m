Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A71C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 12:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630DB2467A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 12:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Rxth38U4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAVM33 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 07:29:29 -0500
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:1790
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgAVM33 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 07:29:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceOmVHfaWdpoet6um2Bc6Rp+ManfpCnUjBn1TCVMxB59DPUsjRtZQP/jv5OOglIvLSNwStrJwKBtbiQ2cHRcZeqS5NLTr+LH8BEBCz1QNjXTUooorc6/zCpHMXWPkyThZmkkLtJ0guWXKlTHiRl7AIbpgt0UdVVmqCieyFCLtaGH/tAFGxvbHa9lQdc6ENqWgYKA1mwvNzJJusONixIS1dUgpsjFBoFwt8yWwD+DaraPxrTsn9x3DJMKnxopCVRzw9k5owDNvaqVABjzuqgynE1ZZYnnhjBg79dr6FVJOKmvHkG4l5GXeJJgQlptghUSd70+mt0pvdQfil0fpUMEeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ima0gc7kM5uSLGKNJyiFgHXs/rYus8KLTtH9RAgOl98=;
 b=X+TMTtjsZ4r7GyAhDpVb8JBLon/nZjPywE8ec/5jwH5ES4aw4M9UFZkNgTl77nX1jRFqBvkZTn4tBcw9M8oV5iYfpM6BEU1M1WL3WwVy5Bi+8waxWj7DcF9ahl4inuz7d+8x17Wj5ZKFwU0IPn2/xKYyaMsbjxZQ8TpEhB0WKVH7+aD9ci0kHrymiq2l9t0O+STC/UMODhyrUOKfx95jogEnuTFh3t4u/78AjYxazBEvHd9sw4oF35E0WFwGPrLOhLyiE6zNqpDKnQCctyPhhT7+7cSJb1UYdwolrZjKlr4Q4K0ga/8caKyZ90BA/rYG4mY2xGE63Zg+lieffvIErw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ima0gc7kM5uSLGKNJyiFgHXs/rYus8KLTtH9RAgOl98=;
 b=Rxth38U4bFNJ1pjODsAfU1GPfA/8MgVi56USOtKdOqevRyu2ATvYHYDiBzLlNTrJJyfEYXljkUx+IRoAT0agOnTFSnAvCO2JJkWBqEHlHbW3lnwejDhOSvE+lxkwk9mEl7ZngO1/NcnHW7DSD1F6VPp/oLzpQ/wZpJ4HxCoRCZM=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4829.eurprd04.prod.outlook.com (20.177.51.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Wed, 22 Jan 2020 12:29:22 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::304d:b7d8:1233:2ae0%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 12:29:22 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
Date:   Wed, 22 Jan 2020 12:29:22 +0000
Message-ID: <VI1PR04MB44455343230CBA7400D21C998C0C0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
 <20200121100053.GA14095@Red>
 <VI1PR04MB44454A0468073981FDA603B38C0D0@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20200122104134.GA13173@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: de00cc46-5d81-463b-7384-08d79f36b601
x-ms-traffictypediagnostic: VI1PR04MB4829:|VI1PR04MB4829:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4829A180CBF3C01FF683B5E48C0C0@VI1PR04MB4829.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(199004)(189003)(2906002)(7416002)(86362001)(8936002)(81166006)(81156014)(33656002)(8676002)(7696005)(6506007)(110136005)(44832011)(186003)(54906003)(316002)(71200400001)(26005)(55016002)(52536014)(478600001)(66556008)(64756008)(53546011)(4326008)(91956017)(76116006)(9686003)(5660300002)(66946007)(66446008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4829;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KtaiAuQ40qRNu7iKByIFhjg+8//mig0adsdjTZWh2iQzVvo6yzR0kqME/SrJ0q0kIVAXz5NUS7KPFr70MUt4mwuYG4kH7ADtrfnzZkJUU/yBTWy3Zhi6OyfohcjQeC2KgW2E68RFyxvCI43kf4SZ/mhBS+a8EXCieKxh5blor1OomUmwfKRv+/jB/uq6I15BS96YPOJgiofhS/jKD/ni0KJY9EAfZdnLiEVeJmGXfnUzfQ43vvnjo4kqN37K0jLrIY1hPsJ4nSvf0RQcNNJuoYXXbp+o+oOgghFZZsDe5HtzRNFI2RWLelY7RwRE4EfNf7MFIgj9B6BfFKBFYE46epFV+rmB5iwX8QRWUusC/wKJeuu0JMqw9OJdHLq/OhWNkWtxJ5JahZwnPtdmFQJZjWNdUATqcesugTaDWt7fTZWlNbwr5gWgCoITaQGInjrb
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de00cc46-5d81-463b-7384-08d79f36b601
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 12:29:22.5865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TthnQpUSexdizyn6g0zDVs5cUD7Y2QOHi935Df+e0Nqu/sLj6r8RBUN5kZoDcy/bJBZvizH/xKjcOI1UUkbTRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4829
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/22/2020 12:41 PM, Corentin Labbe wrote:=0A=
> On Tue, Jan 21, 2020 at 02:20:27PM +0000, Iuliana Prodan wrote:=0A=
>> On 1/21/2020 12:00 PM, Corentin Labbe wrote:=0A=
>>> On Tue, Jan 21, 2020 at 01:32:29AM +0200, Iuliana Prodan wrote:=0A=
>>>> Added support for executing multiple requests, in parallel,=0A=
>>>> for crypto engine.=0A=
>>>> A no_reqs is initialized and set in the new=0A=
>>>> crypto_engine_alloc_init_and_set function.=0A=
>>>> =0A=
>>>>=0A=
>>>=0A=
>>> Hello=0A=
>>>=0A=
>>> In your model, who is running finalize_request() ?=0A=
>> finalize_request() in CAAM, and in other drivers, is called on the _done=
=0A=
>> callback (stm32, virtio and omap).=0A=
>>=0A=
>>> In caam it seems that you have a taskqueue dedicated for that but you c=
annot assume that all drivers will have this.=0A=
>>> I think the crypto_engine should be sufficient by itself and does not n=
eed external thread/taskqueue.=0A=
>>>=0A=
>>> But in your case, it seems that you dont have the choice, since do_one_=
request does not "do" but simply enqueue the request in the "jobring".=0A=
>>>=0A=
>> But, do_one_request it shouldn't, necessary,  execute the request. Is ok=
=0A=
>> to enqueue it, since we have asynchronous requests. do_one_request is=0A=
>> not blocking.=0A=
>>=0A=
>>> What about adding along prepare/do_one_request/unprepare a new enqueue(=
)/can_do_more() function ?=0A=
>>>=0A=
>>> The stream will be:=0A=
>>> retry:=0A=
>>> optionnal prepare=0A=
>>> optionnal enqueue=0A=
>>> optionnal can_do_more() (goto retry)=0A=
>>> optionnal do_one_request=0A=
>>>=0A=
>>> then=0A=
>>> finalize()=0A=
>>> optionnal unprepare=0A=
>>>=0A=
>>=0A=
>> I'm planning to improve crypto-engine incrementally, so I'm taking one=
=0A=
>> step at a time :)=0A=
>> But I'm not sure if adding an enqueue operation is a good idea, since,=
=0A=
>> my understanding, is that do_one_request is a non-blocking operation and=
=0A=
>> it shouldn't execute the request.=0A=
> =0A=
> do_one_request is a blocking operation on amlogic/sun8i-ce/sun8i-ss and t=
he "documentation" is clear "@do_one_request: do encryption for current req=
uest".=0A=
> But I agree that is a bit small for a documentation.=0A=
> =0A=
=0A=
Herbert, Baolin,=0A=
=0A=
What do you think about do_one_requet operation: is blocking or not?=0A=
=0A=
There are several drivers (stm32, omap, virtio, caam) that include =0A=
crypto-engine, and uses do_one_request as non-blocking, only the ones =0A=
mentioned and implemented by Corentin use do_one_request as blocking.=0A=
=0A=
>>=0A=
>> IMO, the crypto-engine flow should be kept simple:=0A=
>> 1. a request comes to hw -> this is doing transfer_request_to_engine;=0A=
>> 2. CE enqueue the requests=0A=
>> 3. on pump_requests:=0A=
>> 	3. a) optional prepare operation=0A=
>> 	3. b) sends the reqs to hw, by do_one_request operation. To wait for=0A=
>> completion here it contradicts the asynchronous crypto API.=0A=
> =0A=
> There are no contradiction, the call is asynchronous for the user of the =
API.=0A=
> =0A=
>> do_one_request operation has a crypto_async_request type as argument.=0A=
>> Note: Step 3. b) can be done several times, depending on size of hw queu=
e.=0A=
>> 4. in driver, when req is done:=0A=
>> 	4. a) optional unprepare operation=0A=
>> 	4. b) crypto_finalize_request is called=0A=
>> 	=0A=
> =0A=
> Since Herbert say the same thing than me:=0A=
> "Instead, we should just let the driver tell us when it is ready to accep=
t more requests."=0A=
> Let me insist on my proposal, I have updated my serie, and it should hand=
le your case and mine.=0A=
> I will send it within minutes.=0A=
> =0A=
=0A=
Corentin,=0A=
=0A=
In your new proposal, a few patches include my modifications. The others =
=0A=
include a solution that fits your drivers very well, but implies =0A=
modifications in all the other 4 drivers. It's not backwards compatible.=0A=
I believe it can be done better, so we won't need to modify, _at all_, =0A=
the other drivers.=0A=
=0A=
I'm working on a new version for my RFC, that has the can_enqueue_more, =0A=
as Herbert suggested, but I would really want to know how =0A=
crypto-engine's do_one_request was thought: blocking or non-blocking?=0A=
=0A=
Just your driver(s) use it as blocking, the other examples use it to =0A=
enqueue (don't block in waiting for request to finish).=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
