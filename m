From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/9] crypto: ux500/cryp - Fix compile error
Date: Thu, 25 Apr 2013 14:44:43 +0100
Message-ID: <20130425134443.GO4623@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
 <1366280825-31136-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZNFqbHJB7R5zqVzkAn_nV=G+c27YRB7VCQxiMyFTnPbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdZNFqbHJB7R5zqVzkAn_nV=G+c27YRB7VCQxiMyFTnPbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wr=
ote:
>=20
> > Clearly this driver hasn't been tested, or even enabled in a while.
> >
> > drivers/crypto/ux500/cryp/cryp_core.c:1771:3:
> >         error: request for member =E2=80=98pm=E2=80=99 in something=
 not a structure or union
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Andreas Westin <andreas.westin@stericsson.com>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> NAK. I already fixed this. It is in v3.9-rc7.

Yes, I saw it when I rebased. I've dropped the patch.

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
