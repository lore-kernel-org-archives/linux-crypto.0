From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Sun, 26 Mar 2017 06:10:44 +0200
Message-ID: <1882318.c2IBOhq8iD@positron.chronox.de>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap> <20170323082307.GB16625@Red> <20170323094406.GA6848@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58498 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750728AbdCZEKx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 00:10:53 -0400
In-Reply-To: <20170323094406.GA6848@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. März 2017, 10:44:06 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 23, 2017 at 09:23:07AM +0100, Corentin Labbe wrote:
> > Problem with this conversion, a huge regression for user space.
> > Using hwrng is simple as cat /dev/hwrng.
> > Using algif_rng via AF_ALG is ... unusable for the moment.
> > Perhaps creating an user space tool (prng-tool which provide a cat
> > /dev/hwrng replacement) is mandatory before any convertion.
> Stephan may have a tool to do this.  Stephan?

I added the application kcapi-rng to HEAD of [1]. Create the application with 
the --enable-kcapi-rngapp configure option.

$ kcapi-rng 

Kernel Crypto API Random Number Gatherer

Kernel Crypto API interface library version: libkcapi pre-release 0.13.1
Reported numeric version number 130080

Usage:
        -b --bytes <BYTES>      Number of bytes to generate (required option)
        -h --help       This help information
           --version    Print version
        -v --verbose    Verbose logging, multiple options increase verbosity

Data provided at stdin is used to seed the DRNG

[1] https://github.com/smuellerDD/libkcapi/

Ciao
Stephan
