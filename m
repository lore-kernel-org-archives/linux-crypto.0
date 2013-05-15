From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 03/39] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
Date: Wed, 15 May 2013 18:44:26 +0200
Message-ID: <CACRpkdbvhB=7QScU1bCN8wXr7ZOuPX9XYoCjX_a8gFSMCkbm-w@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-4-git-send-email-lee.jones@linaro.org>
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
	Rabin Vincent <rabin@rab.in>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Dan Williams <djbw@fb.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49504 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab3EOQo1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 12:44:27 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so4236680iec.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 09:44:27 -0700 (PDT)
In-Reply-To: <1368611522-9984-4-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Using the dmaengine API, allocating and configuring a channel are two
> separate actions. Here we're removing logical channel configuration from
> the channel allocating routines.

This commit message is also incorrect, but I amended it.

Besides, when I amend commit messages I make sure I really
understand what is going on so no big deal...

> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I still need Vinod's ACK on this before I send it anywhere.

Patch applied!

Yours,
Linus Walleij
