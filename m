Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12A6C64ED8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 05:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjB0FUj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 00:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjB0FUi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 00:20:38 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2049.outbound.protection.outlook.com [40.107.21.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102721116D
        for <linux-crypto@vger.kernel.org>; Sun, 26 Feb 2023 21:20:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9hXEWOP9QywzP17kg+PAxVSZEKI0sP/qOosJKuA+2aFpjdvOtTAX+mG9Bjj9XPaGmsiiTsg+Zsu5JIskwwBc5upbC7LRcZeMxoiILuKgrUVXO4ijNNLWfJExVh5MCpVhqtxAx2fQJ+1TNDo3IvM2+ZSee+pkqKgBMrnh0Wzm3IokPzKPgoLYjajjD/rcJ1pQgkp8ZR809stEmXtGeCnwKHaSH1uB9NNUvU2251iy4coq7UismS6/YMTLm+x4v/TAbMfD4kOeuC9hE7xnzqdKJAvhDaCamoo4cvEvlcnU/bCn+P/jf388hsWXAbgLyWuyYQk/6Re5n+GYYI18LnNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLFcrLqUK8KthkbcO5/n2k7hIkh+COVpiUVA9Uj/ATs=;
 b=ntUqHns1azPWcXpDNBGRBRWbcdkK5FKYLFAPfRdJ3Oh5e+FN0Ukj5YSxUsEkWouiD8jThNezbnbKMAtPOK5rHURHEm6iIyKGoacOdo/N2pWAZa0EASRY+hJ6Y64Ar2Sk2GK8faf12Ymk/EeZIVm8+64vjaLJfSuAk9FmhqfzzAZiyxVNb99w9QPhsSYnUAJ/QmP8PyZm3UFSMYe8KlMYiJhl1WPu58/P7QH0FLDkBy1tuJHsqrIfc0qj0X8iJ4ONMo2txJD8m+gSmypj+MEgomY2fUdQZLemUXy5KSgDfrI1BnbIkS7ABUrE1wNxBj2Q9OoMWMOtC25INXWzYLj9Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLFcrLqUK8KthkbcO5/n2k7hIkh+COVpiUVA9Uj/ATs=;
 b=pTcseAu81XlO4F2vP9id/PpqVzVucjp7Jok/hZOf98S9NN/yfCKppHwSiNG/pYedntQ423FJ0pbNFKcJF8uREGg0iytS6vptgn1yFGnTJFoWZ6ul9dmss63NKJTAxGYNFLAeSPcldGaVbkr4kudT3bpkcFr0+qgWRGvDCR6nICI=
Received: from DU0PR04MB9563.eurprd04.prod.outlook.com (2603:10a6:10:314::7)
 by AS4PR04MB9458.eurprd04.prod.outlook.com (2603:10a6:20b:4ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 05:20:33 +0000
Received: from DU0PR04MB9563.eurprd04.prod.outlook.com
 ([fe80::a518:512c:4af1:276e]) by DU0PR04MB9563.eurprd04.prod.outlook.com
 ([fe80::a518:512c:4af1:276e%4]) with mapi id 15.20.6134.026; Mon, 27 Feb 2023
 05:20:32 +0000
From:   Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Subject: RE: [PATCH] crypto: caam - Fix edesc/iv ordering mixup
Thread-Topic: [PATCH] crypto: caam - Fix edesc/iv ordering mixup
Thread-Index: AQHZSDlSYbMeKe5lF0K+qHGPz5S9xq7iRZrQ
Date:   Mon, 27 Feb 2023 05:20:32 +0000
Message-ID: <DU0PR04MB9563F6D1EFBC6165087D51EF8EAF9@DU0PR04MB9563.eurprd04.prod.outlook.com>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org> <Y47BgCuZsYLX61A9@gondor.apana.org.au>
 <Y47g7qO8dsRdxCgf@infradead.org> <Y47+gxbdKR03EYCj@gondor.apana.org.au>
 <Y61WrVAjjtAMAvSh@gondor.apana.org.au> <Y651YoR58cCg3adj@gondor.apana.org.au>
 <DU0PR04MB95635D72885111458C50DB6F8EA89@DU0PR04MB9563.eurprd04.prod.outlook.com>
 <Y/iO3+HbrK0TnDln@gondor.apana.org.au>
In-Reply-To: <Y/iO3+HbrK0TnDln@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR04MB9563:EE_|AS4PR04MB9458:EE_
x-ms-office365-filtering-correlation-id: 82ec9b7c-a703-4dcc-06ab-08db18825946
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wLMSJGAqeWyqT+o2rSSaJWffWvtY5MrTlBb4D9VAgNH1OQHjt+Y7IeQHJG8z4QI4DLzAJbX/u6iyNMELEw298wFVY+3A+a8kmIgtQrsJVRzAv26GnpGIu1ULtc8skAWppzPBApQISv9gna5gR0134MsB16yYtW/Oec6dmJ0w0nwXosUQ11IyS/GDCS+ExApXOXoKKQI9D8wmhldxVd8XQhqpoIgDF/SL3j/UrPJxWmf86R1utxn2p5xcllhIm5dzGjKUUn1NA3WZcOfOFbuPKwxVhxjBIa35NsRcM/N8s5fv8zQg7uZji6e2wO5LyIrERRBdZG8qA3Jwo2JR/1AFAbSWpiUGfGPUxwxFZrEQFrB0t4vthie5Hxrtwvy2A6KC9Hx1R6ipbU5lv/W9nGzQTjFw50WVgyCy1tF6W7q97KRTkjNRF1S2MdAJlTpTMMGzDhQ/F4pZKtirNSM+vqLuu+ibw8rWq7/Xnl05nzJIDlCYogIh6vwxXI4+Dun3m5FjOgYC/wNA4T5rAzLeA8bAel8SbHptpNqFToShiWxxqtProSW7oG6HgT4xfA+Xu01QYECMYgi2+YVoo0tpUUO6FwfT65dreStohP1i7LPYtoG8UIEML/leGx/aATYaOGgqW4+Lznb2JBIY5LK+et/gAjjt0MhGKtFFNC7zAOU5rrmZIMuuSpjg7J8AqZvLGPWtTkAi8C41ydMVpkUpbqkLtSDc66bI5c194hoJVDFJATk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9563.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199018)(83380400001)(2906002)(44832011)(52536014)(5660300002)(122000001)(55016003)(38070700005)(41300700001)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(38100700002)(8936002)(4326008)(6916009)(7696005)(966005)(45080400002)(86362001)(53546011)(9686003)(186003)(26005)(6506007)(71200400001)(478600001)(33656002)(316002)(54906003)(505234007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?US3IA+f2NdWNnzX02VOdQmMpR8fa7wks2mL0gQrloIhe3GU4HrsbOHEFzbVJ?=
 =?us-ascii?Q?Dhr4EAKdsA4cJRFPzEtaZAS4+MCFs6AWgW71GQOVKHsTlpzPY77IaTspPzb/?=
 =?us-ascii?Q?luOJ9z9V1n5XOBx0O6SLngWAA32+wmCqjYwckMXxg09W+UFfxT2caYoix9RJ?=
 =?us-ascii?Q?Nc9Hd5mXMOqN/u38bGbh4x9iHq5aXF0BoqGrh6AP44DqZK0CziUfSFZQ/Oz0?=
 =?us-ascii?Q?ZB0Y2HCIKDwKLrMx6n7guX8EDx0dFTWyUuNybpO+kStfwwyzcSSq6UFy6irF?=
 =?us-ascii?Q?SHE0nOkt0dm7x8GlojcEW1gs+dEKcey65X5Mjnl1jNdIsc5/v5otcHqtWJaB?=
 =?us-ascii?Q?KmEYsCbRh8X5gXOHldjMT132Iy/4r2lLhYO2WM6/+Mlx7c1kej6odnq78n0f?=
 =?us-ascii?Q?XOXHxJ0K9ubFpFbgWW/aIy/dTpwt1oEw3g9xZAORckKDg14y/xgozpAKZtC7?=
 =?us-ascii?Q?PY8RagIfd13h+pc5Mi8Qd/CDQZ+qR392kD5+KaA3DEThN4n8VbY3ZR7f/HkC?=
 =?us-ascii?Q?ZU7c1RvNmBQg17A1zeBsSQ+xwu5AW6NgiLp032fyEPapmCBKuiVTEZdgKme1?=
 =?us-ascii?Q?gIjfLd51Z5dWLqZNB392uMGKfrqGj9KGRR0mQa6X+tIC7kLo/iAlkGmIEkzm?=
 =?us-ascii?Q?UdGuO4cbTVTQx6Q1gzFNMm+hVGqdC83ZJxVhW4+stloeIM+T7FGNfqF0XF6E?=
 =?us-ascii?Q?vTLpqf7cxiEjsHsLcqkijqqsQyQ4akg2PMNHPhFDtbIkG8GLpWZ7W91JUhPj?=
 =?us-ascii?Q?6eUrwJPHIYYXuNj8a/dxbP30fBDk/LjZvMMOU8MkvqOdIsxXsf2iV+jZokCZ?=
 =?us-ascii?Q?S8oihQ615HhL0tN+JVDPGhejqlVpu7ThFQCXRQ0YrdyRGq1MyYVDEer9/Pdr?=
 =?us-ascii?Q?3pYmfWc3rUrvSW02w2CR6PEIilSYw1ZubsVef3Fznji33VnCNsDtRin/6LlW?=
 =?us-ascii?Q?ESDqcE9ZTD8QHnB42K+W9eHp7ibMkul+03PL5RL7cVjEvbxBVxqWAXZ56zpq?=
 =?us-ascii?Q?BnYgT/69hmDx+rmWGyBScNsgzJFY2PlWqDKMt5BLfszZoQZZtylFOEF/2WeW?=
 =?us-ascii?Q?D/qyKdXmNsxGzO6FyyJadI8tCnDPfeGS8CuztaIlRZuU4Gy4e5SjPKKWYBw0?=
 =?us-ascii?Q?qAmNAw31aPuudmhlQTEbkvMgNH2J/N7DREoLFs+gByk5zIwOSUzc5oWalcb6?=
 =?us-ascii?Q?ZqCYWHM35ruy+CdvEakpd2ENFUFS3CCb3Y8VBYpMuy6d0cmTz0QZdDdkJ6f6?=
 =?us-ascii?Q?1o2hhVXSrSB4PXHJ0yhkLGCBmZk4TKsC9T1aYD6IfD3oo8JJen8OKhjMQ1Tl?=
 =?us-ascii?Q?ILV1iCZpnsBgrlFK5oawASCxxbg+B6E5U0STRqEdfKnJTOBBRW31LXx1am5x?=
 =?us-ascii?Q?G+kdXPhy64KTFchCuxumbtPKBVXCjukodZxyMqjzAXbC2O0Ibs4ck2FvinUC?=
 =?us-ascii?Q?tMP/pUVD7TbUEx1G0rlirWvgl4uibAnFZqJkpDYyezl4BzKxHDhBdSMDX6Zd?=
 =?us-ascii?Q?AvJpCKKTwXQiDhVx13Czp8VKp38ikq+agZZlj3L8NkD0HKc74yGCIhbLMZeS?=
 =?us-ascii?Q?0TL0GH05YF4NNMt6DDUA7HI7eXQ1WMr9urHCz43fSz+NkXOrz1zv7Zd53lEj?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9563.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ec9b7c-a703-4dcc-06ab-08db18825946
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 05:20:32.5009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Za3YZO3y4FVrLHZYUJ8ZJqwwDsIdSDzHzpTjLUq/EQjmtXj1OqKf16QvMw4LOAueKXpj28k63P0n8f/ijPSF4JzqShgIoKwnx4MOKNGnQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9458
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

I have tested your changes, not facing a kernel crash now but still kernel =
warning messages are coming:

[    6.359772] alg: skcipher: ctr-aes-caam encryption test failed (wrong ou=
tput IV) on test vector 0, cfg=3D"in-place (one sglist)"
[    6.371179] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    6.377645] alg: self-tests for ctr(aes) using ctr-aes-caam failed (rc=
=3D-22)
[    6.377649] ------------[ cut here ]------------
[    6.389248] alg: self-tests for ctr(aes) using ctr-aes-caam failed (rc=
=3D-22)
[    6.389269] WARNING: CPU: 0 PID: 246 at crypto/testmgr.c:6101 alg_test.p=
art.0+0x3c8/0x3d0
[    6.404400] Modules linked in:
[    6.407446] CPU: 0 PID: 246 Comm: cryptomgr_test Not tainted 6.2.0-rc4-n=
ext-20230119-04770-gb8b0d08d8447 #3
[    6.417181] Hardware name: LS1046A RDB Board (DT)
[    6.421876] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    6.428833] pc : alg_test.part.0+0x3c8/0x3d0
[    6.433095] lr : alg_test.part.0+0x3c8/0x3d0
[    6.437358] sp : ffff80000a51bd40
[    6.440662] x29: ffff80000a51bd40 x28: 0000000000000000 x27: 00000000000=
00000
[    6.447795] x26: 00000000ffffffff x25: 0000000000000400 x24: ffff125a1d7=
ad280
[    6.454926] x23: ffff125a1d7ad200 x22: ffff125a1e24d100 x21: 00000000000=
11085
[    6.462057] x20: 00000000ffffffea x19: ffffb57461018490 x18: 00000000000=
00001
[    6.469188] x17: 74757074756f2067 x16: 6e6f727728206465 x15: ffff125a1e2=
4d568
[    6.476319] x14: 0000000000000000 x13: ffffb57462e8e300 x12: 00000000fff=
fefff
[    6.483450] x11: 0000000000000003 x10: ffffb5746298ecd8 x9 : ffffb5745f9=
02b34
[    6.490581] x8 : 0000000000017fe8 x7 : c0000000ffffefff x6 : 00000000000=
0bff4
[    6.497712] x5 : 0000000000057fa8 x4 : 0000000000000000 x3 : ffff80000a5=
1bb08
[    6.504842] x2 : ffffb57462936a60 x1 : 78bd64a75e317900 x0 : 00000000000=
00000
[    6.511973] Call trace:
[    6.514409]  alg_test.part.0+0x3c8/0x3d0
[    6.518325]  alg_test+0x24/0x68
[    6.521458]  cryptomgr_test+0x28/0x48
[    6.525112]  kthread+0x114/0x120
[    6.528334]  ret_from_fork+0x10/0x20
[    6.531903] ---[ end trace 0000000000000000 ]---
[    6.536608] alg: skcipher: cbc-des-caam encryption test failed (wrong ou=
tput IV) on test vector 0, cfg=3D"in-place (one sglist)"
[    6.548010] 00000000: 00 00 00 00 00 00 00 00
[    6.552370] alg: self-tests for cbc(des) using cbc-des-caam failed (rc=
=3D-22)


