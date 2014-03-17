From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH cryptodev 1/4] crypto: caam - remove error propagation handling
Date: Mon, 17 Mar 2014 19:23:11 +0100
Message-ID: <201403171923.11855.marex@denx.de>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:48503 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaCQSn6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Mar 2014 14:43:58 -0400
In-Reply-To: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, March 14, 2014 at 04:46:49 PM, Horia Geanta wrote:
> Commit 61bb86bba169507a5f223b94b9176c32c84b4721
> ("crypto: caam - set descriptor sharing type to SERIAL")
> changed the descriptor sharing mode from SHARE_WAIT to SHARE_SERIAL.
> 
> All descriptor commands that handle the "ok to share" and
> "error propagation" settings should also go away, since they have no
> meaning for SHARE_SERIAL.

[...]

> @@ -253,7 +236,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	/* assoclen + cryptlen = seqinlen - ivsize */
>  	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
> 
> -	/* assoclen + cryptlen = (assoclen + cryptlen) - cryptlen */
> +	/* assoclen = (assoclen + cryptlen) - cryptlen */

This comment basically says 'x = x' , but it doesn't explain anything to 
uninformed observer. Can you fix such comments please ?

[...]

Best regards,
Marek Vasut
