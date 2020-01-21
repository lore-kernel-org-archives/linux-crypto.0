Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBADC2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 16:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED89E22525
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 16:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MUUsYGft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgAUQiX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 11:38:23 -0500
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:59195
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbgAUQiX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 11:38:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8NCphYx5j4JXzlqLcY9P6xgbNsyEd9eVqkqU2OIJq9pSRqa/iZSOjbMVMxDsTzaGyX9z/IL8N6SxaVtrXqy4K3WNkiGCHX32CVfLlqHd4M3NjwUv2ZmF3Cv9oJqib8enMrOjKPnMJDmKL7CJp9Zd0fLdDQSG0pnjM1qWppOjkVcr/hBiV3gDVy2mvn6eA2mmdtdUr9JRWJnZIEkyoyxCHHO35kh1aPp1+zmjG44ikOrg7Uaz5VksBwy6ROI7E1lAr55y8hkvdrDY5hD0FZj7NXfNOnn6Z6r9pTYZWt5trY1CKV3aI/t0W5USvOphP0nWACtPr+nV7rOV7fPTfIACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13oC8717DGp2yKnzBQwPgCM0jrefTVUdC1wSasivdu4=;
 b=Z3LTWlnJ8U4NU6AJ2Bf6rYyBt6t4wlzyBx8urUAgY5jOC6YH3GWqkxrGUlshRHtC1/wRqnBsS//1woRZloV86DmD1UGt3MMzUr8C0/CwabAN97VLlWJypoUlciPUt0JVtI5KyIPzwHEJJWF+hwgb9n3AWipNEBRpdm6znFgbtrxKzRJ58WKApGbV9hjiFd+JaeNKKVL8Ek+H0ulbb27mmJwElh9JOmEe8hGfHrLltmxPgnbSeC1HfDonZ5a0wftXKTzPdiCVZV/vp4EC057CyDNJOyPcqpk06LIheUG3Jx7QIyDpzL5Rq4KkFagKQWUrjirxgDeak0lzEKVw8qGMwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13oC8717DGp2yKnzBQwPgCM0jrefTVUdC1wSasivdu4=;
 b=MUUsYGftfoFXmKKIfbXdJ+XUK8HlMJPeSkj7cPXSqk+mPFtEkWBPpDnRgANCd/S6i5nTKMZzjZ2duGUbbyNceTHMm8jGxb1IXE8l5++rk/kLdCz0M6NpvooVhuL1MQvvoV7tgvqYWEKMCsGNrNW8oCJNEjlFTHv5crmkkEvuM3g=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3583.eurprd04.prod.outlook.com (52.134.7.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 16:38:18 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2644.024; Tue, 21 Jan 2020
 16:38:18 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Topic: [PATCH v6 6/7] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Index: AQHVxjouh/c8xz5csUKnQ9CkhtEExg==
Date:   Tue, 21 Jan 2020 16:38:18 +0000
Message-ID: <VI1PR0402MB3485B3F4C3E39D0D94A1D8C6980D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-7-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48774d56-5085-4023-50b4-08d79e9051fa
x-ms-traffictypediagnostic: VI1PR0402MB3583:|VI1PR0402MB3583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB35836F41A89BA80DB9AA3CAD980D0@VI1PR0402MB3583.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(189003)(199004)(81166006)(8676002)(186003)(33656002)(9686003)(8936002)(81156014)(91956017)(76116006)(26005)(478600001)(2906002)(55016002)(53546011)(6506007)(4326008)(44832011)(54906003)(71200400001)(110136005)(7696005)(316002)(52536014)(5660300002)(86362001)(66556008)(66446008)(4744005)(64756008)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3583;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xtk5DUcvp1bUT/EQh6sqbwiicIPuQbYy//oYwFfBLxFLFG1sexUcsq1Zmpt0WSS37LokyqiJ+zKCK1rcn+RSWqw+e6nOOSb/kYvOdDL7Kp5C1rItJ4eot1MhpB4G6IdUHcp9kfN22Uc6GTiUAa7BT/JxPuckPQo0W7/73Wglc+GQZVQ2isBnecqUtCd+AHsEKy4D0I2ZW/V75euxanFqRFDoVQv1SAL9Wz+reMSIJ7MrgBKiQ3lQ3zNo6nmAlUb+GoaviNZpleTlOo/Muee3LIjDAGc/XYBAmzJknqdqhPdSRtWy3RD36R23F16lVbnSr53pmAQFVWqCNm0V7BAp6SKP9Eo0Mf0VnG55vEgNma6dJM/4lYUyUICFRuOCFMVZdm34r1aR/2fKBhBYdrFH8muRYckAKpaEXXeVCums/Pacn48ElVIZOP6F/kena4XH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48774d56-5085-4023-50b4-08d79e9051fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 16:38:18.3059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5aey0HGHU/IHfLP7zRP+k6JjuymwWPLk3fRLtEe19DJ0XLaizd18gaR1k9wWox/dgYItl3JQLR1UfTo4zSxwxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/8/2020 5:42 PM, Andrey Smirnov wrote:=0A=
> @@ -275,12 +276,25 @@ static int instantiate_rng(struct device *ctrldev, =
int state_handle_mask,=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	for (sh_idx =3D 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {=0A=
> +		const u32 rdsta_if =3D RDSTA_IF0 << sh_idx;=0A=
> +		const u32 rdsta_pr =3D RDSTA_PR0 << sh_idx;=0A=
> +		const u32 rdsta_mask =3D rdsta_if | rdsta_pr;=0A=
>  		/*=0A=
>  		 * If the corresponding bit is set, this state handle=0A=
>  		 * was initialized by somebody else, so it's left alone.=0A=
>  		 */=0A=
> -		if ((1 << sh_idx) & state_handle_mask)=0A=
> -			continue;=0A=
> +		if (rdsta_if & state_handle_mask) {=0A=
> +			if (rdsta_pr & state_handle_mask)=0A=
instantiate_rng() is called with=0A=
	state_handle_mask =3D rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;=0A=
so if (rdsta_pr & state_handle_mask) will always be false,=0A=
leading to unneeded state handle re-initialization.=0A=
=0A=
Horia=0A=
=0A=
=0A=
=0A=
