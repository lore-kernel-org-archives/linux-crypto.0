Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6160AC10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A47E2067C
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="M6zJx4KU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCLMp6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:45:58 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:52177
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbgCLMp6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 08:45:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klU3tbMN1GLiZyvYOcnbtONGd0SrRFbmJoktmKDEJ7GB/w+mNy/B0goJRK5TOlJZhPpMaFAk+3QgufYSRiVXyHMQhSwxV3jEyBbXk2IVfyP5UNOd+PIriwCiRMiF6YEadytWwedXd8DWNc0fSw40dpx6MSjp2hMxfw8UZny0U26+hNQ+V0egEqL+Y3z+0nSfDkAsN/o0eugAvxO++PMLBDzRcIGsrEC3msoOJuOcReKOofwQd+OnQXddO0NLpaOYjR4rnbEA+srkPjtIy4a47TjQd3SvR445kg7G9sm/LwJqm9UYjlwI+zr0kZ8OoQbk61dfkfBza0qU10zBGVTQyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A30ulyu7NtFUU29LHRq42wVumsK2ZdF5SeUApZItKio=;
 b=ItoYD0sz8z1lXmTAuIS4tBh9ovPpGK6eaBFgGf9fFfhM51tp+NmFVEZ4xax4CqRPZTiUhaq/twYZYUCS9O5oLkrJ91aE2UHHS88uCavXcpEJLMpILAP6Zvxn5MKvaPyqkMVmed2TycrJUCfL+HyG/mpBbs3SBk/QcLsY6IdrJcOVoJF8PXrE2GJbJo2i8897spgLCQzeb5NgBZgVVUM0uHnVsSaP8nZt5SzvYSX5huBxRwgjFBAodnlBh5ol5ghBz3pF2gh0V5cwCSVmBCQf4J1MsM4w4blS7DQzR0Ybqt/hOIrouswq3KHODotrUudK3dsDAmpm+vvxQ/c2dFlH3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A30ulyu7NtFUU29LHRq42wVumsK2ZdF5SeUApZItKio=;
 b=M6zJx4KUsAm/ZkbZCScQydCJ7YkmmPxg96ij1WHbDynuqgLGId8bSkVhGddr3ko3DgRcvcTktL/GobNmDaT7CedFAU/NHGclVunLdArdpIxbKBGRoJvqkkC9MQnvLrUl6GbMpLgAdGbR97NA3SxyMIafF7ObqvrrG3xDPW6zMKw=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0SPR01MB0029.eurprd04.prod.outlook.com (52.135.152.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Thu, 12 Mar 2020 12:45:54 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 12:45:54 +0000
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
Date:   Thu, 12 Mar 2020 12:45:54 +0000
Message-ID: <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 422ced39-bc2f-4803-8d67-08d7c6834db9
x-ms-traffictypediagnostic: AM0SPR01MB0029:|AM0SPR01MB0029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0SPR01MB0029CEC1E1DAF6C55AF1A0BA8CFD0@AM0SPR01MB0029.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(199004)(8936002)(54906003)(316002)(66446008)(66476007)(66556008)(64756008)(53546011)(6506007)(55016002)(66946007)(33656002)(91956017)(5660300002)(76116006)(9686003)(478600001)(7696005)(52536014)(7416002)(2906002)(4326008)(44832011)(71200400001)(26005)(86362001)(81156014)(186003)(6916009)(8676002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0SPR01MB0029;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2IBs+5v95DN5zti7bxgFSuOf9s93env1qAyK22qc6Y3B6CB7UoxzAKBbSXCSaz2zXlaRUR4gwEiSmKdG51KsB2x3nE5BK/BIQslWCmY3Xizw0FnQrgJSZGReZ5aOFTWTAm+a3exFSFQbHfoNxHOTA7neEXNDEkBavTB581x6gv3Hmn8hCHatVMK3BrvP5xEeIw1wQx4t9sGAZwq1ZpWZcTijEQeOmvNsv/ZSYzMbVTYak1JLi0oWYF/MNvtrPDCxdtWn5ApjipM4DvqwG86fsLwL9vOeyCof1bRHJHlShwNFW+lBX6irtGfocKMinchlpER1zhvMd5zRHkj0JUDSYkNDLZXcdoVGb1uKiI/Gtx/oX7MkNR0Isvte5E+02R0MxDEpkyL3mmlW6v0UjaV4JeTazdnyJAKa3P+52Kck/zKKHlO9omPqjo75HQaGqGi1
x-ms-exchange-antispam-messagedata: wVAFwbNKgciIT9K1nVM0CzxArLabsjBCtCLd+vmxX58eubVJjay2R0zcwqHjOkvYHEJ49hfywTxiSasRIOr7uXuN8+xqKz7WA59r8LjiUvKQN7BxHurlf8m/1LVLJAhUiDDL7alJjPtujOfIjllNcg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422ced39-bc2f-4803-8d67-08d7c6834db9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 12:45:54.2310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gnVlq4kgr7Ds9AywrobZIWtk+nz1KNsjpwFIE/3Q94Dbp3wWDt0bVfOSEhodOiVw4Rz/JPQv4GXWQFjqXtH1cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0SPR01MB0029
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/12/2020 5:26 AM, Herbert Xu wrote:=0A=
> On Mon, Mar 09, 2020 at 12:51:32AM +0200, Iuliana Prodan wrote:=0A=
>>=0A=
>>   	ret =3D enginectx->op.do_one_request(engine, async_req);=0A=
>> -	if (ret) {=0A=
>> -		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret=
);=0A=
>> -		goto req_err;=0A=
>> +	can_enq_more =3D ret;=0A=
>> +	if (can_enq_more < 0) {=0A=
>> +		dev_err(engine->dev, "Failed to do one request from queue: %d\n",=0A=
>> +			ret);=0A=
>> +		goto req_err_1;=0A=
>> +	}=0A=
> =0A=
> So this now includes the case of the hardware queue being full=0A=
> and the request needs to be queued until space opens up again.=0A=
> In this case, we should not do dev_err.  So you need to be able=0A=
> to distinguish between the hardware queue being full vs. a real=0A=
> fatal error on the request (e.g., out-of-memory or some hardware=0A=
> failure).=0A=
> =0A=
There are two aspects here:=0A=
- if all requests go through crypto-engine, and, in this case, if there =0A=
is no space in hw queue, do_one_req returns 0, and actually there will =0A=
be no case of do_one_request() < 0;=0A=
- if there are other requests (non crypto API) that go to hw for =0A=
execution (in CAAM we have split key or RNG) those might occupy the hw =0A=
queue, after crypto-engine returns that it still has space. This case =0A=
wasn't supported before my modifications and neither with these patches.=0A=
This use-case can be solved by retrying to send the request to hw - =0A=
enqueue it back to crypto-engine, in the head of the queue (to keep the =0A=
order, and send it again to hw).=0A=
I've tried this, but it implies modifications in all drivers. For =0A=
example, a driver, in case of error, it frees the resources of the =0A=
request. So, will need to map again a request.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
=0A=
