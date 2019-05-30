Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627A0C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4618F259CC
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfE3NoJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:44:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38078 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfE3NoJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:44:09 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWLLk-0005gQ-Fn; Thu, 30 May 2019 21:44:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWLLh-0003hY-2D; Thu, 30 May 2019 21:44:05 +0800
Date:   Thu, 30 May 2019 21:44:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 0/6] crypto - wire up Atmel SHA204A as RNG in DT and
 ACPI mode
Message-ID: <20190530134404.kpxdpkxbzyxhpbxo@gondor.apana.org.au>
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 06:26:45PM +0200, Ard Biesheuvel wrote:
> The Socionext SynQuacer based 96boards DeveloperBox platform does not
> incorporate a random number generator, but it does have a 96boards low
> speed connector which supports extension boards such as the Secure96,
> which has a TPM and some crypto accelerators, one of which incorporates
> a random number generator.
> 
> This series implements support for the RNG part, which is one of several
> functions of the Atmel SHA204A I2C crypto accelerator, and wires it up so
> both DT and ACPI based boot methods can use the device.
> 
> v2:
> - update DT binding patches so the SHA204A and ECC508A module bindings are
>   in trivial-devices.yaml.
> - add acks from Linus and Mika
> 
> Assuming Rob is ok now with the DT binding patches, can we please take
> this through the crypto tree?
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Ard Biesheuvel (6):
>   i2c: acpi: permit bus speed to be discovered after enumeration
>   crypto: atmel-ecc: add support for ACPI probing on non-AT91 platforms
>   crypto: atmel-ecc: factor out code that can be shared
>   crypto: atmel-i2c: add support for SHA204A random number generator
>   dt-bindings: add Atmel SHA204A I2C crypto processor
>   dt-bindings: move Atmel ECC508A I2C crypto processor to
>     trivial-devices
> 
>  Documentation/devicetree/bindings/crypto/atmel-crypto.txt |  13 -
>  Documentation/devicetree/bindings/trivial-devices.yaml    |   4 +
>  drivers/crypto/Kconfig                                    |  19 +-
>  drivers/crypto/Makefile                                   |   2 +
>  drivers/crypto/atmel-ecc.c                                | 403 ++------------------
>  drivers/crypto/atmel-ecc.h                                | 116 ------
>  drivers/crypto/atmel-i2c.c                                | 364 ++++++++++++++++++
>  drivers/crypto/atmel-i2c.h                                | 196 ++++++++++
>  drivers/crypto/atmel-sha204a.c                            | 171 +++++++++
>  drivers/i2c/i2c-core-acpi.c                               |   6 +-
>  10 files changed, 781 insertions(+), 513 deletions(-)
>  delete mode 100644 drivers/crypto/atmel-ecc.h
>  create mode 100644 drivers/crypto/atmel-i2c.c
>  create mode 100644 drivers/crypto/atmel-i2c.h
>  create mode 100644 drivers/crypto/atmel-sha204a.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
