From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 10/39] dmaengine: ste_dma40: Correct copy/paste error
Date: Wed, 15 May 2013 19:04:27 +0200
Message-ID: <CACRpkdbQaB9adaCb6FR3XAMMK2AtDdzKfNb0WZZ8Gm5yQBiuVw@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-11-git-send-email-lee.jones@linaro.org>
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
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> 'struct stedma40_half_channel_info's header comment says that it's
> called 'struct stedma40_chan_cfg'. Let's straighten that out.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch tentatively applied waiting for Vinod's ACK.

Yours,
Linus Walleij
