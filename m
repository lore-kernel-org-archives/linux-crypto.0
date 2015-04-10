From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] crypto/arm: accelerated SHA-512 using ARM generic ASM and NEON
Date: Fri, 10 Apr 2015 22:08:38 +0200
Message-ID: <5553652.sur4tr0YJi@wuerfel>
References: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51256 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbDJUJO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 16:09:14 -0400
In-Reply-To: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 10 April 2015 16:29:08 Ard Biesheuvel wrote:
> +#if __ARM_MAX_ARCH__>=7
> +.arch  armv7-a
> +.fpu   neon
> +
> 

This will cause a build failure on an ARMv7-M build, which is incompatible
with .arch  armv7-a and .fpu   neon.

	Arnd
