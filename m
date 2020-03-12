Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF74C10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98742206FA
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qGKMK4fY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgCLMwM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:52:12 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:21217
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbgCLMwM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 08:52:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKSF+t/+pjHrYFaFNc64oOWWuT9fp/BvCD5KGKr2qA7DhBA1GIx/YFlT4t9ZcphenFSqsIQT+Td1YHmyqmm2UDpGaGoGTyFbTG7gPb0IEqFSiYyO71eCZBWJC9WaxxMmOkHYF2HguDU9ywiiwynsMC0hxJz+puqLNheEwuhBVEDdOjtnVXzenoOw2PSG4kClgxPmjV3g4gV0prwLUKOwzXJLSubg34WcrxSLICrct2yhDRftfHaK0+BkWPm9Yg3M6KNbT8UHOUDrqSmDC4JV8OwtQ7ijfYR+U9OVALhZc2/m4ssDbX9xD2mWS4R+OOjiexFzJpOOibP+Hzz0V7uB8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMlkpGjjqlVkePQgdW4PoF4ZNUYh8QQdqleQCyOz1M8=;
 b=dW/57FsQzluWR1vqC0DcqZ2sad9Equk50QkA2FTmHJXaEJk1fXNbh3FZq4yp6WjLxFQK0yfEX1NBoY77p3SoxM2BE4FeW//tC8aiDnKi1fpDvoKOeV1jo3TW2zTA+27rUox19+5Pqzbx5Kz/V9qAhV/TyfBwX1yABG7AJDo18V0pH9H1xgZ+lb2jAgR/xPPvTEtPwxnxsSzLm/umtVzysFqoHHsnbnxQypzduUM5ack9b53dKpfhtoRaoxpMjyDvvHH5sf5iC4+PupA5k5OPuUktINGXsRPcVQuRuMUhPYGRrb0WA0+t8qq4ux5UM8J6yTVTnPsWHMl8gJWHpFV0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMlkpGjjqlVkePQgdW4PoF4ZNUYh8QQdqleQCyOz1M8=;
 b=qGKMK4fY2O5RggqqJbiP5FGbcMMJFLPFYsoJjivNfLMKtJ/fYOUj8i/q9GoPC9I/pwzxm949092cEy4W2jzFIW9TTwoLlmjv39dvGn9IT5FayMi04vy6DLriJy8spBdiLSBA346jdYXOcT0jQRtH0afPUx7uxeXT+KvC6HVBwSQ=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0PR04MB5747.eurprd04.prod.outlook.com (20.178.119.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Thu, 12 Mar 2020 12:52:05 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 12:52:05 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
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
Subject: Re: [PATCH v4 1/2] crypto: engine - support for parallel requests
Thread-Topic: [PATCH v4 1/2] crypto: engine - support for parallel requests
Thread-Index: AQHV9ZwplCPBsoqUKkWl+/E0XiXZQA==
Date:   Thu, 12 Mar 2020 12:52:05 +0000
Message-ID: <AM0PR04MB71718435E87539AAFFF2A9568CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
 <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2627186-502b-4929-89dc-08d7c6842ad4
x-ms-traffictypediagnostic: AM0PR04MB5747:|AM0PR04MB5747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5747DED26DB4E2555E257A4C8CFD0@AM0PR04MB5747.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(5660300002)(66556008)(81166006)(66446008)(8676002)(81156014)(2906002)(6916009)(54906003)(7696005)(53546011)(6506007)(86362001)(55016002)(478600001)(9686003)(52536014)(44832011)(71200400001)(64756008)(76116006)(91956017)(66476007)(66946007)(4326008)(26005)(316002)(8936002)(33656002)(186003)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5747;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SX30wrVV1092TGcK3/kbALdXbJqjSmeogTAO+vMWI+LLMqvaK94CcPVtJrsq9cRIVOTLoz/7buWeEgh/rAjrsyxNdb3FwfE5W+7tiPnzUwtOtq7oPzM9oluZLW+Z2BzdY6d9BJIgLazmpgpygiNrzW+uWnblfy/jrk0xnP+SJVB+jfS87qEW6zxISadFlolPu3mK8mKy6+CAwmZ39kUgk3zzuNYV0Fk89Fsf5lSQvE2k5RpJrgQq9VojhxHo5zKCZJCMGRP92R6wF2sLTCzOVFqDVcCXnzoQCjKRzQPpBe3/fSq1O3mdWWpqANc37XXh5xE5LV7ue1rzxOGZXu4nj+GC0j3+RY3JgIkYK6xsi2RWqiaej8is7UnM3juCjaeYoXIhUosIh9M/GX3M/FkMlzj6/w7nXeg4HXkRWhRJ5tRf6GsP2zP9l1fVHsl7aHxh
x-ms-exchange-antispam-messagedata: 8SNG6hdWdwqVcjbopxT9bHzFl/9VjJD1Kp9/tPplYIrHyA/pmRnK8uk2d8nRXAO3Amt4rMyt1XWCYNNC4mSVxNtEX4EnH/21iz+n/tnUs8RrNg4ysTl3ftTlA6xVW+Zc/Ke3KNLU4uyWbbtsEemJ0Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2627186-502b-4929-89dc-08d7c6842ad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 12:52:05.1773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pFtxvncvMsWds0Jd01tw4bqqrUCPmWb6Xs7dzf2KKCJVecY2JOBTXpyzb8xREMvbFjXAtxayFVvnPGf+JQLgzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5747
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/12/2020 2:45 PM, Iuliana Prodan wrote:=0A=
> On 3/12/2020 5:26 AM, Herbert Xu wrote:=0A=
>> On Mon, Mar 09, 2020 at 12:51:32AM +0200, Iuliana Prodan wrote:=0A=
>>>=0A=
>>>    	ret =3D enginectx->op.do_one_request(engine, async_req);=0A=
>>> -	if (ret) {=0A=
>>> -		dev_err(engine->dev, "Failed to do one request from queue: %d\n", re=
t);=0A=
>>> -		goto req_err;=0A=
>>> +	can_enq_more =3D ret;=0A=
>>> +	if (can_enq_more < 0) {=0A=
>>> +		dev_err(engine->dev, "Failed to do one request from queue: %d\n",=0A=
>>> +			ret);=0A=
>>> +		goto req_err_1;=0A=
>>> +	}=0A=
>>=0A=
>> So this now includes the case of the hardware queue being full=0A=
>> and the request needs to be queued until space opens up again.=0A=
>> In this case, we should not do dev_err.  So you need to be able=0A=
>> to distinguish between the hardware queue being full vs. a real=0A=
>> fatal error on the request (e.g., out-of-memory or some hardware=0A=
>> failure).=0A=
>>=0A=
> There are two aspects here:=0A=
> - if all requests go through crypto-engine, and, in this case, if there=
=0A=
> is no space in hw queue, do_one_req returns 0, and actually there will=0A=
> be no case of do_one_request() < 0;=0A=
> - if there are other requests (non crypto API) that go to hw for=0A=
> execution (in CAAM we have split key or RNG) those might occupy the hw=0A=
> queue, after crypto-engine returns that it still has space. This case=0A=
> wasn't supported before my modifications and neither with these patches.=
=0A=
> This use-case can be solved by retrying to send the request to hw -=0A=
> enqueue it back to crypto-engine, in the head of the queue (to keep the=
=0A=
> order, and send it again to hw).=0A=
> I've tried this, but it implies modifications in all drivers. For=0A=
> example, a driver, in case of error, it frees the resources of the=0A=
> request. So, will need to map again a request.=0A=
> =0A=
=0A=
I believe this recovery mechanism should be handled in other patch (series)=
.=0A=
Herbert, what is your proposal to move forward?=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
