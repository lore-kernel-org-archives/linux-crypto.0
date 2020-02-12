Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0B3C352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 18:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41BB2467E
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 18:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="EuxkiyU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgBLSwm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 13:52:42 -0500
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:51734
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbgBLSwm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 13:52:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gK4UAc62/ha8u2dwggOwmI2J36UA9dZy/ZI2GQ7giIbMEZKADprcp1JyAdo2qt0Ep9v4c6Sy6r+UgbvU9qdvrM81jf8jngRhTcjHsLU4nK8CpVpJ7hgylyTazHBIruvvk0jch1NHt6CoJxhkQXTw8SZnZQWdC/6+nfRyVq54LT7qc2hLxBwDszjx7+ArTRLfgBXqryC4d2F+i+eSSiRrmK1crwNMSedBJD3B/dnS9zcAPn00gdarNYze7CxURyYH7fY/KJ0GlIFo9W2q8BtuKUekeyp7zp2qd19rkKBxVRixgDzVDQPDIZae2Joq9SsySohwv3r1peQVs8jVqZtbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOhZRvhEjTqSS9KJA8HgulAeEAmZP4EYVEB4JbzYhm0=;
 b=JkpQvGD9Ou2uUXaXFHxa/xGsYP9qKm+qm3JS9N/+x1k5/pWi+hSMI9mFJxJPa1ow+NnBV6CpEt8qvs7jN4/BzFh1hJNacpeEwdHMVJoruZNXER3qi+dluI5OMuT5JMBrfD+8B7aG1KhPKKALGluBDYikqLFbWor8vzWISjg7hjoiLxQI4Cv+lFRySbmbLO8UdcNqp1KEI/PUbeo7HdYqxiUFpumpnTH0jQSOdK+EOLcnZHrlWt4cWP93BK9X/KXsZ4FvcN+sodm5jM+XsGBmzb2C3huH50qJW3pCaQTat56q1TVXISqVhkGITS9YGoIemOpuUuMa//GwxHzrq1e5yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOhZRvhEjTqSS9KJA8HgulAeEAmZP4EYVEB4JbzYhm0=;
 b=EuxkiyU9xSubVTjbIFiwhsTZRHjmfrAKrDNTnFDcNA4z9BtoPbTE5ZJgm5siHbj1dzyOFl+O8DS3pJFfPT965Tonq3wwMoWlmyu1W1GWz5u+G+AtgX+4hQF29VVHUwELHUi5wKuwCG6+Kg9ZBvJx8+xkexNuwEuvnbFu2dg2Fy0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2896.eurprd04.prod.outlook.com (10.175.23.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Wed, 12 Feb 2020 18:52:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 18:52:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 6/9] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Topic: [PATCH v6 6/9] crypto: caam - support crypto_engine framework
 for SKCIPHER algorithms
Thread-Index: AQHV4c2vZT1FL1HnJUmtdyuVIaRrTQ==
Date:   Wed, 12 Feb 2020 18:52:37 +0000
Message-ID: <VI1PR0402MB348517DB62AA6A1C1A137FE7981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
 <1581530124-9135-7-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6100ebef-5556-41e8-9a83-08d7afecbb35
x-ms-traffictypediagnostic: VI1PR0402MB2896:|VI1PR0402MB2896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2896AE971EB53EB3BE24E6F8981B0@VI1PR0402MB2896.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(189003)(199004)(6636002)(81166006)(8676002)(8936002)(81156014)(86362001)(4326008)(110136005)(7696005)(316002)(54906003)(478600001)(33656002)(71200400001)(55016002)(9686003)(53546011)(44832011)(6506007)(4744005)(186003)(5660300002)(2906002)(66476007)(66946007)(26005)(76116006)(52536014)(66446008)(91956017)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2896;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kzziXvtp764ieskzPL8aTYybbmMHoyrXzk/UZGBYDGCstYRybno4w1mREM4wbok/Ul8D5o9a1umpDrVKF0E21mgwk18A6YduQu5Rhha8rQFzdSqlAqS/d9nUqxMAW1iQXW+FWJClLJPfTe8BLqfHzwyeTy19dfXql/82a3bIMwiwgMCdnU+ZZ4BhtQ7wivyoPwKbdvaE8oaNgRr3DUeNBx7QYg4ib4ViQD+oe1uDHI8x1q1dw+ekyJ14wla1elLuW14UQKC5JqtPg0yqEvgwQ0XfUabPYynqyAhuhGaB9q8TZqX/FD/jHN00Gs4JReq46oZ4JEWlQYo/OT28210q/4tOtWNYYBP+Yql5isIHNnp2qd69gv1l5XyfwNpRkjt2Z7hQJqKCO1WRAO1SozQ8QmMNKCBBcwb+7ouHOdbl/L5WjJUGr4pZgXked8cKYdhr
x-ms-exchange-antispam-messagedata: mlYdBq1VYvMCfBvrzPQtnGapYpK/SfSxlV9hg0bzrHkseCz1hzhm2Rf3ctqngr4MlVAcLWHamY0qR1mBwKLkhQArQA2Ue/jh2zO4FVJCqXRwU2lJJNtGOV+RwVWdyINAui2/+Kq4b+j9hXq9aw4buw==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6100ebef-5556-41e8-9a83-08d7afecbb35
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 18:52:37.8542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D2wNiDYZP8PWGUFe+8sZnxYKVqvH67PDnxSoVUt6Nz90QXOjl/4bpu+c+0m5tx01rLpC8v/FlemNVnOex3u8jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2896
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/12/2020 7:56 PM, Iuliana Prodan wrote:=0A=
> Integrate crypto_engine into CAAM, to make use of the engine queue.=0A=
> Add support for SKCIPHER algorithms.=0A=
> =0A=
> This is intended to be used for CAAM backlogging support.=0A=
> The requests, with backlog flag (e.g. from dm-crypt) will be listed=0A=
> into crypto-engine queue and processed by CAAM when free.=0A=
> This changes the return codes for enqueuing a request:=0A=
> -EINPROGRESS if OK, -EBUSY if request is backlogged (via=0A=
> crypto-engine), -ENOSPC if the queue is full, -EIO if it=0A=
> cannot map the caller's descriptor.=0A=
> =0A=
> The requests, with backlog flag, will be listed into crypto-engine=0A=
> queue and processed by CAAM when free. Only the backlog request are=0A=
> sent to crypto-engine since the others can be handled by CAAM, if free,=
=0A=
> especially since JR has up to 1024 entries (more than the 10 entries=0A=
> from crypto-engine).=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
