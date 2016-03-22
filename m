From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: use spin_lock_irq{save|restore}
Date: Tue, 22 Mar 2016 18:48:00 +0100
Message-ID: <56F18550.7030201@gmail.com>
References: <1458662694-25527-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34585 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbcCVRsI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 13:48:08 -0400
In-Reply-To: <1458662694-25527-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 22/03/2016 17:04, LABBE Corentin a =E9crit :
> The current sun4i-ss driver is subject to data corruption when
> ciphering/deciphering.
> It occurs randomly on end of handled data.
> No root cause have been found and the only way to remove it is to rep=
lace
> all spin_lock_bh by they irq counterparts.
>=20
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20

Hello

I have made a huge spelling problem, and didn't added Fixes tag.
I will resend it.
Sorry for the noise.

Regards
