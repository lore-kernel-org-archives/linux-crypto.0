Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A42C64ED6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Feb 2023 07:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjB1HLV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Feb 2023 02:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjB1HLT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2023 02:11:19 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E878A20544
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 23:10:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuNOp/E9kfJDHxmPt3iD+legEpgK+onh6YEx7OthNlm84Z0JFWjFNffZh5omHipinzkWc2iNKVMtU6CKLr2LfWLMZhMDLcbW+Tgy1nrDu6J97jnampLqvELv3lobsmkYzte/VRtnPM1wfaM6tSV8J8sVVROZOu6xxfwT5DRwQhxfC4aHVqQeZJY7R2bIxtegtS47KOz1KNLM0Eth2RXxia3k6ApIY53qtSzd0QXmfikZYbC5fY9aEPS3Zz1W4z678EEUpO3aI3Cfjb9oBFpCq56/95cNKYb5yEUCsnuFJs/ubmJ/+wSO+AgY3CLWzXoq9rr8GLsBfsujSWdQXiquVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkkbWu9FOfMzg3Nt9B4kAUVuWtsG1DGst976/KF/8Rk=;
 b=dmqP5UQTS7bcoXnrun/03O+kCezzFjOu0NHaxRrENM3FkEHqZwLpIuEQFAP8DLpCq+xNjc4X/V+wcfOVU9A4Iigw7VCV3CEt2EAVTICg87nsUBEEo4HoumLmIPFapHm86gOkD0gd28cJM28TdvNXk6vSHegX4HHTxok0ZCq0bxbC4NXCktDr9To7I4EAbfdECMdzCBhE4eZ8wHEN1IeGTo+ybb/bdZvtkqjuxMbr3LfyIeQ7EYyxYir1fClrBuFwW2kl6yXcE1eP2/E4OXQ86XlrK7Fmy5JwBo2/hM1wT6mbOPSut+rbYu6LFghNW2qI44iXkKY2BfvlM6C2l5LWhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkkbWu9FOfMzg3Nt9B4kAUVuWtsG1DGst976/KF/8Rk=;
 b=F2ixJJgR8ZZFIFpMoQctmGCdP753rWJirKZEv1sX5OqqggzUbsl1mH9Q+siwr5YdOHC3E7kYCPuti1O49ALODezNbk/xsrKSPpAtoB0wEIKeP8zi+bxgPyDEwkXg2uy8l+rLmIGY0JZwGQYQRnomC6Tq9+JVT8WRCi8iQLcVwBk=
