Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9CAC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 07:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AE62173C
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 07:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="qG3KjJXc";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="riI33dfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfBZH4T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 02:56:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54534 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726794AbfBZH4S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 02:56:18 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1Q7soS3013862;
        Mon, 25 Feb 2019 23:56:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=7krqOTU/Ntc8ur6uMNMzLeP/uUJuxPZFxr66ZlmqWv4=;
 b=qG3KjJXcehhE/9FG/drM9DNxdbQ2MWGCysS7qdkm5YCnEFDpF0rv3bgueofRQSqHLmLJ
 5qMVCzEv0mukcyFY6ne/01W27cWnGHwj1QPMKtqmkvSmFV+9bsy0P1UdJ4cUR+J8clIO
 AIbgGvzLQfQRsrIt+H5vttEmUGlIaP0LyFP2S3MKh9V7/y0EZ7UEcC2FkiXoPzAn9Cvh
 OtIa8Df8ZDSGdzpveiGf7FGDd+wE/VTdRJHYgQ8V92daL9Y0pxelpO8zqo+Z+FnqiIja
 hGRpmKg0VcgOJKKBdppbX2Nkp2fIZtzQLDB9C4kJJJsasdFgeFzv16OOM1gD4d/Gr9RZ qw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2qvqcssfer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Feb 2019 23:56:00 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 25 Feb
 2019 23:55:59 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 25 Feb 2019 23:55:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7krqOTU/Ntc8ur6uMNMzLeP/uUJuxPZFxr66ZlmqWv4=;
 b=riI33dfn8m1QQtWWXPX1ob/L3zi1yap6XRSspipRgfWTWjk8bj/0XE+zcNXxzghK09JI3Mj2kbT/wwuWTHDZfnvCNb3fif6SkL9y84QQrdI/ADdvntz+5VziA2R2XbZnTrakf5aiO8lG9JimNvxd2F7gLs7RGjZRWWZ8p5+NA1I=
Received: from DM5PR18MB2135.namprd18.prod.outlook.com (52.132.143.32) by
 DM5PR18MB1196.namprd18.prod.outlook.com (10.173.213.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Tue, 26 Feb 2019 07:55:54 +0000
Received: from DM5PR18MB2135.namprd18.prod.outlook.com
 ([fe80::a567:1b91:514:5e30]) by DM5PR18MB2135.namprd18.prod.outlook.com
 ([fe80::a567:1b91:514:5e30%8]) with mapi id 15.20.1643.019; Tue, 26 Feb 2019
 07:55:54 +0000
From:   Jan Glauber <jglauber@marvell.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mahipal Challa <mahipalreddy2006@gmail.com>
Subject: Re: [PATCH] crypto: cavium/zip - fix collision with generic
 cra_driver_name
Thread-Topic: [PATCH] crypto: cavium/zip - fix collision with generic
 cra_driver_name
Thread-Index: AQHUy1ZnmC4fqf1kOU60Q/oSSDq40qXxuq6A
Date:   Tue, 26 Feb 2019 07:55:54 +0000
Message-ID: <20190226075545.GB15176@hc>
References: <20190223082323.4126-1-ebiggers@kernel.org>
In-Reply-To: <20190223082323.4126-1-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0102CA0037.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::14) To DM5PR18MB2135.namprd18.prod.outlook.com
 (2603:10b6:4:b8::32)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.5.206.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9567dfa3-7ffe-4667-2985-08d69bbfd59a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR18MB1196;
