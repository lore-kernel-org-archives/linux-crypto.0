Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3E8C2BA83
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 10:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04592206D7
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 10:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="U/OSgAlM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBLKl0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 05:41:26 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:57761
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbgBLKl0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 05:41:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGtt3wvm9pEkDE1RcJaxASi8mtIfAFsCIgFCcydYPt+sa/8wvmHfXXmrOGr0x3oGjRVnQf2qnYiaZvhvxBueh+XqFI4vqbT+xXnFdcppDr/GdHj4rFUK0ZBAcNiHqXXc/I46ggqk8+9mDbWUukRDMC6EmBE9PulTL/8J+Q5TzQQQQt7wsZs5iI9LErV7tlKjg5U9N5Grygx21DrxjcgGAWTgGUjTJ+nJ6iluEsjZq4zxybuQLUeFztuTi02Jsnq4V2fHO1kGHd5GzN+Btf7aR6ms246CAIe/8dMlYPRoOishU8jM1ZqhH0K3JtrKjfU1nAKblK4nsvWL+JqVy9aqCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeW4JcHEXQsHfnyPcqzUlWtalvBB+BeRW/0pF66eMVg=;
 b=FKPKQXKYi8J+t3vbv1c3UPmEwnocJuYupTCjRpzAJivXLWWWoNa9sE1ZVx5ApSWm0tYz1y71idXk8yAgiD+tUxhLd706wi16PUKrPuDZ7EwxMsZIkmVUiqcYy5pspvmMaM/XhXGRqh8YD/SVln2rNwlC31gDNt4ZHCcVI2ezX5xK0DvkKXZd4it4kz72P52pMTaBRR84iKTuR9QbDQxKHqwMDxMAIycwHc+N2XkkyNE3KYRpxXZmbRkB2J1qBTehXgNJRCAESNUFUHba078TqAfFupsh9M71f0nP3fAFNpFMYOwg5o1ApGjs+a+wFPi4QOGV5A3/rx08uIRehswlvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeW4JcHEXQsHfnyPcqzUlWtalvBB+BeRW/0pF66eMVg=;
 b=U/OSgAlMQ58C3CPN9ZY9yraBa9ov9kuyELo3d6kd5xREhKZuPNKuFpaRrLXUvkd05er+FcIabsG/qgf1oXhE1DaZIY3ehKLwIYznFQGew6Ng2u/qC6lCulPTkrf6hQlbOOgU8TifekWfq1UnmCGxcmVzbI80Gj3aJHn0KvQCi4E=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3549.eurprd04.prod.outlook.com (52.134.4.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 10:41:21 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 10:41:21 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 6/9] crypto: caam - check if RNG job failed
Thread-Topic: [PATCH v7 6/9] crypto: caam - check if RNG job failed
Thread-Index: AQHV1TLUvWTrrHqD+kWSWumiFCRkzg==
Date:   Wed, 12 Feb 2020 10:41:21 +0000
Message-ID: <VI1PR0402MB34857006B42E8F0DAFECC514981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-7-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4683e604-26b9-4fb2-291c-08d7afa819ce
x-ms-traffictypediagnostic: VI1PR0402MB3549:|VI1PR0402MB3549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3549A18B06206DC5B2E8B5BB981B0@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(52536014)(7696005)(5660300002)(86362001)(2906002)(71200400001)(8676002)(8936002)(81156014)(81166006)(53546011)(4326008)(6506007)(44832011)(26005)(33656002)(316002)(186003)(9686003)(76116006)(66946007)(54906003)(55016002)(66446008)(64756008)(110136005)(66556008)(478600001)(66476007)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3549;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HEVQSUYO8JXLLbZ2PCUxWXG3oCCxVxOC3TY3HKDCOwE5DifPANHLplUKyx41U/blgSsp4Lf1jy+WPR4wI2gtxEwfdUYg9Ke7/yDpdwTgAjpFpHfiFuouKZMV86C8sA8hiHqqn3oQdZ1nNe9CKz9atZSPjxSkkjKbPpoScJtHTn9rVaJQ2kKqKKjzdy0S4ScUNWefXWyBbj2lb6e+5VTAJXn7qVVs6r8Cg11NHwtLAO6V7zMCqtunwlNerEyFmAnz/7A5Ma5itW79+yrgNWRrt1IZCIm3F6FkbXdffQ5DZxR0TOwQHW4mo8eZIaBowtMrzcFIspqsFDJ3nHLr0g8z4lZ0Fpanvd876rFMkK0oBxGypNu5H94Rsuq4G8JPlxQ94HiLWxcvEIiVk4x0URQtl820sL7OkOMSVgLwGrfHm20S2vOprsuTAckg87S3sJG
x-ms-exchange-antispam-messagedata: SFnkCrhqFMzE+bIp/2JbH3w+F9xWD4iTfy+gzb1K1Ai1pGqJp2hkL4MUZ9sJ7Z8ZUTLLIo9RqV2eXOfSC5wcQu9F76f5tv0qgXbBkH7HjhNrwyfqziXp6Xl3eK/8qv9C0dAm+k06lUfrtYYoddjbpA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4683e604-26b9-4fb2-291c-08d7afa819ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 10:41:21.6953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BFCBIbMQHHVHgE1w/PObUhd2Rs2Ht4jtW97+Vtt/PGuwv7B3DFWD9giGNJvIdp0quIWxkS4Nn1K7fBSao6RWBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> @@ -60,12 +65,12 @@ static struct caam_rng_ctx *to_caam_rng_ctx(struct hw=
rng *r)=0A=
>  static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,=0A=
>  			  void *context)=0A=
>  {=0A=
> -	struct completion *done =3D context;=0A=
> +	struct caam_rng_job_ctx *jctx =3D context;=0A=
>  =0A=
>  	if (err)=0A=
> -		caam_jr_strstatus(jrdev, err);=0A=
> +		*jctx->err =3D caam_jr_strstatus(jrdev, err);=0A=
>  =0A=
> -	complete(done);=0A=
> +	complete(jctx->done);=0A=
>  }=0A=
>  =0A=
>  static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)=0A=
> @@ -89,6 +94,10 @@ static int caam_rng_read_one(struct device *jrdev,=0A=
>  {=0A=
>  	dma_addr_t dst_dma;=0A=
>  	int err;=0A=
> +	struct caam_rng_job_ctx jctx =3D {=0A=
> +		.done =3D done,=0A=
> +		.err  =3D &err,=0A=
> +	};=0A=
>  =0A=
>  	len =3D min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);=0A=
>  =0A=
> @@ -101,7 +110,7 @@ static int caam_rng_read_one(struct device *jrdev,=0A=
>  	init_completion(done);=0A=
>  	err =3D caam_jr_enqueue(jrdev,=0A=
>  			      caam_init_desc(desc, dst_dma, len),=0A=
> -			      caam_rng_done, done);=0A=
> +			      caam_rng_done, &jctx);=0A=
AFAICT there's a race condition b/w caam_jr_enqueue() and caam_rng_done(),=
=0A=
both writing to "err":=0A=
caam_jr_enqueue()=0A=
	-> JR interrupt -> caam_jr_interrupt() -> tasklet_schedule()...=0A=
	-> spin_unlock_bh()=0A=
	-> caam_jr_dequeue() -> caam_rng_done() -> write err=0A=
	-> return 0 -> write err=0A=
=0A=
Horia=0A=
