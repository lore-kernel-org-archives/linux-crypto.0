From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] AT91SAM9G46/M11: add crypto drivers
Date: Wed, 11 Jul 2012 11:25:37 +0800
Message-ID: <20120711032537.GF5263@gondor.apana.org.au>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:43143 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754478Ab2GKDZv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 23:25:51 -0400
Content-Disposition: inline
In-Reply-To: <1341163187-14946-1-git-send-email-eric@eukrea.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 01, 2012 at 07:19:42PM +0200, Eric B=E9nard wrote:
> This patch serie adds the support for the crypto engine available in
> the Atmel SAM9G46 http://www.atmel.com/devices/SAM9G46.aspx and SAM9M=
11
> http://www.atmel.com/devices/SAM9M11.aspx
>=20
> For each driver the choice between PDC/DMA or PIO was optimized to
> maximize the performances (benchmarks will soon be available on
> the linux4sam wiki http://www.at91.com/).
>=20
> These drivers were tested on both devices : the last patch adds a few
> missing tests to tcrypt.
>=20
> This work was sponsored by Atmel.

All applied.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
