From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 25/39] usb: musb: ux500: add device tree probing support
Date: Thu, 30 May 2013 10:38:34 +0200
Message-ID: <CACRpkdZE-i5v_B7CCVPVNpU+EgCx4D17mZ+OvwAHZXXDBdoi1w@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-26-git-send-email-lee.jones@linaro.org>
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
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Rob Herring <rob.herring@calxeda.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40922 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967913Ab3E3Iif (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 04:38:35 -0400
Received: by mail-ie0-f177.google.com with SMTP id 9so27770743iec.36
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 01:38:35 -0700 (PDT)
In-Reply-To: <1368611522-9984-26-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch will allow ux500-musb to be probed and configured solely from
> configuration found in Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-usb@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied with Felipe's ACK.

Yours,
Linus Walleij
