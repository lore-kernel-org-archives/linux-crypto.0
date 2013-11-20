From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH RESEND 0/7] crypto: at91/atmel: add Device Tree support
Date: Wed, 20 Nov 2013 11:43:26 +0100
Message-ID: <528C924E.50206@atmel.com>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>
To: <linux-arm-kernel@lists.infradead.org>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:39313 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTKnc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Nov 2013 05:43:32 -0500
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/11/2013 16:08, Nicolas Ferre :
> This series adds Device Tree support to the Atmel crypto drivers
> (AES/[T]DES/SHA). The Device Tree entries are very simple and only
> declare the reg/irq values and the link to DMA.

Herbert,

ping?

Could I have your "Acked-by" for taking these patches through the 
arm-soc git tree, or do you want that we split this series so that you 
can take the driver part of it?

Best regards,


> Some trivial patches are preceding this move to Device Tree to clean
> things up beforehand.
>
> The series has already been sent but a little bit scattered. So I collect
> everything, this time.
>
> Nicolas Ferre (7):
>    ARM: at91/dt/trivial: use macro for AES irq type
>    ARM: at91/dt/trivial: before sama5d3, Atmel MPU were using at91 prefix
>    ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
>    crypto: atmel-aes - add support for Device Tree
>    crypto: atmel-tdes - add support for Device Tree
>    crypto: atmel-sha - add support for Device Tree
>    crypto: atmel-sha - add sha information to the log
>
>   .../devicetree/bindings/crypto/atmel-crypto.txt    |  68 ++++++++++
>   arch/arm/boot/dts/sama5d3.dtsi                     |  16 ++-
>   drivers/crypto/atmel-aes.c                         | 143 ++++++++++++++-------
>   drivers/crypto/atmel-sha.c                         | 103 +++++++++++----
>   drivers/crypto/atmel-tdes.c                        | 143 ++++++++++++++-------
>   5 files changed, 346 insertions(+), 127 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt
>


-- 
Nicolas Ferre
