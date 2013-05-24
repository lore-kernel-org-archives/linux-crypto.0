From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the
 driver
Date: Fri, 24 May 2013 14:21:10 +0800
Message-ID: <20130524062110.GA32684@gondor.apana.org.au>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
 <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZHT0g_Agtug6jC3rU+DYKOpmwqZ9eQAkRGRw5Kj0wW4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Jones <lee.jones@linaro.org>,
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

On Fri, May 24, 2013 at 08:20:38AM +0200, Linus Walleij wrote:
> On Thu, May 16, 2013 at 1:27 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > By providing an OF match table with a suitable compatible string, we
> > can ensure the ux500-crypt driver is probed by supplying an associated
> > DT node in a given platform's Device Tree.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Herbert, can I have your ACK on patch 5 & 6 in this series to take it
> through the ARM SoC tree?

Sure,

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