Received: from DU0PR04MB9563.eurprd04.prod.outlook.com (2603:10a6:10:314::7)
 by AM8PR04MB7859.eurprd04.prod.outlook.com (2603:10a6:20b:24c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 07:05:28 +0000
Received: from DU0PR04MB9563.eurprd04.prod.outlook.com
 ([fe80::a518:512c:4af1:276e]) by DU0PR04MB9563.eurprd04.prod.outlook.com
 ([fe80::a518:512c:4af1:276e%4]) with mapi id 15.20.6134.026; Tue, 28 Feb 2023
 07:05:28 +0000
From:   Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Subject: RE: [v2 PATCH] crypto: caam - Fix edesc/iv ordering mixup
Thread-Topic: [v2 PATCH] crypto: caam - Fix edesc/iv ordering mixup
Thread-Index: AQHZSoUr6Ga2a3gIu0iZD2WOgpJkD67j8M7g
Date:   Tue, 28 Feb 2023 07:05:27 +0000
Message-ID: <DU0PR04MB95635FED35AA44AEEC2C69FE8EAC9@DU0PR04MB9563.eurprd04.prod.outlook.com>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org> <Y47BgCuZsYLX61A9@gondor.apana.org.au>
 <Y47g7qO8dsRdxCgf@infradead.org> <Y47+gxbdKR03EYCj@gondor.apana.org.au>
 <Y61WrVAjjtAMAvSh@gondor.apana.org.au> <Y651YoR58cCg3adj@gondor.apana.org.au>
 <DU0PR04MB95635D72885111458C50DB6F8EA89@DU0PR04MB9563.eurprd04.prod.outlook.com>
 <Y/iO3+HbrK0TnDln@gondor.apana.org.au>
 <DU0PR04MB9563F6D1EFBC6165087D51EF8EAF9@DU0PR04MB9563.eurprd04.prod.outlook.com>
 <Y/xpFtBoamuBCNfi@gondor.apana.org.au>
In-Reply-To: <Y/xpFtBoamuBCNfi@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR04MB9563:EE_|AM8PR04MB7859:EE_
x-ms-office365-filtering-correlation-id: c1d2277f-dfbe-4bac-6338-08db195a2bf7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zn+9t93PybZn0VmlxR0UOzl7hRo4dhH4jqw8D1tW9sZfAX+pz/WJyYMfg/xo7DkBxVcIXJsQpsa3Csa0jrf8o4bgqZank7U8zAFCROTA4serx7Blh0NqQnUzreefOSkJ+E4i82Kqza+b7nDvniYrUyTPK8tqJfxqkKNm26ViGZhTGcfJPIL0lJP2NyFQgTuPDGnkssJpNeEQyqS465kFA/YHXQlC6jXK0vOV7D1EWxMCm53ndFr9Z2a2JXguKNxZ80FZj/0vjF9eV1npQvvysqggkDSXDoNe3o5ddX4Zgthk9vmX6paLtB/pSaih65fRugRmY71PK69xna13GFJX/KfZ1xyXf7tKNkdLcouoWudsGVBKSLxkNzmTRchxIzx+3QqXAI9b0AtHuYnd0au5ho3PxtelCiAOZQ4L8D/NWUEdrjee2vrurBqjPZ7Q5ZwQyvD066aAzM1AhGMStVm1CaWHVBx2OSo7ezH9nry9qaPmiU7iHpjAKrhrmnhgU3iHl+6izrJuxxWmWj7g5TSS3ANeQ+sylwDHty4CxscGtYhyD1x8X189Wmba/fWKKZZrJua1AC5Jn/tj33lq+GY5CzRXdMm8yRNf8NPM87znBLANajSKOBpefGQOGtf47W0g1JpvtOLjAd4u07eO32uhD0Ma9SY6oftqMxPgan/tiG5jJZ3FdNw8E0emOeypmKAI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9563.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(52536014)(66946007)(44832011)(2906002)(8936002)(41300700001)(66446008)(5660300002)(66556008)(4326008)(6916009)(8676002)(64756008)(66476007)(76116006)(54906003)(83380400001)(316002)(45080400002)(71200400001)(7696005)(478600001)(6506007)(966005)(186003)(9686003)(53546011)(26005)(55016003)(33656002)(122000001)(86362001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OIeBdTP2lLYSULTcIDhaqc5LUWoPv++Vh8tOUmayX8W8TJiAdKxkYJqkPRbm?=
 =?us-ascii?Q?2lzx8Pnwf5Y+MVcqJswQWR41QUSOEZWlc1HmQHYKpZwIkOpCKu7uWfb8BL9A?=
 =?us-ascii?Q?qsD5IUV/hkGhW7BtykdZ/qpQIt05wOzA13a40Ys2QaXMcIYSTTcldP2D7sSh?=
 =?us-ascii?Q?5zgtFeUJUP+Sw19arDNr8W8TNCR91ZP+QJ/LQWV74cgyQCcXIEGnQQTTcnOD?=
 =?us-ascii?Q?hC5IJ8a8fTUkdOzOe1/dv2mMIrovwzPVzMnuOA8yeUnfs+FslYaLxie24b7R?=
 =?us-ascii?Q?1uwaoJpgKbzwUzN6fWHWodYMWMzwTq9R1DzRAIpUSVio/O1fFbNdRm2WTiMB?=
 =?us-ascii?Q?ZJfp038ah5WF/U3SU+r2kutVbW3yzxcNAj4Homa7/lOfEXqz6D0+X/Ko02/G?=
 =?us-ascii?Q?/5vvXZgXNXe+mzdKeFVeTWO3ZW82bAdU5Daur1hValtqZkrCkCWinf1V/Ai7?=
 =?us-ascii?Q?5ri7LCQu6S5BSTtqfKskHWZpcqA/zjl76mhDa6j2Wx7UAoVogkTkYpggZeJA?=
 =?us-ascii?Q?8OU/Ap4N3yLI15y9xriGuqJWQ3ElHyu0lh6YeRipe9aeyNhHjsHDH6cU8MUL?=
 =?us-ascii?Q?iUXHfzVcAfomAbxCGCaSzWlP68XI3cbXV/NAm8FnbYjgEL4Jm5rf/hc0WaYt?=
 =?us-ascii?Q?FLBAgB2lmRCF5bGaz45KtoMjGWrG84/nuZT/qzSmPCsKFWPajaXGMjryhPmR?=
 =?us-ascii?Q?c2Wo89zJnakAUYii+P45gtKPLnt+qGJQ7ZEo6ExYx70t1JiQ4PQTRBm7fA1g?=
 =?us-ascii?Q?u/T2N1BHqHdHGhnRdw/SH2p5Zh1I8UICjEnMzIvCS7J54TMed2+5N9IQIglp?=
 =?us-ascii?Q?4pi+6jkRd8kv9rQxMWy27d3v31j166yVAsSeI2ooY7HW7P5miG2Yx6/yU7Jm?=
 =?us-ascii?Q?X/GVfAVSYuNaIwlmW6I54cZuCmcG3dYuP9SxmO4ZDZLprMpZ5EE2qOPhh3U5?=
 =?us-ascii?Q?CuFvucgZadp76VpO5THoJeO9ia6urwFgzbPKDVzsbgls7aWsdWw0Ll3RQo9y?=
 =?us-ascii?Q?0GFGpSjJVMOtSYLNSWUMy6YKQPFiIJH1A6i5X/+0mr8QQ4F6HBhxfm1R6PK/?=
 =?us-ascii?Q?xxiUya6UsqPEZ8cs6/x1gXR5uWAzJDcfpmOev0KrtcRwwr63rd2MYFQ8nuee?=
 =?us-ascii?Q?pd3gccxrWaXohlRjR5nlx32o9Os6+a6XVYxuBxA9Pk6/B2nzbtFZbEbmS97x?=
 =?us-ascii?Q?G1pmbYhtc+fKnBZk9KMCheZ9IW23SDM3wzOyu9MQZB26UdJiDepC+5yR1Z3+?=
 =?us-ascii?Q?ChBtNBn3rAzG/FIDN6A22gbfV2ZEXNgnxDnfQq5m0LkfeEM3rwrPDSB/xGRK?=
 =?us-ascii?Q?UEaPwvz+XgX43oZDaoCNzL7UZGw+kytJbcqmiZY/If44FIH1XtLxSWPB5ddK?=
 =?us-ascii?Q?racD6bE38JDi8x+5QKbC78DTmYysccIlrDSJRuS+TFNvly0qijKKp08b05sm?=
 =?us-ascii?Q?0WjzOtUvvKSGqlVjOK6bMOz4agFiJuYfzcvq2FDeTLIpQ+Tt7hsaEivqtCBp?=
 =?us-ascii?Q?7W2H2PyswHUuure9pfHyjl7an/Onq1gbO2RoGYnT1Hx5oT4TgEjUqwox4Mat?=
 =?us-ascii?Q?mHYjqoDlMHVTRXgZqCU0BnZBRvNP5uRma6TZ58TmVjh3L9B6mJATWR4ZW7Uo?=
 =?us-ascii?Q?8A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9563.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d2277f-dfbe-4bac-6338-08db195a2bf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 07:05:27.7816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zZyhHAQKskLx3m0XMAA4WoWbFpIZ3eTwTTKGMpTMTVECFbeaeAEQA8MA0o4R5khrvi/IR1YJ1lmCrL+upJzrVaJmU6DxXbnQjR26p8gbt2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7859
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Changes are working for me.

Thanks,
Meenakshi

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, February 27, 2023 1:56 PM
> To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; Christoph H=
ellwig
> <hch@infradead.org>; Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>
> Subject: [v2 PATCH] crypto: caam - Fix edesc/iv ordering mixup
>=20
> On Mon, Feb 27, 2023 at 05:20:32AM +0000, Meenakshi Aggarwal wrote:
> > Hi Herbert,
> >
> > I have tested your changes, not facing a kernel crash now but still ker=
nel
> warning messages are coming:
>=20
> Thanks for testing! Indeed, I forgot to update the IV calculations on the=
 way out:
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
> index 4a9b998a8d26..12b1c8346243 100644
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
> @@ -1000,6 +1004,13 @@ static void aead_crypt_done(struct device *jrdev,
> u32 *desc, u32 err,
>  		crypto_finalize_aead_request(jrp->engine, req, ecode);  }
>=20
> +static inline u8 *skcipher_edesc_iv(struct skcipher_edesc *edesc) {
> +
> +	return PTR_ALIGN((u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,
> +			 dma_get_cache_alignment());
> +}
> +
>  static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err=
,
>  				void *context)
>  {
> @@ -1027,8 +1038,7 @@ static void skcipher_crypt_done(struct device *jrde=
v,
> u32 *desc, u32 err,
>  	 * This is used e.g. by the CTS mode.
>  	 */
>  	if (ivsize && !ecode) {
> -		memcpy(req->iv, (u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,
> -		       ivsize);
> +		memcpy(req->iv, skcipher_edesc_iv(edesc), ivsize);
>=20
>  		print_hex_dump_debug("dstiv  @" __stringify(__LINE__)": ",
>  				     DUMP_PREFIX_ADDRESS, 16, 4, req->iv, @@
> -1683,18 +1693,19 @@ static struct skcipher_edesc
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
>  	edesc->mapped_src_nents =3D mapped_src_nents; @@ -1706,6 +1717,7
> @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_req=
uest
> *req,
>=20
>  	/* Make sure IV is located in a DMAable area */
>  	if (ivsize) {
> +		iv =3D skcipher_edesc_iv(edesc);
>  		memcpy(iv, req->iv, ivsize);
>=20
>  		iv_dma =3D dma_map_single(jrdev, iv, ivsize,
> DMA_BIDIRECTIONAL); diff --git a/drivers/crypto/caam/caamalg_qi.c
> b/drivers/crypto/caam/caamalg_qi.c
> index 5e218bf20d5b..743ce50c14f2 100644
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
> @@ -1204,6 +1207,12 @@ static int ipsec_gcm_decrypt(struct aead_request
> *req)
>  					   false);
>  }
>=20
> +static inline u8 *skcipher_edesc_iv(struct skcipher_edesc *edesc) {
> +	return PTR_ALIGN((u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
> +			 dma_get_cache_alignment());
> +}
> +
>  static void skcipher_done(struct caam_drv_req *drv_req, u32 status)  {
>  	struct skcipher_edesc *edesc;
> @@ -1236,8 +1245,7 @@ static void skcipher_done(struct caam_drv_req
> *drv_req, u32 status)
>  	 * This is used e.g. by the CTS mode.
>  	 */
>  	if (!ecode)
> -		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
> -		       ivsize);
> +		memcpy(req->iv, skcipher_edesc_iv(edesc), ivsize);
>=20
>  	qi_cache_free(edesc);
>  	skcipher_request_complete(req, ecode); @@ -1259,6 +1267,7 @@
> static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_reques=
t *req,
>  	int dst_sg_idx, qm_sg_ents, qm_sg_bytes;
>  	struct qm_sg_entry *sg_table, *fd_sgt;
>  	struct caam_drv_ctx *drv_ctx;
> +	unsigned int len;
>=20
>  	drv_ctx =3D get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
>  	if (IS_ERR(drv_ctx))
> @@ -1319,9 +1328,12 @@ static struct skcipher_edesc
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
> @@ -1330,18 +1342,24 @@ static struct skcipher_edesc
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
> +	edesc->src_nents =3D src_nents;
> +	edesc->dst_nents =3D dst_nents;
> +	edesc->qm_sg_bytes =3D qm_sg_bytes;
> +	edesc->drv_req.app_ctx =3D req;
> +	edesc->drv_req.cbk =3D skcipher_done;
> +	edesc->drv_req.drv_ctx =3D drv_ctx;
>=20
>  	/* Make sure IV is located in a DMAable area */
>  	sg_table =3D &edesc->sgt[0];
> +	iv =3D skcipher_edesc_iv(edesc);
>  	memcpy(iv, req->iv, ivsize);
>=20
>  	iv_dma =3D dma_map_single(qidev, iv, ivsize, DMA_BIDIRECTIONAL); @@
> -1353,13 +1371,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(st=
ruct
> skcipher_request *req,
>  		return ERR_PTR(-ENOMEM);
>  	}
>=20
> -	edesc->src_nents =3D src_nents;
> -	edesc->dst_nents =3D dst_nents;
>  	edesc->iv_dma =3D iv_dma;
> -	edesc->qm_sg_bytes =3D qm_sg_bytes;
> -	edesc->drv_req.app_ctx =3D req;
> -	edesc->drv_req.cbk =3D skcipher_done;
> -	edesc->drv_req.drv_ctx =3D drv_ctx;
>=20
>  	dma_to_qm_sg_one(sg_table, iv_dma, ivsize, 0);
>  	sg_to_qm_sg(req->src, req->cryptlen, sg_table + 1, 0); diff --git
> a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c index
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
> m%7Cfa91dc99b1b147f0b13008db189c4c71%7C686ea1d3bc2b4c6fa92cd99c5c
> 301635%7C0%7C0%7C638130831812121500%7CUnknown%7CTWFpbGZsb3d8e
> yJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7
> C3000%7C%7C%7C&sdata=3DUScavImC4%2FcLjGiqTDANWb%2FG1cOg4J18Ijfoicl
> %2FRSg%3D&reserved=3D0
> PGP Key:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.ap
> ana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C01%7Cmeenakshi.aggarwal
> %40nxp.com%7Cfa91dc99b1b147f0b13008db189c4c71%7C686ea1d3bc2b4c6fa
> 92cd99c5c301635%7C0%7C0%7C638130831812121500%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6
> Mn0%3D%7C3000%7C%7C%7C&sdata=3Dub4VeaCOKFt4iDVcxy3jnN0EXJBPJZEs%2
> B1CrnK5gimg%3D&reserved=3D0
