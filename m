From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: simd ciphers
Date: Thu, 08 Dec 2016 19:40:38 +0100
Message-ID: <10079298.uODr7IfrOJ@tauon.atsec.com>
References: <3279008.xAQAe6ukNz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39198 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752105AbcLHSkk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 13:40:40 -0500
In-Reply-To: <3279008.xAQAe6ukNz@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 8. Dezember 2016, 19:32:03 CET schrieb Stephan Müller:

Hi Herbert,

> Hi Herbert,
> 
> with the addition of the simd cipher change I seem to be unable to use the
> AESNI ciphers. My .config contains CONFIG_CRYPTO_SIMD=y and
> CONFIG_CRYPTO_AES_NI_INTEL=y. Those options always worked to load the AES-NI

(with "always worked" I meant the CONFIG_CRYPTO_AES_NI_INTEL=y option of 
course, that always ensured AES-NI to be present and usable)

> implementation. But now, I do not see the AES-NI implementations any more
> in / proc/crypto.
> 
> Ciao
> Stephan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
