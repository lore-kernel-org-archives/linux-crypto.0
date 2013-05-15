From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 07/39] dmaengine: ste_dma40: Only use addresses passed as
 configuration information
Date: Wed, 15 May 2013 18:54:18 +0200
Message-ID: <CACRpkdY97uS_ckSqy=Ta0SDrXrGmtDB4eL28_ZZPN5j--emr5A@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-8-git-send-email-lee.jones@linaro.org>
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
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36738 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665Ab3EOQyT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 12:54:19 -0400
Received: by mail-ie0-f172.google.com with SMTP id 16so4164906iea.17
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 09:54:19 -0700 (PDT)
In-Reply-To: <1368611522-9984-8-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Addresses are passed in from the client's driver via the invocation of
> dmaengine_slave_config(), so there's no need to fetch them from platform
> data too, hardwired or otherwise. This is a great step forward, as it
> elevates a large burden from platform data in the way of a look-up
> table.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This should be the case even without patch 5 & 6 so patch tentatively
applied.

Waiting for Vinod's ACK on this though.

Yours,
Linus Walleij
