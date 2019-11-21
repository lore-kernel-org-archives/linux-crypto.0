Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EFCC432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 17:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B997A20692
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 17:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="iRGWasfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKURHF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:07:05 -0500
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:30022
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfKURHF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 12:07:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F21zzpwcZQq0+SbT9D3U9fLF/Ly1ncQJSry2XiCoUcSTqbvQQk5wulLwabMJoazQaN5sdF8VVn5yeO5053ab1amyODfwnGnlZiz7x+fkXxFTECv5E0OXyCbNUArD1ooRbLhioFML9bqPofoCuAqq3ikJQ5d4Rvbq4gSYjORMBAJf5HrErEBAqSIOQJDzV46pPiP26G1RlGzqvs7R8LwtTJWO87cyx2xbAucLZCR8T6XIU+zGxvVX8mkyO9mYx/8HfDSOShvlt0hAHcdBe518C6q5l5sSjNDQ1hW1xXNpWj7K/sYKioE62uRvur4R7+kqKLHTexN/h34TRMpFnwo8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28JtSm7tlisDLwV/L6DbfJuv0VYJNNc1AOqPnbGmymM=;
 b=hTdVOLxe+7t+YQg7JU2e/ARPO9SlYjd0/1h9TG7XkE2wfpYkvnRNZjMRcpFKmrSM6sM5YkoOgA0eEokd+Nb3e1NkA+M51BMlSk+2Jt6388m26ExIBw2B7bPOS3xpQhMwn9jYfflQrG1xCcEzoJcJBqr8mYmtTpc72Mj9VV8vsf2tE5rpTmw7Q306DsE1u7Nx1RLsubu4S8i8ymi6dYC2kKvsdRhjxO2YQFIiDy7u3D14ID2tN9+1wxoNNr/z4XRdMUXpasbPzUwM3xFfqYfBgRJqlHl4meTZmf9RoVXtg3oH3D0YdiRiZgN/V25tR/Xx9BsIlmi92j9zsQ3B7gsWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28JtSm7tlisDLwV/L6DbfJuv0VYJNNc1AOqPnbGmymM=;
 b=iRGWasfpMjpXVwBknWX/DdJR8fp5r2kOEfyfVk0OXz/raIA1KPIztLWRmxKkvVbfa3UVcFiyGOM9Ez2g9k/IsR/01YcnCfehJ0+Y1NY8nR7rE5QusPrB1RxqCKEyOyGRayznZRwMYxPSNITFT5fLyFDK861pjnG3EhELdHNMXcI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3374.eurprd04.prod.outlook.com (52.134.5.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 17:06:59 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.018; Thu, 21 Nov 2019
 17:06:59 +0000
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
Subject: Re: [PATCH 12/12] crypto: caam - add crypto_engine support for HASH
 algorithms
Thread-Topic: [PATCH 12/12] crypto: caam - add crypto_engine support for HASH
 algorithms
Thread-Index: AQHVnZa1YAvOB9zlFEuQgR2AeTqLIg==
Date:   Thu, 21 Nov 2019 17:06:59 +0000
Message-ID: <VI1PR0402MB3485A57B6A13B5571DF93B53984E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-13-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be9f06fa-7ae2-4334-12d5-08d76ea538b6
x-ms-traffictypediagnostic: VI1PR0402MB3374:|VI1PR0402MB3374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB337410BA11D8A2449FCD2D47984E0@VI1PR0402MB3374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(189003)(199004)(6506007)(53546011)(26005)(186003)(446003)(102836004)(6636002)(14454004)(44832011)(86362001)(5660300002)(7736002)(508600001)(52536014)(14444005)(7696005)(305945005)(91956017)(76116006)(66946007)(74316002)(76176011)(66446008)(64756008)(66556008)(66476007)(25786009)(81166006)(81156014)(8936002)(6116002)(3846002)(33656002)(99286004)(256004)(2906002)(316002)(8676002)(54906003)(110136005)(6246003)(9686003)(55016002)(4326008)(66066001)(71190400001)(71200400001)(229853002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3374;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SGKT7n0/kxHxmJqFiU13uMiFtM+dk8zOz9uWclZ2q2Qq9rZBFTFVMCDE8wh5J+s2NvunIWAtBUypFLjOapVhjUAx3yLfusTUiLXBQlAce/ro5eVQL17n6dPFE97dK0aOokUrsc2pTl4DJpFPP851cePF+ga76OrnZ8y+ZsC9W9iqmcFpUe5bLOKZ1reJZnrFsmkn1p+u/ckZ0jyFooE1t28ptaMB7KFuIf+PIZSk+BTahLWtj0IN9mqSJMl+Hjc2jN0Tof+cEGG/fzksgmaxvMcU4JIDhFwEV7sII/WA34O+8FgnUg8+eMCTeXndfP/WIdMcMbiiZFqjR4ANOIRabJyWmYTguLxxZX/giWo9SXBTdY88ju0uiiSVJvgneWuv0tK10qsmslfjctcwThJfJexM1Hj3ZJgo0hzBRD0dQ4QH1u0TNusnPP9jPPYTO3yU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be9f06fa-7ae2-4334-12d5-08d76ea538b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 17:06:59.4920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 74jubjwUDfs5UJglRVDmEwgW05zQRnXKT3UdeHfcbUUsxGTDhBuLFVpJCRtjda5Khqj1WEW1nVbee8jZeQAo0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3374
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> @@ -1150,20 +1201,19 @@ static int ahash_final_no_ctx(struct ahash_reques=
t *req)=0A=
>  			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),=0A=
>  			     1);=0A=
>  =0A=
> -	jrentry =3D &edesc->jrentry;=0A=
> +	state->ahash_op_done =3D ahash_done;=0A=
>  =0A=
> -	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);=0A=
> -	if (ret !=3D -EINPROGRESS) {=0A=
> +	ret =3D caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);=0A=
> +	if ((ret !=3D -EINPROGRESS) && (ret !=3D -EBUSY)) {=0A=
>  		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);=0A=
>  		kfree(edesc);=0A=
>  	}=0A=
>  =0A=
>  	return ret;=0A=
> - unmap:=0A=
> +unmap:=0A=
>  	ahash_unmap(jrdev, edesc, req, digestsize);=0A=
>  	kfree(edesc);=0A=
>  	return -ENOMEM;=0A=
> -=0A=
>  }=0A=
Unrelated whitespace changes.=0A=
=0A=
> @@ -1294,7 +1344,7 @@ static int ahash_update_no_ctx(struct ahash_request=
 *req)=0A=
>  			     1);=0A=
>  =0A=
>  	return ret;=0A=
> - unmap_ctx:=0A=
> +unmap_ctx:=0A=
Same here.=0A=
=0A=
> @@ -1509,6 +1558,7 @@ static int ahash_init(struct ahash_request *req)=0A=
>  	state->update =3D ahash_update_first;=0A=
>  	state->finup =3D ahash_finup_first;=0A=
>  	state->final =3D ahash_final_no_ctx;=0A=
> +	state->ahash_op_done =3D ahash_done;=0A=
>  =0A=
Is this initialization really needed?=0A=
=0A=
Horia=0A=
=0A=
