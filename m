From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 35/39] dmaengine: ste_dma40_ll: Replace meaningless
 register set with comment
Date: Thu, 30 May 2013 23:26:09 +0530
Message-ID: <20130530175609.GF3767@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-36-git-send-email-lee.jones@linaro.org>
 <CACRpkdbXVd7k9rzb-OKUmnW_9J+jWYhz=AjO09_Ymvd2_DOVcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Jones <lee.jones@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Dan Williams <djbw@fb.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Rabin Vincent <rabin@rab.in>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3E3SeP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 14:34:15 -0400
Content-Disposition: inline
In-Reply-To: <CACRpkdbXVd7k9rzb-OKUmnW_9J+jWYhz=AjO09_Ymvd2_DOVcQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 30, 2013 at 11:04:23AM +0200, Linus Walleij wrote:
> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Unsure of the author's intentions, rather than just removing the nop,
> > we're replacing it with a comment containing the possible intention
> > of the statement OR:ing with 0.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Tentatively applied. Missing Vinod's ACK.
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
