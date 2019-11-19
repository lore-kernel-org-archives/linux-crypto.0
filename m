Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B46AC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E57B5222CD
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Pc+UREXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfKSPFQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:05:16 -0500
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:57060
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbfKSPFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:05:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3J7sl6K6BbWEBa0jVfc+TRXZ9cO0NVO9RP6hcsyN/yi239OxqVlRu3tNcB2Z4PvKo1exIrxiqiFeRlwugxwCvSDHHyV38AtzLyUyH+/TLkK4Hqd5HCHTvw9JqbY9K7VONkTR3NOO9SeS3OS6JyeOqBQhAdjUOvIACx4YWDoN1vz6+d+P3ayeMtAPn5L03ScXzB02Wdyy4EEW/jbLzUypXOfDfSI5HZFnf925VeroL1RgnEyFdDfgyd9IpU7L2ytWcccyPS8/E0ZvyfEZ+Ks0X9ivwSBpROCgzM0YJFMX2/Q07dCBOLfifFoyREY6kkxQAHNmCn/yAgwT4l89585mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/k4jdrsDHtc82q20JIAXTpNLKbFGNMFBc3vbvMQueM=;
 b=Mt04W/NMoWeRpq3/7Snt+b/IOEEpaDiqnyCTOW7IETGPqvqjD08qBySsRcq/t7vKRAq84DhA30y4a+AJh3OdXIkyn/8qWworm+syR5IBxp1LdnGCDP/mEr/Beu8rWzzXH0gwe6un7/Qv/0Ly/7rpCHgvHhZ/ZVz/hQuLlrqWSjQb+JshvQyhrIGIfkrYNO2KUlDbu1Z9o9atTZTCsJflYdST7V/GcFmw9U/NF+9lSuVN7axPZxYfMpnOrZ4M/J/Ij6zd3yoVOhaCfD+aF2fLZAHLpND4wndzwy1NSxZNomB7guehQ9wtwELU+9lyaSq7YIJRLVLWzZjr5mtMj9H49Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/k4jdrsDHtc82q20JIAXTpNLKbFGNMFBc3vbvMQueM=;
 b=Pc+UREXu8lqQCsXzNWSxR7ohpM5dU2daF/96S3b7RdqqTH4B3R01doXIiBit3ckBV0x8ruReQ8TDGqlhUeKXBpR/+U2MGxDaUtEavFu/iollH8d8u7wLBEa3SaK2GBFDMEJZKhX7PUjPaEZ/oJUZpJ9ql6uy3QSOVQLzw7YIJIQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3920.eurprd04.prod.outlook.com (52.134.17.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Tue, 19 Nov 2019 15:05:12 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 15:05:12 +0000
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
Subject: Re: [PATCH 04/12] crypto: caam - refactor ahash_edesc_alloc
Thread-Topic: [PATCH 04/12] crypto: caam - refactor ahash_edesc_alloc
Thread-Index: AQHVnZazrPktEYxsFUGlA3OloV904g==
Date:   Tue, 19 Nov 2019 15:05:12 +0000
Message-ID: <VI1PR0402MB3485A8C1320F32659B95776B984C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-5-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0da5732f-9645-4150-9d36-08d76d01e06e
x-ms-traffictypediagnostic: VI1PR0402MB3920:|VI1PR0402MB3920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB39203C03D04FA7A8DD458102984C0@VI1PR0402MB3920.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(33656002)(4744005)(102836004)(25786009)(229853002)(7696005)(66446008)(26005)(81166006)(8676002)(52536014)(64756008)(4326008)(86362001)(81156014)(91956017)(14444005)(256004)(76116006)(76176011)(14454004)(8936002)(99286004)(44832011)(486006)(476003)(5660300002)(3846002)(446003)(66556008)(66476007)(71190400001)(71200400001)(6246003)(66946007)(6636002)(6116002)(186003)(2906002)(478600001)(66066001)(6436002)(55016002)(54906003)(110136005)(316002)(74316002)(305945005)(53546011)(6506007)(7736002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3920;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zXJ+sCIvzUUmYbl30N97QBu6xZZGT/vjXT+Uer9pa8PyOpMJEmdxzzTErUNg9Jd4qftjKjBM2SRwgCqJ0F8hi7Pve/Wg+qC21lFUf+ndOXpjJ7xGmhZ8AD232tjDnEndlAjKPT67z25SyuIDkMyf6Qtr5JP/vbU++dpFntkskUfng+j+RJhLKB8oez2gqV3moh7B4dOdcwKgslYAaKhv0ek/ol1Teh7bveP7lY5TnCboCsuWgewUUgTkpD8SOiz8aFmE7bG/BeRA4+NsAAXYiO9Ts8QHFtCliWZISNJzMSYyTP8yCbBFJTRa7S1dUAW72VGaq4oPInQ+mqI/g5Td5YnLISZDCfqyiycF3kdHV8mj0AVKuGOmtTFmBb7vHhKuhlEvlcI1YJpyEBbi+nWA+0TmrGHU6po7/nQ6rp780W+Xb69hvrCzxwwNLiLkdOil
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da5732f-9645-4150-9d36-08d76d01e06e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 15:05:12.2735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpIhjleBcQUpDeUdbqJjUsuheuWUbCDqVwnc//am5/GbKLwzcwGPxY9eXyS/9YfSIfbJHh/ZJZ8d42RmCWZT4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3920
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Changed parameters for ahash_edesc_alloc function:=0A=
> - remove flags since they can be computed in=0A=
> ahash_edesc_alloc, the only place they are needed;=0A=
> - use ahash_request instead of caam_hash_ctx, which=0A=
> can be obtained from request.=0A=
> =0A=
Technically, the use of ahash_request is to allow for access to=0A=
request flags. The change is needed only to be able to refactor=0A=
the computation of gfp flags.=0A=
=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