Thanks,
Meenakshi

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, February 24, 2023 3:48 PM
> To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; Christoph H=
ellwig
> <hch@infradead.org>; Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>
> Subject: [PATCH] crypto: caam - Fix edesc/iv ordering mixup
>=20
> Hi Meenakshi:
>=20
> On Fri, Feb 24, 2023 at 06:23:15AM +0000, Meenakshi Aggarwal wrote:
> >
> > with this change, edesc is following IV but we need IV to follow edesc.
> > Also, we are freeing edesc pointer in function, returning edesc
> > pointer and calling function also free edesc pointer but you have alloc=
ated IV .
> So we are facing kernel crash.
> >
> > We need to fix this, please share why are you allocating IV in place of=
 edesc ?
>=20
> Sorry, my patch was completely broken.  I was trying to place the IV at t=
he front
> in a vain effort to reduce the total allocation size.
>=20
> Anyhow, please let me know if this patch fixes the problem, and I will pu=
sh it to
> Linus.
>=20
> BTW, should we add you to the list of maintainers for caam? Perhaps next =
time
> we can spot the problem earlier.  Thanks!
>=20
> ---8<---
> The attempt to add DMA alignment padding by moving IV to the front of ede=
sc
> was completely broken as it didn't change the places where edesc was free=
d.
>=20
> It's also wrong as the IV may still share a cache-line with the edesc.
>=20
> Fix this by restoring the original layout and simply reserving enough mem=
mory
> so that the IV is on a DMA cache-line by itself.
>=20
> Reported-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA
> alignment padding")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c
> index 4a9b998a8d26..c71955ac2252 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -60,7 +60,11 @@
>  #include <crypto/xts.h>
>  #include <asm/unaligned.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
>=20
>  /*
>   * crypto alg
> @@ -1683,18 +1687,19 @@ static struct skcipher_edesc
> *skcipher_edesc_alloc(struct skcipher_request *req,
>  	/*
>  	 * allocate space for base edesc and hw desc commands, link tables, IV
>  	 */
> -	aligned_size =3D ALIGN(ivsize, __alignof__(*edesc));
> -	aligned_size +=3D sizeof(*edesc) + desc_bytes + sec4_sg_bytes;
> +	aligned_size =3D sizeof(*edesc) + desc_bytes + sec4_sg_bytes;
>  	aligned_size =3D ALIGN(aligned_size, dma_get_cache_alignment());
> -	iv =3D kzalloc(aligned_size, flags);
> -	if (!iv) {
> +	aligned_size +=3D ~(ARCH_KMALLOC_MINALIGN - 1) &
> +			(dma_get_cache_alignment() - 1);
> +	aligned_size +=3D ALIGN(ivsize, dma_get_cache_alignment());
> +	edesc =3D kzalloc(aligned_size, flags);
> +	if (!edesc) {
>  		dev_err(jrdev, "could not allocate extended descriptor\n");
>  		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
>  			   0, 0, 0);
>  		return ERR_PTR(-ENOMEM);
>  	}
>=20
> -	edesc =3D (void *)(iv + ALIGN(ivsize, __alignof__(*edesc)));
>  	edesc->src_nents =3D src_nents;
>  	edesc->dst_nents =3D dst_nents;
>  	edesc->mapped_src_nents =3D mapped_src_nents; @@ -1706,6 +1711,8
> @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_req=
uest
> *req,
>=20
>  	/* Make sure IV is located in a DMAable area */
>  	if (ivsize) {
> +		iv =3D (u8 *)edesc->sec4_sg + sec4_sg_bytes;
> +		iv =3D PTR_ALIGN(iv, dma_get_cache_alignment());
>  		memcpy(iv, req->iv, ivsize);
>=20
>  		iv_dma =3D dma_map_single(jrdev, iv, ivsize,
> DMA_BIDIRECTIONAL); diff --git a/drivers/crypto/caam/caamalg_qi.c
> b/drivers/crypto/caam/caamalg_qi.c
> index 5e218bf20d5b..5d17f5862b93 100644
> --- a/drivers/crypto/caam/caamalg_qi.c
> +++ b/drivers/crypto/caam/caamalg_qi.c
> @@ -20,8 +20,11 @@
>  #include "caamalg_desc.h"
>  #include <crypto/xts.h>
>  #include <asm/unaligned.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/kernel.h>
> +#include <linux/string.h>
>=20
>  /*
>   * crypto alg
> @@ -1259,6 +1262,7 @@ static struct skcipher_edesc
> *skcipher_edesc_alloc(struct skcipher_request *req,
>  	int dst_sg_idx, qm_sg_ents, qm_sg_bytes;
>  	struct qm_sg_entry *sg_table, *fd_sgt;
>  	struct caam_drv_ctx *drv_ctx;
> +	unsigned int len;
>=20
>  	drv_ctx =3D get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
>  	if (IS_ERR(drv_ctx))
> @@ -1319,9 +1323,12 @@ static struct skcipher_edesc
> *skcipher_edesc_alloc(struct skcipher_request *req,
>  		qm_sg_ents =3D 1 + pad_sg_nents(qm_sg_ents);
>=20
>  	qm_sg_bytes =3D qm_sg_ents * sizeof(struct qm_sg_entry);
> -	if (unlikely(ALIGN(ivsize, __alignof__(*edesc)) +
> -		     offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes >
> -		     CAAM_QI_MEMCACHE_SIZE)) {
> +
> +	len =3D offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes;
> +	len =3D ALIGN(len, dma_get_cache_alignment());
> +	len +=3D ivsize;
> +
> +	if (unlikely(len > CAAM_QI_MEMCACHE_SIZE)) {
>  		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
>  			qm_sg_ents, ivsize);
>  		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
> @@ -1330,18 +1337,18 @@ static struct skcipher_edesc
> *skcipher_edesc_alloc(struct skcipher_request *req,
>  	}
>=20
>  	/* allocate space for base edesc, link tables and IV */
> -	iv =3D qi_cache_alloc(flags);
> -	if (unlikely(!iv)) {
> +	edesc =3D qi_cache_alloc(flags);
> +	if (unlikely(!edesc)) {
>  		dev_err(qidev, "could not allocate extended descriptor\n");
>  		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
>  			   0, DMA_NONE, 0, 0);
>  		return ERR_PTR(-ENOMEM);
>  	}
>=20
> -	edesc =3D (void *)(iv + ALIGN(ivsize, __alignof__(*edesc)));
> -
>  	/* Make sure IV is located in a DMAable area */
>  	sg_table =3D &edesc->sgt[0];
> +	iv =3D (u8 *)(sg_table + qm_sg_ents);
> +	iv =3D PTR_ALIGN(iv, dma_get_cache_alignment());
>  	memcpy(iv, req->iv, ivsize);
>=20
>  	iv_dma =3D dma_map_single(qidev, iv, ivsize, DMA_BIDIRECTIONAL); diff -
> -git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c index
> 4c52c9365558..2ad2c1035856 100644
> --- a/drivers/crypto/caam/qi.c
> +++ b/drivers/crypto/caam/qi.c
> @@ -8,7 +8,13 @@
>   */
>=20
>  #include <linux/cpumask.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
>  #include <linux/kthread.h>
> +#include <linux/netdevice.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
>  #include <soc/fsl/qman.h>
>=20
>  #include "debugfs.h"
> @@ -755,8 +761,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
>  		napi_enable(irqtask);
>  	}
>=20
> -	qi_cache =3D kmem_cache_create("caamqicache",
> CAAM_QI_MEMCACHE_SIZE, 0,
> -				     0, NULL);
> +	qi_cache =3D kmem_cache_create("caamqicache",
> CAAM_QI_MEMCACHE_SIZE,
> +				     dma_get_cache_alignment(), 0, NULL);
>  	if (!qi_cache) {
>  		dev_err(qidev, "Can't allocate CAAM cache\n");
>  		free_rsp_fqs();
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2F&data=3D05%7C01%7Cmeenakshi.aggarwal%40nxp.co
> m%7C02a5c1fbb5f54a893c0a08db165073cb%7C686ea1d3bc2b4c6fa92cd99c5c
> 301635%7C0%7C0%7C638128307024161720%7CUnknown%7CTWFpbGZsb3d8e
> yJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7
> C3000%7C%7C%7C&sdata=3D51qldsOV%2FNUO5VEMSd4kKbQdqIOJdEWF99Us%2
> FR01sUA%3D&reserved=3D0
> PGP Key:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C01%7Cmeenakshi.aggarwal
> %40nxp.com%7C02a5c1fbb5f54a893c0a08db165073cb%7C686ea1d3bc2b4c6fa
> 92cd99c5c301635%7C0%7C0%7C638128307024161720%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6
> Mn0%3D%7C3000%7C%7C%7C&sdata=3DME%2BROVEsFMovZ1P4Y3KOONWHwA
> ezgFgxOOe0y5fToCA%3D&reserved=3D0
