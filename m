Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34370C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 16:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A914206CB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 16:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DJ+iLiPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfKUQx6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:53:58 -0500
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:29150
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfKUQx6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 11:53:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnP1OV1uLqNw+wrsPEf5ilikHiRyZ9b4FiczAwGC0rtdSdx3qGwdfzTspJ8AsdqpxLEAYfmspWExANxESA0unp4+5LDZ119+Xzd/dJzXjdKsbLAuoi2aR0ldN9lDbQCsbk2QH5WA/My4lOX6A2EZA3rNKVW5bvHKoEVytGRdYf42dqGnKHwI4YKi4Gm+GLigkD+tmLYo7XK6WSrAMhchp1Hn3sTD7nDXtihhWTMB0PYqrI87fpQBvNG7kyxT/3lQCvMUWQQ5wfl7WQJvtWhfgfcCl1ZIfCVF4Ruxet6hIq3Vr17NU1TM4nXA3iZCRk7qVcAH3g3X8QR5Ha9vyiswRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bodTCa8XnK0sTflBlrDF56OuAk9gGmZbGnR4AXhac2k=;
 b=SC/N81YrHK3UoqTeTpDNeBqYvE3JUv0PuLaE12CxoPnSgJsTL1dvdKJkztQJmm+icJmmMNlYz8IcPS9lUbLujb7AnSWjDRyOp5+13eZqDHaok5Q+01QeK+5C7bLE+/BHNBdALt/5t18fzRrAI6yDJ9lmKFxkaRYeixvAG9vSJdIO0Va8VNUklWhvGKqw1gEDRvJaC6d+3gmdfofce2M9UKs090pMlj2lDBhLvDN8cht9QQ6ASWGgRMFtq+y4nUHLH55/bP0eneNPskETK2RwhOvpcEVYD3RIy2vfQS3YYlRRHUkj1yw/B56FnUaYEvHpwXpstth7/cVFk0AQpbo8Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bodTCa8XnK0sTflBlrDF56OuAk9gGmZbGnR4AXhac2k=;
 b=DJ+iLiPs9OELMDYYw4nyhMTPtMJyGAgpU8swVQxYVKhKGcdYGkAAX+MdngTbmbvNBQA4oEAVZyWhKOWBbNq22vCboon5k0tno1SIVGuXRUdg9C5pCB0UA8B88fa3P7Ma+Rfw+8ufB1SvxcDqmvB6xYeyNQmTf3MVIliA7Ejyajw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2782.eurprd04.prod.outlook.com (10.175.24.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 21 Nov 2019 16:53:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.018; Thu, 21 Nov 2019
 16:53:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 11/12] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH 11/12] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Index: AQHVnZa1Je0BlUBIrE+TMPovQJFAQg==
Date:   Thu, 21 Nov 2019 16:53:54 +0000
Message-ID: <VI1PR0402MB348579F11E5BF69DBACF756A984E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-12-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1f2ac4fb-913d-4e17-2dad-08d76ea364d9
x-ms-traffictypediagnostic: VI1PR0402MB2782:|VI1PR0402MB2782:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2782151490CC044DD0512DFD984E0@VI1PR0402MB2782.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(199004)(189003)(76116006)(316002)(110136005)(25786009)(6116002)(5660300002)(33656002)(66476007)(64756008)(66556008)(8936002)(7736002)(14444005)(256004)(508600001)(2906002)(91956017)(66446008)(66946007)(54906003)(6436002)(86362001)(14454004)(186003)(102836004)(8676002)(305945005)(53546011)(55016002)(71200400001)(9686003)(446003)(76176011)(6506007)(71190400001)(81166006)(81156014)(6636002)(66066001)(3846002)(99286004)(4744005)(52536014)(44832011)(7696005)(6246003)(74316002)(229853002)(4326008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2782;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o+CB23G8S9n9T+NdGIjY1RuGWfXXY5rjNEby82L8OjEtwGMWf+JDNi1pjN44U1ayp73CqsL75aPtHaUcfDxmTi3/Lreg4tFzv/qjpjy/GKLohaT6U7GIKZUjD3EPXPdqC12XwlNzghYF6jyttbTNpNjPkui1AK6IpoVWy6aN9ieMHOBBmMu5Xq3zX/WlhcrRYvfJxAatJD7YeVTmziXN3KNnSaApdRZiXU75KxsrI62TloqlL3xCJE8xV5infXyj7z6RIKH8UJ80cBPyNf5RF+fuSX69fWuRT4Z1poooFMhi7n4rrOEZQcSgOt4GToP2pyaH0MOvyZkxGKCc91orR7hPqpfIbviXjBI7qbeV4QFX9tFkUzSLZMP/pWNaO5wrZJCwqJk2/h1u228e2Xne30qIsJlDcUWwrBNk9q+55PmXrvn6FTpVl+SrPSDoYCfW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2ac4fb-913d-4e17-2dad-08d76ea364d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:53:54.5864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VXKMziiVZH0busgOc1E51NVTrmtfc0UWWJW5eZDpxdgpWcjWsawDTvIxFQ6T1aY1MasoLX+iVWcVmFpIdDJ63A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2782
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> @@ -311,14 +329,16 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akc=
ipher_request *req,=0A=
>  	edesc->src_nents =3D src_nents;=0A=
>  	edesc->dst_nents =3D dst_nents;=0A=
>  =0A=
> +	edesc->jrentry.base =3D &req->base;=0A=
> +=0A=
> +	req_ctx->edesc =3D edesc;=0A=
> +=0A=
>  	if (!sec4_sg_bytes)=0A=
>  		return edesc;=0A=
>  =0A=
>  	edesc->mapped_src_nents =3D mapped_src_nents;=0A=
>  	edesc->mapped_dst_nents =3D mapped_dst_nents;=0A=
>  =0A=
> -	edesc->jrentry.base =3D &req->base;=0A=
> -=0A=
This is a bug fix - edesc->jrentry.base must be set earlier,=0A=
before having the chance to return from the function (in case no S/G table=
=0A=
needs to be generated).=0A=
=0A=
It should be squashed into=0A=
[PATCH 07/12] crypto: caam - refactor caam_jr_enqueue=0A=
=0A=
Horia=0A=