x-ms-traffictypediagnostic: DM5PR18MB1196:
x-ms-exchange-purlcount: 1
x-microsoft-exchange-diagnostics: 1;DM5PR18MB1196;20:CN+Pd+ghbW7nlQbwlHoMXcl5NGXlkUwLbe6pVIeMVgJq+nw54iOONUm4xiErRuPEwdwdQ7L5nwppcYruEcTM7cyneTIpWS2ThZz9l4GwGLc8lXm5Wpy19AbXkUHvKcKLfbTqQezTD4SINvjEuxtiyMSPDxyG61gR7bOBYx5N978=
x-microsoft-antispam-prvs: <DM5PR18MB1196C4A58FC4A7B5A9A2E593D87B0@DM5PR18MB1196.namprd18.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39860400002)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(97736004)(66066001)(26005)(486006)(52116002)(11346002)(6246003)(476003)(76176011)(446003)(99286004)(102836004)(386003)(6506007)(1076003)(33716001)(186003)(53936002)(81156014)(81166006)(256004)(33656002)(68736007)(8936002)(8676002)(2906002)(86362001)(966005)(106356001)(6116002)(3846002)(71200400001)(6916009)(229853002)(6512007)(54906003)(25786009)(9686003)(105586002)(6436002)(316002)(305945005)(6486002)(5660300002)(4326008)(71190400001)(478600001)(14454004)(6306002)(7736002)(41533002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1196;H:DM5PR18MB2135.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /Qk3Oyaq2E5dxAzDqI24XXzQyr/tdPYFeg7VkTVuY55g/K/yRCTxgLh78FSiEnA3xV5UZ7MuDp6VDA+AB232b+R8mso3vW3rTI84cxfm+eqhti+WpYg8pHBaQQUToH9NG4koK5hn1lnWuHbv30mvv75KT5mE1zipxFSmiQ95pz97CjRFxY/SEMHhrNEgBf/Q0JYjJChrAgAstaPRU2998UlnGx/TrU0FzhC4Q+eQdVQTbaAvPQCBtsBGwlNqYPsuOYU14ovrvDpl1R1Yp8TAPrhWQme32SEFos4+sqBh51n0J0YfjGmVw/JZOTCaXX4XmmBKWcyfbVugqhyLzvDpAWQGZqR4i7vyTP5u4GxFwL1vPunPrQz/PdgpBi1xFSZMef0hHkCl0YAZidbaF2BqYPZs9psc8IPVY45jSoWrnGM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC6464BABAC43943A5DF9F8615511E3B@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9567dfa3-7ffe-4667-2985-08d69bbfd59a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 07:55:53.3775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1196
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-26_06:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=871 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902260061
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 23, 2019 at 12:23:23AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> The cavium/zip implementation of the deflate compression algorithm is
> incorrectly being registered under the generic driver name, which
> prevents the generic implementation from being registered with the
> crypto API when CONFIG_CRYPTO_DEV_CAVIUM_ZIP=3Dy.  Similarly the lzs
> algorithm (which does not currently have a generic implementation...)
> is incorrectly being registered as lzs-generic.
>=20
> Fix the naming collision by adding a suffix "-cavium" to the
> cra_driver_name of the cavium/zip algorithms.

The patch is fine, basically the same as:
https://marc.info/?l=3Dlinux-crypto-vger&m=3D152968599829763&w=3D2

Shouldn't we also rename deflate to deflate generic?

--Jan

> Fixes: 640035a2dc55 ("crypto: zip - Add ThunderX ZIP driver core")
> Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
> Cc: Jan Glauber <jglauber@cavium.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/cavium/zip/zip_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium=
/zip/zip_main.c
> index e6b09e784e666..a8447a3cf3665 100644
> --- a/drivers/crypto/cavium/zip/zip_main.c
> +++ b/drivers/crypto/cavium/zip/zip_main.c
> @@ -351,6 +351,7 @@ static struct pci_driver zip_driver =3D {
>=20
>  static struct crypto_alg zip_comp_deflate =3D {
>         .cra_name               =3D "deflate",
> +       .cra_driver_name        =3D "deflate-cavium",
>         .cra_flags              =3D CRYPTO_ALG_TYPE_COMPRESS,
>         .cra_ctxsize            =3D sizeof(struct zip_kernel_ctx),
>         .cra_priority           =3D 300,
> @@ -365,6 +366,7 @@ static struct crypto_alg zip_comp_deflate =3D {
>=20
>  static struct crypto_alg zip_comp_lzs =3D {
>         .cra_name               =3D "lzs",
> +       .cra_driver_name        =3D "lzs-cavium",
>         .cra_flags              =3D CRYPTO_ALG_TYPE_COMPRESS,
>         .cra_ctxsize            =3D sizeof(struct zip_kernel_ctx),
>         .cra_priority           =3D 300,
> @@ -384,7 +386,7 @@ static struct scomp_alg zip_scomp_deflate =3D {
>         .decompress             =3D zip_scomp_decompress,
>         .base                   =3D {
>                 .cra_name               =3D "deflate",
> -               .cra_driver_name        =3D "deflate-scomp",
> +               .cra_driver_name        =3D "deflate-scomp-cavium",
>                 .cra_module             =3D THIS_MODULE,
>                 .cra_priority           =3D 300,
>         }
> @@ -397,7 +399,7 @@ static struct scomp_alg zip_scomp_lzs =3D {
>         .decompress             =3D zip_scomp_decompress,
>         .base                   =3D {
>                 .cra_name               =3D "lzs",
> -               .cra_driver_name        =3D "lzs-scomp",
> +               .cra_driver_name        =3D "lzs-scomp-cavium",
>                 .cra_module             =3D THIS_MODULE,
>                 .cra_priority           =3D 300,
>         }
> --
> 2.20.1
