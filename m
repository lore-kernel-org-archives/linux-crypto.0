Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C9CC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 09:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 807E920656
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 09:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BwwNCWlB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKZJNp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:13:45 -0500
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:8298
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727028AbfKZJNp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 04:13:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9pDa9QgJg1qkTvG3UVp4C6Ppv8Cfcc4KxWEOGHo1UXvM/PN8gJjqG0Ww2WnDauNSM40A+AKG0VmzKKFycNTZCIPBMSgKRonrkYlNWX2yxb1OzGKUROtUkwLt+mX+3J7pmi/aPqgqWYUHNdJ+pxukCxv9y57egeRODcdco4mwRsMJ1VyzXZ5/o7/N68sUmn04lnNkTmmMKbdI0Ts6gCXLSS98onmrWOeo2T/jemw0v3XoPy69mtEz/RU8O7B4+jg8g55CzzJryk2UYlIdmfpJvoMDuLgfS4a521Js3pCPVO/3iE7GjApRbDi2mlKzy7OpIxltaAsWvOINmu9Z2xtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg+34PtvP6u0N7MyHOOoCNJq7S4yPtjOfR0bsIqizKY=;
 b=LxDA08WO4AE8B5D1nKIO6RvxuVkX7VR8nc+TvsXJfOThJp14190cxT0ErKEx3GtAv5Br7RiiOVmxfksteP0XouL0eThzftvDWi8H1UboH562eRRCIXnIE9MTMc0ddcaMxpiZT6zHhwmIn+y0HatiEPDlytOxkwLjRwtcRMemz4EXKV4JS8umGfBFAzJo8NbLGIMvjbpkxkyYgDEbjRTbrO2UNeijgSXJrU1G9IxN5yYvmeLWC/a3efhtv4pCzLdYYFoL6/I3K/7hebD9qmeYret5olaoA/Exxb/OVT4i5Z3jiwiFuFlx6ot80WO2tYONCInVHpTV8xFcKA/ii+fqbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg+34PtvP6u0N7MyHOOoCNJq7S4yPtjOfR0bsIqizKY=;
 b=BwwNCWlBd/OvXwLHk6ltqv90kZb8XpLca2nw65+8smWdOOfH0bCewZN7hySdG+i4aMFqwrhOLzfV4QjJ19i7wacSHiwOJnAUdgBwklau8vL8yHprAZs2UtjfqWkam7LPrdaDiGp1tQnfoYZRZsFkZ2dQUYFU4vhZd2Zo9fgd4OY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3472.eurprd04.prod.outlook.com (52.134.5.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Tue, 26 Nov 2019 09:13:39 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2495.014; Tue, 26 Nov 2019
 09:13:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 2/6] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Topic: [PATCH v4 2/6] crypto: caam - enable prediction resistance in
 HRWNG
Thread-Index: AQHVoIQyJHCMNObN7kuHGNWFUpD0kQ==
Date:   Tue, 26 Nov 2019 09:13:38 +0000
Message-ID: <VI1PR0402MB348521C01FBACF44C531C7CD98450@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
 <20191121155554.1227-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 169b8eb6-51fe-4608-0f72-08d77250eca4
