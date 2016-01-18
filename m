From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 1/4] hw_random: bcm63xx-rng: remove unused variables
Date: Mon, 18 Jan 2016 11:08:44 -0800
Message-ID: <569D383C.7030307@gmail.com>
References: <1453021437-12531-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32917 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbcARTIq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 14:08:46 -0500
In-Reply-To: <1453021437-12531-1-git-send-email-noltari@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 17/01/2016 01:03, =C3=81lvaro Fern=C3=A1ndez Rojas a =C3=A9crit :
> These variables where left as unused in commit 6229c16060fe
> ("hwrng: bcm63xx - make use of devm_hwrng_register")
>=20
> Fixes the following warning:
> drivers/char/hw_random/bcm63xx-rng.c: In function 'bcm63xx_rng_probe'=
:
> drivers/char/hw_random/bcm63xx-rng.c:85:16: warning: unused variable =
'rng'
> [-Wunused-variable]
>   struct hwrng *rng;
>                 ^
> drivers/char/hw_random/bcm63xx-rng.c:82:14: warning: unused variable =
'clk'
> [-Wunused-variable]
>   struct clk *clk;
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--=20
=46lorian
