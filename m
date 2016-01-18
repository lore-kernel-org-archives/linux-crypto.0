From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4/4] hw_random: brcm63xx-rng: document device tree
 bindings
Date: Mon, 18 Jan 2016 11:11:47 -0800
Message-ID: <569D38F3.6020801@gmail.com>
References: <1453021437-12531-4-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33336 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbcARTLu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 14:11:50 -0500
In-Reply-To: <1453021437-12531-4-git-send-email-noltari@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 17/01/2016 01:03, =C3=81lvaro Fern=C3=A1ndez Rojas a =C3=A9crit :
> Documents device tree bindings for random number generator present on=
 Broadcom
> BCM6368 SoC.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I could not track down the proper versioning of this IP block, so this
is a good choice, thanks!

Nit: it is kind of nice to re-order the binding addition to come before
the driver and/or driver conversion to Device Tree probing.
--=20
=46lorian
