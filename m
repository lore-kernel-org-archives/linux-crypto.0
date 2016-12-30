From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: simd ciphers
Date: Fri, 30 Dec 2016 11:51:14 +0100
Message-ID: <2669432.vkvfdvCWnZ@positron.chronox.de>
References: <3279008.xAQAe6ukNz@positron.chronox.de> <2449210.sSYcIB5U3R@positron.chronox.de> <20161229094415.GA14453@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55210 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752595AbcL3KvS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 05:51:18 -0500
In-Reply-To: <20161229094415.GA14453@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 29. Dezember 2016, 17:44:15 CET schrieb Herbert Xu:

Hi Herbert,

> On Wed, Dec 28, 2016 at 12:21:52PM +0100, Stephan Müller wrote:
> > This patch does not help. But I now found the issue: we need some Kconfig
> > wizardry to mandate pcbc to be compiled statically when AES-NI is static.
> > Currently I had pcbc always as a module even when selecting AES-NI as
> > static compilation.
> 
> OK, please test this patch and see if it cures the problem with
> aesni built-in and pcbc built as a module.

This patch works -- PCBC can be compiled as a module whereas AES-NI is 
compiled statically and yet AES-NI can be loaded.

Thanks.

Tested-by: Stephan Müller <smueller@chronox.de>

Ciao
Stephan
