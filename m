From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: simd ciphers
Date: Wed, 28 Dec 2016 09:37:04 +0100
Message-ID: <1497014.RmdRyQUAOo@positron.chronox.de>
References: <3279008.xAQAe6ukNz@positron.chronox.de> <10079298.uODr7IfrOJ@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55176 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750958AbcL1IhL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 03:37:11 -0500
In-Reply-To: <10079298.uODr7IfrOJ@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 8. Dezember 2016, 19:40:38 CET schrieb Stephan Müller:

Hi Herbert,

> Am Donnerstag, 8. Dezember 2016, 19:32:03 CET schrieb Stephan Müller:
> 
> Hi Herbert,
> 
> > Hi Herbert,
> > 
> > with the addition of the simd cipher change I seem to be unable to use the
> > AESNI ciphers. My .config contains CONFIG_CRYPTO_SIMD=y and
> > CONFIG_CRYPTO_AES_NI_INTEL=y. Those options always worked to load the
> > AES-NI
> (with "always worked" I meant the CONFIG_CRYPTO_AES_NI_INTEL=y option of
> course, that always ensured AES-NI to be present and usable)

With 4.10-rc1, I also do not get the AES-NI implementations to work. do you 
have any ideas what may be the issue?

Ciao
Stephan
