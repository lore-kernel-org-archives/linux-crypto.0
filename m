Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A13C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89B22067D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfHEIER (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 04:04:17 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:45375 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfHEIER (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 04:04:17 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id CDAD0FF80E;
        Mon,  5 Aug 2019 08:04:13 +0000 (UTC)
Date:   Mon, 5 Aug 2019 10:04:12 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv3 1/4] crypto: inside-secure - make driver selectable for
 non-Marvell hardware
Message-ID: <20190805080412.GF14470@kwain>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-2-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564586959-9963-2-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Jul 31, 2019 at 05:29:16PM +0200, Pascal van Leeuwen wrote:
> While being a generic EIP97/EIP197 driver, the driver was only selectable
> for Marvell Armada hardware. This fix makes the driver selectable for any
> Device Tree supporting kernel configuration, allowing it to be used for
> other compatible hardware by just adding the correct device tree entry.
> 
> It also allows the driver to be selected for PCI(E) supporting kernel con-
> figurations, to be able to use it with PCIE based FPGA development boards
> for pre-silicon driver development by both Inside Secure and its IP custo-
> mers.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/Kconfig | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 67af688..0d9f67d 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -716,8 +716,7 @@ source "drivers/crypto/stm32/Kconfig"
> 
>  config CRYPTO_DEV_SAFEXCEL
>  	tristate "Inside Secure's SafeXcel cryptographic engine driver"
> -	depends on OF
> -	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
> +	depends on OF || PCI || COMPILE_TEST
>  	select CRYPTO_AES
>  	select CRYPTO_AUTHENC
>  	select CRYPTO_BLKCIPHER
> @@ -729,10 +728,11 @@ config CRYPTO_DEV_SAFEXCEL
>  	select CRYPTO_SHA256
>  	select CRYPTO_SHA512
>  	help
> -	  This driver interfaces with the SafeXcel EIP-197 cryptographic engine
> -	  designed by Inside Secure. Select this if you want to use CBC/ECB
> -	  chain mode, AES cipher mode and SHA1/SHA224/SHA256/SHA512 hash
> -	  algorithms.
> +	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
> +	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
> +	  AES block ciphers in ECB and CBC mode, as well as SHA1, SHA224, SHA256,
> +	  SHA384 and SHA512 hash algorithms for both basic hash and HMAC.
> +	  Additionally, it accelerates combined AES-CBC/HMAC-SHA AEAD operations.
> 
>  config CRYPTO_DEV_ARTPEC6
>  	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
> --
> 1.8.3.1

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
