From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 19/39] ARM: ux500: Register Cyrp and Hash platform drivers
 on Snowball
Date: Mon, 20 May 2013 14:17:10 +0200
Message-ID: <CACRpkdb4YKHSHf6yPC7KQWxxhP1tEdZuVfY-8ELYqj+xFNhPjw@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-20-git-send-email-lee.jones@linaro.org>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51197 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3ETMRL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 May 2013 08:17:11 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so13949367iec.29
        for <linux-crypto@vger.kernel.org>; Mon, 20 May 2013 05:17:10 -0700 (PDT)
In-Reply-To: <1368611522-9984-20-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> These drivers are now operational and even use the latest common clk
> and DMA APIs. There's no reason why we shouldn't start them up now.
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied now that the deps are in place.

Yours,
Linus Walleij
