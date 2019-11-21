Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31C5C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 16:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 939FB20672
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 16:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="eif0I6Xf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKUQqH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:46:07 -0500
Received: from mail-eopbgr00041.outbound.protection.outlook.com ([40.107.0.41]:51908
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfKUQqG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 11:46:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h56pdZDzQcvMN2RmSmurgqOuxpNaJg1xWXpQmDCPYp4h2jG79TMY3ld5E2Xxp2MCwgh27tDsuFpCU/yjjjL75SQCTVwOSRICTVCaHyeVejCxgQf4NR7SRQnf9oSzzI5n8Ih9GuIv5YQpexrhNr5ph4IbtQ6NPMmUwXr0CmIRyGTD0N4/BSPF8EKAzUgbFgm2+n/ZYg52D2VSKD+97TNZ07n2x6l0OMODu4yhrMoU/E7hy0n29rZqjUJUfQweY3yfl68B7Yss7EX36Kz5n9EatoOwlxG9t0k68AHFmPLSKI87Lq85AUjWGah+ceJSI8FoTCl+6QGIw1gBmJ2axMcFjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xHxrU5fYyVtTolyV7nPmm6s6RdE1DJ4v5fxZKYxCVE=;
 b=jAxScznjYPe7hRoml3JKyXkhG03KT6fMLCSNy5eAiRD4y3ZihCR7aurHRk0ih7B/vYvPyOmyl09PP6plhFOhEx1YlIIDYk6ajJ+ZuNTYhcEltmWUTogvycJQc5IyM+KqXBqw+RYthFmbChjyZU3biNKlzKlNln3U1juvh/Da0oXnH6+ARf5B45KLGRjVqDKxk1KFQXETab5AmQF1YMNbECPFah0m/7k5esNsGDdR7zB0OGZJhhTB7E+ePDO8cFDYx6rwA80l2Eno9gy/jyE+5JNgJcfHi7u97KSuNgi2Bxf3T5tMUptEOrW2n8GwOZwoxE1gG3ciGiJPSIITstDIoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xHxrU5fYyVtTolyV7nPmm6s6RdE1DJ4v5fxZKYxCVE=;
 b=eif0I6XfLbO/1Fh4JsbbNg0RoYwM22tDNwcD5VvV523pu7shNFh6RsZzqRMoFtFn3UFpNx864YhWDyw4sV+JFMUgiqktNBwf6CEgXB/ZDwgqQ49G06KrQubuXENeDFGHZQxqwmHXTmUX0WKwqNMLqAc9oyNcs9FjIzYVumLnCg4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2944.eurprd04.prod.outlook.com (10.172.255.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 16:46:02 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.018; Thu, 21 Nov 2019
 16:46:02 +0000
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
Subject: Re: [PATCH 10/12] crypto: caam - add crypto_engine support for AEAD
 algorithms
Thread-Topic: [PATCH 10/12] crypto: caam - add crypto_engine support for AEAD
 algorithms
Thread-Index: AQHVnZa1FyZOwAzxGE6ZWqnis9ksHA==
Date:   Thu, 21 Nov 2019 16:46:02 +0000
Message-ID: <VI1PR0402MB3485587572B8720F372F4ED5984E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-11-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bbc3181a-6384-43b4-79b6-08d76ea24b94
x-ms-traffictypediagnostic: VI1PR0402MB2944:|VI1PR0402MB2944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29446156897FA47345327F77984E0@VI1PR0402MB2944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:525;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(256004)(2906002)(99286004)(110136005)(54906003)(8676002)(316002)(8936002)(3846002)(6116002)(81156014)(81166006)(33656002)(71200400001)(71190400001)(6436002)(229853002)(6246003)(4326008)(66066001)(9686003)(55016002)(86362001)(44832011)(6636002)(14454004)(5660300002)(6506007)(53546011)(186003)(26005)(102836004)(446003)(76176011)(25786009)(66476007)(66556008)(64756008)(66446008)(305945005)(91956017)(76116006)(74316002)(66946007)(52536014)(478600001)(7736002)(7696005)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2944;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /2X8gl8e9GkqMtA98cPI8hkxs10AxcJgHoSmWArhn2LgbkgaC0R3x1F8xlE1SFz/jjSC9Kp3COVHI4gzus5P4xWoHC1BTy2I8GR+LlUw65qvb87lO+BKjKRt4mWehkeWHXQbK4cvlXewKR7t5rFDBCT8snEmYCiCfM5073uZwFGLGB5tEEFSKJ90qWsZWoLOwrf85eYmr5Tg2Uj7/pKejbD4EO3ZloFWRhTnGP/1NesJlFLyn7ZrsiTMgta6bV2jzugadlLsICHEtaWIRuiN7WaJCev74evfamD0ylgImdN9ymUuMkt8oV4XyxSh0nja+qqbHf14qQjtNOPSR82Q5KPnzN8Kj/5FiTBotyZLuQ7JQdhEKpzYl3gT7pL8UMG3EMjICWA5GlSxtp9tKlRDT+kOMvbjyGNQ1IhRj9k6C15X4pdEhS3nKmb0NZjxZ82t
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc3181a-6384-43b4-79b6-08d76ea24b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:46:02.7064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EK+ElHOIXMwqF4qLesKC2CyDxMYveuxrv2h8JCnUK1kk2QC9GFlfUZJs6ZwhrWhnL3HfWVffecmdTNKU5jtX5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2944
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> @@ -1465,7 +1484,6 @@ static inline int aead_crypt(struct aead_request *r=
eq, bool encrypt)=0A=
>  	struct aead_edesc *edesc;=0A=
>  	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
> -	struct caam_jr_request_entry *jrentry;=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
>  	bool all_contig;=0A=
>  	u32 *desc;=0A=
> @@ -1479,16 +1497,14 @@ static inline int aead_crypt(struct aead_request =
*req, bool encrypt)=0A=
>  =0A=
>  	/* Create and submit job descriptor */=0A=
>  	init_authenc_job(req, edesc, all_contig, encrypt);=0A=
> +	desc =3D edesc->hw_desc;=0A=
>  =0A=
This change is unrelated.=0A=
=0A=
>  	print_hex_dump_debug("aead jobdesc@"__stringify(__LINE__)": ",=0A=
> -			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,=0A=
> -			     desc_bytes(edesc->hw_desc), 1);=0A=
> -=0A=
> -	desc =3D edesc->hw_desc;=0A=
> -	jrentry =3D &edesc->jrentry;=0A=
> +			     DUMP_PREFIX_ADDRESS, 16, 4, desc,=0A=
> +			     desc_bytes(desc), 1);=0A=
>  =0A=
[...]=0A=
>  static inline int gcm_crypt(struct aead_request *req, bool encrypt)=0A=
>  {=0A=
>  	struct aead_edesc *edesc;=0A=
>  	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);=0A=
>  	struct caam_ctx *ctx =3D crypto_aead_ctx(aead);=0A=
>  	struct device *jrdev =3D ctx->jrdev;=0A=
> -	struct caam_jr_request_entry *jrentry;=0A=
>  	bool all_contig;=0A=
>  	u32 *desc;=0A=
>  	int ret =3D 0;=0A=
> @@ -1525,16 +1565,14 @@ static inline int gcm_crypt(struct aead_request *=
req, bool encrypt)=0A=
>  =0A=
>  	/* Create and submit job descriptor */=0A=
>  	init_gcm_job(req, edesc, all_contig, encrypt);=0A=
> +	desc =3D edesc->hw_desc;=0A=
>  =0A=
Same here.=0A=
=0A=
>  	print_hex_dump_debug("aead jobdesc@"__stringify(__LINE__)": ",=0A=
> -			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,=0A=
> -			     desc_bytes(edesc->hw_desc), 1);=0A=
> -=0A=
> -	desc =3D edesc->hw_desc;=0A=
> -	jrentry =3D &edesc->jrentry;=0A=
> +			     DUMP_PREFIX_ADDRESS, 16, 4, desc,=0A=
> +			     desc_bytes(desc), 1);=0A=
>  =0A=
=0A=
Horia=0A=
