Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCB8C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F6FE2071C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UWkDviAG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfKVOLv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:11:51 -0500
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:59456
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfKVOLu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 09:11:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4j6wwWyZif+jJwf3LV9WuPo4SdWiU3hO1Px301/jflGmHrZaP+mdDD99JUG7b5vP5rHc8Zgv0ZWiFGKB9vLD+yMgQMDUOfpXeuAi3VOexg8QlbXu29H0sHgzDfpoHerlI03qdFuSiMeMVEkbOSkc0R/02kW2opPRVHttaSXxR+TkEnhsScFMc5LjGR+TJy9g2bi5h/f4e0DEIV7v4e3Hb5fkAaqV1JEfnscCl6NZ1esjtkVMZeu9CfUV39ZvnonXFY7f7cUBSQbHU0UnvLlVctLEno63hEdrevBfDi0yk7slZus/MT+2u+g3enjwIGO5v+96tyAuTw88OvMdVFzDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y7h6uf2vxdR9HjkrV5la1P1XUsx6+6oF9EtJjEMoA4=;
 b=VF1yWP5Fi8lUBtgFjuy2Xf3dfmQpKTqUoS6hHQ5PRAj9Y0GfloH2DvVnTiPIWMVITzlVF2IP6+QL34OPuoWb5DVVtcBENvb7IvKS3MCdjCjf9IdKDSx8m19YVes9u83G0O6XiKk27clak6sHDRn+A3EOGtkThah8yl7Zs2OUvCit5QrP/CsCW3hm/cBukjwOk7s04U/FFraYLSydZy2UzgzEBnj1NGxq8QaR9V2g4+op5RDjp0IgqT/E5Wzhe2JlNrQ6KO+zo0zEkLjoH6hUke+xGDEilJByQn6dQHQWS5sqf+iF/dWD3Hek1mBvOaBKKnCpkowVtzeTlcqJ8HTw5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y7h6uf2vxdR9HjkrV5la1P1XUsx6+6oF9EtJjEMoA4=;
 b=UWkDviAGXaj96vuBucETbbogtxCWWcJCNnkaXJs2GSbRQ83OCrfSuhBk5QsOU8qRropoKfkWYyxQesAtDLqUNiy4ZiBQPARqfQDzkkmsMT5G1BU+wsdzS7BK1YO/rcEkt8B5A8ww+SM9jQ6WF53UbfAgA7MAwStGNVsjT0Ut+JE=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB3997.eurprd04.prod.outlook.com (52.134.123.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 14:11:46 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d%5]) with mapi id 15.20.2451.032; Fri, 22 Nov 2019
 14:11:46 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Topic: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Index: AQHVnZa0/lOdW2TUXUqvGjTaL30gkA==
Date:   Fri, 22 Nov 2019 14:11:46 +0000
Message-ID: <VI1PR04MB444537DA6774BE5E31F2C04F8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
 <20191122103309.wf2hg7km45ugzzhr@gondor.apana.org.au>
 <VI1PR04MB4445DACDF6F1AF1CDABC6E7A8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20191122110915.f7rsqb4hnsg4pfci@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 06d9a70f-4ac0-4765-2f80-08d76f55e8c3
x-ms-traffictypediagnostic: VI1PR04MB3997:|VI1PR04MB3997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB39972E2AD23E5F9DEB30BD8B8C490@VI1PR04MB3997.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(74316002)(6916009)(76116006)(6436002)(55016002)(6246003)(2906002)(33656002)(81156014)(8676002)(81166006)(25786009)(102836004)(71200400001)(7696005)(76176011)(8936002)(99286004)(53546011)(6506007)(91956017)(71190400001)(52536014)(54906003)(6116002)(446003)(44832011)(66476007)(64756008)(7736002)(4326008)(66556008)(186003)(316002)(305945005)(5660300002)(229853002)(66446008)(478600001)(86362001)(14454004)(14444005)(256004)(66066001)(66946007)(9686003)(3846002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3997;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SSFwAB4vMqwd13I8JRvqUSpKdO6Rx5VqK2db7x5R0ogtHQqN5T/maz44dIUR8lBuZFZrLjerQga2An0Ma8rlqABClNOsIMyhg5+iFF3UUYPKKQ1VYbW7knaEYyJcwckOxCzDdPes2X4Hd2dLuefr9gU80qFi7QkgckWzo/TfLYSHV5bDEaJ95xl6/36xvo0HrSp57KG/dpmE0sb3ULukYI6Mblt7Llbs1+huud8jZ8e8rKg+HZ0dE+t8ChTz7VOdYYjMaeIuYQYq7zxsqmx74h34wLoJdivTGWo1/ymp3d/qiFg4RlIKND2KUhaol5ZEtCeSfrYDIYjDxTXIr83isIUHOHMSOvawVb7RnmmgDwZacK2maEe7FV/tALXGIy0T5Z98BvcXOG+HU4w8+dPMT054mZ9xCf+CvP0WZ/4HgmO2DXKOi2Blj4LAwQ+dih7F
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d9a70f-4ac0-4765-2f80-08d76f55e8c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 14:11:46.2955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 680cLoUnK6L6bZu17OGy5+ur1e3F4cYRYPQFwWfRureRZV6uqW9ZzNpD6ULpn0BDsYoh+Hl2PjqSAXmFBDa4Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3997
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/2019 1:09 PM, Herbert Xu wrote:=0A=
> On Fri, Nov 22, 2019 at 11:05:59AM +0000, Iuliana Prodan wrote:=0A=
>>=0A=
>> Sorry, but I don't understand what is wrong here? I'm using the correct=
=0A=
>> type, the specific type, for the request when sending it to crypto engin=
e.=0A=
>> This transfer_request_to_engine function is called from caam_jr_enqueue,=
=0A=
>> where I have all types of request, so I'm using the async_request, and=
=0A=
>> when transferring to crypto engine I cast it to the specific type.=0A=
> =0A=
> These internal types are only for use by the crypto API and helper=0A=
> code such as crypto_engine.  They should not be used by drivers in=0A=
> general.=0A=
> =0A=
So, just to be clear, I shouldn't use crypto_async_request in driver code?=
=0A=
I see that this generic crypto request is used in multiple drivers.=0A=
=0A=
>> I believe is an overhead to sent all request to crypto engine since most=
=0A=
>> of them can be directly executed by hw.=0A=
>> Also, in case there is no need for backlog and the hw is busy we can=0A=
>> drop the request.=0A=
> =0A=
> If the crypto_engine has so much overhead then you should work on=0A=
> fixing crypto_engine and not work around it like this.=0A=
> =0A=
I can try sending _all_ requests to crypto engine and make some =0A=
performance measurements to see which solution is best.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
