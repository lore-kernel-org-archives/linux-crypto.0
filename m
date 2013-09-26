From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Thu, 26 Sep 2013 08:27:15 -0300
Message-ID: <CAOMZO5AU_R5aeHKbkGRGuyXsVOVdUwdF5oZXdEZZYs442nFnEA@mail.gmail.com>
References: <1380194306-5243-1-git-send-email-marex@denx.de>
	<1380194306-5243-2-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:47114 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab3IZL1Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 07:27:16 -0400
Received: by mail-vb0-f50.google.com with SMTP id x14so710707vbb.23
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2013 04:27:15 -0700 (PDT)
In-Reply-To: <1380194306-5243-2-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marek,

On Thu, Sep 26, 2013 at 8:18 AM, Marek Vasut <marex@denx.de> wrote:
> Add support for the MXS DCP block. The driver currently supports
> SHA-1/SHA-256 hashing and AES-128 CBC/ECB modes. The non-standard
> CRC32 is not yet supported.
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  drivers/crypto/Kconfig   |   17 +
>  drivers/crypto/Makefile  |    1 +
>  drivers/crypto/mxs-dcp.c | 1082 ++++++++++++++++++++++++++++++++++++++++++++++

What about the existing DCP driver at drivers/crypto/dcp.c ?

Why do we need to have two drivers for the same IP block? It looks
confusing to have both.

Regards,

Fabio Estevam
