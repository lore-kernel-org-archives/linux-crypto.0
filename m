From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/9] crypto: ux500/cryp - Fix compile error
Date: Thu, 25 Apr 2013 14:00:00 +0200
Message-ID: <CACRpkdZNFqbHJB7R5zqVzkAn_nV=G+c27YRB7VCQxiMyFTnPbg@mail.gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-6-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366280825-31136-6-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wrot=
e:

> Clearly this driver hasn't been tested, or even enabled in a while.
>
> drivers/crypto/ux500/cryp/cryp_core.c:1771:3:
>         error: request for member =91pm=92 in something not a structu=
re or union
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

NAK. I already fixed this. It is in v3.9-rc7.

Yours,
Linus Walleij
