From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 00/11] Further iMX CAAM updates
Date: Mon, 8 Aug 2016 14:36:51 -0300
Message-ID: <CAOMZO5C0_bCcxPV8NWcBmc8-bGb8SMU2c4E+Mv7LLUJbGy-Apw@mail.gmail.com>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, horia.geanta@nxp.com
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35216 "EHLO
	mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcHHRvH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:51:07 -0400
Received: by mail-ua0-f193.google.com with SMTP id 109so5373883uat.2
        for <linux-crypto@vger.kernel.org>; Mon, 08 Aug 2016 10:51:06 -0700 (PDT)
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russell,

On Mon, Aug 8, 2016 at 2:04 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> This is a re-post (with hopefully bugs fixed from December's review).
> Untested, because AF_ALG appears to be broken in 4.8-rc1.  Maybe
> someone can provide some hints how to test using tcrypt please?
>
> Here are further imx-caam updates that I've had since before the
> previous merge window.  Please review and (I guess) if Freescale
> folk can provide acks etc that would be nice.  Thanks.

I am adding Horia on Cc, who is familiar with the caam driver.

Thanks
