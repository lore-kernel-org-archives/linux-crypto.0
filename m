Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71322C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 16:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4750120859
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 16:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lh04h7ep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfE0QhU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 12:37:20 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:54361
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726937AbfE0QhS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 12:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DV6PUodTsUn3itp8Ad6lHWB2/j2xNErj+Qu5oDa4jrc=;
 b=lh04h7epcWPDTDSvViaYFQsGmnWyNv1zQvvUOtnNEkTY8eIKmPrA1bve7dZCgOcL+1UcsFcoKIA6NVULeuw2PSYfcxq6x/7pBL7JdLW69RcdiP+IZiEiANgtZQ9xrcnVig8KRhFS9sWSTo+2RBRN4C8WJLYxhsQ2cWOO7G5uJT8=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3792.eurprd04.prod.outlook.com (52.134.16.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Mon, 27 May 2019 16:37:15 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 16:37:15 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Topic: [PATCH v3 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVEj+CGyNNQHQJmUKR+9DV1yltFQ==
Date:   Mon, 27 May 2019 16:37:15 +0000
Message-ID: <VI1PR0402MB34853A1681A83D311AD74599981D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1558709189-7237-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f6df39d-02e3-4507-29f7-08d6e2c1938a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3792;
x-ms-traffictypediagnostic: VI1PR0402MB3792:
x-microsoft-antispam-prvs: <VI1PR0402MB3792C467FDA6FCFA5B8F5AE2981D0@VI1PR0402MB3792.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(39860400002)(376002)(366004)(189003)(199004)(64756008)(66446008)(66556008)(66476007)(54906003)(8936002)(110136005)(66946007)(76116006)(55016002)(26005)(229853002)(86362001)(25786009)(71200400001)(71190400001)(66066001)(4744005)(9686003)(5660300002)(81156014)(81166006)(256004)(53546011)(6506007)(76176011)(186003)(4326008)(74316002)(7736002)(52536014)(14454004)(316002)(478600001)(476003)(33656002)(6436002)(68736007)(8676002)(305945005)(73956011)(6116002)(2906002)(6636002)(7696005)(6246003)(446003)(486006)(53936002)(99286004)(44832011)(102836004)(3846002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3792;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2pZbyO8OdGoR56NBHVQ+j9BG42Xtev+HBAc48CVzJDmGUjaq8UiK9EOCf7wAOKhaJR4bpq607pJNUKJrnoLQbHiaiWezPP3e/iMmZAW/FiDdXfl3A8LGQXHdIK86lX0Yr9PmO/OyKX6lyELUy91goqhhv42Bfv/QP1fCirw5KY96JI45nPLSHgluf/1Ip+l4uCcwdQallvMExOR8yzS2o51mKZe8m1azhiQPtZ9VaBpmk4lFbMw736HCgGP0dE3cIlq30qNy6Zp7CVY63G+80Ic4pQx22IE3QfBXtbwIzHj1rr8kJO8YOGg/r+70knzZW+i+2ju77jUs53OJj6SjbPM2EdHTPQYodfJC1mhRbFlUwvPX17RDjUfEyj3ik0fZutuE38+LKfsIfJ24TNPZvDWXTVfqJTZz893qVRCchRA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6df39d-02e3-4507-29f7-08d6e2c1938a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 16:37:15.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3792
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/24/2019 5:46 PM, Iuliana Prodan wrote:=0A=
> @@ -1030,17 +1076,26 @@ int caam_pkc_init(struct device *ctrldev)=0A=
>  	if (!pk_inst)=0A=
>  		return 0;=0A=
>  =0A=
> +	/* allocate zero buffer, used for padding input */=0A=
> +	zero_buffer =3D kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |=0A=
> +			      GFP_KERNEL);=0A=
> +	if (!zero_buffer)=0A=
> +		err =3D -ENOMEM;=0A=
Either return -ENOMEM or jump to a label before return err.=0A=
=0A=
> +=0A=
>  	err =3D crypto_register_akcipher(&caam_rsa);=0A=
> -	if (err)=0A=
> +	if (err) {=0A=
> +		kfree(zero_buffer);=0A=
>  		dev_warn(ctrldev, "%s alg registration failed\n",=0A=
>  			 caam_rsa.base.cra_driver_name);=0A=
> -	else=0A=
> +	} else {=0A=
>  		dev_info(ctrldev, "caam pkc algorithms registered in /proc/crypto\n");=
=0A=
> +	}=0A=
>  =0A=
>  	return err;=0A=
>  }=0A=
>  =0A=
>  void caam_pkc_exit(void)=0A=
>  {=0A=
> +	kfree(zero_buffer);=0A=
>  	crypto_unregister_akcipher(&caam_rsa);=0A=
>  }=0A=
=0A=
Regards,=0A=
Horia=0A=
