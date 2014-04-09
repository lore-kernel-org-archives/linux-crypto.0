From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypt: bfin_crc: access crc registers by ioread32 and iowrite32 functions
Date: Wed, 9 Apr 2014 19:32:01 +0200
Message-ID: <201404091932.02072.marex@denx.de>
References: <1395910353-2853-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:54738 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIRqi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Apr 2014 13:46:38 -0400
In-Reply-To: <1395910353-2853-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, March 27, 2014 at 09:52:33 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Move architecture independant crc header file out of the blackfin folder.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

[...]

> @@ -530,13 +532,14 @@ static irqreturn_t bfin_crypto_crc_handler(int irq,
> void *dev_id) {
>  	struct bfin_crypto_crc *crc = dev_id;
> 
> -	if (crc->regs->status & DCNTEXP) {
> -		crc->regs->status = DCNTEXP;
> +	if (ioread32(&crc->regs->status) & DCNTEXP) {
> +		iowrite32(DCNTEXP, &crc->regs->status);
> 
>  		/* prepare results */
> -		put_unaligned_le32(crc->regs->result, crc->req->result);
> +		put_unaligned_le32(ioread32(&crc->regs->result),
> +			crc->req->result);
> 
> -		crc->regs->control &= ~BLKEN;
> +		iowrite32(ioread32(&crc->regs->control) & ~BLKEN, &crc->regs-
>control);

You should avoid combining the IO accessors into each other like this, it's 
rather cryptic. Please introduce some variable like so:

u32 reg;
reg = ioread32(...);
reg &= ~....
iowrite32(reg, ...);

[...]

Why do you not use readl()/writel() ?

Other than that, it's a move in the right direction.

Best regards,
Marek Vasut