x-ms-traffictypediagnostic: VI1PR0402MB3472:|VI1PR0402MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34729F896DC96E1861005B3B98450@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(199004)(189003)(52536014)(2501003)(91956017)(316002)(9686003)(7696005)(102836004)(53546011)(6506007)(86362001)(26005)(71190400001)(8676002)(8936002)(14454004)(81156014)(71200400001)(229853002)(186003)(76116006)(81166006)(66946007)(305945005)(66476007)(74316002)(66446008)(64756008)(66556008)(256004)(7736002)(110136005)(66066001)(6246003)(44832011)(446003)(55016002)(6116002)(3846002)(33656002)(5660300002)(6436002)(76176011)(4326008)(478600001)(25786009)(2906002)(54906003)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3472;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BYUSgcWPJgD86qQliMRcg0k7hLjHoEbvTVB00q44XAwbZu2TzG/nDaBnjMLE00R0Ch0T2XfcaNediKHc4GOcKEadLjxwJ8RbBRGtCT2oS29lG+3m5HhR3sKOz6F0f7F09zOE/jX+29yw22VB/i0EcY98n9q9ZzTdz/eOpV9rHx27vbCyMx0GYtdr9xAT35fR6D7X81N/YA3XLo4xOsaz7GNVsVsS+oL9qDccpbbxAp0hwfiX74v0Jx4MMwRsgMGVKxZTqDlwcWk2qv/CuNfg2WQHqoVqpk4Dh/WMKQXVVCgcOFU83EGyACoTQmU3wYfjg5pb1i4OPtglcwXGop7n3XeVmFS/FP3P/yqEeqznql4DSAHDfh+vC4EffYZEuFXe/MAhvB51iswiNu5S8Rg+voKzEa/rpZ8r/PfCTJwTYzNO9vTK14cYCIk7KIPaRl7/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169b8eb6-51fe-4608-0f72-08d77250eca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 09:13:38.6481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: syzdeTt5CJL0tqUqY5OJ0YjqO8lIeTS/2y7Uy5eAsq267ivlb7ZJwT/zVFOs/HTrrWkWF6bAaD1F9shh+sY7Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/21/2019 5:56 PM, Andrey Smirnov wrote:=0A=
> Instantiate CAAM RNG with prediction resistance enabled to improve its=0A=
> quality.=0A=
> =0A=
It's worth noting there are two RNG operations being changed:=0A=
-instantiation=0A=
-generation=0A=
=0A=
Generation with prediction resistance (PR) is only supported on=0A=
RNG state handles instantiated with PR option.=0A=
=0A=
Using PR when generating randomness effectively forces a reseed=0A=
of the DRBG / PRNG - that's how quality is improved.=0A=
=0A=
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.=
c=0A=
> index e8baacaabe07..6dde8ae3cd9b 100644=0A=
> --- a/drivers/crypto/caam/caamrng.c=0A=
> +++ b/drivers/crypto/caam/caamrng.c=0A=
> @@ -202,7 +202,8 @@ static inline int rng_create_sh_desc(struct caam_rng_=
ctx *ctx)=0A=
>  	init_sh_desc(desc, HDR_SHARE_SERIAL);=0A=
>  =0A=
>  	/* Generate random bytes */=0A=
> -	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);=0A=
> +	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |=0A=
> +			 OP_ALG_PR_ON);=0A=
>  =0A=
>  	/* Store bytes */=0A=
>  	append_seq_fifo_store(desc, RN_BUF_SIZE, FIFOST_TYPE_RNGSTORE);=0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index df4db10e9fca..a1c879820286 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -36,7 +36,8 @@ static void build_instantiation_desc(u32 *desc, int han=
dle, int do_sk)=0A=
>  	init_job_desc(desc, 0);=0A=
>  =0A=
>  	op_flags =3D OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |=0A=
> -			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;=0A=
> +			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT |=0A=
> +			OP_ALG_PR_ON;=0A=
>  =0A=
>  	/* INIT RNG in non-test mode */=0A=
>  	append_operation(desc, op_flags);=0A=
> @@ -275,11 +276,12 @@ static int instantiate_rng(struct device *ctrldev, =
int state_handle_mask,=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	for (sh_idx =3D 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {=0A=
> +		const u32 rdsta_mask =3D (RDSTA_PR0 | RDSTA_IF0) << sh_idx;=0A=
>  		/*=0A=
>  		 * If the corresponding bit is set, this state handle=0A=
>  		 * was initialized by somebody else, so it's left alone.=0A=
>  		 */=0A=
> -		if ((1 << sh_idx) & state_handle_mask)=0A=
> +		if (rdsta_mask & state_handle_mask)=0A=
>  			continue;=0A=
>  =0A=
If a state handle was previously instantiated (e.g. by U-boot),=0A=
but without prediction resistance support, it won't be re-instantiated=0A=
("continue" / skip above).=0A=
=0A=
The result is using a state handle without PR support.=0A=
Due to this, when extracting / generating randomness (in caamrng.c) with=0A=
the PR bit set, job descriptor will generate a prediction resistance error.=
=0A=
=0A=
IMO the proper thing to do in case a state handle was instantiated=0A=
without PR support is to re-instantiate it.=0A=
=0A=
There's an assumption here though: kernel handles RNG initialization only=
=0A=
in some cases, when it's effectively "controlling" it.=0A=
In cases when it's not, like when Management Complex (MC) f/w is present=0A=
(or OP-TEE OS, SECO etc.), kernel skips RNG init and only uses the job ring=
=0A=
interface for random generation.=0A=
=3D=3D> MC, OP-TEE, SECO etc. have to be updated to initialize=0A=
RNG state handles with PR support=0A=
=0A=
Horia=0A=
