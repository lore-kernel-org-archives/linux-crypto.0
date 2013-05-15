From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 13/39] crypto: ux500/hash - Set DMA configuration though dma_slave_config()
Date: Wed, 15 May 2013 19:09:57 +0200
Message-ID: <CACRpkdZ+XExToF8DaC+iiMrpf-s01Hc6W5q40n=WnfJ4qtKStw@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-14-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368611522-9984-14-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The DMA controller currently takes configuration information from
> information passed though dma_channel_request(), but it shouldn't.
> Using the API, the DMA channel should only be configured during
> a dma_slave_config() call.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I think I need to stop applying here and wait for an ACK from
Herbert on everything hitting drivers/crypto.

If I get Vinod's ACK for the previous patches I can send an
initial pull request on that and then follow up with the rest.

Yours,
Linus Walleij
