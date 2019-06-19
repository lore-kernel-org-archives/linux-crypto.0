Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90938C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B014208CB
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbfFSM3L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:29:11 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:37277 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731713AbfFSM3K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 08:29:10 -0400
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 6F3D5240013;
        Wed, 19 Jun 2019 12:29:05 +0000 (UTC)
Date:   Wed, 19 Jun 2019 14:29:04 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: Re: [PATCH 1/3] crypto: inside-secure - make driver selectable for
 non-Marvell hardware
Message-ID: <20190619122904.GC3254@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-2-git-send-email-pvanleeuwen@insidesecure.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560837384-29814-2-git-send-email-pvanleeuwen@insidesecure.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Jun 18, 2019 at 07:56:22AM +0200, Pascal van Leeuwen wrote:
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
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

This looks good to me, thanks!

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
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
