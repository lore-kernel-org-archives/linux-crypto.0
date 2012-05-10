From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 0/3] Update for ux500 CRYP and HASH
Date: Thu, 10 May 2012 15:18:04 +0200
Message-ID: <CACRpkdapMo4vd=hbuR5T+PrH8D2QpGgPX3gTcswuUCxdkZ80Eg@mail.gmail.com>
References: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, arnd@arndb.de, sfr@canb.auug.org.au,
	lee.jones@linaro.org
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33381 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2EJNSF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 09:18:05 -0400
Received: by gglu4 with SMTP id u4so908491ggl.19
        for <linux-crypto@vger.kernel.org>; Thu, 10 May 2012 06:18:04 -0700 (PDT)
In-Reply-To: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 10, 2012 at 10:14 AM, Andreas Westin
<andreas.westin@stericsson.com> wrote:

> * Removed symbol export
> * Removed usage of SOC specific functions in the drivers.
> * Readded overlooked config for DMA in mach-ux500.
>
> After some internal discussion we felt that the now implemented
> hardware identification solution is cleaner than the suggested
> solution.
>
> The hardware identification patch applies cleanly to
> the cryptodev tree.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
