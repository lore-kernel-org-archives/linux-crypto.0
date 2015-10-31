From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] nx-842: Ignore bit 3 of condition register returned by icswx
Date: Sat, 31 Oct 2015 08:14:58 -0400
Message-ID: <CALZtONBsWoU+q3xiP-8113Q73BADprOH7-murs2SEvwd-vXTWQ@mail.gmail.com>
References: <20151030224301.GA22549@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38008 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbbJaMPi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 Oct 2015 08:15:38 -0400
Received: by igbdj2 with SMTP id dj2so27492569igb.1
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2015 05:15:37 -0700 (PDT)
In-Reply-To: <20151030224301.GA22549@ram.oc3035372033.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2015 at 6:43 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> icswx occasionally under heavy load sets bit 3 of condition register 0.
> It has no software implication.
>
> Currently that bit is interpreted by the driver as a failure, when
> it should have calmly ignored it.
>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>

Acked-by: Dan Streetman <ddstreet@ieee.org>

> ---
>  arch/powerpc/include/asm/icswx.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
> index 9f8402b..bce20c7 100644
> --- a/arch/powerpc/include/asm/icswx.h
> +++ b/arch/powerpc/include/asm/icswx.h
> @@ -177,7 +177,7 @@ static inline int icswx(__be32 ccw, struct coprocessor_request_block *crb)
>         : "r" (ccw_reg), "r" (crb)
>         : "cr0", "memory");
>
> -       return (int)((cr >> 28) & 0xf);
> +       return (int)((cr >> 28) & 0xe);
>  }
>
