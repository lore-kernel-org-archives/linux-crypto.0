From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH] crypto/arm: accelerated SHA-512 using ARM generic ASM
 and NEON
Date: Sat, 28 Mar 2015 12:37:44 +0200
Message-ID: <55168478.4030202@iki.fi>
References: <1427527726-25022-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-arm-kernel@lists.infradead.org, samitolvanen@google.com,
	appro@openssl.org, herbert@gondor.apana.org.au,
	plagnioj@jcrosoft.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35007 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbbC1Kh7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Mar 2015 06:37:59 -0400
In-Reply-To: <1427527726-25022-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28.03.2015 09:28, Ard Biesheuvel wrote:
> This updates the SHA-512 NEON module with the faster and more
> versatile implementation from the OpenSSL project. It consists
> of both a NEON and a generic ASM version of the core SHA-512
> transform, where the NEON version reverts to the ASM version
> when invoked in non-process context.
> 
> Performance relative to the generic implementation (measured
> using tcrypt.ko mode=306 sec=1 running on a Cortex-A57 under
> KVM):
> 
> 	input size	block size	asm	neon	old neon
> 
> 	16		16		1.39	2.54	2.21
> 	64		16		1.32	2.33	2.09
> 	64		64		1.38	2.53	2.19
> 	256		16		1.31	2.28	2.06
> 	256		64		1.38	2.54	2.25
> 	256		256		1.40	2.77	2.39
> 	1024		16		1.29	2.22	2.01
> 	1024		256		1.40	2.82	2.45
> 	1024		1024		1.41	2.93	2.53
> 	2048		16		1.33	2.21	2.00
> 	2048		256		1.40	2.84	2.46
> 	2048		1024		1.41	2.96	2.55
> 	2048		2048		1.41	2.98	2.56
> 	4096		16		1.34	2.20	1.99
> 	4096		256		1.40	2.84	2.46
> 	4096		1024		1.41	2.97	2.56
> 	4096		4096		1.41	3.01	2.58
> 	8192		16		1.34	2.19	1.99
> 	8192		256		1.40	2.85	2.47
> 	8192		1024		1.41	2.98	2.56
> 	8192		4096		1.41	2.71	2.59
> 	8192		8192		1.51	3.51	2.69
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> 
> This should get the same treatment as Sami's sha56 version: I would like
> to wait until the OpenSSL source file hits the upstream repository so that
> I can refer to its sha1 hash in the commit log.
> 
>  arch/arm/crypto/Kconfig               |    2 -
>  arch/arm/crypto/Makefile              |    8 +-
>  arch/arm/crypto/sha512-armv4.pl       |  656 ++++++++++++
>  arch/arm/crypto/sha512-armv7-neon.S   |  455 ---------
>  arch/arm/crypto/sha512-core.S_shipped | 1814 +++++++++++++++++++++++++++++++++
>  arch/arm/crypto/sha512.h              |   14 +
>  arch/arm/crypto/sha512_glue.c         |  255 +++++
>  arch/arm/crypto/sha512_neon_glue.c    |  155 +--
>  8 files changed, 2762 insertions(+), 597 deletions(-)
>  create mode 100644 arch/arm/crypto/sha512-armv4.pl
>  delete mode 100644 arch/arm/crypto/sha512-armv7-neon.S

Acked-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

>  create mode 100644 arch/arm/crypto/sha512-core.S_shipped
>  create mode 100644 arch/arm/crypto/sha512.h
>  create mode 100644 arch/arm/crypto/sha512_glue.c
> 
