From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: arm: workaround for building with old binutils
Date: Sat, 11 Apr 2015 22:54:43 +0200
Message-ID: <2659525.NqojY2z1jk@wuerfel>
References: <1428759154-16251-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, davem@davemloft.net
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428759154-16251-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Saturday 11 April 2015 15:32:34 Ard Biesheuvel wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> How about something like this:
> 
> A warning will be emitted by make when descending into the arch/arm/crypto
> directory, but only if any ARMv8 Crypto modules were in fact selected.
> 
> /home/ard/linux-2.6/arch/arm/crypto/Makefile:22: These ARMv8 Crypto Extensions modules need binutils 2.23 or higher
> /home/ard/linux-2.6/arch/arm/crypto/Makefile:23: aes-arm-ce.o sha1-arm-ce.o sha2-arm-ce.o ghash-arm-ce.o
> 
> 

Looks good. Do you want me to do more randconfig tests on this, or put it in
right away to fix the allmodconfig problem?

	Arnd
