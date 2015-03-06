From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH V3 2/2] Documentation: crypto: Add DT binding info for the
 img hw hash accelerator
Date: Fri, 6 Mar 2015 13:50:17 -0800
Message-ID: <CAL1qeaHSkwTvL35yrQQD-5F37D3LKxS7zEg3vdPBfVQvznbYQQ@mail.gmail.com>
References: <1425610912-9930-1-git-send-email-james.hartley@imgtec.com>
	<1425610912-9930-3-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45722 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbCFVuS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 16:50:18 -0500
Received: by qcwb13 with SMTP id b13so16309747qcw.12
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2015 13:50:18 -0800 (PST)
In-Reply-To: <1425610912-9930-3-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On Thu, Mar 5, 2015 at 7:01 PM, James Hartley <james.hartley@imgtec.com> wrote:
> This adds the binding documentation for the Imagination Technologies
> hash accelerator that provides hardware acceleration for
> SHA1/SHA224/SHA256/MD5 hashes.  This hardware will be present in
> the upcoming pistachio SoC.
>
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

> diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt
> new file mode 100644
> index 0000000..7adc519
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/img-hash.txt
> @@ -0,0 +1,27 @@
> +Imagination Technologies hardware hash accelerator
> +
> +The hash accelerator provides hardware hashing acceleration for
> +SHA1, SHA224, SHA256 and MD5 hashes
> +
> +Required properties:
> +
> +- compatible : "img,hash-accelerator"
> +- reg : Offset and length of the register set for the module, and the DMA port
> +- interrupts : The designated IRQ line for the hashing module.
> +- dmas : DMA specifier as per Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names : Should be "tx"
> +- clocks : Clock specifiers
> +- clock-names : "hash_clk" Used to clock data through the accelerator
> +               "hash_reg_clk" Used to clock the hash block registers

For the other IMG drivers that have been submitted, we've been  using
"sys" as the name for the register gate clock.  Maybe we should do
that here too to be consistent?

> +Example:
> +
> +       hash: hash@18149600 {
> +       compatible = "img,hash-accelerator";
> +               reg = <0x18149600 0x100, 0x18101100 0x4>;
> +               interrupts = <GIC_SHARED 59 IRQ_TYPE_LEVEL_HIGH>;
> +               dmas = <&dma 8 0xffffffff>;
> +               dma-names = "tx";
> +               clocks = <&cr_periph SYS_CLK_HASH>, <&clk_periph PERIPH_CLK_ROM>;
> +               clock-names = "hash_clk, hash_reg_clk";

I think these are flipped (and you're missing some quotation marks).

Otherwise this looks good to me.

-Andrew
