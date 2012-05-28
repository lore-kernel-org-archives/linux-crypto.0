From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: [PATCH 2/4] mv_cesa: no need to write to that FPGA_INT_STATUS
 field
Date: Mon, 28 May 2012 09:58:32 +0800
Message-ID: <4FC2DBC8.2070805@gmail.com>
References: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com> <1337954089-12702-2-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34102 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2E1B6i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 May 2012 21:58:38 -0400
Received: by dady13 with SMTP id y13so3512094dad.19
        for <linux-crypto@vger.kernel.org>; Sun, 27 May 2012 18:58:37 -0700 (PDT)
In-Reply-To: <1337954089-12702-2-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-5-25 21:54, Phil Sutter wrote:
> Also drop the whole definition, since it's unused otherwise.
>
> Signed-off-by: Phil Sutter<phil.sutter@viprinet.com>
> ---
>   drivers/crypto/mv_cesa.c |    1 -
>   drivers/crypto/mv_cesa.h |    7 -------
>   2 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
> index 8327bed..4a1f872 100644
> --- a/drivers/crypto/mv_cesa.c
> +++ b/drivers/crypto/mv_cesa.c
> @@ -908,7 +908,6 @@ irqreturn_t crypto_int(int irq, void *priv)
>   		       "got an interrupt but no pending timer?\n");
>   	}
>   	val&= ~SEC_INT_ACCEL0_DONE;
> -	writel(val, cpg->reg + FPGA_INT_STATUS);
>   	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
>   	BUG_ON(cpg->eng_st != ENGINE_BUSY);
>   	cpg->eng_st = ENGINE_W_DEQUEUE;
> diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
> index 08fcb11..81ce109 100644
> --- a/drivers/crypto/mv_cesa.h
> +++ b/drivers/crypto/mv_cesa.h
> @@ -29,13 +29,6 @@
>   #define SEC_ST_ACT_0		(1<<  0)
>   #define SEC_ST_ACT_1		(1<<  1)
>
> -/*
> - * FPGA_INT_STATUS looks like a FPGA leftover and is documented only in Errata
> - * 4.12. It looks like that it was part of an IRQ-controller in FPGA and
> - * someone forgot to remove  it while switching to the core and moving to
> - * SEC_ACCEL_INT_STATUS.
> - */
> -#define FPGA_INT_STATUS		0xdd68
>   #define SEC_ACCEL_INT_STATUS	0xde20
>   #define SEC_INT_AUTH_DONE	(1<<  0)
>   #define SEC_INT_DES_E_DONE	(1<<  1)

According to the functional errata of 88F5182, the FPGA_INT_STATUS is 
needed (at least for 88F5182-A1/A2). Here is the quote from that errata:

4.12	Clearing the Cryptographic Engines and Security Accelerator 
Interrupt Cause Register
	Type:		Guideline
	Ref#:		GL-CESA-100
	Relevant for:	88F5182-A1/A2

Description:
Writing 0 to bits[6:0] of the Crytographic Engines ...  Interrupt Cause 
register (offset 0x9DE20) has no effect.

Steps to be performed by the designer
Before writing 0 to any of the bits[6:0] of the Cryptographic Engines .. 
Interrupt Cause register, the software must write 0 to the corresponding 
bit of the internal register at offset 0x9DD68.
Writing to offset 0x9DD68 is not possible when any of the Security 
Accelerators' sessions are active. Therefore, the software must verify 
that no channel is active before clearing any of those interrupts.
