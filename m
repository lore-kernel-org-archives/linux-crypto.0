From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/39] dmaengine: ste_dma40: Remove redundant address
 fetching function
Date: Wed, 15 May 2013 18:56:05 +0200
Message-ID: <CACRpkdZpx3=8dhGaZ9xW7vXTmvhi=OVE5vFCAW66-AnwV_i=rQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-9-git-send-email-lee.jones@linaro.org>
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
In-Reply-To: <1368611522-9984-9-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Addresses are now stored in local data structures and are easy to
> obtain, thus a specialist function used to fetch them is now surplus
> to requirement.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch tentatively applied, waiting for Vinod's ACK.

Yours,
Linus Walleij
