From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: simd ciphers
Date: Wed, 28 Dec 2016 12:21:52 +0100
Message-ID: <2449210.sSYcIB5U3R@positron.chronox.de>
References: <3279008.xAQAe6ukNz@positron.chronox.de> <3170771.4e7c0aHuJX@positron.chronox.de> <20161228102826.GB12607@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55184 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbcL1LV6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 06:21:58 -0500
In-Reply-To: <20161228102826.GB12607@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 28. Dezember 2016, 18:28:26 CET schrieb Herbert Xu:

Hi Herbert,

> On Wed, Dec 28, 2016 at 11:00:51AM +0100, Stephan Müller wrote:
> > When I configure AES-NI as module, it works. When compiling it statically,
> > the allocation returns an -ENOENT.
> > 
> > Now, when I diff both config files after a simple toggle from AES-NI=y to
> > =m I see (linux-4.10.config contains the static config, .config contains
> > the module
> > configuration):
> Thanks Stephan! Does this patch help?

This patch does not help. But I now found the issue: we need some Kconfig 
wizardry to mandate pcbc to be compiled statically when AES-NI is static. 
Currently I had pcbc always as a module even when selecting AES-NI as static 
compilation.

Ciao
Stephan
