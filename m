From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the driver
Date: Fri, 24 May 2013 09:32:31 +0100
Message-ID: <20130524083231.GQ22683@gmail.com>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
 <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZHT0g_Agtug6jC3rU+DYKOpmwqZ9eQAkRGRw5Kj0wW4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACRpkdZHT0g_Agtug6jC3rU+DYKOpmwqZ9eQAkRGRw5Kj0wW4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 24 May 2013, Linus Walleij wrote:

> On Thu, May 16, 2013 at 1:27 PM, Lee Jones <lee.jones@linaro.org> wro=
te:
>=20
> > By providing an OF match table with a suitable compatible string, w=
e
> > can ensure the ux500-crypt driver is probed by supplying an associa=
ted
> > DT node in a given platform's Device Tree.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> Herbert, can I have your ACK on patch 5 & 6 in this series to take it
> through the ARM SoC tree?

Right, there are no bindings, so they don't need a document.

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
